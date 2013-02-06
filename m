Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab3BFCEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:04:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:15605 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924Ab3BFCE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:04:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,612,1355126400"; 
   d="log'?scan'208";a="283329029"
Date: Wed, 6 Feb 2013 10:04:24 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [usb gadget] WARNING: at kernel/mutex.c:198 __mutex_lock_common()
Message-ID: <20130206020424.GB1175@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below warning and the first bad commit is

commit 19b10a8828a6cdd5a4e7e37babd5084d35641f87
Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date:   Sun Dec 23 21:10:06 2012 +0100

    usb: gadget: allocate & giveback serial ports instead hard code them
    
    This patch removes gserial_setup() and gserial_cleanup() and adds
    gserial_alloc_line() and gserial_free_line() to replace them.
    
    The initial setup of u_serial happens now on module load time. A
    maximum of four TTY ports can be requested which is the current limit.
    In theory we could extend this limit, the hard limit is the number of
    available endpoints.
    alloc_tty_driver() is now called at module init time with the max
    available ports. The per-line footprint here is on 32bit is 3 * size of
    pointer + 60 bytes (for cdevs).
    The remaining memory (struct gs_port) is allocated once a port is
    requested.
    
    With this change it is possible to load g_multi and g_serial at the same
    time. GS0 receives the module that is loaded first, GS1 is received by
    the next module and so on. With the configfs interface the port number
    can be exported and the device node is more predictable. Nothing changes
    for g_serial and friends as long as one module is used.
    
    Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

[    4.625655] usb0: HOST MAC da:6c:61:74:5d:c0
[    4.626504] ------------[ cut here ]------------
[    4.627366] WARNING: at /c/kernel-tests/src/linux/kernel/mutex.c:198 __mutex_lock_common+0xcf/0x357()
[    4.627446] Pid: 1, comm: swapper Not tainted 3.8.0-rc5-00646-g2f520a0 #4
[    4.627446] Call Trace:
[    4.627446]  [<c1028524>] warn_slowpath_common+0x54/0x69
[    4.627446]  [<c147be9a>] ? __mutex_lock_common+0xcf/0x357
[    4.627446]  [<c147be9a>] ? __mutex_lock_common+0xcf/0x357
[    4.627446]  [<c10285d7>] warn_slowpath_null+0x1d/0x22
[    4.627446]  [<c147be9a>] __mutex_lock_common+0xcf/0x357
[    4.627446]  [<c123b588>] ? gserial_alloc_line+0x21/0x18d
[    4.627446]  [<c10391c0>] ? schedule_delayed_work+0x11/0x13
[    4.627446]  [<c13b7c82>] ? linkwatch_schedule_work+0x62/0x65
[    4.627446]  [<c147c15b>] mutex_lock_nested+0x39/0x3f
[    4.627446]  [<c123b588>] ? gserial_alloc_line+0x21/0x18d
[    4.627446]  [<c123b588>] gserial_alloc_line+0x21/0x18d
[    4.627446]  [<c18ffb7c>] cdc_bind+0x2b/0xf2
[    4.627446]  [<c122d9ca>] ? composite_dev_prepare+0x8e/0xc0
[    4.627446]  [<c122db66>] composite_bind+0x82/0x16a
[    4.627446]  [<c18fface>] ? udc_driver_init+0xf/0xf
[    4.627446]  [<c18fface>] ? udc_driver_init+0xf/0xf
[    4.627446]  [<c122b6c4>] udc_bind_to_driver+0x47/0xb2
[    4.627446]  [<c18fface>] ? udc_driver_init+0xf/0xf
[    4.627446]  [<c122bc07>] usb_gadget_probe_driver+0x65/0x7e
[    4.627446]  [<c122dcbb>] usb_composite_probe+0x6d/0x78
[    4.627446]  [<c18ffadb>] init+0xd/0xf
[    4.627446]  [<c18dd9ba>] do_one_initcall+0x7e/0x12e
[    4.627446]  [<c18ddb3e>] kernel_init_freeable+0xd4/0x16e
[    4.627446]  [<c18dd435>] ? do_early_param+0x7a/0x7a
[    4.627446]  [<c14737fb>] kernel_init+0xb/0xbe
[    4.627446]  [<c147e8b7>] ret_from_kernel_thread+0x1b/0x28
[    4.627446]  [<c14737f0>] ? rest_init+0x11c/0x11c
[    4.627446] ---[ end trace 8ef03ce626e1a2a9 ]---

git bisect start 2f520a0e87bbe47bf0909ce5700dd72b258991d2 cf5425bfcd6909f9831a00bc06ccb9a5b163766a --
git bisect good   #    10  2013-02-05 16:54:14  Merge branch 'sdio_acpi' into for-zhangrui
git bisect good   #    10  2013-02-05 17:24:30  Merge tag 'dwc3-for-v3.9' of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-next
git bisect  bad   #     0  2013-02-05 17:33:09  usb: gadget: pxa25x_udc: convert to udc_start/udc_stop
git bisect good   #    15  2013-02-05 18:04:34  usb: gadget: u_serial: convert into a module
git bisect  bad   #     0  2013-02-05 18:10:01  usb: gadget: composite: introduce usb_gstrings_attach()
git bisect  bad   #     0  2013-02-05 18:11:55  usb: gadget: cdc2: use function framework for ACM
git bisect  bad   #     0  2013-02-05 18:13:49  usb: gadget: allocate & giveback serial ports instead hard code them
git bisect good   #    10  2013-02-05 18:45:13  usb: gadget: composite: add usb_remove_function()
git bisect good   #    33  2013-02-05 19:35:39  usb: gadget: composite: add usb_remove_function()
git bisect good   #    30  2013-02-05 20:31:48  Add linux-next specific files for 20130125

Thanks,
Fengguang

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-inn-52453-2013-02-01-16-07-28-3.8.0-rc5-00646-g2f520a0-4"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc5-00646-g2f520a0 (kbuild@inn) (gcc ver=
sion 4.7.1 (Debian 4.7.1-6) ) #4 PREEMPT Fri Feb 1 16:06:13 CST 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reser=
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
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
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
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[c00fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x023fa0=
00-0x023fffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128296(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL=
 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00010000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat c18d7f3c, node_mem_map cd=
d3f200
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 64897 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 171fa00
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64897
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 branch=3Dinternal-rtd3/rtd3-all log_buf_len=3D8M ignore_lo=
glevel debug sched_debug apic=3Ddebug dynamic_printk sysrq_always_enabled p=
anic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dn=
ormal  root=3D/dev/ram0 rw link=3Dvmlinuz-2013-02-01-16-06-34-internal-rtd3=
:rtd3-all:2f520a0-2f520a0-i386-randconfig-n015-3-inn BOOT_IMAGE=3Dkernel-te=
sts/kernels/i386-randconfig-n015/2f520a0/vmlinuz-3.8.0-rc5-00646-g2f520a0
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 210068k/262136k available (4605k kernel code, 51568k=
 reserved, 4469k data, 360k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa1000 - 0xfffff000   ( 376 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc18dd000 - 0xc1937000   ( 360 kB)
[    0.000000]       .data : 0xc147f73b - 0xc18dcb40   (4469 kB)
[    0.000000]       .text : 0xc1000000 - 0xc147f73b   (4605 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D128, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3Dc0080000 soft=3Dc0082000
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
[    0.000000] ODEBUG: 3 of 3 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.560 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5387.12 Bogo=
MIPS (lpj=3D2693560)
[    0.004011] pid_max: default: 4096 minimum: 301
[    0.005087] Mount-cache hash table entries: 512
[    0.006261] Initializing cgroup subsys debug
[    0.007022] Initializing cgroup subsys freezer
[    0.008118] mce: CPU supports 10 MCE banks
[    0.009074] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009074] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009074] tlb_flushall_shift: 6
[    0.010015] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.013614] ACPI: Core revision 20121018
[    0.017317] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.020123] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.021018] Getting VERSION: 50014
[    0.021673] Getting VERSION: 50014
[    0.022021] Getting ID: 0
[    0.023019] Getting ID: f000000
[    0.023636] Getting LVT0: 8700
[    0.024048] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.025072] Getting LVT1: 8400
[    0.026099] enabled ExtINT on CPU#0
[    0.028645] ENABLING IO-APIC IRQs
[    0.029015] init IO_APIC IRQs
[    0.029591]  apic 2 pin 0 not connected
[    0.030034] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.031042] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.033011] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.034039] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.035040] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.036043] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.037038] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.039012] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.040038] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.041042] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.042046] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.043037] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.044038] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.045038] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.046037] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.047033]  apic 2 pin 16 not connected
[    0.047825]  apic 2 pin 17 not connected
[    0.048008]  apic 2 pin 18 not connected
[    0.049007]  apic 2 pin 19 not connected
[    0.050007]  apic 2 pin 20 not connected
[    0.051007]  apic 2 pin 21 not connected
[    0.052007]  apic 2 pin 22 not connected
[    0.052792]  apic 2 pin 23 not connected
[    0.053171] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.054008] Using local APIC timer interrupts.
[    0.054008] calibrating APIC timer ...
[    0.056000] ... lapic delta =3D 6800900
[    0.056000] ... PM-Timer delta =3D 389504
[    0.056000] APIC calibration not consistent with PM-Timer: 108ms instead=
 of 100ms
[    0.056000] APIC delta adjusted to PM-Timer: 6250024 (6800900)
[    0.056000] TSC delta adjusted to PM-Timer: 269349448 (293089860)
[    0.056000] ..... delta 6250024
[    0.056000] ..... mult: 268436486
[    0.056000] ..... calibration result: 1000003
[    0.056000] ..... CPU clock speed is 2693.0494 MHz.
[    0.056000] ..... host bus clock speed is 1000.0003 MHz.
[    0.056357] device: 'platform': device_add
[    0.057019] PM: Adding info for No Bus:platform
[    0.059030] bus: 'platform': registered
[    0.060016] bus: 'cpu': registered
[    0.061026] device: 'cpu': device_add
[    0.062009] PM: Adding info for No Bus:cpu
[    0.064652] device class 'regulator': registering
[    0.065020] Registering platform device 'reg-dummy'. Parent at platform
[    0.066000] device: 'reg-dummy': device_add
[    0.066000] bus: 'platform': add device reg-dummy
[    0.066000] PM: Adding info for platform:reg-dummy
[    0.066053] bus: 'platform': add driver reg-dummy
[    0.067000] bus: 'platform': driver_probe_device: matched device reg-dum=
my with driver reg-dummy
[    0.067000] bus: 'platform': really_probe: probing driver reg-dummy with=
 device reg-dummy
[    0.067000] device: 'regulator.0': device_add
[    0.067000] PM: Adding info for No Bus:regulator.0
[    0.067000] regulator-dummy: no parameters
[    0.067000] driver: 'reg-dummy': driver_bound: bound to device 'reg-dumm=
y'
[    0.067000] bus: 'platform': really_probe: bound device reg-dummy to dri=
ver reg-dummy
[    0.067000] RTC time:  8:07:17, date: 02/01/13
[    0.067079] NET: Registered protocol family 16
[    0.068497] device class 'bdi': registering
[    0.069028] device class 'pci_bus': registering
[    0.070052] bus: 'pci': registered
[    0.071012] device: 'rapidio': device_add
[    0.072008] PM: Adding info for No Bus:rapidio
[    0.074023] bus: 'rapidio': registered
[    0.075008] device class 'backlight': registering
[    0.076031] device class 'video_output': registering
[    0.078007] device class 'tty': registering
[    0.079047] bus: 'spi': registered
[    0.080006] device class 'spi_master': registering
[    0.081046] bus: 'hsi': registered
[    0.083578] bus: 'platform': add driver cs5535-pms
[    0.085026] bus: 'platform': add driver olpc-xo1-pm-acpi
[    0.086044] bus: 'platform': add driver olpc-xo1-sci-acpi
[    0.088020] ACPI: bus type pci registered
[    0.089007] device class 'dma': registering
[    0.090059] dca service started, version 1.12.1
[    0.091007] device class 'dca': registering
[    0.092179] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=3D0
[    0.093006] PCI: Using configuration type 1 for base access
[    0.094000] device: 'cpu0': device_add
[    0.094000] bus: 'cpu': add device cpu0
[    0.094000] PM: Adding info for cpu:cpu0
[    0.094038] device: 'default': device_add
[    0.095017] PM: Adding info for No Bus:default
[    0.096219] bus: 'spi': add driver max7301
[    0.098006] bus: 'spi': add driver mc33880
[    0.099030] bus: 'platform': add driver wm831x-gpio
[    0.100055] ACPI: Added _OSI(Module Device)
[    0.101036] ACPI: Added _OSI(Processor Device)
[    0.102000] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.102000] ACPI: Added _OSI(Processor Aggregator Device)
[    0.105338] ACPI: EC: Look up EC in DSDT
[    0.112533] ACPI: Interpreter enabled
[    0.113006] ACPI: (supports S0 S3 S5)
[    0.115006] ACPI: Using IOAPIC for interrupt routing
[    0.116043] bus: 'acpi': registered
[    0.117008] bus: 'acpi': add driver power
[    0.119012] device: 'LNXSYSTM:00': device_add
[    0.120020] bus: 'acpi': add device LNXSYSTM:00
[    0.121008] PM: Adding info for acpi:LNXSYSTM:00
[    0.123191] device: 'LNXSYBUS:00': device_add
[    0.124010] bus: 'acpi': add device LNXSYBUS:00
[    0.125008] PM: Adding info for acpi:LNXSYBUS:00
[    0.126109] device: 'PNP0A03:00': device_add
[    0.127010] bus: 'acpi': add device PNP0A03:00
[    0.128000] PM: Adding info for acpi:PNP0A03:00
[    0.130101] device: 'device:00': device_add
[    0.131010] bus: 'acpi': add device device:00
[    0.132008] PM: Adding info for acpi:device:00
[    0.134124] device: 'device:01': device_add
[    0.135009] bus: 'acpi': add device device:01
[    0.136007] PM: Adding info for acpi:device:01
[    0.138103] device: 'PNP0B00:00': device_add
[    0.139009] bus: 'acpi': add device PNP0B00:00
[    0.140007] PM: Adding info for acpi:PNP0B00:00
[    0.141145] device: 'PNP0303:00': device_add
[    0.142010] bus: 'acpi': add device PNP0303:00
[    0.143008] PM: Adding info for acpi:PNP0303:00
[    0.144164] device: 'PNP0F13:00': device_add
[    0.146009] bus: 'acpi': add device PNP0F13:00
[    0.147008] PM: Adding info for acpi:PNP0F13:00
[    0.149027] device: 'PNP0700:00': device_add
[    0.150012] bus: 'acpi': add device PNP0700:00
[    0.151009] PM: Adding info for acpi:PNP0700:00
[    0.153288] device: 'PNP0400:00': device_add
[    0.154010] bus: 'acpi': add device PNP0400:00
[    0.155007] PM: Adding info for acpi:PNP0400:00
[    0.157201] device: 'PNP0501:00': device_add
[    0.158010] bus: 'acpi': add device PNP0501:00
[    0.159008] PM: Adding info for acpi:PNP0501:00
[    0.160202] device: 'device:02': device_add
[    0.161011] bus: 'acpi': add device device:02
[    0.162000] PM: Adding info for acpi:device:02
[    0.162156] device: 'device:03': device_add
[    0.163010] bus: 'acpi': add device device:03
[    0.164000] PM: Adding info for acpi:device:03
[    0.164115] device: 'device:04': device_add
[    0.165011] bus: 'acpi': add device device:04
[    0.166008] PM: Adding info for acpi:device:04
[    0.167170] device: 'device:05': device_add
[    0.168010] bus: 'acpi': add device device:05
[    0.169000] PM: Adding info for acpi:device:05
[    0.170081] device: 'device:06': device_add
[    0.171010] bus: 'acpi': add device device:06
[    0.172007] PM: Adding info for acpi:device:06
[    0.174125] device: 'device:07': device_add
[    0.175010] bus: 'acpi': add device device:07
[    0.176007] PM: Adding info for acpi:device:07
[    0.178134] device: 'device:08': device_add
[    0.179010] bus: 'acpi': add device device:08
[    0.180008] PM: Adding info for acpi:device:08
[    0.182128] device: 'device:09': device_add
[    0.183009] bus: 'acpi': add device device:09
[    0.184007] PM: Adding info for acpi:device:09
[    0.186122] device: 'device:0a': device_add
[    0.187010] bus: 'acpi': add device device:0a
[    0.188007] PM: Adding info for acpi:device:0a
[    0.189158] device: 'device:0b': device_add
[    0.190009] bus: 'acpi': add device device:0b
[    0.191006] PM: Adding info for acpi:device:0b
[    0.193123] device: 'device:0c': device_add
[    0.194010] bus: 'acpi': add device device:0c
[    0.195007] PM: Adding info for acpi:device:0c
[    0.196145] device: 'device:0d': device_add
[    0.197009] bus: 'acpi': add device device:0d
[    0.198000] PM: Adding info for acpi:device:0d
[    0.198140] device: 'device:0e': device_add
[    0.199009] bus: 'acpi': add device device:0e
[    0.200007] PM: Adding info for acpi:device:0e
[    0.202057] device: 'device:0f': device_add
[    0.203009] bus: 'acpi': add device device:0f
[    0.204007] PM: Adding info for acpi:device:0f
[    0.205150] device: 'device:10': device_add
[    0.206009] bus: 'acpi': add device device:10
[    0.207007] PM: Adding info for acpi:device:10
[    0.209122] device: 'device:11': device_add
[    0.210009] bus: 'acpi': add device device:11
[    0.211007] PM: Adding info for acpi:device:11
[    0.212159] device: 'device:12': device_add
[    0.214007] bus: 'acpi': add device device:12
[    0.215007] PM: Adding info for acpi:device:12
[    0.216156] device: 'device:13': device_add
[    0.217008] bus: 'acpi': add device device:13
[    0.218007] PM: Adding info for acpi:device:13
[    0.220130] device: 'device:14': device_add
[    0.221010] bus: 'acpi': add device device:14
[    0.222007] PM: Adding info for acpi:device:14
[    0.223154] device: 'device:15': device_add
[    0.224009] bus: 'acpi': add device device:15
[    0.225007] PM: Adding info for acpi:device:15
[    0.227169] device: 'device:16': device_add
[    0.228009] bus: 'acpi': add device device:16
[    0.229007] PM: Adding info for acpi:device:16
[    0.230167] device: 'device:17': device_add
[    0.231010] bus: 'acpi': add device device:17
[    0.232008] PM: Adding info for acpi:device:17
[    0.233133] device: 'device:18': device_add
[    0.234009] bus: 'acpi': add device device:18
[    0.235008] PM: Adding info for acpi:device:18
[    0.237040] device: 'device:19': device_add
[    0.238009] bus: 'acpi': add device device:19
[    0.239008] PM: Adding info for acpi:device:19
[    0.240146] device: 'device:1a': device_add
[    0.241009] bus: 'acpi': add device device:1a
[    0.242007] PM: Adding info for acpi:device:1a
[    0.244125] device: 'device:1b': device_add
[    0.245009] bus: 'acpi': add device device:1b
[    0.246007] PM: Adding info for acpi:device:1b
[    0.247147] device: 'device:1c': device_add
[    0.248009] bus: 'acpi': add device device:1c
[    0.249007] PM: Adding info for acpi:device:1c
[    0.250125] device: 'device:1d': device_add
[    0.251009] bus: 'acpi': add device device:1d
[    0.252008] PM: Adding info for acpi:device:1d
[    0.253159] device: 'device:1e': device_add
[    0.254009] bus: 'acpi': add device device:1e
[    0.255000] PM: Adding info for acpi:device:1e
[    0.255126] device: 'device:1f': device_add
[    0.256010] bus: 'acpi': add device device:1f
[    0.257007] PM: Adding info for acpi:device:1f
[    0.259109] device: 'device:20': device_add
[    0.260010] bus: 'acpi': add device device:20
[    0.261007] PM: Adding info for acpi:device:20
[    0.262148] device: 'device:21': device_add
[    0.263009] bus: 'acpi': add device device:21
[    0.264007] PM: Adding info for acpi:device:21
[    0.266336] device: 'PNP0103:00': device_add
[    0.267010] bus: 'acpi': add device PNP0103:00
[    0.268008] PM: Adding info for acpi:PNP0103:00
[    0.270270] device: 'PNP0C0F:00': device_add
[    0.271010] bus: 'acpi': add device PNP0C0F:00
[    0.272008] PM: Adding info for acpi:PNP0C0F:00
[    0.274037] device: 'PNP0C0F:01': device_add
[    0.275009] bus: 'acpi': add device PNP0C0F:01
[    0.276008] PM: Adding info for acpi:PNP0C0F:01
[    0.277271] device: 'PNP0C0F:02': device_add
[    0.278009] bus: 'acpi': add device PNP0C0F:02
[    0.279007] PM: Adding info for acpi:PNP0C0F:02
[    0.280250] device: 'PNP0C0F:03': device_add
[    0.281009] bus: 'acpi': add device PNP0C0F:03
[    0.282007] PM: Adding info for acpi:PNP0C0F:03
[    0.284251] device: 'PNP0C0F:04': device_add
[    0.285010] bus: 'acpi': add device PNP0C0F:04
[    0.286007] PM: Adding info for acpi:PNP0C0F:04
[    0.287190] device: 'LNXCPU:00': device_add
[    0.288009] bus: 'acpi': add device LNXCPU:00
[    0.289007] PM: Adding info for acpi:LNXCPU:00
[    0.290128] device: 'LNXCPU:01': device_add
[    0.291009] bus: 'acpi': add device LNXCPU:01
[    0.292007] PM: Adding info for acpi:LNXCPU:01
[    0.293161] device: 'LNXSYBUS:01': device_add
[    0.294009] bus: 'acpi': add device LNXSYBUS:01
[    0.295000] PM: Adding info for acpi:LNXSYBUS:01
[    0.295081] device: 'LNXPWRBN:00': device_add
[    0.296009] bus: 'acpi': add device LNXPWRBN:00
[    0.297007] PM: Adding info for acpi:LNXPWRBN:00
[    0.299429] bus: 'acpi': add driver ec
[    0.300072] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.301008] bus: 'acpi': add driver pci_root
[    0.302000] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 =
with driver pci_root
[    0.302000] bus: 'acpi': really_probe: probing driver pci_root with devi=
ce PNP0A03:00
[    0.302027] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.303011] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.304657] pci_root PNP0A03:00: Unable to request _OSC control (_OSC su=
pport mask: 0x08)
[    0.305000] pci_root PNP0A03:00: fail to add MMCONFIG information, can't=
 access extended PCI configuration space under this bridge.
