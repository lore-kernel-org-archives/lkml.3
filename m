Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaANNbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:31:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:59830 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbaANNbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:31:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,658,1384329600"; 
   d="log'?scan'208";a="458549247"
Date: Tue, 14 Jan 2014 21:31:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [x86, kaslr] BUG: kernel boot hang
Message-ID: <20140114133125.GB26942@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below dmesg and the first bad commit is

commit 82fa9637a2ba285bcc7c5050c73010b2c1b3d803
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Thu Oct 10 17:18:16 2013 -0700
Commit:     H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun Oct 13 03:12:19 2013 -0700

    x86, kaslr: Select random position from e820 maps
    
    Counts available alignment positions across all e820 maps, and chooses
    one randomly for the new kernel base address, making sure not to collide
    with unsafe memory areas.
    
    Signed-off-by: Kees Cook <keescook@chromium.org>
    Link: http://lkml.kernel.org/r/1381450698-28710-5-git-send-email-keescook@chromium.org
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

Note that there are many other warning/errors and it's not very
reproducible, so this report might be wrong.

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================

+-----------------------------------------------------------+--------------+--------------+
|                                                           | 5bfce5ef55cb | 1955a14a5ba6 |
+-----------------------------------------------------------+--------------+--------------+
| boot_successes                                            | 3948         | 0            |
| boot_failures                                             | 52           | 89           |
| page_allocation_failure:order:,mode                       | 48           | 2            |
| Out_of_memory:Kill_process                                | 7            |              |
| BUG:kernel_early_hang_without_any_printk_output           | 1            |              |
| BUG:soft_lockup-CPU_stuck_for_s                           | 1            |              |
| WARNING:CPU:PID:at_kernel/locking/lockdep.c:check_flags() | 0            | 85           |
| general_protection_fault:SMP_SMP                          | 0            | 1            |
| RIP:__lock_acquire                                        | 0            | 1            |
| Kernel_panic-not_syncing:Fatal_exception                  | 0            | 1            |
| BUG:kernel_boot_hang                                      | 0            | 2            |
| BUG:kernel_boot_crashed                                   | 0            | 1            |
+-----------------------------------------------------------+--------------+--------------+

The last dmesg is

[    0.803796] Initramfs unpacking failed: junk in compressed archive
[    0.803796] Initramfs unpacking failed: junk in compressed archive

or in some cases

[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x07886000, 0x07886fff] PGTABLE
[    0.000000] BRK [0x07887000, 0x07887fff] PGTABLE
[    0.000000] BRK [0x07888000, 0x07888fff] PGTABLE
PANIC: early exception 0e rip 10:ffffffff86204c6e error 0 cr2 ffffffff81972b28
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-rc4-00008-g6e6a493 #614
PANIC: early exception 0e rip 10:ffffffff86204f22 error 0 cr2 ffffffff81972b28

git bisect start 7ddcdb2ccdcae0838a39b1bf7b0773c5540da847 v3.12 --
git bisect good c537aba00e3f1df8ce6c7c9fcb98b82c0c2d1d2c  # 06:55    790+     10  Merge git://git.kvack.org/~bcrl/aio-next
git bisect good a707271a8180eb60edc3bd9dc3cb425c7547fd76  # 11:26    790+      9  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good e0e8fc3148e0e142079611f82089258fb3b46f00  # 16:33    790+     16  Merge remote-tracking branch 'thermal/next'
git bisect good f7f483b7c64695af05e1ce58cc23001631281fe4  # 21:08    790+     14  Merge remote-tracking branch 'vfio/next'
git bisect  bad 19eee7a401b4a2316f1ebcdc7e66b44d6d7ea963  # 21:39     36-      1  Merge remote-tracking branch 'leds/for-next'
git bisect  bad aa3a911ccf01099f146cda01793bad03d970bc0f  # 21:56     54-      1  Merge remote-tracking branch 'edac-amd/for-next'
git bisect good a11acbbed1bf2fd3204027d2b2ac6246daf14445  # 00:27    790+      8  Merge remote-tracking branch 'dt-rh/for-next'
git bisect  bad b8057368d6c29db538ff259266a4375200c3d029  # 01:09     66-      3  Merge remote-tracking branch 'tip/auto-latest'
git bisect good 592410b1ba9daf61c3bde92762a43eac58000850  # 06:02    790+     15  Merge remote-tracking branch 'spi/for-next'
git bisect good fa6e8e5f7cbf85f364ebd5a90525dbbe9de2083b  # 11:29    790+      9  Merge tag 'perf-core-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/core
git bisect good 230d47dedb5763acfaf6842c85d9d24f97fc3ee2  # 16:02    790+     16  Merge branch 'sched/core'
git bisect good c0ffb3570ae6e152490abcf1a0241e0924db3176  # 20:38    790+     14  manual merge of x86/efi
git bisect  bad 88ec17ea98ebac2a6306bc14810046493c96e27f  # 21:09    102-      3  Merge branch 'x86/kaslr'
git bisect good 939379960e3fcd81cb8b709b67afe4c7f097dcc8  # 02:19   1000+     14  Merge branch 'x86/efi-kexec'
git bisect  bad 6e6a4932b0f569b1a5bb4fcbf5dde1b1a42f01bb  # 02:38      0-      3  x86, boot: Rename get_flags() and check_flags() to *_cpuflags()
git bisect good 5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3  # 07:35   1000+     11  x86, kaslr: Provide randomness functions
git bisect  bad f32360ef6608434a032dc7ad262d45e9693c27f3  # 07:48      0-      4  x86, kaslr: Report kernel offset on panic
git bisect  bad 82fa9637a2ba285bcc7c5050c73010b2c1b3d803  # 08:00      1-      2  x86, kaslr: Select random position from e820 maps
# first bad commit: [82fa9637a2ba285bcc7c5050c73010b2c1b3d803] x86, kaslr: Select random position from e820 maps
git bisect good 5bfce5ef55cbe78ee2ee6e97f2e26a8a582008f3  # 20:21   3000+     52  x86, kaslr: Provide randomness functions
git bisect  bad 1955a14a5ba6e3c3b11117812d11dc550ccc37ae  # 20:21      0-     89  Add linux-next specific files for 20140110
git bisect good a815a5e98e7bf4d75b2515fd08f464ca24f52c85  # 08:40   3000+   3000  Revert "x86, kaslr: Select random position from e820 maps"
git bisect good a6da83f98267bc8ee4e34aa899169991eb0ceb93  # 19:21   3000+     41  Merge branch 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
git bisect  bad cf1c1d193e37b9f79eedddc6bbd71b9f5f9751e5  # 19:51     99-    100  Add linux-next specific files for 20140114

Thanks,
Fengguang

--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-xgwo-5:20140110182546:x86_64-randconfig-s1-01101738:3.13.0-rc7-next-20140110-08732-g1955a14:1"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc7-next-20140110-08732-g1955a14 (kbuil=
d@snb) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Fri Jan 10 18:14:26 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/next:master/.v=
mlinuz-1955a14a5ba6e3c3b11117812d11dc550ccc37ae-20140110181444-6-xgwo branc=
h=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738/1955a14a=
5ba6e3c3b11117812d11dc550ccc37ae/vmlinuz-3.13.0-rc7-next-20140110-08732-g19=
55a14
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0eec0000, 0x0eec0fff] PGTABLE
[    0.000000] BRK [0x0eec1000, 0x0eec1fff] PGTABLE
[    0.000000] BRK [0x0eec2000, 0x0eec2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0d600000-0x0d7fffff]
[    0.000000]  [mem 0x0d600000-0x0d7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0d5fffff]
[    0.000000]  [mem 0x0c000000-0x0d5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0d800000-0x0fffdfff]
[    0.000000]  [mem 0x0d800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0e93d000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 000040
[    0.000000] ACPI: SSDT 000000000ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fff9000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000ca0000=
0-ffff88000cdfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88000d200000 s1914704 r8=
192 d22704 u2097152
[    0.000000] pcpu-alloc: s1914704 r8192 d22704 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr d20d180
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/next:mas=
ter/.vmlinuz-1955a14a5ba6e3c3b11117812d11dc550ccc37ae-20140110181444-6-xgwo=
 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738/19=
55a14a5ba6e3c3b11117812d11dc550ccc37ae/vmlinuz-3.13.0-rc7-next-20140110-087=
32-g1955a14
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 212104K/261744K available (6445K kernel code, 695K r=
wdata, 2688K rodata, 2588K init, 10844K bss, 49640K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc7-next-20140110-08732-g1955a14 (kbuil=
d@snb) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Fri Jan 10 18:14:26 CST=
 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/next:master/.v=
mlinuz-1955a14a5ba6e3c3b11117812d11dc550ccc37ae-20140110181444-6-xgwo branc=
h=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738/1955a14a=
5ba6e3c3b11117812d11dc550ccc37ae/vmlinuz-3.13.0-rc7-next-20140110-08732-g19=
55a14
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0eec0000, 0x0eec0fff] PGTABLE
[    0.000000] BRK [0x0eec1000, 0x0eec1fff] PGTABLE
[    0.000000] BRK [0x0eec2000, 0x0eec2fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0d600000-0x0d7fffff]
[    0.000000]  [mem 0x0d600000-0x0d7fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0d5fffff]
[    0.000000]  [mem 0x0c000000-0x0d5fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x0bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0d800000-0x0fffdfff]
[    0.000000]  [mem 0x0d800000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0e93d000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe450 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe490 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 000040
[    0.000000] ACPI: SSDT 000000000ffff7a0 000796 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff680 000080 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff640 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fff9000-0x0fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00003fffff] PMD -> [ffff88000ca0000=
0-ffff88000cdfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 840 pages used for memmap
[    0.000000]   DMA32 zone: 61438 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5fa000 (        fee00000)
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
[    0.000000] mapped IOAPIC to ffffffffff5f9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff88000d200000 s1914704 r8=
192 d22704 u2097152
[    0.000000] pcpu-alloc: s1914704 r8192 d22704 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fff8001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr d20d180
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 64519
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/next:mas=
ter/.vmlinuz-1955a14a5ba6e3c3b11117812d11dc550ccc37ae-20140110181444-6-xgwo=
 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738/19=
55a14a5ba6e3c3b11117812d11dc550ccc37ae/vmlinuz-3.13.0-rc7-next-20140110-087=
32-g1955a14
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Memory: 212104K/261744K available (6445K kernel code, 695K r=
wdata, 2688K rodata, 2588K init, 10844K bss, 49640K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
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
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000]  per task-struct memory footprint: 2688 bytes
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
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]                  A-B-B-A deadlock:
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-B-C-C-A deadlock:
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]              A-B-C-A-B-C deadlock:
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-B-C-C-D-D-A deadlock:
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-D-D-A deadlock:
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

[    0.000000]          A-B-C-D-B-C-D-A deadlock:
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |

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
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]            recursive read-lock #2:
[    0.000000]            recursive read-lock #2:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed read-write-lock:
[    0.000000]             mixed read-write-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]             mixed write-read-lock:
[    0.000000]             mixed write-read-lock:             |            =
 |  ok  |  ok  |             |             |  ok  |  ok  |

[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/12:
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      hard-irqs-on + irq-safe-A/21:
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]      soft-irqs-on + irq-safe-A/21:
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/12:
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]        sirq-safe-A =3D> hirqs-on/21:
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |  o=
k  |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/12:
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/12:
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          hard-safe-A + irqs-on/21:
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]          soft-safe-A + irqs-on/21:
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/123:
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/123:
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/132:
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/132:
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/213:
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/213:
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/231:
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/231:
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/312:
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/312:
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #1/321:
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #1/321:
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/123:
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/123:
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/132:
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/132:
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/213:
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/213:
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/231:
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/231:
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/312:
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/312:
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     hard-safe-A + unsafe-B #2/321:
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]     soft-safe-A + unsafe-B #2/321:
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/123:
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/123:
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/132:
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/132:
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/213:
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/213:
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/231:
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/231:
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/312:
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/312:
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       hard-irq lock-inversion/321:
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]       soft-irq lock-inversion/321:
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

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
[    0.000000]                ww contexts mixing:  ok  |  ok  |  ok  |  ok =
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
[    0.000000]                           context:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                               try:
[    0.000000]                               try:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                             block:
[    0.000000]                             block:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000]                          spinlock:
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |

[    0.000000] -------------------------------------------------------
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 14 of 14 active objects replaced
[    0.000000] ODEBUG: 14 of 14 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2666.792 MHz processor
[    0.000000] tsc: Detected 2666.792 MHz processor
[    0.020000] Calibrating delay loop (skipped) preset value..=20
[    0.020000] Calibrating delay loop (skipped) preset value.. 5333.58 Bogo=
MIPS (lpj=3D26667920)
5333.58 BogoMIPS (lpj=3D26667920)
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] pid_max: default: 32768 minimum: 301
[    0.020000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.020000] Dentry cache hash table entries: 32768 (order: 6, 262144 byt=
es)
[    0.020536] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.020536] Inode-cache hash table entries: 16384 (order: 5, 131072 byte=
s)
[    0.024210] Mount-cache hash table entries: 256
[    0.024210] Mount-cache hash table entries: 256
[    0.030518] Initializing cgroup subsys devices
[    0.030518] Initializing cgroup subsys devices
[    0.032796] Initializing cgroup subsys freezer
[    0.032796] Initializing cgroup subsys freezer
[    0.034513] Initializing cgroup subsys net_cls
[    0.034513] Initializing cgroup subsys net_cls
[    0.036325] mce: CPU supports 10 MCE banks
[    0.036325] mce: CPU supports 10 MCE banks
[    0.038128] numa_add_cpu cpu 0 node 0: mask now 0
[    0.038128] numa_add_cpu cpu 0 node 0: mask now 0
[    0.040020] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.040020] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.040020] tlb_flushall_shift: 6
[    0.040020] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.040020] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.040020] tlb_flushall_shift: 6
[    0.046457] Freeing SMP alternatives memory: 24K (ffffffff8e423000 - fff=
fffff8e429000)
[    0.046457] Freeing SMP alternatives memory: 24K (ffffffff8e423000 - fff=
fffff8e429000)
[    0.056352] ACPI: Core revision 20131218
[    0.056352] ACPI: Core revision 20131218
[    0.063287] ACPI:=20
[    0.063287] ACPI: All ACPI Tables successfully acquiredAll ACPI Tables s=
uccessfully acquired

[    0.066233] Getting VERSION: 50014
[    0.066233] Getting VERSION: 50014
[    0.067607] Getting VERSION: 50014
[    0.067607] Getting VERSION: 50014
[    0.068948] Getting ID: 0
[    0.068948] Getting ID: 0
[    0.070038] Getting ID: ff000000
[    0.070038] Getting ID: ff000000
[    0.071262] Getting LVT0: 8700
[    0.071262] Getting LVT0: 8700
[    0.072653] Getting LVT1: 8400
[    0.072653] Getting LVT1: 8400
[    0.074552] enabled ExtINT on CPU#0
[    0.074552] enabled ExtINT on CPU#0
[    0.077479] ENABLING IO-APIC IRQs
[    0.077479] ENABLING IO-APIC IRQs
[    0.078792] init IO_APIC IRQs
[    0.078792] init IO_APIC IRQs
[    0.080013]  apic 0 pin 0 not connected
[    0.080013]  apic 0 pin 0 not connected
[    0.081823] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.081823] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.084857] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.084857] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.087932] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.087932] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.090034] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.090034] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.093026] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.093026] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.096037] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.096037] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.100035] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.100035] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.103520] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.103520] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.106474] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.106474] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.110033] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.110033] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.113053] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.113053] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.116684] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.116684] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.120044] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.120044] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.123107] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.123107] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.126163] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.126163] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.130032]  apic 0 pin 16 not connected
[    0.130032]  apic 0 pin 16 not connected
[    0.133060]  apic 0 pin 17 not connected
[    0.133060]  apic 0 pin 17 not connected
[    0.134529]  apic 0 pin 18 not connected
[    0.134529]  apic 0 pin 18 not connected
[    0.136011]  apic 0 pin 19 not connected
[    0.136011]  apic 0 pin 19 not connected
[    0.137541]  apic 0 pin 20 not connected
[    0.137541]  apic 0 pin 20 not connected
[    0.139317]  apic 0 pin 21 not connected
[    0.139317]  apic 0 pin 21 not connected
[    0.140011]  apic 0 pin 22 not connected
[    0.140011]  apic 0 pin 22 not connected
[    0.141543]  apic 0 pin 23 not connected
[    0.141543]  apic 0 pin 23 not connected
[    0.143211] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.143211] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.146375] smpboot: CPU0:=20
[    0.146375] smpboot: CPU0: Intel Intel Common KVM processorCommon KVM pr=
ocessor (fam: 0f, model: 06 (fam: 0f, model: 06, stepping: 01)
, stepping: 01)
[    0.151700] Using local APIC timer interrupts.
[    0.151700] calibrating APIC timer ...
[    0.151700] Using local APIC timer interrupts.
[    0.151700] calibrating APIC timer ...
[    0.160000] ... lapic delta =3D 6247446
[    0.160000] ... lapic delta =3D 6247446
[    0.160000] ... PM-Timer delta =3D 357892
[    0.160000] ... PM-Timer delta =3D 357892
[    0.160000] ... PM-Timer result ok
[    0.160000] ... PM-Timer result ok
[    0.160000] ..... delta 6247446
[    0.160000] ..... delta 6247446
[    0.160000] ..... mult: 268325762
[    0.160000] ..... mult: 268325762
[    0.160000] ..... calibration result: 9995913
[    0.160000] ..... calibration result: 9995913
[    0.160000] ..... CPU clock speed is 2666.2429 MHz.
[    0.160000] ..... CPU clock speed is 2666.2429 MHz.
[    0.160000] ..... host bus clock speed is 999.5913 MHz.
[    0.160000] ..... host bus clock speed is 999.5913 MHz.
[    0.160181] Performance Events:=20
[    0.160181] Performance Events: unsupported Netburst CPU model 6 unsuppo=
rted Netburst CPU model 6 no PMU driver, software events only.
no PMU driver, software events only.
[    0.167257] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.167257] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.171337] x86: Booting SMP configuration:
[    0.171337] x86: Booting SMP configuration:
[    0.173629] .... node  #0, CPUs: =20
[    0.173629] .... node  #0, CPUs:         #1 #1
[    0.167119] kvm-clock: cpu 1, msr 0:fff8041, secondary cpu clock
[    0.167119] masked ExtINT on CPU#1
[    0.167119] numa_add_cpu cpu 1 node 0: mask now 0-1
[    0.212081] x86: Booted up 1 node, 2 CPUs
[    0.212081] x86: Booted up 1 node, 2 CPUs
[    0.212029] KVM setup async PF for cpu 1
[    0.212029] KVM setup async PF for cpu 1
[    0.212029] kvm-stealtime: cpu 1, msr d40d180
[    0.212029] kvm-stealtime: cpu 1, msr d40d180
[    0.220007] smpboot: Total of 2 processors activated (10667.16 BogoMIPS)
[    0.220007] smpboot: Total of 2 processors activated (10667.16 BogoMIPS)
[    0.251024] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.251024] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.254488] regulator-dummy: no parameters
[    0.254488] regulator-dummy: no parameters
[    0.256582] NET: Registered protocol family 16
[    0.256582] NET: Registered protocol family 16
[    0.259159] cpuidle: using governor ladder
[    0.259159] cpuidle: using governor ladder
[    0.260010] cpuidle: using governor menu
[    0.260010] cpuidle: using governor menu
[    0.261692] ACPI: bus type PCI registered
[    0.261692] ACPI: bus type PCI registered
[    0.263249] PCI: Using configuration type 1 for base access
[    0.263249] PCI: Using configuration type 1 for base access
[    0.282259] bio: create slab <bio-0> at 0
[    0.282259] bio: create slab <bio-0> at 0
[    0.294293] ACPI: Added _OSI(Module Device)
[    0.294293] ACPI: Added _OSI(Module Device)
[    0.300008] ACPI: Added _OSI(Processor Device)
[    0.300008] ACPI: Added _OSI(Processor Device)
[    0.301614] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.301614] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.303380] ACPI: Added _OSI(Processor Aggregator Device)
[    0.303380] ACPI: Added _OSI(Processor Aggregator Device)
[    0.321927] ACPI: Interpreter enabled
[    0.321927] ACPI: Interpreter enabled
[    0.323348] ACPI Exception: AE_NOT_FOUND,=20
[    0.323348] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_]While evaluating Sleep State [\_S1_] (20131218/hwxface-580)
 (20131218/hwxface-580)
[    0.326754] ACPI Exception: AE_NOT_FOUND,=20
[    0.326754] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_]While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
 (20131218/hwxface-580)
[    0.331064] ACPI: (supports S0 S3 S5)
[    0.331064] ACPI: (supports S0 S3 S5)
[    0.332392] ACPI: Using IOAPIC for interrupt routing
[    0.332392] ACPI: Using IOAPIC for interrupt routing
[    0.334299] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.334299] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.361916] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.361916] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.364245] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.364245] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.366361] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.366361] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.369922] PCI host bridge to bus 0000:00
[    0.369922] PCI host bridge to bus 0000:00
[    0.370010] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.370010] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.372320] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.372320] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.374606] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.374606] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.377006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.377006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.380007] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.380007] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.383425] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.383425] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.390979] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.390979] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.395233] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.395233] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.402073] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.402073] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.410485] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.410485] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.413955] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.413955] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.416654] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.416654] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.420285] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.420285] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.429406] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.429406] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.431755] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.431755] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.446163] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.446163] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.451341] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.451341] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.455258] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.455258] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.458773] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.458773] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.466859] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.466859] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.470852] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.470852] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.474312] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.474312] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.478371] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.478371] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.490035] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.490035] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.493713] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.493713] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.497618] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.497618] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.513660] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.513660] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.517515] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.517515] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.520608] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.520608] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.529825] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.529825] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.531316] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.531316] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.534545] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.534545] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.545499] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.545499] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.548995] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.548995] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.551217] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.551217] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.561594] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.561594] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.565284] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.565284] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.568488] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.568488] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.576893] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.576893] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.580353] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.580353] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.588957] ACPI: PCI Interrupt Link [LNKA] (IRQs
[    0.588957] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 5 *10 *10 11 11))

[    0.590973] ACPI: PCI Interrupt Link [LNKB] (IRQs
[    0.590973] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 5 *10 *10 11 11))

[    0.593574] ACPI: PCI Interrupt Link [LNKC] (IRQs
[    0.593574] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 5 10 10 *11 *11))

[    0.596888] ACPI: PCI Interrupt Link [LNKD] (IRQs
[    0.596888] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 5 10 10 *11 *11))

[    0.600711] ACPI: PCI Interrupt Link [LNKS] (IRQs
[    0.600711] ACPI: PCI Interrupt Link [LNKS] (IRQs *9 *9))

[    0.604287] ACPI:=20
[    0.604287] ACPI: Enabled 16 GPEs in block 00 to 0FEnabled 16 GPEs in bl=
ock 00 to 0F

[    0.607721] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.607721] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.610029] vgaarb: loaded
[    0.610029] vgaarb: loaded
[    0.611435] vgaarb: bridge control possible 0000:00:02.0
[    0.611435] vgaarb: bridge control possible 0000:00:02.0
[    0.614260] Linux video capture interface: v2.00
[    0.614260] Linux video capture interface: v2.00
[    0.620199] pps_core: LinuxPPS API ver. 1 registered
[    0.620199] pps_core: LinuxPPS API ver. 1 registered
[    0.622035] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.622035] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.625370] PTP clock support registered
[    0.625370] PTP clock support registered
[    0.626924] EDAC MC: Ver: 3.0.0
[    0.626924] EDAC MC: Ver: 3.0.0
[    0.640443] PCI: Using ACPI for IRQ routing
[    0.640443] PCI: Using ACPI for IRQ routing
[    0.641828] PCI: pci_cache_line_size set to 64 bytes
[    0.641828] PCI: pci_cache_line_size set to 64 bytes
[    0.644083] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.644083] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.646302] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.646302] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.650296] Bluetooth: Core ver 2.18
[    0.650296] Bluetooth: Core ver 2.18
[    0.651728] NET: Registered protocol family 31
[    0.651728] NET: Registered protocol family 31
[    0.653388] Bluetooth: HCI device and connection manager initialized
[    0.653388] Bluetooth: HCI device and connection manager initialized
[    0.655710] Bluetooth: HCI socket layer initialized
[    0.655710] Bluetooth: HCI socket layer initialized
[    0.657558] Bluetooth: L2CAP socket layer initialized
[    0.657558] Bluetooth: L2CAP socket layer initialized
[    0.659518] Bluetooth: SCO socket layer initialized
[    0.659518] Bluetooth: SCO socket layer initialized
[    0.660033] NET: Registered protocol family 8
[    0.660033] NET: Registered protocol family 8
[    0.661702] NET: Registered protocol family 20
[    0.661702] NET: Registered protocol family 20
[    0.663584] nfc: nfc_init: NFC Core ver 0.1
[    0.663584] nfc: nfc_init: NFC Core ver 0.1
[    0.665253] NET: Registered protocol family 39
[    0.665253] NET: Registered protocol family 39
[    0.672028] Switched to clocksource kvm-clock
[    0.672028] Switched to clocksource kvm-clock
[    0.674059] FS-Cache: Loaded
[    0.674059] FS-Cache: Loaded
[    0.675221] pnp: PnP ACPI init
[    0.675221] pnp: PnP ACPI init
[    0.676442] ACPI: bus type PNP registered
[    0.676442] ACPI: bus type PNP registered
[    0.678220] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.678220] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.681452] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.681452] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.683946] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.683946] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.687028] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.687028] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.689452] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.689452] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.692651] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.692651] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.695247] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.695247] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.699569] pnp 00:03: [dma 2]
[    0.699569] pnp 00:03: [dma 2]
[    0.700955] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.700955] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.703600] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.703600] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.707089] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.707089] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.711002] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.711002] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.714113] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.714113] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.717341] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.717341] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.720249] pnp: PnP ACPI: found 7 devices
[    0.720249] pnp: PnP ACPI: found 7 devices
[    0.721754] ACPI: bus type PNP unregistered
[    0.721754] ACPI: bus type PNP unregistered
[    0.730937] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.730937] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.733350] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.733350] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.736362] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.736362] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.738650] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.738650] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.741413] NET: Registered protocol family 2
[    0.741413] NET: Registered protocol family 2
[    0.749165] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    0.749165] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    0.752089] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    0.752089] TCP bind hash table entries: 2048 (order: 5, 163840 bytes)
[    0.754857] TCP: Hash tables configured (established 2048 bind 2048)
[    0.754857] TCP: Hash tables configured (established 2048 bind 2048)
[    0.757852] TCP: reno registered
[    0.757852] TCP: reno registered
[    0.759669] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.759669] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.762343] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.762343] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.765243] NET: Registered protocol family 1
[    0.765243] NET: Registered protocol family 1
[    0.767435] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.767435] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.770682] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.770682] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.772896] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.772896] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.775338] pci 0000:00:02.0: Boot video device
[    0.775338] pci 0000:00:02.0: Boot video device
[    0.777179] PCI: CLS 0 bytes, default 64
[    0.777179] PCI: CLS 0 bytes, default 64
[    0.789474] Unpacking initramfs...
[    0.789474] Unpacking initramfs...
[    0.803796] Initramfs unpacking failed: junk in compressed archive
[    0.803796] Initramfs unpacking failed: junk in compressed archive

BUG: kernel boot hang
Elapsed time: 615
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-s1-01101738/1955a14a5ba6e3c3b11117812d11dc550ccc37ae/vmlinuz-3.13.0-rc7-ne=
xt-20140110-08732-g1955a14 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=
=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 r=
w link=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/next:mas=
ter/.vmlinuz-1955a14a5ba6e3c3b11117812d11dc550ccc37ae-20140110181444-6-xgwo=
 branch=3Dnext/master BOOT_IMAGE=3D/kernel/x86_64-randconfig-s1-01101738/19=
55a14a5ba6e3c3b11117812d11dc550ccc37ae/vmlinuz-3.13.0-rc7-next-20140110-087=
32-g1955a14'  -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz -m 256M =
-smp 2 -net nic,vlan=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::15=
175-:22 -boot order=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltim=
e -drive file=3D/fs/LABEL=3DKVM/disk0-quantal-xgwo-5,media=3Ddisk,if=3Dvirt=
io -drive file=3D/fs/LABEL=3DKVM/disk1-quantal-xgwo-5,media=3Ddisk,if=3Dvir=
tio -drive file=3D/fs/LABEL=3DKVM/disk2-quantal-xgwo-5,media=3Ddisk,if=3Dvi=
rtio -drive file=3D/fs/LABEL=3DKVM/disk3-quantal-xgwo-5,media=3Ddisk,if=3Dv=
irtio -drive file=3D/fs/LABEL=3DKVM/disk4-quantal-xgwo-5,media=3Ddisk,if=3D=
virtio -drive file=3D/fs/LABEL=3DKVM/disk5-quantal-xgwo-5,media=3Ddisk,if=
=3Dvirtio -pidfile /dev/shm/kboot/pid-quantal-xgwo-5 -serial file:/dev/shm/=
kboot/serial-quantal-xgwo-5 -daemonize -display none -monitor null=20

