Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaCVKFW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 06:05:22 -0400
Received: from lekensteyn.nl ([178.21.112.251]:32841 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbaCVKFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 06:05:17 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: Gleb Natapov <gleb@kernel.org>
Cc: Venkatesh Srinivas <venkateshs@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: GPF in intel_pmu_lbr_reset() with qemu -cpu host
Date: Sat, 22 Mar 2014 11:05:03 +0100
Message-ID: <1558917.OgpeoK0IhF@al>
User-Agent: KMail/4.12.3 (Linux/3.14.0-rc7-custom-00033-g8878439; KDE/4.12.3; x86_64; ; )
In-Reply-To: <20140322085045.GA5535@minantech.com>
References: <4055058.qLAukpngnj@al> <CAHdzE-88ZPTs_QvVLZsHs=O6TNKG61+iLH+ctGKLMdG5h6G0sg@mail.gmail.com> <20140322085045.GA5535@minantech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 March 2014 10:50:45 Gleb Natapov wrote:
> On Fri, Mar 21, 2014 at 12:04:32PM -0700, Venkatesh Srinivas wrote:
> > On Fri, Mar 21, 2014 at 10:46 AM, Peter Wu <peter@lekensteyn.nl> wrote:
> [skip]
> 
> > When -cpu host is used, qemu/kvm passed the host CPUID F/M/S to the
> > guest. intel_pmu_cpu_*() -> intel_pmu_lbr_reset() uses rdmsr() /
> > wrmsr(), rather than the safe variants; if KVM does not support the
> > particular MSRs in question, you will see a #GP(0) there. See
> > https://lkml.org/lkml/2014/3/13/453 for a similar bug other PMU code.
> > 
> When kernel is compiled with guest support all rdmsr()/wrmsr() become _safe(),
> so the question for Peter is if his guest kernel has guest support enabled?

Linux guest support (CONFIG_HYPERVISOR_GUEST) was not enabled, see
.config in the first mail[1]. Enabling that option does not change the
situation.

With CONFIG_PARAVIRT and CONFIG_KVM_GUEST enabled, the PMU GPF is gone,
but now I have a NULL dereference (in rapl_pmu_init). Previously, when
`-cpu SandyBridge` was passed to qemu, it would show this:

    [    0.016995] Performance Events: unsupported p6 CPU model 42 no PMU driver, software events only.

The same NULL pointer deref would be visible (slightly different
addresses, but the Code lines are equal). With `-host`, the NULL deref
with `-cpu host` contains:

    [    0.016445] Performance Events: 16-deep LBR, IvyBridge events, Intel PMU driver.

Full dmesg below.

Stepping through the debugger (for `-cpu SandyBridge`) showed that the
pmu variable is NULL (in arch/x86/kernel/cpu/perf_event_intel_rapl.c)
Skipping that line (`jump +1` in gdb) allowed Linux to continue
booting without crashing. I have no idea what is going on here,
but hopefully this information helps.

Kind regards,
Peter

 [1]: https://lkml.kernel.org/r/4055058.qLAukpngnj@al

[    0.000000] Linux version 3.14.0-rc7-qemu-00059-g08edb33 (pc@antartica) (gcc version 4.8.2 (Ubuntu 4.8.2-16ubuntu6) ) #27 Sat Mar 22 10:06:46 CET 2014
[    0.000000] Command line: console=ttyS0 loglevel=8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000003fffe000-0x000000003fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x3fffe max_arch_pfn = 0x400000000
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
[    0.000000] found SMP MP-table at [mem 0x000f1b10-0x000f1b1f] mapped at [ffff8800000f1b10]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x019d1000, 0x019d1fff] PGTABLE
[    0.000000] BRK [0x019d2000, 0x019d2fff] PGTABLE
[    0.000000] BRK [0x019d3000, 0x019d3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x3fc00000-0x3fdfffff]
[    0.000000]  [mem 0x3fc00000-0x3fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x3c000000-0x3fbfffff]
[    0.000000]  [mem 0x3c000000-0x3fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x3bffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x3fe00000-0x3fffdfff]
[    0.000000]  [mem 0x3fe00000-0x3fffdfff] page 4k
[    0.000000] BRK [0x019d4000, 0x019d4fff] PGTABLE
[    0.000000] ACPI: RSDP 00000000000f19b0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000003ffffad3 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000003ffff177 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000003fffe040 001137 (v01   BXPC   BXDSDT 00000001 INTL 20130823)
[    0.000000] ACPI: FACS 000000003fffe000 000040
[    0.000000] ACPI: SSDT 000000003ffff1eb 000838 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000003ffffa23 000078 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000003ffffa9b 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:3fffd001, boot clock
[    0.000000]  [ffffea0000000000-ffffea0000ffffff] PMD -> [ffff88003e600000-ffff88003f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x3fffdfff]
[    0.000000] On node 0 totalpages: 262044
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 4032 pages used for memmap
[    0.000000]   DMA32 zone: 258046 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
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
[    0.000000] nr_irqs_gsi: 40
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 162cd80
[    0.000000] e820: [mem 0x40000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257927
[    0.000000] Kernel command line: console=ttyS0 loglevel=8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 1019980K/1048176K available (2892K kernel code, 355K rwdata, 720K rodata, 3116K init, 428K bss, 28196K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS:4352 nr_irqs:256 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3392.292 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 6784.58 BogoMIPS (lpj=13569168)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] ACPI: Core revision 20131218
[    0.008109] ACPI: All ACPI Tables successfully acquired
[    0.008966] Mount-cache hash table entries: 256
[    0.009752] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.009752] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.009752] tlb_flushall_shift: 2
[    0.011935] CPU: Intel(R) Core(TM) i7-3770 CPU @ 3.40GHz (fam: 06, model: 3a, stepping: 09)
[    0.016291] Performance Events: 16-deep LBR, IvyBridge events, Intel PMU driver.
[    0.017460] ... version:                2
[    0.018057] ... bit width:              48
[    0.018666] ... generic registers:      4
[    0.019282] ... value mask:             0000ffffffffffff
[    0.020003] ... max period:             000000007fffffff
[    0.020787] ... fixed-purpose events:   3
[    0.021382] ... event mask:             000000070000000f
[    0.025328] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.026242] TSC deadline timer enabled
[    0.026833] devtmpfs: initialized
[    0.027385] NET: Registered protocol family 16
[    0.028000] cpuidle: using governor ladder
[    0.028000] cpuidle: using governor menu
[    0.028000] ACPI: bus type PCI registered
[    0.028000] PCI: Using configuration type 1 for base access
[    0.028043] bio: create slab <bio-0> at 0
[    0.028659] ACPI: Added _OSI(Module Device)
[    0.029283] ACPI: Added _OSI(Processor Device)
[    0.029929] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.030612] ACPI: Added _OSI(Processor Aggregator Device)
[    0.032294] ACPI: Interpreter enabled
[    0.032853] ACPI: (supports S0 S5)
[    0.033382] ACPI: Using IOAPIC for interrupt routing
[    0.034111] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.036680] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.037595] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.038385] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.039385] PCI host bridge to bus 0000:00
[    0.039994] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.040004] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.040907] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.041800] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.042792] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.043783] pci_bus 0000:00: scanning bus
[    0.044038] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.044907] pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x10
[    0.046116] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.047433] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.049702] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.051297] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.052014] pci 0000:00:01.3: calling acpi_pm_check_blacklist+0x0/0x40
[    0.053325] pci 0000:00:01.3: calling quirk_piix4_acpi+0x0/0x140
[    0.054196] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.055240] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.056044] pci 0000:00:01.3: calling pci_fixup_piix4_acpi+0x0/0x10
[    0.057069] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.058779] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.060365] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.064713] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.065806] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.067329] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.068616] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.072318] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.073577] pci_bus 0000:00: fixups for bus
[    0.074188] pci_bus 0000:00: bus scan returning with max=00
[    0.075063] pci_bus 0000:00: on NUMA node 0
[    0.075809] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.076329] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.077310] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.078311] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.079273] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.080074] acpi LNXCPU:00: Invalid PBLK length [0]
[    0.081012] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.081801] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.082973] vgaarb: loaded
[    0.083375] vgaarb: bridge control possible 0000:00:02.0
[    0.084010] PCI: Using ACPI for IRQ routing
[    0.084621] PCI: pci_cache_line_size set to 64 bytes
[    0.085375] pci 0000:00:01.1: BAR 0: reserving [io  0x01f0-0x01f7 flags 0x110] (d=0, p=0)
[    0.086558] pci 0000:00:01.1: BAR 1: reserving [io  0x03f6 flags 0x110] (d=0, p=0)
[    0.087666] pci 0000:00:01.1: BAR 2: reserving [io  0x0170-0x0177 flags 0x110] (d=0, p=0)
[    0.088003] pci 0000:00:01.1: BAR 3: reserving [io  0x0376 flags 0x110] (d=0, p=0)
[    0.089102] pci 0000:00:01.1: BAR 4: reserving [io  0xc040-0xc04f flags 0x40101] (d=0, p=0)
[    0.090314] pci 0000:00:02.0: BAR 0: reserving [mem 0xfc000000-0xfdffffff flags 0x42208] (d=0, p=0)
[    0.091613] pci 0000:00:02.0: BAR 1: reserving [mem 0xfebf0000-0xfebf0fff flags 0x40200] (d=0, p=0)
[    0.092012] pci 0000:00:03.0: BAR 0: reserving [mem 0xfebc0000-0xfebdffff flags 0x40200] (d=0, p=0)
[    0.093334] pci 0000:00:03.0: BAR 1: reserving [io  0xc000-0xc03f flags 0x40101] (d=0, p=0)
[    0.094591] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.095460] e820: reserve RAM buffer [mem 0x3fffe000-0x3fffffff]
[    0.096059] Switched to clocksource kvm-clock
[    0.096714] pnp: PnP ACPI init
[    0.097172] ACPI: bus type PNP registered
[    0.097794] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.098772] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.099767] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.100692] pnp 00:03: [dma 2]
[    0.101151] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.102134] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.103119] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.104122] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.105120] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.106130] pnp: PnP ACPI: found 8 devices
[    0.106731] ACPI: bus type PNP unregistered
[    0.112256] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.113069] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.113880] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.114789] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.115714] NET: Registered protocol family 2
[    0.116404] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.117434] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.118374] TCP: Hash tables configured (established 8192 bind 8192)
[    0.119304] TCP: reno registered
[    0.119791] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.120664] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.121595] NET: Registered protocol family 1
[    0.122248] pci 0000:00:00.0: calling quirk_natoma+0x0/0x30
[    0.123059] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.123939] pci 0000:00:00.0: calling quirk_passive_release+0x0/0x90
[    0.124875] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.125724] pci 0000:00:01.0: calling quirk_isa_dma_hangs+0x0/0x30
[    0.126617] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.127523] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xd0
[    0.128391] pci 0000:00:02.0: Boot video device
[    0.129065] pci 0000:00:03.0: calling quirk_e100_interrupt+0x0/0x1c0
[    0.129992] PCI: CLS 0 bytes, default 64
[    0.153212] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
[    0.154421] IP: [<ffffffff81662301>] rapl_pmu_init+0x11a/0x15d
[    0.155292] PGD 0 
[    0.155617] Oops: 0000 [#1] 
[    0.156003] CPU: 0 PID: 1 Comm: swapper Not tainted 3.14.0-rc7-qemu-00059-g08edb33 #27
[    0.156003] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.156003] task: ffff88003e050000 ti: ffff88003e054000 task.ti: ffff88003e054000
[    0.156003] RIP: 0010:[<ffffffff81662301>]  [<ffffffff81662301>] rapl_pmu_init+0x11a/0x15d
[    0.156003] RSP: 0000:ffff88003e055ea0  EFLAGS: 00010246
[    0.156003] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff81623620
[    0.156003] RDX: 0000000000000003 RSI: 0000000000000001 RDI: ffffffff81637750
[    0.156003] RBP: ffff88003e055eb0 R08: ffff88003e0051c4 R09: ffff88003ffeed10
[    0.156003] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000068
[    0.156003] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    0.156003] FS:  0000000000000000(0000) GS:ffffffff8161f000(0000) knlGS:0000000000000000
[    0.156003] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.156003] CR2: 0000000000000020 CR3: 0000000001612000 CR4: 00000000001407b0
[    0.156003] Stack:
[    0.156003]  0000000000000000 0000000000000000 ffffffff816621e7 ffffffff8165ae40
[    0.156003]  0000000000000200 ffffffff8108761a ffffffff814a643a 0000006800000000
[    0.156003]  ffffffff814b3008 0000000000060006 0000000000000006 ffffffff816ef428
[    0.156003] Call Trace:
[    0.156003]  [<ffffffff816621e7>] ? intel_uncore_init+0x2a9/0x2a9
[    0.156003]  [<ffffffff8165ae40>] ? do_one_initcall+0x76/0x104
[    0.156003]  [<ffffffff8108761a>] ? parse_args+0x1fa/0x330
[    0.156003]  [<ffffffff8165afc3>] ? kernel_init_freeable+0xf5/0x177
[    0.156003]  [<ffffffff8165a826>] ? do_early_param+0x81/0x81
[    0.156003]  [<ffffffff812c7ae0>] ? rest_init+0x70/0x70
[    0.156003]  [<ffffffff812c7ae5>] ? kernel_init+0x5/0xe0
[    0.156003]  [<ffffffff812d1b0a>] ? ret_from_fork+0x7a/0xb0
[    0.156003]  [<ffffffff812c7ae0>] ? rest_init+0x70/0x70
[    0.156003] Code: 48 81 89 44 24 04 e8 bf 00 a1 ff 8b 44 24 04 48 c7 c7 d8 61 48 81 89 c6 31 c0 e8 61 99 c6 ff 83 c8 ff eb 46 48 8b 1d 07 9e fc ff <48> 8b 7b 20 e8 06 2a a1 ff 48 69 c8 e8 03 00 00 48 89 d0 be e8 
[    0.156003] RIP  [<ffffffff81662301>] rapl_pmu_init+0x11a/0x15d
[    0.156003]  RSP <ffff88003e055ea0>
[    0.156003] CR2: 0000000000000020
[    0.156003] ---[ end trace 30b5cedf4c045624 ]---
[    0.187473] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[    0.187473] 
[    0.188792] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)

