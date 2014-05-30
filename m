Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaE3E31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 00:29:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:38087 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbaE3E3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 00:29:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,938,1392192000"; 
   d="log'?scan'208";a="539851928"
Message-ID: <538808FD.3060707@intel.com>
Date: Fri, 30 May 2014 12:28:45 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Fengguang Wu <fengguang.wu@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [prink]  BUG: spinlock lockup suspected on CPU#0, swapper/1
Content-Type: multipart/mixed;
 boundary="------------040306070508090709090006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040306070508090709090006
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Jan,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0
Author:     Jan Kara <jack@suse.cz>
AuthorDate: Thu May 22 10:43:35 2014 +1000
Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
CommitDate: Thu May 22 10:43:35 2014 +1000

    printk: enable interrupts before calling console_trylock_for_printk()
        We need interrupts disabled when calling console_trylock_for_printk() only
    so that cpu id we pass to can_use_console() remains valid (for other
    things console_sem provides all the exclusion we need and deadlocks on
    console_sem due to interrupts are impossible because we use
    down_trylock()).  However if we are rescheduled, we are guaranteed to run
    on an online cpu so we can easily just get the cpu id in
    can_use_console().
        We can lose a bit of performance when we enable interrupts in
    vprintk_emit() and then disable them again in console_unlock() but OTOH it
    can somewhat reduce interrupt latency caused by console_unlock()
    especially since later in the patch series we will want to spin on
    console_sem in console_trylock_for_printk().
        Signed-off-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

+----------------------------------------------------+------------+------------+
|                                                    | ee75ecbd8b | bafe980f5a |
+----------------------------------------------------+------------+------------+
| boot_successes                                     | 60         | 0          |
| boot_failures                                      | 0          | 20         |
| BUG:spinlock_lockup_suspected_on_CPU               | 0          | 20         |
| INFO:possible_circular_locking_dependency_detected | 0          | 20         |
| backtrace:do_sys_open                              | 0          | 20         |
| backtrace:SyS_open                                 | 0          | 20         |
| backtrace:kernel_init_freeable                     | 0          | 20         |
| backtrace:print_ICs                                | 0          | 20         |
| backtrace:setup_default_timer_irq                  | 0          | 20         |
| backtrace:hpet_time_init                           | 0          | 20         |
| backtrace:x86_late_time_init                       | 0          | 20         |
+----------------------------------------------------+------------+------------+


[    7.490555] EDD information not available.
[    7.490999] ### dt-test ### No testcase data in device tree; not running tests
[    7.491848] [    7.492350] BUG: spinlock lockup suspected on CPU#0, swapper/1
[    7.492350]  lock: serial8250_ports+0x0/0x4c0, .magic: dead4ead, .owner: swapper/1, .owner_cpu: 0
[    7.492350] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc5-00567-gbafe980 #1
[    7.492350]  80038000 80038000 80027a8c 81b9bd30 80027ab4 81b968d0 81eb5198 82755f80
[    7.492350]  dead4ead 80038340 00000001 00000000 82755f80 a08b8bfc 80027ad0 81077777
[    7.492350]  a08b8bfc 00000000 82755f80 00000086 00000001 80027af0 81baeda4 00000000
[    7.492350] Call Trace:
[    7.492350]  [<81b9bd30>] dump_stack+0x16/0x18
[    7.492350]  [<81b968d0>] spin_dump+0x90/0x97
[    7.492350]  [<81077777>] do_raw_spin_lock+0xa7/0xf0
[    7.492350]  [<81baeda4>] _raw_spin_lock_irqsave+0x54/0x60
[    7.492350]  [<815f652c>] ? serial8250_console_write+0x11c/0x140
[    7.492350]  [<815f6410>] ? serial8250_modem_status+0xc0/0xc0
[    7.492350]  [<815f652c>] serial8250_console_write+0x11c/0x140
[    7.492350]  [<815f6410>] ? serial8250_modem_status+0xc0/0xc0
[    7.492350]  [<8107b534>] call_console_drivers.constprop.20+0x64/0x130
[    7.492350]  [<8107bcb5>] console_unlock+0x445/0x4d0
[    7.492350]  [<8107be98>] vprintk_emit+0x158/0x4d0
[    7.492350]  [<81b969b9>] printk+0x38/0x3a
[    7.492350]  [<81b95fd0>] print_circular_bug_header+0x35/0xc1
[    7.492350]  [<81b960c6>] print_circular_bug+0x6a/0x268
[    7.492350]  [<810743c2>] __lock_acquire+0x19c2/0x1b20
[    7.492350]  [<81070d18>] ? check_irq_usage+0x88/0xc0
[    7.492350]  [<810750e5>] lock_acquire+0x85/0x190
[    7.492350]  [<8107dc8c>] ? __irq_get_desc_lock+0x3c/0x70
[    7.492350]  [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
[    7.492350]  [<8107dc8c>] ? __irq_get_desc_lock+0x3c/0x70
[    7.492350]  [<8107dc8c>] __irq_get_desc_lock+0x3c/0x70
[    7.492350]  [<8107eb1e>] __disable_irq_nosync+0x1e/0x50
[    7.492350]  [<8107eb58>] disable_irq_nosync+0x8/0x10
[    7.492350]  [<815f5c78>] serial8250_startup+0x488/0x720
[    7.492350]  [<810de6d0>] ? __get_free_pages+0x20/0x40
[    7.492350]  [<815f205e>] uart_startup.part.4+0x6e/0x1e0
[    7.492350]  [<815f2a40>] uart_open+0xe0/0x140
[    7.492350]  [<815f2960>] ? uart_ioctl+0x2f0/0x2f0
[    7.492350]  [<815e4b51>] tty_open+0x141/0x510
[    7.492350]  [<815e4a10>] ? tty_ioctl+0xb20/0xb20
[    7.492350]  [<81118bc0>] chrdev_open+0x60/0x140
[    7.492350]  [<8111372c>] do_dentry_open+0x14c/0x230
[    7.492350]  [<81118b60>] ? exact_lock+0x20/0x20
[    7.492350]  [<8111459e>] finish_open+0x2e/0x40
[    7.492350]  [<8112132a>] do_last+0x4aa/0xd30
[    7.492350]  [<8111f4fd>] ? link_path_walk+0x1dd/0x700
[    7.492350]  [<81121c5a>] path_openat+0xaa/0x610
[    7.492350]  [<811221ec>] do_filp_open+0x2c/0x70
[    7.492350]  [<81114a81>] do_sys_open+0x111/0x210
[    7.492350]  [<81600000>] ? _xfer_secondary_pool+0x150/0x230
[    7.492350]  [<81114b9d>] SyS_open+0x1d/0x20
[    7.492350]  [<8212bda4>] kernel_init_freeable+0x1c6/0x236
[    7.492350]  [<8212b4f2>] ? do_early_param+0x78/0x78
[    7.492350]  [<81b9238b>] kernel_init+0xb/0xd0
[    7.492350]  [<81063b12>] ? schedule_tail+0x12/0x40
[    7.492350]  [<81bb0080>] ret_from_kernel_thread+0x20/0x30
[    7.492350]  [<81b92380>] ? rest_init+0x130/0x130
[    7.492350] ======================================================

git bisect start 07dd999f99b1135fdece697e17c4f4248ab40f72 53a4fdb4a7c8aeef977f8450bcdb92d1962e321e --
git bisect  bad 54af61db1031c7ddef016987e9938cbbbaf92968  # 09:12      0-     18  Merge branch 'akpm-current/current'
git bisect good d93e8dbb6c2cd2fde8d46e1ad12d19ffa1868747  # 09:19     20+      0  mm: page_alloc: use unsigned int for order in more places
git bisect  bad 7ff60469e63f2bd110582cdf8ba95afa694bf7c6  # 09:24      0-      4  rtc: rtc-mv: make of_device_id array const
git bisect  bad 3c3ad385a174d5d2490b2f9c6513b588dc8a1ddb  # 09:27      0-     19  printk: disable preemption for printk_sched
git bisect good 456407d6fec5f28c1be67fcf803f9cca14b75142  # 09:31     20+      0  do_shared_fault(): check that mmap_sem is held
git bisect good e94a01e20b75345d1486e7d0bdf03313f8f47d0b  # 09:36     20+      0  kernel/utsname_sysctl.c: replace obsolete __initcall by device_initcall
git bisect good 6f83a1a8d7e0a9e71f3ee1641a965aede0ee4c6c  # 09:49     20+      0  printk: shrink too long messages
git bisect good 3bd16050e9c555cb7b08a4f830db95e9025336e6  # 09:54     20+      0  printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix
git bisect  bad bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0  # 10:00      0-      4  printk: enable interrupts before calling console_trylock_for_printk()
git bisect good ee75ecbd8b9ad26cd0094573cd4b612ab20b3e71  # 10:10     20+      0  printk: fix lockdep instrumentation of console_sem
# first bad commit: [bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0] printk: enable interrupts before calling console_trylock_for_printk()
git bisect good ee75ecbd8b9ad26cd0094573cd4b612ab20b3e71  # 10:13     60+      0  printk: fix lockdep instrumentation of console_sem
git bisect  bad 07dd999f99b1135fdece697e17c4f4248ab40f72  # 10:13      0-     13  Add linux-next specific files for 20140529
git bisect good a991639c26c7231ddb6de7f34899fb70832b7d04  # 10:18     60+      0  Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux
git bisect  bad 07dd999f99b1135fdece697e17c4f4248ab40f72  # 10:18      0-     13  Add linux-next specific files for 20140529


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm 	-kernel $kernel
	-initrd $initrd
	-smp 2
	-m 256M
	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
	-net user,vlan=0
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-serial stdio
	-display none
	-monitor null
)

append=(
	debug
	sched_debug
	apic=debug
	ignore_loglevel
	sysrq_always_enabled
	panic=10
	prompt_ramdisk=0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
)

"${kvm[@]}" --append "${append[*]}"
-----------------------------------------------------------------------------

Thanks,
Jet


--------------040306070508090709090006
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-yocto-ivb42-1:20140530095845:i386-randconfig-ib0-05300841:3.15.0-rc5-00567-gbafe980:1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="dmesg-yocto-ivb42-1:20140530095845:i386-randconfig-ib0-05300";
 filename*1="841:3.15.0-rc5-00567-gbafe980:1"

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... No relocation needed... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.15.0-rc5-00567-gbafe980 (kbuild@lkp-ib03) =
(gcc version 4.8.2 (Debian 4.8.2-18) ) #1 Fri May 30 09:58:14 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] res=
erved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled:=
 non-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
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
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
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
[    0.000000] BRK [0x02782000, 0x02782fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001=
 BXPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001=
 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001=
 INTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001=
 BXPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001=
 BXPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001=
 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] BRK [0x02783000, 0x02783fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 8210fca0, node_mem_map =
93a3d020
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor=
 1/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, API=
C INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, API=
C INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, API=
C INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, API=
C INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, API=
C INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, API=
C INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, API=
C INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, API=
C INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, API=
C INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, API=
C INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, API=
C INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, API=
C INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, API=
C INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, API=
C INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, API=
C INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2018040
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ib0-05300=
841/next:master:bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0:bisect-linux2/.v=
mlinuz-bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0-20140530095827-2-ivb42 br=
anch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-ib0-05300841/bafe=
980f5afc7ccc693fd8c81c8aa5a02fbb5ae0/vmlinuz-3.15.0-rc5-00567-gbafe980 dr=
bd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 by=
tes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 296816K/327280K available (11971K kernel code, 120=
0K rwdata, 4396K rodata, 736K init, 5712K bss, 30464K reserved, 0K highme=
m)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xff7fe000   (1712 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x8212b000 - 0x821e3000   ( 736 kB)
[    0.000000]       .data : 0x81bb0ff1 - 0x82129280   (5600 kB)
[    0.000000]       .text : 0x81000000 - 0x81bb0ff1   (11971 kB)
[    0.000000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1=
, Nodes=3D1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3D80092000 soft=3D80094000
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.15.0-rc5-00567-gbafe980 (kbuild@lkp-ib03) =
(gcc version 4.8.2 (Debian 4.8.2-18) ) #1 Fri May 30 09:58:14 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013ffdfff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x0000000013ffe000-0x0000000013ffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] res=
erved
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled:=
 non-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x100000
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
[    0.000000] initial memory mapped: [mem 0x00000000-0x02bfffff]
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
[    0.000000] BRK [0x02782000, 0x02782fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD950 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FFE450 000034 (v01 BOCHS  BXPCRSDT 00000001=
 BXPC 00000001)
[    0.000000] ACPI: FACP 0x13FFFF80 000074 (v01 BOCHS  BXPCFACP 00000001=
 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x13FFE490 0011A9 (v01 BXPC   BXDSDT   00000001=
 INTL 20100528)
[    0.000000] ACPI: FACS 0x13FFFF40 000040
[    0.000000] ACPI: SSDT 0x13FFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001=
 BXPC 00000001)
[    0.000000] ACPI: APIC 0x13FFF680 000080 (v01 BOCHS  BXPCAPIC 00000001=
 BXPC 00000001)
[    0.000000] ACPI: HPET 0x13FFF640 000038 (v01 BOCHS  BXPCHPET 00000001=
 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] BRK [0x02783000, 0x02783fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00001000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000] free_area_init_node: node 0, pgdat 8210fca0, node_mem_map =
93a3d020
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 81820 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffc000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor=
 1/0x1 ignored.
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI =
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, API=
C INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, API=
C INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level=
)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, API=
C INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, API=
C INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high lev=
el)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, API=
C INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, API=
C INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, API=
C INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, API=
C INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, API=
C INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, API=
C INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, API=
C INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, API=
C INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, API=
C INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, API=
C INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, API=
C INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] mapped IOAPIC to ffffb000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 2018040
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ib0-05300=
841/next:master:bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0:bisect-linux2/.v=
mlinuz-bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0-20140530095827-2-ivb42 br=
anch=3Dnext/master BOOT_IMAGE=3D/kernel/i386-randconfig-ib0-05300841/bafe=
980f5afc7ccc693fd8c81c8aa5a02fbb5ae0/vmlinuz-3.15.0-rc5-00567-gbafe980 dr=
bd.minor_count=3D8
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 by=
tes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 296816K/327280K available (11971K kernel code, 120=
0K rwdata, 4396K rodata, 736K init, 5712K bss, 30464K reserved, 0K highme=
m)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x947fe000 - 0xff7fe000   (1712 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x93ffe000   ( 319 MB)
[    0.000000]       .init : 0x8212b000 - 0x821e3000   ( 736 kB)
[    0.000000]       .data : 0x81bb0ff1 - 0x82129280   (5600 kB)
[    0.000000]       .text : 0x81000000 - 0x81bb0ff1   (11971 kB)
[    0.000000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D1=
, Nodes=3D1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3D80092000 soft=3D80094000
[    0.000000] console [ttyS0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc=
=2E, Ingo Molnar
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc=
=2E, Ingo Molnar
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
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------=
------------------
[    0.000000] ----------------------------------------------------------=
------------------
[    0.000000]                                  | spin |wlock |rlock |mut=
ex | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mut=
ex | wsem | rsem |
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |          =
   |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |          =
   |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |          =
   |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |          =
   |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  | =
 ok  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  | =
 ok  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/123:
[    0.000000]       hard-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/123:
[    0.000000]       soft-irq read-recursion/123:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/132:
[    0.000000]       hard-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/132:
[    0.000000]       soft-irq read-recursion/132:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/213:
[    0.000000]       hard-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/213:
[    0.000000]       soft-irq read-recursion/213:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/231:
[    0.000000]       hard-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/231:
[    0.000000]       soft-irq read-recursion/231:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/312:
[    0.000000]       hard-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/312:
[    0.000000]       soft-irq read-recursion/312:  ok  |  ok  |

[    0.000000]       hard-irq read-recursion/321:
[    0.000000]       hard-irq read-recursion/321:  ok  |  ok  |

[    0.000000]       soft-irq read-recursion/321:
[    0.000000]       soft-irq read-recursion/321:  ok  |  ok  |

[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]   --------------------------------------------------------=
------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  o=
k  |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  =
|  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.500 MHz processor
[    0.000000] tsc: Detected 2693.500 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value..=20
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.45 Bo=
goMIPS (lpj=3D8978333)
5389.45 BogoMIPS (lpj=3D8978333)
[    0.006666] pid_max: default: 4096 minimum: 301
[    0.006666] pid_max: default: 4096 minimum: 301
[    0.006684] ACPI: Core revision 20140214
[    0.006684] ACPI: Core revision 20140214
[    0.008685] ACPI:=20
[    0.008685] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables=
 successfully acquired

[    0.009552] Security Framework initialized
[    0.009552] Security Framework initialized
[    0.010007] AppArmor: AppArmor disabled by boot time parameter
[    0.010007] AppArmor: AppArmor disabled by boot time parameter
[    0.010910] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes=
)
[    0.010910] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes=
)
[    0.011935] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 =
bytes)
[    0.011935] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 =
bytes)
[    0.013718] Initializing cgroup subsys debug
[    0.013718] Initializing cgroup subsys debug
[    0.014387] Initializing cgroup subsys blkio
[    0.014387] Initializing cgroup subsys blkio
[    0.015059] Initializing cgroup subsys perf_event
[    0.015059] Initializing cgroup subsys perf_event
[    0.015799] Initializing cgroup subsys net_prio
[    0.015799] Initializing cgroup subsys net_prio
[    0.016562] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.016562] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.016562] tlb_flushall_shift: 6
[    0.016562] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.016562] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.016562] tlb_flushall_shift: 6
[    0.016671] CPU:=20
[    0.016671] CPU: Intel Intel Common KVM processorCommon KVM processor =
(fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.025086] Performance Events:=20
[    0.025086] Performance Events: unsupported Netburst CPU model 6 unsup=
ported Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.026764] ftrace: Allocated trace_printk buffers
[    0.026764] ftrace: Allocated trace_printk buffers
[    0.028395] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.028395] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.029248] Getting VERSION: 50014
[    0.029248] Getting VERSION: 50014
[    0.029780] Getting VERSION: 50014
[    0.029780] Getting VERSION: 50014
[    0.030006] Getting ID: 0
[    0.030006] Getting ID: 0
[    0.030422] Getting ID: f000000
[    0.030422] Getting ID: f000000
[    0.030911] Getting LVT0: 8700
[    0.030911] Getting LVT0: 8700
[    0.031399] Getting LVT1: 8400
[    0.031399] Getting LVT1: 8400
[    0.031887] enabled ExtINT on CPU#0
[    0.031887] enabled ExtINT on CPU#0
[    0.033462] ENABLING IO-APIC IRQs
[    0.033462] ENABLING IO-APIC IRQs
[    0.033984] init IO_APIC IRQs
[    0.033984] init IO_APIC IRQs
[    0.034443]  apic 0 pin 0 not connected
[    0.034443]  apic 0 pin 0 not connected
[    0.035049] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.035049] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.036265] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 =
Active:0 Dest:1)
[    0.036265] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 =
Active:0 Dest:1)
[    0.036686] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.036686] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.037940] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.037940] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.040018] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 =
Active:0 Dest:1)
[    0.040018] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 =
Active:0 Dest:1)
[    0.041248] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.041248] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.042473] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.042473] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.043351] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.043351] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.044587] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 =
Active:0 Dest:1)
[    0.044587] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 =
Active:0 Dest:1)
[    0.045822] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:=
1 Active:0 Dest:1)
[    0.045822] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:=
1 Active:0 Dest:1)
[    0.046684] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
1 Active:0 Dest:1)
[    0.046684] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
1 Active:0 Dest:1)
[    0.047956] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.047956] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.050017] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:=
0 Active:0 Dest:1)
[    0.050017] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:=
0 Active:0 Dest:1)
[    0.051271] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:=
0 Active:0 Dest:1)
[    0.051271] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:=
0 Active:0 Dest:1)
[    0.052523] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:=
0 Active:0 Dest:1)
[    0.052523] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:=
0 Active:0 Dest:1)
[    0.053349]  apic 0 pin 16 not connected
[    0.053349]  apic 0 pin 16 not connected
[    0.053954]  apic 0 pin 17 not connected
[    0.053954]  apic 0 pin 17 not connected
[    0.054563]  apic 0 pin 18 not connected
[    0.054563]  apic 0 pin 18 not connected
[    0.055174]  apic 0 pin 19 not connected
[    0.055174]  apic 0 pin 19 not connected
[    0.055773]  apic 0 pin 20 not connected
[    0.055773]  apic 0 pin 20 not connected
[    0.056670]  apic 0 pin 21 not connected
[    0.056670]  apic 0 pin 21 not connected
[    0.057274]  apic 0 pin 22 not connected
[    0.057274]  apic 0 pin 22 not connected
[    0.057892]  apic 0 pin 23 not connected
[    0.057892]  apic 0 pin 23 not connected
[    0.058642] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.058642] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.060002] Using local APIC timer interrupts.
[    0.060002] calibrating APIC timer ...
[    0.060002] Using local APIC timer interrupts.
[    0.060002] calibrating APIC timer ...
[    0.063333] ... lapic delta =3D 6249968
[    0.063333] ... lapic delta =3D 6249968
[    0.063333] ... PM-Timer delta =3D 357904
[    0.063333] ... PM-Timer delta =3D 357904
[    0.063333] ... PM-Timer result ok
[    0.063333] ... PM-Timer result ok
[    0.063333] ..... delta 6249968
[    0.063333] ..... delta 6249968
[    0.063333] ..... mult: 268434108
[    0.063333] ..... mult: 268434108
[    0.063333] ..... calibration result: 3333316
[    0.063333] ..... calibration result: 3333316
[    0.063333] ..... CPU clock speed is 2693.1339 MHz.
[    0.063333] ..... CPU clock speed is 2693.1339 MHz.
[    0.063333] ..... host bus clock speed is 1000.0316 MHz.
[    0.063333] ..... host bus clock speed is 1000.0316 MHz.
[    0.064037] evm: security.capability
[    0.064037] evm: security.capability
[    0.066353] xor: measuring software checksum speed
[    0.066353] xor: measuring software checksum speed
[    0.100002]    pIII_sse  : 12600.000 MB/sec
[    0.100002]    pIII_sse  : 12600.000 MB/sec
[    0.133335]    prefetch64-sse: 13532.400 MB/sec
[    0.133335]    prefetch64-sse: 13532.400 MB/sec
[    0.134228] xor: using function: prefetch64-sse (13532.400 MB/sec)
[    0.134228] xor: using function: prefetch64-sse (13532.400 MB/sec)
[    0.135392] prandom: seed boundary self test passed
[    0.135392] prandom: seed boundary self test passed
[    0.136735] prandom: 100 self tests passed
[    0.136735] prandom: 100 self tests passed
[    0.137537] atomic64 test passed for i586+ platform with CX8 and with =
SSE
[    0.137537] atomic64 test passed for i586+ platform with CX8 and with =
SSE
[    0.139119] regulator-dummy: no parameters
[    0.139119] regulator-dummy: no parameters
[    0.140099] NET: Registered protocol family 16
[    0.140099] NET: Registered protocol family 16
[    0.141516] EISA bus registered
[    0.141516] EISA bus registered
[    0.142123] cpuidle: using governor ladder
[    0.142123] cpuidle: using governor ladder
[    0.142909] cpuidle: using governor menu
[    0.142909] cpuidle: using governor menu
[    0.143759] ACPI: bus type PCI registered
[    0.143759] ACPI: bus type PCI registered
[    0.144663] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0=

[    0.144663] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0=

[    0.145886] PCI: Using configuration type 1 for base access
[    0.145886] PCI: Using configuration type 1 for base access
[    0.210004] raid6: mmxx1     4208 MB/s
[    0.210004] raid6: mmxx1     4208 MB/s
[    0.266678] raid6: mmxx2     4781 MB/s
[    0.266678] raid6: mmxx2     4781 MB/s
[    0.323336] raid6: sse1x1    3826 MB/s
[    0.323336] raid6: sse1x1    3826 MB/s
[    0.380011] raid6: sse1x2    4768 MB/s
[    0.380011] raid6: sse1x2    4768 MB/s
[    0.436670] raid6: sse2x1    6291 MB/s
[    0.436670] raid6: sse2x1    6291 MB/s
[    0.493337] raid6: sse2x2    8035 MB/s
[    0.493337] raid6: sse2x2    8035 MB/s
[    0.494068] raid6: using algorithm sse2x2 (8035 MB/s)
[    0.494068] raid6: using algorithm sse2x2 (8035 MB/s)
[    0.495023] raid6: using intx1 recovery algorithm
[    0.495023] raid6: using intx1 recovery algorithm
[    0.495936] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.495936] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.496698] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.496698] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.497902] ACPI: Added _OSI(Module Device)
[    0.497902] ACPI: Added _OSI(Module Device)
[    0.498702] ACPI: Added _OSI(Processor Device)
[    0.498702] ACPI: Added _OSI(Processor Device)
[    0.499556] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.499556] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.500003] ACPI: Added _OSI(Processor Aggregator Device)
[    0.500003] ACPI: Added _OSI(Processor Aggregator Device)
[    0.505292] ACPI: Interpreter enabled
[    0.505292] ACPI: Interpreter enabled
[    0.505993] ACPI Exception: AE_NOT_FOUND,=20
[    0.505993] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S1_]While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
 (20140214/hwxface-580)
[    0.507681] ACPI Exception: AE_NOT_FOUND,=20
[    0.507681] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State=
 [\_S2_]While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
 (20140214/hwxface-580)
[    0.509465] ACPI: (supports S0 S3 S5)
[    0.509465] ACPI: (supports S0 S3 S5)
[    0.510003] ACPI: Using IOAPIC for interrupt routing
[    0.510003] ACPI: Using IOAPIC for interrupt routing
[    0.510974] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.510974] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.518169] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.518169] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.519384] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.519384] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.520028] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASP=
M
[    0.520028] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASP=
M
[    0.521493] acpi PNP0A03:00: fail to add MMCONFIG information, can't a=
ccess extended PCI configuration space under this bridge.
[    0.521493] acpi PNP0A03:00: fail to add MMCONFIG information, can't a=
ccess extended PCI configuration space under this bridge.
[    0.523455] PCI host bridge to bus 0000:00
[    0.523455] PCI host bridge to bus 0000:00
[    0.524239] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.524239] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.525263] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.525263] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.526671] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.526671] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.527827] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.527827] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.529119] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebff=
fff]
[    0.529119] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebff=
fff]
[    0.530048] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.530048] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.531566] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.531566] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.533801] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.533801] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.537316] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.537316] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.539222] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-=
0x01f7]
[    0.539222] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-=
0x01f7]
[    0.540004] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]=

[    0.540004] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]=

[    0.541236] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-=
0x0177]
[    0.541236] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-=
0x0177]
[    0.542608] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]=

[    0.542608] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]=

[    0.543540] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.543540] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.544937] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PI=
IX4 ACPI
[    0.544937] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PI=
IX4 ACPI
[    0.546677] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PI=
IX4 SMB
[    0.546677] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PI=
IX4 SMB
[    0.548241] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.548241] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.552439] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pre=
f]
[    0.552439] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pre=
f]
[    0.554470] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.554470] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.561579] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pre=
f]
[    0.561579] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pre=
f]
[    0.563635] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.563635] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.565592] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.565592] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.567475] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.567475] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.572422] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pre=
f]
[    0.572422] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pre=
f]
[    0.573569] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.573569] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.575145] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.575145] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.579512] pci_bus 0000:00: on NUMA node 0
[    0.579512] pci_bus 0000:00: on NUMA node 0
[    0.580526] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.580526] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.581807] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.581807] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.583725] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.583725] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.584994] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.584994] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.586209] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.586209] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.587319] ACPI:=20
[    0.587319] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in =
block 00 to 0F

[    0.588890] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.588890] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.590003] vgaarb: loaded
[    0.590003] vgaarb: loaded
[    0.590511] vgaarb: bridge control possible 0000:00:02.0
[    0.590511] vgaarb: bridge control possible 0000:00:02.0
[    0.591913] SCSI subsystem initialized
[    0.591913] SCSI subsystem initialized
[    0.593524] libata version 3.00 loaded.
[    0.593524] libata version 3.00 loaded.
[    0.594309] ACPI: bus type USB registered
[    0.594309] ACPI: bus type USB registered
[    0.595117] usbcore: registered new interface driver usbfs
[    0.595117] usbcore: registered new interface driver usbfs
[    0.596155] usbcore: registered new interface driver hub
[    0.596155] usbcore: registered new interface driver hub
[    0.596719] usbcore: registered new device driver usb
[    0.596719] usbcore: registered new device driver usb
[    0.597794] Linux video capture interface: v2.00
[    0.597794] Linux video capture interface: v2.00
[    0.598732] pps_core: LinuxPPS API ver. 1 registered
[    0.598732] pps_core: LinuxPPS API ver. 1 registered
[    0.600003] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[    0.600003] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[    0.601721] PTP clock support registered
[    0.601721] PTP clock support registered
[    0.602623] PCI: Using ACPI for IRQ routing
[    0.602623] PCI: Using ACPI for IRQ routing
[    0.603339] PCI: pci_cache_line_size set to 64 bytes
[    0.603339] PCI: pci_cache_line_size set to 64 bytes
[    0.604382] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.604382] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.605509] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.605509] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.607278] cfg80211: Calling CRDA to update world regulatory domain
[    0.607278] cfg80211: Calling CRDA to update world regulatory domain
[    0.608518] nfc: nfc_init: NFC Core ver 0.1
[    0.608518] nfc: nfc_init: NFC Core ver 0.1
[    0.609356] NET: Registered protocol family 39
[    0.609356] NET: Registered protocol family 39
[    0.610533] Switched to clocksource kvm-clock
[    0.610533] Switched to clocksource kvm-clock
[    0.654422] pnp: PnP ACPI init
[    0.654422] pnp: PnP ACPI init
[    0.655063] ACPI: bus type PNP registered
[    0.655063] ACPI: bus type PNP registered
[    0.655880] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.655880] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.657480] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.657480] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.658738] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.658738] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.660273] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)=

