Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3JHCPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:15:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:17828 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab3JHCPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:15:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1053,1371106800"; 
   d="scan'208";a="406952698"
Date: Tue, 8 Oct 2013 10:14:52 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131008021452.GA6456@localhost>
References: <20131006082340.GA24568@localhost>
 <CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
 <20131007021118.GA27927@localhost>
 <20131007051038.GA9764@localhost>
 <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
 <20131007083505.GA22585@localhost>
 <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
 <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
 <20131008020918.GA1220@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008020918.GA1220@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 10:09:18AM +0800, Fengguang Wu wrote:
> On Mon, Oct 07, 2013 at 04:47:29PM -0700, Linus Torvalds wrote:
> > On Mon, Oct 7, 2013 at 3:14 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > I *think* r14 contains the function we're going to jump to in the
> > > oops, and that could be interesting to know, but it's not decoded, so
> > > you'd have to match it up against a symbol map...
> > 
> > Actually, Fenguguan, never mind. Instead, change the "pr_debug()" in
> > kobject_release() to  "pr_alert()", so that it gets printed out. Or
> > just boot with the "ignore_loglevel" thing so that debug messages are
> > actually visible.
> > 
> > At that point, we should be able to match the oops workqueue list
> > address with the address of the delayed kernel object that gets
> > printed out.
> 
> Thanks for the hints! I run a kernel with pr_alert() for several times
> and here is the screen log. Note that this kernel is compiled with gcc
> 4.6.3 and the decoded code looks different than gcc 4.8.1

I got a call trace containing parport_pc_probe_port() (is it the
culprit?) after recompiling kernel with

CONFIG_DEBUG_OBJECTS_TIMERS=y

and booting with "ignore_loglevel". Here is the log for two kernel boots.