--uZ3hkaAS1mZxFaxD
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="x86_64-randconfig-s1-01101738-1955a14a5ba6e3c3b11117812d11dc550ccc37ae-BUG:-kernel-boot-hang-21372.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDdkZGNkYjJjY2RjYWUwODM4YTM5YjFiZjdiMDc3M2M1NTQwZGE4NDcK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTAxMTAxNzM4L25leHQ6bWFzdGVyOjdkZGNkYjJjY2RjYWUwODM4YTM5YjFiZjdiMDc3M2M1
NTQwZGE4NDc6YmlzZWN0LW1tCgoyMDE0LTAxLTEwLTIwOjE2OjU0IDdkZGNkYjJjY2RjYWUw
ODM4YTM5YjFiZjdiMDc3M2M1NTQwZGE4NDcgY29tcGlsaW5nCjQ4MyByZWFsICAxNTA1IHVz
ZXIgIDE1NCBzeXMgIDM0Mi45OSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTcz
OAoKMjAxNC0wMS0xMC0yMDoyODozNyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAtcmM3
LTA4MzI0LWc3ZGRjZGIyLi4uCTIJNAk3CTgJMTEuLgkxMgkxNC4uLi4uLgkyMAkyNgkyOQk0
MAk0MQk0NQk0Ngk0OAk1Mgk1NAk1Ngk1OAk2MQk2Mi4JNjMJNjQJNjguLgk3MS4uLi4uLi4u
Li4uCTcyCTc0CTc3LiBURVNUIEZBSUxVUkUKL2Jpbi9zaDogL3Byb2Mvc2VsZi9mZC85OiBO
byBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5ClsgICAxNC4xMTYxODRdIHNvY2s6IHByb2Nlc3Mg
YHRyaW5pdHktbWFpbicgaXMgdXNpbmcgb2Jzb2xldGUgc2V0c29ja29wdCBTT19CU0RDT01Q
QVQKWyAgIDE1LjA5NzIzMV0gd2FpdGluZyBtb2R1bGUgcmVtb3ZhbCBub3Qgc3VwcG9ydGVk
OiBwbGVhc2UgdXBncmFkZQpbICAgMTUuNDcxMDc3XSB0cmluaXR5LWMwIGludm9rZWQgb29t
LWtpbGxlcjogZ2ZwX21hc2s9MHgyMDBkYSwgb3JkZXI9MCwgb29tX3Njb3JlX2Fkaj0wClsg
ICAxNS40NzI2MTZdIHRyaW5pdHktYzAgY3B1c2V0PS8gbWVtc19hbGxvd2VkPTAKWyAgIDE1
LjQ3MzQ2NV0gQ1BVOiAwIFBJRDogMjM3NSBDb21tOiB0cmluaXR5LWMwIE5vdCB0YWludGVk
IDMuMTMuMC1yYzctMDgzMjQtZzdkZGNkYjIgIzU5OAoKWyAgIDE1LjQ3NDkwM10gIDAwMDAw
MDAwMDAwMDAwMDAgZmZmZjg4MDAwNjk1ZDhlOCBmZmZmZmZmZjhiODNhZTdkIGZmZmY4ODAw
MGVlY2E2MTAKWyAgIDE1LjQ3NjQwNl0gIGZmZmY4ODAwMDY5NWQ5NzggZmZmZmZmZmY4Yjgz
ODU5NyBmZmZmODgwMDA2OTVkOTE4IDAwMDAwMDAwMDAwMDAwMDIKWyAgIDE1LjQ3NzgxOF0g
IDAwMDAwMDAwMDAwMDAyMDIgZmZmZmZmZmY4YmIyNzU0MCBmZmZmODgwMDA2OTVkOTI4IGZm
ZmZmZmZmOGIyOWRiMWQKWyAgIDE1LjQ3OTIyNl0gQ2FsbCBUcmFjZToKWyAgIDE1LjQ3OTY4
M10gIFs8ZmZmZmZmZmY4YjgzYWU3ZD5dIGR1bXBfc3RhY2srMHg0ZC8weDY2ClsgICAxNS40
ODA2OTZdICBbPGZmZmZmZmZmOGI4Mzg1OTc+XSBkdW1wX2hlYWRlci5pc3JhLjcrMHg3NC8w
eDIyYgpbICAgMTUuNDgxNzczXSAgWzxmZmZmZmZmZjhiMjlkYjFkPl0gPyB0cmFjZV9oYXJk
aXJxc19vbisweGQvMHgxMApbICAgMTUuNDgyODM4XSAgWzxmZmZmZmZmZjhiMmYwNTFmPl0g
b29tX2tpbGxfcHJvY2VzcysweDZmLzB4MzgwClsgICAxNS40ODM4NzRdICBbPGZmZmZmZmZm
OGIyZjBlY2Q+XSBvdXRfb2ZfbWVtb3J5KzB4NGFkLzB4NTIwClsgICAxNS40ODQ4NjJdICBb
PGZmZmZmZmZmOGIyZjZhZjA+XSBfX2FsbG9jX3BhZ2VzX25vZGVtYXNrKzB4N2YwLzB4OTgw
ClsgICAxNS40ODYwMDVdICBbPGZmZmZmZmZmOGIzMjQ1Mjc+XSBhbGxvY19wYWdlc192bWEr
MHgxNTcvMHgxYjAKWyAgIDE1LjQ4NzAzMV0gIFs8ZmZmZmZmZmY4YjJmZmY2YT5dID8gc2ht
ZW1fYWxsb2NfcGFnZSsweDVhLzB4OTAKWyAgIDE1LjQ4ODA2NF0gIFs8ZmZmZmZmZmY4YjJm
ZmY2YT5dIHNobWVtX2FsbG9jX3BhZ2UrMHg1YS8weDkwClsgICAxNS40ODkwNjVdICBbPGZm
ZmZmZmZmOGIyOGMwOTE+XSA/IGxvY2FsX2Nsb2NrKzB4NDEvMHg2MApbICAgMTUuNDkwMTEw
XSAgWzxmZmZmZmZmZjhiMmVkNTM1Pl0gPyBmaW5kX2dldF9wYWdlKzB4MTA1LzB4MTIwClsg
ICAxNS40OTExMzddICBbPGZmZmZmZmZmOGIyZWQ0MzA+XSA/IHVubG9ja19wYWdlKzB4NDAv
MHg0MApbICAgMTUuNDkyMTEyXSAgWzxmZmZmZmZmZjhiMmVkNTZhPl0gPyBmaW5kX2xvY2tf
cGFnZSsweDFhLzB4OTAKWyAgIDE1LjQ5MzE0Ml0gIFs8ZmZmZmZmZmY4YjMwMDFhNz5dIHNo
bWVtX2dldHBhZ2VfZ2ZwKzB4MjA3LzB4NjQwClsgICAxNS40OTQyMDZdICBbPGZmZmZmZmZm
OGIzMDA2MjI+XSBzaG1lbV9mYXVsdCsweDQyLzB4NjAKWyAgIDE1LjQ5NTE0MF0gIFs8ZmZm
ZmZmZmY4YjMwODVhZT5dIF9fZG9fZmF1bHQrMHhiZS8weDU1MApbICAgMTUuNDk1ODA4XSAg
WzxmZmZmZmZmZjhiMjhjMDkxPl0gPyBsb2NhbF9jbG9jaysweDQxLzB4NjAKWyAgIDE1LjQ5
NjM3NV0gIFs8ZmZmZmZmZmY4YjMwYzJlYT5dIGhhbmRsZV9tbV9mYXVsdCsweDUxYS8weDZl
MApbICAgMTUuNDk2OTcyXSAgWzxmZmZmZmZmZjhiMzBhZjVmPl0gPyBmb2xsb3dfcGFnZV9t
YXNrKzB4MjNmLzB4NDAwClsgICAxNS40OTc1ODldICBbPGZmZmZmZmZmOGIzMGM4OGU+XSBf
X2dldF91c2VyX3BhZ2VzKzB4M2RlLzB4NjAwClsgICAxNS40OTgxODNdICBbPGZmZmZmZmZm
OGIzMGVjYjI+XSBfX21sb2NrX3ZtYV9wYWdlc19yYW5nZSsweGIyLzB4YzAKWyAgIDE1LjQ5
ODgzMF0gIFs8ZmZmZmZmZmY4YjMwZjNlMT5dIF9fbW1fcG9wdWxhdGUrMHhmMS8weDE3MApb
ICAgMTUuNDk5NDAzXSAgWzxmZmZmZmZmZjhiMzBmNmVhPl0gU3lTX21sb2NrYWxsKzB4ZWEv
MHgxYjAKWyAgIDE1LjQ5OTk1Nl0gIFs8ZmZmZmZmZmY4Yjg0YTVmOT5dIHN5c3RlbV9jYWxs
X2Zhc3RwYXRoKzB4MTYvMHgxYgpbICAgMTUuNTAwNzc3XSBNZW0tSW5mbzoKWyAgIDE1LjUw
MTE1M10gTm9kZSAwIERNQSBwZXItY3B1OgpbICAgMTUuNTAxNjkyXSBDUFUgICAgMDogaGk6
ICAgIDAsIGJ0Y2g6ICAgMSB1c2Q6ICAgMAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMx
LTAxMTAxNzM4LzdkZGNkYjJjY2RjYWUwODM4YTM5YjFiZjdiMDc3M2M1NTQwZGE4NDcvZG1l
c2cteW9jdG8tcm9hbS0zNToyMDE0MDExMDIwNTUyNTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0w
MTEwMTczODozLjEzLjAtcmM3LTA4MzI0LWc3ZGRjZGIyOjU5OAo3NDoxOjQgYWxsX2dvb2Q6
YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bVJFUEVBVCBDT1VOVDogNzkwICAjIC9jYy93Zmcv
bW0tYmlzZWN0Ly5yZXBlYXQbWzBtCgpiaXNlY3Q6IGJhZCBjb21taXQgN2RkY2RiMmNjZGNh
ZTA4MzhhMzliMWJmN2IwNzczYzU1NDBkYTg0NwpnaXQgY2hlY2tvdXQgdjMuMTIKbHMgLWEg
L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAx
NzM4L25leHQ6bWFzdGVyOjVlMDFkYzdiMjZkOWYyNGYzOWFiYWNlNWRhOThjY2JkNmE1Y2Vi
NTI6YmlzZWN0LW1tCgoyMDE0LTAxLTEwLTIwOjU1OjQzIDVlMDFkYzdiMjZkOWYyNGYzOWFi
YWNlNWRhOThjY2JkNmE1Y2ViNTIgY29tcGlsaW5nCjIwOSByZWFsICAxNTMxIHVzZXIgIDE0
OCBzeXMgIDgwMi4wMCUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOAoKMjAx
NC0wMS0xMC0yMDo1OTozOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEyLjAuLi4JNQkxMAkx
MQkxNgkyMQkyMi4uCTIzLgkyNAkyNQkyNy4JMjgJMjkJMzQJMzYJMzgJMzkJNDkJNTIJNTMJ
NTkuCTYwLgk2OAk3Mgk3NC4uLi4uLgk3Nwk3OQk4MAk4MS4JODcJOTYJOTguLi4uCTk5Li4J
MTAzCTEwOS4uCTExMQkxMTIuCTExNC4uCTExNQkxMTkJMTI1CTEyNy4JMTI4LgkxMjkJMTM0
CTE0MgkxNDMJMTQ0Li4uCTE0NgkxNTEJMTUzCTE1NQkxNjAJMTY1LgkxNjkJMTcwCTE3Nwkx
NzkuCTE4MwkxODUJMTg2LgkxODgJMTkwCTE5MQkxOTQJMTk1CTE5Ny4uCTE5OAkyMDAJMjA1
LgkyMDYuLi4uLi4uLi4uCTIwOAkyMTcuCTIyMS4JMjIyLi4uLgkyMjQJMjI4LgkyMjkuLi4u
LgkyMzEJMjMyCTIzNwkyMzgJMjM5CTI0MC4uCTI0MQkyNDIJMjQ1Li4uLgkyNDYuLi4uLi4J
MjUxCTI1NS4uCTI1OAkyNjIJMjcyLi4JMjc3CTI4MgkyODMuCTI4NC4JMjg1CTI4OAkyOTgJ
MzAzLi4JMzA5CTMxNC4uLi4JMzE1Li4JMzE2CTMxNy4uCTMyMAkzMjIJMzI1CTMyNy4uCTMy
OQkzMzAJMzMyCTMzMwkzMzkJMzQxLgkzNDIJMzQ0LgkzNDUJMzQ2CTM0Ny4JMzQ4LgkzNTAJ
MzU0Li4JMzYwCTM2MQkzNjIuLgkzNjgJMzY5CTM3MAkzNzEuCTM3MgkzNzMJMzc0Li4JMzg1
CTM4OS4uLi4uLi4JMzkxCTM5NS4uCTM5Ni4uCTM5NwkzOTkJNDAxCTQwNgk0MDcuLi4uLgk0
MDgJNDA5CTQxMC4uCTQxNAk0MTguLi4JNDIwLi4uCTQyNC4JNDI1CTQyNwk0MjkuLgk0MzEu
CTQzMy4uCTQzOAk0NDMJNDQ1CTQ1MQk0NTYJNDU5CTQ2MC4uLi4uLgk0NjIJNDYzCTQ2Ngk0
NjkuLi4JNDc0Lgk0NzgJNDgxCTQ4Mwk0OTEJNDk0Lgk0OTcJNDk4Lgk0OTkJNTA3Lgk1MDgJ
NTEwLgk1MTQuCTUxNi4uCTUxNy4uLi4uLgk1MjMuCTUyNQk1MzEJNTM3CTUzOC4uLi4uLi4u
Li4JNTQwLgk1NDMJNTUwCTU1My4uLi4uLi4uLi4uLi4uLi4JNTYwCTU2MS4JNTY0CTU2NQk1
NjcuCTU2OS4JNTcwLgk1NzIJNTczCTU3NAk1NzUJNTc4CTU4Mwk1ODQJNTg1CTU4Nwk1ODgJ
NTg5CTU5My4JNTk1Lgk1OTgJNTk5Li4JNjAxCTYwNwk2MDgJNjE1CTYxNwk2MTkJNjIzLi4J
NjI0CTYyNgk2MjcJNjI4CTYzMAk2MzMuCTYzNC4JNjM5CTY0MAk2NDIJNjQzCTY0NC4JNjQ1
Li4uCTY0Ngk2NTAuCTY1Mwk2NTQJNjU4Lgk2NTkuCTY2Mwk2NjQJNjY2Lgk2NjkJNjcyCTY3
NAk2NzUuCTY3Ni4JNjc4Lgk2NzkuCTY4MQk2ODYJNjkxCTY5Ngk3MDEuCTcwMi4JNzAzLi4u
CTcwNQk3MDYJNzA3CTcwOS4uCTcxMS4JNzEyLgk3MTMJNzE2CTcyMAk3MjUJNzI2CTcyNwk3
MjkJNzMxLgk3MzIJNzM2Li4JNzM4Lgk3NDQJNzQ3Lgk3NTIJNzUzLi4JNzU2CTc1Ny4uLi4u
Lgk3NTgJNzYxLi4uLi4JNzY2Li4uLi4uLi4JNzY3Li4uLgk3NjkuLi4JNzcxLi4uCTc3NAk3
ODAJNzg3CTc4OS4JNzkwIFNVQ0NFU1MKCmJpc2VjdDogZ29vZCBjb21taXQgdjMuMTIKZ2l0
IGJpc2VjdCBzdGFydCA3ZGRjZGIyY2NkY2FlMDgzOGEzOWIxYmY3YjA3NzNjNTU0MGRhODQ3
IHYzLjEyIC0tCi9jL2tlcm5lbC10ZXN0cy9saW5lYXItYmlzZWN0OiBbIi1iIiwgIjdkZGNk
YjJjY2RjYWUwODM4YTM5YjFiZjdiMDc3M2M1NTQwZGE4NDciLCAiLWciLCAidjMuMTIiLCAi
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCIsICIvaG9tZS93
ZmcvbW0vb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogMjEzOTkgcmV2aXNpb25zIGxlZnQgdG8g
dGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDE1IHN0ZXBzKQpbYzUzN2FiYTAwZTNmMWRmOGNl
NmM3YzlmY2I5OGI4MmMwYzJkMWQyY10gTWVyZ2UgZ2l0Oi8vZ2l0Lmt2YWNrLm9yZy9+YmNy
bC9haW8tbmV4dApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4L25leHQ6bWFzdGVy
OmM1MzdhYmEwMGUzZjFkZjhjZTZjN2M5ZmNiOThiODJjMGMyZDFkMmM6YmlzZWN0LW1tCgoy
MDE0LTAxLTExLTAxOjMwOjE4IGM1MzdhYmEwMGUzZjFkZjhjZTZjN2M5ZmNiOThiODJjMGMy
ZDFkMmMgY29tcGlsaW5nCjI3MiByZWFsICAxNTYyIHVzZXIgIDE1MSBzeXMgIDYyOS44NyUg
Y3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOAoKMjAxNC0wMS0xMS0wMTozNTox
OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAtcmMyLTAwMzI0LWdjNTM3YWJhLi4JMQky
CTMuLi4uLgk2Li4JOQkxMC4JMTEJMTMuLgkyMAkyMQkyNwkzNAkzNS4JMzgJNDQJNTEJNTgu
CTYwCTYxLgk2Mwk2NQk2Ny4uCTcwCTc0CTc1Li4uLi4uCTc4CTc5CTgyCTg0Li4uLgk4NS4u
Li4uLi4uCTg3Li4JODkuCTkyCTkzCTk1CTk4Lgk5OQkxMDMJMTA0CTEwNwkxMDguCTExMC4J
MTEzCTExNAkxMTUJMTE2CTExNwkxMTguCTExOQkxMjEuCTEyNAkxMjYuLgkxMzAJMTMxCTEz
MwkxMzUJMTM2LgkxMzkJMTQwLi4JMTQxCTE0MgkxNDMJMTQ1LgkxNDYJMTQ3CTE0OAkxNTAJ
MTUzCTE1NwkxNTkJMTYwCTE2MQkxNjIJMTYzLgkxNjUuCTE2NgkxNjcuLi4uLi4uLi4uLi4u
Li4JMTY4LgkxNjkJMTcwCTE3MS4JMTcyLgkxNzMuCTE3NAkxNzYJMTc4CTE4MAkxODEJMTgy
CTE4NC4uCTE4OQkxOTAuLi4JMTk3CTE5OC4uLi4JMTk5CTIwMAkyMDUuLi4JMjA3CTIwOAky
MTQJMjE1Li4JMjE3CTIyMgkyMjUJMjMwCTIzNAkyMzcJMjQ1CTI0NwkyNTAuLi4uCTI1MQky
NTIJMjU1CTI1OAkyNTkuCTI2NQkyNjYuCTI2Ny4JMjY4Li4uLi4uLi4uLi4uCTI2OS4JMjcw
CTI3NgkyODAJMjgyCTI4My4uLgkyOTAJMjkxLgkyOTMJMjk3LgkyOTgJMzAxLi4uLi4uLi4u
Li4JMzA0CTMwNQkzMDYJMzA3CTMxNC4uLi4uLi4uLi4uLi4uLi4JMzE1LgkzMTcuLgkzMTgJ
MzE5CTMyMS4JMzI0CTMyNS4JMzI2Li4JMzI3Li4uLi4uLgkzMjkJMzMyLi4JMzMzLgkzMzUu
Li4uCTMzNi4JMzM3LgkzNDAuLi4uLgkzNDIJMzQ1LgkzNDgJMzU3CTM1OC4uCTM2MC4JMzYx
CTM2MwkzNjgJMzcxLgkzNzIJMzc2CTM3Ny4JMzgxLi4uCTM4Mi4JMzg0CTM4NS4JMzg3Li4J
Mzg4CTM5My4JMzk2CTQwMS4JNDA0Lgk0MTAJNDEzLi4uCTQyMQk0MjMuLi4uLgk0MjQJNDI1
CTQyOQk0MzEJNDMyLgk0NDQJNDU1CTQ2MAk0NjkJNDc3CTQ4Mi4uLi4uLi4uLi4uCTQ4NAk0
ODYJNDg4Lgk0OTAJNDkzCTQ5OAk1MDIJNTA1CTUwNwk1MDguLi4uLgk1MDkJNTEwCTUxNQk1
MjIJNTIzCTUyNC4JNTI2Li4uLgk1MjcJNTI5CTUzMAk1MzIJNTQyCTU0Ngk1NDcuCTU0OQk1
NTAJNTUzCTU1OAk1NjAJNTYyLgk1NjQJNTY1CTU2Ni4JNTY5CTU3MS4uCTU3NAk1ODgJNTg5
Li4uCTU5Mgk1OTMuLi4uCTU5NC4uCTU5NS4uCTU5OAk2MDAJNjA0CTYxNAk2MTUuLi4uLgk2
MTYuLgk2MTcuLi4uLi4uLi4uLi4JNjIyLgk2MjQuCTYzMQk2MzYJNjM3Li4uLi4JNjQyLgk2
NDQJNjQ1CTY0Ngk2NTAJNjU1CTY1OAk2NjMuCTY2Ngk2NzEuLi4uLi4uCTY3Mwk2NzQJNjc1
Li4JNjc2Li4uCTY3Ny4JNjc4Lgk2ODMJNjg0CTY4NS4uLgk2ODYuLi4uLgk2ODcJNjg5CTY5
NS4JNjk2Li4uLi4uLi4uLi4JNjk3Li4uCTcwMQk3MDQuLgk3MDUuLi4uLgk3MDYJNzA4Li4J
NzA5Li4uLgk3MTIJNzE2CTcxOQk3MjMuLi4JNzI1CTcyNwk3MzMJNzM3Li4uCTczOAk3NDEu
Lgk3NDYuLi4uLi4JNzQ4Lgk3NDkuLgk3NTAJNzUzCTc1NC4JNzU2Lgk3NTkJNzYwLi4JNzYx
CTc2Mgk3NjQuCTc2NS4JNzY4CTc3Mgk3NzcuCTc3OAk3ODAuCTc4MQk3ODIJNzgzCTc4Ni4J
Nzg5Lgk3OTAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA5NDEwIHJldmlzaW9ucyBsZWZ0IHRvIHRl
c3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAxNCBzdGVwcykKW2E3MDcyNzFhODE4MGViNjBlZGMz
YmQ5ZGMzY2I0MjVjNzU0N2ZkNzZdIE1lcmdlIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9z
Y20vbGludXgva2VybmVsL2dpdC9kYXZlbS9uZXQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0Cmxz
IC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
MTEwMTczOC9uZXh0Om1hc3RlcjphNzA3MjcxYTgxODBlYjYwZWRjM2JkOWRjM2NiNDI1Yzc1
NDdmZDc2OmJpc2VjdC1tbQoKMjAxNC0wMS0xMS0wNjo1NTo1NyBhNzA3MjcxYTgxODBlYjYw
ZWRjM2JkOWRjM2NiNDI1Yzc1NDdmZDc2IGNvbXBpbGluZwoyOTggcmVhbCAgMTU0OCB1c2Vy
ICAxNDggc3lzICA1NjkuMzIlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3MzgK
CjIwMTQtMDEtMTEtMDc6MDE6MjIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMy4wLXJjNy0w
MDA1My1nYTcwNzI3MS4uLgkyLi4JNQk2CTgJOS4JMTMJMTQuLgkxNwkxOAkxOQkyMC4JMjEu
Li4JMjcJMjgJMzAJMzIJMzQJMzYuCTM3CTM5Lgk0MAk0Mgk0My4JNDYuCTQ3Lgk0OS4JNTUJ
NTYuCTU3CTU4CTU5Li4JNjAuCTYyLi4JNjYJNjguLgk3MC4uLi4uCTcxCTcyCTc0Li4JNzUu
CTc2CTc3Li4JNzguCTgyCTgzCTg1CTg2Li4uLgk4OS4uLgk5Ni4JMTAwLgkxMDIuCTEwMy4u
Li4JMTA0Li4JMTA2Li4JMTA3CTExNAkxMTcuCTExOAkxMjAuLi4JMTIyCTEyNAkxMjcuCTEz
MS4JMTM3CTEzOQkxNDAJMTQyCTE0MwkxNDUJMTQ5CTE1MwkxNTcJMTYzCTE2Ni4uLi4JMTY4
CTE3MgkxNzUJMTc3CTE4MgkxODkJMTkwCTE5MgkxOTUJMTk5CTIwNAkyMDYJMjA4Li4uCTIx
NgkyMTcJMjE4LgkyMjAuCTIyNAkyMjYuLi4uLi4uLi4uLgkyMjcJMjMzCTIzNC4JMjM1Lgky
MzcJMjM4Li4JMjQyLi4uLi4uLi4uLgkyNDcJMjUzCTI1OS4uCTI2NgkyNjgJMjcxCTI3Mgky
NzQJMjgxCTI4Mi4JMjg0LgkyOTEJMjkyCTI5MwkyOTUuCTI5Ni4JMzA0CTMyMC4JMzI0Li4u
LgkzMjYJMzI3Li4uCTMyOAkzMjkJMzMzLgkzMzQJMzM1CTMzNwkzNDMuLi4JMzQ0CTM0Nwkz
NDgJMzUyCTM1NC4JMzU1Li4uLgkzNTcuLi4uLgkzNTguLgkzNTkJMzYyCTM2OQkzNzYuCTM3
NwkzNzgJMzgwLi4uLi4uLi4JMzgxLgkzODcJMzg5LgkzOTAJMzkxCTM5MgkzOTMuCTM5NQkz
OTYJNDAwCTQwNS4uLi4JNDA2CTQwOAk0MTAuLi4uLi4uLgk0MTEuLi4uCTQxMi4uCTQxMy4u
Li4uCTQxNQk0MTYuCTQxNwk0MTgJNDIxCTQyNQk0MjYuCTQyNwk0MzAJNDM0CTQzNQk0MzYJ
NDM3Lgk0MzkuLi4JNDQwLgk0NDQJNDQ1Li4uCTQ0Ni4JNDQ3CTQ0OQk0NTQJNDU1CTQ1OAk0
NjIJNDY1CTQ2OAk0NjkJNDcyCTQ3OAk0ODMJNDg1Lgk0OTEJNDkyCTQ5Mwk0OTUJNTAyCTUw
Nwk1MTAJNTE5CTU0MQk1NDUJNTQ5CTU1My4uLi4uLi4uCTU1NAk1NTcuLgk1NjcuLi4JNTY4
Li4uCTU3MC4JNTcyCTU3My4uLi4uLi4uCTU3NS4uCTU3Ngk1NzcuLgk1NzkJNTg0CTU4Ni4u
CTU4OC4JNTkzCTYwNS4JNjA3CTYxOS4uLi4JNjIwCTYyMgk2MjUJNjMxLgk2MzIJNjM5CTY1
MC4uLi4uCTY1MS4JNjU1CTY1Nwk2NjcJNjY5CTY3MAk2NzEJNjcyCTY4MAk2ODQJNjg1Li4J
Njg5CTY5NQk2OTYuCTY5OS4uLi4JNzAyCTcwNgk3MDkuLi4uLi4JNzEzCTcxOS4uLi4JNzI1
Li4uLi4uLi4JNzMzCTczNi4JNzM5Li4uLgk3NDEuCTc0Mi4JNzQzLi4uLgk3NDYJNzQ4Lgk3
NTEuCTc1Mgk3NTYuCTc1Nwk3NjAJNzYzCTc2OAk3NzAuCTc3MS4JNzc0CTc3Ngk3ODUJNzg2
CTc4OC4JNzkwIFNVQ0NFU1MKCkJpc2VjdGluZzogODI3MSByZXZpc2lvbnMgbGVmdCB0byB0
ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTQgc3RlcHMpCltlMGU4ZmMzMTQ4ZTBlMTQyMDc5
NjExZjgyMDg5MjU4ZmIzYjQ2ZjAwXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICd0
aGVybWFsL25leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3Qt
ZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3Rz
L3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3MzgvbmV4dDptYXN0
ZXI6ZTBlOGZjMzE0OGUwZTE0MjA3OTYxMWY4MjA4OTI1OGZiM2I0NmYwMDpiaXNlY3QtbW0K
CjIwMTQtMDEtMTEtMTE6MjY6MzMgZTBlOGZjMzE0OGUwZTE0MjA3OTYxMWY4MjA4OTI1OGZi
M2I0NmYwMCBjb21waWxpbmcKMjk0IHJlYWwgIDE1MDggdXNlciAgMTQ5IHN5cyAgNTYyLjMy
JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4CgoyMDE0LTAxLTExLTExOjMy
OjA3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTMuMC1yYzctMDI3NzItZ2UwZThmYzMuLgkx
CTIuLi4JNwk4CTE2CTE4CTIyCTIzCTI4CTMwCTMxCTMyLi4JMzQuLi4uLgkzNQkzNgkzOC4J
MzkJNDAuLgk0MS4JNDMuLgk1Mwk1OAk2NAk2OQk3Mgk3Mwk3NQk3OC4uLgk3OS4JODIJODUJ
ODYJODkJOTAJOTIuCTkzLgk5NAk5Nwk5OC4JOTkuLgkxMDQJMTA1CTEwOAkxMTEJMTEzCTEx
Ny4JMTIwCTEyMi4uLi4JMTIzCTEyNQkxMjYJMTI4Li4JMTMwCTEzMQkxMzMJMTM0LgkxMzUJ
MTM2Li4JMTM5LgkxNDYuLgkxNDcuCTE0OQkxNTAJMTUxCTE1MgkxNTYJMTYxCTE2OAkxNzEu
CTE3NS4uLgkxNzYuCTE3OC4JMTgwCTE4My4uLi4uLi4uLgkxODUuLgkxODguLgkxODkJMTky
CTE5NC4JMTk1Li4uCTE5Ny4JMTk4CTIwMwkyMDgJMjA5CTIxMgkyMjAJMjI3CTIzMAkyMzEu
LgkyMzIJMjMzLi4JMjM2LgkyMzkuCTI0MQkyNDIJMjQzLi4uLgkyNDQJMjQ1CTI0Ni4uCTI0
NwkyNDguLi4uLi4JMjUxLgkyNTYJMjY0Li4uLi4JMjY1LgkyNjYJMjcyCTI3My4JMjc0CTI3
NQkyNzkJMjgxCTI4NAkyODUJMjkwCTI5Mi4JMjkzCTI5NgkyOTcuLgkyOTguLgkzMDAJMzAy
CTMwMwkzMDQuCTMwNy4JMzA4CTMxMAkzMTYJMzIwCTMyMQkzMjMuCTMyNS4uLgkzMjcJMzI4
LgkzMzAJMzM0CTMzNS4uLgkzMzcJMzQwCTM0MwkzNDYJMzQ3CTM0OAkzNDkJMzUxLgkzNTIJ
MzU1Li4uLi4uLi4uLi4uCTM1Ni4uLi4uLgkzNTcJMzU5LgkzNjIuLgkzNjMuLi4JMzY2CTM3
MAkzNzUuCTM3NgkzNzgJMzc5CTM4MgkzODQJMzg1LgkzODYuCTM4NwkzODkJMzkwLi4JMzk0
CTM5NQkzOTcJMzk4Lgk0MDEuLi4uLgk0MDUJNDA2CTQwNwk0MTEJNDEyLi4JNDE0CTQxNQk0
MTYJNDE4Lgk0MjMJNDM4CTQ0MAk0NDIuLi4JNDQzLi4uLgk0NDQJNDQ5CTQ1MAk0NTEJNDUy
CTQ1Mwk0NTQJNDU1Li4uLgk0NTcJNDU4CTQ1OQk0NjEuLgk0NjYJNDcwCTQ3MS4uCTQ3Mi4J
NDgwCTQ4MS4JNDgyLi4JNDg0CTQ4NQk0OTAJNDk5Lgk1MDAuCTUwMQk1MDIuLi4uLi4uLgk1
MTIJNTEzLi4JNTE0Lgk1MjYJNTMxLi4uLi4JNTMyCTUzMwk1MzkJNTQ0CTU1NAk1NjYJNTcy
Lgk1NzUJNTc2CTU3OAk1ODEJNTg2CTU5MQk1OTYJNTk5CTYwMAk2MDMuCTYwNAk2MDUuLi4u
Li4uLi4uLi4uLi4uCTYwNgk2MTEJNjEzLi4JNjE0CTYxNi4uCTYyMwk2MjcJNjI4Lgk2MzIu
Li4uCTYzMy4uLi4JNjM0Li4JNjM3Lgk2MzkJNjQwLi4uLi4uLi4uLi4uLi4uCTY0NC4uLi4J
NjQ2Li4JNjQ3CTY0OAk2NTIJNjUzLi4uLi4uLi4JNjU1CTY2MQk2NjIJNjY4CTY2OQk2NzIu
Lgk2NzUJNjc4CTY3OQk2ODAJNjgxLi4JNjgyCTY5MAk2OTEJNjk1Li4uLi4JNjk3Lgk2OTgu
Li4uCTY5OS4uCTcwMC4JNzAyLi4uLgk3MDQJNzA3CTcwOQk3MTQuCTcxNS4uCTcxNy4JNzE5
CTcyMQk3MjQJNzI2CTcyOC4uLi4uLi4uLgk3MzEJNzM1CTc0MS4uCTc0Mi4uCTc0Ni4JNzQ4
CTc0OQk3NTEuCTc1Mi4JNzU2CTc1OAk3NTkJNzYwLi4JNzY1Li4JNzY3CTc2OAk3NjkJNzcw
Li4JNzcyCTc3NQk3NzgJNzgxCTc4Mwk3ODkJNzkwIFNVQ0NFU1MKCkJpc2VjdGluZzogNTU1
MiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTMgc3RlcHMp
CltmN2Y0ODNiN2M2NDY5NWFmMDVlMWNlNThjYzIzMDAxNjMxMjgxZmU0XSBNZXJnZSByZW1v
dGUtdHJhY2tpbmcgYnJhbmNoICd2ZmlvL25leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdAps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEt
MDExMDE3MzgvbmV4dDptYXN0ZXI6ZjdmNDgzYjdjNjQ2OTVhZjA1ZTFjZTU4Y2MyMzAwMTYz
MTI4MWZlNDpiaXNlY3QtbW0KCjIwMTQtMDEtMTEtMTY6MzM6NDcgZjdmNDgzYjdjNjQ2OTVh
ZjA1ZTFjZTU4Y2MyMzAwMTYzMTI4MWZlNCBjb21waWxpbmcKMzU0IHJlYWwgIDE1MjIgdXNl
ciAgMTQ4IHN5cyAgNDcxLjM4JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4
CgoyMDE0LTAxLTExLTE2OjQwOjIxIGRldGVjdGluZyBib290IHN0YXRlIDMuMTMuMC1yYzct
MDU3MzEtZ2Y3ZjQ4M2IuLi4uLgkxCTIuCTUJOQkxMQkxNS4uCTE2Li4uCTIyCTMzLgkzNC4J
MzUuLi4uLi4uCTM2Li4JMzgJNDEuCTQyLgk0Ngk1MQk1Mwk1NS4uLgk1Ni4JNTcJNjIJNjQJ
NjUJNjgJNzIJNzMuLgk3OAk3OQk4MC4JODIJODMuLi4uLi4uLi4JODUJODcJODgJOTAuCTkz
CTEwMgkxMDYuCTExNC4JMTE1CTExNi4JMTE3CTExOQkxMjAJMTIxCTEyOAkxMzAJMTMyCTE0
MAkxNDEJMTQzLgkxNDQJMTQ2CTE0OAkxNDkuLi4uLgkxNTIJMTYwCTE2MQkxNjIuLi4uLi4J
MTY5CTE3MgkxODMuCTE4NQkxODYuLi4uCTE5MwkxOTUJMTk2CTE5OAkxOTkuCTIwMQkyMDIu
LgkyMDMJMjExLgkyMTIJMjEzCTIxOC4uLi4uCTIyMQkyMjIJMjIzCTIyNC4JMjI2CTIyNwky
MjgJMjI5CTI0MS4uLgkyNDYJMjQ4CTI1MS4JMjUzCTI1OAkyNjAJMjY0CTI2OQkyNzEuLgky
NzIJMjczLi4JMjc4CTI4NAkyODUuCTI4NwkyOTAJMjkyCTI5My4uCTI5NS4uCTI5OQkzMDAu
LgkzMDEuCTMwMgkzMDQJMzA1LgkzMDYJMzExCTMyMAkzMjQJMzI5CTMzMC4uLi4JMzMxCTMz
Mi4JMzQ0Li4uLi4uLgkzNDUJMzQ2CTM0OAkzNTEJMzU5CTM2MC4uCTM2MQkzNjQJMzY2Lgkz
NzIJMzc1LgkzNzguLi4uCTM3OQkzODIuCTM4MwkzODYJMzkxCTM5OQk0MDMJNDA0CTQwNi4J
NDA4CTQxMy4JNDE3Li4uLi4JNDE4Li4JNDIwCTQyMwk0MjQuLi4uLgk0MjUJNDM2CTQ0Mgk0
NDQuLgk0NDUuCTQ0Nwk0NDkuLi4JNDUwCTQ1MQk0NTcuCTQ1OQk0NjAJNDYxLgk0NjIuLi4u
Lgk0NjMJNDY0CTQ2NS4JNDY3CTQ3MQk0NzMuLgk0NzYJNDc3CTQ3OQk0ODQJNDg1CTQ5MC4u
CTQ5MS4uCTQ5Mi4uLi4uLi4uLi4uLi4uLi4uLgk0OTMJNTAwCTUwMS4JNTAyLi4uLi4uLi4u
Li4JNTA2Lgk1MjMJNTI2Lgk1MjcuLi4JNTI4CTUzMAk1MzYJNTQyLgk1NDMJNTQ2Li4JNTQ5
CTU1Mi4JNTYxCTU2OS4uCTU3MQk1NzcJNTc4CTU3OS4uLgk1ODAJNTgyCTU4NS4uCTU4Ngk1
ODcJNTkwCTU5MS4uLi4uCTU5Nwk1OTkJNjA2Lgk2MTEJNjEyLi4JNjE0Lgk2MTgJNjE5CTYy
MAk2MjEuLgk2MjYJNjI5Lgk2MzAuCTYzMwk2MzQuLi4uLgk2MzYJNjM5CTY0MAk2NDIJNjQ1
CTY0OC4uCTY1MQk2NTUJNjU5CTY2MAk2NjEJNjYzLi4JNjY2CTY2OC4JNjcwLi4uCTY3Mi4J
NjczCTY3NAk2NzUuCTY3OC4uCTY4MAk2ODMJNjg1CTY4Nwk2ODkuLgk2OTEJNjkyCTY5NAk2
OTcJNjk4CTY5OQk3MDIuLi4JNzA0CTcwNgk3MTAJNzExLi4uCTcxMgk3MTMuCTcxNgk3MTgJ
NzIwLgk3MjEJNzI0CTczMi4uLgk3MzMJNzM0Li4JNzM1CTczNy4JNzQwLi4uCTc0Mgk3NDYJ
NzQ3CTc1NQk3NTYJNzU4CTc2MC4uLi4JNzYxCTc2Mwk3NjQJNzY2CTc2OAk3NjkuCTc3Mgk3
NzMJNzc1CTc3Ngk3NzcJNzc4CTc4OAk3ODkJNzkwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjU5
MyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTIgc3RlcHMp
ClsxOWVlZTdhNDAxYjRhMjMxNmYxZWJjZGM3ZTY2YjQ0ZDZkN2VhOTYzXSBNZXJnZSByZW1v
dGUtdHJhY2tpbmcgYnJhbmNoICdsZWRzL2Zvci1uZXh0JwpydW5uaW5nIC9jL2tlcm5lbC10
ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNl
Y3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmln
LXMxLTAxMTAxNzM4L25leHQ6bWFzdGVyOjE5ZWVlN2E0MDFiNGEyMzE2ZjFlYmNkYzdlNjZi
NDRkNmQ3ZWE5NjM6YmlzZWN0LW1tCgoyMDE0LTAxLTExLTIxOjA4OjIxIDE5ZWVlN2E0MDFi
NGEyMzE2ZjFlYmNkYzdlNjZiNDRkNmQ3ZWE5NjMgY29tcGlsaW5nCjM1MCByZWFsICAxNTA0
IHVzZXIgIDE1OCBzeXMgIDQ3NC44NSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEw
MTczOAoKMjAxNC0wMS0xMS0yMToyMTo0NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAt
cmM3LTA2NDIwLWcxOWVlZTdhLi4JMS4uCTIuLgk0Lgk2CTguLgk5CTEzCTE2CTE3CTE4CTE5
CTIwCTI0CTI2CTI3LgkyOC4uCTMyLgkzNAkzNS4uCTM2IFRFU1QgRkFJTFVSRQpbICAgIDAu
NDAxNzUzXSBJbml0cmFtZnMgdW5wYWNraW5nIGZhaWxlZDoganVuayBpbiBjb21wcmVzc2Vk
IGFyY2hpdmUKWyAgICAwLjQwMTc1M10gSW5pdHJhbWZzIHVucGFja2luZyBmYWlsZWQ6IGp1
bmsgaW4gY29tcHJlc3NlZCBhcmNoaXZlCgpCVUc6IGtlcm5lbCBib290IGhhbmcKRWxhcHNl
ZCB0aW1lOiA2MTAKcWVtdS1zeXN0ZW0teDg2XzY0IC1jcHUga3ZtNjQgLWVuYWJsZS1rdm0g
LWtlcm5lbCAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4LzE5ZWVlN2E0
MDFiNGEyMzE2ZjFlYmNkYzdlNjZiNDRkNmQ3ZWE5NjMvdm1saW51ei0zLjEzLjAtcmM3LTA2
NDIwLWcxOWVlZTdhIC1hcHBlbmQgJ2h1bmdfdGFza19wYW5pYz0xIGVhcmx5cHJpbnRrPXR0
eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRlYnVnIHN5c3JxX2Fsd2F5c19lbmFibGVkIHBhbmlj
PTEwICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5
MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rZXJuZWwtdGVzdHMvcnVu
LXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOC9uZXh0Om1hc3Rlcjox
OWVlZTdhNDAxYjRhMjMxNmYxZWJjZGM3ZTY2YjQ0ZDZkN2VhOTYzOmJpc2VjdC1tbS8udm1s
aW51ei0xOWVlZTdhNDAxYjRhMjMxNmYxZWJjZGM3ZTY2YjQ0ZDZkN2VhOTYzLTIwMTQwMTEx
MjEyMTM4LTExNC1hdGhlbnMgYnJhbmNoPW5leHQvbWFzdGVyIEJPT1RfSU1BR0U9L2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOC8xOWVlZTdhNDAxYjRhMjMxNmYxZWJj
ZGM3ZTY2YjQ0ZDZkN2VhOTYzL3ZtbGludXotMy4xMy4wLXJjNy0wNjQyMC1nMTllZWU3YScg
IC1pbml0cmQgL2tlcm5lbC10ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3JlLXg4Nl82NC5jZ3og
LW0gMjU2TSAtc21wIDIgLW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2
bGFuPTEsaG9zdGZ3ZD10Y3A6OjE0MTQ0LToyMiAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290
IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1kcml2ZSBmaWxlPS9m
cy9MQUJFTD1LVk0vZGlzazAtcXVhbnRhbC1hdGhlbnMtMzYsbWVkaWE9ZGlzayxpZj12aXJ0
aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrMS1xdWFudGFsLWF0aGVucy0zNixt
ZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2syLXF1
YW50YWwtYXRoZW5zLTM2LG1lZGlhPWRpc2ssaWY9dmlydGlvIC1kcml2ZSBmaWxlPS9mcy9M
QUJFTD1LVk0vZGlzazMtcXVhbnRhbC1hdGhlbnMtMzYsbWVkaWE9ZGlzayxpZj12aXJ0aW8g
LWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrNC1xdWFudGFsLWF0aGVucy0zNixtZWRp
YT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2s1LXF1YW50
YWwtYXRoZW5zLTM2LG1lZGlhPWRpc2ssaWY9dmlydGlvIC1waWRmaWxlIC9kZXYvc2htL2ti
b290L3BpZC1xdWFudGFsLWF0aGVucy0zNiAtc2VyaWFsIGZpbGU6L2Rldi9zaG0va2Jvb3Qv
c2VyaWFsLXF1YW50YWwtYXRoZW5zLTM2IC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9u
aXRvciBudWxsIAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4LzE5ZWVl
N2E0MDFiNGEyMzE2ZjFlYmNkYzdlNjZiNDRkNmQ3ZWE5NjMvZG1lc2ctcXVhbnRhbC1hdGhl
bnMtMzY6MjAxNDAxMTEyMTM5MDc6eDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3Mzg6My4x
My4wLXJjNy0wNjQyMC1nMTllZWU3YTo2MDQKMzY6MToxIGFsbF9nb29kOmJhZDphbGxfYmFk
IGJvb3RzCgpCaXNlY3Rpbmc6IDY4OSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRo
aXMgKHJvdWdobHkgMTAgc3RlcHMpClthYTNhOTExY2NmMDEwOTlmMTQ2Y2RhMDE3OTNiYWQw
M2Q5NzBiYzBmXSBNZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdlZGFjLWFtZC9mb3It
bmV4dCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1
ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOC9uZXh0Om1hc3RlcjphYTNh
OTExY2NmMDEwOTlmMTQ2Y2RhMDE3OTNiYWQwM2Q5NzBiYzBmOmJpc2VjdC1tbQoKMjAxNC0w
MS0xMS0yMTozOToyMiBhYTNhOTExY2NmMDEwOTlmMTQ2Y2RhMDE3OTNiYWQwM2Q5NzBiYzBm
IGNvbXBpbGluZwoyMjEgcmVhbCAgMjYzIHVzZXIgIDMzIHN5cyAgMTMzLjUxJSBjcHUgCXg4
Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4CgoyMDE0LTAxLTExLTIxOjQ0OjU3IGRldGVj
dGluZyBib290IHN0YXRlIDMuMTMuMC1yYzctMDYyNzYtZ2FhM2E5MTEuLi4uCTUJMTEJMTUJ
MjAuCTIzLgkyNwkzNAkzNgkzOQk0MS4JNDQJNDUJNDYJNDcJNTAuCTU0IFRFU1QgRkFJTFVS
RQpbICAgIDAuNzU0OTAxXSBJbml0cmFtZnMgdW5wYWNraW5nIGZhaWxlZDoganVuayBpbiBj
b21wcmVzc2VkIGFyY2hpdmUKWyAgICAwLjc1NDkwMV0gSW5pdHJhbWZzIHVucGFja2luZyBm
YWlsZWQ6IGp1bmsgaW4gY29tcHJlc3NlZCBhcmNoaXZlCgpCVUc6IGtlcm5lbCBib290IGhh
bmcKRWxhcHNlZCB0aW1lOiA2MTAKcWVtdS1zeXN0ZW0teDg2XzY0IC1jcHUga3ZtNjQgLWVu
YWJsZS1rdm0gLWtlcm5lbCAva2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4
L2FhM2E5MTFjY2YwMTA5OWYxNDZjZGEwMTc5M2JhZDAzZDk3MGJjMGYvdm1saW51ei0zLjEz
LjAtcmM3LTA2Mjc2LWdhYTNhOTExIC1hcHBlbmQgJ2h1bmdfdGFza19wYW5pYz0xIGVhcmx5
cHJpbnRrPXR0eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRlYnVnIHN5c3JxX2Fsd2F5c19lbmFi
bGVkIHBhbmljPTEwICBwcm9tcHRfcmFtZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNv
bnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290PS9kZXYvcmFtMCBydyBsaW5rPS9rZXJuZWwt
dGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOC9uZXh0
Om1hc3RlcjphYTNhOTExY2NmMDEwOTlmMTQ2Y2RhMDE3OTNiYWQwM2Q5NzBiYzBmOmJpc2Vj
dC1tbS8udm1saW51ei1hYTNhOTExY2NmMDEwOTlmMTQ2Y2RhMDE3OTNiYWQwM2Q5NzBiYzBm
LTIwMTQwMTExMjE0NDQ5LTEwMS1zbmIgYnJhbmNoPW5leHQvbWFzdGVyIEJPT1RfSU1BR0U9
L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOC9hYTNhOTExY2NmMDEwOTlm
MTQ2Y2RhMDE3OTNiYWQwM2Q5NzBiYzBmL3ZtbGludXotMy4xMy4wLXJjNy0wNjI3Ni1nYWEz
YTkxMScgIC1pbml0cmQgL2tlcm5lbC10ZXN0cy9pbml0cmQveW9jdG8tbWluaW1hbC14ODZf
NjQuY2d6IC1tIDI1Nk0gLXNtcCAyIC1uZXQgbmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0
IHVzZXIsdmxhbj0xLGhvc3Rmd2Q9dGNwOjoxODA5Mi06MjIgLWJvb3Qgb3JkZXI9bmMgLW5v
LXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBlc2IgLXJ0YyBiYXNlPWxvY2FsdGltZSAtZHJpdmUg
ZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2swLXlvY3RvLXNuYi04LG1lZGlhPWRpc2ssaWY9dmly
dGlvIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazEteW9jdG8tc25iLTgsbWVkaWE9
ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrMi15b2N0by1z
bmItOCxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rp
c2szLXlvY3RvLXNuYi04LG1lZGlhPWRpc2ssaWY9dmlydGlvIC1kcml2ZSBmaWxlPS9mcy9M
QUJFTD1LVk0vZGlzazQteW9jdG8tc25iLTgsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZl
IGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrNS15b2N0by1zbmItOCxtZWRpYT1kaXNrLGlmPXZp
cnRpbyAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQteW9jdG8tc25iLTggLXNlcmlhbCBm
aWxlOi9kZXYvc2htL2tib290L3NlcmlhbC15b2N0by1zbmItOCAtZGFlbW9uaXplIC1kaXNw
bGF5IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
MTEwMTczOC9hYTNhOTExY2NmMDEwOTlmMTQ2Y2RhMDE3OTNiYWQwM2Q5NzBiYzBmL2RtZXNn
LXlvY3RvLXNuYi04OjIwMTQwMTExMjE1NjEzOng4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAx
NzM4OjMuMTMuMC1yYzctMDYyNzYtZ2FhM2E5MTE6NjA1CjU0OjE6MSBhbGxfZ29vZDpiYWQ6
YWxsX2JhZCBib290cwoKQmlzZWN0aW5nOiA1NDUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDEwIHN0ZXBzKQpbYTExYWNiYmVkMWJmMmZkMzIwNDAyN2Qy
YjJhYzYyNDZkYWYxNDQ0NV0gTWVyZ2UgcmVtb3RlLXRyYWNraW5nIGJyYW5jaCAnZHQtcmgv
Zm9yLW5leHQnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFp
bHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1
bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3MzgvbmV4dDptYXN0ZXI6
YTExYWNiYmVkMWJmMmZkMzIwNDAyN2QyYjJhYzYyNDZkYWYxNDQ0NTpiaXNlY3QtbW0KCjIw
MTQtMDEtMTEtMjE6NTc6MDAgYTExYWNiYmVkMWJmMmZkMzIwNDAyN2QyYjJhYzYyNDZkYWYx
NDQ0NSBjb21waWxpbmcKMjA2IHJlYWwgIDE1OTYgdXNlciAgMTU0IHN5cyAgODQ4LjQzJSBj
cHUgCXg4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4CgoyMDE0LTAxLTExLTIyOjAxOjUy
IGRldGVjdGluZyBib290IHN0YXRlIDMuMTMuMC1yYzctMDU3NzItZ2ExMWFjYmIuLgkxCTIJ
Mwk0Li4uCTUJNwkxMwkxOC4JMzEJMzMJMzgJNDEuLi4JNDIuLi4JNDMJNDYJNDkJNTMJNTQJ
NTYuCTU3CTY1CTY3CTc1CTc5CTgwCTgxCTkyCTk0CTk4CTEwMAkxMDMJMTA0LgkxMTAJMTE2
CTExOC4JMTI0Li4uCTEyNQkxMzIJMTM3CTEzOQkxNDIJMTQ2CTE1MAkxNTMJMTU1CTE3MQkx
NzcJMTg0CTE4NgkxODcJMTg5CTE5OAkyMDIJMjA0LgkyMDgJMjA5CTIxNQkyMTcJMjE4CTIy
My4JMjI2LgkyMzEJMjMyCTIzMwkyMzYJMjQxLi4uCTI0NAkyNTUJMjYxCTI2OAkyNzUJMjgz
Li4JMjg1CTI5MgkyOTQJMjk2CTMwMgkzMDcJMzA5LgkzMTAuLi4uLi4uLgkzMTUJMzE4Li4u
Li4JMzIzCTMzMAkzMzcJMzM4CTM0MQkzNTEuLgkzNTIJMzU2LgkzNTcJMzYyCTM2My4uLi4u
CTM2OAkzNjkJMzc4CTM4NS4JMzg5LgkzOTAuLi4uCTM5Mgk0MDQJNDA1CTQxMgk0MTMJNDE3
CTQxOC4JNDE5Lgk0MjMJNDMwCTQzOS4JNDQwLi4JNDQ0Lgk0NDkJNDUwCTQ1Mi4JNDUzCTQ1
NC4JNDU3CTQ2Ngk0NzMJNDc3CTQ3OC4uLi4JNDc5Lgk0ODUJNDkxCTQ5OQk1MDcJNTE1Li4J
NTE2Li4JNTIxCTUyMwk1MjQJNTI2CTUyNwk1MjkuCTUzMC4JNTMyCTUzMwk1MzkJNTQxCTU0
NAk1NTEJNTUzLi4uLi4JNTU1CTU1Nwk1NjAJNTYyLi4JNTY0CTU2NQk1NjkJNTc0CTU3Ny4J
NTg0CTU4OS4uLi4uLi4uLi4uCTYwNAk2MDkJNjEwCTYxMwk2MTgJNjI0Lgk2MjYJNjI3CTYy
OAk2MjkJNjMxCTYzOAk2NDEJNjQ4CTY1NQk2NjAJNjYyCTY3Mgk2NzQJNjc1Li4JNjgwCTY4
OQk2OTQJNjk4CTcwOAk3MTEuCTcxNQk3MjIJNzMxCTczOQk3NDUJNzQ5CTc1Mgk3NjIJNzY1
CTc3OAk3ODQJNzg5CTc5MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDUwNCByZXZpc2lvbnMgbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgOSBzdGVwcykKW2I4MDU3MzY4ZDZjMjlk
YjUzOGZmMjU5MjY2YTQzNzUyMDBjM2QwMjldIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFu
Y2ggJ3RpcC9hdXRvLWxhdGVzdCcKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRl
c3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOC9u
ZXh0Om1hc3RlcjpiODA1NzM2OGQ2YzI5ZGI1MzhmZjI1OTI2NmE0Mzc1MjAwYzNkMDI5OmJp
c2VjdC1tbQoKMjAxNC0wMS0xMi0wMDoyNzoyMSBiODA1NzM2OGQ2YzI5ZGI1MzhmZjI1OTI2
NmE0Mzc1MjAwYzNkMDI5IGNvbXBpbGluZwoxMjEzIHJlYWwgIDE0OTIgdXNlciAgMTQ2IHN5
cyAgMTM1LjA2JSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4CgoyMDE0LTAx
LTEyLTAwOjU2OjMzIGRldGVjdGluZyBib290IHN0YXRlIDMuMTMuMC1yYzctMDYyNDUtZ2I4
MDU3MzYuLgkyLi4JNi4uLgkxMwkxOQkyMi4JMjQJMzAJMzQJMzUJNDAJNDEJNTMJNTcJNjEJ
NjIJNjMJNjQJNjYgVEVTVCBGQUlMVVJFClsgICAyMC4zMzY4MTddIHNvY2s6IHByb2Nlc3Mg
YHRyaW5pdHktbWFpbicgaXMgdXNpbmcgb2Jzb2xldGUgc2V0c29ja29wdCBTT19CU0RDT01Q
QVQKWyAgIDIyLjU4Njg1N10gaHJ0aW1lcjogaW50ZXJydXB0IHRvb2sgMjMwMjggbnMKWyAg
IDI4LjgxNzI1NF0gdm1hbGxvYzogYWxsb2NhdGlvbiBmYWlsdXJlOiAxODQ0Njc0NDA3MTcz
MjAwNDEzMyBieXRlcwpbICAgMjguODE4NDg3XSB0cmluaXR5LWMwOiBwYWdlIGFsbG9jYXRp
b24gZmFpbHVyZTogb3JkZXI6MCwgbW9kZToweGQyClsgICAyOC44MzM4NTddIENQVTogMCBQ
SUQ6IDIzMjIgQ29tbTogdHJpbml0eS1jMCBOb3QgdGFpbnRlZCAzLjEzLjAtcmM3LTA2MjQ1
LWdiODA1NzM2ICM2MDcKWyAgIDI4LjgzNTM2M10gIGZmZmZmZmZmOGFjMmVhZTggZmZmZjg4
MDAwZWVmN2RkMCBmZmZmZmZmZjhhYTNhOTJkIDAwMDAwMDAwMDAwMDAwZDIKWyAgIDI4Ljgz
NjgxN10gIGZmZmY4ODAwMGVlZjdlNTggZmZmZmZmZmY4YTRmMmIyMiBmZmZmZmZmZjhhYzJl
YWU4IGZmZmY4ODAwMGVlZjdkZjAKWyAgIDI4Ljg3OTMxMl0gIGZmZmZmZmZmMDAwMDAwMTgg
ZmZmZjg4MDAwZWVmN2U2OCBmZmZmODgwMDBlZWY3ZTA4IDAwMDAwMDAwMDAwMDAwMDAKWyAg
IDI4Ljg4MDcwOV0gQ2FsbCBUcmFjZToKWyAgIDI4Ljg4MTE2N10gIFs8ZmZmZmZmZmY4YWEz
YTkyZD5dIGR1bXBfc3RhY2srMHg0ZC8weDY2ClsgICAyOC45MDYyMDNdICBbPGZmZmZmZmZm
OGE0ZjJiMjI+XSB3YXJuX2FsbG9jX2ZhaWxlZCsweDExMi8weDEzMApbICAgMjguOTA3MjE0
XSAgWzxmZmZmZmZmZjhhNDhjMGU4Pl0gPyBzY2hlZF9jbG9ja19jcHUrMHhkOC8weGYwClsg
ICAyOC45MDgyNzNdICBbPGZmZmZmZmZmOGE1MWE5YzY+XSBfX3ZtYWxsb2Nfbm9kZV9yYW5n
ZSsweDI1Ni8weDI3MApbICAgMjguOTI5NTAwXSAgWzxmZmZmZmZmZjhhNTFhYzM2Pl0gdm1h
bGxvYysweDQ2LzB4NTAKWyAgIDI4LjkzMDM5NF0gIFs8ZmZmZmZmZmY4YTRjN2E4MD5dID8g
U3lTX2luaXRfbW9kdWxlKzB4NTAvMHhjMApbICAgMjguOTMxNDUxXSAgWzxmZmZmZmZmZjhh
NGM3YTgwPl0gU3lTX2luaXRfbW9kdWxlKzB4NTAvMHhjMApbICAgMjguOTMyNDY2XSAgWzxm
ZmZmZmZmZjhhYTRhMGI5Pl0gc3lzdGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8weDFiClsgICAy
OC45NTI2ODNdIE1lbS1JbmZvOgpbICAgMjguOTUzMTM2XSBOb2RlIDAgRE1BIHBlci1jcHU6
ClsgICAyOC45NTM3NDldIENQVSAgICAwOiBoaTogICAgMCwgYnRjaDogICAxIHVzZDogICAw
Ci9rZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3MzgvYjgwNTczNjhkNmMyOWRi
NTM4ZmYyNTkyNjZhNDM3NTIwMGMzZDAyOS9kbWVzZy15b2N0by1zdG9ha2xleS00OjIwMTQw
MTEyMDEwOTAwOng4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4OjMuMTMuMC1yYzctMDYy
NDUtZ2I4MDU3MzY6NjA3CjY0OjE6MyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoKQmlz
ZWN0aW5nOiA0NzMgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDkgc3RlcHMpCls1OTI0MTBiMWJhOWRhZjYxYzNiZGU5Mjc2MmE0M2VhYzU4MDAwODUwXSBN
ZXJnZSByZW1vdGUtdHJhY2tpbmcgYnJhbmNoICdzcGkvZm9yLW5leHQnCnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0v
b2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJh
bmRjb25maWctczEtMDExMDE3MzgvbmV4dDptYXN0ZXI6NTkyNDEwYjFiYTlkYWY2MWMzYmRl
OTI3NjJhNDNlYWM1ODAwMDg1MDpiaXNlY3QtbW0KCjIwMTQtMDEtMTItMDE6MDk6MzkgNTky
NDEwYjFiYTlkYWY2MWMzYmRlOTI3NjJhNDNlYWM1ODAwMDg1MCBjb21waWxpbmcKOTI3IHJl
YWwgIDE1NjYgdXNlciAgMTQ2IHN5cyAgMTg0Ljc2JSBjcHUgCXg4Nl82NC1yYW5kY29uZmln
LXMxLTAxMTAxNzM4CgoyMDE0LTAxLTEyLTAxOjMzOjAwIGRldGVjdGluZyBib290IHN0YXRl
IDMuMTMuMC1yYzctMDU4NjgtZzU5MjQxMGIxLi4JMS4uCTIJOS4JMTUuLgkxOQkyMy4JMzAJ
MzIJMzYuCTM3CTM4Li4uLi4uCTQwLgk0Ngk1Mi4JNTQJNjAJNjEJNjMJNjQuCTY1CTcwCTcx
CTczLgk3NQk3OS4uCTgwCTg2CTkyCTk3CTEwMS4JMTAyCTEwNQkxMDkJMTE3CTEyMC4JMTIx
LgkxMjIJMTI0Li4JMTI4CTEzMi4uCTEzMwkxMzUJMTQwCTE1NQkxNTcJMTU4LgkxNTkJMTYx
Li4uCTE2NAkxNzcuCTE4MQkxODYuLgkxODgJMTg5Li4uLi4uLgkxOTEuLgkxOTUJMTk5CTIw
NAkyMDUJMjExLi4uLgkyMTMJMjIwCTIyOC4JMjI5CTIzMAkyMzMJMjM1CTIzOQkyNDYJMjQ3
CTI1MwkyNTYJMjYxCTI2NAkyNjUuLgkyNjcJMjY5CTI3NwkyODQJMjk2CTI5NwkyOTkJMzAw
CTMwMQkzMDQJMzE0CTMyMQkzMjkJMzQwCTM0OQkzNjQJMzY1Li4uLi4uCTM2NgkzNjcJMzY4
LgkzNzEJMzc4CTM4OAkzOTEJMzk3CTQxNAk0MjEJNDI0CTQyNS4JNDI2Lgk0MjcJNDMwCTQz
MQk0MzYJNDM5CTQ0Mgk0NDcuLi4uLi4uLi4uCTQ0OQk0NTAJNDUyLi4uLgk0NTQuLgk0NTUu
CTQ1OC4uLi4uLi4JNDU5Lgk0NjEJNDYyCTQ2My4JNDY0Li4uLgk0NzEJNDc0Lgk0NzUuCTQ3
Ngk0NzguCTQ3OS4JNDgwLi4JNDgxLgk0ODcJNDg4Li4uLi4uLi4uCTQ4OQk0OTAuLi4JNDkz
Li4JNDk0CTQ5OQk1MDQJNTA1Li4uLi4uCTUxMgk1MTMuLi4uLgk1MjAJNTI0CTUyNS4uCTUy
Ny4JNTI4Lgk1MzEuCTUzMi4uLi4uLi4JNTM1CTUzOC4JNTM5Li4uLi4JNTQwCTU0NAk1NDYu
Li4uCTU0Nwk1NDgJNTUwLgk1NTEuLgk1NTUJNTU2Lgk1NTgJNTYwLgk1NjEJNTYzCTU2Ngk1
NzAJNTcyCTU3OS4JNTgyCTU4Mwk1ODQJNTg1CTU4OQk1OTIJNjAwCTYwNAk2MDUuLgk2MDYJ
NjA4CTYwOQk2MTEJNjIxCTYyNgk2MjcJNjI5Li4uLi4uLi4JNjMyLi4uCTYzNAk2MzYuLi4u
Lgk2MzgJNjQ0CTY0Ni4uCTY0OQk2NTAuLi4uLgk2NTEJNjUzCTY2MC4uLi4uLi4uLi4uLi4u
Lgk2NjIJNjY1CTY2OQk2NzMuCTY3Nwk2ODIJNjgzCTY4NS4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uCTY4OC4uCTY5MC4uLi4uLi4uCTcwMQk3MDIuLi4JNzA2Li4JNzExLi4uLgk3MTYuLi4u
Li4uLi4uLi4uLi4uLi4uCTcxOAk3MjAuLi4uCTcyMS4uCTcyMy4uLgk3MjcJNzI5CTczMQk3
MzIJNzM0Lgk3MzgJNzQzCTc0NQk3NDkJNzUwCTc1MS4uLi4uLi4uLi4uLi4JNzUzCTc1Nwk3
NTgJNzYyCTc2Mwk3NjQuLi4uLi4uCTc2OC4uLi4uLgk3NjkJNzczCTc3Ni4uCTc3Nwk3Nzgu
Lgk3ODAJNzgzCTc4Nwk3ODgJNzkwIFNVQ0NFU1MKCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFu
Y2ggbWF5IGJlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3RpcC9hdXRvLWxhdGVzdCcKbGlu
ZWFyLWJpc2VjdDogaGFuZGxlIG92ZXIgdG8gZ2l0IGJpc2VjdApsaW5lYXItYmlzZWN0OiBn
aXQgYmlzZWN0IHN0YXJ0IGI4MDU3MzY4ZDZjMjlkYjUzOGZmMjU5MjY2YTQzNzUyMDBjM2Qw
MjkgNTkyNDEwYjFiYTlkYWY2MWMzYmRlOTI3NjJhNDNlYWM1ODAwMDg1MCAtLQpQcmV2aW91
cyBIRUFEIHBvc2l0aW9uIHdhcyA1OTI0MTBiMS4uLiBNZXJnZSByZW1vdGUtdHJhY2tpbmcg
YnJhbmNoICdzcGkvZm9yLW5leHQnCkhFQUQgaXMgbm93IGF0IDNjMGVlZTMuLi4gTGludXgg
Mi42LjM3CkJpc2VjdGluZzogMjA4IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhp
cyAocm91Z2hseSA4IHN0ZXBzKQpbZmE2ZThlNWY3Y2JmODVmMzY0ZWJkNWE5MDUyNWRiYmU5
ZGUyMDgzYl0gTWVyZ2UgdGFnICdwZXJmLWNvcmUtZm9yLW1pbmdvJyBvZiBnaXQ6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYWNtZS9saW51eCBpbnRvIHBl
cmYvY29yZQpsaW5lYXItYmlzZWN0OiBnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMv
YmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9vYmotYmlzZWN0CnJ1
bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9t
ZS93ZmcvbW0vb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0v
eDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3MzgvbmV4dDptYXN0ZXI6ZmE2ZThlNWY3Y2Jm
ODVmMzY0ZWJkNWE5MDUyNWRiYmU5ZGUyMDgzYjpiaXNlY3QtbW0KCjIwMTQtMDEtMTItMDY6
MDM6MDIgZmE2ZThlNWY3Y2JmODVmMzY0ZWJkNWE5MDUyNWRiYmU5ZGUyMDgzYiBjb21waWxp
bmcKMzkyIHJlYWwgIDE1NzcgdXNlciAgMTU3IHN5cyAgNDQxLjQwJSBjcHUgCXg4Nl82NC1y
YW5kY29uZmlnLXMxLTAxMTAxNzM4CgoyMDE0LTAxLTEyLTA2OjEwOjExIGRldGVjdGluZyBi
b290IHN0YXRlIDMuMTMuMC1yYzQtMDAxNjgtZ2ZhNmU4ZTUuLi4JMS4uLi4uLi4uLgk3CTEx
CTE3CTE4CTIwCTIxLgkyMi4JMjUJMjYJMjcuCTI4CTM5CTQxLi4JNDMJNDQJNDUuCTQ3Li4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uCTQ4CTUxCTU0CTU4CTYxCTY2CTY3CTY5CTcwCTcyLgk4MC4JODEuLi4u
Li4uLi4uLi4uLi4uLgk4Mi4JODQuCTg2CTkxLi4uLi4uCTkzLgk5Ni4JOTgJMTAxLgkxMDIJ
MTAzCTEwNwkxMDkuLgkxMTIJMTE1Li4JMTE2CTExNy4uLi4uLi4uCTEyMwkxMjgJMTI5Li4u
Li4uLgkxMzIuCTEzMy4uLi4uCTEzNQkxMzgJMTQ0CTE0NwkxNTYuLgkxNTcJMTYwLgkxNjIu
CTE2My4JMTY1Li4uLi4uLi4uLi4uLgkxNjcuLi4uCTE3MgkxNzMJMTc0CTE3NgkxNzcuLgkx
NzkuCTE4MwkxODUJMTg2CTE4OAkxOTAuLi4uLi4uLi4JMTkxLgkxOTYJMjAwCTIwMgkyMDMu
CTIwNS4JMjA2CTIxMC4uLgkyMTEuLgkyMTIJMjE1CTIxNwkyMTkuCTIyMAkyMjIJMjIzLi4u
Li4uLi4uLi4uLgkyMjgJMjMxCTIzMi4JMjM0Li4JMjQxLi4uCTI0MwkyNDYuCTI0NwkyNTAJ
MjUxLi4JMjUyCTI1NQkyNTYJMjYzLi4uCTI2NC4uLgkyNjUJMjY2Li4uLi4uCTI3MQkyNzMu
CTI3NgkyODAJMjg3CTI4OAkyODkuCTI5MAkyOTQJMjk2CTI5OQkzMDUuLi4uCTMwNi4JMzA4
Li4JMzEwCTMxMQkzMTQJMzIwLgkzMjEuLi4JMzIyLi4JMzI0CTMyNwkzMzUuCTMzNy4JMzM5
Li4JMzQwLi4JMzQxCTM0MwkzNTAJMzU3CTM1OQkzNjAJMzYxCTM2MgkzNjMuCTM2NQkzNjcJ
MzY4LgkzNjkJMzcwCTM3MQkzNzIuLi4uLgkzODAJMzgxLgkzODcJMzkwCTM5MgkzOTMuCTM5
NwkzOTguCTQwNwk0MDkuLi4uLi4uCTQxNgk0MTkuLi4JNDIyCTQyNi4uCTQzMAk0MzQJNDQ1
CTQ1MAk0NTIJNDU0CTQ2Mgk0NjMJNDY3Li4uLi4uLi4uCTQ2OQk0ODIuLgk0ODMJNDg0CTQ4
NQk0ODYuLi4uCTQ4Nwk0ODguLgk0OTAJNDkxCTQ5Mi4uCTQ5NC4uLi4JNDk1Li4uCTQ5Nwk0
OTgJNTA0CTUwNgk1MTIJNTEzCTUxNC4uLi4uLi4uLi4uLgk1MTkJNTIwCTUyNgk1MzMuLi4u
Li4JNTQwLi4uLi4uLi4JNTQxLgk1NDMJNTQ3CTU1MQk1NTUuLgk1NTgJNTYzCTU2OAk1NzUJ
NTgxCTU4Mwk1ODYuLgk1ODcuLgk1OTEJNTk0Li4JNTk2CTU5OQk2MDAJNjAyCTYwMy4uCTYw
NAk2MTAJNjE3CTYxOS4uCTYyMC4uLi4uLgk2MjEJNjIyLi4uLi4JNjMxCTYzNQk2NTAJNjU0
Lgk2NTUuCTY1OAk2NTkuCTY2MAk2NjMJNjcwCTY3Mgk2NzYJNjgzCTY4OAk2OTAJNjkzCTY5
NC4JNjk2CTY5Nwk3MDMJNzA2CTcwNwk3MDkJNzEwCTcxOAk3MjEJNzIyLgk3MjQuLi4uCTcy
NS4uLgk3MjcuCTcyOS4uCTczMQk3MzMJNzQwCTc0OC4uCTc1NQk3NTcJNzU4CTc1OQk3NjAu
CTc2MS4uCTc2Mwk3NjcJNzY4CTc3MAk3NzQJNzc3CTc3OQk3ODMJNzg0Li4uCTc4Ngk3ODcu
CTc5MCBTVUNDRVNTCgpCaXNlY3Rpbmc6IDEwNCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFm
dGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzIzMGQ0N2RlZGI1NzYzYWNmYWY2ODQyYzg1
ZDlkMjRmOTdmYzNlZTJdIE1lcmdlIGJyYW5jaCAnc2NoZWQvY29yZScKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9tbS9v
YmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFu
ZGNvbmZpZy1zMS0wMTEwMTczOC9uZXh0Om1hc3RlcjoyMzBkNDdkZWRiNTc2M2FjZmFmNjg0
MmM4NWQ5ZDI0Zjk3ZmMzZWUyOmJpc2VjdC1tbQoKMjAxNC0wMS0xMi0xMToyOTozMSAyMzBk
NDdkZWRiNTc2M2FjZmFmNjg0MmM4NWQ5ZDI0Zjk3ZmMzZWUyIGNvbXBpbGluZwozMjYgcmVh
bCAgMTUwMyB1c2VyICAxNDggc3lzICA1MDUuNTclIGNwdSAJeDg2XzY0LXJhbmRjb25maWct
czEtMDExMDE3MzgKCjIwMTQtMDEtMTItMTE6MzU6NDcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xMy4wLXJjNy0wMDI3Ny1nMjMwZDQ3ZC4uLi4uCTEJNQk2LgkyMgkyNAkyNS4uLi4uLi4u
Li4uCTI4CTMwCTMxCTMzCTM0CTM1CTM2Lgk0MQk0Mgk0Mwk0NAk0OQk1NAk2MC4JNjIJNjcJ
NjkJNzAuLi4uCTcxLgk3Mgk3OAk4MQk4Mgk4NQk4Nwk4OQk5MC4JOTIJOTYuLi4JOTgJOTkJ
MTAzCTEwNAkxMDguCTEwOQkxMTAJMTExLgkxMTIuCTExMwkxMTQuCTExNwkxMjAJMTIyCTEy
NQkxMjYuCTEyNwkxMjkuLi4JMTMwLi4uLgkxMzEJMTM0Li4uLi4JMTM5CTE0MS4JMTQyCTE0
NAkxNDgJMTUwCTE1MwkxNTYJMTYwCTE3MQkxNzQJMTc1CTE4NQkxOTIJMTk2CTE5NwkxOTgJ
MjAwCTIwNAkyMDgJMjA5CTIxMQkyMTQuLi4uCTIxNwkyMjAuLgkyMjEJMjIyCTIyNy4JMjI5
LgkyMzcuCTI0MS4JMjQ4CTI2MgkyNjkJMjcxLi4JMjcyCTI3My4JMjc1CTI3Ni4JMjc4Li4J
Mjc5CTI4MS4JMjgyCTI4My4JMjg2LgkyODcJMjk2CTMwMQkzMDcJMzA4Li4JMzEwCTMxMgkz
MTUJMzE4CTMyMC4uLi4JMzIxLi4uLgkzMjQuCTMyNS4uLgkzMjYJMzI4Li4uCTMzMQkzMzMJ
MzQwCTM0NAkzNDYJMzUyCTM1NwkzNjEJMzYzCTM2Ni4uLgkzNzAJMzc0CTM3NgkzNzcuCTM3
OAkzODAuLgkzODEuCTM4MgkzODYJMzg3CTM4OC4uLi4uCTM4OS4JMzkxLgkzOTQJMzk2Li4u
Li4JMzk4CTM5OQk0MDYJNDA4Lgk0MDkuLi4JNDEzLgk0MTUJNDE4Li4JNDE5Li4uCTQyMwk0
MjgJNDMyCTQzNi4JNDQyCTQ0NAk0NDkJNDUzCTQ1NC4JNDU1CTQ1Ngk0NTguCTQ1OQk0NjAu
Li4uLi4uLi4uLi4uLgk0NjEJNDcwCTQ3Ngk0ODMJNDg1CTQ4Ni4uLi4JNDg3CTQ4OAk0ODkJ
NDkwCTQ5Mgk0OTQJNDk1Lgk0OTYJNDk4CTUwMAk1MDEJNTA3CTUxMS4JNTEyCTUxNC4JNTE2
CTUxOAk1MjIuCTUyMy4JNTI3Li4JNTI4CTUzMC4JNTMzCTUzNC4JNTM4CTU0MAk1NDEJNTQz
CTU0NS4uCTU0Ni4uLi4uLi4uCTU0OC4JNTUxCTU1Mi4JNTUzLgk1NTQuCTU1NQk1NTYJNTU3
Lgk1NjAuCTU2Mgk1NjMJNTY0Lgk1NjYuLgk1NjkuCTU3MQk1NzIuLgk1NzMuLi4uLi4uLi4J
NTc0CTU3NS4JNTgyLgk1ODQJNTg1Li4JNTg5CTU5MC4uLi4uCTU5Mi4JNTk0CTYwMgk2MDcJ
NjE2CTYzMy4uLgk2MzQuCTYzOAk2NDIJNjQ2CTY0OAk2NTcJNjU4Li4JNjU5CTY2MC4uLi4u
Li4uLi4JNjYxLi4uLgk2NjUuLgk2NjcuCTY2OC4uCTY2OS4uLi4JNjcwCTY3Mgk2NzcJNjc4
Lgk2NzkuCTY4MAk2ODEJNjgzCTY4NAk2ODcJNjg5Lgk2OTEuLi4uCTY5Mgk2OTMJNjk1Li4u
Li4JNjk2CTcwMAk3MDcJNzE3CTcyMwk3MjUJNzI2Li4JNzMyCTc0MQk3NDMJNzQ0CTc1MAk3
NTQJNzU2Li4JNzYwCTc2MQk3NjIuLgk3NjcJNzY4CTc3MAk3NzIJNzczLi4uLi4JNzc2CTc3
OC4uLi4uCTc3OS4uLi4uCTc4MC4JNzgxLi4JNzkwIFNVQ0NFU1MKCkJpc2VjdGluZzogNTUg
cmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDYgc3RlcHMpCltj
MGZmYjM1NzBhZTZlMTUyNDkwYWJjZjFhMDI0MWUwOTI0ZGIzMTc2XSBtYW51YWwgbWVyZ2Ug
b2YgeDg2L2VmaQpydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZh
aWx1cmUuc2ggL2hvbWUvd2ZnL21tL29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL3g4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4L25leHQ6bWFzdGVy
OmMwZmZiMzU3MGFlNmUxNTI0OTBhYmNmMWEwMjQxZTA5MjRkYjMxNzY6YmlzZWN0LW1tCgoy
MDE0LTAxLTEyLTE2OjAyOjU3IGMwZmZiMzU3MGFlNmUxNTI0OTBhYmNmMWEwMjQxZTA5MjRk
YjMxNzYgY29tcGlsaW5nCjI4NiByZWFsICAxNTUyIHVzZXIgIDE1MCBzeXMgIDU5NC40NyUg
Y3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOAoKMjAxNC0wMS0xMi0xNjowODox
NSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAtcmM3LTAwMzI2LWdjMGZmYjM1Li4uCTQJ
Ngk3CTgJMTAuCTExCTEzCTE1LgkxNi4uLi4JMTcuCTIwLgkyMi4uCTI0Li4JMjgJMzgJNDQu
CTQ1Lgk1Mgk1NAk2Mgk2Mwk2OAk2OQk3NQk3Ni4JNzcJODEJODIJODMuLi4uLgk4NS4JODcJ
ODguLi4JODkJOTAuCTkxCTkzCTk3CTEwMAkxMDYuCTEwOQkxMTUJMTE2LgkxMTgJMTE5CTEy
MS4uLi4JMTIyCTEyNC4JMTI2CTEzMAkxMzEJMTM0Li4JMTM1Li4uCTEzNy4JMTM4CTE0MS4u
LgkxNDMJMTQ0CTE0NwkxNDgJMTQ5CTE1NAkxNjAJMTY2CTE2OQkxNzEJMTcyCTE3NAkxODIu
CTE4NAkxODYJMTg4LgkxODkuCTE5MQkxOTIJMTk0Li4uLi4JMjAxLi4uLi4uLi4uLi4uLi4u
CTIwMy4uLi4uCTIwNAkyMDUJMjA3LgkyMDgJMjA5LgkyMTIJMjE0CTIyMQkyMjQuLi4JMjI4
CTIyOS4JMjMwLgkyMzIuLgkyMzMJMjM0CTIzNQkyMzYJMjM3Li4JMjM5CTI0MAkyNDMJMjQ2
CTI0OC4uCTI1MgkyNTQuCTI1NS4JMjU2CTI1OQkyNjAuLi4uCTI2MQkyNjQJMjY5CTI3MQky
NzUJMjc3CTI3OAkyODIuCTI4My4uLi4uLgkyODQJMjg4CTI5MgkyOTcuLi4JMjk5Li4JMzAx
Li4uLi4uLi4uLi4uLi4uLgkzMTIJMzEzLgkzMTUuLi4uLi4JMzIwCTMyMgkzMjMJMzI2CTMz
NAkzMzgJMzQwCTM0MS4uCTM0Mi4JMzQ1Li4uLgkzNTAJMzU1CTM1NwkzNTgJMzU5Li4uLi4u
CTM2MC4JMzYyCTM2My4JMzY0CTM2OAkzNjkuCTM3MAkzNzIuCTM3NAkzNzYJMzc3Li4JMzg2
CTM4Ny4JMzg4CTM5MgkzOTUJNDAyCTQwOS4uCTQxNQk0MjAJNDIyLi4uLi4uLi4uLi4uLi4J
NDI0CTQyNQk0MjYuCTQyNy4uCTQyOC4JNDM1CTQzNgk0MzcJNDM4Li4uCTQ0MS4uLi4uLi4J
NDQ1Lgk0NDYJNDQ3Li4uCTQ0OS4uCTQ1MAk0NTEJNDUzCTQ1NQk0NTYuLgk0NTgJNDU5CTQ2
MAk0NjQuLi4uLi4uLgk0NjUuCTQ2Ni4JNDY3Li4uCTQ2OC4JNDcyCTQ4OAk0OTQuLi4JNDk1
CTQ5OS4uCTUwMAk1MDIuCTUwMwk1MTgJNTIwLi4uLi4uCTUyMwk1MjUuCTUyOQk1MzEuLgk1
MzIJNTMzCTUzNgk1NDQJNTQ4CTU1NC4uLi4uCTU1Nwk1NjEuLgk1NjcJNTc4Lgk1ODEJNTkz
CTU5Nwk1OTguLi4uLi4uLi4JNjAzCTYwNQk2MDcJNjEwCTYxNQk2MjAJNjIyCTYyNy4JNjI4
Li4uCTYzMS4uCTYzNAk2MzgJNjQxCTY0Mwk2NTQuLi4JNjYwCTY2MS4uCTY2Mgk2NjMuLgk2
NjQuCTY2OC4uCTY2OS4uLi4uCTY3MC4JNjcxCTY3My4JNjc0Li4uLgk2NzcJNjgyCTY4Mwk2
ODYJNjg4CTY5Mwk3MDEJNzA0CTcwNgk3MTEuCTcxMgk3MTUuCTcxNy4uLgk3MTgJNzIwCTcy
NC4JNzI1CTcyNwk3MjguCTcyOQk3MzgJNzQ0CTc1Mwk3NzMJNzc0CTc3OC4JNzgwLi4uCTc4
NQk3ODkJNzkwIFNVQ0NFU1MKCkJpc2VjdGluZzogMjMgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDUgc3RlcHMpCls4OGVjMTdlYTk4ZWJhYzJhNjMwNmJj
MTQ4MTAwNDY0OTNjOTZlMjdmXSBNZXJnZSBicmFuY2ggJ3g4Ni9rYXNscicKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9t
bS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wMTEwMTczOC9uZXh0Om1hc3Rlcjo4OGVjMTdlYTk4ZWJhYzJhNjMw
NmJjMTQ4MTAwNDY0OTNjOTZlMjdmOmJpc2VjdC1tbQoKMjAxNC0wMS0xMi0yMDozODozMSA4
OGVjMTdlYTk4ZWJhYzJhNjMwNmJjMTQ4MTAwNDY0OTNjOTZlMjdmIGNvbXBpbGluZwo0Mzgg
cmVhbCAgMTQ5MCB1c2VyICAxNDYgc3lzICAzNzMuNDAlIGNwdSAJeDg2XzY0LXJhbmRjb25m
aWctczEtMDExMDE3MzgKCjIwMTQtMDEtMTItMjA6NDY6MzIgZGV0ZWN0aW5nIGJvb3Qgc3Rh
dGUgMy4xMy4wLXJjNy0wMDM1OC1nODhlYzE3ZS4uLi4JNAk2CTcuCTExLi4uCTE0CTE3Lgkx
OC4JMTkJMjYJMzIJMzYJMzguCTM5CTQ0CTQ2Lgk1MQk2MC4uLgk2Mi4uLi4uLgk3Mgk4NAk5
Ny4JMTAwLgkxMDIgVEVTVCBGQUlMVVJFClsgICAxNC4xNzQxNjNdIHNvY2s6IHByb2Nlc3Mg
YHRyaW5pdHktbWFpbicgaXMgdXNpbmcgb2Jzb2xldGUgc2V0c29ja29wdCBTT19CU0RDT01Q
QVQKWyAgIDE0LjY4MDI1NV0gaHJ0aW1lcjogaW50ZXJydXB0IHRvb2sgMTYyODkgbnMKWyAg
IDE2LjQyMzc2Ml0gd2FybmluZzogcHJvY2VzcyBgdHJpbml0eS1jMScgdXNlZCB0aGUgZGVw
cmVjYXRlZCBzeXNjdGwgc3lzdGVtIGNhbGwgd2l0aCAKWyAgIDE3LjAxMDQ4N10gdHJpbml0
eS1jMSBpbnZva2VkIG9vbS1raWxsZXI6IGdmcF9tYXNrPTB4MjgwZGEsIG9yZGVyPTAsIG9v
bV9zY29yZV9hZGo9MApbICAgMTcuMDExNDczXSB0cmluaXR5LWMxIGNwdXNldD0vIG1lbXNf
YWxsb3dlZD0wClsgICAxNy4wMTIwNjJdIENQVTogMSBQSUQ6IDIzNTIgQ29tbTogdHJpbml0
eS1jMSBOb3QgdGFpbnRlZCAzLjEzLjAtcmM3LTAwMzU4LWc4OGVjMTdlICM2MTIKWyAgIDE3
LjAxMzE4OF0gIDAwMDAwMDAwMDAwMDAwMDAgZmZmZjg4MDAwMDExYmE3OCBmZmZmZmZmZjg1
ODMyOWFkIGZmZmY4ODAwMGVlZjY3MTAKWyAgIDE3LjAxNDI4N10gIGZmZmY4ODAwMDAxMWJi
MDggZmZmZmZmZmY4NTgzMDBjNyBmZmZmODgwMDAwMTFiYWE4IDAwMDAwMDAwMDAwMDAwMDYK
WyAgIDE3LjAxNTUzMF0gIDAwMDAwMDAwMDAwMDAyMDIgZmZmZmZmZmY4NWIxYjljMCBmZmZm
ODgwMDAwMTFiYWI4IGZmZmZmZmZmODUyOWQ5Y2QKWyAgIDE3LjAxNjU0Ml0gQ2FsbCBUcmFj
ZToKWyAgIDE3LjAxNjkwMF0gIFs8ZmZmZmZmZmY4NTgzMjlhZD5dIGR1bXBfc3RhY2srMHg0
ZC8weDY2ClsgICAxNy4wMTc1MzNdICBbPGZmZmZmZmZmODU4MzAwYzc+XSBkdW1wX2hlYWRl
ci5pc3JhLjcrMHg3NC8weDIyYgpbICAgMTcuMDE4MjE3XSAgWzxmZmZmZmZmZjg1MjlkOWNk
Pl0gPyB0cmFjZV9oYXJkaXJxc19vbisweGQvMHgxMApbICAgMTcuMDE4OTIwXSAgWzxmZmZm
ZmZmZjg1MmYwYzJmPl0gb29tX2tpbGxfcHJvY2VzcysweDZmLzB4MzgwClsgICAxNy4wMTk3
ODldICBbPGZmZmZmZmZmODUyZjE1ZGQ+XSBvdXRfb2ZfbWVtb3J5KzB4NGFkLzB4NTIwClsg
ICAxNy4wMjA1OTldICBbPGZmZmZmZmZmODUyZjcyMDA+XSBfX2FsbG9jX3BhZ2VzX25vZGVt
YXNrKzB4N2YwLzB4OTgwClsgICAxNy4wMjEzNTFdICBbPGZmZmZmZmZmODUzMjRhOTc+XSBh
bGxvY19wYWdlc192bWErMHgxNTcvMHgxYjAKWyAgIDE3LjAyMjAyOF0gIFs8ZmZmZmZmZmY4
NTMwYzg1ZD5dID8gaGFuZGxlX21tX2ZhdWx0KzB4MzdkLzB4NmUwClsgICAxNy4wMjI4Njdd
ICBbPGZmZmZmZmZmODUzMGM4NWQ+XSBoYW5kbGVfbW1fZmF1bHQrMHgzN2QvMHg2ZTAKWyAg
IDE3LjAyMzU5NV0gIFs8ZmZmZmZmZmY4NTMwYjY2Zj5dID8gZm9sbG93X3BhZ2VfbWFzaysw
eDIzZi8weDQwMApbICAgMTcuMDI0NDQ4XSAgWzxmZmZmZmZmZjg1MzBjZjllPl0gX19nZXRf
dXNlcl9wYWdlcysweDNkZS8weDYwMApbICAgMTcuMDI1MzExXSAgWzxmZmZmZmZmZjg1MzBm
M2MyPl0gX19tbG9ja192bWFfcGFnZXNfcmFuZ2UrMHhiMi8weGMwClsgICAxNy4wMjYwNTFd
ICBbPGZmZmZmZmZmODUzMGZhZjE+XSBfX21tX3BvcHVsYXRlKzB4ZjEvMHgxNzAKWyAgIDE3
LjAyNjc5NV0gIFs8ZmZmZmZmZmY4NTMwMjFkNj5dIHZtX21tYXBfcGdvZmYrMHg4Ni8weGEw
ClsgICAxNy4wMjc1MzJdICBbPGZmZmZmZmZmODUzMTFmYTY+XSBTeVNfbW1hcF9wZ29mZisw
eDIxNi8weDIzMApbICAgMTcuMDI4MTkwXSAgWzxmZmZmZmZmZjg1NDlmYTdiPl0gPyB0cmFj
ZV9oYXJkaXJxc19vbl90aHVuaysweDNhLzB4M2YKWyAgIDE3LjAyODkwN10gIFs8ZmZmZmZm
ZmY4NTIwNmM0ZD5dIFN5U19tbWFwKzB4MWQvMHgyMApbICAgMTcuMDI5NTg5XSAgWzxmZmZm
ZmZmZjg1ODQyMGY5Pl0gc3lzdGVtX2NhbGxfZmFzdHBhdGgrMHgxNi8weDFiClsgICAxNy4w
MzA0MzhdIE1lbS1JbmZvOgpbICAgMTcuMDMwNzQ2XSBOb2RlIDAgRE1BIHBlci1jcHU6Clsg
ICAxNy4wMzExNTZdIENQVSAgICAwOiBoaTogICAgMCwgYnRjaDogICAxIHVzZDogICAwCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3MzgvODhlYzE3ZWE5OGViYWMyYTYz
MDZiYzE0ODEwMDQ2NDkzYzk2ZTI3Zi9kbWVzZy15b2N0by1hdGhlbnMtNToyMDE0MDExMjIx
MDkyNTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczODozLjEzLjAtcmM3LTAwMzU4LWc4
OGVjMTdlOjYxMgoxMDA6MTozIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW1S
RVBFQVQgQ09VTlQ6IDEwMDAgICMgL2NjL3dmZy9tbS1iaXNlY3QvLnJlcGVhdBtbMG0KCkJp
c2VjdGluZzogMTYgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5
IDQgc3RlcHMpCls5MzkzNzk5NjBlM2ZjZDgxY2I4YjcwOWI2N2FmZTRjN2YwOTdkY2M4XSBN
ZXJnZSBicmFuY2ggJ3g4Ni9lZmkta2V4ZWMnCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jp
c2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2VjdApscyAt
YSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDEx
MDE3MzgvbmV4dDptYXN0ZXI6OTM5Mzc5OTYwZTNmY2Q4MWNiOGI3MDliNjdhZmU0YzdmMDk3
ZGNjODpiaXNlY3QtbW0KCjIwMTQtMDEtMTItMjE6MDk6MzggOTM5Mzc5OTYwZTNmY2Q4MWNi
OGI3MDliNjdhZmU0YzdmMDk3ZGNjOCBjb21waWxpbmcKNDM4IHJlYWwgIDE1NzkgdXNlciAg
MTUyIHN5cyAgMzk0LjkyJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4Cgoy
MDE0LTAxLTEyLTIxOjE3OjIyIGRldGVjdGluZyBib290IHN0YXRlIDMuMTMuMC1yYzctMDAz
NDEtZzkzOTM3OTkuLi4JMS4uLi4JMy4JNQk2Li4uLi4uLi4JMTYJMTcuLgkyOQkzMQkzMgkz
MwkzNAkzNQkzNy4JNDEuCTQyCTQzCTQ0CTQ3Lgk0OQk1Ny4JNjAJNjMuLi4JNjUJNjcJNjgJ
NjkuCTgxLgk5Ngk5Nwk5OC4uLi4uLgkxMDEJMTAyLgkxMDYJMTA3CTEwOS4JMTEwLgkxMTUu
LgkxMTcuCTEyMAkxMjUJMTMxLgkxMzkJMTQwCTE0MgkxNTAJMTUxCTE1NC4uCTE1NS4JMTU2
LgkxNjEJMTYyCTE2Ni4JMTY3LgkxNjgJMTY5LgkxNzIJMTc2LgkxODAJMTg4CTE4OQkxOTAJ
MTkxCTE5Mi4JMTkzLgkxOTQJMTk4LgkxOTkuLi4uCTIwMQkyMDQJMjA5CTIxNgkyMTcJMjE5
Li4uLgkyMjAJMjIzLi4JMjI0Li4uCTIyNS4JMjI2Li4uCTIyNwkyMzAuLgkyMzIJMjM1CTIz
Ni4JMjQyCTI0Ny4JMjUzCTI1NwkyNTgJMjY4CTI3MAkyNzIJMjc1CTI3NwkyODAJMjgyCTI5
MQkyOTUJMjk3CTI5OAkzMDYJMzA5Li4uCTMxMAkzMTYJMzIyLgkzMjMJMzI0Li4JMzI1CTMz
MAkzMzQJMzM3CTMzOS4JMzQxLgkzNDMuCTM1MQkzNTIJMzU0LgkzNTcJMzYxCTM2My4JMzY0
Li4JMzY3CTM3MAkzNzEJMzc0CTM3NS4uLgkzNzgJMzc5CTM4MAkzODMJMzg1LgkzODcJMzkx
CTM5NAk0MDAJNDA2CTQxNAk0MTUJNDE2Li4uLi4uCTQxNy4JNDI0CTQyNQk0MzQJNDQwLgk0
NDIuLi4uCTQ0Ngk0NDcuLi4JNDQ4Li4uCTQ0OQk0NTAuLgk0NTMJNDU3Li4JNDU4Li4JNDU5
CTQ2Mgk0NzEuLi4uLi4uLi4JNDcyLi4JNDc1CTQ3Ngk0ODEJNDgyLi4uLi4JNDg1Lgk0ODYu
CTQ5NQk0OTYuCTQ5Ny4JNDk4Li4uLi4uLi4uLi4JNDk5CTUwMAk1MDIuLgk1MDQJNTA4CTUw
OS4uLi4JNTEwCTUxNQk1MTYuLi4uLi4uLi4uLi4JNTQ4Lgk1NDkJNTUxLi4JNTUyCTU1Ni4J
NTU4Lgk1NTkJNTYwLgk1NjEJNTcyCTU3Nwk1NzkJNTgwLi4uLgk1ODQJNTg4CTU5MAk1OTEu
CTU5NC4uCTU5Ngk2MDAuLi4JNjAxLgk2MTcJNjIyCTYyOS4uLgk2MzAJNjMyCTYzMy4JNjM1
CTYzNgk2NDEuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgk2NDIJNjQ1
CTY0Ngk2NDcJNjUxLgk2NTMJNjU0Li4uCTY1NS4uLi4uLgk2NTYuLi4uLi4JNjU5Lgk2NjMJ
NjY2CTY3MAk2NzMJNjc0Li4uLgk2NzUuLi4uCTY3Ngk2NzkJNjgxCTY4Mi4JNjgzLgk2OTMJ
Njk2CTY5Nwk3MTAJNzExCTcxMwk3MTQJNzE4CTcyOQk3MzIJNzM0CTczNgk3NDIJNzUxCTc1
NAk3NTgJNzY1CTc3MAk3NzYJNzc3CTc3OQk3ODYJNzkxCTc5NQk3OTYJNzk3CTgwNwk4MDgJ
ODEyCTgxNC4uCTgxNS4uLgk4MTYuCTgxOAk4MjEuLgk4MjQJODMwCTgzMS4uCTgzNgk4Mzgu
CTgzOQk4NDEJODQyCTg0Mwk4NDYJODUxCTg1Ni4JODU4CTg2MQk4NjQJODY1CTg2Ngk4NjgJ
ODcyCTg3NS4JODc3Li4JODgxLgk4ODYJODg4CTg5MC4JOTA2Lgk5MTEuCTkxMi4JOTEzCTkx
NQk5MTcuCTkxOS4uCTkyMQk5MjcJOTI4CTkzMwk5NDYJOTQ3Lgk5NTIuCTk1NS4JOTYxLgk5
NjIJOTYzCTk2NAk5NjYuLgk5NjcuCTk2OQk5NzYJOTc4Li4JOTc5CTk4NQk5OTAJOTkyCTk5
OS4uLi4uLi4uCTEwMDAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA4IHJldmlzaW9ucyBsZWZ0IHRv
IHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAzIHN0ZXBzKQpbNmU2YTQ5MzJiMGY1NjliMWE1
YmI0ZmNiZjVkZGUxYjFhNDJmMDFiYl0geDg2LCBib290OiBSZW5hbWUgZ2V0X2ZsYWdzKCkg
YW5kIGNoZWNrX2ZsYWdzKCkgdG8gKl9jcHVmbGFncygpCnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvaG9tZS93ZmcvbW0vb2JqLWJpc2Vj
dApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWct
czEtMDExMDE3MzgvbmV4dDptYXN0ZXI6NmU2YTQ5MzJiMGY1NjliMWE1YmI0ZmNiZjVkZGUx
YjFhNDJmMDFiYjpiaXNlY3QtbW0KCjIwMTQtMDEtMTMtMDI6MTk6MjcgNmU2YTQ5MzJiMGY1
NjliMWE1YmI0ZmNiZjVkZGUxYjFhNDJmMDFiYiBjb21waWxpbmcKNDE0IHJlYWwgIDE0ODcg
dXNlciAgMTUwIHN5cyAgMzk1LjEwJSBjcHUgCXg4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAx
NzM4CgoyMDE0LTAxLTEzLTAyOjI3OjA0IGRldGVjdGluZyBib290IHN0YXRlIDMuMTIuMC1y
YzQtMDAwMDgtZzZlNmE0OTMuLi4uLi4uLi4uLi4uLi4uLi4uLi4uIFRFU1QgRkFJTFVSRQpb
ICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQg
My4xMi4wLXJjNC0wMDAwOC1nNmU2YTQ5MyAjNjE0ClBBTklDOiBlYXJseSBleGNlcHRpb24g
MGUgcmlwIDEwOmZmZmZmZmZmODVhMDRmMjIgZXJyb3IgMCBjcjIgZmZmZmZmZmY4MTk3MmIy
OAoKQlVHOiBrZXJuZWwgYm9vdCBoYW5nCkVsYXBzZWQgdGltZTogNjEwCnFlbXUtc3lzdGVt
LXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wMTEwMTczOC82ZTZhNDkzMmIwZjU2OWIxYTViYjRmY2JmNWRkZTFi
MWE0MmYwMWJiL3ZtbGludXotMy4xMi4wLXJjNC0wMDAwOC1nNmU2YTQ5MyAtYXBwZW5kICdo
dW5nX3Rhc2tfcGFuaWM9MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcgYXBpYz1k
ZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxlZCBwYW5pYz0xMCAgcHJvbXB0X3JhbWRpc2s9MCBj
b25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9vdD0vZGV2
L3JhbTAgcncgbGluaz0va2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRj
b25maWctczEtMDExMDE3MzgvbmV4dDptYXN0ZXI6NmU2YTQ5MzJiMGY1NjliMWE1YmI0ZmNi
ZjVkZGUxYjFhNDJmMDFiYjpiaXNlY3QtbW0vLnZtbGludXotNmU2YTQ5MzJiMGY1NjliMWE1
YmI0ZmNiZjVkZGUxYjFhNDJmMDFiYi0yMDE0MDExMzAyMjcwMS0xMDAtY2Fpcm8gYnJhbmNo
PW5leHQvbWFzdGVyIEJPT1RfSU1BR0U9L2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
MTEwMTczOC82ZTZhNDkzMmIwZjU2OWIxYTViYjRmY2JmNWRkZTFiMWE0MmYwMWJiL3ZtbGlu
dXotMy4xMi4wLXJjNC0wMDAwOC1nNmU2YTQ5MycgIC1pbml0cmQgL2tlcm5lbC10ZXN0cy9p
bml0cmQvcXVhbnRhbC1jb3JlLXg4Nl82NC5jZ3ogLW0gMjU2TSAtc21wIDIgLW5ldCBuaWMs
dmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFuPTEsaG9zdGZ3ZD10Y3A6OjE0Nzg4
LToyMiAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRvZyBpNjMwMGVzYiAtcnRj
IGJhc2U9bG9jYWx0aW1lIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazAtcXVhbnRh
bC1jYWlyby00OCxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9
S1ZNL2Rpc2sxLXF1YW50YWwtY2Fpcm8tNDgsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZl
IGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrMi1xdWFudGFsLWNhaXJvLTQ4LG1lZGlhPWRpc2ss
aWY9dmlydGlvIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazMtcXVhbnRhbC1jYWly
by00OCxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rp
c2s0LXF1YW50YWwtY2Fpcm8tNDgsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9
L2ZzL0xBQkVMPUtWTS9kaXNrNS1xdWFudGFsLWNhaXJvLTQ4LG1lZGlhPWRpc2ssaWY9dmly
dGlvIC1waWRmaWxlIC9kZXYvc2htL2tib290L3BpZC1xdWFudGFsLWNhaXJvLTQ4IC1zZXJp
YWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1jYWlyby00OCAtZGFlbW9u
aXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tlcm5lbC94ODZfNjQtcmFuZGNv
bmZpZy1zMS0wMTEwMTczOC82ZTZhNDkzMmIwZjU2OWIxYTViYjRmY2JmNWRkZTFiMWE0MmYw
MWJiL2RtZXNnLXF1YW50YWwtY2Fpcm8tNDg6MjAxNDAxMTMwMjM3NDk6eDg2XzY0LXJhbmRj
b25maWctczEtMDExMDE3Mzg6My4xMi4wLXJjNC0wMDAwOC1nNmU2YTQ5Mzo2MTQKL2tlcm5l
bC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOC82ZTZhNDkzMmIwZjU2OWIxYTViYjRm
Y2JmNWRkZTFiMWE0MmYwMWJiL2RtZXNnLXF1YW50YWwteGlhbi0xMjoyMDE0MDExMzAyMzc0
NDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczODozLjEyLjAtcmM0LTAwMDA4LWc2ZTZh
NDkzOjYxNAova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4LzZlNmE0OTMy
YjBmNTY5YjFhNWJiNGZjYmY1ZGRlMWIxYTQyZjAxYmIvZG1lc2cteW9jdG8teGlhbi0yNDoy
MDE0MDExMzAyMzc0NDp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczODozLjEyLjAtcmM0
LTAwMDA4LWc2ZTZhNDkzOjYxNAowOjM6MyBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwoK
QmlzZWN0aW5nOiAzIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSAyIHN0ZXBzKQpbNWJmY2U1ZWY1NWNiZTc4ZWUyZWU2ZTk3ZjJlMjZhOGE1ODIwMDhmM10g
eDg2LCBrYXNscjogUHJvdmlkZSByYW5kb21uZXNzIGZ1bmN0aW9ucwpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTAxMTAxNzM4L25leHQ6bWFzdGVyOjViZmNlNWVmNTVjYmU3OGVlMmVlNmU5
N2YyZTI2YThhNTgyMDA4ZjM6YmlzZWN0LW1tCgoyMDE0LTAxLTEzLTAyOjM4OjA2IDViZmNl
NWVmNTVjYmU3OGVlMmVlNmU5N2YyZTI2YThhNTgyMDA4ZjMgY29tcGlsaW5nCjE5NSByZWFs
ICAxNTMxIHVzZXIgIDE0NiBzeXMgIDg1OC4zNSUgY3B1IAl4ODZfNjQtcmFuZGNvbmZpZy1z
MS0wMTEwMTczOAoKMjAxNC0wMS0xMy0wMjo0MTo0MCBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAz
LjEyLjAtcmM0LTAwMDA0LWc1YmZjZTVlLi4uCTEJMgkzCTguLgkxNS4uLgkxNgkxNy4JMTkJ
MjAJMjIuLi4uCTI0Li4uLi4uLgkyNi4uLgkzMAkzMwkzOQk0OAk1Mi4JNTcJNjIJNjQJNjcJ
NzEJNzIuCTc4Lgk4MC4uCTgyCTg0CTg5Li4JOTAJOTEuCTk0Lgk5NQk5Ny4uCTk4CTEwMy4u
CTEwOS4uLi4JMTEyCTExNS4JMTE3CTExOAkxMjAuLgkxMjEJMTIyCTEyNAkxMzUJMTM4CTE0
Ny4JMTQ4CTE0OQkxNTIJMTU1LgkxNjEJMTY3CTE2OAkxNzMJMTc5CTE4MS4JMTgzCTE4OQkx
OTcJMjA2CTIwOAkyMDkuLi4uCTIxMC4JMjE2CTIyNQkyMjgJMjMwCTIzOAkyMzkJMjQ2CTI0
OC4JMjU2LgkyNTkuLgkyNjAuLi4uLgkyNjEuLi4JMjY3Li4uLi4JMjc1LgkyNzYJMjgwCTI4
NwkyODguLi4uCTI5OAkzMDEuLgkzMDIJMzA0LgkzMDgJMzE1CTMxNgkzMjAJMzI3CTMzMi4J
MzMzCTMzNQkzNDAJMzQ3CTM0OAkzNTcJMzY3CTM2OQkzNzguCTM3OS4uCTM4MC4JMzgyLi4u
LgkzODUJMzg4Li4JMzg5Li4uLi4JMzkwLgkzOTIJMzk0Li4uLgkzOTUuCTQwMAk0MDMJNDA3
CTQxMi4uLi4uLi4JNDEzCTQxNgk0MTcJNDIxCTQyMwk0MjUuLi4uLgk0MzAJNDMyCTQzMy4J
NDM0CTQzNi4uLi4JNDM4CTQzOQk0NDAJNDQxCTQ0NQk0NTEJNDUyCTQ1Mwk0NTcuLgk0NTkJ
NDYyCTQ2NQk0NjkJNDcxCTQ3Mgk0NzUJNDc3CTQ4MAk0ODEuLgk0ODQJNDg3CTQ5NAk0OTYJ
NDk3CTQ5OAk1MDAuLgk1MDQJNTA1CTUxMC4JNTExCTUxOC4JNTIwLi4JNTIxCTUyNC4uLgk1
MjUJNTI2CTUyOAk1MjkJNTMwCTUzNC4uCTUzOQk1NDEJNTQzLi4uLgk1NDUJNTQ2Li4uCTU0
OQk1NTAuLgk1NTQJNTU5CTU2NAk1NjUuCTU2Ngk1NjcJNTY5CTU3Mgk1NzMJNTc1CTU4Mgk1
ODMJNTg1Li4uLi4uLi4uLi4uLi4uCTU5MAk1OTMuLi4JNTk1CTU5OQk2MDAJNjA4Lgk2MTAJ
NjEyCTYxNAk2MTUuLi4uLgk2MTYJNjE3Lgk2MTkuCTYyMAk2MjEJNjIzLgk2MjUJNjI2CTYy
Nwk2MjguLgk2MjkuLi4JNjMyCTYzNC4JNjM3CTYzOC4uCTY0MC4uLi4uCTY0NS4JNjUwCTY1
Mgk2NTcJNjY0Lgk2NjUJNjY2CTY2Nwk2NzAuLgk2NzIJNjc1CTY4Mgk2OTIJNjk4CTcwMAk3
MDEJNzA2Li4uLi4JNzA4CTcwOS4JNzEzCTcxNC4JNzI4CTcyOS4JNzMwCTczMS4uLgk3MzIJ
NzM0CTczNwk3MzgJNzQyLi4uLi4uCTc0Ngk3NTAJNzU5CTc2Nwk3NzMJNzc1CTc4MQk3ODYJ
Nzg5CTc5MQk3OTYuCTgwMwk4MDUJODA4CTgxMAk4MTEJODE1CTgxNgk4MjMJODI0Li4uCTgy
NS4uCTgyNi4uCTgzMAk4MzMJODM2Lgk4MzcuLi4JODQyLi4JODQ0CTg0NS4uCTg0Ngk4NTUJ
ODYwCTg2Mwk4NjYJODY3CTg3MAk4NzIuLgk4NzUuCTg3Ny4JODc4Li4uLi4JODgyLi4JODg0
CTg5MQk4OTQuLgk4OTUuCTg5OS4JOTAwLgk5MDMJOTA1CTkwOQk5MTAuCTkxMi4uCTkxMwk5
MTguLi4uCTkyMC4JOTIxLgk5MjMJOTI0CTkyNS4JOTI3CTkzMgk5NDAJOTQzCTk0Ngk5NDcJ
OTUxCTk1Ny4JOTYwCTk2Mgk5NjcJOTY4CTk3MC4JOTcyCTk3NQk5NzcJOTc5CTk4MAk5ODIJ
OTgzCTk4NQk5ODYJOTg4CTk5NAk5OTUuLi4uLi4uLi4JOTk2Li4uLgkxMDAwIFNVQ0NFU1MK
CkJpc2VjdGluZzogMSByZXZpc2lvbiBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hs
eSAxIHN0ZXApCltmMzIzNjBlZjY2MDg0MzRhMDMyZGM3YWQyNjJkNDVlOTY5M2MyN2YzXSB4
ODYsIGthc2xyOiBSZXBvcnQga2VybmVsIG9mZnNldCBvbiBwYW5pYwpydW5uaW5nIC9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2hvbWUvd2ZnL21tL29i
ai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL3g4Nl82NC1yYW5k
Y29uZmlnLXMxLTAxMTAxNzM4L25leHQ6bWFzdGVyOmYzMjM2MGVmNjYwODQzNGEwMzJkYzdh
ZDI2MmQ0NWU5NjkzYzI3ZjM6YmlzZWN0LW1tCgoyMDE0LTAxLTEzLTA3OjM1OjA0IGYzMjM2
MGVmNjYwODQzNGEwMzJkYzdhZDI2MmQ0NWU5NjkzYzI3ZjMgY29tcGlsaW5nCjEwOSByZWFs
ICAxMTIgdXNlciAgMjAgc3lzICAxMjEuMjUlIGNwdSAJeDg2XzY0LXJhbmRjb25maWctczEt
MDExMDE3MzgKCjIwMTQtMDEtMTMtMDc6Mzc6MjEgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
Mi4wLXJjNC0wMDAwNi1nZjMyMzYwZS4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uIFRFU1QgRkFJ
TFVSRQpbICAgIDAuMDAwMDAwXSBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIgTm90IHRh
aW50ZWQgMy4xMi4wLXJjNC0wMDAwNi1nZjMyMzYwZSAjNjE2ClBBTklDOiBlYXJseSBleGNl
cHRpb24gMGUgcmlwIDEwOmZmZmZmZmZmOGFjMDRmMjIgZXJyb3IgMCBjcjIgZmZmZmZmZmY4
MTk3MmIyOAoKQlVHOiBrZXJuZWwgYm9vdCBoYW5nCkVsYXBzZWQgdGltZTogNjEwCnFlbXUt
c3lzdGVtLXg4Nl82NCAtY3B1IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tlcm5lbC94
ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOC9mMzIzNjBlZjY2MDg0MzRhMDMyZGM3YWQy
NjJkNDVlOTY5M2MyN2YzL3ZtbGludXotMy4xMi4wLXJjNC0wMDAwNi1nZjMyMzYwZSAtYXBw
ZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXByaW50az10dHlTMCwxMTUyMDAgZGVidWcg
YXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxlZCBwYW5pYz0xMCAgcHJvbXB0X3JhbWRp
c2s9MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdhPW5vcm1hbCAgcm9v
dD0vZGV2L3JhbTAgcncgbGluaz0va2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0
LXJhbmRjb25maWctczEtMDExMDE3MzgvbmV4dDptYXN0ZXI6ZjMyMzYwZWY2NjA4NDM0YTAz
MmRjN2FkMjYyZDQ1ZTk2OTNjMjdmMzpiaXNlY3QtbW0vLnZtbGludXotZjMyMzYwZWY2NjA4
NDM0YTAzMmRjN2FkMjYyZDQ1ZTk2OTNjMjdmMy0yMDE0MDExMzA3MzcxNy0xMDAtaW5uIGJy
YW5jaD1uZXh0L21hc3RlciBCT09UX0lNQUdFPS9rZXJuZWwveDg2XzY0LXJhbmRjb25maWct
czEtMDExMDE3MzgvZjMyMzYwZWY2NjA4NDM0YTAzMmRjN2FkMjYyZDQ1ZTk2OTNjMjdmMy92
bWxpbnV6LTMuMTIuMC1yYzQtMDAwMDYtZ2YzMjM2MGUnICAtaW5pdHJkIC9rZXJuZWwtdGVz
dHMvaW5pdHJkL3F1YW50YWwtY29yZS14ODZfNjQuY2d6IC1tIDI1Nk0gLXNtcCAyIC1uZXQg
bmljLHZsYW49MSxtb2RlbD1lMTAwMCAtbmV0IHVzZXIsdmxhbj0xLGhvc3Rmd2Q9dGNwOjo5
OTU3LToyMiAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRvZyBpNjMwMGVzYiAt
cnRjIGJhc2U9bG9jYWx0aW1lIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazAtcXVh
bnRhbC1pbm4tNCxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9
S1ZNL2Rpc2sxLXF1YW50YWwtaW5uLTQsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZp
bGU9L2ZzL0xBQkVMPUtWTS9kaXNrMi1xdWFudGFsLWlubi00LG1lZGlhPWRpc2ssaWY9dmly
dGlvIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazMtcXVhbnRhbC1pbm4tNCxtZWRp
YT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2s0LXF1YW50
YWwtaW5uLTQsbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtW
TS9kaXNrNS1xdWFudGFsLWlubi00LG1lZGlhPWRpc2ssaWY9dmlydGlvIC1waWRmaWxlIC9k
ZXYvc2htL2tib290L3BpZC1xdWFudGFsLWlubi00IC1zZXJpYWwgZmlsZTovZGV2L3NobS9r
Ym9vdC9zZXJpYWwtcXVhbnRhbC1pbm4tNCAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1v
bml0b3IgbnVsbCAKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOC9mMzIz
NjBlZjY2MDg0MzRhMDMyZGM3YWQyNjJkNDVlOTY5M2MyN2YzL2RtZXNnLXF1YW50YWwtaW5u
LTQ6MjAxNDAxMTMwNzQ4MDk6eDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3Mzg6My4xMi4w
LXJjNC0wMDAwNi1nZjMyMzYwZTo2MTYKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0w
MTEwMTczOC9mMzIzNjBlZjY2MDg0MzRhMDMyZGM3YWQyNjJkNDVlOTY5M2MyN2YzL2RtZXNn
LXF1YW50YWwtamFrZXRvd24tMTc6MjAxNDAxMTMwNzQ4MDk6eDg2XzY0LXJhbmRjb25maWct
czEtMDExMDE3Mzg6My4xMi4wLXJjNC0wMDAwNi1nZjMyMzYwZTo2MTYKL2tlcm5lbC94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOC9mMzIzNjBlZjY2MDg0MzRhMDMyZGM3YWQyNjJk
NDVlOTY5M2MyN2YzL2RtZXNnLXF1YW50YWwtcm9hbS0zODoyMDE0MDExMzA3NDgxMTp4ODZf
NjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczODozLjEyLjAtcmM0LTAwMDA2LWdmMzIzNjBlOjYx
Ngova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4L2YzMjM2MGVmNjYwODQz
NGEwMzJkYzdhZDI2MmQ0NWU5NjkzYzI3ZjMvZG1lc2ctcXVhbnRhbC1zbmItNDg6MjAxNDAx
MTMwNzQ3NTc6eDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3Mzg6My4xMi4wLXJjNC0wMDAw
Ni1nZjMyMzYwZTo2MTYKMDo0OjQgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKCkJpc2Vj
dGluZzogMCByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMCBz
dGVwcykKWzgyZmE5NjM3YTJiYTI4NWJjYzdjNTA1MGM3MzAxMGIyYzFiM2Q4MDNdIHg4Niwg
a2FzbHI6IFNlbGVjdCByYW5kb20gcG9zaXRpb24gZnJvbSBlODIwIG1hcHMKcnVubmluZyAv
Yy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9ob21lL3dmZy9t
bS9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wMTEwMTczOC9uZXh0Om1hc3Rlcjo4MmZhOTYzN2EyYmEyODViY2M3
YzUwNTBjNzMwMTBiMmMxYjNkODAzOmJpc2VjdC1tbQoKMjAxNC0wMS0xMy0wNzo0ODo1MyA4
MmZhOTYzN2EyYmEyODViY2M3YzUwNTBjNzMwMTBiMmMxYjNkODAzIGNvbXBpbGluZwozNyBy
ZWFsICAxMTcgdXNlciAgMjAgc3lzICAzNjkuNzYlIGNwdSAJeDg2XzY0LXJhbmRjb25maWct
czEtMDExMDE3MzgKCjIwMTQtMDEtMTMtMDc6NDk6NTIgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
My4xMi4wLXJjNC0wMDAwNS1nODJmYTk2My4uLi4uLi4uLi4uCTEuLi4uLi4uLi4gVEVTVCBG
QUlMVVJFClsgICAgMC4wMDAwMDBdIENQVTogMCBQSUQ6IDAgQ29tbTogc3dhcHBlciBOb3Qg
dGFpbnRlZCAzLjEyLjAtcmM0LTAwMDA1LWc4MmZhOTYzICM2MTcKUEFOSUM6IGVhcmx5IGV4
Y2VwdGlvbiAwZSByaXAgMTA6ZmZmZmZmZmY4OTgwNGYyMiBlcnJvciAwIGNyMiBmZmZmZmZm
ZjgxOTcyYjI4CgpCVUc6IGtlcm5lbCBib290IGhhbmcKRWxhcHNlZCB0aW1lOiA2MTAKcWVt
dS1zeXN0ZW0teDg2XzY0IC1jcHUga3ZtNjQgLWVuYWJsZS1rdm0gLWtlcm5lbCAva2VybmVs
L3g4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4LzgyZmE5NjM3YTJiYTI4NWJjYzdjNTA1
MGM3MzAxMGIyYzFiM2Q4MDMvdm1saW51ei0zLjEyLjAtcmM0LTAwMDA1LWc4MmZhOTYzIC1h
cHBlbmQgJ2h1bmdfdGFza19wYW5pYz0xIGVhcmx5cHJpbnRrPXR0eVMwLDExNTIwMCBkZWJ1
ZyBhcGljPWRlYnVnIHN5c3JxX2Fsd2F5c19lbmFibGVkIHBhbmljPTEwICBwcm9tcHRfcmFt
ZGlzaz0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICBy
b290PS9kZXYvcmFtMCBydyBsaW5rPS9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOC9uZXh0Om1hc3Rlcjo4MmZhOTYzN2EyYmEyODVi
Y2M3YzUwNTBjNzMwMTBiMmMxYjNkODAzOmJpc2VjdC1tbS8udm1saW51ei04MmZhOTYzN2Ey
YmEyODViY2M3YzUwNTBjNzMwMTBiMmMxYjNkODAzLTIwMTQwMTEzMDc0OTQ5LTEwLWF0aGVu
cyBicmFuY2g9bmV4dC9tYXN0ZXIgQk9PVF9JTUFHRT0va2VybmVsL3g4Nl82NC1yYW5kY29u
ZmlnLXMxLTAxMTAxNzM4LzgyZmE5NjM3YTJiYTI4NWJjYzdjNTA1MGM3MzAxMGIyYzFiM2Q4
MDMvdm1saW51ei0zLjEyLjAtcmM0LTAwMDA1LWc4MmZhOTYzJyAgLWluaXRyZCAva2VybmVs
LXRlc3RzL2luaXRyZC9xdWFudGFsLWNvcmUteDg2XzY0LmNneiAtbSAyNTZNIC1zbXAgMiAt
bmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSxob3N0ZndkPXRj
cDo6MTE2NzUtOjIyIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3QgLXdhdGNoZG9nIGk2MzAw
ZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNr
MC1xdWFudGFsLWF0aGVucy0xNixtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0v
ZnMvTEFCRUw9S1ZNL2Rpc2sxLXF1YW50YWwtYXRoZW5zLTE2LG1lZGlhPWRpc2ssaWY9dmly
dGlvIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazItcXVhbnRhbC1hdGhlbnMtMTYs
bWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrMy1x
dWFudGFsLWF0aGVucy0xNixtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMv
TEFCRUw9S1ZNL2Rpc2s0LXF1YW50YWwtYXRoZW5zLTE2LG1lZGlhPWRpc2ssaWY9dmlydGlv
IC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazUtcXVhbnRhbC1hdGhlbnMtMTYsbWVk
aWE9ZGlzayxpZj12aXJ0aW8gLXBpZGZpbGUgL2Rldi9zaG0va2Jvb3QvcGlkLXF1YW50YWwt
YXRoZW5zLTE2IC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1h
dGhlbnMtMTYgLWRhZW1vbml6ZSAtZGlzcGxheSBub25lIC1tb25pdG9yIG51bGwgCi9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3MzgvODJmYTk2MzdhMmJhMjg1YmNjN2M1
MDUwYzczMDEwYjJjMWIzZDgwMy9kbWVzZy1xdWFudGFsLWF0aGVucy0xNjoyMDE0MDExMzA4
MDAxMTp4ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczODozLjEyLjAtcmM0LTAwMDA1LWc4
MmZhOTYzOjYxNwova2VybmVsL3g4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4LzgyZmE5
NjM3YTJiYTI4NWJjYzdjNTA1MGM3MzAxMGIyYzFiM2Q4MDMvZG1lc2ctcXVhbnRhbC1hdGhl
bnMtMjY6MjAxNDAxMTMwODAwMTE6eDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3Mzg6My4x
Mi4wLXJjNC0wMDAwNS1nODJmYTk2Mzo2MTcKMToyOjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQg
Ym9vdHMKCjgyZmE5NjM3YTJiYTI4NWJjYzdjNTA1MGM3MzAxMGIyYzFiM2Q4MDMgaXMgdGhl
IGZpcnN0IGJhZCBjb21taXQKY29tbWl0IDgyZmE5NjM3YTJiYTI4NWJjYzdjNTA1MGM3MzAx
MGIyYzFiM2Q4MDMKQXV0aG9yOiBLZWVzIENvb2sgPGtlZXNjb29rQGNocm9taXVtLm9yZz4K
RGF0ZTogICBUaHUgT2N0IDEwIDE3OjE4OjE2IDIwMTMgLTA3MDAKCiAgICB4ODYsIGthc2xy
OiBTZWxlY3QgcmFuZG9tIHBvc2l0aW9uIGZyb20gZTgyMCBtYXBzCiAgICAKICAgIENvdW50
cyBhdmFpbGFibGUgYWxpZ25tZW50IHBvc2l0aW9ucyBhY3Jvc3MgYWxsIGU4MjAgbWFwcywg
YW5kIGNob29zZXMKICAgIG9uZSByYW5kb21seSBmb3IgdGhlIG5ldyBrZXJuZWwgYmFzZSBh
ZGRyZXNzLCBtYWtpbmcgc3VyZSBub3QgdG8gY29sbGlkZQogICAgd2l0aCB1bnNhZmUgbWVt
b3J5IGFyZWFzLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBLZWVzIENvb2sgPGtlZXNjb29r
QGNocm9taXVtLm9yZz4KICAgIExpbms6IGh0dHA6Ly9sa21sLmtlcm5lbC5vcmcvci8xMzgx
NDUwNjk4LTI4NzEwLTUtZ2l0LXNlbmQtZW1haWwta2Vlc2Nvb2tAY2hyb21pdW0ub3JnCiAg
ICBTaWduZWQtb2ZmLWJ5OiBILiBQZXRlciBBbnZpbiA8aHBhQGxpbnV4LmludGVsLmNvbT4K
CjowNDAwMDAgMDQwMDAwIDA5Y2U5YmE0NjdhMDIzNGVkYjBlN2MzM2JjZDdiNzY3Yzc3Zjgx
ZjMgMTU0ODQ5Zjc2MzMyYjQ4NWU0MGZkNzMxNTJlMDIyYWZhZGYwODk0NyBNCWFyY2gKYmlz
ZWN0IHJ1biBzdWNjZXNzCmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZf
NjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOC9uZXh0Om1hc3Rlcjo1YmZjZTVlZjU1Y2JlNzhl
ZTJlZTZlOTdmMmUyNmE4YTU4MjAwOGYzOmJpc2VjdC1tbQoKMjAxNC0wMS0xMy0wODowMDoy
OSA1YmZjZTVlZjU1Y2JlNzhlZTJlZTZlOTdmMmUyNmE4YTU4MjAwOGYzIHJldXNlIC9rZXJu
ZWwveDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3MzgvNWJmY2U1ZWY1NWNiZTc4ZWUyZWU2
ZTk3ZjJlMjZhOGE1ODIwMDhmMy92bWxpbnV6LTMuMTIuMC1yYzQtMDAwMDQtZzViZmNlNWUK
CjIwMTQtMDEtMTMtMDg6MDA6MzMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLgkxLgkyCTMJNC4u
Li4uLgk1CTYuCTcJOQkxMQkxNAkxOC4JMTkJMjAuLgkyMQkyMwkyNAkzMAkzMS4uCTMyLi4u
Li4uCTMzCTM5CTQwCTQzCTQ2CTQ5CTU0Lgk1Ngk2MC4JNjEJNjQuLi4uCTcwLgk3MQk3NQk3
OQk4MC4JODEJODUuLgk5MAk5Mi4JOTUJOTYJOTcuLi4JMTAwLgkxMDEuLi4uLi4uCTEwMwkx
MDUJMTA4CTExMC4JMTExCTExMgkxMTQJMTE3CTExOS4uLi4uLgkxMjAuLgkxMjEJMTIyLi4J
MTI4CTEzNAkxMzkJMTQzCTE0NgkxNDguCTE0OQkxNTEJMTU4CTE2MQkxNjIJMTYzLgkxNjUJ
MTY3LgkxNzIJMTc0CTE3NQkxNzkJMTg4Li4uCTE5Ni4JMjAwCTIwMS4JMjA5CTIxMQkyMTMJ
MjE1CTIxNy4uCTIxOQkyMjEuCTIzMAkyMzEuLi4uLi4uLgkyMzQJMjM1LgkyMzYuLi4JMjM3
CTIzOC4JMjM5CTI0MC4uCTI0MQkyNDQJMjQ3CTI0OQkyNTIJMjU2CTI1OAkyNjAJMjY4Li4u
LgkyNjkuCTI3MwkyNzkJMjgyCTI4Ny4JMjk0CTMwNi4uLi4uLi4JMzEwCTMxMS4JMzE4CTMy
MQkzMjMJMzI1CTMzNQkzMzYuLgkzMzcuLi4JMzQwLgkzNDEuCTM0OQkzNTEJMzUyCTM1NQkz
NjUJMzY2CTM3MAkzNzEJMzcyCTM3Ni4uLgkzODEJMzg1LgkzODYJMzkwCTM5NC4uCTM5NS4J
Mzk3Lgk0MDEJNDAyLi4JNDA1Lgk0MDkuLgk0MTQuCTQxNQk0MjAJNDIzLi4uCTQyNQk0MzAJ
NDM0CTQzNwk0NDAJNDQyCTQ0NAk0NDUJNDQ2CTQ0OAk0NTIJNDUzLi4JNDYxCTQ3NAk0NzUJ
NDc3CTQ4Mwk0ODQuLi4uLgk0OTAuLi4uCTQ5NS4uLgk0OTgJNTEwCTUxOAk1MTkuCTUyMC4u
Li4uLi4JNTQxCTU1MAk1NTIJNTU4CTU2MAk1NjQJNTY3Lgk1NzYJNTc5CTU4Nwk1OTEJNTk0
CTU5Ngk2MDAuCTYwMgk2MTcJNjI0CTYyNQk2MjgJNjMwLgk2NDEJNjQ1CTY1NS4JNjc3Lgk2
ODcJNzA1CTcxNQk3MjkJNzQzCTc1Mgk3NTcJNzY5CTc4MAk3ODYJNzkwCTgwMgk4MjAJODMx
CTgzOAk4NDgJODU0CTg1Ngk4NjYJODgzCTg5Ngk5MDUJOTE4CTkyOQk5NDAJOTUzCTk2Mwk5
NzIJOTc1CTk3OAk5ODAJOTg5Lgk5OTAJOTk2CTk5Ny4JMTAxMgkxMDI4CTEwNTMJMTA2NAkx
MDg2CTExMTcJMTEzNAkxMTUyCTExODMJMTIwOAkxMjM3CTEyNDcJMTI3MgkxMjg1CTEyOTgJ
MTMwMAkxMzAzCTEzMDQJMTMwNQkxMzA2CTEzMTYJMTMyNgkxMzI3CTEzMzUJMTM0NAkxMzU2
CTEzNjAuCTEzNjIuLgkxMzY0CTEzNjcJMTM3My4uCTEzNzQJMTM3OQkxMzgyCTEzODMJMTM4
NwkxMzk3CTE0MDAJMTQwMgkxNDAzLi4uCTE0MTAJMTQxMQkxNDEyCTE0MTMJMTQxNwkxNDIx
Li4JMTQzNgkxNDM3CTE0NDMJMTQ0NC4uCTE0NTAuCTE0NTMJMTQ2MQkxNDY0Li4uCTE0NjUJ
MTQ2Ni4uLi4JMTQ2NwkxNDY4Li4JMTQ3MAkxNDc0CTE0NzUuCTE0NzcuCTE0ODcJMTQ5Ngkx
NTAxCTE1MDQJMTUxMgkxNTEzCTE1MTkuLi4uCTE1MjEuCTE1MjUuCTE1MjYuLgkxNTI3CTE1
MjkuCTE1MzEuCTE1MzIJMTUzNS4uLgkxNTM2Li4JMTUzNy4uCTE1NDQJMTU0Ni4uLi4uLgkx
NTQ5CTE1NTMuLi4uLgkxNTU0LgkxNTU4LgkxNTYwLi4uLi4uCTE1NjEuCTE1NjMJMTU2NC4J
MTU2NgkxNTY4CTE1NjkuLi4uCTE1NzAuCTE1NzEuLgkxNTcyLi4uLgkxNTczCTE1NzQJMTU3
OAkxNTc5CTE1ODQJMTU5MgkxNTkzLi4uLi4uLi4JMTU5NAkxNTk1CTE1OTcJMTYwMS4uCTE2
MDMuLi4uCTE2MDQJMTYwNS4JMTYwNy4uCTE2MTAJMTYxMgkxNjE5LgkxNjI5Li4JMTYzMC4u
Li4uLi4JMTYzMQkxNjMzCTE2MzUuCTE2MzgJMTY0MQkxNjQ0CTE2NDUuLgkxNjQ2Li4uCTE2
NDguLi4uCTE2NTAuLi4uLi4uLi4uLgkxNjUxLgkxNjU1CTE2NTYJMTY2MwkxNjY2Li4JMTY3
MAkxNjg3CTE2OTAJMTY5OAkxNzAwLgkxNzAzLi4uLgkxNzEwCTE3MTUJMTcxNgkxNzE3Lgkx
NzIxCTE3MjQuLi4uCTE3MjYuCTE3MzAJMTczMwkxNzM2CTE3MzcuLi4JMTc0MQkxNzQzCTE3
NDQuCTE3NDcJMTc0OQkxNzYwLi4uLgkxNzYxLgkxNzYyLi4JMTc2NAkxNzY2CTE3NzEJMTc3
MgkxNzc1CTE3NzcuLi4JMTc4MgkxNzg5CTE3OTYJMTgwMAkxODAxLi4JMTgwNAkxODExLgkx
ODEyCTE4MTUJMTgyMy4JMTgyNAkxODI3CTE4MjgJMTgyOS4uLi4uLi4JMTgzMi4JMTgzMwkx
ODM3CTE4MzkJMTg0MgkxODU0CTE4NTYJMTg2MS4uCTE4NjIuLi4JMTg2My4uCTE4NjQuLgkx
ODY1CTE4OTIJMTg5NS4JMTg5Ni4JMTg5NwkxODk4CTE4OTkuLi4JMTkwNQkxOTA2LgkxOTEw
CTE5MTQuLi4JMTkyMQkxOTI2CTE5MzAJMTkzMS4uCTE5MzUuCTE5MzYJMTkzNy4JMTkzOAkx
OTM5LgkxOTQ5CTE5NTIuLi4JMTk1My4JMTk1NAkxOTYxCTE5NjIJMTk2NwkxOTY4CTE5Njku
Li4JMTk3MgkxOTc2CTE5ODAuCTE5ODEuLi4JMTk5MS4uCTE5OTIJMTk5OC4JMjAwMAkyMDAx
CTIwMDQJMjAwNgkyMDA3CTIwMDgJMjAxMC4JMjAxNgkyMDE4Li4uLi4JMjAyMy4uLgkyMDI2
Li4JMjAyOAkyMDMwCTIwMzQJMjAzNwkyMDM4CTIwNDIJMjA1Mi4uLgkyMDU1CTIwNTYJMjA1
OQkyMDYxCTIwNjIJMjA2NAkyMDY1Li4JMjA2Ny4JMjA2OAkyMDY5Li4uLi4uCTIwNzIJMjA3
Ni4uCTIwNzcJMjA3OS4JMjA4MwkyMDg3CTIwODkJMjA5MAkyMDkzCTIxMDMJMjEwNQkyMTA2
LgkyMTEwCTIxMTEJMjExMgkyMTE1CTIxMjIJMjEyMwkyMTI1CTIxMjYJMjEzMAkyMTMxLi4u
CTIxMzMJMjEzNgkyMTM3Li4JMjE0MC4uCTIxNDEuLi4uLgkyMTQyCTIxNDMJMjE0NC4uLi4u
Li4JMjE0NS4JMjE1MAkyMTUxCTIxNTMuLi4uLi4uLgkyMTU5CTIxNjguCTIxODMuLi4uLi4u
CTIxODYuCTIxODkJMjE5Mi4JMjE5MwkyMTk1CTIxOTYJMjIwNy4JMjIyNi4uCTIyNzQuLgky
MzI3CTIzMzIuCTIzMzQuLgkyMzM3CTIzNDAuLi4uLi4uLi4uLi4uLi4JMjM0Mi4uCTIzNDcJ
MjM0OAkyMzQ5CTIzNTAJMjM1MgkyMzUzLgkyMzU2CTIzNjAuLi4uLi4uLi4uLi4JMjM2Mwky
MzY0LgkyMzY1CTIzNjYJMjM2OC4uLi4JMjM2OS4uLi4uLi4uLi4uLi4uLgkyMzgwCTIzODQu
Li4JMjM4NQkyMzg3CTIzODgJMjM5Mi4JMjM5NAkyMzk1CTIzOTgJMjQwMC4uLgkyNDAyCTI0
MDQuLi4uLi4uLi4uLi4uLi4uLi4uLi4JMjQxMwkyNDE1CTI0MTcJMjQyMgkyNDI0Li4uLgky
NDI1LgkyNDM1Li4JMjQzOS4uLi4JMjQ0Mi4uCTI0NDMJMjQ0NS4uCTI0NDYuLi4uLi4JMjQ1
NgkyNDU3Li4JMjQ1OC4JMjQ1OS4uCTI0NjEJMjQ2Mi4JMjQ2My4JMjQ2NAkyNDY2CTI0NzEJ
MjQ3NQkyNDgyCTI0ODMJMjQ4Ny4JMjQ5MS4uLi4uLgkyNDkyLgkyNDk0Li4JMjQ5NgkyNDk3
LgkyNDk4Li4uLgkyNTA2CTI1MTAJMjUxNC4JMjUxNi4uCTI1MTcJMjUyNAkyNTI2CTI1Mjcu
LgkyNTI4CTI1MjkJMjUzMC4uLi4uLgkyNTM0CTI1MzUJMjU0MC4JMjU0Mi4JMjU0NC4uLi4u
Li4uCTI1NDUJMjU0NgkyNTQ3CTI1NDguCTI1NTEJMjU1OS4uCTI1NjIJMjU2NwkyNTY5Li4u
Li4JMjU3MwkyNTc1Li4uLgkyNTc5LgkyNTgzCTI1ODUJMjU4Ni4uCTI1ODcuLi4JMjU5MC4u
Li4JMjU5MgkyNTkzLi4uLi4JMjU5Ni4JMjU5OAkyNjAwCTI2MDEJMjYwMy4JMjYwNi4JMjYx
MAkyNjE0CTI2MTYJMjYxOS4JMjYyMgkyNjI1Li4uCTI2MjYuLi4JMjYyNy4JMjYyOAkyNjMx
CTI2MzMJMjYzNAkyNjM4CTI2NDAuCTI2NDEJMjY0NwkyNjUyCTI2NTUuCTI2NTcuCTI2NTgu
CTI2NjQuCTI2NjcJMjY2OAkyNjczCTI2NzQJMjY3NgkyNjc3CTI2ODMuCTI2ODYuCTI2ODcJ
MjY5MgkyNjkzCTI2OTUJMjY5OAkyNzAxCTI3MDIJMjcwMy4JMjcwNAkyNzA3Li4uLi4uLi4J
MjcwOC4JMjcxMgkyNzE0CTI3MTUuLgkyNzE4Li4uCTI3MjIJMjcyOC4JMjcyOS4uLi4uLi4J
MjczMy4JMjczOAkyNzM5CTI3NDEJMjc0MwkyNzUxCTI3NTIJMjc1My4uLi4uLi4uLi4uLi4u
Li4uLi4JMjc1NAkyNzU1CTI3NjEJMjc2NgkyNzY4LgkyNzcwCTI3NzEJMjc3Mi4JMjc3Mwky
Nzc1Li4JMjc3OC4uLgkyNzc5LgkyNzgwLi4uCTI3ODEuLi4JMjc4Mi4uLgkyNzgzCTI3OTEJ
Mjc5MwkyODAyCTI4MDYJMjgxMgkyODE1CTI4MTcJMjgyMi4JMjgyOAkyODI5CTI4MzAJMjgz
NAkyODM3CTI4MzgJMjg1OQkyODY2CTI4NzYJMjg4MAkyODgxLi4uLi4uLi4uLi4uLi4uLi4u
CTI4ODQJMjg4NgkyODg3Li4uLi4uLi4uLi4uLi4uCTI4ODgJMjg4OQkyODkyLi4uLgkyODk2
Li4uLi4JMjg5Ny4JMjkwMS4uCTI5MDMJMjkwNgkyOTEyCTI5MTYuCTI5MTkuCTI5MjIJMjky
NQkyOTI5CTI5MzMJMjkzNAkyOTM2LgkyOTM3CTI5MzgJMjkzOS4uCTI5NDEuCTI5NDIJMjk0
MwkyOTQ1CTI5NDkJMjk1MC4JMjk1MwkyOTU1CTI5NTgJMjk2MAkyOTY2CTI5NzAJMjk4NAky
OTg3CTI5OTEJMjk5NAkyOTk3CTI5OTgJMzAwMCBTVUNDRVNTCgpscyAtYSAva2VybmVsLXRl
c3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3MzgvbmV4dDpt
YXN0ZXI6MTk1NWExNGE1YmE2ZTNjM2IxMTExNzgxMmQxMWRjNTUwY2NjMzdhZTpiaXNlY3Qt
bW0KIFRFU1QgRkFJTFVSRQpbICAgIDAuOTcxNDA5XSBVbnBhY2tpbmcgaW5pdHJhbWZzLi4u
ClsgICAgMS4wODcxODhdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQpb
ICAgIDEuMDg3MTg4XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0KWyAg
ICAxLjA4OTk4NV0gV0FSTklORzogQ1BVOiAwIFBJRDogMSBhdCBrZXJuZWwvbG9ja2luZy9s
b2NrZGVwLmM6MzUzNyBjaGVja19mbGFncysweDdhLzB4MjAwKCkKL2tlcm5lbC94ODZfNjQt
cmFuZGNvbmZpZy1zMS0wMTEwMTczOC8xOTU1YTE0YTViYTZlM2MzYjExMTE3ODEyZDExZGM1
NTBjY2MzN2FlL2RtZXNnLXF1YW50YWwtamFrZXRvd24tMzA6MjAxNDAxMTAyMDE1MjA6eDg2
XzY0LXJhbmRjb25maWctczEtMDExMDE3Mzg6My4xMy4wLXJjNy1uZXh0LTIwMTQwMTEwLTA4
NzMyLWcxOTU1YTE0OjEKL2tlcm5lbC94ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOC8x
OTU1YTE0YTViYTZlM2MzYjExMTE3ODEyZDExZGM1NTBjY2MzN2FlL2RtZXNnLXF1YW50YWwt
eGd3by01OjIwMTQwMTEwMTgyNTQ2Ong4Nl82NC1yYW5kY29uZmlnLXMxLTAxMTAxNzM4OjMu
MTMuMC1yYzctbmV4dC0yMDE0MDExMC0wODczMi1nMTk1NWExNDoxCjA6Mjo4OSBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwoKW2RldGFjaGVkIEhFQUQgYTgxNWE1ZV0gUmV2ZXJ0ICJ4
ODYsIGthc2xyOiBTZWxlY3QgcmFuZG9tIHBvc2l0aW9uIGZyb20gZTgyMCBtYXBzIgogMyBm
aWxlcyBjaGFuZ2VkLCAxMzQgaW5zZXJ0aW9ucygrKSwgMzI3IGRlbGV0aW9ucygtKQogcmV3
cml0ZSBhcmNoL3g4Ni9ib290L2NvbXByZXNzZWQvYXNsci5jICg2NSUpCmxzIC1hIC9rZXJu
ZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZpZy1zMS0wMTEwMTczOC9u
ZXh0Om1hc3RlcjphODE1YTVlOThlN2JmNGQ3NWIyNTE1ZmQwOGY0NjRjYTI0ZjUyYzg1OmJp
c2VjdC1tbQoKMjAxNC0wMS0xMy0yMDoyMTo0MiBhODE1YTVlOThlN2JmNGQ3NWIyNTE1ZmQw
OGY0NjRjYTI0ZjUyYzg1IGNvbXBpbGluZwoKMjAxNC0wMS0xMy0yMDoyNzo1MCBkZXRlY3Rp
bmcgYm9vdCBzdGF0ZSAzLjEzLjAtcmM3LW5leHQtMjAxNDAxMTAtMDAwMDEtZ2E4MTVhNWUu
Li4JMQk1CTkJMTEJMTIJMTguLgkyMAkyMy4uCTI0CTI3CTMxCTM1CTM2CTM4CTM5CTQyCTQ0
Lgk0Ny4uCTQ4CTUwCTUxLi4JNTMJNTgJNjAJNjIJNzEJMTAwCTEwOQkxMTAJMTEyCTExOQkx
MjMJMTI5CTEzMgkxMzUJMTM4CTE0MQkxNTAJMTU0CTE1NwkxNjQJMTczCTE5MwkxOTcJMjAy
CTIwOAkyMjAuLi4uLgkyMjEuCTIyMi4uCTIyNwkyMzIJMjM0CTIzNy4uLgkyNDQJMjQ4CTI1
NAkyNTYJMjU5LgkyNjAuLi4uLgkyNjMJMjcwCTI3Ni4JMjc3CTI4MAkyODEJMjgzLi4uLi4J
Mjg1CTI4NwkyOTAJMjk1Li4uCTMwMAkzMDIuLgkzMDMuLgkzMDUJMzEwCTMxMgkzMjMJMzI5
CTMzNQkzMzkuCTM0MgkzNDMuCTM0NC4JMzQ5CTM1MgkzNTgJMzYxCTM2My4uLgkzNjQuLgkz
NjUuLi4JMzY2CTM2Ny4JMzY4Li4JMzcyCTM3NAkzNzUJMzc4CTM4NgkzOTUJNDAwCTQwNC4u
CTQwNQk0MDcJNDA5CTQxMS4JNDEyCTQxNQk0MTYuCTQxOC4JNDE5CTQyNS4JNDI2Li4JNDMw
CTQzMS4uCTQzMi4uCTQzMwk0MzQuLgk0MzcJNDM5Li4JNDQxLi4uLi4uCTQ0Mi4JNDQzLgk0
NDUuLgk0NDcuLgk0NDkJNDUwCTQ1MQk0NTQJNDYwCTQ2Mi4JNDYzLi4uLi4JNDY1CTQ2Ngk0
NjcuCTQ2OAk0NjkJNDcwLgk0ODAuCTQ4Mi4uLi4JNDg4CTQ5MQk0OTMJNDk1CTQ5Ni4uLi4J
NTAxLi4uCTUwOAk1MTkuLi4JNTIwCTUyMQk1MjUuCTUzMS4uCTUzMgk1MzMJNTM0CTUzNi4u
CTUzOQk1NDAJNTQ3CTU1MAk1NTMuCTU1NAk1NTYJNTU4CTU1OQk1NjIJNTY2CTU3Mgk1NzMJ
NTc3CTU3OAk1ODUJNTg5CTU5MS4uCTU5NQk1OTgJNTk5CTYwNwk2MTAuCTYxOAk2MjYJNjI5
CTYzMgk2MzUuLi4JNjM2CTYzOAk2NDEJNjQ5CTY1Mgk2NTQJNjYwCTY2MQk2NjMJNjY0Li4u
CTY2OAk2NzQJNjc2CTY3OAk2ODIJNjgzCTY5MS4uCTcwMQk3MDYJNzA3CTcxMgk3MjcJNzMy
CTczMy4JNzM0CTczNQk3MzYuCTc0MAk3NDEuLgk3NDQJNzQ2Lgk3NTAJNzU2CTc1OQk3NjIJ
NzYzCTc2NQk3NzIJNzczCTc3NQk3NzcJNzgzCTc4Ni4JNzk1CTgwMAk4MDIJODE2CTgxNy4J
ODIxCTgyMgk4MjMuCTgzMQk4MzgJODQwCTg0Mwk4NTAJODUxLi4JODUyCTg1NAk4NjAuLi4J
ODczCTg3OAk4ODEJODg1CTg4Ngk4ODgJODkzCTg5Nwk4OTkuLgk5MDEJOTAyCTkwNAk5MDUJ
OTA2CTkwOAk5MTAJOTEyCTkxNQk5MTcJOTM0CTkzOAk5NTEJOTczCTk3OS4uLgk5ODEJOTg0
Lgk5ODcuCTk4OC4uLi4uLi4JOTg5CTk5MS4uLi4uLi4uLi4uLi4uCTEwMjUJMTAyNgkxMDMy
CTEwMzQJMTAzOQkxMDQxCTEwNDQJMTA0NwkxMDQ4CTEwNDkJMTA1MC4JMTA1MS4JMTA1Mgkx
MDU1Li4uCTEwNTYJMTA2MgkxMDYzCTEwNjcJMTA3OQkxMDgxCTEwODcJMTEwNAkxMTE3CTEx
MzIJMTE0NQkxMTYwCTExODMJMTE5NAkxMjA3CTEyMjAJMTIyNwkxMjI4CTEyNDAJMTI0Nwkx
MjUzCTEyNjMJMTI3MgkxMjc3CTEyODEJMTI4NwkxMjg4CTEyODkJMTI5OAkxMzAwLgkxMzAz
CTEzMDkJMTMxMwkxMzE3CTEzMTkJMTMyMAkxMzI3CTEzMjgJMTMzMwkxMzM0CTEzMzgJMTM0
MS4uCTEzNDMJMTM0NS4uCTEzNTIJMTM1NgkxMzU3CTEzNjMJMTM2OAkxMzc0CTEzNzcJMTM3
OQkxMzg0Li4JMTM4NgkxMzk2Li4JMTQwMS4JMTQxMC4JMTQxMS4JMTQxNwkxNDI3CTE0MzAJ
MTQzMS4JMTQzMi4uLgkxNDMzLi4uCTE0MzYJMTQzOAkxNDQzCTE0NDQJMTQ0OAkxNDUwLgkx
NDUzCTE0NTcJMTQ2MQkxNDYyCTE0NjQJMTQ2OAkxNDY5CTE0NzAJMTQ3NgkxNDgwLi4JMTQ4
OQkxNDk0LgkxNDk1LgkxNDk2CTE0OTkJMTUwMAkxNTA1CTE1MjAJMTUyNC4JMTUyNQkxNTI2
LgkxNTI3CTE1MzMJMTUzNAkxNTM1LgkxNTM3CTE1MzgJMTU0MAkxNTQ0CTE1NTAJMTU1OAkx
NTU5CTE1NjIJMTU3MAkxNTc0CTE1NzYJMTU3OAkxNTgzLgkxNTg0LgkxNTg2Li4uLgkxNTg3
Li4uCTE1OTQJMTYwMQkxNjA1CTE2MDYJMTYyMwkxNjI4CTE2MjkuCTE2MzAJMTYzMgkxNjMz
CTE2MzYJMTYzNwkxNjM4LgkxNjM5LgkxNjQzCTE2NDcJMTY1MgkxNjU2CTE2NTcJMTY2Mwkx
NjY2CTE2NjcJMTY2OAkxNjcwCTE2NzUJMTY3NwkxNjgxCTE2ODYJMTY4OS4JMTY5NgkxNzAz
CTE3MDQuLgkxNzA1CTE3MDcuCTE3MDgJMTcwOS4uCTE3MTAJMTcxMgkxNzE0LgkxNzE1CTE3
MTYJMTcxOAkxNzI2CTE3MjcuLi4uLi4JMTcyOS4JMTczMS4JMTczNAkxNzM2CTE3NDIuCTE3
NDYJMTc0OAkxNzU1CTE3NjcJMTc2OAkxNzcxCTE3ODkJMTc5MQkxNzk1CTE3OTgJMTc5OQkx
ODA3CTE4MTAJMTgyMAkxODI4Li4JMTgzMwkxODM1CTE4MzcJMTgzOQkxODQyCTE4NDQuCTE4
NDUJMTg1NAkxODY0CTE4NjYJMTg2OAkxODc1CTE4NzgJMTg4MS4JMTg4MwkxODg2CTE4OTEJ
MTg5MwkxODk2CTE5MDEuCTE5MDIuCTE5MDYuCTE5MDkJMTkxMy4JMTkxNwkxOTE5CTE5MjEJ
MTkyNQkxOTI2Li4uLgkxOTI3Li4uCTE5MjgJMTkyOQkxOTMyCTE5MzYJMTkzNwkxOTQwCTE5
NTQJMTk1NwkxOTYwCTE5NjMJMTk2NgkxOTczCTE5NzQJMTk3NgkxOTc3LgkxOTc4CTE5ODAJ
MTk4MwkxOTkxCTE5OTkJMjAwMwkyMDEyCTIwMTUJMjAxOQkyMDIxCTIwMjIJMjAyMwkyMDI0
CTIwMjYJMjAyNwkyMDMyCTIwMzMuCTIwMzQuLgkyMDM2CTIwMzcJMjAzOS4JMjA0NC4uLi4u
CTIwNDUJMjA0NwkyMDU4CTIwNjUJMjA3MwkyMDc2CTIwNzcJMjA3OQkyMDgwLi4uLgkyMDgx
LgkyMDgzCTIwODYJMjA4OAkyMDkxLi4JMjA5MwkyMDk3CTIwOTkJMjEwMAkyMTA0CTIxMDkJ
MjExMwkyMTE0CTIxMTcuCTIxMTgJMjEyNS4uCTIxMjYJMjEzMAkyMTMyCTIxNDMJMjE1MQky
MTU1CTIxNjEJMjE2NwkyMTcyCTIxNzUJMjE3Ny4JMjE3OAkyMTg1CTIxOTEJMjE5MgkyMTk4
CTIxOTkJMjIwMQkyMjA0CTIyMTEJMjIyMAkyMjI1LgkyMjI2Li4JMjIyOC4uCTIyMzMJMjIz
NAkyMjM2LgkyMjM4CTIyNDAJMjI0NQkyMjQ2CTIyNTMJMjI1NgkyMjYyCTIyNjQuCTIyNjkJ
MjI3NgkyMjc4CTIyODAJMjI4MgkyMjgzCTIyODQJMjI4NS4JMjI4OC4JMjI4OQkyMjkxCTIy
OTQJMjMwMgkyMzA1LgkyMzA4CTIzMTMJMjMxNgkyMzE4CTIzMjEJMjMyOQkyMzMxLgkyMzMy
CTIzMzcuCTIzMzkJMjM0MC4JMjM0NAkyMzQ3CTIzNDguLgkyMzUyCTIzNTMJMjM1NC4JMjM1
NwkyMzU5LgkyMzY0LgkyMzY2Li4JMjM2OAkyMzcwCTIzODEuLi4JMjM4NAkyMzkxCTIzOTUJ
MjM5NgkyMzk3LgkyMzk4CTIzOTkJMjQwMQkyNDAyLgkyNDAzCTI0MTAuCTI0MTUJMjQxNwky
NDIxLgkyNDIyLi4uLgkyNDI4CTI0MzIJMjQzNwkyNDM5CTI0NDMuCTI0NDcJMjQ1MQkyNDYx
CTI0NjIJMjQ3MwkyNDc5CTI0ODIJMjQ4My4JMjQ4OC4JMjQ5NS4JMjQ5Ni4JMjQ5OAkyNDk5
CTI1MDAJMjUwMgkyNTA0Li4uLi4uLi4JMjUwNQkyNTExCTI1MTMJMjUxOQkyNTIxLi4JMjUy
NS4JMjUyOAkyNTMxCTI1MzMJMjUzNgkyNTM4CTI1NDEJMjU1MgkyNTU5CTI1NjYJMjU2OQky
NTcwCTI1NzEJMjU4MwkyNTg5CTI1OTkJMjYwMAkyNjAyCTI2MDcJMjYxMwkyNjE1CTI2MTYJ
MjYxNwkyNjE4LgkyNjIwLi4uCTI2MjMJMjYyNi4JMjYyOC4JMjYzMwkyNjM1CTI2MzguCTI2
MzkJMjY0MAkyNjQzCTI2NDkJMjY1MwkyNjU1CTI2NTYJMjY1OAkyNjY0Li4JMjY2OAkyNjcy
CTI2NzYJMjY4MgkyNjg2CTI2OTAJMjY5NgkyNzA2CTI3MTAJMjcyNQkyNzMzCTI3MzguCTI3
NDIJMjc0NgkyNzQ3LgkyNzUwLi4uLi4uLi4uLgkyNzUyCTI3NTgJMjc1OS4uCTI3NjUJMjc2
NwkyNzc1CTI3ODkJMjc5MC4uLi4JMjc5MgkyNzkzCTI3OTYJMjc5NwkyNzk4Li4JMjc5OS4J
MjgwMwkyODA0Li4uLgkyODA1CTI4MDYJMjgwOAkyODEwCTI4MTIJMjgxMy4JMjgxOS4uCTI4
MjUJMjgyNgkyODI4CTI4MjkuCTI4MzUJMjg0NwkyODU5CTI4NjQJMjg2NgkyODY4Li4JMjg3
MAkyODczCTI4ODIJMjg4MwkyODg0Li4uCTI4ODcJMjg5MQkyODkzCTI4OTQuCTI4OTUuLgky
ODk2Li4JMjkwMQkyOTA0CTI5MDUJMjkwNy4uCTI5MDkJMjkxMAkyOTE0CTI5MTcJMjkyMS4u
LgkyOTI2CTI5MzUuCTI5MzguCTI5NDAJMjk0MgkyOTQzCTI5NDQuCTI5NDcuCTI5NDgJMjk1
MQkyOTUzCTI5NzEJMjk4MgkyOTk0CTI5OTcuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uG1sxOzM1bWFkZF90b19ydW5fcXVldWUgMxtbMG0KLi4uCTI5OTgJMjk5OS4JMzAwMCBT
VUNDRVNTCgoKPT09PT09PT09IHVwc3RyZWFtID09PT09PT09PQpGZXRjaGluZyBsaW51cwps
cyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0veDg2XzY0LXJhbmRjb25maWctczEt
MDExMDE3MzgvbmV4dDptYXN0ZXI6YTZkYTgzZjk4MjY3YmM4ZWU0ZTM0YWE4OTkxNjk5OTFl
YjBjZWI5MzpiaXNlY3QtbW0KCjIwMTQtMDEtMTQtMDg6NDI6MDEgYTZkYTgzZjk4MjY3YmM4
ZWU0ZTM0YWE4OTkxNjk5OTFlYjBjZWI5MyBjb21waWxpbmcKCjIwMTQtMDEtMTQtMDg6NDg6
MTMgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xMy4wLXJjOC0wMDAwNS1nYTZkYTgzZi4uLi4J
Mgk4CTE2LgkxNwkyMQkyNQkyOAkyOS4JMzIuLi4JMzQJMzUuLgkzNwkzOC4uLgk0OQk1Mgk1
OQk2Mgk2My4uLgk2NS4uLi4uLgk2OAk3MAk3MQk3Mgk3Ni4uCTc5Li4uLi4uCTgxLi4uLi4u
CTgyCTg0CTg1Li4uCTkyCTEwMAkxMDkJMTI2CTE0MAkxNDQJMTUwCTE1OAkxNjEJMTcyCTE3
NwkxODEJMTg0LgkxODYJMTg4CTE5MQkyMDAJMjAxCTIwNAkyMDYJMjA3LgkyMTAJMjE1CTIy
MAkyMjUuLgkyMjgJMjMwCTIzNQkyMzgJMjQ0CTI0NQkyNTEJMjUzCTI1NwkyNjAuLi4JMjY2
CTI2Ny4JMjcwLgkyNzEJMjcyCTI3NwkyNzkuCTI4MwkyODQJMjg3Li4JMjkxLgkyOTIJMjkz
CTI5NS4JMjk3CTI5OC4JMjk5CTMwMAkzMDYJMzA3CTMxMwkzMTYJMzE4LgkzMTkJMzI0CTMy
NwkzMjgJMzM0CTMzOQkzNDIJMzQ4CTM1NQkzNjEJMzY0CTM2NgkzNjcJMzc5CTM4OAkzOTIu
CTM5Ngk0MDAJNDA4Li4JNDM2Lgk0NDAuLi4JNDUxLi4uCTQ1NQk0NjIJNDcxCTQ3Mgk0NzUu
Li4uLi4uLi4uCTQ3OAk0NzkJNDgwLgk0ODIuCTQ4Ngk0ODkJNDk2CTUwMQk1MDkJNTEwCTUx
NQk1MTcuCTUyMC4uLgk1MjcJNTI5CTUzMQk1MzcJNTM4CTU0MAk1NDEJNTQyCTU0My4uCTU0
Nwk1NDguLi4uCTU0OS4JNTUzLgk1NTQuLi4uLi4JNTU1CTU2Mgk1NjMJNTY1CTU3MQk1NzYJ
NTgwCTU5Ny4uCTU5OQk2MDIuCTYwMwk2MDQuCTYwNQk2MTQJNjE3CTYyNgk2MjkJNjMwLi4J
NjM0CTYzNgk2MzgJNjM5CTY0MC4JNjQzCTY0Ngk2NDcJNjUyCTY1NQk2NTcuCTY2Mi4JNjYz
CTY2NQk2NzMuCTY3Ngk2ODIJNjg2CTY4OAk2OTEJNjk0CTY5NQk3MDYJNzEzCTcxNwk3MjAJ
NzIzCTcyOC4uLgk3MjkuCTczNQk3MzkJNzQ4CTc0OQk3NTEJNzUyCTc1Mwk3NTQuCTc1Ngk3
NTguCTc1OS4JNzYwLi4JNzYxLgk3NjQJNzY2CTc3MAk3NzMJNzc5CTc4MC4JNzg1CTc4Nwk3
OTEJNzkyCTc5Ny4JNzk4CTgwMgk4MDYJODE0Li4uCTgxOAk4MjAJODI2Lgk4MzEJODQzLgk4
NDkJODUyLgk4NTQuLi4JODYxCTg2Nwk4NzAJODcyCTg3Mwk4NzUJODc3CTg4Ngk4OTAJODk3
CTkwNgk5MDkuCTkxMwk5MTYJOTI0CTkyNgk5MzAJOTM0Lgk5NDEJOTQyCTk0OAk5NTAJOTUx
CTk2MQk5NjIJOTY0CTk2OAk5NzAJOTc4CTk4MAk5ODEJOTg3CTk5MAk5OTMJOTk2LgkxMDEy
LgkxMDE2CTEwMTgJMTAyNQkxMDI3CTEwMjkuLi4uLgkxMDMwCTEwMzEJMTAzNAkxMDM1CTEw
NDEJMTA0NAkxMDUwLi4uCTEwNTYuCTEwNTcJMTA1OAkxMDU5CTEwNjAJMTA2NQkxMDY5Li4J
MTA3MC4JMTA3MS4uLi4uLi4JMTA3Mi4uLi4JMTA3MwkxMDc0CTEwNzUuCTEwNzcJMTA3OAkx
MDc5CTEwODAJMTA4MgkxMDg1LgkxMDkzCTEwOTcJMTEwMgkxMTA4CTExMTQJMTExNQkxMTE3
CTExMjgJMTEyOS4JMTEzMC4JMTEzMS4uCTExMzYJMTE0MAkxMTQzLgkxMTQ0LgkxMTQ3CTEx
NDguCTExNTEuCTExNjQJMTE2OS4uCTExNzMJMTE3NAkxMTc3CTExNzguLi4uCTExNzkJMTE4
NQkxMTkzCTExOTUuLgkxMTk2CTExOTcuCTExOTkJMTIwMC4uLgkxMjAyLi4uLi4JMTIwNQkx
MjEwCTEyMTEJMTIyNwkxMjMzCTEyMzQuCTEyMzcJMTI0MC4JMTI0MQkxMjQzCTEyNDQJMTI1
MAkxMjU4CTEyNjYJMTI2OQkxMjcxCTEyNzMJMTI3OAkxMjgyCTEyODYJMTI5MAkxMjk5CTEz
MDkJMTMxMwkxMzI1CTEzMzEJMTMzNwkxMzQzCTEzNDQJMTM0OQkxMzUwLi4JMTM1Mi4JMTM1
NAkxMzYyLi4JMTM2MwkxMzY2CTEzNzAJMTM3MQkxMzcyCTEzNzUJMTM4MQkxMzg3LgkxMzkw
CTEzOTkJMTQwMQkxNDA2CTE0MDcJMTQwOC4JMTQwOQkxNDE0CTE0MTYJMTQxNy4uCTE0MjAJ
MTQyNAkxNDI1CTE0MzAJMTQzNgkxNDM3CTE0NDAJMTQ0MS4uCTE0NDIJMTQ0NAkxNDQ4Lgkx
NDUxCTE0NTMuCTE0NTguCTE0NjAuCTE0NjEuLgkxNDYyLi4uLi4uCTE0NjMuLi4JMTQ2NAkx
NDY3CTE0NjkuCTE0NzAuLi4uLi4uLgkxNDcxLgkxNDcyLgkxNDc0CTE0NzguLgkxNDc5Lgkx
NDgxCTE0ODIJMTQ4MwkxNDg1CTE0ODYJMTQ5MAkxNDkxCTE0OTMJMTQ5NQkxNDk2CTE0OTgu
LgkxNDk5CTE1MDAuCTE1MDIuLi4JMTUwNgkxNTEyCTE1MTYJMTUxOAkxNTE5CTE1MjAJMTUy
Ny4uCTE1MjkJMTUzMgkxNTM0CTE1MzcuCTE1MzkJMTU0My4uLgkxNTQ0CTE1NTAuCTE1NTcJ
MTU2MAkxNTY2LgkxNTczCTE1ODQJMTU4OAkxNTkyCTE1OTYJMTYwNQkxNjA2Li4uCTE2MDcu
CTE2MTAuCTE2MTEJMTYxMwkxNjE2CTE2MTguLi4JMTYyMQkxNjI0LgkxNjI4CTE2MzEJMTYz
MgkxNjMzCTE2MzQJMTYzOAkxNjQ0CTE2NTIJMTY1OQkxNjYxLgkxNjYyCTE2NjkJMTY3NC4u
LgkxNjgxCTE2ODYJMTY5MwkxNjk1CTE2OTgJMTcwMC4JMTcwMS4uLi4uLi4JMTcwMgkxNzA1
CTE3MDcuCTE3MDgJMTcxNC4JMTcxNS4uLi4uLgkxNzE2CTE3MjAJMTcyNAkxNzI5CTE3MzEJ
MTczMy4JMTc0MC4JMTc0NAkxNzU0CTE3NjIuLgkxNzY0LgkxNzY3CTE3NzMJMTc3Ni4JMTc4
MAkxNzg1LgkxNzg2LgkxNzkyCTE3OTUJMTc5Ny4uLi4uLi4uCTE3OTguCTE3OTkJMTgwMAkx
ODAyCTE4MDMJMTgxMQkxODEzCTE4MTQuCTE4MTUJMTgxOQkxODI1LgkxODI4CTE4MjkuCTE4
MzAJMTgzMgkxODM3CTE4MzkJMTg0MAkxODQxCTE4NDQuLi4JMTg0Ni4JMTg0NwkxODQ4CTE4
NTgJMTg2NC4JMTg3MQkxODc1LgkxODc2LgkxODc3LgkxODgwCTE4ODIJMTg4OAkxODg5Li4u
Li4JMTg5MAkxODkxCTE4OTIJMTg5NQkxODk3CTE5MDUJMTkwNwkxOTA4CTE5MTAJMTkxMQkx
OTEzCTE5MTgJMTkyMgkxOTI0LgkxOTI1CTE5MjgJMTkzMgkxOTM2CTE5NDEJMTk0MwkxOTQ1
Li4JMTk0NgkxOTUwCTE5NTQJMTk1OQkxOTY0CTE5NjUJMTk2OAkxOTcwCTE5NzIuCTE5Nzgu
CTE5ODEJMTk5MAkxOTk1LgkxOTk2Li4uCTE5OTkJMjAwMgkyMDA1CTIwMTIJMjAxNQkyMDE3
CTIwMjAJMjAyMQkyMDIyCTIwMjYJMjAyNy4JMjAyOC4JMjAzMQkyMDM3CTIwNDQJMjA0Nwky
MDQ5CTIwNTAuCTIwNTMJMjA1NgkyMDU5CTIwNjAJMjA2MgkyMDYzCTIwNjUJMjA3MAkyMDcz
LgkyMDc2CTIwODIJMjA4My4JMjA4NQkyMDg4CTIwOTAJMjA5MgkyMDk3CTIwOTguLgkyMTAw
CTIxMDEJMjEwMgkyMTA0Li4JMjEwNgkyMTA4CTIxMTEJMjExNgkyMTE4LgkyMTI1CTIxMjgu
CTIxMjkJMjEzMgkyMTM0CTIxMzUJMjEzOAkyMTM5CTIxNDIJMjE0MwkyMTQ1CTIxNTIJMjE1
NAkyMTU5CTIxNjAuLgkyMTYyCTIxNjYuLgkyMTY5CTIxNzAuCTIxNzEJMjE3NQkyMTg0CTIx
ODkJMjE5MS4uCTIxOTYJMjE5NwkyMTk4CTIyMDIJMjIwOC4JMjIxMgkyMjEzCTIyMjAJMjIy
NAkyMjI3LgkyMjI4CTIyMjkJMjIzMwkyMjM3CTIyMzkJMjI0MwkyMjQ0Li4JMjI0NQkyMjQ2
CTIyNDgJMjI0OQkyMjU2CTIyNTkuCTIyNjEJMjI2NwkyMjY4CTIyNzEJMjI3Mi4JMjI3My4J
MjI3NgkyMjg4CTIyOTIJMjI5NAkyMjk1CTIyOTcJMjMwMAkyMzAzCTIzMTEJMjMxNAkyMzE3
CTIzMTgJMjMyMS4JMjMzNQkyMzQxCTIzNDIJMjM0NQkyMzU2CTIzNTgJMjM2NgkyMzczCTIz
NzQJMjM3NwkyMzgyCTIzODMJMjM4OC4uLgkyMzkwCTIzOTMJMjM5NAkyMzk1Li4JMjM5Ny4u
Li4JMjQwMAkyNDA0CTI0MTIJMjQzNwkyNDYyCTI0NzAJMjQ4NwkyNDk1CTI0OTgJMjUwMAky
NTA3CTI1MDkuCTI1MTAuLi4uLgkyNTEyCTI1MTgJMjUyMC4JMjUyNgkyNTI4CTI1MzAuCTI1
MzIuCTI1MzkuCTI1NDAJMjU0MgkyNTQ1CTI1NDYuCTI1NTEJMjU2NAkyNTY4CTI1NzAJMjU3
NC4uLgkyNTc1CTI1NzguCTI1ODAuCTI1ODIJMjU4NwkyNTg4Li4JMjU4OQkyNTk0LgkyNjAy
CTI2MTcJMjYxOQkyNjIwCTI2MzgJMjYzOQkyNjQxLi4JMjY0NAkyNjQ3CTI2NTAJMjY1Mwky
NjU2CTI2NTkJMjY2MAkyNjYyCTI2NjQJMjY2OS4uLi4JMjY3MC4JMjY3MQkyNjc2LgkyNjc4
Li4uCTI2ODAuLgkyNjg0LgkyNjg2CTI2ODkuCTI2OTEJMjY5My4uCTI3MTIJMjcxOC4uCTI3
MTkJMjcyMwkyNzI0Li4JMjcyNgkyNzMwLgkyNzMxLgkyNzMzCTI3MzUJMjczOAkyNzM5CTI3
NDMJMjc0NAkyNzUxCTI3NTYJMjc1OQkyNzY3CTI3NzEJMjc3NwkyNzgxCTI3ODYJMjc5MC4u
CTI3OTMJMjc5NwkyODEyCTI4MTYJMjgyMQkyODIzCTI4MjkJMjgzMwkyODM3CTI4MzgJMjg0
MgkyODQ2CTI4NTAJMjg1MQkyODUyCTI4NTUJMjg1OQkyODYyCTI4NjUJMjg2OAkyODcwLgky
ODczCTI4NzQuCTI4ODYuCTI4OTEJMjg5Mi4JMjg5NC4JMjg5NS4uLgkyODk3Li4uLi4uCTI4
OTgJMjkwMAkyOTAxCTI5MDIJMjkwNwkyOTA5CTI5MTAuCTI5MTMuCTI5MTYJMjkxOAkyOTE5
LgkyOTIxCTI5MjMJMjkyNQkyOTMwCTI5MzcJMjk1MAkyOTUzLgkyOTU4CTI5NTkJMjk2NC4u
CTI5NjcJMjk3MS4JMjk4MAkyOTgyCTI5OTIJMjk5OC4uLi4uLi4uLi4uLi4uLi4uLi4uCTMw
MDAgU1VDQ0VTUwoKCj09PT09PT09PSBsaW51eC1uZXh0ID09PT09PT09PQpGZXRjaGluZyBu
ZXh0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS94ODZfNjQtcmFuZGNvbmZp
Zy1zMS0wMTEwMTczOC9uZXh0Om1hc3RlcjpjZjFjMWQxOTNlMzdiOWY3OWVlZGRkYzZiYmQ3
MWI5ZjVmOTc1MWU1OmJpc2VjdC1tbQoKMjAxNC0wMS0xNC0xOToyMzoyNSBjZjFjMWQxOTNl
MzdiOWY3OWVlZGRkYzZiYmQ3MWI5ZjVmOTc1MWU1IGNvbXBpbGluZwoKMjAxNC0wMS0xNC0x
OTozNzo0NyBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjEzLjAtcmM4LW5leHQtMjAxNDAxMTQu
LgkzCTEwLgkxMQkyMAkyNwkyOAkzMwk0Mwk1MAk1Mwk1NC4uCTU1CTY4CTY5CTcxCTc5CTgw
Lgk4NQk4OAk5Mgk5NAk5OSBURVNUIEZBSUxVUkUKWzYzODYwLjMyMjQzMV0gVW5wYWNraW5n
IGluaXRyYW1mcy4uLgpbNjM4NjAuMzU0Njc0XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0t
LS0tLS0tLS0tLS0KWzYzODYwLjM1NDY3NF0gLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0t
LS0tLS0tLS0tCls2Mzg2MC4zNTU2NzFdIFdBUk5JTkc6IENQVTogMSBQSUQ6IDEgYXQga2Vy
bmVsL2xvY2tpbmcvbG9ja2RlcC5jOjM1MzcgY2hlY2tfZmxhZ3MrMHg3YS8weDIwMCgpCi9r
ZXJuZWwveDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3MzgvY2YxYzFkMTkzZTM3YjlmNzll
ZWRkZGM2YmJkNzFiOWY1Zjk3NTFlNS9kbWVzZy1xdWFudGFsLWNhaXJvLTM6MjAxNDAxMTQx
OTUxMzk6eDg2XzY0LXJhbmRjb25maWctczEtMDExMDE3Mzg6My4xMy4wLXJjOC1uZXh0LTIw
MTQwMTE0OjYyMAowOjE6MTAwIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzCgo=

