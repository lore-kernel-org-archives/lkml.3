Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaCGCL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 21:11:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:22320 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004AbaCGCKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 21:10:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,605,1389772800"; 
   d="log'?scan'208";a="487633419"
Date: Fri, 7 Mar 2014 09:42:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [percpu]  BUG: using __this_cpu_add() in preemptible [00000000]
 code: swapper/0/1
Message-ID: <20140307014233.GE8427@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AjmyJqqohANyBN/e"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AjmyJqqohANyBN/e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Christoph,

FYI, this commit helps expose more information (a warning with
backtrace) on a previously clueless kernel crash.

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit a25982c15ae5298520033cd5848a82adf6a97376
Author:     Christoph Lameter <cl@linux.com>
AuthorDate: Thu Mar 6 11:05:21 2014 +1100
Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
CommitDate: Thu Mar 6 18:13:33 2014 +1100

    percpu: add preemption checks to __this_cpu ops
    
    We define a check function in order to avoid trouble with the include
    files.  Then the higher level __this_cpu macros are modified to invoke the
    preemption check.
    
    Signed-off-by: Christoph Lameter <cl@linux.com>
    Acked-by: Ingo Molnar <mingo@kernel.org>
    Cc: Tejun Heo <tj@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

+-------------------------------------------------------+------------+------------+---------------+
|                                                       | 26d02cfa38 | a25982c15a | next-20140306 |
+-------------------------------------------------------+------------+------------+---------------+
| boot_successes                                        | 72         | 0          | 0             |
| boot_failures                                         | 8          | 20         | 19            |
| BUG:kernel_test_crashed                               | 1          |            |               |
| BUG:kernel_boot_crashed                               | 6          |            |               |
| BUG:kernel_boot_hang                                  | 1          |            |               |
| BUG:using__this_cpu_add()in_preemptible_code:swapper  | 0          | 20         | 19            |
| backtrace:getname_kernel                              | 0          | 6          | 10            |
| backtrace:run_init_process                            | 0          | 6          | 10            |
| BUG:using__this_cpu_add()in_preemptible_code:kthreadd | 0          | 3          | 1             |
| backtrace:__this_cpu_preempt_check                    | 0          | 1          |               |
| backtrace:do_fork                                     | 0          | 1          |               |
| backtrace:kthreadd                                    | 0          | 1          |               |
| backtrace:do_execve                                   | 0          | 1          |               |
+-------------------------------------------------------+------------+------------+---------------+

[  107.002146]   #2: MTPAV on parallel port at 0x378
[  107.138481] random: nonblocking pool is initialized
[  107.276022] Freeing unused kernel memory: 800K (d2c49000 - d2d11000)
[  107.417645] BUG: using __this_cpu_add() in preemptible [00000000] code: swapper/0/1
[  107.703813] caller is __this_cpu_preempt_check+0x3b/0x60
[  107.852357] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5-next-20140306-06952-g0ffb2fe #1
[  108.157111] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  108.319103]  00000000 00000000 d343deec d22ec747 00000000 d343df10 d13efdcd d290362c
[  108.685150]  d343df28 00000000 d34403d8 00000001 d343df28 d0745000 d343df58 d13efe2b
[  109.086205]  d343df28 00000028 d2902c14 d2a74fc6 68745f5f 635f7369 615f7570 29286464
[  109.512575] Call Trace:
[  109.718526]  [<d22ec747>] dump_stack+0x4b/0x75
[  109.927550]  [<d13efdcd>] check_preemption_disabled+0xcd/0xe0
[  110.138792]  [<d13efe2b>] __this_cpu_preempt_check+0x3b/0x60
[  110.351853]  [<d106966b>] ? preempt_count_add+0x4b/0xa0
[  110.564753]  [<d10f3fa2>] kmem_cache_alloc+0xc2/0x190
[  110.776294]  [<d11077ff>] ? getname_kernel+0x3f/0x80
[  110.983777]  [<d11077ff>] getname_kernel+0x3f/0x80
[  111.181555]  [<d100036d>] run_init_process+0xd/0x20
[  111.381971]  [<d22e42d2>] kernel_init+0x32/0xe0
[  111.578459]  [<d230315b>] ret_from_kernel_thread+0x1b/0x30
[  111.768674]  [<d22e42a0>] ? rest_init+0x70/0x70

git bisect start 0ffb2fe7b9c30082876fa3a17da018bf0632cf03 09de192242d86ede449146ac423effca53bc1810 --
git bisect  bad 439cde1f3d8230f858c0a55902381d24cd7a2df2  # 03:37      0-      4  Merge branch 'akpm/master'
git bisect good ce34778eb4d9fa0aaaeae76c1068026ee5255fd7  # 04:14     20+      5  Merge branch 'akpm-current/current'
git bisect good 117314461e82adabb6b78dcb03259da75b50833b  # 04:30     20+      4  mm: don't implictly include linux/mm.h in linux/sched.h
git bisect  bad 9d58cf7a388c1b4a06cb335980eb1bb1352ba876  # 04:35      0-      1  scheduler: replace __get_cpu_var with this_cpu_ptr
git bisect  bad b2ff2cfebad92bebfca28bad650045821ed270c4  # 04:41      0-      6  tracing: replace __get_cpu_var uses with this_cpu_ptr
git bisect good 6fb77936481538ba05726345d86af4b39128a8a9  # 05:03     20+      4  arm: move arm_dma_limit to setup_dma_zone
git bisect good d1cea07efbfa2723ca1b83d3a69d1f1000896d4d  # 06:15     20+     10  modules: use raw_cpu_write for initialization of per cpu refcount.
git bisect  bad a25982c15ae5298520033cd5848a82adf6a97376  # 06:23      0-      3  percpu: add preemption checks to __this_cpu ops
git bisect good 26d02cfa385067c39c0407b022c01a011c2fbb51  # 06:46     20+      3  net: replace __this_cpu_inc in route.c with raw_cpu_inc
# first bad commit: [a25982c15ae5298520033cd5848a82adf6a97376] percpu: add preemption checks to __this_cpu ops
git bisect good 26d02cfa385067c39c0407b022c01a011c2fbb51  # 07:23     60+      8  net: replace __this_cpu_inc in route.c with raw_cpu_inc
git bisect  bad 0ffb2fe7b9c30082876fa3a17da018bf0632cf03  # 07:23      0-     19  Add linux-next specific files for 20140306
git bisect good cb19098c9fa7af13a3efbe02076e8a4b17d86e38  # 07:59     60+      8  Revert "percpu: add preemption checks to __this_cpu ops"
git bisect good c3bebc71c4bcdafa24b506adf0c1de3c1f77e2e0  # 08:22     60+      1  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect  bad 0ffb2fe7b9c30082876fa3a17da018bf0632cf03  # 08:22      0-     19  Add linux-next specific files for 20140306

Thanks,
Fengguang

--AjmyJqqohANyBN/e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivytown2-18:20140307011851:i386-randconfig-an0-03070034:3.14.0-rc5-next-20140306-06952-g0ffb2fe:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc5-next-20140306-06952-g0ffb2fe (kbuil=
d@ant) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP PREEMPT Fri Mar 7 01:09=
:25 CST 2014
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
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x133fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
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
[    0.000000] BRK [0x12e59000, 0x12e59fff] PGTABLE
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
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] BRK [0x12e5a000, 0x12e5afff] PGTABLE
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
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @d3a29000 s26240 r0 d14720 u40=
960
[    0.000000] pcpu-alloc: s26240 r0 d14720 u40960 alloc=3D10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 13a2b580
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-an0-03070034/next:master/.vmlinuz-0ffb2fe7b9c30082876fa3=
a17da018bf0632cf03-20140307011128-4-ivytown2 branch=3Dnext/master BOOT_IMAG=
E=3D/kernel/i386-randconfig-an0-03070034/0ffb2fe7b9c30082876fa3a17da018bf06=
32cf03/vmlinuz-3.14.0-rc5-next-20140306-06952-g0ffb2fe
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 289776K/327280K available (19471K kernel code, 1291K=
 rwdata, 8196K rodata, 800K init, 956K bss, 37504K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd35000 - 0xfffff000   (2856 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xff7fe000   ( 688 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xd2c49000 - 0xd2d11000   ( 800 kB)
[    0.000000]       .data : 0xd230423d - 0xd2c48f20   (9491 kB)
[    0.000000]       .text : 0xd1000000 - 0xd230423d   (19472 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dd3408000 soft=3Dd340a000
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc5-next-20140306-06952-g0ffb2fe (kbuil=
d@ant) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP PREEMPT Fri Mar 7 01:09=
:25 CST 2014
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
[c00fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x133fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
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
[    0.000000] BRK [0x12e59000, 0x12e59fff] PGTABLE
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
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13ffe000
[    0.000000]   low ram: 0 - 13ffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13ffd001, primary cpu clock
[    0.000000] BRK [0x12e5a000, 0x12e5afff] PGTABLE
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
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @d3a29000 s26240 r0 d14720 u40=
960
[    0.000000] pcpu-alloc: s26240 r0 d14720 u40960 alloc=3D10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 13a2b580
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 81180
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-an0-03070034/next:master/.vmlinuz-0ffb2fe7b9c30082876fa3=
a17da018bf0632cf03-20140307011128-4-ivytown2 branch=3Dnext/master BOOT_IMAG=
E=3D/kernel/i386-randconfig-an0-03070034/0ffb2fe7b9c30082876fa3a17da018bf06=
32cf03/vmlinuz-3.14.0-rc5-next-20140306-06952-g0ffb2fe
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 289776K/327280K available (19471K kernel code, 1291K=
 rwdata, 8196K rodata, 800K init, 956K bss, 37504K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd35000 - 0xfffff000   (2856 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd47fe000 - 0xff7fe000   ( 688 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3ffe000   ( 319 MB)
[    0.000000]       .init : 0xd2c49000 - 0xd2d11000   ( 800 kB)
[    0.000000]       .data : 0xd230423d - 0xd2c48f20   (9491 kB)
[    0.000000]       .text : 0xd1000000 - 0xd230423d   (19472 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D128, Order=3D0-3, MinObjects=3D0, CPUs=3D2, =
Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3Dd3408000 soft=3Dd340a000
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2493.918 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 4987.83 Bogo=
MIPS (lpj=3D9975672)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] Security Framework initialized
[    0.008000] Yama: becoming mindful.
[    0.008000] Mount-cache hash table entries: 512
[    0.008221] Initializing cgroup subsys net_cls
[    0.008911] Initializing cgroup subsys blkio
[    0.009575] Initializing cgroup subsys perf_event
[    0.010289] Initializing cgroup subsys net_prio
[    0.010976] Initializing cgroup subsys hugetlb
[    0.011716] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.011716] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.011716] tlb_flushall_shift: 6
[    0.014084] Freeing SMP alternatives memory: 44K (d2d11000 - d2d1c000)
[    0.018920] Getting VERSION: 50014
[    0.020008] Getting VERSION: 50014
[    0.020573] Getting ID: 0
[    0.021066] Getting ID: f000000
[    0.021619] Getting LVT0: 8700
[    0.022152] Getting LVT1: 8400
[    0.022690] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.023481] enabled ExtINT on CPU#0
[    0.024688] ENABLING IO-APIC IRQs
[    0.025244] init IO_APIC IRQs
[    0.025779]  apic 0 pin 0 not connected
[    0.026389] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.028018] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.029223] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.030434] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.031635] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.032016] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.033226] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.034423] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.036016] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.037218] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.038446] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.040016] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.041231] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.042446] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.043660] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.044015]  apic 0 pin 16 not connected
[    0.044631]  apic 0 pin 17 not connected
[    0.045252]  apic 0 pin 18 not connected
[    0.045873]  apic 0 pin 19 not connected
[    0.046492]  apic 0 pin 20 not connected
[    0.048003]  apic 0 pin 21 not connected
[    0.048622]  apic 0 pin 22 not connected
[    0.049241]  apic 0 pin 23 not connected
[    0.050003] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.050946] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.052815] Using local APIC timer interrupts.
[    0.052815] calibrating APIC timer ...
[    0.056000] ... lapic delta =3D 6250022
[    0.056000] ... PM-Timer delta =3D 357969
[    0.056000] ... PM-Timer result ok
[    0.056000] ..... delta 6250022
[    0.056000] ..... mult: 268436400
[    0.056000] ..... calibration result: 4000014
[    0.056000] ..... CPU clock speed is 2494.0311 MHz.
[    0.056000] ..... host bus clock speed is 1000.0014 MHz.
[    0.056037] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.080137] CPU 1 irqstacks, hard=3Dd347a000 soft=3Dd347c000
[    0.081044] x86: Booting SMP configuration:
[    0.081760] .... node  #0, CPUs:      #1
[    0.004000] Initializing CPU#1
[    0.008000] kvm-clock: cpu 1, msr 0:13ffd021, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.096027] x86: Booted up 1 node, 2 CPUs
[    0.096018] KVM setup async PF for cpu 1
[    0.096018] kvm-stealtime: cpu 1, msr 13a35580
[    0.100003] smpboot: Total of 2 processors activated (9975.67 BogoMIPS)
[    0.101584] devtmpfs: initialized
[    0.104120] prandom: seed boundary self test passed
[    0.105289] prandom: 100 self tests passed
[    0.105920] pinctrl core: initialized pinctrl subsystem
[    0.106777] regulator-dummy: no parameters
[    0.107483] NET: Registered protocol family 16
[    0.108869] EISA bus registered
[    0.109414] cpuidle: using governor ladder
[    0.110793] ACPI: bus type PCI registered
[    0.111488] PCI: Using configuration type 1 for base access
[    0.120995] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.121792] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.122660] ACPI: Added _OSI(Module Device)
[    0.123303] ACPI: Added _OSI(Processor Device)
[    0.123973] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.124003] ACPI: Added _OSI(Processor Aggregator Device)
[    0.128545] ACPI: Interpreter enabled
[    0.129142] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140214/hwxface-580)
[    0.130587] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140214/hwxface-580)
[    0.132013] ACPI: (supports S0 S3 S5)
[    0.132599] ACPI: Using IOAPIC for interrupt routing
[    0.133332] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.139027] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.139903] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.140011] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.141181] PCI host bridge to bus 0000:00
[    0.141828] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.142603] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.144004] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.144844] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.145762] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.146708] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.148191] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.149449] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.152438] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.154263] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.155361] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.156012] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.157196] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.160552] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.164043] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.170648] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.172102] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.173764] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.175439] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.180004] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.181149] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.182430] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.186449] pci_bus 0000:00: on NUMA node 0
[    0.187564] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.188716] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.189938] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.191184] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.192463] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.193865] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.195238] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.196003] vgaarb: loaded
[    0.196491] vgaarb: bridge control possible 0000:00:02.0
[    0.197589] SCSI subsystem initialized
[    0.198236] libata version 3.00 loaded.
[    0.198898] ACPI: bus type USB registered
[    0.200041] usbcore: registered new interface driver usbfs
[    0.200838] usbcore: registered new interface driver hub
[    0.201749] usbcore: registered new device driver usb
[    0.202584] media: Linux media interface: v0.10
[    0.203274] Linux video capture interface: v2.00
[    0.204008] pps_core: LinuxPPS API ver. 1 registered
[    0.204735] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.206043] PTP clock support registered
[    0.206932] Advanced Linux Sound Architecture Driver Initialized.
[    0.207791] PCI: Using ACPI for IRQ routing
[    0.208006] PCI: pci_cache_line_size set to 64 bytes
[    0.208822] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.209654] e820: reserve RAM buffer [mem 0x13ffe000-0x13ffffff]
[    0.210711] irda_init()
[    0.211214] NET: Registered protocol family 23
[    0.212032] NET: Registered protocol family 8
[    0.212696] NET: Registered protocol family 20
[    0.214323] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.215284] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.216491] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.219619] Switched to clocksource kvm-clock
[    0.219619] pnp: PnP ACPI init
[    0.219619] ACPI: bus type PNP registered
[    0.219619] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.219619] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.220229] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.221466] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.222388] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.223628] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.224575] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.227475] pnp 00:03: [dma 2]
[    0.228039] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.228983] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.230220] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.231175] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.232420] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.233522] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.234591] pnp: PnP ACPI: found 7 devices
[    0.235233] ACPI: bus type PNP unregistered
[    0.517845] mdacon: MDA with 8K of memory detected.
[    0.517877] Console: switching consoles 13-16 to MDA-2
[    0.554012] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.554801] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.555581] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.556444] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.557317] NET: Registered protocol family 1
[    0.557990] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.558823] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.559631] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.560499] pci 0000:00:02.0: Boot video device
[    0.561202] PCI: CLS 0 bytes, default 64
[    0.561922] Unpacking initramfs...
[    0.631823] Freeing initrd memory: 3276K (d3cbd000 - d3ff0000)
[    0.633871] apm: BIOS not found.
[    0.634718] cryptomgr_test (26) used greatest stack depth: 7224 bytes le=
ft
[    0.635793] PCLMULQDQ-NI instructions are not detected.
[    0.636560] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    0.637897] NatSemi SCx200 Driver
[    0.639106] Initializing RT-Tester: OK
[    0.639718] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.641808] spin_lock-torture: Creating torture_shuffle task
[    0.642659] spin_lock-torture: Creating torture_stutter task
[    0.643474] spin_lock-torture: torture_shuffle task started
[    0.644273] spin_lock-torture: Creating lock_torture_writer task
[    0.644324] spin_lock-torture: torture_stutter task started
[    0.645977] spin_lock-torture: Creating lock_torture_writer task
[    0.646840] spin_lock-torture: lock_torture_writer task started
[    0.647669] spin_lock-torture: Creating lock_torture_writer task
[    0.647705] spin_lock-torture: lock_torture_writer task started
[    0.649401] spin_lock-torture: Creating lock_torture_writer task
[    0.650246] spin_lock-torture: lock_torture_writer task started
[    0.651095] spin_lock-torture: Creating lock_torture_stats task
[    0.651128] spin_lock-torture: lock_torture_writer task started
[    0.652998] futex hash table entries: 512 (order: 2, 16384 bytes)
[    0.653890] Initialise system trusted keyring
[    0.654700] spin_lock-torture: lock_torture_stats task started
[    0.655563] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.659830] VFS: Disk quotas dquot_6.5.2
[    0.660547] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.662261] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.663843] NTFS driver 2.1.30 [Flags: R/O DEBUG].
[    0.664704] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    0.665498] jffs2: version 2.2.=20
[    0.666632] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.667418] QNX4 filesystem 0.2.3 registered.
[    0.668168] QNX6 filesystem 1.0.0 registered.
[    0.668950] fuse init (API version 7.22)
[    0.670025] NILFS version 2 loaded
[    0.670929] OCFS2 User DLM kernel interface loaded
[    0.672470] GFS2 installed
[    0.673083] Key type big_key registered
[    0.674155] cryptomgr_test (57) used greatest stack depth: 6848 bytes le=
ft
[    0.675655] cryptomgr_test (63) used greatest stack depth: 6764 bytes le=
ft
[    0.676647] cryptomgr_test (64) used greatest stack depth: 6708 bytes le=
ft
[    0.677725] cryptomgr_test (65) used greatest stack depth: 6472 bytes le=
ft
[    0.678785] cryptomgr_test (66) used greatest stack depth: 6384 bytes le=
ft
[    0.682378] alg: No test for lz4 (lz4-generic)
[    0.683167] alg: No test for lz4hc (lz4hc-generic)
[    0.683978] alg: No test for stdrng (krng)
[    0.687883] NET: Registered protocol family 38
[    0.688584] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 249)
[    0.689709] io scheduler noop registered
[    0.690328] io scheduler deadline registered
[    0.691090] io scheduler cfq registered (default)
[    0.691803] test_string_helpers: Running tests...
[    0.692574] rbtree testing -> 9445 cycles
[    1.102242] augmented rbtree testing -> 11988 cycles
[    1.623060] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.623874] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.624789] Console: switching consoles 13-16 to MDA-2
[    1.625667] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    1.626444] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    1.627436] vmlfb: initializing
[    1.628071] hgafb: HGA card not detected.
[    1.628707] hgafb: probe of hgafb.0 failed with error -22
[    1.629665] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    1.631034] fbcon: CL Picasso4 (fb0) is primary device
[    1.632390] tsc: Refined TSC clocksource calibration: 2493.956 MHz
[    1.969637] Console: switching to colour frame buffer device 80x30
[    2.045103] usbcore: registered new interface driver smscufx
[    2.050847] uvesafb: VGABIOS Cirrus extension, VGABIOS Cirrus extension,=
 1.0, OEM: VGABIOS Cirrus extension, VBE v2.0