[    0.660273] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)=

[    0.661560] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.661560] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.663148] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)=

[    0.663148] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)=

[    0.664409] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.664409] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.665912] pnp 00:03: [dma 2]
[    0.665912] pnp 00:03: [dma 2]
[    0.666550] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)=

[    0.666550] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)=

[    0.667832] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.667832] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.669377] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)=

[    0.669377] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)=

[    0.670646] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.670646] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.672158] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.672158] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.673417] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.673417] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.674968] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.674968] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.676427] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)=

[    0.676427] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)=

[    0.677800] pnp: PnP ACPI: found 8 devices
[    0.677800] pnp: PnP ACPI: found 8 devices
[    0.678582] ACPI: bus type PNP unregistered
[    0.678582] ACPI: bus type PNP unregistered
[    0.714450] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.714450] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.715515] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.715515] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.716561] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.716561] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.717752] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.717752] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.718983] NET: Registered protocol family 1
[    0.718983] NET: Registered protocol family 1
[    0.719838] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.719838] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.720975] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.720975] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.722096] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.722096] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.723264] pci 0000:00:02.0: Boot video device
[    0.723264] pci 0000:00:02.0: Boot video device
[    0.724149] PCI: CLS 0 bytes, default 64
[    0.724149] PCI: CLS 0 bytes, default 64
[    0.725102] Unpacking initramfs...
[    0.725102] Unpacking initramfs...
[    0.794708] Freeing initrd memory: 3276K (93cbd000 - 93ff0000)
[    0.794708] Freeing initrd memory: 3276K (93cbd000 - 93ff0000)
[    0.797272] The force parameter has not been set to 1. The Iris powero=
ff handler will not be installed.
[    0.797272] The force parameter has not been set to 1. The Iris powero=
ff handler will not be installed.
[    0.799048] NatSemi SCx200 Driver
[    0.799048] NatSemi SCx200 Driver
[    0.800185] Initializing RT-Tester: OK
[    0.800185] Initializing RT-Tester: OK
[    0.801162] futex hash table entries: 16 (order: -3, 704 bytes)
[    0.801162] futex hash table entries: 16 (order: -3, 704 bytes)
[    0.802309] Initialise system trusted keyring
[    0.802309] Initialise system trusted keyring
[    0.803209] audit: initializing netlink subsys (disabled)
[    0.803209] audit: initializing netlink subsys (disabled)
[    0.804299] audit: type=3D2000 audit(1401415040.101:1): initialized
[    0.804299] audit: type=3D2000 audit(1401415040.101:1): initialized
[    0.820038] VFS: Disk quotas dquot_6.5.2
[    0.820038] VFS: Disk quotas dquot_6.5.2
[    0.820927] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=

[    0.820927] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=

[    0.823528] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.823528] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.825899] ntfs: driver 2.1.30 [Flags: R/O].
[    0.825899] ntfs: driver 2.1.30 [Flags: R/O].
[    0.827082] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    0.827082] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    0.829777] QNX6 filesystem 1.0.0 registered.
[    0.829777] QNX6 filesystem 1.0.0 registered.
[    0.830972] JFS: nTxBlock =3D 2344, nTxLock =3D 18755
[    0.830972] JFS: nTxBlock =3D 2344, nTxLock =3D 18755
[    0.833733] NILFS version 2 loaded
[    0.833733] NILFS version 2 loaded
[    0.834390] befs: version: 0.9.3
[    0.834390] befs: version: 0.9.3
[    0.835429] ocfs2: Registered cluster interface o2cb
[    0.835429] ocfs2: Registered cluster interface o2cb
[    0.836564] OCFS2 User DLM kernel interface loaded
[    0.836564] OCFS2 User DLM kernel interface loaded
[    0.838607] gfs2: GFS2 installed
[    0.838607] gfs2: GFS2 installed
[    0.839402] msgmni has been set to 586
[    0.839402] msgmni has been set to 586
[    0.840154] Key type big_key registered
[    0.840154] Key type big_key registered
[    0.844145] alg: No test for crc32 (crc32-table)
[    0.844145] alg: No test for crc32 (crc32-table)
[    0.845138] alg: No test for lz4hc (lz4hc-generic)
[    0.845138] alg: No test for lz4hc (lz4hc-generic)
[    0.846101] alg: No test for stdrng (krng)
[    0.846101] alg: No test for stdrng (krng)
[    0.848893] NET: Registered protocol family 38
[    0.848893] NET: Registered protocol family 38
[    0.849757] Key type asymmetric registered
[    0.849757] Key type asymmetric registered
[    0.850550] Asymmetric key parser 'x509' registered
[    0.850550] Asymmetric key parser 'x509' registered
[    0.851602] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 251)
[    0.851602] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 251)
[    0.853062] io scheduler noop registered
[    0.853062] io scheduler noop registered
[    0.853814] io scheduler deadline registered (default)
[    0.853814] io scheduler deadline registered (default)
[    0.854900] io scheduler cfq registered
[    0.854900] io scheduler cfq registered
[    0.856617] list_sort_test: start testing list_sort()
[    0.856617] list_sort_test: start testing list_sort()
[    0.857942] xz_dec_test: module loaded
[    0.857942] xz_dec_test: module loaded
[    0.858663] xz_dec_test: Create a device node with 'mknod xz_dec_test =
c 250 0' and write .xz files to it.
[    0.858663] xz_dec_test: Create a device node with 'mknod xz_dec_test =
c 250 0' and write .xz files to it.
[    0.860468] rbtree testing
[    0.860468] rbtree testing -> 9494 cycles
 -> 9494 cycles
[    1.240410] augmented rbtree testing
[    1.240410] augmented rbtree testing -> 11758 cycles
 -> 11758 cycles
[    1.713480] hgafb: HGA card not detected.
[    1.713480] hgafb: HGA card not detected.
[    1.714280] hgafb: probe of hgafb.0 failed with error -22
[    1.714280] hgafb: probe of hgafb.0 failed with error -22
[    1.715388] usbcore: registered new interface driver udlfb
[    1.715388] usbcore: registered new interface driver udlfb
[    1.716428] usbcore: registered new interface driver smscufx
[    1.716428] usbcore: registered new interface driver smscufx
[    1.719072] v86d[98]: segfault at 0 ip 080492bf sp 7ffcc100 error 4
[    1.719072] v86d[98]: segfault at 0 ip 080492bf sp 7ffcc100 error 4 in=
 v86d[8047000+1c000] in v86d[8047000+1c000]

[    1.798885] tsc: Refined TSC clocksource calibration: 2693.539 MHz
[    1.798885] tsc: Refined TSC clocksource calibration: 2693.539 MHz
[    6.725702] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
1)
[    6.725702] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
1)
[    6.727021] uvesafb: vbe_init() failed with -22
[    6.727021] uvesafb: vbe_init() failed with -22
[    6.727887] uvesafb: probe of uvesafb.0 failed with error -22
[    6.727887] uvesafb: probe of uvesafb.0 failed with error -22
[    6.729021] ipmi message handler version 39.2
[    6.729021] ipmi message handler version 39.2
[    6.729854] ipmi device interface
[    6.729854] ipmi device interface
[    6.730575] IPMI System Interface driver.
[    6.730575] IPMI System Interface driver.
[    6.731468] ipmi_si: Unable to find any System Interface(s)
[    6.731468] ipmi_si: Unable to find any System Interface(s)
[    6.732560] IPMI Watchdog: driver initialized
[    6.732560] IPMI Watchdog: driver initialized
[    6.733410] Copyright (C) 2004 MontaVista Software - IPMI Powerdown vi=
a sys_reboot.
[    6.733410] Copyright (C) 2004 MontaVista Software - IPMI Powerdown vi=
a sys_reboot.
[    6.735062] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input0
[    6.735062] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input0
[    6.736508] ACPI: Power Button [PWRF]
[    6.736508] ACPI: Power Button [PWRF]
[    6.739128] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    6.739128] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    7.022510] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1=
15200) is a 16550A
[    7.024523] serial: Freescale lpuart driver
[    7.024523] serial: Freescale lpuart driver
[    7.025502] DoubleTalk PC - not found
[    7.025502] DoubleTalk PC - not found
[    7.026221] toshiba: not a supported Toshiba laptop
[    7.026221] toshiba: not a supported Toshiba laptop
[    7.027234] ppdev: user-space parallel port driver
[    7.027234] ppdev: user-space parallel port driver
[    7.028189] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initi=
alizing
[    7.028189] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initi=
alizing
[    7.029544] platform pc8736x_gpio.0: no device found
[    7.029544] platform pc8736x_gpio.0: no device found
[    7.030587] nsc_gpio initializing
[    7.030587] nsc_gpio initializing
[    7.031228] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    7.031228] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    7.032191] smapi::smapi_init, ERROR invalid usSmapiID
[    7.032191] smapi::smapi_init, ERROR invalid usSmapiID
[    7.033180] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI =
is not available on this machine
[    7.033180] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI =
is not available on this machine
[    7.034896] mwave: mwavedd::mwave_init: Error: Failed to initialize bo=
ard data
[    7.034896] mwave: mwavedd::mwave_init: Error: Failed to initialize bo=
ard data
[    7.036284] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    7.036284] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    7.037479] SyncLink PC Card driver $Revision: 4.34 $, tty major#245
[    7.037479] SyncLink PC Card driver $Revision: 4.34 $, tty major#245
[    7.038711] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 sec=
onds, margin is 60 seconds).
[    7.038711] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 sec=
onds, margin is 60 seconds).
[    7.040411] Hangcheck: Using getrawmonotonic().
[    7.040411] Hangcheck: Using getrawmonotonic().
[    7.041417] [drm] Initialized drm 1.1.0 20060810
[    7.041417] [drm] Initialized drm 1.1.0 20060810
[    7.042802] parport_pc 00:04: reported by Plug and Play ACPI
[    7.042802] parport_pc 00:04: reported by Plug and Play ACPI
[    7.043939] parport0: PC-style at 0x378
[    7.043939] parport0: PC-style at 0x378, irq 7, irq 7 [ [PCSPPPCSPP(,.=
=2E.)(,...)]
]
[    7.047148] loop: module loaded
[    7.047148] loop: module loaded
[    7.048052] nbd: registered device at major 43
[    7.048052] nbd: registered device at major 43
[    7.051594]  nullb0: unknown partition table
[    7.051594]  nullb0: unknown partition table
[    7.052639] Floppy drive(s):
[    7.052639] Floppy drive(s): fd0 is 1.44M fd0 is 1.44M

[    7.055909]  nullb1: unknown partition table
[    7.055909]  nullb1: unknown partition table
[    7.056864] null: module loaded
[    7.056864] null: module loaded
[    7.057506] dummy-irq: no IRQ given.  Use irq=3DN
[    7.057506] dummy-irq: no IRQ given.  Use irq=3DN
[    7.058384] lkdtm: No crash points registered, enable through debugfs
[    7.058384] lkdtm: No crash points registered, enable through debugfs
[    7.059681] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo =
Giometti
[    7.059681] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo =
Giometti
[    7.061122] c2port c2port0: C2 port uc added
[    7.061122] c2port c2port0: C2 port uc added
[    7.061922] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 =
bytes total)
[    7.061922] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 =
bytes total)
[    7.063536] usbcore: registered new interface driver viperboard
[    7.063536] usbcore: registered new interface driver viperboard
[    7.064690] usbcore: registered new interface driver pn533
[    7.064690] usbcore: registered new interface driver pn533
[    7.065904] usbcore: registered new interface driver port100
[    7.065904] usbcore: registered new interface driver port100
[    7.067185] Loading iSCSI transport class v2.0-870.
[    7.067185] Loading iSCSI transport class v2.0-870.
[    7.068571] FDC 0 is a S82078B
[    7.068571] FDC 0 is a S82078B
[    7.069717] hp_sw: device handler registered
[    7.069717] hp_sw: device handler registered
[    7.070534] alua: device handler registered
[    7.070534] alua: device handler registered
[    7.072828] scsi: <fdomain> Detection failed (no card)
[    7.072828] scsi: <fdomain> Detection failed (no card)
[    7.073889] NCR53c406a: no available ports found
[    7.073889] NCR53c406a: no available ports found
[    7.074762] qlogicfas: no cards were found, please specify I/O address=
 and IRQ using iobase=3D and irq=3D options
[    7.074762] qlogicfas: no cards were found, please specify I/O address=
 and IRQ using iobase=3D and irq=3D optionsGDT-HA: Storage RAID Controlle=
r Driver. Version: 3.05
GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    7.077550] osst :I: Tape driver with OnStream support version 0.99.4
[    7.077550] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp=
 $
[    7.077550] osst :I: Tape driver with OnStream support version 0.99.4
[    7.077550] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp=
 $
[    7.080737] Rounding down aligned max_sectors from 4294967295 to 42949=
67288
[    7.080737] Rounding down aligned max_sectors from 4294967295 to 42949=
67288
[    7.082986] mtdoops: mtd device (mtddev=3Dname/number) must be supplie=
d
[    7.082986] mtdoops: mtd device (mtddev=3Dname/number) must be supplie=
d
[    7.084226] L440GX flash mapping: failed to find PIIX4 ISA bridge, can=
not continue
[    7.084226] L440GX flash mapping: failed to find PIIX4 ISA bridge, can=
not continue
[    7.085678] platform physmap-flash.0: failed to claim resource 0
[    7.085678] platform physmap-flash.0: failed to claim resource 0
[    7.086813] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[    7.086813] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[    7.087923] slram: not enough parameters.
[    7.087923] slram: not enough parameters.
[    7.122766] No valid DiskOnChip devices found
[    7.122766] No valid DiskOnChip devices found
[    7.123666] [nandsim] warning: read_byte: unexpected data output cycle=
, state is STATE_READY return 0x0
[    7.123666] [nandsim] warning: read_byte: unexpected data output cycle=
, state is STATE_READY return 0x0
[    7.125416] [nandsim] warning: read_byte: unexpected data output cycle=
, state is STATE_READY return 0x0
[    7.125416] [nandsim] warning: read_byte: unexpected data output cycle=
, state is STATE_READY return 0x0
[    7.127163] [nandsim] warning: read_byte: unexpected data output cycle=
, state is STATE_READY return 0x0
[    7.127163] [nandsim] warning: read_byte: unexpected data output cycle=
, state is STATE_READY return 0x0
[    7.128908] [nandsim] warning: read_byte: unexpected data output cycle=
, state is STATE_READY return 0x0
[    7.128908] [nandsim] warning: read_byte: unexpected data output cycle=
, state is STATE_READY return 0x0
[    7.130654] [nandsim] warning: read_byte: unexpected data output cycle=
, state is STATE_READY return 0x0
[    7.130654] [nandsim] warning: read_byte: unexpected data output cycle=
, state is STATE_READY return 0x0
[    7.132404] [nandsim] warning: read_byte: unexpected data output cycle=
, state is STATE_READY return 0x0
[    7.132404] [nandsim] warning: read_byte: unexpected data output cycle=
, state is STATE_READY return 0x0
[    7.134157] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    7.134157] nand: device found, Manufacturer ID: 0x98, Chip ID: 0x39
[    7.135336] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    7.135336] nand: Toshiba NAND 128MiB 1,8V 8-bit
[    7.136214] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    7.136214] nand: 128MiB, SLC, page size: 512, OOB size: 16
[    7.137299] flash size: 128 MiB
[    7.137299] flash size: 128 MiB
[    7.137895] page size: 512 bytes
[    7.137895] page size: 512 bytes
[    7.138509] OOB area size: 16 bytes
[    7.138509] OOB area size: 16 bytes
[    7.139189] sector size: 16 KiB
[    7.139189] sector size: 16 KiB
[    7.139781] pages number: 262144
[    7.139781] pages number: 262144
[    7.140393] pages per sector: 32
[    7.140393] pages per sector: 32
[    7.140998] bus width: 8
[    7.140998] bus width: 8
[    7.141484] bits in sector size: 14
[    7.141484] bits in sector size: 14
[    7.142142] bits in page size: 9
[    7.142142] bits in page size: 9
[    7.142752] bits in OOB size: 4
[    7.142752] bits in OOB size: 4
[    7.143347] flash size with OOB: 135168 KiB
[    7.143347] flash size with OOB: 135168 KiB
[    7.144120] page address bytes: 4
[    7.144120] page address bytes: 4
[    7.144747] sector address bytes: 3
[    7.144747] sector address bytes: 3
[    7.145408] options: 0x42
[    7.145408] options: 0x42
[    7.146940] Scanning device for bad blocks
[    7.146940] Scanning device for bad blocks
[    7.166831] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    7.166831] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    7.168012] 0x000000000000-0x000008000000 : "NAND simulator partition =
0"
[    7.168012] 0x000000000000-0x000008000000 : "NAND simulator partition =
0"
[    7.169664] ftl_cs: FTL header not found.
[    7.169664] ftl_cs: FTL header not found.
[    7.170778] HSI/SSI char device loaded
[    7.170778] HSI/SSI char device loaded
[    7.171519] LocalTalk card not found; 220 =3D ff, 240 =3D ff.
[    7.171519] LocalTalk card not found; 220 =3D ff, 240 =3D ff.
[    7.172553] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon=
=2Etc.umn.edu>
[    7.172553] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon=
=2Etc.umn.edu>
[    7.174146] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <j=
ohns393@maroon.tc.umn.edu>
[    7.174146] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <j=
ohns393@maroon.tc.umn.edu>
[    7.175794] vcan: Virtual CAN interface driver
[    7.175794] vcan: Virtual CAN interface driver
[    7.176639] CAN device driver interface
[    7.176639] CAN device driver interface
[    7.177390] usbcore: registered new interface driver ems_usb
[    7.177390] usbcore: registered new interface driver ems_usb
[    7.178464] usbcore: registered new interface driver esd_usb2
[    7.178464] usbcore: registered new interface driver esd_usb2
[    7.179557] usbcore: registered new interface driver kvaser_usb
[    7.179557] usbcore: registered new interface driver kvaser_usb
[    7.180676] usbcore: registered new interface driver peak_usb
[    7.180676] usbcore: registered new interface driver peak_usb
[    7.181768] usbcore: registered new interface driver usb_8dev
[    7.181768] usbcore: registered new interface driver usb_8dev
[    7.182911] Databook TCIC-2 PCMCIA probe:=20
[    7.182911] Databook TCIC-2 PCMCIA probe: not found.
not found.
[    7.185681] aoe: AoE v85 initialised.
[    7.185681] aoe: AoE v85 initialised.
[    7.186448] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    7.186448] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    7.187675] ehci-pci: EHCI PCI platform driver
[    7.187675] ehci-pci: EHCI PCI platform driver
[    7.188534] ehci-platform: EHCI generic platform driver
[    7.188534] ehci-platform: EHCI generic platform driver
[    7.189673] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    7.189673] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    7.190817] usbcore: registered new interface driver cdc_acm
[    7.190817] usbcore: registered new interface driver cdc_acm
[    7.191877] cdc_acm: USB Abstract Control Model driver for USB modems =
and ISDN adapters
[    7.191877] cdc_acm: USB Abstract Control Model driver for USB modems =
and ISDN adapters
[    7.193396] usbcore: registered new interface driver usblp
[    7.193396] usbcore: registered new interface driver usblp
[    7.194440] usbcore: registered new interface driver cdc_wdm
[    7.194440] usbcore: registered new interface driver cdc_wdm
[    7.195507] usbcore: registered new interface driver uas
[    7.195507] usbcore: registered new interface driver uas
[    7.196527] usbcore: registered new interface driver usb-storage
[    7.196527] usbcore: registered new interface driver usb-storage
[    7.197658] usbcore: registered new interface driver ums-alauda
[    7.197658] usbcore: registered new interface driver ums-alauda
[    7.198769] usbcore: registered new interface driver ums-cypress
[    7.198769] usbcore: registered new interface driver ums-cypress
[    7.199904] usbcore: registered new interface driver ums-datafab
[    7.199904] usbcore: registered new interface driver ums-datafab
[    7.201042] usbcore: registered new interface driver ums_eneub6250
[    7.201042] usbcore: registered new interface driver ums_eneub6250
[    7.202209] usbcore: registered new interface driver ums-isd200
[    7.202209] usbcore: registered new interface driver ums-isd200
[    7.203328] usbcore: registered new interface driver ums-karma
[    7.203328] usbcore: registered new interface driver ums-karma
[    7.204432] usbcore: registered new interface driver ums-onetouch
[    7.204432] usbcore: registered new interface driver ums-onetouch
[    7.205591] usbcore: registered new interface driver ums-sddr55
[    7.205591] usbcore: registered new interface driver ums-sddr55
[    7.206708] usbcore: registered new interface driver microtekX6
[    7.206708] usbcore: registered new interface driver microtekX6
[    7.207871] usbcore: registered new interface driver usbserial
[    7.207871] usbcore: registered new interface driver usbserial
[    7.208983] usbcore: registered new interface driver usbserial_generic=

[    7.208983] usbcore: registered new interface driver usbserial_generic=

[    7.210248] usbserial: USB Serial support registered for generic
[    7.210248] usbserial: USB Serial support registered for generic
[    7.211389] usbcore: registered new interface driver aircable
[    7.211389] usbcore: registered new interface driver aircable
[    7.212482] usbserial: USB Serial support registered for aircable
[    7.212482] usbserial: USB Serial support registered for aircable
[    7.213629] usbcore: registered new interface driver belkin_sa
[    7.213629] usbcore: registered new interface driver belkin_sa
[    7.214735] usbserial: USB Serial support registered for Belkin / Pera=
com / GoHubs USB Serial Adapter
[    7.214735] usbserial: USB Serial support registered for Belkin / Pera=
com / GoHubs USB Serial Adapter
[    7.216468] usbcore: registered new interface driver ch341
[    7.216468] usbcore: registered new interface driver ch341
[    7.217508] usbserial: USB Serial support registered for ch341-uart
[    7.217508] usbserial: USB Serial support registered for ch341-uart
[    7.218692] usbcore: registered new interface driver cp210x
[    7.218692] usbcore: registered new interface driver cp210x
[    7.219740] usbserial: USB Serial support registered for cp210x
[    7.219740] usbserial: USB Serial support registered for cp210x
[    7.220861] usbcore: registered new interface driver cyberjack
[    7.220861] usbcore: registered new interface driver cyberjack
[    7.221958] usbserial: USB Serial support registered for Reiner SCT Cy=
berjack USB card reader
[    7.221958] usbserial: USB Serial support registered for Reiner SCT Cy=
berjack USB card reader
[    7.223550] usbcore: registered new interface driver usb_debug
[    7.223550] usbcore: registered new interface driver usb_debug
[    7.224649] usbserial: USB Serial support registered for debug
[    7.224649] usbserial: USB Serial support registered for debug
[    7.225757] usbcore: registered new interface driver empeg
[    7.225757] usbcore: registered new interface driver empeg
[    7.226809] usbserial: USB Serial support registered for empeg
[    7.226809] usbserial: USB Serial support registered for empeg
[    7.227903] usbcore: registered new interface driver f81232
[    7.227903] usbcore: registered new interface driver f81232
[    7.228967] usbserial: USB Serial support registered for f81232
[    7.228967] usbserial: USB Serial support registered for f81232
[    7.230097] usbcore: registered new interface driver ipw
[    7.230097] usbcore: registered new interface driver ipw
[    7.231102] usbserial: USB Serial support registered for IPWireless co=
nverter
[    7.231102] usbserial: USB Serial support registered for IPWireless co=
nverter
[    7.232454] usbcore: registered new interface driver iuu_phoenix
[    7.232454] usbcore: registered new interface driver iuu_phoenix
[    7.233587] usbserial: USB Serial support registered for iuu_phoenix
[    7.233587] usbserial: USB Serial support registered for iuu_phoenix
[    7.234787] usbcore: registered new interface driver keyspan_pda
[    7.234787] usbcore: registered new interface driver keyspan_pda
[    7.235934] usbserial: USB Serial support registered for Keyspan PDA
[    7.235934] usbserial: USB Serial support registered for Keyspan PDA
[    7.237135] usbserial: USB Serial support registered for Keyspan PDA -=
 (prerenumeration)
[    7.237135] usbserial: USB Serial support registered for Keyspan PDA -=
 (prerenumeration)
[    7.238653] usbcore: registered new interface driver metro_usb
[    7.238653] usbcore: registered new interface driver metro_usb
[    7.239761] usbserial: USB Serial support registered for Metrologic US=
B to Serial
[    7.239761] usbserial: USB Serial support registered for Metrologic US=
B to Serial
[    7.241178] usbcore: registered new interface driver mos7720
[    7.241178] usbcore: registered new interface driver mos7720
[    7.242265] usbserial: USB Serial support registered for Moschip 2 por=
t adapter
[    7.242265] usbserial: USB Serial support registered for Moschip 2 por=
t adapter
[    7.243642] usbcore: registered new interface driver mos7840
[    7.243642] usbcore: registered new interface driver mos7840
[    7.244718] usbserial: USB Serial support registered for Moschip 7840/=
7820 USB Serial Driver
[    7.244718] usbserial: USB Serial support registered for Moschip 7840/=
7820 USB Serial Driver
[    7.246313] usbcore: registered new interface driver mxuport
[    7.246313] usbcore: registered new interface driver mxuport
[    7.247392] usbserial: USB Serial support registered for MOXA UPort
[    7.247392] usbserial: USB Serial support registered for MOXA UPort
[    7.248580] usbcore: registered new interface driver navman
[    7.248580] usbcore: registered new interface driver navman
[    7.249648] usbserial: USB Serial support registered for navman
[    7.249648] usbserial: USB Serial support registered for navman
[    7.250775] usbcore: registered new interface driver oti6858
[    7.250775] usbcore: registered new interface driver oti6858
[    7.251852] usbserial: USB Serial support registered for oti6858
[    7.251852] usbserial: USB Serial support registered for oti6858
[    7.252990] usbcore: registered new interface driver pl2303
[    7.252990] usbcore: registered new interface driver pl2303
[    7.254047] usbserial: USB Serial support registered for pl2303
[    7.254047] usbserial: USB Serial support registered for pl2303
[    7.255169] usbcore: registered new interface driver qcaux
[    7.255169] usbcore: registered new interface driver qcaux
[    7.256213] usbserial: USB Serial support registered for qcaux
[    7.256213] usbserial: USB Serial support registered for qcaux
[    7.257313] usbcore: registered new interface driver qcserial
[    7.257313] usbcore: registered new interface driver qcserial
[    7.258397] usbserial: USB Serial support registered for Qualcomm USB =
modem
[    7.258397] usbserial: USB Serial support registered for Qualcomm USB =
modem
[    7.259713] usbcore: registered new interface driver usb_serial_simple=

[    7.259713] usbcore: registered new interface driver usb_serial_simple=

[    7.260957] usbserial: USB Serial support registered for zio
[    7.260957] usbserial: USB Serial support registered for zio
[    7.262028] usbserial: USB Serial support registered for funsoft
[    7.262028] usbserial: USB Serial support registered for funsoft
[    7.263179] usbserial: USB Serial support registered for flashloader
[    7.263179] usbserial: USB Serial support registered for flashloader
[    7.264379] usbserial: USB Serial support registered for vivopay
[    7.264379] usbserial: USB Serial support registered for vivopay
[    7.265510] usbserial: USB Serial support registered for moto_modem
[    7.265510] usbserial: USB Serial support registered for moto_modem
[    7.266697] usbserial: USB Serial support registered for hp4x
[    7.266697] usbserial: USB Serial support registered for hp4x
[    7.267781] usbserial: USB Serial support registered for suunto
[    7.267781] usbserial: USB Serial support registered for suunto
[    7.268902] usbserial: USB Serial support registered for siemens_mpi
[    7.268902] usbserial: USB Serial support registered for siemens_mpi
[    7.270093] usbcore: registered new interface driver symbolserial
[    7.270093] usbcore: registered new interface driver symbolserial
[    7.271242] usbserial: USB Serial support registered for symbol
[    7.271242] usbserial: USB Serial support registered for symbol
[    7.272365] usbcore: registered new interface driver wishbone_serial
[    7.272365] usbcore: registered new interface driver wishbone_serial
[    7.273577] usbserial: USB Serial support registered for wishbone_seri=
al
[    7.273577] usbserial: USB Serial support registered for wishbone_seri=
al
[    7.274843] usbcore: registered new interface driver zte_ev
[    7.274843] usbcore: registered new interface driver zte_ev
[    7.275902] usbserial: USB Serial support registered for zte_ev
[    7.275902] usbserial: USB Serial support registered for zte_ev
[    7.277021] usbcore: registered new interface driver adutux
[    7.277021] usbcore: registered new interface driver adutux
[    7.278144] usbcore: registered new interface driver appledisplay
[    7.278144] usbcore: registered new interface driver appledisplay
[    7.279312] usbcore: registered new interface driver cytherm
[    7.279312] usbcore: registered new interface driver cytherm
[    7.280391] usbcore: registered new interface driver emi26 - firmware =
loader
[    7.280391] usbcore: registered new interface driver emi26 - firmware =
loader
[    7.281718] usbcore: registered new interface driver emi62 - firmware =
loader
[    7.281718] usbcore: registered new interface driver emi62 - firmware =
loader
[    7.283028] driver ftdi-elan
[    7.283028] driver ftdi-elan
[    7.283690] usbcore: registered new interface driver ftdi-elan
[    7.283690] usbcore: registered new interface driver ftdi-elan
[    7.284809] usbcore: registered new interface driver isight_firmware
[    7.284809] usbcore: registered new interface driver isight_firmware
[    7.286026] usbcore: registered new interface driver usblcd
[    7.286026] usbcore: registered new interface driver usblcd
[    7.287081] usbcore: registered new interface driver usbled
[    7.287081] usbcore: registered new interface driver usbled
[    7.288145] usbcore: registered new interface driver legousbtower
[    7.288145] usbcore: registered new interface driver legousbtower
[    7.289310] usbcore: registered new interface driver rio500
[    7.289310] usbcore: registered new interface driver rio500
[    7.290375] usbcore: registered new interface driver usb_ehset_test
[    7.290375] usbcore: registered new interface driver usb_ehset_test
[    7.291558] usbcore: registered new interface driver uss720
[    7.291558] usbcore: registered new interface driver uss720
[    7.292604] uss720: v0.6:USB Parport Cable driver for Cables using the=
 Lucent Technologies USS720 Chip