--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.13.0-rc7-next-20140110-08732-g1955a14"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.13.0-rc7 Kernel Configuration
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
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
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
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_FHANDLE=y
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
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
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
# CONFIG_NO_HZ_FULL_ALL is not set
# CONFIG_NO_HZ_FULL_SYSIDLE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_RCU_FAST_NO_HZ is not set
CONFIG_TREE_RCU_TRACE=y
CONFIG_RCU_NOCB_CPU=y
CONFIG_RCU_NOCB_CPU_ALL=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_RD_LZ4=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
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
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_EVENT_MULTIPLEX is not set
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
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_SYSTEM_TRUSTED_KEYRING is not set
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_CMDLINE_PARSER=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
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
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
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
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_INJECT=m
# CONFIG_I8K is not set
CONFIG_MICROCODE=y
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
CONFIG_MICROCODE_AMD_EARLY=y
CONFIG_MICROCODE_EARLY=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_MOVABLE_NODE=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTREMOVE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x40000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
CONFIG_DEBUG_HOTPLUG_CPU0=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_ACPI_EXTLOG is not set
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
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=m
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_X86_DEV_DMA_OPS=y
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
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
# CONFIG_NET_IPGRE is not set
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=m
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
# CONFIG_TCP_CONG_CUBIC is not set
CONFIG_TCP_CONG_WESTWOOD=m
# CONFIG_TCP_CONG_HTCP is not set
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
# CONFIG_TCP_CONG_LP is not set
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
CONFIG_DEFAULT_HYBLA=y
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="hybla"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_RDS=y
CONFIG_RDS_TCP=m
# CONFIG_RDS_DEBUG is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
# CONFIG_ATM_LANE is not set
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
# CONFIG_L2TP is not set
CONFIG_STP=m
CONFIG_GARP=m
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
# CONFIG_VLAN_8021Q_MVRP is not set
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
# CONFIG_IPDDP_ENCAP is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_IEEE802154=m
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_ATM=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
# CONFIG_NET_SCH_CHOKE is not set
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_FQ=m
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
# CONFIG_NET_CLS_FW is not set
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=m
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
# CONFIG_OPENVSWITCH_GRE is not set
CONFIG_OPENVSWITCH_VXLAN=y
# CONFIG_VSOCKETS is not set
CONFIG_NETLINK_MMAP=y
CONFIG_NETLINK_DIAG=m
CONFIG_NET_MPLS_GSO=y
# CONFIG_HSR is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=m
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
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
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
CONFIG_6PACK=y
CONFIG_BPQETHER=y
# CONFIG_BAYCOM_SER_FDX is not set
# CONFIG_BAYCOM_SER_HDX is not set
CONFIG_BAYCOM_PAR=m
CONFIG_YAM=y
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
# CONFIG_IRNET is not set
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
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