[    2.219431] uvesafb: no monitor limits have been set, default refresh ra=
te will be used
[    2.533474] uvesafb: VBE state buffer size cannot be determined (eax=3D0=
x14f, err=3D0)
[    2.875389] uvesafb: scrolling: redraw
[    3.051237] uvesafb: request region 0x3c0-0x3e0 failed
[    3.223082] uvesafb: probe of uvesafb.0 failed with error -5
[    3.388862] ipmi message handler version 39.2
[    3.553519] ipmi device interface
[    3.719380] IPMI System Interface driver.
[    3.886295] ipmi_si: Adding default-specified kcs state machine
[    4.057777] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    4.404806] ipmi_si: Interface detection failed
[    4.592440] ipmi_si: Adding default-specified smic state machine
[    4.771182] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    5.125252] ipmi_si: Interface detection failed
[    5.312454] ipmi_si: Adding default-specified bt state machine
[    5.493924] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    5.851912] ipmi_si: Interface detection failed
[    6.040598] ipmi_si: Unable to find any System Interface(s)
[    6.212961] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via =
sys_reboot.
[    6.559068] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    6.910831] ACPI: Power Button [PWRF]
[    7.087701] r3964: Philips r3964 Driver $Revision: 1.10 $
[    7.266314] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    7.461377] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    7.807997] serial: Freescale lpuart driver
[    7.979059] Initializing Nozomi driver 2.1d
[    8.146841] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    8.323236] ac.o: No PCI boards found.
[    8.323238] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    8.325355] Non-volatile memory driver v1.3
[    8.325361] toshiba: not a supported Toshiba laptop
[    8.325540] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    8.325782] platform pc8736x_gpio.0: no device found
[    8.325807] nsc_gpio initializing
[    8.325823] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[    8.326761] smapi::smapi_init, ERROR invalid usSmapiID
[    8.326765] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    8.326767] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    8.326768] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    8.327025] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    8.327037] Hangcheck: Using getrawmonotonic().
[    8.328213] [drm] Initialized drm 1.1.0 20060810
[    8.328322] [drm] radeon kernel modesetting enabled.
[    8.328788] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    8.328841] dummy-irq: no IRQ given.  Use irq=3DN
[    8.328915] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    8.329068] c2port c2port0: C2 port uc added
[    8.329070] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    8.329646] Guest personality initialized and is inactive
[    8.329855] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D61)
[    8.329856] Initialized host personality
[    8.329904] usbcore: registered new interface driver rtsx_usb
[    8.330611] usbcore: registered new interface driver viperboard
[    8.331514] Loading iSCSI transport class v2.0-870.
[    8.331931] rdac: device handler registered
[    8.331967] hp_sw: device handler registered
[    8.331968] emc: device handler registered
[    8.348791] fnic: Cisco FCoE HBA Driver, ver 1.5.0.45
[    8.349303] fnic: Successfully Initialized Trace Buffer
[    8.350156] bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v2.4.1 (Sep=
 17, 2013)
[    8.375878] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    8.376963] scsi: <fdomain> Detection failed (no card)
[    8.377391] qlogicfas: no cards were found, please specify I/O address a=
nd IRQ using iobase=3D and irq=3D options
[    8.377393] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.12-k.
[    8.377728] Brocade BFA FC/FCOE SCSI driver - version: 3.2.23.0
[    8.377769] csiostor: Chelsio FCoE driver 1.0.0
[    8.408734] Failed initialization of WD-7000 SCSI card!
[   13.519825] DC390: clustering now enabled by default. If you get problem=
s load
[   13.519826]        with "disable_clustering=3D1" and report to maintaine=
rs
[   13.519839] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[   13.519879] mpt2sas version 16.100.00.00 loaded
[   13.520803] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[   13.520855] 3ware 9000 Storage Controller device driver for Linux v2.26.=
02.014.
[   13.520872] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[   13.520886] nsp32: loading...
[   13.520899] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[   13.520916] RocketRAID 3xxx/4xxx Controller driver v1.8
[   13.521461] iscsi: registered transport (be2iscsi)
[   13.521468] In beiscsi_module_init, tt=3Dd2b7cfc0
[   13.521559] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[   13.521681] VMware PVSCSI driver - version 1.0.2.0-k
[   13.521700] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[   13.521842] SCSI Media Changer driver v0.25=20
[   13.523344] Rounding down aligned max_sectors from 4294967295 to 4294967=
288
[   13.525706] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[   13.525710] scx200_docflash: NatSemi SCx200 DOCCS Flash Driver
[   13.525802] slram: not enough parameters.
[   13.525803] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[   13.525805] pmc551: not detected
[   13.525819] HSI/SSI char device loaded
[   13.528273] tun: Universal TUN/TAP device driver, 1.6
[   13.528275] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   13.528596] arcnet loaded.
[   13.528600] arcnet: RFC1051 "simple standard" (`s') encapsulation suppor=
t loaded.
[   13.528601] arcnet: cap mode (`c') encapsulation support loaded.
[   13.528624] arcnet: COM90xx IO-mapped mode support (by David Woodhouse e=
t el.)
[   13.528624] E-mail me if you actually test this driver, please!
[   13.528626]  arc%d: No autoprobe for IO mapped cards; you must specify t=
he base address!
[   13.528643] arcnet: COM20020 ISA support (by David Woodhouse et al.)
[   13.528644]  arc%d: No autoprobe (yet) for IO mapped cards; you must spe=
cify the base address!
[   13.528645] arcnet: COM20020 PCI support
[   13.529294] vcan: Virtual CAN interface driver
[   13.529298] slcan: serial line CAN interface driver
[   13.529300] slcan: 10 dynamic interface channels.
[   13.529320] CAN device driver interface
[   13.529376] usbcore: registered new interface driver esd_usb2
[   13.529392] usbcore: registered new interface driver peak_usb
[   13.529473] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   13.529475] Copyright (c) 2007 Atheros Corporation.
[   13.529554] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.19 (Decemb=
er 19, 2013)
[   13.529730] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.78.19-0 (2014/02/10)
[   13.530411] Brocade 10G Ethernet driver - version: 3.2.23.0
[   13.530470] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.50
[   13.530533] vxge: Copyright(c) 2002-2010 Exar Corp.
[   13.530535] vxge: Driver version: 2.5.3.22640-k
[   13.530557] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[   13.530558] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   13.532329] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   13.532366] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[   15.650042] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[   15.650090] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[   15.650549] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   15.650551] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[   15.650619] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[   15.650620] igb: Copyright (c) 2007-2014 Intel Corporation.
[   15.650642] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.2-k
[   15.650643] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[   15.650656] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.19.1-k
[   15.650656] ixgbe: Copyright (c) 1999-2014 Intel Corporation.
[   15.650743] ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Ne=
twork Driver - version 2.12.1-k
[   15.650745] ixgbevf: Copyright (c) 2009 - 2012 Intel Corporation.
[   15.650762] i40e: Intel(R) Ethernet Connection XL710 Network Driver - ve=
rsion 0.3.32-k
[   15.650764] i40e: Copyright (c) 2013 - 2014 Intel Corporation.
[   15.650795] i40evf: Intel(R) XL710 X710 Virtual Function Network Driver =
- version 0.9.13
[   15.650797] Copyright (c) 2013 - 2014 Intel Corporation.
[   15.650849] jme: JMicron JMC2XX ethernet driver version 1.0.8
[   15.650974] Solarflare NET driver v4.0
[   15.651278] tehuti: Tehuti Networks(R) Network Driver, 7.29.3
[   15.651280] tehuti: Options: hw_csum=20
[   15.651503] AX.25: Z8530 SCC driver version 3.0.dl1bke
[   15.652065] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[   15.652073] AX.25: 6pack driver, Revision: 0.3.0
[   15.652082] AX.25: bpqether driver version 004
[   15.652084] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   15.652084] baycom_ser_fdx: version 0.10
[   15.652497] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   15.652498] hdlcdrv: version 0.8
[   15.652498] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   15.652498] baycom_ser_hdx: version 0.10
[   15.653597] usbcore: registered new interface driver irda-usb
[   15.653611] usbcore: registered new interface driver stir4200
[   15.653613] w83977af_init()
[   15.653614] w83977af_open()
[   15.653626] w83977af_probe()
[   15.654559] w83977af_probe(), Wrong chip version
[   15.654559] w83977af_probe()
[   15.659267] w83977af_probe(), Wrong chip version
[   15.659269] usbcore: registered new interface driver mcs7780
[   15.659459] usbcore: registered new interface driver ksdazzle-sir
[   15.659468] usbcore: registered new interface driver ks959-sir
[   15.659471] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=
=3D256).
[   15.659532] usbcore: registered new interface driver i2400m_usb
[   15.660553] ieee802154hardmac ieee802154hardmac: Added ieee802154 HardMA=
C hardware
[   15.660905] ieee802154fakelb ieee802154fakelb: added ieee802154 hardware
[   15.661364] usbcore: registered new interface driver catc
[   15.661376] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[   15.661443] usbcore: registered new interface driver pegasus
[   15.661455] usbcore: registered new interface driver rtl8150
[   15.661467] usbcore: registered new interface driver r8152
[   15.661477] usbcore: registered new interface driver cdc_ether
[   15.661486] usbcore: registered new interface driver r815x
[   15.661494] usbcore: registered new interface driver cdc_eem
[   15.661502] usbcore: registered new interface driver dm9601
[   15.661512] usbcore: registered new interface driver CoreChips
[   15.661520] usbcore: registered new interface driver gl620a
[   15.661537] usbcore: registered new interface driver net1080
[   15.661546] usbcore: registered new interface driver rndis_host
[   15.661562] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[   15.661586] usbcore: registered new interface driver int51x1
[   15.661594] usbcore: registered new interface driver cdc_phonet
[   15.661602] usbcore: registered new interface driver kalmia
[   15.661611] usbcore: registered new interface driver ipheth
[   15.661617] usbcore: registered new interface driver sierra_net
[   15.661625] usbcore: registered new interface driver cdc_ncm
[   15.661633] usbcore: registered new interface driver lg-vl600
[   15.661945] usbcore: registered new interface driver hwa-rc
[   15.661959] usbcore: registered new interface driver i1480-dfu-usb
[   15.661992] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   15.662004] ehci-pci: EHCI PCI platform driver
[   15.662022] ehci-platform: EHCI generic platform driver
[   15.662062] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   15.662071] ohci-platform: OHCI generic platform driver
[   15.662086] uhci_hcd: USB Universal Host Controller Interface driver
[   15.662813] usbcore: registered new interface driver hwa-hc
[   15.662832] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[   15.662833] Warning! fusbh200_hcd should always be loaded before uhci_hc=
d and ohci_hcd, not after
[   15.663093] usbcore: registered new interface driver wusb-cbaf
[   15.663118] usbcore: registered new interface driver cdc_acm
[   15.663121] cdc_acm: USB Abstract Control Model driver for USB modems an=
d ISDN adapters
[   15.663133] usbcore: registered new interface driver usblp
[   15.663142] usbcore: registered new interface driver usbtmc
[   15.663156] usbcore: registered new interface driver usb-storage
[   15.663167] usbcore: registered new interface driver ums-alauda
[   15.663174] usbcore: registered new interface driver ums-datafab
[   15.663181] usbcore: registered new interface driver ums-freecom
[   15.663188] usbcore: registered new interface driver ums-isd200
[   15.663194] usbcore: registered new interface driver ums-jumpshot
[   15.663201] usbcore: registered new interface driver ums-karma
[   15.663208] usbcore: registered new interface driver ums-onetouch
[   15.663216] usbcore: registered new interface driver ums-realtek
[   15.663226] usbcore: registered new interface driver ums-sddr09
[   15.663234] usbcore: registered new interface driver ums-sddr55
[   15.663242] usbcore: registered new interface driver ums-usbat
[   15.663255] usbcore: registered new interface driver mdc800
[   15.663257] mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Dig=
ital Camera
[   15.663271] usbcore: registered new interface driver adutux
[   15.663311] usbcore: registered new interface driver appledisplay
[   15.663320] usbcore: registered new interface driver emi26 - firmware lo=
ader
[   15.663335] usbcore: registered new interface driver emi62 - firmware lo=
ader
[   15.663335] driver ftdi-elan
[   15.663439] usbcore: registered new interface driver ftdi-elan
[   15.663641] usbcore: registered new interface driver idmouse
[   15.663916] usbcore: registered new interface driver iowarrior
[   15.663933] usbcore: registered new interface driver isight_firmware
[   15.663944] usbcore: registered new interface driver usblcd
[   15.663953] usbcore: registered new interface driver ldusb
[   15.663995] usbcore: registered new interface driver usbled
[   15.664009] usbcore: registered new interface driver legousbtower
[   15.664018] usbcore: registered new interface driver rio500
[   15.664028] usbcore: registered new interface driver usbtest
[   15.664044] usbcore: registered new interface driver usb_ehset_test
[   15.664055] usbcore: registered new interface driver trancevibrator
[   15.664066] usbcore: registered new interface driver usbsevseg
[   15.664162] usbcore: registered new interface driver sisusb
[   15.664223] usbcore: registered new interface driver cxacru
[   15.664232] usbcore: registered new interface driver ueagle-atm
[   15.664637] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   15.708978] serio: i8042 KBD port at 0x60,0x64 irq 1
[   15.709186] serio: i8042 AUX port at 0x60,0x64 irq 12
[   15.709632] mousedev: PS/2 mouse device common for all mice
[   15.709641] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[   15.711123] usbcore: registered new interface driver appletouch
[   15.711380] inport.c: Didn't find InPort mouse at 0x23c
[   15.712110] logibm.c: Didn't find Logitech busmouse at 0x23c
[   15.713077] usbcore: registered new interface driver synaptics_usb
[   15.713255] usbcore: registered new interface driver iforce
[   15.713340] usbcore: registered new interface driver xpad
[   15.713364] usbcore: registered new interface driver usb_acecad
[   15.713373] usbcore: registered new interface driver gtco
[   15.713384] usbcore: registered new interface driver hanwang
[   15.713393] usbcore: registered new interface driver wacom
[   15.713942] mk712: device not present
[   15.713974] usbcore: registered new interface driver usbtouchscreen
[   15.714675] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[   15.714713] usbcore: registered new interface driver ati_remote2
[   15.714811] usbcore: registered new interface driver keyspan_remote
[   15.714851] usbcore: registered new interface driver powermate
[   15.715139] wistron_btns: System unknown
[   15.715152] usbcore: registered new interface driver yealink
[   15.715155] ideapad_slidebar: DMI does not match
[   15.715403] rtc_cmos 00:00: RTC can wake from S4
[   15.717765] rtc (null): alarm rollover: day
[   15.719613] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[   15.721706] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[   15.722565] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[   15.737520] usbcore: registered new interface driver RobotFuzz Open Sour=
ce InterFace, OSIF
[   15.737561] usbcore: registered new interface driver i2c-tiny-usb
[   15.737642] isa i2c-pca-isa.0: Please specify I/O base
[   15.737864] Marvell M88ALP01 'CAFE' Camera Controller version 2
[   15.738798] m2m-testdev m2m-testdev.0: Device registered as /dev/video0
[   15.738938] PMS: not enabled, use pms.enable=3D1 to probe
[   15.739017] pps pps0: new PPS source ktimer
[   15.739021] pps pps0: ktimer PPS source registered
[   15.739065] Driver for 1-wire Dallas network protocol.
[   15.739137] usbcore: registered new interface driver DS9490R
[   15.739159] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[   15.739186] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   15.922472] hpet1: lost 11 rtc interrupts
[   16.320817] atkbd serio0: Failed to enable keyboard on isa0060/serio0
[   16.321416] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   16.321785] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[   16.354126] atkbd serio0: Spurious ACK on isa0060/serio0. Some program m=
ight be trying to access hardware directly.
[   16.354143] atkbd serio0: Spurious ACK on isa0060/serio0. Some program m=
ight be trying to access hardware directly.
[   16.585168] i2c i2c-0: detect fail: address match, 0x2c
[   16.600941] i2c i2c-0: detect fail: address match, 0x2d
[   16.616816] i2c i2c-0: detect fail: address match, 0x2e
[   16.632966] i2c i2c-0: detect fail: address match, 0x2f
[   16.760965] applesmc: supported laptop not found!
[   16.761011] applesmc: driver init failed (ret=3D-19)!
[   24.297006] intel_powerclamp: Intel powerclamp does not run on family 15=
 model 6
[   24.297290] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[   24.298017] acquirewdt: I/O address 0x0043 already in use
[   24.298026] acquirewdt: probe of acquirewdt failed with error -5
[   24.298050] alim7101_wdt: Steve Hill <steve@navaho.co.uk>
[   24.298051] alim7101_wdt: ALi M7101 PMU not present - WDT not set
[   24.298487] sc520_wdt: WDT driver for SC520 initialised. timeout=3D30 se=
c (nowayout=3D1)
[   24.298493] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[   24.298497] wafer5823wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[   24.298570] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[   24.299586] i6300esb: cannot register miscdev on minor=3D130 (err=3D-16)
[   24.300424] i6300ESB timer: probe of 0000:00:04.0 failed with error -16
[   24.301268] it87_wdt: no device
[   24.301743] sc1200wdt: build 20020303
[   24.301789] sc1200wdt: io parameter must be specified
[   24.301804] pc87413_wdt: Version 1.1 at io 0x2E
[   24.301826] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   24.301830] nv_tco: NV TCO WatchDog Timer Driver v0.01
[   24.302121] sbc60xxwdt: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[   24.302435] cpu5wdt: misc_register failed
[   24.303131] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[   24.304749] smsc37b787_wdt: Unable to register miscdev on minor 130
[   24.305268] w83697hf_wdt: WDT driver for W83697HF/HG initializing
[   24.305294] w83697hf_wdt: watchdog not found at address 0x2e
[   24.305295] w83697hf_wdt: No W83697HF/HG could be found
[   24.305298] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[   24.305310] w83697ug_wdt: No W83697UG/UF could be found
[   24.305319] w83877f_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[   24.305567] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[   24.305569] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[   24.305752] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D1)
[   24.311102] ISDN subsystem Rev: 1.1.2.3/1.1.2.2/none/none/1.1.2.2
[   24.311117] Modular ISDN core version 1.1.29
[   24.311439] NET: Registered protocol family 34
[   24.311442] DSP module 2.0
[   24.311444] mISDN_dsp: DSP clocks every 64 samples. This equals 2 jiffie=
s.
[   24.313881] usbcore: registered new interface driver HFC-S_USB
[   24.313886] AVM Fritz PCI driver Rev. 2.3
[   24.313940] Winbond W6692 PCI driver Rev. 2.0
[   24.313955] mISDNipac module version 2.0
[   24.313956] PCBIT-D device driver v 0.5-fjpc0 19991204 - Copyright (C) 1=
996 Universidade de Lisboa
[   24.313956] Trying to detect board using default settings
[   24.314066] SpellCaster ISA ISDN Adapter Driver rev. 2.0b1
[   24.314066] Copyright (C) 1996 SpellCaster Telecommunications Inc.
[   24.317585] Failed to find any adapters, driver unloaded
[   24.317594] IBM Active 2000 ISDN driver
[   24.318769] act2000: No cards defined yet
[   24.319030] gigaset: Driver for Gigaset 307x (debug build)
[   24.319042] gigaset: ISDN4Linux interface
[   24.319228] usbcore: registered new interface driver usb_gigaset
[   24.319229] usb_gigaset: USB Driver for Gigaset 307x using M105
[   24.319248] usbcore: registered new interface driver bas_gigaset
[   24.319249] bas_gigaset: USB Driver for Gigaset 307x
[   24.319332] lguest: switcher text too large (4384)
[   24.319360] cpufreq-nforce2: No nForce2 chipset.
[   24.319432] sdhci: Secure Digital Host Controller Interface driver
[   24.319433] sdhci: Copyright(c) Pierre Ossman
[   24.319464] wbsd: Winbond W83L51xD SD/MMC card interface driver
[   24.319465] wbsd: Copyright(c) Pierre Ossman
[   24.319832] VUB300 Driver rom wait states =3D 1C irqpoll timeout =3D 0400
[   24.319832] usbcore: registered new interface driver vub300
[   24.319851] sdhci-pltfm: SDHCI platform and OF driver helper
[   24.320670] leds_ss4200: no LED devices found
[   24.320868] ledtrig-cpu: registered to indicate activity on CPUs
[   24.321657] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[   24.321827] Driver for HIFN 795x crypto accelerator chip has been succes=
sfully registered.
[   24.321867] hidraw: raw HID events driver (C) Jiri Kosina
[   24.323098] usbip_core: USB/IP Core v1.0.0
[   24.323393] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[   24.323404] vhci_hcd vhci_hcd: new USB bus registered, assigned bus numb=
er 1
[   24.324599] hub 1-0:1.0: USB hub found
[   24.324684] hub 1-0:1.0: 8 ports detected
[   24.325041] vhci_hcd: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.=
0.0
[   24.325097] usbcore: registered new interface driver rts5139
[   24.325116] usbcore: registered new interface driver line6usb
[   24.325118] vme_user: VME User Space Access Driver
[   24.325118] vme_user: No cards, skipping registration
[   24.325864] Loading crystalhd 0.9.27
[   24.325931] beceem: Beceem Communications Inc. WiMAX driver, 5.2.45
[   24.325932] Copyright 2010. Beceem Communications Inc
[   24.325974] usbcore: registered new interface driver usbbcm
[   24.326114] input: Speakup as /devices/virtual/input/input4
[   24.326133] evbug: Connected device: input4 (Speakup at speakup/input0)
[   24.326371] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[   24.326895] speakup 3.1.6: initialized
[   24.326896] synth name on entry is: (null)
[   24.327142] usbcore: registered new interface driver cedusb
[   24.327360] dgnc: dgnc-1.3-16, Digi International Part Number 40002369_F
[   24.327361] dgnc: For the tools package or updated drivers please visit =
http://www.digi.com
[   24.327537] dgap-1.3-16, Digi International Part Number 40002347_C
[   24.327540] For the tools package please visit http://www.digi.com
[   24.327607] FPGA DOWNLOAD --->
[   24.327608] built at Fri Mar  7 00:36:07 2014 UTC
[   24.327608] FPGA image file name: xlinx_fpga_firmware.bit
[   24.328303] GPIO INIT FAIL!!
[   24.328529] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[   24.328544] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Boch=
s, please report, aborting!
[   24.328545] Initializing HPQ6001 module
[   24.328571] hdaps: supported laptop not found!
[   24.328572] hdaps: driver init failed (ret=3D-19)!
[   24.328577] fujitsu_tablet: Unknown (using defaults)
[   24.329997]  fake-fmc-carrier: mezzanine 0
[   24.330002]       Manufacturer: fake-vendor
[   24.330003]       Product name: fake-design-for-testing
[   24.330032] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   24.330054] fmc_trivial: probe of fake-design-for-testing-f001 failed wi=
th error -95
[   24.330062] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   24.330070] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eep=
rom: no busid passed, refusing all cards
[   24.330516] fmc fake-design-for-testing-f001: Driver has no ID: matches =
all
[   24.330796] fmc_chardev fake-design-for-testing-f001: Created misc devic=
e "fake-design-for-testing-f001"
[   24.330861] intel_rapl: driver does not support CPU family 15 model 6
[   24.336028] no UART detected at 0x1
[   24.340106] Motu MidiTimePiece on parallel port irq: 7 ioport: 0x378
[   24.340640] usbcore: registered new interface driver snd-usb-audio
[   24.340700] usbcore: registered new interface driver snd-usb-usx2y
[   24.340827] usbcore: registered new interface driver snd-usb-us122l
[   24.340841] usbcore: registered new interface driver snd-usb-caiaq
[   24.342390] NET: Registered protocol family 26
[   24.342397] GACT probability on
[   24.343090] netem: version 1.3
[   24.343195] u32 classifier
[   24.343197]     Performance counters on
[   24.343197]     Actions configured
[   24.343275] NET: Registered protocol family 15
[   24.344617] NET: Registered protocol family 6
[   24.346337] NET: Registered protocol family 11
[   24.346849] NET: Registered protocol family 3
[   24.346898] can: controller area network core (rev 20120528 abi 9)
[   24.347026] NET: Registered protocol family 29
[   24.347030] can: raw protocol (rev 20120528)
[   24.347033] can: netlink gateway (rev 20130117) max_hops=3D1
[   24.347494] lec:lane_module_init: lec.c: initialized
[   24.347496] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet=
 Project Team