[    0.305000] device: 'pci0000:00': device_add
[    0.305053] PM: Adding info for No Bus:pci0000:00
[    0.306030] device: '0000:00': device_add
[    0.307023] PM: Adding info for No Bus:0000:00
[    0.308064] PCI host bridge to bus 0000:00
[    0.309012] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.310011] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.311009] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.312009] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.313000] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    0.313000] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.313000] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.313000] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.315009] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.317416] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.318599] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.319000] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.319000] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.321494] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.324565] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.332064] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.334181] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.335890] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.336000] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.340846] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.342078] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.343956] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    0.344000] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    0.348758] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.349966] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    0.351448] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.353091] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.354951] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.356445] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    0.358000] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.359417] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    0.361456] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.364028] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.366463] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    0.368456] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.370000] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.370945] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    0.371000] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.371000] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.371000] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    0.371021] pci_bus 0000:00: on NUMA node 0
[    0.373522] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.375018] device: '0000:00:00.0': device_add
[    0.377747] bus: 'pci': add device 0000:00:00.0
[    0.378018] PM: Adding info for pci:0000:00:00.0
[    0.380100] device: '0000:00:01.0': device_add
[    0.382774] bus: 'pci': add device 0000:00:01.0
[    0.383008] PM: Adding info for pci:0000:00:01.0
[    0.385013] device: '0000:00:01.1': device_add
[    0.387717] bus: 'pci': add device 0000:00:01.1
[    0.388009] PM: Adding info for pci:0000:00:01.1
[    0.390013] device: '0000:00:01.3': device_add
[    0.392620] bus: 'pci': add device 0000:00:01.3
[    0.393008] PM: Adding info for pci:0000:00:01.3
[    0.395040] device: '0000:00:02.0': device_add
[    0.397547] bus: 'pci': add device 0000:00:02.0
[    0.398008] PM: Adding info for pci:0000:00:02.0
[    0.400013] device: '0000:00:03.0': device_add
[    0.402472] bus: 'pci': add device 0000:00:03.0
[    0.403008] PM: Adding info for pci:0000:00:03.0
[    0.404042] device: '0000:00:04.0': device_add
[    0.407391] bus: 'pci': add device 0000:00:04.0
[    0.408008] PM: Adding info for pci:0000:00:04.0
[    0.409040] device: '0000:00:05.0': device_add
[    0.412304] bus: 'pci': add device 0000:00:05.0
[    0.413008] PM: Adding info for pci:0000:00:05.0
[    0.414040] device: '0000:00:06.0': device_add
[    0.417248] bus: 'pci': add device 0000:00:06.0
[    0.418008] PM: Adding info for pci:0000:00:06.0
[    0.419042] device: '0000:00:07.0': device_add
[    0.422182] bus: 'pci': add device 0000:00:07.0
[    0.423008] PM: Adding info for pci:0000:00:07.0
[    0.424042] device: '0000:00:08.0': device_add
[    0.427079] bus: 'pci': add device 0000:00:08.0
[    0.428009] PM: Adding info for pci:0000:00:08.0
[    0.429042] device: '0000:00:09.0': device_add
[    0.431975] bus: 'pci': add device 0000:00:09.0
[    0.432008] PM: Adding info for pci:0000:00:09.0
[    0.433046] device: '0000:00:0a.0': device_add
[    0.435909] bus: 'pci': add device 0000:00:0a.0
[    0.436009] PM: Adding info for pci:0000:00:0a.0
[    0.437022] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_roo=
t'
[    0.438015] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver=
 pci_root
[    0.440067] bus: 'acpi': add driver pci_link
[    0.441042] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 =
with driver pci_link
[    0.442000] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:00
[    0.444064] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.446021] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_lin=
k'
[    0.447023] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver=
 pci_link
[    0.448015] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 =
with driver pci_link
[    0.449000] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:01
[    0.449000] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.449000] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_lin=
k'
[    0.449000] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver=
 pci_link
[    0.449000] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 =
with driver pci_link
[    0.449000] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:02
[    0.449000] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.449000] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_lin=
k'
[    0.449016] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver=
 pci_link
[    0.450000] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 =
with driver pci_link
[    0.450000] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:03
[    0.450119] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.452426] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_lin=
k'
[    0.453012] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver=
 pci_link
[    0.454000] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 =
with driver pci_link
[    0.454000] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:04
[    0.454000] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.454000] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_lin=
k'
[    0.454000] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver=
 pci_link