#
# FIR device drivers
#
CONFIG_NSC_FIR=m
# CONFIG_WINBOND_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
# CONFIG_BT_BNEP is not set
# CONFIG_BT_CMTP is not set
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTSDIO is not set
CONFIG_BT_HCIUART=m
# CONFIG_BT_HCIUART_H4 is not set
# CONFIG_BT_HCIUART_BCSP is not set
# CONFIG_BT_HCIUART_ATH3K is not set
CONFIG_BT_HCIUART_LL=y
# CONFIG_BT_HCIUART_3WIRE is not set
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
# CONFIG_AF_RXRPC is not set
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_SPY=y
CONFIG_CFG80211=m
CONFIG_NL80211_TESTMODE=y
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
# CONFIG_RFKILL_INPUT is not set
# CONFIG_RFKILL_REGULATOR is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
CONFIG_NET_9P_DEBUG=y
CONFIG_CAIF=m
CONFIG_CAIF_DEBUG=y
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=m
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=y
CONFIG_NFC_DIGITAL=m
# CONFIG_NFC_NCI is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_SIM is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
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
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
# CONFIG_MTD_TESTS is not set
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=y
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
CONFIG_FTL=m
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=y
# CONFIG_SSFDC is not set
CONFIG_SM_FTL=m
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
CONFIG_MTD_CFI_ADV_OPTIONS=y
CONFIG_MTD_CFI_NOSWAP=y
# CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
# CONFIG_MTD_CFI_LE_BYTE_SWAP is not set
CONFIG_MTD_CFI_GEOMETRY=y
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_MAP_BANK_WIDTH_8=y
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
CONFIG_MTD_MAP_BANK_WIDTH_32=y
CONFIG_MTD_CFI_I1=y
# CONFIG_MTD_CFI_I2 is not set
CONFIG_MTD_CFI_I4=y
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_OTP is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
# CONFIG_MTD_RAM is not set
CONFIG_MTD_ROM=y
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=y
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_TS5500=m
CONFIG_MTD_SBC_GXX=m
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_L440GX=m
# CONFIG_MTD_PCI is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
CONFIG_MTD_LATCH_ADDR=m

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
CONFIG_MTD_PHRAM=m
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=y
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
CONFIG_MTD_NAND=m
CONFIG_MTD_NAND_BCH=m
CONFIG_MTD_NAND_ECC_BCH=y
# CONFIG_MTD_SM_COMMON is not set
CONFIG_MTD_NAND_DENALI=m
# CONFIG_MTD_NAND_DENALI_PCI is not set
CONFIG_MTD_NAND_IDS=m
# CONFIG_MTD_NAND_RICOH is not set
CONFIG_MTD_NAND_DISKONCHIP=m
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED=y
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
CONFIG_MTD_NAND_DISKONCHIP_PROBE_HIGH=y
CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE=y
# CONFIG_MTD_NAND_DOCG4 is not set
# CONFIG_MTD_NAND_CAFE is not set
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
CONFIG_MTD_ONENAND_OTP=y
CONFIG_MTD_ONENAND_2X_PROGRAM=y

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
CONFIG_MTD_UBI_FASTMAP=y
CONFIG_MTD_UBI_GLUEBI=m
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
# CONFIG_PARPORT_PC is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=m
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS or INET not selected
#
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SKD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=y
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_DUMMY_IRQ=m
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
CONFIG_ISL29020=m
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=m
CONFIG_DS1682=y
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_SRAM=y
CONFIG_C2PORT=m
CONFIG_C2PORT_DURAMAR_2150=m

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_LEGACY=m
# CONFIG_EEPROM_MAX6875 is not set
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