[   24.347572] DECnet: Routing cache hash table of 512 buckets, 10Kbytes
[   24.347585] NET: Registered protocol family 12
[   24.347606] NET: Registered protocol family 35
[   24.347633] 8021q: 802.1Q VLAN Support v1.8
[   24.347667] 9pnet: Installing 9P2000 support
[   24.347707] NET: Registered protocol family 37
[   24.347731] NET: Registered protocol family 36
[   24.348168] Key type dns_resolver registered
[   24.348580] batman_adv: B.A.T.M.A.N. advanced 2014.1.0 (compatibility ve=
rsion 15) loaded
[   24.348582] openvswitch: Open vSwitch switching datapath
[   24.350250]=20
[   24.350250] printing PIC contents
[   24.350264] ... PIC  IMR: ffff
[   24.350268] ... PIC  IRR: 1113
[   24.350275] ... PIC  ISR: 0000
[   24.350279] ... PIC ELCR: 0c00
[   24.350298] printing local APIC contents on CPU#0/0:
[   24.350301] ... APIC ID:      00000000 (0)
[   24.350304] ... APIC VERSION: 00050014
[   24.350306] ... APIC TASKPRI: 00000000 (00)
[   24.350310] ... APIC PROCPRI: 00000000
[   24.350311] ... APIC LDR: 01000000
[   24.350312] ... APIC DFR: ffffffff
[   24.350313] ... APIC SPIV: 000001ff
[   24.350313] ... APIC ISR field:
[   24.350323] 000000000000000000000000000000000000000000000000000000000000=
0000
[   24.350323] ... APIC TMR field:
[   24.350328] 000000000220000000000000000000000000000000000000000000000000=
0000
[   24.350329] ... APIC IRR field:
[   24.350335] 000000000000000000000000000000000000000000000000000000000000=
0000
[   24.350337] ... APIC ESR: 00000000
[   24.350338] ... APIC ICR: 000008fd
[   24.350339] ... APIC ICR2: 02000000
[   24.350340] ... APIC LVTT: 000200ef
[   24.350341] ... APIC LVTPC: 00010000
[   24.350342] ... APIC LVT0: 00010700
[   24.350343] ... APIC LVT1: 00000400
[   24.350344] ... APIC LVTERR: 000000fe
[   24.350345] ... APIC TMICT: 0003d090
[   24.350348] ... APIC TMCCT: 000240a0
[   24.350348] ... APIC TDCR: 00000003
[   24.350349]=20
[   24.350350] number of MP IRQ sources: 15.
[   24.350352] number of IO-APIC #0 registers: 24.
[   24.350352] testing the IO APIC.......................
[   24.350368] IO APIC #0......
[   24.350368] .... register #00: 00000000
[   24.350368] .......    : physical APIC id: 00
[   24.350369] .......    : Delivery Type: 0
[   24.350369] .......    : LTS          : 0
[   24.350370] .... register #01: 00170011
[   24.350370] .......     : max redirection entries: 17
[   24.350370] .......     : PRQ implemented: 0
[   24.350371] .......     : IO APIC version: 11
[   24.350371] .... register #02: 00000000
[   24.350371] .......     : arbitration: 00
[   24.350372] .... IRQ redirection table:
[   24.350381] 1    0    0   0   0    0    0    00
[   24.350389] 0    0    0   0   0    1    1    31
[   24.350398] 0    0    0   0   0    1    1    30
[   24.350406] 0    0    0   0   0    1    1    33
[   24.350414] 1    0    0   0   0    1    1    34
[   24.350422] 0    1    0   0   0    1    1    35
[   24.350429] 0    0    0   0   0    1    1    36
[   24.350437] 0    0    0   0   0    1    1    37
[   24.350445] 0    0    0   0   0    1    1    38
[   24.350453] 0    1    0   0   0    1    1    39
[   24.350461] 1    1    0   0   0    1    1    3A
[   24.350471] 1    1    0   0   0    1    1    3B
[   24.350479] 0    0    0   0   0    1    1    3C
[   24.350486] 0    0    0   0   0    1    1    3D
[   24.350494] 0    0    0   0   0    1    1    3E
[   24.350502] 0    0    0   0   0    1    1    3F
[   24.350510] 1    0    0   0   0    0    0    00
[   24.350517] 1    0    0   0   0    0    0    00
[   24.350525] 1    0    0   0   0    0    0    00
[   24.350533] 1    0    0   0   0    0    0    00
[   24.350540] 1    0    0   0   0    0    0    00
[   24.350548] 1    0    0   0   0    0    0    00
[   24.350556] 1    0    0   0   0    0    0    00
[   24.350564] 1    0    0   0   0    0    0    00
[   24.350564] IRQ to pin mappings:
[   24.350576] IRQ0 -> 0:2
[   24.350576] IRQ1 -> 0:1
[   24.350577] IRQ3 -> 0:3
[   24.350578] IRQ4 -> 0:4
[   24.350579] IRQ5 -> 0:5
[   24.350579] IRQ6 -> 0:6
[   24.350580] IRQ7 -> 0:7
[   24.350581] IRQ8 -> 0:8
[   24.350582] IRQ9 -> 0:9
[   24.350582] IRQ10 -> 0:10
[   24.350583] IRQ11 -> 0:11
[   24.350584] IRQ12 -> 0:12
[   24.350585] IRQ13 -> 0:13
[   24.350586] IRQ14 -> 0:14
[   24.350586] IRQ15 -> 0:15
[   24.350587] .................................... done.
[   24.350589] Using IPI No-Shortcut mode
[   24.351595] Loading compiled-in X.509 certificates
[   24.352502] Key type trusted registered
[   24.352517] IMA: No TPM chip found, activating TPM-bypass!
[   70.816613] spin_lock-torture: Writes:  Total: 4  Max/Min: 0/0   Fail: 0=
=20
[  106.165399] console [netcon0] enabled
[  106.267407] netconsole: network logging started
[  106.374175] rtc_cmos 00:00: setting system clock to 2014-03-07 01:18:42 =
UTC (1394155122)
[  106.610519] ALSA device list:
[  106.738444]   #0: Loopback 1
[  106.867578]   #1: Virtual MIDI Card 1
[  107.002146]   #2: MTPAV on parallel port at 0x378
[  107.138481] random: nonblocking pool is initialized
[  107.276022] Freeing unused kernel memory: 800K (d2c49000 - d2d11000)
[  107.417645] BUG: using __this_cpu_add() in preemptible [00000000] code: =
swapper/0/1
[  107.703813] caller is __this_cpu_preempt_check+0x3b/0x60
[  107.852357] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5-next-20=
140306-06952-g0ffb2fe #1
[  108.157111] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  108.319103]  00000000 00000000 d343deec d22ec747 00000000 d343df10 d13ef=
dcd d290362c
[  108.685150]  d343df28 00000000 d34403d8 00000001 d343df28 d0745000 d343d=
f58 d13efe2b
[  109.086205]  d343df28 00000028 d2902c14 d2a74fc6 68745f5f 635f7369 615f7=
570 29286464
[  109.512575] Call Trace:
[  109.718526]  [<d22ec747>] dump_stack+0x4b/0x75
[  109.927550]  [<d13efdcd>] check_preemption_disabled+0xcd/0xe0
[  110.138792]  [<d13efe2b>] __this_cpu_preempt_check+0x3b/0x60
[  110.351853]  [<d106966b>] ? preempt_count_add+0x4b/0xa0
[  110.564753]  [<d10f3fa2>] kmem_cache_alloc+0xc2/0x190
[  110.776294]  [<d11077ff>] ? getname_kernel+0x3f/0x80
[  110.983777]  [<d11077ff>] getname_kernel+0x3f/0x80
[  111.181555]  [<d100036d>] run_init_process+0xd/0x20
[  111.381971]  [<d22e42d2>] kernel_init+0x32/0xe0
[  111.578459]  [<d230315b>] ret_from_kernel_thread+0x1b/0x30
[  111.768674]  [<d22e42a0>] ? rest_init+0x70/0x70
[  111.959006] BUG: using __this_cpu_add() in preemptible [00000000] code: =
swapper/0/1
[  112.355107] caller is __this_cpu_preempt_check+0x3b/0x60
[  112.553383] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc5-next-20=
140306-06952-g0ffb2fe #1
[  112.955533] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[  113.162708]  00000000 00000000 d343deac d22ec747 00000001 d343ded0 d13ef=
dcd d290362c
[  113.602376]  d343dee8 00000000 d34403d8 00000001 d343dee8 c001b400 d343d=
f18 d13efe2b
[  114.059422]  d343dee8 00000028 d2902c14 d2a74fc6 68745f5f 635f7369 615f7=
570 29286464
[  114.521193] Call Trace:
[  114.734074]  [<d22ec747>] dump_stack+0x4b/0x75
[  114.940517]  [<d13efdcd>] check_preemption_disabled+0xcd/0xe0
[  115.142378]  [<d13efe2b>] __this_cpu_preempt_check+0x3b/0x60
[  115.341154]  [<d22ff445>] ? preempt_schedule+0x35/0x50

Elapsed time: 115
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-a=
n0-03070034/0ffb2fe7b9c30082876fa3a17da018bf0632cf03/vmlinuz-3.14.0-rc5-nex=
t-20140306-06952-g0ffb2fe -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,=
115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-an0-03070034/next:master/.vmlinuz-0ffb2fe7b9c30082876fa3=
a17da018bf0632cf03-20140307011128-4-ivytown2 branch=3Dnext/master BOOT_IMAG=
E=3D/kernel/i386-randconfig-an0-03070034/0ffb2fe7b9c30082876fa3a17da018bf06=
32cf03/vmlinuz-3.14.0-rc5-next-20140306-06952-g0ffb2fe'  -initrd /kernel-te=
sts/initrd/yocto-minimal-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=3De=
1000 -net user,vlan=3D1,hostfwd=3Dtcp::17018-:22 -boot order=3Dnc -no-reboo=
t -watchdog i6300esb -rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yoct=
o-ivytown2-18 -serial file:/dev/shm/kboot/serial-yocto-ivytown2-18 -daemoni=
ze -display none -monitor null=20