[    7.292604] uss720: v0.6:USB Parport Cable driver for Cables using the=
 Lucent Technologies USS720 Chip
[    7.294343] uss720: NOTE: this is a special purpose driver to allow no=
nstandard
[    7.294343] uss720: NOTE: this is a special purpose driver to allow no=
nstandard
[    7.295703] uss720: protocols (eg. bitbang) over USS720 usb to paralle=
l cables
[    7.295703] uss720: protocols (eg. bitbang) over USS720 usb to paralle=
l cables
[    7.297031] uss720: If you just want to connect to a printer, use usbl=
p instead
[    7.297031] uss720: If you just want to connect to a printer, use usbl=
p instead
[    7.298419] usbcore: registered new interface driver usbsevseg
[    7.298419] usbcore: registered new interface driver usbsevseg
[    7.299533] usbcore: registered new interface driver yurex
[    7.299533] usbcore: registered new interface driver yurex
[    7.300766] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0=
x60,0x64 irq 1,12
[    7.300766] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0=
x60,0x64 irq 1,12
[    7.302908] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.302908] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.303865] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.303865] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.304901] serio: PARKBD AT adapter on parport0
[    7.304901] serio: PARKBD AT adapter on parport0
[    7.345506] usbcore: registered new interface driver xpad
[    7.345506] usbcore: registered new interface driver xpad
[    7.346580] usbcore: registered new interface driver usb_acecad
[    7.346580] usbcore: registered new interface driver usb_acecad
[    7.347735] usbcore: registered new interface driver gtco
[    7.347735] usbcore: registered new interface driver gtco
[    7.348802] usbcore: registered new interface driver hanwang
[    7.348802] usbcore: registered new interface driver hanwang
[    7.349926] usbcore: registered new interface driver kbtab
[    7.349926] usbcore: registered new interface driver kbtab
[    7.350983] usbcore: registered new interface driver wacom
[    7.350983] usbcore: registered new interface driver wacom
[    7.352199] mk712: device not present
[    7.352199] mk712: device not present
[    7.352928] usbcore: registered new interface driver usbtouchscreen
[    7.352928] usbcore: registered new interface driver usbtouchscreen
[    7.354213] usbcore: registered new interface driver sur40
[    7.354213] usbcore: registered new interface driver sur40
[    7.355417] rtc_cmos 00:00: RTC can wake from S4
[    7.355417] rtc_cmos 00:00: RTC can wake from S4
[    7.356617] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    7.356617] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    7.357909] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpe=
t irqs
[    7.357909] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpe=
t irqs
[    7.359672] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    7.359672] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    7.360900] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    7.360900] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    7.362085] i2c /dev entries driver
[    7.362085] i2c /dev entries driver
[    7.362819] usbcore: registered new interface driver i2c-diolan-u2c
[    7.362819] usbcore: registered new interface driver i2c-diolan-u2c
[    7.363960] i2c-parport: adapter type unspecified
[    7.363960] i2c-parport: adapter type unspecified
[    7.364825] i2c-parport-light: adapter type unspecified
[    7.364825] i2c-parport-light: adapter type unspecified
[    7.365803] usbcore: registered new interface driver RobotFuzz Open So=
urce InterFace, OSIF
[    7.365803] usbcore: registered new interface driver RobotFuzz Open So=
urce InterFace, OSIF
[    7.367328] usbcore: registered new interface driver i2c-tiny-usb
[    7.367328] usbcore: registered new interface driver i2c-tiny-usb
[    7.368476] isa i2c-pca-isa.0: Please specify I/O base
[    7.368476] isa i2c-pca-isa.0: Please specify I/O base
[    7.370036] parport0: no more devices allowed
[    7.370036] parport0: no more devices allowed
[    7.370843] bw-qcam0: couldn't register for parport0.
[    7.370843] bw-qcam0: couldn't register for parport0.
[    7.371812] PMS: not enabled, use pms.enable=3D1 to probe
[    7.371812] PMS: not enabled, use pms.enable=3D1 to probe
[    7.372781] pps_ldisc: PPS line discipline registered
[    7.372781] pps_ldisc: PPS line discipline registered
[    7.373770] pps_parport: parallel port PPS client
[    7.373770] pps_parport: parallel port PPS client
[    7.374638] parport0: no more devices allowed
[    7.374638] parport0: no more devices allowed
[    7.375429] pps_parport: couldn't register with parport0
[    7.375429] pps_parport: couldn't register with parport0
[    7.376438] Driver for 1-wire Dallas network protocol.
[    7.376438] Driver for 1-wire Dallas network protocol.
[    7.377420] usbcore: registered new interface driver DS9490R
[    7.377420] usbcore: registered new interface driver DS9490R
[    7.378503] 1-Wire driver for the DS2760 battery monitor  chip  - (c) =
2004-2005, Szabolcs Gyurko
[    7.378503] 1-Wire driver for the DS2760 battery monitor  chip  - (c) =
2004-2005, Szabolcs Gyurko
[    7.380437] w83781d: Detection failed at step 2
[    7.380437] w83781d: Detection failed at step 2
[    7.381922] pc87360: PC8736x not detected, module not inserted
[    7.381922] pc87360: PC8736x not detected, module not inserted
[    7.383143] intel_powerclamp: Intel powerclamp does not run on family =
15 model 6
[    7.383143] intel_powerclamp: Intel powerclamp does not run on family =
15 model 6
[    7.384786] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialise=
d: dm-devel@redhat.com
[    7.384786] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialise=
d: dm-devel@redhat.com
[    7.386911] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input1
[    7.386911] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input1
[    7.389723] cpufreq-nforce2: No nForce2 chipset.
[    7.389723] cpufreq-nforce2: No nForce2 chipset.
[    7.390608] sdhci: Secure Digital Host Controller Interface driver
[    7.390608] sdhci: Secure Digital Host Controller Interface driver
[    7.391719] sdhci: Copyright(c) Pierre Ossman
[    7.391719] sdhci: Copyright(c) Pierre Ossman
[    7.392521] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0=
400
[    7.392521] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0=
400

[    7.393769] usbcore: registered new interface driver vub300
[    7.393769] usbcore: registered new interface driver vub300
[    7.394851] usbcore: registered new interface driver ushc
[    7.394851] usbcore: registered new interface driver ushc
[    7.395839] sdhci-pltfm: SDHCI platform and OF driver helper
[    7.395839] sdhci-pltfm: SDHCI platform and OF driver helper
[    7.397166] ledtrig-cpu: registered to indicate activity on CPUs
[    7.397166] ledtrig-cpu: registered to indicate activity on CPUs
[    7.398421] dcdbas dcdbas: Dell Systems Management Base Driver (versio=
n 5.6.0-3.2)
[    7.398421] dcdbas dcdbas: Dell Systems Management Base Driver (versio=
n 5.6.0-3.2)
[    7.399832] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Gol=
dfish MMIO.
[    7.399832] goldfish_pdev_bus goldfish_pdev_bus: unable to reserve Gol=
dfish MMIO.
[    7.401219] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with =
error -16
[    7.401219] goldfish_pdev_bus: probe of goldfish_pdev_bus failed with =
error -16
[    7.403054] NET: Registered protocol family 26
[    7.403054] NET: Registered protocol family 26
[    7.403897] NET: Registered protocol family 17
[    7.403897] NET: Registered protocol family 17
[    7.404738] NET: Registered protocol family 4
[    7.404738] NET: Registered protocol family 4
[    7.405584] NET: Registered protocol family 5
[    7.405584] NET: Registered protocol family 5
[    7.406411] can: controller area network core (rev 20120528 abi 9)
[    7.406411] can: controller area network core (rev 20120528 abi 9)
[    7.407568] NET: Registered protocol family 29
[    7.407568] NET: Registered protocol family 29
[    7.408397] can: raw protocol (rev 20120528)
[    7.408397] can: raw protocol (rev 20120528)
[    7.409193] can: broadcast manager protocol (rev 20120528 t)
[    7.409193] can: broadcast manager protocol (rev 20120528 t)
[    7.410222] can: netlink gateway (rev 20130117) max_hops=3D1
[    7.410222] can: netlink gateway (rev 20130117) max_hops=3D1
[    7.411360] NET: Registered protocol family 35
[    7.411360] NET: Registered protocol family 35
[    7.412201] 8021q: 802.1Q VLAN Support v1.8
[    7.412201] 8021q: 802.1Q VLAN Support v1.8
[    7.413036] NET: Registered protocol family 37
[    7.413036] NET: Registered protocol family 37
[    7.413871] Key type dns_resolver registered
[    7.413871] Key type dns_resolver registered
[    7.414735] batman_adv: B.A.T.M.A.N. advanced 2014.2.0 (compatibility =
version 15) loaded
[    7.414735] batman_adv: B.A.T.M.A.N. advanced 2014.2.0 (compatibility =
version 15) loaded
[    7.416223] openvswitch: Open vSwitch switching datapath
[    7.416223] openvswitch: Open vSwitch switching datapath
[    7.417347] mpls_gso: MPLS GSO support
[    7.417347] mpls_gso: MPLS GSO support
[    7.418467]=20
[    7.418467] printing PIC contents
[    7.418467]=20
[    7.418467] printing PIC contents
[    7.419358] ... PIC  IMR: ffff
[    7.419358] ... PIC  IMR: ffff
[    7.419920] ... PIC  IRR: 1153
[    7.419920] ... PIC  IRR: 1153
[    7.420486] ... PIC  ISR: 0000
[    7.420486] ... PIC  ISR: 0000
[    7.421047] ... PIC ELCR: 0c00
[    7.421047] ... PIC ELCR: 0c00
[    7.421614] printing local APIC contents on CPU#0/0:
[    7.421614] printing local APIC contents on CPU#0/0:
[    7.422522] ... APIC ID:      00000000 (0)
[    7.422522] ... APIC ID:      00000000 (0)
[    7.422681] ... APIC VERSION: 00050014
[    7.422681] ... APIC VERSION: 00050014
[    7.422681] ... APIC TASKPRI: 00000000 (00)
[    7.422681] ... APIC TASKPRI: 00000000 (00)
[    7.422681] ... APIC PROCPRI: 00000000
[    7.422681] ... APIC PROCPRI: 00000000
[    7.422681] ... APIC LDR: 01000000
[    7.422681] ... APIC LDR: 01000000
[    7.422681] ... APIC DFR: ffffffff
[    7.422681] ... APIC DFR: ffffffff
[    7.422681] ... APIC SPIV: 000001ff
[    7.422681] ... APIC SPIV: 000001ff
[    7.422681] ... APIC ISR field:
[    7.422681] ... APIC ISR field:
[    7.422681] 00000000
[    7.422681] 0000000000000000000000000000000000000000000000000000000000=
00000000000000000000000000000000000000000000000000000000000000

[    7.422681] ... APIC TMR field:
[    7.422681] ... APIC TMR field:
[    7.422681] 00000000
[    7.422681] 0000000002000000020000000000000000000000000000000000000000=
00000000000000000000000000000000000000000000000000000000000000

[    7.422681] ... APIC IRR field:
[    7.422681] ... APIC IRR field:
[    7.422681] 00000000
[    7.422681] 0000000000000000000000000000000000000000000000000000000000=
00000000000000000000000000000000000000000000000000800000008000

[    7.422681] ... APIC ESR: 00000000
[    7.422681] ... APIC ESR: 00000000
[    7.422681] ... APIC ICR: 000c4610
[    7.422681] ... APIC ICR: 000c4610
[    7.422681] ... APIC ICR2: 00000000
[    7.422681] ... APIC ICR2: 00000000
[    7.422681] ... APIC LVTT: 000200ef
[    7.422681] ... APIC LVTT: 000200ef
[    7.422681] ... APIC LVTPC: 00010000
[    7.422681] ... APIC LVTPC: 00010000
[    7.422681] ... APIC LVT0: 00010700
[    7.422681] ... APIC LVT0: 00010700
[    7.422681] ... APIC LVT1: 00000400
[    7.422681] ... APIC LVT1: 00000400
[    7.422681] ... APIC LVTERR: 000000fe
[    7.422681] ... APIC LVTERR: 000000fe
[    7.422681] ... APIC TMICT: 00032dcc
[    7.422681] ... APIC TMICT: 00032dcc
[    7.422681] ... APIC TMCCT: 0003237f
[    7.422681] ... APIC TMCCT: 0003237f
[    7.422681] ... APIC TDCR: 00000003
[    7.422681] ... APIC TDCR: 00000003
[    7.422681]=20
[    7.422681]=20
[    7.440511] number of MP IRQ sources: 15.
[    7.440511] number of MP IRQ sources: 15.
[    7.441242] number of IO-APIC #0 registers: 24.
[    7.441242] number of IO-APIC #0 registers: 24.
[    7.442052] testing the IO APIC.......................
[    7.442052] testing the IO APIC.......................
[    7.442992] IO APIC #0......
[    7.442992] IO APIC #0......
[    7.443535] .... register #00: 00000000
[    7.443535] .... register #00: 00000000
[    7.444244] .......    : physical APIC id: 00
[    7.444244] .......    : physical APIC id: 00
[    7.445032] .......    : Delivery Type: 0
[    7.445032] .......    : Delivery Type: 0
[    7.445791] .......    : LTS          : 0
[    7.445791] .......    : LTS          : 0
[    7.446529] .... register #01: 00170011
[    7.446529] .... register #01: 00170011
[    7.447240] .......     : max redirection entries: 17
[    7.447240] .......     : max redirection entries: 17
[    7.448160] .......     : PRQ implemented: 0
[    7.448160] .......     : PRQ implemented: 0
[    7.448936] .......     : IO APIC version: 11
[    7.448936] .......     : IO APIC version: 11
[    7.449732] .... register #02: 00000000
[    7.449732] .... register #02: 00000000
[    7.450438] .......     : arbitration: 00
[    7.450438] .......     : arbitration: 00
[    7.451166] .... IRQ redirection table:
[    7.451166] .... IRQ redirection table:
[    7.451871] 1    0    0   0   0    0    0    00
[    7.451871] 1    0    0   0   0    0    0    00
[    7.452715] 0    0    0   0   0    1    1    31
[    7.452715] 0    0    0   0   0    1    1    31
[    7.453547] 0    0    0   0   0    1    1    30
[    7.453547] 0    0    0   0   0    1    1    30
[    7.454390] 1    0    0   0   0    1    1    33
[    7.454390] 1    0    0   0   0    1    1    33
[    7.455230] 1    0    0   0   0    1    1    34
[    7.455230] 1    0    0   0   0    1    1    34
[    7.456059] 1    1    0   0   0    1    1    35
[    7.456059] 1    1    0   0   0    1    1    35
[    7.456904] 0    0    0   0   0    1    1    36
[    7.456904] 0    0    0   0   0    1    1    36
[    7.457739] 0    0    0   0   0    1    1    37
[    7.457739] 0    0    0   0   0    1    1    37
[    7.458579] 0    0    0   0   0    1    1    38
[    7.458579] 0    0    0   0   0    1    1    38
[    7.459429] 0    1    0   0   0    1    1    39
[    7.459429] 0    1    0   0   0    1    1    39
[    7.460263] 1    1    0   0   0    1    1    3A
[    7.460263] 1    1    0   0   0    1    1    3A
[    7.461083] 1    1    0   0   0    1    1    3B
[    7.461083] 1    1    0   0   0    1    1    3B
[    7.461931] 0    0    0   0   0    1    1    3C
[    7.461931] 0    0    0   0   0    1    1    3C
[    7.462772] 1    0    0   0   0    1    1    3D
[    7.462772] 1    0    0   0   0    1    1    3D
[    7.463608] 1    0    0   0   0    1    1    3E
[    7.463608] 1    0    0   0   0    1    1    3E
[    7.464441] 1    0    0   0   0    1    1    3F
[    7.464441] 1    0    0   0   0    1    1    3F
[    7.465295] 1    0    0   0   0    0    0    00
[    7.465295] 1    0    0   0   0    0    0    00
[    7.466123] 1    0    0   0   0    0    0    00
[    7.466123] 1    0    0   0   0    0    0    00
[    7.466970] 1    0    0   0   0    0    0    00
[    7.466970] 1    0    0   0   0    0    0    00
[    7.467810] 1    0    0   0   0    0    0    00
[    7.467810] 1    0    0   0   0    0    0    00
[    7.468648] 1    0    0   0   0    0    0    00
[    7.468648] 1    0    0   0   0    0    0    00
[    7.469484] 1    0    0   0   0    0    0    00
[    7.469484] 1    0    0   0   0    0    0    00
[    7.470310] 1    0    0   0   0    0    0    00
[    7.470310] 1    0    0   0   0    0    0    00
[    7.471143] 1    0    0   0   0    0    0    00
[    7.471143] 1    0    0   0   0    0    0    00
[    7.471960] IRQ to pin mappings:
[    7.471960] IRQ to pin mappings:
[    7.472567] IRQ0=20
[    7.472567] IRQ0 -> 0:2-> 0:2

[    7.473053] IRQ1=20
[    7.473053] IRQ1 -> 0:1-> 0:1

[    7.473543] IRQ3=20
[    7.473543] IRQ3 -> 0:3-> 0:3

[    7.474025] IRQ4=20
[    7.474025] IRQ4 -> 0:4-> 0:4

[    7.474515] IRQ5=20
[    7.474515] IRQ5 -> 0:5-> 0:5

[    7.474993] IRQ6=20
[    7.474993] IRQ6 -> 0:6-> 0:6

[    7.475481] IRQ7=20
[    7.475481] IRQ7 -> 0:7-> 0:7

[    7.475976] IRQ8=20
[    7.475976] IRQ8 -> 0:8-> 0:8

[    7.476467] IRQ9=20
[    7.476467] IRQ9 -> 0:9-> 0:9

[    7.476949] IRQ10=20
[    7.476949] IRQ10 -> 0:10-> 0:10

[    7.477473] IRQ11=20
[    7.477473] IRQ11 -> 0:11-> 0:11

[    7.477991] IRQ12=20
[    7.477991] IRQ12 -> 0:12-> 0:12

[    7.478527] IRQ13=20
[    7.478527] IRQ13 -> 0:13-> 0:13

[    7.479050] IRQ14=20
[    7.479050] IRQ14 -> 0:14-> 0:14

[    7.479572] IRQ15=20
[    7.479572] IRQ15 -> 0:15-> 0:15

[    7.480089] .................................... done.
[    7.480089] .................................... done.
[    7.481022] Using IPI Shortcut mode
[    7.481022] Using IPI Shortcut mode
[    7.481789] bootconsole [earlyser0] disabled
[    7.481789] bootconsole [earlyser0] disabled
[    7.482613] Loading compiled-in X.509 certificates
[    7.486073] Btrfs loaded, assert=3Don, integrity-checker=3Don
[    7.486883] Key type trusted registered
[    7.487474] Key type encrypted registered
[    7.488285] hd: no drives specified - use hd=3Dcyl,head,sectors on ker=
nel command line
[    7.489254] rtc_cmos 00:00: setting system clock to 2014-05-30 09:57:2=
6 UTC (1401443846)
[    7.489993] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    7.490555] EDD information not available.
[    7.490999] ### dt-test ### No testcase data in device tree; not runni=
ng tests
[    7.491848]=20
[    7.492350] BUG: spinlock lockup suspected on CPU#0, swapper/1
[    7.492350]  lock: serial8250_ports+0x0/0x4c0, .magic: dead4ead, .owne=
r: swapper/1, .owner_cpu: 0
[    7.492350] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc5-00567-g=
bafe980 #1
[    7.492350]  80038000 80038000 80027a8c 81b9bd30 80027ab4 81b968d0 81e=
b5198 82755f80
[    7.492350]  dead4ead 80038340 00000001 00000000 82755f80 a08b8bfc 800=
27ad0 81077777
[    7.492350]  a08b8bfc 00000000 82755f80 00000086 00000001 80027af0 81b=
aeda4 00000000
[    7.492350] Call Trace:
[    7.492350]  [<81b9bd30>] dump_stack+0x16/0x18
[    7.492350]  [<81b968d0>] spin_dump+0x90/0x97
[    7.492350]  [<81077777>] do_raw_spin_lock+0xa7/0xf0
[    7.492350]  [<81baeda4>] _raw_spin_lock_irqsave+0x54/0x60
[    7.492350]  [<815f652c>] ? serial8250_console_write+0x11c/0x140
[    7.492350]  [<815f6410>] ? serial8250_modem_status+0xc0/0xc0
[    7.492350]  [<815f652c>] serial8250_console_write+0x11c/0x140
[    7.492350]  [<815f6410>] ? serial8250_modem_status+0xc0/0xc0
[    7.492350]  [<8107b534>] call_console_drivers.constprop.20+0x64/0x130=