[    0.454050] bus: 'pnp': registered
[    0.455022] bus: 'platform': add driver mc13783-regulator
[    0.457013] bus: 'platform': add driver mc13892-regulator
[    0.458031] bus: 'platform': add driver wm831x-buckv
[    0.460007] bus: 'platform': add driver wm831x-buckp
[    0.461036] bus: 'platform': add driver wm831x-boostp
[    0.463007] bus: 'platform': add driver wm831x-epe
[    0.464032] bus: 'platform': add driver wm831x-isink
[    0.466009] bus: 'platform': add driver wm831x-ldo
[    0.468008] bus: 'platform': add driver wm831x-aldo
[    0.469031] bus: 'platform': add driver wm831x-alive-ldo
[    0.471025] device class 'misc': registering
[    0.472101] device: 'vga_arbiter': device_add
[    0.473037] PM: Adding info for No Bus:vga_arbiter
[    0.474110] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.475019] vgaarb: loaded
[    0.475802] vgaarb: bridge control possible 0000:00:02.0
[    0.477074] bus: 'spi': add driver wm831x
[    0.478034] bus: 'spi': add driver mc13xxx
[    0.479043] ACPI: bus type usb registered
[    0.480035] bus: 'usb': registered
[    0.481028] bus: 'usb': add driver usbfs
[    0.482034] usbcore: registered new interface driver usbfs
[    0.484018] bus: 'usb': add driver hub
[    0.485028] usbcore: registered new interface driver hub
[    0.486219] bus: 'usb': add driver usb
[    0.487028] usbcore: registered new device driver usb
[    0.488014] bus: 'platform': add driver nop_usb_xceiv
[    0.490079] bus: 'platform': add driver usbmisc_imx6q
[    0.491033] device class 'udc': registering
[    0.492055] bus: 'serio': registered
[    0.493035] bus: 'gameport': registered
[    0.494006] device class 'input': registering
[    0.495030] device class 'rtc': registering
[    0.497008] Linux video capture interface: v2.00
[    0.498012] device class 'video4linux': registering
[    0.499038] device class 'dvb': registering
[    0.500031] device class 'pps': registering
[    0.501036] pps_core: LinuxPPS API ver. 1 registered
[    0.502007] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.503000] device class 'ptp': registering
[    0.504019] PTP clock support registered
[    0.505007] device class 'power_supply': registering
[    0.506045] device class 'hwmon': registering
[    0.507033] device class 'leds': registering
[    0.509016] device class 'wmi': registering
[    0.510028] bus: 'acpi': add driver wmi
[    0.511071] wmi: Mapper loaded
[    0.512006] device class 'devfreq': registering
[    0.513214] bus: 'iio': registered
[    0.514016] device class 'sound': registering
[    0.515051] Advanced Linux Sound Architecture Driver Initialized.
[    0.517037] bus: 'ac97': registered
[    0.518012] PCI: Using ACPI for IRQ routing
[    0.519016] PCI: pci_cache_line_size set to 64 bytes
[    0.520375] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.522007] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.524041] device class 'net': registering
[    0.525122] device: 'lo': device_add
[    0.526029] PM: Adding info for No Bus:lo
[    0.529109] device class 'ieee80211': registering
[    0.530294] Registering platform device 'regulatory.0'. Parent at platfo=
rm
[    0.531008] device: 'regulatory.0': device_add
[    0.532000] bus: 'platform': add device regulatory.0
[    0.532000] PM: Adding info for platform:regulatory.0
[    0.532355] nfc: nfc_init: NFC Core ver 0.1
[    0.533007] device class 'nfc': registering
[    0.534072] NET: Registered protocol family 39
[    0.536061] cfg80211: Calling CRDA to update world regulatory domain
[    0.538406] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.539325] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.541013] Switching to clocksource kvm-clock
[    0.542266] bus: 'pnp': add driver system
[    0.543392] pnp: PnP ACPI init
[    0.544240] device: 'pnp0': device_add
[    0.545205] PM: Adding info for No Bus:pnp0
[    0.546315] ACPI: bus type pnp registered
[    0.547500] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.549593] device: '00:00': device_add
[    0.550610] bus: 'pnp': add device 00:00
[    0.551668] PM: Adding info for pnp:00:00
[    0.552771] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.554528] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.556600] device: '00:01': device_add
[    0.557589] bus: 'pnp': add device 00:01
[    0.558689] PM: Adding info for pnp:00:01
[    0.559738] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.561505] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.563642] device: '00:02': device_add
[    0.564656] bus: 'pnp': add device 00:02
[    0.565725] PM: Adding info for pnp:00:02
[    0.566809] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.568581] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.570665] pnp 00:03: [dma 2]
[    0.571499] device: '00:03': device_add
[    0.572512] bus: 'pnp': add device 00:03
[    0.573537] PM: Adding info for pnp:00:03
[    0.574663] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.576455] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.578537] device: '00:04': device_add
[    0.579541] bus: 'pnp': add device 00:04
[    0.580590] PM: Adding info for pnp:00:04
[    0.581668] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.583467] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.585543] device: '00:05': device_add
[    0.586536] bus: 'pnp': add device 00:05
[    0.587598] PM: Adding info for pnp:00:05
[    0.588668] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.590805] device: '00:06': device_add
[    0.591836] bus: 'pnp': add device 00:06
[    0.592903] PM: Adding info for pnp:00:06
[    0.593948] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.595943] pnp: PnP ACPI: found 7 devices
[    0.597026] ACPI: ACPI bus type pnp unregistered
[    0.598262] bus: 'pci': add driver Intel MID DMA
[    0.599555] device class 'mem': registering
[    0.600678] device: 'mem': device_add
[    0.601682] PM: Adding info for No Bus:mem
[    0.602787] device: 'null': device_add
[    0.603796] PM: Adding info for No Bus:null
[    0.604894] device: 'port': device_add
[    0.605884] PM: Adding info for No Bus:port
[    0.607054] device: 'zero': device_add
[    0.607981] PM: Adding info for No Bus:zero
[    0.609144] device: 'full': device_add
[    0.610108] PM: Adding info for No Bus:full
[    0.611253] device: 'random': device_add
[    0.612282] PM: Adding info for No Bus:random
[    0.613417] device: 'urandom': device_add
[    0.614559] PM: Adding info for No Bus:urandom
[    0.615506] device: 'kmsg': device_add
[    0.616372] PM: Adding info for No Bus:kmsg
[    0.618481] device: 'tty': device_add
[    0.619478] PM: Adding info for No Bus:tty
[    0.620591] device: 'console': device_add
[    0.621626] PM: Adding info for No Bus:console
[    0.622826] device class 'firmware': registering
[    0.624029] device class 'thermal': registering
[    0.660094] bus: 'ssb': registered
[    0.661224] bus: 'bcma': registered
[    0.662256] bus: 'pci': add driver bcma-pci-bridge
[    0.663770] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.665449] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.667116] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.668976] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.670878] NET: Registered protocol family 2
[    0.672517] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    0.674674] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    0.676870] TCP: Hash tables configured (established 2048 bind 2048)
[    0.678919] TCP: reno registered
[    0.679945] UDP hash table entries: 128 (order: 1, 12288 bytes)
[    0.681786] UDP-Lite hash table entries: 128 (order: 1, 12288 bytes)
[    0.683866] NET: Registered protocol family 1
[    0.685207] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.687004] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.688793] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.690672] pci 0000:00:02.0: Boot video device
[    0.692181] PCI: CLS 0 bytes, default 64
[    0.693966] Unpacking initramfs...
[    2.704037] Freeing initrd memory: 25284k freed
[    2.726421] DMA-API: preallocated 65536 debug entries
[    2.727999] DMA-API: debugging enabled by kernel config
[    2.730174] Machine check injector initialized
[    2.731560] device class 'cpuid': registering
[    2.734576] device: 'cpu0': device_add
[    2.735764] PM: Adding info for No Bus:cpu0
[    2.737090] Registering platform device 'pcspkr'. Parent at platform
[    2.739075] device: 'pcspkr': device_add
[    2.740311] bus: 'platform': add device pcspkr
[    2.741708] PM: Adding info for platform:pcspkr
[    2.743821] bus: 'acpi': add driver olpc-xo15-sci
[    2.745372] bus: 'platform': add driver alarmtimer
[    2.746859] cryptomgr_test (17) used greatest stack depth: 7268 bytes le=
ft
[    2.750051] cryptomgr_test (16) used greatest stack depth: 7160 bytes le=
ft
[    2.752369] Registering platform device 'alarmtimer'. Parent at platform
[    2.754511] device: 'alarmtimer': device_add
[    2.755875] bus: 'platform': add device alarmtimer
[    2.757454] PM: Adding info for platform:alarmtimer
[    2.759046] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[    2.761603] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[    2.764085] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[    2.766164] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[    2.768622] rcu-torture:--- Start of test: nreaders=3D2 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D0 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/0 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 stall_cpu=3D0 stall_cpu_holdoff=3D10 n_barrier_cbs=3D0 onoff_interval=
=3D0 onoff_holdoff=3D0
[    2.778604] bus: 'event_source': registered
[    2.780005] device: 'breakpoint': device_add
[    2.781376] bus: 'event_source': add device breakpoint
[    2.782916] PM: Adding info for event_source:breakpoint
[    2.784605] device: 'software': device_add
[    2.785866] bus: 'event_source': add device software
[    2.787320] PM: Adding info for event_source:software
[    2.790955] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.793253] VFS: Disk quotas dquot_6.5.2
[    2.794515] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.797061] device: 'autofs': device_add
[    2.798292] PM: Adding info for No Bus:autofs
[    2.800074] cryptomgr_test (33) used greatest stack depth: 6684 bytes le=
ft
[    2.803485] cryptomgr_test (39) used greatest stack depth: 6668 bytes le=
ft
[    2.805816] cryptomgr_test (40) used greatest stack depth: 6432 bytes le=
ft
[    2.808129] cryptomgr_test (41) used greatest stack depth: 6344 bytes le=
ft
[    2.812244] alg: No test for fcrypt (fcrypt-generic)
[    2.817888] alg: No test for stdrng (krng)
[    2.831848] NET: Registered protocol family 38
[    2.833326] list_sort_test: start testing list_sort()
[    2.835134] bus: 'platform': add driver basic-mmio-gpio
[    2.836883] bus: 'platform': add driver cs5535-gpio
[    2.838415] bus: 'pci': add driver langwell_gpio
[    2.839758] bus: 'platform': add driver wp_gpio
[    2.841168] bus: 'pci': add driver pch_gpio
[    2.842504] bus: 'platform': add driver rdc321x-gpio
[    2.844055] bus: 'platform': add driver ts5500-dio
[    2.845573] bus: 'platform': add driver vx855_gpio
[    2.847070] bus: 'pci_express': registered
[    2.848326] bus: 'pci': add driver pcieport
[    2.849687] device: 'aer_inject': device_add
[    2.851034] PM: Adding info for No Bus:aer_inject
[    2.852474] bus: 'pci': add driver ioapic
[    2.853717] bus: 'acpi': add driver Apple backlight
[    2.855238] bus: 'platform': add driver wm831x-backlight
[    2.856846] bus: 'platform': add driver ipmi
[    2.858164] ipmi message handler version 39.2
[    2.859520] ipmi device interface
[    2.860545] device class 'ipmi': registering
[    2.861893] bus: 'platform': add driver ipmi_si
[    2.863279] IPMI System Interface driver.
[    2.864537] bus: 'pci': add driver ipmi_si
[    2.865823] bus: 'pnp': add driver ipmi_si
[    2.867167] ipmi_si: Adding default-specified kcs state machine
[    2.868986] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    2.871924] ipmi_si: Interface detection failed
[    2.873312] ipmi_si: Adding default-specified smic state machine
[    2.875145] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    2.878128] ipmi_si: Interface detection failed
[    2.879533] ipmi_si: Adding default-specified bt state machine
[    2.881247] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    2.883976] ipmi_si: Interface detection failed
[    2.885420] bus: 'pci': remove driver ipmi_si
[    2.886725] driver: 'ipmi_si': driver_release
[    2.888004] bus: 'pnp': remove driver ipmi_si
[    2.889369] driver: 'ipmi_si': driver_release
[    2.890644] bus: 'platform': remove driver ipmi_si
[    2.892101] driver: 'ipmi_si': driver_release
[    2.893513] ipmi_si: Unable to find any System Interface(s)
[    2.895264] IPMI Watchdog: driver initialized
[    2.896560] bus: 'acpi': add driver fan
[    2.897838] bus: 'acpi': add driver video
[    2.899174] bus: 'acpi': add driver processor
[    2.900580] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 w=
ith driver processor
[    2.903036] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:00
[    2.905340] device: 'cooling_device0': device_add
[    2.906591] PM: Adding info for No Bus:cooling_device0
[    2.908040] driver: 'LNXCPU:00': driver_bound: bound to device 'processo=
r'
[    2.909829] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver =
processor
[    2.911774] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 w=
ith driver processor
[    2.914227] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:01
[    2.916345] driver: 'LNXCPU:01': driver_bound: bound to device 'processo=
r'
[    2.918022] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver =
processor
[    2.921097] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    2.922704] bus: 'pci': add driver ioatdma
[    2.923854] bus: 'platform': add driver timb-dma
[    2.925163] bus: 'platform': add driver reg-virt-consumer
[    2.926617] bus: 'platform': add driver reg-userspace-consumer
[    2.928160] bus: 'spi': add driver tps6524x
[    2.929565] device: 'ptyp0': device_add
[    2.930736] PM: Adding info for No Bus:ptyp0
[    2.932061] device: 'ptyp1': device_add
[    2.933237] PM: Adding info for No Bus:ptyp1
[    2.934598] device: 'ptyp2': device_add
[    2.935809] PM: Adding info for No Bus:ptyp2
[    2.937236] device: 'ptyp3': device_add
[    2.938465] PM: Adding info for No Bus:ptyp3
[    2.939777] device: 'ptyp4': device_add
[    2.940959] PM: Adding info for No Bus:ptyp4
[    2.942277] device: 'ptyp5': device_add
[    2.943516] PM: Adding info for No Bus:ptyp5
[    2.944895] device: 'ptyp6': device_add
[    2.946031] PM: Adding info for No Bus:ptyp6
[    2.947342] device: 'ptyp7': device_add
[    2.948576] PM: Adding info for No Bus:ptyp7
[    2.949921] device: 'ptyp8': device_add
[    2.951125] PM: Adding info for No Bus:ptyp8
[    2.952535] device: 'ptyp9': device_add
[    2.953738] PM: Adding info for No Bus:ptyp9
[    2.955095] device: 'ptypa': device_add
[    2.956304] PM: Adding info for No Bus:ptypa
[    2.957667] device: 'ptypb': device_add
[    2.958878] PM: Adding info for No Bus:ptypb
[    2.960240] device: 'ptypc': device_add
[    2.961420] PM: Adding info for No Bus:ptypc
[    2.962743] device: 'ptypd': device_add
[    2.963902] PM: Adding info for No Bus:ptypd
[    2.965264] device: 'ptype': device_add
[    2.966470] PM: Adding info for No Bus:ptype
[    2.967839] device: 'ptypf': device_add
[    2.969103] PM: Adding info for No Bus:ptypf
[    2.970427] device: 'ptyq0': device_add
[    2.971591] PM: Adding info for No Bus:ptyq0
[    2.972946] device: 'ptyq1': device_add
[    2.974120] PM: Adding info for No Bus:ptyq1
[    2.975451] device: 'ptyq2': device_add
[    2.976560] PM: Adding info for No Bus:ptyq2
[    2.977874] device: 'ptyq3': device_add
[    2.979070] PM: Adding info for No Bus:ptyq3
[    2.980389] device: 'ptyq4': device_add
[    2.981608] PM: Adding info for No Bus:ptyq4
[    2.982885] device: 'ptyq5': device_add
[    2.984023] PM: Adding info for No Bus:ptyq5
[    2.985428] device: 'ptyq6': device_add
[    2.986586] PM: Adding info for No Bus:ptyq6
[    2.987853] device: 'ptyq7': device_add
[    2.989000] PM: Adding info for No Bus:ptyq7
[    2.990314] device: 'ptyq8': device_add
[    2.991473] PM: Adding info for No Bus:ptyq8
[    2.992857] device: 'ptyq9': device_add
[    2.994072] PM: Adding info for No Bus:ptyq9
[    2.995422] device: 'ptyqa': device_add
[    2.996718] PM: Adding info for No Bus:ptyqa
[    2.997979] device: 'ptyqb': device_add
[    2.999160] PM: Adding info for No Bus:ptyqb
[    3.000569] device: 'ptyqc': device_add
[    3.001765] PM: Adding info for No Bus:ptyqc
[    3.003114] device: 'ptyqd': device_add
[    3.004310] PM: Adding info for No Bus:ptyqd
[    3.005673] device: 'ptyqe': device_add
[    3.006864] PM: Adding info for No Bus:ptyqe
[    3.008271] device: 'ptyqf': device_add
[    3.009487] PM: Adding info for No Bus:ptyqf
[    3.010830] device: 'ptyr0': device_add
[    3.012039] PM: Adding info for No Bus:ptyr0
[    3.013390] device: 'ptyr1': device_add
[    3.014591] PM: Adding info for No Bus:ptyr1
[    3.015933] device: 'ptyr2': device_add
[    3.017197] PM: Adding info for No Bus:ptyr2
[    3.018575] device: 'ptyr3': device_add
[    3.019775] PM: Adding info for No Bus:ptyr3
[    3.021185] device: 'ptyr4': device_add
[    3.022387] PM: Adding info for No Bus:ptyr4
[    3.023748] device: 'ptyr5': device_add
[    3.024993] PM: Adding info for No Bus:ptyr5
[    3.026335] device: 'ptyr6': device_add
[    3.027536] PM: Adding info for No Bus:ptyr6
[    3.028952] device: 'ptyr7': device_add
[    3.030148] PM: Adding info for No Bus:ptyr7
[    3.031508] device: 'ptyr8': device_add
[    3.032782] PM: Adding info for No Bus:ptyr8
[    3.034101] device: 'ptyr9': device_add
[    3.035292] PM: Adding info for No Bus:ptyr9
[    3.036623] device: 'ptyra': device_add
[    3.037783] PM: Adding info for No Bus:ptyra
[    3.039096] device: 'ptyrb': device_add
[    3.040331] PM: Adding info for No Bus:ptyrb
[    3.041644] device: 'ptyrc': device_add
[    3.042811] PM: Adding info for No Bus:ptyrc
[    3.044148] device: 'ptyrd': device_add
[    3.045339] PM: Adding info for No Bus:ptyrd
[    3.046677] device: 'ptyre': device_add
[    3.047901] PM: Adding info for No Bus:ptyre
[    3.049320] device: 'ptyrf': device_add
[    3.050525] PM: Adding info for No Bus:ptyrf
[    3.051863] device: 'ptys0': device_add
[    3.053035] PM: Adding info for No Bus:ptys0
[    3.054353] device: 'ptys1': device_add
[    3.055539] PM: Adding info for No Bus:ptys1
[    3.056900] device: 'ptys2': device_add
[    3.058106] PM: Adding info for No Bus:ptys2
[    3.059445] device: 'ptys3': device_add
[    3.060663] PM: Adding info for No Bus:ptys3
[    3.062048] device: 'ptys4': device_add
[    3.063263] PM: Adding info for No Bus:ptys4
[    3.064701] device: 'ptys5': device_add
[    3.065923] PM: Adding info for No Bus:ptys5
[    3.067283] device: 'ptys6': device_add
[    3.068574] PM: Adding info for No Bus:ptys6
[    3.069911] device: 'ptys7': device_add
[    3.071127] PM: Adding info for No Bus:ptys7
[    3.072465] device: 'ptys8': device_add
[    3.073654] PM: Adding info for No Bus:ptys8
[    3.074976] device: 'ptys9': device_add
[    3.076150] PM: Adding info for No Bus:ptys9
[    3.077358] device: 'ptysa': device_add
[    3.078560] PM: Adding info for No Bus:ptysa
[    3.079890] device: 'ptysb': device_add
[    3.081128] PM: Adding info for No Bus:ptysb
[    3.082482] device: 'ptysc': device_add
[    3.083660] PM: Adding info for No Bus:ptysc
[    3.084970] device: 'ptysd': device_add
[    3.086129] PM: Adding info for No Bus:ptysd
[    3.087462] device: 'ptyse': device_add
[    3.088681] PM: Adding info for No Bus:ptyse
[    3.089997] device: 'ptysf': device_add
[    3.091147] PM: Adding info for No Bus:ptysf
[    3.092494] device: 'ptyt0': device_add
[    3.093661] PM: Adding info for No Bus:ptyt0
[    3.095024] device: 'ptyt1': device_add
[    3.096254] PM: Adding info for No Bus:ptyt1
[    3.097617] device: 'ptyt2': device_add
[    3.098757] PM: Adding info for No Bus:ptyt2
[    3.100104] device: 'ptyt3': device_add
[    3.101295] PM: Adding info for No Bus:ptyt3
[    3.102661] device: 'ptyt4': device_add
[    3.103829] PM: Adding info for No Bus:ptyt4
[    3.105206] device: 'ptyt5': device_add
[    3.106358] PM: Adding info for No Bus:ptyt5
[    3.107675] device: 'ptyt6': device_add
[    3.108858] PM: Adding info for No Bus:ptyt6
[    3.110189] device: 'ptyt7': device_add
[    3.111353] PM: Adding info for No Bus:ptyt7
[    3.112738] device: 'ptyt8': device_add
[    3.113908] PM: Adding info for No Bus:ptyt8
[    3.115241] device: 'ptyt9': device_add
[    3.116465] PM: Adding info for No Bus:ptyt9
[    3.117636] device: 'ptyta': device_add
[    3.118780] PM: Adding info for No Bus:ptyta
[    3.120104] device: 'ptytb': device_add
[    3.121370] PM: Adding info for No Bus:ptytb
[    3.122638] device: 'ptytc': device_add
[    3.123785] PM: Adding info for No Bus:ptytc
[    3.125079] device: 'ptytd': device_add
[    3.126249] PM: Adding info for No Bus:ptytd
[    3.127601] device: 'ptyte': device_add
[    3.128889] PM: Adding info for No Bus:ptyte
[    3.130253] device: 'ptytf': device_add
[    3.131376] PM: Adding info for No Bus:ptytf
[    3.132694] device: 'ptyu0': device_add
[    3.133909] PM: Adding info for No Bus:ptyu0
[    3.135303] device: 'ptyu1': device_add
[    3.136549] PM: Adding info for No Bus:ptyu1
[    3.137819] device: 'ptyu2': device_add
[    3.139003] PM: Adding info for No Bus:ptyu2
[    3.140418] device: 'ptyu3': device_add
[    3.141428] PM: Adding info for No Bus:ptyu3
[    3.142615] device: 'ptyu4': device_add
[    3.143706] PM: Adding info for No Bus:ptyu4
[    3.145049] device: 'ptyu5': device_add
[    3.146156] PM: Adding info for No Bus:ptyu5
[    3.147459] device: 'ptyu6': device_add
[    3.148656] PM: Adding info for No Bus:ptyu6
[    3.149948] device: 'ptyu7': device_add
[    3.151153] PM: Adding info for No Bus:ptyu7
[    3.152526] device: 'ptyu8': device_add
[    3.153694] PM: Adding info for No Bus:ptyu8
[    3.154954] device: 'ptyu9': device_add
[    3.156153] PM: Adding info for No Bus:ptyu9
[    3.157459] device: 'ptyua': device_add
[    3.158645] PM: Adding info for No Bus:ptyua
[    3.159977] device: 'ptyub': device_add
[    3.161145] PM: Adding info for No Bus:ptyub
[    3.162418] device: 'ptyuc': device_add
[    3.163602] PM: Adding info for No Bus:ptyuc
[    3.165036] device: 'ptyud': device_add
[    3.166229] PM: Adding info for No Bus:ptyud
[    3.167603] device: 'ptyue': device_add
[    3.168853] PM: Adding info for No Bus:ptyue
[    3.170216] device: 'ptyuf': device_add
[    3.171414] PM: Adding info for No Bus:ptyuf
[    3.172762] device: 'ptyv0': device_add
[    3.173978] PM: Adding info for No Bus:ptyv0
[    3.175341] device: 'ptyv1': device_add
[    3.176618] PM: Adding info for No Bus:ptyv1
[    3.177963] device: 'ptyv2': device_add
[    3.179180] PM: Adding info for No Bus:ptyv2
[    3.180533] device: 'ptyv3': device_add
[    3.181735] PM: Adding info for No Bus:ptyv3
[    3.183083] device: 'ptyv4': device_add
[    3.184348] PM: Adding info for No Bus:ptyv4
[    3.185712] device: 'ptyv5': device_add
[    3.186913] PM: Adding info for No Bus:ptyv5
[    3.188317] device: 'ptyv6': device_add
[    3.189558] PM: Adding info for No Bus:ptyv6
[    3.190894] device: 'ptyv7': device_add
[    3.192078] PM: Adding info for No Bus:ptyv7
[    3.193468] device: 'ptyv8': device_add
[    3.194616] PM: Adding info for No Bus:ptyv8
[    3.195924] device: 'ptyv9': device_add
[    3.197074] PM: Adding info for No Bus:ptyv9
[    3.198384] device: 'ptyva': device_add
[    3.199576] PM: Adding info for No Bus:ptyva
[    3.200968] device: 'ptyvb': device_add
[    3.202105] PM: Adding info for No Bus:ptyvb
[    3.203451] device: 'ptyvc': device_add
[    3.204625] PM: Adding info for No Bus:ptyvc
[    3.205964] device: 'ptyvd': device_add
[    3.207155] PM: Adding info for No Bus:ptyvd
[    3.208563] device: 'ptyve': device_add
[    3.209756] PM: Adding info for No Bus:ptyve
[    3.211073] device: 'ptyvf': device_add
[    3.212270] PM: Adding info for No Bus:ptyvf
[    3.213582] device: 'ptyw0': device_add
[    3.214725] PM: Adding info for No Bus:ptyw0
[    3.216086] device: 'ptyw1': device_add
[    3.217327] PM: Adding info for No Bus:ptyw1
[    3.218740] device: 'ptyw2': device_add
[    3.219952] PM: Adding info for No Bus:ptyw2
[    3.221326] device: 'ptyw3': device_add
[    3.222556] PM: Adding info for No Bus:ptyw3
[    3.223920] device: 'ptyw4': device_add
[    3.225196] PM: Adding info for No Bus:ptyw4
[    3.226587] device: 'ptyw5': device_add
[    3.227770] PM: Adding info for No Bus:ptyw5
[    3.230100] device: 'ptyw6': device_add
[    3.231295] PM: Adding info for No Bus:ptyw6
[    3.232701] device: 'ptyw7': device_add
[    3.233862] PM: Adding info for No Bus:ptyw7
[    3.235078] device: 'ptyw8': device_add
[    3.236350] PM: Adding info for No Bus:ptyw8
[    3.237690] device: 'ptyw9': device_add
[    3.238916] PM: Adding info for No Bus:ptyw9
[    3.240303] device: 'ptywa': device_add
[    3.241473] PM: Adding info for No Bus:ptywa
[    3.242760] device: 'ptywb': device_add
[    3.243932] PM: Adding info for No Bus:ptywb
[    3.245238] device: 'ptywc': device_add
[    3.246433] PM: Adding info for No Bus:ptywc
[    3.247729] device: 'ptywd': device_add
[    3.248915] PM: Adding info for No Bus:ptywd
[    3.250212] device: 'ptywe': device_add
[    3.251395] PM: Adding info for No Bus:ptywe
[    3.252699] device: 'ptywf': device_add
[    3.253854] PM: Adding info for No Bus:ptywf
[    3.255166] device: 'ptyx0': device_add
[    3.256402] PM: Adding info for No Bus:ptyx0
[    3.257678] device: 'ptyx1': device_add
[    3.258881] PM: Adding info for No Bus:ptyx1
[    3.260261] device: 'ptyx2': device_add
[    3.261481] PM: Adding info for No Bus:ptyx2
[    3.262790] device: 'ptyx3': device_add
[    3.263946] PM: Adding info for No Bus:ptyx3
[    3.265285] device: 'ptyx4': device_add
[    3.266444] PM: Adding info for No Bus:ptyx4
[    3.267758] device: 'ptyx5': device_add
[    3.268943] PM: Adding info for No Bus:ptyx5
[    3.270245] device: 'ptyx6': device_add
[    3.271417] PM: Adding info for No Bus:ptyx6
[    3.272803] device: 'ptyx7': device_add
[    3.273975] PM: Adding info for No Bus:ptyx7
[    3.275299] device: 'ptyx8': device_add
[    3.276295] PM: Adding info for No Bus:ptyx8
[    3.277512] device: 'ptyx9': device_add
[    3.278728] PM: Adding info for No Bus:ptyx9
[    3.280075] device: 'ptyxa': device_add
[    3.281280] PM: Adding info for No Bus:ptyxa
[    3.282560] device: 'ptyxb': device_add
[    3.283715] PM: Adding info for No Bus:ptyxb
[    3.285060] device: 'ptyxc': device_add
[    3.286248] PM: Adding info for No Bus:ptyxc
[    3.287553] device: 'ptyxd': device_add
[    3.288782] PM: Adding info for No Bus:ptyxd
[    3.290089] device: 'ptyxe': device_add
[    3.291302] PM: Adding info for No Bus:ptyxe
[    3.292671] device: 'ptyxf': device_add
[    3.293907] PM: Adding info for No Bus:ptyxf
[    3.295264] device: 'ptyy0': device_add
[    3.296547] PM: Adding info for No Bus:ptyy0
[    3.297885] device: 'ptyy1': device_add
[    3.299114] PM: Adding info for No Bus:ptyy1
[    3.300460] device: 'ptyy2': device_add
[    3.301616] PM: Adding info for No Bus:ptyy2
[    3.303079] device: 'ptyy3': device_add
[    3.304305] PM: Adding info for No Bus:ptyy3
[    3.305559] device: 'ptyy4': device_add
[    3.306716] PM: Adding info for No Bus:ptyy4
[    3.308108] device: 'ptyy5': device_add
[    3.309342] PM: Adding info for No Bus:ptyy5
[    3.310671] device: 'ptyy6': device_add
[    3.311840] PM: Adding info for No Bus:ptyy6
[    3.313230] device: 'ptyy7': device_add
[    3.314403] PM: Adding info for No Bus:ptyy7
[    3.315735] device: 'ptyy8': device_add
[    3.316909] PM: Adding info for No Bus:ptyy8
[    3.318181] device: 'ptyy9': device_add
[    3.319333] PM: Adding info for No Bus:ptyy9
[    3.320736] device: 'ptyya': device_add
[    3.321909] PM: Adding info for No Bus:ptyya
[    3.323214] device: 'ptyyb': device_add
[    3.324406] PM: Adding info for No Bus:ptyyb
[    3.325715] device: 'ptyyc': device_add
[    3.326883] PM: Adding info for No Bus:ptyyc
[    3.328344] device: 'ptyyd': device_add
[    3.329552] PM: Adding info for No Bus:ptyyd
[    3.330902] device: 'ptyye': device_add
[    3.332075] PM: Adding info for No Bus:ptyye
[    3.333450] device: 'ptyyf': device_add
[    3.334612] PM: Adding info for No Bus:ptyyf
[    3.335925] device: 'ptyz0': device_add
[    3.337148] PM: Adding info for No Bus:ptyz0
[    3.338431] device: 'ptyz1': device_add
[    3.339523] PM: Adding info for No Bus:ptyz1
[    3.340820] device: 'ptyz2': device_add
[    3.342002] PM: Adding info for No Bus:ptyz2
[    3.343339] device: 'ptyz3': device_add
[    3.344613] PM: Adding info for No Bus:ptyz3
[    3.345860] device: 'ptyz4': device_add
[    3.346998] PM: Adding info for No Bus:ptyz4
[    3.348325] device: 'ptyz5': device_add
[    3.349517] PM: Adding info for No Bus:ptyz5
[    3.350850] device: 'ptyz6': device_add
[    3.352028] PM: Adding info for No Bus:ptyz6
[    3.353368] device: 'ptyz7': device_add
[    3.354496] PM: Adding info for No Bus:ptyz7
[    3.355843] device: 'ptyz8': device_add
[    3.357103] PM: Adding info for No Bus:ptyz8
[    3.358456] device: 'ptyz9': device_add
[    3.359642] PM: Adding info for No Bus:ptyz9
[    3.360953] device: 'ptyza': device_add
[    3.362097] PM: Adding info for No Bus:ptyza
[    3.363334] device: 'ptyzb': device_add
[    3.364509] PM: Adding info for No Bus:ptyzb
[    3.365823] device: 'ptyzc': device_add
[    3.366968] PM: Adding info for No Bus:ptyzc
[    3.368379] device: 'ptyzd': device_add
[    3.369599] PM: Adding info for No Bus:ptyzd
[    3.370917] device: 'ptyze': device_add
[    3.372106] PM: Adding info for No Bus:ptyze
[    3.373428] device: 'ptyzf': device_add
[    3.374598] PM: Adding info for No Bus:ptyzf
[    3.375900] device: 'ptya0': device_add
[    3.377162] PM: Adding info for No Bus:ptya0
[    3.378512] device: 'ptya1': device_add
[    3.379646] PM: Adding info for No Bus:ptya1
[    3.381056] device: 'ptya2': device_add
[    3.382221] PM: Adding info for No Bus:ptya2
[    3.383537] device: 'ptya3': device_add
[    3.384790] PM: Adding info for No Bus:ptya3
[    3.386075] device: 'ptya4': device_add
[    3.387275] PM: Adding info for No Bus:ptya4
[    3.388614] device: 'ptya5': device_add
[    3.389821] PM: Adding info for No Bus:ptya5
[    3.391153] device: 'ptya6': device_add
[    3.392432] PM: Adding info for No Bus:ptya6
[    3.393693] device: 'ptya7': device_add
[    3.394873] PM: Adding info for No Bus:ptya7
[    3.396197] device: 'ptya8': device_add
[    3.397334] PM: Adding info for No Bus:ptya8
[    3.398685] device: 'ptya9': device_add
[    3.399801] PM: Adding info for No Bus:ptya9
[    3.401158] device: 'ptyaa': device_add
[    3.402297] PM: Adding info for No Bus:ptyaa
[    3.403654] device: 'ptyab': device_add
[    3.404898] PM: Adding info for No Bus:ptyab
[    3.406258] device: 'ptyac': device_add
[    3.407458] PM: Adding info for No Bus:ptyac
[    3.408862] device: 'ptyad': device_add
[    3.410048] PM: Adding info for No Bus:ptyad
[    3.411399] device: 'ptyae': device_add
[    3.412587] PM: Adding info for No Bus:ptyae
[    3.413936] device: 'ptyaf': device_add
[    3.415137] PM: Adding info for No Bus:ptyaf
[    3.416556] device: 'ptyb0': device_add
[    3.417746] PM: Adding info for No Bus:ptyb0
[    3.419119] device: 'ptyb1': device_add
[    3.420312] PM: Adding info for No Bus:ptyb1
[    3.421658] device: 'ptyb2': device_add
[    3.422854] PM: Adding info for No Bus:ptyb2
[    3.424250] device: 'ptyb3': device_add
[    3.425459] PM: Adding info for No Bus:ptyb3
[    3.426805] device: 'ptyb4': device_add
[    3.428034] PM: Adding info for No Bus:ptyb4
[    3.429428] device: 'ptyb5': device_add
[    3.430614] PM: Adding info for No Bus:ptyb5
[    3.431957] device: 'ptyb6': device_add
[    3.433201] PM: Adding info for No Bus:ptyb6
[    3.434550] device: 'ptyb7': device_add
[    3.435741] PM: Adding info for No Bus:ptyb7
[    3.437083] device: 'ptyb8': device_add
[    3.438279] PM: Adding info for No Bus:ptyb8
[    3.439639] device: 'ptyb9': device_add
[    3.440894] PM: Adding info for No Bus:ptyb9
[    3.442226] device: 'ptyba': device_add
[    3.443425] PM: Adding info for No Bus:ptyba
[    3.444779] device: 'ptybb': device_add
[    3.445970] PM: Adding info for No Bus:ptybb
[    3.447312] device: 'ptybc': device_add
[    3.448541] PM: Adding info for No Bus:ptybc
[    3.449869] device: 'ptybd': device_add
[    3.451027] PM: Adding info for No Bus:ptybd
[    3.452408] device: 'ptybe': device_add
[    3.453603] PM: Adding info for No Bus:ptybe
[    3.454898] device: 'ptybf': device_add
[    3.456076] PM: Adding info for No Bus:ptybf
[    3.457465] device: 'ptyc0': device_add
[    3.458678] PM: Adding info for No Bus:ptyc0
[    3.460047] device: 'ptyc1': device_add
[    3.461248] PM: Adding info for No Bus:ptyc1
[    3.462566] device: 'ptyc2': device_add
[    3.463726] PM: Adding info for No Bus:ptyc2
[    3.465052] device: 'ptyc3': device_add
[    3.466249] PM: Adding info for No Bus:ptyc3
[    3.467557] device: 'ptyc4': device_add
[    3.468746] PM: Adding info for No Bus:ptyc4
[    3.470100] device: 'ptyc5': device_add
[    3.471319] PM: Adding info for No Bus:ptyc5
[    3.472776] device: 'ptyc6': device_add
[    3.473992] PM: Adding info for No Bus:ptyc6
[    3.475356] device: 'ptyc7': device_add
[    3.476624] PM: Adding info for No Bus:ptyc7
[    3.477969] device: 'ptyc8': device_add
[    3.479178] PM: Adding info for No Bus:ptyc8
[    3.480626] device: 'ptyc9': device_add
[    3.481850] PM: Adding info for No Bus:ptyc9
[    3.483225] device: 'ptyca': device_add
[    3.484430] PM: Adding info for No Bus:ptyca
[    3.485767] device: 'ptycb': device_add
[    3.486952] PM: Adding info for No Bus:ptycb
[    3.488380] device: 'ptycc': device_add
[    3.489554] PM: Adding info for No Bus:ptycc
[    3.490897] device: 'ptycd': device_add
[    3.492081] PM: Adding info for No Bus:ptycd
[    3.493404] device: 'ptyce': device_add
[    3.494466] PM: Adding info for No Bus:ptyce
[    3.495832] device: 'ptycf': device_add
[    3.497099] PM: Adding info for No Bus:ptycf
[    3.498447] device: 'ptyd0': device_add
[    3.499633] PM: Adding info for No Bus:ptyd0
[    3.500990] device: 'ptyd1': device_add
[    3.502156] PM: Adding info for No Bus:ptyd1
[    3.503499] device: 'ptyd2': device_add
[    3.504709] PM: Adding info for No Bus:ptyd2
[    3.505984] device: 'ptyd3': device_add
[    3.507142] PM: Adding info for No Bus:ptyd3
[    3.508462] device: 'ptyd4': device_add
[    3.509630] PM: Adding info for No Bus:ptyd4
[    3.510940] device: 'ptyd5': device_add
[    3.512237] PM: Adding info for No Bus:ptyd5
[    3.513547] device: 'ptyd6': device_add
[    3.514727] PM: Adding info for No Bus:ptyd6
[    3.516074] device: 'ptyd7': device_add
[    3.517248] PM: Adding info for No Bus:ptyd7
[    3.518604] device: 'ptyd8': device_add
[    3.519777] PM: Adding info for No Bus:ptyd8
[    3.521141] device: 'ptyd9': device_add
[    3.522289] PM: Adding info for No Bus:ptyd9
[    3.523623] device: 'ptyda': device_add
[    3.524842] PM: Adding info for No Bus:ptyda
[    3.526085] device: 'ptydb': device_add
[    3.527278] PM: Adding info for No Bus:ptydb
[    3.528708] device: 'ptydc': device_add
[    3.529869] PM: Adding info for No Bus:ptydc
[    3.531206] device: 'ptydd': device_add
[    3.532372] PM: Adding info for No Bus:ptydd
[    3.533584] device: 'ptyde': device_add
[    3.534746] PM: Adding info for No Bus:ptyde
[    3.536073] device: 'ptydf': device_add
[    3.537265] PM: Adding info for No Bus:ptydf
[    3.538558] device: 'ptye0': device_add
[    3.539733] PM: Adding info for No Bus:ptye0
[    3.541046] device: 'ptye1': device_add
[    3.542223] PM: Adding info for No Bus:ptye1
[    3.543591] device: 'ptye2': device_add
[    3.544857] PM: Adding info for No Bus:ptye2
[    3.546235] device: 'ptye3': device_add
[    3.547398] PM: Adding info for No Bus:ptye3
[    3.548804] device: 'ptye4': device_add
[    3.550050] PM: Adding info for No Bus:ptye4
[    3.551387] device: 'ptye5': device_add
[    3.552613] PM: Adding info for No Bus:ptye5
[    3.553929] device: 'ptye6': device_add
[    3.555055] PM: Adding info for No Bus:ptye6
[    3.556355] device: 'ptye7': device_add
[    3.557479] PM: Adding info for No Bus:ptye7
[    3.558663] device: 'ptye8': device_add
[    3.559782] PM: Adding info for No Bus:ptye8
[    3.561156] device: 'ptye9': device_add
[    3.562339] PM: Adding info for No Bus:ptye9
[    3.563658] device: 'ptyea': device_add
[    3.564631] PM: Adding info for No Bus:ptyea
[    3.565464] device: 'ptyeb': device_add
[    3.566430] PM: Adding info for No Bus:ptyeb
[    3.567528] device: 'ptyec': device_add
[    3.568635] PM: Adding info for No Bus:ptyec
[    3.569739] device: 'ptyed': device_add
[    3.570724] PM: Adding info for No Bus:ptyed
[    3.571846] device: 'ptyee': device_add
[    3.572880] PM: Adding info for No Bus:ptyee
[    3.573974] device: 'ptyef': device_add
[    3.574943] PM: Adding info for No Bus:ptyef
[    3.576040] device: 'ttyp0': device_add
[    3.577067] PM: Adding info for No Bus:ttyp0
[    3.578162] device: 'ttyp1': device_add
[    3.579291] PM: Adding info for No Bus:ttyp1
[    3.580628] device: 'ttyp2': device_add
[    3.581778] PM: Adding info for No Bus:ttyp2
[    3.583097] device: 'ttyp3': device_add
[    3.584279] PM: Adding info for No Bus:ttyp3
[    3.585586] device: 'ttyp4': device_add
[    3.586551] PM: Adding info for No Bus:ttyp4
[    3.587658] device: 'ttyp5': device_add
[    3.588742] PM: Adding info for No Bus:ttyp5
[    3.589905] device: 'ttyp6': device_add
[    3.591029] PM: Adding info for No Bus:ttyp6
[    3.592323] device: 'ttyp7': device_add
[    3.593460] PM: Adding info for No Bus:ttyp7
[    3.594788] device: 'ttyp8': device_add
[    3.595995] PM: Adding info for No Bus:ttyp8
[    3.597346] device: 'ttyp9': device_add
[    3.598557] PM: Adding info for No Bus:ttyp9
[    3.599841] device: 'ttypa': device_add
[    3.601053] PM: Adding info for No Bus:ttypa
[    3.602382] device: 'ttypb': device_add
[    3.603553] PM: Adding info for No Bus:ttypb
[    3.604847] device: 'ttypc': device_add
[    3.606048] PM: Adding info for No Bus:ttypc
[    3.607367] device: 'ttypd': device_add
[    3.608681] PM: Adding info for No Bus:ttypd
[    3.610043] device: 'ttype': device_add
[    3.611206] PM: Adding info for No Bus:ttype
[    3.612514] device: 'ttypf': device_add
[    3.613685] PM: Adding info for No Bus:ttypf
[    3.614996] device: 'ttyq0': device_add
[    3.616153] PM: Adding info for No Bus:ttyq0
[    3.617524] device: 'ttyq1': device_add
[    3.618750] PM: Adding info for No Bus:ttyq1
[    3.620073] device: 'ttyq2': device_add
[    3.621311] PM: Adding info for No Bus:ttyq2
[    3.622550] device: 'ttyq3': device_add
[    3.623593] PM: Adding info for No Bus:ttyq3
[    3.624921] device: 'ttyq4': device_add
[    3.626109] PM: Adding info for No Bus:ttyq4
[    3.627408] device: 'ttyq5': device_add
[    3.628548] PM: Adding info for No Bus:ttyq5
[    3.629838] device: 'ttyq6': device_add
[    3.630946] PM: Adding info for No Bus:ttyq6
[    3.632038] device: 'ttyq7': device_add
[    3.633131] PM: Adding info for No Bus:ttyq7
[    3.634249] device: 'ttyq8': device_add
[    3.635263] PM: Adding info for No Bus:ttyq8
[    3.636414] device: 'ttyq9': device_add
[    3.637396] PM: Adding info for No Bus:ttyq9
[    3.638569] device: 'ttyqa': device_add
[    3.639524] PM: Adding info for No Bus:ttyqa
[    3.640759] device: 'ttyqb': device_add
[    3.641760] PM: Adding info for No Bus:ttyqb
[    3.642898] device: 'ttyqc': device_add
[    3.643926] PM: Adding info for No Bus:ttyqc
[    3.645070] device: 'ttyqd': device_add
[    3.646110] PM: Adding info for No Bus:ttyqd
[    3.647228] device: 'ttyqe': device_add
[    3.648284] PM: Adding info for No Bus:ttyqe
[    3.649463] device: 'ttyqf': device_add
[    3.650425] PM: Adding info for No Bus:ttyqf
[    3.651601] device: 'ttyr0': device_add
[    3.652597] PM: Adding info for No Bus:ttyr0
[    3.653780] device: 'ttyr1': device_add
[    3.654811] PM: Adding info for No Bus:ttyr1
[    3.655917] device: 'ttyr2': device_add
[    3.657026] PM: Adding info for No Bus:ttyr2
[    3.658155] device: 'ttyr3': device_add
[    3.659168] PM: Adding info for No Bus:ttyr3
[    3.660322] device: 'ttyr4': device_add
[    3.661281] PM: Adding info for No Bus:ttyr4
[    3.662467] device: 'ttyr5': device_add
[    3.663471] PM: Adding info for No Bus:ttyr5
[    3.664661] device: 'ttyr6': device_add
[    3.665687] PM: Adding info for No Bus:ttyr6
[    3.666791] device: 'ttyr7': device_add
[    3.667883] PM: Adding info for No Bus:ttyr7
[    3.669350] device: 'ttyr8': device_add
[    3.670551] PM: Adding info for No Bus:ttyr8
[    3.671891] device: 'ttyr9': device_add
[    3.673144] PM: Adding info for No Bus:ttyr9
[    3.674497] device: 'ttyra': device_add
[    3.675683] PM: Adding info for No Bus:ttyra
[    3.677036] device: 'ttyrb': device_add
[    3.678231] PM: Adding info for No Bus:ttyrb
[    3.679591] device: 'ttyrc': device_add
[    3.680853] PM: Adding info for No Bus:ttyrc
[    3.682182] device: 'ttyrd': device_add
[    3.683376] PM: Adding info for No Bus:ttyrd
[    3.684719] device: 'ttyre': device_add
[    3.685918] PM: Adding info for No Bus:ttyre
[    3.687253] device: 'ttyrf': device_add
[    3.688521] PM: Adding info for No Bus:ttyrf
[    3.689776] device: 'ttys0': device_add
[    3.690944] PM: Adding info for No Bus:ttys0
[    3.692298] device: 'ttys1': device_add
[    3.693466] PM: Adding info for No Bus:ttys1
[    3.694791] device: 'ttys2': device_add
[    3.695936] PM: Adding info for No Bus:ttys2
[    3.697300] device: 'ttys3': device_add
[    3.698491] PM: Adding info for No Bus:ttys3
[    3.699832] device: 'ttys4': device_add
[    3.701034] PM: Adding info for No Bus:ttys4
[    3.702379] device: 'ttys5': device_add
[    3.703590] PM: Adding info for No Bus:ttys5
[    3.704989] device: 'ttys6': device_add
[    3.706106] PM: Adding info for No Bus:ttys6
[    3.707467] device: 'ttys7': device_add
[    3.708687] PM: Adding info for No Bus:ttys7
[    3.710055] device: 'ttys8': device_add
[    3.711265] PM: Adding info for No Bus:ttys8
[    3.712706] device: 'ttys9': device_add
[    3.713922] PM: Adding info for No Bus:ttys9
[    3.715279] device: 'ttysa': device_add
[    3.716524] PM: Adding info for No Bus:ttysa
[    3.717848] device: 'ttysb': device_add
[    3.719064] PM: Adding info for No Bus:ttysb
[    3.720425] device: 'ttysc': device_add
[    3.721619] PM: Adding info for No Bus:ttysc
[    3.722923] device: 'ttysd': device_add
[    3.724089] PM: Adding info for No Bus:ttysd
[    3.725292] device: 'ttyse': device_add
[    3.726484] PM: Adding info for No Bus:ttyse
[    3.727815] device: 'ttysf': device_add
[    3.729058] PM: Adding info for No Bus:ttysf
[    3.730400] device: 'ttyt0': device_add
[    3.731539] PM: Adding info for No Bus:ttyt0
[    3.734598] tsc: Refined TSC clocksource calibration: 2693.507 MHz
[    3.736578] device: 'ttyt1': device_add
[    3.737666] PM: Adding info for No Bus:ttyt1
[    3.739027] device: 'ttyt2': device_add
[    3.740233] PM: Adding info for No Bus:ttyt2
[    3.741564] device: 'ttyt3': device_add
[    3.742732] PM: Adding info for No Bus:ttyt3
[    3.744088] device: 'ttyt4': device_add
[    3.745241] PM: Adding info for No Bus:ttyt4
[    3.746633] device: 'ttyt5': device_add
[    3.747826] PM: Adding info for No Bus:ttyt5
[    3.749161] device: 'ttyt6': device_add
[    3.750343] PM: Adding info for No Bus:ttyt6
[    3.751668] device: 'ttyt7': device_add
[    3.752897] PM: Adding info for No Bus:ttyt7
[    3.754192] device: 'ttyt8': device_add
[    3.755378] PM: Adding info for No Bus:ttyt8
[    3.756699] device: 'ttyt9': device_add
[    3.757785] PM: Adding info for No Bus:ttyt9
[    3.759059] device: 'ttyta': device_add
[    3.760270] PM: Adding info for No Bus:ttyta
[    3.761592] device: 'ttytb': device_add
[    3.762780] PM: Adding info for No Bus:ttytb
[    3.764110] device: 'ttytc': device_add
[    3.765250] PM: Adding info for No Bus:ttytc
[    3.766544] device: 'ttytd': device_add
[    3.767743] PM: Adding info for No Bus:ttytd
[    3.769105] device: 'ttyte': device_add
[    3.770231] PM: Adding info for No Bus:ttyte
[    3.771526] device: 'ttytf': device_add
[    3.772691] PM: Adding info for No Bus:ttytf
[    3.773999] device: 'ttyu0': device_add
[    3.775194] PM: Adding info for No Bus:ttyu0
[    3.776618] device: 'ttyu1': device_add
[    3.777834] PM: Adding info for No Bus:ttyu1
[    3.779147] device: 'ttyu2': device_add
[    3.780352] PM: Adding info for No Bus:ttyu2
[    3.781774] device: 'ttyu3': device_add
[    3.782957] PM: Adding info for No Bus:ttyu3
[    3.784333] device: 'ttyu4': device_add
[    3.785486] PM: Adding info for No Bus:ttyu4
[    3.786776] device: 'ttyu5': device_add
[    3.787951] PM: Adding info for No Bus:ttyu5
[    3.789319] device: 'ttyu6': device_add
[    3.790318] PM: Adding info for No Bus:ttyu6
[    3.791481] device: 'ttyu7': device_add
[    3.792596] PM: Adding info for No Bus:ttyu7
[    3.793837] device: 'ttyu8': device_add
[    3.794926] PM: Adding info for No Bus:ttyu8
[    3.796179] device: 'ttyu9': device_add
[    3.797329] PM: Adding info for No Bus:ttyu9
[    3.798610] device: 'ttyua': device_add
[    3.799798] PM: Adding info for No Bus:ttyua
[    3.801171] device: 'ttyub': device_add
[    3.802361] PM: Adding info for No Bus:ttyub
[    3.803709] device: 'ttyuc': device_add
[    3.804910] PM: Adding info for No Bus:ttyuc
[    3.806273] device: 'ttyud': device_add
[    3.807453] PM: Adding info for No Bus:ttyud
[    3.808776] device: 'ttyue': device_add
[    3.809925] PM: Adding info for No Bus:ttyue
[    3.811281] device: 'ttyuf': device_add
[    3.812525] PM: Adding info for No Bus:ttyuf
[    3.813892] device: 'ttyv0': device_add
[    3.815124] PM: Adding info for No Bus:ttyv0
[    3.816569] device: 'ttyv1': device_add
[    3.817774] PM: Adding info for No Bus:ttyv1
[    3.819127] device: 'ttyv2': device_add
[    3.820303] PM: Adding info for No Bus:ttyv2
[    3.821667] device: 'ttyv3': device_add
[    3.822816] PM: Adding info for No Bus:ttyv3
[    3.824157] device: 'ttyv4': device_add
[    3.825407] PM: Adding info for No Bus:ttyv4
[    3.826743] device: 'ttyv5': device_add
[    3.827819] PM: Adding info for No Bus:ttyv5
[    3.829158] device: 'ttyv6': device_add
[    3.830351] PM: Adding info for No Bus:ttyv6
[    3.831678] device: 'ttyv7': device_add
[    3.832823] PM: Adding info for No Bus:ttyv7
[    3.833966] device: 'ttyv8': device_add
[    3.834944] PM: Adding info for No Bus:ttyv8
[    3.836131] device: 'ttyv9': device_add
[    3.837163] PM: Adding info for No Bus:ttyv9
[    3.838290] device: 'ttyva': device_add
[    3.839451] PM: Adding info for No Bus:ttyva
[    3.840798] device: 'ttyvb': device_add
[    3.841972] PM: Adding info for No Bus:ttyvb
[    3.843280] device: 'ttyvc': device_add
[    3.844470] PM: Adding info for No Bus:ttyvc
[    3.845804] device: 'ttyvd': device_add
[    3.846882] PM: Adding info for No Bus:ttyvd
[    3.848242] device: 'ttyve': device_add
[    3.849268] PM: Adding info for No Bus:ttyve
[    3.850398] device: 'ttyvf': device_add
[    3.851404] PM: Adding info for No Bus:ttyvf
[    3.852544] device: 'ttyw0': device_add
[    3.853575] PM: Adding info for No Bus:ttyw0
[    3.854880] device: 'ttyw1': device_add
[    3.856035] PM: Adding info for No Bus:ttyw1
[    3.857401] device: 'ttyw2': device_add
[    3.858576] PM: Adding info for No Bus:ttyw2
[    3.859864] device: 'ttyw3': device_add
[    3.861183] PM: Adding info for No Bus:ttyw3
[    3.862534] device: 'ttyw4': device_add
[    3.863734] PM: Adding info for No Bus:ttyw4
[    3.865111] device: 'ttyw5': device_add
[    3.866272] PM: Adding info for No Bus:ttyw5
[    3.867574] device: 'ttyw6': device_add
[    3.868747] PM: Adding info for No Bus:ttyw6
[    3.870072] device: 'ttyw7': device_add
[    3.871243] PM: Adding info for No Bus:ttyw7
[    3.872483] device: 'ttyw8': device_add
[    3.873644] PM: Adding info for No Bus:ttyw8
[    3.874976] device: 'ttyw9': device_add
[    3.876132] PM: Adding info for No Bus:ttyw9
[    3.877478] device: 'ttywa': device_add
[    3.878672] PM: Adding info for No Bus:ttywa
[    3.879875] device: 'ttywb': device_add
[    3.881109] PM: Adding info for No Bus:ttywb
[    3.882441] device: 'ttywc': device_add
[    3.883567] PM: Adding info for No Bus:ttywc
[    3.884892] device: 'ttywd': device_add
[    3.886057] PM: Adding info for No Bus:ttywd
[    3.887331] device: 'ttywe': device_add
[    3.888568] PM: Adding info for No Bus:ttywe
[    3.889930] device: 'ttywf': device_add
[    3.891135] PM: Adding info for No Bus:ttywf
[    3.892486] device: 'ttyx0': device_add
[    3.893623] PM: Adding info for No Bus:ttyx0
[    3.894935] device: 'ttyx1': device_add
[    3.896152] PM: Adding info for No Bus:ttyx1
[    3.897567] device: 'ttyx2': device_add
[    3.898771] PM: Adding info for No Bus:ttyx2
[    3.900049] device: 'ttyx3': device_add
[    3.901208] PM: Adding info for No Bus:ttyx3
[    3.902371] device: 'ttyx4': device_add
[    3.903370] PM: Adding info for No Bus:ttyx4
[    3.904666] device: 'ttyx5': device_add
[    3.905805] PM: Adding info for No Bus:ttyx5
[    3.907199] device: 'ttyx6': device_add
[    3.908401] PM: Adding info for No Bus:ttyx6
[    3.909663] device: 'ttyx7': device_add
[    3.910838] PM: Adding info for No Bus:ttyx7
[    3.912052] device: 'ttyx8': device_add
[    3.913277] PM: Adding info for No Bus:ttyx8
[    3.914589] device: 'ttyx9': device_add
[    3.915728] PM: Adding info for No Bus:ttyx9
[    3.917050] device: 'ttyxa': device_add
[    3.918233] PM: Adding info for No Bus:ttyxa
[    3.919610] device: 'ttyxb': device_add
[    3.920810] PM: Adding info for No Bus:ttyxb
[    3.922160] device: 'ttyxc': device_add
[    3.923374] PM: Adding info for No Bus:ttyxc
[    3.924711] device: 'ttyxd': device_add
[    3.925777] PM: Adding info for No Bus:ttyxd
[    3.927116] device: 'ttyxe': device_add
[    3.928368] PM: Adding info for No Bus:ttyxe
[    3.929733] device: 'ttyxf': device_add
[    3.930943] PM: Adding info for No Bus:ttyxf
[    3.932324] device: 'ttyy0': device_add
[    3.933494] PM: Adding info for No Bus:ttyy0
[    3.934801] device: 'ttyy1': device_add
[    3.935982] PM: Adding info for No Bus:ttyy1
[    3.937341] device: 'ttyy2': device_add
[    3.938570] PM: Adding info for No Bus:ttyy2
[    3.939834] device: 'ttyy3': device_add
[    3.940994] PM: Adding info for No Bus:ttyy3
[    3.942303] device: 'ttyy4': device_add
[    3.943483] PM: Adding info for No Bus:ttyy4
[    3.944869] device: 'ttyy5': device_add
[    3.946037] PM: Adding info for No Bus:ttyy5
[    3.947331] device: 'ttyy6': device_add
[    3.948543] PM: Adding info for No Bus:ttyy6
[    3.949892] device: 'ttyy7': device_add
[    3.951095] PM: Adding info for No Bus:ttyy7
[    3.952484] device: 'ttyy8': device_add
[    3.953657] PM: Adding info for No Bus:ttyy8
[    3.954955] device: 'ttyy9': device_add
[    3.956103] PM: Adding info for No Bus:ttyy9
[    3.957476] device: 'ttyya': device_add
[    3.958603] PM: Adding info for No Bus:ttyya
[    3.959889] device: 'ttyyb': device_add
[    3.961102] PM: Adding info for No Bus:ttyyb
[    3.962278] device: 'ttyyc': device_add
[    3.963464] PM: Adding info for No Bus:ttyyc
[    3.964764] device: 'ttyyd': device_add
[    3.965905] PM: Adding info for No Bus:ttyyd
[    3.967225] device: 'ttyye': device_add
[    3.968498] PM: Adding info for No Bus:ttyye
[    3.969784] device: 'ttyyf': device_add
[    3.970917] PM: Adding info for No Bus:ttyyf
[    3.972256] device: 'ttyz0': device_add
[    3.973425] PM: Adding info for No Bus:ttyz0
[    3.974777] device: 'ttyz1': device_add
[    3.975996] PM: Adding info for No Bus:ttyz1
[    3.977422] device: 'ttyz2': device_add
[    3.978647] PM: Adding info for No Bus:ttyz2
[    3.979980] device: 'ttyz3': device_add
[    3.981263] PM: Adding info for No Bus:ttyz3
[    3.982618] device: 'ttyz4': device_add
[    3.983818] PM: Adding info for No Bus:ttyz4
[    3.985206] device: 'ttyz5': device_add
[    3.986399] PM: Adding info for No Bus:ttyz5
[    3.987744] device: 'ttyz6': device_add
[    3.988927] PM: Adding info for No Bus:ttyz6
[    3.990267] device: 'ttyz7': device_add
[    3.991432] PM: Adding info for No Bus:ttyz7
[    3.992784] device: 'ttyz8': device_add
[    3.993887] PM: Adding info for No Bus:ttyz8
[    3.995224] device: 'ttyz9': device_add
[    3.996397] PM: Adding info for No Bus:ttyz9
[    3.997715] device: 'ttyza': device_add
[    3.998933] PM: Adding info for No Bus:ttyza
[    4.000287] device: 'ttyzb': device_add
[    4.001467] PM: Adding info for No Bus:ttyzb
[    4.002765] device: 'ttyzc': device_add
[    4.003942] PM: Adding info for No Bus:ttyzc
[    4.005282] device: 'ttyzd': device_add
[    4.006471] PM: Adding info for No Bus:ttyzd
[    4.007749] device: 'ttyze': device_add
[    4.008963] PM: Adding info for No Bus:ttyze
[    4.010274] device: 'ttyzf': device_add
[    4.011441] PM: Adding info for No Bus:ttyzf
[    4.012749] device: 'ttya0': device_add
[    4.013915] PM: Adding info for No Bus:ttya0
[    4.015192] device: 'ttya1': device_add
[    4.016443] PM: Adding info for No Bus:ttya1
[    4.017780] device: 'ttya2': device_add
[    4.018969] PM: Adding info for No Bus:ttya2
[    4.020299] device: 'ttya3': device_add
[    4.021471] PM: Adding info for No Bus:ttya3
[    4.022780] device: 'ttya4': device_add
[    4.023937] PM: Adding info for No Bus:ttya4
[    4.025316] device: 'ttya5': device_add
[    4.026536] PM: Adding info for No Bus:ttya5
[    4.027853] device: 'ttya6': device_add
[    4.029065] PM: Adding info for No Bus:ttya6
[    4.030432] device: 'ttya7': device_add
[    4.031603] PM: Adding info for No Bus:ttya7
[    4.032998] device: 'ttya8': device_add
[    4.034048] PM: Adding info for No Bus:ttya8
[    4.035233] device: 'ttya9': device_add
[    4.036377] PM: Adding info for No Bus:ttya9
[    4.037717] device: 'ttyaa': device_add
[    4.038882] PM: Adding info for No Bus:ttyaa
[    4.040146] device: 'ttyab': device_add
[    4.041358] PM: Adding info for No Bus:ttyab
[    4.042648] device: 'ttyac': device_add
[    4.043813] PM: Adding info for No Bus:ttyac
[    4.045157] device: 'ttyad': device_add
[    4.046352] PM: Adding info for No Bus:ttyad
[    4.047732] device: 'ttyae': device_add
[    4.048935] PM: Adding info for No Bus:ttyae
[    4.050246] device: 'ttyaf': device_add
[    4.051459] PM: Adding info for No Bus:ttyaf
[    4.052839] device: 'ttyb0': device_add
[    4.053997] PM: Adding info for No Bus:ttyb0
[    4.055293] device: 'ttyb1': device_add
[    4.056512] PM: Adding info for No Bus:ttyb1
[    4.057820] device: 'ttyb2': device_add
[    4.058945] PM: Adding info for No Bus:ttyb2
[    4.060091] device: 'ttyb3': device_add
[    4.061239] PM: Adding info for No Bus:ttyb3
[    4.062456] device: 'ttyb4': device_add
[    4.063532] PM: Adding info for No Bus:ttyb4
[    4.064826] device: 'ttyb5': device_add
[    4.065946] PM: Adding info for No Bus:ttyb5
[    4.067074] device: 'ttyb6': device_add
[    4.068046] PM: Adding info for No Bus:ttyb6
[    4.069160] device: 'ttyb7': device_add
[    4.070157] PM: Adding info for No Bus:ttyb7
[    4.071228] device: 'ttyb8': device_add
[    4.072268] PM: Adding info for No Bus:ttyb8
[    4.073367] device: 'ttyb9': device_add
[    4.074098] PM: Adding info for No Bus:ttyb9
[    4.075124] device: 'ttyba': device_add
[    4.076125] PM: Adding info for No Bus:ttyba
[    4.077294] device: 'ttybb': device_add
[    4.078266] PM: Adding info for No Bus:ttybb
[    4.079394] device: 'ttybc': device_add
[    4.080419] PM: Adding info for No Bus:ttybc
[    4.081523] device: 'ttybd': device_add
[    4.082500] PM: Adding info for No Bus:ttybd
[    4.083597] device: 'ttybe': device_add
[    4.084583] PM: Adding info for No Bus:ttybe
[    4.085678] device: 'ttybf': device_add
[    4.086652] PM: Adding info for No Bus:ttybf
[    4.087744] device: 'ttyc0': device_add
[    4.088817] PM: Adding info for No Bus:ttyc0
[    4.089913] device: 'ttyc1': device_add
[    4.090882] PM: Adding info for No Bus:ttyc1
[    4.091981] device: 'ttyc2': device_add
[    4.092960] PM: Adding info for No Bus:ttyc2
[    4.094073] device: 'ttyc3': device_add
[    4.095056] PM: Adding info for No Bus:ttyc3
[    4.096151] device: 'ttyc4': device_add
[    4.097166] PM: Adding info for No Bus:ttyc4
[    4.098114] device: 'ttyc5': device_add
[    4.098948] PM: Adding info for No Bus:ttyc5
[    4.099915] device: 'ttyc6': device_add
[    4.100931] PM: Adding info for No Bus:ttyc6
[    4.101994] device: 'ttyc7': device_add
[    4.102965] PM: Adding info for No Bus:ttyc7
[    4.104062] device: 'ttyc8': device_add
[    4.105094] PM: Adding info for No Bus:ttyc8
[    4.106199] device: 'ttyc9': device_add
[    4.107188] PM: Adding info for No Bus:ttyc9
[    4.108287] device: 'ttyca': device_add
[    4.109290] PM: Adding info for No Bus:ttyca
[    4.110375] device: 'ttycb': device_add
[    4.111341] PM: Adding info for No Bus:ttycb
[    4.112508] device: 'ttycc': device_add
[    4.113477] PM: Adding info for No Bus:ttycc
[    4.114567] device: 'ttycd': device_add
[    4.115544] PM: Adding info for No Bus:ttycd
[    4.116630] device: 'ttyce': device_add
[    4.117587] PM: Adding info for No Bus:ttyce
[    4.118719] device: 'ttycf': device_add
[    4.119691] PM: Adding info for No Bus:ttycf
[    4.120874] device: 'ttyd0': device_add
[    4.121860] PM: Adding info for No Bus:ttyd0
[    4.122965] device: 'ttyd1': device_add
[    4.123950] PM: Adding info for No Bus:ttyd1
[    4.125130] device: 'ttyd2': device_add
[    4.126122] PM: Adding info for No Bus:ttyd2
[    4.127240] device: 'ttyd3': device_add
[    4.128253] PM: Adding info for No Bus:ttyd3
[    4.129384] device: 'ttyd4': device_add
[    4.130351] PM: Adding info for No Bus:ttyd4
[    4.131469] device: 'ttyd5': device_add
[    4.132434] PM: Adding info for No Bus:ttyd5
[    4.133535] device: 'ttyd6': device_add
[    4.134490] PM: Adding info for No Bus:ttyd6
[    4.135592] device: 'ttyd7': device_add
[    4.136642] PM: Adding info for No Bus:ttyd7
[    4.137760] device: 'ttyd8': device_add
[    4.138781] PM: Adding info for No Bus:ttyd8
[    4.139890] device: 'ttyd9': device_add
[    4.140876] PM: Adding info for No Bus:ttyd9
[    4.141976] device: 'ttyda': device_add
[    4.142968] PM: Adding info for No Bus:ttyda
[    4.144070] device: 'ttydb': device_add
[    4.145110] PM: Adding info for No Bus:ttydb
[    4.146219] device: 'ttydc': device_add
[    4.147198] PM: Adding info for No Bus:ttydc
[    4.148350] device: 'ttydd': device_add
[    4.149346] PM: Adding info for No Bus:ttydd
[    4.150456] device: 'ttyde': device_add
[    4.151430] PM: Adding info for No Bus:ttyde
[    4.152602] device: 'ttydf': device_add
[    4.153586] PM: Adding info for No Bus:ttydf
[    4.154663] device: 'ttye0': device_add
[    4.155629] PM: Adding info for No Bus:ttye0
[    4.156707] device: 'ttye1': device_add
[    4.157685] PM: Adding info for No Bus:ttye1
[    4.158810] device: 'ttye2': device_add
[    4.159786] PM: Adding info for No Bus:ttye2
[    4.160964] device: 'ttye3': device_add
[    4.161913] PM: Adding info for No Bus:ttye3
[    4.162993] device: 'ttye4': device_add
[    4.163960] PM: Adding info for No Bus:ttye4
[    4.165055] device: 'ttye5': device_add
[    4.166101] PM: Adding info for No Bus:ttye5
[    4.167205] device: 'ttye6': device_add
[    4.168256] PM: Adding info for No Bus:ttye6
[    4.169397] device: 'ttye7': device_add
[    4.170366] PM: Adding info for No Bus:ttye7
[    4.171479] device: 'ttye8': device_add
[    4.172516] PM: Adding info for No Bus:ttye8
[    4.173623] device: 'ttye9': device_add
[    4.174612] PM: Adding info for No Bus:ttye9
[    4.175720] device: 'ttyea': device_add
[    4.176754] PM: Adding info for No Bus:ttyea
[    4.177864] device: 'ttyeb': device_add
[    4.178754] PM: Adding info for No Bus:ttyeb
[    4.179485] device: 'ttyec': device_add
[    4.180111] PM: Adding info for No Bus:ttyec
[    4.180807] device: 'ttyed': device_add
[    4.181556] PM: Adding info for No Bus:ttyed
[    4.182642] device: 'ttyee': device_add
[    4.183603] PM: Adding info for No Bus:ttyee
[    4.184788] device: 'ttyef': device_add
[    4.185736] PM: Adding info for No Bus:ttyef
[    4.186806] device: 'ptmx': device_add
[    4.187744] PM: Adding info for No Bus:ptmx
[    4.188836] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.190429] bus: 'pnp': add driver serial
[    4.191499] bus: 'pnp': driver_probe_device: matched device 00:05 with d=
river serial
[    4.193337] bus: 'pnp': really_probe: probing driver serial with device =
00:05
[    4.218885] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    4.220598] device: 'ttyS0': device_add
[    4.221767] PM: Adding info for No Bus:ttyS0
[    4.223143] driver: '00:05': driver_bound: bound to device 'serial'
[    4.225083] bus: 'pnp': really_probe: bound device 00:05 to driver serial
[    4.227233] Registering platform device 'serial8250'. Parent at platform
[    4.229209] device: 'serial8250': device_add
[    4.230540] bus: 'platform': add device serial8250
[    4.232028] PM: Adding info for platform:serial8250
[    4.233625] device: 'ttyS1': device_add
[    4.234776] PM: Adding info for No Bus:ttyS1
[    4.236197] device: 'ttyS2': device_add
[    4.237230] PM: Adding info for No Bus:ttyS2
[    4.238393] device: 'ttyS3': device_add
[    4.239494] PM: Adding info for No Bus:ttyS3
[    4.240707] bus: 'platform': add driver serial8250
[    4.242128] bus: 'platform': driver_probe_device: matched device serial8=
250 with driver serial8250
[    4.244687] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250
[    4.246992] driver: 'serial8250': driver_bound: bound to device 'serial8=
250'
[    4.248326] bus: 'platform': really_probe: bound device serial8250 to dr=
iver serial8250
[    4.250032] bus: 'pci': add driver serial
[    4.251287] bus: 'pci': add driver jsm
[    4.252339] bus: 'pci': add driver pch_uart
[    4.253506] bus: 'platform': add driver xuartps
[    4.254714] bus: 'platform': add driver arc-uart
[    4.255933] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    4.258042] ac.o: No PCI boards found.
[    4.259223] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    4.261430] device: 'hpet': device_add
[    4.262627] PM: Adding info for No Bus:hpet
[    4.263965] bus: 'acpi': add driver hpet
[    4.265233] bus: 'acpi': driver_probe_device: matched device PNP0103:00 =
with driver hpet
[    4.267701] bus: 'acpi': really_probe: probing driver hpet with device P=
NP0103:00
[    4.270096] hpet: probe of PNP0103:00 rejects match -19
[    4.271696] device: 'nvram': device_add
[    4.272907] PM: Adding info for No Bus:nvram
[    4.274226] Non-volatile memory driver v1.3
[    4.275784] nsc_gpio initializing
[    4.276806] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    4.279479] Hangcheck: Using getrawmonotonic().
[    4.280899] bus: 'platform': add driver tpm_atmel
[    4.282417] bus: 'platform': remove driver tpm_atmel
[    4.283962] driver: 'tpm_atmel': driver_release
[    4.285382] bus: 'pci': add driver poulsbo
[    4.286742] bus: 'pci': add driver ibmasm
[    4.288044] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    4.290034] bus: 'pci': add driver pciPTI
[    4.291261] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    4.293450] device class 'c2port': registering
[    4.294927] device: 'c2port0': device_add
[    4.296221] PM: Adding info for No Bus:c2port0
[    4.297715] c2port c2port0: C2 port uc added
[    4.299090] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    4.301432] bus: 'pci': add driver pch_phub
[    4.302812] bus: 'platform': add driver kim
[    4.304127] bus: 'pci': add driver rtsx_pci
[    4.305483] bus: 'spi': add driver arizona
[    4.306759] bus: 'ac97': add driver ucb1400_core
[    4.308188] bus: 'pci': add driver lpc_sch
[    4.309534] bus: 'pci': add driver lpc_ich
[    4.310810] bus: 'pci': add driver RDC321x Southbridge
[    4.312289] bus: 'pci': add driver vx855
[    4.313556] bus: 'pci': add driver cs5535-mfd
[    4.314943] bus: 'usb': add driver pn533
[    4.316177] usbcore: registered new interface driver pn533
[    4.317883] bus: 'platform': add driver spi_altera
[    4.319334] bus: 'platform': add driver pch-spi
[    4.320749] bus: 'pci': add driver pch_spi
[    4.322052] vcan: Virtual CAN interface driver
[    4.323431] slcan: serial line CAN interface driver
[    4.324884] slcan: 10 dynamic interface channels.
[    4.326413] bus: 'firewire': registered
[    4.327633] bus: 'pci': add driver firewire_ohci
[    4.329097] bus: 'firewire': add driver firewire_net
[    4.330652] device class 'uwb_rc': registering
[    4.332068] bus: 'umc': registered
[    4.333107] bus: 'pci': add driver whci
[    4.334288] bus: 'umc': add driver whc-rc
[    4.335574] bus: 'usb': add driver hwa-rc
[    4.336835] usbcore: registered new interface driver hwa-rc
[    4.338555] bus: 'platform': add driver gpio-vbus
[    4.340035] bus: 'platform': remove driver gpio-vbus
[    4.341546] driver: 'gpio-vbus': driver_release
[    4.342915] bus: 'platform': add driver isp116x-hcd
[    4.344414] uhci_hcd: USB Universal Host Controller Interface driver
[    4.346312] bus: 'pci': add driver uhci_hcd
[    4.347619] bus: 'pci': add driver xhci_hcd
[    4.348987] bus: 'platform': add driver r8a66597_hcd
[    4.350560] bus: 'platform': add driver isp1760
[    4.351976] bus: 'platform': add driver nxp-isp1760
[    4.353295] bus: 'pci': add driver isp1760
[    4.354514] bus: 'usb': add driver hwa-hc
[    4.355754] usbcore: registered new interface driver hwa-hc
[    4.357424] bus: 'bcma': add driver bcma_hcd
[    4.358834] bus: 'usb': add driver wusb-cbaf
[    4.360146] usbcore: registered new interface driver wusb-cbaf
[    4.361869] bus: 'usb': add driver cdc_acm
[    4.363156] usbcore: registered new interface driver cdc_acm
[    4.364933] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[    4.367346] bus: 'usb': add driver usblp
[    4.368594] usbcore: registered new interface driver usblp
[    4.370306] bus: 'usb': add driver cdc_wdm
[    4.371601] usbcore: registered new interface driver cdc_wdm
[    4.373333] bus: 'usb-serial': registered
[    4.374538] bus: 'usb': add driver usbserial
[    4.375862] usbcore: registered new interface driver usbserial
[    4.377436] bus: 'usb': add driver usbserial_generic
[    4.378822] usbcore: registered new interface driver usbserial_generic
[    4.380584] bus: 'usb-serial': add driver generic
[    4.381990] usbserial: USB Serial support registered for generic
[    4.383726] bus: 'usb': add driver belkin_sa
[    4.384798] usbcore: registered new interface driver belkin_sa
[    4.385892] bus: 'usb-serial': add driver belkin
[    4.386785] usbserial: USB Serial support registered for Belkin / Peraco=
m / GoHubs USB Serial Adapter
[    4.388501] bus: 'usb': add driver io_edgeport
[    4.389354] usbcore: registered new interface driver io_edgeport
[    4.390479] bus: 'usb-serial': add driver edgeport_2
[    4.391423] usbserial: USB Serial support registered for Edgeport 2 port=
 adapter