--AjmyJqqohANyBN/e
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-an0-03070034-0ffb2fe7b9c30082876fa3a17da018bf0632cf03-BUG:-using----in-preemptible----code:-14502.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDA5ZGUxOTIyNDJkODZlZGU0NDkxNDZhYzQyM2VmZmNhNTNiYzE4MTAK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjAt
MDMwNzAwMzQvbmV4dDptYXN0ZXI6MDlkZTE5MjI0MmQ4NmVkZTQ0OTE0NmFjNDIzZWZmY2E1
M2JjMTgxMDpiaXNlY3QtbGludXgyCgoyMDE0LTAzLTA3LTAzOjEyOjM0IDA5ZGUxOTIyNDJk
ODZlZGU0NDkxNDZhYzQyM2VmZmNhNTNiYzE4MTAgY29tcGlsaW5nCjE1MSByZWFsICAyNzk1
IHVzZXIgIDIxNiBzeXMgIDE5ODMuMDAlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3
MDAzNAoKMjAxNC0wMy0wNy0wMzoxNToyNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAt
cmM1LTA2NDk0LWcwOWRlMTkyLi4uLi4uCTEuLi4uCTQJNi4JNy4uLgk5CTEwCTExCTEyCTEz
CTE1CTE2CTE4CTIwIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgMDlkZTE5MjI0MmQ4
NmVkZTQ0OTE0NmFjNDIzZWZmY2E1M2JjMTgxMApnaXQgYmlzZWN0IHN0YXJ0IDBmZmIyZmU3
YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMgMDlkZTE5MjI0MmQ4NmVkZTQ0OTE0
NmFjNDIzZWZmY2E1M2JjMTgxMCAtLQovYy9rZXJuZWwtdGVzdHMvbGluZWFyLWJpc2VjdDog
WyItYiIsICIwZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzIiwgIi1n
IiwgIjA5ZGUxOTIyNDJkODZlZGU0NDkxNDZhYzQyM2VmZmNhNTNiYzE4MTAiLCAiL2Mva2Vy
bmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIva2VybmVsLXRlc3Rz
L2xpbnV4Mi9vYmotYmlzZWN0Il0KQmlzZWN0aW5nOiA0NTggcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpCls0MzljZGUxZjNkODIzMGY4NThj
MGE1NTkwMjM4MWQyNGNkN2EyZGYyXSBNZXJnZSBicmFuY2ggJ2FrcG0vbWFzdGVyJwpydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5l
bC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNC9uZXh0Om1hc3Rlcjo0MzljZGUx
ZjNkODIzMGY4NThjMGE1NTkwMjM4MWQyNGNkN2EyZGYyOmJpc2VjdC1saW51eDIKCjIwMTQt
MDMtMDctMDM6Mjg6NTkgNDM5Y2RlMWYzZDgyMzBmODU4YzBhNTU5MDIzODFkMjRjZDdhMmRm
MiBjb21waWxpbmcKMjAyIHJlYWwgIDI3OTQgdXNlciAgMjE3IHN5cyAgMTQ4Ny44MyUgY3B1
IAlpMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0CgoyMDE0LTAzLTA3LTAzOjMzOjA1IGRl
dGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUtMDY5NDgtZzQzOWNkZTEuLi4uLi4uLiBU
RVNUIEZBSUxVUkUKWyAgMTA5LjA2NDQ1NF0gICAjMjogTVRQQVYgb24gcGFyYWxsZWwgcG9y
dCBhdCAweDM3OApbICAxMDkuMjI4NTkzXSByYW5kb206IG5vbmJsb2NraW5nIHBvb2wgaXMg
aW5pdGlhbGl6ZWQKWyAgMTA5LjM5NDgwMV0gRnJlZWluZyB1bnVzZWQga2VybmVsIG1lbW9y
eTogODAwSyAoYzcyMmYwMDAgLSBjNzJmNzAwMCkKWyAgMTA5LjU2MzgzOV0gQlVHOiB1c2lu
ZyBfX3RoaXNfY3B1X2FkZCgpIGluIHByZWVtcHRpYmxlIFswMDAwMDAwMF0gY29kZTogc3dh
cHBlci8wLzEKWyAgMTA5LjkxMjg2Nl0gY2FsbGVyIGlzIF9fdGhpc19jcHVfcHJlZW1wdF9j
aGVjaysweDNiLzB4NjAKWyAgMTEwLjA5MjQ3MF0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2Fw
cGVyLzAgTm90IHRhaW50ZWQgMy4xNC4wLXJjNS0wNjk0OC1nNDM5Y2RlMSAjMzgKWyAgMTEw
LjQ2NTY1Ml0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJT1MgQm9jaHMgMDEvMDEv
MjAxMQpbICAxMTAuNjcwNDk3XSAgMDAwMDAwMDAgMDAwMDAwMDAgZDIwM2RlZWMgYzY4ZDkz
OWMgMDAwMDAwMDAgZDIwM2RmMTAgYzU5ZjE0NmQgYzZlZWRmMjQKWyAgMTExLjExMjMxMF0g
IGQyMDNkZjI4IDAwMDAwMDAwIGQyMDQwM2Q4IDAwMDAwMDAxIGQyMDNkZjI4IGQzYjdkMDAw
IGQyMDNkZjU4IGM1OWYxNGNiClsgIDExMS41ODYxNTZdICBkMjAzZGYyOCAwMDAwMDAyOCBj
NmVlZDU0MCBjNzA1YWI2YSA2ODc0NWY1ZiA2MzVmNzM2OSA2MTVmNzU3MCAyOTI4NjQ2NApb
ICAxMTIuMDc5NzQwXSBDYWxsIFRyYWNlOgpbICAxMTIuMzE3NTEzXSAgWzxjNjhkOTM5Yz5d
IGR1bXBfc3RhY2srMHg0Yi8weDc1ClsgIDExMi41NTkxMTJdICBbPGM1OWYxNDZkPl0gY2hl
Y2tfcHJlZW1wdGlvbl9kaXNhYmxlZCsweGNkLzB4ZTAKWyAgMTEyLjc5ODcxMl0gIFs8YzU5
ZjE0Y2I+XSBfX3RoaXNfY3B1X3ByZWVtcHRfY2hlY2srMHgzYi8weDYwClsgIDExMy4wMzQ1
MDVdICBbPGM1NjY5NzZiPl0gPyBwcmVlbXB0X2NvdW50X2FkZCsweDRiLzB4YTAKWyAgMTEz
LjI3MTQxMl0gIFs8YzU2ZjQyNDI+XSBrbWVtX2NhY2hlX2FsbG9jKzB4YzIvMHgxOTAKCkVs
YXBzZWQgdGltZTogMTE1CnFlbXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUt
a3ZtIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0LzQzOWNk
ZTFmM2Q4MjMwZjg1OGMwYTU1OTAyMzgxZDI0Y2Q3YTJkZjIvdm1saW51ei0zLjE0LjAtcmM1
LTA2OTQ4LWc0MzljZGUxIC1hcHBlbmQgJ2h1bmdfdGFza19wYW5pYz0xIGVhcmx5cHJpbnRr
PXR0eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRlYnVnIHN5c3JxX2Fsd2F5c19lbmFibGVkIHBh
bmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9y
YW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwg
IHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvbmV4dDptYXN0ZXI6NDM5Y2RlMWYzZDgyMzBm
ODU4YzBhNTU5MDIzODFkMjRjZDdhMmRmMjpiaXNlY3QtbGludXgyLy52bWxpbnV6LTQzOWNk
ZTFmM2Q4MjMwZjg1OGMwYTU1OTAyMzgxZDI0Y2Q3YTJkZjItMjAxNDAzMDcwMzMyNDMtMTQt
aXZ5dG93bjIgYnJhbmNoPW5leHQvbWFzdGVyIEJPT1RfSU1BR0U9L2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYW4wLTAzMDcwMDM0LzQzOWNkZTFmM2Q4MjMwZjg1OGMwYTU1OTAyMzgxZDI0
Y2Q3YTJkZjIvdm1saW51ei0zLjE0LjAtcmM1LTA2OTQ4LWc0MzljZGUxJyAgLWluaXRyZCAv
a2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFsLWNvcmUtaTM4Ni5jZ3ogLW0gMzIwIC1zbXAg
MiAtbmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSxob3N0Zndk
PXRjcDo6MTE3MjUtOjIyIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2
MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlk
LXF1YW50YWwtaXZ5dG93bjItMTQgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3Nlcmlh
bC1xdWFudGFsLWl2eXRvd24yLTE0IC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRv
ciBudWxsIAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvNDM5Y2RlMWYz
ZDgyMzBmODU4YzBhNTU5MDIzODFkMjRjZDdhMmRmMi9kbWVzZy1xdWFudGFsLWl2eXRvd24y
LTI3OjIwMTQwMzA3MDMzNjQzOmkzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQ6My4xNC4w
LXJjNS0wNjk0OC1nNDM5Y2RlMTozOAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMw
NzAwMzQvNDM5Y2RlMWYzZDgyMzBmODU4YzBhNTU5MDIzODFkMjRjZDdhMmRmMi9kbWVzZy15
b2N0by1pdnl0b3duMi0yNToyMDE0MDMwNzAzMzY0MzppMzg2LXJhbmRjb25maWctYW4wLTAz
MDcwMDM0OjMuMTQuMC1yYzUtMDY5NDgtZzQzOWNkZTE6MzgKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctYW4wLTAzMDcwMDM0LzQzOWNkZTFmM2Q4MjMwZjg1OGMwYTU1OTAyMzgxZDI0Y2Q3
YTJkZjIvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xNDoyMDE0MDMwNzAzMzY1MTppMzg2LXJh
bmRjb25maWctYW4wLTAzMDcwMDM0OjMuMTQuMC1yYzUtMDY5NDgtZzQzOWNkZTE6MzgKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0LzQzOWNkZTFmM2Q4MjMwZjg1OGMw
YTU1OTAyMzgxZDI0Y2Q3YTJkZjIvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi05OjIwMTQwMzA3
MDMzNjQ4OmkzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQ6My4xNC4wLXJjNS0wNjk0OC1n
NDM5Y2RlMTozOAowOjQ6NCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAx
NC0wMy0wNyAwMzozNzowNiBSRVBFQVQgQ09VTlQ6IDIwICAjIC9rZXJuZWwtdGVzdHMvbGlu
dXgyL29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2VjdGluZzogNDU0IHJldmlzaW9ucyBs
ZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA5IHN0ZXBzKQpbY2UzNDc3OGViNGQ5
ZmEwYWFhZWFlNzZjMTA2ODAyNmVlNTI1NWZkN10gTWVyZ2UgYnJhbmNoICdha3BtLWN1cnJl
bnQvY3VycmVudCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvbmV4
dDptYXN0ZXI6Y2UzNDc3OGViNGQ5ZmEwYWFhZWFlNzZjMTA2ODAyNmVlNTI1NWZkNzpiaXNl
Y3QtbGludXgyCgoyMDE0LTAzLTA3LTAzOjM3OjA3IGNlMzQ3NzhlYjRkOWZhMGFhYWVhZTc2
YzEwNjgwMjZlZTUyNTVmZDcgY29tcGlsaW5nCjE0NCByZWFsICAyODM2IHVzZXIgIDIxNyBz
eXMgIDIxMTUuMDIlIGNwdSAJaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNAoKMjAxNC0w
My0wNy0wMzozOTo0NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTA2ODkzLWdj
ZTM0Nzc4Li4uLi4uLi4JMgkzCTYJOC4uCTkuLi4uCTEwLgkxMQkxMy4uLgkxNC4uLi4uCTE4
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTE5Li4uLgkyMCBTVUNDRVNTCgpCaXNl
Y3Rpbmc6IDU1IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA2
IHN0ZXBzKQpbMTE3MzE0NDYxZTgyYWRhYmI2Yjc4ZGNiMDMyNTlkYTc1YjUwODMzYl0gbW06
IGRvbid0IGltcGxpY3RseSBpbmNsdWRlIGxpbnV4L21tLmggaW4gbGludXgvc2NoZWQuaApy
dW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tl
cm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNC9uZXh0Om1hc3RlcjoxMTcz
MTQ0NjFlODJhZGFiYjZiNzhkY2IwMzI1OWRhNzViNTA4MzNiOmJpc2VjdC1saW51eDIKCjIw
MTQtMDMtMDctMDQ6MTQ6MjAgMTE3MzE0NDYxZTgyYWRhYmI2Yjc4ZGNiMDMyNTlkYTc1YjUw
ODMzYiBjb21waWxpbmcKMTQwIHJlYWwgIDI0NDAgdXNlciAgMjE2IHN5cyAgMTg5OC40OSUg
Y3B1IAlpMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0CgoyMDE0LTAzLTA3LTA0OjE2OjU2
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUtMDY4OTQtZzExNzMxNDQuLi4uLi4J
MQkyCTMuCTgJOQkxMQkxMy4uLi4JMTQJMTUuCTE4Li4uCTE5CTIwIFNVQ0NFU1MKCmxpbmVh
ci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIGJyYW5jaCAnYWtwbS9tYXN0ZXInCmxpbmVh
ci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0
IGJpc2VjdCBzdGFydCA0MzljZGUxZjNkODIzMGY4NThjMGE1NTkwMjM4MWQyNGNkN2EyZGYy
IDExNzMxNDQ2MWU4MmFkYWJiNmI3OGRjYjAzMjU5ZGE3NWI1MDgzM2IgLS0KUHJldmlvdXMg
SEVBRCBwb3NpdGlvbiB3YXMgMTE3MzE0NC4uLiBtbTogZG9uJ3QgaW1wbGljdGx5IGluY2x1
ZGUgbGludXgvbW0uaCBpbiBsaW51eC9zY2hlZC5oCkhFQUQgaXMgbm93IGF0IGY3MTE5NGEu
Li4gTWVyZ2UgYnJhbmNoICd4ODYvdXJnZW50JyBvZiBnaXQ6Ly9naXQua2VybmVsLm9yZy9w
dWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdGlwL3RpcApCaXNlY3Rpbmc6IDI2IHJldmlzaW9u
cyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbOWQ1OGNmN2Ez
ODhjMWI0YTA2Y2IzMzU5ODBlYjFiYjEzNTJiYTg3Nl0gc2NoZWR1bGVyOiByZXBsYWNlIF9f
Z2V0X2NwdV92YXIgd2l0aCB0aGlzX2NwdV9wdHIKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2Vj
dCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2Vy
bmVsLXRlc3RzL2xpbnV4Mi9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Mi9vYmotYmlz
ZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWct
YW4wLTAzMDcwMDM0L25leHQ6bWFzdGVyOjlkNThjZjdhMzg4YzFiNGEwNmNiMzM1OTgwZWIx
YmIxMzUyYmE4NzY6YmlzZWN0LWxpbnV4MgoKMjAxNC0wMy0wNy0wNDozMDozOSA5ZDU4Y2Y3
YTM4OGMxYjRhMDZjYjMzNTk4MGViMWJiMTM1MmJhODc2IGNvbXBpbGluZwoxNDggcmVhbCAg
Mjc4MCB1c2VyICAyNDcgc3lzICAyMDQxLjcyJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1hbjAt
MDMwNzAwMzQKCjIwMTQtMDMtMDctMDQ6MzM6MjUgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
NC4wLXJjNS0wNjkyMS1nOWQ1OGNmNy4uLi4uIFRFU1QgRkFJTFVSRQpbICAgMjUuNjg1MDQx
XSBJTUE6IE5vIFRQTSBjaGlwIGZvdW5kLCBhY3RpdmF0aW5nIFRQTS1ieXBhc3MhClsgICAy
Ny45NDEwNTFdIGlucHV0OiBQUy8yIExvZ2l0ZWNoIFdoZWVsIE1vdXNlIGFzIC9kZXZpY2Vz
L3BsYXRmb3JtL2k4MDQyL3NlcmlvMS9pbnB1dC9pbnB1dDYKWyAgIDI3Ljk0MTI3OV0gZXZi
dWc6IENvbm5lY3RlZCBkZXZpY2U6IGlucHV0NiAoUFMvMiBMb2dpdGVjaCBXaGVlbCBNb3Vz
ZSBhdCBpc2EwMDYwL3NlcmlvMS9pbnB1dDApClsgICAyOC4wMTE0MzhdIGV2YnVnOiBFdmVu
dC4gRGV2OiBpbnB1dDYsIFR5cGU6IDIsIENvZGU6IDAsIFZhbHVlOiAyNTAKWyAgIDI4LjAx
MTQzOV0gZXZidWc6IEV2ZW50LiBEZXY6IGlucHV0NiwgVHlwZTogMiwgQ29kZTogMSwgVmFs
dWU6IC0yNTAKWyAgIDI4LjAxMTQ0MF0gZXZidWc6IEV2ZW50LiBEZXY6IGlucHV0NiwgVHlw
ZTogMCwgQ29kZTogMCwgVmFsdWU6IDAKWyAgIDcxLjQ5MDA5MF0gc3Bpbl9sb2NrLXRvcnR1
cmU6IFdyaXRlczogIFRvdGFsOiA0ICBNYXgvTWluOiAwLzAgICBGYWlsOiAwIApbICAxMDMu
OTUyMzYyXSBjb25zb2xlIFtuZXRjb24wXSBlbmFibGVkClsgIDEwNC4wOTE2NjBdIG5ldGNv
bnNvbGU6IG5ldHdvcmsgbG9nZ2luZyBzdGFydGVkCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LWFuMC0wMzA3MDAzNC85ZDU4Y2Y3YTM4OGMxYjRhMDZjYjMzNTk4MGViMWJiMTM1MmJhODc2
L2RtZXNnLXlvY3RvLWl2eXRvd24yLTMwOjIwMTQwMzA3MDQzNTQ2OmkzODYtcmFuZGNvbmZp
Zy1hbjAtMDMwNzAwMzQ6My4xNC4wLXJjNS0wNjkyMS1nOWQ1OGNmNzo0MQowOjE6MSBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0wNyAwNDozNTo1NyBSRVBF
QVQgQ09VTlQ6IDIwICAjIC9rZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QvLnJlcGVh
dBtbMG0KCkJpc2VjdGluZzogMTMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlz
IChyb3VnaGx5IDQgc3RlcHMpCltiMmZmMmNmZWJhZDkyYmViZmNhMjhiYWQ2NTAwNDU4MjFl
ZDI3MGM0XSB0cmFjaW5nOiByZXBsYWNlIF9fZ2V0X2NwdV92YXIgdXNlcyB3aXRoIHRoaXNf
Y3B1X3B0cgpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1
cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDIvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNC9uZXh0Om1h
c3RlcjpiMmZmMmNmZWJhZDkyYmViZmNhMjhiYWQ2NTAwNDU4MjFlZDI3MGM0OmJpc2VjdC1s
aW51eDIKCjIwMTQtMDMtMDctMDQ6MzU6NTkgYjJmZjJjZmViYWQ5MmJlYmZjYTI4YmFkNjUw
MDQ1ODIxZWQyNzBjNCBjb21waWxpbmcKMTQ1IHJlYWwgIDI3ODIgdXNlciAgMjEzIHN5cyAg
MjA2MS43NCUgY3B1IAlpMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0CgoyMDE0LTAzLTA3
LTA0OjM4OjQxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUtMDY5MDctZ2IyZmYy
Y2YuLi4uLi4gVEVTVCBGQUlMVVJFClsgIDExMS41MzQ1NDJdICAgIzE6IFZpcnR1YWwgTUlE
SSBDYXJkIDEKWyAgMTExLjY4MzU1MF0gICAjMjogTVRQQVYgb24gcGFyYWxsZWwgcG9ydCBh
dCAweDM3OApbICAxMTEuODMwNDM5XSBGcmVlaW5nIHVudXNlZCBrZXJuZWwgbWVtb3J5OiA4
MDBLIChkMGUyZjAwMCAtIGQwZWY3MDAwKQpbICAxMTEuOTg0NDQ2XSBCVUc6IHVzaW5nIF9f
dGhpc19jcHVfYWRkKCkgaW4gcHJlZW1wdGlibGUgWzAwMDAwMDAwXSBjb2RlOiBzd2FwcGVy
LzAvMQpbICAxMTIuMzAzMDA2XSBjYWxsZXIgaXMgX190aGlzX2NwdV9wcmVlbXB0X2NoZWNr
KzB4M2IvMHg2MApbICAxMTIuNDY5NjI3XSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIv
MCBOb3QgdGFpbnRlZCAzLjE0LjAtcmM1LTA2OTA3LWdiMmZmMmNmICM0MgpbICAxMTIuODEy
MDU4XSBIYXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDEx
ClsgIDExMi45OTY0NThdICAwMDAwMDAwMCAwMDAwMDAwMCBkMjAzZGVlYyBkMDRkOTMzYyAw
MDAwMDAwMCBkMjAzZGYxMCBjZjVmMTQwZCBkMGFlZGVlOApbICAxMTMuNDEwMTQ2XSAgZDIw
M2RmMjggMDAwMDAwMDAgZDIwNDAzZDggMDAwMDAwMDEgZDIwM2RmMjggZDNiNWQwMDAgZDIw
M2RmNTggY2Y1ZjE0NmIKWyAgMTEzLjg1NjI0MF0gIGQyMDNkZjI4IDAwMDAwMDI4IGQwYWVk
NTA0IGQwYzVhYjJlIDY4NzQ1ZjVmIDYzNWY3MzY5IDYxNWY3NTcwIDI5Mjg2NDY0ClsgIDEx
NC4zMjg5MTFdIENhbGwgVHJhY2U6ClsgIDExNC41NTcxMzBdICBbPGQwNGQ5MzNjPl0gZHVt
cF9zdGFjaysweDRiLzB4NzUKWyAgMTE0Ljc4NjUxNl0gIFs8Y2Y1ZjE0MGQ+XSBjaGVja19w
cmVlbXB0aW9uX2Rpc2FibGVkKzB4Y2QvMHhlMApbICAxMTUuMDE3NzM0XSAgWzxjZjVmMTQ2
Yj5dIF9fdGhpc19jcHVfcHJlZW1wdF9jaGVjaysweDNiLzB4NjAKWyAgMTE1LjI0OTY0Nl0g
IFs8Y2YyNjk3OWI+XSA/IHByZWVtcHRfY291bnRfYWRkKzB4NGIvMHhhMApbICAxMTUuNDgz
MjQ4XSAgWzxjZjJmNDFlMj5dIGttZW1fY2FjaGVfYWxsb2MrMHhjMi8weDE5MApbICAxMTUu
NzE2NzYxXSAgWzxjZjMwN2FjZj5dID8gZ2V0bmFtZV9rZXJuZWwrMHgzZi8weDgwClsgIDEx
NS45NTIxMjBdICBbPGNmMzA3YWNmPl0gZ2V0bmFtZV9rZXJuZWwrMHgzZi8weDgwClsgIDEx
Ni4xODI0MzJdICBbPGNmMjAwMzZkPl0gcnVuX2luaXRfcHJvY2VzcysweGQvMHgyMApbICAx
MTYuNDA2MzMxXSAgWzxkMDRkMGYwMj5dIGtlcm5lbF9pbml0KzB4MzIvMHhlMApbICAxMTYu
NjMwODkwXSAgWzxkMDRlZmQ3Yj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMw
ClsgIDExNi44NTA1NDFdICBbPGQwNGQwZWQwPl0gPyByZXN0X2luaXQrMHg3MC8weDcwCi9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNC9iMmZmMmNmZWJhZDkyYmViZmNh
MjhiYWQ2NTAwNDU4MjFlZDI3MGM0L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMjk6MjAxNDAz
MDcwNDQxMTM6aTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNDozLjE0LjAtcmM1LTA2OTA3
LWdiMmZmMmNmOjQyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNC9iMmZm
MmNmZWJhZDkyYmViZmNhMjhiYWQ2NTAwNDU4MjFlZDI3MGM0L2RtZXNnLXlvY3RvLWl2eXRv
d24yLTEwOjIwMTQwMzA3MDQ0MTEzOmkzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQ6My4x
NC4wLXJjNS0wNjkwNy1nYjJmZjJjZjo0Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjAt
MDMwNzAwMzQvYjJmZjJjZmViYWQ5MmJlYmZjYTI4YmFkNjUwMDQ1ODIxZWQyNzBjNC9kbWVz
Zy15b2N0by1pdnl0b3duMi0yMDoyMDE0MDMwNzA0NDEyMjppMzg2LXJhbmRjb25maWctYW4w
LTAzMDcwMDM0OjMuMTQuMC1yYzUtMDY5MDctZ2IyZmYyY2Y6NDIKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctYW4wLTAzMDcwMDM0L2IyZmYyY2ZlYmFkOTJiZWJmY2EyOGJhZDY1MDA0NTgy
MWVkMjcwYzQvZG1lc2cteW9jdG8taXZ5dG93bjItNDoyMDE0MDMwNzA0NDEyMTppMzg2LXJh
bmRjb25maWctYW4wLTAzMDcwMDM0OjMuMTQuMC1yYzUtMDY5MDctZ2IyZmYyY2Y6NDIKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0L2IyZmYyY2ZlYmFkOTJiZWJmY2Ey
OGJhZDY1MDA0NTgyMWVkMjcwYzQvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi0xNToyMDE0MDMw
NzA0NDEzMzppMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0OjMuMTQuMC1yYzUtMDY5MDct
Z2IyZmYyY2Y6NDIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0L2IyZmYy
Y2ZlYmFkOTJiZWJmY2EyOGJhZDY1MDA0NTgyMWVkMjcwYzQvZG1lc2ctcXVhbnRhbC1pdnl0
b3duMi0yMToyMDE0MDMwNzA0NDEyODppMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0OjMu
MTQuMC1yYzUtMDY5MDctZ2IyZmYyY2Y6NDIKMDo2OjYgYWxsX2dvb2Q6YmFkOmFsbF9iYWQg
Ym9vdHMKG1sxOzM1bTIwMTQtMDMtMDcgMDQ6NDE6NDIgUkVQRUFUIENPVU5UOiAyMCAgIyAv
a2VybmVsLXRlc3RzL2xpbnV4Mi9vYmotYmlzZWN0Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6
IDYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDMgc3RlcHMp
Cls2ZmI3NzkzNjQ4MTUzOGJhMDU3MjYzNDVkODZhZjRiMzkxMjhhOGE5XSBhcm06IG1vdmUg
YXJtX2RtYV9saW1pdCB0byBzZXR1cF9kbWFfem9uZQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0
cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDIvb2Jq
LWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLWFuMC0wMzA3MDAzNC9uZXh0Om1hc3Rlcjo2ZmI3NzkzNjQ4MTUzOGJhMDU3MjYzNDVk
ODZhZjRiMzkxMjhhOGE5OmJpc2VjdC1saW51eDIKCjIwMTQtMDMtMDctMDQ6NDE6NDMgNmZi
Nzc5MzY0ODE1MzhiYTA1NzI2MzQ1ZDg2YWY0YjM5MTI4YThhOSBjb21waWxpbmcKMTU0IHJl
YWwgIDI3OTAgdXNlciAgMjEzIHN5cyAgMTk0NC4xMCUgY3B1IAlpMzg2LXJhbmRjb25maWct
YW4wLTAzMDcwMDM0CgoyMDE0LTAzLTA3LTA0OjQ0OjI4IGRldGVjdGluZyBib290IHN0YXRl
IDMuMTQuMC1yYzUtMDY5MDAtZzZmYjc3OTMuLi4uLi4JMgkzCTQuCTUJNgk4CTkuCTEwCTEx
LgkxMwkxNy4JMTguLi4uCTE5Li4uLi4uLi4uLgkyMCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDMg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDIgc3RlcHMpCltk
MWNlYTA3ZWZiZmEyNzIzY2ExYjgzZDNhNjlkMWYxMDAwODk2ZDRkXSBtb2R1bGVzOiB1c2Ug
cmF3X2NwdV93cml0ZSBmb3IgaW5pdGlhbGl6YXRpb24gb2YgcGVyIGNwdSByZWZjb3VudC4K
cnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9r
ZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4t
cXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvbmV4dDptYXN0ZXI6ZDFj
ZWEwN2VmYmZhMjcyM2NhMWI4M2QzYTY5ZDFmMTAwMDg5NmQ0ZDpiaXNlY3QtbGludXgyCgoy
MDE0LTAzLTA3LTA1OjAzOjMwIGQxY2VhMDdlZmJmYTI3MjNjYTFiODNkM2E2OWQxZjEwMDA4
OTZkNGQgY29tcGlsaW5nCjE0NyByZWFsICAyNzczIHVzZXIgIDI1MCBzeXMgIDIwNDQuNTkl
IGNwdSAJaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNAoKMjAxNC0wMy0wNy0wNTowNjox
MiBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTA2OTAzLWdkMWNlYTA3Li4uLi4u
LgkyCTQJNQk4Li4uLi4uLgk5CTE0CTE2LgkxNy4uLi4uLi4uLgkxOC4JMTkuLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JMjAgU1VDQ0VTUwoKQmlz
ZWN0aW5nOiAxIHJldmlzaW9uIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEg
c3RlcCkKW2EyNTk4MmMxNWFlNTI5ODUyMDAzM2NkNTg0OGE4MmFkZjZhOTczNzZdIHBlcmNw
dTogYWRkIHByZWVtcHRpb24gY2hlY2tzIHRvIF9fdGhpc19jcHUgb3BzCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3Rz
L2xpbnV4Mi9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0L25leHQ6bWFzdGVyOmEyNTk4MmMxNWFlNTI5
ODUyMDAzM2NkNTg0OGE4MmFkZjZhOTczNzY6YmlzZWN0LWxpbnV4MgoKMjAxNC0wMy0wNy0w
NjoxNToxNyBhMjU5ODJjMTVhZTUyOTg1MjAwMzNjZDU4NDhhODJhZGY2YTk3Mzc2IGNvbXBp
bGluZwoxNTEgcmVhbCAgMjc2NyB1c2VyICAyMTEgc3lzICAxOTcxLjkwJSBjcHUgCWkzODYt
cmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQKCjIwMTQtMDMtMDctMDY6MTg6MDMgZGV0ZWN0aW5n
IGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wNjkwNS1nYTI1OTgyYy4uLi4uLi4uLi4gVEVTVCBG
QUlMVVJFClsgIDExMi40NjgwMjldICAgIzE6IFZpcnR1YWwgTUlESSBDYXJkIDEKWyAgMTEy
LjQ2ODAzMl0gICAjMjogTVRQQVYgb24gcGFyYWxsZWwgcG9ydCBhdCAweDM3OApbICAxMTMu
NDg1MDMzXSBGcmVlaW5nIHVudXNlZCBrZXJuZWwgbWVtb3J5OiA4MDBLIChjZDYyZjAwMCAt
IGNkNmY3MDAwKQpbICAxMTMuNjkyODI0XSBCVUc6IHVzaW5nIF9fdGhpc19jcHVfYWRkKCkg
aW4gcHJlZW1wdGlibGUgWzAwMDAwMDAwXSBjb2RlOiBzd2FwcGVyLzAvMQpbICAxMTQuMDM0
MDc1XSBjYWxsZXIgaXMgX190aGlzX2NwdV9wcmVlbXB0X2NoZWNrKzB4M2IvMHg2MApbICAx
MTQuMjAzNTUxXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAz
LjE0LjAtcmM1LTA2OTA1LWdhMjU5ODJjICM0NQpbICAxMTQuNTQ5MjgxXSBIYXJkd2FyZSBu
YW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgIDExNC43Mzc3MDhd
ICAwMDAwMDAwMCAwMDAwMDAwMCBkMjAzZGVlYyBjY2NkOTMxYyAwMDAwMDAwMCBkMjAzZGYx
MCBjYmRmMTNlZCBjZDJlZGVlOApbICAxMTUuMTUxMzU1XSAgZDIwM2RmMjggMDAwMDAwMDAg
ZDIwNDAzZDggMDAwMDAwMDEgZDIwM2RmMjggZDNiN2QwMDAgZDIwM2RmNTggY2JkZjE0NGIK
WyAgMTE1LjU5NDg4OV0gIGQyMDNkZjI4IDAwMDAwMDI4IGNkMmVkNTA0IGNkNDVhYjJlIDY4
NzQ1ZjVmIDYzNWY3MzY5IDYxNWY3NTcwIDI5Mjg2NDY0ClsgIDExNi4wNzg1NzldIENhbGwg
VHJhY2U6ClsgIDExNi4zMTk2ODZdICBbPGNjY2Q5MzFjPl0gZHVtcF9zdGFjaysweDRiLzB4
NzUKWyAgMTE2LjU1ODY3M10gIFs8Y2JkZjEzZWQ+XSBjaGVja19wcmVlbXB0aW9uX2Rpc2Fi
bGVkKzB4Y2QvMHhlMApbICAxMTYuNzg4MzM0XSAgWzxjYmRmMTQ0Yj5dIF9fdGhpc19jcHVf
cHJlZW1wdF9jaGVjaysweDNiLzB4NjAKWyAgMTE3LjAyOTE3MV0gIFs8Y2JhNjk3OWI+XSA/
IHByZWVtcHRfY291bnRfYWRkKzB4NGIvMHhhMApbICAxMTcuMjY1OTE2XSAgWzxjYmFmNDFk
Yj5dIGttZW1fY2FjaGVfYWxsb2MrMHhiYi8weDE5MApbICAxMTcuNTEwODk2XSAgWzxjYmIw
N2FhZj5dID8gZ2V0bmFtZV9rZXJuZWwrMHgzZi8weDgwClsgIDExNy43NDQxMDFdICBbPGNi
YjA3YWFmPl0gZ2V0bmFtZV9rZXJuZWwrMHgzZi8weDgwClsgIDExNy45NjQ4OThdICBbPGNi
YTAwMzZkPl0gcnVuX2luaXRfcHJvY2VzcysweGQvMHgyMApbICAxMTguMTg1Mzg5XSAgWzxj
Y2NkMGVlMj5dIGtlcm5lbF9pbml0KzB4MzIvMHhlMAoKRWxhcHNlZCB0aW1lOiAxMjAKcWVt
dS1zeXN0ZW0teDg2XzY0IC1jcHUga3ZtNjQgLWVuYWJsZS1rdm0gLWtlcm5lbCAva2VybmVs
L2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvYTI1OTgyYzE1YWU1Mjk4NTIwMDMzY2Q1
ODQ4YTgyYWRmNmE5NzM3Ni92bWxpbnV6LTMuMTQuMC1yYzUtMDY5MDUtZ2EyNTk4MmMgLWFw
cGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVn
IGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcGFuaWM9MTAgc29mdGxvY2t1cF9w
YW5pYz0xIG5taV93YXRjaGRvZz1wYW5pYyAgcHJvbXB0X3JhbWRpc2s9MCBjb25zb2xlPXR0
eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9vdD0vZGV2L3JhbTAgcncg
bGluaz0va2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMC0w
MzA3MDAzNC9uZXh0Om1hc3RlcjphMjU5ODJjMTVhZTUyOTg1MjAwMzNjZDU4NDhhODJhZGY2
YTk3Mzc2OmJpc2VjdC1saW51eDIvLnZtbGludXotYTI1OTgyYzE1YWU1Mjk4NTIwMDMzY2Q1
ODQ4YTgyYWRmNmE5NzM3Ni0yMDE0MDMwNzA2MTc1OS0xOC1pdnl0b3duMiBicmFuY2g9bmV4
dC9tYXN0ZXIgQk9PVF9JTUFHRT0va2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAw
MzQvYTI1OTgyYzE1YWU1Mjk4NTIwMDMzY2Q1ODQ4YTgyYWRmNmE5NzM3Ni92bWxpbnV6LTMu
MTQuMC1yYzUtMDY5MDUtZ2EyNTk4MmMnICAtaW5pdHJkIC9rZXJuZWwtdGVzdHMvaW5pdHJk
L3F1YW50YWwtY29yZS1pMzg2LmNneiAtbSAzMjAgLXNtcCAyIC1uZXQgbmljLHZsYW49MSxt
b2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxhbj0xLGhvc3Rmd2Q9dGNwOjoxMjIxOS06MjIgLWJv
b3Qgb3JkZXI9bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBlc2IgLXJ0YyBiYXNlPWxv
Y2FsdGltZSAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQtcXVhbnRhbC1pdnl0b3duMi0x
OCAtc2VyaWFsIGZpbGU6L2Rldi9zaG0va2Jvb3Qvc2VyaWFsLXF1YW50YWwtaXZ5dG93bjIt
MTggLWRhZW1vbml6ZSAtZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNC9hMjU5ODJjMTVhZTUyOTg1MjAwMzNjZDU4NDhh
ODJhZGY2YTk3Mzc2L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMTg6MjAxNDAzMDcwNjIyMzA6
aTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNDozLjE0LjAtcmM1LTA2OTA1LWdhMjU5ODJj
OjQ1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNC9hMjU5ODJjMTVhZTUy
OTg1MjAwMzNjZDU4NDhhODJhZGY2YTk3Mzc2L2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMjI6
MjAxNDAzMDcwNjIyMjc6aTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNDozLjE0LjAtcmM1
LTA2OTA1LWdhMjU5ODJjOjQ1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAz
NC9hMjU5ODJjMTVhZTUyOTg1MjAwMzNjZDU4NDhhODJhZGY2YTk3Mzc2L2RtZXNnLXlvY3Rv
LWl2eXRvd24yLTI4OjIwMTQwMzA3MDYyMjI5OmkzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAw
MzQ6My4xNC4wLXJjNS0wNjkwNS1nYTI1OTgyYzo0NQowOjM6MyBhbGxfZ29vZDpiYWQ6YWxs
X2JhZCBib290cwobWzE7MzVtMjAxNC0wMy0wNyAwNjoyMzoxMSBSRVBFQVQgQ09VTlQ6IDIw
ICAjIC9rZXJuZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCkJpc2Vj
dGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMCBz
dGVwcykKWzI2ZDAyY2ZhMzg1MDY3YzM5YzA0MDdiMDIyYzAxYTAxMWMyZmJiNTFdIG5ldDog
cmVwbGFjZSBfX3RoaXNfY3B1X2luYyBpbiByb3V0ZS5jIHdpdGggcmF3X2NwdV9pbmMKcnVu
bmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJu
ZWwtdGVzdHMvbGludXgyL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvbmV4dDptYXN0ZXI6MjZkMDJj
ZmEzODUwNjdjMzljMDQwN2IwMjJjMDFhMDExYzJmYmI1MTpiaXNlY3QtbGludXgyCgoyMDE0
LTAzLTA3LTA2OjIzOjE1IDI2ZDAyY2ZhMzg1MDY3YzM5YzA0MDdiMDIyYzAxYTAxMWMyZmJi
NTEgY29tcGlsaW5nCjE1NSByZWFsICAyNzcyIHVzZXIgIDIyMCBzeXMgIDE5MTkuODAlIGNw
dSAJaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNAoKMjAxNC0wMy0wNy0wNjoyNjoxOCBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmM1LTA2OTA0LWcyNmQwMmNmLi4uLi4uLi4u
Li4JMwk4Li4uLi4uLgk5Li4JMTAJMTEuCTEyCTEzCTE0Li4uLi4uCTE1LgkxNwkxOAkxOQky
MCBTVUNDRVNTCgphMjU5ODJjMTVhZTUyOTg1MjAwMzNjZDU4NDhhODJhZGY2YTk3Mzc2IGlz
IHRoZSBmaXJzdCBiYWQgY29tbWl0CmNvbW1pdCBhMjU5ODJjMTVhZTUyOTg1MjAwMzNjZDU4
NDhhODJhZGY2YTk3Mzc2CkF1dGhvcjogQ2hyaXN0b3BoIExhbWV0ZXIgPGNsQGxpbnV4LmNv
bT4KRGF0ZTogICBUaHUgTWFyIDYgMTE6MDU6MjEgMjAxNCArMTEwMAoKICAgIHBlcmNwdTog
YWRkIHByZWVtcHRpb24gY2hlY2tzIHRvIF9fdGhpc19jcHUgb3BzCiAgICAKICAgIFdlIGRl
ZmluZSBhIGNoZWNrIGZ1bmN0aW9uIGluIG9yZGVyIHRvIGF2b2lkIHRyb3VibGUgd2l0aCB0
aGUgaW5jbHVkZQogICAgZmlsZXMuICBUaGVuIHRoZSBoaWdoZXIgbGV2ZWwgX190aGlzX2Nw
dSBtYWNyb3MgYXJlIG1vZGlmaWVkIHRvIGludm9rZSB0aGUKICAgIHByZWVtcHRpb24gY2hl
Y2suCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBMYW1ldGVyIDxjbEBsaW51
eC5jb20+CiAgICBBY2tlZC1ieTogSW5nbyBNb2xuYXIgPG1pbmdvQGtlcm5lbC5vcmc+CiAg
ICBDYzogVGVqdW4gSGVvIDx0akBrZXJuZWwub3JnPgogICAgU2lnbmVkLW9mZi1ieTogQW5k
cmV3IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4KCjowNDAwMDAgMDQwMDAw
IDM2N2ZjNDYwOWIzZGE0M2IzNzZjZDJhNTU1YjcyMDgxMDMwOGQwOTQgMDliMTJjMGE0OTFh
MzViM2RkY2JiZDZlOWQ1MDg0YzcxOTZhNTNmMyBNCWluY2x1ZGUKOjA0MDAwMCAwNDAwMDAg
ZmQyMjY2NGIwZTY0NjhmNTUwMDU5OWY5YTI0ODliYWEzOTY2MzljOCBlZDE3Y2NhY2YxNTVm
ZjU3YTU5ZGJmOTE1YzFlZTRhNGQ1MTM3ZDNiIE0JbGliCmJpc2VjdCBydW4gc3VjY2Vzcwps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLWFuMC0w
MzA3MDAzNC9uZXh0Om1hc3RlcjoyNmQwMmNmYTM4NTA2N2MzOWMwNDA3YjAyMmMwMWEwMTFj
MmZiYjUxOmJpc2VjdC1saW51eDIKCjIwMTQtMDMtMDctMDY6NDY6NTEgMjZkMDJjZmEzODUw
NjdjMzljMDQwN2IwMjJjMDFhMDExYzJmYmI1MSByZXVzZSAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1hbjAtMDMwNzAwMzQvMjZkMDJjZmEzODUwNjdjMzljMDQwN2IwMjJjMDFhMDExYzJm
YmI1MS92bWxpbnV6LTMuMTQuMC1yYzUtMDY5MDQtZzI2ZDAyY2YKCjIwMTQtMDMtMDctMDY6
NDY6NTEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgk0
CTgJMTAuLi4uLi4uLgkxMgkxNC4JMTUJMTYJMjAJMjEJMjYuLi4uLgkyNwkyOQkzMAkzMQkz
NAk0Mgk0Ngk0OC4uLgk0OS4JNTEJNTIuLi4uLi4JNTgJNTkJNjAgU1VDQ0VTUwoKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAw
MzQvbmV4dDptYXN0ZXI6MGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2Yw
MzpiaXNlY3QtbGludXgyCiBURVNUIEZBSUxVUkUKWyAgMTA4LjYyOTY2Nl0gICAjMjogTVRQ
QVYgb24gcGFyYWxsZWwgcG9ydCBhdCAweDM3OApbICAxMDguNzYzOTE0XSByYW5kb206IG5v
bmJsb2NraW5nIHBvb2wgaXMgaW5pdGlhbGl6ZWQKWyAgMTA4Ljg5OTY3N10gRnJlZWluZyB1
bnVzZWQga2VybmVsIG1lbW9yeTogODAwSyAoY2Y0NDkwMDAgLSBjZjUxMTAwMCkKWyAgMTA5
LjAzODU4Ml0gQlVHOiB1c2luZyBfX3RoaXNfY3B1X2FkZCgpIGluIHByZWVtcHRpYmxlIFsw
MDAwMDAwMF0gY29kZTogc3dhcHBlci8wLzEKWyAgMTA5LjMyMjgxMF0gY2FsbGVyIGlzIF9f
dGhpc19jcHVfcHJlZW1wdF9jaGVjaysweDNiLzB4NjAKWyAgMTA5LjQ3MjU1OF0gQ1BVOiAw
IFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50ZWQgMy4xNC4wLXJjNS1uZXh0LTIw
MTQwMzA2LTA2OTUyLWcwZmZiMmZlICMxClsgIDEwOS43ODEzMjddIEhhcmR3YXJlIG5hbWU6
IEJvY2hzIEJvY2hzLCBCSU9TIEJvY2hzIDAxLzAxLzIwMTEKWyAgMTA5Ljk0NTMwNF0gIDAw
MDAwMDAwIDAwMDAwMDAwIGQyMDNkZWVjIGNlYWVjNzQ3IDAwMDAwMDAwIGQyMDNkZjEwIGNk
YmVmZGNkIGNmMTAzNjJjClsgIDExMC4zMTQyOTNdICBkMjAzZGYyOCAwMDAwMDAwMCBkMjA0
MDNkOCAwMDAwMDAwMSBkMjAzZGYyOCBkM2I4NTAwMCBkMjAzZGY1OCBjZGJlZmUyYgpbICAx
MTAuNzEzNTkzXSAgZDIwM2RmMjggMDAwMDAwMjggY2YxMDJjMTQgY2YyNzRmYzYgNjg3NDVm
NWYgNjM1ZjczNjkgNjE1Zjc1NzAgMjkyODY0NjQKWyAgMTExLjE0NDUwMl0gQ2FsbCBUcmFj
ZToKWyAgMTExLjM1MDczMV0gIFs8Y2VhZWM3NDc+XSBkdW1wX3N0YWNrKzB4NGIvMHg3NQpb
ICAxMTEuNTU3NTYxXSAgWzxjZGJlZmRjZD5dIGNoZWNrX3ByZWVtcHRpb25fZGlzYWJsZWQr
MHhjZC8weGUwClsgIDExMS43NjcwODldICBbPGNkYmVmZTJiPl0gX190aGlzX2NwdV9wcmVl
bXB0X2NoZWNrKzB4M2IvMHg2MApbICAxMTEuOTc5MTcwXSAgWzxjZDg2OTY2Yj5dID8gcHJl
ZW1wdF9jb3VudF9hZGQrMHg0Yi8weGEwClsgIDExMi4xOTIyMDZdICBbPGNkOGYzZmEyPl0g
a21lbV9jYWNoZV9hbGxvYysweGMyLzB4MTkwClsgIDExMi40MDU0ODhdICBbPGNkOTA3N2Zm
Pl0gPyBnZXRuYW1lX2tlcm5lbCsweDNmLzB4ODAKWyAgMTEyLjYxNTc2Nl0gIFs8Y2Q5MDc3
ZmY+XSBnZXRuYW1lX2tlcm5lbCsweDNmLzB4ODAKWyAgMTEyLjgxNzc0MV0gIFs8Y2Q4MDAz
NmQ+XSBydW5faW5pdF9wcm9jZXNzKzB4ZC8weDIwClsgIDExMy4wMjIwOThdICBbPGNlYWU0
MmQyPl0ga2VybmVsX2luaXQrMHgzMi8weGUwClsgIDExMy4yMTk3MjldICBbPGNlYjAzMTVi
Pl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDFiLzB4MzAKWyAgMTEzLjQxMTI5N10gIFs8
Y2VhZTQyYTA+XSA/IHJlc3RfaW5pdCsweDcwLzB4NzAKCkVsYXBzZWQgdGltZTogMTE1CnFl
bXUtc3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0LzBmZmIyZmU3YjljMzAwODI4NzZmYTNh
MTdkYTAxOGJmMDYzMmNmMDMvdm1saW51ei0zLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5
NTItZzBmZmIyZmUgLWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFybHlwcmludGs9dHR5
UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2VuYWJsZWQgcGFuaWM9
MTAgc29mdGxvY2t1cF9wYW5pYz0xIG5taV93YXRjaGRvZz1wYW5pYyAgcHJvbXB0X3JhbWRp
c2s9MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9v
dD0vZGV2L3JhbTAgcncgbGluaz0va2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWFuMC0wMzA3MDAzNC9uZXh0Om1hc3RlcjowZmZiMmZlN2I5YzMwMDgyODc2
ZmEzYTE3ZGEwMThiZjA2MzJjZjAzOmJpc2VjdC1saW51eDIvLnZtbGludXotMGZmYjJmZTdi
OWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy0yMDE0MDMwNzAzMTAwMC02LWl2eXRv
d24yIGJyYW5jaD1uZXh0L21hc3RlciBCT09UX0lNQUdFPS9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWFuMC0wMzA3MDAzNC8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJj
ZjAzL3ZtbGludXotMy4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlJyAg
LWluaXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFsLWNvcmUtaTM4Ni5jZ3ogLW0g
MzIwIC1zbXAgMiAtbmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49
MSxob3N0ZndkPXRjcDo6MTE4MzctOjIyIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdh
dGNoZG9nIGk2MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLXBpZGZpbGUgL2Rldi9zaG0v
a2Jvb3QvcGlkLXF1YW50YWwtaXZ5dG93bjItMTUgLXNlcmlhbCBmaWxlOi9kZXYvc2htL2ti
b290L3NlcmlhbC1xdWFudGFsLWl2eXRvd24yLTE1IC1kYWVtb25pemUgLWRpc3BsYXkgbm9u
ZSAtbW9uaXRvciBudWxsIAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQv
MGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0by1p
dnl0b3duMi0xODoyMDE0MDMwNzAxMTg1MTppMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0
OjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZmYjJmZToxCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNC8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEw
MThiZjA2MzJjZjAzL2RtZXNnLXlvY3RvLXhnd28tNDoyMDE0MDMwNzAzMTYxMjppMzg2LXJh
bmRjb25maWctYW4wLTAzMDcwMDM0OjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1n
MGZmYjJmZToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNC8wZmZiMmZl
N2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXF1YW50YWwtaXZ5dG93
bjItMjU6MjAxNDAzMDcwMTE4NDA6aTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNDozLjE0
LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6MQova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1hbjAtMDMwNzAwMzQvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYw
NjMyY2YwMy9kbWVzZy15b2N0by1pdnl0b3duMi0xOjIwMTQwMzA3MDExOTAwOmkzODYtcmFu
ZGNvbmZpZy1hbjAtMDMwNzAwMzQ6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcw
ZmZiMmZlOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0LzBmZmIyZmU3
YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8tbGtwLXN0MDEt
NDoyMDE0MDMwNzAxMjMxNzppMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0OjMuMTQuMC1y
YzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZmYjJmZToxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWFuMC0wMzA3MDAzNC8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJj
ZjAzL2RtZXNnLXF1YW50YWwteGlhbi03OjIwMTQwMzA3MDEyNTEyOmkzODYtcmFuZGNvbmZp
Zy1hbjAtMDMwNzAwMzQ6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZl
OjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0LzBmZmIyZmU3YjljMzAw
ODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8teGd3by0zOjIwMTQwMzA3
MDMxNjI4OmkzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQ6My4xNC4wLXJjNS1uZXh0LTIw
MTQwMzA2LTA2OTUyLWcwZmZiMmZlOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAz
MDcwMDM0LzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2ct
cXVhbnRhbC1sa3Atc3QwMS0yOjIwMTQwMzA3MDEyMzI5OmkzODYtcmFuZGNvbmZpZy1hbjAt
MDMwNzAwMzQ6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlOjEKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0LzBmZmIyZmU3YjljMzAwODI4NzZm
YTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2ctcXVhbnRhbC1yb2FtLTMyOjIwMTQwMzA3MDEy
NTQyOmkzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQ6My4xNC4wLXJjNS1uZXh0LTIwMTQw
MzA2LTA2OTUyLWcwZmZiMmZlOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcw
MDM0LzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2ctcXVh
bnRhbC1pdnl0b3duMi0zOjIwMTQwMzA3MDExODU2OmkzODYtcmFuZGNvbmZpZy1hbjAtMDMw
NzAwMzQ6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlOjEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0LzBmZmIyZmU3YjljMzAwODI4NzZmYTNh
MTdkYTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8taXZ5dG93bjItMTM6MjAxNDAzMDcwMzEy
MjU6aTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNDozLjE0LjAtcmM1LW5leHQtMjAxNDAz
MDYtMDY5NTItZzBmZmIyZmU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAw
MzQvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0
by14Z3dvLTE6MjAxNDAzMDcwMTIyNDg6aTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNDoz
LjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6MQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4
YmYwNjMyY2YwMy9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTg6MjAxNDAzMDcwMzEyMzg6aTM4
Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNDozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5
NTItZzBmZmIyZmU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvMGZm
YjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0by1iZW5z
LTI6MjAxNDAzMDcwMzE2MDM6aTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNDozLjE0LjAt
cmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6MQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1hbjAtMDMwNzAwMzQvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMy
Y2YwMy9kbWVzZy15b2N0by1pdnl0b3duMi0yMDoyMDE0MDMwNzAzMTIxMzppMzg2LXJhbmRj
b25maWctYW4wLTAzMDcwMDM0OjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZm
YjJmZToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNC8wZmZiMmZlN2I5
YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXF1YW50YWwtaXZ5dG93bjIt
MTU6MjAxNDAzMDcwMzEyMzc6aTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNDozLjE0LjAt
cmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6MQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1hbjAtMDMwNzAwMzQvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMy
Y2YwMy9kbWVzZy15b2N0by14Z3dvLTc6MjAxNDAzMDcwMzE3MDY6aTM4Ni1yYW5kY29uZmln
LWFuMC0wMzA3MDAzNDozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvMGZmYjJmZTdiOWMzMDA4
Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0by1pdnl0b3duMi0xMDoyMDE0
MDMwNzAzMTIyNTppMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0OjMuMTQuMC1yYzUtbmV4
dC0yMDE0MDMwNi0wNjk1Mi1nMGZmYjJmZToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFu
MC0wMzA3MDAzNC8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2Rt
ZXNnLXF1YW50YWwtaXZ5dG93bjItMTk6MjAxNDAzMDcwMzEyMzg6aTM4Ni1yYW5kY29uZmln
LWFuMC0wMzA3MDAzNDozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6
MQowOjE5OjE5IGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgpbZGV0YWNoZWQgSEVBRCBj
YjE5MDk4XSBSZXZlcnQgInBlcmNwdTogYWRkIHByZWVtcHRpb24gY2hlY2tzIHRvIF9fdGhp
c19jcHUgb3BzIgogQ29tbWl0dGVyOiBXdSBGZW5nZ3VhbmcgPGtidWlsZEBiZWU+CllvdXIg
bmFtZSBhbmQgZW1haWwgYWRkcmVzcyB3ZXJlIGNvbmZpZ3VyZWQgYXV0b21hdGljYWxseSBi
YXNlZApvbiB5b3VyIHVzZXJuYW1lIGFuZCBob3N0bmFtZS4gUGxlYXNlIGNoZWNrIHRoYXQg
dGhleSBhcmUgYWNjdXJhdGUuCllvdSBjYW4gc3VwcHJlc3MgdGhpcyBtZXNzYWdlIGJ5IHNl
dHRpbmcgdGhlbSBleHBsaWNpdGx5OgoKICAgIGdpdCBjb25maWcgLS1nbG9iYWwgdXNlci5u
YW1lICJZb3VyIE5hbWUiCiAgICBnaXQgY29uZmlnIC0tZ2xvYmFsIHVzZXIuZW1haWwgeW91
QGV4YW1wbGUuY29tCgpBZnRlciBkb2luZyB0aGlzLCB5b3UgbWF5IGZpeCB0aGUgaWRlbnRp
dHkgdXNlZCBmb3IgdGhpcyBjb21taXQgd2l0aDoKCiAgICBnaXQgY29tbWl0IC0tYW1lbmQg
LS1yZXNldC1hdXRob3IKCiAyIGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDQ1
IGRlbGV0aW9ucygtKQpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLWFuMC0wMzA3MDAzNC9uZXh0Om1hc3RlcjpjYjE5MDk4YzlmYTdhZjEzYTNl
ZmJlMDIwNzZlOGE0YjE3ZDg2ZTM4OmJpc2VjdC1saW51eDIKCjIwMTQtMDMtMDctMDc6MjM6
MjYgY2IxOTA5OGM5ZmE3YWYxM2EzZWZiZTAyMDc2ZThhNGIxN2Q4NmUzOCBjb21waWxpbmcK
CjIwMTQtMDMtMDctMDc6MjY6MTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS1u
ZXh0LTIwMTQwMzA2LTAwMDAxLWdjYjE5MDk4Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4JMwk3CTE3Li4uCTE4Li4JMjEJMjUJMzEJMzgJNDAJNDEJNDkJ
NTYJNTgJNTkuLi4JNjAgU1VDQ0VTUwoKCj09PT09PT09PSB1cHN0cmVhbSA9PT09PT09PT0K
V2FybmluZzogeW91IGFyZSBsZWF2aW5nIDEgY29tbWl0IGJlaGluZCwgbm90IGNvbm5lY3Rl
ZCB0bwphbnkgb2YgeW91ciBicmFuY2hlczoKCiAgY2IxOTA5OCBSZXZlcnQgInBlcmNwdTog
YWRkIHByZWVtcHRpb24gY2hlY2tzIHRvIF9fdGhpc19jcHUgb3BzIgoKSWYgeW91IHdhbnQg
dG8ga2VlcCB0aGVtIGJ5IGNyZWF0aW5nIGEgbmV3IGJyYW5jaCwgdGhpcyBtYXkgYmUgYSBn
b29kIHRpbWUKdG8gZG8gc28gd2l0aDoKCiBnaXQgYnJhbmNoIG5ld19icmFuY2hfbmFtZSBj
YjE5MDk4CgpIRUFEIGlzIG5vdyBhdCBjM2JlYmM3Li4uIE1lcmdlIGdpdDovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9kYXZlbS9uZXQKbHMgLWEgL2tlcm5l
bC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvbmV4
dDptYXN0ZXI6YzNiZWJjNzFjNGJjZGFmYTI0YjUwNmFkZjBjMWRlM2MxZjc3ZTJlMDpiaXNl
Y3QtbGludXgyCgoyMDE0LTAzLTA3LTA3OjU5OjQ3IGMzYmViYzcxYzRiY2RhZmEyNGI1MDZh
ZGYwYzFkZTNjMWY3N2UyZTAgY29tcGlsaW5nCgoyMDE0LTAzLTA3LTA4OjAyOjMzIGRldGVj
dGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUtMDAxODUtZ2MzYmViYzcuLi4uLi4uLgkxLgk0
CTYJNwk4CTkJMTEuCTEyCTI1CTI5LgkzMQkzNAkzOAk0MQk0Ngk0Ny4JNDgJNTMJNTUJNTYJ
NTgJNTkuLi4uCTYwIFNVQ0NFU1MKCgo9PT09PT09PT0gbGludXgtbmV4dCA9PT09PT09PT0K
UHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYzNiZWJjNy4uLiBNZXJnZSBnaXQ6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGF2ZW0vbmV0CkhFQUQgaXMg
bm93IGF0IDBmZmIyZmUuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9yIDIw
MTQwMzA2CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctYW4wLTAzMDcwMDM0L25leHQ6bWFzdGVyOjBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdk
YTAxOGJmMDYzMmNmMDM6YmlzZWN0LWxpbnV4MgogVEVTVCBGQUlMVVJFClsgIDEwOC42Mjk2
NjZdICAgIzI6IE1UUEFWIG9uIHBhcmFsbGVsIHBvcnQgYXQgMHgzNzgKWyAgMTA4Ljc2Mzkx
NF0gcmFuZG9tOiBub25ibG9ja2luZyBwb29sIGlzIGluaXRpYWxpemVkClsgIDEwOC44OTk2
NzddIEZyZWVpbmcgdW51c2VkIGtlcm5lbCBtZW1vcnk6IDgwMEsgKGNmNDQ5MDAwIC0gY2Y1
MTEwMDApClsgIDEwOS4wMzg1ODJdIEJVRzogdXNpbmcgX190aGlzX2NwdV9hZGQoKSBpbiBw
cmVlbXB0aWJsZSBbMDAwMDAwMDBdIGNvZGU6IHN3YXBwZXIvMC8xClsgIDEwOS4zMjI4MTBd
IGNhbGxlciBpcyBfX3RoaXNfY3B1X3ByZWVtcHRfY2hlY2srMHgzYi8weDYwClsgIDEwOS40
NzI1NThdIENQVTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTQu
MC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZmYjJmZSAjMQpbICAxMDkuNzgxMzI3XSBI
YXJkd2FyZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgIDEw
OS45NDUzMDRdICAwMDAwMDAwMCAwMDAwMDAwMCBkMjAzZGVlYyBjZWFlYzc0NyAwMDAwMDAw
MCBkMjAzZGYxMCBjZGJlZmRjZCBjZjEwMzYyYwpbICAxMTAuMzE0MjkzXSAgZDIwM2RmMjgg
MDAwMDAwMDAgZDIwNDAzZDggMDAwMDAwMDEgZDIwM2RmMjggZDNiODUwMDAgZDIwM2RmNTgg
Y2RiZWZlMmIKWyAgMTEwLjcxMzU5M10gIGQyMDNkZjI4IDAwMDAwMDI4IGNmMTAyYzE0IGNm
Mjc0ZmM2IDY4NzQ1ZjVmIDYzNWY3MzY5IDYxNWY3NTcwIDI5Mjg2NDY0ClsgIDExMS4xNDQ1
MDJdIENhbGwgVHJhY2U6ClsgIDExMS4zNTA3MzFdICBbPGNlYWVjNzQ3Pl0gZHVtcF9zdGFj
aysweDRiLzB4NzUKWyAgMTExLjU1NzU2MV0gIFs8Y2RiZWZkY2Q+XSBjaGVja19wcmVlbXB0
aW9uX2Rpc2FibGVkKzB4Y2QvMHhlMApbICAxMTEuNzY3MDg5XSAgWzxjZGJlZmUyYj5dIF9f
dGhpc19jcHVfcHJlZW1wdF9jaGVjaysweDNiLzB4NjAKWyAgMTExLjk3OTE3MF0gIFs8Y2Q4
Njk2NmI+XSA/IHByZWVtcHRfY291bnRfYWRkKzB4NGIvMHhhMApbICAxMTIuMTkyMjA2XSAg
WzxjZDhmM2ZhMj5dIGttZW1fY2FjaGVfYWxsb2MrMHhjMi8weDE5MApbICAxMTIuNDA1NDg4
XSAgWzxjZDkwNzdmZj5dID8gZ2V0bmFtZV9rZXJuZWwrMHgzZi8weDgwClsgIDExMi42MTU3
NjZdICBbPGNkOTA3N2ZmPl0gZ2V0bmFtZV9rZXJuZWwrMHgzZi8weDgwClsgIDExMi44MTc3
NDFdICBbPGNkODAwMzZkPl0gcnVuX2luaXRfcHJvY2VzcysweGQvMHgyMApbICAxMTMuMDIy
MDk4XSAgWzxjZWFlNDJkMj5dIGtlcm5lbF9pbml0KzB4MzIvMHhlMApbICAxMTMuMjE5NzI5
XSAgWzxjZWIwMzE1Yj5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgxYi8weDMwClsgIDEx
My40MTEyOTddICBbPGNlYWU0MmEwPl0gPyByZXN0X2luaXQrMHg3MC8weDcwCgpFbGFwc2Vk
IHRpbWU6IDExNQpxZW11LXN5c3RlbS14ODZfNjQgLWNwdSBrdm02NCAtZW5hYmxlLWt2bSAt
a2VybmVsIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNC8wZmZiMmZlN2I5
YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL3ZtbGludXotMy4xNC4wLXJjNS1uZXh0
LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlIC1hcHBlbmQgJ2h1bmdfdGFza19wYW5pYz0xIGVh
cmx5cHJpbnRrPXR0eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRlYnVnIHN5c3JxX2Fsd2F5c19l
bmFibGVkIHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMg
IHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29sZT10dHkwIHZn
YT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvbmV4dDptYXN0ZXI6MGZmYjJm
ZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMzpiaXNlY3QtbGludXgyLy52bWxp
bnV6LTBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMtMjAxNDAzMDcw
MzEwMDAtNi1pdnl0b3duMiBicmFuY2g9bmV4dC9tYXN0ZXIgQk9PVF9JTUFHRT0va2VybmVs
L2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2Ex
N2RhMDE4YmYwNjMyY2YwMy92bWxpbnV6LTMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1
Mi1nMGZmYjJmZScgIC1pbml0cmQgL2tlcm5lbC10ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3Jl
LWkzODYuY2d6IC1tIDMyMCAtc21wIDIgLW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1u
ZXQgdXNlcix2bGFuPTEsaG9zdGZ3ZD10Y3A6OjExODM3LToyMiAtYm9vdCBvcmRlcj1uYyAt
bm8tcmVib290IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1waWRm
aWxlIC9kZXYvc2htL2tib290L3BpZC1xdWFudGFsLWl2eXRvd24yLTE1IC1zZXJpYWwgZmls
ZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1pdnl0b3duMi0xNSAtZGFlbW9uaXpl
IC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
YW4wLTAzMDcwMDM0LzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMv
ZG1lc2cteW9jdG8taXZ5dG93bjItMTg6MjAxNDAzMDcwMTE4NTE6aTM4Ni1yYW5kY29uZmln
LWFuMC0wMzA3MDAzNDozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6
MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvMGZmYjJmZTdiOWMzMDA4
Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy15b2N0by14Z3dvLTQ6MjAxNDAzMDcw
MzE2MTI6aTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNDozLjE0LjAtcmM1LW5leHQtMjAx
NDAzMDYtMDY5NTItZzBmZmIyZmU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMw
NzAwMzQvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy1x
dWFudGFsLWl2eXRvd24yLTI1OjIwMTQwMzA3MDExODQwOmkzODYtcmFuZGNvbmZpZy1hbjAt
MDMwNzAwMzQ6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlOjEKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0LzBmZmIyZmU3YjljMzAwODI4NzZm
YTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8taXZ5dG93bjItMToyMDE0MDMwNzAx
MTkwMDppMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0OjMuMTQuMC1yYzUtbmV4dC0yMDE0
MDMwNi0wNjk1Mi1nMGZmYjJmZToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3
MDAzNC8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXlv
Y3RvLWxrcC1zdDAxLTQ6MjAxNDAzMDcwMTIzMTc6aTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3
MDAzNDozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6MQova2VybmVs
L2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2Ex
N2RhMDE4YmYwNjMyY2YwMy9kbWVzZy1xdWFudGFsLXhpYW4tNzoyMDE0MDMwNzAxMjUxMjpp
Mzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0OjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0w
Njk1Mi1nMGZmYjJmZToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNC8w
ZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXlvY3RvLXhn
d28tMzoyMDE0MDMwNzAzMTYyODppMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0OjMuMTQu
MC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZmYjJmZToxCi9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLWFuMC0wMzA3MDAzNC8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2
MzJjZjAzL2RtZXNnLXF1YW50YWwtbGtwLXN0MDEtMjoyMDE0MDMwNzAxMjMyOTppMzg2LXJh
bmRjb25maWctYW4wLTAzMDcwMDM0OjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1n
MGZmYjJmZToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNC8wZmZiMmZl
N2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXF1YW50YWwtcm9hbS0z
MjoyMDE0MDMwNzAxMjU0MjppMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0OjMuMTQuMC1y
YzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZmYjJmZToxCi9rZXJuZWwvaTM4Ni1yYW5kY29u
ZmlnLWFuMC0wMzA3MDAzNC8wZmZiMmZlN2I5YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJj
ZjAzL2RtZXNnLXF1YW50YWwtaXZ5dG93bjItMzoyMDE0MDMwNzAxMTg1NjppMzg2LXJhbmRj
b25maWctYW4wLTAzMDcwMDM0OjMuMTQuMC1yYzUtbmV4dC0yMDE0MDMwNi0wNjk1Mi1nMGZm
YjJmZToxCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNC8wZmZiMmZlN2I5
YzMwMDgyODc2ZmEzYTE3ZGEwMThiZjA2MzJjZjAzL2RtZXNnLXlvY3RvLWl2eXRvd24yLTEz
OjIwMTQwMzA3MDMxMjI1OmkzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQ6My4xNC4wLXJj
NS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctYW4wLTAzMDcwMDM0LzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNm
MDMvZG1lc2cteW9jdG8teGd3by0xOjIwMTQwMzA3MDEyMjQ4OmkzODYtcmFuZGNvbmZpZy1h
bjAtMDMwNzAwMzQ6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlOjEK
L2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0LzBmZmIyZmU3YjljMzAwODI4
NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2ctcXVhbnRhbC1pdnl0b3duMi04OjIwMTQw
MzA3MDMxMjM4OmkzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQ6My4xNC4wLXJjNS1uZXh0
LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4w
LTAzMDcwMDM0LzBmZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1l
c2cteW9jdG8tYmVucy0yOjIwMTQwMzA3MDMxNjAzOmkzODYtcmFuZGNvbmZpZy1hbjAtMDMw
NzAwMzQ6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlOjEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0LzBmZmIyZmU3YjljMzAwODI4NzZmYTNh
MTdkYTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8taXZ5dG93bjItMjA6MjAxNDAzMDcwMzEy
MTM6aTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNDozLjE0LjAtcmM1LW5leHQtMjAxNDAz
MDYtMDY5NTItZzBmZmIyZmU6MQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAw
MzQvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4YmYwNjMyY2YwMy9kbWVzZy1xdWFu
dGFsLWl2eXRvd24yLTE1OjIwMTQwMzA3MDMxMjM3OmkzODYtcmFuZGNvbmZpZy1hbjAtMDMw
NzAwMzQ6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2OTUyLWcwZmZiMmZlOjEKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0LzBmZmIyZmU3YjljMzAwODI4NzZmYTNh
MTdkYTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8teGd3by03OjIwMTQwMzA3MDMxNzA2Omkz
ODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQ6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2
OTUyLWcwZmZiMmZlOjEKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctYW4wLTAzMDcwMDM0LzBm
ZmIyZmU3YjljMzAwODI4NzZmYTNhMTdkYTAxOGJmMDYzMmNmMDMvZG1lc2cteW9jdG8taXZ5
dG93bjItMTA6MjAxNDAzMDcwMzEyMjU6aTM4Ni1yYW5kY29uZmlnLWFuMC0wMzA3MDAzNDoz
LjE0LjAtcmM1LW5leHQtMjAxNDAzMDYtMDY5NTItZzBmZmIyZmU6MQova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQvMGZmYjJmZTdiOWMzMDA4Mjg3NmZhM2ExN2RhMDE4
YmYwNjMyY2YwMy9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTE5OjIwMTQwMzA3MDMxMjM4Omkz
ODYtcmFuZGNvbmZpZy1hbjAtMDMwNzAwMzQ6My4xNC4wLXJjNS1uZXh0LTIwMTQwMzA2LTA2
OTUyLWcwZmZiMmZlOjEKMDoxOToxOSBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoK

