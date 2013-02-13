Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906Ab3BML6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 06:58:24 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:59969 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab3BML6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 06:58:21 -0500
Message-ID: <1360756629.4803.5.camel@thor.lan>
Subject: Re: [Bisected][-next-20130204+] [x86/kvm] udevd:[97]: segfault at
 ffffffffff5fd020 ip 00007fff069e277f sp 00007fff068c9ef8 error d
From: Peter Hurley <peter@hurleysoftware.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Wed, 13 Feb 2013 06:57:09 -0500
In-Reply-To: <20130213105129.GB9817@redhat.com>
References: <1360715210.31472.20.camel@thor.lan>
	 <511AE0A7.2000101@linux.intel.com> <20130213105129.GB9817@redhat.com>
Content-Type: multipart/mixed; boundary="=-zF6tWuqbn1HqhqGanR6c"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zF6tWuqbn1HqhqGanR6c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2013-02-13 at 12:51 +0200, Gleb Natapov wrote:
> On Tue, Feb 12, 2013 at 04:39:03PM -0800, H. Peter Anvin wrote:
> > On 02/12/2013 04:26 PM, Peter Hurley wrote:
> > > With -next-20130204+ in ubuntu 12.10 VM (so the 80x25 VGA
> > > device/console):
> > > 
> > > [    0.666410] udevd[97]: starting version 175
> > > [    0.674043] udevd[97]: udevd:[97]: segfault at ffffffffff5fd020 ip 00007fff069e277f sp 00007fff068c9ef8 error d
> > > 
> > > and boots to an initramfs prompt.
> > > 
> > > git bisect (log attached) blames:
> > > 
> > > commit 7b5c4a65cc27f017c170b025f8d6d75dabb11c6f
> > > Merge: 3596f5b 949db15
> > > Author: H. Peter Anvin <hpa@linux.intel.com>
> > > Date:   Fri Jan 25 16:31:21 2013 -0800
> > > 
> > >     Merge tag 'v3.8-rc5' into x86/mm
> > >     
> > >     The __pa() fixup series that follows touches KVM code that is not
> > >     present in the existing branch based on v3.7-rc5, so merge in the
> > >     current upstream from Linus.
> > >     
> > >     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > > 
> > > 
> > > This only happens with the VGA device/console but that is the default
> > > configuration for Ubuntu/KVM because it blacklists pretty much every fb
> > > driver.
> > > 
> > 
> > I am guessing this is another bad use of __pa()... need to look into that.
> > 
> He is using 64bit guest and on those __pa() happens to be working. Is it
> possible that slow_virt_to_phys() does not work as expected? Peter (the
> bug reporter :)) can you run your guest kernel with loglevel=7 and
> attach send me console output?

Attached.

BTW, this message happens on 'good' boots too:

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /home/peter/src/kernels/next/arch/x86/kernel/pvclock.c:182 pvclock_init_vsyscall+0x22/0x60()
[    0.000000] Hardware name: Bochs
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.8.0-next-20130204-xeon #20130204
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8105812f>] warn_slowpath_common+0x7f/0xc0
[    0.000000]  [<ffffffff8105818a>] warn_slowpath_null+0x1a/0x20
[    0.000000]  [<ffffffff81d20521>] pvclock_init_vsyscall+0x22/0x60
[    0.000000]  [<ffffffff81d20480>] kvm_setup_vsyscall_timeinfo+0x74/0xd8
[    0.000000]  [<ffffffff81d201d1>] kvm_guest_init+0xd0/0xe9
[    0.000000]  [<ffffffff81d13f7c>] setup_arch+0xbee/0xcaf
[    0.000000]  [<ffffffff816cbceb>] ? printk+0x61/0x63
[    0.000000]  [<ffffffff81d0cbc3>] start_kernel+0xd3/0x3f0
[    0.000000]  [<ffffffff81d0c5e4>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d0c6d7>] x86_64_start_kernel+0xf1/0x100
[    0.000000] ---[ end trace b47bb564b2d6ec76 ]---

Regards,
Peter Hurley