[    4.392820] bus: 'usb-serial': add driver edgeport_4
[    4.393769] usbserial: USB Serial support registered for Edgeport 4 port=
 adapter
[    4.395138] bus: 'usb-serial': add driver edgeport_8
[    4.396084] usbserial: USB Serial support registered for Edgeport 8 port=
 adapter
[    4.397453] bus: 'usb-serial': add driver epic
[    4.398298] usbserial: USB Serial support registered for EPiC device
[    4.399503] bus: 'usb': add driver io_ti
[    4.400282] usbcore: registered new interface driver io_ti
[    4.401307] bus: 'usb-serial': add driver edgeport_ti_1
[    4.402302] usbserial: USB Serial support registered for Edgeport TI 1 p=
ort adapter
[    4.403719] bus: 'usb-serial': add driver edgeport_ti_2
[    4.404711] usbserial: USB Serial support registered for Edgeport TI 2 p=
ort adapter
[    4.406122] bus: 'usb': add driver empeg
[    4.406871] usbcore: registered new interface driver empeg
[    4.407898] bus: 'usb-serial': add driver empeg
[    4.408785] usbserial: USB Serial support registered for empeg
[    4.409880] bus: 'usb': add driver ipaq
[    4.410627] usbcore: registered new interface driver ipaq
[    4.411644] bus: 'usb-serial': add driver ipaq
[    4.412519] usbserial: USB Serial support registered for PocketPC PDA
[    4.413714] bus: 'usb': add driver kl5kusb105
[    4.414549] usbcore: registered new interface driver kl5kusb105
[    4.415649] bus: 'usb-serial': add driver kl5kusb105d
[    4.416611] usbserial: USB Serial support registered for KL5KUSB105D / P=
almConnect
[    4.418018] bus: 'usb': add driver mct_u232
[    4.418821] usbcore: registered new interface driver mct_u232
[    4.419890] bus: 'usb-serial': add driver mct_u232
[    4.420807] usbserial: USB Serial support registered for MCT U232
[    4.421937] bus: 'usb': add driver metro_usb
[    4.422758] usbcore: registered new interface driver metro_usb
[    4.423844] bus: 'usb-serial': add driver metro-usb
[    4.424778] usbserial: USB Serial support registered for Metrologic USB =
to Serial
[    4.426155] bus: 'usb': add driver mos7720
[    4.426930] usbcore: registered new interface driver mos7720
[    4.427979] bus: 'usb-serial': add driver moschip7720
[    4.428953] usbserial: USB Serial support registered for Moschip 2 port =
adapter
[    4.430296] bus: 'usb': add driver mos7840
[    4.431081] usbcore: registered new interface driver mos7840
[    4.432131] bus: 'usb-serial': add driver mos7840
[    4.433034] usbserial: USB Serial support registered for Moschip 7840/78=
20 USB Serial Driver
[    4.434586] bus: 'usb': add driver navman
[    4.435355] usbcore: registered new interface driver navman
[    4.436404] bus: 'usb-serial': add driver navman
[    4.437281] usbserial: USB Serial support registered for navman
[    4.438450] bus: 'usb': add driver opticon
[    4.439274] usbcore: registered new interface driver opticon
[    4.440417] bus: 'usb-serial': add driver opticon
[    4.441350] usbserial: USB Serial support registered for opticon
[    4.442540] bus: 'usb': add driver qcserial
[    4.443385] usbcore: registered new interface driver qcserial
[    4.445124] bus: 'usb-serial': add driver qcserial
[    4.446615] usbserial: USB Serial support registered for Qualcomm USB mo=
dem
[    4.448768] bus: 'usb': add driver ssu100
[    4.450050] usbcore: registered new interface driver ssu100
[    4.451788] bus: 'usb-serial': add driver ssu100
[    4.453253] usbserial: USB Serial support registered for Quatech SSU-100=
 USB to Serial Driver