#
# Intel MIC Host Driver
#
# CONFIG_INTEL_MIC_HOST is not set

#
# Intel MIC Card Driver
#
CONFIG_INTEL_MIC_CARD=y
# CONFIG_GENWQE is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
CONFIG_IDE_GD_ATAPI=y
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
CONFIG_BLK_DEV_IDETAPE=m
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_PLATFORM=y
CONFIG_BLK_DEV_CMD640=y
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
# CONFIG_BLK_DEV_IDEPNP is not set

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
# CONFIG_BLK_DEV_IDEDMA is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=m
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
# CONFIG_BCACHE is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
CONFIG_BONDING=y
CONFIG_DUMMY=m
CONFIG_EQUALIZER=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
# CONFIG_NET_TEAM_MODE_ACTIVEBACKUP is not set
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=y
# CONFIG_MACVTAP is not set
CONFIG_VXLAN=y
CONFIG_NETCONSOLE=m
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_TUN is not set
CONFIG_VETH=m
# CONFIG_VIRTIO_NET is not set
CONFIG_NLMON=y
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=m
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=m
CONFIG_CAIF_SPI_SLAVE=m
CONFIG_CAIF_SPI_SYNC=y
CONFIG_CAIF_HSI=m
# CONFIG_CAIF_VIRTIO is not set

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
# CONFIG_ETHERNET is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=m
CONFIG_AMD_PHY=m
CONFIG_MARVELL_PHY=m
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=m
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=m
# CONFIG_BROADCOM_PHY is not set
CONFIG_BCM87XX_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
# CONFIG_MICREL_PHY is not set
CONFIG_MDIO_BITBANG=m
CONFIG_PLIP=y
CONFIG_PPP=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_FILTER is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=y
CONFIG_PPPOE=y
# CONFIG_PPTP is not set
CONFIG_PPP_ASYNC=m
# CONFIG_PPP_SYNC_TTY is not set
CONFIG_SLIP=m
CONFIG_SLHC=y
# CONFIG_SLIP_COMPRESSED is not set
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_WLAN=y
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
CONFIG_ATH_CARDS=m
CONFIG_ATH_DEBUG=y
CONFIG_ATH_REG_DYNAMIC_USER_REG_HINTS=y
# CONFIG_ATH_REG_DYNAMIC_USER_CERT_TESTING is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH6KL=m
CONFIG_ATH6KL_SDIO=m
CONFIG_ATH6KL_DEBUG=y
CONFIG_ATH6KL_REGDOMAIN=y
# CONFIG_WIL6210 is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMFMAC=m
# CONFIG_BRCMFMAC_SDIO is not set
# CONFIG_BRCM_TRACING is not set
# CONFIG_BRCMDBG is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_SDIO=m
CONFIG_LIBERTAS_DEBUG=y
CONFIG_LIBERTAS_MESH=y
# CONFIG_HERMES is not set
CONFIG_WL_TI=y
CONFIG_MWIFIEX=m
CONFIG_MWIFIEX_SDIO=m
# CONFIG_MWIFIEX_PCIE is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_IEEE802154_DRIVERS is not set
# CONFIG_VMXNET3 is not set
CONFIG_ISDN=y
CONFIG_ISDN_I4L=y
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
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
CONFIG_ISDN_CAPI=y
# CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON is not set
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=y
CONFIG_ISDN_CAPI_CAPIDRV=y

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
# CONFIG_CAPI_EICON is not set
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_MISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
# CONFIG_INPUT_POLLDEV is not set
CONFIG_INPUT_SPARSEKMAP=m
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_EVDEV is not set
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
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
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
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
CONFIG_MOUSE_PS2_CYPRESS=y
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PARKBD=m
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=m
CONFIG_GAMEPORT=m
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=m
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
CONFIG_N_GSM=m
CONFIG_TRACE_ROUTER=m
CONFIG_TRACE_SINK=m
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
# CONFIG_SERIAL_PCH_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=m
CONFIG_TTY_PRINTK=y
# CONFIG_PRINTER is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
# CONFIG_IPMI_DEVICE_INTERFACE is not set
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
CONFIG_MWAVE=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
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
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_KEMPLD is not set
CONFIG_I2C_OCORES=y
CONFIG_I2C_PCA_PLATFORM=y
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
CONFIG_I2C_XILINX=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_STUB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
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
CONFIG_PPS_CLIENT_KTIMER=m
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=m
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_DS1WM=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2413=m
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=m
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=m
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=m
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_SBS=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_LP8727=m
# CONFIG_CHARGER_MANAGER is not set
CONFIG_CHARGER_MAX8998=m
CONFIG_CHARGER_BQ2415X=y
CONFIG_CHARGER_SMB347=m
CONFIG_CHARGER_TPS65090=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE=y
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_INTEL_POWERCLAMP=m
# CONFIG_ACPI_INT3403_THERMAL is not set

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_RETU_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
CONFIG_ADVANTECH_WDT=y
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
CONFIG_F71808E_WDT=y
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
# CONFIG_IBMASR is not set
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
CONFIG_KEMPLD_WDT=m
CONFIG_SC1200_WDT=m
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=m
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=m
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=y
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
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
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_CROS_EC=m
CONFIG_MFD_CROS_EC_I2C=m
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
CONFIG_MFD_DA9063=y
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_LPC_ICH is not set
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_KEMPLD=m
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
CONFIG_MFD_MAX77686=y
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8907=y
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_RETU=m
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_MFD_SYSCON=y
CONFIG_MFD_TI_AM335X_TSCADC=m
# CONFIG_MFD_LP3943 is not set
CONFIG_MFD_LP8788=y
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=m
CONFIG_TPS6507X=y
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
CONFIG_MFD_TPS6586X=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=y
CONFIG_MFD_LM3533=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
CONFIG_MFD_WM8400=y
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=y
# CONFIG_REGULATOR_ANATOP is not set
# CONFIG_REGULATOR_DA9063 is not set
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_ISL6271A=m
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=m
# CONFIG_REGULATOR_LP8755 is not set
# CONFIG_REGULATOR_LP8788 is not set
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8907=m
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8998=m
# CONFIG_REGULATOR_MAX77686 is not set
# CONFIG_REGULATOR_MAX77693 is not set
CONFIG_REGULATOR_PFUZE100=m
CONFIG_REGULATOR_RC5T583=m
CONFIG_REGULATOR_TPS51632=y
# CONFIG_REGULATOR_TPS6105X is not set
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
# CONFIG_REGULATOR_TPS6507X is not set
CONFIG_REGULATOR_TPS65090=y
# CONFIG_REGULATOR_TPS65217 is not set
# CONFIG_REGULATOR_TPS6586X is not set
CONFIG_REGULATOR_WM8400=m
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_DVB_CORE=y
CONFIG_DVB_NET=y
# CONFIG_TTPCI_EEPROM is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
# CONFIG_RC_DECODERS is not set
# CONFIG_RC_DEVICES is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=y
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_SI470X=y
CONFIG_I2C_SI470X=y
# CONFIG_RADIO_SI4713 is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_TEA5764 is not set
CONFIG_RADIO_SAA7706H=m
CONFIG_RADIO_TEF6862=m
CONFIG_RADIO_WL1273=y

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_SMS_SIANO_MDTV=y
CONFIG_SMS_SIANO_RC=y

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
# CONFIG_VIDEO_TDA7432 is not set
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=y
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=y
CONFIG_VIDEO_CS5345=y
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_TLV320AIC23B=y
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=y
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=y
CONFIG_VIDEO_SONY_BTF_MPX=y

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
# CONFIG_VIDEO_ADV7180 is not set
# CONFIG_VIDEO_ADV7183 is not set
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=y
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=y
# CONFIG_VIDEO_ML86V7667 is not set
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=m
# CONFIG_VIDEO_SAA7191 is not set
CONFIG_VIDEO_TVP514X=m
CONFIG_VIDEO_TVP5150=y
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
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
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#