--AjmyJqqohANyBN/e
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
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
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
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_KERNEL_LZ4=y
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
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
# CONFIG_IRQ_DOMAIN_DEBUG is not set
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
# CONFIG_BSD_PROCESS_ACCT is not set
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
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
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
# CONFIG_MEMCG is not set
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
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
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_EXPERT is not set
CONFIG_UID16=y
CONFIG_SYSFS_SYSCALL=y
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
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
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
CONFIG_HAVE_CLK=y
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
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_AIX_PARTITION=y
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set

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
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
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
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
CONFIG_MVIAC3_2=y
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=y
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_MICROCODE_EARLY=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
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
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_SCHED_HRTICK is not set
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
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
CONFIG_PM_WAKELOCKS_GC=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_PM_SLEEP_DEBUG=y
CONFIG_DPM_WATCHDOG=y
CONFIG_DPM_WATCHDOG_TIMEOUT=12
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_EC_DEBUGFS=y
# CONFIG_ACPI_AC is not set
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_INTEL_PSTATE is not set
CONFIG_X86_PCC_CPUFREQ=y
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K6=y
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
# CONFIG_X86_LONGRUN is not set
CONFIG_X86_LONGHAUL=y
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
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_CPU_IDLE_GOV_MENU is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
CONFIG_PCI_GODIRECT=y
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
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
CONFIG_EISA_VLB_PRIMING=y
CONFIG_EISA_PCI_EISA=y
# CONFIG_EISA_VIRTUAL_ROOT is not set
# CONFIG_EISA_NAMES is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
# CONFIG_OLPC is not set
CONFIG_ALIX=y
# CONFIG_NET5501 is not set
CONFIG_GEOS=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_IOSF_MBI=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
# CONFIG_INET is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_ATM=y
CONFIG_ATM_LANE=y
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=y
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
CONFIG_LAPB=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_ATM is not set
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
# CONFIG_NET_SCH_TBF is not set
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
CONFIG_NET_SCH_QFQ=y
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_FQ=y
CONFIG_NET_SCH_HHF=y
CONFIG_NET_SCH_PIE=y
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
# CONFIG_NET_ACT_MIRRED is not set
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
# CONFIG_NET_ACT_SIMP is not set
CONFIG_NET_ACT_SKBEDIT=y
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=y
# CONFIG_NET_MPLS_GSO is not set
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
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
CONFIG_NETROM=y
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
CONFIG_BPQETHER=y
CONFIG_SCC=y
# CONFIG_SCC_DELAY is not set
# CONFIG_SCC_TRXECHO is not set
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
# CONFIG_YAM is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_LEDS=y
CONFIG_PCH_CAN=y
# CONFIG_CAN_SJA1000 is not set
# CONFIG_CAN_C_CAN is not set
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
CONFIG_CAN_ESD_USB2=y
# CONFIG_CAN_KVASER_USB is not set
CONFIG_CAN_PEAK_USB=y
# CONFIG_CAN_8DEV_USB is not set
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
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

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
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=y