[    4.455876] bus: 'usb': add driver ti_usb_3410_5052
[    4.457429] usbcore: registered new interface driver ti_usb_3410_5052
[    4.459434] bus: 'usb-serial': add driver ti_usb_3410_5052_1
[    4.461199] usbserial: USB Serial support registered for TI USB 3410 1 p=
ort adapter
[    4.463556] bus: 'usb-serial': add driver ti_usb_3410_5052_2
[    4.465341] usbserial: USB Serial support registered for TI USB 5052 2 p=
ort adapter
[    4.467717] bus: 'usb': add driver visor
[    4.468976] usbcore: registered new interface driver visor
[    4.470670] bus: 'usb-serial': add driver visor
[    4.472087] usbserial: USB Serial support registered for Handspring Viso=
r / Palm OS
[    4.474368] bus: 'usb-serial': add driver clie_5
[    4.475800] usbserial: USB Serial support registered for Sony Clie 5.0
[    4.477752] bus: 'usb-serial': add driver clie_3.5
[    4.479248] usbserial: USB Serial support registered for Sony Clie 3.5
[    4.481223] bus: 'usb': add driver adutux
[    4.482495] usbcore: registered new interface driver adutux
[    4.484317] bus: 'usb': add driver appledisplay
[    4.485759] usbcore: registered new interface driver appledisplay
[    4.487605] bus: 'usb': add driver cytherm
[    4.488883] usbcore: registered new interface driver cytherm
[    4.490618] bus: 'usb': add driver iowarrior
[    4.491932] usbcore: registered new interface driver iowarrior
[    4.493734] bus: 'usb': add driver isight_firmware
[    4.495262] usbcore: registered new interface driver isight_firmware
[    4.497264] bus: 'usb': add driver usblcd
[    4.498607] usbcore: registered new interface driver usblcd
[    4.500367] bus: 'usb': add driver usbled
[    4.501666] usbcore: registered new interface driver usbled
[    4.503395] bus: 'usb': add driver usbtest
[    4.504695] usbcore: registered new interface driver usbtest
[    4.506466] bus: 'usb': add driver trancevibrator
[    4.507842] usbcore: registered new interface driver trancevibrator
[    4.509730] bus: 'usb': add driver yurex
[    4.510977] usbcore: registered new interface driver yurex
[    4.512637] bus: 'platform': add driver rcar_usb_phy
[    4.514115] bus: 'platform': add driver ci_hdrc
[    4.515465] bus: 'platform': add driver msm_hsusb
[    4.516952] bus: 'pci': add driver ci13xxx_pci
[    4.518364] bus: 'platform': add driver imx_usb
[    4.519814] bus: 'platform': add driver dummy_hcd
[    4.521266] bus: 'platform': add driver dummy_udc
[    4.522722] Registering platform device 'dummy_hcd.0'. Parent at platform
[    4.524745] device: 'dummy_hcd.0': device_add
[    4.526077] bus: 'platform': add device dummy_hcd.0
[    4.527550] PM: Adding info for platform:dummy_hcd.0
[    4.529101] bus: 'platform': driver_probe_device: matched device dummy_h=
cd.0 with driver dummy_hcd
[    4.531721] bus: 'platform': really_probe: probing driver dummy_hcd with=
 device dummy_hcd.0
