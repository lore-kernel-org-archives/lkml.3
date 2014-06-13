Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaFMIPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 04:15:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:23599 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbaFMIO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 04:14:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,470,1400050800"; 
   d="log'?scan'208";a="547388817"
Message-ID: <539AB2F4.1040700@intel.com>
Date: Fri, 13 Jun 2014 16:14:44 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        lkp@01.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [idr] WARNING: at lib/idr.c:669 idr_find_slowpath()
Content-Type: multipart/mixed;
 boundary="------------050201040302000204090605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050201040302000204090605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Tejun,

0day kernel testing robot got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
commit 0ffc2a9c8072969253a20821c2c733a2cbb4c7c7
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Wed Feb 27 17:05:08 2013 -0800
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Wed Feb 27 19:10:21 2013 -0800

    idr: implement lookup hint
        While idr lookup isn't a particularly heavy operation, it still is too
    substantial to use in hot paths without worrying about the performance
    implications.  With recent changes, each idr_layer covers 256 slots
    which should be enough to cover most use cases with single idr_layer
    making lookup hint very attractive.
        This patch adds idr->hint which points to the idr_layer which
    allocated an ID most recently and the fast path lookup becomes
        	if (look up target's prefix matches that of the hinted layer)
    		return hint->ary[ID's offset in the leaf layer];
        which can be inlined.
        idr->hint is set to the leaf node on idr_fill_slot() and cleared from
    free_layer().
        [andriy.shevchenko@linux.intel.com: always do slow path when hint is uninitialized]
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Cc: Sasha Levin <sasha.levin@oracle.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


+--------------------------------------------------------------------------+------------+------------+
|                                                                          | 54616283c2 | 0ffc2a9c80 |
+--------------------------------------------------------------------------+------------+------------+
| boot_successes                                                           | 140        | 31         |
| boot_failures                                                            | 320        | 84         |
| BUG:soft_lockup-CPU_stuck_for_s                                          | 128        | 40         |
| EIP_is_at_stop_machine_cpu_stop                                          | 128        | 40         |
| Kernel_panic-not_syncing:softlockup:hung_tasks                           | 128        | 40         |
| backtrace:smpboot_thread_fn                                              | 128        | 40         |
| BUG:unable_to_handle_kernel_paging_request                               | 67         | 18         |
| Oops                                                                     | 40         | 12         |
| EIP_is_at_static_key_slow_inc                                            | 35         | 10         |
| Kernel_panic-not_syncing:Fatal_exception                                 | 39         | 12         |
| backtrace:perf_swevent_init                                              | 37         | 10         |
| backtrace:perf_init_event                                                | 144        | 35         |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference                     | 2          |            |
| EIP_is_at_jump_label_update                                              | 2          |            |
| backtrace:static_key_slow_inc                                            | 2          |            |
| WARNING:at_lib/idr.c:idr_find()                                          | 119        |            |
| EIP_is_at_atomic_dec_and_mutex_lock                                      | 2          | 2          |
| backtrace:idr_find                                                       | 111        |            |
| WARNING:at_kernel/jump_label.c:__static_key_slow_dec()                   | 3          | 1          |
| BUG:kernel_test_crashed                                                  | 18         | 4          |
| WARNING:at_kernel/lockdep.c:__bfs()                                      | 1          |            |
| EIP_is_at__bfs                                                           | 1          |            |
| WARNING:at_arch/x86/kernel/hw_breakpoint.c:arch_install_hw_breakpoint()  | 1          |            |
| BUG:sleeping_function_called_from_invalid_context_at_arch/x86/mm/fault.c | 1          |            |
| WARNING:at_lib/idr.c:idr_find_slowpath()                                 | 0          | 27         |
| backtrace:idr_find_slowpath                                              | 0          | 26         |
| WARNING:at_drivers/tty/tty_buffer.c:flush_to_ldisc()                     | 0          | 1          |
| backtrace:flush_to_ldisc                                                 | 0          | 1          |
+--------------------------------------------------------------------------+------------+------------+


Kernel tests: Boot OK!
[   17.603698] sock: process `trinity-main' is using obsolete setsockopt SO_BSDCOMPAT
[   17.798944] ------------[ cut here ]------------
[   17.798972] WARNING: at lib/idr.c:669 idr_find_slowpath+0x28/0xca()
[   17.798973] Hardware name: Bochs
[   17.798976] Pid: 655, comm: trinity-main Not tainted 3.8.0-06482-g0ffc2a9 #68
[   17.798976] Call Trace:
[   17.798989]  [<c022ace6>] warn_slowpath_common+0x72/0x89
[   17.798992]  [<c051f001>] ? idr_find_slowpath+0x28/0xca
[   17.798994]  [<c051f001>] ? idr_find_slowpath+0x28/0xca
[   17.798997]  [<c022ad9b>] warn_slowpath_null+0x1d/0x1f
[   17.798999]  [<c051f001>] idr_find_slowpath+0x28/0xca
[   17.799007]  [<c027fab7>] perf_init_event+0x82/0x124
[   17.799013]  [<c024321f>] ? __mutex_init+0x3f/0x44
[   17.799015]  [<c027fda9>] perf_event_alloc+0x250/0x360
[   17.799018]  [<c028040e>] sys_perf_event_open+0x336/0x664
[   17.799036]  [<c0944280>] syscall_call+0x7/0xb
[   17.799042]  [<c0940000>] ? SetAgcIf.isra.6+0x156/0x290
[   17.799043] ---[ end trace 8e00e88be2b81021 ]---
[   76.161086] Unregister pv shared memory for cpu 0


Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.

git bisect start 6dbe51c251a327e012439c4772097a13df43c5b8 v3.8 --
git bisect good d414c104e26fd3b597f855cc29473a8b1527fb4c  # 02:41     35+     35  Merge tag 'please-pull-vm_unwrapped' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux
git bisect  bad ee89f81252179dcbf6cd65bd48299f5e52292d88  # 02:46     10-     14  Merge branch 'for-3.9/core' of git://git.kernel.dk/linux-block
git bisect good a6590b9f01dca2d45a38b8387f59812c44f68a2f  # 03:05     40+     40  Merge tag 'upstream-3.9-rc1' of git://git.infradead.org/linux-ubifs
git bisect good 09884964335e85e897876d17783c2ad33cf8a2e0  # 03:13     40+     40  mm: do not grow the stack vma just because of an overrun on preceding vma
git bisect good ad60a9333035f2323840b71ab8ad07bbab728faf  # 03:29     40+     17  Merge branch 'misc' of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild
git bisect good e3c4877de8b9d93bd47b6ee88eb594b1c1e10da5  # 04:16     40+     15  Merge branch 'x86-efi-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect  bad 2a7d2b96d5cba7568139d9ab157a0e97ab32440f  # 04:29      1-      3  Merge branch 'akpm' (final batch from Andrew)
git bisect good 6fa780095f058f0960f220754217701a53a9e403  # 05:44     40+     19  IB/cxgb3: convert to idr_alloc()
git bisect good 050a6b47d98e2bcea909c1129111e721668aaa2c  # 06:06     40+     36  idr: make idr_layer larger
git bisect  bad 459a86d83dce6641f66311d37fbfe1419c477a5a  # 06:28     19-     21  mtd: mtd_nandecctest: use prandom_bytes instead of get_random_bytes()
git bisect  bad 06004e6eebdaf101a0f9b533fac77b5768d2c09c  # 06:40      5-      6  block/partitions/mac.c: obey the state->limit constraint
git bisect  bad d941aeae42942c2ef61ed5e05cc1ad0428085704  # 06:52      0-      1  ipmi: add new kernel options to prevent automatic ipmi init
git bisect  bad 0ffc2a9c8072969253a20821c2c733a2cbb4c7c7  # 07:00      9-     10  idr: implement lookup hint
git bisect good 54616283c2948812a44240858ced610e7cacbde1  # 07:06    115+     73  idr: add idr_layer->prefix
# first bad commit: [0ffc2a9c8072969253a20821c2c733a2cbb4c7c7] idr: implement lookup hint
git bisect good 54616283c2948812a44240858ced610e7cacbde1  # 07:15    345+    320  idr: add idr_layer->prefix
git bisect good d67a0e110187abd560a1de63fa172894a52839d5  # 07:30    345+     11  morphologies: Enable CONFIG_FHANDLE
git bisect good 0e04c641b199435f3779454055f6a7de258ecdfc  # 07:45    345+     22  Merge tag 'dm-3.16-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm
git bisect good b1cce620fd4b6864c92e7307be7839789f9c8be0  # 08:03    345+     18  Add linux-next specific files for 20140612


This script may reproduce the error.

-----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm
 	-kernel $kernel
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


--------------050201040302000204090605
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-yocto-ivb41-19:20140613070119:i386-randconfig-ha3-0612:3.8.0-06482-g0ffc2a9:68"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="dmesg-yocto-ivb41-19:20140613070119:i386-randconfig-ha3-0612";
 filename*1=":3.8.0-06482-g0ffc2a9:68"

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-06482-g0ffc2a9 (kbuild@lkp-hsx01) (gcc=
 version 4.8.2 (Debian 4.8.2-18) ) #68 SMP PREEMPT Fri Jun 13 06:54:17 CS=
T 2014
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped a=
t [c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] ACPI: RSDP 000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13ffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BX=
PC 00000001)
[    0.000000] ACPI: FACP 13ffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BX=
PC 00000001)
[    0.000000] ACPI: DSDT 13ffe490 011A9 (v01   BXPC   BXDSDT 00000001 IN=
TL 20100528)
[    0.000000] ACPI: FACS 13ffff40 00040
[    0.000000] ACPI: SSDT 13fff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BX=
PC 00000001)
[    0.000000] ACPI: APIC 13fff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BX=
PC 00000001)
[    0.000000] ACPI: HPET 13fff640 00038 (v01 BOCHS  BXPCHPET 00000001 BX=
PC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] initial memory mapped: [mem 0x00000000-0x019fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13cbcfff]
[    0.000000]  [mem 0x13c00000-0x13cbcfff] page 4k
[    0.000000] BRK [0x01415000, 0x01415fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x13bfffff]
[    0.000000]  [mem 0x10000000-0x13bfffff] page 4k
[    0.000000] BRK [0x01416000, 0x01416fff] PGTABLE
[    0.000000] BRK [0x01417000, 0x01417fff] PGTABLE
[    0.000000] BRK [0x01418000, 0x01418fff] PGTABLE
[    0.000000] BRK [0x01419000, 0x01419fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13cbd000-0x13ffdfff]
[    0.000000]  [mem 0x13cbd000-0x13ffdfff] page 4k
[    0.000000] cma: CMA: reserved 16 MiB at 12c00000
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @d2744000 s26752 r0 d14208 u=
40960
[    0.000000] pcpu-alloc: s26752 r0 d14208 u40960 alloc=3D10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12746500
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ha3-0612/=
baserock:baserock:morph:0ffc2a9c8072969253a20821c2c733a2cbb4c7c7:bisect-l=
inux6/.vmlinuz-0ffc2a9c8072969253a20821c2c733a2cbb4c7c7-20140613065423-11=
0-ivb41 branch=3Dbaserock/baserock/morph BOOT_IMAGE=3D/kernel/i386-randco=
nfig-ha3-0612/0ffc2a9c8072969253a20821c2c733a2cbb4c7c7/vmlinuz-3.8.0-0648=
2-g0ffc2a9 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 by=
tes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 283028k/327672k available (7446k kernel code, 4425=
2k reserved, 4320k data, 544k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xffbfe000   ( 692 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc0d7e000 - 0xc0e06000   ( 544 kB)
[    0.000000]       .data : 0xc0945a01 - 0xc0d7dd40   (4320 kB)
[    0.000000]       .text : 0xc0200000 - 0xc0945a01   (7446 kB)
[    0.000000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dd201a000 soft=3Dd201c000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-06482-g0ffc2a9 (kbuild@lkp-hsx01) (gcc=
 version 4.8.2 (Debian 4.8.2-18) ) #68 SMP PREEMPT Fri Jun 13 06:54:17 CS=
T 2014
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped a=
t [c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] ACPI: RSDP 000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13ffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BX=
PC 00000001)
[    0.000000] ACPI: FACP 13ffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BX=
PC 00000001)
[    0.000000] ACPI: DSDT 13ffe490 011A9 (v01   BXPC   BXDSDT 00000001 IN=
TL 20100528)
[    0.000000] ACPI: FACS 13ffff40 00040
[    0.000000] ACPI: SSDT 13fff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BX=
PC 00000001)
[    0.000000] ACPI: APIC 13fff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BX=
PC 00000001)
[    0.000000] ACPI: HPET 13fff640 00038 (v01 BOCHS  BXPCHPET 00000001 BX=
PC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] initial memory mapped: [mem 0x00000000-0x019fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13cbcfff]
[    0.000000]  [mem 0x13c00000-0x13cbcfff] page 4k
[    0.000000] BRK [0x01415000, 0x01415fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x13bfffff]
[    0.000000]  [mem 0x10000000-0x13bfffff] page 4k
[    0.000000] BRK [0x01416000, 0x01416fff] PGTABLE
[    0.000000] BRK [0x01417000, 0x01417fff] PGTABLE
[    0.000000] BRK [0x01418000, 0x01418fff] PGTABLE
[    0.000000] BRK [0x01419000, 0x01419fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13cbd000-0x13ffdfff]
[    0.000000]  [mem 0x13cbd000-0x13ffdfff] page 4k
[    0.000000] cma: CMA: reserved 16 MiB at 12c00000
[    0.000000] RAMDISK: [mem 0x13cbd000-0x13feffff]
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @d2744000 s26752 r0 d14208 u=
40960
[    0.000000] pcpu-alloc: s26752 r0 d14208 u40960 alloc=3D10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 12746500
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ha3-0612/=
baserock:baserock:morph:0ffc2a9c8072969253a20821c2c733a2cbb4c7c7:bisect-l=
inux6/.vmlinuz-0ffc2a9c8072969253a20821c2c733a2cbb4c7c7-20140613065423-11=
0-ivb41 branch=3Dbaserock/baserock/morph BOOT_IMAGE=3D/kernel/i386-randco=
nfig-ha3-0612/0ffc2a9c8072969253a20821c2c733a2cbb4c7c7/vmlinuz-3.8.0-0648=
2-g0ffc2a9 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 by=
tes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 283028k/327672k available (7446k kernel code, 4425=
2k reserved, 4320k data, 544k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xffbfe000   ( 692 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc0d7e000 - 0xc0e06000   ( 544 kB)
[    0.000000]       .data : 0xc0945a01 - 0xc0d7dd40   (4320 kB)
[    0.000000]       .text : 0xc0200000 - 0xc0945a01   (7446 kB)
[    0.000000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dd201a000 soft=3Dd201c000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc=
=2E, Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ODEBUG: 18 of 18 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.482 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.42 Bo=
goMIPS (lpj=3D8978273)
[    0.006666] pid_max: default: 32768 minimum: 301
[    0.006666] Mount-cache hash table entries: 512
[    0.007315] Initializing cgroup subsys devices
[    0.008332] Initializing cgroup subsys blkio
[    0.010215] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010215] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.010215] tlb_flushall_shift: 6
[    0.013672] debug: unmapping init [mem 0xc0e06000-0xc0e09fff]
[    0.017817] ACPI: Core revision 20130117
[    0.023767] ACPI: All ACPI Tables successfully acquired
[    0.025532] Getting VERSION: 50014
[    0.026394] Getting VERSION: 50014
[    0.026676] Getting ID: 0
[    0.027416] Getting ID: f000000
[    0.028219] Getting LVT0: 8700
[    0.028993] Getting LVT1: 8400
[    0.030007] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.031229] enabled ExtINT on CPU#0
[    0.033724] ENABLING IO-APIC IRQs
[    0.034587] init IO_APIC IRQs
[    0.035436]  apic 0 pin 0 not connected
[    0.036399] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.036703] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 =
Active:0 Dest:1)
[    0.040036] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.041828] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.043369] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 =
Active:0 Dest:1)
[    0.045206] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.046694] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.048573] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.050030] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 =
Active:0 Dest:1)
[    0.051832] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:=
1 Active:0 Dest:1)
[    0.053371] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
1 Active:0 Dest:1)
[    0.056696] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.058501] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:=
0 Active:0 Dest:1)
[    0.060030] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:=
0 Active:0 Dest:1)
[    0.061899] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:=
0 Active:0 Dest:1)
[    0.063364]  apic 0 pin 16 not connected
[    0.064282]  apic 0 pin 17 not connected
[    0.065193]  apic 0 pin 18 not connected
[    0.066672]  apic 0 pin 19 not connected
[    0.067586]  apic 0 pin 20 not connected
[    0.068505]  apic 0 pin 21 not connected
[    0.069426]  apic 0 pin 22 not connected
[    0.070006]  apic 0 pin 23 not connected
[    0.072462] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.073340] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model:=
 06, stepping: 01)
[    0.078063] Using local APIC timer interrupts.
[    0.078063] calibrating APIC timer ...
[    0.083333] ... lapic delta =3D 8747919
[    0.083333] ... PM-Timer delta =3D 500996
[    0.083333] APIC calibration not consistent with PM-Timer: 139ms inste=
ad of 100ms
[    0.083333] APIC delta adjusted to PM-Timer: 6250254 (8747919)
[    0.083333] TSC delta adjusted to PM-Timer: 269344292 (376976967)
[    0.083333] ..... delta 6250254
[    0.083333] ..... mult: 268446392
[    0.083333] ..... calibration result: 3333468
[    0.083333] ..... CPU clock speed is 2693.2374 MHz.
[    0.083333] ..... host bus clock speed is 1000.0468 MHz.
[    0.083420] Performance Events: unsupported Netburst CPU model 6 no PM=
U driver, software events only.
[    0.104701] NMI watchdog: disabled (cpu0): hardware events not enabled=

[    0.107910] SMP alternatives: lockdep: fixing up alternatives
[    0.109138] CPU 1 irqstacks, hard=3Dd21d4000 soft=3Dd21d6000
[    0.110012] smpboot: Booting Node   0, Processors  #1 OK
[    0.003333] Initializing CPU#1
[    0.006666] kvm-clock: cpu 1, msr 0:13ffd041, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.140172] Brought up 2 CPUs
[    0.143340] smpboot: Total of 2 processors activated (10778.84 BogoMIP=
S)
[    0.143347] KVM setup async PF for cpu 1
[    0.143353] kvm-stealtime: cpu 1, msr 12750500
[    0.153339] devtmpfs: initialized
[    0.164120] regulator-dummy: no parameters
[    0.167689] NET: Registered protocol family 16
[    0.169986] EISA bus registered
[    0.170763] ACPI: bus type pci registered
[    0.173426] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you w=
ant it NX.
[    0.176673] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0=

[    0.178055] PCI: Using configuration type 1 for base access
[    0.205310] bio: create slab <bio-0> at 0
[    0.210542] ACPI: Added _OSI(Module Device)
[    0.211508] ACPI: Added _OSI(Processor Device)
[    0.213340] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.214368] ACPI: Added _OSI(Processor Aggregator Device)
[    0.217350] ACPI: EC: Look up EC in DSDT
[    0.229021] ACPI: Interpreter enabled
[    0.229983] ACPI: (supports S0 S5)
[    0.230488] ACPI: Using IOAPIC for interrupt routing
[    0.231686] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.248773] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.250020] acpi PNP0A03:00: Unable to request _OSC control (_OSC supp=
ort mask: 0x08)
[    0.252362] acpi PNP0A03:00: fail to add MMCONFIG information, can't a=
ccess extended PCI configuration space under this bridge.
[    0.253515] PCI host bridge to bus 0000:00
[    0.254542] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.256675] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.257913] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.260029] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff]
[    0.263341] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebff=
fff]
[    0.264794] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.267418] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.269242] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.277262] pci 0000:00:01.1: reg 20: [io  0xc040-0xc04f]
[    0.280350] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.281963] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PI=
IX4 ACPI
[    0.283352] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PI=
IX4 SMB
[    0.285017] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.290791] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]=

[    0.294991] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.304107] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]=

[    0.305997] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.307824] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.310540] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.316674] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]=

[    0.318160] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.320314] pci 0000:00:04.0: reg 10: [mem 0xfebf1000-0xfebf100f]
[    0.325529] pci_bus 0000:00: on NUMA node 0
[    0.326491] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.328397] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.331096] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.332933] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.334408] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.336032] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.337788] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.338977] acpi root: \_SB_.PCI0 notify handler is installed
[    0.340103] Found 1 acpi root devices
[    0.343430] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.345096] vgaarb: loaded
[    0.345772] vgaarb: bridge control possible 0000:00:02.0
[    0.348034] SCSI subsystem initialized
[    0.348980] ACPI: bus type usb registered
[    0.350100] usbcore: registered new interface driver usbfs
[    0.351281] usbcore: registered new interface driver hub
[    0.360104] usbcore: registered new device driver usb
[    0.363411] Linux video capture interface: v2.00
[    0.364545] pps_core: LinuxPPS API ver. 1 registered
[    0.366671] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[    0.370043] PTP clock support registered
[    0.383455] PCI: Using ACPI for IRQ routing
[    0.386677] PCI: pci_cache_line_size set to 64 bytes
[    0.387805] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.388960] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.390749] Bluetooth: Core ver 2.16
[    0.391622] NET: Registered protocol family 31
[    0.392545] Bluetooth: HCI device and connection manager initialized
[    0.393371] Bluetooth: HCI socket layer initialized
[    0.394374] Bluetooth: L2CAP socket layer initialized
[    0.395458] Bluetooth: SCO socket layer initialized
[    0.396678] NET: Registered protocol family 8
[    0.397584] NET: Registered protocol family 20
[    0.398583] nfc: nfc_init: NFC Core ver 0.1
[    0.400117] NET: Registered protocol family 39
[    0.401811] Switching to clocksource kvm-clock
[    0.402777] pnp: PnP ACPI init
[    0.421219] ACPI: bus type pnp registered
[    0.422175] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:3)
[    0.437460] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.438872] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:3)
[    0.440718] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)=

[    0.442083] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:3)
[    0.443950] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)=

[    0.445362] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:3)
[    0.457222] pnp 00:03: [dma 2]
[    0.458083] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)=

[    0.459518] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:3)
[    0.461380] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)=

[    0.462802] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:3)
[    0.464637] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.466071] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:3)
[    0.477967] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.479733] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)=

[    0.481451] pnp: PnP ACPI: found 8 devices
[    0.482397] ACPI: ACPI bus type pnp unregistered
[    0.483434] PnPBIOS: Disabled
[    1.190744] mdacon: MDA with 8K of memory detected.
[    1.191998] Console: switching consoles 13-16 to MDA-2
[    1.243079] PM-Timer running at invalid rate: 116% of normal - abortin=
g.
[    1.244570] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.245815] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.246948] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.248118] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    1.249459] NET: Registered protocol family 1
[    1.250448] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.251605] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    1.252720] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    1.264258] pci 0000:00:02.0: Boot video device
[    1.265362] PCI: CLS 0 bytes, default 64
[    1.266866] Unpacking initramfs...
[    1.571154] debug: unmapping init [mem 0xd3cbd000-0xd3feffff]
[    1.585305] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    1.586565] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    1.593387] microcode: Microcode Update Driver: v2.00 <tigran@aivazian=
=2Efsnet.co.uk>, Peter Oruba
[    1.595493] Scanning for low memory corruption every 60 seconds
[    1.603636] PCLMULQDQ-NI instructions are not detected.
[    1.604827] The force parameter has not been set to 1. The Iris powero=
ff handler will not be installed.
[    1.607082] NatSemi SCx200 Driver
[    1.614484] Initializing RT-Tester: OK
[    1.623376] bounce pool size: 64 pages
[    1.624332] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.633797] VFS: Disk quotas dquot_6.5.2
[    1.634918] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=

[    1.639544] NTFS driver 2.1.30 [Flags: R/W DEBUG].
[    1.641354] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    1.642540] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.643908] QNX4 filesystem 0.2.3 registered.
[    1.645019] QNX6 filesystem 1.0.0 registered.
[    1.653386] JFS: nTxBlock =3D 2339, nTxLock =3D 18713
[    1.663469] SGI XFS with ACLs, security attributes, realtime, large bl=
ock/inode numbers, no debug enabled
[    1.672283] BeFS version: 0.9.3
[    1.673256] OCFS2 1.5.0
[    1.674611] OCFS2 DLMFS 1.5.0
[    1.683067] OCFS2 User DLM kernel interface loaded
[    1.684223] OCFS2 Node Manager 1.5.0
[    1.688680] GFS2 installed
[    1.689813] msgmni has been set to 584
[    1.701590] alg: No test for cipher_null (cipher_null-generic)
[    1.702958] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    1.704489] alg: No test for compress_null (compress_null-generic)
[    1.705930] alg: No test for digest_null (digest_null-generic)
[    1.718154] alg: No test for stdrng (krng)
[    1.719363] NET: Registered protocol family 38
[    1.720640] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 252)
[    1.722514] io scheduler noop registered
[    1.723501] io scheduler deadline registered
[    1.724617] io scheduler cfq registered (default)
[    1.725752] list_sort_test: start testing list_sort()
[    1.728313] crc32: CRC_LE_BITS =3D 64, CRC_BE BITS =3D 64
[    1.729451] crc32: self tests passed, processed 225944 bytes in 209348=
 nsec
[    1.731045] crc32c: CRC_LE_BITS =3D 64
[    1.731947] crc32c: self tests passed, processed 225944 bytes in 10935=
7 nsec
[    1.744045] Console: switching consoles 13-16 to MDA-2
[    1.745532] ipmi message handler version 39.2
[    1.746744] IPMI System Interface driver.
[    1.747827] ipmi_si: Adding default-specified kcs state machine
[    1.749104] ipmi_si: Trying default-specified kcs state machine at i/o=
 address 0xca2, slave address 0x0, irq 0
[    1.751125] ipmi_si: Interface detection failed
[    1.760129] ipmi_si: Adding default-specified smic state machine
[    1.761417] ipmi_si: Trying default-specified smic state machine at i/=
o address 0xca9, slave address 0x0, irq 0
[    1.763635] ipmi_si: Interface detection failed
[    1.764802] ipmi_si: Adding default-specified bt state machine
[    1.766148] ipmi_si: Trying default-specified bt state machine at i/o =
address 0xe4, slave address 0x0, irq 0
[    1.768305] ipmi_si: Interface detection failed
[    1.781748] ipmi_si: Unable to find any System Interface(s)
[    1.791640] IPMI Watchdog: driver initialized
[    1.793052] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input0
[    1.794858] ACPI: Power Button [PWRF]
[    1.797025] isapnp: Scanning for PnP cards...
[    2.464930] isapnp: No Plug & Play device found
[    2.574606] r3964: Philips r3964 Driver $Revision: 1.10 $
[    2.575826] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.628174] tsc: Refined TSC clocksource calibration: 2693.453 MHz
[    2.629581] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    2.666568] lp: driver loaded but no devices found
[    2.667819] DoubleTalk PC - not found
[    2.668835] Non-volatile memory driver v1.3
[    2.669764] toshiba: not a supported Toshiba laptop
[    2.671332] ppdev: user-space parallel port driver
[    2.672427] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initi=
alizing
[    2.673881] platform pc8736x_gpio.0: no device found
[    2.675028] nsc_gpio initializing
[    2.675926] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    2.677048] SyncLink PC Card driver $Revision: 4.34 $, tty major#248
[    2.678325] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 sec=
onds, margin is 60 seconds).
[    2.680259] Hangcheck: Using getrawmonotonic().
[    2.681535] [drm] Initialized drm 1.1.0 20060810
[    2.682626] parport_pc 00:04: reported by Plug and Play ACPI
[    2.694107] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    2.777437] lp0: using parport0 (interrupt-driven).
[    2.779781] usbcore: registered new interface driver viperboard
[    2.781037] usbcore: registered new interface driver pn533
[    2.782168] Uniform Multi-Platform E-IDE driver
[    2.783274] ide_generic: please use "probe_mask=3D0x3f" module paramet=
er for probing all legacy ISA IDE ports
[    2.785411] ide-gd driver 1.18
[    2.786197] ide-cd driver 5.00
[    2.787275] Loading iSCSI transport class v2.0-870.
[    2.806667] rdac: device handler registered
[    2.807886] hp_sw: device handler registered
[    2.808950] emc: device handler registered
[    2.809945] alua: device handler registered
[    2.835778] NCR53c406a: no available ports found
[    2.836948] sym53c416.c: Version 1.0.0-ac
[    2.837954] qlogicfas: no cards were found, please specify I/O address=
 and IRQ using iobase=3D and irq=3D optionsimm: Version 2.05 (for Linux 2=
=2E4.0)
[    4.218175] osst :I: Tape driver with OnStream support version 0.99.4
[    4.218175] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp=
 $
[    4.221352] SCSI Media Changer driver v0.25=20
[    4.250171] scsi_debug: host protection
[    4.251164] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D=
8, opts=3D0x0
[    4.257889] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       =
0004 PQ: 0 ANSI: 5
[    4.260655] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    4.373794] parport_pc 00:04: master is unqueued, this is deprecated
[    4.375183] parport0: AVR Butterfly
[    4.376050] parport0: cannot grant exclusive access for device spi-lm7=
0llp
[    4.377319] spi-lm70llp: spi_lm70llp probe fail, status -12
[    4.379195] LocalTalk card not found; 220 =3D ff, 240 =3D ff.
[    4.380329] AX.25: Z8530 SCC driver version 3.0.dl1bke
[    4.381658] AX.25: 6pack driver, Revision: 0.3.0
[    4.382614] YAM driver version 0.8 by F1OAT/F6FBB
[    4.395935] AX.25: bpqether driver version 004
[    4.397106] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    4.397106] baycom_ser_fdx: version 0.10
[    4.408461] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    4.409730] hdlcdrv: version 0.8
[    4.417962] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.419700] usbcore: registered new interface driver cdc_acm
[    4.420905] cdc_acm: USB Abstract Control Model driver for USB modems =
and ISDN adapters
[    4.429637] usbcore: registered new interface driver usblp
[    4.430751] usbcore: registered new interface driver cdc_wdm
[    4.431850] Initializing USB Mass Storage driver...
[    4.437573] usbcore: registered new interface driver usb-storage
[    4.438826] USB Mass Storage support registered.
[    4.439929] usbcore: registered new interface driver ums-alauda
[    4.444964] usbcore: registered new interface driver ums-cypress
[    4.446145] usbcore: registered new interface driver ums-datafab
[    4.473986] usbcore: registered new interface driver ums_eneub6250
[    4.483000] usbcore: registered new interface driver ums-freecom
[    4.484190] usbcore: registered new interface driver ums-isd200
[    4.485351] usbcore: registered new interface driver ums-karma
[    4.486883] usbcore: registered new interface driver ums-onetouch
[    4.488062] usbcore: registered new interface driver ums-realtek
[    4.489212] usbcore: registered new interface driver ums-sddr09
[    4.497066] usbcore: registered new interface driver ums-sddr55
[    4.498938] usbcore: registered new interface driver mdc800
[    4.500292] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 D=
igital Camera
[    4.506146] usbcore: registered new interface driver usbserial
[    4.507649] usbcore: registered new interface driver usbserial_generic=

[    4.513127] usbserial: USB Serial support registered for generic
[    4.514477] usbcore: registered new interface driver aircable
[    4.515775] usbserial: USB Serial support registered for aircable
[    4.524210] usbcore: registered new interface driver belkin_sa
[    4.525565] usbserial: USB Serial support registered for Belkin / Pera=
com / GoHubs USB Serial Adapter
[    4.531676] usbcore: registered new interface driver ch341
[    4.532819] usbserial: USB Serial support registered for ch341-uart
[    4.534093] usbcore: registered new interface driver cyberjack
[    4.539707] usbserial: USB Serial support registered for Reiner SCT Cy=
berjack USB card reader
[    4.541764] usbcore: registered new interface driver cypress_m8
[    4.547685] usbserial: USB Serial support registered for DeLorme Earth=
mate USB
[    4.549532] usbserial: USB Serial support registered for HID->COM RS23=
2 Adapter
[    4.555417] usbserial: USB Serial support registered for Nokia CA-42 V=
2 Adapter
[    4.557277] usbcore: registered new interface driver digi_acceleport
[    4.558551] usbserial: USB Serial support registered for Digi 2 port U=
SB adapter
[    4.564879] usbserial: USB Serial support registered for Digi 4 port U=
SB adapter
[    4.566531] usbcore: registered new interface driver io_edgeport
[    4.571958] usbserial: USB Serial support registered for Edgeport 2 po=
rt adapter
[    4.573749] usbserial: USB Serial support registered for Edgeport 4 po=
rt adapter
[    4.579267] usbserial: USB Serial support registered for Edgeport 8 po=
rt adapter
[    4.581264] usbserial: USB Serial support registered for EPiC device
[    4.582627] usbcore: registered new interface driver io_ti
[    4.588187] usbserial: USB Serial support registered for Edgeport TI 1=
 port adapter
[    4.589890] usbserial: USB Serial support registered for Edgeport TI 2=
 port adapter
[    4.596024] usbcore: registered new interface driver empeg
[    4.597238] usbserial: USB Serial support registered for empeg
[    4.598562] usbcore: registered new interface driver f81232
[    4.603814] usbserial: USB Serial support registered for f81232
[    4.605147] usbcore: registered new interface driver ftdi_sio
[    4.606417] usbserial: USB Serial support registered for FTDI USB Seri=
al Device
[    4.612590] usbcore: registered new interface driver ipaq
[    4.613739] usbserial: USB Serial support registered for PocketPC PDA
[    4.619513] usbcore: registered new interface driver ipw
[    4.620732] usbserial: USB Serial support registered for IPWireless co=
nverter
[    4.622200] usbcore: registered new interface driver ir_usb
[    4.627557] usbserial: USB Serial support registered for IR Dongle
[    4.628824] usbcore: registered new interface driver iuu_phoenix
[    4.631651] usbserial: USB Serial support registered for iuu_phoenix
[    4.632928] usbcore: registered new interface driver keyspan_pda
[    4.634149] usbserial: USB Serial support registered for Keyspan PDA
[    4.640265] usbserial: USB Serial support registered for Keyspan PDA -=
 (prerenumeration)
[    4.642164] usbserial: USB Serial support registered for Xircom / Entr=
egra PGS - (prerenumeration)
[    4.649071] usbcore: registered new interface driver kl5kusb105
[    4.650300] usbserial: USB Serial support registered for KL5KUSB105D /=
 PalmConnect
[    4.656049] usbcore: registered new interface driver kobil_sct
[    4.657259] usbserial: USB Serial support registered for KOBIL USB sma=
rt card terminal
[    4.658977] usbcore: registered new interface driver metro_usb
[    4.664710] usbserial: USB Serial support registered for Metrologic US=
B to Serial
[    4.666382] usbcore: registered new interface driver mos7720
[    4.671990] usbserial: USB Serial support registered for Moschip 2 por=
t adapter
[    4.673636] usbcore: registered new interface driver opticon
[    4.674792] usbserial: USB Serial support registered for opticon
[    4.680183] usbcore: registered new interface driver oti6858
[    4.681347] usbserial: USB Serial support registered for oti6858
[    4.682572] usbcore: registered new interface driver pl2303
[    4.687777] usbserial: USB Serial support registered for pl2303
[    4.688990] usbcore: registered new interface driver qcserial
[    4.690170] usbserial: USB Serial support registered for Qualcomm USB =
modem
[    4.696345] usbcore: registered new interface driver quatech2
[    4.697550] usbserial: USB Serial support registered for Quatech 2nd g=
en USB to Serial Driver
[    4.703570] usbcore: registered new interface driver safe_serial
[    4.704787] usbserial: USB Serial support registered for safe_serial
[    4.706043] usbcore: registered new interface driver sierra
[    4.711257] usbserial: USB Serial support registered for Sierra USB mo=
dem
[    4.712597] usbcore: registered new interface driver spcp8x5
[    4.713781] usbserial: USB Serial support registered for SPCP8x5
[    4.719388] usbcore: registered new interface driver ssu100
[    4.720578] usbserial: USB Serial support registered for Quatech SSU-1=
00 USB to Serial Driver
[    4.722374] usbcore: registered new interface driver symbolserial
[    4.727974] usbserial: USB Serial support registered for symbol
[    4.729195] usbcore: registered new interface driver ti_usb_3410_5052
[    4.730476] usbserial: USB Serial support registered for TI USB 3410 1=
 port adapter
[    4.736308] usbserial: USB Serial support registered for TI USB 5052 2=
 port adapter
[    4.738024] usbcore: registered new interface driver visor
[    4.743295] usbserial: USB Serial support registered for Handspring Vi=
sor / Palm OS
[    4.745012] usbserial: USB Serial support registered for Sony Clie 5.0=

[    4.746299] usbserial: USB Serial support registered for Sony Clie 3.5=

[    4.752008] usbcore: registered new interface driver whiteheat
[    4.753186] usbserial: USB Serial support registered for Connect Tech =
- WhiteHEAT - (prerenumeration)
[    4.759156] usbserial: USB Serial support registered for Connect Tech =
- WhiteHEAT
[    4.760927] usbcore: registered new interface driver xsens_mt
[    4.762092] usbserial: USB Serial support registered for xsens_mt
[    4.768268] usbcore: registered new interface driver zte_ev
[    4.769420] usbserial: USB Serial support registered for zte_ev
[    4.775409] usbcore: registered new interface driver appledisplay
[    4.776653] usbcore: registered new interface driver cypress_cy7c63
[    4.777904] usbcore: registered new interface driver cytherm
[    4.783135] usbcore: registered new interface driver emi26 - firmware =
loader
[    4.784593] usbcore: registered new interface driver emi62 - firmware =
loader
[    4.785917] driver ftdi-elan
[    4.795516] usbcore: registered new interface driver ftdi-elan
[    4.796757] usbcore: registered new interface driver idmouse
[    4.797922] usbcore: registered new interface driver iowarrior
[    4.799147] usbcore: registered new interface driver isight_firmware
[    4.800514] usbcore: registered new interface driver ldusb
[    4.801645] usbcore: registered new interface driver usbled
[    4.802794] usbcore: registered new interface driver legousbtower
[    4.808965] usbcore: registered new interface driver trancevibrator
[    4.810242] usbcore: registered new interface driver yurex
[    4.811523] usbcore: registered new interface driver cxacru
[    4.812674] usbcore: registered new interface driver speedtch
[    4.813832] xusbatm: malformed module parameters
[    4.815148] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0=
x60,0x64 irq 1,12
[    4.825751] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.827319] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.913671] mousedev: PS/2 mouse device common for all mice
[    4.915719] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input1
[    4.918235] usbcore: registered new interface driver xpad
[    4.919522] parport0: cannot grant exclusive access for device walkera=
0701
[    4.920981] walkera0701: failed to register parport device
[    4.922248] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    4.924614] usbcore: registered new interface driver ati_remote2
[    4.925915] cm109: Keymap for Komunikate KIP1000 phone loaded
[    4.927662] usbcore: registered new interface driver cm109
[    4.928853] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggesta=
d
[    4.930292] usbcore: registered new interface driver keyspan_remote
[    4.951413] wistron_btns: System unknown
[    4.952432] usbcore: registered new interface driver yealink
[    4.953959] i2c-parport: adapter type unspecified
[    4.963413] i2c-parport-light: adapter type unspecified
[    4.964575] usbcore: registered new interface driver i2c-tiny-usb
[    4.965835] isa i2c-pca-isa.0: Please specify I/O base
[    4.975354] lirc_dev: IR Remote Control driver registered, major 243=20
[    4.976708] IR RC5(x) protocol handler initialized
[    4.977788] IR JVC protocol handler initialized
[    4.978740] IR Sony protocol handler initialized
[    4.983778] IR SANYO protocol handler initialized
[    4.984762] IR MCE Keyboard/mouse protocol handler initialized
[    4.985985] usbcore: registered new interface driver dvb_usb_vp7045
[    4.992107] usbcore: registered new interface driver dvb_usb_vp702x
[    4.993497] usbcore: registered new interface driver dvb_usb_gp8psk
[    4.994871] usbcore: registered new interface driver dvb_usb_dtt200u
[    5.000506] usbcore: registered new interface driver dvb_usb_a800
[    5.001741] usbcore: registered new interface driver dvb_usb_dibusb_mb=

[    5.007457] usbcore: registered new interface driver dvb_usb_dibusb_mc=

[    5.008825] usbcore: registered new interface driver dvb_usb_m920x
[    5.010172] usbcore: registered new interface driver dvb_usb_cxusb
[    5.015902] usbcore: registered new interface driver dvb_usb_dib0700
[    5.017392] usbcore: registered new interface driver opera1
[    5.042455] usbcore: registered new interface driver pctv452e
[    5.047697] usbcore: registered new interface driver dw2102
[    5.048844] usbcore: registered new interface driver dvb_usb_dtv5100
[    5.050101] usbcore: registered new interface driver cinergyT2
[    5.055649] usbcore: registered new interface driver dvb_usb_friio
[    5.056907] usbcore: registered new interface driver dvb_usb_az6027
[    5.058152] usbcore: registered new interface driver dvb_usb_technisat=
_usb2
[    5.063716] usbcore: registered new interface driver dvb_usb_anysee
[    5.064947] usbcore: registered new interface driver dvb_usb_au6610
[    5.066187] usbcore: registered new interface driver dvb_usb_az6007
[    5.071837] usbcore: registered new interface driver dvb_usb_ce6230
[    5.073153] usbcore: registered new interface driver dvb_usb_mxl111sf
[    5.074423] usbcore: registered new interface driver dvb_usb_rtl28xxu
[    5.079756] usbcore: registered new interface driver smsusb
[    5.080887] au0828 driver loaded
[    5.081701] usbcore: registered new interface driver au0828
[    5.082837] usbcore: registered new interface driver hdpvr
[    5.088369] usbcore: registered new interface driver usbvision
[    5.089520] USBVision USB Video Device Driver for Linux : 0.9.11
[    5.090723] usbcore: registered new interface driver cx231xx
[    5.094888] usbcore: registered new interface driver tm6000
[    5.096418] Driver for 1-wire Dallas network protocol.
[    5.097690] usbcore: registered new interface driver DS9490R
[    5.098883] 1-Wire driver for the DS2760 battery monitor  chip  - (c) =
2004-2005, Szabolcs Gyurko
[    5.102842] applesmc: supported laptop not found!
[    5.112706] applesmc: driver init failed (ret=3D-19)!
[    5.119392] Bluetooth: Virtual HCI driver ver 1.3
[    5.131079] Bluetooth: HCI UART driver ver 2.2
[    5.132051] Bluetooth: HCI H4 protocol initialized
[    5.133114] Bluetooth: HCI BCSP protocol initialized
[    5.134155] Bluetooth: HCILL protocol initialized
[    5.139525] Bluetooth: HCIATH3K protocol initialized
[    5.140562] Bluetooth: HCI Three-wire UART (H5) protocol initialized
[    5.141907] usbcore: registered new interface driver bpa10x
[    5.147419] usbcore: registered new interface driver bfusb
[    5.148656] EDAC MC: Ver: 3.0.0
[    5.151165] EISA: Probing bus 0 at eisa.0
[    5.152080] EISA: Cannot allocate resource for mainboard
[    5.153317] lguest: mapped switcher at ffe00000
[    5.159619] cpuidle: using governor ladder
[    5.160547] cpuidle: using governor menu
[    5.164241] dcdbas dcdbas: Dell Systems Management Base Driver (versio=
n 5.6.0-3.2)
[    5.171269] usbcore: registered new interface driver usbhid
[    5.172401] usbhid: USB HID core driver
[    5.175541] NET: Registered protocol family 26
[    5.176556] NET: Registered protocol family 17
[    5.177782] NET: Registered protocol family 5
[    5.185281] NET: Registered protocol family 11
[    5.186366] NET: Registered protocol family 3
[    5.195129] Bluetooth: RFCOMM TTY layer initialized
[    5.196216] Bluetooth: RFCOMM socket layer initialized
[    5.197362] Bluetooth: RFCOMM ver 1.11
[    5.198205] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.203674] Bluetooth: BNEP filters: protocol multicast
[    5.204776] Bluetooth: BNEP socket layer initialized
[    5.205853] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    5.211075] Bluetooth: HIDP socket layer initialized
[    5.212093] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECn=
et Project Team
[    5.214207] DECnet: Routing cache hash table of 256 buckets, 9Kbytes
[    5.219956] NET: Registered protocol family 12
[    5.221004] 8021q: 802.1Q VLAN Support v1.8
[    5.222066] 9pnet: Installing 9P2000 support
[    5.227527] NET: Registered protocol family 37
[    5.228655] Key type dns_resolver registered
[    5.230257]=20
[    5.230257] printing PIC contents
[    5.235863] ... PIC  IMR: ffff
[    5.236614] ... PIC  IRR: 1013
[    5.237386] ... PIC  ISR: 0000
[    5.238136] ... PIC ELCR: 0c00
[    5.238879] printing local APIC contents on CPU#0/0:
[    5.240708] ... APIC ID:      00000000 (0)
[    5.240708] ... APIC VERSION: 00050014
[    5.240708] ... APIC TASKPRI: 00000000 (00)
[    5.240708] ... APIC PROCPRI: 00000000
[    5.240708] ... APIC LDR: 01000000
[    5.240708] ... APIC DFR: ffffffff
[    5.240708] ... APIC SPIV: 000001ff
[    5.240708] ... APIC ISR field:
[    5.240708] 0000000000000000000000000000000000000000000000000000000000=
000000
[    5.240708] ... APIC TMR field:
[    5.240708] 0000000002000000000000000000000000000000000000000000000000=
000000
[    5.240708] ... APIC IRR field:
[    5.240708] 0000000000000000000000000000000000000000000000000000000000=
008000
[    5.240708] ... APIC ESR: 00000000
[    5.240708] ... APIC ICR: 000008fb
[    5.240708] ... APIC ICR2: 02000000
[    5.240708] ... APIC LVTT: 000000ef
[    5.240708] ... APIC LVTPC: 00010000
[    5.240708] ... APIC LVT0: 00010700
[    5.240708] ... APIC LVT1: 00000400
[    5.240708] ... APIC LVTERR: 000000fe
[    5.240708] ... APIC TMICT: 00027fd9
[    5.240708] ... APIC TMCCT: 00000000
[    5.240708] ... APIC TDCR: 00000003
[    5.240708]=20
[    5.286159] number of MP IRQ sources: 15.
[    5.297060] number of IO-APIC #0 registers: 24.
[    5.297957] testing the IO APIC.......................
[    5.298941] IO APIC #0......
[    5.299752] .... register #00: 00000000
[    5.300566] .......    : physical APIC id: 00
[    5.301424] .......    : Delivery Type: 0
[    5.302236] .......    : LTS          : 0
[    5.303083] .... register #01: 00170011
[    5.304006] .......     : max redirection entries: 17
[    5.304965] .......     : PRQ implemented: 0
[    5.305814] .......     : IO APIC version: 11
[    5.316761] .... register #02: 00000000
[    5.317577] .......     : arbitration: 00
[    5.318381] .... IRQ redirection table:
[    5.319198] 1    0    0   0   0    0    0    00
[    5.320111] 0    0    0   0   0    1    1    31
[    5.321049] 0    0    0   0   0    1    1    30
[    5.321943] 0    0    0   0   0    1    1    33
[    5.322839] 1    0    0   0   0    1    1    34
[    5.323766] 1    1    0   0   0    1    1    35
[    5.324661] 0    0    0   0   0    1    1    36
[    5.325549] 0    0    0   0   0    1    1    37
[    5.326432] 0    0    0   0   0    1    1    38
[    5.327535] 0    1    0   0   0    1    1    39
[    5.328580] 1    1    0   0   0    1    1    3A
[    5.329541] 1    1    0   0   0    1    1    3B
[    5.330513] 0    0    0   0   0    1    1    3C
[    5.331574] 0    0    0   0   0    1    1    3D
[    5.332462] 0    0    0   0   0    1    1    3E
[    5.333371] 0    0    0   0   0    1    1    3F
[    5.334264] 1    0    0   0   0    0    0    00
[    5.335234] 1    0    0   0   0    0    0    00
[    5.336289] 1    0    0   0   0    0    0    00
[    5.337234] 1    0    0   0   0    0    0    00
[    5.338127] 1    0    0   0   0    0    0    00
[    5.339035] 1    0    0   0   0    0    0    00
[    5.340030] 1    0    0   0   0    0    0    00
[    5.341072] 1    0    0   0   0    0    0    00
[    5.342025] IRQ to pin mappings:
[    5.342813] IRQ0 -> 0:2
[    5.343665] IRQ1 -> 0:1
[    5.344502] IRQ3 -> 0:3
[    5.345386] IRQ4 -> 0:4
[    5.346155] IRQ5 -> 0:5
[    5.346981] IRQ6 -> 0:6
[    5.347889] IRQ7 -> 0:7
[    5.348659] IRQ8 -> 0:8
[    5.349421] IRQ9 -> 0:9
[    5.350228] IRQ10 -> 0:10
[    5.351046] IRQ11 -> 0:11
[    5.352002] IRQ12 -> 0:12
[    5.352939] IRQ13 -> 0:13
[    5.353969] IRQ14 -> 0:14
[    5.354839] IRQ15 -> 0:15
[    5.355852] .................................... done.
[    5.357013] Using IPI Shortcut mode
[    5.387490] Key type trusted registered
[    5.406920] Key type encrypted registered
[    5.418481] debug: unmapping init [mem 0xc0d7e000-0xc0e05fff]
[    5.427149] Write protecting the kernel text: 7448k
[    5.428398] Write protecting the kernel read-only data: 3432k
[    5.429603] NX-protecting the kernel data: 6888k
[    5.616799] udev[135]: starting version 164
[    7.005320] GFS2: path_lookup on rootfs returned error -2
Kernel tests: Boot OK!
[   17.603698] sock: process `trinity-main' is using obsolete setsockopt =
SO_BSDCOMPAT
[   17.798944] ------------[ cut here ]------------
[   17.798972] WARNING: at lib/idr.c:669 idr_find_slowpath+0x28/0xca()
[   17.798973] Hardware name: Bochs
[   17.798976] Pid: 655, comm: trinity-main Not tainted 3.8.0-06482-g0ffc=
2a9 #68
[   17.798976] Call Trace:
[   17.798989]  [<c022ace6>] warn_slowpath_common+0x72/0x89
[   17.798992]  [<c051f001>] ? idr_find_slowpath+0x28/0xca
[   17.798994]  [<c051f001>] ? idr_find_slowpath+0x28/0xca
[   17.798997]  [<c022ad9b>] warn_slowpath_null+0x1d/0x1f
[   17.798999]  [<c051f001>] idr_find_slowpath+0x28/0xca
[   17.799007]  [<c027fab7>] perf_init_event+0x82/0x124
[   17.799013]  [<c024321f>] ? __mutex_init+0x3f/0x44
[   17.799015]  [<c027fda9>] perf_event_alloc+0x250/0x360
[   17.799018]  [<c028040e>] sys_perf_event_open+0x336/0x664
[   17.799036]  [<c0944280>] syscall_call+0x7/0xb
[   17.799042]  [<c0940000>] ? SetAgcIf.isra.6+0x156/0x290
[   17.799043] ---[ end trace 8e00e88be2b81021 ]---
[   76.161086] Unregister pv shared memory for cpu 0
[   76.162184] Unregister pv shared memory for cpu 1
[   76.163250] no ifx modem active;
[   76.165073] Restarting system.
[   76.165819] reboot: machine restart
Elapsed time: 85
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig=
-ha3-0612/0ffc2a9c8072969253a20821c2c733a2cbb4c7c7/vmlinuz-3.8.0-06482-g0=
ffc2a9 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbu=
ild-tests/run-queue/kvm/i386-randconfig-ha3-0612/baserock:baserock:morph:=
0ffc2a9c8072969253a20821c2c733a2cbb4c7c7:bisect-linux6/.vmlinuz-0ffc2a9c8=
072969253a20821c2c733a2cbb4c7c7-20140613065423-110-ivb41 branch=3Dbaseroc=
k/baserock/morph BOOT_IMAGE=3D/kernel/i386-randconfig-ha3-0612/0ffc2a9c80=
72969253a20821c2c733a2cbb4c7c7/vmlinuz-3.8.0-06482-g0ffc2a9 drbd.minor_co=
unt=3D8'  -initrd /kernel-tests/initrd/yocto-minimal-i386.cgz -m 320 -smp=
 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -n=
o-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot=
/pid-yocto-ivb41-19 -serial file:/dev/shm/kboot/serial-yocto-ivb41-19 -da=
emonize -display none -monitor null=20


--------------050201040302000204090605
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-quantal-ivb41-100:20140613071446:i386-randconfig-ha3-0612:3.8.0-06481-g5461628:69"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="dmesg-quantal-ivb41-100:20140613071446:i386-randconfig-ha3-0";
 filename*1="612:3.8.0-06481-g5461628:69"

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-06481-g5461628 (kbuild@lkp-hsx01) (gcc=
 version 4.8.2 (Debian 4.8.2-18) ) #69 SMP PREEMPT Fri Jun 13 07:03:18 CS=
T 2014
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped a=
t [c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] ACPI: RSDP 000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13ffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BX=
PC 00000001)
[    0.000000] ACPI: FACP 13ffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BX=
PC 00000001)
[    0.000000] ACPI: DSDT 13ffe490 011A9 (v01   BXPC   BXDSDT 00000001 IN=
TL 20100528)
[    0.000000] ACPI: FACS 13ffff40 00040
[    0.000000] ACPI: SSDT 13fff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BX=
PC 00000001)
[    0.000000] ACPI: APIC 13fff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BX=
PC 00000001)
[    0.000000] ACPI: HPET 13fff640 00038 (v01 BOCHS  BXPCHPET 00000001 BX=
PC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] initial memory mapped: [mem 0x00000000-0x019fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127aafff]
[    0.000000]  [mem 0x12600000-0x127aafff] page 4k
[    0.000000] BRK [0x01413000, 0x01413fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x01414000, 0x01414fff] PGTABLE
[    0.000000] BRK [0x01415000, 0x01415fff] PGTABLE
[    0.000000] BRK [0x01416000, 0x01416fff] PGTABLE
[    0.000000] BRK [0x01417000, 0x01417fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x127ab000-0x13ffdfff]
[    0.000000]  [mem 0x127ab000-0x13ffdfff] page 4k
[    0.000000] cma: CMA: reserved 16 MiB at 11400000
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @d26b9000 s26752 r0 d14208 u=
40960
[    0.000000] pcpu-alloc: s26752 r0 d14208 u40960 alloc=3D10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 126bb500
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ha3-0612/=
baserock:baserock:morph:54616283c2948812a44240858ced610e7cacbde1:bisect-l=
inux6/.vmlinuz-54616283c2948812a44240858ced610e7cacbde1-20140613070651-31=
4-ivb41 branch=3Dbaserock/baserock/morph BOOT_IMAGE=3D/kernel/i386-randco=
nfig-ha3-0612/54616283c2948812a44240858ced610e7cacbde1/vmlinuz-3.8.0-0648=
1-g5461628 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 by=
tes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 261460k/327672k available (7444k kernel code, 6582=
0k reserved, 4315k data, 544k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xffbfe000   ( 692 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc0d7c000 - 0xc0e04000   ( 544 kB)
[    0.000000]       .data : 0xc0945001 - 0xc0d7bcc0   (4315 kB)
[    0.000000]       .text : 0xc0200000 - 0xc0945001   (7444 kB)
[    0.000000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dd081a000 soft=3Dd081c000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-06481-g5461628 (kbuild@lkp-hsx01) (gcc=
 version 4.8.2 (Debian 4.8.2-18) ) #69 SMP PREEMPT Fri Jun 13 07:03:18 CS=
T 2014
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
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
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped a=
t [c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] ACPI: RSDP 000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 13ffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BX=
PC 00000001)
[    0.000000] ACPI: FACP 13ffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BX=
PC 00000001)
[    0.000000] ACPI: DSDT 13ffe490 011A9 (v01   BXPC   BXDSDT 00000001 IN=
TL 20100528)
[    0.000000] ACPI: FACS 13ffff40 00040
[    0.000000] ACPI: SSDT 13fff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BX=
PC 00000001)
[    0.000000] ACPI: APIC 13fff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BX=
PC 00000001)
[    0.000000] ACPI: HPET 13fff640 00038 (v01 BOCHS  BXPCHPET 00000001 BX=
PC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] initial memory mapped: [mem 0x00000000-0x019fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12600000-0x127aafff]
[    0.000000]  [mem 0x12600000-0x127aafff] page 4k
[    0.000000] BRK [0x01413000, 0x01413fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x125fffff]
[    0.000000]  [mem 0x10000000-0x125fffff] page 4k
[    0.000000] BRK [0x01414000, 0x01414fff] PGTABLE
[    0.000000] BRK [0x01415000, 0x01415fff] PGTABLE
[    0.000000] BRK [0x01416000, 0x01416fff] PGTABLE
[    0.000000] BRK [0x01417000, 0x01417fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x127ab000-0x13ffdfff]
[    0.000000]  [mem 0x127ab000-0x13ffdfff] page 4k
[    0.000000] cma: CMA: reserved 16 MiB at 11400000
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 684 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI device=
s
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @d26b9000 s26752 r0 d14208 u=
40960
[    0.000000] pcpu-alloc: s26752 r0 d14208 u40960 alloc=3D10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 126bb500
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 81100
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3Dtty=
S0,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_=
timeout=3D100 panic=3D10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  promp=
t_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D=
/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-ha3-0612/=
baserock:baserock:morph:54616283c2948812a44240858ced610e7cacbde1:bisect-l=
inux6/.vmlinuz-54616283c2948812a44240858ced610e7cacbde1-20140613070651-31=
4-ivb41 branch=3Dbaserock/baserock/morph BOOT_IMAGE=3D/kernel/i386-randco=
nfig-ha3-0612/54616283c2948812a44240858ced610e7cacbde1/vmlinuz-3.8.0-0648=
1-g5461628 drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 b=
ytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 by=
tes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 261460k/327672k available (7444k kernel code, 6582=
0k reserved, 4315k data, 544k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff15000 - 0xfffff000   ( 936 kB)
[    0.000000]     pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xffbfe000   ( 692 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc0d7c000 - 0xc0e04000   ( 544 kB)
[    0.000000]       .data : 0xc0945001 - 0xc0d7bcc0   (4315 kB)
[    0.000000]       .text : 0xc0200000 - 0xc0945001   (7444 kB)
[    0.000000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dd081a000 soft=3Dd081c000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled, bootconsole disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc=
=2E, Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ODEBUG: 18 of 18 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.482 MHz processor
[    0.006666] Calibrating delay loop (skipped) preset value.. 5389.42 Bo=
goMIPS (lpj=3D8978273)
[    0.006675] pid_max: default: 32768 minimum: 301
[    0.008181] Mount-cache hash table entries: 512
[    0.011666] Initializing cgroup subsys devices
[    0.013352] Initializing cgroup subsys blkio
[    0.014639] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014639] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014639] tlb_flushall_shift: 6
[    0.016950] debug: unmapping init [mem 0xc0e04000-0xc0e07fff]
[    0.021092] ACPI: Core revision 20130117
[    0.031049] ACPI: All ACPI Tables successfully acquired
[    0.033769] Getting VERSION: 50014
[    0.034673] Getting VERSION: 50014
[    0.036676] Getting ID: 0
[    0.037429] Getting ID: f000000
[    0.038254] Getting LVT0: 8700
[    0.040008] Getting LVT1: 8400
[    0.040927] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.043366] enabled ExtINT on CPU#0
[    0.046972] ENABLING IO-APIC IRQs
[    0.050009] init IO_APIC IRQs
[    0.050858]  apic 0 pin 0 not connected
[    0.053372] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 =
Active:0 Dest:1)
[    0.055224] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 =
Active:0 Dest:1)
[    0.056706] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 =
Active:0 Dest:1)
[    0.060035] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 =
Active:0 Dest:1)
[    0.063370] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 =
Active:0 Dest:1)
[    0.066701] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 =
Active:0 Dest:1)
[    0.070009] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 =
Active:0 Dest:1)
[    0.073368] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 =
Active:0 Dest:1)
[    0.076697] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 =
Active:0 Dest:1)
[    0.080031] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:=
1 Active:0 Dest:1)
[    0.083368] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:=
1 Active:0 Dest:1)
[    0.086698] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:=
0 Active:0 Dest:1)
[    0.088567] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:=
0 Active:0 Dest:1)
[    0.090037] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:=
0 Active:0 Dest:1)
[    0.093371] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:=
0 Active:0 Dest:1)
[    0.095244]  apic 0 pin 16 not connected
[    0.096674]  apic 0 pin 17 not connected
[    0.097666]  apic 0 pin 18 not connected
[    0.098719]  apic 0 pin 19 not connected
[    0.100006]  apic 0 pin 20 not connected
[    0.101033]  apic 0 pin 21 not connected
[    0.101958]  apic 0 pin 22 not connected
[    0.103340]  apic 0 pin 23 not connected
[    0.104488] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.106673] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model:=
 06, stepping: 01)