[    7.492350]  [<8107bcb5>] console_unlock+0x445/0x4d0
[    7.492350]  [<8107be98>] vprintk_emit+0x158/0x4d0
[    7.492350]  [<81b969b9>] printk+0x38/0x3a
[    7.492350]  [<81b95fd0>] print_circular_bug_header+0x35/0xc1
[    7.492350]  [<81b960c6>] print_circular_bug+0x6a/0x268
[    7.492350]  [<810743c2>] __lock_acquire+0x19c2/0x1b20
[    7.492350]  [<81070d18>] ? check_irq_usage+0x88/0xc0
[    7.492350]  [<810750e5>] lock_acquire+0x85/0x190
[    7.492350]  [<8107dc8c>] ? __irq_get_desc_lock+0x3c/0x70
[    7.492350]  [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
[    7.492350]  [<8107dc8c>] ? __irq_get_desc_lock+0x3c/0x70
[    7.492350]  [<8107dc8c>] __irq_get_desc_lock+0x3c/0x70
[    7.492350]  [<8107eb1e>] __disable_irq_nosync+0x1e/0x50
[    7.492350]  [<8107eb58>] disable_irq_nosync+0x8/0x10
[    7.492350]  [<815f5c78>] serial8250_startup+0x488/0x720
[    7.492350]  [<810de6d0>] ? __get_free_pages+0x20/0x40
[    7.492350]  [<815f205e>] uart_startup.part.4+0x6e/0x1e0
[    7.492350]  [<815f2a40>] uart_open+0xe0/0x140
[    7.492350]  [<815f2960>] ? uart_ioctl+0x2f0/0x2f0
[    7.492350]  [<815e4b51>] tty_open+0x141/0x510
[    7.492350]  [<815e4a10>] ? tty_ioctl+0xb20/0xb20
[    7.492350]  [<81118bc0>] chrdev_open+0x60/0x140
[    7.492350]  [<8111372c>] do_dentry_open+0x14c/0x230
[    7.492350]  [<81118b60>] ? exact_lock+0x20/0x20
[    7.492350]  [<8111459e>] finish_open+0x2e/0x40
[    7.492350]  [<8112132a>] do_last+0x4aa/0xd30
[    7.492350]  [<8111f4fd>] ? link_path_walk+0x1dd/0x700
[    7.492350]  [<81121c5a>] path_openat+0xaa/0x610
[    7.492350]  [<811221ec>] do_filp_open+0x2c/0x70
[    7.492350]  [<81114a81>] do_sys_open+0x111/0x210
[    7.492350]  [<81600000>] ? _xfer_secondary_pool+0x150/0x230
[    7.492350]  [<81114b9d>] SyS_open+0x1d/0x20
[    7.492350]  [<8212bda4>] kernel_init_freeable+0x1c6/0x236
[    7.492350]  [<8212b4f2>] ? do_early_param+0x78/0x78
[    7.492350]  [<81b9238b>] kernel_init+0xb/0xd0
[    7.492350]  [<81063b12>] ? schedule_tail+0x12/0x40
[    7.492350]  [<81bb0080>] ret_from_kernel_thread+0x20/0x30
[    7.492350]  [<81b92380>] ? rest_init+0x130/0x130
[    7.492350] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    7.492350] [ INFO: possible circular locking dependency detected ]
[    7.492350] 3.15.0-rc5-00567-gbafe980 #1 Not tainted
[    7.492350] -------------------------------------------------------
[    7.492350] swapper/1 is trying to acquire lock:
[    7.492350]  (&irq_desc_lock_class){-.-...}, at: [<8107dc8c>] __irq_ge=
t_desc_lock+0x3c/0x70
[    7.492350]=20
[    7.492350] but task is already holding lock:
[    7.492350]  (&port_lock_key){......}, at: [<815f5b27>] serial8250_sta=
rtup+0x337/0x720
[    7.492350]=20
[    7.492350] which lock already depends on the new lock.
[    7.492350]=20
[    7.492350]=20
[    7.492350] the existing dependency chain (in reverse order) is:
[    7.492350]=20
-> #2 (&port_lock_key){......}:
[    7.492350]        [<810750e5>] lock_acquire+0x85/0x190
[    7.492350]        [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
[    7.492350]        [<8106eb1c>] down_trylock+0xc/0x30
[    7.492350]        [<8107b795>] console_trylock+0x15/0xb0
[    7.492350]        [<8107be8f>] vprintk_emit+0x14f/0x4d0
[    7.492350]        [<81b969b9>] printk+0x38/0x3a
[    7.492350]        [<82137f78>] print_ICs+0x5b/0x3e7
[    7.492350]        [<8212bb41>] do_one_initcall+0x8b/0x128
[    7.492350]        [<8212bd7d>] kernel_init_freeable+0x19f/0x236
[    7.492350]        [<81b9238b>] kernel_init+0xb/0xd0
[    7.492350]        [<81bb0080>] ret_from_kernel_thread+0x20/0x30
[    7.492350]=20
-> #1 (i8259A_lock){-.....}:
[    7.492350]        [<810750e5>] lock_acquire+0x85/0x190
[    7.492350]        [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
[    7.492350]        [<81005af1>] unmask_8259A_irq+0x11/0x60
[    7.492350]        [<81005b4b>] enable_8259A_irq+0xb/0x10
[    7.492350]        [<8107fffb>] irq_enable+0x2b/0x40
[    7.492350]        [<8108005d>] irq_startup+0x4d/0x60
[    7.492350]        [<8107f2bc>] __setup_irq+0x39c/0x460
[    7.492350]        [<8107f433>] setup_irq+0x33/0x80
[    7.492350]        [<8212db15>] setup_default_timer_irq+0xf/0x11
[    7.492350]        [<8212db2d>] hpet_time_init+0x16/0x18
[    7.492350]        [<8212daff>] x86_late_time_init+0x9/0x10
[    7.492350]        [<8212ba3d>] start_kernel+0x331/0x3aa
[    7.492350]        [<8212b380>] i386_start_kernel+0x12e/0x131
[    7.492350]=20
-> #0 (&irq_desc_lock_class){-.-...}:
[    7.492350]        [<810743c2>] __lock_acquire+0x19c2/0x1b20
[    7.492350]        [<810750e5>] lock_acquire+0x85/0x190
[    7.492350]        [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
[    7.492350]        [<8107dc8c>] __irq_get_desc_lock+0x3c/0x70
[    7.492350]        [<8107eb1e>] __disable_irq_nosync+0x1e/0x50
[    7.492350]        [<8107eb58>] disable_irq_nosync+0x8/0x10
[    7.492350]        [<815f5c78>] serial8250_startup+0x488/0x720
[    7.492350]        [<815f205e>] uart_startup.part.4+0x6e/0x1e0
[    7.492350]        [<815f2a40>] uart_open+0xe0/0x140
[    7.492350]        [<815e4b51>] tty_open+0x141/0x510
[    7.492350]        [<81118bc0>] chrdev_open+0x60/0x140
[    7.492350]        [<8111372c>] do_dentry_open+0x14c/0x230
[    7.492350]        [<8111459e>] finish_open+0x2e/0x40
[    7.492350]        [<8112132a>] do_last+0x4aa/0xd30
[    7.492350]        [<81121c5a>] path_openat+0xaa/0x610
[    7.492350]        [<811221ec>] do_filp_open+0x2c/0x70
[    7.492350]        [<81114a81>] do_sys_open+0x111/0x210
[    7.492350]        [<81114b9d>] SyS_open+0x1d/0x20
[    7.492350]        [<8212bda4>] kernel_init_freeable+0x1c6/0x236
[    7.492350]        [<81b9238b>] kernel_init+0xb/0xd0
[    7.492350]        [<81bb0080>] ret_from_kernel_thread+0x20/0x30
[    7.492350]=20
[    7.492350] other info that might help us debug this:
[    7.492350]=20
[    7.492350] Chain exists of:
  &irq_desc_lock_class --> i8259A_lock --> &port_lock_key

[    7.492350]  Possible unsafe locking scenario:
[    7.492350]=20
[    7.492350]        CPU0                    CPU1
[    7.492350]        ----                    ----
[    7.492350]   lock(&port_lock_key);
[    7.492350]                                lock(i8259A_lock);
[    7.492350]                                lock(&port_lock_key);
[    7.492350]   lock(&irq_desc_lock_class);
[    7.492350]=20
[    7.492350]  *** DEADLOCK ***
[    7.492350]=20
[    7.492350] 3 locks held by swapper/1:
[    7.492350]  #0:  (&tty->legacy_mutex){+.+.+.}, at: [<81baf736>] tty_l=
ock_nested+0x36/0x80
[    7.492350]  #1:  (&port->mutex){+.+.+.}, at: [<815f2991>] uart_open+0=
x31/0x140
[    7.492350]  #2:  (&port_lock_key){......}, at: [<815f5b27>] serial825=
0_startup+0x337/0x720
[    7.492350]=20
[    7.492350] stack backtrace:
[    7.492350] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc5-00567-g=
bafe980 #1
[    7.492350]  82412ea0 82412ea0 80027be4 81b9bd30 80027c10 81b962ba 81e=
bd41a 82413720
[    7.492350]  80038534 00000003 82634380 80038000 80038534 00000003 000=
00002 80027c88
[    7.492350]  810743c2 8003851c 8003851c 80027c44 81070d18 00001bd9 000=
00000 00000004
[    7.492350] Call Trace:
[    7.492350]  [<81b9bd30>] dump_stack+0x16/0x18
[    7.492350]  [<81b962ba>] print_circular_bug+0x25e/0x268
[    7.492350]  [<810743c2>] __lock_acquire+0x19c2/0x1b20
[    7.492350]  [<81070d18>] ? check_irq_usage+0x88/0xc0
[    7.492350]  [<810750e5>] lock_acquire+0x85/0x190
[    7.492350]  [<8107dc8c>] ? __irq_get_desc_lock+0x3c/0x70
[    7.492350]  [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
[    7.492350]  [<8107dc8c>] ? __irq_get_desc_lock+0x3c/0x70
[    7.492350]  [<8107dc8c>] __irq_get_desc_lock+0x3c/0x70
[    7.492350]  [<8107eb1e>] __disable_irq_nosync+0x1e/0x50
[    7.492350]  [<8107eb58>] disable_irq_nosync+0x8/0x10
[    7.492350]  [<815f5c78>] serial8250_startup+0x488/0x720
[    7.492350]  [<810de6d0>] ? __get_free_pages+0x20/0x40
[    7.492350]  [<815f205e>] uart_startup.part.4+0x6e/0x1e0
[    7.492350]  [<815f2a40>] uart_open+0xe0/0x140
[    7.492350]  [<815f2960>] ? uart_ioctl+0x2f0/0x2f0
[    7.492350]  [<815e4b51>] tty_open+0x141/0x510
[    7.492350]  [<815e4a10>] ? tty_ioctl+0xb20/0xb20
[    7.492350]  [<81118bc0>] chrdev_open+0x60/0x140
[    7.492350]  [<8111372c>] do_dentry_open+0x14c/0x230
[    7.492350]  [<81118b60>] ? exact_lock+0x20/0x20
[    7.492350]  [<8111459e>] finish_open+0x2e/0x40
[    7.492350]  [<8112132a>] do_last+0x4aa/0xd30
[    7.492350]  [<8111f4fd>] ? link_path_walk+0x1dd/0x700
[    7.492350]  [<81121c5a>] path_openat+0xaa/0x610
[    7.492350]  [<811221ec>] do_filp_open+0x2c/0x70
[    7.492350]  [<81114a81>] do_sys_open+0x111/0x210
[    7.492350]  [<81600000>] ? _xfer_secondary_pool+0x150/0x230
[    7.492350]  [<81114b9d>] SyS_open+0x1d/0x20
[    7.492350]  [<8212bda4>] kernel_init_freeable+0x1c6/0x236
[    7.492350]  [<8212b4f2>] ? do_early_param+0x78/0x78
[    7.492350]  [<81b9238b>] kernel_init+0xb/0xd0
[    7.492350]  [<81063b12>] ? schedule_tail+0x12/0x40
[    7.492350]  [<81bb0080>] ret_from_kernel_thread+0x20/0x30
[    7.492350]  [<81b92380>] ? rest_init+0x130/0x130
[   78.177434] Freeing unused kernel memory: 736K (8212b000 - 821e3000)
/etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: No such file or directory

Please wait: booting...
Starting udev
error initializing inotify
error sending message: Connection refused
error sending message: Connection refused
Starting Bootlog daemon: bootlogd: cannot find console device 4:64 under =
/dev
bootlogd.
[   78.215246] gfs2: path_lookup on rootfs returned error -2
Configuring network interfaces... ifconfig: socket: Address family not su=
pported by protocol
done.
hwclock: can't open '/dev/misc/rtc': No such file or directory
Running postinst /etc/rpm-postinsts/100...

Elapsed time: 80
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig=
-ib0-05300841/bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0/vmlinuz-3.15.0-rc5=
-00567-gbafe980 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 d=
ebug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D1=
00 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D=
0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw=
 link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ib0-05300841/next:mas=
ter:bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0:bisect-linux2/.vmlinuz-bafe9=
80f5afc7ccc693fd8c81c8aa5a02fbb5ae0-20140530095827-2-ivb42 branch=3Dnext/=
master BOOT_IMAGE=3D/kernel/i386-randconfig-ib0-05300841/bafe980f5afc7ccc=
693fd8c81c8aa5a02fbb5ae0/vmlinuz-3.15.0-rc5-00567-gbafe980 drbd.minor_cou=
nt=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-i386.cgz -m 320 -smp =
2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no=
-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/=
pid-yocto-ivb42-1 -serial file:/dev/shm/kboot/serial-yocto-ivb42-1 -daemo=
nize -display none -monitor null=20


--------------040306070508090709090006
Content-Type: application/octet-stream;
 name="i386-randconfig-ib0-05300841-07dd999f99b1135fdece697e17c4f4248ab40f72-BUG:-spinlock-lockup-suspected-on-CPU---29720.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="i386-randconfig-ib0-05300841-07dd999f99b1135fdece697e17c4f42";
 filename*1="48ab40f72-BUG:-spinlock-lockup-suspected-on-CPU---29720.log"

SEVBRCBpcyBub3cgYXQgMDdkZDk5OS4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxl
cyBmb3IgMjAxNDA1MjkKZ2l0IGNoZWNrb3V0IDUzYTRmZGI0YTdjOGFlZWY5NzdmODQ1MGJj
ZGI5MmQxOTYyZTMyMWUKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvbmV4dDptYXN0ZXI6NTNhNGZkYjRhN2M4YWVlZjk3
N2Y4NDUwYmNkYjkyZDE5NjJlMzIxZTpiaXNlY3QtbGludXgyCgoyMDE0LTA1LTMwLTA4OjQ5
OjU1IDUzYTRmZGI0YTdjOGFlZWY5NzdmODQ1MGJjZGI5MmQxOTYyZTMyMWUgY29tcGlsaW5n
ClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1y
YW5kY29uZmlnLWliMC0wNTMwMDg0MS01M2E0ZmRiNGE3YzhhZWVmOTc3Zjg0NTBiY2RiOTJk
MTk2MmUzMjFlCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aWIwLTA1MzAwODQxLzUzYTRmZGI0YTdjOGFlZWY5NzdmODQ1MGJjZGI5MmQxOTYyZTMyMWUK
d2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kz
ODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEtNTNhNGZkYjRhN2M4YWVlZjk3N2Y4NDUwYmNk
YjkyZDE5NjJlMzIxZQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEtNTNhNGZkYjRhN2M4
YWVlZjk3N2Y4NDUwYmNkYjkyZDE5NjJlMzIxZQprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWliMC0wNTMwMDg0MS81M2E0ZmRiNGE3YzhhZWVmOTc3Zjg0NTBiY2RiOTJkMTk2
MmUzMjFlL3ZtbGludXotMy4xNS4wLXJjNy0xMDI5MS1nNTNhNGZkYgoKMjAxNC0wNS0zMC0w
OTowMjo1NSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTQJMjAgU1VDQ0VTUwoKYmlzZWN0OiBn
b29kIGNvbW1pdCA1M2E0ZmRiNGE3YzhhZWVmOTc3Zjg0NTBiY2RiOTJkMTk2MmUzMjFlCmdp
dCBiaXNlY3Qgc3RhcnQgMDdkZDk5OWY5OWIxMTM1ZmRlY2U2OTdlMTdjNGY0MjQ4YWI0MGY3
MiA1M2E0ZmRiNGE3YzhhZWVmOTc3Zjg0NTBiY2RiOTJkMTk2MmUzMjFlIC0tCi9jL2tlcm5l
bC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgIjA3ZGQ5OTlmOTliMTEzNWZkZWNlNjk3
ZTE3YzRmNDI0OGFiNDBmNzIiLCAiLWciLCAiNTNhNGZkYjRhN2M4YWVlZjk3N2Y4NDUwYmNk
YjkyZDE5NjJlMzIxZSIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIiwgIi9jL2Jvb3QtYmlzZWN0L2xpbnV4Mi9vYmotYmlzZWN0Il0KQmlzZWN0aW5n
OiA1NjQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0
ZXBzKQpbNTRhZjYxZGIxMDMxYzdkZGVmMDE2OTg3ZTk5MzhjYmJiYWY5Mjk2OF0gTWVyZ2Ug
YnJhbmNoICdha3BtLWN1cnJlbnQvY3VycmVudCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4Mi9vYmot
YmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctaWIwLTA1MzAwODQxL25leHQ6bWFzdGVyOjU0YWY2MWRiMTAzMWM3ZGRlZjAxNjk4N2U5
OTM4Y2JiYmFmOTI5Njg6YmlzZWN0LWxpbnV4MgoKMjAxNC0wNS0zMC0wOTowNDoyNiA1NGFm
NjFkYjEwMzFjN2RkZWYwMTY5ODdlOTkzOGNiYmJhZjkyOTY4IGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1pYjAtMDUzMDA4NDEtNTRhZjYxZGIxMDMxYzdkZGVmMDE2OTg3ZTk5MzhjYmJiYWY5Mjk2
OApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMw
MDg0MS81NGFmNjFkYjEwMzFjN2RkZWYwMTY5ODdlOTkzOGNiYmJhZjkyOTY4CndhaXRpbmcg
Zm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctaWIwLTA1MzAwODQxLTU0YWY2MWRiMTAzMWM3ZGRlZjAxNjk4N2U5OTM4Y2JiYmFm
OTI5NjgKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlLy5pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLTU0YWY2MWRiMTAzMWM3ZGRlZjAx
Njk4N2U5OTM4Y2JiYmFmOTI5NjgKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1p
YjAtMDUzMDA4NDEvNTRhZjYxZGIxMDMxYzdkZGVmMDE2OTg3ZTk5MzhjYmJiYWY5Mjk2OC92
bWxpbnV6LTMuMTUuMC1yYzctMTA3NzAtZzU0YWY2MWQKCjIwMTQtMDUtMzAtMDk6MTE6MjYg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4gVEVTVCBGQUlMVVJFClsgICAgMy4wMTg4ODRdIEVE
RCBpbmZvcm1hdGlvbiBub3QgYXZhaWxhYmxlLgpbICAgIDMuMDE5MzE4XSAjIyMgZHQtdGVz
dCAjIyMgTm8gdGVzdGNhc2UgZGF0YSBpbiBkZXZpY2UgdHJlZTsgbm90IHJ1bm5pbmcgdGVz
dHMKWyAgICAzLjAyMDE0Ml0gClsgICAgMy4wMjA2ODJdIEJVRzogc3BpbmxvY2sgbG9ja3Vw
IHN1c3BlY3RlZCBvbiBDUFUjMCwgc3dhcHBlci8xClsgICAgMy4wMjA2ODJdICBsb2NrOiBz
ZXJpYWw4MjUwX3BvcnRzKzB4MC8weDRjMCwgLm1hZ2ljOiBkZWFkNGVhZCwgLm93bmVyOiBz
d2FwcGVyLzEsIC5vd25lcl9jcHU6IDAKWyAgICAzLjAyMDY4Ml0gQ1BVOiAwIFBJRDogMSBD
b21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTUuMC1yYzctMTA3NzAtZzU0YWY2MWQgIzEK
WyAgICAzLjAyMDY4Ml0gIDgwMDQwMDAwIDgwMDQwMDAwIDgwMDI3YTdjIDgxYmIxOTgwIDgw
MDI3YWE0IDgxYmFjNTcwIDgxZWRmNzU4IDgyYTI1NGUwClsgICAgMy4wMjA2ODJdICBkZWFk
NGVhZCA4MDA0MDM0NCAwMDAwMDAwMSAwMDAwMDAwMCA4MmEyNTRlMCBhMDhhYTlkMCA4MDAy
N2FjMCA4MTA3N2UzNwpbICAgIDMuMDIwNjgyXSAgYTA4YWE5ZDAgMDAwMDAwMDAgODJhMjU0
ZTAgMDAwMDAwODIgMDAwMDAwMDEgODAwMjdhZTAgODFiYzQ2ZjQgMDAwMDAwMDAKWyAgICAz
LjAyMDY4Ml0gQ2FsbCBUcmFjZToKWyAgICAzLjAyMDY4Ml0gIFs8ODFiYjE5ODA+XSBkdW1w
X3N0YWNrKzB4MTYvMHgxOApbICAgIDMuMDIwNjgyXSAgWzw4MWJhYzU3MD5dIHNwaW5fZHVt
cCsweDkwLzB4OTcKWyAgICAzLjAyMDY4Ml0gIFs8ODEwNzdlMzc+XSBkb19yYXdfc3Bpbl9s
b2NrKzB4YTcvMHhmMApbICAgIDMuMDIwNjgyXSAgWzw4MWJjNDZmND5dIF9yYXdfc3Bpbl9s
b2NrX2lycXNhdmUrMHg1NC8weDYwClsgICAgMy4wMjA2ODJdICBbPDgxNWZjZmNjPl0gPyBz
ZXJpYWw4MjUwX2NvbnNvbGVfd3JpdGUrMHgxMWMvMHgxNDAKWyAgICAzLjAyMDY4Ml0gIFs8
ODE1ZmNlYjA+XSA/IHNlcmlhbDgyNTBfbW9kZW1fc3RhdHVzKzB4YzAvMHhjMApbICAgIDMu
MDIwNjgyXSAgWzw4MTVmY2ZjYz5dIHNlcmlhbDgyNTBfY29uc29sZV93cml0ZSsweDExYy8w
eDE0MApbICAgIDMuMDIwNjgyXSAgWzw4MTVmY2ViMD5dID8gc2VyaWFsODI1MF9tb2RlbV9z
dGF0dXMrMHhjMC8weGMwClsgICAgMy4wMjA2ODJdICBbPDgxMDdiY2U0Pl0gY2FsbF9jb25z
b2xlX2RyaXZlcnMuY29uc3Rwcm9wLjIwKzB4NjQvMHgxMzAKWyAgICAzLjAyMDY4Ml0gIFs8
ODEwN2M0YmQ+XSBjb25zb2xlX3VubG9jaysweDQ5ZC8weDUzMApbICAgIDMuMDIwNjgyXSAg
Wzw4MTA3YzdjZD5dIHZwcmludGtfZW1pdCsweDI3ZC8weDU0MApbICAgIDMuMDIwNjgyXSAg
Wzw4MWJhYzY1OT5dIHByaW50aysweDM4LzB4M2EKWyAgICAzLjAyMDY4Ml0gIFs8ODFiYWJj
NzA+XSBwcmludF9jaXJjdWxhcl9idWdfaGVhZGVyKzB4MzUvMHhjMQpbICAgIDMuMDIwNjgy
XSAgWzw4MWJhYmQ2Nj5dIHByaW50X2NpcmN1bGFyX2J1ZysweDZhLzB4MjY4ClsgICAgMy4w
MjA2ODJdICBbPDgxMDc0YTgyPl0gX19sb2NrX2FjcXVpcmUrMHgxOWMyLzB4MWIyMApbICAg
IDMuMDIwNjgyXSAgWzw4MTA3MTNkOD5dID8gY2hlY2tfaXJxX3VzYWdlKzB4ODgvMHhjMApb
ICAgIDMuMDIwNjgyXSAgWzw4MTA3NTdhNT5dIGxvY2tfYWNxdWlyZSsweDg1LzB4MTkwClsg
ICAgMy4wMjA2ODJdICBbPDgxMDdlNThjPl0gPyBfX2lycV9nZXRfZGVzY19sb2NrKzB4M2Mv
MHg3MApbICAgIDMuMDIwNjgyXSAgWzw4MWJjNDZlZD5dIF9yYXdfc3Bpbl9sb2NrX2lycXNh
dmUrMHg0ZC8weDYwClsgICAgMy4wMjA2ODJdICBbPDgxMDdlNThjPl0gPyBfX2lycV9nZXRf
ZGVzY19sb2NrKzB4M2MvMHg3MApbICAgIDMuMDIwNjgyXSAgWzw4MTA3ZTU4Yz5dIF9faXJx
X2dldF9kZXNjX2xvY2srMHgzYy8weDcwClsgICAgMy4wMjA2ODJdICBbPDgxMDdmMzdlPl0g
X19kaXNhYmxlX2lycV9ub3N5bmMrMHgxZS8weDUwClsgICAgMy4wMjA2ODJdICBbPDgxMDdm
M2I4Pl0gZGlzYWJsZV9pcnFfbm9zeW5jKzB4OC8weDEwClsgICAgMy4wMjA2ODJdICBbPDgx
NWZjNzE4Pl0gc2VyaWFsODI1MF9zdGFydHVwKzB4NDg4LzB4NzIwClsgICAgMy4wMjA2ODJd
ICBbPDgxMGRmZjkwPl0gPyBfX2dldF9mcmVlX3BhZ2VzKzB4MjAvMHg0MApbICAgIDMuMDIw
NjgyXSAgWzw4MTVmOGFmZT5dIHVhcnRfc3RhcnR1cC5wYXJ0LjQrMHg2ZS8weDFlMApbICAg
IDMuMDIwNjgyXSAgWzw4MTVmOTRlMD5dIHVhcnRfb3BlbisweGUwLzB4MTQwClsgICAgMy4w
MjA2ODJdICBbPDgxNWY5NDAwPl0gPyB1YXJ0X2lvY3RsKzB4MmYwLzB4MmYwClsgICAgMy4w
MjA2ODJdICBbPDgxNWViNWYxPl0gdHR5X29wZW4rMHgxNDEvMHg1MTAKWyAgICAzLjAyMDY4
Ml0gIFs8ODE1ZWI0YjA+XSA/IHR0eV9pb2N0bCsweGIyMC8weGIyMApbICAgIDMuMDIwNjgy
XSAgWzw4MTExYTllMD5dIGNocmRldl9vcGVuKzB4NjAvMHgxNDAKWyAgICAzLjAyMDY4Ml0g
IFs8ODExMTUyM2Y+XSBkb19kZW50cnlfb3BlbisweDlmLzB4MjgwClsgICAgMy4wMjA2ODJd
ICBbPDgxMTFhOTgwPl0gPyBleGFjdF9sb2NrKzB4MjAvMHgyMApbICAgIDMuMDIwNjgyXSAg
Wzw4MTExNjFhZT5dIGZpbmlzaF9vcGVuKzB4MmUvMHg0MApbICAgIDMuMDIwNjgyXSAgWzw4
MTEyMmYwYT5dIGRvX2xhc3QrMHg0YWEvMHhkMzAKWyAgICAzLjAyMDY4Ml0gIFs8ODExMjEw
ZGQ+XSA/IGxpbmtfcGF0aF93YWxrKzB4MWRkLzB4NzAwClsgICAgMy4wMjA2ODJdICBbPDgx
MTIzODNhPl0gcGF0aF9vcGVuYXQrMHhhYS8weDYxMApbICAgIDMuMDIwNjgyXSAgWzw4MTEy
M2RjYz5dIGRvX2ZpbHBfb3BlbisweDJjLzB4NzAKWyAgICAzLjAyMDY4Ml0gIFs8ODExMTY2
OTE+XSBkb19zeXNfb3BlbisweDExMS8weDIxMApbICAgIDMuMDIwNjgyXSAgWzw4MTYwMDAw
MD5dID8gcGNpc2VyaWFsX3JlbW92ZV9vbmUrMHgxMC8weDIwClsgICAgMy4wMjA2ODJdICBb
PDgxMTE2N2FkPl0gU3lTX29wZW4rMHgxZC8weDIwClsgICAgMy4wMjA2ODJdICBbPDgyMTU2
ZjFiPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHgxYzYvMHgyMzYKWyAgICAzLjAyMDY4Ml0g
IFs8ODIxNTY1NzM+XSA/IGluaXRjYWxsX2JsYWNrbGlzdCsweDgxLzB4ODEKWyAgICAzLjAy
MDY4Ml0gIFs8ODFiYThmNmI+XSBrZXJuZWxfaW5pdCsweGIvMHhkMApbICAgIDMuMDIwNjgy
XSAgWzw4MTA2NDBmMj5dID8gc2NoZWR1bGVfdGFpbCsweDEyLzB4NDAKWyAgICAzLjAyMDY4
Ml0gIFs8ODFiYzUyMDA+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjAvMHgzMApbICAg
IDMuMDIwNjgyXSAgWzw4MWJhOGY2MD5dID8gcmVzdF9pbml0KzB4MTMwLzB4MTMwClsgICAg
My4wMjA2ODJdID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvNTRhZjYx
ZGIxMDMxYzdkZGVmMDE2OTg3ZTk5MzhjYmJiYWY5Mjk2OC9kbWVzZy1xdWFudGFsLWl2YjQy
LTUwOjIwMTQwNTMwMDkxMDUyOmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4w
LXJjNy0xMDc3MC1nNTRhZjYxZDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMw
MDg0MS81NGFmNjFkYjEwMzFjN2RkZWYwMTY5ODdlOTkzOGNiYmJhZjkyOTY4L2RtZXNnLXF1
YW50YWwtaXZiNDMtMTQ6MjAxNDA1MzAwOTEyMDM6aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMw
MDg0MTozLjE1LjAtcmM3LTEwNzcwLWc1NGFmNjFkOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaWIwLTA1MzAwODQxLzU0YWY2MWRiMTAzMWM3ZGRlZjAxNjk4N2U5OTM4Y2JiYmFmOTI5
NjgvZG1lc2ctcXVhbnRhbC1pdmI0My04MToyMDE0MDUzMDA5MTIwMzppMzg2LXJhbmRjb25m
aWctaWIwLTA1MzAwODQxOjMuMTUuMC1yYzctMTA3NzAtZzU0YWY2MWQ6MQova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvNTRhZjYxZGIxMDMxYzdkZGVmMDE2OTg3ZTk5
MzhjYmJiYWY5Mjk2OC9kbWVzZy1xdWFudGFsLWl2YjQxLTEwNDoyMDE0MDUzMDA5MTIwODpp
Mzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxOjMuMTUuMC1yYzctMTA3NzAtZzU0YWY2MWQ6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvNTRhZjYxZGIxMDMxYzdk
ZGVmMDE2OTg3ZTk5MzhjYmJiYWY5Mjk2OC9kbWVzZy1xdWFudGFsLWl2YjQxLTE3OjIwMTQw
NTMwMDkxMjAzOmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4wLXJjNy0xMDc3
MC1nNTRhZjYxZDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS81NGFm
NjFkYjEwMzFjN2RkZWYwMTY5ODdlOTkzOGNiYmJhZjkyOTY4L2RtZXNnLXF1YW50YWwtaXZi
NDItMzc6MjAxNDA1MzAwOTEwNTU6aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MTozLjE1
LjAtcmM3LTEwNzcwLWc1NGFmNjFkOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIwLTA1
MzAwODQxLzU0YWY2MWRiMTAzMWM3ZGRlZjAxNjk4N2U5OTM4Y2JiYmFmOTI5NjgvZG1lc2ct
cXVhbnRhbC1pdmI0My04MDoyMDE0MDUzMDA5MTIwNzppMzg2LXJhbmRjb25maWctaWIwLTA1
MzAwODQxOjMuMTUuMC1yYzctMTA3NzAtZzU0YWY2MWQ6MQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pYjAtMDUzMDA4NDEvNTRhZjYxZGIxMDMxYzdkZGVmMDE2OTg3ZTk5MzhjYmJiYWY5
Mjk2OC9kbWVzZy1xdWFudGFsLWl2YjQ0LTExMDoyMDE0MDUzMDA5MTA0ODppMzg2LXJhbmRj
b25maWctaWIwLTA1MzAwODQxOjMuMTUuMC1yYzctMTA3NzAtZzU0YWY2MWQ6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvNTRhZjYxZGIxMDMxYzdkZGVmMDE2OTg3
ZTk5MzhjYmJiYWY5Mjk2OC9kbWVzZy1xdWFudGFsLWl2YjQ0LTU6MjAxNDA1MzAwOTEwNDg6
aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MTozLjE1LjAtcmM3LTEwNzcwLWc1NGFmNjFk
OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLzU0YWY2MWRiMTAzMWM3
ZGRlZjAxNjk4N2U5OTM4Y2JiYmFmOTI5NjgvZG1lc2cteW9jdG8taXZiNDEtMjQ6MjAxNDA1
MzAwOTEyMDc6aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MTozLjE1LjAtcmM3LTEwNzcw
LWc1NGFmNjFkOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLzU0YWY2
MWRiMTAzMWM3ZGRlZjAxNjk4N2U5OTM4Y2JiYmFmOTI5NjgvZG1lc2cteW9jdG8taXZiNDEt
NjM6MjAxNDA1MzAwOTEyMDU6aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MTozLjE1LjAt
cmM3LTEwNzcwLWc1NGFmNjFkOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAw
ODQxLzU0YWY2MWRiMTAzMWM3ZGRlZjAxNjk4N2U5OTM4Y2JiYmFmOTI5NjgvZG1lc2cteW9j
dG8taXZiNDEtODQ6MjAxNDA1MzAwOTEyMDQ6aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0
MTozLjE1LjAtcmM3LTEwNzcwLWc1NGFmNjFkOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aWIwLTA1MzAwODQxLzU0YWY2MWRiMTAzMWM3ZGRlZjAxNjk4N2U5OTM4Y2JiYmFmOTI5Njgv
ZG1lc2cteW9jdG8taXZiNDEtOTE6MjAxNDA1MzAwOTEyMDM6aTM4Ni1yYW5kY29uZmlnLWli
MC0wNTMwMDg0MTozLjE1LjAtcmM3LTEwNzcwLWc1NGFmNjFkOjEKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaWIwLTA1MzAwODQxLzU0YWY2MWRiMTAzMWM3ZGRlZjAxNjk4N2U5OTM4Y2Ji
YmFmOTI5NjgvZG1lc2cteW9jdG8taXZiNDItMTM6MjAxNDA1MzAwOTExMDI6aTM4Ni1yYW5k
Y29uZmlnLWliMC0wNTMwMDg0MTozLjE1LjAtcmM3LTEwNzcwLWc1NGFmNjFkOjEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLzU0YWY2MWRiMTAzMWM3ZGRlZjAxNjk4
N2U5OTM4Y2JiYmFmOTI5NjgvZG1lc2cteW9jdG8taXZiNDItMjI6MjAxNDA1MzAwOTEwNTY6
aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MTozLjE1LjAtcmM3LTEwNzcwLWc1NGFmNjFk
OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLzU0YWY2MWRiMTAzMWM3
ZGRlZjAxNjk4N2U5OTM4Y2JiYmFmOTI5NjgvZG1lc2cteW9jdG8taXZiNDMtMTE3OjIwMTQw
NTMwMDkxMjE0OmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4wLXJjNy0xMDc3
MC1nNTRhZjYxZDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS81NGFm
NjFkYjEwMzFjN2RkZWYwMTY5ODdlOTkzOGNiYmJhZjkyOTY4L2RtZXNnLXlvY3RvLWl2YjQ0
LTM4OjIwMTQwNTMwMDkxMDQ4OmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4w
LXJjNy0xMDc3MC1nNTRhZjYxZDoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMw
MDg0MS81NGFmNjFkYjEwMzFjN2RkZWYwMTY5ODdlOTkzOGNiYmJhZjkyOTY4L2RtZXNnLXlv
Y3RvLWl2YjQ0LTQ0OjIwMTQwNTMwMDkxMDQ4OmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4
NDE6My4xNS4wLXJjNy0xMDc3MC1nNTRhZjYxZDoxCjA6MTg6MTggYWxsX2dvb2Q6YmFkOmFs
bF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDUtMzAgMDk6MTI6MjcgUkVQRUFUIENPVU5UOiAy
MCAgIyAvYy9ib290LWJpc2VjdC9saW51eDIvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKbGlu
ZWFyLWJpc2VjdDogYmFkIGJyYW5jaCBtYXkgYmUgYnJhbmNoICdha3BtLWN1cnJlbnQvY3Vy
cmVudCcKbGluZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXIt
YmlzZWN0OiBnaXQgYmlzZWN0IHN0YXJ0IDU0YWY2MWRiMTAzMWM3ZGRlZjAxNjk4N2U5OTM4
Y2JiYmFmOTI5NjggNTNhNGZkYjRhN2M4YWVlZjk3N2Y4NDUwYmNkYjkyZDE5NjJlMzIxZSAt
LQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyA1NGFmNjFkLi4uIE1lcmdlIGJyYW5jaCAn
YWtwbS1jdXJyZW50L2N1cnJlbnQnCkhFQUQgaXMgbm93IGF0IDNiMTY5OTAuLi4gTWVyZ2Ug
cmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnc3RhZ2luZy9zdGFnaW5nLW5leHQnCkJpc2VjdGlu
ZzogMjM5IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0
ZXBzKQpbZDkzZThkYmI2YzJjZDJmZGU4ZDQ2ZTFhZDEyZDE5ZmZhMTg2ODc0N10gbW06IHBh
Z2VfYWxsb2M6IHVzZSB1bnNpZ25lZCBpbnQgZm9yIG9yZGVyIGluIG1vcmUgcGxhY2VzCmxp
bmVhci1iaXNlY3Q6IGdpdCBiaXNlY3QgcnVuIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgyL29iai1iaXNlY3QKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4Mi9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxL25leHQ6bWFzdGVyOmQ5M2U4
ZGJiNmMyY2QyZmRlOGQ0NmUxYWQxMmQxOWZmYTE4Njg3NDc6YmlzZWN0LWxpbnV4MgoKMjAx
NC0wNS0zMC0wOToxMjozMyBkOTNlOGRiYjZjMmNkMmZkZThkNDZlMWFkMTJkMTlmZmExODY4
NzQ3IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEtZDkzZThkYmI2YzJjZDJmZGU4
ZDQ2ZTFhZDEyZDE5ZmZhMTg2ODc0NwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS9kOTNlOGRiYjZjMmNkMmZkZThkNDZlMWFkMTJk
MTlmZmExODY4NzQ3CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLWQ5M2U4ZGJiNmMyY2Qy
ZmRlOGQ0NmUxYWQxMmQxOWZmYTE4Njg3NDcKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQx
LWQ5M2U4ZGJiNmMyY2QyZmRlOGQ0NmUxYWQxMmQxOWZmYTE4Njg3NDcKa2VybmVsOiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvZDkzZThkYmI2YzJjZDJmZGU4ZDQ2
ZTFhZDEyZDE5ZmZhMTg2ODc0Ny92bWxpbnV6LTMuMTUuMC1yYzUtMDA1MDktZ2Q5M2U4ZGIK
CjIwMTQtMDUtMzAtMDk6MTc6MzMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMTAJMjAgU1VD
Q0VTUwoKQmlzZWN0aW5nOiAxMTkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDcgc3RlcHMpCls3ZmY2MDQ2OWU2M2YyYmQxMTA1ODJjZGY4YmE5NWFmYTY5
NGJmN2M2XSBydGM6IHJ0Yy1tdjogbWFrZSBvZl9kZXZpY2VfaWQgYXJyYXkgY29uc3QKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jv
b3QtYmlzZWN0L2xpbnV4Mi9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1
ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxL25leHQ6bWFzdGVyOjdmZjYw
NDY5ZTYzZjJiZDExMDU4MmNkZjhiYTk1YWZhNjk0YmY3YzY6YmlzZWN0LWxpbnV4MgoKMjAx
NC0wNS0zMC0wOToxOTozNCA3ZmY2MDQ2OWU2M2YyYmQxMTA1ODJjZGY4YmE5NWFmYTY5NGJm
N2M2IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEtN2ZmNjA0NjllNjNmMmJkMTEw
NTgyY2RmOGJhOTVhZmE2OTRiZjdjNgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS83ZmY2MDQ2OWU2M2YyYmQxMTA1ODJjZGY4YmE5
NWFmYTY5NGJmN2M2CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLTdmZjYwNDY5ZTYzZjJi
ZDExMDU4MmNkZjhiYTk1YWZhNjk0YmY3YzYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQx
LTdmZjYwNDY5ZTYzZjJiZDExMDU4MmNkZjhiYTk1YWZhNjk0YmY3YzYKa2VybmVsOiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvN2ZmNjA0NjllNjNmMmJkMTEwNTgy
Y2RmOGJhOTVhZmE2OTRiZjdjNi92bWxpbnV6LTMuMTUuMC1yYzUtMDA2MjktZzdmZjYwNDYK
CjIwMTQtMDUtMzAtMDk6MjI6MzQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uIFRFU1QgRkFJ
TFVSRQpbICAgIDMuMDE2MjI2XSBFREQgaW5mb3JtYXRpb24gbm90IGF2YWlsYWJsZS4KWyAg
ICAzLjAxNjY2Nl0gIyMjIGR0LXRlc3QgIyMjIE5vIHRlc3RjYXNlIGRhdGEgaW4gZGV2aWNl
IHRyZWU7IG5vdCBydW5uaW5nIHRlc3RzClsgICAgMy4wMTc0OTFdIApbICAgIDMuMDE4MDI5
XSBCVUc6IHNwaW5sb2NrIGxvY2t1cCBzdXNwZWN0ZWQgb24gQ1BVIzAsIHN3YXBwZXIvMQpb
ICAgIDMuMDE4MDI5XSAgbG9jazogc2VyaWFsODI1MF9wb3J0cysweDAvMHg0YzAsIC5tYWdp
YzogZGVhZDRlYWQsIC5vd25lcjogc3dhcHBlci8xLCAub3duZXJfY3B1OiAwClsgICAgMy4w
MTgwMjldIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE1LjAt
cmM1LTAwNjI5LWc3ZmY2MDQ2ICMxClsgICAgMy4wMTgwMjldICA4MDAzODAwMCA4MDAzODAw
MCA4MDAyN2E3YyA4MWI5YzA0OCA4MDAyN2FhNCA4MWI5NmJjMCA4MWViNjczNCA4Mjc1NGY4
MApbICAgIDMuMDE4MDI5XSAgZGVhZDRlYWQgODAwMzgzNDAgMDAwMDAwMDEgMDAwMDAwMDAg
ODI3NTRmODAgYTA4YWE5ZDAgODAwMjdhYzAgODEwNzc3NzcKWyAgICAzLjAxODAyOV0gIGEw
OGFhOWQwIDAwMDAwMDAwIDgyNzU0ZjgwIDAwMDAwMDgyIDAwMDAwMDAxIDgwMDI3YWUwIDgx
YmFmMGI0IDAwMDAwMDAwClsgICAgMy4wMTgwMjldIENhbGwgVHJhY2U6ClsgICAgMy4wMTgw
MjldICBbPDgxYjljMDQ4Pl0gZHVtcF9zdGFjaysweDE2LzB4MTgKWyAgICAzLjAxODAyOV0g
IFs8ODFiOTZiYzA+XSBzcGluX2R1bXArMHg5MC8weDk3ClsgICAgMy4wMTgwMjldICBbPDgx
MDc3Nzc3Pl0gZG9fcmF3X3NwaW5fbG9jaysweGE3LzB4ZjAKWyAgICAzLjAxODAyOV0gIFs8
ODFiYWYwYjQ+XSBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4NTQvMHg2MApbICAgIDMuMDE4
MDI5XSAgWzw4MTVmNjcxYz5dID8gc2VyaWFsODI1MF9jb25zb2xlX3dyaXRlKzB4MTFjLzB4
MTQwClsgICAgMy4wMTgwMjldICBbPDgxNWY2NjAwPl0gPyBzZXJpYWw4MjUwX21vZGVtX3N0
YXR1cysweGMwLzB4YzAKWyAgICAzLjAxODAyOV0gIFs8ODE1ZjY3MWM+XSBzZXJpYWw4MjUw
X2NvbnNvbGVfd3JpdGUrMHgxMWMvMHgxNDAKWyAgICAzLjAxODAyOV0gIFs8ODE1ZjY2MDA+
XSA/IHNlcmlhbDgyNTBfbW9kZW1fc3RhdHVzKzB4YzAvMHhjMApbICAgIDMuMDE4MDI5XSAg
Wzw4MTA3YjUzND5dIGNhbGxfY29uc29sZV9kcml2ZXJzLmNvbnN0cHJvcC4yMCsweDY0LzB4
MTMwClsgICAgMy4wMTgwMjldICBbPDgxMDdiZDBkPl0gY29uc29sZV91bmxvY2srMHg0OWQv
MHg1MzAKWyAgICAzLjAxODAyOV0gIFs8ODEwN2MwMWQ+XSB2cHJpbnRrX2VtaXQrMHgyN2Qv
MHg1NDAKWyAgICAzLjAxODAyOV0gIFs8ODFiOTZjYTk+XSBwcmludGsrMHgzOC8weDNhClsg
ICAgMy4wMTgwMjldICBbPDgxYjk2MmMwPl0gcHJpbnRfY2lyY3VsYXJfYnVnX2hlYWRlcisw
eDM1LzB4YzEKWyAgICAzLjAxODAyOV0gIFs8ODFiOTYzYjY+XSBwcmludF9jaXJjdWxhcl9i
dWcrMHg2YS8weDI2OApbICAgIDMuMDE4MDI5XSAgWzw4MTA3NDNjMj5dIF9fbG9ja19hY3F1
aXJlKzB4MTljMi8weDFiMjAKWyAgICAzLjAxODAyOV0gIFs8ODEwNzBkMTg+XSA/IGNoZWNr
X2lycV91c2FnZSsweDg4LzB4YzAKWyAgICAzLjAxODAyOV0gIFs8ODEwNzUwZTU+XSBsb2Nr
X2FjcXVpcmUrMHg4NS8weDE5MApbICAgIDMuMDE4MDI5XSAgWzw4MTA3ZGQ1Yz5dID8gX19p
cnFfZ2V0X2Rlc2NfbG9jaysweDNjLzB4NzAKWyAgICAzLjAxODAyOV0gIFs8ODFiYWYwYWQ+
XSBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4NGQvMHg2MApbICAgIDMuMDE4MDI5XSAgWzw4
MTA3ZGQ1Yz5dID8gX19pcnFfZ2V0X2Rlc2NfbG9jaysweDNjLzB4NzAKWyAgICAzLjAxODAy
OV0gIFs8ODEwN2RkNWM+XSBfX2lycV9nZXRfZGVzY19sb2NrKzB4M2MvMHg3MApbICAgIDMu
MDE4MDI5XSAgWzw4MTA3ZWJlZT5dIF9fZGlzYWJsZV9pcnFfbm9zeW5jKzB4MWUvMHg1MApb
ICAgIDMuMDE4MDI5XSAgWzw4MTA3ZWMyOD5dIGRpc2FibGVfaXJxX25vc3luYysweDgvMHgx
MApbICAgIDMuMDE4MDI5XSAgWzw4MTVmNWU2OD5dIHNlcmlhbDgyNTBfc3RhcnR1cCsweDQ4
OC8weDcyMApbICAgIDMuMDE4MDI5XSAgWzw4MTBkZTdhMD5dID8gX19nZXRfZnJlZV9wYWdl
cysweDIwLzB4NDAKWyAgICAzLjAxODAyOV0gIFs8ODE1ZjIyNGU+XSB1YXJ0X3N0YXJ0dXAu
cGFydC40KzB4NmUvMHgxZTAKWyAgICAzLjAxODAyOV0gIFs8ODE1ZjJjMzA+XSB1YXJ0X29w
ZW4rMHhlMC8weDE0MApbICAgIDMuMDE4MDI5XSAgWzw4MTVmMmI1MD5dID8gdWFydF9pb2N0
bCsweDJmMC8weDJmMApbICAgIDMuMDE4MDI5XSAgWzw4MTVlNGQ0MT5dIHR0eV9vcGVuKzB4
MTQxLzB4NTEwClsgICAgMy4wMTgwMjldICBbPDgxNWU0YzAwPl0gPyB0dHlfaW9jdGwrMHhi
MjAvMHhiMjAKWyAgICAzLjAxODAyOV0gIFs8ODExMThkMTA+XSBjaHJkZXZfb3BlbisweDYw
LzB4MTQwClsgICAgMy4wMTgwMjldICBbPDgxMTEzODdjPl0gZG9fZGVudHJ5X29wZW4rMHgx
NGMvMHgyMzAKWyAgICAzLjAxODAyOV0gIFs8ODExMThjYjA+XSA/IGV4YWN0X2xvY2srMHgy
MC8weDIwClsgICAgMy4wMTgwMjldICBbPDgxMTE0NmVlPl0gZmluaXNoX29wZW4rMHgyZS8w
eDQwClsgICAgMy4wMTgwMjldICBbPDgxMTIxNDdhPl0gZG9fbGFzdCsweDRhYS8weGQzMApb
ICAgIDMuMDE4MDI5XSAgWzw4MTExZjY0ZD5dID8gbGlua19wYXRoX3dhbGsrMHgxZGQvMHg3
MDAKWyAgICAzLjAxODAyOV0gIFs8ODExMjFkYWE+XSBwYXRoX29wZW5hdCsweGFhLzB4NjEw
ClsgICAgMy4wMTgwMjldICBbPDgxMTIyMzNjPl0gZG9fZmlscF9vcGVuKzB4MmMvMHg3MApb
ICAgIDMuMDE4MDI5XSAgWzw4MTExNGJkMT5dIGRvX3N5c19vcGVuKzB4MTExLzB4MjEwClsg
ICAgMy4wMTgwMjldICBbPDgxNjAwMDAwPl0gPyBhZGRfdGltZXJfcmFuZG9tbmVzcysweDMw
LzB4ZDAKWyAgICAzLjAxODAyOV0gIFs8ODExMTRjZWQ+XSBTeVNfb3BlbisweDFkLzB4MjAK
WyAgICAzLjAxODAyOV0gIFs8ODIxMmFlYTE+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDFj
Ni8weDIzNgpbICAgIDMuMDE4MDI5XSAgWzw4MjEyYTU3Mz5dID8gaW5pdGNhbGxfYmxhY2ts
aXN0KzB4ODEvMHg4MQpbICAgIDMuMDE4MDI5XSAgWzw4MWI5MjY3Yj5dIGtlcm5lbF9pbml0
KzB4Yi8weGQwClsgICAgMy4wMTgwMjldICBbPDgxMDYzYjEyPl0gPyBzY2hlZHVsZV90YWls
KzB4MTIvMHg0MApbICAgIDMuMDE4MDI5XSAgWzw4MWJiMDM4MD5dIHJldF9mcm9tX2tlcm5l
bF90aHJlYWQrMHgyMC8weDMwClsgICAgMy4wMTgwMjldICBbPDgxYjkyNjcwPl0gPyByZXN0
X2luaXQrMHgxMzAvMHgxMzAKWyAgICAzLjAxODAyOV0gPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWliMC0wNTMwMDg0MS83ZmY2MDQ2OWU2M2YyYmQxMTA1ODJjZGY4YmE5NWFmYTY5NGJm
N2M2L2RtZXNnLXF1YW50YWwtaXZiNDEtMzg6MjAxNDA1MzAwOTIzNDM6aTM4Ni1yYW5kY29u
ZmlnLWliMC0wNTMwMDg0MTozLjE1LjAtcmM1LTAwNjI5LWc3ZmY2MDQ2OjEKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLzdmZjYwNDY5ZTYzZjJiZDExMDU4MmNkZjhi
YTk1YWZhNjk0YmY3YzYvZG1lc2ctcXVhbnRhbC1pdmI0My01NzoyMDE0MDUzMDA5MjM0Nzpp
Mzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxOjMuMTUuMC1yYzUtMDA2MjktZzdmZjYwNDY6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvN2ZmNjA0NjllNjNmMmJk
MTEwNTgyY2RmOGJhOTVhZmE2OTRiZjdjNi9kbWVzZy15b2N0by1pdmI0Mi00OjIwMTQwNTMw
MDkyMjMyOmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4wLXJjNS0wMDYyOS1n
N2ZmNjA0NjoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS83ZmY2MDQ2
OWU2M2YyYmQxMTA1ODJjZGY4YmE5NWFmYTY5NGJmN2M2L2RtZXNnLXlvY3RvLWl2YjQyLTY5
OjIwMTQwNTMwMDkyMjMyOmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4wLXJj
NS0wMDYyOS1nN2ZmNjA0NjoxCjA6NDo0IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtb
MTszNW0yMDE0LTA1LTMwIDA5OjI0OjA1IFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1i
aXNlY3QvbGludXgyL29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogNTkgcmV2
aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpClszYzNh
ZDM4NWExNzRkNWQyNDkwYjJmOWM2NTEzYjU4OGRjOGExZGRiXSBwcmludGs6IGRpc2FibGUg
cHJlZW1wdGlvbiBmb3IgcHJpbnRrX3NjaGVkCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDIvb2JqLWJp
c2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LWliMC0wNTMwMDg0MS9uZXh0Om1hc3RlcjozYzNhZDM4NWExNzRkNWQyNDkwYjJmOWM2NTEz
YjU4OGRjOGExZGRiOmJpc2VjdC1saW51eDIKCjIwMTQtMDUtMzAtMDk6MjQ6MDUgM2MzYWQz
ODVhMTc0ZDVkMjQ5MGIyZjljNjUxM2I1ODhkYzhhMWRkYiBjb21waWxpbmcKUXVldWVkIGJ1
aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
aWIwLTA1MzAwODQxLTNjM2FkMzg1YTE3NGQ1ZDI0OTBiMmY5YzY1MTNiNTg4ZGM4YTFkZGIK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4
NDEvM2MzYWQzODVhMTc0ZDVkMjQ5MGIyZjljNjUxM2I1ODhkYzhhMWRkYgp3YWl0aW5nIGZv
ciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29u
ZmlnLWliMC0wNTMwMDg0MS0zYzNhZDM4NWExNzRkNWQyNDkwYjJmOWM2NTEzYjU4OGRjOGEx
ZGRiCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS8uaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS0zYzNhZDM4NWExNzRkNWQyNDkwYjJm
OWM2NTEzYjU4OGRjOGExZGRiCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIw
LTA1MzAwODQxLzNjM2FkMzg1YTE3NGQ1ZDI0OTBiMmY5YzY1MTNiNTg4ZGM4YTFkZGIvdm1s
aW51ei0zLjE1LjAtcmM1LTAwNTY5LWczYzNhZDM4CgoyMDE0LTA1LTMwLTA5OjI2OjA1IGRl
dGVjdGluZyBib290IHN0YXRlIC4uLiBURVNUIEZBSUxVUkUKWyAgICAyLjk1NDMwM10gRURE
IGluZm9ybWF0aW9uIG5vdCBhdmFpbGFibGUuClsgICAgMi45NTQ3MjddICMjIyBkdC10ZXN0
ICMjIyBObyB0ZXN0Y2FzZSBkYXRhIGluIGRldmljZSB0cmVlOyBub3QgcnVubmluZyB0ZXN0
cwpbICAgIDIuOTU1NTMwXSAKWyAgICAyLjk1NjIyMV0gQlVHOiBzcGlubG9jayBsb2NrdXAg
c3VzcGVjdGVkIG9uIENQVSMwLCBzd2FwcGVyLzEKWyAgICAyLjk1NjIyMV0gIGxvY2s6IHNl
cmlhbDgyNTBfcG9ydHMrMHgwLzB4NGMwLCAubWFnaWM6IGRlYWQ0ZWFkLCAub3duZXI6IHN3
YXBwZXIvMSwgLm93bmVyX2NwdTogMApbICAgIDIuOTU2MjIxXSBDUFU6IDAgUElEOiAxIENv
bW06IHN3YXBwZXIgTm90IHRhaW50ZWQgMy4xNS4wLXJjNS0wMDU2OS1nM2MzYWQzOCAjMQpb
ICAgIDIuOTU2MjIxXSAgODAwMzgwMDAgODAwMzgwMDAgODAwMjdhODQgODFiOWJkYTQgODAw
MjdhYWMgODFiOTY5NTAgODFlYjUxODggODI3NTVmODAKWyAgICAyLjk1NjIyMV0gIGRlYWQ0
ZWFkIDgwMDM4MzQwIDAwMDAwMDAxIDAwMDAwMDAwIDgyNzU1ZjgwIGEwOGFhOWQwIDgwMDI3
YWM4IDgxMDc3Nzc3ClsgICAgMi45NTYyMjFdICBhMDhhYTlkMCAwMDAwMDAwMCA4Mjc1NWY4
MCAwMDAwMDA4MiAwMDAwMDAwMSA4MDAyN2FlOCA4MWJhZWUxNCAwMDAwMDAwMApbICAgIDIu
OTU2MjIxXSBDYWxsIFRyYWNlOgpbICAgIDIuOTU2MjIxXSAgWzw4MWI5YmRhND5dIGR1bXBf
c3RhY2srMHgxNi8weDE4ClsgICAgMi45NTYyMjFdICBbPDgxYjk2OTUwPl0gc3Bpbl9kdW1w
KzB4OTAvMHg5NwpbICAgIDIuOTU2MjIxXSAgWzw4MTA3Nzc3Nz5dIGRvX3Jhd19zcGluX2xv
Y2srMHhhNy8weGYwClsgICAgMi45NTYyMjFdICBbPDgxYmFlZTE0Pl0gX3Jhd19zcGluX2xv
Y2tfaXJxc2F2ZSsweDU0LzB4NjAKWyAgICAyLjk1NjIyMV0gIFs8ODE1ZjY1YWM+XSA/IHNl
cmlhbDgyNTBfY29uc29sZV93cml0ZSsweDExYy8weDE0MApbICAgIDIuOTU2MjIxXSAgWzw4
MTVmNjQ5MD5dID8gc2VyaWFsODI1MF9tb2RlbV9zdGF0dXMrMHhjMC8weGMwClsgICAgMi45
NTYyMjFdICBbPDgxNWY2NWFjPl0gc2VyaWFsODI1MF9jb25zb2xlX3dyaXRlKzB4MTFjLzB4
MTQwClsgICAgMi45NTYyMjFdICBbPDgxNWY2NDkwPl0gPyBzZXJpYWw4MjUwX21vZGVtX3N0
YXR1cysweGMwLzB4YzAKWyAgICAyLjk1NjIyMV0gIFs8ODEwN2I1MzQ+XSBjYWxsX2NvbnNv
bGVfZHJpdmVycy5jb25zdHByb3AuMjArMHg2NC8weDEzMApbICAgIDIuOTU2MjIxXSAgWzw4
MTA3YmNiNT5dIGNvbnNvbGVfdW5sb2NrKzB4NDQ1LzB4NGQwClsgICAgMi45NTYyMjFdICBb
PDgxMDdiZmJkPl0gdnByaW50a19lbWl0KzB4MjdkLzB4NTQwClsgICAgMi45NTYyMjFdICBb
PDgxYjk2YTM5Pl0gcHJpbnRrKzB4MzgvMHgzYQpbICAgIDIuOTU2MjIxXSAgWzw4MWI5NjA1
MD5dIHByaW50X2NpcmN1bGFyX2J1Z19oZWFkZXIrMHgzNS8weGMxClsgICAgMi45NTYyMjFd
ICBbPDgxYjk2MTQ2Pl0gcHJpbnRfY2lyY3VsYXJfYnVnKzB4NmEvMHgyNjgKWyAgICAyLjk1
NjIyMV0gIFs8ODEwNzQzYzI+XSBfX2xvY2tfYWNxdWlyZSsweDE5YzIvMHgxYjIwClsgICAg
Mi45NTYyMjFdICBbPDgxMDcwZDE4Pl0gPyBjaGVja19pcnFfdXNhZ2UrMHg4OC8weGMwClsg
ICAgMi45NTYyMjFdICBbPDgxMDc1MGU1Pl0gbG9ja19hY3F1aXJlKzB4ODUvMHgxOTAKWyAg
ICAyLjk1NjIyMV0gIFs8ODEwN2RjZmM+XSA/IF9faXJxX2dldF9kZXNjX2xvY2srMHgzYy8w
eDcwClsgICAgMi45NTYyMjFdICBbPDgxYmFlZTBkPl0gX3Jhd19zcGluX2xvY2tfaXJxc2F2
ZSsweDRkLzB4NjAKWyAgICAyLjk1NjIyMV0gIFs8ODEwN2RjZmM+XSA/IF9faXJxX2dldF9k
ZXNjX2xvY2srMHgzYy8weDcwClsgICAgMi45NTYyMjFdICBbPDgxMDdkY2ZjPl0gX19pcnFf
Z2V0X2Rlc2NfbG9jaysweDNjLzB4NzAKWyAgICAyLjk1NjIyMV0gIFs8ODEwN2ViOGU+XSBf
X2Rpc2FibGVfaXJxX25vc3luYysweDFlLzB4NTAKWyAgICAyLjk1NjIyMV0gIFs8ODEwN2Vi
Yzg+XSBkaXNhYmxlX2lycV9ub3N5bmMrMHg4LzB4MTAKWyAgICAyLjk1NjIyMV0gIFs8ODE1
ZjVjZjg+XSBzZXJpYWw4MjUwX3N0YXJ0dXArMHg0ODgvMHg3MjAKWyAgICAyLjk1NjIyMV0g
IFs8ODEwZGU3NDA+XSA/IF9fZ2V0X2ZyZWVfcGFnZXMrMHgyMC8weDQwClsgICAgMi45NTYy
MjFdICBbPDgxNWYyMGRlPl0gdWFydF9zdGFydHVwLnBhcnQuNCsweDZlLzB4MWUwClsgICAg
Mi45NTYyMjFdICBbPDgxNWYyYWMwPl0gdWFydF9vcGVuKzB4ZTAvMHgxNDAKWyAgICAyLjk1
NjIyMV0gIFs8ODE1ZjI5ZTA+XSA/IHVhcnRfaW9jdGwrMHgyZjAvMHgyZjAKWyAgICAyLjk1
NjIyMV0gIFs8ODE1ZTRiZDE+XSB0dHlfb3BlbisweDE0MS8weDUxMApbICAgIDIuOTU2MjIx
XSAgWzw4MTVlNGE5MD5dID8gdHR5X2lvY3RsKzB4YjIwLzB4YjIwClsgICAgMi45NTYyMjFd
ICBbPDgxMTE4YzMwPl0gY2hyZGV2X29wZW4rMHg2MC8weDE0MApbICAgIDIuOTU2MjIxXSAg
Wzw4MTExMzc5Yz5dIGRvX2RlbnRyeV9vcGVuKzB4MTRjLzB4MjMwClsgICAgMi45NTYyMjFd
ICBbPDgxMTE4YmQwPl0gPyBleGFjdF9sb2NrKzB4MjAvMHgyMApbICAgIDIuOTU2MjIxXSAg
Wzw4MTExNDYwZT5dIGZpbmlzaF9vcGVuKzB4MmUvMHg0MApbICAgIDIuOTU2MjIxXSAgWzw4
MTEyMTM5YT5dIGRvX2xhc3QrMHg0YWEvMHhkMzAKWyAgICAyLjk1NjIyMV0gIFs8ODExMWY1
NmQ+XSA/IGxpbmtfcGF0aF93YWxrKzB4MWRkLzB4NzAwClsgICAgMi45NTYyMjFdICBbPDgx
MTIxY2NhPl0gcGF0aF9vcGVuYXQrMHhhYS8weDYxMApbICAgIDIuOTU2MjIxXSAgWzw4MTEy
MjI1Yz5dIGRvX2ZpbHBfb3BlbisweDJjLzB4NzAKWyAgICAyLjk1NjIyMV0gIFs8ODExMTRh
ZjE+XSBkb19zeXNfb3BlbisweDExMS8weDIxMApbICAgIDIuOTU2MjIxXSAgWzw4MTYwMDAw
MD5dID8gX3hmZXJfc2Vjb25kYXJ5X3Bvb2wrMHhkMC8weDIzMApbICAgIDIuOTU2MjIxXSAg
Wzw4MTExNGMwZD5dIFN5U19vcGVuKzB4MWQvMHgyMApbICAgIDIuOTU2MjIxXSAgWzw4MjEy
YmRhND5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MWM2LzB4MjM2ClsgICAgMi45NTYyMjFd
ICBbPDgyMTJiNGYyPl0gPyBkb19lYXJseV9wYXJhbSsweDc4LzB4NzgKWyAgICAyLjk1NjIy
MV0gIFs8ODFiOTI0MGI+XSBrZXJuZWxfaW5pdCsweGIvMHhkMApbICAgIDIuOTU2MjIxXSAg
Wzw4MTA2M2IxMj5dID8gc2NoZWR1bGVfdGFpbCsweDEyLzB4NDAKWyAgICAyLjk1NjIyMV0g
IFs8ODFiYjAwYzA+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4MjAvMHgzMApbICAgIDIu
OTU2MjIxXSAgWzw4MWI5MjQwMD5dID8gcmVzdF9pbml0KzB4MTMwLzB4MTMwClsgICAgMi45
NTYyMjFdID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvM2MzYWQzODVh
MTc0ZDVkMjQ5MGIyZjljNjUxM2I1ODhkYzhhMWRkYi9kbWVzZy1xdWFudGFsLWl2YjQxLTcz
OjIwMTQwNTMwMDkyNzA1OmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4wLXJj
NS0wMDU2OS1nM2MzYWQzODoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0
MS8zYzNhZDM4NWExNzRkNWQyNDkwYjJmOWM2NTEzYjU4OGRjOGExZGRiL2RtZXNnLXF1YW50
YWwtaXZiNDQtNTM6MjAxNDA1MzAwOTI1NTA6aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0
MTozLjE1LjAtcmM1LTAwNTY5LWczYzNhZDM4OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aWIwLTA1MzAwODQxLzNjM2FkMzg1YTE3NGQ1ZDI0OTBiMmY5YzY1MTNiNTg4ZGM4YTFkZGIv
ZG1lc2ctcXVhbnRhbC1pdmI0NC03NzoyMDE0MDUzMDA5MjU1MDppMzg2LXJhbmRjb25maWct
aWIwLTA1MzAwODQxOjMuMTUuMC1yYzUtMDA1NjktZzNjM2FkMzg6MQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvM2MzYWQzODVhMTc0ZDVkMjQ5MGIyZjljNjUxM2I1
ODhkYzhhMWRkYi9kbWVzZy1xdWFudGFsLWl2YjQxLTExMToyMDE0MDUzMDA5MjcxMzppMzg2
LXJhbmRjb25maWctaWIwLTA1MzAwODQxOjMuMTUuMC1yYzUtMDA1NjktZzNjM2FkMzg6MQov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvM2MzYWQzODVhMTc0ZDVkMjQ5
MGIyZjljNjUxM2I1ODhkYzhhMWRkYi9kbWVzZy1xdWFudGFsLWl2YjQxLTI6MjAxNDA1MzAw
OTI3MTE6aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MTozLjE1LjAtcmM1LTAwNTY5LWcz
YzNhZDM4OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLzNjM2FkMzg1
YTE3NGQ1ZDI0OTBiMmY5YzY1MTNiNTg4ZGM4YTFkZGIvZG1lc2ctcXVhbnRhbC1pdmI0MS04
OjIwMTQwNTMwMDkyNzA4OmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4wLXJj
NS0wMDU2OS1nM2MzYWQzODoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0
MS8zYzNhZDM4NWExNzRkNWQyNDkwYjJmOWM2NTEzYjU4OGRjOGExZGRiL2RtZXNnLXF1YW50
YWwtaXZiNDItNTk6MjAxNDA1MzAwOTI1NTk6aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0
MTozLjE1LjAtcmM1LTAwNTY5LWczYzNhZDM4OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aWIwLTA1MzAwODQxLzNjM2FkMzg1YTE3NGQ1ZDI0OTBiMmY5YzY1MTNiNTg4ZGM4YTFkZGIv
ZG1lc2ctcXVhbnRhbC1pdmI0My0xMDoyMDE0MDUzMDA5MjcxODppMzg2LXJhbmRjb25maWct
aWIwLTA1MzAwODQxOjMuMTUuMC1yYzUtMDA1NjktZzNjM2FkMzg6MQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvM2MzYWQzODVhMTc0ZDVkMjQ5MGIyZjljNjUxM2I1
ODhkYzhhMWRkYi9kbWVzZy1xdWFudGFsLWl2YjQzLTI1OjIwMTQwNTMwMDkyNzE5OmkzODYt
cmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4wLXJjNS0wMDU2OS1nM2MzYWQzODoxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS8zYzNhZDM4NWExNzRkNWQyNDkw
YjJmOWM2NTEzYjU4OGRjOGExZGRiL2RtZXNnLXlvY3RvLWl2YjQxLTExNToyMDE0MDUzMDA5
MjcxNjppMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxOjMuMTUuMC1yYzUtMDA1NjktZzNj
M2FkMzg6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvM2MzYWQzODVh
MTc0ZDVkMjQ5MGIyZjljNjUxM2I1ODhkYzhhMWRkYi9kbWVzZy15b2N0by1pdmI0MS0zNToy
MDE0MDUzMDA5MjcxNjppMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxOjMuMTUuMC1yYzUt
MDA1NjktZzNjM2FkMzg6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEv
M2MzYWQzODVhMTc0ZDVkMjQ5MGIyZjljNjUxM2I1ODhkYzhhMWRkYi9kbWVzZy15b2N0by1p
dmI0MS00OjIwMTQwNTMwMDkyNzEyOmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4x
NS4wLXJjNS0wMDU2OS1nM2MzYWQzODoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0w
NTMwMDg0MS8zYzNhZDM4NWExNzRkNWQyNDkwYjJmOWM2NTEzYjU4OGRjOGExZGRiL2RtZXNn
LXlvY3RvLWl2YjQxLTc4OjIwMTQwNTMwMDkyNzEzOmkzODYtcmFuZGNvbmZpZy1pYjAtMDUz
MDA4NDE6My4xNS4wLXJjNS0wMDU2OS1nM2MzYWQzODoxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWliMC0wNTMwMDg0MS8zYzNhZDM4NWExNzRkNWQyNDkwYjJmOWM2NTEzYjU4OGRjOGEx
ZGRiL2RtZXNnLXlvY3RvLWl2YjQyLTc6MjAxNDA1MzAwOTI2MDc6aTM4Ni1yYW5kY29uZmln
LWliMC0wNTMwMDg0MTozLjE1LjAtcmM1LTAwNTY5LWczYzNhZDM4OjEKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctaWIwLTA1MzAwODQxLzNjM2FkMzg1YTE3NGQ1ZDI0OTBiMmY5YzY1MTNi
NTg4ZGM4YTFkZGIvZG1lc2cteW9jdG8taXZiNDMtMTA2OjIwMTQwNTMwMDkyNzE2OmkzODYt
cmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4wLXJjNS0wMDU2OS1nM2MzYWQzODoxCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS8zYzNhZDM4NWExNzRkNWQyNDkw
YjJmOWM2NTEzYjU4OGRjOGExZGRiL2RtZXNnLXlvY3RvLWl2YjQzLTY1OjIwMTQwNTMwMDky
NzE1OmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4wLXJjNS0wMDU2OS1nM2Mz
YWQzODoxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS8zYzNhZDM4NWEx
NzRkNWQyNDkwYjJmOWM2NTEzYjU4OGRjOGExZGRiL2RtZXNnLXlvY3RvLWl2YjQ0LTExOToy
MDE0MDUzMDA5MjU1NzppMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxOjMuMTUuMC1yYzUt
MDA1NjktZzNjM2FkMzg6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEv
M2MzYWQzODVhMTc0ZDVkMjQ5MGIyZjljNjUxM2I1ODhkYzhhMWRkYi9kbWVzZy15b2N0by1p
dmI0NC0xNzoyMDE0MDUzMDA5MjU1OTppMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxOjMu
MTUuMC1yYzUtMDA1NjktZzNjM2FkMzg6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAt
MDUzMDA4NDEvM2MzYWQzODVhMTc0ZDVkMjQ5MGIyZjljNjUxM2I1ODhkYzhhMWRkYi9kbWVz
Zy15b2N0by1pdmI0NC03NDoyMDE0MDUzMDA5MjU1NDppMzg2LXJhbmRjb25maWctaWIwLTA1
MzAwODQxOjMuMTUuMC1yYzUtMDA1NjktZzNjM2FkMzg6MQowOjE5OjE5IGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTA1LTMwIDA5OjI3OjM2IFJFUEVBVCBDT1VO
VDogMjAgICMgL2MvYm9vdC1iaXNlY3QvbGludXgyL29iai1iaXNlY3QvLnJlcGVhdBtbMG0K
CkJpc2VjdGluZzogMjkgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3Vn
aGx5IDUgc3RlcHMpCls0NTY0MDdkNmZlYzVmMjhjMWJlNjdmY2Y4MDNmOWNjYTE0Yjc1MTQy
XSBkb19zaGFyZWRfZmF1bHQoKTogY2hlY2sgdGhhdCBtbWFwX3NlbSBpcyBoZWxkCnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290
LWJpc2VjdC9saW51eDIvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS9uZXh0Om1hc3Rlcjo0NTY0MDdk
NmZlYzVmMjhjMWJlNjdmY2Y4MDNmOWNjYTE0Yjc1MTQyOmJpc2VjdC1saW51eDIKCjIwMTQt
MDUtMzAtMDk6Mjc6MzYgNDU2NDA3ZDZmZWM1ZjI4YzFiZTY3ZmNmODAzZjljY2ExNGI3NTE0
MiBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLTQ1NjQwN2Q2ZmVjNWYyOGMxYmU2
N2ZjZjgwM2Y5Y2NhMTRiNzUxNDIKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvNDU2NDA3ZDZmZWM1ZjI4YzFiZTY3ZmNmODAzZjlj
Y2ExNGI3NTE0Mgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS00NTY0MDdkNmZlYzVmMjhj
MWJlNjdmY2Y4MDNmOWNjYTE0Yjc1MTQyCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS00
NTY0MDdkNmZlYzVmMjhjMWJlNjdmY2Y4MDNmOWNjYTE0Yjc1MTQyCmtlcm5lbDogL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLzQ1NjQwN2Q2ZmVjNWYyOGMxYmU2N2Zj
ZjgwM2Y5Y2NhMTRiNzUxNDIvdm1saW51ei0zLjE1LjAtcmM1LTAwNTM5LWc0NTY0MDdkCgoy
MDE0LTA1LTMwLTA5OjI5OjM2IGRldGVjdGluZyBib290IHN0YXRlIC4uCTEwCTIwIFNVQ0NF
U1MKCkJpc2VjdGluZzogMTQgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChy
b3VnaGx5IDQgc3RlcHMpCltlOTRhMDFlMjBiNzUzNDVkMTQ4NmU3ZDBiZGYwMzMxM2Y4ZjQ3
ZDBiXSBrZXJuZWwvdXRzbmFtZV9zeXNjdGwuYzogcmVwbGFjZSBvYnNvbGV0ZSBfX2luaXRj
YWxsIGJ5IGRldmljZV9pbml0Y2FsbApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXgyL29iai1iaXNlY3QK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjAt
MDUzMDA4NDEvbmV4dDptYXN0ZXI6ZTk0YTAxZTIwYjc1MzQ1ZDE0ODZlN2QwYmRmMDMzMTNm
OGY0N2QwYjpiaXNlY3QtbGludXgyCgoyMDE0LTA1LTMwLTA5OjMxOjM3IGU5NGEwMWUyMGI3
NTM0NWQxNDg2ZTdkMGJkZjAzMzEzZjhmNDdkMGIgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMC0w
NTMwMDg0MS1lOTRhMDFlMjBiNzUzNDVkMTQ4NmU3ZDBiZGYwMzMxM2Y4ZjQ3ZDBiCkNoZWNr
IGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxL2U5
NGEwMWUyMGI3NTM0NWQxNDg2ZTdkMGJkZjAzMzEzZjhmNDdkMGIKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1p
YjAtMDUzMDA4NDEtZTk0YTAxZTIwYjc1MzQ1ZDE0ODZlN2QwYmRmMDMzMTNmOGY0N2QwYgp3
YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLmkz
ODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEtZTk0YTAxZTIwYjc1MzQ1ZDE0ODZlN2QwYmRm
MDMzMTNmOGY0N2QwYgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMw
MDg0MS9lOTRhMDFlMjBiNzUzNDVkMTQ4NmU3ZDBiZGYwMzMxM2Y4ZjQ3ZDBiL3ZtbGludXot
My4xNS4wLXJjNS0wMDU1NC1nZTk0YTAxZQoKMjAxNC0wNS0zMC0wOTozNDozNyBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAuCTQJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA3IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbNmY4M2ExYThkN2Uw
YTllNzFmM2VlMTY0MWE5NjVhZWRlMGVlNGM2Y10gcHJpbnRrOiBzaHJpbmsgdG9vIGxvbmcg
bWVzc2FnZXMKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4Mi9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQt
dGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxL25leHQ6
bWFzdGVyOjZmODNhMWE4ZDdlMGE5ZTcxZjNlZTE2NDFhOTY1YWVkZTBlZTRjNmM6YmlzZWN0
LWxpbnV4MgoKMjAxNC0wNS0zMC0wOTozNjowNyA2ZjgzYTFhOGQ3ZTBhOWU3MWYzZWUxNjQx
YTk2NWFlZGUwZWU0YzZjIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEtNmY4M2Ex
YThkN2UwYTllNzFmM2VlMTY0MWE5NjVhZWRlMGVlNGM2YwpDaGVjayBmb3Iga2VybmVsIGlu
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS82ZjgzYTFhOGQ3ZTBhOWU3
MWYzZWUxNjQxYTk2NWFlZGUwZWU0YzZjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLTZm
ODNhMWE4ZDdlMGE5ZTcxZjNlZTE2NDFhOTY1YWVkZTBlZTRjNmMKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWct
aWIwLTA1MzAwODQxLTZmODNhMWE4ZDdlMGE5ZTcxZjNlZTE2NDFhOTY1YWVkZTBlZTRjNmMK
a2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvNmY4M2ExYThk
N2UwYTllNzFmM2VlMTY0MWE5NjVhZWRlMGVlNGM2Yy92bWxpbnV6LTMuMTUuMC1yYzUtMDA1
NjEtZzZmODNhMWEKCjIwMTQtMDUtMzAtMDk6NDg6MDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Lgk3CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgMiBzdGVwcykKWzNiZDE2MDUwZTljNTU1Y2I3YjA4YTRmODMw
ZGI5NWU5MDI1MzM2ZTZdIHByaW50ay1yZWxlYXNlLWxvY2tidWZfbG9jay1iZWZvcmUtY2Fs
bGluZy1jb25zb2xlX3RyeWxvY2tfZm9yX3ByaW50ay1maXgKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4
Mi9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctaWIwLTA1MzAwODQxL25leHQ6bWFzdGVyOjNiZDE2MDUwZTljNTU1Y2I3YjA4
YTRmODMwZGI5NWU5MDI1MzM2ZTY6YmlzZWN0LWxpbnV4MgoKMjAxNC0wNS0zMC0wOTo0OToz
OCAzYmQxNjA1MGU5YzU1NWNiN2IwOGE0ZjgzMGRiOTVlOTAyNTMzNmU2IGNvbXBpbGluZwpR
dWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFu
ZGNvbmZpZy1pYjAtMDUzMDA4NDEtM2JkMTYwNTBlOWM1NTVjYjdiMDhhNGY4MzBkYjk1ZTkw
MjUzMzZlNgpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MC0wNTMwMDg0MS8zYmQxNjA1MGU5YzU1NWNiN2IwOGE0ZjgzMGRiOTVlOTAyNTMzNmU2Cndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2
LXJhbmRjb25maWctaWIwLTA1MzAwODQxLTNiZDE2MDUwZTljNTU1Y2I3YjA4YTRmODMwZGI5
NWU5MDI1MzM2ZTYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1
aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLTNiZDE2MDUwZTljNTU1
Y2I3YjA4YTRmODMwZGI5NWU5MDI1MzM2ZTYKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pYjAtMDUzMDA4NDEvM2JkMTYwNTBlOWM1NTVjYjdiMDhhNGY4MzBkYjk1ZTkwMjUz
MzZlNi92bWxpbnV6LTMuMTUuMC1yYzUtMDA1NjUtZzNiZDE2MDUKCjIwMTQtMDUtMzAtMDk6
NTM6MzggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTQJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAx
IHJldmlzaW9uIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKW2Jh
ZmU5ODBmNWFmYzdjY2M2OTNmZDhjODFjOGFhNWEwMmZiYjVhZTBdIHByaW50azogZW5hYmxl
IGludGVycnVwdHMgYmVmb3JlIGNhbGxpbmcgY29uc29sZV90cnlsb2NrX2Zvcl9wcmludGso
KQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2gg
L2MvYm9vdC1iaXNlY3QvbGludXgyL29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvbmV4dDptYXN0ZXI6
YmFmZTk4MGY1YWZjN2NjYzY5M2ZkOGM4MWM4YWE1YTAyZmJiNWFlMDpiaXNlY3QtbGludXgy
CgoyMDE0LTA1LTMwLTA5OjU0OjM4IGJhZmU5ODBmNWFmYzdjY2M2OTNmZDhjODFjOGFhNWEw
MmZiYjVhZTAgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS1iYWZlOTgwZjVhZmM3
Y2NjNjkzZmQ4YzgxYzhhYTVhMDJmYmI1YWUwCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxL2JhZmU5ODBmNWFmYzdjY2M2OTNmZDhj
ODFjOGFhNWEwMmZiYjVhZTAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRl
c3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEtYmFmZTk4MGY1
YWZjN2NjYzY5M2ZkOGM4MWM4YWE1YTAyZmJiNWFlMAp3YWl0aW5nIGZvciBjb21wbGV0aW9u
IG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1pYjAtMDUz
MDA4NDEtYmFmZTk4MGY1YWZjN2NjYzY5M2ZkOGM4MWM4YWE1YTAyZmJiNWFlMAprZXJuZWw6
IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS9iYWZlOTgwZjVhZmM3Y2Nj
NjkzZmQ4YzgxYzhhYTVhMDJmYmI1YWUwL3ZtbGludXotMy4xNS4wLXJjNS0wMDU2Ny1nYmFm
ZTk4MAoKMjAxNC0wNS0zMC0wOTo1ODozOCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4gVEVT
VCBGQUlMVVJFClsgICAgMy4wMDQzODNdIEVERCBpbmZvcm1hdGlvbiBub3QgYXZhaWxhYmxl
LgpbICAgIDMuMDA0ODQxXSAjIyMgZHQtdGVzdCAjIyMgTm8gdGVzdGNhc2UgZGF0YSBpbiBk
ZXZpY2UgdHJlZTsgbm90IHJ1bm5pbmcgdGVzdHMKWyAgICAzLjAwNTY5N10gClsgICAgMy4w
MDgxMDldIEJVRzogc3BpbmxvY2sgbG9ja3VwIHN1c3BlY3RlZCBvbiBDUFUjMCwgc3dhcHBl
ci8xClsgICAgMy4wMDgxMDldICBsb2NrOiBzZXJpYWw4MjUwX3BvcnRzKzB4MC8weDRjMCwg
Lm1hZ2ljOiBkZWFkNGVhZCwgLm93bmVyOiBzd2FwcGVyLzEsIC5vd25lcl9jcHU6IDAKWyAg
ICAzLjAwODEwOV0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMu
MTUuMC1yYzUtMDA1NjctZ2JhZmU5ODAgIzEKWyAgICAzLjAwODEwOV0gIDgwMDM4MDAwIDgw
MDM4MDAwIDgwMDI3YThjIDgxYjliZDMwIDgwMDI3YWI0IDgxYjk2OGQwIDgxZWI1MTk4IDgy
NzU1ZjgwClsgICAgMy4wMDgxMDldICBkZWFkNGVhZCA4MDAzODM0MCAwMDAwMDAwMSAwMDAw
MDAwMCA4Mjc1NWY4MCBhMDg5NTk3YyA4MDAyN2FkMCA4MTA3Nzc3NwpbICAgIDMuMDA4MTA5
XSAgYTA4OTU5N2MgMDAwMDAwMDAgODI3NTVmODAgMDAwMDAwODYgMDAwMDAwMDEgODAwMjdh
ZjAgODFiYWVkYTQgMDAwMDAwMDAKWyAgICAzLjAwODEwOV0gQ2FsbCBUcmFjZToKWyAgICAz
LjAwODEwOV0gIFs8ODFiOWJkMzA+XSBkdW1wX3N0YWNrKzB4MTYvMHgxOApbICAgIDMuMDA4
MTA5XSAgWzw4MWI5NjhkMD5dIHNwaW5fZHVtcCsweDkwLzB4OTcKWyAgICAzLjAwODEwOV0g
IFs8ODEwNzc3Nzc+XSBkb19yYXdfc3Bpbl9sb2NrKzB4YTcvMHhmMApbICAgIDMuMDA4MTA5
XSAgWzw4MWJhZWRhND5dIF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHg1NC8weDYwClsgICAg
My4wMDgxMDldICBbPDgxNWY2NTJjPl0gPyBzZXJpYWw4MjUwX2NvbnNvbGVfd3JpdGUrMHgx
MWMvMHgxNDAKWyAgICAzLjAwODEwOV0gIFs8ODE1ZjY0MTA+XSA/IHNlcmlhbDgyNTBfbW9k
ZW1fc3RhdHVzKzB4YzAvMHhjMApbICAgIDMuMDA4MTA5XSAgWzw4MTVmNjUyYz5dIHNlcmlh
bDgyNTBfY29uc29sZV93cml0ZSsweDExYy8weDE0MApbICAgIDMuMDA4MTA5XSAgWzw4MTVm
NjQxMD5dID8gc2VyaWFsODI1MF9tb2RlbV9zdGF0dXMrMHhjMC8weGMwClsgICAgMy4wMDgx
MDldICBbPDgxMDdiNTM0Pl0gY2FsbF9jb25zb2xlX2RyaXZlcnMuY29uc3Rwcm9wLjIwKzB4
NjQvMHgxMzAKWyAgICAzLjAwODEwOV0gIFs8ODEwN2JjYjU+XSBjb25zb2xlX3VubG9jaysw
eDQ0NS8weDRkMApbICAgIDMuMDA4MTA5XSAgWzw4MTA3YmU5OD5dIHZwcmludGtfZW1pdCsw
eDE1OC8weDRkMApbICAgIDMuMDA4MTA5XSAgWzw4MWI5NjliOT5dIHByaW50aysweDM4LzB4
M2EKWyAgICAzLjAwODEwOV0gIFs8ODFiOTVmZDA+XSBwcmludF9jaXJjdWxhcl9idWdfaGVh
ZGVyKzB4MzUvMHhjMQpbICAgIDMuMDA4MTA5XSAgWzw4MWI5NjBjNj5dIHByaW50X2NpcmN1
bGFyX2J1ZysweDZhLzB4MjY4ClsgICAgMy4wMDgxMDldICBbPDgxMDc0M2MyPl0gX19sb2Nr
X2FjcXVpcmUrMHgxOWMyLzB4MWIyMApbICAgIDMuMDA4MTA5XSAgWzw4MTA3MGQxOD5dID8g
Y2hlY2tfaXJxX3VzYWdlKzB4ODgvMHhjMApbICAgIDMuMDA4MTA5XSAgWzw4MTA3NTBlNT5d
IGxvY2tfYWNxdWlyZSsweDg1LzB4MTkwClsgICAgMy4wMDgxMDldICBbPDgxMDdkYzhjPl0g
PyBfX2lycV9nZXRfZGVzY19sb2NrKzB4M2MvMHg3MApbICAgIDMuMDA4MTA5XSAgWzw4MWJh
ZWQ5ZD5dIF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHg0ZC8weDYwClsgICAgMy4wMDgxMDld
ICBbPDgxMDdkYzhjPl0gPyBfX2lycV9nZXRfZGVzY19sb2NrKzB4M2MvMHg3MApbICAgIDMu
MDA4MTA5XSAgWzw4MTA3ZGM4Yz5dIF9faXJxX2dldF9kZXNjX2xvY2srMHgzYy8weDcwClsg
ICAgMy4wMDgxMDldICBbPDgxMDdlYjFlPl0gX19kaXNhYmxlX2lycV9ub3N5bmMrMHgxZS8w
eDUwClsgICAgMy4wMDgxMDldICBbPDgxMDdlYjU4Pl0gZGlzYWJsZV9pcnFfbm9zeW5jKzB4
OC8weDEwClsgICAgMy4wMDgxMDldICBbPDgxNWY1Yzc4Pl0gc2VyaWFsODI1MF9zdGFydHVw
KzB4NDg4LzB4NzIwClsgICAgMy4wMDgxMDldICBbPDgxMGRlNmQwPl0gPyBfX2dldF9mcmVl
X3BhZ2VzKzB4MjAvMHg0MApbICAgIDMuMDA4MTA5XSAgWzw4MTVmMjA1ZT5dIHVhcnRfc3Rh
cnR1cC5wYXJ0LjQrMHg2ZS8weDFlMApbICAgIDMuMDA4MTA5XSAgWzw4MTVmMmE0MD5dIHVh
cnRfb3BlbisweGUwLzB4MTQwClsgICAgMy4wMDgxMDldICBbPDgxNWYyOTYwPl0gPyB1YXJ0
X2lvY3RsKzB4MmYwLzB4MmYwClsgICAgMy4wMDgxMDldICBbPDgxNWU0YjUxPl0gdHR5X29w
ZW4rMHgxNDEvMHg1MTAKWyAgICAzLjAwODEwOV0gIFs8ODE1ZTRhMTA+XSA/IHR0eV9pb2N0
bCsweGIyMC8weGIyMApbICAgIDMuMDA4MTA5XSAgWzw4MTExOGJjMD5dIGNocmRldl9vcGVu
KzB4NjAvMHgxNDAKWyAgICAzLjAwODEwOV0gIFs8ODExMTM3MmM+XSBkb19kZW50cnlfb3Bl
bisweDE0Yy8weDIzMApbICAgIDMuMDA4MTA5XSAgWzw4MTExOGI2MD5dID8gZXhhY3RfbG9j
aysweDIwLzB4MjAKWyAgICAzLjAwODEwOV0gIFs8ODExMTQ1OWU+XSBmaW5pc2hfb3Blbisw
eDJlLzB4NDAKWyAgICAzLjAwODEwOV0gIFs8ODExMjEzMmE+XSBkb19sYXN0KzB4NGFhLzB4
ZDMwClsgICAgMy4wMDgxMDldICBbPDgxMTFmNGZkPl0gPyBsaW5rX3BhdGhfd2FsaysweDFk
ZC8weDcwMApbICAgIDMuMDA4MTA5XSAgWzw4MTEyMWM1YT5dIHBhdGhfb3BlbmF0KzB4YWEv
MHg2MTAKWyAgICAzLjAwODEwOV0gIFs8ODExMjIxZWM+XSBkb19maWxwX29wZW4rMHgyYy8w
eDcwClsgICAgMy4wMDgxMDldICBbPDgxMTE0YTgxPl0gZG9fc3lzX29wZW4rMHgxMTEvMHgy
MTAKWyAgICAzLjAwODEwOV0gIFs8ODE2MDAwMDA+XSA/IF94ZmVyX3NlY29uZGFyeV9wb29s
KzB4MTUwLzB4MjMwClsgICAgMy4wMDgxMDldICBbPDgxMTE0YjlkPl0gU3lTX29wZW4rMHgx
ZC8weDIwClsgICAgMy4wMDgxMDldICBbPDgyMTJiZGE0Pl0ga2VybmVsX2luaXRfZnJlZWFi
bGUrMHgxYzYvMHgyMzYKWyAgICAzLjAwODEwOV0gIFs8ODIxMmI0ZjI+XSA/IGRvX2Vhcmx5
X3BhcmFtKzB4NzgvMHg3OApbICAgIDMuMDA4MTA5XSAgWzw4MWI5MjM4Yj5dIGtlcm5lbF9p
bml0KzB4Yi8weGQwClsgICAgMy4wMDgxMDldICBbPDgxMDYzYjEyPl0gPyBzY2hlZHVsZV90
YWlsKzB4MTIvMHg0MApbICAgIDMuMDA4MTA5XSAgWzw4MWJiMDA4MD5dIHJldF9mcm9tX2tl
cm5lbF90aHJlYWQrMHgyMC8weDMwClsgICAgMy4wMDgxMDldICBbPDgxYjkyMzgwPl0gPyBy
ZXN0X2luaXQrMHgxMzAvMHgxMzAKWyAgICAzLjAwODEwOV0gPT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWliMC0wNTMwMDg0MS9iYWZlOTgwZjVhZmM3Y2NjNjkzZmQ4YzgxYzhhYTVhMDJm
YmI1YWUwL2RtZXNnLXF1YW50YWwtaXZiNDMtMTE4OjIwMTQwNTMwMDk1OTQ4OmkzODYtcmFu
ZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4wLXJjNS0wMDU2Ny1nYmFmZTk4MDoxCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS9iYWZlOTgwZjVhZmM3Y2NjNjkzZmQ4
YzgxYzhhYTVhMDJmYmI1YWUwL2RtZXNnLXF1YW50YWwtaXZiNDQtMzY6MjAxNDA1MzAwOTU4
MzA6aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MTozLjE1LjAtcmM1LTAwNTY3LWdiYWZl
OTgwOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxL2JhZmU5ODBmNWFm
YzdjY2M2OTNmZDhjODFjOGFhNWEwMmZiYjVhZTAvZG1lc2cteW9jdG8taXZiNDEtNDc6MjAx
NDA1MzAwOTU5NDM6aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MTozLjE1LjAtcmM1LTAw
NTY3LWdiYWZlOTgwOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxL2Jh
ZmU5ODBmNWFmYzdjY2M2OTNmZDhjODFjOGFhNWEwMmZiYjVhZTAvZG1lc2cteW9jdG8taXZi
NDItODA6MjAxNDA1MzAwOTU4MzU6aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MTozLjE1
LjAtcmM1LTAwNTY3LWdiYWZlOTgwOjEKMDo0OjQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKG1sxOzM1bTIwMTQtMDUtMzAgMTA6MDA6MTAgUkVQRUFUIENPVU5UOiAyMCAgIyAvYy9i
b290LWJpc2VjdC9saW51eDIvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAw
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBzKQpb
ZWU3NWVjYmQ4YjlhZDI2Y2QwMDk0NTczY2Q0YjYxMmFiMjBiM2U3MV0gcHJpbnRrOiBmaXgg
bG9ja2RlcCBpbnN0cnVtZW50YXRpb24gb2YgY29uc29sZV9zZW0KcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xp
bnV4Mi9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctaWIwLTA1MzAwODQxL25leHQ6bWFzdGVyOmVlNzVlY2JkOGI5YWQyNmNk
MDA5NDU3M2NkNGI2MTJhYjIwYjNlNzE6YmlzZWN0LWxpbnV4MgoKMjAxNC0wNS0zMC0xMDow
MDoxMCBlZTc1ZWNiZDhiOWFkMjZjZDAwOTQ1NzNjZDRiNjEyYWIyMGIzZTcxIGNvbXBpbGlu
ZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEtZWU3NWVjYmQ4YjlhZDI2Y2QwMDk0NTczY2Q0YjYx
MmFiMjBiM2U3MQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWliMC0wNTMwMDg0MS9lZTc1ZWNiZDhiOWFkMjZjZDAwOTQ1NzNjZDRiNjEyYWIyMGIzZTcx
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLWVlNzVlY2JkOGI5YWQyNmNkMDA5NDU3M2Nk
NGI2MTJhYjIwYjNlNzEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3Rz
L2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLWVlNzVlY2JkOGI5
YWQyNmNkMDA5NDU3M2NkNGI2MTJhYjIwYjNlNzEKa2VybmVsOiAva2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pYjAtMDUzMDA4NDEvZWU3NWVjYmQ4YjlhZDI2Y2QwMDk0NTczY2Q0YjYxMmFi
MjBiM2U3MS92bWxpbnV6LTMuMTUuMC1yYzUtMDA1NjYtZ2VlNzVlY2IKCjIwMTQtMDUtMzAt
MTA6MDk6MTAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgk0CTIwIFNVQ0NFU1MKCmJhZmU5ODBm
NWFmYzdjY2M2OTNmZDhjODFjOGFhNWEwMmZiYjVhZTAgaXMgdGhlIGZpcnN0IGJhZCBjb21t
aXQKY29tbWl0IGJhZmU5ODBmNWFmYzdjY2M2OTNmZDhjODFjOGFhNWEwMmZiYjVhZTAKQXV0
aG9yOiBKYW4gS2FyYSA8amFja0BzdXNlLmN6PgpEYXRlOiAgIFRodSBNYXkgMjIgMTA6NDM6
MzUgMjAxNCArMTAwMAoKICAgIHByaW50azogZW5hYmxlIGludGVycnVwdHMgYmVmb3JlIGNh
bGxpbmcgY29uc29sZV90cnlsb2NrX2Zvcl9wcmludGsoKQogICAgCiAgICBXZSBuZWVkIGlu
dGVycnVwdHMgZGlzYWJsZWQgd2hlbiBjYWxsaW5nIGNvbnNvbGVfdHJ5bG9ja19mb3JfcHJp
bnRrKCkgb25seQogICAgc28gdGhhdCBjcHUgaWQgd2UgcGFzcyB0byBjYW5fdXNlX2NvbnNv
bGUoKSByZW1haW5zIHZhbGlkIChmb3Igb3RoZXIKICAgIHRoaW5ncyBjb25zb2xlX3NlbSBw
cm92aWRlcyBhbGwgdGhlIGV4Y2x1c2lvbiB3ZSBuZWVkIGFuZCBkZWFkbG9ja3Mgb24KICAg
IGNvbnNvbGVfc2VtIGR1ZSB0byBpbnRlcnJ1cHRzIGFyZSBpbXBvc3NpYmxlIGJlY2F1c2Ug
d2UgdXNlCiAgICBkb3duX3RyeWxvY2soKSkuICBIb3dldmVyIGlmIHdlIGFyZSByZXNjaGVk
dWxlZCwgd2UgYXJlIGd1YXJhbnRlZWQgdG8gcnVuCiAgICBvbiBhbiBvbmxpbmUgY3B1IHNv
IHdlIGNhbiBlYXNpbHkganVzdCBnZXQgdGhlIGNwdSBpZCBpbgogICAgY2FuX3VzZV9jb25z
b2xlKCkuCiAgICAKICAgIFdlIGNhbiBsb3NlIGEgYml0IG9mIHBlcmZvcm1hbmNlIHdoZW4g
d2UgZW5hYmxlIGludGVycnVwdHMgaW4KICAgIHZwcmludGtfZW1pdCgpIGFuZCB0aGVuIGRp
c2FibGUgdGhlbSBhZ2FpbiBpbiBjb25zb2xlX3VubG9jaygpIGJ1dCBPVE9IIGl0CiAgICBj
YW4gc29tZXdoYXQgcmVkdWNlIGludGVycnVwdCBsYXRlbmN5IGNhdXNlZCBieSBjb25zb2xl
X3VubG9jaygpCiAgICBlc3BlY2lhbGx5IHNpbmNlIGxhdGVyIGluIHRoZSBwYXRjaCBzZXJp
ZXMgd2Ugd2lsbCB3YW50IHRvIHNwaW4gb24KICAgIGNvbnNvbGVfc2VtIGluIGNvbnNvbGVf
dHJ5bG9ja19mb3JfcHJpbnRrKCkuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IEphbiBLYXJh
IDxqYWNrQHN1c2UuY3o+CiAgICBTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgTW9ydG9uIDxha3Bt
QGxpbnV4LWZvdW5kYXRpb24ub3JnPgoKOjA0MDAwMCAwNDAwMDAgMWQyNDRlYzNkNzA3OWE1
OGUwZTg1NGJhODE2ZWJmMTA4OWZkYmQxNiA5ZjI2ZDVjNzE1MDQ3YjljZjI1OGM5NzNkNGJk
M2RmZGQ1YTQxMzU0IE0Ja2VybmVsCmJpc2VjdCBydW4gc3VjY2VzcwpIRUFEIGlzIG5vdyBh
dCBlZTc1ZWNiLi4uIHByaW50azogZml4IGxvY2tkZXAgaW5zdHJ1bWVudGF0aW9uIG9mIGNv
bnNvbGVfc2VtCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctaWIwLTA1MzAwODQxL25leHQ6bWFzdGVyOmVlNzVlY2JkOGI5YWQyNmNkMDA5NDU3
M2NkNGI2MTJhYjIwYjNlNzE6YmlzZWN0LWxpbnV4MgoKMjAxNC0wNS0zMC0xMDoxMDo0MSBl
ZTc1ZWNiZDhiOWFkMjZjZDAwOTQ1NzNjZDRiNjEyYWIyMGIzZTcxIHJldXNlIC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS9lZTc1ZWNiZDhiOWFkMjZjZDAwOTQ1NzNj
ZDRiNjEyYWIyMGIzZTcxL3ZtbGludXotMy4xNS4wLXJjNS0wMDU2Ni1nZWU3NWVjYgoKMjAx
NC0wNS0zMC0xMDoxMDo0MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuLi4JNTMJNjAgU1VDQ0VT
UwoKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZWU3NWVjYi4uLiBwcmludGs6IGZpeCBs
b2NrZGVwIGluc3RydW1lbnRhdGlvbiBvZiBjb25zb2xlX3NlbQpIRUFEIGlzIG5vdyBhdCAw
N2RkOTk5Li4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAyMDE0MDUyOQps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWliMC0w
NTMwMDg0MS9uZXh0Om1hc3RlcjowN2RkOTk5Zjk5YjExMzVmZGVjZTY5N2UxN2M0ZjQyNDhh
YjQwZjcyOmJpc2VjdC1saW51eDIKIFRFU1QgRkFJTFVSRQpbICAgIDMuMDQ2NDM3XSBFREQg
aW5mb3JtYXRpb24gbm90IGF2YWlsYWJsZS4KWyAgICAzLjA0NjkwOF0gIyMjIGR0LXRlc3Qg
IyMjIE5vIHRlc3RjYXNlIGRhdGEgaW4gZGV2aWNlIHRyZWU7IG5vdCBydW5uaW5nIHRlc3Rz
ClsgICAgMy4wNDc3NTJdIApbICAgIDMuMDUwMTc2XSBCVUc6IHNwaW5sb2NrIGxvY2t1cCBz
dXNwZWN0ZWQgb24gQ1BVIzAsIHN3YXBwZXIvMQpbICAgIDMuMDUwMTc2XSAgbG9jazogc2Vy
aWFsODI1MF9wb3J0cysweDAvMHg0YzAsIC5tYWdpYzogZGVhZDRlYWQsIC5vd25lcjogc3dh
cHBlci8xLCAub3duZXJfY3B1OiAwClsgICAgMy4wNTAxNzZdIENQVTogMCBQSUQ6IDEgQ29t
bTogc3dhcHBlciBOb3QgdGFpbnRlZCAzLjE1LjAtcmM3LW5leHQtMjAxNDA1MjkgIzUKWyAg
ICAzLjA1MDE3Nl0gIDgwMDQwMDAwIDgwMDQwMDAwIDgwMDI3YTdjIDgxYmIxYmUwIDgwMDI3
YWE0IDgxYmFjN2QwIDgxZWRmNmQ4IDgyYTI2NGUwClsgICAgMy4wNTAxNzZdICBkZWFkNGVh
ZCA4MDA0MDM0NCAwMDAwMDAwMSAwMDAwMDAwMCA4MmEyNjRlMCBhMDhhYTlkMCA4MDAyN2Fj
MCA4MTA3N2U4NwpbICAgIDMuMDUwMTc2XSAgYTA4YWE5ZDAgMDAwMDAwMDAgODJhMjY0ZTAg
MDAwMDAwODIgMDAwMDAwMDEgODAwMjdhZTAgODFiYzQ5NzQgMDAwMDAwMDAKWyAgICAzLjA1
MDE3Nl0gQ2FsbCBUcmFjZToKWyAgICAzLjA1MDE3Nl0gIFs8ODFiYjFiZTA+XSBkdW1wX3N0
YWNrKzB4MTYvMHgxOApbICAgIDMuMDUwMTc2XSAgWzw4MWJhYzdkMD5dIHNwaW5fZHVtcCsw
eDkwLzB4OTcKWyAgICAzLjA1MDE3Nl0gIFs8ODEwNzdlODc+XSBkb19yYXdfc3Bpbl9sb2Nr
KzB4YTcvMHhmMApbICAgIDMuMDUwMTc2XSAgWzw4MWJjNDk3ND5dIF9yYXdfc3Bpbl9sb2Nr
X2lycXNhdmUrMHg1NC8weDYwClsgICAgMy4wNTAxNzZdICBbPDgxNWZkMjZjPl0gPyBzZXJp
YWw4MjUwX2NvbnNvbGVfd3JpdGUrMHgxMWMvMHgxNDAKWyAgICAzLjA1MDE3Nl0gIFs8ODE1
ZmQxNTA+XSA/IHNlcmlhbDgyNTBfbW9kZW1fc3RhdHVzKzB4YzAvMHhjMApbICAgIDMuMDUw
MTc2XSAgWzw4MTVmZDI2Yz5dIHNlcmlhbDgyNTBfY29uc29sZV93cml0ZSsweDExYy8weDE0
MApbICAgIDMuMDUwMTc2XSAgWzw4MTVmZDE1MD5dID8gc2VyaWFsODI1MF9tb2RlbV9zdGF0
dXMrMHhjMC8weGMwClsgICAgMy4wNTAxNzZdICBbPDgxMDdiZDM0Pl0gY2FsbF9jb25zb2xl
X2RyaXZlcnMuY29uc3Rwcm9wLjIwKzB4NjQvMHgxMzAKWyAgICAzLjA1MDE3Nl0gIFs8ODEw
N2M1MGQ+XSBjb25zb2xlX3VubG9jaysweDQ5ZC8weDUzMApbICAgIDMuMDUwMTc2XSAgWzw4
MTA3YzgxZD5dIHZwcmludGtfZW1pdCsweDI3ZC8weDU0MApbICAgIDMuMDUwMTc2XSAgWzw4
MWJhYzhiOT5dIHByaW50aysweDM4LzB4M2EKWyAgICAzLjA1MDE3Nl0gIFs8ODFiYWJlZDA+
XSBwcmludF9jaXJjdWxhcl9idWdfaGVhZGVyKzB4MzUvMHhjMQpbICAgIDMuMDUwMTc2XSAg
Wzw4MWJhYmZjNj5dIHByaW50X2NpcmN1bGFyX2J1ZysweDZhLzB4MjY4ClsgICAgMy4wNTAx
NzZdICBbPDgxMDc0YWQyPl0gX19sb2NrX2FjcXVpcmUrMHgxOWMyLzB4MWIyMApbICAgIDMu
MDUwMTc2XSAgWzw4MTA3MTQyOD5dID8gY2hlY2tfaXJxX3VzYWdlKzB4ODgvMHhjMApbICAg
IDMuMDUwMTc2XSAgWzw4MTA3NTdmNT5dIGxvY2tfYWNxdWlyZSsweDg1LzB4MTkwClsgICAg
My4wNTAxNzZdICBbPDgxMDdlNWRjPl0gPyBfX2lycV9nZXRfZGVzY19sb2NrKzB4M2MvMHg3
MApbICAgIDMuMDUwMTc2XSAgWzw4MWJjNDk2ZD5dIF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUr
MHg0ZC8weDYwClsgICAgMy4wNTAxNzZdICBbPDgxMDdlNWRjPl0gPyBfX2lycV9nZXRfZGVz
Y19sb2NrKzB4M2MvMHg3MApbICAgIDMuMDUwMTc2XSAgWzw4MTA3ZTVkYz5dIF9faXJxX2dl
dF9kZXNjX2xvY2srMHgzYy8weDcwClsgICAgMy4wNTAxNzZdICBbPDgxMDdmM2NlPl0gX19k
aXNhYmxlX2lycV9ub3N5bmMrMHgxZS8weDUwClsgICAgMy4wNTAxNzZdICBbPDgxMDdmNDA4
Pl0gZGlzYWJsZV9pcnFfbm9zeW5jKzB4OC8weDEwClsgICAgMy4wNTAxNzZdICBbPDgxNWZj
OWI4Pl0gc2VyaWFsODI1MF9zdGFydHVwKzB4NDg4LzB4NzIwClsgICAgMy4wNTAxNzZdICBb
PDgxMGRmZmYwPl0gPyBfX2dldF9mcmVlX3BhZ2VzKzB4MjAvMHg0MApbICAgIDMuMDUwMTc2
XSAgWzw4MTVmOGQ5ZT5dIHVhcnRfc3RhcnR1cC5wYXJ0LjQrMHg2ZS8weDFlMApbICAgIDMu
MDUwMTc2XSAgWzw4MTVmOTc4MD5dIHVhcnRfb3BlbisweGUwLzB4MTQwClsgICAgMy4wNTAx
NzZdICBbPDgxNWY5NmEwPl0gPyB1YXJ0X2lvY3RsKzB4MmYwLzB4MmYwClsgICAgMy4wNTAx
NzZdICBbPDgxNWViODkxPl0gdHR5X29wZW4rMHgxNDEvMHg1MTAKWyAgICAzLjA1MDE3Nl0g
IFs8ODE1ZWI3NTA+XSA/IHR0eV9pb2N0bCsweGIyMC8weGIyMApbICAgIDMuMDUwMTc2XSAg
Wzw4MTExYTg2MD5dIGNocmRldl9vcGVuKzB4NjAvMHgxNDAKWyAgICAzLjA1MDE3Nl0gIFs8
ODExMTUwYmY+XSBkb19kZW50cnlfb3BlbisweDlmLzB4MjgwClsgICAgMy4wNTAxNzZdICBb
PDgxMTFhODAwPl0gPyBleGFjdF9sb2NrKzB4MjAvMHgyMApbICAgIDMuMDUwMTc2XSAgWzw4
MTExNjAyZT5dIGZpbmlzaF9vcGVuKzB4MmUvMHg0MApbICAgIDMuMDUwMTc2XSAgWzw4MTEy
MmQ4YT5dIGRvX2xhc3QrMHg0YWEvMHhkMzAKWyAgICAzLjA1MDE3Nl0gIFs8ODExMjBmNWQ+
XSA/IGxpbmtfcGF0aF93YWxrKzB4MWRkLzB4NzAwClsgICAgMy4wNTAxNzZdICBbPDgxMTIz
NmJhPl0gcGF0aF9vcGVuYXQrMHhhYS8weDYxMApbICAgIDMuMDUwMTc2XSAgWzw4MTEyM2M0
Yz5dIGRvX2ZpbHBfb3BlbisweDJjLzB4NzAKWyAgICAzLjA1MDE3Nl0gIFs8ODExMTY1MTE+
XSBkb19zeXNfb3BlbisweDExMS8weDIxMApbICAgIDMuMDUwMTc2XSAgWzw4MTYwMDAwMD5d
ID8gcGNpc2VyaWFsX2luaXRfcG9ydHMrMHgxNDAvMHgxZDAKWyAgICAzLjA1MDE3Nl0gIFs8
ODExMTY2MmQ+XSBTeVNfb3BlbisweDFkLzB4MjAKWyAgICAzLjA1MDE3Nl0gIFs8ODIxNTZm
MWI+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweDFjNi8weDIzNgpbICAgIDMuMDUwMTc2XSAg
Wzw4MjE1NjU3Mz5dID8gaW5pdGNhbGxfYmxhY2tsaXN0KzB4ODEvMHg4MQpbICAgIDMuMDUw
MTc2XSAgWzw4MWJhOTFjYj5dIGtlcm5lbF9pbml0KzB4Yi8weGQwClsgICAgMy4wNTAxNzZd
ICBbPDgxMDY0MTQyPl0gPyBzY2hlZHVsZV90YWlsKzB4MTIvMHg0MApbICAgIDMuMDUwMTc2
XSAgWzw4MWJjNTQ4MD5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMC8weDMwClsgICAg
My4wNTAxNzZdICBbPDgxYmE5MWMwPl0gPyByZXN0X2luaXQrMHgxMzAvMHgxMzAKWyAgICAz
LjA1MDE3Nl0gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS8wN2RkOTk5
Zjk5YjExMzVmZGVjZTY5N2UxN2M0ZjQyNDhhYjQwZjcyL2RtZXNnLXlvY3RvLWl2YjQ0LTc0
OjIwMTQwNTMwMDg0ODI4OmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4wLXJj
Ny1uZXh0LTIwMTQwNTI5OjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQx
LzA3ZGQ5OTlmOTliMTEzNWZkZWNlNjk3ZTE3YzRmNDI0OGFiNDBmNzIvZG1lc2ctcXVhbnRh
bC1pdmI0My0xMjoyMDE0MDUzMDA4NDk1MDppMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQx
OjMuMTUuMC1yYzctbmV4dC0yMDE0MDUyOTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MC0wNTMwMDg0MS8wN2RkOTk5Zjk5YjExMzVmZGVjZTY5N2UxN2M0ZjQyNDhhYjQwZjcyL2Rt
ZXNnLXF1YW50YWwtaXZiNDEtMTE0OjIwMTQwNTMwMDg0OTM5OmkzODYtcmFuZGNvbmZpZy1p
YjAtMDUzMDA4NDE6My4xNS4wLXJjNy1uZXh0LTIwMTQwNTI5OjUKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaWIwLTA1MzAwODQxLzA3ZGQ5OTlmOTliMTEzNWZkZWNlNjk3ZTE3YzRmNDI0
OGFiNDBmNzIvZG1lc2cteW9jdG8taXZiNDEtNDM6MjAxNDA1MzAwODQ5NDY6aTM4Ni1yYW5k
Y29uZmlnLWliMC0wNTMwMDg0MTozLjE1LjAtcmM3LW5leHQtMjAxNDA1Mjk6NQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvMDdkZDk5OWY5OWIxMTM1ZmRlY2U2OTdl
MTdjNGY0MjQ4YWI0MGY3Mi9kbWVzZy15b2N0by1pdmI0Mi0xMjg6MjAxNDA1MzAwODQzMzQ6
aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MTozLjE1LjAtcmM3LW5leHQtMjAxNDA1Mjk6
NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvMDdkZDk5OWY5OWIxMTM1
ZmRlY2U2OTdlMTdjNGY0MjQ4YWI0MGY3Mi9kbWVzZy15b2N0by1pdmI0My0yMjoyMDE0MDUz
MDA4NDk0MTppMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxOjMuMTUuMC1yYzctbmV4dC0y
MDE0MDUyOTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS8wN2RkOTk5
Zjk5YjExMzVmZGVjZTY5N2UxN2M0ZjQyNDhhYjQwZjcyL2RtZXNnLXF1YW50YWwtaXZiNDQt
MzoyMDE0MDUzMDA4NDgyMTppMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxOjMuMTUuMC1y
YzctbmV4dC0yMDE0MDUyOTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0
MS8wN2RkOTk5Zjk5YjExMzVmZGVjZTY5N2UxN2M0ZjQyNDhhYjQwZjcyL2RtZXNnLXlvY3Rv
LWl2YjQyLTEwNjoyMDE0MDUzMDA4NDM0MzppMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQx
OjMuMTUuMC1yYzctbmV4dC0yMDE0MDUyOTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWli
MC0wNTMwMDg0MS8wN2RkOTk5Zjk5YjExMzVmZGVjZTY5N2UxN2M0ZjQyNDhhYjQwZjcyL2Rt
ZXNnLXF1YW50YWwtaXZiNDQtMjU6MjAxNDA1MzAwODQ4MTU6aTM4Ni1yYW5kY29uZmlnLWli
MC0wNTMwMDg0MTozLjE1LjAtcmM3LW5leHQtMjAxNDA1Mjk6NQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1pYjAtMDUzMDA4NDEvMDdkZDk5OWY5OWIxMTM1ZmRlY2U2OTdlMTdjNGY0MjQ4
YWI0MGY3Mi9kbWVzZy1xdWFudGFsLWl2YjQxLTkzOjIwMTQwNTMwMDg0OTQ1OmkzODYtcmFu
ZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4wLXJjNy1uZXh0LTIwMTQwNTI5OjUKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLzA3ZGQ5OTlmOTliMTEzNWZkZWNlNjk3
ZTE3YzRmNDI0OGFiNDBmNzIvZG1lc2cteW9jdG8taXZiNDMtODc6MjAxNDA1MzAwODQ5NDM6
aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MTozLjE1LjAtcmM3LW5leHQtMjAxNDA1Mjk6
NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvMDdkZDk5OWY5OWIxMTM1
ZmRlY2U2OTdlMTdjNGY0MjQ4YWI0MGY3Mi9kbWVzZy1xdWFudGFsLWl2YjQ0LTExNDoyMDE0
MDUzMDA4NDMyODppMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxOjMuMTUuMC1yYzctbmV4
dC0yMDE0MDUyOTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS8wN2Rk
OTk5Zjk5YjExMzVmZGVjZTY5N2UxN2M0ZjQyNDhhYjQwZjcyL2RtZXNnLXlvY3RvLWl2YjQy
LTIxOjIwMTQwNTMwMDg0ODM4OmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6My4xNS4w
LXJjNy1uZXh0LTIwMTQwNTI5OjUKMDoxMzoxMyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290
cwoKSEVBRCBpcyBub3cgYXQgMDdkZDk5OSBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBmaWxl
cyBmb3IgMjAxNDA1MjkKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0KUHJldmlvdXMg
SEVBRCBwb3NpdGlvbiB3YXMgMDdkZDk5OS4uLiBBZGQgbGludXgtbmV4dCBzcGVjaWZpYyBm
aWxlcyBmb3IgMjAxNDA1MjkKSEVBRCBpcyBub3cgYXQgYTk5MTYzOS4uLiBNZXJnZSB0YWcg
J2FybTY0LWZpeGVzJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tl
cm5lbC9naXQvYXJtNjQvbGludXgKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvbGludXM6bWFzdGVyOmE5OTE2MzljMjZj
NzIzMWRkYjZkZTdmMzQ4OTlmYjcwODMyYjdkMDQ6YmlzZWN0LWxpbnV4MgoKMjAxNC0wNS0z
MC0xMDoxMzoxNyBhOTkxNjM5YzI2YzcyMzFkZGI2ZGU3ZjM0ODk5ZmI3MDgzMmI3ZDA0IGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEtYTk5MTYzOWMyNmM3MjMxZGRiNmRlN2Yz
NDg5OWZiNzA4MzJiN2QwNApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWliMC0wNTMwMDg0MS9hOTkxNjM5YzI2YzcyMzFkZGI2ZGU3ZjM0ODk5ZmI3MDgz
MmI3ZDA0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLWE5OTE2MzljMjZjNzIzMWRkYjZk
ZTdmMzQ4OTlmYjcwODMyYjdkMDQKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxk
LXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLWE5OTE2
MzljMjZjNzIzMWRkYjZkZTdmMzQ4OTlmYjcwODMyYjdkMDQKa2VybmVsOiAva2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvYTk5MTYzOWMyNmM3MjMxZGRiNmRlN2YzNDg5
OWZiNzA4MzJiN2QwNC92bWxpbnV6LTMuMTUuMC1yYzctMDAwNzItZ2E5OTE2MzkKCjIwMTQt
MDUtMzAtMTA6MTU6MTcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JNwkyNAk0MAk1Mgk2MCBT
VUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09ClByZXZpb3VzIEhFQUQg
cG9zaXRpb24gd2FzIGE5OTE2MzkuLi4gTWVyZ2UgdGFnICdhcm02NC1maXhlcycgb2YgZ2l0
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2FybTY0L2xpbnV4
CkhFQUQgaXMgbm93IGF0IDA3ZGQ5OTkuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmls
ZXMgZm9yIDIwMTQwNTI5CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctaWIwLTA1MzAwODQxL25leHQ6bWFzdGVyOjA3ZGQ5OTlmOTliMTEzNWZk
ZWNlNjk3ZTE3YzRmNDI0OGFiNDBmNzI6YmlzZWN0LWxpbnV4MgogVEVTVCBGQUlMVVJFClsg
ICAgMy4wNDY0MzddIEVERCBpbmZvcm1hdGlvbiBub3QgYXZhaWxhYmxlLgpbICAgIDMuMDQ2
OTA4XSAjIyMgZHQtdGVzdCAjIyMgTm8gdGVzdGNhc2UgZGF0YSBpbiBkZXZpY2UgdHJlZTsg
bm90IHJ1bm5pbmcgdGVzdHMKWyAgICAzLjA0Nzc1Ml0gClsgICAgMy4wNTAxNzZdIEJVRzog
c3BpbmxvY2sgbG9ja3VwIHN1c3BlY3RlZCBvbiBDUFUjMCwgc3dhcHBlci8xClsgICAgMy4w
NTAxNzZdICBsb2NrOiBzZXJpYWw4MjUwX3BvcnRzKzB4MC8weDRjMCwgLm1hZ2ljOiBkZWFk
NGVhZCwgLm93bmVyOiBzd2FwcGVyLzEsIC5vd25lcl9jcHU6IDAKWyAgICAzLjA1MDE3Nl0g
Q1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDMuMTUuMC1yYzctbmV4
dC0yMDE0MDUyOSAjNQpbICAgIDMuMDUwMTc2XSAgODAwNDAwMDAgODAwNDAwMDAgODAwMjdh
N2MgODFiYjFiZTAgODAwMjdhYTQgODFiYWM3ZDAgODFlZGY2ZDggODJhMjY0ZTAKWyAgICAz
LjA1MDE3Nl0gIGRlYWQ0ZWFkIDgwMDQwMzQ0IDAwMDAwMDAxIDAwMDAwMDAwIDgyYTI2NGUw
IGEwOGFhOWQwIDgwMDI3YWMwIDgxMDc3ZTg3ClsgICAgMy4wNTAxNzZdICBhMDhhYTlkMCAw
MDAwMDAwMCA4MmEyNjRlMCAwMDAwMDA4MiAwMDAwMDAwMSA4MDAyN2FlMCA4MWJjNDk3NCAw
MDAwMDAwMApbICAgIDMuMDUwMTc2XSBDYWxsIFRyYWNlOgpbICAgIDMuMDUwMTc2XSAgWzw4
MWJiMWJlMD5dIGR1bXBfc3RhY2srMHgxNi8weDE4ClsgICAgMy4wNTAxNzZdICBbPDgxYmFj
N2QwPl0gc3Bpbl9kdW1wKzB4OTAvMHg5NwpbICAgIDMuMDUwMTc2XSAgWzw4MTA3N2U4Nz5d
IGRvX3Jhd19zcGluX2xvY2srMHhhNy8weGYwClsgICAgMy4wNTAxNzZdICBbPDgxYmM0OTc0
Pl0gX3Jhd19zcGluX2xvY2tfaXJxc2F2ZSsweDU0LzB4NjAKWyAgICAzLjA1MDE3Nl0gIFs8
ODE1ZmQyNmM+XSA/IHNlcmlhbDgyNTBfY29uc29sZV93cml0ZSsweDExYy8weDE0MApbICAg
IDMuMDUwMTc2XSAgWzw4MTVmZDE1MD5dID8gc2VyaWFsODI1MF9tb2RlbV9zdGF0dXMrMHhj
MC8weGMwClsgICAgMy4wNTAxNzZdICBbPDgxNWZkMjZjPl0gc2VyaWFsODI1MF9jb25zb2xl
X3dyaXRlKzB4MTFjLzB4MTQwClsgICAgMy4wNTAxNzZdICBbPDgxNWZkMTUwPl0gPyBzZXJp
YWw4MjUwX21vZGVtX3N0YXR1cysweGMwLzB4YzAKWyAgICAzLjA1MDE3Nl0gIFs8ODEwN2Jk
MzQ+XSBjYWxsX2NvbnNvbGVfZHJpdmVycy5jb25zdHByb3AuMjArMHg2NC8weDEzMApbICAg
IDMuMDUwMTc2XSAgWzw4MTA3YzUwZD5dIGNvbnNvbGVfdW5sb2NrKzB4NDlkLzB4NTMwClsg
ICAgMy4wNTAxNzZdICBbPDgxMDdjODFkPl0gdnByaW50a19lbWl0KzB4MjdkLzB4NTQwClsg
ICAgMy4wNTAxNzZdICBbPDgxYmFjOGI5Pl0gcHJpbnRrKzB4MzgvMHgzYQpbICAgIDMuMDUw
MTc2XSAgWzw4MWJhYmVkMD5dIHByaW50X2NpcmN1bGFyX2J1Z19oZWFkZXIrMHgzNS8weGMx
ClsgICAgMy4wNTAxNzZdICBbPDgxYmFiZmM2Pl0gcHJpbnRfY2lyY3VsYXJfYnVnKzB4NmEv
MHgyNjgKWyAgICAzLjA1MDE3Nl0gIFs8ODEwNzRhZDI+XSBfX2xvY2tfYWNxdWlyZSsweDE5
YzIvMHgxYjIwClsgICAgMy4wNTAxNzZdICBbPDgxMDcxNDI4Pl0gPyBjaGVja19pcnFfdXNh
Z2UrMHg4OC8weGMwClsgICAgMy4wNTAxNzZdICBbPDgxMDc1N2Y1Pl0gbG9ja19hY3F1aXJl
KzB4ODUvMHgxOTAKWyAgICAzLjA1MDE3Nl0gIFs8ODEwN2U1ZGM+XSA/IF9faXJxX2dldF9k
ZXNjX2xvY2srMHgzYy8weDcwClsgICAgMy4wNTAxNzZdICBbPDgxYmM0OTZkPl0gX3Jhd19z
cGluX2xvY2tfaXJxc2F2ZSsweDRkLzB4NjAKWyAgICAzLjA1MDE3Nl0gIFs8ODEwN2U1ZGM+
XSA/IF9faXJxX2dldF9kZXNjX2xvY2srMHgzYy8weDcwClsgICAgMy4wNTAxNzZdICBbPDgx
MDdlNWRjPl0gX19pcnFfZ2V0X2Rlc2NfbG9jaysweDNjLzB4NzAKWyAgICAzLjA1MDE3Nl0g
IFs8ODEwN2YzY2U+XSBfX2Rpc2FibGVfaXJxX25vc3luYysweDFlLzB4NTAKWyAgICAzLjA1
MDE3Nl0gIFs8ODEwN2Y0MDg+XSBkaXNhYmxlX2lycV9ub3N5bmMrMHg4LzB4MTAKWyAgICAz
LjA1MDE3Nl0gIFs8ODE1ZmM5Yjg+XSBzZXJpYWw4MjUwX3N0YXJ0dXArMHg0ODgvMHg3MjAK
WyAgICAzLjA1MDE3Nl0gIFs8ODEwZGZmZjA+XSA/IF9fZ2V0X2ZyZWVfcGFnZXMrMHgyMC8w
eDQwClsgICAgMy4wNTAxNzZdICBbPDgxNWY4ZDllPl0gdWFydF9zdGFydHVwLnBhcnQuNCsw
eDZlLzB4MWUwClsgICAgMy4wNTAxNzZdICBbPDgxNWY5NzgwPl0gdWFydF9vcGVuKzB4ZTAv
MHgxNDAKWyAgICAzLjA1MDE3Nl0gIFs8ODE1Zjk2YTA+XSA/IHVhcnRfaW9jdGwrMHgyZjAv
MHgyZjAKWyAgICAzLjA1MDE3Nl0gIFs8ODE1ZWI4OTE+XSB0dHlfb3BlbisweDE0MS8weDUx
MApbICAgIDMuMDUwMTc2XSAgWzw4MTVlYjc1MD5dID8gdHR5X2lvY3RsKzB4YjIwLzB4YjIw
ClsgICAgMy4wNTAxNzZdICBbPDgxMTFhODYwPl0gY2hyZGV2X29wZW4rMHg2MC8weDE0MApb
ICAgIDMuMDUwMTc2XSAgWzw4MTExNTBiZj5dIGRvX2RlbnRyeV9vcGVuKzB4OWYvMHgyODAK
WyAgICAzLjA1MDE3Nl0gIFs8ODExMWE4MDA+XSA/IGV4YWN0X2xvY2srMHgyMC8weDIwClsg
ICAgMy4wNTAxNzZdICBbPDgxMTE2MDJlPl0gZmluaXNoX29wZW4rMHgyZS8weDQwClsgICAg
My4wNTAxNzZdICBbPDgxMTIyZDhhPl0gZG9fbGFzdCsweDRhYS8weGQzMApbICAgIDMuMDUw
MTc2XSAgWzw4MTEyMGY1ZD5dID8gbGlua19wYXRoX3dhbGsrMHgxZGQvMHg3MDAKWyAgICAz
LjA1MDE3Nl0gIFs8ODExMjM2YmE+XSBwYXRoX29wZW5hdCsweGFhLzB4NjEwClsgICAgMy4w
NTAxNzZdICBbPDgxMTIzYzRjPl0gZG9fZmlscF9vcGVuKzB4MmMvMHg3MApbICAgIDMuMDUw
MTc2XSAgWzw4MTExNjUxMT5dIGRvX3N5c19vcGVuKzB4MTExLzB4MjEwClsgICAgMy4wNTAx
NzZdICBbPDgxNjAwMDAwPl0gPyBwY2lzZXJpYWxfaW5pdF9wb3J0cysweDE0MC8weDFkMApb
ICAgIDMuMDUwMTc2XSAgWzw4MTExNjYyZD5dIFN5U19vcGVuKzB4MWQvMHgyMApbICAgIDMu
MDUwMTc2XSAgWzw4MjE1NmYxYj5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4MWM2LzB4MjM2
ClsgICAgMy4wNTAxNzZdICBbPDgyMTU2NTczPl0gPyBpbml0Y2FsbF9ibGFja2xpc3QrMHg4
MS8weDgxClsgICAgMy4wNTAxNzZdICBbPDgxYmE5MWNiPl0ga2VybmVsX2luaXQrMHhiLzB4
ZDAKWyAgICAzLjA1MDE3Nl0gIFs8ODEwNjQxNDI+XSA/IHNjaGVkdWxlX3RhaWwrMHgxMi8w
eDQwClsgICAgMy4wNTAxNzZdICBbPDgxYmM1NDgwPl0gcmV0X2Zyb21fa2VybmVsX3RocmVh
ZCsweDIwLzB4MzAKWyAgICAzLjA1MDE3Nl0gIFs8ODFiYTkxYzA+XSA/IHJlc3RfaW5pdCsw
eDEzMC8weDEzMApbICAgIDMuMDUwMTc2XSA9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT0KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIw
LTA1MzAwODQxLzA3ZGQ5OTlmOTliMTEzNWZkZWNlNjk3ZTE3YzRmNDI0OGFiNDBmNzIvZG1l
c2cteW9jdG8taXZiNDQtNzQ6MjAxNDA1MzAwODQ4Mjg6aTM4Ni1yYW5kY29uZmlnLWliMC0w
NTMwMDg0MTozLjE1LjAtcmM3LW5leHQtMjAxNDA1Mjk6NQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1pYjAtMDUzMDA4NDEvMDdkZDk5OWY5OWIxMTM1ZmRlY2U2OTdlMTdjNGY0MjQ4YWI0
MGY3Mi9kbWVzZy1xdWFudGFsLWl2YjQzLTEyOjIwMTQwNTMwMDg0OTUwOmkzODYtcmFuZGNv
bmZpZy1pYjAtMDUzMDA4NDE6My4xNS4wLXJjNy1uZXh0LTIwMTQwNTI5OjUKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLzA3ZGQ5OTlmOTliMTEzNWZkZWNlNjk3ZTE3
YzRmNDI0OGFiNDBmNzIvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMTQ6MjAxNDA1MzAwODQ5Mzk6
aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MTozLjE1LjAtcmM3LW5leHQtMjAxNDA1Mjk6
NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvMDdkZDk5OWY5OWIxMTM1
ZmRlY2U2OTdlMTdjNGY0MjQ4YWI0MGY3Mi9kbWVzZy15b2N0by1pdmI0MS00MzoyMDE0MDUz
MDA4NDk0NjppMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxOjMuMTUuMC1yYzctbmV4dC0y
MDE0MDUyOTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS8wN2RkOTk5
Zjk5YjExMzVmZGVjZTY5N2UxN2M0ZjQyNDhhYjQwZjcyL2RtZXNnLXlvY3RvLWl2YjQyLTEy
ODoyMDE0MDUzMDA4NDMzNDppMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxOjMuMTUuMC1y
YzctbmV4dC0yMDE0MDUyOTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0
MS8wN2RkOTk5Zjk5YjExMzVmZGVjZTY5N2UxN2M0ZjQyNDhhYjQwZjcyL2RtZXNnLXlvY3Rv
LWl2YjQzLTIyOjIwMTQwNTMwMDg0OTQxOmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDE6
My4xNS4wLXJjNy1uZXh0LTIwMTQwNTI5OjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaWIw
LTA1MzAwODQxLzA3ZGQ5OTlmOTliMTEzNWZkZWNlNjk3ZTE3YzRmNDI0OGFiNDBmNzIvZG1l
c2ctcXVhbnRhbC1pdmI0NC0zOjIwMTQwNTMwMDg0ODIxOmkzODYtcmFuZGNvbmZpZy1pYjAt
MDUzMDA4NDE6My4xNS4wLXJjNy1uZXh0LTIwMTQwNTI5OjUKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaWIwLTA1MzAwODQxLzA3ZGQ5OTlmOTliMTEzNWZkZWNlNjk3ZTE3YzRmNDI0OGFi
NDBmNzIvZG1lc2cteW9jdG8taXZiNDItMTA2OjIwMTQwNTMwMDg0MzQzOmkzODYtcmFuZGNv
bmZpZy1pYjAtMDUzMDA4NDE6My4xNS4wLXJjNy1uZXh0LTIwMTQwNTI5OjUKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxLzA3ZGQ5OTlmOTliMTEzNWZkZWNlNjk3ZTE3
YzRmNDI0OGFiNDBmNzIvZG1lc2ctcXVhbnRhbC1pdmI0NC0yNToyMDE0MDUzMDA4NDgxNTpp
Mzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxOjMuMTUuMC1yYzctbmV4dC0yMDE0MDUyOTo1
Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MS8wN2RkOTk5Zjk5YjExMzVm
ZGVjZTY5N2UxN2M0ZjQyNDhhYjQwZjcyL2RtZXNnLXF1YW50YWwtaXZiNDEtOTM6MjAxNDA1
MzAwODQ5NDU6aTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0MTozLjE1LjAtcmM3LW5leHQt
MjAxNDA1Mjk6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4NDEvMDdkZDk5
OWY5OWIxMTM1ZmRlY2U2OTdlMTdjNGY0MjQ4YWI0MGY3Mi9kbWVzZy15b2N0by1pdmI0My04
NzoyMDE0MDUzMDA4NDk0MzppMzg2LXJhbmRjb25maWctaWIwLTA1MzAwODQxOjMuMTUuMC1y
YzctbmV4dC0yMDE0MDUyOTo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWliMC0wNTMwMDg0
MS8wN2RkOTk5Zjk5YjExMzVmZGVjZTY5N2UxN2M0ZjQyNDhhYjQwZjcyL2RtZXNnLXF1YW50
YWwtaXZiNDQtMTE0OjIwMTQwNTMwMDg0MzI4OmkzODYtcmFuZGNvbmZpZy1pYjAtMDUzMDA4
NDE6My4xNS4wLXJjNy1uZXh0LTIwMTQwNTI5OjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aWIwLTA1MzAwODQxLzA3ZGQ5OTlmOTliMTEzNWZkZWNlNjk3ZTE3YzRmNDI0OGFiNDBmNzIv
ZG1lc2cteW9jdG8taXZiNDItMjE6MjAxNDA1MzAwODQ4Mzg6aTM4Ni1yYW5kY29uZmlnLWli
MC0wNTMwMDg0MTozLjE1LjAtcmM3LW5leHQtMjAxNDA1Mjk6NQowOjEzOjEzIGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzCgo=
--------------040306070508090709090006
Content-Type: text/plain; charset=UTF-8;
 name="config-3.15.0-rc5-00567-gbafe980"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-3.15.0-rc5-00567-gbafe980"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.15.0-rc5 Kernel Configuration
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
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
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
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
# CONFIG_UID16 is not set
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
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
# CONFIG_SLOB is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
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
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
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
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBDAF=y
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
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_GOLDFISH=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_GOLDFISH=y
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
CONFIG_X86_32_IRIS=y
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
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
CONFIG_MPENTIUMII=y
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
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_MICROCODE_EARLY is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
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
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_NEED_PER_CPU_KM=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
# CONFIG_RANDOMIZE_BASE is not set
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

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
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

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
# CONFIG_PCI_CNB20LE_QUIRK is not set
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
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
# CONFIG_EISA_VIRTUAL_ROOT is not set
CONFIG_EISA_NAMES=y
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
CONFIG_NET5501=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
CONFIG_TCIC=y
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
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_LTPC=y
# CONFIG_COPS is not set
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
# CONFIG_BATMAN_ADV_NC is not set
CONFIG_BATMAN_ADV_MCAST=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
# CONFIG_HSR is not set
CONFIG_CGROUP_NET_PRIO=y
# CONFIG_CGROUP_NET_CLASSID is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_HAMRADIO is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
CONFIG_CAN_BCM=y
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
# CONFIG_CAN_SLCAN is not set
CONFIG_CAN_DEV=y
# CONFIG_CAN_CALC_BITTIMING is not set
CONFIG_CAN_LEDS=y
# CONFIG_PCH_CAN is not set
CONFIG_CAN_GRCAN=y
# CONFIG_CAN_SJA1000 is not set
CONFIG_CAN_C_CAN=y
# CONFIG_CAN_C_CAN_PLATFORM is not set
# CONFIG_CAN_C_CAN_STRICT_FRAME_ORDERING is not set
# CONFIG_CAN_C_CAN_PCI is not set
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
CONFIG_CAN_ESD_USB2=y
CONFIG_CAN_KVASER_USB=y
CONFIG_CAN_PEAK_USB=y
CONFIG_CAN_8DEV_USB=y
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
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
CONFIG_MAC80211=y
# CONFIG_MAC80211_RC_PID is not set
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""

#
# Some wireless drivers require a rate control algorithm
#
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=y
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
CONFIG_NFC_SHDLC=y

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y
CONFIG_NFC_SIM=y
CONFIG_NFC_PORT100=y
CONFIG_NFC_PN544=y
CONFIG_NFC_PN544_I2C=y
CONFIG_NFC_MICROREAD=y
CONFIG_NFC_MICROREAD_I2C=y
CONFIG_NFC_MRVL=y
# CONFIG_NFC_MRVL_USB is not set

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
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
CONFIG_MTD_REDBOOT_PARTS=y
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
CONFIG_MTD_OF_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=y
# CONFIG_NFTL is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
CONFIG_MTD_OOPS=y
CONFIG_MTD_SWAP=y

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
# CONFIG_MTD_CFI_AMDSTD is not set
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
CONFIG_MTD_ROM=y
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
# CONFIG_MTD_PHYSMAP_OF is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_SCx200_DOCFLASH=y
# CONFIG_MTD_AMD76XROM is not set
CONFIG_MTD_ICHXROM=y
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=y
CONFIG_MTD_NAND_BCH=y
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=y
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_GPIO=y
CONFIG_MTD_NAND_IDS=y
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=y
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_DOCG4=y
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_CS553X is not set
CONFIG_MTD_NAND_NANDSIM=y
CONFIG_MTD_NAND_PLATFORM=y
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
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
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_ADDRESS_PCI=y
CONFIG_OF_IRQ=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_OF_MTD=y
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=y
CONFIG_BLK_DEV_FD=y
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_AD525X_DPOT is not set
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
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
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
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AHA152X=y
CONFIG_SCSI_AHA1542=y
CONFIG_SCSI_AHA1740=y
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_IN2000=y
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_ISCI is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_NCR53C406A=y
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_PAS16=y
CONFIG_SCSI_QLOGIC_FAS=y
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SIM710=y
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_T128=y
CONFIG_SCSI_U14_34F=y
# CONFIG_SCSI_U14_34F_TAGGED_QUEUE is not set
CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
CONFIG_SCSI_U14_34F_MAX_TAGS=8
CONFIG_SCSI_ULTRASTOR=y
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
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
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
CONFIG_PATA_PLATFORM=y
CONFIG_PATA_OF_PLATFORM=y
CONFIG_PATA_QDI=y
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_WINBOND_VLB is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
CONFIG_PATA_LEGACY=y
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
# CONFIG_DM_CACHE is not set
# CONFIG_DM_ERA is not set
CONFIG_DM_MIRROR=y
# CONFIG_DM_LOG_USERSPACE is not set
# CONFIG_DM_RAID is not set
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=y
CONFIG_DM_VERITY=y
CONFIG_DM_SWITCH=y
CONFIG_TARGET_CORE=y
# CONFIG_TCM_IBLOCK is not set
CONFIG_TCM_FILEIO=y
CONFIG_TCM_PSCSI=y
# CONFIG_LOOPBACK_TARGET is not set
CONFIG_ISCSI_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
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
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
# CONFIG_KEYBOARD_QT2160 is not set
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_GOLDFISH_EVENTS=y
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_TC3589X=y
# CONFIG_KEYBOARD_TWL4030 is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_KEYBOARD_CROS_EC=y
CONFIG_INPUT_LEDS=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
# CONFIG_JOYSTICK_ZHENHUA is not set
CONFIG_JOYSTICK_DB9=y
CONFIG_JOYSTICK_GAMECON=y
# CONFIG_JOYSTICK_TURBOGRAFX is not set
CONFIG_JOYSTICK_AS5011=y
# CONFIG_JOYSTICK_JOYDUMP is not set
CONFIG_JOYSTICK_XPAD=y
# CONFIG_JOYSTICK_XPAD_FF is not set
# CONFIG_JOYSTICK_XPAD_LEDS is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
# CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
# CONFIG_TOUCHSCREEN_DA9034 is not set
CONFIG_TOUCHSCREEN_DYNAPRO=y
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_EGALAX=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
CONFIG_TOUCHSCREEN_ILI210X=y
CONFIG_TOUCHSCREEN_GUNZE=y
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
# CONFIG_TOUCHSCREEN_USB_3M is not set
# CONFIG_TOUCHSCREEN_USB_ITM is not set
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
# CONFIG_TOUCHSCREEN_USB_E2I is not set
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
# CONFIG_TOUCHSCREEN_USB_EASYTOUCH is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_STMPE=y
CONFIG_TOUCHSCREEN_SUR40=y
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_TOUCHSCREEN_ZFORCE=y
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=y
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_SERIO_ARC_PS2=y
CONFIG_SERIO_APBPS2=y
CONFIG_SERIO_OLPC_APSP=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
# CONFIG_GAMEPORT_L4 is not set
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=y
# CONFIG_GOLDFISH_TTY is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
# CONFIG_SERIAL_8250_PNP is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_OF_PLATFORM=y
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_TTY_PRINTK=y
# CONFIG_PRINTER is not set
CONFIG_PPDEV=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_SI_PROBE_DEFAULTS is not set
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_TPM is not set
# CONFIG_NVRAM is not set
CONFIG_DTLK=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
CONFIG_MWAVE=y
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
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
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=y

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=y
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_ROBOTFUZZ_OSIF=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ELEKTOR is not set
CONFIG_I2C_PCA_ISA=y
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
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
CONFIG_NTP_PPS=y

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=y
CONFIG_PPS_CLIENT_PARPORT=y
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
CONFIG_OF_GPIO=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_GENERIC=y
# CONFIG_GPIO_DA9055 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_DWAPB is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_SYSCON is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set
CONFIG_GPIO_GRGPIO=y

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_LP3943 is not set
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
# CONFIG_GPIO_TWL4030 is not set
# CONFIG_GPIO_TWL6040 is not set
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set
CONFIG_GPIO_ADNP=y

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_INTEL_MID is not set
# CONFIG_GPIO_PCH is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
# CONFIG_GPIO_RDC321X is not set

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
CONFIG_GPIO_KEMPLD=y

#
# MODULbus GPIO expanders:
#
# CONFIG_GPIO_PALMAS is not set
# CONFIG_GPIO_BCM_KONA is not set

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
CONFIG_W1_SLAVE_DS2408_READBACK=y
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_MAX8925_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_OLPC is not set
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=y
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
# CONFIG_CHARGER_TWL4030 is not set
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_LP8788=y
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX14577=y
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24735=y
CONFIG_CHARGER_SMB347=y
CONFIG_BATTERY_GOLDFISH=y
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_GPIO is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4222 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4260=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_PC87360=y
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_THERMAL_OF is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=y
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
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
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
# CONFIG_SSB_DRIVER_GPIO is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_MFD_AS3722 is not set
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
CONFIG_PMIC_DA903X=y
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
CONFIG_PCF50633_GPIO=y
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RTSX_USB is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=y
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS65218 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=y
CONFIG_REGULATOR_DA903X=y
CONFIG_REGULATOR_DA9055=y
# CONFIG_REGULATOR_DA9063 is not set
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_LP8788=y
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8925=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MAX77693=y
# CONFIG_REGULATOR_MC13783 is not set
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
# CONFIG_REGULATOR_TPS62360 is not set
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_TWL4030=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_DVB_CORE=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_SOC_CAMERA=y
CONFIG_SOC_CAMERA_SCALE_CROP=y
CONFIG_SOC_CAMERA_PLATFORM=y
CONFIG_VIDEO_RCAR_VIN=y
CONFIG_V4L_MEM2MEM_DRIVERS=y
# CONFIG_VIDEO_SH_VEU is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_SMS_SDIO_DRV is not set
CONFIG_MEDIA_PARPORT_SUPPORT=y
CONFIG_VIDEO_BWQCAM=y
# CONFIG_VIDEO_CQCAM is not set
CONFIG_VIDEO_PMS=y
# CONFIG_CYPRESS_FIRMWARE is not set

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
CONFIG_VIDEO_TDA7432=y
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
CONFIG_VIDEO_TEA6420=y
# CONFIG_VIDEO_MSP3400 is not set
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
# CONFIG_VIDEO_WM8775 is not set
# CONFIG_VIDEO_WM8739 is not set
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_ADV7183=y
CONFIG_VIDEO_BT819=y
CONFIG_VIDEO_BT856=y
# CONFIG_VIDEO_BT866 is not set
CONFIG_VIDEO_KS0127=y
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
# CONFIG_VIDEO_SAA711X is not set
CONFIG_VIDEO_SAA7191=y
CONFIG_VIDEO_TVP514X=y
CONFIG_VIDEO_TVP5150=y
# CONFIG_VIDEO_TVP7002 is not set
CONFIG_VIDEO_TW2804=y
CONFIG_VIDEO_TW9903=y
CONFIG_VIDEO_TW9906=y
CONFIG_VIDEO_VPX3220=y

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
CONFIG_VIDEO_CX25840=y

#
# Video encoders
#
# CONFIG_VIDEO_SAA7127 is not set
CONFIG_VIDEO_SAA7185=y
# CONFIG_VIDEO_ADV7170 is not set
CONFIG_VIDEO_ADV7175=y
CONFIG_VIDEO_ADV7343=y
# CONFIG_VIDEO_ADV7393 is not set
CONFIG_VIDEO_AK881X=y
CONFIG_VIDEO_THS8200=y

#
# Camera sensor devices
#
CONFIG_VIDEO_OV7640=y
# CONFIG_VIDEO_OV7670 is not set
CONFIG_VIDEO_VS6624=y
CONFIG_VIDEO_MT9V011=y
# CONFIG_VIDEO_SR030PC30 is not set

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=y
# CONFIG_VIDEO_UPD64083 is not set

#
# Audio/Video compression chips
#
# CONFIG_VIDEO_SAA6752HS is not set

#
# Miscellaneous helper chips
#
CONFIG_VIDEO_THS7303=y
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#

#
# soc_camera sensor drivers
#
CONFIG_SOC_CAMERA_IMX074=y
CONFIG_SOC_CAMERA_MT9M001=y
# CONFIG_SOC_CAMERA_MT9M111 is not set
# CONFIG_SOC_CAMERA_MT9T031 is not set
CONFIG_SOC_CAMERA_MT9T112=y
CONFIG_SOC_CAMERA_MT9V022=y
CONFIG_SOC_CAMERA_OV2640=y
CONFIG_SOC_CAMERA_OV5642=y
CONFIG_SOC_CAMERA_OV6650=y
CONFIG_SOC_CAMERA_OV772X=y
# CONFIG_SOC_CAMERA_OV9640 is not set
# CONFIG_SOC_CAMERA_OV9740 is not set
CONFIG_SOC_CAMERA_RJ54N1=y
# CONFIG_SOC_CAMERA_TW9910 is not set
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=y
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
# CONFIG_MEDIA_TUNER_FC2580 is not set
# CONFIG_MEDIA_TUNER_M88TS2022 is not set
CONFIG_MEDIA_TUNER_TUA9001=y
CONFIG_MEDIA_TUNER_IT913X=y
# CONFIG_MEDIA_TUNER_R820T is not set

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
# CONFIG_DVB_STB0899 is not set
# CONFIG_DVB_STB6100 is not set
CONFIG_DVB_STV090x=y
# CONFIG_DVB_STV6110x is not set

#
# Multistandard (cable + terrestrial) frontends
#
# CONFIG_DVB_DRXK is not set
# CONFIG_DVB_TDA18271C2DD is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=y
CONFIG_DVB_CX24123=y
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_ZL10036 is not set
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
# CONFIG_DVB_STV0288 is not set
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=y
CONFIG_DVB_TDA8261=y
# CONFIG_DVB_VES1X93 is not set
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
CONFIG_DVB_TUA6100=y
CONFIG_DVB_CX24116=y
# CONFIG_DVB_CX24117 is not set
CONFIG_DVB_SI21XX=y
CONFIG_DVB_TS2020=y
# CONFIG_DVB_DS3000 is not set
CONFIG_DVB_MB86A16=y
# CONFIG_DVB_TDA10071 is not set

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=y
CONFIG_DVB_SP887X=y
CONFIG_DVB_CX22700=y
CONFIG_DVB_CX22702=y
# CONFIG_DVB_S5H1432 is not set
CONFIG_DVB_DRXD=y
CONFIG_DVB_L64781=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_NXT6000=y
# CONFIG_DVB_MT352 is not set
CONFIG_DVB_ZL10353=y
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
CONFIG_DVB_DIB7000M=y
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_DIB9000=y
# CONFIG_DVB_TDA10048 is not set
CONFIG_DVB_AF9013=y
# CONFIG_DVB_EC100 is not set
CONFIG_DVB_HD29L2=y
# CONFIG_DVB_STV0367 is not set
# CONFIG_DVB_CXD2820R is not set
CONFIG_DVB_RTL2830=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=y
CONFIG_DVB_TDA10021=y
CONFIG_DVB_TDA10023=y
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
CONFIG_DVB_OR51211=y
CONFIG_DVB_OR51132=y
CONFIG_DVB_BCM3510=y
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_LG2160=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=y
# CONFIG_DVB_AU8522_DTV is not set
CONFIG_DVB_AU8522_V4L=y
# CONFIG_DVB_S5H1411 is not set

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=y
# CONFIG_DVB_DIB8000 is not set
CONFIG_DVB_MB86A20S=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=y
CONFIG_DVB_LNBP21=y
CONFIG_DVB_LNBP22=y
CONFIG_DVB_ISL6405=y
CONFIG_DVB_ISL6421=y
# CONFIG_DVB_ISL6423 is not set
CONFIG_DVB_A8293=y
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
CONFIG_DVB_TDA665x=y
# CONFIG_DVB_IX2505V is not set
CONFIG_DVB_M88RS2000=y
# CONFIG_DVB_AF9033 is not set

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
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_DRM_BOCHS is not set
# CONFIG_DRM_PTN3460 is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
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
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
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
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
# CONFIG_FB_OPENCORES is not set
CONFIG_FB_S1D13XXX=y
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
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
# CONFIG_FB_MB862XX is not set
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_FB_SSD1307=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_PWM=y
# CONFIG_BACKLIGHT_DA903X is not set
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_LP8788 is not set
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
# CONFIG_VGASTATE is not set
CONFIG_HDMI=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set

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
CONFIG_USB_KBD=y
# CONFIG_USB_MOUSE is not set

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
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
CONFIG_USB_FOTG210_HCD=y
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_SL811_CS=y
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_HCD_BCMA=y
CONFIG_USB_HCD_SSB=y
# CONFIG_USB_HCD_TEST_MODE is not set

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
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=y
# CONFIG_USB_STORAGE_FREECOM is not set
CONFIG_USB_STORAGE_ISD200=y
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_STORAGE_ENE_UB6250=y
CONFIG_USB_UAS=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
CONFIG_USB_MUSB_TUSB6010=y
# CONFIG_USB_MUSB_DSPS is not set
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_DEBUG is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_HOST is not set
CONFIG_USB_CHIPIDEA_DEBUG=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_SIMPLE=y
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
CONFIG_USB_SERIAL_CP210X=y
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
CONFIG_USB_SERIAL_EMPEG=y
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
CONFIG_USB_SERIAL_F81232=y
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
CONFIG_USB_SERIAL_MOS7840=y
CONFIG_USB_SERIAL_MXUPORT=y
CONFIG_USB_SERIAL_NAVMAN=y
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
CONFIG_USB_SERIAL_QUALCOMM=y
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
CONFIG_USB_SERIAL_SYMBOL=y
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=y
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=y
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
CONFIG_USB_SERIAL_WISHBONE=y
CONFIG_USB_SERIAL_ZTE=y
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
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
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=y
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
CONFIG_TAHVO_USB=y
CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_SDHCI_OF_ARASAN is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_GOLDFISH is not set
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
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
# CONFIG_MS_BLOCK is not set

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
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_LP8788 is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_PCA963X=y
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_DA903X=y
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_MC13783=y
# CONFIG_LEDS_TCA6507 is not set
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
CONFIG_LEDS_TRIGGER_CAMERA=y
# CONFIG_ACCESSIBILITY is not set
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
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_HYM8563=y
CONFIG_RTC_DRV_LP8788=y
CONFIG_RTC_DRV_MAX6900=y
# CONFIG_RTC_DRV_MAX8907 is not set
CONFIG_RTC_DRV_MAX8925=y
# CONFIG_RTC_DRV_MAX8998 is not set
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PALMAS=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_TWL4030=y
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=y
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9055=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
# CONFIG_RTC_DRV_V3020 is not set
CONFIG_RTC_DRV_DS2404=y
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y
# CONFIG_RTC_DRV_SNVS is not set
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_GOLDFISH_PIPE is not set
CONFIG_CHROME_PLATFORMS=y
# CONFIG_CHROMEOS_PSTORE is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y

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
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
CONFIG_EXTCON_ADC_JACK=y
# CONFIG_EXTCON_MAX14577 is not set
# CONFIG_EXTCON_MAX77693 is not set
CONFIG_EXTCON_PALMAS=y
# CONFIG_MEMORY is not set
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
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y

#
# Analog to digital converters
#
# CONFIG_EXYNOS_ADC is not set
CONFIG_LP8788_ADC=y
# CONFIG_MAX1363 is not set
CONFIG_MCP3422=y
CONFIG_NAU7802=y
# CONFIG_TI_ADC081C is not set
# CONFIG_TWL4030_MADC is not set
# CONFIG_TWL6030_GPADC is not set
# CONFIG_VF610_ADC is not set
# CONFIG_VIPERBOARD_ADC is not set

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5380 is not set
CONFIG_AD5446=y
# CONFIG_MAX517 is not set
CONFIG_MCP4725=y

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
CONFIG_IIO_ST_GYRO_3AXIS=y
CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
CONFIG_ITG3200=y

#
# Humidity sensors
#
CONFIG_DHT11=y
CONFIG_SI7005=y

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_APDS9300=y
# CONFIG_CM32181 is not set
# CONFIG_CM36651 is not set
CONFIG_GP2AP020A00F=y
# CONFIG_SENSORS_LM3533 is not set
CONFIG_LTR501=y
CONFIG_TCS3472=y
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
# CONFIG_MAG3110 is not set
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

#
# Inclinometer sensors
#

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
# CONFIG_MPL3115 is not set
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y

#
# Temperature sensors
#
CONFIG_TMP006=y
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_FSL_FTM is not set
CONFIG_PWM_LP3943=y
# CONFIG_PWM_LPSS is not set
CONFIG_PWM_PCA9685=y
CONFIG_PWM_TWL=y
CONFIG_PWM_TWL_LED=y
CONFIG_IRQCHIP=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
# CONFIG_FMC_WRITE_EEPROM is not set
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_SAMSUNG_USB2=y
# CONFIG_POWERCAP is not set
# CONFIG_MCB is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
# CONFIG_EXT2_FS_POSIX_ACL is not set
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
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
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
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
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
# CONFIG_JFFS2_RTIME is not set
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
CONFIG_JFFS2_CMODE_SIZE=y
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
# CONFIG_F2FS_FS_XATTR is not set
CONFIG_F2FS_CHECK_FS=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
# CONFIG_NLS_CODEPAGE_850 is not set
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
CONFIG_NLS_MAC_ROMANIAN=y
# CONFIG_NLS_MAC_TURKISH is not set
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
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
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
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

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
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_TORTURE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
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
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_RING_BUFFER_BENCHMARK=y
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
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
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_SECURITY_APPARMOR_HASH=y
# CONFIG_SECURITY_YAMA is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
# CONFIG_INTEGRITY_AUDIT is not set
# CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
# CONFIG_IMA is not set
CONFIG_EVM=y
CONFIG_EVM_HMAC_VERSION=2
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
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
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_AES_NI_INTEL is not set
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
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
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
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
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
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y


--------------040306070508090709090006
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message Part"

_______________________________________________
LKP mailing list
LKP@linux.intel.com


--------------040306070508090709090006--