#
# FIR device drivers
#
CONFIG_USB_IRDA=y
CONFIG_SIGMATEL_FIR=y
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=y
CONFIG_TOSHIBA_FIR=y
CONFIG_SMC_IRCC_FIR=y
# CONFIG_ALI_FIR is not set
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=y
CONFIG_MCS_FIR=y
# CONFIG_BT is not set
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=y
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
CONFIG_CAIF_DEBUG=y
CONFIG_CAIF_NETDEV=y
CONFIG_CAIF_USB=y
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
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_FW_LOADER_USER_HELPER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
# CONFIG_MTD_REDBOOT_PARTS is not set
CONFIG_MTD_CMDLINE_PARTS=y
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=y
CONFIG_FTL=y
# CONFIG_NFTL is not set
CONFIG_INFTL=y
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=y
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=y
# CONFIG_MTD_JEDECPROBE is not set
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
# CONFIG_MTD_CFI_INTELEXT is not set
CONFIG_MTD_CFI_AMDSTD=y
# CONFIG_MTD_CFI_STAA is not set
CONFIG_MTD_CFI_UTIL=y
CONFIG_MTD_RAM=y
# CONFIG_MTD_ROM is not set
CONFIG_MTD_ABSENT=y

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_PHYSMAP is not set
# CONFIG_MTD_SC520CDP is not set
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_SCx200_DOCFLASH=y
CONFIG_MTD_INTEL_VR_NOR=y
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=y
CONFIG_MTD_PMC551_BUGFIX=y
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_SLRAM=y
CONFIG_MTD_PHRAM=y
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=y
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=y
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_GENERIC is not set
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
CONFIG_MTD_LPDDR=y
CONFIG_MTD_QINFO_PROBE=y
# CONFIG_MTD_UBI is not set
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
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
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
# CONFIG_AD525X_DPOT is not set
CONFIG_ATMEL_PWM=y
CONFIG_DUMMY_IRQ=y
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
# CONFIG_EEPROM_LEGACY is not set
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
CONFIG_INTEL_MEI_TXE=y
CONFIG_VMWARE_VMCI=y

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
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
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
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_BOOT_SYSFS=y
# CONFIG_SCSI_BNX2_ISCSI is not set
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
CONFIG_SCSI_3W_9XXX=y
CONFIG_SCSI_3W_SAS=y
CONFIG_SCSI_7000FASST=y
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AHA1740 is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
# CONFIG_SCSI_MVSAS is not set
CONFIG_SCSI_MVUMI=y
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=y
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
CONFIG_SCSI_ESAS2R=y
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
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
CONFIG_FCOE=y
CONFIG_FCOE_FNIC=y
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_DTC3280=y
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_GDTH=y
# CONFIG_SCSI_ISCI is not set
CONFIG_SCSI_GENERIC_NCR5380=y
CONFIG_SCSI_GENERIC_NCR5380_MMIO=y
# CONFIG_SCSI_GENERIC_NCR53C400 is not set
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=y
CONFIG_SCSI_IPR_TRACE=y
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_PAS16=y
CONFIG_SCSI_QLOGIC_FAS=y
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=y
CONFIG_TCM_QLA2XXX=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
CONFIG_SCSI_SIM710=y
# CONFIG_SCSI_SYM53C416 is not set
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_T128=y
# CONFIG_SCSI_U14_34F is not set
CONFIG_SCSI_ULTRASTOR=y
CONFIG_SCSI_NSP32=y
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
CONFIG_SCSI_PM8001=y
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_BFA_FC=y
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_CHELSIO_FCOE=y
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
# CONFIG_ATA_ACPI is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
# CONFIG_MD is not set
CONFIG_TARGET_CORE=y
CONFIG_TCM_IBLOCK=y
# CONFIG_TCM_FILEIO is not set
# CONFIG_TCM_PSCSI is not set
# CONFIG_LOOPBACK_TARGET is not set
CONFIG_TCM_FC=y
CONFIG_ISCSI_TARGET=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_DUMMY=y
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_IFB=y
CONFIG_NET_TEAM=y
CONFIG_NET_TEAM_MODE_BROADCAST=y
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
# CONFIG_NET_TEAM_MODE_RANDOM is not set
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_NTB_NETDEV=y
CONFIG_TUN=y
CONFIG_VETH=y
CONFIG_VIRTIO_NET=y
CONFIG_NLMON=y
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
CONFIG_ARCNET_1051=y
# CONFIG_ARCNET_RAW is not set
CONFIG_ARCNET_CAP=y
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=y
# CONFIG_ARCNET_RIM_I is not set
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_ISA=y
CONFIG_ARCNET_COM20020_PCI=y
# CONFIG_ATM_DRIVERS is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=y
CONFIG_CAIF_SPI_SLAVE=y
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=y
CONFIG_CAIF_VIRTIO=y
# CONFIG_VHOST_NET is not set
CONFIG_VHOST_RING=y

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ARC is not set
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
# CONFIG_ATL1E is not set
CONFIG_ATL1C=y
# CONFIG_ALX is not set
CONFIG_NET_CADENCE=y
CONFIG_ARM_AT91_ETHER=y
CONFIG_MACB=y
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_TIGON3=y
CONFIG_BNX2X=y
CONFIG_BNX2X_SRIOV=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=y
CONFIG_NET_CALXEDA_XGMAC=y
# CONFIG_NET_VENDOR_CHELSIO is not set
# CONFIG_NET_VENDOR_CIRRUS is not set
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
CONFIG_NET_VENDOR_EXAR=y
CONFIG_S2IO=y
CONFIG_VXGE=y
CONFIG_VXGE_DEBUG_TRACE_ALL=y
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
# CONFIG_IGB_HWMON is not set
CONFIG_IGBVF=y
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
# CONFIG_IXGBE_HWMON is not set
CONFIG_IXGBEVF=y
CONFIG_I40E=y
CONFIG_I40EVF=y
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_IP1000=y
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_FEALNX=y
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
# CONFIG_R8169 is not set
CONFIG_SH_ETH=y
CONFIG_NET_VENDOR_RDC=y
CONFIG_R6040=y
# CONFIG_NET_VENDOR_SEEQ is not set
# CONFIG_NET_VENDOR_SILAN is not set
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
# CONFIG_SIS190 is not set
CONFIG_SFC=y
# CONFIG_SFC_MTD is not set
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
# CONFIG_NET_VENDOR_SMSC is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=y
# CONFIG_STMMAC_PLATFORM is not set
CONFIG_STMMAC_PCI=y
CONFIG_STMMAC_DEBUG_FS=y
CONFIG_STMMAC_DA=y
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_TEHUTI=y
CONFIG_TEHUTI=y
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
# CONFIG_DEFXX_MMIO is not set
# CONFIG_SKFP is not set
CONFIG_NET_SB1000=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
CONFIG_AMD_PHY=y
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=y
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
CONFIG_MDIO_BITBANG=y
# CONFIG_MDIO_GPIO is not set
# CONFIG_PPP is not set
CONFIG_SLIP=y
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
# CONFIG_SLIP_MODE_SLIP6 is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=y
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
# CONFIG_USB_NET_AX88179_178A is not set
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
CONFIG_USB_NET_SR9800=y
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
CONFIG_USB_NET_KALMIA=y
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_CDC_PHONET=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=y
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_USB=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
CONFIG_IEEE802154_FAKELB=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
# CONFIG_ISDN_AUDIO is not set