wfg@bee ~/linux/obj-compiletest% kvm-0day.sh arch/x86/boot/bzImage
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc2-00010-gc817a67-dirty (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #6 SMP PREEMPT Tue Oct 8 10:03:08 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug ignore_loglevel apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f1840-0x000f184f] mapped at [ffff8800000f1840]
[    0.000000]   mpc: f1850-f193c
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x028a8000, 0x028a8fff] PGTABLE
[    0.000000] BRK [0x028a9000, 0x028a9fff] PGTABLE
[    0.000000] BRK [0x028aa000, 0x028aafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x028ab000, 0x028abfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x028ac000, 0x028acfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128348(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000f16b0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe3f0 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe430 01137 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff6a0 00899 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff5b0 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff570 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:e896001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5ba000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88000dc00000 s77904 r0 d24496 u1048576
[    0.000000] pcpu-alloc: s77904 r0 d24496 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] kvm-clock: cpu 0, msr 0:e896001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dc0ccc0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64391
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug ignore_loglevel apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 199064K/261744K available (8558K kernel code, 1784K rwdata, 3968K rodata, 844K init, 10064K bss, 62680K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000]  Additional per-CPU info printed with stalls.
[    0.000000]  RCU restricting CPUs from NR_CPUS=4096 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:262400 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=10774032)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008316] Mount-cache hash table entries: 256
[    0.009826] Initializing cgroup subsys devices
[    0.011770] Initializing cgroup subsys perf_event
[    0.012031] Initializing cgroup subsys net_prio
[    0.016209] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.016209] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.016209] tlb_flushall_shift: 6
[    0.020050] debug: unmapping init [mem 0xffffffff81ed0000-0xffffffff81ed3fff]
[    0.028645] ACPI: Core revision 20130517
[    0.034170] ACPI: All ACPI Tables successfully acquired
[    0.036460] Getting VERSION: 50014
[    0.040024] Getting VERSION: 50014
[    0.042141] Getting ID: 0
[    0.044026] Getting ID: ff000000
[    0.046033] Getting LVT0: 8700
[    0.048023] Getting LVT1: 8400
[    0.051332] enabled ExtINT on CPU#0
[    0.056011] ENABLING IO-APIC IRQs
[    0.058172] init IO_APIC IRQs
[    0.060014]  apic 0 pin 0 not connected
[    0.062460] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.064084] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.068068] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.072062] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.076058] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.080057] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.084053] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.088060] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.092067] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.096071] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.100066] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.104066] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.108061] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.112060] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.116064] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.120051]  apic 0 pin 16 not connected
[    0.122546]  apic 0 pin 17 not connected
[    0.124014]  apic 0 pin 18 not connected
[    0.128010]  apic 0 pin 19 not connected
[    0.130547]  apic 0 pin 20 not connected
[    0.132015]  apic 0 pin 21 not connected
[    0.136015]  apic 0 pin 22 not connected
[    0.138473]  apic 0 pin 23 not connected
[    0.140193] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.144011] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.152013] Using local APIC timer interrupts.
[    0.152013] calibrating APIC timer ...
[    0.160000] ... lapic delta = 6250138
[    0.160000] ... PM-Timer delta = 357965
[    0.160000] ... PM-Timer result ok
[    0.160000] ..... delta 6250138
[    0.160000] ..... mult: 268441383
[    0.160000] ..... calibration result: 4000088
[    0.160000] ..... CPU clock speed is 2693.2050 MHz.
[    0.160000] ..... host bus clock speed is 1000.0088 MHz.
[    0.160123] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.188704] SMP alternatives: lockdep: fixing up alternatives
[    0.190001] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:e896041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.212067] KVM setup async PF for cpu 1
[    0.212180] Brought up 2 CPUs
[    0.212180] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.215718] kvm-stealtime: cpu 1, msr dd0ccc0
[    0.220087] devtmpfs: initialized
[    0.224150] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.228706] regulator-dummy: no parameters
[    0.232321] NET: Registered protocol family 16
[    0.236568] ACPI: bus type PCI registered
[    0.239182] PCI: Using configuration type 1 for base access
[    0.252982] ACPI: Added _OSI(Module Device)
[    0.253830] ACPI: Added _OSI(Processor Device)
[    0.254687] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.256009] ACPI: Added _OSI(Processor Aggregator Device)
[    0.259290] ACPI: EC: Look up EC in DSDT
[    0.267251] ACPI: Interpreter enabled
[    0.268037] ACPI: (supports S0 S5)
[    0.270165] ACPI: Using IOAPIC for interrupt routing
[    0.272080] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.296528] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.300629] PCI host bridge to bus 0000:00
[    0.303206] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.304021] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.308015] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.312014] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.316019] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.320144] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.330282] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.336522] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.343635] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.349660] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.352693] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.356053] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.364392] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.368954] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.373885] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.388932] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.391120] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.393333] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.396014] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.403236] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.404775] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.409382] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.413072] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.420019] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.422323] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.424767] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.431725] pci_bus 0000:00: on NUMA node 0
[    0.432051] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.434279] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.437989] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.440889] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.444521] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.446505] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.448519] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.451322] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.452030] ACPI: \_SB_.PCI0: notify handler is installed
[    0.453629] Found 1 acpi root devices
[    0.460206] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.462748] vgaarb: loaded
[    0.463598] vgaarb: bridge control possible 0000:00:02.0
[    0.464738] ACPI: bus type USB registered
[    0.468121] usbcore: registered new interface driver usbfs
[    0.469647] usbcore: registered new interface driver hub
[    0.471265] usbcore: registered new device driver usb
[    0.472212] pps_core: LinuxPPS API ver. 1 registered
[    0.473534] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.476081] PTP clock support registered
[    0.477702] wmi: Mapper loaded
[    0.480107] PCI: Using ACPI for IRQ routing
[    0.481325] PCI: pci_cache_line_size set to 64 bytes
[    0.484253] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.486020] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.489029] NET: Registered protocol family 23
[    0.491080] cfg80211: Calling CRDA to update world regulatory domain
[    0.492239] nfc: nfc_init: NFC Core ver 0.1
[    0.492970] NET: Registered protocol family 39
[    0.492970] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.496209] Switched to clocksource kvm-clock
[    0.497223] pnp: PnP ACPI init
[    0.497760] ACPI: bus type PNP registered
[    0.498392] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.499849] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.501522] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.503951] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.505628] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.507607] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.509257] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.511096] pnp 00:03: [dma 2]
[    0.511925] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.513484] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.515459] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.517213] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.519323] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.521341] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.523041] pnp: PnP ACPI: found 7 devices
[    0.524391] ACPI: bus type PNP unregistered
[    0.531387] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.532754] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.534044] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.535403] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.537269] NET: Registered protocol family 2
[    0.539173] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    0.541005] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.542866] TCP: Hash tables configured (established 2048 bind 2048)
[    0.544564] TCP: reno registered
[    0.545345] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.546777] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.548877] NET: Registered protocol family 1
[    0.550645] RPC: Registered named UNIX socket transport module.
[    0.552194] RPC: Registered udp transport module.
[    0.553364] RPC: Registered tcp transport module.
[    0.554508] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.555980] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.557353] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.558710] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.560224] pci 0000:00:02.0: Boot video device
[    0.561269] PCI: CLS 0 bytes, default 64
[    0.562457] Unpacking initramfs...
[    2.516338] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    2.517945] has_svm: not amd
[    2.518311] kvm: no hardware support
[    2.519408] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    2.521140] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    2.526872] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    2.528631] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.528719] cryptomgr_test (24) used greatest stack depth: 6320 bytes left
[    2.531042] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.532304] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.533567] AVX or AES-NI instructions are not detected.
[    2.534412] AVX instructions are not detected.
[    2.535210] AVX instructions are not detected.
[    2.536056] AVX instructions are not detected.
[    2.544063] Initializing RT-Tester: OK
[    2.544692] audit: initializing netlink socket (disabled)
[    2.545582] type=2000 audit(1378709047.986:1): initialized
[    2.549906] DLM installed
[    2.551558] NFS: Registering the id_resolver key type
[    2.555756] Key type id_resolver registered
[    2.556647] Key type id_legacy registered
[    2.557466] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.559284] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.560321] fuse init (API version 7.22)
[    2.561738] ceph: loaded (mds proto 32)
[    2.564411] cryptomgr_test (43) used greatest stack depth: 5696 bytes left
[    2.575692] cryptomgr_test (72) used greatest stack depth: 5280 bytes left
[    2.581083] alg: No test for crc32 (crc32-table)
[    2.582949] alg: No test for lz4hc (lz4hc-generic)
[    2.599837] alg: No test for stdrng (krng)
[    2.602824] NET: Registered protocol family 38
[    2.604069] Key type asymmetric registered
[    2.605178] Asymmetric key parser 'x509' registered
[    2.606504] test_string_helpers: Running tests...
[    2.608629] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    2.610014] crc32: self tests passed, processed 225944 bytes in 308809 nsec
[    2.612005] crc32c: CRC_LE_BITS = 32
[    2.612967] crc32c: self tests passed, processed 225944 bytes in 154301 nsec
[    2.615586] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    2.617128] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    2.619201] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    2.621099] vmlfb: initializing
[    2.621922] Could not find Carillo Ranch MCH device.
[    2.623237] no IO addresses supplied
[    2.624404] hgafb: HGA card not detected.
[    2.625428] hgafb: probe of hgafb.0 failed with error -22
[    2.626842] usbcore: registered new interface driver udlfb
[    2.628264] usbcore: registered new interface driver smscufx
[    2.630814] uvesafb: failed to execute /sbin/v86d
[    2.632062] uvesafb: make sure that the v86d helper is installed and executable
[    2.633855] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    2.635660] uvesafb: vbe_init() failed with -22
[    2.636981] uvesafb: probe of uvesafb.0 failed with error -22
[    2.638761] ipmi message handler version 39.2
[    2.639819] ipmi device interface
[    2.640815] IPMI System Interface driver.
[    2.641928] ipmi_si: Adding default-specified kcs state machine
[    2.643342] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    2.645947] ipmi_si: Interface detection failed
[    2.660232] ipmi_si: Adding default-specified smic state machine
[    2.661575] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    2.663578] ipmi_si: Interface detection failed
[    2.676160] ipmi_si: Adding default-specified bt state machine
[    2.677266] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    2.678956] ipmi_si: Interface detection failed
[    2.688369] kobject: 'ipmi_si' (ffff8800077ac600): kobject_release, parent ffff8800001b7648 (delayed)
[    2.690070] kobject: 'ipmi_si' (ffff8800077ac400): kobject_release, parent ffff880000221248 (delayed)
[    2.691569] kobject: 'ipmi_si' (ffff8800077ac800): kobject_release, parent ffff880000189248 (delayed)
[    2.693069] ipmi_si: Unable to find any System Interface(s)
[    2.694381] IPMI Watchdog: driver initialized
[    2.695402] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    2.697710] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.700067] ACPI: Power Button [PWRF]
[    2.748211] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.772998] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.776086] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    2.777783] ac.o: No PCI boards found.
[    2.778746] ac.o: For an ISA board you must supply memory and irq parameters.
[    2.780870] Non-volatile memory driver v1.3
[    2.782013] Linux agpgart interface v0.103
[    2.783638] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    2.785188] kobject: 'drm' (ffff880006dae048): kobject_release, parent ffff880000189648 (delayed)
[    2.787362] kobject: 'drm' (ffff880006dafe00): kobject_release, parent           (null) (delayed)
[    2.789674] [drm] radeon kernel modesetting enabled.
[    2.791798] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
[    2.793280] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/dri.
[    2.795591] kobject: 'controlD64' (ffff880006dc3820): kobject_release, parent           (null) (delayed)
[    2.797988] cirrus: probe of 0000:00:02.0 failed with error -1
[    2.799675] usbcore: registered new interface driver udl
[    2.802167] parport_pc 00:04: reported by Plug and Play ACPI
[    2.803818] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    2.806035] kobject: 'parport_pc.956' (ffff880006dc3820): kobject_release, parent           (null) (delayed)
[    2.808626] ------------[ cut here ]------------
[    2.809776] WARNING: CPU: 1 PID: 1 at /c/wfg/linux/lib/debugobjects.c:260 debug_print_object+0x7c/0x8d()
[    2.812433] ODEBUG: init active (active state 0) object type: timer_list hint:           (null)
[    2.812579] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc2-00010-gc817a67-dirty #6
[    2.812579]  0000000000000104 ffff88000010db78 ffffffff8184ea6e 0000000000000000
[    2.812579]  ffff88000010dbc8 ffff88000010dbb8 ffffffff8108f38d 0000000000000046
[    2.812579]  ffffffff81223681 ffffffff81c20277 ffff880006d92ee8 ffffffff81c602d0
[    2.812579] Call Trace:
[    2.812579]  [<ffffffff8184ea6e>] dump_stack+0x4f/0x84
[    2.812579]  [<ffffffff8108f38d>] warn_slowpath_common+0x72/0x8c
[    2.812579]  [<ffffffff81223681>] ? debug_print_object+0x7c/0x8d
[    2.812579]  [<ffffffff8108f40b>] warn_slowpath_fmt+0x41/0x43
[    2.812579]  [<ffffffff81223681>] debug_print_object+0x7c/0x8d
[    2.812579]  [<ffffffff812239e0>] __debug_object_init+0x27c/0x2c6
[    2.812579]  [<ffffffff81223a1b>] ? __debug_object_init+0x2b7/0x2c6
[    2.812579]  [<ffffffff81223a3e>] debug_object_init+0x14/0x16
[    2.812579]  [<ffffffff810992e8>] init_timer_key+0x23/0x65
[    2.812579]  [<ffffffff8121352f>] kobject_release+0x90/0xba
[    2.812579]  [<ffffffff812137ac>] kobject_put+0x4d/0x51
[    2.812579]  [<ffffffff81482cfb>] put_device+0x12/0x14
[    2.812579]  [<ffffffff814873a2>] platform_device_put+0x12/0x14
[    2.812579]  [<ffffffff81487727>] platform_device_unregister+0x16/0x1a
[    2.812579]  [<ffffffff814810f9>] parport_pc_probe_port+0x7c4/0x7d9
[    2.812579]  [<ffffffff81e36c75>] parport_pc_init+0x2b0/0x317
[    2.812579]  [<ffffffff81e369c5>] ? parport_setup+0x147/0x147
[    2.812579]  [<ffffffff81e11e0c>] do_one_initcall+0x8e/0x132
[    2.812579]  [<ffffffff810a7000>] ? param_array_set+0x7f/0xf2
[    2.812579]  [<ffffffff810a7275>] ? parse_args+0x1ad/0x26c
[    2.812579]  [<ffffffff81e11fe2>] kernel_init_freeable+0x132/0x1bc
[    2.812579]  [<ffffffff81e116e3>] ? do_early_param+0x86/0x86
[    2.812579]  [<ffffffff818488bf>] ? rest_init+0xc3/0xc3
[    2.812579]  [<ffffffff818488c8>] kernel_init+0x9/0xcc
[    2.812579]  [<ffffffff81859e3c>] ret_from_fork+0x7c/0xb0
[    2.812579]  [<ffffffff818488bf>] ? rest_init+0xc3/0xc3
[    2.812579] ---[ end trace ce7dd707bef7dc3e ]---
[    2.863098] INFO: trying to register non-static key.
[    2.864466] the code is fine but needs lockdep annotation.
[    2.865862] turning off the locking correctness validator.
[    2.867041] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.11.0-rc2-00010-gc817a67-dirty #6
[    2.867041]  0000000000000000 ffff88000010da28 ffffffff8184ea6e 0000000000000000
[    2.867041]  0000000000000000 ffff88000010daa8 ffffffff810c5e5a ffff88000010da88
[    2.867041]  ffffffff810907e4 0000000000007a4c 0000000000000046 ffff88000010da78
[    2.867041] Call Trace:
[    2.867041]  [<ffffffff8184ea6e>] dump_stack+0x4f/0x84
[    2.867041]  [<ffffffff810c5e5a>] register_lock_class+0x104/0x2d8
[    2.867041]  [<ffffffff810907e4>] ? console_unlock+0x35b/0x36a
[    2.867041]  [<ffffffff810c744b>] ? trace_hardirqs_off_caller+0x33/0xa0
[    2.867041]  [<ffffffff810c813b>] __lock_acquire+0xf6/0xe51
[    2.867041]  [<ffffffff81859677>] ? retint_restore_args+0x13/0x13
[    2.867041]  [<ffffffff810c73d2>] ? trace_hardirqs_on_caller+0x154/0x18b
[    2.867041]  [<ffffffff810c92bf>] lock_acquire+0x7e/0x99
[    2.867041]  [<ffffffff8109962b>] ? try_to_del_timer_sync+0x5f/0x5f
[    2.867041]  [<ffffffff81099674>] del_timer_sync+0x49/0xcb
[    2.867041]  [<ffffffff8109962b>] ? try_to_del_timer_sync+0x5f/0x5f
[    2.867041]  [<ffffffff810cde75>] ? arch_local_irq_restore+0x6/0xd
[    2.867041]  [<ffffffff8109973a>] timer_fixup_init+0x16/0x2f
[    2.867041]  [<ffffffff812234ba>] debug_object_fixup+0x15/0x1d
[    2.867041]  [<ffffffff812239ff>] __debug_object_init+0x29b/0x2c6
[    2.867041]  [<ffffffff81223a1b>] ? __debug_object_init+0x2b7/0x2c6
[    2.867041]  [<ffffffff81223a3e>] debug_object_init+0x14/0x16
[    2.867041]  [<ffffffff810992e8>] init_timer_key+0x23/0x65
[    2.867041]  [<ffffffff8121352f>] kobject_release+0x90/0xba
[    2.867041]  [<ffffffff812137ac>] kobject_put+0x4d/0x51
[    2.867041]  [<ffffffff81482cfb>] put_device+0x12/0x14
[    2.867041]  [<ffffffff814873a2>] platform_device_put+0x12/0x14
[    2.867041]  [<ffffffff81487727>] platform_device_unregister+0x16/0x1a
[    2.867041]  [<ffffffff814810f9>] parport_pc_probe_port+0x7c4/0x7d9
[    2.867041]  [<ffffffff81e36c75>] parport_pc_init+0x2b0/0x317
[    2.867041]  [<ffffffff81e369c5>] ? parport_setup+0x147/0x147
[    2.867041]  [<ffffffff81e11e0c>] do_one_initcall+0x8e/0x132
[    2.867041]  [<ffffffff810a7000>] ? param_array_set+0x7f/0xf2
[    2.867041]  [<ffffffff810a7275>] ? parse_args+0x1ad/0x26c
[    2.867041]  [<ffffffff81e11fe2>] kernel_init_freeable+0x132/0x1bc
[    2.867041]  [<ffffffff81e116e3>] ? do_early_param+0x86/0x86
[    2.867041]  [<ffffffff818488bf>] ? rest_init+0xc3/0xc3
[    2.867041]  [<ffffffff818488c8>] kernel_init+0x9/0xcc
[    2.867041]  [<ffffffff81859e3c>] ret_from_fork+0x7c/0xb0
[    2.867041]  [<ffffffff818488bf>] ? rest_init+0xc3/0xc3
[    3.516155] tsc: Refined TSC clocksource calibration: 2693.463 MHz
[    3.796079] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    3.798252] IP: [<          (null)>]           (null)
[    3.799447] PGD 0
[    3.799956] Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    3.800042] CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    3.11.0-rc2-00010-gc817a67-dirty #6
[    3.800042] task: ffff88000010a040 ti: ffff88000010c000 task.ti: ffff88000010c000
[    3.800042] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[    3.800042] RSP: 0000:ffff88000dd03e40  EFLAGS: 00010286
[    3.800042] RAX: 0000000000000000 RBX: 0000000000000100 RCX: 0000000000000000
[    3.800042] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[    3.800042] RBP: ffff88000dd03e98 R08: 0000000000000002 R09: 0000000000000000
[    3.800042] R10: ffff88000dd03e58 R11: ffff88000015c000 R12: ffff88000010dfd8
[    3.800042] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88000015d058
[    3.800042] FS:  0000000000000000(0000) GS:ffff88000dd00000(0000) knlGS:0000000000000000
[    3.800042] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.800042] CR2: 0000000000000000 CR3: 0000000001c47000 CR4: 00000000000006a0
[    3.800042] Stack:
[    3.800042]  ffffffff810989e6 ffffffff8109897b ffff88000015c000 ffff880006dc38d8
[    3.800042]  0000000000000000 0000000000000000 0000000000000000 ffff88000015c000
[    3.800042]  ffff88000dd03ec8 ffff88000015d858 ffff88000015d458 ffff88000dd03f08
[    3.800042] Call Trace:
[    3.800042]  <IRQ>
[    3.800042]  [<ffffffff810989e6>] ? call_timer_fn+0x6b/0xde
[    3.800042]  [<ffffffff8109897b>] ? detach_timer+0x46/0x46
[    3.800042]  [<ffffffff81098fcb>] run_timer_softirq+0x187/0x1cf
[    3.800042]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
[    3.800042]  [<ffffffff81095745>] irq_exit+0x58/0x9e
[    3.800042]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
[    3.800042]  [<ffffffff8185ab72>] apic_timer_interrupt+0x72/0x80
[    3.800042]  <EOI>
[    3.800042]  [<ffffffff81859677>] ? retint_restore_args+0x13/0x13
[    3.800042]  [<ffffffff810990a2>] ? lock_timer_base.isra.17+0x49/0x4b
[    3.800042]  [<ffffffff810995f3>] try_to_del_timer_sync+0x27/0x5f
[    3.800042]  [<ffffffff81098801>] ? arch_local_irq_restore+0x6/0xd
[    3.800042]  [<ffffffff810996e3>] del_timer_sync+0xb8/0xcb
[    3.800042]  [<ffffffff8109962b>] ? try_to_del_timer_sync+0x5f/0x5f
[    3.800042]  [<ffffffff810cde75>] ? arch_local_irq_restore+0x6/0xd
[    3.800042]  [<ffffffff8109973a>] timer_fixup_init+0x16/0x2f
[    3.800042]  [<ffffffff812234ba>] debug_object_fixup+0x15/0x1d
[    3.800042]  [<ffffffff812239ff>] __debug_object_init+0x29b/0x2c6
[    3.800042]  [<ffffffff81223a1b>] ? __debug_object_init+0x2b7/0x2c6
[    3.800042]  [<ffffffff81223a3e>] debug_object_init+0x14/0x16
[    3.800042]  [<ffffffff810992e8>] init_timer_key+0x23/0x65
[    3.800042]  [<ffffffff8121352f>] kobject_release+0x90/0xba
[    3.800042]  [<ffffffff812137ac>] kobject_put+0x4d/0x51
[    3.800042]  [<ffffffff81482cfb>] put_device+0x12/0x14
[    3.800042]  [<ffffffff814873a2>] platform_device_put+0x12/0x14
[    3.800042]  [<ffffffff81487727>] platform_device_unregister+0x16/0x1a
[    3.800042]  [<ffffffff814810f9>] parport_pc_probe_port+0x7c4/0x7d9
[    3.800042]  [<ffffffff81e36c75>] parport_pc_init+0x2b0/0x317
[    3.800042]  [<ffffffff81e369c5>] ? parport_setup+0x147/0x147
[    3.800042]  [<ffffffff81e11e0c>] do_one_initcall+0x8e/0x132
[    3.800042]  [<ffffffff810a7000>] ? param_array_set+0x7f/0xf2
[    3.800042]  [<ffffffff810a7275>] ? parse_args+0x1ad/0x26c
[    3.800042]  [<ffffffff81e11fe2>] kernel_init_freeable+0x132/0x1bc
[    3.800042]  [<ffffffff81e116e3>] ? do_early_param+0x86/0x86
[    3.800042]  [<ffffffff818488bf>] ? rest_init+0xc3/0xc3
[    3.800042]  [<ffffffff818488c8>] kernel_init+0x9/0xcc
[    3.800042]  [<ffffffff81859e3c>] ret_from_fork+0x7c/0xb0
[    3.800042]  [<ffffffff818488bf>] ? rest_init+0xc3/0xc3
[    3.800042] Code:  Bad RIP value.
[    3.800042] RIP  [<          (null)>]           (null)
[    3.800042]  RSP <ffff88000dd03e40>
[    3.800042] CR2: 0000000000000000
[    3.940037] ---[ end trace ce7dd707bef7dc3f ]---
[    3.941218] Kernel panic - not syncing: Fatal exception in interrupt
[    3.943251] Rebooting in 10 seconds..%                                                                                                  wfg@bee ~/linux/obj-compiletest%
wfg@bee ~/linux/obj-compiletest% kvm-0day.sh arch/x86/boot/bzImage
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc2-00010-gc817a67-dirty (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #6 SMP PREEMPT Tue Oct 8 10:03:08 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug ignore_loglevel apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f1840-0x000f184f] mapped at [ffff8800000f1840]
[    0.000000]   mpc: f1850-f193c
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x028a8000, 0x028a8fff] PGTABLE
[    0.000000] BRK [0x028a9000, 0x028a9fff] PGTABLE
[    0.000000] BRK [0x028aa000, 0x028aafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x028ab000, 0x028abfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x028ac000, 0x028acfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128348(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000f16b0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe3f0 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe430 01137 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffff6a0 00899 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffff5b0 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffff570 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:e896001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00001000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 21 pages reserved
[    0.000000]   DMA32 zone: 65436 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5bb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5ba000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:4096 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88000dc00000 s77904 r0 d24496 u1048576
[    0.000000] pcpu-alloc: s77904 r0 d24496 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] kvm-clock: cpu 0, msr 0:e896001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dc0ccc0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64391
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug ignore_loglevel apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 199064K/261744K available (8558K kernel code, 1784K rwdata, 3968K rodata, 844K init, 10064K bss, 62680K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000]  Additional per-CPU info printed with stalls.
[    0.000000]  RCU restricting CPUs from NR_CPUS=4096 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:262400 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=10774032)
[    0.008014] pid_max: default: 32768 minimum: 301
[    0.009283] Mount-cache hash table entries: 256
[    0.012065] Initializing cgroup subsys devices
[    0.013312] Initializing cgroup subsys perf_event
[    0.014562] Initializing cgroup subsys net_prio
[    0.015855] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.015855] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.015855] tlb_flushall_shift: 6
[    0.016052] debug: unmapping init [mem 0xffffffff81ed0000-0xffffffff81ed3fff]
[    0.020896] ACPI: Core revision 20130517
[    0.024485] ACPI: All ACPI Tables successfully acquired
[    0.025852] Getting VERSION: 50014
[    0.026522] Getting VERSION: 50014
[    0.027164] Getting ID: 0
[    0.027658] Getting ID: ff000000
[    0.028029] Getting LVT0: 8700
[    0.028865] Getting LVT1: 8400
[    0.029725] enabled ExtINT on CPU#0
[    0.032835] ENABLING IO-APIC IRQs
[    0.035067] init IO_APIC IRQs
[    0.036026]  apic 0 pin 0 not connected
[    0.040061] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.041439] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.044075] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.046150] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.048056] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.052053] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.053431] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.056044] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.058534] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.060059] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.062489] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.064058] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.068046] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.070212] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.072067] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.076042]  apic 0 pin 16 not connected
[    0.077071]  apic 0 pin 17 not connected
[    0.078192]  apic 0 pin 18 not connected
[    0.080016]  apic 0 pin 19 not connected
[    0.081411]  apic 0 pin 20 not connected
[    0.082403]  apic 0 pin 21 not connected
[    0.083447]  apic 0 pin 22 not connected
[    0.084018]  apic 0 pin 23 not connected
[    0.085207] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.088019] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.090632] Using local APIC timer interrupts.
[    0.090632] calibrating APIC timer ...
[    0.096000] ... lapic delta = 6252850
[    0.096000] ... PM-Timer delta = 358097
[    0.096000] ... PM-Timer result ok
[    0.096000] ..... delta 6252850
[    0.096000] ..... mult: 268557862
[    0.096000] ..... calibration result: 4001824
[    0.096000] ..... CPU clock speed is 2694.2010 MHz.
[    0.096000] ..... host bus clock speed is 1000.1824 MHz.
[    0.096124] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.124680] SMP alternatives: lockdep: fixing up alternatives
[    0.125979] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:e896041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.144326] Brought up 2 CPUs
[    0.148010] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.148030] KVM setup async PF for cpu 1
[    0.149476] kvm-stealtime: cpu 1, msr dd0ccc0
[    0.156081] devtmpfs: initialized
[    0.158681] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.160566] regulator-dummy: no parameters
[    0.164009] NET: Registered protocol family 16
[    0.167013] ACPI: bus type PCI registered
[    0.168090] PCI: Using configuration type 1 for base access
[    0.184154] ACPI: Added _OSI(Module Device)
[    0.188010] ACPI: Added _OSI(Processor Device)
[    0.189135] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.190322] ACPI: Added _OSI(Processor Aggregator Device)
[    0.198032] ACPI: EC: Look up EC in DSDT
[    0.204857] ACPI: Interpreter enabled
[    0.205961] ACPI: (supports S0 S5)
[    0.206844] ACPI: Using IOAPIC for interrupt routing
[    0.208085] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.226725] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.228521] PCI host bridge to bus 0000:00
[    0.229731] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.231040] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.232015] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.233723] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.236025] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.237867] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.240716] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.242911] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.247373] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.252962] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.255051] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.256044] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.260534] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.269902] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.280846] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.294951] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.296944] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.301342] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.304014] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.312017] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.314493] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.318666] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.324016] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.334321] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.340512] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.344793] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.354855] pci_bus 0000:00: on NUMA node 0
[    0.356060] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.358553] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.361801] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.364806] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.368089] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.370283] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.372133] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.374863] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.376030] ACPI: \_SB_.PCI0: notify handler is installed
[    0.377608] Found 1 acpi root devices
[    0.381053] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.382144] vgaarb: loaded
[    0.384009] vgaarb: bridge control possible 0000:00:02.0
[    0.385779] ACPI: bus type USB registered
[    0.388109] usbcore: registered new interface driver usbfs
[    0.389486] usbcore: registered new interface driver hub
[    0.390974] usbcore: registered new device driver usb
[    0.392204] pps_core: LinuxPPS API ver. 1 registered
[    0.393152] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.394913] PTP clock support registered
[    0.396412] wmi: Mapper loaded
[    0.397318] PCI: Using ACPI for IRQ routing
[    0.398279] PCI: pci_cache_line_size set to 64 bytes
[    0.399380] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.400032] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.402853] NET: Registered protocol family 23
[    0.405468] cfg80211: Calling CRDA to update world regulatory domain
[    0.408532] nfc: nfc_init: NFC Core ver 0.1
[    0.409575] NET: Registered protocol family 39
[    0.412580] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.420103] Switched to clocksource kvm-clock
[    0.421942] pnp: PnP ACPI init
[    0.422815] ACPI: bus type PNP registered
[    0.424055] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.426218] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.427982] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.430940] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.433470] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.435710] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.437450] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.439696] pnp 00:03: [dma 2]
[    0.440658] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.442422] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.445911] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.447617] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.449862] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.452297] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.455436] pnp: PnP ACPI: found 7 devices
[    0.457339] ACPI: bus type PNP unregistered
[    0.465411] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.466801] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.470348] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.475305] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.479840] NET: Registered protocol family 2
[    0.482036] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    0.486547] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.492225] TCP: Hash tables configured (established 2048 bind 2048)
[    0.494850] TCP: reno registered
[    0.497568] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.502215] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.509049] NET: Registered protocol family 1
[    0.520899] RPC: Registered named UNIX socket transport module.
[    0.524920] RPC: Registered udp transport module.
[    0.527946] RPC: Registered tcp transport module.
[    0.530970] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.535125] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.539003] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.542927] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.544932] pci 0000:00:02.0: Boot video device
[    0.546059] PCI: CLS 0 bytes, default 64
[    0.547393] Unpacking initramfs...
[    2.413896] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    2.417719] has_svm: not amd
[    2.418473] kvm: no hardware support
[    2.419790] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    2.423888] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    2.430234] cryptomgr_test (24) used greatest stack depth: 6224 bytes left
[    2.430241] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    2.430251] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.430253] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.430254] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.430255] AVX or AES-NI instructions are not detected.
[    2.430256] AVX instructions are not detected.
[    2.430270] AVX instructions are not detected.
[    2.430272] AVX instructions are not detected.
[    2.461428] Initializing RT-Tester: OK
[    2.462139] audit: initializing netlink socket (disabled)
[    2.463243] type=2000 audit(1378709048.086:1): initialized
[    2.473933] DLM installed
[    2.477193] NFS: Registering the id_resolver key type
[    2.479252] Key type id_resolver registered
[    2.480479] Key type id_legacy registered
[    2.481501] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.484505] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.486279] fuse init (API version 7.22)
[    2.488216] ceph: loaded (mds proto 32)
[    2.504162] cryptomgr_test (43) used greatest stack depth: 5768 bytes left
[    2.526085] cryptomgr_test (72) used greatest stack depth: 5352 bytes left
[    2.530361] alg: No test for crc32 (crc32-table)
[    2.532132] cryptomgr_test (80) used greatest stack depth: 5008 bytes left
[    2.532528] alg: No test for lz4hc (lz4hc-generic)
[    2.532639] alg: No test for stdrng (krng)
[    2.532890] NET: Registered protocol family 38
[    2.532938] Key type asymmetric registered
[    2.532958] Asymmetric key parser 'x509' registered
[    2.532960] test_string_helpers: Running tests...
[    2.538602] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    2.540168] crc32: self tests passed, processed 225944 bytes in 304358 nsec
[    2.542213] crc32c: CRC_LE_BITS = 32
[    2.543439] crc32c: self tests passed, processed 225944 bytes in 151613 nsec
[    2.546191] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    2.547546] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    2.549529] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    2.551331] vmlfb: initializing
[    2.552321] Could not find Carillo Ranch MCH device.
[    2.554636] no IO addresses supplied
[    2.556542] hgafb: HGA card not detected.
[    2.557567] hgafb: probe of hgafb.0 failed with error -22
[    2.558920] usbcore: registered new interface driver udlfb
[    2.560837] usbcore: registered new interface driver smscufx
[    2.563345] uvesafb: failed to execute /sbin/v86d
[    2.564360] uvesafb: make sure that the v86d helper is installed and executable
[    2.565725] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    2.566873] uvesafb: vbe_init() failed with -22
[    2.567710] uvesafb: probe of uvesafb.0 failed with error -22
[    2.568814] ipmi message handler version 39.2
[    2.569560] ipmi device interface
[    2.570275] IPMI System Interface driver.
[    2.571082] ipmi_si: Adding default-specified kcs state machine
[    2.572494] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    2.574876] ipmi_si: Interface detection failed
[    2.584184] ipmi_si: Adding default-specified smic state machine
[    2.585201] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    2.586643] ipmi_si: Interface detection failed
[    2.596475] ipmi_si: Adding default-specified bt state machine
[    2.597615] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    2.599306] ipmi_si: Interface detection failed
[    2.612491] kobject: 'ipmi_si' (ffff8800077a7c00): kobject_release, parent ffff8800001b7648 (delayed)
[    2.614180] kobject: 'ipmi_si' (ffff8800077a7a00): kobject_release, parent ffff880000221248 (delayed)
[    2.615854] kobject: 'ipmi_si' (ffff8800077a7e00): kobject_release, parent ffff880000189248 (delayed)
[    2.618018] ipmi_si: Unable to find any System Interface(s)
[    2.621129] IPMI Watchdog: driver initialized
[    2.623943] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    2.629342] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.634175] ACPI: Power Button [PWRF]
[    2.729623] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.757438] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.762864] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    2.768339] ac.o: No PCI boards found.
[    2.771569] ac.o: For an ISA board you must supply memory and irq parameters.
[    2.776227] Non-volatile memory driver v1.3
[    2.777300] Linux agpgart interface v0.103
[    2.779021] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    2.780618] kobject: 'drm' (ffff880006daf848): kobject_release, parent ffff880000189648 (delayed)
[    2.782833] kobject: 'drm' (ffff880006dad400): kobject_release, parent           (null) (delayed)
[    2.785596] [drm] radeon kernel modesetting enabled.
[    2.787831] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
[    2.789363] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/dri.
[    2.791917] kobject: 'controlD64' (ffff880006daf020): kobject_release, parent           (null) (delayed)
[    2.794702] cirrus: probe of 0000:00:02.0 failed with error -1
[    2.800244] usbcore: registered new interface driver udl
[    2.802802] parport_pc 00:04: reported by Plug and Play ACPI
[    2.806445] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    2.809299] kobject: 'parport_pc.956' (ffff880006daf020): kobject_release, parent           (null) (delayed)
[    2.815944] ------------[ cut here ]------------
[    2.818957] WARNING: CPU: 0 PID: 1 at /c/wfg/linux/lib/debugobjects.c:260 debug_print_object+0x7c/0x8d()
[    2.819887] ODEBUG: init active (active state 0) object type: timer_list hint:           (null)
[    2.819887] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc2-00010-gc817a67-dirty #6
[    2.819887]  0000000000000104 ffff88000010db78 ffffffff8184ea6e 0000000000000000
[    2.819887]  ffff88000010dbc8 ffff88000010dbb8 ffffffff8108f38d 0000000000000046
[    2.819887]  ffffffff81223681 ffffffff81c20277 ffff880006db17b8 ffffffff81c602d0
[    2.819887] Call Trace:
[    2.819887]  [<ffffffff8184ea6e>] dump_stack+0x4f/0x84
[    2.819887]  [<ffffffff8108f38d>] warn_slowpath_common+0x72/0x8c
[    2.819887]  [<ffffffff81223681>] ? debug_print_object+0x7c/0x8d
[    2.819887]  [<ffffffff8108f40b>] warn_slowpath_fmt+0x41/0x43
[    2.819887]  [<ffffffff81223681>] debug_print_object+0x7c/0x8d
[    2.819887]  [<ffffffff812239e0>] __debug_object_init+0x27c/0x2c6
[    2.819887]  [<ffffffff81223a1b>] ? __debug_object_init+0x2b7/0x2c6
[    2.819887]  [<ffffffff81223a3e>] debug_object_init+0x14/0x16
[    2.819887]  [<ffffffff810992e8>] init_timer_key+0x23/0x65
[    2.819887]  [<ffffffff8121352f>] kobject_release+0x90/0xba
[    2.819887]  [<ffffffff812137ac>] kobject_put+0x4d/0x51
[    2.819887]  [<ffffffff81482cfb>] put_device+0x12/0x14
[    2.819887]  [<ffffffff814873a2>] platform_device_put+0x12/0x14
[    2.819887]  [<ffffffff81487727>] platform_device_unregister+0x16/0x1a
[    2.819887]  [<ffffffff814810f9>] parport_pc_probe_port+0x7c4/0x7d9
[    2.819887]  [<ffffffff81e36c75>] parport_pc_init+0x2b0/0x317
[    2.819887]  [<ffffffff81e369c5>] ? parport_setup+0x147/0x147
[    2.819887]  [<ffffffff81e11e0c>] do_one_initcall+0x8e/0x132
[    2.819887]  [<ffffffff810a7000>] ? param_array_set+0x7f/0xf2
[    2.819887]  [<ffffffff810a7275>] ? parse_args+0x1ad/0x26c
[    2.819887]  [<ffffffff81e11fe2>] kernel_init_freeable+0x132/0x1bc
[    2.819887]  [<ffffffff81e116e3>] ? do_early_param+0x86/0x86
[    2.819887]  [<ffffffff818488bf>] ? rest_init+0xc3/0xc3
[    2.819887]  [<ffffffff818488c8>] kernel_init+0x9/0xcc
[    2.819887]  [<ffffffff81859e3c>] ret_from_fork+0x7c/0xb0
[    2.819887]  [<ffffffff818488bf>] ? rest_init+0xc3/0xc3
[    2.819887] ---[ end trace 2f14671be5565db5 ]---
[    2.894906] INFO: trying to register non-static key.
[    2.896172] the code is fine but needs lockdep annotation.
[    2.897687] turning off the locking correctness validator.
[    2.898870] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.11.0-rc2-00010-gc817a67-dirty #6
[    2.898870]  0000000000000000 ffff88000010da28 ffffffff8184ea6e 0000000000000000
[    2.898870]  0000000000000000 ffff88000010daa8 ffffffff810c5e5a ffff88000010da88
[    2.898870]  ffffffff810907e4 0000000000007a9c 0000000000000046 ffff88000010da78
[    2.898870] Call Trace:
[    2.898870]  [<ffffffff8184ea6e>] dump_stack+0x4f/0x84
[    2.898870]  [<ffffffff810c5e5a>] register_lock_class+0x104/0x2d8
[    2.898870]  [<ffffffff810907e4>] ? console_unlock+0x35b/0x36a
[    2.898870]  [<ffffffff810c744b>] ? trace_hardirqs_off_caller+0x33/0xa0
[    2.898870]  [<ffffffff810c813b>] __lock_acquire+0xf6/0xe51
[    2.898870]  [<ffffffff81859677>] ? retint_restore_args+0x13/0x13
[    2.898870]  [<ffffffff810c73d2>] ? trace_hardirqs_on_caller+0x154/0x18b
[    2.898870]  [<ffffffff810c92bf>] lock_acquire+0x7e/0x99
[    2.898870]  [<ffffffff8109962b>] ? try_to_del_timer_sync+0x5f/0x5f
[    2.898870]  [<ffffffff81099674>] del_timer_sync+0x49/0xcb
[    2.898870]  [<ffffffff8109962b>] ? try_to_del_timer_sync+0x5f/0x5f
[    2.898870]  [<ffffffff810cde75>] ? arch_local_irq_restore+0x6/0xd
[    2.898870]  [<ffffffff8109973a>] timer_fixup_init+0x16/0x2f
[    2.898870]  [<ffffffff812234ba>] debug_object_fixup+0x15/0x1d
[    2.898870]  [<ffffffff812239ff>] __debug_object_init+0x29b/0x2c6
[    2.898870]  [<ffffffff81223a1b>] ? __debug_object_init+0x2b7/0x2c6
[    2.898870]  [<ffffffff81223a3e>] debug_object_init+0x14/0x16
[    2.898870]  [<ffffffff810992e8>] init_timer_key+0x23/0x65
[    2.898870]  [<ffffffff8121352f>] kobject_release+0x90/0xba
[    2.898870]  [<ffffffff812137ac>] kobject_put+0x4d/0x51
[    2.898870]  [<ffffffff81482cfb>] put_device+0x12/0x14
[    2.898870]  [<ffffffff814873a2>] platform_device_put+0x12/0x14
[    2.898870]  [<ffffffff81487727>] platform_device_unregister+0x16/0x1a
[    2.898870]  [<ffffffff814810f9>] parport_pc_probe_port+0x7c4/0x7d9
[    2.898870]  [<ffffffff81e36c75>] parport_pc_init+0x2b0/0x317
[    2.898870]  [<ffffffff81e369c5>] ? parport_setup+0x147/0x147
[    2.898870]  [<ffffffff81e11e0c>] do_one_initcall+0x8e/0x132
[    2.898870]  [<ffffffff810a7000>] ? param_array_set+0x7f/0xf2
[    2.898870]  [<ffffffff810a7275>] ? parse_args+0x1ad/0x26c
[    2.898870]  [<ffffffff81e11fe2>] kernel_init_freeable+0x132/0x1bc
[    2.898870]  [<ffffffff81e116e3>] ? do_early_param+0x86/0x86
[    2.898870]  [<ffffffff818488bf>] ? rest_init+0xc3/0xc3
[    2.898870]  [<ffffffff818488c8>] kernel_init+0x9/0xcc
[    2.898870]  [<ffffffff81859e3c>] ret_from_fork+0x7c/0xb0
[    2.898870]  [<ffffffff818488bf>] ? rest_init+0xc3/0xc3
[    3.416153] tsc: Refined TSC clocksource calibration: 2693.460 MHz
[    3.792076] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    3.793846] IP: [<          (null)>]           (null)
[    3.794895] PGD 0
[    3.795349] Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    3.796043] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.11.0-rc2-00010-gc817a67-dirty #6
[    3.796043] task: ffff88000010a040 ti: ffff88000010c000 task.ti: ffff88000010c000
[    3.796043] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[    3.796043] RSP: 0000:ffff88000dc03e40  EFLAGS: 00010286
[    3.796043] RAX: 0000000000000000 RBX: 0000000000000100 RCX: 0000000000000000
[    3.796043] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[    3.796043] RBP: ffff88000dc03e98 R08: 0000000000000002 R09: 0000000000000000
[    3.796043] R10: ffff88000dc03e58 R11: ffffffff81f3f780 R12: ffff88000010dfd8
[    3.796043] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff81f407d8
[    3.796043] FS:  0000000000000000(0000) GS:ffff88000dc00000(0000) knlGS:0000000000000000
[    3.796043] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.796043] CR2: 0000000000000000 CR3: 0000000001c47000 CR4: 00000000000006b0
[    3.796043] Stack:
[    3.796043]  ffffffff810989e6 ffffffff8109897b ffffffff81f3f780 ffff880006daf0d8
[    3.796043]  0000000000000000 0000000000000000 0000000000000000 ffffffff81f3f780
[    3.796043]  ffff88000dc03ec8 ffffffff81f40fd8 ffffffff81f40bd8 ffff88000dc03f08
[    3.796043] Call Trace:
[    3.796043]  <IRQ>
[    3.796043]  [<ffffffff810989e6>] ? call_timer_fn+0x6b/0xde
[    3.796043]  [<ffffffff8109897b>] ? detach_timer+0x46/0x46
[    3.796043]  [<ffffffff81098fcb>] run_timer_softirq+0x187/0x1cf
[    3.796043]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
[    3.796043]  [<ffffffff81095745>] irq_exit+0x58/0x9e
[    3.796043]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
[    3.796043]  [<ffffffff8185ab72>] apic_timer_interrupt+0x72/0x80
[    3.796043]  <EOI>
[    3.796043]  [<ffffffff81859677>] ? retint_restore_args+0x13/0x13
[    3.796043]  [<ffffffff810990a2>] ? lock_timer_base.isra.17+0x49/0x4b
[    3.796043]  [<ffffffff810995f3>] try_to_del_timer_sync+0x27/0x5f
[    3.796043]  [<ffffffff81098801>] ? arch_local_irq_restore+0x6/0xd
[    3.796043]  [<ffffffff810996e3>] del_timer_sync+0xb8/0xcb
[    3.796043]  [<ffffffff8109962b>] ? try_to_del_timer_sync+0x5f/0x5f
[    3.796043]  [<ffffffff810cde75>] ? arch_local_irq_restore+0x6/0xd
[    3.796043]  [<ffffffff8109973a>] timer_fixup_init+0x16/0x2f
[    3.796043]  [<ffffffff812234ba>] debug_object_fixup+0x15/0x1d
[    3.796043]  [<ffffffff812239ff>] __debug_object_init+0x29b/0x2c6
[    3.796043]  [<ffffffff81223a1b>] ? __debug_object_init+0x2b7/0x2c6
[    3.796043]  [<ffffffff81223a3e>] debug_object_init+0x14/0x16
[    3.796043]  [<ffffffff810992e8>] init_timer_key+0x23/0x65
[    3.796043]  [<ffffffff8121352f>] kobject_release+0x90/0xba
[    3.796043]  [<ffffffff812137ac>] kobject_put+0x4d/0x51
[    3.796043]  [<ffffffff81482cfb>] put_device+0x12/0x14
[    3.796043]  [<ffffffff814873a2>] platform_device_put+0x12/0x14
[    3.796043]  [<ffffffff81487727>] platform_device_unregister+0x16/0x1a
[    3.796043]  [<ffffffff814810f9>] parport_pc_probe_port+0x7c4/0x7d9
[    3.796043]  [<ffffffff81e36c75>] parport_pc_init+0x2b0/0x317
[    3.796043]  [<ffffffff81e369c5>] ? parport_setup+0x147/0x147
[    3.796043]  [<ffffffff81e11e0c>] do_one_initcall+0x8e/0x132
[    3.796043]  [<ffffffff810a7000>] ? param_array_set+0x7f/0xf2
[    3.796043]  [<ffffffff810a7275>] ? parse_args+0x1ad/0x26c
[    3.796043]  [<ffffffff81e11fe2>] kernel_init_freeable+0x132/0x1bc
[    3.796043]  [<ffffffff81e116e3>] ? do_early_param+0x86/0x86
[    3.796043]  [<ffffffff818488bf>] ? rest_init+0xc3/0xc3
[    3.796043]  [<ffffffff818488c8>] kernel_init+0x9/0xcc
[    3.796043]  [<ffffffff81859e3c>] ret_from_fork+0x7c/0xb0
[    3.796043]  [<ffffffff818488bf>] ? rest_init+0xc3/0xc3
[    3.796043] Code:  Bad RIP value.
[    3.796043] RIP  [<          (null)>]           (null)
[    3.796043]  RSP <ffff88000dc03e40>
[    3.796043] CR2: 0000000000000000
[    3.877786] ---[ end trace 2f14671be5565db6 ]---
[    3.878755] Kernel panic - not syncing: Fatal exception in interrupt
[    3.880631] Rebooting in 10 seconds..%                                                                                                  wfg@bee ~/linux/obj-c