[    4.534209] dummy_hcd dummy_hcd.0: USB Host+Gadget Emulator, driver 02 M=
ay 2005
[    4.536356] dummy_hcd dummy_hcd.0: Dummy host controller
[    4.538098] dummy_hcd dummy_hcd.0: new USB bus registered, assigned bus =
number 1
[    4.540503] usb usb1: default language 0x0409
[    4.541868] usb usb1: udev 1, busnum 1, minor =3D 0
[    4.543096] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    4.544889] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    4.547040] usb usb1: Product: Dummy host controller
[    4.548548] usb usb1: Manufacturer: Linux 3.8.0-rc5-00646-g2f520a0 dummy=
_hcd
[    4.550648] usb usb1: SerialNumber: dummy_hcd.0
[    4.552073] device: 'usb1': device_add
[    4.553251] bus: 'usb': add device usb1
[    4.554471] PM: Adding info for usb:usb1
[    4.555673] bus: 'usb': driver_probe_device: matched device usb1 with dr=
iver usb
[    4.557786] bus: 'usb': really_probe: probing driver usb with device usb1
[    4.559863] usb usb1: usb_probe_device
[    4.560975] usb usb1: configuration #1 chosen from 1 choice
[    4.562756] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.564477] device: '1-0:1.0': device_add
[    4.565714] bus: 'usb': add device 1-0:1.0
[    4.566998] PM: Adding info for usb:1-0:1.0
[    4.568454] bus: 'usb': driver_probe_device: matched device 1-0:1.0 with=
 driver hub