#
# Flash devices
#

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
CONFIG_VIDEO_M52790=y

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
# CONFIG_MEDIA_TUNER_TDA8290 is not set
# CONFIG_MEDIA_TUNER_TDA827X is not set
# CONFIG_MEDIA_TUNER_TDA18271 is not set
CONFIG_MEDIA_TUNER_TDA9887=m
# CONFIG_MEDIA_TUNER_TEA5761 is not set
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
# CONFIG_MEDIA_TUNER_MT2060 is not set
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=y
# CONFIG_MEDIA_TUNER_XC4000 is not set
CONFIG_MEDIA_TUNER_MXL5005S=m
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=y
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=y
# CONFIG_MEDIA_TUNER_FC0011 is not set
CONFIG_MEDIA_TUNER_FC0012=y
# CONFIG_MEDIA_TUNER_FC0013 is not set
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=y
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88TS2022=y
# CONFIG_MEDIA_TUNER_TUA9001 is not set
# CONFIG_MEDIA_TUNER_IT913X is not set
CONFIG_MEDIA_TUNER_R820T=m

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=y
CONFIG_DVB_STB6100=y
# CONFIG_DVB_STV090x is not set
# CONFIG_DVB_STV6110x is not set

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
# CONFIG_DVB_CX24123 is not set
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=y
CONFIG_DVB_S5H1420=y
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=m
# CONFIG_DVB_STV6110 is not set
# CONFIG_DVB_STV0900 is not set
CONFIG_DVB_TDA8083=y
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=y
CONFIG_DVB_TUNER_ITD1000=m
# CONFIG_DVB_TUNER_CX24113 is not set
CONFIG_DVB_TDA826X=y
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=y
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=y
# CONFIG_DVB_DS3000 is not set
# CONFIG_DVB_MB86A16 is not set
# CONFIG_DVB_TDA10071 is not set

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=y
# CONFIG_DVB_CX22700 is not set
CONFIG_DVB_CX22702=m
# CONFIG_DVB_S5H1432 is not set
# CONFIG_DVB_DRXD is not set
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
CONFIG_DVB_MT352=y
CONFIG_DVB_ZL10353=y
CONFIG_DVB_DIB3000MB=y
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
# CONFIG_DVB_DIB7000P is not set
# CONFIG_DVB_DIB9000 is not set
CONFIG_DVB_TDA10048=y
CONFIG_DVB_AF9013=y
# CONFIG_DVB_EC100 is not set
CONFIG_DVB_HD29L2=m
CONFIG_DVB_STV0367=y
CONFIG_DVB_CXD2820R=y
CONFIG_DVB_RTL2830=y
CONFIG_DVB_RTL2832=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
# CONFIG_DVB_TDA10021 is not set
CONFIG_DVB_TDA10023=y
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=y
# CONFIG_DVB_OR51211 is not set
CONFIG_DVB_OR51132=y
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LG2160=y
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=y
# CONFIG_DVB_AU8522_DTV is not set
CONFIG_DVB_AU8522_V4L=y
# CONFIG_DVB_S5H1411 is not set

