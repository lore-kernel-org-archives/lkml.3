Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaCGWSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 17:18:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:1160 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaCGWSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 17:18:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,610,1389772800"; 
   d="log'?scan'208";a="488192988"
Date: Sat, 8 Mar 2014 06:18:36 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [torture] BUG: soft lockup - CPU#0 stuck for 22s!
 [lock_torture_wr:26]
Message-ID: <20140307221836.GB9286@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
In-Reply-To: <20140307051551.GR3334@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 06, 2014 at 09:15:51PM -0800, Paul E. McKenney wrote:
> On Fri, Mar 07, 2014 at 09:28:47AM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit is
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/dev
> > commit 1f9c26968e1a501f3a839603c9633f21abca65b3
> > Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > AuthorDate: Tue Mar 4 11:03:21 2014 -0800
> > Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > CommitDate: Wed Mar 5 07:49:28 2014 -0800
> > 
> >     torture: Increase stutter-end intensity
> 
> Hmmm...  A bit too intense, you say?  I will tone it down a bit.

Maybe too intense, or it helps trigger some other kernel hang bug in
this bisect:

+-------------------------------------+------------+------------+
|                                     | 1f9c26968e | d478a960ed |
+-------------------------------------+------------+------------+
| boot_successes                      | 9          | 2          |
| boot_failures                       | 76         | 17         |
| BUG:kernel_test_hang                | 54         | 15         |
| BUG:kernel_boot_hang                | 22         | 2          |
| page_allocation_failure:order:,mode | 2          |            |
| backtrace:vmalloc                   | 2          |            |
| backtrace:SyS_init_module           | 2          |            |
+-------------------------------------+------------+------------+

[   14.243909] can: request_module (can-proto-5) failed.
[   14.259351] can: request_module (can-proto-3) failed.

BUG: kernel test hang
Elapsed time: 3605

Unfortunately there's no much information in the dmesg - the kernel
just hangs there.

git bisect start d478a960edf1ea61ca31a07a48a8771f043dba78 0414855fdc4a40da05221fc6062cccbc0c30f169 --
git bisect good 6c2191ad9b6225860eef70a77d300c3d5ad39182  # 14:31     25+      0  Merge 'digsig/for-mimi' into devel-hourly-2014030618
git bisect  bad 8d06d39b2d95c1c3f10ce3d1969e1e381935bbaf  # 15:35     14-      2  Merge 'rcu/rcu/dev' into devel-hourly-2014030618
git bisect good 6845af00920e6b0d6e252c44784aaca3b0d2f42f  # 15:46     85+      0  Merge 'drm-intel/drm-intel-nightly' into devel-hourly-2014030618
git bisect good e5a16a9dbec8844bbd4b35ba52fef5c5f22e1e6a  # 15:54     85+      0  Merge 'ath6kl/ath-next-test' into devel-hourly-2014030618
git bisect good 5c709b0d8abc5dac4d7323fe6e3fdc8e6c4d0e59  # 16:11     85+      0  Merge 'tip/x86/efi' into devel-hourly-2014030618
git bisect good fbe938e4f6c837ca17c284c001b43bb21d5ca389  # 16:20     85+      0  Merge 'arm-soc/next/drivers' into devel-hourly-2014030618
git bisect good b46f358ae5e3558a9072f0354128d5749a584d01  # 19:16     85+      0  rcutorture: Place kvm-test-1-run.sh output into res directory
git bisect good f5604f67fe8cbd6f2088b20b9463f721aa613d4b  # 19:36     85+      0  Merge branch 'torture.2014.02.23a' into HEAD
git bisect good dd35b81c341c685bafd15bc9a6bfa79584e07b07  # 19:54     85+      0  torture: Rename RCU_BUILDONLY to TORTURE_BUILDONLY
git bisect good 8864f0996e8b7f07a536aa07553c4461cd5f4211  # 20:09     85+      0  torture: Make "--dryrun script" output self-sufficient
git bisect good b2d777a6d9d64929b9701f1905fdeda8fc3cb16d  # 20:28     85+      0  rcutorture: Print negatives for SRCU counter wraparound
git bisect good 4c79d7d89902a2e9c96b3db5115af52b3cf94da9  # 23:54     85+      0  torture: Report diagnostics from qemu
git bisect  bad 1f9c26968e1a501f3a839603c9633f21abca65b3  # 00:56     31-     23  torture: Increase stutter-end intensity
# first bad commit: [1f9c26968e1a501f3a839603c9633f21abca65b3] torture: Increase stutter-end intensity
git bisect good 4c79d7d89902a2e9c96b3db5115af52b3cf94da9  # 01:05    990+      0  torture: Report diagnostics from qemu
git bisect  bad d478a960edf1ea61ca31a07a48a8771f043dba78  # 01:05      0-     17  0day head guard for 'devel-hourly-2014030618'
git bisect good 78e760ddde020af97bd84c3ec2199cd3832fdb2e  # 01:23    990+      0  Revert "torture: Increase stutter-end intensity"
git bisect good c3bebc71c4bcdafa24b506adf0c1de3c1f77e2e0  # 01:56    990+      0  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect  bad 1b0a7e3263168a06d3858798e48c5a21d1c78d3c  # 03:23    971-     10  Add linux-next specific files for 20140307

Thanks,
Fengguang

