Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaCGCMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 21:12:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:28273 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbaCGCKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 21:10:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,605,1389772800"; 
   d="log'?scan'208";a="487633449"
Date: Fri, 7 Mar 2014 09:37:34 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [scheduler] BUG: unable to handle kernel paging request
Message-ID: <20140307013734.GC8427@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="yVhtmJPUSI46BTXb"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Christoph,

I got the below dmesg and the first bad commit is

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit 9d58cf7a388c1b4a06cb335980eb1bb1352ba876
Author:     Christoph Lameter <cl@linux.com>
AuthorDate: Thu Mar 6 11:05:25 2014 +1100
Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
CommitDate: Thu Mar 6 18:13:42 2014 +1100

    scheduler: replace __get_cpu_var with this_cpu_ptr
    
    Convert all uses of __get_cpu_var for address calculation to use
    this_cpu_ptr instead.
    
    Signed-off-by: Christoph Lameter <cl@linux.com>
    Acked-by: Ingo Molnar <mingo@kernel.org>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Tejun Heo <tj@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>


[    0.309561] BUG: unable to handle kernel
[    0.309561] BUG: unable to handle kernel paging requestpaging request at 0feea000
 at 0feea000
[    0.309899] IP:
[    0.309899] IP: [<c10540d0>] load_balance+0x89/0x657
 [<c10540d0>] load_balance+0x89/0x657
[    0.310171] *pdpt = 0000000000000000
[    0.310171] *pdpt = 0000000000000000 *pde = f000ff53f000ff53 *pde = f000ff53f000ff53


+---------------------------------------------------------+------------+------------+---------------+
|                                                         | 76b1e44e98 | 9d58cf7a38 | next-20140306 |
+---------------------------------------------------------+------------+------------+---------------+
| boot_successes                                          | 77         | 0          | 0             |
| boot_failures                                           | 3          | 20         | 19            |
| WARNING:CPU:PID:at_arch/x86/kernel/cpu/amd.c:init_amd() | 2          | 0          | 1             |
| backtrace:init_amd                                      | 2          | 0          | 1             |
| backtrace:warn_slowpath_fmt                             | 2          | 0          | 1             |
| BUG:kernel_boot_hang                                    | 1          |            |               |
| BUG:unable_to_handle_kernel_paging_request              | 0          | 20         | 19            |
| Oops                                                    | 0          | 20         | 19            |
| Oops:SMP_SMP                                            | 0          | 20         | 19            |
| EIP_is_at_load_balance                                  | 0          | 20         | 19            |
| Oops:SMP                                                | 0          | 19         | 19            |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference    | 0          | 20         | 17            |
| EIP_is_at_set_next_entity                               | 0          | 20         | 17            |
| BUG:scheduling_while_atomic                             | 0          | 20         | 18            |
| INFO:lockdep_is_turned_off                              | 0          | 20         | 18            |
| backtrace:kthreadd                                      | 0          | 20         | 17            |
| backtrace:schedule                                      | 0          | 20         | 19            |
| backtrace:schedule_timeout                              | 0          | 20         | 17            |
| backtrace:smpboot_thread_fn                             | 0          | 0          | 2             |
+---------------------------------------------------------+------------+------------+---------------+

git bisect start 0ffb2fe7b9c30082876fa3a17da018bf0632cf03 09de192242d86ede449146ac423effca53bc1810 --
git bisect  bad 439cde1f3d8230f858c0a55902381d24cd7a2df2  # 22:58      0-      1  Merge branch 'akpm/master'
git bisect good ce34778eb4d9fa0aaaeae76c1068026ee5255fd7  # 23:21     20+      2  Merge branch 'akpm-current/current'
git bisect good 117314461e82adabb6b78dcb03259da75b50833b  # 23:28     20+      1  mm: don't implictly include linux/mm.h in linux/sched.h
git bisect  bad 9d58cf7a388c1b4a06cb335980eb1bb1352ba876  # 23:34      0-      2  scheduler: replace __get_cpu_var with this_cpu_ptr
git bisect good b2ff2cfebad92bebfca28bad650045821ed270c4  # 00:06     20+      0  tracing: replace __get_cpu_var uses with this_cpu_ptr
git bisect good efcd38c3b500ab67593e4514ed7ececf2ec550f5  # 00:13     20+      2  drivers/clocksource: replace __get_cpu_var used for address calculation
git bisect good 222152a10e298d770a186b871163553c062d4a6f  # 00:18     20+      0  drivers/net/ethernet/tile: replace __get_cpu_var uses for address calculation
git bisect good 36086a569a67cd314801b0c0d9aadf3008b5504b  # 00:42     20+      0  tilegx: another case of get_cpu_var
git bisect good 76b1e44e98a5dffb32d95095260ebbd32fb06ff7  # 02:10     20+      1  time: replace __get_cpu_var uses
# first bad commit: [9d58cf7a388c1b4a06cb335980eb1bb1352ba876] scheduler: replace __get_cpu_var with this_cpu_ptr
git bisect good 76b1e44e98a5dffb32d95095260ebbd32fb06ff7  # 02:33     60+      3  time: replace __get_cpu_var uses
git bisect  bad 0ffb2fe7b9c30082876fa3a17da018bf0632cf03  # 02:33      0-     19  Add linux-next specific files for 20140306
git bisect good 3f877e6a523c45a33ce8ea7380f1f32dda7d8137  # 05:35     60+      1  Revert "scheduler: replace __get_cpu_var with this_cpu_ptr"
git bisect good c3bebc71c4bcdafa24b506adf0c1de3c1f77e2e0  # 05:44     60+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect  bad 0ffb2fe7b9c30082876fa3a17da018bf0632cf03  # 05:45      0-     19  Add linux-next specific files for 20140306

Thanks,
Fengguang

--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-waimea-13:20140306201241:i386-randconfig-st1-03061911:3.14.0-rc5-next-20140306-06952-g0ffb2fe:4"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.14.0-rc5-next-20140306-06952-g0ffb2fe (kbuil=
d@stoakley) (gcc version 4.8.1 (Debian 4.8.1-8) ) #4 SMP Thu Mar 6 20:07:18=
 CST 2014
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[c00fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x02dfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x125fffff]
[    0.000000]  [mem 0x12400000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x123fffff]
[    0.000000]  [mem 0x10000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12600000-0x13ffdfff]
[    0.000000]  [mem 0x12600000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02920000, 0x02920fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
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
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] BRK [0x02921000, 0x02921fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
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
[    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 330 pages/cpu @d2117000 s1337792 r0 d13888 =
u1351680
[    0.000000] pcpu-alloc: s1337792 r0 d13888 u1351680 alloc=3D330*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-st1-03061911/next:master/.vmlinuz-0ffb2fe7b9c30082876fa3=
a17da018bf0632cf03-20140306200948-7-waimea branch=3Dnext/master BOOT_IMAGE=
=3D/kernel/i386-randconfig-st1-03061911/0ffb2fe7b9c30082876fa3a17da018bf063=
2cf03/vmlinuz-3.14.0-rc5-next-20140306-06952-g0ffb2fe
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 269440K/327280K available (11435K kernel code, 891K =
rwdata, 5812K rodata, 1776K init, 5676K bss, 57840K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6c000 - 0xfffff000   (1612 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xff9fe000   ( 690 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc21b8000 - 0xc2374000   (1776 kB)
[    0.000000]       .data : 0xc1b2b039 - 0xc21b7f80   (6707 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1b2b039   (11436 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dd1c0a000 soft=3Dd1c0c000
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.14.0-rc5-next-20140306-06952-g0ffb2fe (kbuil=
d@stoakley) (gcc version 4.8.1 (Debian 4.8.1-8) ) #4 SMP Thu Mar 6 20:07:18=
 CST 2014
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13ffe max_arch_pfn =3D 0x1000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[c00fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x02dfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x125fffff]
[    0.000000]  [mem 0x12400000-0x125fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x10000000-0x123fffff]
[    0.000000]  [mem 0x10000000-0x123fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x12600000-0x13ffdfff]
[    0.000000]  [mem 0x12600000-0x13dfffff] page 2M
[    0.000000]  [mem 0x13e00000-0x13ffdfff] page 4k
[    0.000000] BRK [0x02920000, 0x02920fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x127ab000-0x13feffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
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
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] BRK [0x02921000, 0x02921fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13ffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13ffdfff]
[    0.000000] On node 0 totalpages: 81820
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 608 pages used for memmap
[    0.000000]   Normal zone: 77822 pages, LIFO batch:15
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
[    0.000000] e820: [mem 0x14000000-0xfffbffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 330 pages/cpu @d2117000 s1337792 r0 d13888 =
u1351680
[    0.000000] pcpu-alloc: s1337792 r0 d13888 u1351680 alloc=3D330*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-st1-03061911/next:master/.vmlinuz-0ffb2fe7b9c30082876fa3=
a17da018bf0632cf03-20140306200948-7-waimea branch=3Dnext/master BOOT_IMAGE=
=3D/kernel/i386-randconfig-st1-03061911/0ffb2fe7b9c30082876fa3a17da018bf063=
2cf03/vmlinuz-3.14.0-rc5-next-20140306-06952-g0ffb2fe
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 269440K/327280K available (11435K kernel code, 891K =
rwdata, 5812K rodata, 1776K init, 5676K bss, 57840K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6c000 - 0xfffff000   (1612 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xff9fe000   ( 690 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xc21b8000 - 0xc2374000   (1776 kB)
[    0.000000]       .data : 0xc1b2b039 - 0xc21b7f80   (6707 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1b2b039   (11436 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dd1c0a000 soft=3Dd1c0c000
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
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
[    0.000000] ------------------------
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:
[    0.000000]                      A-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:failed|failed|failed|faile=
d|  ok  |  ok  |failed|failed|failed|failed|failed|failed|

[    0.000000]                     double unlock:
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                   initialize held:
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  bad unlock order:
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:
[    0.000000]               recursive read-lock:             |            =
 |  ok  |  ok  |             |             |failed|failed|

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |failed|failed|

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |failed|failed|             |             |failed|failed|

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |failed|failed|             |             |failed|failed|

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:failed|failed|failed|fai=
led|  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:failed|failed|failed|fai=
led|  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:failed|failed|failed|faile=
d|  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:failed|failed|failed|faile=
d|  ok  |  ok  |

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

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                ww contexts mixing:
[    0.000000]                ww contexts mixing:failed|failed|  ok  |  ok =
 |

[    0.000000]              finishing ww context:
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                locking mismatches:
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                  EDEADLK handling:
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]            spinlock nest unlocked:
[    0.000000]            spinlock nest unlocked:  ok  |  ok  |

[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:
[    0.000000]                           context:failed|failed|  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:failed|failed|  ok  |  ok =
 |failed|failed|

[    0.000000]                             block:
[    0.000000]                             block:failed|failed|  ok  |  ok =
 |failed|failed|

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:failed|failed|  ok  |  ok =
 |failed|failed|

[    0.000000] --------------------------------------------------------
[    0.000000] --------------------------------------------------------
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] 141 out of 253 testcases failed, as expected. |
[    0.000000] ----------------------------------------------------
[    0.000000] ----------------------------------------------------
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] allocated 1048576 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] ODEBUG: 7 of 7 active objects replaced
[    0.000000] ODEBUG: 7 of 7 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3300.212 MHz processor
[    0.000000] tsc: Detected 3300.212 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.008819] Calibrating delay loop (skipped), value calculated using tim=
er frequency..=20
[    0.008819] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6600.42 BogoMIPS (lpj=3D13200848)
6600.42 BogoMIPS (lpj=3D13200848)
[    0.012534] pid_max: default: 32768 minimum: 301
[    0.012534] pid_max: default: 32768 minimum: 301
[    0.014088] Mount-cache hash table entries: 512
[    0.014088] Mount-cache hash table entries: 512
[    0.026326] Initializing cgroup subsys debug
[    0.026326] Initializing cgroup subsys debug
[    0.026704] Initializing cgroup subsys memory
[    0.026704] Initializing cgroup subsys memory
[    0.027197] Initializing cgroup subsys devices
[    0.027197] Initializing cgroup subsys devices
[    0.027498] Initializing cgroup subsys blkio
[    0.027498] Initializing cgroup subsys blkio
[    0.027747] Initializing cgroup subsys perf_event
[    0.027747] Initializing cgroup subsys perf_event
[    0.028132] Initializing cgroup subsys hugetlb
[    0.028132] Initializing cgroup subsys hugetlb
[    0.030491] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.030491] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.030491] tlb_flushall_shift: -1
[    0.030491] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.030491] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.030491] tlb_flushall_shift: -1
[    0.034625] Freeing SMP alternatives memory: 40K (c2374000 - c237e000)
[    0.034625] Freeing SMP alternatives memory: 40K (c2374000 - c237e000)
[    0.053379] Getting VERSION: 50011
[    0.053379] Getting VERSION: 50011
[    0.053617] Getting VERSION: 50011
[    0.053617] Getting VERSION: 50011
[    0.053824] Getting ID: 0
[    0.053824] Getting ID: 0
[    0.053995] Getting ID: f000000
[    0.053995] Getting ID: f000000
[    0.054165] Getting LVT0: 8700
[    0.054165] Getting LVT0: 8700
[    0.054317] Getting LVT1: 8400
[    0.054317] Getting LVT1: 8400
[    0.054496] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.054496] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.055077] enabled ExtINT on CPU#0
[    0.055077] enabled ExtINT on CPU#0
[    0.056630] ENABLING IO-APIC IRQs
[    0.056630] ENABLING IO-APIC IRQs
[    0.056840] init IO_APIC IRQs
[    0.056840] init IO_APIC IRQs
[    0.057054]  apic 0 pin 0 not connected
[    0.057054]  apic 0 pin 0 not connected
[    0.057860] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.057860] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.058540] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.058540] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.058932] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.058932] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.059334] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.059334] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.059720] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.059720] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.060000] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.060000]  apic 0 pin 16 not connected
[    0.060000]  apic 0 pin 16 not connected
[    0.060000]  apic 0 pin 17 not connected
[    0.060000]  apic 0 pin 17 not connected
[    0.060000]  apic 0 pin 18 not connected
[    0.060000]  apic 0 pin 18 not connected
[    0.060000]  apic 0 pin 19 not connected
[    0.060000]  apic 0 pin 19 not connected
[    0.060000]  apic 0 pin 20 not connected
[    0.060000]  apic 0 pin 20 not connected
[    0.060000]  apic 0 pin 21 not connected
[    0.060000]  apic 0 pin 21 not connected
[    0.060000]  apic 0 pin 22 not connected
[    0.060000]  apic 0 pin 22 not connected
[    0.060000]  apic 0 pin 23 not connected
[    0.060000]  apic 0 pin 23 not connected
[    0.060000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.060000] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.098264] smpboot: CPU0:=20
[    0.098264] smpboot: CPU0: AMD AMD QEMU Virtual CPU version 1.6.0QEMU Vi=
rtual CPU version 1.6.0 (fam: 06, model: 02 (fam: 06, model: 02, stepping: =
03)
, stepping: 03)
[    0.098927] Using local APIC timer interrupts.
[    0.098927] calibrating APIC timer ...
[    0.098927] Using local APIC timer interrupts.
[    0.098927] calibrating APIC timer ...
[    0.100000] ... lapic delta =3D 6249323
[    0.100000] ... lapic delta =3D 6249323
[    0.100000] ... PM-Timer delta =3D 357914
[    0.100000] ... PM-Timer delta =3D 357914
[    0.100000] ... PM-Timer result ok
[    0.100000] ... PM-Timer result ok
[    0.100000] ..... delta 6249323
[    0.100000] ..... delta 6249323
[    0.100000] ..... mult: 268406379
[    0.100000] ..... mult: 268406379
[    0.100000] ..... calibration result: 3999566
[    0.100000] ..... calibration result: 3999566
[    0.100000] ..... CPU clock speed is 3299.3013 MHz.
[    0.100000] ..... CPU clock speed is 3299.3013 MHz.
[    0.100000] ..... host bus clock speed is 999.3566 MHz.
[    0.100000] ..... host bus clock speed is 999.3566 MHz.
[    0.100000] Performance Events:=20
[    0.100000] Performance Events: Broken PMU hardware detected, using soft=
ware events only.
Broken PMU hardware detected, using software events only.
[    0.100000] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.100000] Failed to access perfctr msr (MSR c0010004 is 0)
[    0.114051] CPU 1 irqstacks, hard=3Dd1c86000 soft=3Dd1c90000
[    0.114051] CPU 1 irqstacks, hard=3Dd1c86000 soft=3Dd1c90000
[    0.114336] x86: Booting SMP configuration:
[    0.114336] x86: Booting SMP configuration:
[    0.114575] .... node  #0, CPUs: =20
[    0.114575] .... node  #0, CPUs:         #1 #1
[    0.012000] Initializing CPU#1
[    0.012000] masked ExtINT on CPU#1
[    0.012000] ------------[ cut here ]------------
[    0.012000] WARNING: CPU: 1 PID: 0 at arch/x86/kernel/cpu/amd.c:220 init=
_amd+0x2e2/0x5e6()
[    0.012000] WARNING: This combination of AMD processors is not suitable =
for SMP.
[    0.012000] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.14.0-rc5-next-20=
140306-06952-g0ffb2fe #4
[    0.012000]  00000000 00000000 d1c75f00 c1b203a5 d1c75f28 d1c75f18 c1031=
5ba c100da55
[    0.012000]  d1c75f54 d23a6a80 d23a6afc d1c75f30 c1031610 00000009 d1c75=
f28 c1f3ddef
[    0.012000]  d1c75f44 d1c75f64 c100da55 c1f3de35 000000dc c1f3ddef 01000=
800 00000000
[    0.012000] Call Trace:
[    0.012000]  [<c1b203a5>] dump_stack+0x48/0x60
[    0.012000]  [<c10315ba>] warn_slowpath_common+0x57/0x6e
[    0.012000]  [<c100da55>] ? init_amd+0x2e2/0x5e6
[    0.012000]  [<c1031610>] warn_slowpath_fmt+0x26/0x2a
[    0.012000]  [<c100da55>] init_amd+0x2e2/0x5e6
[    0.012000]  [<c100c50e>] identify_cpu+0x202/0x3b5
[    0.012000]  [<c100c6d2>] identify_secondary_cpu+0x11/0x18
[    0.012000]  [<c101c549>] smp_store_cpu_info+0x2d/0x31
[    0.012000]  [<c101cb95>] start_secondary+0x13e/0x233
[    0.012000] ---[ end trace 94f8acaebb1dc786 ]---
[    0.012000] Disabling lock debugging due to kernel taint
[    0.012000] calibrate_delay_direct() failed to get a good estimate for l=
oops_per_jiffy.
[    0.012000] Probably due to long platform interrupts. Consider using "lp=
j=3D" boot option.
[    0.261451] x86: Booted up 1 node, 2 CPUs
[    0.261451] x86: Booted up 1 node, 2 CPUs
[    0.261676] ----------------
[    0.261676] ----------------
[    0.261809] | NMI testsuite:
[    0.261809] | NMI testsuite:
[    0.261945] --------------------
[    0.261945] --------------------
[    0.262109]   remote IPI:
[    0.262109]   remote IPI:  ok  |  ok  |