#
# ISDB-T (terrestrial) frontends
#
# CONFIG_DVB_S921 is not set
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
# CONFIG_DVB_LNBP22 is not set
# CONFIG_DVB_ISL6405 is not set
# CONFIG_DVB_ISL6421 is not set
# CONFIG_DVB_ISL6423 is not set
# CONFIG_DVB_A8293 is not set
CONFIG_DVB_LGS8GL5=m
# CONFIG_DVB_LGS8GXX is not set
CONFIG_DVB_ATBM8830=m
# CONFIG_DVB_TDA665x is not set
CONFIG_DVB_IX2505V=y
# CONFIG_DVB_IT913X_FE is not set
CONFIG_DVB_M88RS2000=m
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
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
# CONFIG_DRM_AST is not set
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
# CONFIG_DRM_QXL is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
CONFIG_BACKLIGHT_LM3533=m
# CONFIG_BACKLIGHT_PWM is not set
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_ADP5520=m
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_ADP8870=m
# CONFIG_BACKLIGHT_LM3630A is not set
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
CONFIG_BACKLIGHT_LP8788=m
CONFIG_BACKLIGHT_TPS65217=m
CONFIG_BACKLIGHT_LV5207LP=m
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
CONFIG_UHID=m
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
CONFIG_HID_CHERRY=m
CONFIG_HID_CHICONY=m
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
CONFIG_HID_LENOVO_TPKBD=m
# CONFIG_HID_LOGITECH is not set
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
# CONFIG_HID_MONTEREY is not set
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_ORTEK is not set
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
# CONFIG_HID_PICOLCD_BACKLIGHT is not set
CONFIG_HID_PICOLCD_LEDS=y
# CONFIG_HID_PICOLCD_CIR is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SPEEDLINK is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
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
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
# CONFIG_MMC_SDHCI_PCI is not set
# CONFIG_MMC_SDHCI_ACPI is not set
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=m
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
# CONFIG_MSPRO_BLOCK is not set
CONFIG_MS_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
# CONFIG_MEMSTICK_TIFM_MS is not set
# CONFIG_MEMSTICK_JMICRON_38X is not set
# CONFIG_MEMSTICK_R592 is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_LM3533=m
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_LP8788=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_PCA9685 is not set
CONFIG_LEDS_PWM=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_ADP5520=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=m
CONFIG_LEDS_OT200=m
CONFIG_LEDS_BLINKM=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_LEDS_TRIGGER_CAMERA is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
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
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM80X=m
# CONFIG_RTC_DRV_DS1307 is not set
CONFIG_RTC_DRV_DS1374=y
CONFIG_RTC_DRV_DS1672=m
# CONFIG_RTC_DRV_DS3232 is not set
CONFIG_RTC_DRV_LP8788=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=y
# CONFIG_RTC_DRV_MAX8998 is not set
# CONFIG_RTC_DRV_MAX77686 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_ISL12057 is not set
CONFIG_RTC_DRV_X1205=y
CONFIG_RTC_DRV_PCF2127=m
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TPS6586X is not set
CONFIG_RTC_DRV_RC5T583=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1742 is not set
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_DS2404=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MOXART=m

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
# CONFIG_UIO_CIF is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=m
# CONFIG_UIO_AEC is not set
# CONFIG_UIO_SERCOS3 is not set
# CONFIG_UIO_PCI_GENERIC is not set
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

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
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_MAILBOX=y
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
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
CONFIG_FMC_TRIVIAL=m
CONFIG_FMC_WRITE_EEPROM=m
CONFIG_FMC_CHARDEV=m

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=m
CONFIG_PHY_EXYNOS_MIPI_VIDEO=m
# CONFIG_BCM_KONA_USB2_PHY is not set
CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL=y

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
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
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=m
# CONFIG_EXT4_USE_FOR_EXT23 is not set
# CONFIG_EXT4_FS_POSIX_ACL is not set
CONFIG_EXT4_FS_SECURITY=y
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
CONFIG_OCFS2_DEBUG_FS=y
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=m
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
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=y
CONFIG_CUSE=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_DEBUG=y
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
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
# CONFIG_PROC_FS is not set
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
CONFIG_ADFS_FS_RW=y
# CONFIG_AFFS_FS is not set
CONFIG_ECRYPT_FS=m
CONFIG_ECRYPT_FS_MESSAGING=y
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
CONFIG_SQUASHFS_DECOMP_MULTI=y
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZO=y
# CONFIG_SQUASHFS_XZ is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=m
CONFIG_QNX6FS_FS=y
# CONFIG_QNX6FS_DEBUG is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
CONFIG_PSTORE_RAM=y
CONFIG_SYSV_FS=m
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
CONFIG_CEPH_FS=y
# CONFIG_CEPH_FSCACHE is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=m
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=y
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=m
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=y
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=m
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
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
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
CONFIG_DEBUG_OBJECTS_TIMERS=y
CONFIG_DEBUG_OBJECTS_WORK=y
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_DEBUG_SLAB is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_VM_RB=y
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
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
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0

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
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_KOBJECT_RELEASE=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
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
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_RBTREE_TEST=y
CONFIG_INTERVAL_TREE_TEST=m
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
CONFIG_TEST_STRING_HELPERS=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
CONFIG_DMA_API_DEBUG=y
# CONFIG_TEST_MODULE is not set
# CONFIG_TEST_USER_COPY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
CONFIG_IO_DELAY_0XED=y
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=1
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_STATIC_CPU_HAS=y

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
CONFIG_ENCRYPTED_KEYS=m
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
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
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
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
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
CONFIG_CRYPTO_GHASH=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=m
CONFIG_CRYPTO_SHA256_SSSE3=y
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=y
# CONFIG_CRYPTO_ARC4 is not set
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=y
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_X86_64 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
# CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_ZLIB=m
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_LZ4=y
CONFIG_CRYPTO_LZ4HC=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
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
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
# CONFIG_CRC32_SLICEBY8 is not set
CONFIG_CRC32_SLICEBY4=y
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_CRC64_ECMA=m
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_COMPRESS=y
CONFIG_LZ4HC_COMPRESS=m
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=m
# CONFIG_XZ_DEC_X86 is not set
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_BCH=y
CONFIG_BCH_CONST_PARAMS=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
# CONFIG_CPUMASK_OFFSTACK is not set
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y