#
# ISDN feature submodules
#
# CONFIG_ISDN_DIVERSION is not set

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
# CONFIG_ISDN_DRV_ICN is not set
CONFIG_ISDN_DRV_PCBIT=y
CONFIG_ISDN_DRV_SC=y
CONFIG_ISDN_DRV_ACT2000=y
# CONFIG_ISDN_CAPI is not set
CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_I4L=y
# CONFIG_GIGASET_DUMMYLL is not set
CONFIG_GIGASET_BASE=y
CONFIG_GIGASET_M105=y
CONFIG_GIGASET_M101=y
CONFIG_GIGASET_DEBUG=y
CONFIG_MISDN=y
CONFIG_MISDN_DSP=y
# CONFIG_MISDN_L1OIP is not set

#
# mISDN hardware drivers
#
# CONFIG_MISDN_HFCPCI is not set
# CONFIG_MISDN_HFCMULTI is not set
CONFIG_MISDN_HFCUSB=y
CONFIG_MISDN_AVMFRITZ=y
# CONFIG_MISDN_SPEEDFAX is not set
# CONFIG_MISDN_INFINEON is not set
CONFIG_MISDN_W6692=y
# CONFIG_MISDN_NETJET is not set
CONFIG_MISDN_IPAC=y

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
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
CONFIG_KEYBOARD_SAMSUNG=y
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_TC3589X=y
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
CONFIG_MOUSE_INPORT=y
# CONFIG_MOUSE_ATIXL is not set
CONFIG_MOUSE_LOGIBM=y
# CONFIG_MOUSE_PC110PAD is not set
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_MOUSE_SYNAPTICS_USB=y
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
CONFIG_JOYSTICK_ADI=y
CONFIG_JOYSTICK_COBRA=y
CONFIG_JOYSTICK_GF2K=y
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
# CONFIG_JOYSTICK_TMDC is not set
CONFIG_JOYSTICK_IFORCE=y
CONFIG_JOYSTICK_IFORCE_USB=y
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
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_WACOM_I2C=y
CONFIG_TOUCHSCREEN_MAX11801=y
# CONFIG_TOUCHSCREEN_MCS5000 is not set
CONFIG_TOUCHSCREEN_MMS114=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
CONFIG_TOUCHSCREEN_EDT_FT5X06=y
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
# CONFIG_TOUCHSCREEN_TI_AM335X_TSC is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
# CONFIG_TOUCHSCREEN_MC13783 is not set
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
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_W90X900 is not set
CONFIG_TOUCHSCREEN_ST1232=y
# CONFIG_TOUCHSCREEN_SUR40 is not set
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_TOUCHSCREEN_ZFORCE=y
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_88PM860X_ONKEY is not set
CONFIG_INPUT_88PM80X_ONKEY=y
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_ARIZONA_HAPTICS=y
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MC13783_PWRBUTTON is not set
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
# CONFIG_INPUT_GPIO_TILT_POLLED is not set
CONFIG_INPUT_WISTRON_BTNS=y
CONFIG_INPUT_ATLAS_BTNS=y
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_KXTJ9=y
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_TWL4030_PWRBUTTON=y
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9055_ONKEY=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
# CONFIG_INPUT_IMS_PCU is not set
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y
CONFIG_INPUT_IDEAPAD_SLIDEBAR=y

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
# CONFIG_SERIO_ARC_PS2 is not set
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
# CONFIG_GAMEPORT_L4 is not set
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

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
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_SERIAL_SCCNXP=y
CONFIG_SERIAL_SCCNXP_CONSOLE=y
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
# CONFIG_SERIAL_ALTERA_UART_CONSOLE is not set
CONFIG_SERIAL_PCH_UART=y
CONFIG_SERIAL_PCH_UART_CONSOLE=y
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
# CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_ATMEL is not set
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
# CONFIG_HW_RANDOM_EXYNOS is not set
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=y
# CONFIG_DTLK is not set
CONFIG_R3964=y
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set
CONFIG_MWAVE=y
# CONFIG_SCx200_GPIO is not set
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HPET_MMAP_DEFAULT=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_TIS_I2C_NUVOTON=y
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
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_MUX_PINCTRL=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
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
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
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
# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_KEMPLD=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_ROBOTFUZZ_OSIF=y
CONFIG_I2C_TAOS_EVM=y
CONFIG_I2C_TINY_USB=y
CONFIG_I2C_VIPERBOARD=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_ISA=y
CONFIG_SCx200_ACB=y
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
CONFIG_DP83640_PHY=y
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_PINCTRL=y

#
# Pin controllers
#
# CONFIG_PINMUX is not set
CONFIG_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
# CONFIG_GPIO_DA9055 is not set
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
# CONFIG_GPIO_LP3943 is not set
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
# CONFIG_GPIO_RC5T583 is not set
# CONFIG_GPIO_SX150X is not set
# CONFIG_GPIO_TC3589X is not set
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_TWL4030 is not set
# CONFIG_GPIO_ADP5520 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#

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
CONFIG_GPIO_PALMAS=y

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
CONFIG_W1_MASTER_GPIO=y

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=y
CONFIG_W1_SLAVE_DS2423=y
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2760=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
CONFIG_CHARGER_PCF50633=y
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
# CONFIG_CHARGER_MANAGER is not set
# CONFIG_CHARGER_MAX8997 is not set
# CONFIG_CHARGER_BQ2415X is not set
CONFIG_CHARGER_BQ24190=y
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_CHARGER_TPS65090=y
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=y
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADM1021=y
CONFIG_SENSORS_ADM1025=y
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
CONFIG_SENSORS_ADT7462=y
CONFIG_SENSORS_ADT7470=y
# CONFIG_SENSORS_ADT7475 is not set
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_APPLESMC=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9055 is not set
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
CONFIG_SENSORS_GPIO_FAN=y
CONFIG_SENSORS_HIH6130=y
CONFIG_SENSORS_IBMAEM=y
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IIO_HWMON=y
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4260=y
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
# CONFIG_SENSORS_LM90 is not set
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LM95234 is not set
CONFIG_SENSORS_LM95241=y
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
CONFIG_SENSORS_SIS5595=y
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
CONFIG_SENSORS_EMC2103=y
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
# CONFIG_SENSORS_SCH5636 is not set
CONFIG_SENSORS_SMM665=y
CONFIG_SENSORS_ADC128D818=y
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_AMC6821 is not set
CONFIG_SENSORS_INA209=y
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=y
CONFIG_SENSORS_VIA686A=y
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
CONFIG_SENSORS_W83781D=y
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=y
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set

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
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_THERMAL_EMULATION=y
CONFIG_INTEL_POWERCLAMP=y
CONFIG_ACPI_INT3403_THERMAL=y

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
CONFIG_DA9055_WATCHDOG=y
CONFIG_XILINX_WATCHDOG=y
# CONFIG_DW_WATCHDOG is not set
CONFIG_TWL4030_WATCHDOG=y
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=y
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=y
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=y
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
# CONFIG_KEMPLD_WDT is not set
CONFIG_HPWDT_NMI_DECODING=y
CONFIG_SC1200_WDT=y
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
CONFIG_NV_TCO=y
CONFIG_60XX_WDT=y
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83697HF_WDT=y
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
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
# CONFIG_PCIPCWATCHDOG is not set
CONFIG_WDTPCI=y

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
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
CONFIG_SSB_DEBUG=y
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
# CONFIG_BCMA_DRIVER_GPIO is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_HTC_PASIC3=y
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=y
CONFIG_MFD_88PM800=y
CONFIG_MFD_88PM805=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
CONFIG_MFD_MAX8997=y
# CONFIG_MFD_MAX8998 is not set
CONFIG_MFD_VIPERBOARD=y
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=y
CONFIG_PCF50633_ADC=y
CONFIG_PCF50633_GPIO=y
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
CONFIG_MFD_RTSX_USB=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
CONFIG_MFD_PALMAS=y
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS65218=y
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS80031 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
CONFIG_MFD_TWL4030_AUDIO=y
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_WM5102 is not set
# CONFIG_MFD_WM5110 is not set
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
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_ACT8865=y
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_AAT2870 is not set
# CONFIG_REGULATOR_ARIZONA is not set
CONFIG_REGULATOR_AS3711=y
# CONFIG_REGULATOR_DA9055 is not set
CONFIG_REGULATOR_DA9063=y
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
CONFIG_REGULATOR_LP3971=y
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8907=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8997=y
CONFIG_REGULATOR_MAX77686=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
# CONFIG_REGULATOR_MC13892 is not set
CONFIG_REGULATOR_PALMAS=y
CONFIG_REGULATOR_PCF50633=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_RC5T583=y
CONFIG_REGULATOR_TPS51632=y
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_TWL4030=y
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_V4L2_MEM2MEM_DEV=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF2_CORE=y
CONFIG_VIDEOBUF2_MEMOPS=y
CONFIG_VIDEOBUF2_DMA_CONTIG=y
CONFIG_VIDEOBUF2_VMALLOC=y
CONFIG_VIDEOBUF2_DMA_SG=y
# CONFIG_TTPCI_EEPROM is not set