[    0.280587]    local IPI:
[    0.280587]    local IPI:  ok  |  ok  |

[    0.304122] --------------------
[    0.304122] --------------------
[    0.304317] Good, all   2 testcases passed! |
[    0.304317] Good, all   2 testcases passed! |
[    0.304600] ---------------------------------
[    0.304600] ---------------------------------
[    0.304908] smpboot: Total of 2 processors activated (13092.58 BogoMIPS)
[    0.304908] smpboot: Total of 2 processors activated (13092.58 BogoMIPS)
[    0.309561] BUG: unable to handle kernel=20
[    0.309561] BUG: unable to handle kernel paging requestpaging request at=
 0feea000
 at 0feea000
[    0.309899] IP:
[    0.309899] IP: [<c10540d0>] load_balance+0x89/0x657
 [<c10540d0>] load_balance+0x89/0x657
[    0.310171] *pdpt =3D 0000000000000000=20
[    0.310171] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff53 *pde =
=3D f000ff53f000ff53=20

[    0.310527] Oops: 0002 [#1]=20
[    0.310527] Oops: 0002 [#1] SMP SMP=20

[    0.310925] CPU: 0 PID: 2 Comm: kthreadd Tainted: G S      W    3.14.0-r=
c5-next-20140306-06952-g0ffb2fe #4
[    0.310925] CPU: 0 PID: 2 Comm: kthreadd Tainted: G S      W    3.14.0-r=
c5-next-20140306-06952-g0ffb2fe #4
[    0.311311] task: d1c50db0 ti: d1c58000 task.ti: d1c58000
[    0.311311] task: d1c50db0 ti: d1c58000 task.ti: d1c58000
[    0.311740] EIP: 0060:[<c10540d0>] EFLAGS: 00000002 CPU: 0
[    0.311740] EIP: 0060:[<c10540d0>] EFLAGS: 00000002 CPU: 0
[    0.312000] EIP is at load_balance+0x89/0x657
[    0.312000] EIP is at load_balance+0x89/0x657
[    0.312000] EAX: d1c09900 EBX: 0feea000 ECX: 00000004 EDX: d225d200
[    0.312000] EAX: d1c09900 EBX: 0feea000 ECX: 00000004 EDX: d225d200
[    0.312000] ESI: c21b63e8 EDI: 0feea000 EBP: d1c59ed4 ESP: d1c59e58
[    0.312000] ESI: c21b63e8 EDI: 0feea000 EBP: d1c59ed4 ESP: d1c59e58
[    0.312000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.312000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.312000] CR0: 8005003b CR2: 0feea000 CR3: 02381000 CR4: 001006b0
[    0.312000] CR0: 8005003b CR2: 0feea000 CR3: 02381000 CR4: 001006b0
[    0.312000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    0.312000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    0.312000] DR6: 00000000 DR7: 00000000
[    0.312000] DR6: 00000000 DR7: 00000000
[    0.312000] Stack:
[    0.312000] Stack:
[    0.312000]  e754821a
[    0.312000]  e754821a 00000000 00000000 00000000 00000000 00000001 00000=
001 0feea000 0feea000 00000000 00000000 d225d780 d225d780 00000000 00000000

[    0.312000]  d1c59e84
[    0.312000]  d1c59e84 00000000 00000000 00000000 00000000 d1c03120 d1c03=
120 d1c09900 d1c09900 d1c09900 d1c09900 00000000 00000000 00000000 00000000

[    0.312000]  00000000
[    0.312000]  00000000 d225d200 d225d200 00000000 00000000 00000000 00000=
000 00000002 00000002 00000000 00000000 0feea000 0feea000 00000000 00000000

[    0.312000] Call Trace:
[    0.312000] Call Trace:
[    0.312000]  [<c1054a65>] pick_next_task_fair+0x1b6/0x2d7
[    0.312000]  [<c1054a65>] pick_next_task_fair+0x1b6/0x2d7
[    0.312000]  [<c1b25d46>] __schedule+0x22e/0x72a
[    0.312000]  [<c1b25d46>] __schedule+0x22e/0x72a
[    0.312000]  [<c1030ddd>] ? do_fork+0xcb/0x16f
[    0.312000]  [<c1030ddd>] ? do_fork+0xcb/0x16f
[    0.312000]  [<c104623a>] ? kthreadd+0x143/0x160
[    0.312000]  [<c104623a>] ? kthreadd+0x143/0x160
[    0.312000]  [<c1b2629c>] schedule+0x5a/0x5c
[    0.312000]  [<c1b2629c>] schedule+0x5a/0x5c
[    0.312000]  [<c10461d8>] kthreadd+0xe1/0x160
[    0.312000]  [<c10461d8>] kthreadd+0xe1/0x160
[    0.312000]  [<c1b2a0bb>] ret_from_kernel_thread+0x1b/0x30
[    0.312000]  [<c1b2a0bb>] ret_from_kernel_thread+0x1b/0x30
[    0.312000]  [<c10460f7>] ? kthread_stop+0x4b/0x4b
[    0.312000]  [<c10460f7>] ? kthread_stop+0x4b/0x4b
[    0.312000] Code:
[    0.312000] Code: 45 45 08 08 83 83 f8 f8 02 02 89 89 45 45 d4 d4 75 75 =
07 07 c7 c7 45 45 cc cc 00 00 00 00 00 00 00 00 a1 a1 88 88 6c 6c 1b 1b c2 =
c2 8b 8b 35 35 a4 a4 22 22 b3 b3 c1 c1 8b 8b 7d 7d 94 94 8d 8d 48 48 1f 1f =
8b 8b 45 45 b4 b4 c1 c1 e9 e9 05 05 c1 c1 e1 e1 02 02 <f3> <f3> a4 a4 8b 8b=
 7d 7d 08 08 8d 8d 04 04 b8 b8 89 89 45 45 ac ac ff ff 40 40 5c 5c b8 b8 00=
 00 32 32 37 37 c2 c2 89 89 45 45

[    0.312000] EIP: [<c10540d0>]=20
[    0.312000] EIP: [<c10540d0>] load_balance+0x89/0x657load_balance+0x89/0=
x657 SS:ESP 0068:d1c59e58
 SS:ESP 0068:d1c59e58
[    0.312000] CR2: 000000000feea000
[    0.312000] CR2: 000000000feea000
[    0.312000] ---[ end trace 94f8acaebb1dc787 ]---
[    0.312000] ---[ end trace 94f8acaebb1dc787 ]---
[    0.312000] note: kthreadd[2] exited with preempt_count 2
[    0.312000] note: kthreadd[2] exited with preempt_count 2
[    0.312000] BUG: unable to handle kernel=20
[    0.312000] BUG: unable to handle kernel paging requestpaging request at=
 10034000
 at 10034000
[    0.312000] IP:
[    0.312000] IP: [<c10540d0>] load_balance+0x89/0x657
 [<c10540d0>] load_balance+0x89/0x657
[    0.312000] *pdpt =3D 0000000000000000=20
[    0.312000] *pdpt =3D 0000000000000000 *pde =3D 00000000000003f8 *pde =
=3D 00000000000003f8=20

[    0.312000] Oops: 0002 [#2]=20
[    0.312000] Oops: 0002 [#2] SMP SMP=20

[    0.312000] CPU: 1 PID: 14 Comm: kthreadd Tainted: G S    D W    3.14.0-=
rc5-next-20140306-06952-g0ffb2fe #4
[    0.312000] CPU: 1 PID: 14 Comm: kthreadd Tainted: G S    D W    3.14.0-=
rc5-next-20140306-06952-g0ffb2fe #4
[    0.312000] task: d1c7c470 ti: d1c92000 task.ti: d1c92000
[    0.312000] task: d1c7c470 ti: d1c92000 task.ti: d1c92000
[    0.312000] EIP: 0060:[<c10540d0>] EFLAGS: 00000002 CPU: 1
[    0.312000] EIP: 0060:[<c10540d0>] EFLAGS: 00000002 CPU: 1
[    0.312000] EIP is at load_balance+0x89/0x657
[    0.312000] EIP is at load_balance+0x89/0x657
[    0.312000] EAX: d1c09a00 EBX: 10034000 ECX: 00000004 EDX: d23a7200
[    0.312000] EAX: d1c09a00 EBX: 10034000 ECX: 00000004 EDX: d23a7200
[    0.312000] ESI: c21b63e8 EDI: 10034000 EBP: d1c93e68 ESP: d1c93dec
[    0.312000] ESI: c21b63e8 EDI: 10034000 EBP: d1c93e68 ESP: d1c93dec
[    0.312000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.312000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.312000] CR0: 8005003b CR2: 10034000 CR3: 02381000 CR4: 001006b0
[    0.312000] CR0: 8005003b CR2: 10034000 CR3: 02381000 CR4: 001006b0
[    0.312000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    0.312000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    0.312000] DR6: 00000000 DR7: 00000000
[    0.312000] DR6: 00000000 DR7: 00000000
[    0.312000] Stack:
[    0.312000] Stack:
[    0.312000]  e8ab05d5
[    0.312000]  e8ab05d5 00000003 00000003 00000000 00000000 00000001 00000=
001 10034000 10034000 00000001 00000001 d23a7780 d23a7780 00000001 00000001

[    0.312000]  d1c93e18
[    0.312000]  d1c93e18 00000001 00000001 00000001 00000001 d1c03220 d1c03=
220 d1c09a00 d1c09a00 d1c09a00 d1c09a00 00000000 00000000 00000000 00000000

[    0.312000]  00000001
[    0.312000]  00000001 d23a7200 d23a7200 00000000 00000000 00000000 00000=
000 00000002 00000002 00000000 00000000 10034000 10034000 00000000 00000000

[    0.312000] Call Trace:
[    0.312000] Call Trace:
[    0.312000]  [<c1054a65>] pick_next_task_fair+0x1b6/0x2d7
[    0.312000]  [<c1054a65>] pick_next_task_fair+0x1b6/0x2d7
[    0.312000]  [<c1b25d46>] __schedule+0x22e/0x72a
[    0.312000]  [<c1b25d46>] __schedule+0x22e/0x72a
[    0.312000]  [<c101e042>] ? smp_apic_timer_interrupt+0x33/0x3d
[    0.312000]  [<c101e042>] ? smp_apic_timer_interrupt+0x33/0x3d
[    0.312000]  [<c1058b28>] ? complete+0x30/0x35
[    0.312000]  [<c1058b28>] ? complete+0x30/0x35
[    0.312000]  [<c1b290dc>] ? _raw_spin_unlock_irqrestore+0x24/0x33
[    0.312000]  [<c1b290dc>] ? _raw_spin_unlock_irqrestore+0x24/0x33
[    0.312000]  [<c10413b7>] ? process_scheduled_works+0x21/0x21
[    0.312000]  [<c10413b7>] ? process_scheduled_works+0x21/0x21
[    0.312000]  [<c1b2629c>] schedule+0x5a/0x5c
[    0.312000]  [<c1b2629c>] schedule+0x5a/0x5c
[    0.312000]  [<c1045db1>] kthread+0x8c/0xaa
[    0.312000]  [<c1045db1>] kthread+0x8c/0xaa
[    0.312000]  [<c1b2a0bb>] ret_from_kernel_thread+0x1b/0x30
[    0.312000]  [<c1b2a0bb>] ret_from_kernel_thread+0x1b/0x30
[    0.312000]  [<c1045d25>] ? __kthread_unpark+0x3a/0x3a
[    0.312000]  [<c1045d25>] ? __kthread_unpark+0x3a/0x3a
[    0.312000] Code:
[    0.312000] Code: 45 45 08 08 83 83 f8 f8 02 02 89 89 45 45 d4 d4 75 75 =
07 07 c7 c7 45 45 cc cc 00 00 00 00 00 00 00 00 a1 a1 88 88 6c 6c 1b 1b c2 =
c2 8b 8b 35 35 a4 a4 22 22 b3 b3 c1 c1 8b 8b 7d 7d 94 94 8d 8d 48 48 1f 1f =
8b 8b 45 45 b4 b4 c1 c1 e9 e9 05 05 c1 c1 e1 e1 02 02 <f3> <f3> a4 a4 8b 8b=
 7d 7d 08 08 8d 8d 04 04 b8 b8 89 89 45 45 ac ac ff ff 40 40 5c 5c b8 b8 00=
 00 32 32 37 37 c2 c2 89 89 45 45

[    0.312000] EIP: [<c10540d0>]=20
[    0.312000] EIP: [<c10540d0>] load_balance+0x89/0x657load_balance+0x89/0=
x657 SS:ESP 0068:d1c93dec
 SS:ESP 0068:d1c93dec
[    0.312000] CR2: 0000000010034000
[    0.312000] CR2: 0000000010034000
[    0.312000] ---[ end trace 94f8acaebb1dc788 ]---
[    0.312000] ---[ end trace 94f8acaebb1dc788 ]---
[    0.320000] BUG: unable to handle kernel paging request at 0feea000
[    0.320000] BUG: unable to handle kernel paging request at 0feea000
[    0.320000] IP: [<c10540d0>] load_balance+0x89/0x657
[    0.320000] IP: [<c10540d0>] load_balance+0x89/0x657
[    0.320000] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff53=20
[    0.320000] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff53=20
[    0.320000] Oops: 0002 [#3] SMP=20
[    0.320000] Oops: 0002 [#3] SMP=20
[    0.320000] CPU: 0 PID: 7 Comm: rcu_sched Tainted: G S    D W    3.14.0-=
rc5-next-20140306-06952-g0ffb2fe #4
[    0.320000] CPU: 0 PID: 7 Comm: rcu_sched Tainted: G S    D W    3.14.0-=
rc5-next-20140306-06952-g0ffb2fe #4
[    0.320000] task: d1c55220 ti: d1c6e000 task.ti: d1c6e000
[    0.320000] task: d1c55220 ti: d1c6e000 task.ti: d1c6e000
[    0.320000] EIP: 0060:[<c10540d0>] EFLAGS: 00000002 CPU: 0
[    0.320000] EIP: 0060:[<c10540d0>] EFLAGS: 00000002 CPU: 0
[    0.320000] EIP is at load_balance+0x89/0x657
[    0.320000] EIP is at load_balance+0x89/0x657
[    0.320000] EAX: d1c09900 EBX: 0feea000 ECX: 00000004 EDX: d225d200
[    0.320000] EAX: d1c09900 EBX: 0feea000 ECX: 00000004 EDX: d225d200
[    0.320000] ESI: c21b63e8 EDI: 0feea000 EBP: d1c6fdc4 ESP: d1c6fd48
[    0.320000] ESI: c21b63e8 EDI: 0feea000 EBP: d1c6fdc4 ESP: d1c6fd48
[    0.320000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.320000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.320000] CR0: 8005003b CR2: 0feea000 CR3: 02381000 CR4: 001006b0
[    0.320000] CR0: 8005003b CR2: 0feea000 CR3: 02381000 CR4: 001006b0
[    0.320000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    0.320000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    0.320000] DR6: 00000000 DR7: 00000000
[    0.320000] DR6: 00000000 DR7: 00000000
[    0.320000] Stack:
[    0.320000] Stack:
[    0.320000]  ea5750e8 00000000 00000000 00000001 0feea000 00000000 d225d=
780 00000000
[    0.320000]  ea5750e8 00000000 00000000 00000001 0feea000 00000000 d225d=
780 00000000
[    0.320000]  d1c6fd74 00000000 00000000 d1c03120 d1c09900 d1c09900 00000=
000 00000000
[    0.320000]  d1c6fd74 00000000 00000000 d1c03120 d1c09900 d1c09900 00000=
000 00000000
[    0.320000]  00000000 d225d200 00000000 00000000 00000002 00000000 0feea=
000 00000000
[    0.320000]  00000000 d225d200 00000000 00000000 00000002 00000000 0feea=
000 00000000
[    0.320000] Call Trace:
[    0.320000] Call Trace:
[    0.320000]  [<c1054a65>] pick_next_task_fair+0x1b6/0x2d7
[    0.320000]  [<c1054a65>] pick_next_task_fair+0x1b6/0x2d7
[    0.320000]  [<c1b25d46>] __schedule+0x22e/0x72a
[    0.320000]  [<c1b25d46>] __schedule+0x22e/0x72a
[    0.320000]  [<c133dee8>] ? debug_object_activate+0x57/0x12a
[    0.320000]  [<c133dee8>] ? debug_object_activate+0x57/0x12a
[    0.320000]  [<c133df7c>] ? debug_object_activate+0xeb/0x12a
[    0.320000]  [<c133df7c>] ? debug_object_activate+0xeb/0x12a
[    0.320000]  [<c1b2629c>] schedule+0x5a/0x5c
[    0.320000]  [<c1b2629c>] schedule+0x5a/0x5c
[    0.320000]  [<c1b25822>] schedule_timeout+0x112/0x13a
[    0.320000]  [<c1b25822>] schedule_timeout+0x112/0x13a
[    0.320000]  [<c10384b0>] ? cascade+0x5a/0x5a
[    0.320000]  [<c10384b0>] ? cascade+0x5a/0x5a
[    0.320000]  [<c10690eb>] rcu_gp_kthread+0x262/0x541
[    0.320000]  [<c10690eb>] rcu_gp_kthread+0x262/0x541
[    0.320000]  [<c10585f5>] ? __wake_up_common+0x59/0x59
[    0.320000]  [<c10585f5>] ? __wake_up_common+0x59/0x59
[    0.320000]  [<c1068e89>] ? note_gp_changes+0x62/0x62
[    0.320000]  [<c1068e89>] ? note_gp_changes+0x62/0x62
[    0.320000]  [<c1045dca>] kthread+0xa5/0xaa
[    0.320000]  [<c1045dca>] kthread+0xa5/0xaa
[    0.320000]  [<c1b2a0bb>] ret_from_kernel_thread+0x1b/0x30
[    0.320000]  [<c1b2a0bb>] ret_from_kernel_thread+0x1b/0x30
[    0.320000]  [<c1045d25>] ? __kthread_unpark+0x3a/0x3a
[    0.320000]  [<c1045d25>] ? __kthread_unpark+0x3a/0x3a
[    0.320000] Code: 45 08 83 f8 02 89 45 d4 75 07 c7 45 cc 00 00 00 00 a1 =
88 6c 1b c2 8b 35 a4 22 b3 c1 8b 7d 94 8d 48 1f 8b 45 b4 c1 e9 05 c1 e1 02 =
<f3> a4 8b 7d 08 8d 04 b8 89 45 ac ff 40 5c b8 00 32 37 c2 89 45
[    0.320000] Code: 45 08 83 f8 02 89 45 d4 75 07 c7 45 cc 00 00 00 00 a1 =
88 6c 1b c2 8b 35 a4 22 b3 c1 8b 7d 94 8d 48 1f 8b 45 b4 c1 e9 05 c1 e1 02 =
<f3> a4 8b 7d 08 8d 04 b8 89 45 ac ff 40 5c b8 00 32 37 c2 89 45
[    0.320000] EIP: [<c10540d0>] load_balance+0x89/0x657 SS:ESP 0068:d1c6fd=
48
[    0.320000] EIP: [<c10540d0>] load_balance+0x89/0x657 SS:ESP 0068:d1c6fd=
48
[    0.320000] CR2: 000000000feea000
[    0.320000] CR2: 000000000feea000
[    0.320000] ---[ end trace 94f8acaebb1dc789 ]---
[    0.320000] ---[ end trace 94f8acaebb1dc789 ]---
[    0.320000] note: rcu_sched[7] exited with preempt_count 2
[    0.320000] note: rcu_sched[7] exited with preempt_count 2
[    0.312000] note: kthreadd[14] exited with preempt_count 2
[    0.312000] note: kthreadd[14] exited with preempt_count 2

Elapsed time: 5
qemu-system-x86_64 -cpu qemu64,+smep,+smap -kernel /kernel/i386-randconfig-=
st1-03061911/0ffb2fe7b9c30082876fa3a17da018bf0632cf03/vmlinuz-3.14.0-rc5-ne=
xt-20140306-06952-g0ffb2fe -append 'hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-st1-03061911/next:master/.vmlinuz-0ffb2fe7b9c30082876fa3=
a17da018bf0632cf03-20140306200948-7-waimea branch=3Dnext/master BOOT_IMAGE=
=3D/kernel/i386-randconfig-st1-03061911/0ffb2fe7b9c30082876fa3a17da018bf063=
2cf03/vmlinuz-3.14.0-rc5-next-20140306-06952-g0ffb2fe'  -initrd /kernel-tes=
ts/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De10=
00 -net user,vlan=3D1,hostfwd=3Dtcp::10096-:22 -boot order=3Dnc -no-reboot =
-watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk=
0-quantal-waimea-13,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/=
disk1-quantal-waimea-13,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3D=
KVM/disk2-quantal-waimea-13,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABE=
L=3DKVM/disk3-quantal-waimea-13,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/=
LABEL=3DKVM/disk4-quantal-waimea-13,media=3Ddisk,if=3Dvirtio -drive file=3D=
/fs/LABEL=3DKVM/disk5-quantal-waimea-13,media=3Ddisk,if=3Dvirtio -pidfile /=
dev/shm/kboot/pid-quantal-waimea-13 -serial file:/dev/shm/kboot/serial-quan=
tal-waimea-13 -daemonize -display none -monitor null=20

--yVhtmJPUSI46BTXb
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-st1-03061911-0ffb2fe7b9c30082876fa3a17da018bf0632cf03-schedule+-x-91080.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDA5ZGUxOTIyNDJkODZlZGU0NDkxNDZhYzQyM2VmZmNhNTNiYzE4MTAK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDEt
MDMwNjE5MTEvbmV4dDptYXN0ZXI6MDlkZTE5MjI0MmQ4NmVkZTQ0OTE0NmFjNDIzZWZmY2E1
M2JjMTgxMDpiaXNlY3QtbGludXgzCgoyMDE0LTAzLTA2LTIyOjM1OjU4IDA5ZGUxOTIyNDJk
ODZlZGU0NDkxNDZhYzQyM2VmZmNhNTNiYzE4MTAgY29tcGlsaW5nCjEyMCByZWFsICAyMDcx
IHVzZXIgIDE3OSBzeXMgIDE4NjUuODglIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2
MTkxMQoKMjAxNC0wMy0wNi0yMjozODoxOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAt
cmM1LTA2NDk0LWcwOWRlMTkyLi4uCTMuCTUJNgkxNy4JMTgJMjAgU1VDQ0VTUwoKYmlzZWN0
OiBnb29kIGNvbW1pdCAwOWRlMTkyMjQyZDg2ZWRlNDQ5MTQ2YWM0MjNlZmZjYTUzYmMxODEw
CmdpdCBiaXNlY3Qgc3RhcnQgMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMy
Y2YwMyAwOWRlMTkyMjQyZDg2ZWRlNDQ5MTQ2YWM0MjNlZmZjYTUzYmMxODEwIC0tCi9jL2tl
cm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgIjBmZmIyZmU3YjljMzAwODI4NzZm
YTNhMTdkYTAxOGJmMDYzMmNmMDMiLCAiLWciLCAiMDlkZTE5MjI0MmQ4NmVkZTQ0OTE0NmFj
NDIzZWZmY2E1M2JjMTgxMCIsICIvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIiwgIi9rZXJuZWwtdGVzdHMvbGludXgzL29iai1iaXNlY3QiXQpCaXNlY3Rp
bmc6IDQ1OCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBz
dGVwcykKWzQzOWNkZTFmM2Q4MjMwZjg1OGMwYTU1OTAyMzgxZDI0Y2Q3YTJkZjJdIE1lcmdl
IGJyYW5jaCAnYWtwbS9tYXN0ZXInCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10
ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4My9vYmotYmlzZWN0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3QxLTAz
MDYxOTExL25leHQ6bWFzdGVyOjQzOWNkZTFmM2Q4MjMwZjg1OGMwYTU1OTAyMzgxZDI0Y2Q3
YTJkZjI6YmlzZWN0LWxpbnV4MwoKMjAxNC0wMy0wNi0yMjo0Mzo1MCA0MzljZGUxZjNkODIz
MGY4NThjMGE1NTkwMjM4MWQyNGNkN2EyZGYyIGNvbXBpbGluZwoxMTkgcmVhbCAgMjA4MCB1
c2VyICAxODQgc3lzICAxODkwLjUwJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5
MTEKCjIwMTQtMDMtMDYtMjI6NDY6MDYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJj
NS0wNjk0OC1nNDM5Y2RlMS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLiBURVNUIEZBSUxVUkUK
WyAgICAwLjEyNTMzN10gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tClsgICAg
MC4xMjYwNTFdIHNtcGJvb3Q6IFRvdGFsIG9mIDIgcHJvY2Vzc29ycyBhY3RpdmF0ZWQgKDk5
NzUuNjcgQm9nb01JUFMpClsgICAgMC4xMjYwNTFdIHNtcGJvb3Q6IFRvdGFsIG9mIDIgcHJv
Y2Vzc29ycyBhY3RpdmF0ZWQgKDk5NzUuNjcgQm9nb01JUFMpClsgICAgMC4xMjc0NTldIEJV
RzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0
MS0wMzA2MTkxMS80MzljZGUxZjNkODIzMGY4NThjMGE1NTkwMjM4MWQyNGNkN2EyZGYyL2Rt
ZXNnLXF1YW50YWwtaXZ5dG93bjItMToyMDE0MDMwNjIyNTc0NjppMzg2LXJhbmRjb25maWct
c3QxLTAzMDYxOTExOjMuMTQuMC1yYzUtMDY5NDgtZzQzOWNkZTE6MzEKMDoxOjEgYWxsX2dv
b2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMDYgMjI6NTg6MDcgUkVQRUFU
IENPVU5UOiAyMCAgIyAva2VybmVsLXRlc3RzL2xpbnV4My9vYmotYmlzZWN0Ly5yZXBlYXQb
WzBtCgpCaXNlY3Rpbmc6IDQ1NCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgOSBzdGVwcykKW2NlMzQ3NzhlYjRkOWZhMGFhYWVhZTc2YzEwNjgwMjZlZTUy
NTVmZDddIE1lcmdlIGJyYW5jaCAnYWtwbS1jdXJyZW50L2N1cnJlbnQnCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3Rz
L2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExL25leHQ6bWFzdGVyOmNlMzQ3NzhlYjRkOWZh
MGFhYWVhZTc2YzEwNjgwMjZlZTUyNTVmZDc6YmlzZWN0LWxpbnV4MwoKMjAxNC0wMy0wNi0y
Mjo1ODowOCBjZTM0Nzc4ZWI0ZDlmYTBhYWFlYWU3NmMxMDY4MDI2ZWU1MjU1ZmQ3IGNvbXBp
bGluZwoxMTggcmVhbCAgMjA4OCB1c2VyICAxNzcgc3lzICAxOTEzLjgyJSBjcHUgCWkzODYt
cmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEKCjIwMTQtMDMtMDYtMjM6MDA6MjAgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wNjg5My1nY2UzNDc3OC4uLi4uLgk4CTE4Li4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTE5CTIwIFNVQ0NFU1MKCkJpc2VjdGluZzog
NTUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMp
ClsxMTczMTQ0NjFlODJhZGFiYjZiNzhkY2IwMzI1OWRhNzViNTA4MzNiXSBtbTogZG9uJ3Qg
aW1wbGljdGx5IGluY2x1ZGUgbGludXgvbW0uaCBpbiBsaW51eC9zY2hlZC5oCnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRl
c3RzL2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExL25leHQ6bWFzdGVyOjExNzMxNDQ2MWU4
MmFkYWJiNmI3OGRjYjAzMjU5ZGE3NWI1MDgzM2I6YmlzZWN0LWxpbnV4MwoKMjAxNC0wMy0w
Ni0yMzoyMTo1MSAxMTczMTQ0NjFlODJhZGFiYjZiNzhkY2IwMzI1OWRhNzViNTA4MzNiIGNv
bXBpbGluZwoxMDAgcmVhbCAgMTgyMCB1c2VyICAxNTYgc3lzICAxOTY5LjA5JSBjcHUgCWkz
ODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEKCjIwMTQtMDMtMDYtMjM6MjM6NDMgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wNjg5NC1nMTE3MzE0NC4uLi4JMwk1CTEzCTE5
CTIwIFNVQ0NFU1MKCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIGJyYW5jaCAn
YWtwbS9tYXN0ZXInCmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QK
bGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBzdGFydCA0MzljZGUxZjNkODIzMGY4NThjMGE1
NTkwMjM4MWQyNGNkN2EyZGYyIDExNzMxNDQ2MWU4MmFkYWJiNmI3OGRjYjAzMjU5ZGE3NWI1
MDgzM2IgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMTE3MzE0NC4uLiBtbTogZG9u
J3QgaW1wbGljdGx5IGluY2x1ZGUgbGludXgvbW0uaCBpbiBsaW51eC9zY2hlZC5oCkhFQUQg
aXMgbm93IGF0IDA4ZDc2NzYuLi4gTWVyZ2UgYnJhbmNoICdmb3ItbGludXMnIG9mIGdpdDov
L2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC92aXJvL3NpZ25hbApC
aXNlY3Rpbmc6IDI2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSA1IHN0ZXBzKQpbOWQ1OGNmN2EzODhjMWI0YTA2Y2IzMzU5ODBlYjFiYjEzNTJiYTg3Nl0g
c2NoZWR1bGVyOiByZXBsYWNlIF9fZ2V0X2NwdV92YXIgd2l0aCB0aGlzX2NwdV9wdHIKbGlu
ZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0
LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4My9vYmotYmlzZWN0CnJ1bm5p
bmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVs
LXRlc3RzL2xpbnV4My9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVl
L2t2bS9pMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExL25leHQ6bWFzdGVyOjlkNThjZjdh
Mzg4YzFiNGEwNmNiMzM1OTgwZWIxYmIxMzUyYmE4NzY6YmlzZWN0LWxpbnV4MwoKMjAxNC0w
My0wNi0yMzoyODozMiA5ZDU4Y2Y3YTM4OGMxYjRhMDZjYjMzNTk4MGViMWJiMTM1MmJhODc2
IGNvbXBpbGluZwoxMjQgcmVhbCAgMjA3MiB1c2VyICAxNzggc3lzICAxODA0Ljc2JSBjcHUg
CWkzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEKCjIwMTQtMDMtMDYtMjM6MzA6NTkgZGV0
ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wNjkyMS1nOWQ1OGNmNy4uLi4uLi4uIFRF
U1QgRkFJTFVSRQpbICAgIDAuMTI1Mzk5XSAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0KWyAgICAwLjEyNjEzMF0gc21wYm9vdDogVG90YWwgb2YgMiBwcm9jZXNzb3JzIGFj
dGl2YXRlZCAoOTk3NS42NyBCb2dvTUlQUykKWyAgICAwLjEyNjEzMF0gc21wYm9vdDogVG90
YWwgb2YgMiBwcm9jZXNzb3JzIGFjdGl2YXRlZCAoOTk3NS42NyBCb2dvTUlQUykKWyAgICAw
LjEyNzU3M10gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCAKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctc3QxLTAzMDYxOTExLzlkNThjZjdhMzg4YzFiNGEwNmNiMzM1OTgwZWIxYmIx
MzUyYmE4NzYvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi05OjIwMTQwMzA2MjMzNDI1OmkzODYt
cmFuZGNvbmZpZy1zdDEtMDMwNjE5MTE6My4xNC4wLXJjNS0wNjkyMS1nOWQ1OGNmNzozNAov
a2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEvOWQ1OGNmN2EzODhjMWI0YTA2
Y2IzMzU5ODBlYjFiYjEzNTJiYTg3Ni9kbWVzZy15b2N0by1pdnl0b3duMi0xNDoyMDE0MDMw
NjIzMzQyODppMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExOjMuMTQuMC1yYzUtMDY5MjEt
ZzlkNThjZjc6MzQKMDoyOjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIw
MTQtMDMtMDYgMjM6MzU6MDQgUkVQRUFUIENPVU5UOiAyMCAgIyAva2VybmVsLXRlc3RzL2xp
bnV4My9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDEzIHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbYjJmZjJjZmViYWQ5
MmJlYmZjYTI4YmFkNjUwMDQ1ODIxZWQyNzBjNF0gdHJhY2luZzogcmVwbGFjZSBfX2dldF9j
cHVfdmFyIHVzZXMgd2l0aCB0aGlzX2NwdV9wdHIKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgzL29iai1i
aXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZp
Zy1zdDEtMDMwNjE5MTEvbmV4dDptYXN0ZXI6YjJmZjJjZmViYWQ5MmJlYmZjYTI4YmFkNjUw
MDQ1ODIxZWQyNzBjNDpiaXNlY3QtbGludXgzCgoyMDE0LTAzLTA2LTIzOjM1OjI0IGIyZmYy
Y2ZlYmFkOTJiZWJmY2EyOGJhZDY1MDA0NTgyMWVkMjcwYzQgY29tcGlsaW5nCjY0NCByZWFs
ICAyMTIzIHVzZXIgIDE2MyBzeXMgIDM1NS4wMCUgY3B1IAlpMzg2LXJhbmRjb25maWctc3Qx
LTAzMDYxOTExCgoyMDE0LTAzLTA2LTIzOjQ4OjAxIGRldGVjdGluZyBib290IHN0YXRlIDMu
MTQuMC1yYzUtMDY5MDctZ2IyZmYyY2YuLi4uLi4uLi4uLi4uLi4uLi4uLgkxCTIuCTUuLi4u
Li4uLi4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDYgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMpCltlZmNkMzhjM2I1MDBhYjY3NTkzZTQ1
MTRlZDdlY2VjZjJlYzU1MGY1XSBkcml2ZXJzL2Nsb2Nrc291cmNlOiByZXBsYWNlIF9fZ2V0
X2NwdV92YXIgdXNlZCBmb3IgYWRkcmVzcyBjYWxjdWxhdGlvbgpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51
eDMvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLXN0MS0wMzA2MTkxMS9uZXh0Om1hc3RlcjplZmNkMzhjM2I1MDBhYjY3NTkz
ZTQ1MTRlZDdlY2VjZjJlYzU1MGY1OmJpc2VjdC1saW51eDMKCjIwMTQtMDMtMDctMDA6MDY6
MDMgZWZjZDM4YzNiNTAwYWI2NzU5M2U0NTE0ZWQ3ZWNlY2YyZWM1NTBmNSBjb21waWxpbmcK
MTIwIHJlYWwgIDIwNzEgdXNlciAgMTY2IHN5cyAgMTg1OC4xMSUgY3B1IAlpMzg2LXJhbmRj
b25maWctc3QxLTAzMDYxOTExCgoyMDE0LTAzLTA3LTAwOjA4OjIxIGRldGVjdGluZyBib290
IHN0YXRlIDMuMTQuMC1yYzUtMDY5MTQtZ2VmY2QzOGMuLi4JMwkxMC4JMTEJMTQJMTcJMTkJ
MjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiAzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSAyIHN0ZXBzKQpbMjIyMTUyYTEwZTI5OGQ3NzBhMTg2Yjg3MTE2MzU1
M2MwNjJkNGE2Zl0gZHJpdmVycy9uZXQvZXRoZXJuZXQvdGlsZTogcmVwbGFjZSBfX2dldF9j
cHVfdmFyIHVzZXMgZm9yIGFkZHJlc3MgY2FsY3VsYXRpb24KcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgz
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1zdDEtMDMwNjE5MTEvbmV4dDptYXN0ZXI6MjIyMTUyYTEwZTI5OGQ3NzBhMTg2
Yjg3MTE2MzU1M2MwNjJkNGE2ZjpiaXNlY3QtbGludXgzCgoyMDE0LTAzLTA3LTAwOjEzOjUy
IDIyMjE1MmExMGUyOThkNzcwYTE4NmI4NzExNjM1NTNjMDYyZDRhNmYgY29tcGlsaW5nCjIw
IHJlYWwgIDQxIHVzZXIgIDYgc3lzICAyMzQuMjUlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXN0
MS0wMzA2MTkxMQoKMjAxNC0wMy0wNy0wMDoxNDoyNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjE0LjAtcmM1LTA2OTE3LWcyMjIxNTJhMS4uLi4JMwk1CTE3CTIwIFNVQ0NFU1MKCkJpc2Vj
dGluZzogMSByZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxIHN0
ZXApClszNjA4NmE1NjlhNjdjZDMxNDgwMWIwYzBkOWFhZGYzMDA4YjU1MDRiXSB0aWxlZ3g6
IGFub3RoZXIgY2FzZSBvZiBnZXRfY3B1X3ZhcgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDMvb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LXN0MS0wMzA2MTkxMS9uZXh0Om1hc3RlcjozNjA4NmE1NjlhNjdjZDMxNDgwMWIwYzBkOWFh
ZGYzMDA4YjU1MDRiOmJpc2VjdC1saW51eDMKCjIwMTQtMDMtMDctMDA6MTg6MzEgMzYwODZh
NTY5YTY3Y2QzMTQ4MDFiMGMwZDlhYWRmMzAwOGI1NTA0YiBjb21waWxpbmcKMTIyIHJlYWwg
IDQyIHVzZXIgIDUgc3lzICAzOS4xOSUgY3B1IAlpMzg2LXJhbmRjb25maWctc3QxLTAzMDYx
OTExCgoyMDE0LTAzLTA3LTAwOjIxOjQzIGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1y
YzUtMDY5MTktZzM2MDg2YTUuLi4uLi4JMgk0CTExCTEyLi4uLi4uLi4uLi4uLi4uLgkxMy4u
Li4uLi4uLgkxNy4JMTguLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDAgcmV2aXNpb25zIGxl
ZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAgc3RlcHMpCls3NmIxZTQ0ZTk4YTVk
ZmZiMzJkOTUwOTUyNjBlYmJkMzJmYjA2ZmY3XSB0aW1lOiByZXBsYWNlIF9fZ2V0X2NwdV92
YXIgdXNlcwpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDMvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMS9uZXh0Om1h
c3Rlcjo3NmIxZTQ0ZTk4YTVkZmZiMzJkOTUwOTUyNjBlYmJkMzJmYjA2ZmY3OmJpc2VjdC1s
aW51eDMKCjIwMTQtMDMtMDctMDA6NDI6NDYgNzZiMWU0NGU5OGE1ZGZmYjMyZDk1MDk1MjYw
ZWJiZDMyZmIwNmZmNyBjb21waWxpbmcKMjg2IHJlYWwgIDQ0IHVzZXIgIDUgc3lzICAxNy42
OCUgY3B1IAlpMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExCgoyMDE0LTAzLTA3LTAwOjQ4
OjI0IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUtMDY5MjAtZzc2YjFlNDQuLi4u
LgkyCTYJNwk5Li4JMTAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uCTIwIFNVQ0NFU1MKCjlkNThjZjdhMzg4YzFiNGEwNmNiMzM1OTgwZWIxYmIxMzUyYmE4
NzYgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IDlkNThjZjdhMzg4YzFiNGEwNmNi
MzM1OTgwZWIxYmIxMzUyYmE4NzYKQXV0aG9yOiBDaHJpc3RvcGggTGFtZXRlciA8Y2xAbGlu
dXguY29tPgpEYXRlOiAgIFRodSBNYXIgNiAxMTowNToyNSAyMDE0ICsxMTAwCgogICAgc2No
ZWR1bGVyOiByZXBsYWNlIF9fZ2V0X2NwdV92YXIgd2l0aCB0aGlzX2NwdV9wdHIKICAgIAog
ICAgQ29udmVydCBhbGwgdXNlcyBvZiBfX2dldF9jcHVfdmFyIGZvciBhZGRyZXNzIGNhbGN1
bGF0aW9uIHRvIHVzZQogICAgdGhpc19jcHVfcHRyIGluc3RlYWQuCiAgICAKICAgIFNpZ25l
ZC1vZmYtYnk6IENocmlzdG9waCBMYW1ldGVyIDxjbEBsaW51eC5jb20+CiAgICBBY2tlZC1i
eTogSW5nbyBNb2xuYXIgPG1pbmdvQGtlcm5lbC5vcmc+CiAgICBDYzogUGV0ZXIgWmlqbHN0
cmEgPHBldGVyekBpbmZyYWRlYWQub3JnPgogICAgQ2M6IFRlanVuIEhlbyA8dGpAa2VybmVs
Lm9yZz4KICAgIFNpZ25lZC1vZmYtYnk6IEFuZHJldyBNb3J0b24gPGFrcG1AbGludXgtZm91
bmRhdGlvbi5vcmc+Cgo6MDQwMDAwIDA0MDAwMCBiN2ExNDQ0Y2E3YjZjNTIyOGMxN2RjY2Mz
ZTk4Njk2Yzk3ZWViMzhkIDRmMTQ3YjEwMGZmNzA1YTk0OTY3MGY4MjkyN2ZhMjdlMDQ1ZmM1
MzUgTQlpbmNsdWRlCjowNDAwMDAgMDQwMDAwIDg0YTc1MTNhMWUwYmNiMDQ2NDM0ZDg0ZjY5
M2I1OTZlNTZjYjMwZTEgMzI2OGEyZWIyMGQ1ODBkNzFmZTUyYjU1YWRhYzdjNjU0Yjc1YTQx
MiBNCWtlcm5lbApiaXNlY3QgcnVuIHN1Y2Nlc3MKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEvbmV4dDptYXN0ZXI6NzZi
MWU0NGU5OGE1ZGZmYjMyZDk1MDk1MjYwZWJiZDMyZmIwNmZmNzpiaXNlY3QtbGludXgzCgoy
MDE0LTAzLTA3LTAyOjEwOjI3IDc2YjFlNDRlOThhNWRmZmIzMmQ5NTA5NTI2MGViYmQzMmZi
MDZmZjcgcmV1c2UgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExLzc2YjFl
NDRlOThhNWRmZmIzMmQ5NTA5NTI2MGViYmQzMmZiMDZmZjcvdm1saW51ei0zLjE0LjAtcmM1
LTA2OTIwLWc3NmIxZTQ0CgoyMDE0LTAzLTA3LTAyOjEwOjI3IGRldGVjdGluZyBib290IHN0
YXRlIC4uLgkxCTUJMTAJMTgJMjUuLi4uLi4uLgkzMwk0Nwk1MAk1OAk1OS4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4JNjAgU1VDQ0VTUwoKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEvbmV4dDptYXN0ZXI6MGZmYjJm
ZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMzpiaXNlY3QtbGludXgzCiBURVNU
IEZBSUxVUkUKWyAgICAwLjE4MjQ0M10gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tClsgICAgMC4xODM4MTRdIHNtcGJvb3Q6IFRvdGFsIG9mIDIgcHJvY2Vzc29ycyBhY3Rp
dmF0ZWQgKDExNTcyLjA3IEJvZ29NSVBTKQpbICAgIDAuMTgzODE0XSBzbXBib290OiBUb3Rh
bCBvZiAyIHByb2Nlc3NvcnMgYWN0aXZhdGVkICgxMTU3Mi4wNyBCb2dvTUlQUykKWyAgICAw
LjE4NDY3MF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCAKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctc3QxLTAzMDYxOTExLzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJm
MDYzMmNmMDMvZG1lc2ctcXVhbnRhbC13YWltZWEtMTM6MjAxNDAzMDYyMDEyNDE6aTM4Ni1y
YW5kY29uZmlnLXN0MS0wMzA2MTkxMTozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTIt
ZzBmZmIyZmU6NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEvMGZmYjJm
ZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0by1pdnl0b3du
Mi0xNDoyMDE0MDMwNjIyMzYyNTppMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExOjMuMTQu
MC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZmYjJmZTo0Ci9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXN0MS0wMzA2MTkxMS8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2
MzJjZjAzL2RtZXNnLXlvY3RvLWxrcC1zdDAxLTY6MjAxNDAzMDYyMDEyMTE6aTM4Ni1yYW5k
Y29uZmlnLXN0MS0wMzA2MTkxMTozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBm
ZmIyZmU6NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEvMGZmYjJmZTdi
OWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy1xdWFudGFsLWlubi00MDoy
MDE0MDMwNjIwMTM0NjppMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExOjoKL2tlcm5lbC9p
Mzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExLzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdk
YTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8taXZ5dG93bjItMjg6MjAxNDAzMDYyMjM2MjA6
aTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMTozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYt
MDY5NTItZzBmZmIyZmU6NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEv
MGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0by14
aWFuLTU6MjAxNDAzMDYyMDExMDk6aTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMTozLjE0
LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6NAova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1zdDEtMDMwNjE5MTEvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYw
NjMyY2YwMy9kbWVzZy15b2N0by14aWFuLTM2OjIwMTQwMzA2MjAxMTUzOmkzODYtcmFuZGNv
bmZpZy1zdDEtMDMwNjE5MTE6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZi
MmZlOjQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExLzBmZmIyZmU3Yjlj
MzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2ctcXVhbnRhbC1hdGhlbnMtNDU6
MjAxNDAzMDYyMDE0NDM6aTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMTozLjE0LjAtcmM1
LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6NAova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1zdDEtMDMwNjE5MTEvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2Yw
My9kbWVzZy1xdWFudGFsLXJvYW0tMzQ6MjAxNDAzMDYyMDExNTY6aTM4Ni1yYW5kY29uZmln
LXN0MS0wMzA2MTkxMTozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6
NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEvMGZmYjJmZTdiOWMzMDA4
Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy1xdWFudGFsLXJvYW0tMTM6MjAxNDAz
MDYyMjM3MTA6aTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMTozLjE0LjAtcmM1LW5leHQt
MjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDEt
MDMwNjE5MTEvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVz
Zy1xdWFudGFsLWl2eXRvd24yLTIyOjIwMTQwMzA2MjIzNTM3OmkzODYtcmFuZGNvbmZpZy1z
dDEtMDMwNjE5MTE6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlOjQK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExLzBmZmIyZmU3YjljMzAwODI4
NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8taXZ5dG93bjItMjk6MjAxNDAz
MDYyMjM2MTg6aTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMTozLjE0LjAtcmM1LW5leHQt
MjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDEt
MDMwNjE5MTEvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVz
Zy15b2N0by1pdnl0b3duMi0xOToyMDE0MDMwNjIyMzYxODppMzg2LXJhbmRjb25maWctc3Qx
LTAzMDYxOTExOjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZmYjJmZTo0Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMS8wZmZiMmZlN2I5YzMwMDgyODc2
ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXlvY3RvLWlubi0yMzoyMDE0MDMwNjIwMTEx
MjppMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExOjoKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctc3QxLTAzMDYxOTExLzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNm
MDMvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0yMjoyMDE0MDMwNjIyMzU0NzppMzg2LXJhbmRj
b25maWctc3QxLTAzMDYxOTExOjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZm
YjJmZTo0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMS8wZmZiMmZlN2I5
YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXlvY3RvLWl2eXRvd24yLTE5
OjIwMTQwMzA2MjIzNjI3OmkzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTE6My4xNC4wLXJj
NS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlOjQKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctc3QxLTAzMDYxOTExLzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNm
MDMvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xODoyMDE0MDMwNjIyMzYyNjppMzg2LXJhbmRj
b25maWctc3QxLTAzMDYxOTExOjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZm
YjJmZTo0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMS8wZmZiMmZlN2I5
YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXlvY3RvLWl2eXRvd24yLTI5
OjIwMTQwMzA2MjIzNjI4OmkzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTE6My4xNC4wLXJj
NS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlOjQKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctc3QxLTAzMDYxOTExLzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNm
MDMvZG1lc2ctcXVhbnRhbC14aWFuLTc6MjAxNDAzMDYyMDExMjM6aTM4Ni1yYW5kY29uZmln
LXN0MS0wMzA2MTkxMTozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6
NAowOjE5OjE5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpbZGV0YWNoZWQgSEVBRCAz
Zjg3N2U2XSBSZXZlcnQgInNjaGVkdWxlcjogcmVwbGFjZSBfX2dldF9jcHVfdmFyIHdpdGgg
dGhpc19jcHVfcHRyIgogQ29tbWl0dGVyOiBXdSBGZW5nZ3VhbmcgPGtidWlsZEBiZWU+Cllv
dXIgbmFtZSBhbmQgZW1haWwgYWRkcmVzcyB3ZXJlIGNvbmZpZ3VyZWQgYXV0b21hdGljYWxs
eSBiYXNlZApvbiB5b3VyIHVzZXJuYW1lIGFuZCBob3N0bmFtZS4gUGxlYXNlIGNoZWNrIHRo
YXQgdGhleSBhcmUgYWNjdXJhdGUuCllvdSBjYW4gc3VwcHJlc3MgdGhpcyBtZXNzYWdlIGJ5
IHNldHRpbmcgdGhlbSBleHBsaWNpdGx5OgoKICAgIGdpdCBjb25maWcgLS1nbG9iYWwgdXNl
ci5uYW1lICJZb3VyIE5hbWUiCiAgICBnaXQgY29uZmlnIC0tZ2xvYmFsIHVzZXIuZW1haWwg
eW91QGV4YW1wbGUuY29tCgpBZnRlciBkb2luZyB0aGlzLCB5b3UgbWF5IGZpeCB0aGUgaWRl
bnRpdHkgdXNlZCBmb3IgdGhpcyBjb21taXQgd2l0aDoKCiAgICBnaXQgY29tbWl0IC0tYW1l
bmQgLS1yZXNldC1hdXRob3IKCiA4IGZpbGVzIGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKyks
IDIyIGRlbGV0aW9ucygtKQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4
Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMS9uZXh0Om1hc3RlcjozZjg3N2U2YTUyM2M0NWEz
M2NlOGVhNzM4MGYxZjMyZGRhN2Q4MTM3OmJpc2VjdC1saW51eDMKCjIwMTQtMDMtMDctMDI6
MzQ6MDIgM2Y4NzdlNmE1MjNjNDVhMzNjZThlYTczODBmMWYzMmRkYTdkODEzNyBjb21waWxp
bmcKCjIwMTQtMDMtMDctMDI6MzU6MDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJj
NS1uZXh0LTIwMTQwMzA2LTAwMDAxLWczZjg3N2U2Li4uLi4uCTEJMwkzNQk0Nwk1Mgk1Mwk1
NQk1Ngk1Ny4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgk1OC4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtMjAxNC0wMy0wNyAwNTozMDoxOSBhZGRfdG9f
cnVuX3F1ZXVlIDIbWzBtCi4uLi4uLi4uLgk2MCBTVUNDRVNTCgoKPT09PT09PT09IHVwc3Ry
ZWFtID09PT09PT09PQpXYXJuaW5nOiB5b3UgYXJlIGxlYXZpbmcgMSBjb21taXQgYmVoaW5k
LCBub3QgY29ubmVjdGVkIHRvCmFueSBvZiB5b3VyIGJyYW5jaGVzOgoKICAzZjg3N2U2IFJl
dmVydCAic2NoZWR1bGVyOiByZXBsYWNlIF9fZ2V0X2NwdV92YXIgd2l0aCB0aGlzX2NwdV9w
dHIiCgpJZiB5b3Ugd2FudCB0byBrZWVwIHRoZW0gYnkgY3JlYXRpbmcgYSBuZXcgYnJhbmNo
LCB0aGlzIG1heSBiZSBhIGdvb2QgdGltZQp0byBkbyBzbyB3aXRoOgoKIGdpdCBicmFuY2gg
bmV3X2JyYW5jaF9uYW1lIDNmODc3ZTYKCkhFQUQgaXMgbm93IGF0IGMzYmViYzcuLi4gTWVy
Z2UgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2RhdmVt
L25ldApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LXN0MS0wMzA2MTkxMS9uZXh0Om1hc3RlcjpjM2JlYmM3MWM0YmNkYWZhMjRiNTA2YWRmMGMx
ZGUzYzFmNzdlMmUwOmJpc2VjdC1saW51eDMKCjIwMTQtMDMtMDctMDU6MzU6MjIgYzNiZWJj
NzFjNGJjZGFmYTI0YjUwNmFkZjBjMWRlM2MxZjc3ZTJlMCBjb21waWxpbmcKCjIwMTQtMDMt
MDctMDU6Mzc6MjggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wMDE4NS1nYzNi
ZWJjNy4uCTEJMgkxMQkyMQkzMC4JMzcJNDAJNDMJNDUJNDcJNTgJNjAgU1VDQ0VTUwoKCj09
PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdh
cyBjM2JlYmM3Li4uIE1lcmdlIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9kYXZlbS9uZXQKSEVBRCBpcyBub3cgYXQgMGZmYjJmZS4uLiBBZGQgbGlu
dXgtbmV4dCBzcGVjaWZpYyBmaWxlcyBmb3IgMjAxNDAzMDYKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEvbmV4dDptYXN0
ZXI6MGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMzpiaXNlY3QtbGlu
dXgzCiBURVNUIEZBSUxVUkUKWyAgICAwLjE4MjQ0M10gLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tClsgICAgMC4xODM4MTRdIHNtcGJvb3Q6IFRvdGFsIG9mIDIgcHJvY2Vz
c29ycyBhY3RpdmF0ZWQgKDExNTcyLjA3IEJvZ29NSVBTKQpbICAgIDAuMTgzODE0XSBzbXBi
b290OiBUb3RhbCBvZiAyIHByb2Nlc3NvcnMgYWN0aXZhdGVkICgxMTU3Mi4wNyBCb2dvTUlQ
UykKWyAgICAwLjE4NDY3MF0gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCAKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExLzBmZmIyZmU3YjljMzAwODI4NzZmYTNh
MTdkYTAxOGJmMDYzMmNmMDMvZG1lc2ctcXVhbnRhbC13YWltZWEtMTM6MjAxNDAzMDYyMDEy
NDE6aTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMTozLjE0LjAtcmM1LW5leHQtMjAxNDAz
MDYtMDY5NTItZzBmZmIyZmU6NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5
MTEvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0
by1pdnl0b3duMi0xNDoyMDE0MDMwNjIyMzYyNTppMzg2LXJhbmRjb25maWctc3QxLTAzMDYx
OTExOjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZmYjJmZTo0Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMS8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3
ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXlvY3RvLWxrcC1zdDAxLTY6MjAxNDAzMDYyMDEyMTE6
aTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMTozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYt
MDY5NTItZzBmZmIyZmU6NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEv
MGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy1xdWFudGFs
LWlubi00MDoyMDE0MDMwNjIwMTM0NjppMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExOjoK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExLzBmZmIyZmU3YjljMzAwODI4
NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8taXZ5dG93bjItMjg6MjAxNDAz
MDYyMjM2MjA6aTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMTozLjE0LjAtcmM1LW5leHQt
MjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDEt
MDMwNjE5MTEvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVz
Zy15b2N0by14aWFuLTU6MjAxNDAzMDYyMDExMDk6aTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2
MTkxMTozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6NAova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2Ex
N2RhMDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0by14aWFuLTM2OjIwMTQwMzA2MjAxMTUzOmkz
ODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTE6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2
OTUyLWcwZmZiMmZlOjQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExLzBm
ZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2ctcXVhbnRhbC1h
dGhlbnMtNDU6MjAxNDAzMDYyMDE0NDM6aTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMToz
LjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6NAova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4
YmYwNjMyY2YwMy9kbWVzZy1xdWFudGFsLXJvYW0tMzQ6MjAxNDAzMDYyMDExNTY6aTM4Ni1y
YW5kY29uZmlnLXN0MS0wMzA2MTkxMTozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTIt
ZzBmZmIyZmU6NAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTEvMGZmYjJm
ZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy1xdWFudGFsLXJvYW0t
MTM6MjAxNDAzMDYyMjM3MTA6aTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMTozLjE0LjAt
cmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6NAova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1zdDEtMDMwNjE5MTEvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMy
Y2YwMy9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTIyOjIwMTQwMzA2MjIzNTM3OmkzODYtcmFu
ZGNvbmZpZy1zdDEtMDMwNjE5MTE6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcw
ZmZiMmZlOjQKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExLzBmZmIyZmU3
YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8taXZ5dG93bjIt
Mjk6MjAxNDAzMDYyMjM2MTg6aTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMTozLjE0LjAt
cmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6NAova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1zdDEtMDMwNjE5MTEvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMy
Y2YwMy9kbWVzZy15b2N0by1pdnl0b3duMi0xOToyMDE0MDMwNjIyMzYxODppMzg2LXJhbmRj
b25maWctc3QxLTAzMDYxOTExOjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZm
YjJmZTo0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMS8wZmZiMmZlN2I5
YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXlvY3RvLWlubi0yMzoyMDE0
MDMwNjIwMTExMjppMzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExOjoKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctc3QxLTAzMDYxOTExLzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAx
OGJmMDYzMmNmMDMvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0yMjoyMDE0MDMwNjIyMzU0Nzpp
Mzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExOjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0w
Njk1Mi1nMGZmYjJmZTo0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMS8w
ZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXlvY3RvLWl2
eXRvd24yLTE5OjIwMTQwMzA2MjIzNjI3OmkzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTE6
My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlOjQKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctc3QxLTAzMDYxOTExLzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAx
OGJmMDYzMmNmMDMvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xODoyMDE0MDMwNjIyMzYyNjpp
Mzg2LXJhbmRjb25maWctc3QxLTAzMDYxOTExOjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0w
Njk1Mi1nMGZmYjJmZTo0Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MS0wMzA2MTkxMS8w
ZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXlvY3RvLWl2
eXRvd24yLTI5OjIwMTQwMzA2MjIzNjI4OmkzODYtcmFuZGNvbmZpZy1zdDEtMDMwNjE5MTE6
My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlOjQKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctc3QxLTAzMDYxOTExLzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAx
OGJmMDYzMmNmMDMvZG1lc2ctcXVhbnRhbC14aWFuLTc6MjAxNDAzMDYyMDExMjM6aTM4Ni1y
YW5kY29uZmlnLXN0MS0wMzA2MTkxMTozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTIt
ZzBmZmIyZmU6NAowOjE5OjE5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgo=

--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc5-next-20140306-06952-g0ffb2fe"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.14.0-rc5 Kernel Configuration
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
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_FHANDLE=y
# CONFIG_USELIB is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
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
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
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
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_NONE=y
# CONFIG_RCU_NOCB_CPU_ZERO is not set
# CONFIG_RCU_NOCB_CPU_ALL is not set
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
CONFIG_MEMCG=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
# CONFIG_IPC_NS is not set
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
CONFIG_RD_LZO=y
# CONFIG_RD_LZ4 is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SYSFS_SYSCALL=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
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
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_SLUB_CPU_PARTIAL is not set
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
CONFIG_HAVE_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_CC_STACKPROTECTOR_NONE=y
# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
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
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
CONFIG_GCOV_FORMAT_AUTODETECT=y
# CONFIG_GCOV_FORMAT_3_4 is not set
# CONFIG_GCOV_FORMAT_4_7 is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
# CONFIG_ACORN_PARTITION_ICS is not set
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_AIX_PARTITION=y
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
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
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
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
CONFIG_M586MMX=y
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
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_F00F_BUG=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
# CONFIG_MICROCODE_EARLY is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
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
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_TRANSPARENT_HUGEPAGE is not set
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
# CONFIG_MTRR is not set
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
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
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
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

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
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
CONFIG_PCI_GOMMCONFIG=y
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
# CONFIG_PCIEASPM is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
CONFIG_PCI_PASID=y
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_ALIX is not set
CONFIG_NET5501=y
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
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
CONFIG_RAPIDIO_TSI57X=y
# CONFIG_RAPIDIO_CPS_XX is not set
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
# CONFIG_IOSF_MBI is not set
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=y
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
CONFIG_VLAN_8021Q_MVRP=y
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
# CONFIG_IPDDP_ENCAP is not set
CONFIG_X25=y
CONFIG_LAPB=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
CONFIG_VSOCKETS=y
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
# CONFIG_CGROUP_NET_CLASSID is not set
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
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
# CONFIG_MKISS is not set
# CONFIG_6PACK is not set
CONFIG_BPQETHER=y
# CONFIG_BAYCOM_SER_FDX is not set
CONFIG_BAYCOM_SER_HDX=y
CONFIG_BAYCOM_PAR=y
CONFIG_BAYCOM_EPP=y
CONFIG_YAM=y
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=y
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRNET=y
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
# CONFIG_IRDA_FAST_RR is not set
CONFIG_IRDA_DEBUG=y

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

#
# FIR device drivers
#
CONFIG_NSC_FIR=y
# CONFIG_WINBOND_FIR is not set
CONFIG_TOSHIBA_FIR=y
CONFIG_SMC_IRCC_FIR=y
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
# CONFIG_BT is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
CONFIG_NL80211_TESTMODE=y
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_MESSAGE_TRACING=y
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y
# CONFIG_CAIF_USB is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
# CONFIG_DMA_SHARED_BUFFER is not set
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=y
CONFIG_FTL=y
CONFIG_NFTL=y
CONFIG_NFTL_RW=y
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
CONFIG_SSFDC=y
CONFIG_SM_FTL=y
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
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
# CONFIG_MTD_PHYSMAP_COMPAT is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=y
CONFIG_MTD_SBC_GXX=y
CONFIG_MTD_SCx200_DOCFLASH=y
CONFIG_MTD_AMD76XROM=y
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=y
CONFIG_MTD_CK804XROM=y
CONFIG_MTD_SCB2_FLASH=y
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=y
CONFIG_MTD_PCI=y
CONFIG_MTD_PCMCIA=y
# CONFIG_MTD_PCMCIA_ANONYMOUS is not set
CONFIG_MTD_GPIO_ADDR=y
CONFIG_MTD_INTEL_VR_NOR=y
CONFIG_MTD_PLATRAM=y
# CONFIG_MTD_LATCH_ADDR is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
CONFIG_MTD_DATAFLASH=y
# CONFIG_MTD_DATAFLASH_WRITE_VERIFY is not set
CONFIG_MTD_DATAFLASH_OTP=y
CONFIG_MTD_M25P80=y
# CONFIG_MTD_SST25L is not set
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
# CONFIG_MTD_DOCG3 is not set
CONFIG_MTD_NAND_ECC=y
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=y
CONFIG_MTD_ONENAND_OTP=y
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
CONFIG_MTD_UBI_BLOCK=y
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=y
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=y
CONFIG_PARIDE=y

#
# Parallel IDE high-level drivers
#
# CONFIG_PARIDE_PD is not set
# CONFIG_PARIDE_PCD is not set
# CONFIG_PARIDE_PF is not set
CONFIG_PARIDE_PT=y
CONFIG_PARIDE_PG=y

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=y
# CONFIG_PARIDE_BPCK is not set
# CONFIG_PARIDE_BPCK6 is not set
CONFIG_PARIDE_COMM=y
CONFIG_PARIDE_DSTR=y
# CONFIG_PARIDE_FIT2 is not set
# CONFIG_PARIDE_FIT3 is not set
# CONFIG_PARIDE_EPAT is not set
CONFIG_PARIDE_EPIA=y
# CONFIG_PARIDE_FRIQ is not set
CONFIG_PARIDE_FRPW=y
CONFIG_PARIDE_KBIC=y
CONFIG_PARIDE_KTTI=y
# CONFIG_PARIDE_ON20 is not set
CONFIG_PARIDE_ON26=y
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=y

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
CONFIG_SRAM=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
# CONFIG_EEPROM_MAX6875 is not set
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
CONFIG_IDE_GD_ATAPI=y
# CONFIG_BLK_DEV_IDECS is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=y
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
CONFIG_BLK_DEV_OPTI621=y
CONFIG_BLK_DEV_RZ1000=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
CONFIG_BLK_DEV_ALI15X3=y
CONFIG_BLK_DEV_AMD74XX=y
CONFIG_BLK_DEV_ATIIXP=y
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
# CONFIG_BLK_DEV_CS5520 is not set
CONFIG_BLK_DEV_CS5530=y
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=y
CONFIG_BLK_DEV_SC1200=y
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=y
CONFIG_BLK_DEV_IT8213=y
CONFIG_BLK_DEV_IT821X=y
CONFIG_BLK_DEV_NS87415=y
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_BLK_DEV_SVWKS is not set
CONFIG_BLK_DEV_SIIMAGE=y
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
CONFIG_BLK_DEV_VIA82CXXX=y
CONFIG_BLK_DEV_TC86C001=y
CONFIG_BLK_DEV_IDEDMA=y

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
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=y
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_FC_TGT_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=y
# CONFIG_SCSI_MVSAS_DEBUG is not set
# CONFIG_SCSI_MVSAS_TASKLET is not set
CONFIG_SCSI_MVUMI=y
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ESAS2R=y
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPT3SAS is not set
CONFIG_SCSI_UFSHCD=y
CONFIG_SCSI_UFSHCD_PCI=y
CONFIG_SCSI_UFSHCD_PLATFORM=y
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
CONFIG_VMWARE_PVSCSI=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
CONFIG_FCOE_FNIC=y
CONFIG_SCSI_DMX3191D=y
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=y
CONFIG_SCSI_IPS=y
# CONFIG_SCSI_INITIO is not set
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_PPA=y
CONFIG_SCSI_IMM=y
CONFIG_SCSI_IZIP_EPP16=y
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
# CONFIG_SCSI_SYM53C8XX_MMIO is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_NSP32=y
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_PMCRAID=y
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_BFA_FC=y
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
# CONFIG_SCSI_DH_EMC is not set
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
# CONFIG_NET_CORE is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_ARCNET_COM20020_CS=y

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
# CONFIG_CAIF_SPI_SYNC is not set
CONFIG_CAIF_HSI=y
CONFIG_CAIF_VIRTIO=y
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
CONFIG_NET_VENDOR_3COM=y
# CONFIG_PCMCIA_3C574 is not set
CONFIG_PCMCIA_3C589=y
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ARC is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_CADENCE is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_TIGON3 is not set
CONFIG_BNX2X=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
# CONFIG_NET_VENDOR_CISCO is not set
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
CONFIG_NET_VENDOR_HP=y
CONFIG_HP100=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
# CONFIG_E1000 is not set
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
CONFIG_IXGB=y
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBEVF=y
CONFIG_I40E=y
# CONFIG_I40EVF is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_IP1000 is not set
CONFIG_JME=y
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=y
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKGE_GENESIS=y
# CONFIG_SKY2 is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
CONFIG_FEALNX=y
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
# CONFIG_NET_VENDOR_8390 is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
CONFIG_ETHOC=y
CONFIG_NET_PACKET_ENGINE=y
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=y
# CONFIG_NET_VENDOR_QLOGIC is not set
# CONFIG_NET_VENDOR_REALTEK is not set
CONFIG_SH_ETH=y
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_SEEQ=y
# CONFIG_NET_VENDOR_SILAN is not set
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
# CONFIG_SIS190 is not set
CONFIG_SFC=y
# CONFIG_SFC_MTD is not set
CONFIG_SFC_MCDI_MON=y
# CONFIG_NET_VENDOR_SMSC is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
CONFIG_VIA_VELOCITY=y
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
# CONFIG_WIZNET_BUS_DIRECT is not set
# CONFIG_WIZNET_BUS_INDIRECT is not set
CONFIG_WIZNET_BUS_ANY=y
# CONFIG_NET_VENDOR_XIRCOM is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
CONFIG_MICREL_KS8995MA=y
CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_FILTER=y
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=y
# CONFIG_PPP_ASYNC is not set
CONFIG_PPP_SYNC_TTY=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
CONFIG_AIRO=y
CONFIG_ATMEL=y
CONFIG_PCI_ATMEL=y
CONFIG_PCMCIA_ATMEL=y
# CONFIG_AIRO_CS is not set
CONFIG_PCMCIA_WL3501=y
CONFIG_PRISM54=y
CONFIG_RTL8180=y
CONFIG_ADM8211=y
CONFIG_MAC80211_HWSIM=y
# CONFIG_MWL8K is not set
CONFIG_ATH_COMMON=y
CONFIG_ATH_CARDS=y
CONFIG_ATH_DEBUG=y
# CONFIG_ATH5K is not set
CONFIG_ATH5K_PCI=y
CONFIG_ATH9K_HW=y
CONFIG_ATH9K_COMMON=y
# CONFIG_ATH9K_BTCOEX_SUPPORT is not set
CONFIG_ATH9K=y
# CONFIG_ATH9K_PCI is not set
# CONFIG_ATH9K_AHB is not set
CONFIG_ATH9K_DEBUGFS=y
# CONFIG_ATH9K_STATION_STATISTICS is not set
CONFIG_ATH9K_WOW=y
# CONFIG_ATH9K_RFKILL is not set
CONFIG_ATH6KL=y
CONFIG_ATH6KL_SDIO=y
CONFIG_ATH6KL_DEBUG=y
CONFIG_WIL6210=y
CONFIG_WIL6210_ISR_COR=y
CONFIG_ATH10K=y
CONFIG_ATH10K_PCI=y
# CONFIG_ATH10K_DEBUG is not set
CONFIG_ATH10K_DEBUGFS=y
# CONFIG_WCN36XX is not set
# CONFIG_B43 is not set
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
# CONFIG_B43LEGACY_DMA_AND_PIO_MODE is not set
CONFIG_B43LEGACY_DMA_MODE=y
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_BRCMUTIL=y
CONFIG_BRCMSMAC=y
CONFIG_BRCMFMAC=y
CONFIG_BRCMFMAC_SDIO=y
CONFIG_BRCM_TRACING=y
# CONFIG_BRCMDBG is not set
# CONFIG_HOSTAP is not set
CONFIG_IPW2100=y
CONFIG_IPW2100_MONITOR=y
CONFIG_IPW2100_DEBUG=y
CONFIG_IPW2200=y
# CONFIG_IPW2200_MONITOR is not set
# CONFIG_IPW2200_QOS is not set
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=y
CONFIG_LIBIPW_DEBUG=y
# CONFIG_IWLWIFI is not set
CONFIG_IWLEGACY=y
CONFIG_IWL4965=y
# CONFIG_IWL3945 is not set

#
# iwl3945 / iwl4965 Debugging Options
#
# CONFIG_IWLEGACY_DEBUG is not set
# CONFIG_IWLEGACY_DEBUGFS is not set
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_CS=y
CONFIG_LIBERTAS_SDIO=y
CONFIG_LIBERTAS_SPI=y
# CONFIG_LIBERTAS_DEBUG is not set
# CONFIG_LIBERTAS_MESH is not set
CONFIG_HERMES=y
# CONFIG_HERMES_PRISM is not set
# CONFIG_HERMES_CACHE_FW_ON_INIT is not set
CONFIG_PLX_HERMES=y
CONFIG_TMD_HERMES=y
# CONFIG_NORTEL_HERMES is not set
CONFIG_PCMCIA_HERMES=y
CONFIG_PCMCIA_SPECTRUM=y
CONFIG_P54_COMMON=y
CONFIG_P54_PCI=y
CONFIG_P54_SPI=y
CONFIG_P54_SPI_DEFAULT_EEPROM=y
CONFIG_P54_LEDS=y
# CONFIG_RT2X00 is not set
# CONFIG_RTL_CARDS is not set
CONFIG_WL_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
CONFIG_WL18XX=y
CONFIG_WLCORE=y
# CONFIG_WLCORE_SPI is not set
CONFIG_WLCORE_SDIO=y
# CONFIG_WILINK_PLATFORM_DATA is not set
CONFIG_MWIFIEX=y
CONFIG_MWIFIEX_SDIO=y
# CONFIG_MWIFIEX_PCIE is not set
CONFIG_CW1200=y
# CONFIG_CW1200_WLAN_SDIO is not set
# CONFIG_CW1200_WLAN_SPI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
CONFIG_IEEE802154_FAKELB=y
# CONFIG_IEEE802154_AT86RF230 is not set
CONFIG_IEEE802154_MRF24J40=y
# CONFIG_ISDN is not set

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
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
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
# CONFIG_KEYBOARD_TWL4030 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_LEDS=y
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
CONFIG_JOYSTICK_A3D=y
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
# CONFIG_JOYSTICK_STINGER is not set
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=y
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=y
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
# CONFIG_TOUCHSCREEN_88PM860X is not set
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_CYTTSP_CORE=y
CONFIG_TOUCHSCREEN_CYTTSP_I2C=y
# CONFIG_TOUCHSCREEN_CYTTSP_SPI is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=y
CONFIG_TOUCHSCREEN_MTOUCH=y
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_TI_AM335X_TSC=y
# CONFIG_TOUCHSCREEN_PIXCIR is not set
CONFIG_TOUCHSCREEN_WM831X=y
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_TOUCHSCREEN_MC13783=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
CONFIG_TOUCHSCREEN_TSC2005=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_PCAP=y
CONFIG_TOUCHSCREEN_ST1232=y
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
CONFIG_SERIO_CT82C710=y
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
# CONFIG_SERIO_PS2MULT is not set
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
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
CONFIG_N_GSM=y
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CLPS711X=y
CONFIG_SERIAL_CLPS711X_CONSOLE=y
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_MAX310X=y
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_SH_SCI=y
CONFIG_SERIAL_SH_SCI_NR_UARTS=2
CONFIG_SERIAL_SH_SCI_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
# CONFIG_SERIAL_ARC is not set
CONFIG_SERIAL_RP2=y
CONFIG_SERIAL_RP2_NR_UARTS=32
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
# CONFIG_SERIAL_ST_ASC is not set
CONFIG_TTY_PRINTK=y
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_HW_RANDOM_TPM=y
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
CONFIG_IPWIRELESS=y
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_I2C_ATMEL is not set
# CONFIG_TCG_TIS_I2C_INFINEON is not set
CONFIG_TCG_TIS_I2C_NUVOTON=y
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
# CONFIG_I2C_MUX_GPIO is not set
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
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
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD756_S4882=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_ISMT=y
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
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
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
CONFIG_I2C_DESIGNWARE_PCI=y
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=y
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=y
CONFIG_I2C_SH_MOBILE=y
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
CONFIG_SCx200_ACB=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_ATMEL=y
CONFIG_SPI_BCM2835=y
CONFIG_SPI_BCM63XX_HSSPI=y
CONFIG_SPI_BITBANG=y
# CONFIG_SPI_BUTTERFLY is not set
CONFIG_SPI_EP93XX=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_IMX=y
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_FSL_DSPI=y
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_TI_QSPI=y
CONFIG_SPI_OMAP_100K=y
CONFIG_SPI_ORION=y
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=y
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_SC18IS602=y
# CONFIG_SPI_SH is not set
CONFIG_SPI_SH_HSPI=y
CONFIG_SPI_SUN4I=y
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
CONFIG_SPMI=y
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
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
CONFIG_PPS_CLIENT_GPIO=y

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=y
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_CLPS711X=y
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_LP3943=y
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL4030=y
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8350 is not set
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
CONFIG_GPIO_BT8XX=y
CONFIG_GPIO_AMD8111=y
CONFIG_GPIO_INTEL_MID=y
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
CONFIG_GPIO_MC33880=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
# CONFIG_GPIO_TPS6586X is not set

#
# USB GPIO expanders:
#
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_WM831X_BACKUP is not set
# CONFIG_WM831X_POWER is not set
# CONFIG_WM8350_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_PCF50633 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_TWL4030 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_MAX14577 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_CHARGER_TPS65090 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7314=y
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
CONFIG_SENSORS_ADM1026=y
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_I5K_AMB=y
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
CONFIG_SENSORS_F75375S=y
# CONFIG_SENSORS_MC13783_ADC is not set
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_G762=y
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=y
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LTC2945=y
CONFIG_SENSORS_LTC4151=y
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
CONFIG_SENSORS_MAX6697=y
# CONFIG_SENSORS_HTU21 is not set
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
CONFIG_SENSORS_LM73=y
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
# CONFIG_SENSORS_LM78 is not set
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_NCT6775=y
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=y
# CONFIG_SENSORS_PMBUS is not set
CONFIG_SENSORS_ADM1275=y
# CONFIG_SENSORS_LM25066 is not set
# CONFIG_SENSORS_LTC2978 is not set
CONFIG_SENSORS_MAX16064=y
# CONFIG_SENSORS_MAX34440 is not set
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
# CONFIG_SENSORS_UCD9200 is not set
# CONFIG_SENSORS_ZL6100 is not set
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
CONFIG_SENSORS_AMC6821=y
CONFIG_SENSORS_INA209=y
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
CONFIG_SENSORS_WM8350=y

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
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_RCAR_THERMAL is not set
# CONFIG_INTEL_POWERCLAMP is not set
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
CONFIG_DA9052_WATCHDOG=y
CONFIG_WM831X_WATCHDOG=y
# CONFIG_WM8350_WATCHDOG is not set
CONFIG_XILINX_WATCHDOG=y
# CONFIG_DW_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
CONFIG_TEGRA_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
CONFIG_SP5100_TCO=y
CONFIG_GEODE_WDT=y
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
# CONFIG_HPWDT_NMI_DECODING is not set
CONFIG_SC1200_WDT=y
# CONFIG_SCx200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
CONFIG_W83977F_WDT=y
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=y
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
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
CONFIG_MFD_CS5535=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_CROS_EC=y
# CONFIG_MFD_CROS_EC_I2C is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS65218 is not set
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS65910 is not set
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
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8997 is not set
CONFIG_MFD_WM8400=y
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_AAT2870 is not set
# CONFIG_REGULATOR_DA903X is not set
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
# CONFIG_REGULATOR_MAX14577 is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
# CONFIG_REGULATOR_MAX8907 is not set
CONFIG_REGULATOR_MAX8952=y
# CONFIG_REGULATOR_MAX8973 is not set
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MAX77693=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PCAP=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
# CONFIG_REGULATOR_TPS65217 is not set
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS6586X=y
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
CONFIG_REGULATOR_WM8400=y
# CONFIG_REGULATOR_WM8994 is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
CONFIG_MEDIA_RC_SUPPORT=y
# CONFIG_MEDIA_CONTROLLER is not set
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_DMA_CONTIG=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
CONFIG_RC_DECODERS=y
CONFIG_LIRC=y
CONFIG_IR_LIRC_CODEC=y
CONFIG_IR_NEC_DECODER=y
# CONFIG_IR_RC5_DECODER is not set
CONFIG_IR_RC6_DECODER=y
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_SANYO_DECODER=y
CONFIG_IR_MCE_KBD_DECODER=y
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
# CONFIG_IR_WINBOND_CIR is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_RC_LOOPBACK=y
CONFIG_IR_GPIO_CIR=y
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
CONFIG_V4L_PLATFORM_DRIVERS=y
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_VIDEO_SH_VOU=y
# CONFIG_SOC_CAMERA is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
# CONFIG_MEDIA_PARPORT_SUPPORT is not set

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

#
# Video and audio decoders
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
# Audio/Video compression chips
#

#
# Miscellaneous helper chips
#

#
# Sensors used on soc_camera driver
#

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
# CONFIG_AGP_VIA is not set
CONFIG_AGP_EFFICEON=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
# CONFIG_DRM is not set

#
# Frame buffer Devices
#
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
# CONFIG_BACKLIGHT_CLASS_DEVICE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
# CONFIG_SND is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=y
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
CONFIG_HID_UCLOGIC=y
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=y
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
# CONFIG_HID_SAMSUNG is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THINGM is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
CONFIG_HID_XINMO=y
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
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
# CONFIG_OMAP_CONTROL_USB is not set
# CONFIG_OMAP_USB3 is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_RCAR_GEN2_PHY is not set
# CONFIG_USB_GADGET is not set
CONFIG_UWB=y
CONFIG_UWB_WHCI=y
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_OMAP_HS=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MEMSTICK=y
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
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3533=y
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_NET48XX=y
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_PCA9685=y
CONFIG_LEDS_WM831X_STATUS=y
CONFIG_LEDS_WM8350=y
# CONFIG_LEDS_DA903X is not set
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_PWM=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_LM355x=y
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
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
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
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
CONFIG_EXTCON_MAX77693=y
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
# CONFIG_BMA180 is not set
# CONFIG_HID_SENSOR_ACCEL_3D is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=y

#
# Analog to digital converters
#
CONFIG_AD7266=y
CONFIG_AD7298=y
CONFIG_AD7476=y
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
# CONFIG_MAX1363 is not set
CONFIG_MCP320X=y
# CONFIG_MCP3422 is not set
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y
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
CONFIG_AD5360=y
CONFIG_AD5380=y
# CONFIG_AD5421 is not set
CONFIG_AD5446=y
# CONFIG_AD5449 is not set
# CONFIG_AD5504 is not set
CONFIG_AD5624R_SPI=y
CONFIG_AD5686=y
# CONFIG_AD5755 is not set
CONFIG_AD5764=y
CONFIG_AD5791=y
CONFIG_AD7303=y
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set

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
# CONFIG_ADIS16080 is not set
CONFIG_ADIS16130=y
CONFIG_ADIS16136=y
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS450 is not set
CONFIG_HID_SENSOR_GYRO_3D=y
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set

#
# Humidity sensors
#
CONFIG_DHT11=y
CONFIG_SI7005=y

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
CONFIG_ADIS16480=y
CONFIG_INV_MPU6050_IIO=y
CONFIG_IIO_ADIS_LIB=y
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
CONFIG_APDS9300=y
CONFIG_CM32181=y
CONFIG_CM36651=y
CONFIG_GP2AP020A00F=y
# CONFIG_HID_SENSOR_ALS is not set
CONFIG_HID_SENSOR_PROX=y
# CONFIG_SENSORS_LM3533 is not set
# CONFIG_LTR501 is not set
CONFIG_TCS3472=y
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
CONFIG_AK8975=y
CONFIG_MAG3110=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
CONFIG_IIO_ST_MAGN_SPI_3AXIS=y

#
# Inclinometer sensors
#
# CONFIG_HID_SENSOR_INCLINOMETER_3D is not set

#
# Triggers - standalone
#
CONFIG_IIO_INTERRUPT_TRIGGER=y
CONFIG_IIO_SYSFS_TRIGGER=y

#
# Pressure sensors
#
CONFIG_HID_SENSOR_PRESS=y
# CONFIG_MPL3115 is not set
CONFIG_IIO_ST_PRESS=y
CONFIG_IIO_ST_PRESS_I2C=y
CONFIG_IIO_ST_PRESS_SPI=y

#
# Temperature sensors
#
CONFIG_TMP006=y
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=y
CONFIG_PWM_RENESAS_TPU=y
CONFIG_PWM_TWL=y
CONFIG_PWM_TWL_LED=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
# CONFIG_RESET_CONTROLLER is not set
CONFIG_FMC=y
# CONFIG_FMC_FAKEDEV is not set
# CONFIG_FMC_TRIVIAL is not set
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
CONFIG_POWERCAP=y
# CONFIG_INTEL_RAPL is not set
CONFIG_MCB=y

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
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
# CONFIG_REISERFS_FS_POSIX_ACL is not set
# CONFIG_REISERFS_FS_SECURITY is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
# CONFIG_JFS_STATISTICS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
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
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_DEBUG=y
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
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
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
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
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_PROVE_LOCKING is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_KOBJECT_RELEASE is not set
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
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
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
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
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
CONFIG_DEBUG_NMI_SELFTEST=y
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

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
CONFIG_CRYPTO_ABLK_HELPER=y
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
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

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
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_USER_API_HASH is not set
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_LGUEST is not set
# CONFIG_BINARY_PRINTF is not set

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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_CRC64_ECMA=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
CONFIG_DDR=y

--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--yVhtmJPUSI46BTXb--