[    0.110007] Using local APIC timer interrupts.
[    0.110007] calibrating APIC timer ...
[    0.116666] ... lapic delta =3D 6825029
[    0.116666] ... PM-Timer delta =3D 390889
[    0.116666] APIC calibration not consistent with PM-Timer: 109ms inste=
ad of 100ms
[    0.116666] APIC delta adjusted to PM-Timer: 6249974 (6825029)
[    0.116666] TSC delta adjusted to PM-Timer: 269343877 (294125946)
[    0.116666] ..... delta 6249974
[    0.116666] ..... mult: 268434366
[    0.116666] ..... calibration result: 3333319
[    0.116666] ..... CPU clock speed is 2693.2360 MHz.
[    0.116666] ..... host bus clock speed is 1000.0319 MHz.
[    0.116746] Performance Events: unsupported Netburst CPU model 6 no PM=
U driver, software events only.
[    0.131377] NMI watchdog: disabled (cpu0): hardware events not enabled=

[    0.135125] SMP alternatives: lockdep: fixing up alternatives
[    0.136693] CPU 1 irqstacks, hard=3Dd09d4000 soft=3Dd09d6000
[    0.138116] smpboot: Booting Node   0, Processors  #1 OK
[    0.003333] Initializing CPU#1
[    0.006666] kvm-clock: cpu 1, msr 0:13ffd041, secondary cpu clock
[    0.006666] masked ExtINT on CPU#1
[    0.180158] Brought up 2 CPUs
[    0.181036] smpboot: Total of 2 processors activated (10778.84 BogoMIP=
S)
[    0.180122] KVM setup async PF for cpu 1
[    0.180122] kvm-stealtime: cpu 1, msr 126c5500
[   48.133333] BUG: soft lockup - CPU#0 stuck for 22s! [migration/0:8]
[   48.133333] irq event stamp: 115138
[   48.133333] hardirqs last  enabled at (115137): [<c09438b9>] restore_a=
ll_notrace+0x0/0x18
[   48.133333] hardirqs last disabled at (115138): [<c0943b8b>] apic_time=
r_interrupt+0x2b/0x38
[   48.133333] softirqs last  enabled at (115136): [<c02303e2>] __do_soft=
irq+0x134/0x14f
[   48.133333] softirqs last disabled at (115131): [<c020389b>] do_softir=
q+0x60/0xb8
[   48.133333] Pid: 8, comm: migration/0 Not tainted 3.8.0-06481-g5461628=
 #69 Bochs Bochs