#
# Media drivers
#
CONFIG_RC_CORE=y
CONFIG_RC_MAP=y
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_USB_SUPPORT is not set
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
CONFIG_V4L_PLATFORM_DRIVERS=y
CONFIG_VIDEO_CAFE_CCIC=y
CONFIG_SOC_CAMERA=y
CONFIG_SOC_CAMERA_SCALE_CROP=y
# CONFIG_SOC_CAMERA_PLATFORM is not set
CONFIG_VIDEO_RCAR_VIN=y
# CONFIG_VIDEO_SH_MOBILE_CSI2 is not set
CONFIG_VIDEO_SH_MOBILE_CEU=y
CONFIG_V4L_MEM2MEM_DRIVERS=y
CONFIG_VIDEO_SH_VEU=y
# CONFIG_VIDEO_RENESAS_VSP1 is not set
CONFIG_V4L_TEST_DRIVERS=y
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_MEM2MEM_TESTDEV=y

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_PARPORT_SUPPORT=y
CONFIG_VIDEO_PMS=y
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_CYPRESS_FIRMWARE=y

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
CONFIG_VIDEO_OV7670=y

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
# soc_camera sensor drivers
#
CONFIG_SOC_CAMERA_IMX074=y
CONFIG_SOC_CAMERA_MT9M001=y
# CONFIG_SOC_CAMERA_MT9M111 is not set
# CONFIG_SOC_CAMERA_MT9T031 is not set
# CONFIG_SOC_CAMERA_MT9T112 is not set
# CONFIG_SOC_CAMERA_MT9V022 is not set
CONFIG_SOC_CAMERA_OV2640=y
CONFIG_SOC_CAMERA_OV5642=y
# CONFIG_SOC_CAMERA_OV6650 is not set
CONFIG_SOC_CAMERA_OV772X=y
# CONFIG_SOC_CAMERA_OV9640 is not set
CONFIG_SOC_CAMERA_OV9740=y
CONFIG_SOC_CAMERA_RJ54N1=y
CONFIG_SOC_CAMERA_TW9910=y
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
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_UMS=y
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_I915_FBDEV=y
CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT=y
CONFIG_DRM_I915_UMS=y
# CONFIG_DRM_MGA is not set
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=y
# CONFIG_DRM_GMA600 is not set
# CONFIG_DRM_GMA3600 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_QXL=y
# CONFIG_DRM_BOCHS is not set

#
# Frame buffer Devices
#
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
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
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
# CONFIG_FB_PM2 is not set
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
CONFIG_FB_GEODE_GX=y
# CONFIG_FB_GEODE_GX1 is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_SMSCUFX=y
# CONFIG_FB_UDL is not set
CONFIG_FB_GOLDFISH=y
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=y
CONFIG_FB_AUO_K1900=y
CONFIG_FB_AUO_K1901=y
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_ATMEL_PWM=y
# CONFIG_BACKLIGHT_GENERIC is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_APPLE=y
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_ADP5520 is not set
CONFIG_BACKLIGHT_ADP8860=y
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_PCF50633=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_TPS65217=y
# CONFIG_BACKLIGHT_AS3711 is not set
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_MDA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_COMPRESS_OFFLOAD=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_DRIVERS=y
# CONFIG_SND_DUMMY is not set
CONFIG_SND_ALOOP=y
CONFIG_SND_VIRMIDI=y
CONFIG_SND_MTPAV=y
CONFIG_SND_SERIAL_U16550=y
# CONFIG_SND_MPU401 is not set
# CONFIG_SND_ISA is not set
# CONFIG_SND_PCI is not set

#
# HD-Audio
#
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
# CONFIG_SND_USB_UA101 is not set
CONFIG_SND_USB_USX2Y=y
CONFIG_SND_USB_CAIAQ=y
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=y
# CONFIG_SND_USB_6FIRE is not set
# CONFIG_SND_USB_HIFACE is not set
CONFIG_SND_SOC=y
# CONFIG_SND_ATMEL_SOC is not set
CONFIG_SND_DESIGNWARE_I2S=y
CONFIG_SND_SOC_INTEL_SST=y
CONFIG_SND_SOC_INTEL_SST_ACPI=y
CONFIG_SND_SOC_INTEL_BAYTRAIL=y
# CONFIG_SND_SOC_INTEL_HASWELL_MACH is not set
CONFIG_SND_SOC_INTEL_BYT_RT5640_MACH=y
CONFIG_SND_SOC_I2C_AND_SPI=y

#
# CODEC drivers
#
CONFIG_SND_SOC_ADAU1701=y
CONFIG_SND_SOC_AK4554=y
# CONFIG_SND_SOC_AK4642 is not set
CONFIG_SND_SOC_AK5386=y
CONFIG_SND_SOC_CS42L52=y
CONFIG_SND_SOC_CS42L73=y
# CONFIG_SND_SOC_CS4270 is not set
# CONFIG_SND_SOC_CS4271 is not set
# CONFIG_SND_SOC_HDMI_CODEC is not set
CONFIG_SND_SOC_PCM1681=y
CONFIG_SND_SOC_PCM512x=y
CONFIG_SND_SOC_RT5640=y
# CONFIG_SND_SOC_SGTL5000 is not set
CONFIG_SND_SOC_SIGMADSP=y
CONFIG_SND_SOC_SPDIF=y
CONFIG_SND_SOC_TAS5086=y
CONFIG_SND_SOC_TLV320AIC3X=y
CONFIG_SND_SOC_WM8510=y
CONFIG_SND_SOC_WM8523=y
CONFIG_SND_SOC_WM8580=y
CONFIG_SND_SOC_WM8711=y
CONFIG_SND_SOC_WM8728=y
CONFIG_SND_SOC_WM8731=y
CONFIG_SND_SOC_WM8737=y
# CONFIG_SND_SOC_WM8741 is not set
CONFIG_SND_SOC_WM8750=y
CONFIG_SND_SOC_WM8753=y
# CONFIG_SND_SOC_WM8776 is not set
# CONFIG_SND_SOC_WM8804 is not set
CONFIG_SND_SOC_WM8903=y
CONFIG_SND_SOC_WM8962=y
CONFIG_SND_SOC_TPA6130A2=y
# CONFIG_SND_SIMPLE_CARD is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
CONFIG_UHID=y
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
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=y
CONFIG_HID_CYPRESS=y
# CONFIG_HID_DRAGONRISE is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_ICADE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LENOVO_TPKBD=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
# CONFIG_LOGITECH_FF is not set
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=y
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_WACOM is not set
# CONFIG_HID_WIIMOTE is not set
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
CONFIG_HID_SENSOR_HUB=y

#
# USB HID support
#
# CONFIG_USB_HID is not set
CONFIG_HID_PID=y

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
# CONFIG_USB_DEFAULT_PERSIST is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_OTG=y
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

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
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_FUSBH200_HCD=y
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_PCI is not set
CONFIG_USB_OHCI_HCD_SSB=y
CONFIG_USB_OHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_RENESAS_USBHS_HCD=y
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=y
# CONFIG_USB_HCD_BCMA is not set
CONFIG_USB_HCD_SSB=y
CONFIG_USB_HCD_TEST_MODE=y
CONFIG_USB_RENESAS_USBHS=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_REALTEK=y
# CONFIG_REALTEK_AUTOPM is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
CONFIG_USB_DWC2=y
# CONFIG_USB_DWC2_DEBUG is not set
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_UDC is not set
CONFIG_USB_CHIPIDEA_HOST=y
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

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
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=y
CONFIG_USB_IOWARRIOR=y
CONFIG_USB_TEST=y
CONFIG_USB_EHSET_TEST_FIXTURE=y
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
CONFIG_USB_HSIC_USB3503=y
CONFIG_USB_ATM=y
# CONFIG_USB_SPEEDTOUCH is not set
CONFIG_USB_CXACRU=y
CONFIG_USB_UEAGLEATM=y
# CONFIG_USB_XUSBATM is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=y
CONFIG_NOP_USB_XCEIV=y
CONFIG_SAMSUNG_USBPHY=y
CONFIG_SAMSUNG_USB2PHY=y
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_TAHVO_USB is not set
CONFIG_USB_ISP1301=y
# CONFIG_USB_RCAR_PHY is not set
CONFIG_USB_GADGET=y
# CONFIG_USB_GADGET_DEBUG is not set
CONFIG_USB_GADGET_DEBUG_FILES=y
CONFIG_USB_GADGET_DEBUG_FS=y
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
CONFIG_USB_FUSB300=y
# CONFIG_USB_FOTG210_UDC is not set
# CONFIG_USB_GR_UDC is not set
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_RENESAS_USBHS_UDC=y
CONFIG_USB_PXA27X=y
CONFIG_USB_S3C_HSOTG=y
# CONFIG_USB_MV_UDC is not set
CONFIG_USB_MV_U3D=y
CONFIG_USB_M66592=y
CONFIG_USB_AMD5536UDC=y
# CONFIG_USB_NET2272 is not set
CONFIG_USB_NET2280=y
CONFIG_USB_GOKU=y
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=y
CONFIG_USB_F_ACM=y
CONFIG_USB_U_SERIAL=y
CONFIG_USB_U_ETHER=y
CONFIG_USB_F_OBEX=y
CONFIG_USB_F_ECM=y
CONFIG_USB_F_PHONET=y
# CONFIG_USB_CONFIGFS is not set
# CONFIG_USB_ZERO is not set
# CONFIG_USB_AUDIO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
# CONFIG_USB_GADGETFS is not set
# CONFIG_USB_FUNCTIONFS is not set
# CONFIG_USB_MASS_STORAGE is not set
# CONFIG_USB_GADGET_TARGET is not set
# CONFIG_USB_G_SERIAL is not set
# CONFIG_USB_MIDI_GADGET is not set
# CONFIG_USB_G_PRINTER is not set
# CONFIG_USB_CDC_COMPOSITE is not set
CONFIG_USB_G_NOKIA=y
# CONFIG_USB_G_ACM_MS is not set
# CONFIG_USB_G_MULTI is not set
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set
# CONFIG_USB_G_WEBCAM is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
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
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
CONFIG_MMC_SDHCI_ACPI=y
CONFIG_MMC_SDHCI_PLTFM=y
# CONFIG_MMC_SDHCI_PXAV3 is not set
CONFIG_MMC_SDHCI_PXAV2=y
CONFIG_MMC_WBSD=y
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_VUB300=y
# CONFIG_MMC_USHC is not set
CONFIG_MMC_REALTEK_PCI=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y
CONFIG_MS_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_MEMSTICK_REALTEK_PCI=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_ATMEL_PWM=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
# CONFIG_LEDS_PCA9532_GPIO is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
# CONFIG_LEDS_LP8501 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA963X=y
CONFIG_LEDS_PCA9685=y
# CONFIG_LEDS_REGULATOR is not set
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=y
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_MAX8997 is not set
CONFIG_LEDS_LM355x=y
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
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
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_88PM860X is not set
CONFIG_RTC_DRV_88PM80X=y
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=y
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
# CONFIG_RTC_DRV_MAX8997 is not set
CONFIG_RTC_DRV_MAX77686=y
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=y
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PALMAS=y
CONFIG_RTC_DRV_PCF2127=y
CONFIG_RTC_DRV_PCF8523=y
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TWL4030 is not set
CONFIG_RTC_DRV_RC5T583=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
CONFIG_RTC_DRV_RX8025=y
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9055=y
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_DS2404 is not set
CONFIG_RTC_DRV_PCF50633=y

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
# CONFIG_UIO_SERCOS3 is not set
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
# CONFIG_UIO_MF624 is not set
# CONFIG_VFIO is not set
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
CONFIG_STAGING=y
CONFIG_ET131X=y
CONFIG_SLICOSS=y
CONFIG_USBIP_CORE=y
CONFIG_USBIP_VHCI_HCD=y
# CONFIG_USBIP_HOST is not set
# CONFIG_USBIP_DEBUG is not set
CONFIG_RTS5139=y
CONFIG_RTS5139_DEBUG=y
# CONFIG_RTS5208 is not set
# CONFIG_TRANZPORT is not set
CONFIG_LINE6_USB=y
# CONFIG_LINE6_USB_IMPULSE_RESPONSE is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD7291=y
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=y
CONFIG_ADT7316_I2C=y

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7152 is not set
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Light sensors
#
# CONFIG_SENSORS_ISL29018 is not set
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
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
# CONFIG_IIO_SIMPLE_DUMMY is not set
CONFIG_CRYSTALHD=y
CONFIG_FB_XGI=y
# CONFIG_ACPI_QUICKSTART is not set
CONFIG_BCM_WIMAX=y
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
CONFIG_SPEAKUP_SYNTH_ACNTSA=y
# CONFIG_SPEAKUP_SYNTH_ACNTPC is not set
CONFIG_SPEAKUP_SYNTH_APOLLO=y
# CONFIG_SPEAKUP_SYNTH_AUDPTR is not set
# CONFIG_SPEAKUP_SYNTH_BNS is not set
# CONFIG_SPEAKUP_SYNTH_DECTLK is not set
# CONFIG_SPEAKUP_SYNTH_DECEXT is not set
# CONFIG_SPEAKUP_SYNTH_DTLK is not set
# CONFIG_SPEAKUP_SYNTH_KEYPC is not set
CONFIG_SPEAKUP_SYNTH_LTLK=y
# CONFIG_SPEAKUP_SYNTH_SOFT is not set
CONFIG_SPEAKUP_SYNTH_SPKOUT=y
# CONFIG_SPEAKUP_SYNTH_TXPRT is not set
# CONFIG_SPEAKUP_SYNTH_DUMMY is not set
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=y
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
CONFIG_STAGING_MEDIA=y
CONFIG_VIDEO_DT3155=y
# CONFIG_DT3155_CCIR is not set
CONFIG_DT3155_STREAMING=y
# CONFIG_VIDEO_GO7007 is not set
# CONFIG_USB_MSI3101 is not set
# CONFIG_VIDEO_TCM825X is not set
CONFIG_SOLO6X10=y

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
CONFIG_WIMAX_GDM72XX_K_MODE=y
# CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
# CONFIG_WIMAX_GDM72XX_USB is not set
CONFIG_WIMAX_GDM72XX_SDIO=y
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_CED1401=y
CONFIG_DGRP=y
CONFIG_XILLYBUS=y
CONFIG_XILLYBUS_PCIE=y
CONFIG_DGNC=y
CONFIG_DGAP=y
CONFIG_GS_FPGABOOT=y
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACERHDF=y
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_DELL_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
CONFIG_FUJITSU_TABLET=y
# CONFIG_HP_ACCEL is not set
CONFIG_HP_WIRELESS=y
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
CONFIG_THINKPAD_ACPI_DEBUG=y
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
CONFIG_SENSORS_HDAPS=y
CONFIG_INTEL_MENLOW=y
CONFIG_EEEPC_LAPTOP=y
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_SAMSUNG_Q10=y
CONFIG_APPLE_GMUX=y
# CONFIG_INTEL_RST is not set
CONFIG_INTEL_SMARTCONNECT=y
CONFIG_PVPANIC=y
CONFIG_CHROME_PLATFORMS=y
CONFIG_CHROMEOS_LAPTOP=y
# CONFIG_CHROMEOS_PSTORE is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
CONFIG_COMMON_CLK_MAX77686=y
# CONFIG_COMMON_CLK_SI5351 is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y

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
# CONFIG_EXTCON_GPIO is not set
CONFIG_EXTCON_ADC_JACK=y
CONFIG_EXTCON_MAX8997=y
CONFIG_EXTCON_ARIZONA=y
CONFIG_EXTCON_PALMAS=y
# CONFIG_MEMORY is not set
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
# CONFIG_BMA180 is not set
CONFIG_HID_SENSOR_ACCEL_3D=y
CONFIG_IIO_ST_ACCEL_3AXIS=y
CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y

#
# Analog to digital converters
#
# CONFIG_MAX1363 is not set
# CONFIG_MCP3422 is not set
CONFIG_NAU7802=y
CONFIG_TI_ADC081C=y
CONFIG_TI_AM335X_ADC=y
CONFIG_TWL6030_GPADC=y
# CONFIG_VIPERBOARD_ADC is not set

#
# Amplifiers
#

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=y
CONFIG_HID_SENSOR_IIO_TRIGGER=y
CONFIG_IIO_ST_SENSORS_I2C=y
CONFIG_IIO_ST_SENSORS_CORE=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5380 is not set
CONFIG_AD5446=y
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
# Humidity sensors
#
CONFIG_DHT11=y
# CONFIG_SI7005 is not set

#
# Inertial measurement units
#
CONFIG_INV_MPU6050_IIO=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
# CONFIG_APDS9300 is not set
CONFIG_CM32181=y
CONFIG_CM36651=y
# CONFIG_GP2AP020A00F is not set
CONFIG_HID_SENSOR_ALS=y
CONFIG_HID_SENSOR_PROX=y
# CONFIG_LTR501 is not set
# CONFIG_TCS3472 is not set
CONFIG_SENSORS_TSL2563=y
CONFIG_TSL4531=y
CONFIG_VCNL4000=y

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
CONFIG_MAG3110=y
CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
CONFIG_IIO_ST_MAGN_3AXIS=y
CONFIG_IIO_ST_MAGN_I2C_3AXIS=y

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
CONFIG_HID_SENSOR_PRESS=y
# CONFIG_MPL3115 is not set
# CONFIG_IIO_ST_PRESS is not set

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
# CONFIG_VME_CA91CX42 is not set
# CONFIG_VME_TSI148 is not set

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
CONFIG_VME_USER=y
# CONFIG_VME_PIO2 is not set
# CONFIG_PWM is not set
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
CONFIG_SERIAL_IPOCTAL=y
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=y
CONFIG_FMC_FAKEDEV=y
CONFIG_FMC_TRIVIAL=y
CONFIG_FMC_WRITE_EEPROM=y
CONFIG_FMC_CHARDEV=y

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y
CONFIG_MCB=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
# CONFIG_EXT4_USE_FOR_EXT23 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
CONFIG_GFS2_FS=y
CONFIG_OCFS2_FS=y
# CONFIG_OCFS2_FS_O2CB is not set
CONFIG_OCFS2_FS_STATS=y
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=y
# CONFIG_ECRYPT_FS_MESSAGING is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
# CONFIG_JFFS2_RTIME is not set
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
# CONFIG_SQUASHFS_XATTR is not set
CONFIG_SQUASHFS_ZLIB=y
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
# CONFIG_ROMFS_BACKED_BY_BLOCK is not set
# CONFIG_ROMFS_BACKED_BY_MTD is not set
CONFIG_ROMFS_BACKED_BY_BOTH=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_ROMFS_ON_MTD=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_F2FS_FS=y
# CONFIG_F2FS_STAT_FS is not set
# CONFIG_F2FS_FS_XATTR is not set
# CONFIG_F2FS_CHECK_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
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
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
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
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
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
CONFIG_DEBUG_PREEMPT=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_VERBOSE=y
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
CONFIG_LATENCYTOP=y
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
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
# CONFIG_ATOMIC64_SELFTEST is not set
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
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
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
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_INTEL_TXT is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
# CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_TEMPLATE=y
# CONFIG_IMA_NG_TEMPLATE is not set
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_APPRAISE=y
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
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
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
# CONFIG_CRYPTO_AUTHENC is not set
CONFIG_CRYPTO_ABLK_HELPER=y

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
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_CRC32 is not set
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
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
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
CONFIG_CRYPTO_DEV_GEODE=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
# CONFIG_CRYPTO_DEV_HIFN_795X_RNG is not set
# CONFIG_CRYPTO_DEV_CCP is not set
# CONFIG_ASYMMETRIC_KEY_TYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_LGUEST=y
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
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
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
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_BTREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_FONT_SUPPORT=y
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
CONFIG_FONT_8x16=y
CONFIG_FONT_6x11=y
# CONFIG_FONT_7x14 is not set
CONFIG_FONT_PEARL_8x8=y
# CONFIG_FONT_ACORN_8x8 is not set
CONFIG_FONT_MINI_4x6=y
# CONFIG_FONT_SUN8x16 is not set
CONFIG_FONT_SUN12x22=y
# CONFIG_FONT_10x18 is not set

--AjmyJqqohANyBN/e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--AjmyJqqohANyBN/e--