[    4.570721] bus: 'usb': really_probe: probing driver hub with device 1-0=
:1.0
[    4.572881] hub 1-0:1.0: usb_probe_interface
[    4.574211] hub 1-0:1.0: usb_probe_interface - got id
[    4.575757] hub 1-0:1.0: USB hub found
[    4.576966] hub 1-0:1.0: 1 port detected
[    4.578161] hub 1-0:1.0: standalone hub
[    4.579313] hub 1-0:1.0: individual port power switching
[    4.580702] hub 1-0:1.0: global over-current protection
[    4.582153] hub 1-0:1.0: Single TT
[    4.583190] hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
[    4.585022] hub 1-0:1.0: power on to power good time: 0ms
[    4.586452] hub 1-0:1.0: local power source is good
[    4.587366] hub 1-0:1.0: no over-current condition exists
[    4.588390] device: 'port1': device_add
[    4.589170] PM: Adding info for No Bus:port1
[    4.589976] hub 1-0:1.0: enabling power on all ports
[    4.590935] driver: '1-0:1.0': driver_bound: bound to device 'hub'
[    4.592084] bus: 'usb': really_probe: bound device 1-0:1.0 to driver hub
[    4.593368] device: 'ep_81': device_add
[    4.594100] PM: Adding info for No Bus:ep_81
[    4.594893] driver: 'usb1': driver_bound: bound to device 'usb'
[    4.595995] bus: 'usb': really_probe: bound device usb1 to driver usb
[    4.597205] device: 'ep_00': device_add
[    4.597927] PM: Adding info for No Bus:ep_00
[    4.598759] driver: 'dummy_hcd.0': driver_bound: bound to device 'dummy_=
hcd'
[    4.600082] bus: 'platform': really_probe: bound device dummy_hcd.0 to d=
river dummy_hcd
[    4.601571] Registering platform device 'dummy_udc.0'. Parent at platform
[    4.602825] device: 'dummy_udc.0': device_add
[    4.603648] bus: 'platform': add device dummy_udc.0
[    4.604563] PM: Adding info for platform:dummy_udc.0
[    4.605548] bus: 'platform': driver_probe_device: matched device dummy_u=
dc.0 with driver dummy_udc
[    4.607189] bus: 'platform': really_probe: probing driver dummy_udc with=
 device dummy_udc.0
[    4.608773] device: 'gadget': device_add
[    4.609527] PM: Adding info for No Bus:gadget
[    4.610391] device: 'dummy_udc.0': device_add
[    4.611230] PM: Adding info for No Bus:dummy_udc.0
[    4.612180] driver: 'dummy_udc.0': driver_bound: bound to device 'dummy_=
udc'
[    4.613494] bus: 'platform': really_probe: bound device dummy_udc.0 to d=
river dummy_udc
[    4.614977] bus: 'pci': add driver net2272
[    4.615788] bus: 'platform': add driver net2272
[    4.616665] bus: 'platform': add driver m66592_udc
[    4.617584] bus: 'platform': remove driver m66592_udc
[    4.618558] driver: 'm66592_udc': driver_release
[    4.619430] bus: 'platform': add driver mv-udc
[    4.620284] udc dummy_udc.0: registering UDC driver [g_cdc]
[    4.621379]  gadget: using random self ethernet address
[    4.622360]  gadget: using random host ethernet address
[    4.623357] device: 'usb0': device_add
[    4.624084] PM: Adding info for No Bus:usb0
[    4.624924] usb0: MAC 1a:5e:8c:5b:c4:d4
[    4.625655] usb0: HOST MAC da:6c:61:74:5d:c0
[    4.626504] ------------[ cut here ]------------
[    4.627366] WARNING: at /c/kernel-tests/src/linux/kernel/mutex.c:198 __m=
utex_lock_common+0xcf/0x357()
[    4.627446] Pid: 1, comm: swapper Not tainted 3.8.0-rc5-00646-g2f520a0 #4
[    4.627446] Call Trace:
[    4.627446]  [<c1028524>] warn_slowpath_common+0x54/0x69
[    4.627446]  [<c147be9a>] ? __mutex_lock_common+0xcf/0x357
[    4.627446]  [<c147be9a>] ? __mutex_lock_common+0xcf/0x357
[    4.627446]  [<c10285d7>] warn_slowpath_null+0x1d/0x22
[    4.627446]  [<c147be9a>] __mutex_lock_common+0xcf/0x357
[    4.627446]  [<c123b588>] ? gserial_alloc_line+0x21/0x18d
[    4.627446]  [<c10391c0>] ? schedule_delayed_work+0x11/0x13
[    4.627446]  [<c13b7c82>] ? linkwatch_schedule_work+0x62/0x65
[    4.627446]  [<c147c15b>] mutex_lock_nested+0x39/0x3f
[    4.627446]  [<c123b588>] ? gserial_alloc_line+0x21/0x18d
[    4.627446]  [<c123b588>] gserial_alloc_line+0x21/0x18d
[    4.627446]  [<c18ffb7c>] cdc_bind+0x2b/0xf2
[    4.627446]  [<c122d9ca>] ? composite_dev_prepare+0x8e/0xc0
[    4.627446]  [<c122db66>] composite_bind+0x82/0x16a
[    4.627446]  [<c18fface>] ? udc_driver_init+0xf/0xf
[    4.627446]  [<c18fface>] ? udc_driver_init+0xf/0xf
[    4.627446]  [<c122b6c4>] udc_bind_to_driver+0x47/0xb2
[    4.627446]  [<c18fface>] ? udc_driver_init+0xf/0xf
[    4.627446]  [<c122bc07>] usb_gadget_probe_driver+0x65/0x7e
[    4.627446]  [<c122dcbb>] usb_composite_probe+0x6d/0x78
[    4.627446]  [<c18ffadb>] init+0xd/0xf
[    4.627446]  [<c18dd9ba>] do_one_initcall+0x7e/0x12e
[    4.627446]  [<c18ddb3e>] kernel_init_freeable+0xd4/0x16e
[    4.627446]  [<c18dd435>] ? do_early_param+0x7a/0x7a
[    4.627446]  [<c14737fb>] kernel_init+0xb/0xbe
[    4.627446]  [<c147e8b7>] ret_from_kernel_thread+0x1b/0x28
[    4.627446]  [<c14737f0>] ? rest_init+0x11c/0x11c
[    4.627446] ---[ end trace 8ef03ce626e1a2a9 ]---
[    4.627446] BUG: unable to handle kernel NULL pointer dereference at   (=
null)
[    4.627446] IP: [<c111d736>] __list_add+0x3e/0xae
[    4.627446] *pde =3D 00000000=20
[    4.627446] Oops: 0000 [#1] PREEMPT=20
[    4.627446] Pid: 1, comm: swapper Tainted: G        W    3.8.0-rc5-00646=
-g2f520a0 #4 =20
[    4.627446] EIP: 0060:[<c111d736>] EFLAGS: 00010046 CPU: 0
[    4.627446] EIP is at __list_add+0x3e/0xae
[    4.627446] EAX: 00000000 EBX: 00000000 ECX: c1f4535c EDX: 00000000
[    4.627446] ESI: c1f4535c EDI: c002be4c EBP: c002be20 ESP: c002bdfc
[    4.627446]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    4.627446] CR0: 8005003b CR2: 00000000 CR3: 0193a000 CR4: 000006d0
[    4.627446] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    4.627446] DR6: ffff0ff0 DR7: 00000400
[    4.627446] Process swapper (pid: 1, ti=3Dc002a000 task=3Dc0030000 task.=
ti=3Dc002a000)
[    4.627446] Stack:
[    4.627446]  c147be9a c147be9a c1f45330 00000246 c0030000 c002be20 c1f45=
330 00000246
[    4.627446]  c0030000 c002be68 c147bec4 00000000 00000002 00000000 c123b=
588 0000010d
[    4.627446]  00000246 c1f4535c 00000002 c1f45370 c002be4c c002be4c 11111=
111 c002be4c
[    4.627446] Call Trace:
[    4.627446]  [<c147be9a>] ? __mutex_lock_common+0xcf/0x357
[    4.627446]  [<c147be9a>] ? __mutex_lock_common+0xcf/0x357
[    4.627446]  [<c147bec4>] __mutex_lock_common+0xf9/0x357
[    4.627446]  [<c123b588>] ? gserial_alloc_line+0x21/0x18d
[    4.627446]  [<c147c15b>] mutex_lock_nested+0x39/0x3f
[    4.627446]  [<c123b588>] ? gserial_alloc_line+0x21/0x18d
[    4.627446]  [<c123b588>] gserial_alloc_line+0x21/0x18d
[    4.627446]  [<c18ffb7c>] cdc_bind+0x2b/0xf2
[    4.627446]  [<c122d9ca>] ? composite_dev_prepare+0x8e/0xc0
[    4.627446]  [<c122db66>] composite_bind+0x82/0x16a
[    4.627446]  [<c18fface>] ? udc_driver_init+0xf/0xf
[    4.627446]  [<c18fface>] ? udc_driver_init+0xf/0xf
[    4.627446]  [<c122b6c4>] udc_bind_to_driver+0x47/0xb2
[    4.627446]  [<c18fface>] ? udc_driver_init+0xf/0xf
[    4.627446]  [<c122bc07>] usb_gadget_probe_driver+0x65/0x7e
[    4.627446]  [<c122dcbb>] usb_composite_probe+0x6d/0x78
[    4.627446]  [<c18ffadb>] init+0xd/0xf
[    4.627446]  [<c18dd9ba>] do_one_initcall+0x7e/0x12e
[    4.627446]  [<c18ddb3e>] kernel_init_freeable+0xd4/0x16e
[    4.627446]  [<c18dd435>] ? do_early_param+0x7a/0x7a
[    4.627446]  [<c14737fb>] kernel_init+0xb/0xbe
[    4.627446]  [<c147e8b7>] ret_from_kernel_thread+0x1b/0x28
[    4.627446]  [<c14737f0>] ? rest_init+0x11c/0x11c
[    4.627446] Code: d0 74 28 89 4c 24 14 89 44 24 10 89 54 24 0c c7 44 24 =
08 33 c3 69 c1 c7 44 24 04 1d 00 00 00 c7 04 24 80 c3 69 c1 e8 25 ae f0 ff =
<8b> 03 39 f0 74 28 89 5c 24 14 89 44 24 10 89 74 24 0c c7 44 24
[    4.627446] EIP: [<c111d736>] __list_add+0x3e/0xae SS:ESP 0068:c002bdfc
[    4.627446] CR2: 0000000000000000
[    4.627446] ---[ end trace 8ef03ce626e1a2aa ]---
[    4.627446] Kernel panic - not syncing: Fatal exception
[    4.627446] Rebooting in 10 seconds..
--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2f520a0-bisect.log"

git checkout cf5425bfcd6909f9831a00bc06ccb9a5b163766a
Previous HEAD position was 2f520a0... Merge branch 'rtd3-usb' of .git into rtd3-all
HEAD is now at cf5425b... Merge branch 'for-3.8/upstream-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid

2013-02-05-16:00:07 cf5425bfcd6909f9831a00bc06ccb9a5b163766a compiling
/home/wfg/linux

2013-02-05-16:01:37 detecting boot state 3.8.0-rc5-bisect-00274-gcf5425b #69 	4............	8................	14............	15 SUCCESS
bisect: good commit cf5425bfcd6909f9831a00bc06ccb9a5b163766a
git bisect start 2f520a0e87bbe47bf0909ce5700dd72b258991d2 cf5425bfcd6909f9831a00bc06ccb9a5b163766a --
Previous HEAD position was cf5425b... Merge branch 'for-3.8/upstream-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid
HEAD is now at 1e51120... userns: Convert 9p's uid/gid handling
Bisecting: 170 revisions left to test after this (roughly 8 steps)
[e38235d67a4282f7df386d2fca77cfa56713e442] Merge branch 'sdio_acpi' into for-zhangrui
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-05-16:24:32 e38235d67a4282f7df386d2fca77cfa56713e442 compiling
/home/wfg/linux

2013-02-05-16:26:13 detecting boot state 3.8.0-rc5-bisect-00394-ge38235d #70 ...........	6.............	10...............	15	16............ SUCCESS
Bisecting: 90 revisions left to test after this (roughly 7 steps)
[a9b8676c17cee40ac78696bb56ab61d550382898] Merge tag 'dwc3-for-v3.9' of git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb into usb-next
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-05-16:54:16 a9b8676c17cee40ac78696bb56ab61d550382898 compiling
/home/wfg/linux

2013-02-05-16:56:29 detecting boot state 3.8.0-rc4-bisect-00056-ga9b8676 #71 ...........	6.............	10...............	15	16............ SUCCESS
Bisecting: 45 revisions left to test after this (roughly 6 steps)
[6166c24669678662547bb4e5dbd6a810268b8b7b] usb: gadget: pxa25x_udc: convert to udc_start/udc_stop
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-05-17:24:32 6166c24669678662547bb4e5dbd6a810268b8b7b compiling
/home/wfg/linux