[   48.133333] EIP: 0060:[<c026e60b>] EFLAGS: 00000293 CPU: 0
[   48.133333] EIP is at stop_machine_cpu_stop+0x53/0xce
[   48.133333] EAX: 00000001 EBX: 00000001 ECX: d08ebeec EDX: 00000000
[   48.133333] ESI: d08ebeec EDI: 00000000 EBP: d0943e5c ESP: d0943e48
[   48.133333]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   48.133333] CR0: 8005003b CR2: ffffffff CR3: 00e0b000 CR4: 000006b0
[   48.133333] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   48.133333] DR6: ffff0ff0 DR7: 00000400
[   48.133333] Process migration/0 (pid: 8, ti=3Dd0942000 task=3Dd09403a0=
 task.ti=3Dd0942000)
[   48.133333] Stack:
[   48.133333]  01943e50 00000296 d26bba24 d08ebe88 c026e5b8 d0943f0c c02=
6e475 00000000
[   48.133333]  00000071 c104aac8 00000001 d09403a0 d26bba48 d08ebeec d09=
43f04 c0942110
[   48.133333]  c0cb844c 00000000 d0943f14 c0e030c0 0abc4e76 d09403a0 000=
00046 00000046
[   48.133333] Call Trace:
[   48.133333]  [<c026e5b8>] ? queue_stop_cpus_work+0xa0/0xa0
[   48.133333]  [<c026e475>] cpu_stopper_thread+0x73/0x116
[   48.133333]  [<c0942110>] ? __schedule+0x5f1/0x657
[   48.133333]  [<c02613d6>] ? lock_acquire+0x82/0x8a
[   48.133333]  [<c0942f41>] ? _raw_spin_unlock_irqrestore+0x38/0x62
[   48.133333]  [<c025fa8b>] ? trace_hardirqs_on_caller+0x129/0x141
[   48.133333]  [<c0942f5e>] ? _raw_spin_unlock_irqrestore+0x55/0x62
[   48.133333]  [<c0246f3a>] smpboot_thread_fn+0x19b/0x1b1
[   48.133333]  [<c0246d9f>] ? __smpboot_create_thread.part.4+0x82/0x82
[   48.133333]  [<c02403ce>] kthread+0x6e/0x73
[   48.133333]  [<c0240000>] ? exit_itimers+0x28/0x6c
[   48.133333]  [<c0943f77>] ret_from_kernel_thread+0x1b/0x28
[   48.133333]  [<c0240360>] ? __kthread_parkme+0x54/0x54
[   48.133333] Code: 00 00 00 e8 d1 b1 2b 00 39 c3 0f 94 45 ef eb 15 83 f=
b 07 76 05 e8 1a 4d 6c 00 0f a3 1f 19 db 85 db 0f 95 45 ef 31 ff 31 c0 f3=
 90 <8b> 5e 10 39 c3 74 41 83 fb 02 74 07 83 fb 03 74 0e eb 19 e8 3d
[   48.133333] Kernel panic - not syncing: softlockup: hung tasks
[   48.133333] Pid: 8, comm: migration/0 Not tainted 3.8.0-06481-g5461628=
 #69
[   48.133333] Call Trace:
[   48.133333]  [<c0932430>] panic+0x8c/0x187
[   48.133333]  [<c026e620>] ? stop_machine_cpu_stop+0x68/0xce
[   48.133333]  [<c026fcf7>] watchdog_timer_fn+0x127/0x146
[   48.133333]  [<c0243435>] __run_hrtimer.isra.20+0x5e/0xb0
[   48.133333]  [<c026fbd0>] ? __touch_watchdog+0x14/0x14
[   48.133333]  [<c0244154>] hrtimer_run_queues+0xf3/0x112
[   48.133333]  [<c0234dfe>] run_local_timers+0x8/0x14
[   48.133333]  [<c0234e2e>] update_process_times+0x24/0x54
[   48.133333]  [<c025c3f6>] tick_periodic+0x66/0x68
[   48.133333]  [<c025c451>] tick_handle_periodic+0x19/0x61
[   48.133333]  [<c0217f67>] smp_apic_timer_interrupt+0x5f/0x71
[   48.133333]  [<c0526254>] ? trace_hardirqs_off_thunk+0xc/0x10
[   48.133333]  [<c0943b92>] apic_timer_interrupt+0x32/0x38
[   48.133333]  [<c09400d8>] ? host_control_smi+0x7/0xdc
[   48.133333]  [<c026e60b>] ? stop_machine_cpu_stop+0x53/0xce
[   48.133333]  [<c026e5b8>] ? queue_stop_cpus_work+0xa0/0xa0
[   48.133333]  [<c026e475>] cpu_stopper_thread+0x73/0x116
[   48.133333]  [<c0942110>] ? __schedule+0x5f1/0x657
[   48.133333]  [<c02613d6>] ? lock_acquire+0x82/0x8a
[   48.133333]  [<c0942f41>] ? _raw_spin_unlock_irqrestore+0x38/0x62
[   48.133333]  [<c025fa8b>] ? trace_hardirqs_on_caller+0x129/0x141
[   48.133333]  [<c0942f5e>] ? _raw_spin_unlock_irqrestore+0x55/0x62
[   48.133333]  [<c0246f3a>] smpboot_thread_fn+0x19b/0x1b1
[   48.133333]  [<c0246d9f>] ? __smpboot_create_thread.part.4+0x82/0x82
[   48.133333]  [<c02403ce>] kthread+0x6e/0x73
[   48.133333]  [<c0240000>] ? exit_itimers+0x28/0x6c
[   48.133333]  [<c0943f77>] ret_from_kernel_thread+0x1b/0x28
[   48.133333]  [<c0240360>] ? __kthread_parkme+0x54/0x54

Elapsed time: 65
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig=
-ha3-0612/54616283c2948812a44240858ced610e7cacbde1/vmlinuz-3.8.0-06481-g5=
461628 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
10 softlockup_panic=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbu=
ild-tests/run-queue/kvm/i386-randconfig-ha3-0612/baserock:baserock:morph:=
54616283c2948812a44240858ced610e7cacbde1:bisect-linux6/.vmlinuz-54616283c=
2948812a44240858ced610e7cacbde1-20140613070651-314-ivb41 branch=3Dbaseroc=
k/baserock/morph BOOT_IMAGE=3D/kernel/i386-randconfig-ha3-0612/54616283c2=
948812a44240858ced610e7cacbde1/vmlinuz-3.8.0-06481-g5461628 drbd.minor_co=
unt=3D8'  -initrd /kernel-tests/initrd/quantal-core-i386.cgz -m 320 -smp =
2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no=
-reboot -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/=
pid-quantal-ivb41-100 -serial file:/dev/shm/kboot/serial-quantal-ivb41-10=
0 -daemonize -display none -monitor null=20