--=-zF6tWuqbn1HqhqGanR6c
Content-Disposition: attachment; filename="segfault_dmesg.log"
Content-Type: text/x-log; name="segfault_dmesg.log"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-next-20130204-xeon (root@thor) (gcc version 4.7.2 (Ubuntu/Linaro 4.7.2-2ubuntu1) ) #20130204 SMP PREEMPT Mon Feb 11 06:49:31 EST 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-next-20130204-xeon root=UUID=cc4fa0a9-18f9-4d5a-b4ec-0243574558a2 ro text loglevel=7
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009dbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009dc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fffe000-0x000000007fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x7fffe max_arch_pfn = 0x400000000
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
[    0.000000] PAT not supported by CPU.
[    0.000000] found SMP MP-table at [mem 0x000fdaa0-0x000fdaaf] mapped at [ffff8800000fdaa0]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01f69000, 0x01f69fff] PGTABLE
[    0.000000] BRK [0x01f6a000, 0x01f6afff] PGTABLE
[    0.000000] BRK [0x01f6b000, 0x01f6bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7fe00000-0x7fffdfff]
[    0.000000]  [mem 0x7fe00000-0x7fffdfff] page 4k
[    0.000000] BRK [0x01f6c000, 0x01f6cfff] PGTABLE
[    0.000000] BRK [0x01f6d000, 0x01f6dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7c000000-0x7fdfffff]
[    0.000000]  [mem 0x7c000000-0x7fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x7bffffff] page 2M
[    0.000000] RAMDISK: [mem 0x3648e000-0x3723efff]
[    0.000000] ACPI: RSDP 00000000000fd8c0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000007fffe470 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000007fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000007fffe4b0 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000007fffff40 00040
[    0.000000] ACPI: SSDT 000000007ffffd70 001C1 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000007ffffc70 00090 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000007ffffc30 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000007ffff5e0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000007fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x7fffdfff]
[    0.000000]   NODE_DATA [mem 0x7fffb000-0x7fffdfff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:7fffa001, boot clock
[    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007d600000-ffff88007f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x7fffdfff]
[    0.000000] On node 0 totalpages: 524171
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3981 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8128 pages used for memmap
[    0.000000]   DMA32 zone: 520190 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /home/peter/src/kernels/next/arch/x86/kernel/pvclock.c:182 pvclock_init_vsyscall+0x22/0x60()
[    0.000000] Hardware name: Bochs
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.8.0-next-20130204-xeon #20130204
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8105812f>] warn_slowpath_common+0x7f/0xc0
[    0.000000]  [<ffffffff8105818a>] warn_slowpath_null+0x1a/0x20
[    0.000000]  [<ffffffff81d20521>] pvclock_init_vsyscall+0x22/0x60
[    0.000000]  [<ffffffff81d20480>] kvm_setup_vsyscall_timeinfo+0x74/0xd8
[    0.000000]  [<ffffffff81d201d1>] kvm_guest_init+0xd0/0xe9
[    0.000000]  [<ffffffff81d13f7c>] setup_arch+0xbee/0xcaf
[    0.000000]  [<ffffffff816cbceb>] ? printk+0x61/0x63
[    0.000000]  [<ffffffff81d0cbc3>] start_kernel+0xd3/0x3f0
[    0.000000]  [<ffffffff81d0c5e4>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d0c6d7>] x86_64_start_kernel+0xf1/0x100
[    0.000000] ---[ end trace b47bb564b2d6ec76 ]---
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x80000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88007fc00000 s85568 r8192 d20928 u524288
[    0.000000] pcpu-alloc: s85568 r8192 d20928 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] kvm-clock: cpu 0, msr 0:7fffa001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 7fc0dec0
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 515973
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-next-20130204-xeon root=UUID=cc4fa0a9-18f9-4d5a-b4ec-0243574558a2 ro text loglevel=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 2033356k/2097144k available (7059k kernel code, 460k absent, 63328k reserved, 6211k data, 1160k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	Hierarchical RCU autobalancing is disabled.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2493.748 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 4987.49 BogoMIPS (lpj=9974992)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] Security Framework initialized
[    0.008000] AppArmor: AppArmor initialized
[    0.008000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.009317] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.010519] Mount-cache hash table entries: 256
[    0.011444] Initializing cgroup subsys cpuacct
[    0.012008] Initializing cgroup subsys devices
[    0.012514] Initializing cgroup subsys freezer
[    0.013011] Initializing cgroup subsys blkio
[    0.013518] Initializing cgroup subsys perf_event
[    0.014140] mce: CPU supports 10 MCE banks
[    0.014697] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014697] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014697] tlb_flushall_shift: 6
[    0.016445] Freeing SMP alternatives: 24k freed
[    0.022822] ACPI: Core revision 20130117
[    0.024299] ACPI: All ACPI Tables successfully acquired
[    0.025061] ftrace: allocating 26131 entries in 103 pages
[    0.033967] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.036003] smpboot: CPU0: Intel Core 2 Duo P9xxx (Penryn Class Core 2) (fam: 06, model: 02, stepping: 03)
[    0.040000] Performance Events: unsupported p6 CPU model 2 no PMU driver, software events only.
[    0.061882] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.008000] kvm-clock: cpu 1, msr 0:7fffa041, secondary cpu clock
[    0.084066] KVM setup async PF for cpu 1
[    0.085434] kvm-stealtime: cpu 1, msr 7fc8dec0
[    0.008000] kvm-clock: cpu 2, msr 0:7fffa081, secondary cpu clock
[    0.112063] KVM setup async PF for cpu 2
[    0.113198] kvm-stealtime: cpu 2, msr 7fd0dec0
[    0.068167] smpboot: Booting Node   0, Processors  #1 #2 #3 OK
[    0.008000] kvm-clock: cpu 3, msr 0:7fffa0c1, secondary cpu clock
[    0.136071] Brought up 4 CPUs
[    0.136062] KVM setup async PF for cpu 3
[    0.136067] kvm-stealtime: cpu 3, msr 7fd8dec0
[    0.140003] smpboot: Total of 4 processors activated (19949.98 BogoMIPS)
[    0.141366] devtmpfs: initialized
[    0.145532] EVM: security.selinux
[    0.145987] EVM: security.SMACK64
[    0.146435] EVM: security.capability
[    0.148804] regulator-dummy: no parameters
[    0.149392] RTC time: 11:42:48, date: 02/13/13
[    0.149968] NET: Registered protocol family 16
[    0.150782] ACPI: bus type pci registered
[    0.151412] PCI: Using configuration type 1 for base access
[    0.153046] bio: create slab <bio-0> at 0
[    0.153046] ACPI: Added _OSI(Module Device)
[    0.153046] ACPI: Added _OSI(Processor Device)
[    0.153084] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.153582] ACPI: Added _OSI(Processor Aggregator Device)
[    0.156801] ACPI: EC: Look up EC in DSDT
[    0.158483] ACPI: Interpreter enabled
[    0.158954] ACPI: (supports S0ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.160419] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.161540]  S3 S4 S5)
[    0.162285] ACPI: Using IOAPIC for interrupt routing
[    0.162807] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.166785] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.167343] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.167551] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.168004] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.168861] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.168863] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.168866] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.168868] acpi PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.168871] PCI: root bus 00: using default resources
[    0.168874] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.169881] PCI host bridge to bus 0000:00
[    0.170357] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.170882] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.171437] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffff]
[    0.172057] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.172610] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.173337] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.176004] pci 0000:00:01.1: reg 20: [io  0xc0a0-0xc0af]
[    0.177089] pci 0000:00:01.2: [8086:7020] type 00 class 0x0c0300
[    0.179236] pci 0000:00:01.2: reg 20: [io  0xc040-0xc05f]
[    0.180230] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.180815] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.181662] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.184273] pci 0000:00:02.0: [1234:1111] type 00 class 0x030000
[    0.188404] pci 0000:00:02.0: reg 10: [mem 0xfd000000-0xfdffffff pref]
[    0.193663] pci 0000:00:02.0: reg 30: [mem 0xfebd0000-0xfebdffff pref]
[    0.194262] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.195086] pci 0000:00:03.0: reg 10: [io  0xc060-0xc07f]
[    0.195843] pci 0000:00:03.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.199384] pci 0000:00:03.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.200191] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.200684] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    0.203669] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.204400] pci 0000:00:05.0: reg 10: [io  0xc000-0xc03f]
[    0.205156] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.209168] pci 0000:00:06.0: [1af4:1002] type 00 class 0x00ff00
[    0.209640] pci 0000:00:06.0: reg 10: [io  0xc080-0xc09f]
[    0.212893] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.214013] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.216133] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.217338] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.218518] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.219703] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.221201] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.221941] acpi root: \_SB_.PCI0 notify handler is installed
[    0.221967] Found 1 acpi root devices
[    0.222421] ACPI: No dock devices found.
[    0.223107] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.224004] vgaarb: loaded
[    0.224436] vgaarb: bridge control possible 0000:00:02.0
[    0.225340] SCSI subsystem initialized
[    0.225819] ACPI: bus type scsi registered
[    0.226480] libata version 3.00 loaded.
[    0.226480] ACPI: bus type usb registered
[    0.226480] usbcore: registered new interface driver usbfs
[    0.228024] usbcore: registered new interface driver hub
[    0.228594] usbcore: registered new device driver usb
[    0.228696] PCI: Using ACPI for IRQ routing
[    0.228696] PCI: pci_cache_line_size set to 64 bytes
[    0.228836] e820: reserve RAM buffer [mem 0x0009dc00-0x0009ffff]
[    0.228843] e820: reserve RAM buffer [mem 0x7fffe000-0x7fffffff]
[    0.229114] NetLabel: Initializing
[    0.229575] NetLabel:  domain hash size = 128
[    0.230064] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.232020] NetLabel:  unlabeled traffic allowed by default
[    0.232588] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.232779] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.233708] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.248083] Switching to clocksource kvm-clock
[    0.261422] AppArmor: AppArmor Filesystem Enabled
[    0.262010] pnp: PnP ACPI init
[    0.262492] ACPI: bus type pnp registered
[    0.263094] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.263208] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.263274] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.263318] pnp 00:03: [dma 2]
[    0.263349] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.263487] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.263667] pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.263827] pnp: PnP ACPI: found 6 devices
[    0.264355] ACPI: ACPI bus type pnp unregistered
[    0.276506] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.276509] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffffff]
[    0.276564] NET: Registered protocol family 2
[    0.279238] TCP established hash table entries: 16384 (order: 6, 262144 bytes)
[    0.280359] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.281125] TCP: Hash tables configured (established 16384 bind 16384)
[    0.281838] TCP: reno registered
[    0.282300] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.282883] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.283581] NET: Registered protocol family 1
[    0.284137] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.284788] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.285381] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.286132] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    0.286839] pci 0000:00:02.0: Boot video device
[    0.286908] PCI: CLS 0 bytes, default 64
[    0.287004] Trying to unpack rootfs image as initramfs...
[    0.618372] Freeing initrd memory: 14020k freed
[    0.626237] audit: initializing netlink socket (disabled)
[    0.626811] type=2000 audit(1360755767.624:1): initialized
[    0.652081] bounce pool size: 64 pages
[    0.652603] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.655393] VFS: Disk quotas dquot_6.5.2
[    0.655959] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.657341] fuse init (API version 7.21)
[    0.657992] msgmni has been set to 3998
[    0.660067] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.661011] io scheduler noop registered
[    0.661487] io scheduler deadline registered
[    0.661973] io scheduler cfq registered (default)
[    0.662604] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.663155] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.663800] intel_idle: does not run on family 6 model 2
[    0.663896] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.664776] ACPI: Power Button [PWRF]
[    0.667448] GHES: HEST is not enabled!
[    0.668288] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[    0.668892] virtio-pci 0000:00:03.0: setting latency timer to 64
[    0.669208] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    0.669783] virtio-pci 0000:00:05.0: setting latency timer to 64
[    0.670318] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[    0.670893] virtio-pci 0000:00:06.0: setting latency timer to 64
[    0.671097] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.694246] 00:04: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.698509] Linux agpgart interface v0.103
[    0.701963] brd: module loaded
[    0.703922] loop: module loaded
[    0.704686] virtio-pci 0000:00:05.0: irq 40 for MSI/MSI-X
[    0.704718] virtio-pci 0000:00:05.0: irq 41 for MSI/MSI-X
[    0.705826]  vda: vda1 vda2 < vda5 >
[    0.707141] ata_piix 0000:00:01.1: version 2.13
[    0.707257] ata_piix 0000:00:01.1: setting latency timer to 64
[    0.707844] scsi0 : ata_piix
[    0.708518] scsi1 : ata_piix
[    0.708997] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc0a0 irq 14
[    0.709569] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc0a8 irq 15
[    0.710486] libphy: Fixed MDIO Bus: probed
[    0.710995] tun: Universal TUN/TAP device driver, 1.6
[    0.711499] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.712894] virtio-pci 0000:00:03.0: irq 42 for MSI/MSI-X
[    0.712936] virtio-pci 0000:00:03.0: irq 43 for MSI/MSI-X
[    0.712968] virtio-pci 0000:00:03.0: irq 44 for MSI/MSI-X
[    0.714604] PPP generic driver version 2.4.2
[    0.715227] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.715801] ehci-pci: EHCI PCI platform driver
[    0.716381] ehci-platform: EHCI generic platform driver
[    0.716916] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.717489] uhci_hcd: USB Universal Host Controller Interface driver
[    0.718149] uhci_hcd 0000:00:01.2: setting latency timer to 64
[    0.718163] uhci_hcd 0000:00:01.2: UHCI Host Controller
[    0.718699] uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
[    0.719685] uhci_hcd 0000:00:01.2: irq 11, io base 0x0000c040
[    0.720509] hub 1-0:1.0: USB hub found
[    0.720996] hub 1-0:1.0: 2 ports detected
[    0.721694] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.723493] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.724090] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.724740] mousedev: PS/2 mouse device common for all mice
[    0.725697] rtc_cmos 00:00: RTC can wake from S4
[    0.726969] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    0.728448] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    0.729177] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    0.729901] device-mapper: uevent: version 1.0.3
[    0.730538] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[    0.731441] cpuidle: using governor ladder
[    0.731933] cpuidle: using governor menu
[    0.732454] EFI Variables Facility v0.08 2004-May-17
[    0.733228] ashmem: initialized
[    0.733890] TCP: cubic registered
[    0.734479] NET: Registered protocol family 10
[    0.735360] NET: Registered protocol family 17
[    0.735886] Key type dns_resolver registered
[    0.736735] PM: Hibernation image not present or could not be loaded.
[    0.736749] registered taskstats version 1
[    0.747253] Key type trusted registered
[    0.754548] Key type encrypted registered
[    0.763988]   Magic number: 1:800:731
[    0.764520] block vda2: hash matches
[    0.765217] rtc_cmos 00:00: setting system clock to 2013-02-13 11:42:48 UTC (1360755768)
[    0.766310] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.766899] EDD information not available.
[    0.868566] ata2.01: NODEV after polling detection
[    0.868913] ata2.00: ATAPI: QEMU DVD-ROM, 1.2.0, max UDMA/100
[    0.870024] ata2.00: configured for MWDMA2
[    0.871482] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.2. PQ: 0 ANSI: 5
[    0.873723] sr0: scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    0.874271] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.875093] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    0.875422] sr 1:0:0:0: Attached scsi generic sg0 type 5
[    0.877557] Freeing unused kernel memory: 1160k freed
[    0.878667] Write protecting the kernel read-only data: 12288k
[    0.882409] Freeing unused kernel memory: 1120k freed
[    0.885468] Freeing unused kernel memory: 904k freed
<30>[    0.959222] udevd[108]: starting version 175
[    0.965536] udevd[108]: segfault at ffffffffff5fd0e0 ip 00007fffc4bfe77f sp 00007fffc4ba0af8 error d
[    1.624134] tsc: Refined TSC clocksource calibration: 2493.749 MHz
[  154.301427] EXT4-fs (vda1): recovery complete
[  154.319257] EXT4-fs (vda1): mounted filesystem with ordered data mode. Opts: (null)

--=-zF6tWuqbn1HqhqGanR6c--