2013-02-05-17:26:09 detecting boot state 3.8.0-rc3-bisect-00045-g6166c24 #72 ............	5 TEST FAILURE
Bisecting: 22 revisions left to test after this (roughly 5 steps)
[3249ca22c088c286d6227d8fae9c85a43a8ce9f6] usb: gadget: u_serial: convert into a module
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-05-17:33:10 3249ca22c088c286d6227d8fae9c85a43a8ce9f6 compiling
/home/wfg/linux

2013-02-05-17:34:03 detecting boot state 3.8.0-rc3-bisect-00022-g3249ca2 #73 	2.........	5..................	6	11.........	14................... SUCCESS
Bisecting: 11 revisions left to test after this (roughly 4 steps)
[9bb2859f8a8dbc9b42f3100641dd0ae80cfbe86a] usb: gadget: composite: introduce usb_gstrings_attach()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-05-18:04:35 9bb2859f8a8dbc9b42f3100641dd0ae80cfbe86a compiling
/home/wfg/linux

2013-02-05-18:05:31 detecting boot state 3.8.0-rc3-bisect-00033-g9bb2859 #74 ........ TEST FAILURE
Bisecting: 5 revisions left to test after this (roughly 3 steps)
[29a6645f7c0a7f1ff09d45e820f0433bd5a5610f] usb: gadget: cdc2: use function framework for ACM
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-05-18:10:02 29a6645f7c0a7f1ff09d45e820f0433bd5a5610f compiling
/home/wfg/linux

2013-02-05-18:10:55 detecting boot state 3.8.0-rc3-bisect-00027-g29a6645 #75 	3 TEST FAILURE
Bisecting: 2 revisions left to test after this (roughly 1 step)
[19b10a8828a6cdd5a4e7e37babd5084d35641f87] usb: gadget: allocate & giveback serial ports instead hard code them
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-05-18:11:56 19b10a8828a6cdd5a4e7e37babd5084d35641f87 compiling
/home/wfg/linux

2013-02-05-18:12:49 detecting boot state 3.8.0-rc3-bisect-00024-g19b10a8 #76 	3 TEST FAILURE
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[b473577854fea63055ff9ab84f0f52a3e8aed15e] usb: gadget: composite: add usb_remove_function()
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-i386

2013-02-05-18:13:50 b473577854fea63055ff9ab84f0f52a3e8aed15e compiling
/home/wfg/linux

2013-02-05-18:14:42 detecting boot state 3.8.0-rc3-bisect-00023-gb473577 #77 	2........	8....................	10	11.......	15	17................... SUCCESS
19b10a8828a6cdd5a4e7e37babd5084d35641f87 is the first bad commit
commit 19b10a8828a6cdd5a4e7e37babd5084d35641f87
Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date:   Sun Dec 23 21:10:06 2012 +0100

    usb: gadget: allocate & giveback serial ports instead hard code them
    
    This patch removes gserial_setup() and gserial_cleanup() and adds
    gserial_alloc_line() and gserial_free_line() to replace them.
    
    The initial setup of u_serial happens now on module load time. A
    maximum of four TTY ports can be requested which is the current limit.
    In theory we could extend this limit, the hard limit is the number of
    available endpoints.
    alloc_tty_driver() is now called at module init time with the max
    available ports. The per-line footprint here is on 32bit is 3 * size of
    pointer + 60 bytes (for cdevs).
    The remaining memory (struct gs_port) is allocated once a port is
    requested.
    
    With this change it is possible to load g_multi and g_serial at the same
    time. GS0 receives the module that is loaded first, GS1 is received by
    the next module and so on. With the configfs interface the port number
    can be exported and the device node is more predictable. Nothing changes
    for g_serial and friends as long as one module is used.
    
    Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

:040000 040000 e13e9e2f9c563368130631e8212aee37f8013acf 2c8991cf1d891b2910e77bb12d55d48cf93b1626 M	drivers
bisect run success

2013-02-05-18:45:14 b473577854fea63055ff9ab84f0f52a3e8aed15e compiling
/home/wfg/linux

2013-02-05-18:45:37 detecting boot state 3.8.0-rc3-bisect-00023-gb473577 #77 ........	6...................	7	9........	14	15...................	16	18.......	22	24...................	25	27.......	28 SUCCESS

========= linux-next =========

2013-02-05-19:35:45 1587f71ebbf5aedf754062baa11fcc9e9b49ecf0 compiling
/home/wfg/linux

2013-02-05-19:36:46 detecting boot state 3.8.0-rc4-bisect-next-20130125 #77 .................	1	3........	9...................	10	12........	17	18...................	19	21.......	25	27...................	28 SUCCESS

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.8.0-rc5 Kernel Configuration
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
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
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
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
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
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SYSVIPC is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
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
CONFIG_NO_HZ=y
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_HAVE_UID16=y
# CONFIG_UID16 is not set
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
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
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_GENERIC_SIGALTSTACK=y
CONFIG_CLONE_BACKWARDS=y

#
# GCOV-based kernel profiling
#
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
# CONFIG_BLOCK is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
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
CONFIG_X86_PPRO_FENCE=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_CPU_SUP_TRANSMETA_32=y
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_THERMAL is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
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
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_SCx200 is not set
CONFIG_OLPC=y
CONFIG_OLPC_XO1_PM=y
CONFIG_OLPC_XO1_RTC=y
CONFIG_OLPC_XO1_SCI=y
CONFIG_OLPC_XO15_SCI=y
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
# CONFIG_PCCARD is not set
CONFIG_RAPIDIO=y
# CONFIG_RAPIDIO_TSI721 is not set
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_RAPIDIO_TSI500 is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_DIAG is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
# CONFIG_IP_PIMSM_V2 is not set
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_PHONET is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
# CONFIG_NETPRIO_CGROUP is not set

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
# CONFIG_CAN_GW is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=y
# CONFIG_CAN_DEV is not set
CONFIG_CAN_DEBUG_DEVICES=y
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_NFC=y
# CONFIG_NFC_NCI is not set
# CONFIG_NFC_HCI is not set
# CONFIG_NFC_LLCP is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
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
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
CONFIG_INTEL_MID_PTI=y
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_PCH_PHUB=y
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y

#
# Altera FPGA firmware download module
#
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
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_NET=y
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_STMPE=y
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_ARIZONA_HAPTICS is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_POWERMATE=y
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_SPI=y
CONFIG_INPUT_CMA3000=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
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
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
CONFIG_SERIAL_XILINX_PS_UART=y
# CONFIG_SERIAL_XILINX_PS_UART_CONSOLE is not set
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_TTY_PRINTK is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_GEODE=y
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
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
CONFIG_PPS_DEBUG=y

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
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_TS5500=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_WM831X=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=y
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#
# CONFIG_GPIO_UCB1400 is not set

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_WM831X_BACKUP is not set
CONFIG_WM831X_POWER=y
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_OLPC is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_CHARGER_ISP1704 is not set
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_AD7314 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_FAIR_SHARE is not set
# CONFIG_STEP_WISE is not set
CONFIG_USER_SPACE=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_SILENT=y
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
# CONFIG_BCMA_DRIVER_GPIO is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_SM501 is not set
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_UCB1400_CORE=y
# CONFIG_MFD_TPS65912_SPI is not set
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
# CONFIG_STMPE_SPI is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_ABX500_CORE=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_CS5535=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_VX855=y
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
# CONFIG_REGULATOR_DUMMY is not set
# CONFIG_REGULATOR_FIXED_VOLTAGE is not set
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_ARIZONA is not set
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_WM831X=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_DVB_CORE=y
# CONFIG_DVB_NET is not set
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Analog TV USB devices
#
# CONFIG_VIDEO_HDPVR is not set

#
# Analog/digital TV USB devices
#

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture/analog TV support
#

#
# Media capture/analog/hybrid TV support
#

#
# Media digital TV PCI Adapters
#

#
# Supported MMC/SDIO adapters
#

#
# Supported FireWire (IEEE 1394) Adapters
#
# CONFIG_DVB_FIREDTV is not set
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#

#
# Video and audio decoders
#

#
# MPEG video encoders
#

#
# Video encoders
#

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#

#
# Miscelaneous helper chips
#

#
# Sensors used on soc_camera driver
#

#
# Multistandard (satellite) frontends
#

#
# Multistandard (cable + terrestrial) frontends
#

#
# DVB-S (satellite) frontends
#

#
# DVB-T (terrestrial) frontends
#

#
# DVB-C (cable) frontends
#

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#

#
# ISDB-T (terrestrial) frontends
#

#
# Digital terrestrial only tuners/PLL
#

#
# SEC control devices for DVB-S
#

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
# CONFIG_DRM is not set
CONFIG_STUB_POULSBO=y
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_APPLE=y
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_KCTL_JACK=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_OPL3_LIB_SEQ=y
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
CONFIG_SND_ALS300=y
CONFIG_SND_ALS4000=y
# CONFIG_SND_ALI5451 is not set
CONFIG_SND_ASIHPI=y
CONFIG_SND_ATIIXP=y
CONFIG_SND_ATIIXP_MODEM=y
# CONFIG_SND_AU8810 is not set
CONFIG_SND_AU8820=y
# CONFIG_SND_AU8830 is not set
CONFIG_SND_AW2=y
CONFIG_SND_AZT3328=y
CONFIG_SND_BT87X=y
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=y
CONFIG_SND_CMIPCI=y
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
CONFIG_SND_CS5530=y
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
CONFIG_SND_LAYLA24=y
CONFIG_SND_MONA=y
CONFIG_SND_MIA=y
CONFIG_SND_ECHO3G=y
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
CONFIG_SND_INDIGODJ=y
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_PREALLOC_SIZE=64
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
# CONFIG_SND_HDA_CODEC_REALTEK is not set
# CONFIG_SND_HDA_CODEC_ANALOG is not set
# CONFIG_SND_HDA_CODEC_SIGMATEL is not set
CONFIG_SND_HDA_CODEC_VIA=y
# CONFIG_SND_HDA_CODEC_HDMI is not set
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
# CONFIG_SND_HDA_CODEC_CA0110 is not set
# CONFIG_SND_HDA_CODEC_CA0132 is not set
# CONFIG_SND_HDA_CODEC_CMEDIA is not set
CONFIG_SND_HDA_CODEC_SI3054=y
# CONFIG_SND_HDA_GENERIC is not set
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# CONFIG_SND_HDSP is not set
CONFIG_SND_HDSPM=y
# CONFIG_SND_ICE1712 is not set
CONFIG_SND_ICE1724=y
CONFIG_SND_INTEL8X0=y
CONFIG_SND_INTEL8X0M=y
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LOLA is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
CONFIG_SND_MIXART=y
CONFIG_SND_NM256=y
CONFIG_SND_PCXHR=y
CONFIG_SND_RIPTIDE=y
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
CONFIG_SND_SONICVIBES=y
CONFIG_SND_TRIDENT=y
CONFIG_SND_VIA82XX=y
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
CONFIG_SND_VX222=y
CONFIG_SND_YMFPCI=y
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_USB_6FIRE is not set
# CONFIG_SND_FIREWIRE is not set
CONFIG_SND_SOC=y
CONFIG_SND_SOC_I2C_AND_SPI=y
CONFIG_SND_SOC_ALL_CODECS=y
CONFIG_SND_SOC_ARIZONA=y
CONFIG_SND_SOC_WM_ADSP=y
CONFIG_SND_SOC_AB8500_CODEC=y
CONFIG_SND_SOC_AD1836=y
CONFIG_SND_SOC_AD193X=y
CONFIG_SND_SOC_AD73311=y
CONFIG_SND_SOC_ADAV80X=y
CONFIG_SND_SOC_ADS117X=y
CONFIG_SND_SOC_AK4104=y
CONFIG_SND_SOC_CS4271=y
CONFIG_SND_SOC_CX20442=y
CONFIG_SND_SOC_JZ4740_CODEC=y
CONFIG_SND_SOC_L3=y
CONFIG_SND_SOC_DFBMCS320=y
CONFIG_SND_SOC_PCM3008=y
CONFIG_SND_SOC_SPDIF=y
CONFIG_SND_SOC_SSM2602=y
CONFIG_SND_SOC_TLV320AIC26=y
CONFIG_SND_SOC_UDA134X=y
CONFIG_SND_SOC_WM0010=y
CONFIG_SND_SOC_WM5102=y
CONFIG_SND_SOC_WM8510=y
CONFIG_SND_SOC_WM8711=y
CONFIG_SND_SOC_WM8727=y
CONFIG_SND_SOC_WM8728=y
CONFIG_SND_SOC_WM8731=y
CONFIG_SND_SOC_WM8737=y
CONFIG_SND_SOC_WM8741=y
CONFIG_SND_SOC_WM8750=y
CONFIG_SND_SOC_WM8753=y
CONFIG_SND_SOC_WM8770=y
CONFIG_SND_SOC_WM8776=y
CONFIG_SND_SOC_WM8782=y
CONFIG_SND_SOC_WM8804=y
CONFIG_SND_SOC_WM8983=y
CONFIG_SND_SOC_WM8985=y
CONFIG_SND_SOC_WM8988=y
CONFIG_SND_SOC_WM8995=y
CONFIG_SND_SOC_MC13783=y
CONFIG_SND_SIMPLE_CARD=y
CONFIG_SOUND_PRIME=y
CONFIG_SOUND_OSS=y
CONFIG_SOUND_TRACEINIT=y
# CONFIG_SOUND_DMAP is not set
# CONFIG_SOUND_VMIDI is not set
CONFIG_SOUND_TRIX=y
# CONFIG_SOUND_MSS is not set
# CONFIG_SOUND_MPU401 is not set
# CONFIG_SOUND_PAS is not set
CONFIG_SOUND_PSS=y
# CONFIG_PSS_MIXER is not set
# CONFIG_SOUND_SB is not set
# CONFIG_SOUND_YM3812 is not set
CONFIG_SOUND_UART6850=y
# CONFIG_SOUND_AEDSP16 is not set
CONFIG_AC97_BUS=y

#
# HID support
#
# CONFIG_HID is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG_WHITELIST=y
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=y
CONFIG_USB_HCD_BCMA=y
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_MUSB_HDRC is not set
CONFIG_USB_CHIPIDEA=y
CONFIG_USB_CHIPIDEA_UDC=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=y
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
# CONFIG_USB_SERIAL_IR is not set
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=y
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
CONFIG_USB_SERIAL_MOS7840=y
# CONFIG_USB_SERIAL_MOTOROLA is not set
CONFIG_USB_SERIAL_NAVMAN=y
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=y
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=y
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=y
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=y
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_ZIO is not set
# CONFIG_USB_SERIAL_ZTE is not set
CONFIG_USB_SERIAL_SSU100=y
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
CONFIG_USB_ADUTUX=y
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
# CONFIG_USB_EZUSB_FX2 is not set

#
# USB Physical Layer drivers
#
# CONFIG_OMAP_USB3 is not set
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_GADGET=y
CONFIG_USB_GADGET_DEBUG=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_FUSB300 is not set
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_MV_UDC=y
CONFIG_USB_M66592=y
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=y
# CONFIG_USB_NET2272_DMA is not set
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
CONFIG_USB_DUMMY_HCD=y
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_F_ACM=y
CONFIG_USB_U_SERIAL=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
CONFIG_USB_CDC_COMPOSITE=y
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
# CONFIG_UWB_I1480U is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_WM831X_STATUS is not set
# CONFIG_LEDS_DAC124S085 is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_DELL_NETBOOKS=y
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
# CONFIG_INFINIBAND_USER_MAD is not set
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
# CONFIG_INFINIBAND_NES is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
# CONFIG_RTC_DRV_M41T94 is not set
CONFIG_RTC_DRV_DS1305=y
CONFIG_RTC_DRV_DS1390=y
# CONFIG_RTC_DRV_MAX6902 is not set
CONFIG_RTC_DRV_R9701=y
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_DS3234 is not set
# CONFIG_RTC_DRV_PCF2123 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_WM831X=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y
# CONFIG_RTC_DRV_SNVS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_TIMB_DMA=y
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set

#
# Virtio drivers
#

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_ACERHDF=y
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_WMI is not set
# CONFIG_DELL_WMI_AIO is not set
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_HP_WMI is not set
CONFIG_PANASONIC_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
# CONFIG_THINKPAD_ACPI_VIDEO is not set
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=y
CONFIG_ACPI_WMI=y
# CONFIG_MSI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=y
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
# CONFIG_MXM_WMI is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_APPLE_GMUX is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
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

#
# Analog to digital converters
#
CONFIG_AD7266=y
# CONFIG_AD7298 is not set
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
# CONFIG_AD7476 is not set
# CONFIG_AD7887 is not set

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Hid Sensor IIO Common
#

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
CONFIG_AD5380=y
CONFIG_AD5421=y
CONFIG_AD5624R_SPI=y
# CONFIG_AD5446 is not set
CONFIG_AD5449=y
CONFIG_AD5504=y
CONFIG_AD5755=y
CONFIG_AD5764=y
# CONFIG_AD5791 is not set
# CONFIG_AD5686 is not set

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
# CONFIG_ADF4350 is not set

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16136 is not set

#
# Inertial measurement units
#
# CONFIG_ADIS16480 is not set

#
# Light sensors
#

#
# Magnetometer sensors
#
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
# CONFIG_SYSFS is not set
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_PSTORE is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG=y
CONFIG_CIFS_DEBUG2=y
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
# CONFIG_NCPFS_NLS is not set
CONFIG_NCPFS_EXTRAS=y
# CONFIG_CODA_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
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
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_WORK=y
# CONFIG_DEBUG_OBJECTS_RCU_HEAD is not set
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_PROVE_RCU_DELAY=y
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
# CONFIG_DEBUG_BUGVERBOSE is not set
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
CONFIG_FAILSLAB=y
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
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
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
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
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y

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
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_GEODE=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
# CONFIG_CRYPTO_DEV_HIFN_795X_RNG is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
CONFIG_CRC32_SARWATE=y
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
# CONFIG_XZ_DEC_X86 is not set
# CONFIG_XZ_DEC_POWERPC is not set
CONFIG_XZ_DEC_IA64=y
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=y
CONFIG_DDR=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ATA_SFF is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set

--ZGiS0Q5IWpPtfppv--