--------------050201040302000204090605
Content-Type: application/octet-stream;
 name="i386-randconfig-ha3-0612-6dbe51c251a327e012439c4772097a13df43c5b8-WARNING:---at----idr_find_slowpath+-x-109888.log"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="i386-randconfig-ha3-0612-6dbe51c251a327e012439c4772097a13df4";
 filename*1="3c5b8-WARNING:---at----idr_find_slowpath+-x-109888.log"

SEVBRCBpcyBub3cgYXQgNmRiZTUxYy4uLiBMaW51eCAzLjktcmMxCmJpc2VjdDogc2tpcCAz
MTZkZjRjM2ViNjY3NjM2ZWFkZjRiNjYzZjQwODdmMWY5Y2MzY2ZlOiBub3QgYSBnb29kIG1l
cmdlIGJhc2UKZ2l0IGNoZWNrb3V0IDZkYmU1MWMyNTFhMzI3ZTAxMjQzOWM0NzcyMDk3YTEz
ZGY0M2M1YjgKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1oYTMtMDYxMi9iYXNlcm9jazpiYXNlcm9jazptb3JwaDo2ZGJlNTFjMjUxYTMyN2Uw
MTI0MzljNDc3MjA5N2ExM2RmNDNjNWI4OmJpc2VjdC1saW51eDYKIFRFU1QgRkFJTFVSRQpb
ICAgIDMuMjg2MjU5XSBpbml0OiBGYWlsZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGluZyBs
b2dnaW5nIGZvciBqb2IKWyAgICAzLjI4NzIzM10gaW5pdDogVGVtcG9yYXJ5IHByb2Nlc3Mg
c3Bhd24gZXJyb3I6IE5vIHNwYWNlIGxlZnQgb24gZGV2aWNlClsgICAgMy4zMTU5MDldIGlu
aXQ6IG1vdW50ZWQtdG1wIG1haW4gcHJvY2VzcyAoMTQ3KSB0ZXJtaW5hdGVkIHdpdGggc3Rh
dHVzIDMyClsgICAxMy4zMjY5NzJdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFn
aW5nIHJlcXVlc3QgYXQgYmEzNDA0ZTAKWyAgIDEzLjMyNzk2Nl0gSVA6IFs8YzAyODI1Yjc+
XSBzdGF0aWNfa2V5X3Nsb3dfaW5jKzB4NC8weDQ3ClsgICAxMy4zMjg3NjJdICpwZHB0ID0g
MDAwMDAwMDAwODVjYjAwMSAqcGRlID0gMDAwMDAwMDAwMDAwMDAwMCAKWyAgIDEzLjMyOTY1
Ml0gT29wczogMDAwMCBbIzFdIFBSRUVNUFQgU01QIERFQlVHX1BBR0VBTExPQwpbICAgMTMu
MzMwMDA4XSBQaWQ6IDE3MiwgY29tbTogdHJpbml0eS1tYWluIFRhaW50ZWQ6IEcgICAgICAg
IFcgICAgMy45LjAtcmMxICMxIEJvY2hzIEJvY2hzClsgICAxMy4zMzAwMDhdIEVJUDogMDA2
MDpbPGMwMjgyNWI3Pl0gRUZMQUdTOiAwMDAxMDIwNiBDUFU6IDEKWyAgIDEzLjMzMDAwOF0g
RUlQIGlzIGF0IHN0YXRpY19rZXlfc2xvd19pbmMrMHg0LzB4NDcKWyAgIDEzLjMzMDAwOF0g
RUFYOiBiYTM0MDRlMCBFQlg6IGM3ZDQxYzAwIEVDWDogMDAwMDAwMTggRURYOiAwMDAwMDAw
OApbICAgMTMuMzMwMDA4XSBFU0k6IDAwMDAwMDA4IEVESTogZmYyMDU4ZmEgRUJQOiBjODVh
NWViNCBFU1A6IGM4NWE1ZWIwClsgICAxMy4zMzAwMDhdICBEUzogMDA3YiBFUzogMDA3YiBG
UzogMDBkOCBHUzogMDAzMyBTUzogMDA2OApbICAgMTMuMzMwMDA4XSBDUjA6IDgwMDUwMDNi
IENSMjogYmEzNDA0ZTAgQ1IzOiAwODY3ZjAwMCBDUjQ6IDAwMDAwNjMwClsgICAxMy4zMzAw
MDhdIERSMDogMDAwMDAwMDAgRFIxOiAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwIERSMzogMDAw
MDAwMDAKWyAgIDEzLjMzMDAwOF0gRFI2OiBmZmZmMGZmMCBEUjc6IDAwMDAwNDAwClsgICAx
My4zMzAwMDhdIFByb2Nlc3MgdHJpbml0eS1tYWluIChwaWQ6IDE3MiwgdGk9Yzg1YTQwMDAg
dGFzaz1jODViZTlhMCB0YXNrLnRpPWM4NWE0MDAwKQpbICAgMTMuMzMwMDA4XSBTdGFjazoK
WyAgIDEzLjMzMDAwOF0gIGM3ZDQxYzAwIGM4NWE1ZWNjIGMwMjdiNjkyIDAwMDAwMDAwIGMw
Y2JiNzMwIGM3ZDQxYzAwIDAwMDAwMDAwIGM4NWE1ZWU4ClsgICAxMy4zMzAwMDhdICBjMDI3
ZjNlMyAwMDAwMDAwMCBjMGNiYjczMCAwMDAwMDAwMCBjN2Q0MWQ0OCBjN2Q0MWMwMCBjODVh
NWYwNCBjMDI3ZjY4OQpbICAgMTMuMzMwMDA4XSAgYzg1YTVmNDAgYzdkNDFjMDAgMDAwMDAw
MDAgYzg1YmU5YTAgMDAwMDAwMDAgYzg1YTVmYWMgYzAyN2ZjZWUgYzdkNDFjMDAKWyAgIDEz
LjMzMDAwOF0gQ2FsbCBUcmFjZToKWyAgIDEzLjMzMDAwOF0gIFs8YzAyN2I2OTI+XSBwZXJm
X3N3ZXZlbnRfaW5pdCsweGI4LzB4ZGQKWyAgIDEzLjMzMDAwOF0gIFs8YzAyN2YzZTM+XSBw
ZXJmX2luaXRfZXZlbnQrMHhjZS8weDEyNApbICAgMTMuMzMwMDA4XSAgWzxjMDI3ZjY4OT5d
IHBlcmZfZXZlbnRfYWxsb2MrMHgyNTAvMHgzNjAKWyAgIDEzLjMzMDAwOF0gIFs8YzAyN2Zj
ZWU+XSBzeXNfcGVyZl9ldmVudF9vcGVuKzB4MzM2LzB4NjY0ClsgICAxMy4zMzAwMDhdICBb
PGMwMjE3YjIwPl0gPyBsYXBpY19uZXh0X2V2ZW50KzB4Zi8weDEzClsgICAxMy4zMzAwMDhd
ICBbPGMwMjViOTVkPl0gPyBjbG9ja2V2ZW50c19wcm9ncmFtX2V2ZW50KzB4YzcvMHhlMgpb
ICAgMTMuMzMwMDA4XSAgWzxjMDk0NWM4YT5dIHN5c2VudGVyX2RvX2NhbGwrMHgxMi8weDNj
ClsgICAxMy4zMzAwMDhdIENvZGU6IDMxIGQyIDg5IGQ4IGU4IDM4IGZmIGZmIGZmIGU4IDg1
IGZmIGZmIGZmIDgzIGM0IDBjIDViIDVlIDVmIDVkIGMzIDU1IDgzIGU4IDBjIDg5IGU1IDMx
IGM5IDMxIGQyIGU4IDdkIGZmIGZmIGZmIDVkIGMzIDU1IDg5IGU1IDUzIDw4Yj4gMTAgODkg
YzMgODUgZDIgNzQgMTEgOGQgNGEgMDEgODkgZDAgZjAgMGYgYjEgMGIgMzkgZDAgNzQgMmIK
WyAgIDEzLjMzMDAwOF0gRUlQOiBbPGMwMjgyNWI3Pl0gc3RhdGljX2tleV9zbG93X2luYysw
eDQvMHg0NyBTUzpFU1AgMDA2ODpjODVhNWViMApbICAgMTMuMzMwMDA4XSBDUjI6IDAwMDAw
MDAwYmEzNDA0ZTAKWyAgIDEzLjM2MzcwM10gLS0tWyBlbmQgdHJhY2UgYjFlMDQ5YWM1ZDBk
NmM3MyBdLS0tClsgICAxMy4zNjQzNzFdIEtlcm5lbCBwYW5pYyAtIG5vdCBzeW5jaW5nOiBG
YXRhbCBleGNlcHRpb24KL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MTIvNmRiZTUx
YzI1MWEzMjdlMDEyNDM5YzQ3NzIwOTdhMTNkZjQzYzViOC9kbWVzZy15b2N0by1pdmI0MS0x
NToyMDE0MDYxMjIzMDUzOTppMzg2LXJhbmRjb25maWctaGEzLTA2MTI6My45LjAtcmMxOjEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MTIvNmRiZTUxYzI1MWEzMjdlMDEyNDM5
YzQ3NzIwOTdhMTNkZjQzYzViOC9kbWVzZy15b2N0by1pdmI0MS0xMTI6MjAxNDA2MTIyMzA1
Mzg6aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyOjMuOS4wLXJjMToxCi9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWhhMy0wNjEyLzZkYmU1MWMyNTFhMzI3ZTAxMjQzOWM0NzcyMDk3YTEzZGY0
M2M1YjgvZG1lc2cteW9jdG8taXZiNDItMTIzOjIwMTQwNjEyMjMwNTM3OmkzODYtcmFuZGNv
bmZpZy1oYTMtMDYxMjozLjkuMC1yYzE6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMt
MDYxMi82ZGJlNTFjMjUxYTMyN2UwMTI0MzljNDc3MjA5N2ExM2RmNDNjNWI4L2RtZXNnLXlv
Y3RvLWl2YjQyLTQzOjIwMTQwNjEyMjI1OTQ3OmkzODYtcmFuZGNvbmZpZy1oYTMtMDYxMjoz
LjkuMC1yYzE6MQoyOjQ6OCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAx
NC0wNi0xMiAyMzowNjowNCBSRVBFQVQgQ09VTlQ6IDM1ICAjIC9jL2Jvb3QtYmlzZWN0L2xp
bnV4Ni9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgNmRiZTUx
YzI1MWEzMjdlMDEyNDM5YzQ3NzIwOTdhMTNkZjQzYzViOApnaXQgY2hlY2tvdXQgdjMuOAps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWhhMy0w
NjEyL2Jhc2Vyb2NrOmJhc2Vyb2NrOm1vcnBoOjE5Zjk0OWY1MjU5OWJhN2MzZjY3YTU4OTdh
YzZiZTE0YmZjYjEyMDA6YmlzZWN0LWxpbnV4NgoKMjAxNC0wNi0xMi0yMzowNjowNyAxOWY5
NDlmNTI1OTliYTdjM2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAwIGNvbXBpbGluZwpRdWV1ZWQg
YnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1oYTMtMDYxMi0xOWY5NDlmNTI1OTliYTdjM2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAwCkNo
ZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MTIvMTlm
OTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2FjNmJlMTRiZmNiMTIwMAp3YWl0aW5nIGZvciBjb21w
bGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhh
My0wNjEyLTE5Zjk0OWY1MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJh
bmRjb25maWctaGEzLTA2MTItMTlmOTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2FjNmJlMTRiZmNi
MTIwMAp0aW1lb3V0ClJldHJ5IGJ1aWxkIC4uClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLTE5Zjk0OWY1
MjU5OWJhN2MzZjY3YTU4OTdhYzZiZTE0YmZjYjEyMDAKQ2hlY2sgZm9yIGtlcm5lbCBpbiAv
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi8xOWY5NDlmNTI1OTliYTdjM2Y2N2E1
ODk3YWM2YmUxNGJmY2IxMjAwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEzLTA2MTItMTlmOTQ5ZjUyNTk5
YmE3YzNmNjdhNTg5N2FjNmJlMTRiZmNiMTIwMAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9m
IC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi0x
OWY5NDlmNTI1OTliYTdjM2Y2N2E1ODk3YWM2YmUxNGJmY2IxMjAwCmtlcm5lbDogL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctaGEzLTA2MTIvMTlmOTQ5ZjUyNTk5YmE3YzNmNjdhNTg5N2Fj
NmJlMTRiZmNiMTIwMC92bWxpbnV6LTMuOC4wCgoyMDE0LTA2LTEzLTAyOjI3OjA3IGRldGVj
dGluZyBib290IHN0YXRlIC4uLi4JMQkxNAkxOAkzNSBTVUNDRVNTCgpiaXNlY3Q6IGdvb2Qg
Y29tbWl0IHYzLjgKZ2l0IGJpc2VjdCBzdGFydCA2ZGJlNTFjMjUxYTMyN2UwMTI0MzljNDc3
MjA5N2ExM2RmNDNjNWI4IHYzLjggLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6
IFsiLWIiLCAiNmRiZTUxYzI1MWEzMjdlMDEyNDM5YzQ3NzIwOTdhMTNkZjQzYzViOCIsICIt
ZyIsICJ2My44IiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUu
c2giLCAiL2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNlY3QiXQpCaXNlY3Rpbmc6IDEw
OTQyIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxNCBzdGVw
cykKW2Q0MTRjMTA0ZTI2ZmQzYjU5N2Y4NTVjYzI5NDczYThiMTUyN2ZiNGNdIE1lcmdlIHRh
ZyAncGxlYXNlLXB1bGwtdm1fdW53cmFwcGVkJyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYWVnbC9saW51eApydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg2
L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1oYTMtMDYxMi9iYXNlcm9jazpiYXNlcm9jazptb3JwaDpkNDE0YzEwNGUyNmZk
M2I1OTdmODU1Y2MyOTQ3M2E4YjE1MjdmYjRjOmJpc2VjdC1saW51eDYKCjIwMTQtMDYtMTMt
MDI6MzI6MzQgZDQxNGMxMDRlMjZmZDNiNTk3Zjg1NWNjMjk0NzNhOGIxNTI3ZmI0YyBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctaGEzLTA2MTItZDQxNGMxMDRlMjZmZDNiNTk3Zjg1NWNjMjk0NzNh
OGIxNTI3ZmI0YwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWhhMy0wNjEyL2Q0MTRjMTA0ZTI2ZmQzYjU5N2Y4NTVjYzI5NDczYThiMTUyN2ZiNGMKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1oYTMtMDYxMi1kNDE0YzEwNGUyNmZkM2I1OTdmODU1Y2MyOTQ3M2E4YjE1
MjdmYjRjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLWQ0MTRjMTA0ZTI2ZmQzYjU5N2Y4NTVj
YzI5NDczYThiMTUyN2ZiNGMKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMt
MDYxMi9kNDE0YzEwNGUyNmZkM2I1OTdmODU1Y2MyOTQ3M2E4YjE1MjdmYjRjL3ZtbGludXot
My44LjAtMDc3MjEtZ2Q0MTRjMTAKCjIwMTQtMDYtMTMtMDI6MzU6MzQgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLi4uLi4uCTEJMwkxMAkyNQkzMwkzNSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDMw
MzAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0ZXBz
KQpbZWU4OWY4MTI1MjE3OWRjYmY2Y2Q2NWJkNDgyOTlmNWU1MjI5MmQ4OF0gTWVyZ2UgYnJh
bmNoICdmb3ItMy45L2NvcmUnIG9mIGdpdDovL2dpdC5rZXJuZWwuZGsvbGludXgtYmxvY2sK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGEzLTA2MTIvYmFzZXJvY2s6YmFzZXJvY2s6
bW9ycGg6ZWU4OWY4MTI1MjE3OWRjYmY2Y2Q2NWJkNDgyOTlmNWU1MjI5MmQ4ODpiaXNlY3Qt
bGludXg2CgoyMDE0LTA2LTEzLTAyOjQxOjM3IGVlODlmODEyNTIxNzlkY2JmNmNkNjViZDQ4
Mjk5ZjVlNTIyOTJkODggY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLWVlODlmODEyNTIx
NzlkY2JmNmNkNjViZDQ4Mjk5ZjVlNTIyOTJkODgKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi9lZTg5ZjgxMjUyMTc5ZGNiZjZjZDY1YmQ0
ODI5OWY1ZTUyMjkyZDg4CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEzLTA2MTItZWU4OWY4MTI1MjE3OWRj
YmY2Y2Q2NWJkNDgyOTlmNWU1MjI5MmQ4OAp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi1lZTg5
ZjgxMjUyMTc5ZGNiZjZjZDY1YmQ0ODI5OWY1ZTUyMjkyZDg4Cmtlcm5lbDogL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaGEzLTA2MTIvZWU4OWY4MTI1MjE3OWRjYmY2Y2Q2NWJkNDgyOTlm
NWU1MjI5MmQ4OC92bWxpbnV6LTMuOC4wLTA2Njg1LWdlZTg5ZjgxCgoyMDE0LTA2LTEzLTAy
OjQ1OjM3IGRldGVjdGluZyBib290IHN0YXRlIAk0CTEwIFRFU1QgRkFJTFVSRQpbICAgIDMu
MzM1Njg5XSBpbml0OiBGYWlsZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGluZyBsb2dnaW5n
IGZvciBqb2IKWyAgICAzLjMzNjYwNF0gaW5pdDogVGVtcG9yYXJ5IHByb2Nlc3Mgc3Bhd24g
ZXJyb3I6IE5vIHNwYWNlIGxlZnQgb24gZGV2aWNlClsgICAgMy4zNjQ4NDNdIGluaXQ6IG1v
dW50ZWQtdG1wIG1haW4gcHJvY2VzcyAoMTQ3KSB0ZXJtaW5hdGVkIHdpdGggc3RhdHVzIDMy
ClsgICAxMy4zOTE3NjldIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJl
cXVlc3QgYXQgYzBiMTNkMDgKWyAgIDEzLjM5Mjc5MV0gSVA6IFs8YzAyODI1ZTc+XSBzdGF0
aWNfa2V5X3Nsb3dfaW5jKzB4MTEvMHg0NwpbICAgMTMuMzkzMzQxXSAqcGRwdCA9IDAwMDAw
MDAwMDBlMGQwMDEgKnBkZSA9IDAwMDAwMDAwMDE0MGYwNjcgKnB0ZSA9IDgwMDAwMDAwMDBi
MTMxNjEgClsgICAxMy4zOTMzNDFdIE9vcHM6IDAwMDMgWyMxXSBQUkVFTVBUIFNNUCBERUJV
R19QQUdFQUxMT0MKWyAgIDEzLjM5MzM0MV0gUGlkOiAxNzIsIGNvbW06IHRyaW5pdHktbWFp
biBOb3QgdGFpbnRlZCAzLjguMC0wNjY4NS1nZWU4OWY4MSAjMyBCb2NocyBCb2NocwpbICAg
MTMuMzkzMzQxXSBFSVA6IDAwNjA6WzxjMDI4MjVlNz5dIEVGTEFHUzogMDAwMTAyMDYgQ1BV
OiAwClsgICAxMy4zOTMzNDFdIEVJUCBpcyBhdCBzdGF0aWNfa2V5X3Nsb3dfaW5jKzB4MTEv
MHg0NwpbICAgMTMuMzkzMzQxXSBFQVg6IDc1MjRmNTY5IEVCWDogYzBiMTNkMDggRUNYOiA3
NTI0ZjU2YSBFRFg6IDc1MjRmNTY5ClsgICAxMy4zOTMzNDFdIEVTSTogMDAwMDAwMDggRURJ
OiBmZmVmZmZmZiBFQlA6IGM5NzY1ZWI0IEVTUDogYzk3NjVlYjAKWyAgIDEzLjM5MzM0MV0g
IERTOiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMDMzIFNTOiAwMDY4ClsgICAxMy4z
OTMzNDFdIENSMDogODAwNTAwM2IgQ1IyOiBjMGIxM2QwOCBDUjM6IDA4NjJjMDAwIENSNDog
MDAwMDA2MzAKWyAgIDEzLjM5MzM0MV0gRFIwOiAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwIERS
MjogMDAwMDAwMDAgRFIzOiAwMDAwMDAwMApbICAgMTMuMzkzMzQxXSBEUjY6IGZmZmYwZmYw
IERSNzogMDAwMDA0MDAKWyAgIDEzLjM5MzM0MV0gUHJvY2VzcyB0cmluaXR5LW1haW4gKHBp
ZDogMTcyLCB0aT1jOTc2NDAwMCB0YXNrPWM5MDE2MTIwIHRhc2sudGk9Yzk3NjQwMDApClsg
ICAxMy4zOTMzNDFdIFN0YWNrOgpbICAgMTMuMzkzMzQxXSAgYzdkMjVjMDAgYzk3NjVlY2Mg
YzAyN2I2YjUgMDAwMDAwMDAgYzBjYmI3MzAgYzdkMjVjMDAgMDAwMDAwMDAgYzk3NjVlZTgK
WyAgIDEzLjM5MzM0MV0gIGMwMjdmNDA2IDAwMDAwMDAwIGMwY2JiNzMwIDAwMDAwMDAwIGM3
ZDI1ZDQ4IGM3ZDI1YzAwIGM5NzY1ZjA0IGMwMjdmNmFjClsgICAxMy4zOTMzNDFdICBjOTc2
NWY0MCBjN2QyNWMwMCAwMDAwMDAwMCBjOTAxNjEyMCAwMDAwMDAwMCBjOTc2NWZhYyBjMDI3
ZmQxMSBjN2QyNWMwMApbICAgMTMuMzkzMzQxXSBDYWxsIFRyYWNlOgpbICAgMTMuMzkzMzQx
XSAgWzxjMDI3YjZiNT5dIHBlcmZfc3dldmVudF9pbml0KzB4YjgvMHhkZApbICAgMTMuMzkz
MzQxXSAgWzxjMDI3ZjQwNj5dIHBlcmZfaW5pdF9ldmVudCsweGNlLzB4MTI0ClsgICAxMy4z
OTMzNDFdICBbPGMwMjdmNmFjPl0gcGVyZl9ldmVudF9hbGxvYysweDI1MC8weDM2MApbICAg
MTMuMzkzMzQxXSAgWzxjMDI3ZmQxMT5dIHN5c19wZXJmX2V2ZW50X29wZW4rMHgzMzYvMHg2
NjQKWyAgIDEzLjM5MzM0MV0gIFs8YzA5NDVmNGE+XSBzeXNlbnRlcl9kb19jYWxsKzB4MTIv
MHgzYwpbICAgMTMuMzkzMzQxXSBDb2RlOiBmZiA4MyBjNCAwYyA1YiA1ZSA1ZiA1ZCBjMyA1
NSA4MyBlOCAwYyA4OSBlNSAzMSBjOSAzMSBkMiBlOCA3ZCBmZiBmZiBmZiA1ZCBjMyA1NSA4
OSBlNSA1MyA4YiAxMCA4OSBjMyA4NSBkMiA3NCAxMSA4ZCA0YSAwMSA4OSBkMCA8ZjA+IDBm
IGIxIDBiIDM5IGQwIDc0IDJiIDg5IGMyIGViIGViIGU4IDM5IGZmIGZmIGZmIDhiIDAzIDg1
IGMwClsgICAxMy4zOTMzNDFdIEVJUDogWzxjMDI4MjVlNz5dIHN0YXRpY19rZXlfc2xvd19p
bmMrMHgxMS8weDQ3IFNTOkVTUCAwMDY4OmM5NzY1ZWIwClsgICAxMy4zOTMzNDFdIENSMjog
MDAwMDAwMDBjMGIxM2QwOApbICAgMTMuMzkzMzQxXSAtLS1bIGVuZCB0cmFjZSA3ZWJlNTJj
NjE3YTE0YWNiIF0tLS0KWyAgIDEzLjM5MzM0MV0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNp
bmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi9l
ZTg5ZjgxMjUyMTc5ZGNiZjZjZDY1YmQ0ODI5OWY1ZTUyMjkyZDg4L2RtZXNnLXlvY3RvLWl2
YjQ0LTk3OjIwMTQwNjEzMDI0NjEzOmkzODYtcmFuZGNvbmZpZy1oYTMtMDYxMjozLjguMC0w
NjY4NS1nZWU4OWY4MTozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyL2VlODlm
ODEyNTIxNzlkY2JmNmNkNjViZDQ4Mjk5ZjVlNTIyOTJkODgvZG1lc2cteW9jdG8taXZiNDIt
MTIxOjIwMTQwNjEzMDI0NjI0OmkzODYtcmFuZGNvbmZpZy1oYTMtMDYxMjozLjguMC0wNjY4
NS1nZWU4OWY4MTozCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyL2VlODlmODEy
NTIxNzlkY2JmNmNkNjViZDQ4Mjk5ZjVlNTIyOTJkODgvZG1lc2cteW9jdG8taXZiNDEtNDg6
MjAxNDA2MTMwMjQ2MjU6aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyOjMuOC4wLTA2Njg1LWdl
ZTg5ZjgxOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MTIvZWU4OWY4MTI1MjE3
OWRjYmY2Y2Q2NWJkNDgyOTlmNWU1MjI5MmQ4OC9kbWVzZy15b2N0by1pdmI0NC0xMTc6MjAx
NDA2MTMwMjQ2MzI6aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyOjMuOC4wLTA2Njg1LWdlZTg5
ZjgxOjMKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MTIvZWU4OWY4MTI1MjE3OWRj
YmY2Y2Q2NWJkNDgyOTlmNWU1MjI5MmQ4OC9kbWVzZy15b2N0by1pdmI0NC01MDoyMDE0MDYx
MzAyNDYyOTppMzg2LXJhbmRjb25maWctaGEzLTA2MTI6My44LjAtMDY2ODUtZ2VlODlmODE6
MwoxOjU6MTQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDYtMTMg
MDI6NDY6MzggUkVQRUFUIENPVU5UOiA0MCAgIyAvYy9ib290LWJpc2VjdC9saW51eDYvb2Jq
LWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAxODIzIHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxMSBzdGVwcykKW2E2NTkwYjlmMDFkY2EyZDQ1
YTM4YjgzODdmNTk4MTJjNDRmNjhhMmZdIE1lcmdlIHRhZyAndXBzdHJlYW0tMy45LXJjMScg
b2YgZ2l0Oi8vZ2l0LmluZnJhZGVhZC5vcmcvbGludXgtdWJpZnMKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xp
bnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctaGEzLTA2MTIvYmFzZXJvY2s6YmFzZXJvY2s6bW9ycGg6YTY1OTBiOWYw
MWRjYTJkNDVhMzhiODM4N2Y1OTgxMmM0NGY2OGEyZjpiaXNlY3QtbGludXg2CgoyMDE0LTA2
LTEzLTAyOjQ2OjQwIGE2NTkwYjlmMDFkY2EyZDQ1YTM4YjgzODdmNTk4MTJjNDRmNjhhMmYg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLWE2NTkwYjlmMDFkY2EyZDQ1YTM4YjgzODdm
NTk4MTJjNDRmNjhhMmYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1oYTMtMDYxMi9hNjU5MGI5ZjAxZGNhMmQ0NWEzOGI4Mzg3ZjU5ODEyYzQ0ZjY4YTJm
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctaGEzLTA2MTItYTY1OTBiOWYwMWRjYTJkNDVhMzhiODM4N2Y1OTgx
MmM0NGY2OGEyZgprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyL2E2
NTkwYjlmMDFkY2EyZDQ1YTM4YjgzODdmNTk4MTJjNDRmNjhhMmYvdm1saW51ei0zLjguMC0w
NjE2OC1nYTY1OTBiOQoKMjAxNC0wNi0xMy0wMzowNDo0MCBkZXRlY3RpbmcgYm9vdCBzdGF0
ZSAJMjAJNDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA1MTcgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbMDk4ODQ5NjQzMzVlODVlODk3ODc2
ZDE3NzgzYzJhZDMzY2Y4YTJlMF0gbW06IGRvIG5vdCBncm93IHRoZSBzdGFjayB2bWEganVz
dCBiZWNhdXNlIG9mIGFuIG92ZXJydW4gb24gcHJlY2VkaW5nIHZtYQpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3Qv
bGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1oYTMtMDYxMi9iYXNlcm9jazpiYXNlcm9jazptb3JwaDowOTg4NDk2
NDMzNWU4NWU4OTc4NzZkMTc3ODNjMmFkMzNjZjhhMmUwOmJpc2VjdC1saW51eDYKCjIwMTQt
MDYtMTMtMDM6MDU6NDEgMDk4ODQ5NjQzMzVlODVlODk3ODc2ZDE3NzgzYzJhZDMzY2Y4YTJl
MCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctaGEzLTA2MTItMDk4ODQ5NjQzMzVlODVlODk3ODc2ZDE3
NzgzYzJhZDMzY2Y4YTJlMApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWhhMy0wNjEyLzA5ODg0OTY0MzM1ZTg1ZTg5Nzg3NmQxNzc4M2MyYWQzM2NmOGEy
ZTAKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi0wOTg4NDk2NDMzNWU4NWU4OTc4NzZkMTc3ODNj
MmFkMzNjZjhhMmUwCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MTIv
MDk4ODQ5NjQzMzVlODVlODk3ODc2ZDE3NzgzYzJhZDMzY2Y4YTJlMC92bWxpbnV6LTMuOC4w
LTA2MzU2LWcwOTg4NDk2CgoyMDE0LTA2LTEzLTAzOjExOjQxIGRldGVjdGluZyBib290IHN0
YXRlIAkxNwkzNAk0MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDMyOSByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKW2FkNjBhOTMzMzAzNWYyMzIz
ODQwYjcxYWI4YWQwN2JiYWI3MjhmYWZdIE1lcmdlIGJyYW5jaCAnbWlzYycgb2YgZ2l0Oi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L21tYXJlay9rYnVpbGQK
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9j
L2Jvb3QtYmlzZWN0L2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVu
LXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctaGEzLTA2MTIvYmFzZXJvY2s6YmFzZXJvY2s6
bW9ycGg6YWQ2MGE5MzMzMDM1ZjIzMjM4NDBiNzFhYjhhZDA3YmJhYjcyOGZhZjpiaXNlY3Qt
bGludXg2CgoyMDE0LTA2LTEzLTAzOjEzOjEzIGFkNjBhOTMzMzAzNWYyMzIzODQwYjcxYWI4
YWQwN2JiYWI3MjhmYWYgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQt
dGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLWFkNjBhOTMzMzAz
NWYyMzIzODQwYjcxYWI4YWQwN2JiYWI3MjhmYWYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2Vy
bmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi9hZDYwYTkzMzMwMzVmMjMyMzg0MGI3MWFi
OGFkMDdiYmFiNzI4ZmFmCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEzLTA2MTItYWQ2MGE5MzMzMDM1ZjIz
MjM4NDBiNzFhYjhhZDA3YmJhYjcyOGZhZgp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9r
YnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi1hZDYw
YTkzMzMwMzVmMjMyMzg0MGI3MWFiOGFkMDdiYmFiNzI4ZmFmCmtlcm5lbDogL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctaGEzLTA2MTIvYWQ2MGE5MzMzMDM1ZjIzMjM4NDBiNzFhYjhhZDA3
YmJhYjcyOGZhZi92bWxpbnV6LTMuOC4wLTA2Mzg0LWdhZDYwYTkzCgoyMDE0LTA2LTEzLTAz
OjI2OjEzIGRldGVjdGluZyBib290IHN0YXRlIAk2CTEyCTI0CTM0CTM5CTQwIFNVQ0NFU1MK
CkJpc2VjdGluZzogMzAxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91
Z2hseSA5IHN0ZXBzKQpbZTNjNDg3N2RlOGI5ZDkzYmQ0N2I2ZWU4OGViNTk0YjFjMWUxMGRh
NV0gTWVyZ2UgYnJhbmNoICd4ODYtZWZpLWZvci1saW51cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RpcC90aXAKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xp
bnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2
LXJhbmRjb25maWctaGEzLTA2MTIvYmFzZXJvY2s6YmFzZXJvY2s6bW9ycGg6ZTNjNDg3N2Rl
OGI5ZDkzYmQ0N2I2ZWU4OGViNTk0YjFjMWUxMGRhNTpiaXNlY3QtbGludXg2CgoyMDE0LTA2
LTEzLTAzOjI5OjE0IGUzYzQ4NzdkZThiOWQ5M2JkNDdiNmVlODhlYjU5NGIxYzFlMTBkYTUg
Y29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLWUzYzQ4NzdkZThiOWQ5M2JkNDdiNmVlODhl
YjU5NGIxYzFlMTBkYTUKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1oYTMtMDYxMi9lM2M0ODc3ZGU4YjlkOTNiZDQ3YjZlZTg4ZWI1OTRiMWMxZTEwZGE1
CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctaGEzLTA2MTItZTNjNDg3N2RlOGI5ZDkzYmQ0N2I2ZWU4OGViNTk0
YjFjMWUxMGRhNQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvLmkzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi1lM2M0ODc3ZGU4YjlkOTNiZDQ3
YjZlZTg4ZWI1OTRiMWMxZTEwZGE1Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aGEzLTA2MTIvZTNjNDg3N2RlOGI5ZDkzYmQ0N2I2ZWU4OGViNTk0YjFjMWUxMGRhNS92bWxp
bnV6LTMuOC4wLTA2NDE5LWdlM2M0ODc3CgoyMDE0LTA2LTEzLTA0OjE1OjE0IGRldGVjdGlu
ZyBib290IHN0YXRlIAkxNAk0MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI2NiByZXZpc2lvbnMg
bGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKWzJhN2QyYjk2ZDVj
YmE3NTY4MTM5ZDlhYjE1N2EwZTk3YWIzMjQ0MGZdIE1lcmdlIGJyYW5jaCAnYWtwbScgKGZp
bmFsIGJhdGNoIGZyb20gQW5kcmV3KQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3Qt
dGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNlY3QK
bHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oYTMt
MDYxMi9iYXNlcm9jazpiYXNlcm9jazptb3JwaDoyYTdkMmI5NmQ1Y2JhNzU2ODEzOWQ5YWIx
NTdhMGU5N2FiMzI0NDBmOmJpc2VjdC1saW51eDYKCjIwMTQtMDYtMTMtMDQ6MTY6MTcgMmE3
ZDJiOTZkNWNiYTc1NjgxMzlkOWFiMTU3YTBlOTdhYjMyNDQwZiBjb21waWxpbmcKUXVldWVk
IGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25m
aWctaGEzLTA2MTItMmE3ZDJiOTZkNWNiYTc1NjgxMzlkOWFiMTU3YTBlOTdhYjMyNDQwZgpD
aGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLzJh
N2QyYjk2ZDVjYmE3NTY4MTM5ZDlhYjE1N2EwZTk3YWIzMjQ0MGYKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1o
YTMtMDYxMi0yYTdkMmI5NmQ1Y2JhNzU2ODEzOWQ5YWIxNTdhMGU5N2FiMzI0NDBmCndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4Ni1y
YW5kY29uZmlnLWhhMy0wNjEyLTJhN2QyYjk2ZDVjYmE3NTY4MTM5ZDlhYjE1N2EwZTk3YWIz
MjQ0MGYKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi8yYTdkMmI5
NmQ1Y2JhNzU2ODEzOWQ5YWIxNTdhMGU5N2FiMzI0NDBmL3ZtbGludXotMy44LjAtMDY1ODMt
ZzJhN2QyYjkKCjIwMTQtMDYtMTMtMDQ6Mjk6MTcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTEg
VEVTVCBGQUlMVVJFClsgICAgMy40MTE4MjRdIGluaXQ6IEZhaWxlZCB0byBjcmVhdGUgcHR5
IC0gZGlzYWJsaW5nIGxvZ2dpbmcgZm9yIGpvYgpbICAgIDMuNDEyNzQ2XSBpbml0OiBUZW1w
b3JhcnkgcHJvY2VzcyBzcGF3biBlcnJvcjogTm8gc3BhY2UgbGVmdCBvbiBkZXZpY2UKWyAg
ICAzLjQ0MDY1N10gaW5pdDogbW91bnRlZC10bXAgbWFpbiBwcm9jZXNzICgxNDcpIHRlcm1p
bmF0ZWQgd2l0aCBzdGF0dXMgMzIKWyAgIDEzLjQ3Njk5OF0gQlVHOiB1bmFibGUgdG8gaGFu
ZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCBiYmVkM2E3OApbICAgMTMuNDc4MTg2XSBJ
UDogWzxjMDI4MjVkYT5dIHN0YXRpY19rZXlfc2xvd19pbmMrMHg0LzB4NDcKWyAgIDEzLjQ3
OTE2OV0gKnBkcHQgPSAwMDAwMDAwMDA4NTFkMDAxICpwZGUgPSAwMDAwMDAwMDAwMDAwMDAw
IApbICAgMTMuNDgwMDA2XSBPb3BzOiAwMDAwIFsjMV0gUFJFRU1QVCBTTVAgREVCVUdfUEFH
RUFMTE9DClsgICAxMy40ODAwMDZdIFBpZDogMTcyLCBjb21tOiB0cmluaXR5LW1haW4gTm90
IHRhaW50ZWQgMy44LjAtMDY1ODMtZzJhN2QyYjkgIzM0IEJvY2hzIEJvY2hzClsgICAxMy40
ODAwMDZdIEVJUDogMDA2MDpbPGMwMjgyNWRhPl0gRUZMQUdTOiAwMDAxMDIwNiBDUFU6IDAK
WyAgIDEzLjQ4MDAwNl0gRUlQIGlzIGF0IHN0YXRpY19rZXlfc2xvd19pbmMrMHg0LzB4NDcK
WyAgIDEzLjQ4MDAwNl0gRUFYOiBiYmVkM2E3OCBFQlg6IGM3ZDI0YzAwIEVDWDogMDAwMDAw
MTggRURYOiAwMDAwMDAwOApbICAgMTMuNDgwMDA2XSBFU0k6IDAwMDAwMDA4IEVESTogZmY1
NzgxYWQgRUJQOiBjODVmYmViNCBFU1A6IGM4NWZiZWIwClsgICAxMy40ODAwMDZdICBEUzog
MDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDAzMyBTUzogMDA2OApbICAgMTMuNDgwMDA2
XSBDUjA6IDgwMDUwMDNiIENSMjogYmJlZDNhNzggQ1IzOiAwODU3ZjAwMCBDUjQ6IDAwMDAw
NjMwClsgICAxMy40ODAwMDZdIERSMDogMDlmYzUwMDAgRFIxOiAwMDAwMDAwMCBEUjI6IDAw
MDAwMDAwIERSMzogMDAwMDAwMDAKWyAgIDEzLjQ4MDAwNl0gRFI2OiBmZmZmMGZmMCBEUjc6
IDAwMDMwNjAyClsgICAxMy40ODAwMDZdIFByb2Nlc3MgdHJpbml0eS1tYWluIChwaWQ6IDE3
MiwgdGk9Yzg1ZmEwMDAgdGFzaz1jODQ5YzQyMCB0YXNrLnRpPWM4NWZhMDAwKQpbICAgMTMu
NDgwMDA2XSBTdGFjazoKWyAgIDEzLjQ4MDAwNl0gIGM3ZDI0YzAwIGM4NWZiZWNjIGMwMjdi
NmI1IDAwMDAwMDAwIGMwY2JiNzMwIGM3ZDI0YzAwIDAwMDAwMDAwIGM4NWZiZWU4ClsgICAx
My40ODAwMDZdICBjMDI3ZjQwNiAwMDAwMDAwMCBjMGNiYjczMCAwMDAwMDAwMCBjN2QyNGQ0
OCBjN2QyNGMwMCBjODVmYmYwNCBjMDI3ZjZhYwpbICAgMTMuNDgwMDA2XSAgYzg1ZmJmNDAg
YzdkMjRjMDAgMDAwMDAwMDAgYzg0OWM0MjAgMDAwMDAwMDAgYzg1ZmJmYWMgYzAyN2ZkMTEg
YzdkMjRjMDAKWyAgIDEzLjQ4MDAwNl0gQ2FsbCBUcmFjZToKWyAgIDEzLjQ4MDAwNl0gIFs8
YzAyN2I2YjU+XSBwZXJmX3N3ZXZlbnRfaW5pdCsweGI4LzB4ZGQKWyAgIDEzLjQ4MDAwNl0g
IFs8YzAyN2Y0MDY+XSBwZXJmX2luaXRfZXZlbnQrMHhjZS8weDEyNApbICAgMTMuNDgwMDA2
XSAgWzxjMDI3ZjZhYz5dIHBlcmZfZXZlbnRfYWxsb2MrMHgyNTAvMHgzNjAKWyAgIDEzLjQ4
MDAwNl0gIFs8YzAyN2ZkMTE+XSBzeXNfcGVyZl9ldmVudF9vcGVuKzB4MzM2LzB4NjY0Clsg
ICAxMy40ODAwMDZdICBbPGMwOTQ1NDBhPl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4M2MK
WyAgIDEzLjQ4MDAwNl0gQ29kZTogMzEgZDIgODkgZDggZTggMzggZmYgZmYgZmYgZTggODUg
ZmYgZmYgZmYgODMgYzQgMGMgNWIgNWUgNWYgNWQgYzMgNTUgODMgZTggMGMgODkgZTUgMzEg
YzkgMzEgZDIgZTggN2QgZmYgZmYgZmYgNWQgYzMgNTUgODkgZTUgNTMgPDhiPiAxMCA4OSBj
MyA4NSBkMiA3NCAxMSA4ZCA0YSAwMSA4OSBkMCBmMCAwZiBiMSAwYiAzOSBkMCA3NCAyYgpb
ICAgMTMuNDgwMDA2XSBFSVA6IFs8YzAyODI1ZGE+XSBzdGF0aWNfa2V5X3Nsb3dfaW5jKzB4
NC8weDQ3IFNTOkVTUCAwMDY4OmM4NWZiZWIwClsgICAxMy40ODAwMDZdIENSMjogMDAwMDAw
MDBiYmVkM2E3OApbICAgMTMuNTE3NzAzXSAtLS1bIGVuZCB0cmFjZSA2Yjk1YzZkMWYzZmM4
YmQ1IF0tLS0KWyAgIDEzLjUxODQ4Ml0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZh
dGFsIGV4Y2VwdGlvbgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi8yYTdkMmI5
NmQ1Y2JhNzU2ODEzOWQ5YWIxNTdhMGU5N2FiMzI0NDBmL2RtZXNnLXlvY3RvLWl2YjQxLTg0
OjIwMTQwNjEzMDQyOTM1OmkzODYtcmFuZGNvbmZpZy1oYTMtMDYxMjozLjguMC0wNjU4My1n
MmE3ZDJiOTozNAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi8yYTdkMmI5NmQ1
Y2JhNzU2ODEzOWQ5YWIxNTdhMGU5N2FiMzI0NDBmL2RtZXNnLXlvY3RvLWl2YjQyLTc1OjIw
MTQwNjEzMDQyOTM2OmkzODYtcmFuZGNvbmZpZy1oYTMtMDYxMjozLjguMC0wNjU4My1nMmE3
ZDJiOTozNAowOjI6MyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKbGluZWFyLWJpc2Vj
dDogYmFkIGJyYW5jaCBtYXkgYmUgYnJhbmNoICdha3BtJyAoZmluYWwgYmF0Y2ggZnJvbSBB
bmRyZXcpCmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFy
LWJpc2VjdDogZ2l0IGJpc2VjdCBzdGFydCAyYTdkMmI5NmQ1Y2JhNzU2ODEzOWQ5YWIxNTdh
MGU5N2FiMzI0NDBmIGUzYzQ4NzdkZThiOWQ5M2JkNDdiNmVlODhlYjU5NGIxYzFlMTBkYTUg
LS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMmE3ZDJiOS4uLiBNZXJnZSBicmFuY2gg
J2FrcG0nIChmaW5hbCBiYXRjaCBmcm9tIEFuZHJldykKSEVBRCBpcyBub3cgYXQgMWVhNTJh
OS4uLiBNZXJnZSAnamJhcm5lcy9hc3luYy1mYi1wcm9iZScgaW50byBkZXZlbC1ob3VybHkt
MjAxNDA2MDIxMApCaXNlY3Rpbmc6IDgxIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSA2IHN0ZXBzKQpbNmZhNzgwMDk1ZjA1OGYwOTYwZjIyMDc1NDIxNzcw
MWE1M2E5ZTQwM10gSUIvY3hnYjM6IGNvbnZlcnQgdG8gaWRyX2FsbG9jKCkKbGluZWFyLWJp
c2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdApydW5uaW5nIC9j
L2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNl
Y3QvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi9iYXNlcm9jazpiYXNlcm9jazptb3JwaDo2ZmE3
ODAwOTVmMDU4ZjA5NjBmMjIwNzU0MjE3NzAxYTUzYTllNDAzOmJpc2VjdC1saW51eDYKCjIw
MTQtMDYtMTMtMDQ6MzI6MzMgNmZhNzgwMDk1ZjA1OGYwOTYwZjIyMDc1NDIxNzcwMWE1M2E5
ZTQwMyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWls
ZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEzLTA2MTItNmZhNzgwMDk1ZjA1OGYwOTYwZjIy
MDc1NDIxNzcwMWE1M2E5ZTQwMwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLWhhMy0wNjEyLzZmYTc4MDA5NWYwNThmMDk2MGYyMjA3NTQyMTc3MDFhNTNh
OWU0MDMKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi02ZmE3ODAwOTVmMDU4ZjA5NjBmMjIwNzU0
MjE3NzAxYTUzYTllNDAzCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLTZmYTc4MDA5NWYwNThm
MDk2MGYyMjA3NTQyMTc3MDFhNTNhOWU0MDMKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1oYTMtMDYxMi82ZmE3ODAwOTVmMDU4ZjA5NjBmMjIwNzU0MjE3NzAxYTUzYTllNDAz
L3ZtbGludXotMy44LjAtMDY0MzktZzZmYTc4MDAKCjIwMTQtMDYtMTMtMDQ6NDM6MzMgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgCTEzCTI1CTM4CTM5Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTQwIFNVQ0NFU1MKCkJp
c2VjdGluZzogNDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDUgc3RlcHMpClswNTBhNmI0N2Q5OGUyYmNlYTkwOWMxMTI5MTExZTcyMTY2OGFhYTJjXSBp
ZHI6IG1ha2UgaWRyX2xheWVyIGxhcmdlcgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNl
Y3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNl
Y3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1o
YTMtMDYxMi9iYXNlcm9jazpiYXNlcm9jazptb3JwaDowNTBhNmI0N2Q5OGUyYmNlYTkwOWMx
MTI5MTExZTcyMTY2OGFhYTJjOmJpc2VjdC1saW51eDYKCjIwMTQtMDYtMTMtMDU6NDQ6Mzgg
MDUwYTZiNDdkOThlMmJjZWE5MDljMTEyOTExMWU3MjE2NjhhYWEyYyBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctaGEzLTA2MTItMDUwYTZiNDdkOThlMmJjZWE5MDljMTEyOTExMWU3MjE2NjhhYWEy
YwpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEy
LzA1MGE2YjQ3ZDk4ZTJiY2VhOTA5YzExMjkxMTFlNzIxNjY4YWFhMmMKd2FpdGluZyBmb3Ig
Y29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZp
Zy1oYTMtMDYxMi0wNTBhNmI0N2Q5OGUyYmNlYTkwOWMxMTI5MTExZTcyMTY2OGFhYTJjCndh
aXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS8uaTM4
Ni1yYW5kY29uZmlnLWhhMy0wNjEyLTA1MGE2YjQ3ZDk4ZTJiY2VhOTA5YzExMjkxMTFlNzIx
NjY4YWFhMmMKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi8wNTBh
NmI0N2Q5OGUyYmNlYTkwOWMxMTI5MTExZTcyMTY2OGFhYTJjL3ZtbGludXotMy44LjAtMDY0
ODAtZzA1MGE2YjQKCjIwMTQtMDYtMTMtMDY6MDM6MzkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
CTEJMTUJMzIJMzkJNDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAyMCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNCBzdGVwcykKWzQ1OWE4NmQ4M2RjZTY2NDFm
NjYzMTFkMzdmYmZlMTQxOWM0NzdhNWFdIG10ZDogbXRkX25hbmRlY2N0ZXN0OiB1c2UgcHJh
bmRvbV9ieXRlcyBpbnN0ZWFkIG9mIGdldF9yYW5kb21fYnl0ZXMoKQpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3Qv
bGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1oYTMtMDYxMi9iYXNlcm9jazpiYXNlcm9jazptb3JwaDo0NTlhODZk
ODNkY2U2NjQxZjY2MzExZDM3ZmJmZTE0MTljNDc3YTVhOmJpc2VjdC1saW51eDYKCjIwMTQt
MDYtMTMtMDY6MDY6MDkgNDU5YTg2ZDgzZGNlNjY0MWY2NjMxMWQzN2ZiZmUxNDE5YzQ3N2E1
YSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctaGEzLTA2MTItNDU5YTg2ZDgzZGNlNjY0MWY2NjMxMWQz
N2ZiZmUxNDE5YzQ3N2E1YQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWhhMy0wNjEyLzQ1OWE4NmQ4M2RjZTY2NDFmNjYzMTFkMzdmYmZlMTQxOWM0Nzdh
NWEKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi00NTlhODZkODNkY2U2NjQxZjY2MzExZDM3ZmJm
ZTE0MTljNDc3YTVhCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLTQ1OWE4NmQ4M2RjZTY2NDFm
NjYzMTFkMzdmYmZlMTQxOWM0NzdhNWEKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1oYTMtMDYxMi80NTlhODZkODNkY2U2NjQxZjY2MzExZDM3ZmJmZTE0MTljNDc3YTVhL3Zt
bGludXotMy44LjAtMDY1MDAtZzQ1OWE4NmQKCjIwMTQtMDYtMTMtMDY6Mjg6MTAgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgCTE5IFRFU1QgRkFJTFVSRQpbICAgIDQuNjc3OTI5XSBpbml0OiBG
YWlsZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBqb2IKWyAgICA0
LjY3OTI4Nl0gaW5pdDogVGVtcG9yYXJ5IHByb2Nlc3Mgc3Bhd24gZXJyb3I6IE5vIHNwYWNl
IGxlZnQgb24gZGV2aWNlClsgICAgNC43MjMyMjRdIGluaXQ6IG1vdW50ZWQtdG1wIG1haW4g
cHJvY2VzcyAoMTQ3KSB0ZXJtaW5hdGVkIHdpdGggc3RhdHVzIDMyClsgICAxNC43OTk1NDBd
IEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgMzc5NGIx
NjgKWyAgIDE0LjgwMDAxMV0gSVA6IFs8YzAyODJjZDc+XSBzdGF0aWNfa2V5X3Nsb3dfaW5j
KzB4NC8weDQ3ClsgICAxNC44MDAwMTFdICpwZHB0ID0gMDAwMDAwMDAwYzMzNjAwMSAqcGRl
ID0gMDAwMDAwMDAwMDAwMDAwMCAKWyAgIDE0LjgwMDAxMV0gT29wczogMDAwMCBbIzFdIFBS
RUVNUFQgU01QIERFQlVHX1BBR0VBTExPQwpbICAgMTQuODAwMDExXSBQaWQ6IDE3MiwgY29t
bTogdHJpbml0eS1tYWluIFRhaW50ZWQ6IEcgICAgICAgIFcgICAgMy44LjAtMDY1MDAtZzQ1
OWE4NmQgIzYxIEJvY2hzIEJvY2hzClsgICAxNC44MDAwMTFdIEVJUDogMDA2MDpbPGMwMjgy
Y2Q3Pl0gRUZMQUdTOiAwMDAxMDIwNiBDUFU6IDEKWyAgIDE0LjgwMDAxMV0gRUlQIGlzIGF0
IHN0YXRpY19rZXlfc2xvd19pbmMrMHg0LzB4NDcKWyAgIDE0LjgwMDAxMV0gRUFYOiAzNzk0
YjE2OCBFQlg6IGM3ZDI5YzAwIEVDWDogMDAwMDAwMTggRURYOiAwMDAwMDAwOApbICAgMTQu
ODAwMDExXSBFU0k6IDAwMDAwMDA4IEVESTogYWVjYzc0OGIgRUJQOiBjZmQ2ZGViNCBFU1A6
IGNmZDZkZWIwClsgICAxNC44MDAwMTFdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBH
UzogMDAzMyBTUzogMDA2OApbICAgMTQuODAwMDExXSBDUjA6IDgwMDUwMDNiIENSMjogMzc5
NGIxNjggQ1IzOiAwYzMzYTAwMCBDUjQ6IDAwMDAwNjMwClsgICAxNC44MDAwMTFdIERSMDog
MDAwMDAwMDAgRFIxOiAwMDAwMDAwMCBEUjI6IDAwMDAwMDAwIERSMzogMDAwMDAwMDAKWyAg
IDE0LjgwMDAxMV0gRFI2OiBmZmZmMGZmMCBEUjc6IDAwMDAwNDAwClsgICAxNC44MDAwMTFd
IFByb2Nlc3MgdHJpbml0eS1tYWluIChwaWQ6IDE3MiwgdGk9Y2ZkNmMwMDAgdGFzaz1jODU5
YTQyMCB0YXNrLnRpPWNmZDZjMDAwKQpbICAgMTQuODAwMDExXSBTdGFjazoKWyAgIDE0Ljgw
MDAxMV0gIGM3ZDI5YzAwIGNmZDZkZWNjIGMwMjdiZjY5IDAwMDAwMDAwIGMwY2I5NzMwIGM3
ZDI5YzAwIDAwMDAwMDAwIGNmZDZkZWU4ClsgICAxNC44MDAwMTFdICBjMDI3ZmIwMyAwMDAw
MDAwMCBjMGNiOTczMCAwMDAwMDAwMCBjN2QyOWQ0OCBjN2QyOWMwMCBjZmQ2ZGYwNCBjMDI3
ZmRhOQpbICAgMTQuODAwMDExXSAgY2ZkNmRmNDAgYzdkMjljMDAgMDAwMDAwMDAgYzg1OWE0
MjAgMDAwMDAwMDAgY2ZkNmRmYWMgYzAyODA0MGUgYzdkMjljMDAKWyAgIDE0LjgwMDAxMV0g
Q2FsbCBUcmFjZToKWyAgIDE0LjgwMDAxMV0gIFs8YzAyN2JmNjk+XSBwZXJmX3N3ZXZlbnRf
aW5pdCsweGI4LzB4ZGQKWyAgIDE0LjgwMDAxMV0gIFs8YzAyN2ZiMDM+XSBwZXJmX2luaXRf
ZXZlbnQrMHhjZS8weDEyNApbICAgMTQuODAwMDExXSAgWzxjMDI3ZmRhOT5dIHBlcmZfZXZl
bnRfYWxsb2MrMHgyNTAvMHgzNjAKWyAgIDE0LjgwMDAxMV0gIFs8YzAyODA0MGU+XSBzeXNf
cGVyZl9ldmVudF9vcGVuKzB4MzM2LzB4NjY0ClsgICAxNC44MDAwMTFdICBbPGMwOTQ0YTBh
Pl0gc3lzZW50ZXJfZG9fY2FsbCsweDEyLzB4M2MKWyAgIDE0LjgwMDAxMV0gQ29kZTogMzEg
ZDIgODkgZDggZTggMzggZmYgZmYgZmYgZTggODUgZmYgZmYgZmYgODMgYzQgMGMgNWIgNWUg
NWYgNWQgYzMgNTUgODMgZTggMGMgODkgZTUgMzEgYzkgMzEgZDIgZTggN2QgZmYgZmYgZmYg
NWQgYzMgNTUgODkgZTUgNTMgPDhiPiAxMCA4OSBjMyA4NSBkMiA3NCAxMSA4ZCA0YSAwMSA4
OSBkMCBmMCAwZiBiMSAwYiAzOSBkMCA3NCAyYgpbICAgMTQuODAwMDExXSBFSVA6IFs8YzAy
ODJjZDc+XSBzdGF0aWNfa2V5X3Nsb3dfaW5jKzB4NC8weDQ3IFNTOkVTUCAwMDY4OmNmZDZk
ZWIwClsgICAxNC44MDAwMTFdIENSMjogMDAwMDAwMDAzNzk0YjE2OApbICAgMTQuODUzMjE5
XSAtLS1bIGVuZCB0cmFjZSAwZjU1MDRmODE5ZmM0Y2M3IF0tLS0KWyAgIDE0Ljg1NDI2NV0g
S2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1oYTMtMDYxMi80NTlhODZkODNkY2U2NjQxZjY2MzExZDM3ZmJmZTE0
MTljNDc3YTVhL2RtZXNnLXlvY3RvLWl2YjQxLTQxOjIwMTQwNjEzMDYyODA1OmkzODYtcmFu
ZGNvbmZpZy1oYTMtMDYxMjozLjguMC0wNjUwMC1nNDU5YTg2ZDo2MQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1oYTMtMDYxMi80NTlhODZkODNkY2U2NjQxZjY2MzExZDM3ZmJmZTE0MTlj
NDc3YTVhL2RtZXNnLXlvY3RvLWl2YjQyLTk1OjIwMTQwNjEzMDYyODE3OmkzODYtcmFuZGNv
bmZpZy1oYTMtMDYxMjozLjguMC0wNjUwMC1nNDU5YTg2ZDo2MQowOjI6MjEgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDYtMTMgMDY6Mjg6NDAgUkVQRUFUIENP
VU5UOiAxMTUgICMgL2MvYm9vdC1iaXNlY3QvbGludXg2L29iai1iaXNlY3QvLnJlcGVhdBtb
MG0KCkJpc2VjdGluZzogOSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMyBzdGVwcykKWzA2MDA0ZTZlZWJkYWYxMDFhMGY5YjUzM2ZhYzc3YjU3NjhkMmMw
OWNdIGJsb2NrL3BhcnRpdGlvbnMvbWFjLmM6IG9iZXkgdGhlIHN0YXRlLT5saW1pdCBjb25z
dHJhaW50CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVy
ZS5zaCAvYy9ib290LWJpc2VjdC9saW51eDYvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyL2Jhc2Vyb2NrOmJh
c2Vyb2NrOm1vcnBoOjA2MDA0ZTZlZWJkYWYxMDFhMGY5YjUzM2ZhYzc3YjU3NjhkMmMwOWM6
YmlzZWN0LWxpbnV4NgoKMjAxNC0wNi0xMy0wNjoyODo0MSAwNjAwNGU2ZWViZGFmMTAxYTBm
OWI1MzNmYWM3N2I1NzY4ZDJjMDljIGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAv
a2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi0wNjAw
NGU2ZWViZGFmMTAxYTBmOWI1MzNmYWM3N2I1NzY4ZDJjMDljCkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MTIvMDYwMDRlNmVlYmRhZjEwMWEw
ZjliNTMzZmFjNzdiNTc2OGQyYzA5Ywp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVp
bGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLTA2MDA0ZTZl
ZWJkYWYxMDFhMGY5YjUzM2ZhYzc3YjU3NjhkMmMwOWMKd2FpdGluZyBmb3IgY29tcGxldGlv
biBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlLy5pMzg2LXJhbmRjb25maWctaGEzLTA2
MTItMDYwMDRlNmVlYmRhZjEwMWEwZjliNTMzZmFjNzdiNTc2OGQyYzA5YwprZXJuZWw6IC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLzA2MDA0ZTZlZWJkYWYxMDFhMGY5YjUz
M2ZhYzc3YjU3NjhkMmMwOWMvdm1saW51ei0zLjguMC0wNjQ5MC1nMDYwMDRlNgoKMjAxNC0w
Ni0xMy0wNjozOTo0MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAuCTUgVEVTVCBGQUlMVVJFClsg
ICAgMC4xNjQzMzddIHNtcGJvb3Q6IFRvdGFsIG9mIDIgcHJvY2Vzc29ycyBhY3RpdmF0ZWQg
KDEwNzc4Ljg0IEJvZ29NSVBTKQpbICAgIDAuMTYzNDUxXSBLVk0gc2V0dXAgYXN5bmMgUEYg
Zm9yIGNwdSAxClsgICAgMC4xNjM0NTFdIGt2bS1zdGVhbHRpbWU6IGNwdSAxLCBtc3IgMTI3
NTA1MDAKWyAgIDI4LjEwOTk5OV0gQlVHOiBzb2Z0IGxvY2t1cCAtIENQVSMwIHN0dWNrIGZv
ciAyM3MhIFttaWdyYXRpb24vMDo4XQpbICAgMjguMTA5OTk5XSBpcnEgZXZlbnQgc3RhbXA6
IDY3MTE2ClsgICAyOC4xMDk5OTldIGhhcmRpcnFzIGxhc3QgIGVuYWJsZWQgYXQgKDY3MTE1
KTogWzxjMDk0NDJmOT5dIHJlc3RvcmVfYWxsX25vdHJhY2UrMHgwLzB4MTgKWyAgIDI4LjEw
OTk5OV0gaGFyZGlycXMgbGFzdCBkaXNhYmxlZCBhdCAoNjcxMTYpOiBbPGMwOTQ0NWNiPl0g
YXBpY190aW1lcl9pbnRlcnJ1cHQrMHgyYi8weDM4ClsgICAyOC4xMDk5OTldIHNvZnRpcnFz
IGxhc3QgIGVuYWJsZWQgYXQgKDY3MTE0KTogWzxjMDIzMDNlMj5dIF9fZG9fc29mdGlycSsw
eDEzNC8weDE0ZgpbICAgMjguMTA5OTk5XSBzb2Z0aXJxcyBsYXN0IGRpc2FibGVkIGF0ICg2
NzEwOSk6IFs8YzAyMDM4OWI+XSBkb19zb2Z0aXJxKzB4NjAvMHhiOApbICAgMjguMTA5OTk5
XSBQaWQ6IDgsIGNvbW06IG1pZ3JhdGlvbi8wIE5vdCB0YWludGVkIDMuOC4wLTA2NDkwLWcw
NjAwNGU2ICM2NSBCb2NocyBCb2NocwpbICAgMjguMTA5OTk5XSBFSVA6IDAwNjA6WzxjMDI2
ZTc2MT5dIEVGTEFHUzogMDAwMDAyOTMgQ1BVOiAwClsgICAyOC4xMDk5OTldIEVJUCBpcyBh
dCBzdG9wX21hY2hpbmVfY3B1X3N0b3ArMHg1My8weGNlClsgICAyOC4xMDk5OTldIEVBWDog
MDAwMDAwMDEgRUJYOiAwMDAwMDAwMSBFQ1g6IGQyMGViZWVjIEVEWDogMDAwMDAwMDAKWyAg
IDI4LjEwOTk5OV0gRVNJOiBkMjBlYmVlYyBFREk6IDAwMDAwMDAwIEVCUDogZDIxNDNlNWMg
RVNQOiBkMjE0M2U0OApbICAgMjguMTA5OTk5XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAw
ZDggR1M6IDAwMDAgU1M6IDAwNjgKWyAgIDI4LjEwOTk5OV0gQ1IwOiA4MDA1MDAzYiBDUjI6
IGZmZmZmZmZmIENSMzogMDBlMGQwMDAgQ1I0OiAwMDAwMDZiMApbICAgMjguMTA5OTk5XSBE
UjA6IDAwMDAwMDAwIERSMTogMDAwMDAwMDAgRFIyOiAwMDAwMDAwMCBEUjM6IDAwMDAwMDAw
ClsgICAyOC4xMDk5OTldIERSNjogZmZmZjBmZjAgRFI3OiAwMDAwMDQwMApbICAgMjguMTA5
OTk5XSBQcm9jZXNzIG1pZ3JhdGlvbi8wIChwaWQ6IDgsIHRpPWQyMTQyMDAwIHRhc2s9ZDIx
NDAzYTAgdGFzay50aT1kMjE0MjAwMCkKWyAgIDI4LjEwOTk5OV0gU3RhY2s6ClsgICAyOC4x
MDk5OTldICAwMTE0M2U1MCAwMDAwMDI5NiBkMjc0NmEyNCBkMjBlYmU4OCBjMDI2ZTcwZSBk
MjE0M2YwYyBjMDI2ZTVjYiAwMDAwMDAwMApbICAgMjguMTA5OTk5XSAgMDAwMDAwNzEgYzEw
NGNhYzggMDAwMDAwMDEgZDIxNDAzYTAgZDI3NDZhNDggZDIwZWJlZWMgZDIxNDNmMDQgYzA5
NDJiNTAKWyAgIDI4LjEwOTk5OV0gIGMwY2JhNDRjIDAwMDAwMDAwIGQyMTQzZjE0IGMwZTA1
MGMwIDA5YmRmNmU0IGQyMTQwM2EwIDAwMDAwMDQ2IDAwMDAwMDQ2ClsgICAyOC4xMDk5OTld
IENhbGwgVHJhY2U6ClsgICAyOC4xMDk5OTldICBbPGMwMjZlNzBlPl0gPyBxdWV1ZV9zdG9w
X2NwdXNfd29yaysweGEwLzB4YTAKWyAgIDI4LjEwOTk5OV0gIFs8YzAyNmU1Y2I+XSBjcHVf
c3RvcHBlcl90aHJlYWQrMHg3My8weDExNgpbICAgMjguMTA5OTk5XSAgWzxjMDk0MmI1MD5d
ID8gX19zY2hlZHVsZSsweDVmMS8weDY1NwpbICAgMjguMTA5OTk5XSAgWzxjMDI2MTRkMT5d
ID8gbG9ja19hY3F1aXJlKzB4ODIvMHg4YQpbICAgMjguMTA5OTk5XSAgWzxjMDk0Mzk4MT5d
ID8gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKzB4MzgvMHg2MgpbICAgMjguMTA5OTk5
XSAgWzxjMDI1ZmI4Nj5dID8gdHJhY2VfaGFyZGlycXNfb25fY2FsbGVyKzB4MTI5LzB4MTQx
ClsgICAyOC4xMDk5OTldICBbPGMwOTQzOTllPl0gPyBfcmF3X3NwaW5fdW5sb2NrX2lycXJl
c3RvcmUrMHg1NS8weDYyClsgICAyOC4xMDk5OTldICBbPGMwMjQ3MDM1Pl0gc21wYm9vdF90
aHJlYWRfZm4rMHgxOWIvMHgxYjEKWyAgIDI4LjEwOTk5OV0gIFs8YzAyNDZlOWE+XSA/IF9f
c21wYm9vdF9jcmVhdGVfdGhyZWFkLnBhcnQuNCsweDgyLzB4ODIKWyAgIDI4LjEwOTk5OV0g
IFs8YzAyNDA0Yzk+XSBrdGhyZWFkKzB4NmUvMHg3MwpbICAgMjguMTA5OTk5XSAgWzxjMDI0
MDAwMD5dID8gc3lzX3RpbWVyX3NldHRpbWUrMHhiZS8weDEwOApbICAgMjguMTA5OTk5XSAg
WzxjMDk0NDliNz5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDI4ClsgICAyOC4x
MDk5OTldICBbPGMwMjQwNDViPl0gPyBfX2t0aHJlYWRfcGFya21lKzB4NTQvMHg1NApbICAg
MjguMTA5OTk5XSBDb2RlOiAwMCAwMCAwMCBlOCBiYiBiNSAyYiAwMCAzOSBjMyAwZiA5NCA0
NSBlZiBlYiAxNSA4MyBmYiAwNyA3NiAwNSBlOCAwNCA1NiA2YyAwMCAwZiBhMyAxZiAxOSBk
YiA4NSBkYiAwZiA5NSA0NSBlZiAzMSBmZiAzMSBjMCBmMyA5MCA8OGI+IDVlIDEwIDM5IGMz
IDc0IDQxIDgzIGZiIDAyIDc0IDA3IDgzIGZiIDAzIDc0IDBlIGViIDE5IGU4IDNkCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLzA2MDA0ZTZlZWJkYWYxMDFhMGY5YjUzM2Zh
Yzc3YjU3NjhkMmMwOWMvZG1lc2cteW9jdG8taXZiNDQtMzU6MjAxNDA2MTMwNjQwMDU6aTM4
Ni1yYW5kY29uZmlnLWhhMy0wNjEyOjMuOC4wLTA2NDkwLWcwNjAwNGU2OjY1CjA6MTo2IGFs
bF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDQgcmV2aXNpb25zIGxlZnQg
dG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpCltkOTQxYWVhZTQyOTQyYzJl
ZjYxZWQ1ZTA1Y2MxYWQwNDI4MDg1NzA0XSBpcG1pOiBhZGQgbmV3IGtlcm5lbCBvcHRpb25z
IHRvIHByZXZlbnQgYXV0b21hdGljIGlwbWkgaW5pdApydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg2L29i
ai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1oYTMtMDYxMi9iYXNlcm9jazpiYXNlcm9jazptb3JwaDpkOTQxYWVhZTQyOTQyYzJl
ZjYxZWQ1ZTA1Y2MxYWQwNDI4MDg1NzA0OmJpc2VjdC1saW51eDYKCjIwMTQtMDYtMTMtMDY6
NDA6NDIgZDk0MWFlYWU0Mjk0MmMyZWY2MWVkNWUwNWNjMWFkMDQyODA4NTcwNCBjb21waWxp
bmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2
LXJhbmRjb25maWctaGEzLTA2MTItZDk0MWFlYWU0Mjk0MmMyZWY2MWVkNWUwNWNjMWFkMDQy
ODA4NTcwNApDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhh
My0wNjEyL2Q5NDFhZWFlNDI5NDJjMmVmNjFlZDVlMDVjYzFhZDA0MjgwODU3MDQKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFu
ZGNvbmZpZy1oYTMtMDYxMi1kOTQxYWVhZTQyOTQyYzJlZjYxZWQ1ZTA1Y2MxYWQwNDI4MDg1
NzA0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1
ZS8uaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLWQ5NDFhZWFlNDI5NDJjMmVmNjFlZDVlMDVj
YzFhZDA0MjgwODU3MDQKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYx
Mi9kOTQxYWVhZTQyOTQyYzJlZjYxZWQ1ZTA1Y2MxYWQwNDI4MDg1NzA0L3ZtbGludXotMy44
LjAtMDY0ODUtZ2Q5NDFhZWEKCjIwMTQtMDYtMTMtMDY6NDg6NDIgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLi4uLi4uLi4gVEVTVCBGQUlMVVJFCktlcm5lbCB0ZXN0czogQm9vdCBPSyEKWyAg
IDE3LjkzOTE5OF0gc29jazogcHJvY2VzcyBgdHJpbml0eS1tYWluJyBpcyB1c2luZyBvYnNv
bGV0ZSBzZXRzb2Nrb3B0IFNPX0JTRENPTVBBVApbICAgMTguMTc2NDEwXSAtLS0tLS0tLS0t
LS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAgIDE4LjE3NjQ0NV0gV0FSTklORzogYXQg
L2tidWlsZC9zcmMvaTM4Ni9saWIvaWRyLmM6Njc4IGlkcl9maW5kX3Nsb3dwYXRoKzB4Mjgv
MHhjYSgpClsgICAxOC4xNzY0NDddIEhhcmR3YXJlIG5hbWU6IEJvY2hzClsgICAxOC4xNzY0
NTBdIFBpZDogNTg0LCBjb21tOiB0cmluaXR5LW1haW4gTm90IHRhaW50ZWQgMy44LjAtMDY0
ODUtZ2Q5NDFhZWEgIzY3ClsgICAxOC4xNzY0NTFdIENhbGwgVHJhY2U6ClsgICAxOC4xNzY0
NjhdICBbPGMwMjJhY2U2Pl0gd2Fybl9zbG93cGF0aF9jb21tb24rMHg3Mi8weDg5ClsgICAx
OC4xNzY0NzJdICBbPGMwNTFmMDAxPl0gPyBpZHJfZmluZF9zbG93cGF0aCsweDI4LzB4Y2EK
WyAgIDE4LjE3NjQ3NF0gIFs8YzA1MWYwMDE+XSA/IGlkcl9maW5kX3Nsb3dwYXRoKzB4Mjgv
MHhjYQpbICAgMTguMTc2NDc3XSAgWzxjMDIyYWQ5Yj5dIHdhcm5fc2xvd3BhdGhfbnVsbCsw
eDFkLzB4MWYKWyAgIDE4LjE3NjQ3OV0gIFs8YzA1MWYwMDE+XSBpZHJfZmluZF9zbG93cGF0
aCsweDI4LzB4Y2EKWyAgIDE4LjE3NjQ5MF0gIFs8YzAyN2ZhYjc+XSBwZXJmX2luaXRfZXZl
bnQrMHg4Mi8weDEyNApbICAgMTguMTc2NDk5XSAgWzxjMDI0MzIxZj5dID8gX19tdXRleF9p
bml0KzB4M2YvMHg0NApbICAgMTguMTc2NTAyXSAgWzxjMDI3ZmRhOT5dIHBlcmZfZXZlbnRf
YWxsb2MrMHgyNTAvMHgzNjAKWyAgIDE4LjE3NjUwNF0gIFs8YzAyODA0MGU+XSBzeXNfcGVy
Zl9ldmVudF9vcGVuKzB4MzM2LzB4NjY0ClsgICAxOC4xNzY1MjldICBbPGMwOTQ0MmEwPl0g
c3lzY2FsbF9jYWxsKzB4Ny8weGIKWyAgIDE4LjE3NjUzN10gIFs8YzA5NDAwMDA+XSA/IFNl
dEFnY0lmLmlzcmEuNisweDEzMi8weDI5MApbICAgMTguMTc2NTM5XSAtLS1bIGVuZCB0cmFj
ZSAxZDJiMjYxZThmNmQwZjY4IF0tLS0KWyAgIDE4LjQxNzc0Nl0gQlVHOiB1bmFibGUgdG8g
aGFuZGxlIGtlcm5lbCBwYWdpbmcgcmVxdWVzdCBhdCAxMjcyNGU1MAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1oYTMtMDYxMi9kOTQxYWVhZTQyOTQyYzJlZjYxZWQ1ZTA1Y2MxYWQwNDI4
MDg1NzA0L2RtZXNnLXlvY3RvLWl2YjQxLTk6MjAxNDA2MTMwNjUyMTQ6aTM4Ni1yYW5kY29u
ZmlnLWhhMy0wNjEyOjMuOC4wLTA2NDg1LWdkOTQxYWVhOjY3CjA6MToxIGFsbF9nb29kOmJh
ZDphbGxfYmFkIGJvb3RzCgpCaXNlY3Rpbmc6IDIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDEgc3RlcCkKWzBmZmMyYTljODA3Mjk2OTI1M2EyMDgyMWMy
YzczM2EyY2JiNGM3YzddIGlkcjogaW1wbGVtZW50IGxvb2t1cCBoaW50CnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2Vj
dC9saW51eDYvb2JqLWJpc2VjdApscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
aTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyL2Jhc2Vyb2NrOmJhc2Vyb2NrOm1vcnBoOjBmZmMy
YTljODA3Mjk2OTI1M2EyMDgyMWMyYzczM2EyY2JiNGM3Yzc6YmlzZWN0LWxpbnV4NgoKMjAx
NC0wNi0xMy0wNjo1Mjo0NSAwZmZjMmE5YzgwNzI5NjkyNTNhMjA4MjFjMmM3MzNhMmNiYjRj
N2M3IGNvbXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxk
LXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi0wZmZjMmE5YzgwNzI5NjkyNTNhMjA4
MjFjMmM3MzNhMmNiYjRjN2M3CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctaGEzLTA2MTIvMGZmYzJhOWM4MDcyOTY5MjUzYTIwODIxYzJjNzMzYTJjYmI0
YzdjNwp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLTBmZmMyYTljODA3Mjk2OTI1M2EyMDgyMWMy
YzczM2EyY2JiNGM3YzcKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYx
Mi8wZmZjMmE5YzgwNzI5NjkyNTNhMjA4MjFjMmM3MzNhMmNiYjRjN2M3L3ZtbGludXotMy44
LjAtMDY0ODItZzBmZmMyYTkKCjIwMTQtMDYtMTMtMDY6NTQ6NDUgZGV0ZWN0aW5nIGJvb3Qg
c3RhdGUgLi4uLi4uLi4uCTEJNQk5IFRFU1QgRkFJTFVSRQpbICAgIDcuNjQyMzEzXSBpbml0
OiBGYWlsZWQgdG8gY3JlYXRlIHB0eSAtIGRpc2FibGluZyBsb2dnaW5nIGZvciBqb2IKWyAg
ICA3LjY0Mzg2Nl0gaW5pdDogVGVtcG9yYXJ5IHByb2Nlc3Mgc3Bhd24gZXJyb3I6IE5vIHNw
YWNlIGxlZnQgb24gZGV2aWNlClsgICAgNy43MjQzMzRdIGluaXQ6IG1vdW50ZWQtdG1wIG1h
aW4gcHJvY2VzcyAoMTQ3KSB0ZXJtaW5hdGVkIHdpdGggc3RhdHVzIDMyClsgICAxNy44NjY2
MjddIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgYmRk
ZGI5YjgKWyAgIDE3Ljg2ODI0Ml0gSVA6IFs8YzAyODJjZDc+XSBzdGF0aWNfa2V5X3Nsb3df
aW5jKzB4NC8weDQ3ClsgICAxNy44Njg5NDVdICpwZHB0ID0gMDAwMDAwMDAwOTAwZDAwMSAq
cGRlID0gMDAwMDAwMDAwMDAwMDAwMCAKWyAgIDE3Ljg2ODk0NV0gT29wczogMDAwMCBbIzFd
IFBSRUVNUFQgU01QIERFQlVHX1BBR0VBTExPQwpbICAgMTcuODY4OTQ1XSBQaWQ6IDE3Miwg
Y29tbTogdHJpbml0eS1tYWluIE5vdCB0YWludGVkIDMuOC4wLTA2NDgyLWcwZmZjMmE5ICM2
OCBCb2NocyBCb2NocwpbICAgMTcuODY4OTQ1XSBFSVA6IDAwNjA6WzxjMDI4MmNkNz5dIEVG
TEFHUzogMDAwMTAyMDYgQ1BVOiAxClsgICAxNy44Njg5NDVdIEVJUCBpcyBhdCBzdGF0aWNf
a2V5X3Nsb3dfaW5jKzB4NC8weDQ3ClsgICAxNy44Njg5NDVdIEVBWDogYmRkZGI5YjggRUJY
OiBjODY3MWMwMCBFQ1g6IDAwMDAwMDE4IEVEWDogMDAwMDAwMDgKWyAgIDE3Ljg2ODk0NV0g
RVNJOiAwMDAwMDAwOCBFREk6IGZmOTU5NTk1IEVCUDogYzg2MjdlYjQgRVNQOiBjODYyN2Vi
MApbICAgMTcuODY4OTQ1XSAgRFM6IDAwN2IgRVM6IDAwN2IgRlM6IDAwZDggR1M6IDAwMzMg
U1M6IDAwNjgKWyAgIDE3Ljg2ODk0NV0gQ1IwOiA4MDA1MDAzYiBDUjI6IGJkZGRiOWI4IENS
MzogMDg1N2UwMDAgQ1I0OiAwMDAwMDYzMApbICAgMTcuODY4OTQ1XSBEUjA6IDA4YTc2MDAw
IERSMTogMDAwMDAwMDAgRFIyOiAwMDAwMDAwMCBEUjM6IDAwMDAwMDAwClsgICAxNy44Njg5
NDVdIERSNjogZmZmZjBmZjAgRFI3OiAwMDA3MDYwMgpbICAgMTcuODY4OTQ1XSBQcm9jZXNz
IHRyaW5pdHktbWFpbiAocGlkOiAxNzIsIHRpPWM4NjI2MDAwIHRhc2s9Yzg2NjA3MjAgdGFz
ay50aT1jODYyNjAwMCkKWyAgIDE3Ljg2ODk0NV0gU3RhY2s6ClsgICAxNy44Njg5NDVdICBj
ODY3MWMwMCBjODYyN2VjYyBjMDI3YmY2OSAwMDAwMDAwMCBjMGNiOTczMCBjODY3MWMwMCAw
MDAwMDAwMCBjODYyN2VlOApbICAgMTcuODY4OTQ1XSAgYzAyN2ZiMDMgMDAwMDAwMDAgYzBj
Yjk3MzAgMDAwMDAwMDAgYzg2NzFkNDggYzg2NzFjMDAgYzg2MjdmMDQgYzAyN2ZkYTkKWyAg
IDE3Ljg2ODk0NV0gIGM4NjI3ZjQwIGM4NjcxYzAwIDAwMDAwMDAwIGM4NjYwNzIwIDAwMDAw
MDAwIGM4NjI3ZmFjIGMwMjgwNDBlIGM4NjcxYzAwClsgICAxNy44Njg5NDVdIENhbGwgVHJh
Y2U6ClsgICAxNy44Njg5NDVdICBbPGMwMjdiZjY5Pl0gcGVyZl9zd2V2ZW50X2luaXQrMHhi
OC8weGRkClsgICAxNy44Njg5NDVdICBbPGMwMjdmYjAzPl0gcGVyZl9pbml0X2V2ZW50KzB4
Y2UvMHgxMjQKWyAgIDE3Ljg2ODk0NV0gIFs8YzAyN2ZkYTk+XSBwZXJmX2V2ZW50X2FsbG9j
KzB4MjUwLzB4MzYwClsgICAxNy44Njg5NDVdICBbPGMwMjgwNDBlPl0gc3lzX3BlcmZfZXZl
bnRfb3BlbisweDMzNi8weDY2NApbICAgMTcuODY4OTQ1XSAgWzxjMDk0NGEwYT5dIHN5c2Vu
dGVyX2RvX2NhbGwrMHgxMi8weDNjClsgICAxNy44Njg5NDVdIENvZGU6IDMxIGQyIDg5IGQ4
IGU4IDM4IGZmIGZmIGZmIGU4IDg1IGZmIGZmIGZmIDgzIGM0IDBjIDViIDVlIDVmIDVkIGMz
IDU1IDgzIGU4IDBjIDg5IGU1IDMxIGM5IDMxIGQyIGU4IDdkIGZmIGZmIGZmIDVkIGMzIDU1
IDg5IGU1IDUzIDw4Yj4gMTAgODkgYzMgODUgZDIgNzQgMTEgOGQgNGEgMDEgODkgZDAgZjAg
MGYgYjEgMGIgMzkgZDAgNzQgMmIKWyAgIDE3Ljg2ODk0NV0gRUlQOiBbPGMwMjgyY2Q3Pl0g
c3RhdGljX2tleV9zbG93X2luYysweDQvMHg0NyBTUzpFU1AgMDA2ODpjODYyN2ViMApbICAg
MTcuODY4OTQ1XSBDUjI6IDAwMDAwMDAwYmRkZGI5YjgKWyAgIDE4LjAxNTkwOF0gLS0tWyBl
bmQgdHJhY2UgM2RhNzI3MmY1NzI4NzVkNCBdLS0tClsgICAxOC4wMTcwNzFdIEtlcm5lbCBw
YW5pYyAtIG5vdCBzeW5jaW5nOiBGYXRhbCBleGNlcHRpb24KL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctaGEzLTA2MTIvMGZmYzJhOWM4MDcyOTY5MjUzYTIwODIxYzJjNzMzYTJjYmI0Yzdj
Ny9kbWVzZy15b2N0by1pdmI0NC00NjoyMDE0MDYxMzA3MDAxNTppMzg2LXJhbmRjb25maWct
aGEzLTA2MTI6My44LjAtMDY0ODItZzBmZmMyYTk6NjgKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctaGEzLTA2MTIvMGZmYzJhOWM4MDcyOTY5MjUzYTIwODIxYzJjNzMzYTJjYmI0YzdjNy9k
bWVzZy15b2N0by1pdmI0MS01NDoyMDE0MDYxMzA3MDAzMTppMzg2LXJhbmRjb25maWctaGEz
LTA2MTI6My44LjAtMDY0ODItZzBmZmMyYTk6NjgKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
aGEzLTA2MTIvMGZmYzJhOWM4MDcyOTY5MjUzYTIwODIxYzJjNzMzYTJjYmI0YzdjNy9kbWVz
Zy15b2N0by1pdmI0Mi0zOToyMDE0MDYxMzA3MDAzMzppMzg2LXJhbmRjb25maWctaGEzLTA2
MTI6My44LjAtMDY0ODItZzBmZmMyYTk6NjgKMjozOjEwIGFsbF9nb29kOmJhZDphbGxfYmFk
IGJvb3RzCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDAgc3RlcHMpCls1NDYxNjI4M2MyOTQ4ODEyYTQ0MjQwODU4Y2VkNjEwZTdj
YWNiZGUxXSBpZHI6IGFkZCBpZHJfbGF5ZXItPnByZWZpeApydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2MvYm9vdC1iaXNlY3QvbGludXg2
L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1oYTMtMDYxMi9iYXNlcm9jazpiYXNlcm9jazptb3JwaDo1NDYxNjI4M2MyOTQ4
ODEyYTQ0MjQwODU4Y2VkNjEwZTdjYWNiZGUxOmJpc2VjdC1saW51eDYKCjIwMTQtMDYtMTMt
MDc6MDA6NDcgNTQ2MTYyODNjMjk0ODgxMmE0NDI0MDg1OGNlZDYxMGU3Y2FjYmRlMSBjb21w
aWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9p
Mzg2LXJhbmRjb25maWctaGEzLTA2MTItNTQ2MTYyODNjMjk0ODgxMmE0NDI0MDg1OGNlZDYx
MGU3Y2FjYmRlMQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWhhMy0wNjEyLzU0NjE2MjgzYzI5NDg4MTJhNDQyNDA4NThjZWQ2MTBlN2NhY2JkZTEKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1oYTMtMDYxMi01NDYxNjI4M2MyOTQ4ODEyYTQ0MjQwODU4Y2VkNjEwZTdj
YWNiZGUxCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS8uaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyLTU0NjE2MjgzYzI5NDg4MTJhNDQyNDA4
NThjZWQ2MTBlN2NhY2JkZTEKa2VybmVsOiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMt
MDYxMi81NDYxNjI4M2MyOTQ4ODEyYTQ0MjQwODU4Y2VkNjEwZTdjYWNiZGUxL3ZtbGludXot
My44LjAtMDY0ODEtZzU0NjE2MjgKCjIwMTQtMDYtMTMtMDc6MDM6NDcgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgCTQJOQkzMgk2Mgk4OQkxMTUgU1VDQ0VTUwoKMGZmYzJhOWM4MDcyOTY5MjUz
YTIwODIxYzJjNzMzYTJjYmI0YzdjNyBpcyB0aGUgZmlyc3QgYmFkIGNvbW1pdApjb21taXQg
MGZmYzJhOWM4MDcyOTY5MjUzYTIwODIxYzJjNzMzYTJjYmI0YzdjNwpBdXRob3I6IFRlanVu
IEhlbyA8dGpAa2VybmVsLm9yZz4KRGF0ZTogICBXZWQgRmViIDI3IDE3OjA1OjA4IDIwMTMg
LTA4MDAKCiAgICBpZHI6IGltcGxlbWVudCBsb29rdXAgaGludAogICAgCiAgICBXaGlsZSBp
ZHIgbG9va3VwIGlzbid0IGEgcGFydGljdWxhcmx5IGhlYXZ5IG9wZXJhdGlvbiwgaXQgc3Rp
bGwgaXMgdG9vCiAgICBzdWJzdGFudGlhbCB0byB1c2UgaW4gaG90IHBhdGhzIHdpdGhvdXQg
d29ycnlpbmcgYWJvdXQgdGhlIHBlcmZvcm1hbmNlCiAgICBpbXBsaWNhdGlvbnMuICBXaXRo
IHJlY2VudCBjaGFuZ2VzLCBlYWNoIGlkcl9sYXllciBjb3ZlcnMgMjU2IHNsb3RzCiAgICB3
aGljaCBzaG91bGQgYmUgZW5vdWdoIHRvIGNvdmVyIG1vc3QgdXNlIGNhc2VzIHdpdGggc2lu
Z2xlIGlkcl9sYXllcgogICAgbWFraW5nIGxvb2t1cCBoaW50IHZlcnkgYXR0cmFjdGl2ZS4K
ICAgIAogICAgVGhpcyBwYXRjaCBhZGRzIGlkci0+aGludCB3aGljaCBwb2ludHMgdG8gdGhl
IGlkcl9sYXllciB3aGljaAogICAgYWxsb2NhdGVkIGFuIElEIG1vc3QgcmVjZW50bHkgYW5k
IHRoZSBmYXN0IHBhdGggbG9va3VwIGJlY29tZXMKICAgIAogICAgCWlmIChsb29rIHVwIHRh
cmdldCdzIHByZWZpeCBtYXRjaGVzIHRoYXQgb2YgdGhlIGhpbnRlZCBsYXllcikKICAgIAkJ
cmV0dXJuIGhpbnQtPmFyeVtJRCdzIG9mZnNldCBpbiB0aGUgbGVhZiBsYXllcl07CiAgICAK
ICAgIHdoaWNoIGNhbiBiZSBpbmxpbmVkLgogICAgCiAgICBpZHItPmhpbnQgaXMgc2V0IHRv
IHRoZSBsZWFmIG5vZGUgb24gaWRyX2ZpbGxfc2xvdCgpIGFuZCBjbGVhcmVkIGZyb20KICAg
IGZyZWVfbGF5ZXIoKS4KICAgIAogICAgW2FuZHJpeS5zaGV2Y2hlbmtvQGxpbnV4LmludGVs
LmNvbTogYWx3YXlzIGRvIHNsb3cgcGF0aCB3aGVuIGhpbnQgaXMgdW5pbml0aWFsaXplZF0K
ICAgIFNpZ25lZC1vZmYtYnk6IFRlanVuIEhlbyA8dGpAa2VybmVsLm9yZz4KICAgIENjOiBL
aXJpbGwgQS4gU2h1dGVtb3YgPGtpcmlsbC5zaHV0ZW1vdkBsaW51eC5pbnRlbC5jb20+CiAg
ICBDYzogU2FzaGEgTGV2aW4gPHNhc2hhLmxldmluQG9yYWNsZS5jb20+CiAgICBTaWduZWQt
b2ZmLWJ5OiBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPgogICAg
U2lnbmVkLW9mZi1ieTogTGludXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRp
b24ub3JnPgoKOjA0MDAwMCAwNDAwMDAgNjE0YmYwMzkyM2I5Yjc4MDBmMWQzMTFiZDNlZDJi
OWI5MDUxZDQ5MiAyMGM2YzUyMzlmOTk2YmE1YzM4YjJmYzZjYWJiOTIxZjMzMzEwNTMxIE0J
aW5jbHVkZQo6MDQwMDAwIDA0MDAwMCAyYThjMzIzNmMyZWYyMGY1N2NkOTFjNmJlODdiMWZi
YjNmZTliMWMwIDZjZTg1NzgxNmNlZDI3ODgzOWM2YWY5NDFlNTczMDM4MTYzZDgyZmUgTQls
aWIKYmlzZWN0IHJ1biBzdWNjZXNzCkhFQUQgaXMgbm93IGF0IDU0NjE2MjguLi4gaWRyOiBh
ZGQgaWRyX2xheWVyLT5wcmVmaXgKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3Zt
L2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi9iYXNlcm9jazpiYXNlcm9jazptb3JwaDo1NDYx
NjI4M2MyOTQ4ODEyYTQ0MjQwODU4Y2VkNjEwZTdjYWNiZGUxOmJpc2VjdC1saW51eDYKCjIw
MTQtMDYtMTMtMDc6MDY6NTEgNTQ2MTYyODNjMjk0ODgxMmE0NDI0MDg1OGNlZDYxMGU3Y2Fj
YmRlMSByZXVzZSAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi81NDYxNjI4M2My
OTQ4ODEyYTQ0MjQwODU4Y2VkNjEwZTdjYWNiZGUxL3ZtbGludXotMy44LjAtMDY0ODEtZzU0
NjE2MjgKCjIwMTQtMDYtMTMtMDc6MDY6NTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4u
Li4uCTEJNwkyMAk0NAkxMTAJMTkxCTI2MgkzMTQJMzQ1IFNVQ0NFU1MKClByZXZpb3VzIEhF
QUQgcG9zaXRpb24gd2FzIDU0NjE2MjguLi4gaWRyOiBhZGQgaWRyX2xheWVyLT5wcmVmaXgK
SEVBRCBpcyBub3cgYXQgZDY3YTBlMS4uLiBtb3JwaG9sb2dpZXM6IEVuYWJsZSBDT05GSUdf
RkhBTkRMRQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWhhMy0wNjEyL2Jhc2Vyb2NrOmJhc2Vyb2NrOm1vcnBoOmQ2N2EwZTExMDE4N2FiZDU2
MGExZGU2M2ZhMTcyODk0YTUyODM5ZDU6YmlzZWN0LWxpbnV4NgoKMjAxNC0wNi0xMy0wNzox
NTo1OCBkNjdhMGUxMTAxODdhYmQ1NjBhMWRlNjNmYTE3Mjg5NGE1MjgzOWQ1IHJldXNlIC9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWhhMy0wNjEyL2Q2N2EwZTExMDE4N2FiZDU2MGExZGU2
M2ZhMTcyODk0YTUyODM5ZDUvdm1saW51ei0zLjE1LjAtMDQ3OTUtZ2Q2N2EwZTEKCjIwMTQt
MDYtMTMtMDc6MTU6NTggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JNgkxMwk2NAk5MAkxMTcJ
MTU1CTE5MAkyMTAJMjcxCTMxOQkzNDMuLi4uLi4uLi4uLi4uCTM0NC4uCTM0NSBTVUNDRVNT
CgpIRUFEIGlzIG5vdyBhdCBkNjdhMGUxIG1vcnBob2xvZ2llczogRW5hYmxlIENPTkZJR19G
SEFORExFCgo9PT09PT09PT0gdXBzdHJlYW0gPT09PT09PT09CkZyb20gZ2l0Oi8vZ2l0bWly
cm9yL2xpbnVzCiAgIDVjMDJjMzkuLjBlMDRjNjQgIG1hc3RlciAgICAgLT4gbGludXMvbWFz
dGVyClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIGQ2N2EwZTEuLi4gbW9ycGhvbG9naWVz
OiBFbmFibGUgQ09ORklHX0ZIQU5ETEUKSEVBRCBpcyBub3cgYXQgMGUwNGM2NC4uLiBNZXJn
ZSB0YWcgJ2RtLTMuMTYtY2hhbmdlcycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L2RldmljZS1tYXBwZXIvbGludXgtZG0KbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi9saW51czpt
YXN0ZXI6MGUwNGM2NDFiMTk5NDM1ZjM3Nzk0NTQwNTVmNmE3ZGUyNThlY2RmYzpiaXNlY3Qt
bGludXg2CgoyMDE0LTA2LTEzLTA3OjMyOjU1IDBlMDRjNjQxYjE5OTQzNWYzNzc5NDU0MDU1
ZjZhN2RlMjU4ZWNkZmMgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MTIv
MGUwNGM2NDFiMTk5NDM1ZjM3Nzk0NTQwNTVmNmE3ZGUyNThlY2RmYy92bWxpbnV6LTMuMTUu
MC0wNDkzNC1nMGUwNGM2NAoKMjAxNC0wNi0xMy0wNzozMjo1NSBkZXRlY3RpbmcgYm9vdCBz
dGF0ZSAuLgkxMgkzOQk3OQkxMDUJMTU0CTE5OQkyNTkJMzMyCTM0Mi4uLi4uLi4uLi4uLgkz
NDMuCTM0NSBTVUNDRVNTCgoKPT09PT09PT09IGxpbnV4LW5leHQgPT09PT09PT09CkZyb20g
Z2l0Oi8vZ2l0bWlycm9yL25leHQKICsgMzA4MDZmOC4uLmY2MGJmMzUgYWtwbSAgICAgICAt
PiBuZXh0L2FrcG0gIChmb3JjZWQgdXBkYXRlKQogKyA1NmI1NDk4Li4uZGFkYTkxNSBha3Bt
LWJhc2UgIC0+IG5leHQvYWtwbS1iYXNlICAoZm9yY2VkIHVwZGF0ZSkKICsgMjdhNGU0My4u
LmIxY2NlNjIgbWFzdGVyICAgICAtPiBuZXh0L21hc3RlciAgKGZvcmNlZCB1cGRhdGUpCiAg
IDE0MjA4YjAuLjQyNTFjMmE2IHN0YWJsZSAgICAgLT4gbmV4dC9zdGFibGUKRnJvbSBnaXQ6
Ly9naXRtaXJyb3IvbmV4dAogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwNjExIC0+
IG5leHQtMjAxNDA2MTEKICogW25ldyB0YWddICAgICAgICAgbmV4dC0yMDE0MDYxMiAtPiBu
ZXh0LTIwMTQwNjEyClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDBlMDRjNjQuLi4gTWVy
Z2UgdGFnICdkbS0zLjE2LWNoYW5nZXMnIG9mIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9z
Y20vbGludXgva2VybmVsL2dpdC9kZXZpY2UtbWFwcGVyL2xpbnV4LWRtCkhFQUQgaXMgbm93
IGF0IGIxY2NlNjIuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIwMTQw
NjEyCmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
aGEzLTA2MTIvbmV4dDptYXN0ZXI6YjFjY2U2MjBmZDRiNjg2NGM5MmU3MzA3YmU3ODM5Nzg5
ZjljOGJlMDpiaXNlY3QtbGludXg2CgoyMDE0LTA2LTEzLTA3OjQ2OjExIGIxY2NlNjIwZmQ0
YjY4NjRjOTJlNzMwN2JlNzgzOTc4OWY5YzhiZTAgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0
YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLWhhMy0w
NjEyLWIxY2NlNjIwZmQ0YjY4NjRjOTJlNzMwN2JlNzgzOTc4OWY5YzhiZTAKQ2hlY2sgZm9y
IGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1oYTMtMDYxMi9iMWNjZTYyMGZk
NGI2ODY0YzkyZTczMDdiZTc4Mzk3ODlmOWM4YmUwCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctaGEzLTA2MTIt
YjFjY2U2MjBmZDRiNjg2NGM5MmU3MzA3YmU3ODM5Nzg5ZjljOGJlMAp3YWl0aW5nIGZvciBj
b21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVldWUvLmkzODYtcmFuZGNvbmZp
Zy1oYTMtMDYxMi1iMWNjZTYyMGZkNGI2ODY0YzkyZTczMDdiZTc4Mzk3ODlmOWM4YmUwCmtl
cm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctaGEzLTA2MTIvYjFjY2U2MjBmZDRiNjg2
NGM5MmU3MzA3YmU3ODM5Nzg5ZjljOGJlMC92bWxpbnV6LTMuMTUuMC1uZXh0LTIwMTQwNjEy
CgoyMDE0LTA2LTEzLTA3OjQ5OjExIGRldGVjdGluZyBib290IHN0YXRlIAkyCTI5CTQ4CTg2
CTEyMQkxNTcJMTczCTE5OQkyMzMJMjc2CTMzMwkzMzkuLi4uLi4uCTM0MAkzNDMJMzQ0Li4u
Li4JMzQ1IFNVQ0NFU1MKCg==
--------------050201040302000204090605
Content-Type: text/plain; charset=UTF-8;
 name="config-3.8.0-06482-g0ffc2a9"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="config-3.8.0-06482-g0ffc2a9"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.8.0 Kernel Configuration
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
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
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
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ALWAYS_USE_PERSISTENT_CLOCK=y
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
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_HAVE_UID16=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
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
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
CONFIG_BLK_DEV_THROTTLING=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_WANT_INTEL_MID is not set
# CONFIG_X86_INTEL_LPSS is not set
# CONFIG_X86_RDC321X is not set
CONFIG_X86_32_NON_STANDARD=y
# CONFIG_X86_NUMAQ is not set
# CONFIG_STA2X11 is not set
# CONFIG_X86_SUMMIT is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
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
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
CONFIG_MICROCODE_INTEL_EARLY=y
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
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
CONFIG_CLEANCACHE=y
# CONFIG_FRONTSWAP is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
# CONFIG_PM_RUNTIME is not set
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
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
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
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
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
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
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
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
# CONFIG_EISA_NAMES is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_ALIX is not set
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
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_COREDUMP=y
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
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
CONFIG_ATM=y
# CONFIG_ATM_LANE is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_LTPC=y
# CONFIG_COPS is not set
# CONFIG_IPDDP is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_VSOCKETS=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
CONFIG_6PACK=y
CONFIG_BPQETHER=y
CONFIG_SCC=y
CONFIG_SCC_DELAY=y
# CONFIG_SCC_TRXECHO is not set
CONFIG_BAYCOM_SER_FDX=y
# CONFIG_BAYCOM_SER_HDX is not set
# CONFIG_BAYCOM_PAR is not set
# CONFIG_BAYCOM_EPP is not set
CONFIG_YAM=y
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIUART_3WIRE=y
# CONFIG_BT_HCIBCM203X is not set
CONFIG_BT_HCIBPA10X=y
CONFIG_BT_HCIBFUSB=y
CONFIG_BT_HCIDTL1=y
CONFIG_BT_HCIBT3C=y
CONFIG_BT_HCIBLUECARD=y
CONFIG_BT_HCIBTUART=y
CONFIG_BT_HCIVHCI=y
CONFIG_BT_MRVL=y
CONFIG_FIB_RULES=y
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
# CONFIG_CAIF_USB is not set
CONFIG_NFC=y
CONFIG_NFC_NCI=y
CONFIG_NFC_HCI=y
# CONFIG_NFC_SHDLC is not set
# CONFIG_NFC_LLCP is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_PN533=y
CONFIG_NFC_PN544=y
CONFIG_NFC_MICROREAD=y

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
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
CONFIG_CMA_SIZE_SEL_MIN=y
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
# CONFIG_PNPBIOS_PROC_FS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_PARIDE is not set
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

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=y
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_AT25 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
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
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECS=y
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y