--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-xian-38:20140113065540:x86_64-randconfig-s1-01101738:3.12.0-rc4-00008-g6e6a493:614"
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel
KASLR using RDTSC...

Decompressing Linux... Parsing ELF... Performing relocations... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-rc4-00008-g6e6a493 (wfg@bee) (gcc versi=
on 4.8.1 (Debian 4.8.1-3) ) #614 SMP Mon Jan 13 02:25:31 CST 2014
[    0.000000] Command line: hung_task_panic=3D1 earlyprintk=3DttyS0,115200=
 debug apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 con=
sole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/next:master:6e=
6a4932b0f569b1a5bb4fcbf5dde1b1a42f01bb:bisect-mm/.vmlinuz-6e6a4932b0f569b1a=
5bb4fcbf5dde1b1a42f01bb-20140113022701-962-xian branch=3Dnext/master BOOT_I=
MAGE=3D/kernel/x86_64-randconfig-s1-01101738/6e6a4932b0f569b1a5bb4fcbf5dde1=
b1a42f01bb/vmlinuz-3.12.0-rc4-00008-g6e6a493
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
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
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
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x07886000, 0x07886fff] PGTABLE
[    0.000000] BRK [0x07887000, 0x07887fff] PGTABLE
[    0.000000] BRK [0x07888000, 0x07888fff] PGTABLE
PANIC: early exception 0e rip 10:ffffffff86204c6e error 0 cr2 ffffffff81972=
b28
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.0-rc4-00008-g6e=
6a493 #614
PANIC: early exception 0e rip 10:ffffffff86204f22 error 0 cr2 ffffffff81972=
b28

BUG: kernel boot hang
Elapsed time: 610
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig=
-s1-01101738/6e6a4932b0f569b1a5bb4fcbf5dde1b1a42f01bb/vmlinuz-3.12.0-rc4-00=
008-g6e6a493 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug =
apic=3Ddebug sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3D=
ttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kerne=
l-tests/run-queue/kvm/x86_64-randconfig-s1-01101738/next:master:6e6a4932b0f=
569b1a5bb4fcbf5dde1b1a42f01bb:bisect-mm/.vmlinuz-6e6a4932b0f569b1a5bb4fcbf5=
dde1b1a42f01bb-20140113022701-962-xian branch=3Dnext/master BOOT_IMAGE=3D/k=
ernel/x86_64-randconfig-s1-01101738/6e6a4932b0f569b1a5bb4fcbf5dde1b1a42f01b=
b/vmlinuz-3.12.0-rc4-00008-g6e6a493'  -initrd /kernel-tests/initrd/yocto-mi=
nimal-x86_64.cgz -m 256M -smp 2 -net nic,vlan=3D1,model=3De1000 -net user,v=
lan=3D1,hostfwd=3Dtcp::18140-:22 -boot order=3Dnc -no-reboot -watchdog i630=
0esb -rtc base=3Dlocaltime -drive file=3D/fs/LABEL=3DKVM/disk0-yocto-xian-3=
8,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk1-yocto-xian-3=
8,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-yocto-xian-3=
8,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-yocto-xian-3=
8,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-yocto-xian-3=
8,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-yocto-xian-3=
8,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-yocto-xian-38 -seria=
l file:/dev/shm/kboot/serial-yocto-xian-38 -daemonize -display none -monito=
r null=20

--uZ3hkaAS1mZxFaxD--
