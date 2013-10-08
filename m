Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3JHCga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:36:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:49698 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab3JHCg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:36:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1053,1371106800"; 
   d="scan'208";a="406959155"
Date: Tue, 8 Oct 2013 10:36:17 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131008023617.GA7066@localhost>
References: <20131006082340.GA24568@localhost>
 <CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
 <20131007021118.GA27927@localhost>
 <20131007051038.GA9764@localhost>
 <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
 <20131007083505.GA22585@localhost>
 <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
 <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
 <20131008020918.GA1220@localhost>
 <20131008021452.GA6456@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008021452.GA6456@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 10:14:52AM +0800, Fengguang Wu wrote:
> On Tue, Oct 08, 2013 at 10:09:18AM +0800, Fengguang Wu wrote:
> > On Mon, Oct 07, 2013 at 04:47:29PM -0700, Linus Torvalds wrote:
> > > On Mon, Oct 7, 2013 at 3:14 PM, Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > >
> > > > I *think* r14 contains the function we're going to jump to in the
> > > > oops, and that could be interesting to know, but it's not decoded, so
> > > > you'd have to match it up against a symbol map...
> > > 
> > > Actually, Fenguguan, never mind. Instead, change the "pr_debug()" in
> > > kobject_release() to  "pr_alert()", so that it gets printed out. Or
> > > just boot with the "ignore_loglevel" thing so that debug messages are
> > > actually visible.
> > > 
> > > At that point, we should be able to match the oops workqueue list
> > > address with the address of the delayed kernel object that gets
> > > printed out.
> > 
> > Thanks for the hints! I run a kernel with pr_alert() for several times
> > and here is the screen log. Note that this kernel is compiled with gcc
> > 4.6.3 and the decoded code looks different than gcc 4.8.1
> 
> I got a call trace containing parport_pc_probe_port() (is it the
> culprit?) after recompiling kernel with
> 
> CONFIG_DEBUG_OBJECTS_TIMERS=y
> 
> and booting with "ignore_loglevel". Here is the log for two kernel boots.

Disabled PARPORT_PC:

# CONFIG_PARPORT is not set

and retest shows another call trace. Here are two run logs:

% kvm-0day.sh arch/x86/boot/bzImage
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc2-00010-gc817a67-dirty (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #7 SMP PREEMPT Tue Oct 8 10:27:55 CST 2013
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
[    0.000000] BRK [0x0289b000, 0x0289bfff] PGTABLE
[    0.000000] BRK [0x0289c000, 0x0289cfff] PGTABLE
[    0.000000] BRK [0x0289d000, 0x0289dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x0289e000, 0x0289efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x0289f000, 0x0289ffff] PGTABLE
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
[    0.000000] Memory: 199116K/261744K available (8533K kernel code, 1781K rwdata, 3952K rodata, 840K init, 10060K bss, 62628K reserved)
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
[    0.008018] pid_max: default: 32768 minimum: 301
[    0.009311] Mount-cache hash table entries: 256
[    0.010874] Initializing cgroup subsys devices
[    0.012047] Initializing cgroup subsys perf_event
[    0.013300] Initializing cgroup subsys net_prio
[    0.014646] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014646] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014646] tlb_flushall_shift: 6
[    0.016052] debug: unmapping init [mem 0xffffffff81ec4000-0xffffffff81ec7fff]
[    0.021076] ACPI: Core revision 20130517
[    0.025212] ACPI: All ACPI Tables successfully acquired
[    0.027244] Getting VERSION: 50014
[    0.028025] Getting VERSION: 50014
[    0.028894] Getting ID: 0
[    0.029646] Getting ID: ff000000
[    0.030533] Getting LVT0: 8700
[    0.031356] Getting LVT1: 8400
[    0.032104] enabled ExtINT on CPU#0
[    0.034296] ENABLING IO-APIC IRQs
[    0.035143] init IO_APIC IRQs
[    0.036020]  apic 0 pin 0 not connected
[    0.036904] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.038757] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.040076] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.042426] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.044052] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.046281] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.048047] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.052045] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.054123] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.056040] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.058112] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.060053] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.062452] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.064047] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.065645] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.068041]  apic 0 pin 16 not connected
[    0.069151]  apic 0 pin 17 not connected
[    0.070192]  apic 0 pin 18 not connected
[    0.072011]  apic 0 pin 19 not connected
[    0.073106]  apic 0 pin 20 not connected
[    0.074196]  apic 0 pin 21 not connected
[    0.075327]  apic 0 pin 22 not connected
[    0.076015]  apic 0 pin 23 not connected
[    0.077247] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.080013] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.082660] Using local APIC timer interrupts.
[    0.082660] calibrating APIC timer ...
[    0.088000] ... lapic delta = 6250583
[    0.088000] ... PM-Timer delta = 358012
[    0.088000] ... PM-Timer result ok
[    0.088000] ..... delta 6250583
[    0.088000] ..... mult: 268460495
[    0.088000] ..... calibration result: 4000373
[    0.088000] ..... CPU clock speed is 2693.3520 MHz.
[    0.088000] ..... host bus clock speed is 1000.0373 MHz.
[    0.088126] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.112625] SMP alternatives: lockdep: fixing up alternatives
[    0.114131] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:e896041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.136165] KVM setup async PF for cpu 1
[    0.136273] Brought up 2 CPUs
[    0.136278] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.140471] kvm-stealtime: cpu 1, msr dd0ccc0
[    0.148381] devtmpfs: initialized
[    0.152362] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.155079] regulator-dummy: no parameters
[    0.156507] NET: Registered protocol family 16
[    0.159496] ACPI: bus type PCI registered
[    0.160097] PCI: Using configuration type 1 for base access
[    0.172548] ACPI: Added _OSI(Module Device)
[    0.173841] ACPI: Added _OSI(Processor Device)
[    0.175172] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.176015] ACPI: Added _OSI(Processor Aggregator Device)
[    0.180607] ACPI: EC: Look up EC in DSDT
[    0.189294] ACPI: Interpreter enabled
[    0.190517] ACPI: (supports S0 S5)
[    0.191625] ACPI: Using IOAPIC for interrupt routing
[    0.192069] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.211359] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.212578] PCI host bridge to bus 0000:00
[    0.213899] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.216017] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.218056] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.220017] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.222211] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.224150] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.228233] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.231050] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.236482] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.240263] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.242906] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.244043] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.246702] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.253230] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.257009] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.272151] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.276137] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.279507] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.281182] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.289241] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.291709] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.293430] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.297252] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.305834] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.308518] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.311230] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.317852] pci_bus 0000:00: on NUMA node 0
[    0.319209] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.320014] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.325500] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.327602] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.328814] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.330854] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.332642] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.336660] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.338086] ACPI: \_SB_.PCI0: notify handler is installed
[    0.339781] Found 1 acpi root devices
[    0.341268] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.344012] vgaarb: loaded
[    0.344806] vgaarb: bridge control possible 0000:00:02.0
[    0.348373] ACPI: bus type USB registered
[    0.349687] usbcore: registered new interface driver usbfs
[    0.351255] usbcore: registered new interface driver hub
[    0.352159] usbcore: registered new device driver usb
[    0.353598] pps_core: LinuxPPS API ver. 1 registered
[    0.354936] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.356068] PTP clock support registered
[    0.360389] wmi: Mapper loaded
[    0.361421] PCI: Using ACPI for IRQ routing
[    0.362717] PCI: pci_cache_line_size set to 64 bytes
[    0.364382] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.366016] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.369105] NET: Registered protocol family 23
[    0.371028] cfg80211: Calling CRDA to update world regulatory domain
[    0.372175] nfc: nfc_init: NFC Core ver 0.1
[    0.373321] NET: Registered protocol family 39
[    0.376595] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.378743] Switched to clocksource kvm-clock
[    0.378743] pnp: PnP ACPI init
[    0.378807] ACPI: bus type PNP registered
[    0.380207] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.382589] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.384308] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.386787] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.388899] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.391554] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.393610] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.396208] pnp 00:03: [dma 2]
[    0.397228] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.399324] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.401965] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.404003] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.406646] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.409247] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.411643] pnp: PnP ACPI: found 7 devices
[    0.412830] ACPI: bus type PNP unregistered
[    0.421098] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.423119] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.424832] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.426612] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.428722] NET: Registered protocol family 2
[    0.430870] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    0.433172] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.435307] TCP: Hash tables configured (established 2048 bind 2048)
[    0.437380] TCP: reno registered
[    0.438229] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.439986] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.442454] NET: Registered protocol family 1
[    0.444511] RPC: Registered named UNIX socket transport module.
[    0.446264] RPC: Registered udp transport module.
[    0.447726] RPC: Registered tcp transport module.
[    0.449188] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.451016] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.452791] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.454537] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.456517] pci 0000:00:02.0: Boot video device
[    0.457913] PCI: CLS 0 bytes, default 64
[    0.459479] Unpacking initramfs...
[    2.808745] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    2.810820] has_svm: not amd
[    2.811267] kvm: no hardware support
[    2.812157] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    2.813529] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    2.816677] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    2.816721] cryptomgr_test (24) used greatest stack depth: 6224 bytes left
[    2.819975] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.821274] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.822543] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.823753] AVX or AES-NI instructions are not detected.
[    2.824844] AVX instructions are not detected.
[    2.825793] AVX instructions are not detected.
[    2.826743] AVX instructions are not detected.
[    2.831560] Initializing RT-Tester: OK
[    2.832675] audit: initializing netlink socket (disabled)
[    2.834387] type=2000 audit(1378709047.226:1): initialized
[    2.840784] DLM installed
[    2.843718] NFS: Registering the id_resolver key type
[    2.844831] Key type id_resolver registered
[    2.845619] Key type id_legacy registered
[    2.846365] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.847932] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.848804] fuse init (API version 7.22)
[    2.850367] ceph: loaded (mds proto 32)
[    2.853502] cryptomgr_test (43) used greatest stack depth: 5696 bytes left
[    2.856268] cryptomgr_test (46) used greatest stack depth: 5688 bytes left
[    2.869127] cryptomgr_test (72) used greatest stack depth: 5352 bytes left
[    2.872728] alg: No test for crc32 (crc32-table)
[    2.874685] alg: No test for lz4hc (lz4hc-generic)
[    2.875789] alg: No test for stdrng (krng)
[    2.877066] NET: Registered protocol family 38
[    2.877605] Key type asymmetric registered
[    2.878135] Asymmetric key parser 'x509' registered
[    2.878700] test_string_helpers: Running tests...
[    2.880142] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    2.881105] crc32: self tests passed, processed 225944 bytes in 309425 nsec
[    2.882471] crc32c: CRC_LE_BITS = 32
[    2.882867] crc32c: self tests passed, processed 225944 bytes in 142131 nsec
[    2.884589] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    2.886208] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    2.888213] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    2.890569] vmlfb: initializing
[    2.891403] Could not find Carillo Ranch MCH device.
[    2.892743] no IO addresses supplied
[    2.893854] hgafb: HGA card not detected.
[    2.894846] hgafb: probe of hgafb.0 failed with error -22
[    2.896298] usbcore: registered new interface driver udlfb
[    2.898103] usbcore: registered new interface driver smscufx
[    2.900262] uvesafb: failed to execute /sbin/v86d
[    2.901425] uvesafb: make sure that the v86d helper is installed and executable
[    2.903205] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    2.904877] uvesafb: vbe_init() failed with -22
[    2.906020] uvesafb: probe of uvesafb.0 failed with error -22
[    2.907502] ipmi message handler version 39.2
[    2.908634] ipmi device interface
[    2.909553] IPMI System Interface driver.
[    2.910615] ipmi_si: Adding default-specified kcs state machine
[    2.912130] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    2.914845] ipmi_si: Interface detection failed
[    2.932159] ipmi_si: Adding default-specified smic state machine
[    2.933511] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    2.935633] ipmi_si: Interface detection failed
[    2.948154] ipmi_si: Adding default-specified bt state machine
[    2.949469] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    2.951624] ipmi_si: Interface detection failed
[    2.964362] kobject: 'ipmi_si' (ffff8800077aba00): kobject_release, parent ffff8800001b7648 (delayed)
[    2.966126] kobject: 'ipmi_si' (ffff8800077ab800): kobject_release, parent ffff880000221248 (delayed)
[    2.967912] kobject: 'ipmi_si' (ffff8800077abc00): kobject_release, parent ffff880000189248 (delayed)
[    2.969937] ipmi_si: Unable to find any System Interface(s)
[    2.971082] IPMI Watchdog: driver initialized
[    2.971988] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    2.974096] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.976333] ACPI: Power Button [PWRF]
[    3.094014] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.119842] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.123509] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    3.125724] ac.o: No PCI boards found.
[    3.126871] ac.o: For an ISA board you must supply memory and irq parameters.
[    3.129443] Non-volatile memory driver v1.3
[    3.130935] Linux agpgart interface v0.103
[    3.133011] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    3.134801] kobject: 'drm' (ffff880006dca848): kobject_release, parent ffff880000189648 (delayed)
[    3.137478] kobject: 'drm' (ffff880006dc7000): kobject_release, parent           (null) (delayed)
[    3.140440] [drm] radeon kernel modesetting enabled.
[    3.143084] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
[    3.145419] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/dri.
[    3.148929] kobject: 'controlD64' (ffff880006dca020): kobject_release, parent           (null) (delayed)
[    3.151865] cirrus: probe of 0000:00:02.0 failed with error -1
[    3.154028] usbcore: registered new interface driver udl
[    3.155856] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    3.157872] dummy-irq: no IRQ given.  Use irq=N
[    3.159273] Phantom Linux Driver, version n0.9.8, init OK
[    3.161152] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    3.163502] c2port c2port0: C2 port uc added
[    3.164832] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    3.167526] Guest personality initialized and is inactive
[    3.169570] VMCI host device registered (name=vmci, major=10, minor=56)
[    3.171644] Initialized host personality
[    3.173031] Driver for timberdale has been successfully registered.
[    3.175176] usbcore: registered new interface driver viperboard
[    3.177101] usbcore: registered new interface driver pn533
[    3.179074] mtdoops: mtd device (mtddev=name/number) must be supplied
[    3.180854] device id = 2440
[    3.181679] device id = 2480
[    3.182438] device id = 24c0
[    3.183487] device id = 24d0
[    3.184530] device id = 25a1
[    3.185627] device id = 2670
[    3.186855] platform physmap-flash.0: failed to claim resource 0
[    3.189081] kobject: 'physmap-flash' (ffff880006df2000): kobject_release, parent ffff880000189248 (delayed)
[    3.192129] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    3.194096] Could not find PAR responsible for SC520CDP Flash Bank #0
[    3.195752] Trying default address 0x8400000
[    3.197103] Could not find PAR responsible for SC520CDP Flash Bank #1
[    3.199068] Trying default address 0x8c00000
[    3.200388] Could not find PAR responsible for SC520CDP DIL Flash
[    3.202446] Trying default address 0x9400000
[    3.203799] SC520 CDP flash device: 0x800000 at 0x8400000
[    3.205419] Failed to ioremap_nocache
[    3.206543] Failed to ioremap_nocache
[    3.207766] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.209844] kobject: 'docg3' (ffff880006df9400): kobject_release, parent ffff880000189248 (delayed)
[    3.212202] slram: not enough parameters.
[    3.217605] No valid DiskOnChip devices found
[    3.218937] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.221774] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.224552] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.227570] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.230262] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.233198] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.236211] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    3.240004] flash size: 128 MiB
[    3.240932] page size: 512 bytes
[    3.241901] OOB area size: 16 bytes
[    3.242976] sector size: 16 KiB
[    3.243972] pages number: 262144
[    3.244999] pages per sector: 32
[    3.246024] bus width: 8
[    3.246784] bits in sector size: 14
[    3.247869] bits in page size: 9
[    3.248987] bits in OOB size: 4
[    3.249936] flash size with OOB: 135168 KiB
[    3.251181] page address bytes: 4
[    3.252267] sector address bytes: 3
[    3.253307] options: 0x42
[    3.259137] Scanning device for bad blocks
[    3.308161] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.309995] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.313682] usbcore: registered new interface driver irda-usb
[    3.315556] usbcore: registered new interface driver stir4200
[    3.317302] usbcore: registered new interface driver mcs7780
[    3.318910] usbcore: registered new interface driver kingsun-sir
[    3.320643] usbcore: registered new interface driver ksdazzle-sir
[    3.322626] usbcore: registered new interface driver ks959-sir
[    3.324910] usbcore: registered new interface driver hwa-rc
[    3.326898] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.328817] ohci-pci: OHCI PCI platform driver
[    3.330178] ohci-platform: OHCI generic platform driver
[    3.331755] uhci_hcd: USB Universal Host Controller Interface driver
[    3.333960] driver u132_hcd
[    3.335452] usbcore: registered new interface driver hwa-hc
[    3.337210] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    3.338963] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    3.341878] usbcore: registered new interface driver cdc_wdm
[    3.343550] usbcore: registered new interface driver usbtmc
[    3.345496] usbcore: registered new interface driver appledisplay
[    3.347326] usbcore: registered new interface driver emi26 - firmware loader
[    3.349335] usbcore: registered new interface driver emi62 - firmware loader
[    3.351383] driver ftdi-elan
[    3.353032] usbcore: registered new interface driver ftdi-elan
[    3.354509] usbcore: registered new interface driver idmouse
[    3.356221] usbcore: registered new interface driver usblcd
[    3.358030] usbcore: registered new interface driver ldusb
[    3.359714] usbcore: registered new interface driver usbled
[    3.361842] usbcore: registered new interface driver legousbtower
[    3.363990] usbcore: registered new interface driver rio500
[    3.365950] usbcore: registered new interface driver usbtest
[    3.367720] usbcore: registered new interface driver trancevibrator
[    3.369654] usbcore: registered new interface driver yurex
[    3.371367] kobject: 'gpio-vbus' (ffff88000682c200): kobject_release, parent ffff880000189248 (delayed)
[    3.374188] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.378081] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.379363] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.476672] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    3.480169] usbcore: registered new interface driver bcm5974
[    3.481737] kobject: '(null)' (ffff8800077bfaf0): kobject_release, parent           (null) (delayed)
[    3.481779] usbcore: registered new interface driver synaptics_usb
[    3.482131] usbcore: registered new interface driver iforce
[    3.482792] usbcore: registered new interface driver usbtouchscreen
[    3.483056] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    3.483080] usbcore: registered new interface driver ati_remote2
[    3.483116] cm109: Keymap for Komunikate KIP1000 phone loaded
[    3.483137] usbcore: registered new interface driver cm109
[    3.483138] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    3.483193] usbcore: registered new interface driver keyspan_remote
[    3.493071] usbcore: registered new interface driver yealink
[    3.495687] I2O subsystem v1.325
[    3.496725] i2o: max drivers = 8
[    3.498023] I2O Configuration OSM v1.323
[    3.498944] I2O ProcFS OSM v1.316
[    3.499765] kobject: 'proc-osm' (ffff880006857c00): kobject_release, parent ffff880006853648 (delayed)
[    3.503457] kobject: 'mc13xxx-rtc' (ffff88000685ec00): kobject_release, parent ffff880000189248 (delayed)
[    3.506421] kobject: 'rtc-msm6242' (ffff88000685ea00): kobject_release, parent ffff880000189248 (delayed)
[    3.509327] kobject: 'pcap-rtc' (ffff88000685e800): kobject_release, parent ffff880000189248 (delayed)
[    3.512481] kobject: 'rtc-rp5c01' (ffff880006860800): kobject_release, parent ffff880000189248 (delayed)
[    3.517173] rtc rtc0: test: dev (254:0)
[    3.518438] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    3.520852] rtc rtc1: test: dev (254:1)
[    3.522043] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    3.524144] i2c /dev entries driver
[    3.525827] usbcore: registered new interface driver i2c-diolan-u2c
[    3.527965] i2c-parport-light: adapter type unspecified
[    3.531198] pps pps0: new PPS source ktimer
[    3.532461] pps pps0: ktimer PPS source registered
[    3.534081] Driver for 1-wire Dallas network protocol.
[    3.535733] usbcore: registered new interface driver DS9490R
[    3.537541] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.539755] power_supply test_ac: uevent
[    3.541002] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    3.542785] power_supply test_ac: prop ONLINE=1
[    3.544324] power_supply test_ac: power_supply_changed
[    3.545933] power_supply test_ac: power_supply_changed_work
[    3.547611] power_supply test_ac: power_supply_update_gen_leds 1
[    3.549602] power_supply test_ac: uevent
[    3.549752] power_supply test_battery: uevent
[    3.549755] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    3.549764] power_supply test_battery: prop STATUS=Discharging
[    3.549768] power_supply test_battery: prop CHARGE_TYPE=Fast
[    3.549772] power_supply test_battery: prop HEALTH=Good
[    3.549776] power_supply test_battery: prop PRESENT=1
[    3.549779] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    3.549783] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    3.549787] power_supply test_battery: prop CHARGE_FULL=100
[    3.549790] power_supply test_battery: prop CHARGE_NOW=50
[    3.549793] power_supply test_battery: prop CAPACITY=50
[    3.549797] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    3.549800] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    3.549804] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    3.549808] power_supply test_battery: prop MODEL_NAME=Test battery
[    3.549811] power_supply test_battery: prop MANUFACTURER=Linux
[    3.549815] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    3.549818] power_supply test_battery: prop TEMP=26
[    3.549821] power_supply test_battery: prop VOLTAGE_NOW=3300
[    3.550151] power_supply test_battery: power_supply_changed
[    3.550200] power_supply test_usb: uevent
[    3.550202] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    3.550215] power_supply test_usb: prop ONLINE=1
[    3.550229] power_supply test_usb: power_supply_changed
[    3.551132] applesmc: supported laptop not found!
[    3.551134] applesmc: driver init failed (ret=-19)!
[    3.551628] f71882fg: Not a Fintek device
[    3.551744] f71882fg: Not a Fintek device
[    3.552673] kobject: 'mc13783-adc' (ffff880007707000): kobject_release, parent ffff880000189248 (delayed)
[    3.553194] pc87360: PC8736x not detected, module not inserted
[    3.554394] cpuidle: using governor ladder
[    3.554398] cpuidle: using governor menu
[    3.554434] sdhci: Secure Digital Host Controller Interface driver
[    3.554435] sdhci: Copyright(c) Pierre Ossman
[    3.554639] power_supply test_battery: power_supply_changed_work
[    3.554645] power_supply test_battery: power_supply_update_bat_leds 2
[    3.554655] power_supply test_battery: uevent
[    3.554657] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    3.554665] power_supply test_battery: prop STATUS=Discharging
[    3.554670] power_supply test_battery: prop CHARGE_TYPE=Fast
[    3.554674] power_supply test_battery: prop HEALTH=Good
[    3.554678] power_supply test_battery: prop PRESENT=1
[    3.554681] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    3.554685] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    3.554689] power_supply test_battery: prop CHARGE_FULL=100
[    3.554692] power_supply test_battery: prop CHARGE_NOW=50
[    3.554696] power_supply test_battery: prop CAPACITY=50
[    3.554700] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    3.554704] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    3.554708] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    3.554712] power_supply test_battery: prop MODEL_NAME=Test battery
[    3.554716] power_supply test_battery: prop MANUFACTURER=Linux
[    3.554720] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    3.554724] power_supply test_battery: prop TEMP=26
[    3.554728] power_supply test_battery: prop VOLTAGE_NOW=3300
[    3.554747] power_supply test_usb: power_supply_changed_work
[    3.554751] power_supply test_usb: power_supply_update_gen_leds 1
[    3.554757] power_supply test_usb: uevent
[    3.554759] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    3.554767] power_supply test_usb: prop ONLINE=1
[    3.651127] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    3.652412] power_supply test_ac: prop ONLINE=1
[    3.652625] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    3.652626] usbcore: registered new interface driver vub300
[    3.652658] usbcore: registered new interface driver ushc
[    3.652660] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.653397] ledtrig-cpu: registered to indicate activity on CPUs
[    3.653743] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    3.655085] usbcore: registered new interface driver usbhid
[    3.655086] usbhid: USB HID core driver
[    3.655138] usbip_core: usbip_core_init:804: USB/IP Core v1.0.0
[    3.655355] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    3.655373] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    3.655471] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 1
[    3.655490] vhci_hcd: vhci_start:884: enter vhci_start
[    3.656448] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.656452] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.656454] usb usb1: Product: USB/IP Virtual Host Controller
[    3.656456] usb usb1: Manufacturer: Linux 3.11.0-rc2-00010-gc817a67-dirty vhci_hcd
[    3.656458] usb usb1: SerialNumber: vhci_hcd
[    3.657266] hub 1-0:1.0: USB hub found
[    3.657307] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIndex 0
[    3.657348] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
[    3.657351] vhci_hcd: vhci_hub_control:398: port -1
[    3.657352] vhci_hcd: vhci_hub_control:405:  bye
[    3.657368] hub 1-0:1.0: 8 ports detected
[    3.657428] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex 0
[    3.657442] vhci_hcd: vhci_hub_control:309:  GetHubStatus
[    3.657444] vhci_hcd: vhci_hub_control:398: port -1
[    3.657445] vhci_hcd: vhci_hub_control:405:  bye
[    3.658028] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 1
[    3.658030] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.658032] vhci_hcd: vhci_hub_control:398: port 0
[    3.658034] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.658035] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.658036] vhci_hcd: dump_port_status_diff:119:
[    3.658038] vhci_hcd: vhci_hub_control:405:  bye
[    3.658046] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 2
[    3.658047] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.658049] vhci_hcd: vhci_hub_control:398: port 1
[    3.658051] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.658052] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.658053] vhci_hcd: dump_port_status_diff:119:
[    3.658055] vhci_hcd: vhci_hub_control:405:  bye
[    3.658061] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 3
[    3.658063] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.658064] vhci_hcd: vhci_hub_control:398: port 2
[    3.658066] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.658068] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.658069] vhci_hcd: dump_port_status_diff:119:
[    3.658070] vhci_hcd: vhci_hub_control:405:  bye
[    3.658077] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 4
[    3.658078] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.658080] vhci_hcd: vhci_hub_control:398: port 3
[    3.658081] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.658083] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.658084] vhci_hcd: dump_port_status_diff:119:
[    3.658091] vhci_hcd: vhci_hub_control:405:  bye
[    3.658099] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 5
[    3.658100] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.658101] vhci_hcd: vhci_hub_control:398: port 4
[    3.658103] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.658104] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.658106] vhci_hcd: dump_port_status_diff:119:
[    3.658107] vhci_hcd: vhci_hub_control:405:  bye
[    3.658114] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 6
[    3.658116] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.658117] vhci_hcd: vhci_hub_control:398: port 5
[    3.658119] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.658121] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.658122] vhci_hcd: dump_port_status_diff:119:
[    3.658123] vhci_hcd: vhci_hub_control:405:  bye
[    3.658129] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 7
[    3.658131] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.658133] vhci_hcd: vhci_hub_control:398: port 6
[    3.658134] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.658136] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.658137] vhci_hcd: dump_port_status_diff:119:
[    3.658138] vhci_hcd: vhci_hub_control:405:  bye
[    3.658145] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 8
[    3.658146] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.658148] vhci_hcd: vhci_hub_control:398: port 7
[    3.658149] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.658151] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.658152] vhci_hcd: dump_port_status_diff:119:
[    3.658153] vhci_hcd: vhci_hub_control:405:  bye
[    3.658408] vhci_hcd: vhci_hcd_probe:1034: bye
[    3.658416] vhci_hcd: vhci_hcd_init:1156: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.0.0
[    3.792948] usbcore: registered new interface driver usbip-host
[    3.795110] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
[    3.797829] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 1
[    3.799852] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 1
[    3.801616] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.801766] usbcore: registered new interface driver tranzport
[    3.801805] usbcore: registered new interface driver alphatrack
[    3.801807] vme_user: VME User Space Access Driver
[    3.801808] vme_user: No cards, skipping registration
[    3.802696] Loading crystalhd 0.9.27
[    3.802763] usbcore: registered new interface driver ft1000usb
[    3.802828] usbcore: registered new interface driver gdm_wimax
[    3.802841] usbcore: registered new interface driver cedusb
[    3.821152] vhci_hcd: vhci_hub_control:398: port 0
[    3.821198] tsc: Refined TSC clocksource calibration: 2693.467 MHz
[    3.821683] ipip: IPv4 over IPv4 tunneling driver
[    3.822360] gre: GRE over IPv4 demultiplexor driver
[    3.822366] IPv4 over IPSec tunneling driver
[    3.822791] TCP: cubic registered
[    3.822797] NET: Registered protocol family 17
[    3.832832] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.832987] NET: Registered protocol family 9
[    3.833011] X.25 for Linux Version 0.2
[    3.838638] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.840796] vhci_hcd: dump_port_status_diff:119:
[    3.840806] NET: Registered protocol family 33
[    3.840820] Key type rxrpc registered
[    3.840822] Key type rxrpc_s registered
[    3.846049] vhci_hcd: vhci_hub_control:405:  bye
[    3.847970] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 2
[    3.850556] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 2
[    3.850820] RxRPC: Registered security type 2 'rxkad'
[    3.850897] l2tp_core: L2TP core driver, V2.0
[    3.850903] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    3.860790] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.863315] vhci_hcd: vhci_hub_control:398: port 1
[    3.863343] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    3.868047] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.868156] NET: Registered protocol family 12
[    3.871635] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.872788] vhci_hcd: dump_port_status_diff:119:
[    3.873747] vhci_hcd: vhci_hub_control:405:  bye
[    3.875122] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 3
[    3.877698] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 3
[    3.886040] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.889131] vhci_hcd: vhci_hub_control:398: port 2
[    3.889155] 8021q: 802.1Q VLAN Support v1.8
[    3.892830] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.895316] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.895783] sctp: Hash tables configured (established 1024 bind 1024)
[    3.899748] vhci_hcd: dump_port_status_diff:119:
[    3.901135] vhci_hcd: vhci_hub_control:405:  bye
[    3.902604] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[    3.903548] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 4
[    3.903554] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 4
[    3.903558] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.903562] vhci_hcd: vhci_hub_control:398: port 3
[    3.903578] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.903580] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.903581] vhci_hcd: dump_port_status_diff:119:
[    3.903582] vhci_hcd: vhci_hub_control:405:  bye
[    3.903592] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 5
[    3.903595] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 5
[    3.903596] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.903598] vhci_hcd: vhci_hub_control:398: port 4
[    3.903599] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.903601] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.903602] vhci_hcd: dump_port_status_diff:119:
[    3.903604] vhci_hcd: vhci_hub_control:405:  bye
[    3.903611] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 6
[    3.903612] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 6
[    3.903614] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.903615] vhci_hcd: vhci_hub_control:398: port 5
[    3.903617] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.903619] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.903620] vhci_hcd: dump_port_status_diff:119:
[    3.903621] vhci_hcd: vhci_hub_control:405:  bye
[    3.903629] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 7
[    3.903631] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 7
[    3.903633] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.903634] vhci_hcd: vhci_hub_control:398: port 6
[    3.903636] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.903638] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.903639] vhci_hcd: dump_port_status_diff:119:
[    3.903640] vhci_hcd: vhci_hub_control:405:  bye
[    3.903648] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 8
[    3.903649] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 8
[    3.903651] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.903652] vhci_hcd: vhci_hub_control:398: port 7
[    3.903654] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.903656] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.903657] vhci_hcd: dump_port_status_diff:119:
[    3.903658] vhci_hcd: vhci_hub_control:405:  bye
[    3.904132] usb usb1: vhci_bus_suspend
[    3.904147] vhci_hcd: vhci_hub_status:208: changed 0
[    3.968780] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[    3.974466] NET: Registered protocol family 37
[    3.976026] NET: Registered protocol family 36
[    3.977464] Key type dns_resolver registered
[    3.978679] Key type ceph registered
[    3.979608] libceph: loaded (mon/osd proto 15/24)
[    3.980601] mpls_gso: MPLS GSO support
[    3.981871]
[    3.981871] printing PIC contents
[    3.982692] ... PIC  IMR: ffff
[    3.983270] ... PIC  IRR: 1013
[    3.983777] ... PIC  ISR: 0000
[    3.984354] ... PIC ELCR: 0c00
[    3.984873] printing local APIC contents on CPU#0/0:
[    3.985701] ... APIC ID:      00000000 (0)
[    3.986530] ... APIC VERSION: 00050014
[    3.987197] ... APIC TASKPRI: 00000000 (00)
[    3.987954] ... APIC PROCPRI: 00000000
[    3.988302] ... APIC LDR: 01000000
[    3.988302] ... APIC DFR: ffffffff
[    3.988302] ... APIC SPIV: 000001ff
[    3.988302] ... APIC ISR field:
[    3.988302] 0000000000000000000000000000000000000000000000000000000000000000
[    3.988302] ... APIC TMR field:
[    3.988302] 0000000000000000000000000000000000000000000000000000000000000000
[    3.988302] ... APIC IRR field:
[    3.988302] 0000000000000000000000000000000000000000000000000000000000008000
[    3.988302] ... APIC ESR: 00000000
[    3.988302] ... APIC ICR: 000008fd
[    3.988302] ... APIC ICR2: 02000000
[    3.988302] ... APIC LVTT: 000000ef
[    3.988302] ... APIC LVTPC: 00010000
[    3.988302] ... APIC LVT0: 00010700
[    3.988302] ... APIC LVT1: 00000400
[    3.988302] ... APIC LVTERR: 000000fe
[    3.988302] ... APIC TMICT: 000384be
[    3.988302] ... APIC TMCCT: 00000000
[    3.988302] ... APIC TDCR: 00000003
[    3.988302]
[    4.011652] number of MP IRQ sources: 15.
[    4.012936] number of IO-APIC #0 registers: 24.
[    4.014048] testing the IO APIC.......................
[    4.015316] IO APIC #0......
[    4.016070] .... register #00: 00000000
[    4.017068] .......    : physical APIC id: 00
[    4.018169] .......    : Delivery Type: 0
[    4.019061] .......    : LTS          : 0
[    4.019985] .... register #01: 00170011
[    4.021096] .......     : max redirection entries: 17
[    4.022207] .......     : PRQ implemented: 0
[    4.023076] .......     : IO APIC version: 11
[    4.024123] .... register #02: 00000000
[    4.025007] .......     : arbitration: 00
[    4.025841] .... IRQ redirection table:
[    4.026653] 1    0    0   0   0    0    0    00
[    4.027649] 0    0    0   0   0    1    1    31
[    4.028689] 0    0    0   0   0    1    1    30
[    4.029682] 0    0    0   0   0    1    1    33
[    4.030797] 1    0    0   0   0    1    1    34
[    4.031746] 1    1    0   0   0    1    1    35
[    4.032739] 0    0    0   0   0    1    1    36
[    4.033780] 0    0    0   0   0    1    1    37
[    4.034756] 0    0    0   0   0    1    1    38
[    4.035762] 0    1    0   0   0    1    1    39
[    4.037041] 1    1    0   0   0    1    1    3A
[    4.039024] 1    1    0   0   0    1    1    3B
[    4.040365] 0    0    0   0   0    1    1    3C
[    4.041643] 0    0    0   0   0    1    1    3D
[    4.042952] 0    0    0   0   0    1    1    3E
[    4.044414] 0    0    0   0   0    1    1    3F
[    4.045695] 1    0    0   0   0    0    0    00
[    4.047865] 1    0    0   0   0    0    0    00
[    4.049175] 1    0    0   0   0    0    0    00
[    4.050342] 1    0    0   0   0    0    0    00
[    4.051594] 1    0    0   0   0    0    0    00
[    4.052837] 1    0    0   0   0    0    0    00
[    4.054100] 1    0    0   0   0    0    0    00
[    4.055302] 1    0    0   0   0    0    0    00
[    4.056864] IRQ to pin mappings:
[    4.057758] IRQ0 -> 0:2
[    4.058504] IRQ1 -> 0:1
[    4.059259] IRQ3 -> 0:3
[    4.060041] IRQ4 -> 0:4
[    4.061282] IRQ5 -> 0:5
[    4.062369] IRQ6 -> 0:6
[    4.063592] IRQ7 -> 0:7
[    4.064660] IRQ8 -> 0:8
[    4.065527] IRQ9 -> 0:9
[    4.066422] IRQ10 -> 0:10
[    4.067555] IRQ11 -> 0:11
[    4.068678] IRQ12 -> 0:12
[    4.069464] IRQ13 -> 0:13
[    4.070438] IRQ14 -> 0:14
[    4.071571] IRQ15 -> 0:15
[    4.072720] .................................... done.
[    4.074903] registered taskstats version 1
[    4.077382] rtc-test rtc-test.0: setting system clock to 2013-09-09 06:44:08 UTC (1378709048)
[    4.081688] debug: unmapping init [mem 0xffffffff81df2000-0xffffffff81ec3fff]
/bin/sh: /proc/self/fd/9: No such file or directory
[    4.148224] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    4.150690] IP: [<          (null)>]           (null)
[    4.152050] PGD 6a79067 PUD 69d3067 PMD 0
[    4.152125] Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    4.152125] CPU: 0 PID: 130 Comm: sh Not tainted 3.11.0-rc2-00010-gc817a67-dirty #7
[    4.152125] task: ffff880006a5e980 ti: ffff880006a3e000 task.ti: ffff880006a3e000
[    4.152125] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[    4.152125] RSP: 0018:ffff88000dc03e40  EFLAGS: 00010286
[    4.152125] RAX: 0000000000000001 RBX: 0000000000000102 RCX: 0000000000000000
[    4.152125] RDX: 0000000000000f13 RSI: 0000000000000000 RDI: 0000000000000000
[    4.152125] RBP: ffff88000dc03e98 R08: 000000000000160f R09: ffff88000dc0a000
[    4.152125] R10: ffff88000dc0a000 R11: ffff880006a5e980 R12: ffff880006a3ffd8
[    4.152125] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff81f347d8
[    4.152125] FS:  00007fe94d7b4700(0000) GS:ffff88000dc00000(0000) knlGS:0000000000000000
[    4.152125] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.152125] CR2: 0000000000000000 CR3: 0000000006a49000 CR4: 00000000000006b0
[    4.152125] Stack:
[    4.152125]  ffffffff810989e6 ffffffff8109897b ffffffff810c73b8 ffff88000dc03e58
[    4.152125]  ffffffff821cbe60 0000000000000000 0000000000000000 ffffffff81f33780
[    4.152125]  ffff88000dc03ec8 ffffffff81f34fd8 ffffffff81f34bd8 ffff88000dc03f08
[    4.152125] Call Trace:
[    4.152125]  <IRQ>
[    4.152125]  [<ffffffff810989e6>] ? call_timer_fn+0x6b/0xde
[    4.152125]  [<ffffffff8109897b>] ? detach_timer+0x46/0x46
[    4.152125]  [<ffffffff810c73b8>] ? trace_hardirqs_on_caller+0x13a/0x18b
[    4.152125]  [<ffffffff81098fcb>] run_timer_softirq+0x187/0x1cf
[    4.152125]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
[    4.152125]  [<ffffffff811264a7>] ? unlazy_walk+0x125/0x172
[    4.152125]  [<ffffffff81095745>] irq_exit+0x58/0x9e
[    4.152125]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
[    4.152125]  [<ffffffff818547b2>] apic_timer_interrupt+0x72/0x80
[    4.152125]  <EOI>
[    4.152125]  [<ffffffff810c563d>] ? arch_local_irq_restore+0x6/0xd
[    4.152125]  [<ffffffff810c9235>] lock_release+0x16e/0x17a
[    4.152125]  [<ffffffff81852754>] _raw_spin_unlock+0x1b/0x4f
[    4.152125]  [<ffffffff811264a7>] unlazy_walk+0x125/0x172
[    4.152125]  [<ffffffff81128578>] do_last+0x6cc/0x9b5
[    4.152125]  [<ffffffff81126108>] ? inode_permission+0x3d/0x3f
[    4.152125]  [<ffffffff81128a8b>] path_openat+0x22a/0x48d
[    4.152125]  [<ffffffff81128d23>] do_filp_open+0x35/0x85
[    4.152125]  [<ffffffff811337e9>] ? __alloc_fd+0xd8/0xea
[    4.152125]  [<ffffffff8111d932>] do_sys_open+0x6b/0xfd
[    4.152125]  [<ffffffff810c73d2>] ? trace_hardirqs_on_caller+0x154/0x18b
[    4.152125]  [<ffffffff8111d9dd>] SyS_open+0x19/0x1b
[    4.152125]  [<ffffffff81853b29>] system_call_fastpath+0x16/0x1b
[    4.152125] Code:  Bad RIP value.
[    4.152125] RIP  [<          (null)>]           (null)
[    4.152125]  RSP <ffff88000dc03e40>
[    4.152125] CR2: 0000000000000000
[    4.232197] ---[ end trace 97326ccec203fce2 ]---
[    4.233576] Kernel panic - not syncing: Fatal exception in interrupt
[    4.235729] Rebooting in 10 seconds..%                                                                                                  wfg@bee ~/linux/obj-compiletest%
wfg@bee ~/linux/obj-compiletest%
wfg@bee ~/linux/obj-compiletest% kvm-0day.sh arch/x86/boot/bzImage
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc2-00010-gc817a67-dirty (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #7 SMP PREEMPT Tue Oct 8 10:27:55 CST 2013
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
[    0.000000] BRK [0x0289b000, 0x0289bfff] PGTABLE
[    0.000000] BRK [0x0289c000, 0x0289cfff] PGTABLE
[    0.000000] BRK [0x0289d000, 0x0289dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x0289e000, 0x0289efff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x0289f000, 0x0289ffff] PGTABLE
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
[    0.000000] Memory: 199116K/261744K available (8533K kernel code, 1781K rwdata, 3952K rodata, 840K init, 10060K bss, 62628K reserved)
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
[    0.008013] pid_max: default: 32768 minimum: 301
[    0.009447] Mount-cache hash table entries: 256
[    0.011082] Initializing cgroup subsys devices
[    0.012040] Initializing cgroup subsys perf_event
[    0.013186] Initializing cgroup subsys net_prio
[    0.014393] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014393] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014393] tlb_flushall_shift: 6
[    0.016045] debug: unmapping init [mem 0xffffffff81ec4000-0xffffffff81ec7fff]
[    0.021105] ACPI: Core revision 20130517
[    0.025144] ACPI: All ACPI Tables successfully acquired
[    0.026799] Getting VERSION: 50014
[    0.027707] Getting VERSION: 50014
[    0.028020] Getting ID: 0
[    0.028621] Getting ID: ff000000
[    0.029360] Getting LVT0: 8700
[    0.030049] Getting LVT1: 8400
[    0.030822] enabled ExtINT on CPU#0
[    0.033395] ENABLING IO-APIC IRQs
[    0.034346] init IO_APIC IRQs
[    0.035020]  apic 0 pin 0 not connected
[    0.036048] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.037837] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.039645] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.040043] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.041833] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.044039] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.045813] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.048039] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.049799] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.052040] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.053986] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.056043] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.057928] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.060039] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.061941] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.064036]  apic 0 pin 16 not connected
[    0.064968]  apic 0 pin 17 not connected
[    0.065954]  apic 0 pin 18 not connected
[    0.066828]  apic 0 pin 19 not connected
[    0.068010]  apic 0 pin 20 not connected
[    0.068877]  apic 0 pin 21 not connected
[    0.069731]  apic 0 pin 22 not connected
[    0.070475]  apic 0 pin 23 not connected
[    0.071241] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.072009] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.073733] Using local APIC timer interrupts.
[    0.073733] calibrating APIC timer ...
[    0.080000] ... lapic delta = 6242035
[    0.080000] ... PM-Timer delta = 357505
[    0.080000] ... PM-Timer result ok
[    0.080000] ..... delta 6242035
[    0.080000] ..... mult: 268093361
[    0.080000] ..... calibration result: 3994902
[    0.080000] ..... CPU clock speed is 2689.3863 MHz.
[    0.080000] ..... host bus clock speed is 998.2902 MHz.
[    0.080077] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.108596] SMP alternatives: lockdep: fixing up alternatives
[    0.109922] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:e896041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.132170] KVM setup async PF for cpu 1
[    0.132270] Brought up 2 CPUs
[    0.132275] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.135179] kvm-stealtime: cpu 1, msr dd0ccc0
[    0.140416] devtmpfs: initialized
[    0.142118] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.144630] regulator-dummy: no parameters
[    0.145887] NET: Registered protocol family 16
[    0.148156] ACPI: bus type PCI registered
[    0.148927] PCI: Using configuration type 1 for base access
[    0.158899] ACPI: Added _OSI(Module Device)
[    0.160011] ACPI: Added _OSI(Processor Device)
[    0.161050] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.162085] ACPI: Added _OSI(Processor Aggregator Device)
[    0.166260] ACPI: EC: Look up EC in DSDT
[    0.174299] ACPI: Interpreter enabled
[    0.175182] ACPI: (supports S0 S5)
[    0.175698] ACPI: Using IOAPIC for interrupt routing
[    0.176036] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.188497] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.190627] PCI host bridge to bus 0000:00
[    0.191684] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.192014] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.193390] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.196013] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.197617] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.199590] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.200629] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.202338] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.206610] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.209944] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.212668] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.214520] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.216499] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.221064] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.228133] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.245207] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.247246] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.249324] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.252938] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.261831] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.264052] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.266157] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.268009] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.274767] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.276631] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.280994] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.290168] pci_bus 0000:00: on NUMA node 0
[    0.292040] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.294438] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.297996] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.300815] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.303150] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.304868] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.308095] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.311258] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.312027] ACPI: \_SB_.PCI0: notify handler is installed
[    0.313672] Found 1 acpi root devices
[    0.320180] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.324012] vgaarb: loaded
[    0.324942] vgaarb: bridge control possible 0000:00:02.0
[    0.326577] ACPI: bus type USB registered
[    0.328086] usbcore: registered new interface driver usbfs
[    0.329401] usbcore: registered new interface driver hub
[    0.330751] usbcore: registered new device driver usb
[    0.332186] pps_core: LinuxPPS API ver. 1 registered
[    0.333379] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.336036] PTP clock support registered
[    0.337282] wmi: Mapper loaded
[    0.338126] PCI: Using ACPI for IRQ routing
[    0.339103] PCI: pci_cache_line_size set to 64 bytes
[    0.340227] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.341626] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.344430] NET: Registered protocol family 23
[    0.347044] cfg80211: Calling CRDA to update world regulatory domain
[    0.348170] nfc: nfc_init: NFC Core ver 0.1
[    0.349287] NET: Registered protocol family 39
[    0.352924] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.356123] Switched to clocksource kvm-clock
[    0.357412] pnp: PnP ACPI init
[    0.358282] ACPI: bus type PNP registered
[    0.359160] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.361010] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.362434] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.364287] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.365743] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.367443] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.368897] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.371084] pnp 00:03: [dma 2]
[    0.371947] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.373809] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.375906] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.379144] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.386558] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.391797] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.393617] pnp: PnP ACPI: found 7 devices
[    0.394610] ACPI: bus type PNP unregistered
[    0.401317] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.402611] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.403452] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.404404] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.405883] NET: Registered protocol family 2
[    0.407144] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    0.408310] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.410062] TCP: Hash tables configured (established 2048 bind 2048)
[    0.411432] TCP: reno registered
[    0.411972] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.412976] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.414307] NET: Registered protocol family 1
[    0.415674] RPC: Registered named UNIX socket transport module.
[    0.417200] RPC: Registered udp transport module.
[    0.418367] RPC: Registered tcp transport module.
[    0.419571] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.421313] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.422921] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.424520] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.426125] pci 0000:00:02.0: Boot video device
[    0.427383] PCI: CLS 0 bytes, default 64
[    0.428658] Unpacking initramfs...
[    1.937139] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    1.940170] has_svm: not amd
[    1.941064] kvm: no hardware support
[    1.942589] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    1.945248] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    1.953193] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    1.955841] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.957503] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.957615] cryptomgr_test (24) used greatest stack depth: 6320 bytes left
[    1.961137] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.962727] AVX or AES-NI instructions are not detected.
[    1.963998] AVX instructions are not detected.
[    1.965207] AVX instructions are not detected.
[    1.966338] AVX instructions are not detected.
[    1.969296] Initializing RT-Tester: OK
[    1.970231] audit: initializing netlink socket (disabled)
[    1.971942] type=2000 audit(1378709043.501:1): initialized
[    1.975586] DLM installed
[    1.977216] NFS: Registering the id_resolver key type
[    1.978556] Key type id_resolver registered
[    1.979648] Key type id_legacy registered
[    1.980757] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.982798] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.983943] fuse init (API version 7.22)
[    1.985471] ceph: loaded (mds proto 32)
[    1.987580] cryptomgr_test (43) used greatest stack depth: 5768 bytes left
[    1.989620] cryptomgr_test (44) used greatest stack depth: 5696 bytes left
[    1.998677] cryptomgr_test (72) used greatest stack depth: 5280 bytes left
[    2.001949] alg: No test for crc32 (crc32-table)
[    2.005977] alg: No test for lz4hc (lz4hc-generic)
[    2.007137] alg: No test for stdrng (krng)
[    2.008298] NET: Registered protocol family 38
[    2.008811] Key type asymmetric registered
[    2.009312] Asymmetric key parser 'x509' registered
[    2.009830] test_string_helpers: Running tests...
[    2.011074] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    2.011692] crc32: self tests passed, processed 225944 bytes in 283371 nsec
[    2.012776] crc32c: CRC_LE_BITS = 32
[    2.013268] crc32c: self tests passed, processed 225944 bytes in 141787 nsec
[    2.014762] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    2.016140] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    2.017359] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    2.018525] vmlfb: initializing
[    2.019027] Could not find Carillo Ranch MCH device.
[    2.019840] no IO addresses supplied
[    2.020526] hgafb: HGA card not detected.
[    2.021145] hgafb: probe of hgafb.0 failed with error -22
[    2.022016] usbcore: registered new interface driver udlfb
[    2.022843] usbcore: registered new interface driver smscufx
[    2.024508] uvesafb: failed to execute /sbin/v86d
[    2.025338] uvesafb: make sure that the v86d helper is installed and executable
[    2.026422] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    2.027425] uvesafb: vbe_init() failed with -22
[    2.028150] uvesafb: probe of uvesafb.0 failed with error -22
[    2.029057] ipmi message handler version 39.2
[    2.029723] ipmi device interface
[    2.030291] IPMI System Interface driver.
[    2.030952] ipmi_si: Adding default-specified kcs state machine
[    2.031843] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    2.033350] ipmi_si: Interface detection failed
[    2.048164] ipmi_si: Adding default-specified smic state machine
[    2.049596] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    2.051474] ipmi_si: Interface detection failed
[    2.064101] ipmi_si: Adding default-specified bt state machine
[    2.065300] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    2.066851] ipmi_si: Interface detection failed
[    2.080186] kobject: 'ipmi_si' (ffff8800077f7e00): kobject_release, parent ffff8800001b7648 (delayed)
[    2.081342] kobject: 'ipmi_si' (ffff8800077f7c00): kobject_release, parent ffff880000221248 (delayed)
[    2.082904] kobject: 'ipmi_si' (ffff8800077ac000): kobject_release, parent ffff880000189248 (delayed)
[    2.084535] ipmi_si: Unable to find any System Interface(s)
[    2.085575] IPMI Watchdog: driver initialized
[    2.086332] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    2.088071] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.089310] ACPI: Power Button [PWRF]
[    2.165079] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.188058] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.190920] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    2.191994] ac.o: No PCI boards found.
[    2.192628] ac.o: For an ISA board you must supply memory and irq parameters.
[    2.193943] Non-volatile memory driver v1.3
[    2.194910] Linux agpgart interface v0.103
[    2.196347] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    2.197808] kobject: 'drm' (ffff880006dae048): kobject_release, parent ffff880000189648 (delayed)
[    2.200148] kobject: 'drm' (ffff880006dab000): kobject_release, parent           (null) (delayed)
[    2.201608] [drm] radeon kernel modesetting enabled.
[    2.203146] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
[    2.204081] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/dri.
[    2.205582] kobject: 'controlD64' (ffff880006dc2820): kobject_release, parent           (null) (delayed)
[    2.207100] cirrus: probe of 0000:00:02.0 failed with error -1
[    2.208322] usbcore: registered new interface driver udl
[    2.209850] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.211532] dummy-irq: no IRQ given.  Use irq=N
[    2.212696] Phantom Linux Driver, version n0.9.8, init OK
[    2.214286] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    2.216162] c2port c2port0: C2 port uc added
[    2.217203] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    2.219100] Guest personality initialized and is inactive
[    2.220548] VMCI host device registered (name=vmci, major=10, minor=56)
[    2.222014] Initialized host personality
[    2.223058] Driver for timberdale has been successfully registered.
[    2.224809] usbcore: registered new interface driver viperboard
[    2.226434] usbcore: registered new interface driver pn533
[    2.228478] mtdoops: mtd device (mtddev=name/number) must be supplied
[    2.230272] device id = 2440
[    2.231001] device id = 2480
[    2.231682] device id = 24c0
[    2.232432] device id = 24d0
[    2.233253] device id = 25a1
[    2.233901] device id = 2670
[    2.234699] platform physmap-flash.0: failed to claim resource 0
[    2.236045] kobject: 'physmap-flash' (ffff880006dd5000): kobject_release, parent ffff880000189248 (delayed)
[    2.238256] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    2.239864] Could not find PAR responsible for SC520CDP Flash Bank #0
[    2.241650] Trying default address 0x8400000
[    2.242792] Could not find PAR responsible for SC520CDP Flash Bank #1
[    2.244485] Trying default address 0x8c00000
[    2.245579] Could not find PAR responsible for SC520CDP DIL Flash
[    2.247104] Trying default address 0x9400000
[    2.248231] SC520 CDP flash device: 0x800000 at 0x8400000
[    2.249579] Failed to ioremap_nocache
[    2.250530] Failed to ioremap_nocache
[    2.251478] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.253207] kobject: 'docg3' (ffff880006ddb400): kobject_release, parent ffff880000189248 (delayed)
[    2.255561] slram: not enough parameters.
[    2.260305] No valid DiskOnChip devices found
[    2.261608] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.263927] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.266430] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.268896] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.271362] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.273761] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.276167] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    2.282762] flash size: 128 MiB
[    2.283600] page size: 512 bytes
[    2.284393] OOB area size: 16 bytes
[    2.285319] sector size: 16 KiB
[    2.286201] pages number: 262144
[    2.286981] pages per sector: 32
[    2.287759] bus width: 8
[    2.288455] bits in sector size: 14
[    2.289303] bits in page size: 9
[    2.290148] bits in OOB size: 4
[    2.290946] flash size with OOB: 135168 KiB
[    2.292122] page address bytes: 4
[    2.292978] sector address bytes: 3
[    2.293844] options: 0x42
[    2.298034] Scanning device for bad blocks
[    2.347896] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    2.349873] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    2.352853] usbcore: registered new interface driver irda-usb
[    2.552866] usbcore: registered new interface driver stir4200
[    2.554086] usbcore: registered new interface driver mcs7780
[    2.555016] usbcore: registered new interface driver kingsun-sir
[    2.556033] usbcore: registered new interface driver ksdazzle-sir
[    2.556995] usbcore: registered new interface driver ks959-sir
[    2.558259] usbcore: registered new interface driver hwa-rc
[    2.559227] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.560178] ohci-pci: OHCI PCI platform driver
[    2.560884] ohci-platform: OHCI generic platform driver
[    2.561757] uhci_hcd: USB Universal Host Controller Interface driver
[    2.562890] driver u132_hcd
[    2.563922] usbcore: registered new interface driver hwa-hc
[    2.565373] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    2.566946] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    2.571165] usbcore: registered new interface driver cdc_wdm
[    2.572279] usbcore: registered new interface driver usbtmc
[    2.573438] usbcore: registered new interface driver appledisplay
[    2.574920] usbcore: registered new interface driver emi26 - firmware loader
[    2.576820] usbcore: registered new interface driver emi62 - firmware loader
[    2.578657] driver ftdi-elan
[    2.580105] usbcore: registered new interface driver ftdi-elan
[    2.581698] usbcore: registered new interface driver idmouse
[    2.583182] usbcore: registered new interface driver usblcd
[    2.584822] usbcore: registered new interface driver ldusb
[    2.586288] usbcore: registered new interface driver usbled
[    2.587807] usbcore: registered new interface driver legousbtower
[    2.589505] usbcore: registered new interface driver rio500
[    2.591166] usbcore: registered new interface driver usbtest
[    2.593097] usbcore: registered new interface driver trancevibrator
[    2.594884] usbcore: registered new interface driver yurex
[    2.596526] kobject: 'gpio-vbus' (ffff88000682a200): kobject_release, parent ffff880000189248 (delayed)
[    2.599292] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.602181] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.603098] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.676760] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    2.679796] kobject: '(null)' (ffff8800068422f0): kobject_release, parent           (null) (delayed)
[    2.682464] usbcore: registered new interface driver bcm5974
[    2.684357] usbcore: registered new interface driver synaptics_usb
[    2.686494] usbcore: registered new interface driver iforce
[    2.689974] usbcore: registered new interface driver usbtouchscreen
[    2.692567] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    2.693934] usbcore: registered new interface driver ati_remote2
[    2.695557] cm109: Keymap for Komunikate KIP1000 phone loaded
[    2.697256] usbcore: registered new interface driver cm109
[    2.698847] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    2.700883] usbcore: registered new interface driver keyspan_remote
[    2.704954] usbcore: registered new interface driver yealink
[    2.706697] I2O subsystem v1.325
[    2.707620] i2o: max drivers = 8
[    2.709016] I2O Configuration OSM v1.323
[    2.710199] I2O ProcFS OSM v1.316
[    2.711350] kobject: 'proc-osm' (ffff88000685dc00): kobject_release, parent ffff880006858648 (delayed)
[    2.714280] kobject: 'mc13xxx-rtc' (ffff880006863c00): kobject_release, parent ffff880000189248 (delayed)
[    2.717277] kobject: 'rtc-msm6242' (ffff880006863a00): kobject_release, parent ffff880000189248 (delayed)
[    2.719830] kobject: 'pcap-rtc' (ffff880006863800): kobject_release, parent ffff880000189248 (delayed)
[    2.722497] kobject: 'rtc-rp5c01' (ffff880006865800): kobject_release, parent ffff880000189248 (delayed)
[    2.725931] rtc rtc0: test: dev (254:0)
[    2.726994] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    2.729203] rtc rtc1: test: dev (254:1)
[    2.730252] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    2.731905] i2c /dev entries driver
[    2.733417] usbcore: registered new interface driver i2c-diolan-u2c
[    2.735020] i2c-parport-light: adapter type unspecified
[    2.736792] pps pps0: new PPS source ktimer
[    2.737965] pps pps0: ktimer PPS source registered
[    2.739307] Driver for 1-wire Dallas network protocol.
[    2.740760] usbcore: registered new interface driver DS9490R
[    2.742116] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.743859] power_supply test_ac: uevent
[    2.744810] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    2.745669] power_supply test_ac: prop ONLINE=1
[    2.746413] power_supply test_ac: power_supply_changed
[    2.747626] power_supply test_ac: power_supply_changed_work
[    2.749078] power_supply test_ac: power_supply_update_gen_leds 1
[    2.749222] power_supply test_battery: uevent
[    2.749224] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    2.749247] power_supply test_battery: prop STATUS=Discharging
[    2.749252] power_supply test_battery: prop CHARGE_TYPE=Fast
[    2.749255] power_supply test_battery: prop HEALTH=Good
[    2.749259] power_supply test_battery: prop PRESENT=1
[    2.749262] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    2.749266] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    2.749269] power_supply test_battery: prop CHARGE_FULL=100
[    2.749272] power_supply test_battery: prop CHARGE_NOW=50
[    2.749275] power_supply test_battery: prop CAPACITY=50
[    2.749279] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    2.749282] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    2.749285] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    2.749289] power_supply test_battery: prop MODEL_NAME=Test battery
[    2.749292] power_supply test_battery: prop MANUFACTURER=Linux
[    2.749295] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    2.749299] power_supply test_battery: prop TEMP=26
[    2.749302] power_supply test_battery: prop VOLTAGE_NOW=3300
[    2.749618] power_supply test_battery: power_supply_changed
[    2.749635] power_supply test_battery: power_supply_changed_work
[    2.749640] power_supply test_battery: power_supply_update_bat_leds 2
[    2.749652] power_supply test_battery: uevent
[    2.749660] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    2.749675] power_supply test_battery: prop STATUS=Discharging
[    2.749680] power_supply test_battery: prop CHARGE_TYPE=Fast
[    2.749683] power_supply test_battery: prop HEALTH=Good
[    2.749687] power_supply test_battery: prop PRESENT=1
[    2.749690] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    2.749694] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    2.749698] power_supply test_battery: prop CHARGE_FULL=100
[    2.749701] power_supply test_battery: prop CHARGE_NOW=50
[    2.749705] power_supply test_battery: prop CAPACITY=50
[    2.749708] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    2.749712] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    2.749715] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    2.749719] power_supply test_battery: prop MODEL_NAME=Test battery
[    2.749722] power_supply test_battery: prop MANUFACTURER=Linux
[    2.749726] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    2.749730] power_supply test_battery: prop TEMP=26
[    2.749733] power_supply test_battery: prop VOLTAGE_NOW=3300
[    2.749790] power_supply test_usb: uevent
[    2.749792] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    2.749798] power_supply test_usb: prop ONLINE=1
[    2.749811] power_supply test_usb: power_supply_changed
[    2.749840] power_supply test_usb: power_supply_changed_work
[    2.749845] power_supply test_usb: power_supply_update_gen_leds 1
[    2.749851] power_supply test_usb: uevent
[    2.749853] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    2.749861] power_supply test_usb: prop ONLINE=1
[    2.750803] applesmc: supported laptop not found!
[    2.750804] applesmc: driver init failed (ret=-19)!
[    2.751254] f71882fg: Not a Fintek device
[    2.751346] f71882fg: Not a Fintek device
[    2.752239] kobject: 'mc13783-adc' (ffff8800068a3000): kobject_release, parent ffff880000189248 (delayed)
[    2.752591] pc87360: PC8736x not detected, module not inserted
[    2.753560] cpuidle: using governor ladder
[    2.753563] cpuidle: using governor menu
[    2.753599] sdhci: Secure Digital Host Controller Interface driver
[    2.753601] sdhci: Copyright(c) Pierre Ossman
[    2.824230] power_supply test_ac: uevent
[    2.824541] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    2.824541] usbcore: registered new interface driver vub300
[    2.824574] usbcore: registered new interface driver ushc
[    2.824575] sdhci-pltfm: SDHCI platform and OF driver helper
[    2.825277] ledtrig-cpu: registered to indicate activity on CPUs
[    2.825595] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    2.826803] usbcore: registered new interface driver usbhid
[    2.826804] usbhid: USB HID core driver
[    2.826870] usbip_core: usbip_core_init:804: USB/IP Core v1.0.0
[    2.827108] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    2.827125] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    2.827198] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 1
[    2.827215] vhci_hcd: vhci_start:884: enter vhci_start
[    2.828084] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.828087] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.828089] usb usb1: Product: USB/IP Virtual Host Controller
[    2.828091] usb usb1: Manufacturer: Linux 3.11.0-rc2-00010-gc817a67-dirty vhci_hcd
[    2.828093] usb usb1: SerialNumber: vhci_hcd
[    2.828896] hub 1-0:1.0: USB hub found
[    2.828932] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIndex 0
[    2.828978] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
[    2.828980] vhci_hcd: vhci_hub_control:398: port -1
[    2.828982] vhci_hcd: vhci_hub_control:405:  bye
[    2.829006] hub 1-0:1.0: 8 ports detected
[    2.829087] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex 0
[    2.829096] vhci_hcd: vhci_hub_control:309:  GetHubStatus
[    2.829098] vhci_hcd: vhci_hub_control:398: port -1
[    2.829100] vhci_hcd: vhci_hub_control:405:  bye
[    2.829683] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 1
[    2.829686] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.829687] vhci_hcd: vhci_hub_control:398: port 0
[    2.829689] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.829691] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.829692] vhci_hcd: dump_port_status_diff:119:
[    2.829693] vhci_hcd: vhci_hub_control:405:  bye
[    2.829701] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 2
[    2.829703] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.829704] vhci_hcd: vhci_hub_control:398: port 1
[    2.829706] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.829707] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.829708] vhci_hcd: dump_port_status_diff:119:
[    2.829710] vhci_hcd: vhci_hub_control:405:  bye
[    2.829716] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 3
[    2.829718] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.829719] vhci_hcd: vhci_hub_control:398: port 2
[    2.829721] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.829722] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.829723] vhci_hcd: dump_port_status_diff:119:
[    2.829725] vhci_hcd: vhci_hub_control:405:  bye
[    2.829731] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 4
[    2.829733] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.829734] vhci_hcd: vhci_hub_control:398: port 3
[    2.829736] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.829737] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.829738] vhci_hcd: dump_port_status_diff:119:
[    2.829740] vhci_hcd: vhci_hub_control:405:  bye
[    2.829746] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 5
[    2.829748] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.829749] vhci_hcd: vhci_hub_control:398: port 4
[    2.829755] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.829757] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.829758] vhci_hcd: dump_port_status_diff:119:
[    2.829759] vhci_hcd: vhci_hub_control:405:  bye
[    2.829766] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 6
[    2.829768] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.829769] vhci_hcd: vhci_hub_control:398: port 5
[    2.829771] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.829775] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.829776] vhci_hcd: dump_port_status_diff:119:
[    2.829777] vhci_hcd: vhci_hub_control:405:  bye
[    2.829784] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 7
[    2.829786] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.829787] vhci_hcd: vhci_hub_control:398: port 6
[    2.829789] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.829790] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.829791] vhci_hcd: dump_port_status_diff:119:
[    2.829792] vhci_hcd: vhci_hub_control:405:  bye
[    2.829799] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 8
[    2.829801] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.829802] vhci_hcd: vhci_hub_control:398: port 7
[    2.829804] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.829805] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.829806] vhci_hcd: dump_port_status_diff:119:
[    2.829807] vhci_hcd: vhci_hub_control:405:  bye
[    2.830065] vhci_hcd: vhci_hcd_probe:1034: bye
[    2.830072] vhci_hcd: vhci_hcd_init:1156: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.0.0
[    2.939166] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    2.939215] usbcore: registered new interface driver usbip-host
[    2.939218] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
[    2.939237] usbcore: registered new interface driver tranzport
[    2.939250] usbcore: registered new interface driver alphatrack
[    2.939251] vme_user: VME User Space Access Driver
[    2.939252] vme_user: No cards, skipping registration
[    2.940118] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 1
[    2.940120] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 1
[    2.940121] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.940123] vhci_hcd: vhci_hub_control:398: port 0
[    2.940124] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.940125] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.940126] vhci_hcd: dump_port_status_diff:119:
[    2.940127] vhci_hcd: vhci_hub_control:405:  bye
[    2.940135] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 2
[    2.940136] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 2
[    2.940137] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.940138] vhci_hcd: vhci_hub_control:398: port 1
[    2.940139] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.940140] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.940141] vhci_hcd: dump_port_status_diff:119:
[    2.940141] vhci_hcd: vhci_hub_control:405:  bye
[    2.940146] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 3
[    2.940147] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 3
[    2.940148] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.940149] vhci_hcd: vhci_hub_control:398: port 2
[    2.940150] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.940151] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.940152] vhci_hcd: dump_port_status_diff:119:
[    2.940152] vhci_hcd: vhci_hub_control:405:  bye
[    2.940157] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 4
[    2.940162] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 4
[    2.940163] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.940164] vhci_hcd: vhci_hub_control:398: port 3
[    2.940165] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.940166] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.940167] vhci_hcd: dump_port_status_diff:119:
[    2.940168] vhci_hcd: vhci_hub_control:405:  bye
[    2.940172] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 5
[    2.940174] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 5
[    2.940174] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.940175] vhci_hcd: vhci_hub_control:398: port 4
[    2.940176] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.940177] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.940178] vhci_hcd: dump_port_status_diff:119:
[    2.940179] vhci_hcd: vhci_hub_control:405:  bye
[    2.940183] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 6
[    2.940184] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 6
[    2.940185] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.940186] vhci_hcd: vhci_hub_control:398: port 5
[    2.940187] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.940187] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.940188] vhci_hcd: dump_port_status_diff:119:
[    2.940189] vhci_hcd: vhci_hub_control:405:  bye
[    2.940193] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 7
[    2.940194] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 7
[    2.940195] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.940196] vhci_hcd: vhci_hub_control:398: port 6
[    2.940197] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.940198] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.940199] vhci_hcd: dump_port_status_diff:119:
[    2.940199] vhci_hcd: vhci_hub_control:405:  bye
[    2.940204] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 8
[    2.940205] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 8
[    2.940206] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.940206] vhci_hcd: vhci_hub_control:398: port 7
[    2.940207] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.940208] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.940209] vhci_hcd: dump_port_status_diff:119:
[    2.940210] vhci_hcd: vhci_hub_control:405:  bye
[    2.940386] usb usb1: vhci_bus_suspend
[    2.940394] vhci_hcd: vhci_hub_status:208: changed 0
[    2.940453] Loading crystalhd 0.9.27
[    2.940511] usbcore: registered new interface driver ft1000usb
[    2.940582] usbcore: registered new interface driver gdm_wimax
[    2.940595] usbcore: registered new interface driver cedusb
[    3.037252] ipip: IPv4 over IPv4 tunneling driver
[    3.038634] gre: GRE over IPv4 demultiplexor driver
[    3.039680] IPv4 over IPSec tunneling driver
[    3.040382] power_supply test_ac: prop ONLINE=1
[    3.042993] tsc: Refined TSC clocksource calibration: 2693.469 MHz
[    3.045459] TCP: cubic registered
[    3.047561] NET: Registered protocol family 17
[    3.049203] NET: Registered protocol family 9
[    3.050344] X.25 for Linux Version 0.2
[    3.051897] NET: Registered protocol family 33
[    3.053095] Key type rxrpc registered
[    3.053960] Key type rxrpc_s registered
[    3.055341] RxRPC: Registered security type 2 'rxkad'
[    3.056193] l2tp_core: L2TP core driver, V2.0
[    3.056871] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    3.058166] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    3.059210] NET: Registered protocol family 12
[    3.068430] 8021q: 802.1Q VLAN Support v1.8
[    3.069843] sctp: Hash tables configured (established 1024 bind 1024)
[    3.071838] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[    3.072998] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[    3.074188] NET: Registered protocol family 37
[    3.075095] NET: Registered protocol family 36
[    3.076313] Key type dns_resolver registered
[    3.077322] Key type ceph registered
[    3.078464] libceph: loaded (mon/osd proto 15/24)
[    3.079510] mpls_gso: MPLS GSO support
[    3.080923]
[    3.080923] printing PIC contents
[    3.082253] ... PIC  IMR: ffff
[    3.082888] ... PIC  IRR: 1013
[    3.083645] ... PIC  ISR: 0000
[    3.084547] ... PIC ELCR: 0c00
[    3.085356] printing local APIC contents on CPU#0/0:
[    3.086093] ... APIC ID:      00000000 (0)
[    3.086634] ... APIC VERSION: 00050014
[    3.087058] ... APIC TASKPRI: 00000000 (00)
[    3.087565] ... APIC PROCPRI: 00000000
[    3.088130] ... APIC LDR: 01000000
[    3.088710] ... APIC DFR: ffffffff
[    3.089268] ... APIC SPIV: 000001ff
[    3.089346] ... APIC ISR field:
[    3.089346] 0000000000000000000000000000000000000000000000000000000000000000
[    3.089346] ... APIC TMR field:
[    3.089346] 0000000000000000000000000000000000000000000000000000000000000000
[    3.089346] ... APIC IRR field:
[    3.089346] 0000000000000000000000000000000000000000000000000000000020008000
[    3.089346] ... APIC ESR: 00000000
[    3.089346] ... APIC ICR: 000008fd
[    3.089346] ... APIC ICR2: 02000000
[    3.089346] ... APIC LVTT: 000000ef
[    3.089346] ... APIC LVTPC: 00010000
[    3.089346] ... APIC LVT0: 00010700
[    3.089346] ... APIC LVT1: 00000400
[    3.089346] ... APIC LVTERR: 000000fe
[    3.089346] ... APIC TMICT: 0003c539
[    3.089346] ... APIC TMCCT: 00000000
[    3.089346] ... APIC TDCR: 00000003
[    3.089346]
[    3.099108] number of MP IRQ sources: 15.
[    3.099695] number of IO-APIC #0 registers: 24.
[    3.100554] testing the IO APIC.......................
[    3.101486] IO APIC #0......
[    3.102232] .... register #00: 00000000
[    3.103210] .......    : physical APIC id: 00
[    3.104260] .......    : Delivery Type: 0
[    3.105258] .......    : LTS          : 0
[    3.106252] .... register #01: 00170011
[    3.107181] .......     : max redirection entries: 17
[    3.108376] .......     : PRQ implemented: 0
[    3.109426] .......     : IO APIC version: 11
[    3.112151] .... register #02: 00000000
[    3.113124] .......     : arbitration: 00
[    3.114126] .... IRQ redirection table:
[    3.115123] 1    0    0   0   0    0    0    00
[    3.116365] 0    0    0   0   0    1    1    31
[    3.117415] 0    0    0   0   0    1    1    30
[    3.118418] 0    0    0   0   0    1    1    33
[    3.119452] 1    0    0   0   0    1    1    34
[    3.120578] 1    1    0   0   0    1    1    35
[    3.121576] 0    0    0   0   0    1    1    36
[    3.122682] 0    0    0   0   0    1    1    37
[    3.123851] 0    0    0   0   0    1    1    38
[    3.124860] 0    1    0   0   0    1    1    39
[    3.126224] 1    1    0   0   0    1    1    3A
[    3.127410] 1    1    0   0   0    1    1    3B
[    3.128610] 0    0    0   0   0    1    1    3C
[    3.129764] 0    0    0   0   0    1    1    3D
[    3.130891] 0    0    0   0   0    1    1    3E
[    3.131947] 0    0    0   0   0    1    1    3F
[    3.133061] 1    0    0   0   0    0    0    00
[    3.134148] 1    0    0   0   0    0    0    00
[    3.135197] 1    0    0   0   0    0    0    00
[    3.136368] 1    0    0   0   0    0    0    00
[    3.137129] 1    0    0   0   0    0    0    00
[    3.138203] 1    0    0   0   0    0    0    00
[    3.139233] 1    0    0   0   0    0    0    00
[    3.140246] 1    0    0   0   0    0    0    00
[    3.141433] IRQ to pin mappings:
[    3.142178] IRQ0 -> 0:2
[    3.142829] IRQ1 -> 0:1
[    3.143427] IRQ3 -> 0:3
[    3.143820] IRQ4 -> 0:4
[    3.144276] IRQ5 -> 0:5
[    3.144828] IRQ6 -> 0:6
[    3.145546] IRQ7 -> 0:7
[    3.146014] IRQ8 -> 0:8
[    3.146447] IRQ9 -> 0:9
[    3.146852] IRQ10 -> 0:10
[    3.147636] IRQ11 -> 0:11
[    3.148334] IRQ12 -> 0:12
[    3.148827] IRQ13 -> 0:13
[    3.149271] IRQ14 -> 0:14
[    3.149717] IRQ15 -> 0:15
[    3.150347] .................................... done.
[    3.151412] registered taskstats version 1
[    3.152819] rtc-test rtc-test.0: setting system clock to 2013-09-09 06:44:04 UTC (1378709044)
[    3.158378] debug: unmapping init [mem 0xffffffff81df2000-0xffffffff81ec3fff]
/bin/sh: /proc/self/fd/9: No such file or directory
[    3.204063] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    3.206657] IP: [<          (null)>]           (null)
[    3.207496] PGD 6a98067 PUD 6aa5067 PMD 0
[    3.208022] Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    3.208022] CPU: 0 PID: 126 Comm: umount Not tainted 3.11.0-rc2-00010-gc817a67-dirty #7
[    3.208022] task: ffff880006958840 ti: ffff880006a56000 task.ti: ffff880006a56000
[    3.208022] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[    3.208022] RSP: 0000:ffff88000dc03e40  EFLAGS: 00010286
[    3.208022] RAX: 0000000000000001 RBX: 0000000000000100 RCX: 0000000000000000
[    3.208022] RDX: 0000000000000f0d RSI: 0000000000000000 RDI: 0000000000000000
[    3.208022] RBP: ffff88000dc03e98 R08: 00000000000015dc R09: ffffffff81f4cc38
[    3.208022] R10: ffff88000dc0a000 R11: ffff880006958840 R12: ffff880006a57fd8
[    3.208022] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff81f347d8
[    3.208022] FS:  00007fe9c91fa800(0000) GS:ffff88000dc00000(0000) knlGS:0000000000000000
[    3.208022] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.208022] CR2: 0000000000000000 CR3: 0000000006a46000 CR4: 00000000000006b0
[    3.208022] Stack:
[    3.208022]  ffffffff810989e6 ffffffff8109897b ffffffff810c73b8 ffff88000dc03e58
[    3.208022]  ffffffff821cc1c0 0000000000000000 0000000000000000 ffffffff81f33780
[    3.208022]  ffff88000dc03ec8 ffffffff81f34fd8 ffffffff81f34bd8 ffff88000dc03f08
[    3.208022] Call Trace:
[    3.208022]  <IRQ>
[    3.208022]  [<ffffffff810989e6>] ? call_timer_fn+0x6b/0xde
[    3.208022]  [<ffffffff8109897b>] ? detach_timer+0x46/0x46
[    3.208022]  [<ffffffff810c73b8>] ? trace_hardirqs_on_caller+0x13a/0x18b
[    3.208022]  [<ffffffff81098fcb>] run_timer_softirq+0x187/0x1cf
[    3.208022]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
[    3.208022]  [<ffffffff81095745>] irq_exit+0x58/0x9e
[    3.208022]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
[    3.208022]  [<ffffffff818547b2>] apic_timer_interrupt+0x72/0x80
[    3.208022]  <EOI>
[    3.208022]  [<ffffffff8185329c>] ? retint_swapgs+0x13/0x1b
[    3.208022] Code:  Bad RIP value.
[    3.208022] RIP  [<          (null)>]           (null)
[    3.208022]  RSP <ffff88000dc03e40>
[    3.208022] CR2: 0000000000000000
[    3.250340] ---[ end trace d54c63bad898dedf ]---
[    3.251281] Kernel panic - not syncing: Fatal exception in interrupt
[    3.252675] Rebooting in 10 seconds..%                                                                                                  wfg@bee ~/linux/obj-compiletest%