#
# PCI IDE chipsets support
#
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
CONFIG_BLK_DEV_ALI14XX=y
# CONFIG_BLK_DEV_DTC2278 is not set
CONFIG_BLK_DEV_HT6560B=y
CONFIG_BLK_DEV_QD65XX=y
# CONFIG_BLK_DEV_UMC8672 is not set
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
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
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
CONFIG_SCSI_AHA1740=y
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=y
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_LIBFC=y
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_DTC3280=y
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_ISCI is not set
CONFIG_SCSI_GENERIC_NCR5380=y
CONFIG_SCSI_GENERIC_NCR5380_MMIO=y
# CONFIG_SCSI_GENERIC_NCR53C400 is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
CONFIG_SCSI_IMM=y
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_NCR53C406A=y
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_PAS16 is not set
CONFIG_SCSI_QLOGIC_FAS=y
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SIM710=y
CONFIG_SCSI_SYM53C416=y
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
CONFIG_SCSI_T128=y
CONFIG_SCSI_U14_34F=y
# CONFIG_SCSI_U14_34F_TAGGED_QUEUE is not set
CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
CONFIG_SCSI_U14_34F_MAX_TAGS=8
CONFIG_SCSI_ULTRASTOR=y
# CONFIG_SCSI_NSP32 is not set
CONFIG_SCSI_DEBUG=y
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
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
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

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
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
CONFIG_JOYSTICK_SPACEORB=y
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_AS5011=y
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_JOYSTICK_WALKERA0701=y
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM860X_ONKEY is not set
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_AD714X_SPI=y
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_WISTRON_BTNS=y
# CONFIG_INPUT_ATLAS_BTNS is not set
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
# CONFIG_INPUT_TWL4030_PWRBUTTON is not set
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
# CONFIG_INPUT_DA9055_ONKEY is not set
CONFIG_INPUT_WM831X_ON=y
# CONFIG_INPUT_PCAP is not set
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
# CONFIG_INPUT_ADXL34X_SPI is not set
# CONFIG_INPUT_CMA3000 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
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
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_FOURPORT=y
CONFIG_SERIAL_8250_ACCENT=y
# CONFIG_SERIAL_8250_BOCA is not set
CONFIG_SERIAL_8250_EXAR_ST16C554=y
CONFIG_SERIAL_8250_HUB6=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_IFX6X60=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=y
# CONFIG_SERIAL_ARC_CONSOLE is not set
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=y
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
CONFIG_DTLK=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
# CONFIG_CARDMAN_4000 is not set
CONFIG_CARDMAN_4040=y
# CONFIG_MWAVE is not set
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=y
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
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
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
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_TOPCLIFF_PCH is not set
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
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
# CONFIG_GPIO_SYSFS is not set
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
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_WM831X is not set
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5520 is not set
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
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_74X164 is not set

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_TPS6586X=y
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=y
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=y
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
CONFIG_BATTERY_BQ27x00=y
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9052=y
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
CONFIG_CHARGER_PCF50633=y
# CONFIG_CHARGER_ISP1704 is not set
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
CONFIG_CHARGER_LP8727=y
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MAX8997=y
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
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
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_DA9055 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NTC_THERMISTOR=y
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
CONFIG_SENSORS_PCF8591=y
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
CONFIG_SENSORS_LM25066=y
# CONFIG_SENSORS_LTC2978 is not set
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=y
CONFIG_SENSORS_MAX8688=y
CONFIG_SENSORS_UCD9000=y
CONFIG_SENSORS_UCD9200=y
CONFIG_SENSORS_ZL6100=y
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
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
# CONFIG_FAIR_SHARE is not set
CONFIG_STEP_WISE=y
# CONFIG_USER_SPACE is not set
# CONFIG_CPU_THERMAL is not set
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
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
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
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_MFD_LM3533=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_STMPE_SPI is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_EZX_PCAP=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
# CONFIG_LPC_SCH is not set
# CONFIG_LPC_ICH is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_MFD_VIPERBOARD=y
# CONFIG_MFD_RETU is not set
CONFIG_MFD_AS3711=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
# CONFIG_REGULATOR_DUMMY is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_DA9052=y
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_MC13XXX_CORE=y
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_88PM8607 is not set
# CONFIG_REGULATOR_MAX1586 is not set
# CONFIG_REGULATOR_MAX8649 is not set
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_PCAP=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
# CONFIG_REGULATOR_TPS6524X is not set
CONFIG_REGULATOR_TPS6586X=y
# CONFIG_REGULATOR_TPS65910 is not set
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8400=y
CONFIG_REGULATOR_WM8994=y
CONFIG_REGULATOR_AS3711=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_VMALLOC=y
# CONFIG_VIDEO_V4L2_INT_DEVICE is not set
CONFIG_DVB_CORE=y
CONFIG_TTPCI_EEPROM=y
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
# CONFIG_IR_LIRC_CODEC is not set
# CONFIG_IR_NEC_DECODER is not set
CONFIG_IR_RC5_DECODER=y
# CONFIG_IR_RC6_DECODER is not set
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
# CONFIG_IR_RC5_SZ_DECODER is not set
CONFIG_IR_SANYO_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
# CONFIG_RC_DEVICES is not set
CONFIG_MEDIA_USB_SUPPORT=y