--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-roam-33:20140307103855:i386-randconfig-st0-03070745:3.14.0-rc5-03765-gd478a96:2"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.14.0-rc5-03765-gd478a96 (kbuild@stoakley) (g=
cc version 4.8.1 (Debian 4.8.1-8) ) #2 Fri Mar 7 09:09:42 CST 2014
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x1000000
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
[    0.000000] initial memory mapped: [mem 0x00000000-0x02ffffff]
[    0.000000] Base memory trampoline at [8009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0e5fffff]
[    0.000000]  [mem 0x0e400000-0x0e5fffff] page 4k
[    0.000000] BRK [0x0260a000, 0x0260afff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e3fffff]
[    0.000000]  [mem 0x0c000000-0x0e3fffff] page 4k
[    0.000000] BRK [0x0260b000, 0x0260bfff] PGTABLE
[    0.000000] BRK [0x0260c000, 0x0260cfff] PGTABLE
[    0.000000] BRK [0x0260d000, 0x0260dfff] PGTABLE
[    0.000000] BRK [0x0260e000, 0x0260efff] PGTABLE
[    0.000000] BRK [0x0260f000, 0x0260ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0fffdfff]
[    0.000000]  [mem 0x0e600000-0x0fffdfff] page 4k
[    0.000000] RAMDISK: [mem 0x0e7ab000-0x0ffeffff]
[    0.000000] ACPI: RSDP 0x000FD930 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x0FFFE450 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x0FFFFF80 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x0FFFE490 0011A9 (v01 BXPC   BXDSDT   00000001 I=
NTL 20100528)
[    0.000000] ACPI: FACS 0x0FFFFF40 000040
[    0.000000] ACPI: SSDT 0x0FFFF7A0 000796 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x0FFFF680 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x0FFFF640 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000] free_area_init_node: node 0, pgdat 81d9d7dc, node_mem_map 8e=
35e024
[    0.000000]   DMA zone: 36 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 540 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffff9000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1=
/0x1 ignored.
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
[    0.000000] mapped IOAPIC to ffff8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1d3af00
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64860
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=
=3D1 nmi_watchdog=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 consol=
e=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/k=
vm/i386-randconfig-st0-03070745/linux-devel:devel-hourly-2014030618/.vmlinu=
z-d478a960edf1ea61ca31a07a48a8771f043dba78-20140307091042-5-roam branch=3Dl=
inux-devel/devel-hourly-2014030618 BOOT_IMAGE=3D/kernel/i386-randconfig-st0=
-03070745/d478a960edf1ea61ca31a07a48a8771f043dba78/vmlinuz-3.14.0-rc5-03765=
-gd478a96
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Memory: 211276K/261744K available (8484K kernel code, 2951K =
rwdata, 4952K rodata, 748K init, 5320K bss, 50468K reserved)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff9e000 - 0xfffff000   ( 388 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xfff9c000   (1783 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x82004000 - 0x820bf000   ( 748 kB)
[    0.000000]       .data : 0x8184943b - 0x82002d80   (7910 kB)
[    0.000000]       .text : 0x81000000 - 0x8184943b   (8485 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=3D8dc02000 soft=3D8dc04000
[    0.000000] ACPI: Core revision 20140214
[    0.000000] ACPI: All ACPI Tables successfully acquired
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
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2892.998 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5785.99 Bogo=
MIPS (lpj=3D11571992)
[    0.008000] pid_max: default: 4096 minimum: 301
[    0.008135] Security Framework initialized
[    0.008905] Mount-cache hash table entries: 512
[    0.012228] Initializing cgroup subsys debug
[    0.013017] Initializing cgroup subsys devices
[    0.013826] Initializing cgroup subsys perf_event
[    0.014645] Initializing cgroup subsys net_prio
[    0.015613] mce: CPU supports 10 MCE banks
[    0.016103] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.016103] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.017976] CPU: Intel Common KVM processor (fam: 0f, model: 06, steppin=
g: 01)
[    0.021635] ftrace: allocating 28045 entries in 55 pages
[    0.036734] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.042539] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.044030] Getting VERSION: 50014
[    0.044635] Getting VERSION: 50014
[    0.045226] Getting ID: 0
[    0.045695] Getting ID: f000000
[    0.046254] Getting LVT0: 8700
[    0.046794] Getting LVT1: 8400
[    0.048139] enabled ExtINT on CPU#0
[    0.050390] ENABLING IO-APIC IRQs
[    0.050997] init IO_APIC IRQs
[    0.051523]  apic 0 pin 0 not connected
[    0.052083] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.053392] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.054681] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.056061] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.057438] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.058799] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.060062] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.061387] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.062666] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.064059] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.065439] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.066832] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.068063] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.069474] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.072056] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.073448]  apic 0 pin 16 not connected
[    0.074132]  apic 0 pin 17 not connected
[    0.076014]  apic 0 pin 18 not connected
[    0.076666]  apic 0 pin 19 not connected
[    0.077335]  apic 0 pin 20 not connected
[    0.078013]  apic 0 pin 21 not connected
[    0.078675]  apic 0 pin 22 not connected
[    0.079342]  apic 0 pin 23 not connected
[    0.080188] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.081566] Using local APIC timer interrupts.
[    0.081566] calibrating APIC timer ...
[    0.084000] ... lapic delta =3D 6250126
[    0.084000] ... PM-Timer delta =3D 357958
[    0.084000] ... PM-Timer result ok
[    0.084000] ..... delta 6250126
[    0.084000] ..... mult: 268440867
[    0.084000] ..... calibration result: 4000080
[    0.084000] ..... CPU clock speed is 2892.3924 MHz.
[    0.084000] ..... host bus clock speed is 1000.0080 MHz.
[    0.085552] devtmpfs: initialized
[    0.089275] prandom: seed boundary self test passed
[    0.091300] prandom: 100 self tests passed
[    0.093469] regulator-dummy: no parameters
[    0.094932] NET: Registered protocol family 16
[    0.097424] EISA bus registered
[    0.098212] cpuidle: using governor menu
[    0.099674] ACPI: bus type PCI registered
[    0.100687] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.102280] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.104015] PCI: Using configuration type 1 for base access
[    0.123171] gpio-f7188x: Not a Fintek device at 0x0000002e
[    0.124069] gpio-f7188x: Not a Fintek device at 0x0000004e
[    0.125830] ACPI: Added _OSI(Module Device)
[    0.126775] ACPI: Added _OSI(Processor Device)
[    0.128014] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.129069] ACPI: Added _OSI(Processor Aggregator Device)
[    0.152994] ACPI: Interpreter enabled
[    0.153869] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140214/hwxface-580)
[    0.155883] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140214/hwxface-580)
[    0.157325] ACPI: (supports S0 S3)
[    0.158115] ACPI: Using IOAPIC for interrupt routing
[    0.160139] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.190577] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.192015] acpi PNP0A03:00: _OSC: OS supports [Segments MSI]
[    0.193427] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.196394] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.199414] PCI host bridge to bus 0000:00
[    0.200023] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.201238] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.202591] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.204023] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.205519] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.207184] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.209527] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.213225] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.219164] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.223001] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.224606] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.226208] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.229128] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.233168] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.238382] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.252152] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.255165] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.257775] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.260955] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.270510] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.273471] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.276898] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.280023] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.290953] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.293812] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.297772] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.309037] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.312027] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.315059] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.326455] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.329859] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.332908] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.344218] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.347420] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.349763] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.361144] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.364863] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.367796] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.379278] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.380954] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.389126] pci_bus 0000:00: on NUMA node 0
[    0.395126] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.397877] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.401397] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.404308] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.406332] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.412156] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.413913] vgaarb: loaded
[    0.414525] vgaarb: bridge control possible 0000:00:02.0
[    0.417860] SCSI subsystem initialized
[    0.419347] libata version 3.00 loaded.
[    0.420378] ACPI: bus type USB registered
[    0.421665] usbcore: registered new interface driver usbfs
[    0.422906] usbcore: registered new interface driver hub
[    0.424243] usbcore: registered new device driver usb
[    0.426196] pps_core: LinuxPPS API ver. 1 registered
[    0.427301] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.428223] PTP clock support registered
[    0.429418] PCI: Using ACPI for IRQ routing
[    0.430350] PCI: pci_cache_line_size set to 64 bytes
[    0.432392] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.433744] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.439041] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.440495] Switched to clocksource kvm-clock
[    0.442776] Warning: could not register all branches stats
[    0.443659] Warning: could not register annotated branches stats
[    0.494318] pnp: PnP ACPI init
[    0.495138] ACPI: bus type PNP registered
[    0.496267] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.498244] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.499955] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.502012] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.503586] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.505478] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.507075] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.508763] pnp 00:03: [dma 2]
[    0.509576] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.511225] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.513185] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.514783] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.516645] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.519266] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.521728] pnp: PnP ACPI: found 7 devices
[    0.522674] ACPI: bus type PNP unregistered
[    0.523626] PnPBIOS: Disabled
[    0.561698] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.562972] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.564244] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.565609] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.567092] NET: Registered protocol family 1
[    0.568113] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.569412] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.570678] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.572130] pci 0000:00:02.0: Boot video device
[    0.573265] PCI: CLS 0 bytes, default 64
[    0.574919] Unpacking initramfs...
[    2.622433] debug: unmapping init [mem 0x8e7ab000-0x8ffeffff]
[    2.626214] apm: BIOS not found.
[    2.629044] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    2.631276] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    2.634663] spin_lock-torture: Creating torture_shuffle task
[    2.636260] spin_lock-torture: Creating torture_stutter task
[    2.637629] spin_lock-torture: torture_shuffle task started
[    2.638885] spin_lock-torture: Creating lock_torture_writer task
[    2.640354] spin_lock-torture: torture_stutter task started
[    2.641608] spin_lock-torture: Creating lock_torture_writer task
[    2.643052] spin_lock-torture: lock_torture_writer task started
[    2.644480] spin_lock-torture: Creating lock_torture_stats task
[    2.645887] spin_lock-torture: lock_torture_writer task started
[    2.648393] futex hash table entries: 16 (order: -3, 640 bytes)
[    2.649761] audit: initializing netlink subsys (disabled)
[    2.651223] audit: type=3D2000 audit(1394154659.708:1): initialized
[    2.652858] spin_lock-torture: lock_torture_stats task started
[    2.656268] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.657761] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.658734] QNX6 filesystem 1.0.0 registered.
[    2.659722] NILFS version 2 loaded
[    2.666153] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    2.667839] io scheduler noop registered
[    2.668774] io scheduler cfq registered (default)
[    2.669749] list_sort_test: start testing list_sort()
[    2.671993] test_string_helpers: Running tests...
[    2.674832] vmlfb: initializing
[    2.675705] Could not find Carillo Ranch MCH device.
[    2.677978] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    2.681547] usbcore: registered new interface driver udlfb
[    2.682880] usbcore: registered new interface driver smscufx
[    2.858466] r3964: Philips r3964 Driver $Revision: 1.10 $
[    2.859767] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.886493] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    2.895030] serial: Freescale lpuart driver
[    2.898194] lp: driver loaded but no devices found
[    2.899353] toshiba: not a supported Toshiba laptop
[    2.901402] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    2.903033] platform pc8736x_gpio.0: no device found
[    2.904563] nsc_gpio initializing
[    2.905402] smapi::smapi_init, ERROR invalid usSmapiID
[    2.906570] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[    2.908757] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[    2.910429] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    2.913779] [drm] Initialized drm 1.1.0 20060810
[    2.917313] parport_pc 00:04: reported by Plug and Play ACPI
[    2.918942] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    3.017736] lp0: using parport0 (interrupt-driven).
[    3.021359] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    3.026703] Loading iSCSI transport class v2.0-870.
[    3.029787] rdac: device handler registered
[    3.031042] alua: device handler registered
[    3.031996] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    3.036507] SSFDC read-only Flash Translation layer
[    3.038817] mtdoops: mtd device (mtddev=3Dname/number) must be supplied
[    3.040474] parport0: powerup/reset Butterfly
[    3.156400] parport_pc 00:04: registered master spi42
[    3.158060] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    3.159281] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    3.162037] parport_pc 00:04: registered child spi42.1
[    3.163167] parport0: dataflash at spi42.1
[    3.164178] parport0: AVR Butterfly
[    3.170282] libphy: Fixed MDIO Bus: probed
[    3.172465] arcnet loaded.
[    3.173143] arcnet: raw mode (`r') encapsulation support loaded.
[    3.174550] arcnet: COM90xx chipset support
[    3.175797] S1: No ARCnet cards found.
[    3.176784] arcnet: RIM I (entirely mem-mapped) support
[    3.177948] E-mail me if you actually test the RIM I driver, please!
[    3.179412] Given: node 00h, shmem 0h, irq 0
[    3.180466] No autoprobe for RIM I; you must specify the shmem and irq!
[    3.181970] arcnet: COM20020 PCI support
[    3.182878] vcan: Virtual CAN interface driver
[    3.183834] slcan: serial line CAN interface driver
[    3.184935] slcan: 10 dynamic interface channels.
[    3.187326] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    3.189041] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    3.194311] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    3.195663] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    3.578460] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    3.580199] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    3.582731] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    3.583912] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    3.585290] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    3.586732] igb: Copyright (c) 2007-2014 Intel Corporation.
[    3.590359] PPP generic driver version 2.4.2
[    3.591671] PPP BSD Compression module registered
[    3.592817] PPP MPPE Compression module registered
[    3.593958] usbcore: registered new interface driver catc
[    3.596199] usbcore: registered new interface driver rtl8150
[    3.597570] usbcore: registered new interface driver ax88179_178a
[    3.598912] usbcore: registered new interface driver CoreChips
[    3.600372] usbcore: registered new interface driver gl620a
[    3.601600] usbcore: registered new interface driver net1080
[    3.603719] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    3.605412] usbcore: registered new interface driver kalmia
[    3.606694] usbcore: registered new interface driver sierra_net
[    3.608113] usbcore: registered new interface driver cx82310_eth
[    3.609491] usbcore: registered new interface driver cdc_ncm
[    3.611685] usbcore: registered new interface driver huawei_cdc_ncm
[    3.613237] usbcore: registered new interface driver cdc_mbim
[    3.614457] I2O subsystem v1.325
[    3.615142] i2o: max drivers =3D 8
[    3.616357] I2O Configuration OSM v1.323
[    3.618326] I2O ProcFS OSM v1.316
[    3.619187] Fusion MPT base driver 3.04.20
[    3.620170] Copyright (c) 1999-2008 LSI Corporation
[    3.621247] Fusion MPT SAS Host driver 3.04.20
[    3.622364] Fusion MPT misc device (ioctl) driver 3.04.20
[    3.624379] tsc: Refined TSC clocksource calibration: 2892.962 MHz
[    3.625756] mptctl: Registered with Fusion MPT base driver
[    3.626910] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    3.629689] fotg210_hcd: FOTG210 Host Controller (EHCI) Driver
[    3.631160] usbcore: registered new interface driver cdc_wdm
[    3.632510] usbcore: registered new interface driver usb-storage
[    3.633855] usbcore: registered new interface driver ums-freecom
[    3.635257] usbcore: registered new interface driver ums-isd200
[    3.637645] usbcore: registered new interface driver ums-sddr55
[    3.639042] usbcore: registered new interface driver microtekX6
[    3.640466] usbcore: registered new interface driver cytherm
[    3.641772] usbcore: registered new interface driver emi62 - firmware lo=
ader
[    3.643369] usbcore: registered new interface driver usbled
[    3.644637] usbcore: registered new interface driver usbsevseg
[    3.647363] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    3.651519] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.652733] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.653916] parport0: cannot grant exclusive access for device parkbd
[    3.657678] usbcore: registered new interface driver bcm5974
[    3.660433] usbcore: registered new interface driver usb_acecad
[    3.663036] mk712: device not present
[    3.664592] usbcore: registered new interface driver sur40
[    3.667018] usbcore: registered new interface driver powermate
[    3.671037] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    3.674970] usbcore: registered new interface driver yealink
[    3.676324] ideapad_slidebar: DMI does not match
[    3.677643] rtc_cmos 00:00: RTC can wake from S4
[    3.680785] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    3.682439] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    3.687297] rtc-test rtc-test.0: rtc core: registered test as rtc1
[    3.689853] rtc-test rtc-test.1: rtc core: registered test as rtc2
[    3.692750] usbcore: registered new interface driver i2c-tiny-usb
[    3.695563] isa i2c-pca-isa.0: Please specify I/O base
[    3.697410] pps pps0: new PPS source ktimer
[    3.698583] pps pps0: ktimer PPS source registered
[    3.701415] mixcomwd: No card detected, or port not available
[    3.703095] sc520_wdt: WDT driver for SC520 initialised. timeout=3D30 se=
c (nowayout=3D0)
[    3.704936] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    3.706745] wafer5823wdt: cannot register miscdev on minor=3D130 (err=3D=
-16)
[    3.708373] it87_wdt: no device
[    3.709093] sbc60xxwdt: cannot register miscdev on minor=3D130 (err=3D-1=
6)
[    3.710562] sbc8360: failed to register misc device
[    3.711682] cpu5wdt: misc_register failed
[    3.712663] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    3.715843] smsc37b787_wdt: Unable to register miscdev on minor 130
[    3.717551] w83697ug_wdt: WDT driver for the Winbond(TM) W83697UG/UF Sup=
er I/O chip initialising
[    3.719567] w83697ug_wdt: No W83697UG/UF could be found
[    3.722898] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    3.726271] leds_ss4200: no LED devices found
[    3.728479] hidraw: raw HID events driver (C) Jiri Kosina
[    3.734562] usbcore: registered new interface driver usbhid
[    3.735875] usbhid: USB HID core driver
[    3.737952] usbcore: registered new interface driver rts5139
[    3.753332] ion_chunk_heap_create: base 8388608 size 4194304 align 16384
[    3.755459] ashmem: initialized
[    3.757902] logger: created 256K log 'log_main'
[    3.759471] logger: created 256K log 'log_events'
[    3.761075] logger: created 256K log 'log_radio'
[    3.763631] logger: created 256K log 'log_system'
[    3.766437] ozwpan ozwpan: Ozmo Devices WPAN
[    3.768456] ozwpan ozwpan: new USB bus registered, assigned bus number 1
[    3.770737] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    3.772311] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    3.773964] usb usb1: Product: Ozmo Devices WPAN
[    3.775017] usb usb1: Manufacturer: Linux 3.14.0-rc5-03765-gd478a96 Ozmo=
 WPAN
[    3.776667] usb usb1: SerialNumber: ozwpan
[    3.780797] hub 1-0:1.0: USB hub found
[    3.781810] hub 1-0:1.0: 8 ports detected
[    3.786275] usbcore: registered new interface driver gdm_wimax
[    3.787771] usbcore: registered new interface driver cedusb
[    3.789226] dgnc: dgnc-1.3-16, Digi International Part Number 40002369_F
[    3.790781] dgnc: For the tools package or updated drivers please visit =
http://www.digi.com
[    3.794522] dgap: dgap-1.3-16, Digi International Part Number 40002347_C
[    3.796153] dgap: For the tools package or updated drivers please visit =
http://www.digi.com
[    3.799880] acerhdf: Acer Aspire One Fan driver, v.0.5.26
[    3.801229] acerhdf: unknown (unsupported) BIOS version Bochs/Bochs/Boch=
s, please report, aborting!
[    3.806092] NET: Registered protocol family 5
[    3.807775] can: controller area network core (rev 20120528 abi 9)
[    3.809383] NET: Registered protocol family 29
[    3.810444] can: netlink gateway (rev 20130117) max_hops=3D1
[    3.811715] mpls_gso: MPLS GSO support
[    3.814981]=20
[    3.814981] printing PIC contents
[    3.816307] ... PIC  IMR: ffff
[    3.817046] ... PIC  IRR: 1113
[    3.817770] ... PIC  ISR: 0000
[    3.818467] ... PIC ELCR: 0c00
[    3.819139] printing local APIC contents on CPU#0/0:
[    3.820071] ... APIC ID:      00000000 (0)
[    3.820071] ... APIC VERSION: 00050014
[    3.820071] ... APIC TASKPRI: 00000000 (00)
[    3.820071] ... APIC PROCPRI: 00000000
[    3.820071] ... APIC LDR: 01000000
[    3.820071] ... APIC DFR: ffffffff
[    3.820071] ... APIC SPIV: 000001ff
[    3.820071] ... APIC ISR field:
[    3.820071] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.820071] ... APIC TMR field:
[    3.820071] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.820071] ... APIC IRR field:
[    3.820071] 000000000000000000000000000000000000000000000000000000000000=
8000
[    3.820071] ... APIC ESR: 00000000
[    3.820071] ... APIC ICR: 00000831
[    3.820071] ... APIC ICR2: 01000000
[    3.820071] ... APIC LVTT: 000000ef
[    3.820071] ... APIC LVTPC: 00010000
[    3.820071] ... APIC LVT0: 00010700
[    3.820071] ... APIC LVT1: 00000400
[    3.820071] ... APIC LVTERR: 000000fe
[    3.820071] ... APIC TMICT: 0003bd81
[    3.820071] ... APIC TMCCT: 00000000
[    3.820071] ... APIC TDCR: 00000003
[    3.820071]=20
[    3.844153] number of MP IRQ sources: 15.
[    3.845098] number of IO-APIC #0 registers: 24.
[    3.846145] testing the IO APIC.......................
[    3.847372] IO APIC #0......
[    3.848096] .... register #00: 00000000
[    3.848976] .......    : physical APIC id: 00
[    3.849966] .......    : Delivery Type: 0
[    3.850877] .......    : LTS          : 0
[    3.851774] .... register #01: 00170011
[    3.852743] .......     : max redirection entries: 17
[    3.853928] .......     : PRQ implemented: 0
[    3.854898] .......     : IO APIC version: 11
[    3.855917] .... register #02: 00000000
[    3.856885] .......     : arbitration: 00
[    3.857811] .... IRQ redirection table:
[    3.858745] 1    0    0   0   0    0    0    00
[    3.859812] 0    0    0   0   0    1    1    31
[    3.860947] 0    0    0   0   0    1    1    30
[    3.862027] 0    0    0   0   0    1    1    33
[    3.863037] 1    0    0   0   0    1    1    34
[    3.864115] 1    1    0   0   0    1    1    35
[    3.865174] 0    0    0   0   0    1    1    36
[    3.866248] 0    0    0   0   0    1    1    37
[    3.867330] 0    0    0   0   0    1    1    38
[    3.868413] 1    1    0   0   0    1    1    39
[    3.869416] 1    1    0   0   0    1    1    3A
[    3.870499] 1    1    0   0   0    1    1    3B
[    3.871430] 0    0    0   0   0    1    1    3C
[    3.872510] 0    0    0   0   0    1    1    3D
[    3.873566] 0    0    0   0   0    1    1    3E
[    3.874622] 0    0    0   0   0    1    1    3F
[    3.875684] 1    0    0   0   0    0    0    00
[    3.876825] 1    0    0   0   0    0    0    00
[    3.877891] 1    0    0   0   0    0    0    00
[    3.878958] 1    0    0   0   0    0    0    00
[    3.880091] 1    0    0   0   0    0    0    00
[    3.881169] 1    0    0   0   0    0    0    00
[    3.882235] 1    0    0   0   0    0    0    00
[    3.883280] 1    0    0   0   0    0    0    00
[    3.884473] IRQ to pin mappings:
[    3.885204] IRQ0 -> 0:2
[    3.885847] IRQ1 -> 0:1
[    3.886499] IRQ3 -> 0:3
[    3.887157] IRQ4 -> 0:4
[    3.887729] IRQ5 -> 0:5
[    3.888376] IRQ6 -> 0:6
[    3.889026] IRQ7 -> 0:7
[    3.889667] IRQ8 -> 0:8
[    3.890327] IRQ9 -> 0:9
[    3.890993] IRQ10 -> 0:10
[    3.891678] IRQ11 -> 0:11
[    3.892446] IRQ12 -> 0:12
[    3.893109] IRQ13 -> 0:13
[    3.893748] IRQ14 -> 0:14
[    3.894446] IRQ15 -> 0:15
[    3.895134] .................................... done.
[    3.896400] Using IPI Shortcut mode
[    3.899564] registered taskstats version 1
[    3.904242] rtc_cmos 00:00: setting system clock to 2014-03-07 09:11:00 =
UTC (1394183460)
[    3.910157] debug: unmapping init [mem 0x82004000-0x820befff]
[    3.911894] Write protecting the kernel text: 8488k
[    3.913276] Write protecting the kernel read-only data: 4956k
[    3.914461] NX-protecting the kernel data: 9944k
[    3.934504] random: init urandom read with 1 bits of entropy available
mountall: Event failed
[    4.176599] init: Failed to create pty - disabling logging for job
[    4.178104] init: Temporary process spawn error: No such file or directo=
ry
[    4.210950] init: Failed to create pty - disabling logging for job
[    4.212672] init: Temporary process spawn error: No such file or directo=
ry
[    4.272929] init: mounted-tmp main process (114) terminated with status =
32
mountall: Event failed
mount: wrong fs type, bad option, bad superblock on none,
       missing codepage or helper program, or other error
       (for several filesystems (e.g. nfs, cifs) you might
       need a /sbin/mount.<type> helper program)
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

mountall: mount /run [122] terminated with status 32
mountall: Filesystem could not be mounted: /run
mountall: Skipping mounting /run since Plymouth is not available
[    4.294794] init: Failed to create pty - disabling logging for job
[    4.296446] init: Temporary process spawn error: No such file or directo=
ry
[    4.305188] init: Failed to create pty - disabling logging for job
[    4.306749] init: Temporary process spawn error: No such file or directo=
ry
[    4.340611] init: Failed to create pty - disabling logging for job
[    4.342206] init: Temporary process spawn error: No such file or directo=
ry
[    4.357056] init: Failed to create pty - disabling logging for job
[    4.374486] init: Failed to create pty - disabling logging for job
udevd[133]: error: runtime directory '/run/udev' not writable, for now fall=
ing back to '/dev/.udev'
[    4.396095] init: Failed to create pty - disabling logging for job
udevd[134]: inotify_init failed: Function not implemented

udevd[134]: error initializing inotify

udevd[136]: error: runtime directory '/run/udev' not writable, for now fall=
ing back to '/dev/.udev'
udevd[139]: inotify_init failed: Function not implemented

udevd[139]: error initializing inotify

udevd[140]: error: runtime directory '/run/udev' not writable, for now fall=
ing back to '/dev/.udev'
udevd[141]: inotify_init failed: Function not implemented

udevd[141]: error initializing inotify

udevd[142]: error: runtime directory '/run/udev' not writable, for now fall=
ing back to '/dev/.udev'
udevd[143]: inotify_init failed: Function not implemented

udevd[143]: error initializing inotify

udevd[144]: error: runtime directory '/run/udev' not writable, for now fall=
ing back to '/dev/.udev'
udevd[145]: inotify_init failed: Function not implemented

udevd[145]: error initializing inotify

udevd[146]: error: runtime directory '/run/udev' not writable, for now fall=
ing back to '/dev/.udev'
udevd[147]: inotify_init failed: Function not implemented

udevd[147]: error initializing inotify

udevd[148]: error: runtime directory '/run/udev' not writable, for now fall=
ing back to '/dev/.udev'
udevd[149]: inotify_init failed: Function not implemented

udevd[149]: error initializing inotify

udevd[150]: error: runtime directory '/run/udev' not writable, for now fall=
ing back to '/dev/.udev'
udevd[151]: inotify_init failed: Function not implemented

udevd[151]: error initializing inotify

udevd[152]: error: runtime directory '/run/udev' not writable, for now fall=
ing back to '/dev/.udev'
udevd[153]: inotify_init failed: Function not implemented

udevd[153]: error initializing inotify

udevd[154]: error: runtime directory '/run/udev' not writable, for now fall=
ing back to '/dev/.udev'
udevd[155]: inotify_init failed: Function not implemented

udevd[155]: error initializing inotify

udevd[156]: error: runtime directory '/run/udev' not writable, for now fall=
ing back to '/dev/.udev'
udevd[157]: inotify_init failed: Function not implemented

udevd[157]: error initializing inotify

[   14.134637] can: request_module (can-proto-5) failed.
[   14.147568] can: request_module (can-proto-0) failed.
[   14.159499] can: request_module (can-proto-5) failed.
[   14.171609] can: request_module (can-proto-5) failed.
[   14.183826] can: request_module (can-proto-1) failed.
[   14.195755] can: request_module (can-proto-1) failed.
[   14.212073] can: request_module (can-proto-1) failed.
[   14.228087] can: request_module (can-proto-0) failed.
[   14.243909] can: request_module (can-proto-5) failed.
[   14.259351] can: request_module (can-proto-3) failed.

BUG: kernel test hang
Elapsed time: 3605
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-s=
t0-03070745/d478a960edf1ea61ca31a07a48a8771f043dba78/vmlinuz-3.14.0-rc5-037=
65-gd478a96 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug a=
pic=3Ddebug sysrq_always_enabled panic=3D10 softlockup_panic=3D1 nmi_watchd=
og=3Dpanic  prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3D=
normal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-queue/kvm/i386-randcon=
fig-st0-03070745/linux-devel:devel-hourly-2014030618/.vmlinuz-d478a960edf1e=
a61ca31a07a48a8771f043dba78-20140307091042-5-roam branch=3Dlinux-devel/deve=
l-hourly-2014030618 BOOT_IMAGE=3D/kernel/i386-randconfig-st0-03070745/d478a=
960edf1ea61ca31a07a48a8771f043dba78/vmlinuz-3.14.0-rc5-03765-gd478a96'  -in=
itrd /kernel-tests/initrd/quantal-core-i386.cgz -m 256 -smp 2 -net nic,vlan=
=3D1,model=3De1000 -net user,vlan=3D1,hostfwd=3Dtcp::16207-:22 -boot order=
=3Dnc -no-reboot -watchdog i6300esb -rtc base=3Dlocaltime -drive file=3D/fs=
/LABEL=3DKVM/disk0-quantal-roam-33,media=3Ddisk,if=3Dvirtio -drive file=3D/=
fs/LABEL=3DKVM/disk1-quantal-roam-33,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/LABEL=3DKVM/disk2-quantal-roam-33,media=3Ddisk,if=3Dvirtio -drive fi=
le=3D/fs/LABEL=3DKVM/disk3-quantal-roam-33,media=3Ddisk,if=3Dvirtio -drive =
file=3D/fs/LABEL=3DKVM/disk4-quantal-roam-33,media=3Ddisk,if=3Dvirtio -driv=
e file=3D/fs/LABEL=3DKVM/disk5-quantal-roam-33,media=3Ddisk,if=3Dvirtio -pi=
dfile /dev/shm/kboot/pid-quantal-roam-33 -serial file:/dev/shm/kboot/serial=
-quantal-roam-33 -daemonize -display none -monitor null=20

--1UWUbFP1cBYEclgG
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-st0-03070745-d478a960edf1ea61ca31a07a48a8771f043dba78-BUG:-kernel-test-hang-122581.log"
Content-Transfer-Encoding: base64

Z2l0IGNoZWNrb3V0IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAt
MDMwNzA3NDUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6MDQxNDg1NWZk
YzRhNDBkYTA1MjIxZmM2MDYyY2NjYmMwYzMwZjE2OTpiaXNlY3QtbGludXg2CiBTVUNDRVNT
CgpiaXNlY3Q6IGdvb2QgY29tbWl0IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2Jj
MGMzMGYxNjkKZ2l0IGJpc2VjdCBzdGFydCBkNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4
NzcxZjA0M2RiYTc4IDA0MTQ4NTVmZGM0YTQwZGEwNTIyMWZjNjA2MmNjY2JjMGMzMGYxNjkg
LS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6IFsiLWIiLCAiZDQ3OGE5NjBlZGYx
ZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3OCIsICItZyIsICIwNDE0ODU1ZmRjNGE0MGRh
MDUyMjFmYzYwNjJjY2NiYzBjMzBmMTY5IiwgIi9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVz
dC1ib290LWZhaWx1cmUuc2giLCAiL2tlcm5lbC10ZXN0cy9saW51eDYvb2JqLWJpc2VjdCJd
CkJpc2VjdGluZzogMzc2NSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJv
dWdobHkgMTIgc3RlcHMpCls2YzIxOTFhZDliNjIyNTg2MGVlZjcwYTc3ZDMwMGMzZDVhZDM5
MTgyXSBNZXJnZSAnZGlnc2lnL2Zvci1taW1pJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDMw
NjE4CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3QwLTAzMDcwNzQ1L2xpbnV4LWRldmVs
OmRldmVsLWhvdXJseS0yMDE0MDMwNjE4OjZjMjE5MWFkOWI2MjI1ODYwZWVmNzBhNzdkMzAw
YzNkNWFkMzkxODI6YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0wNy0xNDoyNDozNiA2YzIxOTFh
ZDliNjIyNTg2MGVlZjcwYTc3ZDMwMGMzZDVhZDM5MTgyIGNvbXBpbGluZwoxOTMgcmVhbCAg
MzMxNSB1c2VyICAyNzYgc3lzICAxODUzLjM5JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1zdDAt
MDMwNzA3NDUKCjIwMTQtMDMtMDctMTQ6Mjg6MjAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4x
NC4wLXJjNS0wMTQwMC1nNmMyMTkxYS4uLgkxNwkyNAkyNSBTVUNDRVNTCgpCaXNlY3Rpbmc6
IDIzNjUgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDEyIHN0
ZXBzKQpbOGQwNmQzOWIyZDk1YzFjM2YxMGNlM2QxOTY5ZTFlMzgxOTM1YmJhZl0gTWVyZ2Ug
J3JjdS9yY3UvZGV2JyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDMwNjE4CnJ1bm5pbmcgL2Mv
a2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3Rz
L2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9p
Mzg2LXJhbmRjb25maWctc3QwLTAzMDcwNzQ1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0y
MDE0MDMwNjE4OjhkMDZkMzliMmQ5NWMxYzNmMTBjZTNkMTk2OWUxZTM4MTkzNWJiYWY6Ymlz
ZWN0LWxpbnV4NgoKMjAxNC0wMy0wNy0xNDozMToyMSA4ZDA2ZDM5YjJkOTVjMWMzZjEwY2Uz
ZDE5NjllMWUzODE5MzViYmFmIGNvbXBpbGluZwoxODUgcmVhbCAgMzMzNyB1c2VyICAyNzkg
c3lzICAxOTU1LjM2JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUKCjIwMTQt
MDMtMDctMTQ6MzQ6NDggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wMjk3MC1n
OGQwNmQzOS4uCTUJMTIuCTEzLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTE0Li4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4gVEVTVCBGQUlMVVJFClsgICAxMi41MjQ0NzFd
IGNhbjogcmVxdWVzdF9tb2R1bGUgKGNhbi1wcm90by00KSBmYWlsZWQuClsgICAxMi41MzI1
MjFdIGNhbjogcmVxdWVzdF9tb2R1bGUgKGNhbi1wcm90by01KSBmYWlsZWQuCgpCVUc6IGtl
cm5lbCB0ZXN0IGhhbmcKRWxhcHNlZCB0aW1lOiAzNjA1CnFlbXUtc3lzdGVtLXg4Nl82NCAt
Y3B1IGt2bTY0IC1lbmFibGUta3ZtIC1rZXJuZWwgL2tlcm5lbC9pMzg2LXJhbmRjb25maWct
c3QwLTAzMDcwNzQ1LzhkMDZkMzliMmQ5NWMxYzNmMTBjZTNkMTk2OWUxZTM4MTkzNWJiYWYv
dm1saW51ei0zLjE0LjAtcmM1LTAyOTcwLWc4ZDA2ZDM5IC1hcHBlbmQgJ2h1bmdfdGFza19w
YW5pYz0xIGVhcmx5cHJpbnRrPXR0eVMwLDExNTIwMCBkZWJ1ZyBhcGljPWRlYnVnIHN5c3Jx
X2Fsd2F5c19lbmFibGVkIHBhbmljPTEwIHNvZnRsb2NrdXBfcGFuaWM9MSBubWlfd2F0Y2hk
b2c9cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlTMCwxMTUyMDAgY29uc29s
ZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxpbms9L2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUvbGludXgtZGV2
ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6OGQwNmQzOWIyZDk1YzFjM2YxMGNlM2QxOTY5
ZTFlMzgxOTM1YmJhZjpiaXNlY3QtbGludXg2Ly52bWxpbnV6LThkMDZkMzliMmQ5NWMxYzNm
MTBjZTNkMTk2OWUxZTM4MTkzNWJiYWYtMjAxNDAzMDcxNDM0NDYtMTEtaXZ5dG93bjIgYnJh
bmNoPWxpbnV4LWRldmVsL2RldmVsLWhvdXJseS0yMDE0MDMwNjE4IEJPT1RfSU1BR0U9L2tl
cm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMDcwNzQ1LzhkMDZkMzliMmQ5NWMxYzNmMTBj
ZTNkMTk2OWUxZTM4MTkzNWJiYWYvdm1saW51ei0zLjE0LjAtcmM1LTAyOTcwLWc4ZDA2ZDM5
JyAgLWluaXRyZCAva2VybmVsLXRlc3RzL2luaXRyZC9xdWFudGFsLWNvcmUtaTM4Ni5jZ3og
LW0gMzIwIC1zbXAgMiAtbmV0IG5pYyx2bGFuPTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZs
YW49MSxob3N0ZndkPXRjcDo6MTIwNzItOjIyIC1ib290IG9yZGVyPW5jIC1uby1yZWJvb3Qg
LXdhdGNoZG9nIGk2MzAwZXNiIC1ydGMgYmFzZT1sb2NhbHRpbWUgLXBpZGZpbGUgL2Rldi9z
aG0va2Jvb3QvcGlkLXF1YW50YWwtaXZ5dG93bjItMTcgLXNlcmlhbCBmaWxlOi9kZXYvc2ht
L2tib290L3NlcmlhbC1xdWFudGFsLWl2eXRvd24yLTE3IC1kYWVtb25pemUgLWRpc3BsYXkg
bm9uZSAtbW9uaXRvciBudWxsIAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3
NDUvOGQwNmQzOWIyZDk1YzFjM2YxMGNlM2QxOTY5ZTFlMzgxOTM1YmJhZi9kbWVzZy1xdWFu
dGFsLWl2eXRvd24yLTE3OjIwMTQwMzA3MTUzNTAwOmkzODYtcmFuZGNvbmZpZy1zdDAtMDMw
NzA3NDU6My4xNC4wLXJjNS0wMjk3MC1nOGQwNmQzOTo5NQova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1zdDAtMDMwNzA3NDUvOGQwNmQzOWIyZDk1YzFjM2YxMGNlM2QxOTY5ZTFlMzgxOTM1
YmJhZi9kbWVzZy1xdWFudGFsLWl2eXRvd24yLTE2OjIwMTQwMzA3MTUzNTI2OmkzODYtcmFu
ZGNvbmZpZy1zdDAtMDMwNzA3NDU6My4xNC4wLXJjNS0wMjk3MC1nOGQwNmQzOTo5NQoxMzoy
OjIgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9vdHMKG1sxOzM1bTIwMTQtMDMtMDcgMTU6MzU6
MzAgUkVQRUFUIENPVU5UOiA4NSAgIyAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0
Ly5yZXBlYXQbWzBtCgpCaXNlY3Rpbmc6IDE1NzAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBh
ZnRlciB0aGlzIChyb3VnaGx5IDExIHN0ZXBzKQpbNjg0NWFmMDA5MjBlNmIwZDZlMjUyYzQ0
Nzg0YWFjYTNiMGQyZjQyZl0gTWVyZ2UgJ2RybS1pbnRlbC9kcm0taW50ZWwtbmlnaHRseScg
aW50byBkZXZlbC1ob3VybHktMjAxNDAzMDYxOApydW5uaW5nIC9jL2tlcm5lbC10ZXN0cy9i
aXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51eDYvb2JqLWJp
c2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmln
LXN0MC0wMzA3MDc0NS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYxODo2ODQ1
YWYwMDkyMGU2YjBkNmUyNTJjNDQ3ODRhYWNhM2IwZDJmNDJmOmJpc2VjdC1saW51eDYKCjIw
MTQtMDMtMDctMTU6MzU6MzIgNjg0NWFmMDA5MjBlNmIwZDZlMjUyYzQ0Nzg0YWFjYTNiMGQy
ZjQyZiBjb21waWxpbmcKNDI1IHJlYWwgIDMzNjIgdXNlciAgMjU2IHN5cyAgODUxLjQ5JSBj
cHUgCWkzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUKCjIwMTQtMDMtMDctMTU6NDM6MDUg
ZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wMjUwMC1nNjg0NWFmMC4uCTQJMzMJ
NDAJNjcJODUgU1VDQ0VTUwoKQmlzZWN0aW5nOiA0NzAgcmV2aXNpb25zIGxlZnQgdG8gdGVz
dCBhZnRlciB0aGlzIChyb3VnaGx5IDkgc3RlcHMpCltlNWExNmE5ZGJlYzg4NDRiYmQ0YjM1
YmE1MmZlZjVjNWYyMmUxZTZhXSBNZXJnZSAnYXRoNmtsL2F0aC1uZXh0LXRlc3QnIGludG8g
ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0
LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNlY3QK
bHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAt
MDMwNzA3NDUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6ZTVhMTZhOWRi
ZWM4ODQ0YmJkNGIzNWJhNTJmZWY1YzVmMjJlMWU2YTpiaXNlY3QtbGludXg2CgoyMDE0LTAz
LTA3LTE1OjQ2OjM4IGU1YTE2YTlkYmVjODg0NGJiZDRiMzViYTUyZmVmNWM1ZjIyZTFlNmEg
Y29tcGlsaW5nCjE5NiByZWFsICAxMDY4IHVzZXIgIDg4IHN5cyAgNTkwLjA4JSBjcHUgCWkz
ODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUKCjIwMTQtMDMtMDctMTU6NTA6MjIgZGV0ZWN0
aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wMjc2OC1nZTVhMTZhOS4uLi4uLi4JMjEJODUg
U1VDQ0VTUwoKQmlzZWN0aW5nOiAyMDIgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0
aGlzIChyb3VnaGx5IDggc3RlcHMpCls1YzcwOWIwZDhhYmM1ZGFjNGQ3MzIzZmU2ZTNmZGM4
ZTZjNGQwZTU5XSBNZXJnZSAndGlwL3g4Ni9lZmknIGludG8gZGV2ZWwtaG91cmx5LTIwMTQw
MzA2MTgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJl
LnNoIC9rZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0
cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUvbGludXgtZGV2
ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6NWM3MDliMGQ4YWJjNWRhYzRkNzMyM2ZlNmUz
ZmRjOGU2YzRkMGU1OTpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTA3LTE1OjU1OjAxIDVjNzA5
YjBkOGFiYzVkYWM0ZDczMjNmZTZlM2ZkYzhlNmM0ZDBlNTkgY29tcGlsaW5nCjYyNCByZWFs
ICAzMzMyIHVzZXIgIDI1MCBzeXMgIDU3My4zNSUgY3B1IAlpMzg2LXJhbmRjb25maWctc3Qw
LTAzMDcwNzQ1CgoyMDE0LTAzLTA3LTE2OjA4OjQ1IGRldGVjdGluZyBib290IHN0YXRlIDMu
MTQuMC1yYzUtMDI4MTUtZzVjNzA5YjAuLi4uCTg1IFNVQ0NFU1MKCkJpc2VjdGluZzogMTU1
IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSA4IHN0ZXBzKQpb
ZmJlOTM4ZTRmNmM4MzdjYTE3YzI4NGMwMDFiNDNiYjIxZDVjYTM4OV0gTWVyZ2UgJ2FybS1z
b2MvbmV4dC9kcml2ZXJzJyBpbnRvIGRldmVsLWhvdXJseS0yMDE0MDMwNjE4CnJ1bm5pbmcg
L2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRl
c3RzL2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2
bS9pMzg2LXJhbmRjb25maWctc3QwLTAzMDcwNzQ1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJs
eS0yMDE0MDMwNjE4OmZiZTkzOGU0ZjZjODM3Y2ExN2MyODRjMDAxYjQzYmIyMWQ1Y2EzODk6
YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0wNy0xNjoxMToyNCBmYmU5MzhlNGY2YzgzN2NhMTdj
Mjg0YzAwMWI0M2JiMjFkNWNhMzg5IGNvbXBpbGluZwoyMjMgcmVhbCAgMjc1IHVzZXIgIDM0
IHN5cyAgMTM4LjYxJSBjcHUgCWkzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUKCjIwMTQt
MDMtMDctMTY6MTc6NDAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wMjg2NS1n
ZmJlOTM4ZS4uCTM5CTc5CTg1IFNVQ0NFU1MKCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2gg
bWF5IGJlIHJjdS9yY3UvZGV2CmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBi
aXNlY3QKbGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBzdGFydCA4ZDA2ZDM5YjJkOTVjMWMz
ZjEwY2UzZDE5NjllMWUzODE5MzViYmFmIGZiZTkzOGU0ZjZjODM3Y2ExN2MyODRjMDAxYjQz
YmIyMWQ1Y2EzODkgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgZmJlOTM4ZS4uLiBN
ZXJnZSAnYXJtLXNvYy9uZXh0L2RyaXZlcnMnIGludG8gZGV2ZWwtaG91cmx5LTIwMTQwMzA2
MTgKSEVBRCBpcyBub3cgYXQgZDhmZTRhYy4uLiBNZXJnZSBicmFuY2ggJ2FrcG0nIChwYXRj
aC1ib21iIGZyb20gQW5kcmV3IE1vcnRvbikKQmlzZWN0aW5nOiA1MiByZXZpc2lvbnMgbGVm
dCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNiBzdGVwcykKW2I0NmYzNThhZTVlMzU1
OGE5MDcyZjAzNTQxMjhkNTc0OWE1ODRkMDFdIHJjdXRvcnR1cmU6IFBsYWNlIGt2bS10ZXN0
LTEtcnVuLnNoIG91dHB1dCBpbnRvIHJlcyBkaXJlY3RvcnkKbGluZWFyLWJpc2VjdDogZ2l0
IGJpc2VjdCBydW4gL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0CnJ1bm5pbmcgL2Mva2VybmVsLXRl
c3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAva2VybmVsLXRlc3RzL2xpbnV4Ni9v
YmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctc3QwLTAzMDcwNzQ1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjE4
OmI0NmYzNThhZTVlMzU1OGE5MDcyZjAzNTQxMjhkNTc0OWE1ODRkMDE6YmlzZWN0LWxpbnV4
NgoKMjAxNC0wMy0wNy0xNjoyMTozNCBiNDZmMzU4YWU1ZTM1NThhOTA3MmYwMzU0MTI4ZDU3
NDlhNTg0ZDAxIGNvbXBpbGluZwo2MDYgcmVhbCAgMzMxNiB1c2VyICAyNTMgc3lzICA1ODgu
ODElIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NQoKMjAxNC0wMy0wNy0xNjoz
Mjo0OSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0LjAtcmMzLTAwMDUyLWdiNDZmMzU4Li4u
LgkxMwk4My4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4bWzE7MzVtMjAxNC0wMy0w
NyAxOTowNjo0MCBhZGRfdG9fcnVuX3F1ZXVlIDIbWzBtCi4uLi4uLi4uLi4uLi4uLi4uLgk4
NSBTVUNDRVNTCgpCaXNlY3Rpbmc6IDI2IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIg
dGhpcyAocm91Z2hseSA1IHN0ZXBzKQpbZjU2MDRmNjdmZThjYmQ2ZjIwODhiMjBiOTQ2M2Y3
MjFhYTYxM2Q0Yl0gTWVyZ2UgYnJhbmNoICd0b3J0dXJlLjIwMTQuMDIuMjNhJyBpbnRvIEhF
QUQKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNo
IC9rZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9y
dW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUvbGludXgtZGV2ZWw6
ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6ZjU2MDRmNjdmZThjYmQ2ZjIwODhiMjBiOTQ2M2Y3
MjFhYTYxM2Q0YjpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTA3LTE5OjE2OjEzIGY1NjA0ZjY3
ZmU4Y2JkNmYyMDg4YjIwYjk0NjNmNzIxYWE2MTNkNGIgY29tcGlsaW5nCjQ0OCByZWFsICAz
MzUyIHVzZXIgIDI0NyBzeXMgIDgwMy4yMiUgY3B1IAlpMzg2LXJhbmRjb25maWctc3QwLTAz
MDcwNzQ1CgoyMDE0LTAzLTA3LTE5OjIzOjU3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQu
MC1yYzMtMDAwNzgtZ2Y1NjA0ZjYuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNjYJODUgU1VD
Q0VTUwoKQmlzZWN0aW5nOiAxMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMg
KHJvdWdobHkgNCBzdGVwcykKW2RkMzViODFjMzQxYzY4NWJhZmQxNWJjOWE2YmZhNzk1ODRl
MDdiMDddIHRvcnR1cmU6IFJlbmFtZSBSQ1VfQlVJTERPTkxZIHRvIFRPUlRVUkVfQlVJTERP
TkxZCnJ1bm5pbmcgL2Mva2VybmVsLXRlc3RzL2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5z
aCAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0CmxzIC1hIC9rZXJuZWwtdGVzdHMv
cnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25maWctc3QwLTAzMDcwNzQ1L2xpbnV4LWRldmVs
OmRldmVsLWhvdXJseS0yMDE0MDMwNjE4OmRkMzViODFjMzQxYzY4NWJhZmQxNWJjOWE2YmZh
Nzk1ODRlMDdiMDc6YmlzZWN0LWxpbnV4NgoKMjAxNC0wMy0wNy0xOTozNzowNyBkZDM1Yjgx
YzM0MWM2ODViYWZkMTViYzlhNmJmYTc5NTg0ZTA3YjA3IGNvbXBpbGluZwo0OTggcmVhbCAg
MzMyMSB1c2VyICAyNDUgc3lzICA3MTUuNDklIGNwdSAJaTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzA3MDc0NQoKMjAxNC0wMy0wNy0xOTo0Nzo1MSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAzLjE0
LjAtcmMzLTAwMDkxLWdkZDM1YjgxLi4uLi4uLi4uLi4uCTY5CTg1IFNVQ0NFU1MKCkJpc2Vj
dGluZzogNiByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMyBz
dGVwcykKWzg4NjRmMDk5NmU4YjdmMDdhNTM2YWEwNzU1M2M0NDYxY2Q1ZjQyMTFdIHRvcnR1
cmU6IE1ha2UgIi0tZHJ5cnVuIHNjcmlwdCIgb3V0cHV0IHNlbGYtc3VmZmljaWVudApydW5u
aW5nIC9jL2tlcm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5l
bC10ZXN0cy9saW51eDYvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NS9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDAzMDYxODo4ODY0ZjA5OTZlOGI3ZjA3YTUzNmFhMDc1NTNjNDQ2MWNkNWY0
MjExOmJpc2VjdC1saW51eDYKCjIwMTQtMDMtMDctMTk6NTQ6NTYgODg2NGYwOTk2ZThiN2Yw
N2E1MzZhYTA3NTUzYzQ0NjFjZDVmNDIxMSBjb21waWxpbmcKMTkzIHJlYWwgIDI3MyB1c2Vy
ICAzNiBzeXMgIDE2MC4yOSUgY3B1IAlpMzg2LXJhbmRjb25maWctc3QwLTAzMDcwNzQ1Cgoy
MDE0LTAzLTA3LTE5OjU5OjM3IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzMtMDAw
OTgtZzg4NjRmMDkuLi4uLi4uLi4uLi4uLi4uCTEzCTc3CTg1IFNVQ0NFU1MKCkJpc2VjdGlu
ZzogMyByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMiBzdGVw
cykKW2IyZDc3N2E2ZDlkNjQ5MjliOTcwMWYxOTA1ZmRlZGE4ZmMzY2IxNmRdIHJjdXRvcnR1
cmU6IFByaW50IG5lZ2F0aXZlcyBmb3IgU1JDVSBjb3VudGVyIHdyYXBhcm91bmQKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwt
dGVzdHMvbGludXg2L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91
cmx5LTIwMTQwMzA2MTg6YjJkNzc3YTZkOWQ2NDkyOWI5NzAxZjE5MDVmZGVkYThmYzNjYjE2
ZDpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTA3LTIwOjA5OjExIGIyZDc3N2E2ZDlkNjQ5Mjli
OTcwMWYxOTA1ZmRlZGE4ZmMzY2IxNmQgY29tcGlsaW5nCjQ0IHJlYWwgIDI3MSB1c2VyICAz
NCBzeXMgIDY4OS4wMyUgY3B1IAlpMzg2LXJhbmRjb25maWctc3QwLTAzMDcwNzQ1CgoyMDE0
LTAzLTA3LTIwOjExOjQ4IGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzMtMDAxMDEt
Z2IyZDc3N2EuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4JNQk3OQk4NSBTVUNDRVNT
CgpCaXNlY3Rpbmc6IDEgcmV2aXNpb24gbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdo
bHkgMSBzdGVwKQpbNGM3OWQ3ZDg5OTAyYTJlOWM5NmIzZGI1MTE1YWY1MmIzY2Y5NGRhOV0g
dG9ydHVyZTogUmVwb3J0IGRpYWdub3N0aWNzIGZyb20gcWVtdQpydW5uaW5nIC9jL2tlcm5l
bC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2ggL2tlcm5lbC10ZXN0cy9saW51
eDYvb2JqLWJpc2VjdApscyAtYSAva2VybmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1y
YW5kY29uZmlnLXN0MC0wMzA3MDc0NS9saW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAz
MDYxODo0Yzc5ZDdkODk5MDJhMmU5Yzk2YjNkYjUxMTVhZjUyYjNjZjk0ZGE5OmJpc2VjdC1s
aW51eDYKCjIwMTQtMDMtMDctMjA6Mjg6MjQgNGM3OWQ3ZDg5OTAyYTJlOWM5NmIzZGI1MTE1
YWY1MmIzY2Y5NGRhOSBjb21waWxpbmcKNDYgcmVhbCAgMjcwIHVzZXIgIDM0IHN5cyAgNjUx
LjY1JSBjcHUgCWkzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUKCjIwMTQtMDMtMDctMjA6
MzA6MTYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjMy0wMDEwMy1nNGM3OWQ3ZC4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCTEyCTI5CTQ2Li4uLi4u
Li4uCTQ3CTQ4Lgk3OC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4JODQuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uG1sxOzM1bTIwMTQtMDMt
MDcgMjM6NTM6MDEgYWRkX3RvX3J1bl9xdWV1ZSAxG1swbQouLgk4NSBTVUNDRVNTCgpCaXNl
Y3Rpbmc6IDAgcmV2aXNpb25zIGxlZnQgdG8gdGVzdCBhZnRlciB0aGlzIChyb3VnaGx5IDAg
c3RlcHMpClsxZjljMjY5NjhlMWE1MDFmM2E4Mzk2MDNjOTYzM2YyMWFiY2E2NWIzXSB0b3J0
dXJlOiBJbmNyZWFzZSBzdHV0dGVyLWVuZCBpbnRlbnNpdHkKcnVubmluZyAvYy9rZXJuZWwt
dGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9rZXJuZWwtdGVzdHMvbGludXg2
L29iai1iaXNlY3QKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFu
ZGNvbmZpZy1zdDAtMDMwNzA3NDUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2
MTg6MWY5YzI2OTY4ZTFhNTAxZjNhODM5NjAzYzk2MzNmMjFhYmNhNjViMzpiaXNlY3QtbGlu
dXg2CgoyMDE0LTAzLTA3LTIzOjU0OjMyIDFmOWMyNjk2OGUxYTUwMWYzYTgzOTYwM2M5NjMz
ZjIxYWJjYTY1YjMgY29tcGlsaW5nCjQ2IHJlYWwgIDI3NCB1c2VyICAzNSBzeXMgIDY2Ni45
OSUgY3B1IAlpMzg2LXJhbmRjb25maWctc3QwLTAzMDcwNzQ1CgoyMDE0LTAzLTA3LTIzOjU1
OjQyIGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzMtMDAxMDQtZzFmOWMyNjkuLi4u
Li4uLi4uLi4uLi4JOS4uLi4uLi4uLi4uCTEwCTIwCTI0CTI5CTMxLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uIFRFU1QgRkFJTFVSRQpbICAgMTIuOTg2MTEwXSAuLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4gZG9uZS4KWyAgIDEyLjk4NzMzOF0g
VXNpbmcgSVBJIFNob3J0Y3V0IG1vZGUKCkJVRzoga2VybmVsIGJvb3QgaGFuZwpFbGFwc2Vk
IHRpbWU6IDYzNQpxZW11LXN5c3RlbS14ODZfNjQgLWNwdSBrdm02NCAtZW5hYmxlLWt2bSAt
a2VybmVsIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NS8xZjljMjY5Njhl
MWE1MDFmM2E4Mzk2MDNjOTYzM2YyMWFiY2E2NWIzL3ZtbGludXotMy4xNC4wLXJjMy0wMDEw
NC1nMWY5YzI2OSAtYXBwZW5kICdodW5nX3Rhc2tfcGFuaWM9MSBlYXJseXByaW50az10dHlT
MCwxMTUyMDAgZGVidWcgYXBpYz1kZWJ1ZyBzeXNycV9hbHdheXNfZW5hYmxlZCBwYW5pYz0x
MCBzb2Z0bG9ja3VwX3BhbmljPTEgbm1pX3dhdGNoZG9nPXBhbmljICBwcm9tcHRfcmFtZGlz
az0wIGNvbnNvbGU9dHR5UzAsMTE1MjAwIGNvbnNvbGU9dHR5MCB2Z2E9bm9ybWFsICByb290
PS9kZXYvcmFtMCBydyBsaW5rPS9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJh
bmRjb25maWctc3QwLTAzMDcwNzQ1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMw
NjE4OjFmOWMyNjk2OGUxYTUwMWYzYTgzOTYwM2M5NjMzZjIxYWJjYTY1YjM6YmlzZWN0LWxp
bnV4Ni8udm1saW51ei0xZjljMjY5NjhlMWE1MDFmM2E4Mzk2MDNjOTYzM2YyMWFiY2E2NWIz
LTIwMTQwMzA3MjM1NTM2LTc1LWJlbnMgYnJhbmNoPWxpbnV4LWRldmVsL2RldmVsLWhvdXJs
eS0yMDE0MDMwNjE4IEJPT1RfSU1BR0U9L2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAz
MDcwNzQ1LzFmOWMyNjk2OGUxYTUwMWYzYTgzOTYwM2M5NjMzZjIxYWJjYTY1YjMvdm1saW51
ei0zLjE0LjAtcmMzLTAwMTA0LWcxZjljMjY5JyAgLWluaXRyZCAva2VybmVsLXRlc3RzL2lu
aXRyZC9xdWFudGFsLWNvcmUtaTM4Ni5jZ3ogLW0gMzIwIC1zbXAgMiAtbmV0IG5pYyx2bGFu
PTEsbW9kZWw9ZTEwMDAgLW5ldCB1c2VyLHZsYW49MSxob3N0ZndkPXRjcDo6NTcyNC06MjIg
LWJvb3Qgb3JkZXI9bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBlc2IgLXJ0YyBiYXNl
PWxvY2FsdGltZSAtZHJpdmUgZmlsZT0vZnMvc2RhNy9kaXNrMC1xdWFudGFsLWJlbnMtNCxt
ZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvc2RhNy9kaXNrMS1xdWFudGFs
LWJlbnMtNCxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvc2RhNy9kaXNr
Mi1xdWFudGFsLWJlbnMtNCxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMv
c2RhNy9kaXNrMy1xdWFudGFsLWJlbnMtNCxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUg
ZmlsZT0vZnMvc2RhNy9kaXNrNC1xdWFudGFsLWJlbnMtNCxtZWRpYT1kaXNrLGlmPXZpcnRp
byAtZHJpdmUgZmlsZT0vZnMvc2RhNy9kaXNrNS1xdWFudGFsLWJlbnMtNCxtZWRpYT1kaXNr
LGlmPXZpcnRpbyAtcGlkZmlsZSAvZGV2L3NobS9rYm9vdC9waWQtcXVhbnRhbC1iZW5zLTQg
LXNlcmlhbCBmaWxlOi9kZXYvc2htL2tib290L3NlcmlhbC1xdWFudGFsLWJlbnMtNCAtZGFl
bW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctc3QwLTAzMDcwNzQ1LzFmOWMyNjk2OGUxYTUwMWYzYTgzOTYwM2M5NjMzZjIxYWJj
YTY1YjMvZG1lc2ctcXVhbnRhbC1zdG9ha2xleS0zOjIwMTQwMzA4MDA1NjIyOmkzODYtcmFu
ZGNvbmZpZy1zdDAtMDMwNzA3NDU6My4xNC4wLXJjMy0wMDEwNC1nMWY5YzI2OToxMDYKOTox
OjIzIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTA4IDAwOjU2
OjQ2IFJFUEVBVCBDT1VOVDogMzMwICAjIC9rZXJuZWwtdGVzdHMvbGludXg2L29iai1iaXNl
Y3QvLnJlcGVhdBtbMG0KCjFmOWMyNjk2OGUxYTUwMWYzYTgzOTYwM2M5NjMzZjIxYWJjYTY1
YjMgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IDFmOWMyNjk2OGUxYTUwMWYzYTgz
OTYwM2M5NjMzZjIxYWJjYTY1YjMKQXV0aG9yOiBQYXVsIEUuIE1jS2VubmV5IDxwYXVsbWNr
QGxpbnV4LnZuZXQuaWJtLmNvbT4KRGF0ZTogICBUdWUgTWFyIDQgMTE6MDM6MjEgMjAxNCAt
MDgwMAoKICAgIHRvcnR1cmU6IEluY3JlYXNlIHN0dXR0ZXItZW5kIGludGVuc2l0eQogICAg
CiAgICBDdXJyZW50bHksIGFsbCBzdHV0dGVyZWQga3RocmVhZHMgYmxvY2sgYSBqaWZmeSBh
dCBhIHRpbWUsIHdoaWNoIGNhbgogICAgcmVzdWx0IGluIHRoZW0gc3RhcnRpbmcgYXQgZGlm
ZmVyZW50IHRpbWVzLiAgKE5vdGU6IFRoaXMgaXMgbm90IGFuCiAgICBlbmVyZ3ktZWZmaWNp
ZW5jeSBwcm9ibGVtIHVubGVzcyB5b3UgcnVuIHRvcnR1cmUgdGVzdHMgaW4gcHJvZHVjdGlv
biwKICAgIGluIHdoaWNoIGNhc2UgeW91IGhhdmUgb3RoZXIgcHJvYmxlbXMhKSAgVGhpcyBj
b21taXQgaW5jcmVhc2VzIHRoZQogICAgaW50ZW5zaXR5IG9mIHRoZSByZXN0YXJ0IGV2ZW50
IGJ5IGNhdXNpbmcga3RocmVhZHMgdG8gc3BpbiB0aHJvdWdoIHRoZQogICAgbGFzdCBqaWZm
eSwgcmVzdGFydGluZyB3aGVuIHRoZXkgc2VlIHRoZSB2YXJpYWJsZSBjaGFuZ2UuCiAgICAK
ICAgIFNpZ25lZC1vZmYtYnk6IFBhdWwgRS4gTWNLZW5uZXkgPHBhdWxtY2tAbGludXgudm5l
dC5pYm0uY29tPgoKOjA0MDAwMCAwNDAwMDAgNDhjNDYzNThhYzQwYTNmZjllNGJlYjRlYzlj
MzM0MzcyMmMyMGY1ZSBkYTU0NjE5MjM3NmM3ZDBjYmViMDg2MTBlMTU2NjExY2FkODZjYmY2
IE0Ja2VybmVsCmJpc2VjdCBydW4gc3VjY2VzcwpscyAtYSAva2VybmVsLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NS9saW51eC1kZXZlbDpkZXZl
bC1ob3VybHktMjAxNDAzMDYxODo0Yzc5ZDdkODk5MDJhMmU5Yzk2YjNkYjUxMTVhZjUyYjNj
Zjk0ZGE5OmJpc2VjdC1saW51eDYKCjIwMTQtMDMtMDgtMDA6NTY6NDggNGM3OWQ3ZDg5OTAy
YTJlOWM5NmIzZGI1MTE1YWY1MmIzY2Y5NGRhOSByZXVzZSAva2VybmVsL2kzODYtcmFuZGNv
bmZpZy1zdDAtMDMwNzA3NDUvNGM3OWQ3ZDg5OTAyYTJlOWM5NmIzZGI1MTE1YWY1MmIzY2Y5
NGRhOS92bWxpbnV6LTMuMTQuMC1yYzMtMDAxMDMtZzRjNzlkN2QKCjIwMTQtMDMtMDgtMDA6
NTY6NDkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JOTMJMTA5CTEyMAkxMzQJMTQ3CTE1OQkx
NjIJMjE1CTI0OAkzMzQJNDQyCTU1MQk3MjcJODc2CTk5MCBTVUNDRVNTCgpscyAtYSAva2Vy
bmVsLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NS9s
aW51eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYxODpkNDc4YTk2MGVkZjFlYTYxY2Ez
MWEwN2E0OGE4NzcxZjA0M2RiYTc4OmJpc2VjdC1saW51eDYKIFRFU1QgRkFJTFVSRQp1ZGV2
ZFsxNTddOiBlcnJvciBpbml0aWFsaXppbmcgaW5vdGlmeQoKCkJVRzoga2VybmVsIHRlc3Qg
aGFuZwpFbGFwc2VkIHRpbWU6IDM2MDUKcWVtdS1zeXN0ZW0teDg2XzY0IC1jcHUga3ZtNjQg
LWVuYWJsZS1rdm0gLWtlcm5lbCAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3
NDUvZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3OC92bWxpbnV6LTMu
MTQuMC1yYzUtMDM3NjUtZ2Q0NzhhOTYgLWFwcGVuZCAnaHVuZ190YXNrX3BhbmljPTEgZWFy
bHlwcmludGs9dHR5UzAsMTE1MjAwIGRlYnVnIGFwaWM9ZGVidWcgc3lzcnFfYWx3YXlzX2Vu
YWJsZWQgcGFuaWM9MTAgc29mdGxvY2t1cF9wYW5pYz0xIG5taV93YXRjaGRvZz1wYW5pYyAg
cHJvbXB0X3JhbWRpc2s9MCBjb25zb2xlPXR0eVMwLDExNTIwMCBjb25zb2xlPXR0eTAgdmdh
PW5vcm1hbCAgcm9vdD0vZGV2L3JhbTAgcncgbGluaz0va2VybmVsLXRlc3RzL3J1bi1xdWV1
ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NS9saW51eC1kZXZlbDpkZXZlbC1o
b3VybHktMjAxNDAzMDYxOC8udm1saW51ei1kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4
NzcxZjA0M2RiYTc4LTIwMTQwMzA3MDkxMDQyLTYtYXRoZW5zIGJyYW5jaD1saW51eC1kZXZl
bC9kZXZlbC1ob3VybHktMjAxNDAzMDYxOCBCT09UX0lNQUdFPS9rZXJuZWwvaTM4Ni1yYW5k
Y29uZmlnLXN0MC0wMzA3MDc0NS9kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0
M2RiYTc4L3ZtbGludXotMy4xNC4wLXJjNS0wMzc2NS1nZDQ3OGE5NicgIC1pbml0cmQgL2tl
cm5lbC10ZXN0cy9pbml0cmQvcXVhbnRhbC1jb3JlLWkzODYuY2d6IC1tIDI1NiAtc21wIDIg
LW5ldCBuaWMsdmxhbj0xLG1vZGVsPWUxMDAwIC1uZXQgdXNlcix2bGFuPTEsaG9zdGZ3ZD10
Y3A6OjEwNTMzLToyMiAtYm9vdCBvcmRlcj1uYyAtbm8tcmVib290IC13YXRjaGRvZyBpNjMw
MGVzYiAtcnRjIGJhc2U9bG9jYWx0aW1lIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlz
azAtcXVhbnRhbC1hdGhlbnMtOSxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0v
ZnMvTEFCRUw9S1ZNL2Rpc2sxLXF1YW50YWwtYXRoZW5zLTksbWVkaWE9ZGlzayxpZj12aXJ0
aW8gLWRyaXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrMi1xdWFudGFsLWF0aGVucy05LG1l
ZGlhPWRpc2ssaWY9dmlydGlvIC1kcml2ZSBmaWxlPS9mcy9MQUJFTD1LVk0vZGlzazMtcXVh
bnRhbC1hdGhlbnMtOSxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFC
RUw9S1ZNL2Rpc2s0LXF1YW50YWwtYXRoZW5zLTksbWVkaWE9ZGlzayxpZj12aXJ0aW8gLWRy
aXZlIGZpbGU9L2ZzL0xBQkVMPUtWTS9kaXNrNS1xdWFudGFsLWF0aGVucy05LG1lZGlhPWRp
c2ssaWY9dmlydGlvIC1waWRmaWxlIC9kZXYvc2htL2tib290L3BpZC1xdWFudGFsLWF0aGVu
cy05IC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9zZXJpYWwtcXVhbnRhbC1hdGhlbnMt
OSAtZGFlbW9uaXplIC1kaXNwbGF5IG5vbmUgLW1vbml0b3IgbnVsbCAKL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctc3QwLTAzMDcwNzQ1L2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3
NzFmMDQzZGJhNzgvZG1lc2cteW9jdG8taW5uLTQ4OjIwMTQwMzA3MTQyOTIyOmkzODYtcmFu
ZGNvbmZpZy1zdDAtMDMwNzA3NDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMw
NzA3NDUvZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3OC9kbWVzZy1x
dWFudGFsLXJvYW0tMzM6MjAxNDAzMDcxMDM4NTU6aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3
MDc0NTozLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjIKL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctc3QwLTAzMDcwNzQ1L2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3NzFmMDQzZGJh
NzgvZG1lc2cteW9jdG8tcm9hbS0zODoyMDE0MDMwNzEwMzg1MDppMzg2LXJhbmRjb25maWct
c3QwLTAzMDcwNzQ1OjMuMTQuMC1yYzUtMDM3NjUtZ2Q0NzhhOTY6Mgova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUvZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3
MWYwNDNkYmE3OC9kbWVzZy15b2N0by14aWFuLTI2OjIwMTQwMzA3MTQ0NTQ0OmkzODYtcmFu
ZGNvbmZpZy1zdDAtMDMwNzA3NDU6My4xNC4wLXJjNS0wMzc2NS1nZDQ3OGE5NjoyCi9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NS9kNDc4YTk2MGVkZjFlYTYxY2EzMWEw
N2E0OGE4NzcxZjA0M2RiYTc4L2RtZXNnLXF1YW50YWwtcm9hbS0yNDoyMDE0MDMwNzEwMzg0
NTppMzg2LXJhbmRjb25maWctc3QwLTAzMDcwNzQ1OjMuMTQuMC1yYzUtMDM3NjUtZ2Q0Nzhh
OTY6Mgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUvZDQ3OGE5NjBlZGYx
ZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNkYmE3OC9kbWVzZy15b2N0by14aWFuLTE4OjIwMTQw
MzA3MTQ0NTM0OmkzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDU6My4xNC4wLXJjNS0wMzc2
NS1nZDQ3OGE5NjoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NS9kNDc4
YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4L2RtZXNnLXlvY3RvLWl2eXRv
d24yLTM6MjAxNDAzMDcxMDI4Mjg6aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NTozLjE0
LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjIKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAz
MDcwNzQ1L2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3NzFmMDQzZGJhNzgvZG1lc2ct
eW9jdG8tbGtwLXN0MDEtOToyMDE0MDMwNzE0MjQwMzppMzg2LXJhbmRjb25maWctc3QwLTAz
MDcwNzQ1OjMuMTQuMC1yYzUtMDM3NjUtZ2Q0NzhhOTY6Mgova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1zdDAtMDMwNzA3NDUvZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhhODc3MWYwNDNk
YmE3OC9kbWVzZy1xdWFudGFsLXJvYW0tNDoyMDE0MDMwNzEwMzg0MDppMzg2LXJhbmRjb25m
aWctc3QwLTAzMDcwNzQ1OjMuMTQuMC1yYzUtMDM3NjUtZ2Q0NzhhOTY6Mgova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUvZDQ3OGE5NjBlZGYxZWE2MWNhMzFhMDdhNDhh
ODc3MWYwNDNkYmE3OC9kbWVzZy15b2N0by1pbm4tMzg6MjAxNDAzMDcxNDI5MzM6aTM4Ni1y
YW5kY29uZmlnLXN0MC0wMzA3MDc0NTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzA3MDc0NS9kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4L2RtZXNn
LXF1YW50YWwtYXRoZW5zLTk6MjAxNDAzMDcxMDQxNDY6aTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzA3MDc0NTozLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjIKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctc3QwLTAzMDcwNzQ1L2Q0NzhhOTYwZWRmMWVhNjFjYTMxYTA3YTQ4YTg3NzFmMDQz
ZGJhNzgvZG1lc2cteW9jdG8tYmVucy00OjIwMTQwMzA3MTQzMTAzOmkzODYtcmFuZGNvbmZp
Zy1zdDAtMDMwNzA3NDU6My4xNC4wLXJjNS0wMzc2NS1nZDQ3OGE5NjoyCi9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NS9kNDc4YTk2MGVkZjFlYTYxY2EzMWEwN2E0OGE4
NzcxZjA0M2RiYTc4L2RtZXNnLXlvY3RvLXJvYW0tMzI6MjAxNDAzMDcxNDQ1MDk6aTM4Ni1y
YW5kY29uZmlnLXN0MC0wMzA3MDc0NTozLjE0LjAtcmM1LTAzNzY1LWdkNDc4YTk2OjIKL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctc3QwLTAzMDcwNzQ1L2Q0NzhhOTYwZWRmMWVhNjFjYTMx
YTA3YTQ4YTg3NzFmMDQzZGJhNzgvZG1lc2cteW9jdG8tcm9hbS0zOjIwMTQwMzA3MTAzODUw
OmkzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDU6My4xNC4wLXJjNS0wMzc2NS1nZDQ3OGE5
NjoyCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NS9kNDc4YTk2MGVkZjFl
YTYxY2EzMWEwN2E0OGE4NzcxZjA0M2RiYTc4L2RtZXNnLXlvY3RvLWlubi00NjoyMDE0MDMw
NzE0MjkxNzppMzg2LXJhbmRjb25maWctc3QwLTAzMDcwNzQ1OjoKMjoxNToxNyBhbGxfZ29v
ZDpiYWQ6YWxsX2JhZCBib290cwoKW2RldGFjaGVkIEhFQUQgNzhlNzYwZF0gUmV2ZXJ0ICJ0
b3J0dXJlOiBJbmNyZWFzZSBzdHV0dGVyLWVuZCBpbnRlbnNpdHkiCiBDb21taXR0ZXI6IFd1
IEZlbmdndWFuZyA8a2J1aWxkQGJlZT4KWW91ciBuYW1lIGFuZCBlbWFpbCBhZGRyZXNzIHdl
cmUgY29uZmlndXJlZCBhdXRvbWF0aWNhbGx5IGJhc2VkCm9uIHlvdXIgdXNlcm5hbWUgYW5k
IGhvc3RuYW1lLiBQbGVhc2UgY2hlY2sgdGhhdCB0aGV5IGFyZSBhY2N1cmF0ZS4KWW91IGNh
biBzdXBwcmVzcyB0aGlzIG1lc3NhZ2UgYnkgc2V0dGluZyB0aGVtIGV4cGxpY2l0bHk6Cgog
ICAgZ2l0IGNvbmZpZyAtLWdsb2JhbCB1c2VyLm5hbWUgIllvdXIgTmFtZSIKICAgIGdpdCBj
b25maWcgLS1nbG9iYWwgdXNlci5lbWFpbCB5b3VAZXhhbXBsZS5jb20KCkFmdGVyIGRvaW5n
IHRoaXMsIHlvdSBtYXkgZml4IHRoZSBpZGVudGl0eSB1c2VkIGZvciB0aGlzIGNvbW1pdCB3
aXRoOgoKICAgIGdpdCBjb21taXQgLS1hbWVuZCAtLXJlc2V0LWF1dGhvcgoKIDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQpscyAtYSAva2VybmVs
LXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NS9saW51
eC1kZXZlbDpkZXZlbC1ob3VybHktMjAxNDAzMDYxODo3OGU3NjBkZGRlMDIwYWY5N2JkODRj
M2VjMjE5OWNkMzgzMmZkYjJlOmJpc2VjdC1saW51eDYKCjIwMTQtMDMtMDgtMDE6MDU6MjQg
NzhlNzYwZGRkZTAyMGFmOTdiZDg0YzNlYzIxOTljZDM4MzJmZGIyZSBjb21waWxpbmcKCjIw
MTQtMDMtMDgtMDE6MTU6MzggZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgMy4xNC4wLXJjNS0wMzc2
Ni1nNzhlNzYwZC4uCTMJMjAJMjUJNDcJNzYJOTYJMTU4CTMxMQk0NzkJNjE0CTc1MQk4OTIJ
OTg4CTk5MCBTVUNDRVNTCgoKPT09PT09PT09IHVwc3RyZWFtID09PT09PT09PQpXYXJuaW5n
OiB5b3UgYXJlIGxlYXZpbmcgMSBjb21taXQgYmVoaW5kLCBub3QgY29ubmVjdGVkIHRvCmFu
eSBvZiB5b3VyIGJyYW5jaGVzOgoKICA3OGU3NjBkIFJldmVydCAidG9ydHVyZTogSW5jcmVh
c2Ugc3R1dHRlci1lbmQgaW50ZW5zaXR5IgoKSWYgeW91IHdhbnQgdG8ga2VlcCB0aGVtIGJ5
IGNyZWF0aW5nIGEgbmV3IGJyYW5jaCwgdGhpcyBtYXkgYmUgYSBnb29kIHRpbWUKdG8gZG8g
c28gd2l0aDoKCiBnaXQgYnJhbmNoIG5ld19icmFuY2hfbmFtZSA3OGU3NjBkCgpIRUFEIGlz
IG5vdyBhdCBjM2JlYmM3Li4uIE1lcmdlIGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC9kYXZlbS9uZXQKbHMgLWEgL2tlcm5lbC10ZXN0cy9ydW4tcXVl
dWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUvbGludXgtZGV2ZWw6ZGV2ZWwt
aG91cmx5LTIwMTQwMzA2MTg6YzNiZWJjNzFjNGJjZGFmYTI0YjUwNmFkZjBjMWRlM2MxZjc3
ZTJlMDpiaXNlY3QtbGludXg2CgoyMDE0LTAzLTA4LTAxOjIzOjQxIGMzYmViYzcxYzRiY2Rh
ZmEyNGI1MDZhZGYwYzFkZTNjMWY3N2UyZTAgY29tcGlsaW5nCgoyMDE0LTAzLTA4LTAxOjM2
OjExIGRldGVjdGluZyBib290IHN0YXRlIDMuMTQuMC1yYzUtMDAxODUtZ2MzYmViYzcuLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLgk4OAkyNzEJNDU3CTY0MQk4NTQJOTkw
IFNVQ0NFU1MKCgo9PT09PT09PT0gbGludXgtbmV4dCA9PT09PT09PT0KRmV0Y2hpbmcgbmV4
dApGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiArIGQ0YmIyZWIuLi42ZjMzZjY5IGFrcG0g
ICAgICAgLT4gbmV4dC9ha3BtICAoZm9yY2VkIHVwZGF0ZSkKICsgMDlkZTE5Mi4uLjU2MDMy
ZmMgYWtwbS1iYXNlICAtPiBuZXh0L2FrcG0tYmFzZSAgKGZvcmNlZCB1cGRhdGUpCiArIDBm
ZmIyZmUuLi4xYjBhN2UzIG1hc3RlciAgICAgLT4gbmV4dC9tYXN0ZXIgIChmb3JjZWQgdXBk
YXRlKQogKiBbbmV3IHRhZ10gICAgICAgICBuZXh0LTIwMTQwMzA3IC0+IG5leHQtMjAxNDAz
MDcKUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgYzNiZWJjNy4uLiBNZXJnZSBnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZGF2ZW0vbmV0CkhFQUQg
aXMgbm93IGF0IDFiMGE3ZTMuLi4gQWRkIGxpbnV4LW5leHQgc3BlY2lmaWMgZmlsZXMgZm9y
IDIwMTQwMzA3CmxzIC1hIC9rZXJuZWwtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRj
b25maWctc3QwLTAzMDcwNzQ1L2xpbnV4LWRldmVsOmRldmVsLWhvdXJseS0yMDE0MDMwNjE4
OjFiMGE3ZTMyNjMxNjhhMDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2M6YmlzZWN0LWxpbnV4
NgoKMjAxNC0wMy0wOC0wMTo1NzoxMiAxYjBhN2UzMjYzMTY4YTA2ZDM4NTg3OThlNDhjNWEy
MWQxYzc4ZDNjIGNvbXBpbGluZwoKMjAxNC0wMy0wOC0wMjowMDo1OCBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAzLjE0LjAtcmM1LW5leHQtMjAxNDAzMDcuLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLgkzCTEwOQkyNjYJNDI1CTYxMwk4MzAJOTY3CTk3MS4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4gVEVTVCBGQUlMVVJFClsgMzU0MC45MzEzNTddIHNwaW5fbG9jay10b3J0dXJlOiBXcml0
ZXM6ICBUb3RhbDogMiAgTWF4L01pbjogMC8wICAgRmFpbDogMCAKWyAzNjAwLjkzMjA4OF0g
c3Bpbl9sb2NrLXRvcnR1cmU6IFdyaXRlczogIFRvdGFsOiAyICBNYXgvTWluOiAwLzAgICBG
YWlsOiAwIAoKQlVHOiBrZXJuZWwgdGVzdCBoYW5nCkVsYXBzZWQgdGltZTogMzYwNQpxZW11
LXN5c3RlbS14ODZfNjQgLWNwdSBrdm02NCAtZW5hYmxlLWt2bSAta2VybmVsIC9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NS8xYjBhN2UzMjYzMTY4YTA2ZDM4NTg3OThl
NDhjNWEyMWQxYzc4ZDNjL3ZtbGludXotMy4xNC4wLXJjNS1uZXh0LTIwMTQwMzA3IC1hcHBl
bmQgJ2h1bmdfdGFza19wYW5pYz0xIGVhcmx5cHJpbnRrPXR0eVMwLDExNTIwMCBkZWJ1ZyBh
cGljPWRlYnVnIHN5c3JxX2Fsd2F5c19lbmFibGVkIHBhbmljPTEwIHNvZnRsb2NrdXBfcGFu
aWM9MSBubWlfd2F0Y2hkb2c9cGFuaWMgIHByb21wdF9yYW1kaXNrPTAgY29uc29sZT10dHlT
MCwxMTUyMDAgY29uc29sZT10dHkwIHZnYT1ub3JtYWwgIHJvb3Q9L2Rldi9yYW0wIHJ3IGxp
bms9L2tlcm5lbC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMw
NzA3NDUvbGludXgtZGV2ZWw6ZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTg6MWIwYTdlMzI2MzE2
OGEwNmQzODU4Nzk4ZTQ4YzVhMjFkMWM3OGQzYzpiaXNlY3QtbGludXg2Ly52bWxpbnV6LTFi
MGE3ZTMyNjMxNjhhMDZkMzg1ODc5OGU0OGM1YTIxZDFjNzhkM2MtMjAxNDAzMDgwMjAwNTUt
MTM0LWF0aGVucyBicmFuY2g9bGludXgtZGV2ZWwvZGV2ZWwtaG91cmx5LTIwMTQwMzA2MTgg
Qk9PVF9JTUFHRT0va2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUvMWIwYTdl
MzI2MzE2OGEwNmQzODU4Nzk4ZTQ4YzVhMjFkMWM3OGQzYy92bWxpbnV6LTMuMTQuMC1yYzUt
bmV4dC0yMDE0MDMwNycgIC1pbml0cmQgL2tlcm5lbC10ZXN0cy9pbml0cmQveW9jdG8tbWlu
aW1hbC1pMzg2LmNneiAtbSAyNTYgLXNtcCAyIC1uZXQgbmljLHZsYW49MSxtb2RlbD1lMTAw
MCAtbmV0IHVzZXIsdmxhbj0xLGhvc3Rmd2Q9dGNwOjoyNTY4NS06MjIgLWJvb3Qgb3JkZXI9
bmMgLW5vLXJlYm9vdCAtd2F0Y2hkb2cgaTYzMDBlc2IgLXJ0YyBiYXNlPWxvY2FsdGltZSAt
ZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2swLXlvY3RvLWF0aGVucy0xNyxtZWRpYT1k
aXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2sxLXlvY3RvLWF0
aGVucy0xNyxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZN
L2Rpc2syLXlvY3RvLWF0aGVucy0xNyxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmls
ZT0vZnMvTEFCRUw9S1ZNL2Rpc2szLXlvY3RvLWF0aGVucy0xNyxtZWRpYT1kaXNrLGlmPXZp
cnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2s0LXlvY3RvLWF0aGVucy0xNyxt
ZWRpYT1kaXNrLGlmPXZpcnRpbyAtZHJpdmUgZmlsZT0vZnMvTEFCRUw9S1ZNL2Rpc2s1LXlv
Y3RvLWF0aGVucy0xNyxtZWRpYT1kaXNrLGlmPXZpcnRpbyAtcGlkZmlsZSAvZGV2L3NobS9r
Ym9vdC9waWQteW9jdG8tYXRoZW5zLTE3IC1zZXJpYWwgZmlsZTovZGV2L3NobS9rYm9vdC9z
ZXJpYWwteW9jdG8tYXRoZW5zLTE3IC1kYWVtb25pemUgLWRpc3BsYXkgbm9uZSAtbW9uaXRv
ciBudWxsIAova2VybmVsL2kzODYtcmFuZGNvbmZpZy1zdDAtMDMwNzA3NDUvMWIwYTdlMzI2
MzE2OGEwNmQzODU4Nzk4ZTQ4YzVhMjFkMWM3OGQzYy9kbWVzZy15b2N0by1hdGhlbnMtMTc6
MjAxNDAzMDgwMzIyNDU6aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NTozLjE0LjAtcmM1
LW5leHQtMjAxNDAzMDc6MTA5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0
NS8xYjBhN2UzMjYzMTY4YTA2ZDM4NTg3OThlNDhjNWEyMWQxYzc4ZDNjL2RtZXNnLXlvY3Rv
LXJvYW0tMzk6MjAxNDAzMDgwMzIyNTA6aTM4Ni1yYW5kY29uZmlnLXN0MC0wMzA3MDc0NToz
LjE0LjAtcmM1LW5leHQtMjAxNDAzMDc6MTA5Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXN0
MC0wMzA3MDc0NS8xYjBhN2UzMjYzMTY4YTA2ZDM4NTg3OThlNDhjNWEyMWQxYzc4ZDNjL2Rt
ZXNnLXlvY3RvLXJvYW0tMzA6MjAxNDAzMDgwMzIyNTM6aTM4Ni1yYW5kY29uZmlnLXN0MC0w
MzA3MDc0NTozLjE0LjAtcmM1LW5leHQtMjAxNDAzMDc6MTA5Cjk2NDozOjEwIGFsbF9nb29k
OmJhZDphbGxfYmFkIGJvb3RzChtbMTszNW0yMDE0LTAzLTA4IDAzOjIzOjA4IFJFUEVBVCBD
T1VOVDogMTAwMCAgIyAva2VybmVsLXRlc3RzL2xpbnV4Ni9vYmotYmlzZWN0Ly5yZXBlYXQb
WzBtCgo=

--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.14.0-rc5-03765-gd478a96"

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
CONFIG_CONSTRUCTORS=y
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
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

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
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set

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
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_SCHED_AUTOGROUP=y
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
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
# CONFIG_BASE_FULL is not set
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
CONFIG_PERF_USE_VMALLOC=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_DEBUG_PERF_USE_VMALLOC=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
# CONFIG_SLUB is not set
CONFIG_SLOB=y
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
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
CONFIG_GCOV_KERNEL=y
# CONFIG_GCOV_PROFILE_ALL is not set
# CONFIG_GCOV_FORMAT_AUTODETECT is not set
# CONFIG_GCOV_FORMAT_3_4 is not set
CONFIG_GCOV_FORMAT_4_7=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
# CONFIG_MODULE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
# CONFIG_MSDOS_PARTITION is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
# CONFIG_CMDLINE_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
# CONFIG_SMP is not set
# CONFIG_X86_MPPARSE is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_GOLDFISH is not set
CONFIG_X86_INTEL_MID=y
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_RDC321X=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
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
CONFIG_HPET_EMULATE_RTC=y
CONFIG_APB_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
# CONFIG_VM86 is not set
CONFIG_TOSHIBA=y
CONFIG_I8K=m
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=y
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
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
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
# CONFIG_COMPACTION is not set
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_NEED_PER_CPU_KM=y
CONFIG_CLEANCACHE=y
CONFIG_CMA=y
CONFIG_CMA_DEBUG=y
# CONFIG_ZBUD is not set
# CONFIG_ZSMALLOC is not set
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
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_PM_RUNTIME is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=m
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_ACPI_REDUCED_HARDWARE_ONLY=y
# CONFIG_ACPI_APEI is not set
CONFIG_ACPI_EXTLOG=y
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
# CONFIG_CPU_IDLE_GOV_LADDER is not set
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
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
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
# CONFIG_EISA_PCI_EISA is not set
# CONFIG_EISA_VIRTUAL_ROOT is not set
# CONFIG_EISA_NAMES is not set
# CONFIG_SCx200 is not set
CONFIG_ALIX=y
CONFIG_NET5501=y
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA=m
# CONFIG_PCMCIA_LOAD_CIS is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_I82365=m
CONFIG_TCIC=m
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set
CONFIG_X86_SYSFB=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
# CONFIG_COREDUMP is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
# CONFIG_NET_KEY is not set
# CONFIG_INET is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
CONFIG_X25=m
CONFIG_LAPB=m
CONFIG_PHONET=m
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y
CONFIG_BATMAN_ADV=m
CONFIG_BATMAN_ADV_NC=y
CONFIG_BATMAN_ADV_DEBUG=y
CONFIG_OPENVSWITCH=m
CONFIG_VSOCKETS=y
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_NETLINK_MMAP=y
# CONFIG_NETLINK_DIAG is not set
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
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_SLCAN=y
CONFIG_CAN_DEV=m
# CONFIG_CAN_CALC_BITTIMING is not set
# CONFIG_CAN_LEDS is not set
CONFIG_CAN_MCP251X=m
CONFIG_CAN_JANZ_ICAN3=m
# CONFIG_PCH_CAN is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
# CONFIG_CAN_SJA1000_PLATFORM is not set
CONFIG_CAN_EMS_PCMCIA=m
CONFIG_CAN_EMS_PCI=m
CONFIG_CAN_PEAK_PCMCIA=m
# CONFIG_CAN_PEAK_PCI is not set
CONFIG_CAN_KVASER_PCI=m
# CONFIG_CAN_PLX_PCI is not set
# CONFIG_CAN_TSCAN1 is not set
CONFIG_CAN_C_CAN=m
# CONFIG_CAN_C_CAN_PLATFORM is not set
CONFIG_CAN_C_CAN_PCI=m
# CONFIG_CAN_CC770 is not set

#
# CAN USB interfaces
#
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
CONFIG_CAN_KVASER_USB=m
CONFIG_CAN_PEAK_USB=m
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_SOFTING is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

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
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
# CONFIG_DONGLE is not set
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=m
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_TOSHIBA_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
# CONFIG_VIA_FIR is not set
CONFIG_MCS_FIR=m
# CONFIG_BT is not set
# CONFIG_WIRELESS is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_REGULATOR is not set
# CONFIG_RFKILL_GPIO is not set
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
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
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
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_CMA is not set

#
# Bus devices
#
CONFIG_CONNECTOR=m
CONFIG_MTD=y
CONFIG_MTD_TESTS=m
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_CMDLINE_PARTS=m
CONFIG_MTD_AR7_PARTS=y

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=y
# CONFIG_MTD_BLOCK is not set
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
# CONFIG_INFTL is not set
CONFIG_RFD_FTL=m
CONFIG_SSFDC=y
CONFIG_SM_FTL=m
CONFIG_MTD_OOPS=y

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
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
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_COMPAT=y
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=m
# CONFIG_MTD_NETSC520 is not set
CONFIG_MTD_TS5500=m
CONFIG_MTD_AMD76XROM=m
CONFIG_MTD_ICHXROM=m
CONFIG_MTD_ESB2ROM=m
# CONFIG_MTD_CK804XROM is not set
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
CONFIG_MTD_L440GX=m
# CONFIG_MTD_INTEL_VR_NOR is not set
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
# CONFIG_MTD_PMC551_BUGFIX is not set
CONFIG_MTD_PMC551_DEBUG=y
# CONFIG_MTD_DATAFLASH is not set
CONFIG_MTD_M25P80=y
CONFIG_MTD_SST25L=m
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOCG3=m
CONFIG_BCH_CONST_M=14
CONFIG_BCH_CONST_T=4
CONFIG_MTD_NAND_ECC=m
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND is not set
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
CONFIG_MTD_ONENAND_GENERIC=m
# CONFIG_MTD_ONENAND_OTP is not set
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
CONFIG_MTD_UBI_BLOCK=y
CONFIG_PARPORT=y
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
CONFIG_PNPBIOS=y
# CONFIG_PNPBIOS_PROC_FS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
# CONFIG_BLK_DEV_FD is not set
# CONFIG_PARIDE is not set
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
# CONFIG_BLK_DEV_OSD is not set
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
# CONFIG_DUMMY_IRQ is not set
CONFIG_IBM_ASM=m
# CONFIG_PHANTOM is not set
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
# CONFIG_TIFM_7XX1 is not set
CONFIG_ICS932S401=y
CONFIG_ATMEL_SSC=m
CONFIG_ENCLOSURE_SERVICES=m
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=y
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=y
CONFIG_SENSORS_BH1780=y
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
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
# CONFIG_EEPROM_AT24 is not set
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=y
# CONFIG_INTEL_MEI_ME is not set
CONFIG_VMWARE_VMCI=m

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=m
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECS=m
CONFIG_BLK_DEV_DELKIN=m
CONFIG_BLK_DEV_IDECD=m
# CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=m
CONFIG_BLK_DEV_CMD640_ENHANCED=y
CONFIG_BLK_DEV_IDEPNP=m
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
CONFIG_BLK_DEV_OPTI621=m
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=m
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=m
# CONFIG_BLK_DEV_TRIFLEX is not set
CONFIG_BLK_DEV_CS5520=m
CONFIG_BLK_DEV_CS5530=m
# CONFIG_BLK_DEV_CS5535 is not set
CONFIG_BLK_DEV_CS5536=m
# CONFIG_BLK_DEV_HPT366 is not set
CONFIG_BLK_DEV_JMICRON=m
CONFIG_BLK_DEV_SC1200=m
CONFIG_BLK_DEV_PIIX=m
CONFIG_BLK_DEV_IT8172=m
CONFIG_BLK_DEV_IT8213=m
CONFIG_BLK_DEV_IT821X=m
CONFIG_BLK_DEV_NS87415=m
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=m
CONFIG_BLK_DEV_SVWKS=m
CONFIG_BLK_DEV_SIIMAGE=m
CONFIG_BLK_DEV_SIS5513=m
CONFIG_BLK_DEV_SLC90E66=m
CONFIG_BLK_DEV_TRM290=m
# CONFIG_BLK_DEV_VIA82CXXX is not set
CONFIG_BLK_DEV_TC86C001=m

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=m
CONFIG_BLK_DEV_ALI14XX=m
CONFIG_BLK_DEV_DTC2278=m
CONFIG_BLK_DEV_HT6560B=m
# CONFIG_BLK_DEV_QD65XX is not set
CONFIG_BLK_DEV_UMC8672=m
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
# CONFIG_BLK_DEV_SD is not set
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
CONFIG_SCSI_SRP_ATTRS=m
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_AHA152X is not set
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_NINJA_SCSI=m
# CONFIG_PCMCIA_QLOGIC is not set
# CONFIG_PCMCIA_SYM53C500 is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
# CONFIG_SATA_AHCI is not set
CONFIG_SATA_AHCI_PLATFORM=y
# CONFIG_AHCI_IMX is not set
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=y
CONFIG_SATA_SX4=m
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_MPIIX=y
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_OPTI=y
CONFIG_PATA_PCMCIA=m
# CONFIG_PATA_PLATFORM is not set
CONFIG_PATA_QDI=m
CONFIG_PATA_RZ1000=m
# CONFIG_PATA_WINBOND_VLB is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_LEGACY=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
# CONFIG_MD_FAULTY is not set
CONFIG_BCACHE=y
CONFIG_BCACHE_DEBUG=y
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_CRYPT is not set
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
# CONFIG_DM_DEBUG_BLOCK_STACK_TRACING is not set
# CONFIG_DM_CACHE is not set
# CONFIG_DM_MIRROR is not set
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_MULTIPATH_QL is not set
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=y
# CONFIG_DM_VERITY is not set
# CONFIG_DM_INTEGRITY is not set
CONFIG_DM_SWITCH=m
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=y
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_NTB_NETDEV=m
CONFIG_TUN=m
CONFIG_VETH=y
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
CONFIG_ARCNET=y
# CONFIG_ARCNET_1201 is not set
# CONFIG_ARCNET_1051 is not set
CONFIG_ARCNET_RAW=y
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=y
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_ISA=m
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_ARCNET_COM20020_CS=m

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=m
CONFIG_VHOST_RING=m
CONFIG_VHOST=m

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
CONFIG_NET_DSA_MV88E6060=y
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL3=m
CONFIG_3C515=m
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_3C589 is not set
CONFIG_VORTEX=m
CONFIG_TYPHOON=y
# CONFIG_NET_VENDOR_ADAPTEC is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_NET_VENDOR_AMD is not set
# CONFIG_NET_VENDOR_ARC is not set
# CONFIG_NET_VENDOR_ATHEROS is not set
# CONFIG_NET_CADENCE is not set
# CONFIG_NET_VENDOR_BROADCOM is not set
# CONFIG_NET_VENDOR_BROCADE is not set
CONFIG_NET_CALXEDA_XGMAC=m
# CONFIG_NET_VENDOR_CHELSIO is not set
CONFIG_NET_VENDOR_CIRRUS=y
# CONFIG_CS89x0 is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_DNET=y
# CONFIG_NET_VENDOR_DEC is not set
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=y
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
# CONFIG_NET_VENDOR_HP is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=m
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
# CONFIG_IGBVF is not set
CONFIG_IXGB=m
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
# CONFIG_I40E is not set
CONFIG_I40EVF=m
# CONFIG_NET_VENDOR_I825XX is not set
# CONFIG_IP1000 is not set
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=m
CONFIG_SKGE=m
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKGE_GENESIS=y
# CONFIG_SKY2 is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=y
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=y
# CONFIG_MLX4_DEBUG is not set
# CONFIG_MLX5_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
CONFIG_KS8842=m
CONFIG_KS8851=m
# CONFIG_KS8851_MLL is not set
CONFIG_KSZ884X_PCI=y
# CONFIG_NET_VENDOR_MICROCHIP is not set
CONFIG_FEALNX=y
# CONFIG_NET_VENDOR_NATSEMI is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
# CONFIG_NET_VENDOR_OKI is not set
CONFIG_ETHOC=y
# CONFIG_NET_PACKET_ENGINE is not set
# CONFIG_NET_VENDOR_QLOGIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
CONFIG_8139_OLD_RX_RESET=y
# CONFIG_R8169 is not set
CONFIG_SH_ETH=y
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=m
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
CONFIG_SIS190=y
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
CONFIG_NET_VENDOR_STMICRO=y
CONFIG_STMMAC_ETH=m
# CONFIG_STMMAC_PLATFORM is not set
CONFIG_STMMAC_PCI=y
# CONFIG_STMMAC_DEBUG_FS is not set
CONFIG_STMMAC_DA=y
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=m
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=m
# CONFIG_VIA_RHINE_MMIO is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
CONFIG_WIZNET_W5100=y
CONFIG_WIZNET_W5300=y
CONFIG_WIZNET_BUS_DIRECT=y
# CONFIG_WIZNET_BUS_INDIRECT is not set
# CONFIG_WIZNET_BUS_ANY is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_FDDI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=y
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=y
# CONFIG_LXT_PHY is not set
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=y
CONFIG_BCM7XXX_PHY=y
CONFIG_BCM87XX_PHY=y
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=y
CONFIG_STE10XP=y
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=y
CONFIG_MDIO_GPIO=m
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PLIP is not set
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
# CONFIG_PPPOE is not set
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
# CONFIG_SLIP is not set
CONFIG_SLHC=y

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
# CONFIG_USB_KAWETH is not set
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=y
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_HUAWEI_CDC_NCM=y
CONFIG_USB_NET_CDC_MBIM=y
CONFIG_USB_NET_DM9601=m
# CONFIG_USB_NET_SR9700 is not set
CONFIG_USB_NET_SR9800=y
CONFIG_USB_NET_SMSC75XX=m
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=m
# CONFIG_USB_NET_CDC_SUBSET is not set
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_CX82310_ETH=y
CONFIG_USB_NET_KALMIA=y
CONFIG_USB_NET_QMI_WWAN=m
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_CDC_PHONET is not set
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=m
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#
# CONFIG_WIMAX_I2400M_USB is not set
# CONFIG_WAN is not set
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
CONFIG_INPUT_MOUSEDEV=m
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=m
CONFIG_KEYBOARD_QT2160=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=m
CONFIG_KEYBOARD_TCA8418=m
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_LM8333=y
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_OPENCORES=m
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_SH_KEYSC=m
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_TC3589X is not set
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_CYAPA=y
CONFIG_MOUSE_INPORT=m
# CONFIG_MOUSE_ATIXL is not set
# CONFIG_MOUSE_LOGIBM is not set
CONFIG_MOUSE_PC110PAD=y
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=y
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=m
# CONFIG_JOYSTICK_ADI is not set
CONFIG_JOYSTICK_COBRA=m
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=m
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=m
# CONFIG_JOYSTICK_AS5011 is not set
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_JOYSTICK_WALKERA0701 is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_HANWANG=m
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=m
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_AD7877=y
# CONFIG_TOUCHSCREEN_AD7879 is not set
CONFIG_TOUCHSCREEN_ATMEL_MXT=m
CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=m
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
CONFIG_TOUCHSCREEN_DA9052=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=m
CONFIG_TOUCHSCREEN_EETI=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
CONFIG_TOUCHSCREEN_GUNZE=m
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_WACOM_I2C=m
CONFIG_TOUCHSCREEN_MAX11801=y
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=y
# CONFIG_TOUCHSCREEN_INTEL_MID is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=m
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_PIXCIR=y
# CONFIG_TOUCHSCREEN_WM831X is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
# CONFIG_TOUCHSCREEN_MC13783 is not set
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
# CONFIG_TOUCHSCREEN_USB_3M is not set
# CONFIG_TOUCHSCREEN_USB_ITM is not set
CONFIG_TOUCHSCREEN_USB_ETURBO=y
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
# CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH is not set
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_ELO=y
CONFIG_TOUCHSCREEN_USB_E2I=y
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
# CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_USB_EASYTOUCH=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC_SERIO=m
CONFIG_TOUCHSCREEN_TSC2005=y
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_TOUCHSCREEN_PCAP=m
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMPE is not set
CONFIG_TOUCHSCREEN_SUR40=y
CONFIG_TOUCHSCREEN_TPS6507X=m
CONFIG_TOUCHSCREEN_ZFORCE=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=m
CONFIG_INPUT_AD714X=y
# CONFIG_INPUT_AD714X_I2C is not set
CONFIG_INPUT_AD714X_SPI=y
# CONFIG_INPUT_BMA150 is not set
CONFIG_INPUT_MC13783_PWRBUTTON=m
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_GP2A=m
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_WISTRON_BTNS=m
CONFIG_INPUT_ATLAS_BTNS=m
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_KXTJ9=m
# CONFIG_INPUT_KXTJ9_POLLED_MODE is not set
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_TWL6040_VIBRA=m
CONFIG_INPUT_UINPUT=y
# CONFIG_INPUT_PCF50633_PMU is not set
# CONFIG_INPUT_PCF8574 is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
CONFIG_INPUT_DA9052_ONKEY=m
CONFIG_INPUT_DA9055_ONKEY=m
# CONFIG_INPUT_WM831X_ON is not set
CONFIG_INPUT_PCAP=y
# CONFIG_INPUT_ADXL34X is not set
CONFIG_INPUT_IMS_PCU=m
CONFIG_INPUT_CMA3000=m
CONFIG_INPUT_CMA3000_I2C=m
CONFIG_INPUT_IDEAPAD_SLIDEBAR=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=y
CONFIG_GAMEPORT=y
# CONFIG_GAMEPORT_NS558 is not set
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
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
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_DMA is not set
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set
CONFIG_SERIAL_8250_DW=m

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CLPS711X=y
# CONFIG_SERIAL_CLPS711X_CONSOLE is not set
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_MFD_HSU=y
CONFIG_SERIAL_MFD_HSU_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_SERIAL_SCCNXP=y
# CONFIG_SERIAL_SCCNXP_CONSOLE is not set
CONFIG_SERIAL_TIMBERDALE=m
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_IFX6X60=y
CONFIG_SERIAL_PCH_UART=m
CONFIG_SERIAL_ARC=y
CONFIG_SERIAL_ARC_CONSOLE=y
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
CONFIG_SERIAL_FSL_LPUART=y
CONFIG_SERIAL_FSL_LPUART_CONSOLE=y
CONFIG_SERIAL_ST_ASC=m
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_HW_RANDOM_TPM=y
CONFIG_NVRAM=m
# CONFIG_DTLK is not set
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=m

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
# CONFIG_IPWIRELESS is not set
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=m
CONFIG_TCG_TIS_I2C_ATMEL=y
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=y
CONFIG_TCG_INFINEON=m
CONFIG_TCG_ST33_I2C=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

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
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=m
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
CONFIG_I2C_DESIGNWARE_PCI=m
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
CONFIG_I2C_KEMPLD=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_RIIC=m
CONFIG_I2C_SH_MOBILE=m
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set
CONFIG_I2C_RCAR=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_ROBOTFUZZ_OSIF=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=y
CONFIG_I2C_PCA_ISA=y
CONFIG_SCx200_ACB=m
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
# CONFIG_SPI_ATMEL is not set
# CONFIG_SPI_BCM2835 is not set
CONFIG_SPI_BCM63XX_HSSPI=m
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_EP93XX=y
CONFIG_SPI_GPIO=y
# CONFIG_SPI_IMX is not set
# CONFIG_SPI_LM70_LLP is not set
CONFIG_SPI_FSL_DSPI=y
CONFIG_SPI_OC_TINY=y
CONFIG_SPI_TI_QSPI=y
# CONFIG_SPI_OMAP_100K is not set
# CONFIG_SPI_ORION is not set
CONFIG_SPI_PXA2XX_DMA=y
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=m
CONFIG_SPI_SC18IS602=m
CONFIG_SPI_SH=m
CONFIG_SPI_SH_HSPI=y
CONFIG_SPI_SUN4I=y
CONFIG_SPI_SUN6I=m
# CONFIG_SPI_TEGRA114 is not set
CONFIG_SPI_TEGRA20_SFLASH=m
CONFIG_SPI_TEGRA20_SLINK=y
CONFIG_SPI_TOPCLIFF_PCH=y
CONFIG_SPI_TXX9=y
CONFIG_SPI_XCOMM=y
CONFIG_SPI_XILINX=m
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set
# CONFIG_SPI_DW_MMIO is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
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
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_PARPORT is not set
CONFIG_PPS_CLIENT_GPIO=m

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
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
# CONFIG_GPIO_SYSFS is not set
CONFIG_GPIO_DA9052=m
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_CLPS711X is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=y
CONFIG_GPIO_ICH=y
CONFIG_GPIO_VX855=m
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_LP3943=m
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TC3589X is not set
CONFIG_GPIO_TPS65912=y
CONFIG_GPIO_TWL6040=y
# CONFIG_GPIO_WM831X is not set
# CONFIG_GPIO_WM8350 is not set
# CONFIG_GPIO_WM8994 is not set
CONFIG_GPIO_ADP5520=y
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=m
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=m
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=m
CONFIG_GPIO_MC33880=y

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
CONFIG_GPIO_JANZ_TTL=m
# CONFIG_GPIO_PALMAS is not set
# CONFIG_GPIO_TPS6586X is not set
# CONFIG_GPIO_TPS65910 is not set
CONFIG_GPIO_MSIC=y

#
# USB GPIO expanders:
#
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_DS1WM=m
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=m
CONFIG_W1_SLAVE_DS2408_READBACK=y
# CONFIG_W1_SLAVE_DS2413 is not set
# CONFIG_W1_SLAVE_DS2423 is not set
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_DS2780=m
CONFIG_W1_SLAVE_DS2781=m
CONFIG_W1_SLAVE_DS28E04=m
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
CONFIG_GENERIC_ADC_BATTERY=m
CONFIG_WM831X_BACKUP=y
CONFIG_WM831X_POWER=m
CONFIG_WM8350_POWER=m
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_88PM860X is not set
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2780=m
# CONFIG_BATTERY_DS2781 is not set
CONFIG_BATTERY_DS2782=m
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_DA9052=m
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=m
# CONFIG_CHARGER_PCF50633 is not set
CONFIG_BATTERY_INTEL_MID=m
CONFIG_CHARGER_ISP1704=y
# CONFIG_CHARGER_MAX8903 is not set
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
CONFIG_CHARGER_MAX14577=m
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24190 is not set
CONFIG_CHARGER_BQ24735=m
CONFIG_CHARGER_SMB347=m
CONFIG_CHARGER_TPS65090=y
CONFIG_BATTERY_GOLDFISH=y
# CONFIG_POWER_RESET is not set
CONFIG_POWER_AVS=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7314=m
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADCXX=m
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
CONFIG_SENSORS_ADT7310=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_DA9055=m
CONFIG_SENSORS_I5K_AMB=m
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_G762=m
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_HTU21=m
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IIO_HWMON is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_LM95245 is not set
CONFIG_SENSORS_MAX1111=m
# CONFIG_SENSORS_MAX16065 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
# CONFIG_SENSORS_MAX197 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
CONFIG_SENSORS_MCP3021=m
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1275 is not set
# CONFIG_SENSORS_LM25066 is not set
CONFIG_SENSORS_LTC2978=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_WM8350=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set
CONFIG_RCAR_THERMAL=m
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_ACPI_INT3403_THERMAL=y

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_DA9052_WATCHDOG=y
CONFIG_DA9055_WATCHDOG=m
CONFIG_WM831X_WATCHDOG=y
# CONFIG_WM8350_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
CONFIG_RETU_WATCHDOG=y
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=m
CONFIG_SC520_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
CONFIG_I6300ESB_WDT=m
# CONFIG_IE6XX_WDT is not set
CONFIG_INTEL_SCU_WATCHDOG=y
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=m
CONFIG_KEMPLD_WDT=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
CONFIG_PC87413_WDT=m
# CONFIG_NV_TCO is not set
# CONFIG_RDC321X_WDT is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=m
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=y
CONFIG_VIA_WDT=y
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m
# CONFIG_MEN_A21_WDT is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
CONFIG_MIXCOMWD=y
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
CONFIG_BCMA_HOST_SOC=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_AS3711=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
# CONFIG_MFD_DA9052_I2C is not set
CONFIG_MFD_DA9055=y
CONFIG_MFD_DA9063=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_SPI=y
CONFIG_MFD_MC13XXX_I2C=m
CONFIG_HTC_PASIC3=m
CONFIG_HTC_I2CPLD=y
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
CONFIG_MFD_INTEL_MSIC=y
CONFIG_MFD_JANZ_CMODIO=y
CONFIG_MFD_KEMPLD=m
# CONFIG_MFD_88PM800 is not set
CONFIG_MFD_88PM805=m
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
CONFIG_MFD_MAX77686=y
# CONFIG_MFD_MAX77693 is not set
CONFIG_MFD_MAX8907=m
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
CONFIG_EZX_PCAP=y
# CONFIG_MFD_VIPERBOARD is not set
CONFIG_MFD_RETU=y
CONFIG_MFD_PCF50633=m
CONFIG_PCF50633_ADC=m
# CONFIG_PCF50633_GPIO is not set
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_RTSX_PCI=m
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
CONFIG_MFD_SI476X_CORE=m
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMicroelectronics STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
CONFIG_STMPE_SPI=y
CONFIG_MFD_SYSCON=y
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_MFD_LP3943=m
CONFIG_MFD_LP8788=y
CONFIG_MFD_PALMAS=y
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
CONFIG_TPS6507X=m
CONFIG_MFD_TPS65090=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
CONFIG_MFD_WL1273_CORE=m
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=m
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_ARIZONA_SPI=m
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
CONFIG_MFD_WM8997=y
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
# CONFIG_REGULATOR_VIRTUAL_CONSUMER is not set
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_88PM8607=y
# CONFIG_REGULATOR_ACT8865 is not set
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_ANATOP=m
CONFIG_REGULATOR_AS3711=y
CONFIG_REGULATOR_DA9052=m
# CONFIG_REGULATOR_DA9055 is not set
# CONFIG_REGULATOR_DA9063 is not set
# CONFIG_REGULATOR_DA9210 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_GPIO=m
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=y
CONFIG_REGULATOR_LP872X=y
CONFIG_REGULATOR_LP8755=m
# CONFIG_REGULATOR_LP8788 is not set
CONFIG_REGULATOR_MAX14577=m
CONFIG_REGULATOR_MAX1586=y
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8907=m
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_MAX77686=m
CONFIG_REGULATOR_MC13XXX_CORE=m
# CONFIG_REGULATOR_MC13783 is not set
CONFIG_REGULATOR_MC13892=m
# CONFIG_REGULATOR_PALMAS is not set
CONFIG_REGULATOR_PCAP=m
CONFIG_REGULATOR_PCF50633=m
# CONFIG_REGULATOR_PFUZE100 is not set
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS62360=y
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=y
# CONFIG_REGULATOR_TPS65090 is not set
CONFIG_REGULATOR_TPS6524X=m
CONFIG_REGULATOR_TPS6586X=m
CONFIG_REGULATOR_TPS65910=m
CONFIG_REGULATOR_TPS65912=y
CONFIG_REGULATOR_WM831X=m
# CONFIG_REGULATOR_WM8350 is not set
CONFIG_REGULATOR_WM8994=y
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I2C_NXP_TDA998X=m
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=m
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_NOUVEAU=m
CONFIG_NOUVEAU_DEBUG=5
CONFIG_NOUVEAU_DEBUG_DEFAULT=3
# CONFIG_DRM_NOUVEAU_BACKLIGHT is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
CONFIG_DRM_VIA=m
# CONFIG_DRM_SAVAGE is not set
CONFIG_DRM_VMWGFX=m
# CONFIG_DRM_VMWGFX_FBCON is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
# CONFIG_DRM_MGAG200 is not set
# CONFIG_DRM_CIRRUS_QEMU is not set
CONFIG_DRM_QXL=m
CONFIG_DRM_BOCHS=y
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_HDMI=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
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
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
# CONFIG_FB_SIS_300 is not set
CONFIG_FB_SIS_315=y
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=y
# CONFIG_FB_3DFX is not set
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=y
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=m
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
# CONFIG_FB_SM501 is not set
CONFIG_FB_SMSCUFX=y
CONFIG_FB_UDL=y
CONFIG_FB_GOLDFISH=m
CONFIG_FB_VIRTUAL=y
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
# CONFIG_FB_MB862XX_I2C is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_FB_AUO_K190X=m
CONFIG_FB_AUO_K1900=m
CONFIG_FB_AUO_K1901=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_LCD_L4F00242T03=m
CONFIG_LCD_LMS283GF05=m
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI922X=m
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=m
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=m
# CONFIG_LCD_LD9040 is not set
CONFIG_LCD_AMS369FG06=m
CONFIG_LCD_LMS501KF03=m
CONFIG_LCD_HX8357=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_DA9052=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP5520 is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=m
CONFIG_BACKLIGHT_PCF50633=m
CONFIG_BACKLIGHT_LM3630A=y
CONFIG_BACKLIGHT_LM3639=m
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_LP8788=m
CONFIG_BACKLIGHT_AS3711=y
# CONFIG_BACKLIGHT_GPIO is not set
CONFIG_BACKLIGHT_LV5207LP=y
# CONFIG_BACKLIGHT_BD6107 is not set
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
# CONFIG_LOGO_LINUX_CLUT224 is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=y
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
CONFIG_HID_APPLEIR=m
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=m
# CONFIG_HID_CYPRESS is not set
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=y
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
CONFIG_HID_HOLTEK=y
# CONFIG_HOLTEK_FF is not set
CONFIG_HID_HUION=y
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
# CONFIG_HID_LOGITECH_DJ is not set
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWHEELS_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=y
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=y
# CONFIG_HID_PICOLCD_FB is not set
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
# CONFIG_HID_PICOLCD_LEDS is not set
# CONFIG_HID_PRIMAX is not set
CONFIG_HID_ROCCAT=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=m
# CONFIG_HID_SUNPLUS is not set
CONFIG_HID_GREENASIA=m
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TIVO=y
# CONFIG_HID_TOPSEED is not set
CONFIG_HID_THINGM=y
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=y
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
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
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_OTG=y
CONFIG_USB_OTG_WHITELIST=y
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB=m
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_EHCI_HCD_PLATFORM=m
CONFIG_USB_OXU210HP_HCD=m
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=m
CONFIG_USB_ISP1362_HCD=m
CONFIG_USB_FUSBH200_HCD=m
CONFIG_USB_FOTG210_HCD=y
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_HCD_ISO=y
CONFIG_USB_SL811_CS=m
CONFIG_USB_R8A66597_HCD=m
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set
CONFIG_USB_HCD_BCMA=m
CONFIG_USB_HCD_SSB=m
CONFIG_USB_HCD_TEST_MODE=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=y
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_MUSB_HOST=y
CONFIG_USB_MUSB_TUSB6010=m
# CONFIG_USB_MUSB_UX500 is not set
CONFIG_MUSB_PIO_ONLY=y
CONFIG_USB_DWC3=m
CONFIG_USB_DWC3_HOST=y

#
# Platform Glue Driver Support
#
CONFIG_USB_DWC3_OMAP=m
# CONFIG_USB_DWC3_EXYNOS is not set
CONFIG_USB_DWC3_PCI=m
CONFIG_USB_DWC3_KEYSTONE=m

#
# Debugging features
#
# CONFIG_USB_DWC3_DEBUG is not set
CONFIG_USB_DWC2=y
CONFIG_USB_DWC2_DEBUG=y
CONFIG_USB_DWC2_VERBOSE=y
# CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
CONFIG_USB_DWC2_DEBUG_PERIODIC=y
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=m
# CONFIG_USB_LEGOTOWER is not set
CONFIG_USB_LCD=m
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=m
CONFIG_USB_EHSET_TEST_FIXTURE=m
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
CONFIG_USB_PHY=y
CONFIG_USB_OTG_FSM=m
# CONFIG_KEYSTONE_USB_PHY is not set
CONFIG_NOP_USB_XCEIV=y
CONFIG_OMAP_CONTROL_USB=y
CONFIG_AM335X_CONTROL_USB=y
CONFIG_AM335X_PHY_USB=y
CONFIG_SAMSUNG_USBPHY=y
# CONFIG_SAMSUNG_USB2PHY is not set
CONFIG_SAMSUNG_USB3PHY=y
CONFIG_USB_GPIO_VBUS=y
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_ISP1301 is not set
CONFIG_USB_RCAR_PHY=m
CONFIG_USB_RCAR_GEN2_PHY=m
# CONFIG_USB_GADGET is not set
CONFIG_UWB=m
# CONFIG_UWB_HWA is not set
# CONFIG_UWB_WHCI is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
CONFIG_MMC_CLKGATE=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
CONFIG_MMC_OMAP_HS=m
CONFIG_MMC_WBSD=m
# CONFIG_MMC_TIFM_SD is not set
CONFIG_MMC_SPI=m
CONFIG_MMC_SDRICOH_CS=m
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_SH_MMCIF=m
# CONFIG_MMC_VUB300 is not set
CONFIG_MMC_USHC=m
CONFIG_MMC_REALTEK_PCI=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_PCA9532=y
CONFIG_LEDS_PCA9532_GPIO=y
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=m
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=m
CONFIG_LEDS_LP8501=m
CONFIG_LEDS_LP8788=m
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_PCA9685=y
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_WM8350=m
CONFIG_LEDS_DA9052=m
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_REGULATOR=m
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=y
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_ADP5520 is not set
CONFIG_LEDS_DELL_NETBOOKS=m
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=m
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
CONFIG_LEDS_TRIGGER_ONESHOT=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_LEDS_TRIGGER_TRANSIENT is not set
CONFIG_LEDS_TRIGGER_CAMERA=m
CONFIG_ACCESSIBILITY=y
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
# CONFIG_RTC_SYSTOHC is not set
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_DS1307=y
# CONFIG_RTC_DRV_DS1374 is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=m
# CONFIG_RTC_DRV_LP8788 is not set
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8907=m
CONFIG_RTC_DRV_MAX77686=y
# CONFIG_RTC_DRV_RS5C372 is not set
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=y
# CONFIG_RTC_DRV_ISL12057 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PALMAS is not set
CONFIG_RTC_DRV_PCF2127=y
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TPS6586X is not set
CONFIG_RTC_DRV_TPS65910=m
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=m
CONFIG_RTC_DRV_RV3029C2=m

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
CONFIG_RTC_DRV_M41T94=m
CONFIG_RTC_DRV_DS1305=m
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=m
# CONFIG_RTC_DRV_RS5C348 is not set
CONFIG_RTC_DRV_DS3234=y
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_RX4581 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_VRTC is not set
# CONFIG_RTC_DRV_DS1286 is not set
CONFIG_RTC_DRV_DS1511=m
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=y
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=y
CONFIG_RTC_DRV_M48T59=y
CONFIG_RTC_DRV_MSM6242=y
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m
# CONFIG_RTC_DRV_DS2404 is not set
# CONFIG_RTC_DRV_WM831X is not set
# CONFIG_RTC_DRV_WM8350 is not set
# CONFIG_RTC_DRV_PCF50633 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=m
CONFIG_RTC_DRV_MC13XXX=m
CONFIG_RTC_DRV_MOXART=y

#
# HID Sensor RTC drivers
#
CONFIG_RTC_DRV_HID_SENSOR_TIME=m
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
CONFIG_DMADEVICES_VDEBUG=y

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=m
CONFIG_INTEL_IOATDMA=m
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=y
# CONFIG_DW_DMAC_PCI is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y
CONFIG_DMA_ACPI=y

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=y
CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
# CONFIG_UIO_PDRV_GENIRQ is not set
CONFIG_UIO_DMEM_GENIRQ=m
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=m
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=m
# CONFIG_UIO_MF624 is not set
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
CONFIG_ET131X=y
CONFIG_SLICOSS=m
# CONFIG_USBIP_CORE is not set
CONFIG_ECHO=y
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_DEFAULT_BUF_SIZE_KB=2048
CONFIG_COMEDI_DEFAULT_BUF_MAXSIZE_KB=20480
# CONFIG_COMEDI_MISC_DRIVERS is not set
# CONFIG_COMEDI_ISA_DRIVERS is not set
CONFIG_COMEDI_PCI_DRIVERS=y
CONFIG_COMEDI_8255_PCI=m
CONFIG_COMEDI_ADDI_WATCHDOG=m
# CONFIG_COMEDI_ADDI_APCI_035 is not set
CONFIG_COMEDI_ADDI_APCI_1032=m
CONFIG_COMEDI_ADDI_APCI_1500=m
CONFIG_COMEDI_ADDI_APCI_1516=m
CONFIG_COMEDI_ADDI_APCI_1564=m
# CONFIG_COMEDI_ADDI_APCI_16XX is not set
CONFIG_COMEDI_ADDI_APCI_2032=m
# CONFIG_COMEDI_ADDI_APCI_2200 is not set
# CONFIG_COMEDI_ADDI_APCI_3120 is not set
CONFIG_COMEDI_ADDI_APCI_3501=m
CONFIG_COMEDI_ADDI_APCI_3XXX=m
# CONFIG_COMEDI_ADL_PCI6208 is not set
CONFIG_COMEDI_ADL_PCI7X3X=m
# CONFIG_COMEDI_ADL_PCI8164 is not set
CONFIG_COMEDI_ADL_PCI9111=m
# CONFIG_COMEDI_ADL_PCI9118 is not set
CONFIG_COMEDI_ADV_PCI1710=m
CONFIG_COMEDI_ADV_PCI1723=m
CONFIG_COMEDI_ADV_PCI1724=m
# CONFIG_COMEDI_ADV_PCI_DIO is not set
CONFIG_COMEDI_AMPLC_DIO200_PCI=m
CONFIG_COMEDI_AMPLC_PC236_PCI=m
# CONFIG_COMEDI_AMPLC_PC263_PCI is not set
CONFIG_COMEDI_AMPLC_PCI224=m
CONFIG_COMEDI_AMPLC_PCI230=m
CONFIG_COMEDI_CONTEC_PCI_DIO=m
CONFIG_COMEDI_DAS08_PCI=m
CONFIG_COMEDI_DT3000=m
CONFIG_COMEDI_DYNA_PCI10XX=m
CONFIG_COMEDI_GSC_HPDI=m
# CONFIG_COMEDI_MF6X4 is not set
CONFIG_COMEDI_ICP_MULTI=m
# CONFIG_COMEDI_DAQBOARD2000 is not set
CONFIG_COMEDI_JR3_PCI=m
CONFIG_COMEDI_KE_COUNTER=m
CONFIG_COMEDI_CB_PCIDAS64=m
# CONFIG_COMEDI_CB_PCIDAS is not set
CONFIG_COMEDI_CB_PCIDDA=m
# CONFIG_COMEDI_CB_PCIMDAS is not set
CONFIG_COMEDI_CB_PCIMDDA=m
CONFIG_COMEDI_ME4000=m
CONFIG_COMEDI_ME_DAQ=m
CONFIG_COMEDI_NI_6527=m
CONFIG_COMEDI_NI_65XX=m
# CONFIG_COMEDI_NI_660X is not set
CONFIG_COMEDI_NI_670X=m
# CONFIG_COMEDI_NI_LABPC_PCI is not set
# CONFIG_COMEDI_NI_PCIDIO is not set
CONFIG_COMEDI_NI_PCIMIO=m
# CONFIG_COMEDI_RTD520 is not set
# CONFIG_COMEDI_S626 is not set
CONFIG_COMEDI_MITE=m
CONFIG_COMEDI_NI_TIOCMD=m
CONFIG_COMEDI_PCMCIA_DRIVERS=y
# CONFIG_COMEDI_CB_DAS16_CS is not set
CONFIG_COMEDI_DAS08_CS=m
CONFIG_COMEDI_NI_DAQ_700_CS=m
CONFIG_COMEDI_NI_DAQ_DIO24_CS=m
CONFIG_COMEDI_NI_LABPC_CS=m
CONFIG_COMEDI_NI_MIO_CS=m
CONFIG_COMEDI_QUATECH_DAQP_CS=m
# CONFIG_COMEDI_USB_DRIVERS is not set
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_FC=m
CONFIG_COMEDI_AMPLC_DIO200=m
CONFIG_COMEDI_AMPLC_PC236=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_NI_TIO=m
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
CONFIG_RTS5139=y
# CONFIG_RTS5139_DEBUG is not set
CONFIG_RTS5208=m
CONFIG_RTS5208_DEBUG=y
# CONFIG_TRANZPORT is not set
CONFIG_DX_SEP=m

#
# IIO staging drivers
#

#
# Accelerometers
#
CONFIG_ADIS16201=m
# CONFIG_ADIS16203 is not set
CONFIG_ADIS16204=m
CONFIG_ADIS16209=m
CONFIG_ADIS16220=m
CONFIG_ADIS16240=m
# CONFIG_LIS3L02DQ is not set
CONFIG_SCA3000=m

#
# Analog to digital converters
#
CONFIG_AD7291=m
CONFIG_AD7606=m
CONFIG_AD7606_IFACE_PARALLEL=m
# CONFIG_AD7606_IFACE_SPI is not set
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y
CONFIG_AD7780=m
CONFIG_AD7816=m
# CONFIG_AD7192 is not set
# CONFIG_AD7280 is not set
# CONFIG_LPC32XX_ADC is not set
CONFIG_MXS_LRADC=m
# CONFIG_SPEAR_ADC is not set

#
# Analog digital bi-direction converters
#
CONFIG_ADT7316=m
CONFIG_ADT7316_SPI=m
# CONFIG_ADT7316_I2C is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=m
CONFIG_AD7746=m

#
# Direct Digital Synthesis
#
CONFIG_AD5930=m
# CONFIG_AD9832 is not set
CONFIG_AD9834=m
CONFIG_AD9850=m
# CONFIG_AD9852 is not set
CONFIG_AD9910=m
CONFIG_AD9951=m

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16060 is not set

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=m

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
# CONFIG_SENSORS_ISL29028 is not set
CONFIG_TSL2583=m
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
CONFIG_ADE7753=m
# CONFIG_ADE7754 is not set
CONFIG_ADE7758=m
CONFIG_ADE7759=m
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m
# CONFIG_ADE7854_SPI is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=m
# CONFIG_AD2S1200 is not set
# CONFIG_AD2S1210 is not set

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=m
CONFIG_IIO_SIMPLE_DUMMY=m
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# CONFIG_FB_SM7XX is not set
CONFIG_CRYSTALHD=m
CONFIG_FB_XGI=y
CONFIG_ACPI_QUICKSTART=m
CONFIG_USB_ENESTORAGE=m
CONFIG_BCM_WIMAX=m
CONFIG_FT1000=m
CONFIG_FT1000_USB=m
CONFIG_FT1000_PCMCIA=m

#
# Speakup console speech
#
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
# CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4 is not set
CONFIG_STAGING_MEDIA=y

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
CONFIG_ASHMEM=y
CONFIG_ANDROID_LOGGER=y
CONFIG_ANDROID_TIMED_OUTPUT=y
CONFIG_ANDROID_TIMED_GPIO=m
CONFIG_ANDROID_LOW_MEMORY_KILLER=y
CONFIG_ANDROID_INTF_ALARM_DEV=y
CONFIG_SYNC=y
# CONFIG_SW_SYNC is not set
CONFIG_ION=y
CONFIG_ION_TEST=y
CONFIG_ION_DUMMY=y
CONFIG_USB_WPAN_HCD=y
CONFIG_WIMAX_GDM72XX=y
CONFIG_WIMAX_GDM72XX_QOS=y
CONFIG_WIMAX_GDM72XX_K_MODE=y
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_USB=y
CONFIG_LTE_GDM724X=m
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_CED1401=y
CONFIG_DGRP=m
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
CONFIG_XILLYBUS=y
CONFIG_XILLYBUS_PCIE=m
CONFIG_DGNC=y
CONFIG_DGAP=y
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
CONFIG_ACERHDF=y
CONFIG_ASUS_LAPTOP=m
# CONFIG_DELL_WMI is not set
CONFIG_DELL_WMI_AIO=m
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
# CONFIG_FUJITSU_TABLET is not set
CONFIG_AMILO_RFKILL=m
CONFIG_TC1100_WMI=m
CONFIG_HP_ACCEL=y
CONFIG_HP_WIRELESS=m
# CONFIG_HP_WMI is not set
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=m
# CONFIG_SONY_LAPTOP is not set
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
CONFIG_THINKPAD_ACPI_DEBUG=y
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_SENSORS_HDAPS is not set
CONFIG_INTEL_MENLOW=m
CONFIG_ACPI_WMI=m
# CONFIG_MSI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=m
CONFIG_INTEL_SCU_IPC=y
CONFIG_INTEL_SCU_IPC_UTIL=y
CONFIG_GPIO_INTEL_PMIC=y
CONFIG_INTEL_MID_POWER_BUTTON=y
# CONFIG_INTEL_MFLD_THERMAL is not set
CONFIG_INTEL_IPS=m
# CONFIG_IBM_RTL is not set
CONFIG_XO15_EBOOK=m
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=m
CONFIG_INTEL_RST=y
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_PVPANIC=y
# CONFIG_CHROME_PLATFORMS is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_DW_APB_TIMER=y
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
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=m
CONFIG_EXTCON_ADC_JACK=m
# CONFIG_EXTCON_MAX14577 is not set
CONFIG_EXTCON_PALMAS=y
CONFIG_MEMORY=y
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#
# CONFIG_BMA180 is not set
# CONFIG_HID_SENSOR_ACCEL_3D is not set
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
CONFIG_KXSD9=m

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=m
CONFIG_AD7266=m
CONFIG_AD7298=m
CONFIG_AD7476=m
CONFIG_AD7791=m
CONFIG_AD7793=m
# CONFIG_AD7887 is not set
CONFIG_AD7923=m
# CONFIG_LP8788_ADC is not set
CONFIG_MAX1363=m
CONFIG_MCP320X=m
# CONFIG_MCP3422 is not set
CONFIG_NAU7802=m
CONFIG_TI_ADC081C=m

#
# Amplifiers
#
CONFIG_AD8366=m

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
CONFIG_IIO_ST_SENSORS_I2C=m
CONFIG_IIO_ST_SENSORS_SPI=m
CONFIG_IIO_ST_SENSORS_CORE=m

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
# CONFIG_AD5446 is not set
CONFIG_AD5449=m
CONFIG_AD5504=m
CONFIG_AD5624R_SPI=m
CONFIG_AD5686=m
CONFIG_AD5755=m
CONFIG_AD5764=m
CONFIG_AD5791=m
# CONFIG_AD7303 is not set
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=m

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16080=m
CONFIG_ADIS16130=m
# CONFIG_ADIS16136 is not set
# CONFIG_ADIS16260 is not set
CONFIG_ADXRS450=m
CONFIG_HID_SENSOR_GYRO_3D=m
CONFIG_IIO_ST_GYRO_3AXIS=m
CONFIG_IIO_ST_GYRO_I2C_3AXIS=m
CONFIG_IIO_ST_GYRO_SPI_3AXIS=m
CONFIG_ITG3200=m

#
# Humidity sensors
#
CONFIG_DHT11=m

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
# CONFIG_ADIS16480 is not set
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y
# CONFIG_INV_MPU6050_IIO is not set

#
# Light sensors
#
CONFIG_ADJD_S311=m
CONFIG_APDS9300=m
# CONFIG_CM32181 is not set
CONFIG_CM36651=m
CONFIG_GP2AP020A00F=m
# CONFIG_HID_SENSOR_ALS is not set
CONFIG_TCS3472=m
CONFIG_SENSORS_TSL2563=m
CONFIG_TSL4531=m
# CONFIG_VCNL4000 is not set

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_MAG3110 is not set
# CONFIG_HID_SENSOR_MAGNETOMETER_3D is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set

#
# Pressure sensors
#
CONFIG_MPL3115=m
CONFIG_IIO_ST_PRESS=m
CONFIG_IIO_ST_PRESS_I2C=m
CONFIG_IIO_ST_PRESS_SPI=m

#
# Temperature sensors
#
# CONFIG_TMP006 is not set
CONFIG_NTB=y
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
CONFIG_RESET_CONTROLLER=y
CONFIG_FMC=m
CONFIG_FMC_FAKEDEV=m
# CONFIG_FMC_TRIVIAL is not set
# CONFIG_FMC_WRITE_EEPROM is not set
# CONFIG_FMC_CHARDEV is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_PHY_EXYNOS_MIPI_VIDEO=m
# CONFIG_TI_PIPE3 is not set
CONFIG_BCM_KONA_USB2_PHY=m
# CONFIG_POWERCAP is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_GOOGLE_FIRMWARE is not set
CONFIG_UEFI_CPER=y

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
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_XFS_WARN=y
# CONFIG_XFS_DEBUG is not set
CONFIG_BTRFS_FS=m
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
CONFIG_BTRFS_ASSERT=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=m
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
# CONFIG_QUOTA is not set
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=m
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
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
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=y
CONFIG_HFSPLUS_FS_POSIX_ACL=y
# CONFIG_BEFS_FS is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
# CONFIG_JFFS2_FS_WRITEBUFFER is not set
# CONFIG_JFFS2_SUMMARY is not set
# CONFIG_JFFS2_FS_XATTR is not set
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
# CONFIG_JFFS2_CMODE_PRIORITY is not set
CONFIG_JFFS2_CMODE_SIZE=y
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
# CONFIG_SQUASHFS_XATTR is not set
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
# CONFIG_ROMFS_BACKED_BY_MTD is not set
# CONFIG_ROMFS_BACKED_BY_BOTH is not set
CONFIG_ROMFS_ON_BLOCK=y
# CONFIG_PSTORE is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
CONFIG_UFS_DEBUG=y
CONFIG_EXOFS_FS=m
# CONFIG_EXOFS_DEBUG is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
CONFIG_F2FS_CHECK_FS=y
CONFIG_ORE=m
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=m
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=m
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=m
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
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
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
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
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_DEBUG_SHIRQ=y

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_WRITECOUNT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_TRACE=y
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
# CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
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
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_UPROBE_EVENT is not set
# CONFIG_PROBE_EVENTS is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=m
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_PERCPU_TEST=m
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=m
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=m
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_TEST_MODULE=m
CONFIG_TEST_USER_COPY=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_SET_MODULE_RONX is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_DOUBLEFAULT is not set
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
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
# CONFIG_KEYS is not set
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_YAMA is not set
# CONFIG_IMA is not set
# CONFIG_EVM is not set
CONFIG_EVM_HMAC_ATTRS="fsuuid"
CONFIG_EVM_HMAC_XATTRS="security.selinux security.SMACK64 security.ima security.capability"
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
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
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
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
# CONFIG_CRYPTO_HMAC is not set
CONFIG_CRYPTO_XCBC=y
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=y
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_586=y
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
# CONFIG_CRYPTO_DEV_CCP is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=m
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_LGUEST=m
CONFIG_BINARY_PRINTF=y

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
CONFIG_STMP_DEVICE=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=m
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
# CONFIG_CRC8 is not set
CONFIG_AUDIT_GENERIC=y
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BCH=m
CONFIG_BCH_CONST_PARAMS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set

--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--1UWUbFP1cBYEclgG--