#
# Analog TV USB devices
#
# CONFIG_VIDEO_PVRUSB2 is not set
CONFIG_VIDEO_HDPVR=y
CONFIG_VIDEO_USBVISION=y
# CONFIG_VIDEO_STK1160 is not set

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=y
# CONFIG_VIDEO_AU0828_V4L2 is not set
CONFIG_VIDEO_CX231XX=y
# CONFIG_VIDEO_CX231XX_RC is not set
# CONFIG_VIDEO_CX231XX_DVB is not set
CONFIG_VIDEO_TM6000=y
# CONFIG_VIDEO_TM6000_DVB is not set

#
# Digital TV USB devices
#
CONFIG_DVB_USB=y
CONFIG_DVB_USB_DEBUG=y
CONFIG_DVB_USB_A800=y
CONFIG_DVB_USB_DIBUSB_MB=y
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
CONFIG_DVB_USB_DIBUSB_MC=y
CONFIG_DVB_USB_DIB0700=y
# CONFIG_DVB_USB_UMT_010 is not set
CONFIG_DVB_USB_CXUSB=y
CONFIG_DVB_USB_M920X=y
# CONFIG_DVB_USB_DIGITV is not set
CONFIG_DVB_USB_VP7045=y
CONFIG_DVB_USB_VP702X=y
CONFIG_DVB_USB_GP8PSK=y
# CONFIG_DVB_USB_NOVA_T_USB2 is not set
# CONFIG_DVB_USB_TTUSB2 is not set
CONFIG_DVB_USB_DTT200U=y
CONFIG_DVB_USB_OPERA1=y
# CONFIG_DVB_USB_AF9005 is not set
CONFIG_DVB_USB_PCTV452E=y
CONFIG_DVB_USB_DW2102=y
CONFIG_DVB_USB_CINERGY_T2=y
CONFIG_DVB_USB_DTV5100=y
CONFIG_DVB_USB_FRIIO=y
CONFIG_DVB_USB_AZ6027=y
CONFIG_DVB_USB_TECHNISAT_USB2=y
CONFIG_DVB_USB_V2=y
CONFIG_DVB_USB_CYPRESS_FIRMWARE=y
# CONFIG_DVB_USB_AF9015 is not set
# CONFIG_DVB_USB_AF9035 is not set
CONFIG_DVB_USB_ANYSEE=y
CONFIG_DVB_USB_AU6610=y
CONFIG_DVB_USB_AZ6007=y
CONFIG_DVB_USB_CE6230=y
# CONFIG_DVB_USB_EC168 is not set
# CONFIG_DVB_USB_GL861 is not set
# CONFIG_DVB_USB_IT913X is not set
# CONFIG_DVB_USB_LME2510 is not set
CONFIG_DVB_USB_MXL111SF=y
CONFIG_DVB_USB_RTL28XXU=y
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
CONFIG_SMS_USB_DRV=y
# CONFIG_DVB_B2C2_FLEXCOP_USB is not set

#
# Webcam, TV (analog/digital) USB devices
#
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_CX2341X=y
CONFIG_VIDEO_TVEEPROM=y
CONFIG_SMS_SIANO_MDTV=y
CONFIG_SMS_SIANO_RC=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders, processors and mixers
#

#
# RDS decoders
#

#
# Video decoders
#
CONFIG_VIDEO_SAA711X=y

#
# Video and audio decoders
#
CONFIG_VIDEO_CX25840=y

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
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_QT1010=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
CONFIG_MEDIA_TUNER_MXL5005S=y
CONFIG_MEDIA_TUNER_MXL5007T=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_MEDIA_TUNER_MAX2165=y
CONFIG_MEDIA_TUNER_FC0012=y
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=y

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_MT312=y
CONFIG_DVB_ZL10039=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=y
CONFIG_DVB_STV0900=y
CONFIG_DVB_CX24116=y
CONFIG_DVB_SI21XX=y
CONFIG_DVB_TS2020=y
CONFIG_DVB_DS3000=y

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_CX22702=y
CONFIG_DVB_TDA1004X=y
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=y
CONFIG_DVB_DIB7000P=y
CONFIG_DVB_CXD2820R=y
CONFIG_DVB_RTL2830=y
CONFIG_DVB_RTL2832=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_TDA10023=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_LG2160=y
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_DTV=y
CONFIG_DVB_S5H1411=y

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_DIB8000=y

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=y
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP22=y
CONFIG_DVB_ISL6423=y
CONFIG_DVB_LGS8GXX=y
CONFIG_DVB_ATBM8830=y
CONFIG_DVB_M88RS2000=y

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
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_HDMI=y
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_PWM=y
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_PCF50633 is not set
# CONFIG_BACKLIGHT_LM3630 is not set
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_AS3711=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_MDA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
# CONFIG_HID_PS3REMOTE is not set
CONFIG_HID_ROCCAT=y
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
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
# CONFIG_USB_HIDDEV is not set

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
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_DWC3=y
# CONFIG_USB_DWC3_HOST is not set
# CONFIG_USB_DWC3_GADGET is not set
CONFIG_USB_DWC3_DUAL_ROLE=y
# CONFIG_USB_DWC3_DEBUG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_PLATFORM=y
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
CONFIG_USB_ISP116X_HCD=y
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_HCD_ISO is not set
CONFIG_USB_SL811_CS=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HCD_SSB=y
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_CHIPIDEA is not set
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
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
# CONFIG_USB_STORAGE_USBAT is not set
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_STORAGE_ENE_UB6250=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
CONFIG_USB_SERIAL_BELKIN=y
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
CONFIG_USB_SERIAL_F81232=y
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=y
CONFIG_USB_SERIAL_IUU=y
CONFIG_USB_SERIAL_KEYSPAN_PDA=y
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=y
CONFIG_USB_SERIAL_KOBIL_SCT=y
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_METRO=y
CONFIG_USB_SERIAL_MOS7720=y
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
# CONFIG_USB_SERIAL_QCAUX is not set
CONFIG_USB_SERIAL_QUALCOMM=y
CONFIG_USB_SERIAL_SPCP8X5=y
# CONFIG_USB_SERIAL_HP4X is not set
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
CONFIG_USB_SERIAL_SYMBOL=y
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
CONFIG_USB_SERIAL_XIRCOM=y
CONFIG_USB_SERIAL_WWAN=y
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
CONFIG_USB_SERIAL_OPTICON=y
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
CONFIG_USB_SERIAL_XSENS_MT=y
# CONFIG_USB_SERIAL_ZIO is not set
CONFIG_USB_SERIAL_ZTE=y
CONFIG_USB_SERIAL_SSU100=y
CONFIG_USB_SERIAL_QT2=y
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y
CONFIG_USB_HSIC_USB3503=y

#
# USB Physical Layer drivers
#
# CONFIG_OMAP_USB3 is not set
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_RCAR_PHY=y
CONFIG_USB_ATM=y
CONFIG_USB_SPEEDTOUCH=y
CONFIG_USB_CXACRU=y
# CONFIG_USB_UEAGLEATM is not set
CONFIG_USB_XUSBATM=y
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_R8A66597=y
# CONFIG_USB_MV_UDC is not set
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
CONFIG_USB_NET2272=y
CONFIG_USB_NET2272_DMA=y
# CONFIG_USB_NET2280 is not set
# CONFIG_USB_GOKU is not set
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_F_ACM=y
CONFIG_USB_U_SERIAL=y
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
CONFIG_USB_G_SERIAL=y
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=y
CONFIG_NOP_USB_XCEIV=y
# CONFIG_UWB is not set
# CONFIG_MMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

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
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_DA9052=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_PWM=y
CONFIG_LEDS_REGULATOR=y
# CONFIG_LEDS_BD2802 is not set
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y
CONFIG_LEDS_BLINKM=y
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
# CONFIG_EDAC_LEGACY_SYSFS is not set
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_AMD76X is not set
# CONFIG_EDAC_E7XXX is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82875P is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I82860 is not set
# CONFIG_EDAC_R82600 is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
# CONFIG_INTEL_MID_DMAC is not set
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_DW_DMAC is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
# CONFIG_UIO_PDRV is not set
# CONFIG_UIO_PDRV_GENIRQ is not set
# CONFIG_UIO_DMEM_GENIRQ is not set
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
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
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_VIRT_DRIVERS is not set
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
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_TWL=y
# CONFIG_PWM_TWL_LED is not set
# CONFIG_IPACK_BUS is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
# CONFIG_EXT4_FS_POSIX_ACL is not set
# CONFIG_EXT4_FS_SECURITY is not set
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_DEBUG=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
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
# CONFIG_ISO9660_FS is not set
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
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
# CONFIG_HFSPLUS_FS is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
CONFIG_F2FS_FS_XATTR=y
# CONFIG_F2FS_FS_POSIX_ACL is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
# CONFIG_NLS_CODEPAGE_861 is not set
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
CONFIG_DEBUG_SLAB=y
# CONFIG_DEBUG_SLAB_LEAK is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
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
CONFIG_TEST_LIST_SORT=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_VERBOSE is not set
# CONFIG_RCU_CPU_STALL_INFO is not set
CONFIG_RCU_TRACE=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_LKDTM is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_DOUBLEFAULT=y
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
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
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
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
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
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
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
CONFIG_CRYPTO_MD4=y
# CONFIG_CRYPTO_MD5 is not set
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_VHOST_NET=y
CONFIG_LGUEST=y
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
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
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
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CORDIC=y
# CONFIG_DDR is not set


--------------050201040302000204090605
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Attached Message Part"

_______________________________________________
LKP mailing list
LKP@linux.intel.com


--------------050201040302000204090605--
