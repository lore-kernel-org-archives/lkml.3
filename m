Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3JHCKC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:10:02 -0400
Received: from mga03.intel.com ([143.182.124.21]:3229 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab3JHCJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:09:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1053,1371106800"; 
   d="scan'208";a="406950838"
Date: Tue, 8 Oct 2013 10:09:18 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131008020918.GA1220@localhost>
References: <20131006082340.GA24568@localhost>
 <CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
 <20131007021118.GA27927@localhost>
 <20131007051038.GA9764@localhost>
 <CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
 <20131007083505.GA22585@localhost>
 <CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
 <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 04:47:29PM -0700, Linus Torvalds wrote:
> On Mon, Oct 7, 2013 at 3:14 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I *think* r14 contains the function we're going to jump to in the
> > oops, and that could be interesting to know, but it's not decoded, so
> > you'd have to match it up against a symbol map...
> 
> Actually, Fenguguan, never mind. Instead, change the "pr_debug()" in
> kobject_release() to  "pr_alert()", so that it gets printed out. Or
> just boot with the "ignore_loglevel" thing so that debug messages are
> actually visible.
> 
> At that point, we should be able to match the oops workqueue list
> address with the address of the delayed kernel object that gets
> printed out.

Thanks for the hints! I run a kernel with pr_alert() for several times
and here is the screen log. Note that this kernel is compiled with gcc
4.6.3 and the decoded code looks different than gcc 4.8.1

wfg@bee ~/linux/obj-compiletest% kvm-0day.sh arch/x86/boot/bzImage
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc2-00010-gc817a67-dirty (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #5 SMP PREEMPT Tue Oct 8 09:29:02 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
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
[    0.000000] BRK [0x028a7000, 0x028a7fff] PGTABLE
[    0.000000] BRK [0x028a8000, 0x028a8fff] PGTABLE
[    0.000000] BRK [0x028a9000, 0x028a9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x028aa000, 0x028aafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x028ab000, 0x028abfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128416(97%)
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
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 199068K/261744K available (8557K kernel code, 1784K rwdata, 3968K rodata, 844K init, 10064K bss, 62676K reserved)
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
[    0.000000] ODEBUG: 5 of 5 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=10774032)
[    0.009066] pid_max: default: 32768 minimum: 301
[    0.011236] Mount-cache hash table entries: 256
[    0.012872] Initializing cgroup subsys devices
[    0.014450] Initializing cgroup subsys perf_event
[    0.016033] Initializing cgroup subsys net_prio
[    0.017679] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.017679] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.017679] tlb_flushall_shift: 6
[    0.020028] debug: unmapping init [mem 0xffffffff81ecf000-0xffffffff81ed2fff]
[    0.024212] ACPI: Core revision 20130517
[    0.028632] ACPI: All ACPI Tables successfully acquired
[    0.030673] Getting VERSION: 50014
[    0.031610] Getting VERSION: 50014
[    0.032029] Getting ID: 0
[    0.032626] Getting ID: ff000000
[    0.033747] Getting LVT0: 8700
[    0.034632] Getting LVT1: 8400
[    0.036125] enabled ExtINT on CPU#0
[    0.038413] ENABLING IO-APIC IRQs
[    0.040022] init IO_APIC IRQs
[    0.041140]  apic 0 pin 0 not connected
[    0.042378] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.044056] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.048053] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.050530] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.052026] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.054012] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.056023] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.060024] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.062168] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.064050] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.068049] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.072050] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.074942] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.076055] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.080055] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.082900]  apic 0 pin 16 not connected
[    0.084011]  apic 0 pin 17 not connected
[    0.085514]  apic 0 pin 18 not connected
[    0.086879]  apic 0 pin 19 not connected
[    0.088021]  apic 0 pin 20 not connected
[    0.089303]  apic 0 pin 21 not connected
[    0.092011]  apic 0 pin 22 not connected
[    0.093447]  apic 0 pin 23 not connected
[    0.094586] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.096004] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.100013] Using local APIC timer interrupts.
[    0.100013] calibrating APIC timer ...
[    0.104000] ... lapic delta = 6249724
[    0.104000] ... PM-Timer delta = 357882
[    0.104000] ... PM-Timer result ok
[    0.104000] ..... delta 6249724
[    0.104000] ..... mult: 268423601
[    0.104000] ..... calibration result: 3999823
[    0.104000] ..... CPU clock speed is 2692.2950 MHz.
[    0.104000] ..... host bus clock speed is 999.3823 MHz.
[    0.104149] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.132578] SMP alternatives: lockdep: fixing up alternatives
[    0.135434] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:e896041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.160289] Brought up 2 CPUs
[    0.160196] KVM setup async PF for cpu 1
[    0.160196] kvm-stealtime: cpu 1, msr dd0ccc0
[    0.162498] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.164526] devtmpfs: initialized
[    0.168645] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.171812] regulator-dummy: no parameters
[    0.172614] NET: Registered protocol family 16
[    0.176978] ACPI: bus type PCI registered
[    0.178107] PCI: Using configuration type 1 for base access
[    0.190156] ACPI: Added _OSI(Module Device)
[    0.192013] ACPI: Added _OSI(Processor Device)
[    0.193400] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.196012] ACPI: Added _OSI(Processor Aggregator Device)
[    0.200616] ACPI: EC: Look up EC in DSDT
[    0.210325] ACPI: Interpreter enabled
[    0.211686] ACPI: (supports S0 S5)
[    0.212005] ACPI: Using IOAPIC for interrupt routing
[    0.213282] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.232392] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.235713] PCI host bridge to bus 0000:00
[    0.236017] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.238057] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.240005] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.241843] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.244014] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.245551] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.248185] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.249736] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.254765] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.258583] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.260593] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.264036] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.266746] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.276091] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.281754] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.304115] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.309097] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.312981] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.317021] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.328994] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.332787] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.336015] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.341000] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.353015] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.356302] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.359664] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.368822] pci_bus 0000:00: on NUMA node 0
[    0.370569] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.372019] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.378316] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.381084] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.384839] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.388247] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.390642] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.393858] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.396038] ACPI: \_SB_.PCI0: notify handler is installed
[    0.398197] Found 1 acpi root devices
[    0.400620] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.404029] vgaarb: loaded
[    0.405007] vgaarb: bridge control possible 0000:00:02.0
[    0.408831] ACPI: bus type USB registered
[    0.410415] usbcore: registered new interface driver usbfs
[    0.412061] usbcore: registered new interface driver hub
[    0.414164] usbcore: registered new device driver usb
[    0.416253] pps_core: LinuxPPS API ver. 1 registered
[    0.418056] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.420056] PTP clock support registered
[    0.424409] wmi: Mapper loaded
[    0.426328] PCI: Using ACPI for IRQ routing
[    0.428014] PCI: pci_cache_line_size set to 64 bytes
[    0.430261] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.432036] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.437512] NET: Registered protocol family 23
[    0.441093] cfg80211: Calling CRDA to update world regulatory domain
[    0.444222] nfc: nfc_init: NFC Core ver 0.1
[    0.445891] NET: Registered protocol family 39
[    0.449152] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.452213] Switched to clocksource kvm-clock
[    0.454338] pnp: PnP ACPI init
[    0.455528] ACPI: bus type PNP registered
[    0.457259] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.460299] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.462761] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.465892] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.468487] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.471777] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.474050] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.477229] pnp 00:03: [dma 2]
[    0.478354] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.480320] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.482865] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.485939] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.488759] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.491673] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.494442] pnp: PnP ACPI: found 7 devices
[    0.496237] ACPI: bus type PNP unregistered
[    0.504585] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.505670] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.506622] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.507711] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.509116] NET: Registered protocol family 2
[    0.510402] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    0.511632] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.512980] TCP: Hash tables configured (established 2048 bind 2048)
[    0.514121] TCP: reno registered
[    0.514698] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.515833] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.517276] NET: Registered protocol family 1
[    0.518445] RPC: Registered named UNIX socket transport module.
[    0.519500] RPC: Registered udp transport module.
[    0.520316] RPC: Registered tcp transport module.
[    0.521159] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.522219] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.523259] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.524315] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.525435] pci 0000:00:02.0: Boot video device
[    0.526226] PCI: CLS 0 bytes, default 64
[    0.527222] Unpacking initramfs...
[    1.647752] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    1.650115] has_svm: not amd
[    1.650654] kvm: no hardware support
[    1.651625] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    1.653324] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    1.655634] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    1.655670] cryptomgr_test (24) used greatest stack depth: 6224 bytes left
[    1.658851] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.660033] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.661182] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    1.662331] AVX or AES-NI instructions are not detected.
[    1.663277] AVX instructions are not detected.
[    1.664104] AVX instructions are not detected.
[    1.664931] AVX instructions are not detected.
[    1.668096] Initializing RT-Tester: OK
[    1.668995] audit: initializing netlink socket (disabled)
[    1.670073] type=2000 audit(1378709045.825:1): initialized
[    1.673842] DLM installed
[    1.676043] NFS: Registering the id_resolver key type
[    1.677041] Key type id_resolver registered
[    1.677755] Key type id_legacy registered
[    1.678456] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.679806] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.680710] fuse init (API version 7.22)
[    1.682180] ceph: loaded (mds proto 32)
[    1.684622] cryptomgr_test (43) used greatest stack depth: 5768 bytes left
[    1.687992] cryptomgr_test (46) used greatest stack depth: 5616 bytes left
[    1.698638] cryptomgr_test (72) used greatest stack depth: 5352 bytes left
[    1.705046] alg: No test for crc32 (crc32-table)
[    1.707753] alg: No test for lz4hc (lz4hc-generic)
[    1.710661] alg: No test for stdrng (krng)
[    1.713037] NET: Registered protocol family 38
[    1.714107] Key type asymmetric registered
[    1.714910] Asymmetric key parser 'x509' registered
[    1.715619] test_string_helpers: Running tests...
[    1.718018] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    1.718935] crc32: self tests passed, processed 225944 bytes in 441140 nsec
[    1.720882] crc32c: CRC_LE_BITS = 32
[    1.721403] crc32c: self tests passed, processed 225944 bytes in 195229 nsec
[    1.723590] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    1.725086] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    1.726751] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    1.728443] vmlfb: initializing
[    1.728969] Could not find Carillo Ranch MCH device.
[    1.730096] no IO addresses supplied
[    1.731101] hgafb: HGA card not detected.
[    1.732351] hgafb: probe of hgafb.0 failed with error -22
[    1.733808] usbcore: registered new interface driver udlfb
[    1.735167] usbcore: registered new interface driver smscufx
[    1.737255] uvesafb: failed to execute /sbin/v86d
[    1.738281] uvesafb: make sure that the v86d helper is installed and executable
[    1.739709] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    1.740807] uvesafb: vbe_init() failed with -22
[    1.741591] uvesafb: probe of uvesafb.0 failed with error -22
[    1.742493] ipmi message handler version 39.2
[    1.743129] ipmi device interface
[    1.743742] IPMI System Interface driver.
[    1.744606] ipmi_si: Adding default-specified kcs state machine
[    1.745483] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    1.746917] ipmi_si: Interface detection failed
[    1.760183] ipmi_si: Adding default-specified smic state machine
[    1.760983] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    1.762260] ipmi_si: Interface detection failed
[    1.776202] ipmi_si: Adding default-specified bt state machine
[    1.777426] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    1.779129] ipmi_si: Interface detection failed
[    1.788358] kobject: 'ipmi_si' (ffff880007739a00): kobject_release, parent ffff8800001b7648 (delayed)
[    1.790616] kobject: 'ipmi_si' (ffff880007739800): kobject_release, parent ffff880000221248 (delayed)
[    1.792576] kobject: 'ipmi_si' (ffff880007739c00): kobject_release, parent ffff880000189248 (delayed)
[    1.794779] ipmi_si: Unable to find any System Interface(s)
[    1.795904] IPMI Watchdog: driver initialized
[    1.796583] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    1.798552] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.799694] ACPI: Power Button [PWRF]
[    1.901778] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.928423] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.931360] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    1.932976] ac.o: No PCI boards found.
[    1.934076] ac.o: For an ISA board you must supply memory and irq parameters.
[    1.937062] Non-volatile memory driver v1.3
[    1.938458] Linux agpgart interface v0.103
[    1.940360] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    1.941826] kobject: 'drm' (ffff880006dc3848): kobject_release, parent ffff880000189648 (delayed)
[    1.944395] kobject: 'drm' (ffff880006dbf000): kobject_release, parent           (null) (delayed)
[    1.947937] [drm] radeon kernel modesetting enabled.
[    1.950192] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
[    1.951997] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/dri.
[    1.955365] kobject: 'controlD64' (ffff880006dc3020): kobject_release, parent           (null) (delayed)
[    1.957033] cirrus: probe of 0000:00:02.0 failed with error -1
[    1.958426] usbcore: registered new interface driver udl
[    1.959998] parport_pc 00:04: reported by Plug and Play ACPI
[    1.961183] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    1.963179] kobject: 'parport_pc.956' (ffff880006dc3020): kobject_release, parent           (null) (delayed)
[    1.965619] kobject: 'parport_pc.888' (ffff880006dd8820): kobject_release, parent           (null) (delayed)
[    1.967935] kobject: 'parport_pc.632' (ffff880006dd8020): kobject_release, parent           (null) (delayed)
[    1.970185] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    1.971827] dummy-irq: no IRQ given.  Use irq=N
[    1.973640] Phantom Linux Driver, version n0.9.8, init OK
[    1.975286] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    1.977157] c2port c2port0: C2 port uc added
[    1.978013] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    1.980241] Guest personality initialized and is inactive
[    1.981607] VMCI host device registered (name=vmci, major=10, minor=56)
[    1.982867] Initialized host personality
[    1.983560] Driver for timberdale has been successfully registered.
[    1.984882] usbcore: registered new interface driver viperboard
[    1.986204] usbcore: registered new interface driver pn533
[    1.987343] mtdoops: mtd device (mtddev=name/number) must be supplied
[    1.988442] device id = 2440
[    1.988896] device id = 2480
[    1.989347] device id = 24c0
[    1.989806] device id = 24d0
[    1.990361] device id = 25a1
[    1.990909] device id = 2670
[    1.991533] platform physmap-flash.0: failed to claim resource 0
[    1.992659] kobject: 'physmap-flash' (ffff880006dee800): kobject_release, parent ffff880000189248 (delayed)
[    1.994199] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    1.995167] Could not find PAR responsible for SC520CDP Flash Bank #0
[    1.996427] Trying default address 0x8400000
[    1.997492] Could not find PAR responsible for SC520CDP Flash Bank #1
[    1.998671] Trying default address 0x8c00000
[    1.999518] Could not find PAR responsible for SC520CDP DIL Flash
[    2.000915] Trying default address 0x9400000
[    2.002087] SC520 CDP flash device: 0x800000 at 0x8400000
[    2.003320] Failed to ioremap_nocache
[    2.004295] Failed to ioremap_nocache
[    2.005066] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.006574] kobject: 'docg3' (ffff880006df5c00): kobject_release, parent ffff880000189248 (delayed)
[    2.008475] slram: not enough parameters.
[    2.012123] No valid DiskOnChip devices found
[    2.013435] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.015249] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.017548] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.019539] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.021586] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.023325] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.025210] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    2.027695] flash size: 128 MiB
[    2.028666] page size: 512 bytes
[    2.029434] OOB area size: 16 bytes
[    2.030053] sector size: 16 KiB
[    2.030769] pages number: 262144
[    2.031294] pages per sector: 32
[    2.032097] bus width: 8
[    2.032645] bits in sector size: 14
[    2.033346] bits in page size: 9
[    2.033905] bits in OOB size: 4
[    2.034494] flash size with OOB: 135168 KiB
[    2.035426] page address bytes: 4
[    2.036146] sector address bytes: 3
[    2.037056] options: 0x42
[    2.043105] Scanning device for bad blocks
[    2.103002] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    2.105238] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    2.107648] parport0: powerup/reset Butterfly
[    2.226163] parport_pc 00:04: registered master spi42
[    2.227704] parport_pc 00:04: master is unqueued, this is deprecated
[    2.230139] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    2.231574] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    2.234657] parport_pc 00:04: registered child spi42.1
[    2.236048] parport0: dataflash at spi42.1
[    2.237235] parport0: AVR Butterfly
[    2.238424] parport0: cannot grant exclusive access for device spi-lm70llp
[    2.240412] spi-lm70llp: spi_lm70llp probe fail, status -12
[    2.242401] usbcore: registered new interface driver irda-usb
[    2.244367] usbcore: registered new interface driver stir4200
[    2.246030] usbcore: registered new interface driver mcs7780
[    2.247511] usbcore: registered new interface driver kingsun-sir
[    2.249376] usbcore: registered new interface driver ksdazzle-sir
[    2.251376] usbcore: registered new interface driver ks959-sir
[    2.253816] usbcore: registered new interface driver hwa-rc
[    2.256189] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.258045] ohci-pci: OHCI PCI platform driver
[    2.259611] ohci-platform: OHCI generic platform driver
[    2.261988] uhci_hcd: USB Universal Host Controller Interface driver
[    2.264494] driver u132_hcd
[    2.266071] usbcore: registered new interface driver hwa-hc
[    2.267855] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    2.269440] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    2.272261] usbcore: registered new interface driver cdc_wdm
[    2.274184] usbcore: registered new interface driver usbtmc
[    2.276471] usbcore: registered new interface driver appledisplay
[    2.278371] usbcore: registered new interface driver emi26 - firmware loader
[    2.280648] usbcore: registered new interface driver emi62 - firmware loader
[    2.282942] driver ftdi-elan
[    2.284600] usbcore: registered new interface driver ftdi-elan
[    2.286331] usbcore: registered new interface driver idmouse
[    2.288059] usbcore: registered new interface driver usblcd
[    2.289890] usbcore: registered new interface driver ldusb
[    2.291707] usbcore: registered new interface driver usbled
[    2.293568] usbcore: registered new interface driver legousbtower
[    2.295169] usbcore: registered new interface driver rio500
[    2.297247] usbcore: registered new interface driver usbtest
[    2.299116] usbcore: registered new interface driver trancevibrator
[    2.301237] usbcore: registered new interface driver uss720
[    2.302963] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[    2.305255] uss720: NOTE: this is a special purpose driver to allow nonstandard
[    2.307371] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[    2.309042] uss720: If you just want to connect to a printer, use usblp instead
[    2.311221] usbcore: registered new interface driver yurex
[    2.312991] kobject: 'gpio-vbus' (ffff880006829400): kobject_release, parent ffff880000189248 (delayed)
[    2.315622] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.319584] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.320822] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.321928] parport0: cannot grant exclusive access for device parkbd
[    2.388821] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    2.391593] kobject: '(null)' (ffff88000770faf0): kobject_release, parent           (null) (delayed)
[    2.393525] usbcore: registered new interface driver bcm5974
[    2.395745] usbcore: registered new interface driver synaptics_usb
[    2.398712] usbcore: registered new interface driver iforce
[    2.401977] parport0: cannot grant exclusive access for device walkera0701
[    2.403796] walkera0701: failed to register parport device
[    2.405993] usbcore: registered new interface driver usbtouchscreen
[    2.407956] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    2.409590] usbcore: registered new interface driver ati_remote2
[    2.411444] cm109: Keymap for Komunikate KIP1000 phone loaded
[    2.413053] usbcore: registered new interface driver cm109
[    2.413904] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    2.415460] usbcore: registered new interface driver keyspan_remote
[    2.417670] usbcore: registered new interface driver yealink
[    2.418707] I2O subsystem v1.325
[    2.419361] i2o: max drivers = 8
[    2.420556] I2O Configuration OSM v1.323
[    2.421581] I2O ProcFS OSM v1.316
[    2.422371] kobject: 'proc-osm' (ffff880007754a00): kobject_release, parent ffff880007717448 (delayed)
[    2.425475] kobject: 'mc13xxx-rtc' (ffff88000776ca00): kobject_release, parent ffff880000189248 (delayed)
[    2.427727] kobject: 'rtc-msm6242' (ffff88000776c800): kobject_release, parent ffff880000189248 (delayed)
[    2.429979] kobject: 'pcap-rtc' (ffff88000776c600): kobject_release, parent ffff880000189248 (delayed)
[    2.432100] kobject: 'rtc-rp5c01' (ffff88000777e600): kobject_release, parent ffff880000189248 (delayed)
[    2.434494] rtc rtc0: test: dev (254:0)
[    2.435196] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    2.436784] rtc rtc1: test: dev (254:1)
[    2.437792] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    2.438988] i2c /dev entries driver
[    2.439794] usbcore: registered new interface driver i2c-diolan-u2c
[    2.440789] i2c-parport: adapter type unspecified
[    2.441529] i2c-parport-light: adapter type unspecified
[    2.442509] pps pps0: new PPS source ktimer
[    2.443262] pps pps0: ktimer PPS source registered
[    2.443979] pps_parport: parallel port PPS client
[    2.444785] parport0: cannot grant exclusive access for device pps_parport
[    2.445804] pps_parport: couldn't register with parport0
[    2.446664] Driver for 1-wire Dallas network protocol.
[    2.447525] usbcore: registered new interface driver DS9490R
[    2.448487] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.449702] power_supply test_ac: uevent
[    2.450474] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    2.451414] power_supply test_ac: prop ONLINE=1
[    2.452149] power_supply test_ac: power_supply_changed
[    2.453075] power_supply test_ac: power_supply_changed_work
[    2.454304] power_supply test_ac: power_supply_update_gen_leds 1
[    2.455498] power_supply test_ac: uevent
[    2.456132] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    2.456317] power_supply test_battery: uevent
[    2.456319] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    2.456342] power_supply test_battery: prop STATUS=Discharging
[    2.456346] power_supply test_battery: prop CHARGE_TYPE=Fast
[    2.456354] power_supply test_battery: prop HEALTH=Good
[    2.456359] power_supply test_battery: prop PRESENT=1
[    2.456362] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    2.456366] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    2.456369] power_supply test_battery: prop CHARGE_FULL=100
[    2.456373] power_supply test_battery: prop CHARGE_NOW=50
[    2.456376] power_supply test_battery: prop CAPACITY=50
[    2.456379] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    2.456383] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    2.456386] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    2.456389] power_supply test_battery: prop MODEL_NAME=Test battery
[    2.456393] power_supply test_battery: prop MANUFACTURER=Linux
[    2.456397] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    2.456400] power_supply test_battery: prop TEMP=26
[    2.456404] power_supply test_battery: prop VOLTAGE_NOW=3300
[    2.456683] power_supply test_battery: power_supply_changed
[    2.456702] power_supply test_battery: power_supply_changed_work
[    2.456707] power_supply test_battery: power_supply_update_bat_leds 2
[    2.456714] power_supply test_battery: uevent
[    2.456717] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    2.456734] power_supply test_battery: prop STATUS=Discharging
[    2.456739] power_supply test_battery: prop CHARGE_TYPE=Fast
[    2.456742] power_supply test_battery: prop HEALTH=Good
[    2.456746] power_supply test_battery: prop PRESENT=1
[    2.456750] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    2.456754] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    2.456758] power_supply test_battery: prop CHARGE_FULL=100
[    2.456767] power_supply test_battery: prop CHARGE_NOW=50
[    2.456771] power_supply test_battery: prop CAPACITY=50
[    2.456775] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    2.456779] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    2.456783] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    2.456787] power_supply test_battery: prop MODEL_NAME=Test battery
[    2.456794] power_supply test_battery: prop MANUFACTURER=Linux
[    2.456799] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    2.456803] power_supply test_battery: prop TEMP=26
[    2.456807] power_supply test_battery: prop VOLTAGE_NOW=3300
[    2.456872] power_supply test_usb: uevent
[    2.456875] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    2.456882] power_supply test_usb: prop ONLINE=1
[    2.456896] power_supply test_usb: power_supply_changed
[    2.456934] power_supply test_usb: power_supply_changed_work
[    2.456939] power_supply test_usb: power_supply_update_gen_leds 1
[    2.456945] power_supply test_usb: uevent
[    2.456947] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    2.456954] power_supply test_usb: prop ONLINE=1
[    2.458181] applesmc: supported laptop not found!
[    2.458182] applesmc: driver init failed (ret=-19)!
[    2.458699] f71882fg: Not a Fintek device
[    2.458778] f71882fg: Not a Fintek device
[    2.459692] kobject: 'mc13783-adc' (ffff88000688e400): kobject_release, parent ffff880000189248 (delayed)
[    2.460194] pc87360: PC8736x not detected, module not inserted
[    2.461635] cpuidle: using governor ladder
[    2.461638] cpuidle: using governor menu
[    2.461658] sdhci: Secure Digital Host Controller Interface driver
[    2.461660] sdhci: Copyright(c) Pierre Ossman
[    2.462799] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    2.462799] usbcore: registered new interface driver vub300
[    2.462836] usbcore: registered new interface driver ushc
[    2.462837] sdhci-pltfm: SDHCI platform and OF driver helper
[    2.463626] ledtrig-cpu: registered to indicate activity on CPUs
[    2.464118] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    2.465514] usbcore: registered new interface driver usbhid
[    2.465516] usbhid: USB HID core driver
[    2.465596] usbip_core: usbip_core_init:804: USB/IP Core v1.0.0
[    2.465737] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    2.465746] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    2.465854] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 1
[    2.465867] vhci_hcd: vhci_start:884: enter vhci_start
[    2.466765] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.466767] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.466769] usb usb1: Product: USB/IP Virtual Host Controller
[    2.466770] usb usb1: Manufacturer: Linux 3.11.0-rc2-00010-gc817a67-dirty vhci_hcd
[    2.466772] usb usb1: SerialNumber: vhci_hcd
[    2.583473] power_supply test_ac: prop ONLINE=1
[    2.584191] hub 1-0:1.0: USB hub found
[    2.584214] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIndex 0
[    2.584245] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
[    2.584247] vhci_hcd: vhci_hub_control:398: port -1
[    2.584248] vhci_hcd: vhci_hub_control:405:  bye
[    2.584258] hub 1-0:1.0: 8 ports detected
[    2.584299] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex 0
[    2.584306] vhci_hcd: vhci_hub_control:309:  GetHubStatus
[    2.584306] vhci_hcd: vhci_hub_control:398: port -1
[    2.584307] vhci_hcd: vhci_hub_control:405:  bye
[    2.584756] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 1
[    2.584758] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.584759] vhci_hcd: vhci_hub_control:398: port 0
[    2.584760] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.584762] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.584763] vhci_hcd: dump_port_status_diff:119:
[    2.584763] vhci_hcd: vhci_hub_control:405:  bye
[    2.584768] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 2
[    2.584769] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.584770] vhci_hcd: vhci_hub_control:398: port 1
[    2.584771] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.584772] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.584773] vhci_hcd: dump_port_status_diff:119:
[    2.584774] vhci_hcd: vhci_hub_control:405:  bye
[    2.584777] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 3
[    2.584779] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.584779] vhci_hcd: vhci_hub_control:398: port 2
[    2.584780] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.584781] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.584782] vhci_hcd: dump_port_status_diff:119:
[    2.584783] vhci_hcd: vhci_hub_control:405:  bye
[    2.584786] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 4
[    2.584787] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.584788] vhci_hcd: vhci_hub_control:398: port 3
[    2.584789] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.584789] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.584790] vhci_hcd: dump_port_status_diff:119:
[    2.584791] vhci_hcd: vhci_hub_control:405:  bye
[    2.584794] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 5
[    2.584795] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.584796] vhci_hcd: vhci_hub_control:398: port 4
[    2.584797] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.584798] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.584799] vhci_hcd: dump_port_status_diff:119:
[    2.584799] vhci_hcd: vhci_hub_control:405:  bye
[    2.584803] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 6
[    2.584804] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.584804] vhci_hcd: vhci_hub_control:398: port 5
[    2.584805] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.584806] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.584807] vhci_hcd: dump_port_status_diff:119:
[    2.584808] vhci_hcd: vhci_hub_control:405:  bye
[    2.584811] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 7
[    2.584812] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.584813] vhci_hcd: vhci_hub_control:398: port 6
[    2.584814] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.584814] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.584815] vhci_hcd: dump_port_status_diff:119:
[    2.584816] vhci_hcd: vhci_hub_control:405:  bye
[    2.584819] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 8
[    2.584820] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    2.584821] vhci_hcd: vhci_hub_control:398: port 7
[    2.584822] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    2.584823] vhci_hcd: dump_port_status_diff:115:  +POWER
[    2.584823] vhci_hcd: dump_port_status_diff:119:
[    2.584824] vhci_hcd: vhci_hub_control:405:  bye
[    2.584976] vhci_hcd: vhci_hcd_probe:1034: bye
[    2.584987] vhci_hcd: vhci_hcd_init:1156: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.0.0
[    2.674167] usbcore: registered new interface driver usbip-host
[    2.675605] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
[    2.677504] tsc: Refined TSC clocksource calibration: 2693.466 MHz
[    2.678974] usbcore: registered new interface driver tranzport
[    2.680315] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 1
[    2.681527] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 1
[    2.682701] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.684277] vhci_hcd: vhci_hub_control:398: port 0
[    2.684284] usbcore: registered new interface driver alphatrack
[    2.684286] vme_user: VME User Space Access Driver
[    2.684287] vme_user: No cards, skipping registration
[    2.685526] Loading crystalhd 0.9.27
[    2.685597] usbcore: registered new interface driver ft1000usb
[    2.685661] usbcore: registered new interface driver gdm_wimax
[    2.685683] usbcore: registered new interface driver cedusb
[    2.700553] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.700671] ipip: IPv4 over IPv4 tunneling driver
[    2.700970] gre: GRE over IPv4 demultiplexor driver
[    2.700972] IPv4 over IPSec tunneling driver
[    2.701327] TCP: cubic registered
[    2.701331] NET: Registered protocol family 17
[    2.711921] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.711981] NET: Registered protocol family 9
[    2.711990] X.25 for Linux Version 0.2
[    2.717433] vhci_hcd: dump_port_status_diff:119:
[    2.718825] vhci_hcd: vhci_hub_control:405:  bye
[    2.718831] NET: Registered protocol family 33
[    2.718835] Key type rxrpc registered
[    2.718836] Key type rxrpc_s registered
[    2.726623] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 2
[    2.726898] RxRPC: Registered security type 2 'rxkad'
[    2.726983] l2tp_core: L2TP core driver, V2.0
[    2.726985] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    2.735459] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 2
[    2.737647] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    2.737685] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.737687] vhci_hcd: vhci_hub_control:398: port 1
[    2.737690] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.737692] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.737694] vhci_hcd: dump_port_status_diff:119:
[    2.737695] vhci_hcd: vhci_hub_control:405:  bye
[    2.737948] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 3
[    2.737950] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 3
[    2.737952] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.737953] vhci_hcd: vhci_hub_control:398: port 2
[    2.737955] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.737965] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.737967] vhci_hcd: dump_port_status_diff:119:
[    2.737968] vhci_hcd: vhci_hub_control:405:  bye
[    2.737978] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 4
[    2.737980] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 4
[    2.737982] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.737983] vhci_hcd: vhci_hub_control:398: port 3
[    2.737985] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.737987] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.737989] vhci_hcd: dump_port_status_diff:119:
[    2.737990] vhci_hcd: vhci_hub_control:405:  bye
[    2.737998] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 5
[    2.738000] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 5
[    2.738002] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.738004] vhci_hcd: vhci_hub_control:398: port 4
[    2.738006] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.738015] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.738018] vhci_hcd: dump_port_status_diff:119:
[    2.738027] vhci_hcd: vhci_hub_control:405:  bye
[    2.738037] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 6
[    2.738039] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 6
[    2.738041] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.738043] vhci_hcd: vhci_hub_control:398: port 5
[    2.738044] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.738046] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.738048] vhci_hcd: dump_port_status_diff:119:
[    2.738049] vhci_hcd: vhci_hub_control:405:  bye
[    2.738058] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 7
[    2.738060] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 7
[    2.738062] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.738063] vhci_hcd: vhci_hub_control:398: port 6
[    2.738065] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.738067] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.738068] vhci_hcd: dump_port_status_diff:119:
[    2.738069] vhci_hcd: vhci_hub_control:405:  bye
[    2.738078] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 8
[    2.738080] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 8
[    2.738081] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    2.738083] vhci_hcd: vhci_hub_control:398: port 7
[    2.738085] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    2.738086] vhci_hcd: dump_port_status_diff:115:   POWER
[    2.738088] vhci_hcd: dump_port_status_diff:119:
[    2.738089] vhci_hcd: vhci_hub_control:405:  bye
[    2.813032] usb usb1: vhci_bus_suspend
[    2.813076] NET: Registered protocol family 12
[    2.814127] vhci_hcd: vhci_hub_status:208: changed 0
[    2.828320] 8021q: 802.1Q VLAN Support v1.8
[    2.830268] sctp: Hash tables configured (established 1024 bind 1024)
[    2.832985] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[    2.834801] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[    2.836415] NET: Registered protocol family 37
[    2.837802] NET: Registered protocol family 36
[    2.839397] Key type dns_resolver registered
[    2.841025] Key type ceph registered
[    2.842412] libceph: loaded (mon/osd proto 15/24)
[    2.843773] mpls_gso: MPLS GSO support
[    2.848993]
[    2.848993] printing PIC contents
[    2.850407] ... PIC  IMR: ffff
[    2.851205] ... PIC  IRR: 1013
[    2.852114] ... PIC  ISR: 0000
[    2.852964] ... PIC ELCR: 0c00
[    2.853853] printing local APIC contents on CPU#0/0:
[    2.855252] ... APIC ID:      00000000 (0)
[    2.856043] ... APIC VERSION: 00050014
[    2.856043] ... APIC TASKPRI: 00000000 (00)
[    2.856043] ... APIC PROCPRI: 00000000
[    2.856043] ... APIC LDR: 01000000
[    2.856043] ... APIC DFR: ffffffff
[    2.856043] ... APIC SPIV: 000001ff
[    2.856043] ... APIC ISR field:
[    2.856043] 0000000000000000000000000000000000000000000000000000000000000000
[    2.856043] ... APIC TMR field:
[    2.856043] 0000000000000000000000000000000000000000000000000000000000000000
[    2.856043] ... APIC IRR field:
[    2.856043] 0000000000000000000000000000000000000000000000000000000000008000
[    2.856043] ... APIC ESR: 00000000
[    2.856043] ... APIC ICR: 000008fd
[    2.856043] ... APIC ICR2: 02000000
[    2.856043] ... APIC LVTT: 000000ef
[    2.856043] ... APIC LVTPC: 00010000
[    2.856043] ... APIC LVT0: 00010700
[    2.856043] ... APIC LVT1: 00000400
[    2.856043] ... APIC LVTERR: 000000fe
[    2.856043] ... APIC TMICT: 0003c481
[    2.856043] ... APIC TMCCT: 00000000
[    2.856043] ... APIC TDCR: 00000003
[    2.856043]
[    2.882198] number of MP IRQ sources: 15.
[    2.882886] number of IO-APIC #0 registers: 24.
[    2.883647] testing the IO APIC.......................
[    2.884582] IO APIC #0......
[    2.885077] .... register #00: 00000000
[    2.885714] .......    : physical APIC id: 00
[    2.886449] .......    : Delivery Type: 0
[    2.887114] .......    : LTS          : 0
[    2.887813] .... register #01: 00170011
[    2.888534] .......     : max redirection entries: 17
[    2.889404] .......     : PRQ implemented: 0
[    2.890110] .......     : IO APIC version: 11
[    2.890846] .... register #02: 00000000
[    2.891489] .......     : arbitration: 00
[    2.892209] .... IRQ redirection table:
[    2.892871] 1    0    0   0   0    0    0    00
[    2.893672] 0    0    0   0   0    1    1    31
[    2.894440] 0    0    0   0   0    1    1    30
[    2.895225] 0    0    0   0   0    1    1    33
[    2.895997] 1    0    0   0   0    1    1    34
[    2.896838] 1    1    0   0   0    1    1    35
[    2.897729] 0    0    0   0   0    1    1    36
[    2.898662] 0    0    0   0   0    1    1    37
[    2.899439] 0    0    0   0   0    1    1    38
[    2.900214] 0    1    0   0   0    1    1    39
[    2.901054] 1    1    0   0   0    1    1    3A
[    2.901822] 1    1    0   0   0    1    1    3B
[    2.902573] 0    0    0   0   0    1    1    3C
[    2.903365] 0    0    0   0   0    1    1    3D
[    2.904130] 0    0    0   0   0    1    1    3E
[    2.904881] 0    0    0   0   0    1    1    3F
[    2.905664] 1    0    0   0   0    0    0    00
[    2.906414] 1    0    0   0   0    0    0    00
[    2.907170] 1    0    0   0   0    0    0    00
[    2.907922] 1    0    0   0   0    0    0    00
[    2.908722] 1    0    0   0   0    0    0    00
[    2.909480] 1    0    0   0   0    0    0    00
[    2.910222] 1    0    0   0   0    0    0    00
[    2.910995] 1    0    0   0   0    0    0    00
[    2.911718] IRQ to pin mappings:
[    2.912249] IRQ0 -> 0:2
[    2.912745] IRQ1 -> 0:1
[    2.913203] IRQ3 -> 0:3
[    2.913650] IRQ4 -> 0:4
[    2.914080] IRQ5 -> 0:5
[    2.914526] IRQ6 -> 0:6
[    2.914959] IRQ7 -> 0:7
[    2.915389] IRQ8 -> 0:8
[    2.915828] IRQ9 -> 0:9
[    2.916277] IRQ10 -> 0:10
[    2.916816] IRQ11 -> 0:11
[    2.917478] IRQ12 -> 0:12
[    2.918074] IRQ13 -> 0:13
[    2.918787] IRQ14 -> 0:14
[    2.919302] IRQ15 -> 0:15
[    2.919777] .................................... done.
[    2.922108] registered taskstats version 1
[    2.924476] rtc-test rtc-test.0: setting system clock to 2013-09-09 06:44:07 UTC (1378709047)
[    2.928387] debug: unmapping init [mem 0xffffffff81dfc000-0xffffffff81ecefff]
[    2.964097] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[    2.966666] IP: [<ffffffff81098f60>] run_timer_softirq+0x126/0x1da
[    2.968060] PGD 0
[    2.968060] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    2.968060] CPU: 0 PID: 95 Comm: kworker/0:2 Not tainted 3.11.0-rc2-00010-gc817a67-dirty #5
[    2.968060] Workqueue: events flush_to_ldisc
[    2.968060] task: ffff8800068544c0 ti: ffff880006856000 task.ti: ffff880006856000
[    2.968060] RIP: 0010:[<ffffffff81098f60>]  [<ffffffff81098f60>] run_timer_softirq+0x126/0x1da
[    2.968060] RSP: 0018:ffff88000dc03ea8  EFLAGS: 00010046
[    2.968060] RAX: ffff880006dc30a0 RBX: ffffffff81f3e780 RCX: ffff88000dc03ec8
[    2.968060] RDX: 00000000ffffffff RSI: dead4ead00000000 RDI: 0000000000000000
[    2.968060] RBP: ffff88000dc03f08 R08: 0000000000000000 R09: dead000000200200
[    2.968060] R10: ffffffff81f3e798 R11: 0000000000000000 R12: ffff88000dc03ec8
[    2.968060] R13: ffffffff81f3ffd8 R14: ffffffff81f3fbd8 R15: ffffffff81f3f7d8
[    2.968060] FS:  0000000000000000(0000) GS:ffff88000dc00000(0000) knlGS:0000000000000000
[    2.968060] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    2.968060] CR2: 0000000000000008 CR3: 00000000069ff000 CR4: 00000000000006b0
[    2.968060] Stack:
[    2.968060]  ffff88000dc03ee8 ffff8800068544c0 ffffffff81095529 000000ed07777040
[    2.968060]  ffff880006dc30a0 ffff880000137d50 ffff88000dc03ef8 ffff880006857fd8
[    2.968060]  ffffffff81c43088 0000000000000101 0000000000000101 0000000000000001
[    2.968060] Call Trace:
[    2.968060]  <IRQ>
[    2.968060]  [<ffffffff81095529>] ? __do_softirq+0x90/0x18f
[    2.968060]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
[    2.968060]  [<ffffffff81095745>] irq_exit+0x58/0x9e
[    2.968060]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
[    2.968060]  [<ffffffff8185a772>] apic_timer_interrupt+0x72/0x80
[    2.968060]  <EOI>
[    2.968060]  [<ffffffff810cdac0>] ? arch_local_irq_restore+0x6/0xd
[    2.968060]  [<ffffffff81858790>] _raw_spin_unlock_irqrestore+0x48/0x75
[    2.968060]  [<ffffffff81302b8b>] flush_to_ldisc+0x139/0x150
[    2.968060]  [<ffffffff810c703b>] ? trace_hardirqs_on_caller+0x154/0x18b
[    2.968060]  [<ffffffff810a2733>] process_one_work+0x1de/0x2fd
[    2.968060]  [<ffffffff810a26c9>] ? process_one_work+0x174/0x2fd
[    2.968060]  [<ffffffff810a2c54>] worker_thread+0x159/0x1ee
[    2.968060]  [<ffffffff810a2afb>] ? rescuer_thread+0x27f/0x27f
[    2.968060]  [<ffffffff810a859a>] kthread+0xac/0xb4
[    2.968060]  [<ffffffff810a84ee>] ? __kthread_parkme+0x68/0x68
[    2.968060]  [<ffffffff81859a3c>] ret_from_fork+0x7c/0xb0
[    2.968060]  [<ffffffff810a84ee>] ? __kthread_parkme+0x68/0x68
[    2.968060] Code: 08 e9 99 00 00 00 4c 8b 40 18 48 8b 70 20 49 b9 00 02 20 00 00 00 ad de 48 8b 50 28 48 89 43 38 48 8b 38 48 8b 48 08 41 83 e0 02 <48> 89 4f 08 48 89 39 f6 40 18 01 48 c7 00 00 00 00 00 4c 89 48
[    2.968060] RIP  [<ffffffff81098f60>] run_timer_softirq+0x126/0x1da
[    2.968060]  RSP <ffff88000dc03ea8>
[    2.968060] CR2: 0000000000000008
[    2.968060] ---[ end trace 8a8edd251c7729a5 ]---
[    2.968060] Kernel panic - not syncing: Fatal exception in interrupt
[    2.968060] Rebooting in 10 seconds..%                                                                                                  wfg@bee ~/linux/obj-compiletest%
wfg@bee ~/linux/obj-compiletest%
wfg@bee ~/linux/obj-compiletest% kvm-0day.sh arch/x86/boot/bzImage
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc2-00010-gc817a67-dirty (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #5 SMP PREEMPT Tue Oct 8 09:29:02 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
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
[    0.000000] BRK [0x028a7000, 0x028a7fff] PGTABLE
[    0.000000] BRK [0x028a8000, 0x028a8fff] PGTABLE
[    0.000000] BRK [0x028a9000, 0x028a9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x028aa000, 0x028aafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x028ab000, 0x028abfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128416(97%)
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
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 199068K/261744K available (8557K kernel code, 1784K rwdata, 3968K rodata, 844K init, 10064K bss, 62676K reserved)
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
[    0.000000] ODEBUG: 5 of 5 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=10774032)
[    0.009609] pid_max: default: 32768 minimum: 301
[    0.012550] Mount-cache hash table entries: 256
[    0.014101] Initializing cgroup subsys devices
[    0.016039] Initializing cgroup subsys perf_event
[    0.016861] Initializing cgroup subsys net_prio
[    0.018098] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.018098] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.018098] tlb_flushall_shift: 6
[    0.020085] debug: unmapping init [mem 0xffffffff81ecf000-0xffffffff81ed2fff]
[    0.025660] ACPI: Core revision 20130517
[    0.032451] ACPI: All ACPI Tables successfully acquired
[    0.034055] Getting VERSION: 50014
[    0.034827] Getting VERSION: 50014
[    0.035718] Getting ID: 0
[    0.036048] Getting ID: ff000000
[    0.037717] Getting LVT0: 8700
[    0.039050] Getting LVT1: 8400
[    0.040094] enabled ExtINT on CPU#0
[    0.045404] ENABLING IO-APIC IRQs
[    0.046940] init IO_APIC IRQs
[    0.047678]  apic 0 pin 0 not connected
[    0.048049] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.052089] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.056087] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.060083] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.064043] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.066564] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.068085] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.070054] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.072047] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.073800] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.076044] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.078333] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.080041] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.084035] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.086224] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.088021]  apic 0 pin 16 not connected
[    0.088813]  apic 0 pin 17 not connected
[    0.089716]  apic 0 pin 18 not connected
[    0.090697]  apic 0 pin 19 not connected
[    0.092023]  apic 0 pin 20 not connected
[    0.094144]  apic 0 pin 21 not connected
[    0.096019]  apic 0 pin 22 not connected
[    0.100007]  apic 0 pin 23 not connected
[    0.101159] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.102975] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.105785] Using local APIC timer interrupts.
[    0.105785] calibrating APIC timer ...
[    0.112000] ... lapic delta = 6289862
[    0.112000] ... PM-Timer delta = 360254
[    0.112000] ... PM-Timer result ok
[    0.112000] ..... delta 6289862
[    0.112000] ..... mult: 270147515
[    0.112000] ..... calibration result: 4025511
[    0.112000] ..... CPU clock speed is 2710.2891 MHz.
[    0.112000] ..... host bus clock speed is 1006.1511 MHz.
[    0.112109] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.136572] SMP alternatives: lockdep: fixing up alternatives
[    0.137880] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:e896041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.156145] KVM setup async PF for cpu 1
[    0.156224] Brought up 2 CPUs
[    0.156228] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.158539] kvm-stealtime: cpu 1, msr dd0ccc0
[    0.160232] devtmpfs: initialized
[    0.164495] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.166547] regulator-dummy: no parameters
[    0.167954] NET: Registered protocol family 16
[    0.169382] ACPI: bus type PCI registered
[    0.170594] PCI: Using configuration type 1 for base access
[    0.181246] ACPI: Added _OSI(Module Device)
[    0.182655] ACPI: Added _OSI(Processor Device)
[    0.184007] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.185741] ACPI: Added _OSI(Processor Aggregator Device)
[    0.189720] ACPI: EC: Look up EC in DSDT
[    0.196733] ACPI: Interpreter enabled
[    0.197779] ACPI: (supports S0 S5)
[    0.198787] ACPI: Using IOAPIC for interrupt routing
[    0.200062] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.215924] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.216321] PCI host bridge to bus 0000:00
[    0.217188] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.218301] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.220019] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.222135] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.224013] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.225995] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.228944] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.232771] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.238213] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.245305] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.247447] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.248082] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.256593] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.264079] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.269023] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.284085] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.286394] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.289519] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.292010] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.300022] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.302335] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.304712] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.308704] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.320686] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.322830] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.324806] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.332307] pci_bus 0000:00: on NUMA node 0
[    0.334276] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.336017] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.340124] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.342025] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.343862] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.345540] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.348693] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.353624] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.356038] ACPI: \_SB_.PCI0: notify handler is installed
[    0.364244] Found 1 acpi root devices
[    0.372204] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.376015] vgaarb: loaded
[    0.376681] vgaarb: bridge control possible 0000:00:02.0
[    0.380748] ACPI: bus type USB registered
[    0.381853] usbcore: registered new interface driver usbfs
[    0.383299] usbcore: registered new interface driver hub
[    0.384137] usbcore: registered new device driver usb
[    0.385550] pps_core: LinuxPPS API ver. 1 registered
[    0.388007] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.390142] PTP clock support registered
[    0.391494] wmi: Mapper loaded
[    0.392084] PCI: Using ACPI for IRQ routing
[    0.393081] PCI: pci_cache_line_size set to 64 bytes
[    0.394480] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.396032] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.398425] NET: Registered protocol family 23
[    0.402056] cfg80211: Calling CRDA to update world regulatory domain
[    0.404182] nfc: nfc_init: NFC Core ver 0.1
[    0.405608] NET: Registered protocol family 39
[    0.408488] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.412322] Switched to clocksource kvm-clock
[    0.413984] pnp: PnP ACPI init
[    0.414898] ACPI: bus type PNP registered
[    0.415928] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.418711] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.420621] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.422806] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.424408] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.426449] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.427671] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.429510] pnp 00:03: [dma 2]
[    0.430765] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.432900] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.435692] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.437724] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.440219] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.442562] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.446348] pnp: PnP ACPI: found 7 devices
[    0.447431] ACPI: bus type PNP unregistered
[    0.458216] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.459708] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.460972] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.462387] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.464895] NET: Registered protocol family 2
[    0.466904] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    0.468747] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.471144] TCP: Hash tables configured (established 2048 bind 2048)
[    0.472829] TCP: reno registered
[    0.473809] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.475283] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.477338] NET: Registered protocol family 1
[    0.479302] RPC: Registered named UNIX socket transport module.
[    0.480790] RPC: Registered udp transport module.
[    0.481957] RPC: Registered tcp transport module.
[    0.482672] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.484502] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.486296] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.487949] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.489855] pci 0000:00:02.0: Boot video device
[    0.490930] PCI: CLS 0 bytes, default 64
[    0.492300] Unpacking initramfs...
[    3.207372] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    3.210544] has_svm: not amd
[    3.211270] kvm: no hardware support
[    3.212692] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    3.215070] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    3.220214] cryptomgr_test (24) used greatest stack depth: 6224 bytes left
[    3.220232] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    3.220240] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    3.220242] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    3.220243] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    3.220244] AVX or AES-NI instructions are not detected.
[    3.220245] AVX instructions are not detected.
[    3.220245] AVX instructions are not detected.
[    3.220246] AVX instructions are not detected.
[    3.232991] Initializing RT-Tester: OK
[    3.234018] audit: initializing netlink socket (disabled)
[    3.235475] type=2000 audit(1378709048.756:1): initialized
[    3.247285] DLM installed
[    3.251613] NFS: Registering the id_resolver key type
[    3.252720] Key type id_resolver registered
[    3.253533] Key type id_legacy registered
[    3.254231] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    3.255828] ROMFS MTD (C) 2007 Red Hat, Inc.
[    3.256668] fuse init (API version 7.22)
[    3.258203] ceph: loaded (mds proto 32)
[    3.267583] cryptomgr_test (43) used greatest stack depth: 5768 bytes left
[    3.271311] cryptomgr_test (46) used greatest stack depth: 5688 bytes left
[    3.287145] cryptomgr_test (72) used greatest stack depth: 5352 bytes left
[    3.291778] alg: No test for crc32 (crc32-table)
[    3.296651] alg: No test for lz4hc (lz4hc-generic)
[    3.298122] alg: No test for stdrng (krng)
[    3.303383] NET: Registered protocol family 38
[    3.305215] Key type asymmetric registered
[    3.306572] Asymmetric key parser 'x509' registered
[    3.308365] test_string_helpers: Running tests...
[    3.312172] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    3.315191] crc32: self tests passed, processed 225944 bytes in 342575 nsec
[    3.318004] crc32c: CRC_LE_BITS = 32
[    3.319251] crc32c: self tests passed, processed 225944 bytes in 181509 nsec
[    3.322850] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    3.325733] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    3.328352] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    3.331040] vmlfb: initializing
[    3.332239] Could not find Carillo Ranch MCH device.
[    3.334323] no IO addresses supplied
[    3.336782] hgafb: HGA card not detected.
[    3.340513] hgafb: probe of hgafb.0 failed with error -22
[    3.342011] usbcore: registered new interface driver udlfb
[    3.343899] usbcore: registered new interface driver smscufx
[    3.346552] uvesafb: failed to execute /sbin/v86d
[    3.347768] uvesafb: make sure that the v86d helper is installed and executable
[    3.349769] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    3.351355] uvesafb: vbe_init() failed with -22
[    3.352473] uvesafb: probe of uvesafb.0 failed with error -22
[    3.353976] ipmi message handler version 39.2
[    3.354861] ipmi device interface
[    3.355837] IPMI System Interface driver.
[    3.356984] ipmi_si: Adding default-specified kcs state machine
[    3.358711] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    3.361799] ipmi_si: Interface detection failed
[    3.372260] ipmi_si: Adding default-specified smic state machine
[    3.373129] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    3.374717] ipmi_si: Interface detection failed
[    3.384236] ipmi_si: Adding default-specified bt state machine
[    3.385147] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    3.386663] ipmi_si: Interface detection failed
[    3.396439] kobject: 'ipmi_si' (ffff880007729200): kobject_release, parent ffff8800001b7648 (delayed)
[    3.397906] kobject: 'ipmi_si' (ffff880007729000): kobject_release, parent ffff880000221248 (delayed)
[    3.399309] kobject: 'ipmi_si' (ffff880007729400): kobject_release, parent ffff880000189248 (delayed)
[    3.400724] ipmi_si: Unable to find any System Interface(s)
[    3.402041] IPMI Watchdog: driver initialized
[    3.402899] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    3.404977] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    3.406690] ACPI: Power Button [PWRF]
[    3.514702] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.539631] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.547502] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    3.549274] ac.o: No PCI boards found.
[    3.550681] ac.o: For an ISA board you must supply memory and irq parameters.
[    3.553628] Non-volatile memory driver v1.3
[    3.554838] Linux agpgart interface v0.103
[    3.556867] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    3.560840] kobject: 'drm' (ffff880006da2848): kobject_release, parent ffff880000189648 (delayed)
[    3.569015] kobject: 'drm' (ffff880006d9d000): kobject_release, parent           (null) (delayed)
[    3.573796] [drm] radeon kernel modesetting enabled.
[    3.579249] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
[    3.581935] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/dri.
[    3.585762] kobject: 'controlD64' (ffff880006da2020): kobject_release, parent           (null) (delayed)
[    3.589511] cirrus: probe of 0000:00:02.0 failed with error -1
[    3.591588] usbcore: registered new interface driver udl
[    3.600335] parport_pc 00:04: reported by Plug and Play ACPI
[    3.607891] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    3.610901] kobject: 'parport_pc.956' (ffff880006da2020): kobject_release, parent           (null) (delayed)
[    3.614901] kobject: 'parport_pc.888' (ffff880006db5820): kobject_release, parent           (null) (delayed)
[    3.617790] kobject: 'parport_pc.632' (ffff880006db5020): kobject_release, parent           (null) (delayed)
[    3.620560] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    3.622245] dummy-irq: no IRQ given.  Use irq=N
[    3.623525] Phantom Linux Driver, version n0.9.8, init OK
[    3.625159] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    3.627308] c2port c2port0: C2 port uc added
[    3.629801] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    3.632457] Guest personality initialized and is inactive
[    3.637209] VMCI host device registered (name=vmci, major=10, minor=56)
[    3.638939] Initialized host personality
[    3.640216] Driver for timberdale has been successfully registered.
[    3.642362] usbcore: registered new interface driver viperboard
[    3.644027] usbcore: registered new interface driver pn533
[    3.646477] mtdoops: mtd device (mtddev=name/number) must be supplied
[    3.648678] device id = 2440
[    3.649405] device id = 2480
[    3.650290] device id = 24c0
[    3.651040] device id = 24d0
[    3.651812] device id = 25a1
[    3.652659] device id = 2670
[    3.653544] platform physmap-flash.0: failed to claim resource 0
[    3.655834] kobject: 'physmap-flash' (ffff880006dcc800): kobject_release, parent ffff880000189248 (delayed)
[    3.659718] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    3.662205] Could not find PAR responsible for SC520CDP Flash Bank #0
[    3.663972] Trying default address 0x8400000
[    3.665090] Could not find PAR responsible for SC520CDP Flash Bank #1
[    3.667177] Trying default address 0x8c00000
[    3.669910] Could not find PAR responsible for SC520CDP DIL Flash
[    3.673116] Trying default address 0x9400000
[    3.674726] SC520 CDP flash device: 0x800000 at 0x8400000
[    3.676162] Failed to ioremap_nocache
[    3.677149] Failed to ioremap_nocache
[    3.678185] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.680019] kobject: 'docg3' (ffff880006dd4c00): kobject_release, parent ffff880000189248 (delayed)
[    3.682650] slram: not enough parameters.
[    3.688153] No valid DiskOnChip devices found
[    3.689386] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.695993] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.698973] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.702597] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.705213] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.707940] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.710801] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    3.714352] flash size: 128 MiB
[    3.715141] page size: 512 bytes
[    3.715945] OOB area size: 16 bytes
[    3.716870] sector size: 16 KiB
[    3.717674] pages number: 262144
[    3.718496] pages per sector: 32
[    3.719302] bus width: 8
[    3.719974] bits in sector size: 14
[    3.720919] bits in page size: 9
[    3.721746] bits in OOB size: 4
[    3.722536] flash size with OOB: 135168 KiB
[    3.723592] page address bytes: 4
[    3.724488] sector address bytes: 3
[    3.725380] options: 0x42
[    3.731404] Scanning device for bad blocks
[    3.777958] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.779667] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.788377] parport0: powerup/reset Butterfly
[    3.907320] parport_pc 00:04: registered master spi42
[    3.908349] parport_pc 00:04: master is unqueued, this is deprecated
[    3.909981] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    3.913842] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    3.916564] parport_pc 00:04: registered child spi42.1
[    3.918549] parport0: dataflash at spi42.1
[    3.919829] parport0: AVR Butterfly
[    3.920821] parport0: cannot grant exclusive access for device spi-lm70llp
[    3.923537] spi-lm70llp: spi_lm70llp probe fail, status -12
[    3.925278] usbcore: registered new interface driver irda-usb
[    3.926783] usbcore: registered new interface driver stir4200
[    3.928343] usbcore: registered new interface driver mcs7780
[    3.932314] usbcore: registered new interface driver kingsun-sir
[    3.933924] usbcore: registered new interface driver ksdazzle-sir
[    3.936083] usbcore: registered new interface driver ks959-sir
[    3.938825] usbcore: registered new interface driver hwa-rc
[    3.940385] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.941683] ohci-pci: OHCI PCI platform driver
[    3.942836] ohci-platform: OHCI generic platform driver
[    3.944191] uhci_hcd: USB Universal Host Controller Interface driver
[    3.946038] driver u132_hcd
[    3.950696] usbcore: registered new interface driver hwa-hc
[    3.953392] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    3.959220] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    3.966848] usbcore: registered new interface driver cdc_wdm
[    3.973087] usbcore: registered new interface driver usbtmc
[    3.979932] usbcore: registered new interface driver appledisplay
[    3.981977] usbcore: registered new interface driver emi26 - firmware loader
[    3.983829] usbcore: registered new interface driver emi62 - firmware loader
[    3.985658] driver ftdi-elan
[    3.991219] usbcore: registered new interface driver ftdi-elan
[    3.992075] usbcore: registered new interface driver idmouse
[    3.993096] usbcore: registered new interface driver usblcd
[    3.994069] usbcore: registered new interface driver ldusb
[    3.995106] usbcore: registered new interface driver usbled
[    3.996153] usbcore: registered new interface driver legousbtower
[    3.997276] usbcore: registered new interface driver rio500
[    3.998128] usbcore: registered new interface driver usbtest
[    3.999238] usbcore: registered new interface driver trancevibrator
[    4.000472] usbcore: registered new interface driver uss720
[    4.001508] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[    4.003713] uss720: NOTE: this is a special purpose driver to allow nonstandard
[    4.005519] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[    4.010250] uss720: If you just want to connect to a printer, use usblp instead
[    4.016793] usbcore: registered new interface driver yurex
[    4.019442] kobject: 'gpio-vbus' (ffff88000681f400): kobject_release, parent ffff880000189248 (delayed)
[    4.022078] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    4.030874] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.035083] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.036912] parport0: cannot grant exclusive access for device parkbd
[    4.125747] usbcore: registered new interface driver bcm5974
[    4.129260] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    4.131500] usbcore: registered new interface driver synaptics_usb
[    4.134116] kobject: '(null)' (ffff88000683e2f0): kobject_release, parent           (null) (delayed)
[    4.136950] usbcore: registered new interface driver iforce
[    4.138586] parport0: cannot grant exclusive access for device walkera0701
[    4.140551] walkera0701: failed to register parport device
[    4.143328] usbcore: registered new interface driver usbtouchscreen
[    4.150250] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    4.159622] usbcore: registered new interface driver ati_remote2
[    4.163462] cm109: Keymap for Komunikate KIP1000 phone loaded
[    4.168826] usbcore: registered new interface driver cm109
[    4.170239] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    4.171715] usbcore: registered new interface driver keyspan_remote
[    4.181913] usbcore: registered new interface driver yealink
[    4.184324] I2O subsystem v1.325
[    4.185399] i2o: max drivers = 8
[    4.187117] I2O Configuration OSM v1.323
[    4.188316] I2O ProcFS OSM v1.316
[    4.189655] kobject: 'proc-osm' (ffff880006859200): kobject_release, parent ffff880006859c48 (delayed)
[    4.192808] kobject: 'mc13xxx-rtc' (ffff880006860200): kobject_release, parent ffff880000189248 (delayed)
[    4.196181] kobject: 'rtc-msm6242' (ffff880006860000): kobject_release, parent ffff880000189248 (delayed)
[    4.199254] kobject: 'pcap-rtc' (ffff880006863e00): kobject_release, parent ffff880000189248 (delayed)
[    4.204132] kobject: 'rtc-rp5c01' (ffff880006869e00): kobject_release, parent ffff880000189248 (delayed)
[    4.207190] rtc rtc0: test: dev (254:0)
[    4.208173] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    4.210072] rtc rtc1: test: dev (254:1)
[    4.210988] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    4.212343] tsc: Refined TSC clocksource calibration: 2693.464 MHz
[    4.215899] i2c /dev entries driver
[    4.217285] usbcore: registered new interface driver i2c-diolan-u2c
[    4.219090] i2c-parport: adapter type unspecified
[    4.220304] i2c-parport-light: adapter type unspecified
[    4.222014] pps pps0: new PPS source ktimer
[    4.223084] pps pps0: ktimer PPS source registered
[    4.224425] pps_parport: parallel port PPS client
[    4.225723] parport0: cannot grant exclusive access for device pps_parport
[    4.227399] pps_parport: couldn't register with parport0
[    4.231870] Driver for 1-wire Dallas network protocol.
[    4.236985] usbcore: registered new interface driver DS9490R
[    4.239868] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    4.241942] power_supply test_ac: uevent
[    4.242901] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    4.244538] power_supply test_ac: prop ONLINE=1
[    4.245737] power_supply test_ac: power_supply_changed
[    4.247023] power_supply test_ac: power_supply_changed_work
[    4.248508] power_supply test_ac: power_supply_update_gen_leds 1
[    4.248690] power_supply test_battery: uevent
[    4.248692] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    4.248705] power_supply test_battery: prop STATUS=Discharging
[    4.248708] power_supply test_battery: prop CHARGE_TYPE=Fast
[    4.248711] power_supply test_battery: prop HEALTH=Good
[    4.248718] power_supply test_battery: prop PRESENT=1
[    4.248721] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    4.248725] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    4.248727] power_supply test_battery: prop CHARGE_FULL=100
[    4.248730] power_supply test_battery: prop CHARGE_NOW=50
[    4.248732] power_supply test_battery: prop CAPACITY=50
[    4.248735] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    4.248738] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    4.248740] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    4.248743] power_supply test_battery: prop MODEL_NAME=Test battery
[    4.248746] power_supply test_battery: prop MANUFACTURER=Linux
[    4.248749] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    4.248751] power_supply test_battery: prop TEMP=26
[    4.248754] power_supply test_battery: prop VOLTAGE_NOW=3300
[    4.249035] power_supply test_battery: power_supply_changed
[    4.249062] power_supply test_battery: power_supply_changed_work
[    4.249081] power_supply test_battery: power_supply_update_bat_leds 2
[    4.249104] power_supply test_battery: uevent
[    4.249108] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    4.249151] power_supply test_battery: prop STATUS=Discharging
[    4.249168] power_supply test_battery: prop CHARGE_TYPE=Fast
[    4.249171] power_supply test_battery: prop HEALTH=Good
[    4.249174] power_supply test_battery: prop PRESENT=1
[    4.249177] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    4.249180] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    4.249183] power_supply test_battery: prop CHARGE_FULL=100
[    4.249185] power_supply test_battery: prop CHARGE_NOW=50
[    4.249188] power_supply test_battery: prop CAPACITY=50
[    4.249191] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    4.249194] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    4.249197] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    4.249200] power_supply test_battery: prop MODEL_NAME=Test battery
[    4.249203] power_supply test_battery: prop MANUFACTURER=Linux
[    4.249209] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    4.249212] power_supply test_battery: prop TEMP=26
[    4.249215] power_supply test_battery: prop VOLTAGE_NOW=3300
[    4.249264] power_supply test_usb: uevent
[    4.249266] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    4.249277] power_supply test_usb: prop ONLINE=1
[    4.249287] power_supply test_usb: power_supply_changed
[    4.249319] power_supply test_usb: power_supply_changed_work
[    4.249323] power_supply test_usb: power_supply_update_gen_leds 1
[    4.249327] power_supply test_usb: uevent
[    4.249329] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    4.249335] power_supply test_usb: prop ONLINE=1
[    4.250182] applesmc: supported laptop not found!
[    4.250184] applesmc: driver init failed (ret=-19)!
[    4.250494] f71882fg: Not a Fintek device
[    4.250528] f71882fg: Not a Fintek device
[    4.251314] kobject: 'mc13783-adc' (ffff8800068a2c00): kobject_release, parent ffff880000189248 (delayed)
[    4.251485] pc87360: PC8736x not detected, module not inserted
[    4.252268] cpuidle: using governor ladder
[    4.252271] cpuidle: using governor menu
[    4.252291] sdhci: Secure Digital Host Controller Interface driver
[    4.252292] sdhci: Copyright(c) Pierre Ossman
[    4.252839] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    4.252840] usbcore: registered new interface driver vub300
[    4.252857] usbcore: registered new interface driver ushc
[    4.252858] sdhci-pltfm: SDHCI platform and OF driver helper
[    4.253560] ledtrig-cpu: registered to indicate activity on CPUs
[    4.253921] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    4.255260] usbcore: registered new interface driver usbhid
[    4.255262] usbhid: USB HID core driver
[    4.255328] usbip_core: usbip_core_init:804: USB/IP Core v1.0.0
[    4.255537] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    4.255568] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    4.255666] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 1
[    4.255696] vhci_hcd: vhci_start:884: enter vhci_start
[    4.256687] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    4.256691] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.256693] usb usb1: Product: USB/IP Virtual Host Controller
[    4.256696] usb usb1: Manufacturer: Linux 3.11.0-rc2-00010-gc817a67-dirty vhci_hcd
[    4.256697] usb usb1: SerialNumber: vhci_hcd
[    4.414785] hub 1-0:1.0: USB hub found
[    4.415230] power_supply test_ac: uevent
[    4.415233] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    4.415248] power_supply test_ac: prop ONLINE=1
[    4.418280] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIndex 0
[    4.419743] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
[    4.420616] vhci_hcd: vhci_hub_control:398: port -1
[    4.421133] vhci_hcd: vhci_hub_control:405:  bye
[    4.422143] hub 1-0:1.0: 8 ports detected
[    4.428378] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex 0
[    4.429547] vhci_hcd: vhci_hub_control:309:  GetHubStatus
[    4.430675] vhci_hcd: vhci_hub_control:398: port -1
[    4.431572] vhci_hcd: vhci_hub_control:405:  bye
[    4.433131] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 1
[    4.434314] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    4.435221] vhci_hcd: vhci_hub_control:398: port 0
[    4.435806] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    4.437133] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.438055] vhci_hcd: dump_port_status_diff:119:
[    4.438673] vhci_hcd: vhci_hub_control:405:  bye
[    4.439348] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 2
[    4.440664] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    4.442169] vhci_hcd: vhci_hub_control:398: port 1
[    4.443554] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    4.445645] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.446731] vhci_hcd: dump_port_status_diff:119:
[    4.447903] vhci_hcd: vhci_hub_control:405:  bye
[    4.449138] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 3
[    4.450742] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    4.452242] vhci_hcd: vhci_hub_control:398: port 2
[    4.453274] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    4.457484] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.459789] vhci_hcd: dump_port_status_diff:119:
[    4.465279] vhci_hcd: vhci_hub_control:405:  bye
[    4.466822] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 4
[    4.469234] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    4.471123] vhci_hcd: vhci_hub_control:398: port 3
[    4.473172] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    4.474594] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.475485] vhci_hcd: dump_port_status_diff:119:
[    4.476722] vhci_hcd: vhci_hub_control:405:  bye
[    4.477905] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 5
[    4.479540] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    4.482163] vhci_hcd: vhci_hub_control:398: port 4
[    4.483415] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    4.484981] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.485964] vhci_hcd: dump_port_status_diff:119:
[    4.487062] vhci_hcd: vhci_hub_control:405:  bye
[    4.488262] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 6
[    4.491803] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    4.493324] vhci_hcd: vhci_hub_control:398: port 5
[    4.494490] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    4.496512] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.497862] vhci_hcd: dump_port_status_diff:119:
[    4.499980] vhci_hcd: vhci_hub_control:405:  bye
[    4.501394] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 7
[    4.503203] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    4.505739] vhci_hcd: vhci_hub_control:398: port 6
[    4.507032] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    4.510569] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.512240] vhci_hcd: dump_port_status_diff:119:
[    4.513755] vhci_hcd: vhci_hub_control:405:  bye
[    4.514941] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 8
[    4.516703] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    4.518338] vhci_hcd: vhci_hub_control:398: port 7
[    4.519557] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    4.521697] vhci_hcd: dump_port_status_diff:115:  +POWER
[    4.523001] vhci_hcd: dump_port_status_diff:119:
[    4.524219] vhci_hcd: vhci_hub_control:405:  bye
[    4.525822] vhci_hcd: vhci_hcd_probe:1034: bye
[    4.526855] vhci_hcd: vhci_hcd_init:1156: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.0.0
[    4.532586] usbcore: registered new interface driver usbip-host
[    4.534441] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
[    4.536505] usbcore: registered new interface driver tranzport
[    4.539141] usbcore: registered new interface driver alphatrack
[    4.540797] vme_user: VME User Space Access Driver
[    4.542017] vme_user: No cards, skipping registration
[    4.544694] Loading crystalhd 0.9.27
[    4.545888] usbcore: registered new interface driver ft1000usb
[    4.547565] usbcore: registered new interface driver gdm_wimax
[    4.550532] usbcore: registered new interface driver cedusb
[    4.556441] ipip: IPv4 over IPv4 tunneling driver
[    4.558268] gre: GRE over IPv4 demultiplexor driver
[    4.559567] IPv4 over IPSec tunneling driver
[    4.561860] TCP: cubic registered
[    4.562890] NET: Registered protocol family 17
[    4.564359] NET: Registered protocol family 9
[    4.565898] X.25 for Linux Version 0.2
[    4.573621] NET: Registered protocol family 33
[    4.575163] Key type rxrpc registered
[    4.576648] Key type rxrpc_s registered
[    4.578809] RxRPC: Registered security type 2 'rxkad'
[    4.582792] l2tp_core: L2TP core driver, V2.0
[    4.584694] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    4.587105] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    4.593234] NET: Registered protocol family 12
[    4.604334] 8021q: 802.1Q VLAN Support v1.8
[    4.605748] sctp: Hash tables configured (established 1024 bind 1024)
[    4.608434] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[    4.609454] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[    4.610704] NET: Registered protocol family 37
[    4.611508] NET: Registered protocol family 36
[    4.612876] Key type dns_resolver registered
[    4.613780] Key type ceph registered
[    4.614747] libceph: loaded (mon/osd proto 15/24)
[    4.615851] mpls_gso: MPLS GSO support
[    4.616080] ------------[ cut here ]------------
[    4.616113] WARNING: CPU: 0 PID: 0 at /c/wfg/linux/kernel/workqueue.c:590 set_work_data+0x35/0x53()
[    4.616117] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.11.0-rc2-00010-gc817a67-dirty #5
[    4.616122]  000000000000024e ffff88000dc03d28 ffffffff8184e69e 0000000006380637
[    4.616125]  0000000000000000 ffff88000dc03d68 ffffffff8108f38d ffff88000dc03da8
[    4.616128]  ffffffff810a09cc ffff880006da2060 ffff88000dc13400 0000000000000005
[    4.616129] Call Trace:
[    4.616155]  <IRQ>  [<ffffffff8184e69e>] dump_stack+0x4f/0x84
[    4.616164]  [<ffffffff8108f38d>] warn_slowpath_common+0x72/0x8c
[    4.616167]  [<ffffffff810a09cc>] ? set_work_data+0x35/0x53
[    4.616169]  [<ffffffff8108f45e>] warn_slowpath_null+0x15/0x17
[    4.616172]  [<ffffffff810a09cc>] set_work_data+0x35/0x53
[    4.616174]  [<ffffffff810a0cc2>] insert_work+0x28/0x66
[    4.616177]  [<ffffffff810a1b64>] __queue_work+0x1d7/0x1ee
[    4.616179]  [<ffffffff810a1b7b>] ? __queue_work+0x1ee/0x1ee
[    4.616181]  [<ffffffff810a1b94>] delayed_work_timer_fn+0x19/0x1b
[    4.616187]  [<ffffffff8109897f>] call_timer_fn+0x6b/0xde
[    4.616189]  [<ffffffff81098914>] ? __internal_add_timer+0xc0/0xc0
[    4.616192]  [<ffffffff81098fa9>] run_timer_softirq+0x16f/0x1da
[    4.616194]  [<ffffffff810a1b7b>] ? __queue_work+0x1ee/0x1ee
[    4.616198]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
[    4.616201]  [<ffffffff81095745>] irq_exit+0x58/0x9e
[    4.616215]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
[    4.616221]  [<ffffffff8185a772>] apic_timer_interrupt+0x72/0x80
[    4.616237]  <EOI>  [<ffffffff810c8e9e>] ? lock_release+0x16e/0x17a
[    4.616243]  [<ffffffff8104a18f>] ? native_safe_halt+0x6/0x8
[    4.616247]  [<ffffffff810c707f>] ? trace_hardirqs_on+0xd/0xf
[    4.616253]  [<ffffffff8103071c>] default_idle+0x13/0x1c
[    4.616259]  [<ffffffff81030e8c>] arch_cpu_idle+0x13/0x21
[    4.616263]  [<ffffffff810bd2d6>] cpu_startup_entry+0xfc/0x164
[    4.616266]  [<ffffffff818484e8>] rest_init+0xbc/0xc3
[    4.616268]  [<ffffffff8184842c>] ? csum_partial_copy_generic+0x16c/0x16c
[    4.616286]  [<ffffffff81e10d71>] start_kernel+0x441/0x44e
[    4.616290]  [<ffffffff81e10739>] ? repair_env_string+0x56/0x56
[    4.616293]  [<ffffffff81e10120>] ? early_idt_handlers+0x120/0x120
[    4.616296]  [<ffffffff81e10453>] x86_64_start_reservations+0x2a/0x2c
[    4.616299]  [<ffffffff81e10531>] x86_64_start_kernel+0xdc/0xeb
[    4.616364] ---[ end trace c00a460c7ab81afb ]---
[    4.670169] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 1
[    4.671671] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 1
[    4.685558] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.686888] vhci_hcd: vhci_hub_control:398: port 0
[    4.688300] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.688650]
[    4.688650] printing PIC contents
[    4.688662] ... PIC  IMR: ffff
[    4.688669] ... PIC  IRR: 1013
[    4.688681] ... PIC  ISR: 0000
[    4.688688] ... PIC ELCR: 0c00
[    4.688700] printing local APIC contents on CPU#0/0:
[    4.688710] ... APIC ID:      00000000 (0)
[    4.688715] ... APIC VERSION: 00050014
[    4.688720] ... APIC TASKPRI: 00000000 (00)
[    4.688725] ... APIC PROCPRI: 00000000
[    4.688729] ... APIC LDR: 01000000
[    4.688734] ... APIC DFR: ffffffff
[    4.688739] ... APIC SPIV: 000001ff
[    4.688740] ... APIC ISR field:
[    4.688776] 0000000000000000000000000000000000000000000000000000000000000000
[    4.688777] ... APIC TMR field:
[    4.688812] 0000000000000000000000000000000000000000000000000000000000000000
[    4.688813] ... APIC IRR field:
[    4.688847] 0000000000000000000000000000000000000000000000000000000000000000
[    4.688856] ... APIC ESR: 00000000
[    4.688865] ... APIC ICR: 000400f6
[    4.688866] ... APIC ICR2: 02000000
[    4.688871] ... APIC LVTT: 000000ef
[    4.688876] ... APIC LVTPC: 00010000
[    4.688880] ... APIC LVT0: 00010700
[    4.688885] ... APIC LVT1: 00000400
[    4.688890] ... APIC LVTERR: 000000fe
[    4.688895] ... APIC TMICT: 0003ccc5
[    4.688900] ... APIC TMCCT: 0002fce4
[    4.688905] ... APIC TDCR: 00000003
[    4.688906]
[    4.688908] number of MP IRQ sources: 15.
[    4.688909] number of IO-APIC #0 registers: 24.
[    4.688910] testing the IO APIC.......................
[    4.688936] IO APIC #0......
[    4.688937] .... register #00: 00000000
[    4.688938] .......    : physical APIC id: 00
[    4.688939] .......    : Delivery Type: 0
[    4.688940] .......    : LTS          : 0
[    4.688942] .... register #01: 00170011
[    4.688943] .......     : max redirection entries: 17
[    4.688944] .......     : PRQ implemented: 0
[    4.688945] .......     : IO APIC version: 11
[    4.688946] .... register #02: 00000000
[    4.688947] .......     : arbitration: 00
[    4.688947] .... IRQ redirection table:
[    4.688966] 1    0    0   0   0    0    0    00
[    4.688983] 0    0    0   0   0    1    1    31
[    4.689000] 0    0    0   0   0    1    1    30
[    4.689016] 0    0    0   0   0    1    1    33
[    4.689033] 1    0    0   0   0    1    1    34
[    4.689051] 1    1    0   0   0    1    1    35
[    4.689067] 0    0    0   0   0    1    1    36
[    4.689083] 0    0    0   0   0    1    1    37
[    4.689100] 0    0    0   0   0    1    1    38
[    4.689117] 0    1    0   0   0    1    1    39
[    4.689135] 1    1    0   0   0    1    1    3A
[    4.689153] 1    1    0   0   0    1    1    3B
[    4.689171] 0    0    0   0   0    1    1    3C
[    4.689189] 0    0    0   0   0    1    1    3D
[    4.689207] 0    0    0   0   0    1    1    3E
[    4.689224] 0    0    0   0   0    1    1    3F
[    4.689242] 1    0    0   0   0    0    0    00
[    4.689260] 1    0    0   0   0    0    0    00
[    4.689276] 1    0    0   0   0    0    0    00
[    4.689298] 1    0    0   0   0    0    0    00
[    4.689315] 1    0    0   0   0    0    0    00
[    4.689333] 1    0    0   0   0    0    0    00
[    4.689351] 1    0    0   0   0    0    0    00
[    4.689368] 1    0    0   0   0    0    0    00
[    4.689369] IRQ to pin mappings:
[    4.689373] IRQ0 -> 0:2
[    4.689375] IRQ1 -> 0:1
[    4.689378] IRQ3 -> 0:3
[    4.689380] IRQ4 -> 0:4
[    4.689383] IRQ5 -> 0:5
[    4.689385] IRQ6 -> 0:6
[    4.689388] IRQ7 -> 0:7
[    4.689390] IRQ8 -> 0:8
[    4.689397] IRQ9 -> 0:9
[    4.689399] IRQ10 -> 0:10
[    4.689402] IRQ11 -> 0:11
[    4.689404] IRQ12 -> 0:12
[    4.689406] IRQ13 -> 0:13
[    4.689412] IRQ14 -> 0:14
[    4.689414] IRQ15 -> 0:15
[    4.689415] .................................... done.
[    4.690250] registered taskstats version 1
[    4.786448] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.788293] rtc-test rtc-test.0: setting system clock to 2013-09-09 06:44:10 UTC (1378709050)
[    4.788359] vhci_hcd: dump_port_status_diff:119:
[    4.788361] vhci_hcd: vhci_hub_control:405:  bye
[    4.788398] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 2
[    4.788400] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 2
[    4.788402] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.788404] vhci_hcd: vhci_hub_control:398: port 1
[    4.788406] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.788408] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.788410] vhci_hcd: dump_port_status_diff:119:
[    4.788411] vhci_hcd: vhci_hub_control:405:  bye
[    4.788419] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 3
[    4.788421] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 3
[    4.788423] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.788424] vhci_hcd: vhci_hub_control:398: port 2
[    4.788426] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.788428] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.788429] vhci_hcd: dump_port_status_diff:119:
[    4.788430] vhci_hcd: vhci_hub_control:405:  bye
[    4.788438] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 4
[    4.788440] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 4
[    4.788442] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.788443] vhci_hcd: vhci_hub_control:398: port 3
[    4.788445] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.788446] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.788448] vhci_hcd: dump_port_status_diff:119:
[    4.788449] vhci_hcd: vhci_hub_control:405:  bye
[    4.788457] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 5
[    4.788458] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 5
[    4.788460] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.788462] vhci_hcd: vhci_hub_control:398: port 4
[    4.788463] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.788465] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.788466] vhci_hcd: dump_port_status_diff:119:
[    4.788468] vhci_hcd: vhci_hub_control:405:  bye
[    4.788476] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 6
[    4.788477] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 6
[    4.788479] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.788480] vhci_hcd: vhci_hub_control:398: port 5
[    4.788482] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.788484] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.788485] vhci_hcd: dump_port_status_diff:119:
[    4.788487] vhci_hcd: vhci_hub_control:405:  bye
[    4.788495] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 7
[    4.788496] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 7
[    4.788498] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.788508] vhci_hcd: vhci_hub_control:398: port 6
[    4.788511] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.788512] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.788514] vhci_hcd: dump_port_status_diff:119:
[    4.788515] vhci_hcd: vhci_hub_control:405:  bye
[    4.788524] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 8
[    4.788526] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 8
[    4.788528] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.788529] vhci_hcd: vhci_hub_control:398: port 7
[    4.788531] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.788532] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.788534] vhci_hcd: dump_port_status_diff:119:
[    4.788535] vhci_hcd: vhci_hub_control:405:  bye
[    4.788818] usb usb1: vhci_bus_suspend
[    4.788836] vhci_hcd: vhci_hub_status:208: changed 0
[    4.899306] debug: unmapping init [mem 0xffffffff81dfc000-0xffffffff81ecefff]
[    5.945463] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
qemu: terminating on signal 2
wfg@bee ~/linux/obj-compiletest% kvm-0day.sh arch/x86/boot/bzImage
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc2-00010-gc817a67-dirty (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #5 SMP PREEMPT Tue Oct 8 09:29:02 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
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
[    0.000000] BRK [0x028a7000, 0x028a7fff] PGTABLE
[    0.000000] BRK [0x028a8000, 0x028a8fff] PGTABLE
[    0.000000] BRK [0x028a9000, 0x028a9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x028aa000, 0x028aafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x028ab000, 0x028abfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128416(97%)
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
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 199068K/261744K available (8557K kernel code, 1784K rwdata, 3968K rodata, 844K init, 10064K bss, 62676K reserved)
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
[    0.000000] ODEBUG: 5 of 5 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=10774032)
[    0.008753] pid_max: default: 32768 minimum: 301
[    0.010233] Mount-cache hash table entries: 256
[    0.011812] Initializing cgroup subsys devices
[    0.012043] Initializing cgroup subsys perf_event
[    0.013236] Initializing cgroup subsys net_prio
[    0.014508] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014508] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014508] tlb_flushall_shift: 6
[    0.016059] debug: unmapping init [mem 0xffffffff81ecf000-0xffffffff81ed2fff]
[    0.021249] ACPI: Core revision 20130517
[    0.026240] ACPI: All ACPI Tables successfully acquired
[    0.028011] Getting VERSION: 50014
[    0.028899] Getting VERSION: 50014
[    0.029775] Getting ID: 0
[    0.030472] Getting ID: ff000000
[    0.031294] Getting LVT0: 8700
[    0.032021] Getting LVT1: 8400
[    0.032887] enabled ExtINT on CPU#0
[    0.035317] ENABLING IO-APIC IRQs
[    0.036024] init IO_APIC IRQs
[    0.036787]  apic 0 pin 0 not connected
[    0.040055] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.041710] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.043143] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.044044] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.045615] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.048053] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.050061] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.052049] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.054068] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.056051] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.058102] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.060044] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.064038] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.067754] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.068048] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.072034]  apic 0 pin 16 not connected
[    0.073017]  apic 0 pin 17 not connected
[    0.074077]  apic 0 pin 18 not connected
[    0.075176]  apic 0 pin 19 not connected
[    0.076008]  apic 0 pin 20 not connected
[    0.077595]  apic 0 pin 21 not connected
[    0.080008]  apic 0 pin 22 not connected
[    0.081915]  apic 0 pin 23 not connected
[    0.084158] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.088007] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.092525] Using local APIC timer interrupts.
[    0.092525] calibrating APIC timer ...
[    0.096000] ... lapic delta = 6233000
[    0.096000] ... PM-Timer delta = 356881
[    0.096000] ... PM-Timer result ok
[    0.096000] ..... delta 6233000
[    0.096000] ..... mult: 267705311
[    0.096000] ..... calibration result: 3989120
[    0.096000] ..... CPU clock speed is 2685.0873 MHz.
[    0.096000] ..... host bus clock speed is 997.1120 MHz.
[    0.096106] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.120570] SMP alternatives: lockdep: fixing up alternatives
[    0.121629] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:e896041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.140257] Brought up 2 CPUs
[    0.140187] KVM setup async PF for cpu 1
[    0.140187] kvm-stealtime: cpu 1, msr dd0ccc0
[    0.144017] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.148805] devtmpfs: initialized
[    0.153250] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.155311] regulator-dummy: no parameters
[    0.156576] NET: Registered protocol family 16
[    0.159034] ACPI: bus type PCI registered
[    0.160177] PCI: Using configuration type 1 for base access
[    0.181111] ACPI: Added _OSI(Module Device)
[    0.182624] ACPI: Added _OSI(Processor Device)
[    0.184019] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.185215] ACPI: Added _OSI(Processor Aggregator Device)
[    0.190492] ACPI: EC: Look up EC in DSDT
[    0.201417] ACPI: Interpreter enabled
[    0.204039] ACPI: (supports S0 S5)
[    0.208015] ACPI: Using IOAPIC for interrupt routing
[    0.212078] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.239280] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.244619] PCI host bridge to bus 0000:00
[    0.248026] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.252034] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.256015] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.257610] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.259571] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.260142] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.264486] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.267258] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.272016] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.275486] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.276698] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.278544] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.280496] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.288085] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.292115] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.306801] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.308912] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.312639] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.315388] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.328621] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.332727] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.341307] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.345227] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.356017] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.360432] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.364762] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.377596] pci_bus 0000:00: on NUMA node 0
[    0.380050] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.388028] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.396739] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.401345] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.405351] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.412163] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.416915] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.421597] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.424043] ACPI: \_SB_.PCI0: notify handler is installed
[    0.428136] Found 1 acpi root devices
[    0.432972] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.440029] vgaarb: loaded
[    0.440609] vgaarb: bridge control possible 0000:00:02.0
[    0.442061] ACPI: bus type USB registered
[    0.442061] usbcore: registered new interface driver usbfs
[    0.444047] usbcore: registered new interface driver hub
[    0.445268] usbcore: registered new device driver usb
[    0.448081] pps_core: LinuxPPS API ver. 1 registered
[    0.449122] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.451156] PTP clock support registered
[    0.452325] wmi: Mapper loaded
[    0.453080] PCI: Using ACPI for IRQ routing
[    0.454056] PCI: pci_cache_line_size set to 64 bytes
[    0.455383] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.456030] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.458159] NET: Registered protocol family 23
[    0.460724] cfg80211: Calling CRDA to update world regulatory domain
[    0.462480] nfc: nfc_init: NFC Core ver 0.1
[    0.464079] NET: Registered protocol family 39
[    0.465761] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.472122] Switched to clocksource kvm-clock
[    0.473251] pnp: PnP ACPI init
[    0.473913] ACPI: bus type PNP registered
[    0.474966] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.476807] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.478333] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.480110] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.481556] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.483282] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.484565] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.486104] pnp 00:03: [dma 2]
[    0.486838] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.488660] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.490844] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.493268] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.495473] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.497793] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.499807] pnp: PnP ACPI: found 7 devices
[    0.502548] ACPI: bus type PNP unregistered
[    0.512560] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.517721] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.524051] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.532086] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.540417] NET: Registered protocol family 2
[    0.547046] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    0.556096] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.565251] TCP: Hash tables configured (established 2048 bind 2048)
[    0.570246] TCP: reno registered
[    0.571179] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.572802] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.576504] NET: Registered protocol family 1
[    0.582664] RPC: Registered named UNIX socket transport module.
[    0.588093] RPC: Registered udp transport module.
[    0.592233] RPC: Registered tcp transport module.
[    0.596400] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.602199] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.607682] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.613098] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.618855] pci 0000:00:02.0: Boot video device
[    0.623120] PCI: CLS 0 bytes, default 64
[    0.627022] Unpacking initramfs...
[    2.418670] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    2.422198] has_svm: not amd
[    2.423494] kvm: no hardware support
[    2.424779] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    2.426607] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    2.430670] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    2.430690] cryptomgr_test (24) used greatest stack depth: 6224 bytes left
[    2.433936] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.435113] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.436369] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.437545] AVX or AES-NI instructions are not detected.
[    2.438559] AVX instructions are not detected.
[    2.439420] AVX instructions are not detected.
[    2.440291] AVX instructions are not detected.
[    2.443992] Initializing RT-Tester: OK
[    2.444794] audit: initializing netlink socket (disabled)
[    2.445899] type=2000 audit(1378709048.176:1): initialized
[    2.450661] DLM installed
[    2.452900] NFS: Registering the id_resolver key type
[    2.454340] Key type id_resolver registered
[    2.455418] Key type id_legacy registered
[    2.456466] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.458618] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.459790] fuse init (API version 7.22)
[    2.476069] ceph: loaded (mds proto 32)
[    2.479014] cryptomgr_test (43) used greatest stack depth: 5768 bytes left
[    2.481356] cryptomgr_test (44) used greatest stack depth: 5696 bytes left
[    2.493173] cryptomgr_test (72) used greatest stack depth: 5280 bytes left
[    2.501786] alg: No test for crc32 (crc32-table)
[    2.503711] alg: No test for lz4hc (lz4hc-generic)
[    2.505095] alg: No test for stdrng (krng)
[    2.506447] NET: Registered protocol family 38
[    2.512887] Key type asymmetric registered
[    2.517118] Asymmetric key parser 'x509' registered
[    2.519463] test_string_helpers: Running tests...
[    2.521414] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    2.522375] crc32: self tests passed, processed 225944 bytes in 309289 nsec
[    2.523817] crc32c: CRC_LE_BITS = 32
[    2.524711] crc32c: self tests passed, processed 225944 bytes in 151191 nsec
[    2.527090] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    2.528131] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    2.529686] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    2.531242] vmlfb: initializing
[    2.531902] Could not find Carillo Ranch MCH device.
[    2.532918] no IO addresses supplied
[    2.533804] hgafb: HGA card not detected.
[    2.534609] hgafb: probe of hgafb.0 failed with error -22
[    2.535964] usbcore: registered new interface driver udlfb
[    2.537439] usbcore: registered new interface driver smscufx
[    2.544719] uvesafb: failed to execute /sbin/v86d
[    2.546025] uvesafb: make sure that the v86d helper is installed and executable
[    2.548494] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    2.550682] uvesafb: vbe_init() failed with -22
[    2.551955] uvesafb: probe of uvesafb.0 failed with error -22
[    2.556349] ipmi message handler version 39.2
[    2.559325] ipmi device interface
[    2.562266] IPMI System Interface driver.
[    2.569161] ipmi_si: Adding default-specified kcs state machine
[    2.570775] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    2.573353] ipmi_si: Interface detection failed
[    2.588194] ipmi_si: Adding default-specified smic state machine
[    2.589409] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    2.591233] ipmi_si: Interface detection failed
[    2.604132] ipmi_si: Adding default-specified bt state machine
[    2.605230] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    2.606937] ipmi_si: Interface detection failed
[    2.616270] kobject: 'ipmi_si' (ffff8800077a3800): kobject_release, parent ffff8800001b7648 (delayed)
[    2.618092] kobject: 'ipmi_si' (ffff8800077a3600): kobject_release, parent ffff880000221248 (delayed)
[    2.619935] kobject: 'ipmi_si' (ffff8800077a3a00): kobject_release, parent ffff880000189248 (delayed)
[    2.621775] ipmi_si: Unable to find any System Interface(s)
[    2.622918] IPMI Watchdog: driver initialized
[    2.623779] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    2.625631] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.626715] ACPI: Power Button [PWRF]
[    2.668901] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.693242] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.699298] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    2.709002] ac.o: No PCI boards found.
[    2.713556] ac.o: For an ISA board you must supply memory and irq parameters.
[    2.722648] Non-volatile memory driver v1.3
[    2.728482] Linux agpgart interface v0.103
[    2.734319] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    2.741862] kobject: 'drm' (ffff880006daf048): kobject_release, parent ffff880000189648 (delayed)
[    2.753174] kobject: 'drm' (ffff880006dad000): kobject_release, parent           (null) (delayed)
[    2.764221] [drm] radeon kernel modesetting enabled.
[    2.771391] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
[    2.778863] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/dri.
[    2.783577] kobject: 'controlD64' (ffff880006dc2820): kobject_release, parent           (null) (delayed)
[    2.791853] cirrus: probe of 0000:00:02.0 failed with error -1
[    2.795666] usbcore: registered new interface driver udl
[    2.798042] parport_pc 00:04: reported by Plug and Play ACPI
[    2.799567] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    2.801747] kobject: 'parport_pc.956' (ffff880006dc2820): kobject_release, parent           (null) (delayed)
[    2.807742] kobject: 'parport_pc.888' (ffff880006dc2020): kobject_release, parent           (null) (delayed)
[    2.810494] kobject: 'parport_pc.632' (ffff880006dca820): kobject_release, parent           (null) (delayed)
[    2.813101] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.814972] dummy-irq: no IRQ given.  Use irq=N
[    2.816267] Phantom Linux Driver, version n0.9.8, init OK
[    2.817855] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    2.824497] c2port c2port0: C2 port uc added
[    2.825602] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    2.827718] Guest personality initialized and is inactive
[    2.829280] VMCI host device registered (name=vmci, major=10, minor=56)
[    2.830926] Initialized host personality
[    2.832135] Driver for timberdale has been successfully registered.
[    2.834270] usbcore: registered new interface driver viperboard
[    2.837324] usbcore: registered new interface driver pn533
[    2.840331] mtdoops: mtd device (mtddev=name/number) must be supplied
[    2.841993] device id = 2440
[    2.842726] device id = 2480
[    2.843433] device id = 24c0
[    2.844233] device id = 24d0
[    2.844977] device id = 25a1
[    2.845715] device id = 2670
[    2.846561] platform physmap-flash.0: failed to claim resource 0
[    2.848148] kobject: 'physmap-flash' (ffff880006ddc800): kobject_release, parent ffff880000189248 (delayed)
[    2.850597] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    2.852226] Could not find PAR responsible for SC520CDP Flash Bank #0
[    2.853842] Trying default address 0x8400000
[    2.854915] Could not find PAR responsible for SC520CDP Flash Bank #1
[    2.856577] Trying default address 0x8c00000
[    2.857656] Could not find PAR responsible for SC520CDP DIL Flash
[    2.859178] Trying default address 0x9400000
[    2.860279] SC520 CDP flash device: 0x800000 at 0x8400000
[    2.861639] Failed to ioremap_nocache
[    2.862567] Failed to ioremap_nocache
[    2.863564] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.865358] kobject: 'docg3' (ffff880006de3c00): kobject_release, parent ffff880000189248 (delayed)
[    2.867627] slram: not enough parameters.
[    2.872257] No valid DiskOnChip devices found
[    2.873463] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.875754] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.878135] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.882363] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.894895] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.906188] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.917607] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    2.929248] flash size: 128 MiB
[    2.931175] page size: 512 bytes
[    2.932266] OOB area size: 16 bytes
[    2.933166] sector size: 16 KiB
[    2.935445] pages number: 262144
[    2.938296] pages per sector: 32
[    2.941153] bus width: 8
[    2.943328] bits in sector size: 14
[    2.946420] bits in page size: 9
[    2.949309] bits in OOB size: 4
[    2.952795] flash size with OOB: 135168 KiB
[    2.958081] page address bytes: 4
[    2.961986] sector address bytes: 3
[    2.965166] options: 0x42
[    2.972265] Scanning device for bad blocks
[    3.027055] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.028664] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.031152] parport0: powerup/reset Butterfly
[    3.148578] parport_pc 00:04: registered master spi42
[    3.149493] parport_pc 00:04: master is unqueued, this is deprecated
[    3.150709] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    3.151681] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    3.153164] parport_pc 00:04: registered child spi42.1
[    3.154540] parport0: dataflash at spi42.1
[    3.156207] parport0: AVR Butterfly
[    3.157303] parport0: cannot grant exclusive access for device spi-lm70llp
[    3.159250] spi-lm70llp: spi_lm70llp probe fail, status -12
[    3.160964] usbcore: registered new interface driver irda-usb
[    3.162346] usbcore: registered new interface driver stir4200
[    3.163774] usbcore: registered new interface driver mcs7780
[    3.165327] usbcore: registered new interface driver kingsun-sir
[    3.166962] usbcore: registered new interface driver ksdazzle-sir
[    3.168543] usbcore: registered new interface driver ks959-sir
[    3.170621] usbcore: registered new interface driver hwa-rc
[    3.172484] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.174064] ohci-pci: OHCI PCI platform driver
[    3.176400] ohci-platform: OHCI generic platform driver
[    3.183675] uhci_hcd: USB Universal Host Controller Interface driver
[    3.191570] driver u132_hcd
[    3.207555] usbcore: registered new interface driver hwa-hc
[    3.212506] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    3.218035] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    3.226248] usbcore: registered new interface driver cdc_wdm
[    3.229400] usbcore: registered new interface driver usbtmc
[    3.235449] usbcore: registered new interface driver appledisplay
[    3.236495] usbcore: registered new interface driver emi26 - firmware loader
[    3.237563] usbcore: registered new interface driver emi62 - firmware loader
[    3.238575] driver ftdi-elan
[    3.239721] usbcore: registered new interface driver ftdi-elan
[    3.240616] usbcore: registered new interface driver idmouse
[    3.241485] usbcore: registered new interface driver usblcd
[    3.242300] usbcore: registered new interface driver ldusb
[    3.243116] usbcore: registered new interface driver usbled
[    3.244072] usbcore: registered new interface driver legousbtower
[    3.244958] usbcore: registered new interface driver rio500
[    3.245792] usbcore: registered new interface driver usbtest
[    3.246659] usbcore: registered new interface driver trancevibrator
[    3.248058] usbcore: registered new interface driver uss720
[    3.249115] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[    3.251364] uss720: NOTE: this is a special purpose driver to allow nonstandard
[    3.252931] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[    3.254329] uss720: If you just want to connect to a printer, use usblp instead
[    3.255761] usbcore: registered new interface driver yurex
[    3.256952] kobject: 'gpio-vbus' (ffff88000681c400): kobject_release, parent ffff880000189248 (delayed)
[    3.258876] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.261485] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.262548] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.263484] parport0: cannot grant exclusive access for device parkbd
[    3.335771] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    3.337691] usbcore: registered new interface driver bcm5974
[    3.338328] kobject: '(null)' (ffff880006831af0): kobject_release, parent           (null) (delayed)
[    3.341408] usbcore: registered new interface driver synaptics_usb
[    3.342586] usbcore: registered new interface driver iforce
[    3.343563] parport0: cannot grant exclusive access for device walkera0701
[    3.344603] walkera0701: failed to register parport device
[    3.346459] usbcore: registered new interface driver usbtouchscreen
[    3.348757] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    3.350099] usbcore: registered new interface driver ati_remote2
[    3.351323] cm109: Keymap for Komunikate KIP1000 phone loaded
[    3.356139] usbcore: registered new interface driver cm109
[    3.357273] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    3.358775] usbcore: registered new interface driver keyspan_remote
[    3.362589] usbcore: registered new interface driver yealink
[    3.364099] I2O subsystem v1.325
[    3.365757] i2o: max drivers = 8
[    3.368144] I2O Configuration OSM v1.323
[    3.369503] I2O ProcFS OSM v1.316
[    3.370485] kobject: 'proc-osm' (ffff880006848200): kobject_release, parent ffff880006848c48 (delayed)
[    3.373415] kobject: 'mc13xxx-rtc' (ffff880006850200): kobject_release, parent ffff880000189248 (delayed)
[    3.376317] kobject: 'rtc-msm6242' (ffff880006850000): kobject_release, parent ffff880000189248 (delayed)
[    3.378760] kobject: 'pcap-rtc' (ffff880006852e00): kobject_release, parent ffff880000189248 (delayed)
[    3.386407] kobject: 'rtc-rp5c01' (ffff880006855e00): kobject_release, parent ffff880000189248 (delayed)
[    3.396825] rtc rtc0: test: dev (254:0)
[    3.400229] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    3.406553] rtc rtc1: test: dev (254:1)
[    3.410022] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    3.415952] i2c /dev entries driver
[    3.419675] usbcore: registered new interface driver i2c-diolan-u2c
[    3.424274] tsc: Refined TSC clocksource calibration: 2693.461 MHz
[    3.433820] i2c-parport: adapter type unspecified
[    3.438015] i2c-parport-light: adapter type unspecified
[    3.444061] pps pps0: new PPS source ktimer
[    3.447928] pps pps0: ktimer PPS source registered
[    3.452631] pps_parport: parallel port PPS client
[    3.456966] parport0: cannot grant exclusive access for device pps_parport
[    3.464788] pps_parport: couldn't register with parport0
[    3.471276] Driver for 1-wire Dallas network protocol.
[    3.478095] usbcore: registered new interface driver DS9490R
[    3.485491] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.494093] power_supply test_ac: uevent
[    3.499234] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    3.506513] power_supply test_ac: prop ONLINE=1
[    3.512357] power_supply test_ac: power_supply_changed
[    3.517982] power_supply test_ac: power_supply_changed_work
[    3.523381] power_supply test_battery: uevent
[    3.524311] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    3.525483] power_supply test_battery: prop STATUS=Discharging
[    3.526578] power_supply test_battery: prop CHARGE_TYPE=Fast
[    3.527740] power_supply test_battery: prop HEALTH=Good
[    3.528856] power_supply test_battery: prop PRESENT=1
[    3.529878] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    3.530962] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    3.532461] power_supply test_battery: prop CHARGE_FULL=100
[    3.533806] power_supply test_battery: prop CHARGE_NOW=50
[    3.535415] power_supply test_battery: prop CAPACITY=50
[    3.536216] power_supply test_ac: power_supply_update_gen_leds 1
[    3.536231] power_supply test_ac: uevent
[    3.536233] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    3.536246] power_supply test_ac: prop ONLINE=1
[    3.542819] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    3.544552] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    3.546377] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    3.551779] power_supply test_battery: prop MODEL_NAME=Test battery
[    3.557613] power_supply test_battery: prop MANUFACTURER=Linux
[    3.562900] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    3.587263] power_supply test_battery: prop TEMP=26
[    3.592420] power_supply test_battery: prop VOLTAGE_NOW=3300
[    3.595618] power_supply test_battery: power_supply_changed
[    3.597127] power_supply test_battery: power_supply_changed_work
[    3.598687] power_supply test_battery: power_supply_update_bat_leds 2
[    3.600726] power_supply test_battery: uevent
[    3.600782] power_supply test_usb: uevent
[    3.600785] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    3.600798] power_supply test_usb: prop ONLINE=1
[    3.600820] power_supply test_usb: power_supply_changed
[    3.601614] applesmc: supported laptop not found!
[    3.601616] applesmc: driver init failed (ret=-19)!
[    3.601936] f71882fg: Not a Fintek device
[    3.601976] f71882fg: Not a Fintek device
[    3.602822] kobject: 'mc13783-adc' (ffff88000688a600): kobject_release, parent ffff880000189248 (delayed)
[    3.602991] pc87360: PC8736x not detected, module not inserted
[    3.603713] cpuidle: using governor ladder
[    3.603716] cpuidle: using governor menu
[    3.603736] sdhci: Secure Digital Host Controller Interface driver
[    3.603737] sdhci: Copyright(c) Pierre Ossman
[    3.604128] power_supply test_usb: power_supply_changed_work
[    3.604135] power_supply test_usb: power_supply_update_gen_leds 1
[    3.604143] power_supply test_usb: uevent
[    3.604145] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    3.604163] power_supply test_usb: prop ONLINE=1
[    3.604556] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    3.604556] usbcore: registered new interface driver vub300
[    3.604595] usbcore: registered new interface driver ushc
[    3.604597] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.605296] ledtrig-cpu: registered to indicate activity on CPUs
[    3.605609] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    3.607016] usbcore: registered new interface driver usbhid
[    3.607017] usbhid: USB HID core driver
[    3.607068] usbip_core: usbip_core_init:804: USB/IP Core v1.0.0
[    3.607298] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    3.607310] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    3.607387] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 1
[    3.607406] vhci_hcd: vhci_start:884: enter vhci_start
[    3.608419] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.608423] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.608426] usb usb1: Product: USB/IP Virtual Host Controller
[    3.608428] usb usb1: Manufacturer: Linux 3.11.0-rc2-00010-gc817a67-dirty vhci_hcd
[    3.608431] usb usb1: SerialNumber: vhci_hcd
[    3.648161] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    3.650180] power_supply test_battery: prop STATUS=Discharging
[    3.652217] power_supply test_battery: prop CHARGE_TYPE=Fast
[    3.652996] hub 1-0:1.0: USB hub found
[    3.653034] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIndex 0
[    3.653081] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
[    3.653083] vhci_hcd: vhci_hub_control:398: port -1
[    3.653085] vhci_hcd: vhci_hub_control:405:  bye
[    3.653101] hub 1-0:1.0: 8 ports detected
[    3.653160] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex 0
[    3.653170] vhci_hcd: vhci_hub_control:309:  GetHubStatus
[    3.653172] vhci_hcd: vhci_hub_control:398: port -1
[    3.653173] vhci_hcd: vhci_hub_control:405:  bye
[    3.653786] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 1
[    3.653789] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.653791] vhci_hcd: vhci_hub_control:398: port 0
[    3.653793] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.653794] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.653796] vhci_hcd: dump_port_status_diff:119:
[    3.653798] vhci_hcd: vhci_hub_control:405:  bye
[    3.653806] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 2
[    3.653808] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.653810] vhci_hcd: vhci_hub_control:398: port 1
[    3.653811] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.653813] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.653814] vhci_hcd: dump_port_status_diff:119:
[    3.653816] vhci_hcd: vhci_hub_control:405:  bye
[    3.653823] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 3
[    3.653825] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.653826] vhci_hcd: vhci_hub_control:398: port 2
[    3.653828] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.653829] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.653830] vhci_hcd: dump_port_status_diff:119:
[    3.653831] vhci_hcd: vhci_hub_control:405:  bye
[    3.653838] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 4
[    3.653840] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.653846] vhci_hcd: vhci_hub_control:398: port 3
[    3.653848] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.653850] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.653851] vhci_hcd: dump_port_status_diff:119:
[    3.653852] vhci_hcd: vhci_hub_control:405:  bye
[    3.653859] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 5
[    3.653861] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.653863] vhci_hcd: vhci_hub_control:398: port 4
[    3.653865] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.653866] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.653867] vhci_hcd: dump_port_status_diff:119:
[    3.653869] vhci_hcd: vhci_hub_control:405:  bye
[    3.653875] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 6
[    3.653878] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.653883] vhci_hcd: vhci_hub_control:398: port 5
[    3.653885] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.653886] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.653888] vhci_hcd: dump_port_status_diff:119:
[    3.653889] vhci_hcd: vhci_hub_control:405:  bye
[    3.653895] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 7
[    3.653897] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.653898] vhci_hcd: vhci_hub_control:398: port 6
[    3.653900] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.653901] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.653902] vhci_hcd: dump_port_status_diff:119:
[    3.653904] vhci_hcd: vhci_hub_control:405:  bye
[    3.653909] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 8
[    3.653911] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.653913] vhci_hcd: vhci_hub_control:398: port 7
[    3.653914] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.653915] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.653917] vhci_hcd: dump_port_status_diff:119:
[    3.653918] vhci_hcd: vhci_hub_control:405:  bye
[    3.654155] vhci_hcd: vhci_hcd_probe:1034: bye
[    3.654164] vhci_hcd: vhci_hcd_init:1156: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.0.0
[    3.897231] BUG: unable to handle kernel [    3.897239] usbcore: registered new interface driver usbip-host
[    3.897243] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
[    3.897271] usbcore: registered new interface driver tranzport
[    3.897285] usbcore: registered new interface driver alphatrack
[    3.897287] vme_user: VME User Space Access Driver
[    3.897287] vme_user: No cards, skipping registration
[    3.898207] Loading crystalhd 0.9.27
[    3.898287] usbcore: registered new interface driver ft1000usb
[    3.898354] usbcore: registered new interface driver gdm_wimax
[    3.898396] usbcore: registered new interface driver cedusb
NULL pointer dereference at 0000000000000008
[    3.901119] IP: [<ffffffff81098f60>] run_timer_softirq+0x126/0x1da
[    3.901119] PGD 0
[    3.901119] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    3.901119] CPU: 1 PID: 22 Comm: kworker/1:1 Not tainted 3.11.0-rc2-00010-gc817a67-dirty #5
[    3.901119] Workqueue: events power_supply_changed_work
[    3.901119] task: ffff8800002dc5c0 ti: ffff8800002de000 task.ti: ffff8800002de000
[    3.901119] RIP: 0010:[<ffffffff81098f60>]  [<ffffffff81098f60>] run_timer_softirq+0x126/0x1da
[    3.901119] RSP: 0000:ffff88000dd03ea8  EFLAGS: 00010002
[    3.901119] RAX: ffff880006dc28a0 RBX: ffff88000015c000 RCX: ffff88000dd03ec8
[    3.901119] RDX: ffff880006dc2860 RSI: ffffffff810a1b7b RDI: 0000000000000000
[    3.901119] RBP: ffff88000dd03f08 R08: 0000000000000002 R09: dead000000200200
[    3.901119] R10: ffff88000015c018 R11: ffff8800002dc5c0 R12: ffff88000dd03ec8
[    3.901119] R13: ffff88000015d858 R14: ffff88000015d458 R15: ffff88000015d058
[    3.901119] FS:  0000000000000000(0000) GS:ffff88000dd00000(0000) knlGS:0000000000000000
[    3.901119] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    3.901119] CR2: 0000000000000008 CR3: 0000000001c47000 CR4: 00000000000006a0
[    3.901119] Stack:
[    3.901119]  ffff88000dd0e1b0 ffff88000dd0e170 ffffffff810a1b7b 000000c000000000
[    3.901119]  ffff880006dc28a0 ffff88000dd0e300 ffff88000dd03ef8 ffff8800002dffd8
[    3.901119]  ffffffff81c43088 0000000010000100 0000000000000141 0000000000000001
[    3.901119] Call Trace:
[    3.901119]  <IRQ>
[    3.901119]  [<ffffffff810a1b7b>] ? __queue_work+0x1ee/0x1ee
[    3.901119]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
[    3.901119]  [<ffffffff81095745>] irq_exit+0x58/0x9e
[    3.901119]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
[    3.901119]  [<ffffffff8185a772>] apic_timer_interrupt+0x72/0x80
[    3.901119]  <EOI>
[    3.901119]  [<ffffffff81859277>] ? retint_restore_args+0x13/0x13
[    3.901119]  [<ffffffff810af994>] ? arch_local_irq_enable+0xb/0xd
[    3.901119]  [<ffffffff810c707f>] ? trace_hardirqs_on+0xd/0xf
[    3.901119]  [<ffffffff81857904>] preempt_schedule_irq+0x36/0x5a
[    3.901119]  [<ffffffff818593a6>] retint_kernel+0x26/0x30
[    3.901119]  [<ffffffff8108f47c>] ? arch_local_irq_restore+0x6/0xd
[    3.901119]  [<ffffffff81090db8>] vprintk_emit+0x3f9/0x422
[    3.901119]  [<ffffffff8121a640>] ? snprintf+0x34/0x36
[    3.901119]  [<ffffffff81483ca2>] dev_vprintk_emit+0x1a3/0x1c9
[    3.901119]  [<ffffffff81219385>] ? string.isra.3+0x3d/0xa2
[    3.901119]  [<ffffffff81483cfc>] dev_printk_emit+0x34/0x36
[    3.901119]  [<ffffffff81483d6f>] __dev_printk+0x71/0x78
[    3.901119]  [<ffffffff81483db6>] dev_printk+0x40/0x42
[    3.901119]  [<ffffffff8111b1b4>] ? __kmalloc+0x93/0xb8
[    3.901119]  [<ffffffff815dd5a4>] power_supply_uevent+0x183/0x1ec
[    3.901119]  [<ffffffff81483451>] dev_uevent+0x179/0x1a2
[    3.901119]  [<ffffffff812130dc>] ? kzalloc+0xf/0x11
[    3.901119]  [<ffffffff812142ce>] kobject_uevent_env+0x195/0x414
[    3.901119]  [<ffffffff81214558>] kobject_uevent+0xb/0xd
[    3.901119]  [<ffffffff815dcc14>] power_supply_changed_work+0x60/0x65
[    3.901119]  [<ffffffff810a2733>] process_one_work+0x1de/0x2fd
[    3.901119]  [<ffffffff810a26c9>] ? process_one_work+0x174/0x2fd
[    3.901119]  [<ffffffff810a2c54>] worker_thread+0x159/0x1ee
[    3.901119]  [<ffffffff810a2afb>] ? rescuer_thread+0x27f/0x27f
[    3.901119]  [<ffffffff810a859a>] kthread+0xac/0xb4
[    3.901119]  [<ffffffff810a84ee>] ? __kthread_parkme+0x68/0x68
[    3.901119]  [<ffffffff81859a3c>] ret_from_fork+0x7c/0xb0
[    3.901119]  [<ffffffff810a84ee>] ? __kthread_parkme+0x68/0x68
[    3.901119] Code: 08 e9 99 00 00 00 4c 8b 40 18 48 8b 70 20 49 b9 00 02 20 00 00 00 ad de 48 8b 50 28 48 89 43 38 48 8b 38 48 8b 48 08 41 83 e0 02 <48> 89 4f 08 48 89 39 f6 40 18 01 48 c7 00 00 00 00 00 4c 89 48
[    3.901119] RIP  [<ffffffff81098f60>] run_timer_softirq+0x126/0x1da
[    3.901119]  RSP <ffff88000dd03ea8>
[    3.901119] CR2: 0000000000000008
[    3.901119] ---[ end trace 5741fbcc66ae6539 ]---
[    3.901119] Kernel panic - not syncing: Fatal exception in interrupt
[    3.901119] Rebooting in 10 seconds..%                                                                                                  wfg@bee ~/linux/obj-compiletest%
wfg@bee ~/linux/obj-compiletest% kvm-0day.sh arch/x86/boot/bzImage
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc2-00010-gc817a67-dirty (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #5 SMP PREEMPT Tue Oct 8 09:29:02 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
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
[    0.000000] BRK [0x028a7000, 0x028a7fff] PGTABLE
[    0.000000] BRK [0x028a8000, 0x028a8fff] PGTABLE
[    0.000000] BRK [0x028a9000, 0x028a9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x028aa000, 0x028aafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x028ab000, 0x028abfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128416(97%)
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
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 199068K/261744K available (8557K kernel code, 1784K rwdata, 3968K rodata, 844K init, 10064K bss, 62676K reserved)
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
[    0.000000] ODEBUG: 5 of 5 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=10774032)
[    0.008017] pid_max: default: 32768 minimum: 301
[    0.009463] Mount-cache hash table entries: 256
[    0.011282] Initializing cgroup subsys devices
[    0.012049] Initializing cgroup subsys perf_event
[    0.013300] Initializing cgroup subsys net_prio
[    0.016066] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.016066] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.016066] tlb_flushall_shift: 6
[    0.019701] debug: unmapping init [mem 0xffffffff81ecf000-0xffffffff81ed2fff]
[    0.021437] ACPI: Core revision 20130517
[    0.025985] ACPI: All ACPI Tables successfully acquired
[    0.027789] Getting VERSION: 50014
[    0.028026] Getting VERSION: 50014
[    0.028960] Getting ID: 0
[    0.029611] Getting ID: ff000000
[    0.030386] Getting LVT0: 8700
[    0.032028] Getting LVT1: 8400
[    0.036096] enabled ExtINT on CPU#0
[    0.041304] ENABLING IO-APIC IRQs
[    0.042257] init IO_APIC IRQs
[    0.043468]  apic 0 pin 0 not connected
[    0.044054] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.048111] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.052047] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.053989] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.056058] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.060063] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.064062] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.066135] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.068044] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.070087] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.072053] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.076065] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.080042] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.082938] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.084056] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.088039]  apic 0 pin 16 not connected
[    0.089067]  apic 0 pin 17 not connected
[    0.090080]  apic 0 pin 18 not connected
[    0.092014]  apic 0 pin 19 not connected
[    0.093028]  apic 0 pin 20 not connected
[    0.094027]  apic 0 pin 21 not connected
[    0.094993]  apic 0 pin 22 not connected
[    0.096015]  apic 0 pin 23 not connected
[    0.097244] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.099201] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.101971] Using local APIC timer interrupts.
[    0.101971] calibrating APIC timer ...
[    0.108000] ... lapic delta = 6249507
[    0.108000] ... PM-Timer delta = 357881
[    0.108000] ... PM-Timer result ok
[    0.108000] ..... delta 6249507
[    0.108000] ..... mult: 268414281
[    0.108000] ..... calibration result: 3999684
[    0.108000] ..... CPU clock speed is 2692.3570 MHz.
[    0.108000] ..... host bus clock speed is 999.3684 MHz.
[    0.108105] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.132590] SMP alternatives: lockdep: fixing up alternatives
[    0.134004] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:e896041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.156198] Brought up 2 CPUs
[    0.156129] KVM setup async PF for cpu 1
[    0.156129] kvm-stealtime: cpu 1, msr dd0ccc0
[    0.164026] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.172878] devtmpfs: initialized
[    0.176992] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.179094] regulator-dummy: no parameters
[    0.180507] NET: Registered protocol family 16
[    0.183361] ACPI: bus type PCI registered
[    0.188197] PCI: Using configuration type 1 for base access
[    0.205417] ACPI: Added _OSI(Module Device)
[    0.205603] ACPI: Added _OSI(Processor Device)
[    0.206394] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.208012] ACPI: Added _OSI(Processor Aggregator Device)
[    0.211002] ACPI: EC: Look up EC in DSDT
[    0.219134] ACPI: Interpreter enabled
[    0.220041] ACPI: (supports S0 S5)
[    0.224027] ACPI: Using IOAPIC for interrupt routing
[    0.228119] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.246281] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.248418] PCI host bridge to bus 0000:00
[    0.252025] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.260058] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.262813] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.268033] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.276036] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.284116] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.288111] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.291113] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.296020] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.299294] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.304381] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.306821] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.308445] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.316864] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.320908] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.334180] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.336933] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.340934] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.344612] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.354101] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.356806] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.361649] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.364612] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.372018] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.376519] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.380798] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.388750] pci_bus 0000:00: on NUMA node 0
[    0.396110] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.400026] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.406859] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.408796] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.410704] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.412739] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.414567] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.417458] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.418679] ACPI: \_SB_.PCI0: notify handler is installed
[    0.420149] Found 1 acpi root devices
[    0.425243] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.432042] vgaarb: loaded
[    0.436015] vgaarb: bridge control possible 0000:00:02.0
[    0.444757] ACPI: bus type USB registered
[    0.448149] usbcore: registered new interface driver usbfs
[    0.452051] usbcore: registered new interface driver hub
[    0.455174] usbcore: registered new device driver usb
[    0.464208] pps_core: LinuxPPS API ver. 1 registered
[    0.468016] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.476119] PTP clock support registered
[    0.480463] wmi: Mapper loaded
[    0.484154] PCI: Using ACPI for IRQ routing
[    0.492053] PCI: pci_cache_line_size set to 64 bytes
[    0.500311] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.504075] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.508186] NET: Registered protocol family 23
[    0.510220] cfg80211: Calling CRDA to update world regulatory domain
[    0.516125] nfc: nfc_init: NFC Core ver 0.1
[    0.517116] NET: Registered protocol family 39
[    0.518659] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.523139] Switched to clocksource kvm-clock
[    0.524478] pnp: PnP ACPI init
[    0.527460] ACPI: bus type PNP registered
[    0.530144] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.532434] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.534203] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.536418] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.541043] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.549049] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.555018] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.561993] pnp 00:03: [dma 2]
[    0.564891] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.571534] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.576771] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.578573] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.580839] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.583019] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.585031] pnp: PnP ACPI: found 7 devices
[    0.588314] ACPI: bus type PNP unregistered
[    0.600594] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.602253] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.603642] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.605107] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.607195] NET: Registered protocol family 2
[    0.613758] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    0.617530] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.620599] TCP: Hash tables configured (established 2048 bind 2048)
[    0.622368] TCP: reno registered
[    0.623233] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.624946] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.627175] NET: Registered protocol family 1
[    0.636669] RPC: Registered named UNIX socket transport module.
[    0.637823] RPC: Registered udp transport module.
[    0.638710] RPC: Registered tcp transport module.
[    0.639550] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.640827] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.641900] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.643040] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.644264] pci 0000:00:02.0: Boot video device
[    0.645164] PCI: CLS 0 bytes, default 64
[    0.646220] Unpacking initramfs...
[    2.550534] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    2.553747] has_svm: not amd
[    2.554420] kvm: no hardware support
[    2.555851] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    2.566661] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    2.573950] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    2.573984] cryptomgr_test (24) used greatest stack depth: 6224 bytes left
[    2.576991] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.578069] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.579153] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.580335] AVX or AES-NI instructions are not detected.
[    2.581263] AVX instructions are not detected.
[    2.582070] AVX instructions are not detected.
[    2.582858] AVX instructions are not detected.
[    2.589536] Initializing RT-Tester: OK
[    2.590784] audit: initializing netlink socket (disabled)
[    2.592308] type=2000 audit(1378709049.127:1): initialized
[    2.599024] DLM installed
[    2.603309] NFS: Registering the id_resolver key type
[    2.604456] Key type id_resolver registered
[    2.605224] Key type id_legacy registered
[    2.605969] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.607594] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.608855] fuse init (API version 7.22)
[    2.611468] ceph: loaded (mds proto 32)
[    2.619585] cryptomgr_test (43) used greatest stack depth: 5696 bytes left
[    2.622236] cryptomgr_test (46) used greatest stack depth: 5688 bytes left
[    2.624249] cryptomgr_test (47) used greatest stack depth: 5280 bytes left
[    2.656779] alg: No test for crc32 (crc32-table)
[    2.665468] alg: No test for lz4hc (lz4hc-generic)
[    2.667020] alg: No test for stdrng (krng)
[    2.668334] NET: Registered protocol family 38
[    2.669106] Key type asymmetric registered
[    2.669862] Asymmetric key parser 'x509' registered
[    2.670724] test_string_helpers: Running tests...
[    2.672341] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    2.673178] crc32: self tests passed, processed 225944 bytes in 308271 nsec
[    2.674335] crc32c: CRC_LE_BITS = 32
[    2.674957] crc32c: self tests passed, processed 225944 bytes in 150514 nsec
[    2.677264] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    2.678179] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    2.679403] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    2.680624] vmlfb: initializing
[    2.681107] Could not find Carillo Ranch MCH device.
[    2.682091] no IO addresses supplied
[    2.682881] hgafb: HGA card not detected.
[    2.683602] hgafb: probe of hgafb.0 failed with error -22
[    2.684531] usbcore: registered new interface driver udlfb
[    2.686055] usbcore: registered new interface driver smscufx
[    2.688696] uvesafb: failed to execute /sbin/v86d
[    2.689939] uvesafb: make sure that the v86d helper is installed and executable
[    2.691896] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    2.694331] uvesafb: vbe_init() failed with -22
[    2.696445] uvesafb: probe of uvesafb.0 failed with error -22
[    2.698076] ipmi message handler version 39.2
[    2.699137] ipmi device interface
[    2.700119] IPMI System Interface driver.
[    2.701500] ipmi_si: Adding default-specified kcs state machine
[    2.703034] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    2.707309] ipmi_si: Interface detection failed
[    2.724274] ipmi_si: Adding default-specified smic state machine
[    2.725452] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    2.727204] ipmi_si: Interface detection failed
[    2.740191] ipmi_si: Adding default-specified bt state machine
[    2.741550] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    2.743343] ipmi_si: Interface detection failed
[    2.756392] kobject: 'ipmi_si' (ffff880007764a00): kobject_release, parent ffff8800001b7648 (delayed)
[    2.758091] kobject: 'ipmi_si' (ffff880007764800): kobject_release, parent ffff880000221248 (delayed)
[    2.759858] kobject: 'ipmi_si' (ffff880007764c00): kobject_release, parent ffff880000189248 (delayed)
[    2.761609] ipmi_si: Unable to find any System Interface(s)
[    2.762741] IPMI Watchdog: driver initialized
[    2.763529] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    2.765403] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.766693] ACPI: Power Button [PWRF]
[    2.864338] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.887946] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.891274] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    2.899007] ac.o: No PCI boards found.
[    2.903578] ac.o: For an ISA board you must supply memory and irq parameters.
[    2.912512] Non-volatile memory driver v1.3
[    2.917616] Linux agpgart interface v0.103
[    2.923278] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    2.929669] kobject: 'drm' (ffff880006db2848): kobject_release, parent ffff880000189648 (delayed)
[    2.932143] kobject: 'drm' (ffff880006daf000): kobject_release, parent           (null) (delayed)
[    2.934488] [drm] radeon kernel modesetting enabled.
[    2.936881] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
[    2.938429] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/dri.
[    2.941844] kobject: 'controlD64' (ffff880006db2020): kobject_release, parent           (null) (delayed)
[    2.944735] cirrus: probe of 0000:00:02.0 failed with error -1
[    2.947604] usbcore: registered new interface driver udl
[    2.954454] parport_pc 00:04: reported by Plug and Play ACPI
[    2.956257] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    2.958432] kobject: 'parport_pc.956' (ffff880006db2020): kobject_release, parent           (null) (delayed)
[    2.965698] kobject: 'parport_pc.888' (ffff880006dc5820): kobject_release, parent           (null) (delayed)
[    2.972583] kobject: 'parport_pc.632' (ffff880006dc5020): kobject_release, parent           (null) (delayed)
[    2.975615] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.991611] dummy-irq: no IRQ given.  Use irq=N
[    2.992619] Phantom Linux Driver, version n0.9.8, init OK
[    2.996828] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    3.000140] c2port c2port0: C2 port uc added
[    3.001107] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    3.009055] Guest personality initialized and is inactive
[    3.013408] VMCI host device registered (name=vmci, major=10, minor=56)
[    3.015047] Initialized host personality
[    3.016297] Driver for timberdale has been successfully registered.
[    3.018138] usbcore: registered new interface driver viperboard
[    3.019688] usbcore: registered new interface driver pn533
[    3.021592] mtdoops: mtd device (mtddev=name/number) must be supplied
[    3.023705] device id = 2440
[    3.024551] device id = 2480
[    3.025546] device id = 24c0
[    3.026305] device id = 24d0
[    3.027081] device id = 25a1
[    3.027773] device id = 2670
[    3.029091] platform physmap-flash.0: failed to claim resource 0
[    3.031704] kobject: 'physmap-flash' (ffff880006ddc800): kobject_release, parent ffff880000189248 (delayed)
[    3.034228] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    3.037429] Could not find PAR responsible for SC520CDP Flash Bank #0
[    3.039536] Trying default address 0x8400000
[    3.043086] Could not find PAR responsible for SC520CDP Flash Bank #1
[    3.044761] Trying default address 0x8c00000
[    3.045844] Could not find PAR responsible for SC520CDP DIL Flash
[    3.047642] Trying default address 0x9400000
[    3.048892] SC520 CDP flash device: 0x800000 at 0x8400000
[    3.050145] Failed to ioremap_nocache
[    3.050995] Failed to ioremap_nocache
[    3.051925] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.055119] kobject: 'docg3' (ffff880006de3c00): kobject_release, parent ffff880000189248 (delayed)
[    3.058149] slram: not enough parameters.
[    3.062881] No valid DiskOnChip devices found
[    3.066336] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.078921] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.090565] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.100196] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.109565] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.114362] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.123427] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    3.134830] flash size: 128 MiB
[    3.137674] page size: 512 bytes
[    3.140543] OOB area size: 16 bytes
[    3.142975] sector size: 16 KiB
[    3.143830] pages number: 262144
[    3.144716] pages per sector: 32
[    3.147387] bus width: 8
[    3.149717] bits in sector size: 14
[    3.152305] bits in page size: 9
[    3.153200] bits in OOB size: 4
[    3.154016] flash size with OOB: 135168 KiB
[    3.155055] page address bytes: 4
[    3.156198] sector address bytes: 3
[    3.157477] options: 0x42
[    3.162940] Scanning device for bad blocks
[    3.210524] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.215991] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.218426] parport0: powerup/reset Butterfly
[    3.332928] parport_pc 00:04: registered master spi42
[    3.333844] parport_pc 00:04: master is unqueued, this is deprecated
[    3.335127] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    3.336259] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    3.337635] parport_pc 00:04: registered child spi42.1
[    3.338509] parport0: dataflash at spi42.1
[    3.339243] parport0: AVR Butterfly
[    3.340078] parport0: cannot grant exclusive access for device spi-lm70llp
[    3.343701] spi-lm70llp: spi_lm70llp probe fail, status -12
[    3.349337] usbcore: registered new interface driver irda-usb
[    3.356416] usbcore: registered new interface driver stir4200
[    3.363806] usbcore: registered new interface driver mcs7780
[    3.371667] usbcore: registered new interface driver kingsun-sir
[    3.379302] usbcore: registered new interface driver ksdazzle-sir
[    3.383248] usbcore: registered new interface driver ks959-sir
[    3.385326] usbcore: registered new interface driver hwa-rc
[    3.386945] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.388564] ohci-pci: OHCI PCI platform driver
[    3.391408] ohci-platform: OHCI generic platform driver
[    3.394895] uhci_hcd: USB Universal Host Controller Interface driver
[    3.401258] driver u132_hcd
[    3.417537] usbcore: registered new interface driver hwa-hc
[    3.420080] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    3.421946] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    3.425609] usbcore: registered new interface driver cdc_wdm
[    3.429966] usbcore: registered new interface driver usbtmc
[    3.437057] usbcore: registered new interface driver appledisplay
[    3.438711] usbcore: registered new interface driver emi26 - firmware loader
[    3.440890] usbcore: registered new interface driver emi62 - firmware loader
[    3.443008] driver ftdi-elan
[    3.444963] usbcore: registered new interface driver ftdi-elan
[    3.446505] usbcore: registered new interface driver idmouse
[    3.450901] usbcore: registered new interface driver usblcd
[    3.455960] usbcore: registered new interface driver ldusb
[    3.460948] usbcore: registered new interface driver usbled
[    3.465310] usbcore: registered new interface driver legousbtower
[    3.470208] usbcore: registered new interface driver rio500
[    3.475214] usbcore: registered new interface driver usbtest
[    3.478069] usbcore: registered new interface driver trancevibrator
[    3.479714] usbcore: registered new interface driver uss720
[    3.481199] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[    3.483997] uss720: NOTE: this is a special purpose driver to allow nonstandard
[    3.487579] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[    3.489708] uss720: If you just want to connect to a printer, use usblp instead
[    3.494738] usbcore: registered new interface driver yurex
[    3.496256] kobject: 'gpio-vbus' (ffff880006817400): kobject_release, parent ffff880000189248 (delayed)
[    3.499210] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.502666] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.503632] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.504389] parport0: cannot grant exclusive access for device parkbd
[    3.552224] tsc: Refined TSC clocksource calibration: 2693.465 MHz
[    3.600996] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    3.616517] usbcore: registered new interface driver bcm5974
[    3.617868] usbcore: registered new interface driver synaptics_usb
[    3.619023] kobject: '(null)' (ffff88000777baf0): kobject_release, parent           (null) (delayed)
[    3.623341] usbcore: registered new interface driver iforce
[    3.630622] parport0: cannot grant exclusive access for device walkera0701
[    3.632167] walkera0701: failed to register parport device
[    3.634032] usbcore: registered new interface driver usbtouchscreen
[    3.635924] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    3.637150] usbcore: registered new interface driver ati_remote2
[    3.638341] cm109: Keymap for Komunikate KIP1000 phone loaded
[    3.639516] usbcore: registered new interface driver cm109
[    3.640715] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    3.642276] usbcore: registered new interface driver keyspan_remote
[    3.644537] usbcore: registered new interface driver yealink
[    3.648919] I2O subsystem v1.325
[    3.649884] i2o: max drivers = 8
[    3.651534] I2O Configuration OSM v1.323
[    3.656625] I2O ProcFS OSM v1.316
[    3.657587] kobject: 'proc-osm' (ffff88000684be00): kobject_release, parent ffff880006849848 (delayed)
[    3.662546] kobject: 'mc13xxx-rtc' (ffff880006851e00): kobject_release, parent ffff880000189248 (delayed)
[    3.669144] kobject: 'rtc-msm6242' (ffff880006851c00): kobject_release, parent ffff880000189248 (delayed)
[    3.677494] kobject: 'pcap-rtc' (ffff880006851a00): kobject_release, parent ffff880000189248 (delayed)
[    3.680280] kobject: 'rtc-rp5c01' (ffff880006855a00): kobject_release, parent ffff880000189248 (delayed)
[    3.685641] rtc rtc0: test: dev (254:0)
[    3.686476] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    3.688354] rtc rtc1: test: dev (254:1)
[    3.689265] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    3.690949] i2c /dev entries driver
[    3.692563] usbcore: registered new interface driver i2c-diolan-u2c
[    3.693797] i2c-parport: adapter type unspecified
[    3.694975] i2c-parport-light: adapter type unspecified
[    3.696954] pps pps0: new PPS source ktimer
[    3.701800] pps pps0: ktimer PPS source registered
[    3.707280] pps_parport: parallel port PPS client
[    3.711769] parport0: cannot grant exclusive access for device pps_parport
[    3.718204] pps_parport: couldn't register with parport0
[    3.724812] Driver for 1-wire Dallas network protocol.
[    3.730378] usbcore: registered new interface driver DS9490R
[    3.732989] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.734820] power_supply test_ac: uevent
[    3.735812] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    3.737512] power_supply test_ac: prop ONLINE=1
[    3.738715] power_supply test_ac: power_supply_changed
[    3.742251] power_supply test_ac: power_supply_changed_work
[    3.747679] power_supply test_ac: power_supply_update_gen_leds 1
[    3.747869] power_supply test_battery: uevent
[    3.747871] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    3.747878] power_supply test_battery: prop STATUS=Discharging
[    3.747881] power_supply test_battery: prop CHARGE_TYPE=Fast
[    3.747884] power_supply test_battery: prop HEALTH=Good
[    3.747897] power_supply test_battery: prop PRESENT=1
[    3.747900] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    3.747902] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    3.747904] power_supply test_battery: prop CHARGE_FULL=100
[    3.747906] power_supply test_battery: prop CHARGE_NOW=50
[    3.747908] power_supply test_battery: prop CAPACITY=50
[    3.747910] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    3.747912] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    3.747914] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    3.747916] power_supply test_battery: prop MODEL_NAME=Test battery
[    3.747918] power_supply test_battery: prop MANUFACTURER=Linux
[    3.747920] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    3.747922] power_supply test_battery: prop TEMP=26
[    3.747924] power_supply test_battery: prop VOLTAGE_NOW=3300
[    3.748203] power_supply test_battery: power_supply_changed
[    3.748253] power_supply test_usb: uevent
[    3.748255] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    3.748263] power_supply test_usb: prop ONLINE=1
[    3.748276] power_supply test_usb: power_supply_changed
[    3.749134] applesmc: supported laptop not found!
[    3.749136] applesmc: driver init failed (ret=-19)!
[    3.749412] f71882fg: Not a Fintek device
[    3.749437] f71882fg: Not a Fintek device
[    3.750200] kobject: 'mc13783-adc' (ffff880007707000): kobject_release, parent ffff880000189248 (delayed)
[    3.750637] pc87360: PC8736x not detected, module not inserted
[    3.751908] cpuidle: using governor ladder
[    3.751911] cpuidle: using governor menu
[    3.751945] sdhci: Secure Digital Host Controller Interface driver
[    3.751946] sdhci: Copyright(c) Pierre Ossman
[    3.752272] power_supply test_battery: power_supply_changed_work
[    3.752279] power_supply test_battery: power_supply_update_bat_leds 2
[    3.752295] power_supply test_battery: uevent
[    3.752297] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    3.752307] power_supply test_battery: prop STATUS=Discharging
[    3.752311] power_supply test_battery: prop CHARGE_TYPE=Fast
[    3.752314] power_supply test_battery: prop HEALTH=Good
[    3.752318] power_supply test_battery: prop PRESENT=1
[    3.752321] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    3.752324] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    3.752334] power_supply test_battery: prop CHARGE_FULL=100
[    3.752338] power_supply test_battery: prop CHARGE_NOW=50
[    3.752341] power_supply test_battery: prop CAPACITY=50
[    3.752344] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    3.752347] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    3.752349] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    3.752352] power_supply test_battery: prop MODEL_NAME=Test battery
[    3.752356] power_supply test_battery: prop MANUFACTURER=Linux
[    3.752360] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    3.752363] power_supply test_battery: prop TEMP=26
[    3.752366] power_supply test_battery: prop VOLTAGE_NOW=3300
[    3.752385] power_supply test_usb: power_supply_changed_work
[    3.752389] power_supply test_usb: power_supply_update_gen_leds 1
[    3.752394] power_supply test_usb: uevent
[    3.752396] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    3.752403] power_supply test_usb: prop ONLINE=1
[    3.752656] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    3.752657] usbcore: registered new interface driver vub300
[    3.752676] usbcore: registered new interface driver ushc
[    3.752678] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.753352] ledtrig-cpu: registered to indicate activity on CPUs
[    3.753688] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    3.755071] usbcore: registered new interface driver usbhid
[    3.755072] usbhid: USB HID core driver
[    3.755132] usbip_core: usbip_core_init:804: USB/IP Core v1.0.0
[    3.755294] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    3.755308] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    3.755396] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 1
[    3.755417] vhci_hcd: vhci_start:884: enter vhci_start
[    3.756398] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.756402] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.756404] usb usb1: Product: USB/IP Virtual Host Controller
[    3.756406] usb usb1: Manufacturer: Linux 3.11.0-rc2-00010-gc817a67-dirty vhci_hcd
[    3.756409] usb usb1: SerialNumber: vhci_hcd
[    3.757209] hub 1-0:1.0: USB hub found
[    3.757244] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIndex 0
[    3.757286] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
[    3.757289] vhci_hcd: vhci_hub_control:398: port -1
[    3.757290] vhci_hcd: vhci_hub_control:405:  bye
[    3.757306] hub 1-0:1.0: 8 ports detected
[    3.757372] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex 0
[    3.757382] vhci_hcd: vhci_hub_control:309:  GetHubStatus
[    3.757384] vhci_hcd: vhci_hub_control:398: port -1
[    3.757386] vhci_hcd: vhci_hub_control:405:  bye
[    3.757970] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 1
[    3.757973] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.757974] vhci_hcd: vhci_hub_control:398: port 0
[    3.757976] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.757978] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.757980] vhci_hcd: dump_port_status_diff:119:
[    3.757981] vhci_hcd: vhci_hub_control:405:  bye
[    3.757989] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 2
[    3.757991] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.757992] vhci_hcd: vhci_hub_control:398: port 1
[    3.757994] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.757995] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.757996] vhci_hcd: dump_port_status_diff:119:
[    3.757998] vhci_hcd: vhci_hub_control:405:  bye
[    3.758005] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 3
[    3.758006] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.758008] vhci_hcd: vhci_hub_control:398: port 2
[    3.758009] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.758011] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.758012] vhci_hcd: dump_port_status_diff:119:
[    3.758014] vhci_hcd: vhci_hub_control:405:  bye
[    3.758020] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 4
[    3.758022] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.758023] vhci_hcd: vhci_hub_control:398: port 3
[    3.758025] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.758027] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.758028] vhci_hcd: dump_port_status_diff:119:
[    3.758029] vhci_hcd: vhci_hub_control:405:  bye
[    3.758035] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 5
[    3.758037] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.758039] vhci_hcd: vhci_hub_control:398: port 4
[    3.758040] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.758042] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.758043] vhci_hcd: dump_port_status_diff:119:
[    3.758045] vhci_hcd: vhci_hub_control:405:  bye
[    3.758051] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 6
[    3.758053] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.758054] vhci_hcd: vhci_hub_control:398: port 5
[    3.758056] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.758057] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.758058] vhci_hcd: dump_port_status_diff:119:
[    3.758060] vhci_hcd: vhci_hub_control:405:  bye
[    3.758066] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 7
[    3.758068] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.758069] vhci_hcd: vhci_hub_control:398: port 6
[    3.758071] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.758072] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.758074] vhci_hcd: dump_port_status_diff:119:
[    3.758075] vhci_hcd: vhci_hub_control:405:  bye
[    3.758082] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 8
[    3.758083] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.758085] vhci_hcd: vhci_hub_control:398: port 7
[    3.758087] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.758088] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.758089] vhci_hcd: dump_port_status_diff:119:
[    3.758090] vhci_hcd: vhci_hub_control:405:  bye
[    3.758354] vhci_hcd: vhci_hcd_probe:1034: bye
[    3.758363] vhci_hcd: vhci_hcd_init:1156: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.0.0
[    4.077194] usbcore: registered new interface driver usbip-host
[    4.077199] ------------[ cut here ]------------
[    4.077235] WARNING: CPU: 0 PID: 20 at /c/wfg/linux/lib/debugobjects.c:260 debug_print_object+0x7c/0x8d()
[    4.077335] ODEBUG: activate active (active state 0) object type: work_struct hint: kobject_delayed_cleanup+0x0/0x6d
[    4.077340] CPU: 0 PID: 20 Comm: kworker/0:1 Not tainted 3.11.0-rc2-00010-gc817a67-dirty #5
[    4.077361] Workqueue: events power_supply_changed_work
[    4.077382]  0000000000000104 ffff88000dc03c88 ffffffff8184e69e 0000000005b405b3
[    4.077385]  ffff88000dc03cd8 ffff88000dc03cc8 ffffffff8108f38d 0000000000000046
[    4.077388]  ffffffff812232c1 ffffffff81b81fd5 ffff880006d9a588 ffffffff81c60760
[    4.077389] Call Trace:
[    4.077417]  <IRQ>  [<ffffffff8184e69e>] dump_stack+0x4f/0x84
[    4.077436]  [<ffffffff8108f38d>] warn_slowpath_common+0x72/0x8c
[    4.077439]  [<ffffffff812232c1>] ? debug_print_object+0x7c/0x8d
[    4.077471]  [<ffffffff8108f40b>] warn_slowpath_fmt+0x41/0x43
[    4.077474]  [<ffffffff812232c1>] debug_print_object+0x7c/0x8d
[    4.077477]  [<ffffffff8121376b>] ? kobject_del+0x38/0x38
[    4.077481]  [<ffffffff81223737>] debug_object_activate+0x9e/0x11b
[    4.077492]  [<ffffffff810a19e1>] __queue_work+0x54/0x1ee
[    4.077495]  [<ffffffff810a1b7b>] ? __queue_work+0x1ee/0x1ee
[    4.077498]  [<ffffffff810a1b94>] delayed_work_timer_fn+0x19/0x1b
[    4.077504]  [<ffffffff8109897f>] call_timer_fn+0x6b/0xde
[    4.077507]  [<ffffffff81098914>] ? __internal_add_timer+0xc0/0xc0
[    4.077510]  [<ffffffff81098fa9>] run_timer_softirq+0x16f/0x1da
[    4.077527]  [<ffffffff810a1b7b>] ? __queue_work+0x1ee/0x1ee
[    4.077533]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
[    4.077536]  [<ffffffff81095745>] irq_exit+0x58/0x9e
[    4.077551]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
[    4.077557]  [<ffffffff8185a772>] apic_timer_interrupt+0x72/0x80
[    4.077563]  <EOI>  [<ffffffff81859277>] ? retint_restore_args+0x13/0x13
[    4.077574]  [<ffffffff810af994>] ? arch_local_irq_enable+0xb/0xd
[    4.077606]  [<ffffffff810c707f>] ? trace_hardirqs_on+0xd/0xf
[    4.077610]  [<ffffffff81857904>] preempt_schedule_irq+0x36/0x5a
[    4.077614]  [<ffffffff818593a6>] retint_kernel+0x26/0x30
[    4.077617]  [<ffffffff8108f47c>] ? arch_local_irq_restore+0x6/0xd
[    4.077619]  [<ffffffff81090db8>] vprintk_emit+0x3f9/0x422
[    4.077623]  [<ffffffff8121a640>] ? snprintf+0x34/0x36
[    4.077641]  [<ffffffff81483ca2>] dev_vprintk_emit+0x1a3/0x1c9
[    4.077645]  [<ffffffff81483cfc>] dev_printk_emit+0x34/0x36
[    4.077648]  [<ffffffff81483d6f>] __dev_printk+0x71/0x78
[    4.077650]  [<ffffffff81483db6>] dev_printk+0x40/0x42
[    4.077654]  [<ffffffff8148688a>] ? class_dev_iter_next+0x11/0x3a
[    4.077673]  [<ffffffff815dd74e>] power_supply_update_leds+0x141/0x163
[    4.077678]  [<ffffffff815dcc02>] power_supply_changed_work+0x4e/0x65
[    4.077681]  [<ffffffff810a2733>] process_one_work+0x1de/0x2fd
[    4.077684]  [<ffffffff810a26c9>] ? process_one_work+0x174/0x2fd
[    4.077687]  [<ffffffff810a2c54>] worker_thread+0x159/0x1ee
[    4.077690]  [<ffffffff810a2afb>] ? rescuer_thread+0x27f/0x27f
[    4.077693]  [<ffffffff810a859a>] kthread+0xac/0xb4
[    4.077696]  [<ffffffff810a84ee>] ? __kthread_parkme+0x68/0x68
[    4.077700]  [<ffffffff81859a3c>] ret_from_fork+0x7c/0xb0
[    4.077702]  [<ffffffff810a84ee>] ? __kthread_parkme+0x68/0x68
[    4.077834] ---[ end trace 2336d3bd525ed002 ]---
[    4.077836] ------------[ cut here ]------------
[    4.077840] WARNING: CPU: 0 PID: 20 at /c/wfg/linux/kernel/workqueue.c:457 work_fixup_activate+0x6c/0x73()
[    4.077843] CPU: 0 PID: 20 Comm: kworker/0:1 Tainted: G        W    3.11.0-rc2-00010-gc817a67-dirty #5
[    4.077848] Workqueue: events power_supply_changed_work
[    4.077851]  00000000000001c9 ffff88000dc03ce8 ffffffff8184e69e 00000000061e061d
[    4.077855]  0000000000000000 ffff88000dc03d28 ffffffff8108f38d ffff88000dc03d08
[    4.077858]  ffffffff810a1fea ffff880006db2060 ffffffff81c60760 ffffffff8284ade8
[    4.077859] Call Trace:
[    4.077863]  <IRQ>  [<ffffffff8184e69e>] dump_stack+0x4f/0x84
[    4.077887]  [<ffffffff8108f38d>] warn_slowpath_common+0x72/0x8c
[    4.077891]  [<ffffffff810a1fea>] ? work_fixup_activate+0x6c/0x73
[    4.077894]  [<ffffffff8108f45e>] warn_slowpath_null+0x15/0x17
[    4.077896]  [<ffffffff810a1fea>] work_fixup_activate+0x6c/0x73
[    4.077900]  [<ffffffff812230fa>] debug_object_fixup+0x15/0x1d
[    4.077902]  [<ffffffff81223756>] debug_object_activate+0xbd/0x11b
[    4.077905]  [<ffffffff810a19e1>] __queue_work+0x54/0x1ee
[    4.077908]  [<ffffffff810a1b7b>] ? __queue_work+0x1ee/0x1ee
[    4.077910]  [<ffffffff810a1b94>] delayed_work_timer_fn+0x19/0x1b
[    4.077913]  [<ffffffff8109897f>] call_timer_fn+0x6b/0xde
[    4.077916]  [<ffffffff81098914>] ? __internal_add_timer+0xc0/0xc0
[    4.077918]  [<ffffffff81098fa9>] run_timer_softirq+0x16f/0x1da
[    4.077921]  [<ffffffff810a1b7b>] ? __queue_work+0x1ee/0x1ee
[    4.077924]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
[    4.077928]  [<ffffffff81095745>] irq_exit+0x58/0x9e
[    4.077931]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
[    4.077934]  [<ffffffff8185a772>] apic_timer_interrupt+0x72/0x80
[    4.077954]  <EOI>  [<ffffffff81859277>] ? retint_restore_args+0x13/0x13
[    4.077958]  [<ffffffff810af994>] ? arch_local_irq_enable+0xb/0xd
[    4.077961]  [<ffffffff810c707f>] ? trace_hardirqs_on+0xd/0xf
[    4.077965]  [<ffffffff81857904>] preempt_schedule_irq+0x36/0x5a
[    4.077968]  [<ffffffff818593a6>] retint_kernel+0x26/0x30
[    4.077970]  [<ffffffff8108f47c>] ? arch_local_irq_restore+0x6/0xd
[    4.077973]  [<ffffffff81090db8>] vprintk_emit+0x3f9/0x422
[    4.077975]  [<ffffffff8121a640>] ? snprintf+0x34/0x36
[    4.077978]  [<ffffffff81483ca2>] dev_vprintk_emit+0x1a3/0x1c9
[    4.077981]  [<ffffffff81483cfc>] dev_printk_emit+0x34/0x36
[    4.077984]  [<ffffffff81483d6f>] __dev_printk+0x71/0x78
[    4.077987]  [<ffffffff81483db6>] dev_printk+0x40/0x42
[    4.077990]  [<ffffffff8148688a>] ? class_dev_iter_next+0x11/0x3a
[    4.077993]  [<ffffffff815dd74e>] power_supply_update_leds+0x141/0x163
[    4.077997]  [<ffffffff815dcc02>] power_supply_changed_work+0x4e/0x65
[    4.078000]  [<ffffffff810a2733>] process_one_work+0x1de/0x2fd
[    4.078003]  [<ffffffff810a26c9>] ? process_one_work+0x174/0x2fd
[    4.078006]  [<ffffffff810a2c54>] worker_thread+0x159/0x1ee
[    4.078024]  [<ffffffff810a2afb>] ? rescuer_thread+0x27f/0x27f
[    4.078027]  [<ffffffff810a859a>] kthread+0xac/0xb4
[    4.078030]  [<ffffffff810a84ee>] ? __kthread_parkme+0x68/0x68
[    4.078033]  [<ffffffff81859a3c>] ret_from_fork+0x7c/0xb0
[    4.078036]  [<ffffffff810a84ee>] ? __kthread_parkme+0x68/0x68
[    4.078038] ---[ end trace 2336d3bd525ed003 ]---
[    4.078040] ------------[ cut here ]------------
[    4.078043] WARNING: CPU: 0 PID: 20 at /c/wfg/linux/kernel/workqueue.c:1378 __queue_work+0x1a0/0x1ee()
[    4.078046] CPU: 0 PID: 20 Comm: kworker/0:1 Tainted: G        W    3.11.0-rc2-00010-gc817a67-dirty #5
[    4.078050] Workqueue: events power_supply_changed_work
[    4.078053]  0000000000000562 ffff88000dc03d88 ffffffff8184e69e 0000000006880687
[    4.078056]  0000000000000000 ffff88000dc03dc8 ffffffff8108f38d ffff880006db2060
[    4.078059]  ffffffff810a1b2d ffff88000dc13400 ffff880006db2060 ffff880000100400
[    4.078060] Call Trace:
[    4.078064]  <IRQ>  [<ffffffff8184e69e>] dump_stack+0x4f/0x84
[    4.078067]  [<ffffffff8108f38d>] warn_slowpath_common+0x72/0x8c
[    4.078070]  [<ffffffff810a1b2d>] ? __queue_work+0x1a0/0x1ee
[    4.078072]  [<ffffffff8108f45e>] warn_slowpath_null+0x15/0x17
[    4.078075]  [<ffffffff810a1b2d>] __queue_work+0x1a0/0x1ee
[    4.078077]  [<ffffffff810a1b7b>] ? __queue_work+0x1ee/0x1ee
[    4.078096]  [<ffffffff810a1b94>] delayed_work_timer_fn+0x19/0x1b
[    4.078099]  [<ffffffff8109897f>] call_timer_fn+0x6b/0xde
[    4.078102]  [<ffffffff81098914>] ? __internal_add_timer+0xc0/0xc0
[    4.078104]  [<ffffffff81098fa9>] run_timer_softirq+0x16f/0x1da
[    4.078107]  [<ffffffff810a1b7b>] ? __queue_work+0x1ee/0x1ee
[    4.078115]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
[    4.078118]  [<ffffffff81095745>] irq_exit+0x58/0x9e
[    4.078121]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
[    4.078124]  [<ffffffff8185a772>] apic_timer_interrupt+0x72/0x80
[    4.078128]  <EOI>  [<ffffffff81859277>] ? retint_restore_args+0x13/0x13
[    4.078132]  [<ffffffff810af994>] ? arch_local_irq_enable+0xb/0xd
[    4.078135]  [<ffffffff810c707f>] ? trace_hardirqs_on+0xd/0xf
[    4.078138]  [<ffffffff81857904>] preempt_schedule_irq+0x36/0x5a
[    4.078142]  [<ffffffff818593a6>] retint_kernel+0x26/0x30
[    4.078144]  [<ffffffff8108f47c>] ? arch_local_irq_restore+0x6/0xd
[    4.078147]  [<ffffffff81090db8>] vprintk_emit+0x3f9/0x422
[    4.078149]  [<ffffffff8121a640>] ? snprintf+0x34/0x36
[    4.078168]  [<ffffffff81483ca2>] dev_vprintk_emit+0x1a3/0x1c9
[    4.078172]  [<ffffffff81483cfc>] dev_printk_emit+0x34/0x36
[    4.078175]  [<ffffffff81483d6f>] __dev_printk+0x71/0x78
[    4.078177]  [<ffffffff81483db6>] dev_printk+0x40/0x42
[    4.078180]  [<ffffffff8148688a>] ? class_dev_iter_next+0x11/0x3a
[    4.078183]  [<ffffffff815dd74e>] power_supply_update_leds+0x141/0x163
[    4.078186]  [<ffffffff815dcc02>] power_supply_changed_work+0x4e/0x65
[    4.078189]  [<ffffffff810a2733>] process_one_work+0x1de/0x2fd
[    4.078192]  [<ffffffff810a26c9>] ? process_one_work+0x174/0x2fd
[    4.078195]  [<ffffffff810a2c54>] worker_thread+0x159/0x1ee
[    4.078198]  [<ffffffff810a2afb>] ? rescuer_thread+0x27f/0x27f
[    4.078200]  [<ffffffff810a859a>] kthread+0xac/0xb4
[    4.078203]  [<ffffffff810a84ee>] ? __kthread_parkme+0x68/0x68
[    4.078207]  [<ffffffff81859a3c>] ret_from_fork+0x7c/0xb0
[    4.078209]  [<ffffffff810a84ee>] ? __kthread_parkme+0x68/0x68
[    4.078211] ---[ end trace 2336d3bd525ed004 ]---
[    4.078401] power_supply test_ac: uevent
[    4.078404] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    4.078425] power_supply test_ac: prop ONLINE=1
[    4.391467] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 1
[    4.393945] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 1
[    4.393994] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
[    4.394059] usbcore: registered new interface driver tranzport
[    4.394080] usbcore: registered new interface driver alphatrack
[    4.394081] vme_user: VME User Space Access Driver
[    4.394082] vme_user: No cards, skipping registration
[    4.395198] Loading crystalhd 0.9.27
[    4.395313] usbcore: registered new interface driver ft1000usb
[    4.395405] usbcore: registered new interface driver gdm_wimax
[    4.395426] usbcore: registered new interface driver cedusb
[    4.413142] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.413696] ipip: IPv4 over IPv4 tunneling driver
[    4.414034] gre: GRE over IPv4 demultiplexor driver
[    4.414037] IPv4 over IPSec tunneling driver
[    4.414406] TCP: cubic registered
[    4.414411] NET: Registered protocol family 17
[    4.423420] vhci_hcd: vhci_hub_control:398: port 0
[    4.423496] NET: Registered protocol family 9
[    4.423509] X.25 for Linux Version 0.2
[    4.426861] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.429065] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.429452] NET: Registered protocol family 33
[    4.429457] Key type rxrpc registered
[    4.429458] Key type rxrpc_s registered
[    4.429787] RxRPC: Registered security type 2 'rxkad'
[    4.429856] l2tp_core: L2TP core driver, V2.0
[    4.429858] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    4.446965] vhci_hcd: dump_port_status_diff:119:
[    4.448285] vhci_hcd: vhci_hub_control:405:  bye
[    4.448298] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    4.452406] NET: Registered protocol family 12
[    4.454192] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 2
[    4.458396] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 2
[    4.460768] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.463400] vhci_hcd: vhci_hub_control:398: port 1
[    4.465369] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.467919] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.469152] vhci_hcd: dump_port_status_diff:119:
[    4.469219] 8021q: 802.1Q VLAN Support v1.8
[    4.471126] vhci_hcd: vhci_hub_control:405:  bye
[    4.472589] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 3
[    4.472866] sctp: Hash tables configured (established 1024 bind 1024)
[    4.476917] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 3
[    4.478955] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.480989] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[    4.480994] vhci_hcd: vhci_hub_control:398: port 2
[    4.480997] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.480998] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.480999] vhci_hcd: dump_port_status_diff:119:
[    4.481000] vhci_hcd: vhci_hub_control:405:  bye
[    4.481195] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 4
[    4.481198] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 4
[    4.481200] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.481202] vhci_hcd: vhci_hub_control:398: port 3
[    4.481204] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.481205] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.481207] vhci_hcd: dump_port_status_diff:119:
[    4.481208] vhci_hcd: vhci_hub_control:405:  bye
[    4.481217] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 5
[    4.481219] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 5
[    4.481220] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.481222] vhci_hcd: vhci_hub_control:398: port 4
[    4.481224] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.481225] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.481227] vhci_hcd: dump_port_status_diff:119:
[    4.481228] vhci_hcd: vhci_hub_control:405:  bye
[    4.481236] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 6
[    4.481238] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 6
[    4.481239] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.481241] vhci_hcd: vhci_hub_control:398: port 5
[    4.481242] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.481244] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.481245] vhci_hcd: dump_port_status_diff:119:
[    4.481247] vhci_hcd: vhci_hub_control:405:  bye
[    4.481254] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 7
[    4.481256] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 7
[    4.481258] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.481259] vhci_hcd: vhci_hub_control:398: port 6
[    4.481261] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.481263] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.481264] vhci_hcd: dump_port_status_diff:119:
[    4.481265] vhci_hcd: vhci_hub_control:405:  bye
[    4.481274] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 8
[    4.481275] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 8
[    4.481277] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.481278] vhci_hcd: vhci_hub_control:398: port 7
[    4.481280] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.481281] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.481283] vhci_hcd: dump_port_status_diff:119:
[    4.481284] vhci_hcd: vhci_hub_control:405:  bye
[    4.481569] usb usb1: vhci_bus_suspend
[    4.481582] vhci_hcd: vhci_hub_status:208: changed 0
[    4.606455] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[    4.608289] NET: Registered protocol family 37
[    4.609137] NET: Registered protocol family 36
[    4.609768] Key type dns_resolver registered
[    4.610283] Key type ceph registered
[    4.611176] libceph: loaded (mon/osd proto 15/24)
[    4.611796] mpls_gso: MPLS GSO support
[    4.612580]
[    4.612580] printing PIC contents
[    4.613399] ... PIC  IMR: ffff
[    4.613948] ... PIC  IRR: 1013
[    4.614497] ... PIC  ISR: 0000
[    4.615034] ... PIC ELCR: 0c00
[    4.615613] printing local APIC contents on CPU#0/0:
[    4.616204] ... APIC ID:      00000000 (0)
[    4.616204] ... APIC VERSION: 00050014
[    4.616204] ... APIC TASKPRI: 00000000 (00)
[    4.616204] ... APIC PROCPRI: 00000000
[    4.616204] ... APIC LDR: 01000000
[    4.616204] ... APIC DFR: ffffffff
[    4.616204] ... APIC SPIV: 000001ff
[    4.616204] ... APIC ISR field:
[    4.616204] 0000000000000000000000000000000000000000000000000000000000000000
[    4.616204] ... APIC TMR field:
[    4.616204] 0000000000000000000000000000000000000000000000000000000000000000
[    4.616204] ... APIC IRR field:
[    4.616204] 0000000000000000000000000000000000000000000000000000000000008000
[    4.616204] ... APIC ESR: 00000000
[    4.616204] ... APIC ICR: 000008fb
[    4.616204] ... APIC ICR2: 02000000
[    4.616204] ... APIC LVTT: 000000ef
[    4.616204] ... APIC LVTPC: 00010000
[    4.616204] ... APIC LVT0: 00010700
[    4.616204] ... APIC LVT1: 00000400
[    4.616204] ... APIC LVTERR: 000000fe
[    4.616204] ... APIC TMICT: 00039de3
[    4.616204] ... APIC TMCCT: 00000000
[    4.616204] ... APIC TDCR: 00000003
[    4.616204]
[    4.681995] number of MP IRQ sources: 15.
[    4.685925] number of IO-APIC #0 registers: 24.
[    4.693072] testing the IO APIC.......................
[    4.695617] IO APIC #0......
[    4.696611] .... register #00: 00000000
[    4.697670] .......    : physical APIC id: 00
[    4.698794] .......    : Delivery Type: 0
[    4.701354] .......    : LTS          : 0
[    4.702641] .... register #01: 00170011
[    4.704943] .......     : max redirection entries: 17
[    4.706550] .......     : PRQ implemented: 0
[    4.707702] .......     : IO APIC version: 11
[    4.708885] .... register #02: 00000000
[    4.709669] .......     : arbitration: 00
[    4.712188] .... IRQ redirection table:
[    4.713090] 1    0    0   0   0    0    0    00
[    4.714110] 0    0    0   0   0    1    1    31
[    4.715074] 0    0    0   0   0    1    1    30
[    4.716449] 0    0    0   0   0    1    1    33
[    4.717540] 1    0    0   0   0    1    1    34
[    4.719013] 1    1    0   0   0    1    1    35
[    4.720094] 0    0    0   0   0    1    1    36
[    4.721299] 0    0    0   0   0    1    1    37
[    4.722910] 0    0    0   0   0    1    1    38
[    4.725178] 0    1    0   0   0    1    1    39
[    4.726269] 1    1    0   0   0    1    1    3A
[    4.727384] 1    1    0   0   0    1    1    3B
[    4.728687] 0    0    0   0   0    1    1    3C
[    4.729885] 0    0    0   0   0    1    1    3D
[    4.731142] 0    0    0   0   0    1    1    3E
[    4.732410] 0    0    0   0   0    1    1    3F
[    4.737904] 1    0    0   0   0    0    0    00
[    4.741137] 1    0    0   0   0    0    0    00
[    4.742078] 1    0    0   0   0    0    0    00
[    4.743146] 1    0    0   0   0    0    0    00
[    4.744198] 1    0    0   0   0    0    0    00
[    4.745320] 1    0    0   0   0    0    0    00
[    4.746301] 1    0    0   0   0    0    0    00
[    4.747227] 1    0    0   0   0    0    0    00
[    4.748485] IRQ to pin mappings:
[    4.749357] IRQ0 -> 0:2
[    4.750069] IRQ1 -> 0:1
[    4.750782] IRQ3 -> 0:3
[    4.752603] IRQ4 -> 0:4
[    4.753345] IRQ5 -> 0:5
[    4.754106] IRQ6 -> 0:6
[    4.754749] IRQ7 -> 0:7
[    4.755474] IRQ8 -> 0:8
[    4.756285] IRQ9 -> 0:9
[    4.757094] IRQ10 -> 0:10
[    4.757860] IRQ11 -> 0:11
[    4.758663] IRQ12 -> 0:12
[    4.759418] IRQ13 -> 0:13
[    4.760283] IRQ14 -> 0:14
[    4.761038] IRQ15 -> 0:15
[    4.761802] .................................... done.
[    4.763375] registered taskstats version 1
[    4.773250] rtc-test rtc-test.0: setting system clock to 2013-09-09 06:44:11 UTC (1378709051)
[    4.779457] debug: unmapping init [mem 0xffffffff81dfc000-0xffffffff81ecefff]
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
[    5.012969] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
qemu: terminating on signal 2
wfg@bee ~/linux/obj-compiletest% kvm-0day.sh arch/x86/boot/bzImage
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc2-00010-gc817a67-dirty (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #5 SMP PREEMPT Tue Oct 8 09:29:02 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
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
[    0.000000] BRK [0x028a7000, 0x028a7fff] PGTABLE
[    0.000000] BRK [0x028a8000, 0x028a8fff] PGTABLE
[    0.000000] BRK [0x028a9000, 0x028a9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x028aa000, 0x028aafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x028ab000, 0x028abfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128416(97%)
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
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 199068K/261744K available (8557K kernel code, 1784K rwdata, 3968K rodata, 844K init, 10064K bss, 62676K reserved)
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
[    0.000000] ODEBUG: 5 of 5 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.012000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=10774032)
[    0.012000] pid_max: default: 32768 minimum: 301
[    0.012000] Mount-cache hash table entries: 256
[    0.012421] Initializing cgroup subsys devices
[    0.013287] Initializing cgroup subsys perf_event
[    0.014156] Initializing cgroup subsys net_prio
[    0.015118] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.015118] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.015118] tlb_flushall_shift: 6
[    0.016051] debug: unmapping init [mem 0xffffffff81ecf000-0xffffffff81ed2fff]
[    0.021279] ACPI: Core revision 20130517
[    0.026777] ACPI: All ACPI Tables successfully acquired
[    0.032691] Getting VERSION: 50014
[    0.036037] Getting VERSION: 50014
[    0.040035] Getting ID: 0
[    0.044033] Getting ID: ff000000
[    0.048033] Getting LVT0: 8700
[    0.052046] Getting LVT1: 8400
[    0.053090] enabled ExtINT on CPU#0
[    0.057329] ENABLING IO-APIC IRQs
[    0.057960] init IO_APIC IRQs
[    0.058515]  apic 0 pin 0 not connected
[    0.059230] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.060070] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.064067] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.068064] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.072066] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.080060] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.084066] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.088059] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.092063] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.096064] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.100067] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.104064] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.108066] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.112068] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.116065] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.120052]  apic 0 pin 16 not connected
[    0.124018]  apic 0 pin 17 not connected
[    0.128015]  apic 0 pin 18 not connected
[    0.130332]  apic 0 pin 19 not connected
[    0.132016]  apic 0 pin 20 not connected
[    0.136013]  apic 0 pin 21 not connected
[    0.138312]  apic 0 pin 22 not connected
[    0.140015]  apic 0 pin 23 not connected
[    0.144175] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.148016] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.154483] Using local APIC timer interrupts.
[    0.154483] calibrating APIC timer ...
[    0.160000] ... lapic delta = 6266088
[    0.160000] ... PM-Timer delta = 358885
[    0.160000] ... PM-Timer result ok
[    0.160000] ..... delta 6266088
[    0.160000] ..... mult: 269126430
[    0.160000] ..... calibration result: 4010296
[    0.160000] ..... CPU clock speed is 2700.1720 MHz.
[    0.160000] ..... host bus clock speed is 1002.2296 MHz.
[    0.160131] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.184540] SMP alternatives: lockdep: fixing up alternatives
[    0.185726] smpboot: Booting Node   0, Processors  #1 OK
[    0.012000] kvm-clock: cpu 1, msr 0:e896041, secondary cpu clock
[    0.012000] masked ExtINT on CPU#1
[    0.204206] Brought up 2 CPUs
[    0.204138] KVM setup async PF for cpu 1
[    0.204138] kvm-stealtime: cpu 1, msr dd0ccc0
[    0.208015] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.212712] devtmpfs: initialized
[    0.214099] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.220787] regulator-dummy: no parameters
[    0.222310] NET: Registered protocol family 16
[    0.228361] ACPI: bus type PCI registered
[    0.229840] PCI: Using configuration type 1 for base access
[    0.246003] ACPI: Added _OSI(Module Device)
[    0.248011] ACPI: Added _OSI(Processor Device)
[    0.248898] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.249736] ACPI: Added _OSI(Processor Aggregator Device)
[    0.254775] ACPI: EC: Look up EC in DSDT
[    0.262442] ACPI: Interpreter enabled
[    0.263447] ACPI: (supports S0 S5)
[    0.264009] ACPI: Using IOAPIC for interrupt routing
[    0.265333] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.281983] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.284639] PCI host bridge to bus 0000:00
[    0.285793] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.287554] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.288013] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.289598] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.292015] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.294017] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.296915] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.300313] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.305645] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.308938] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.312764] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.320076] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.328527] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.336068] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.344119] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.360081] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.362690] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.365347] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.368619] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.377184] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.379555] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.381258] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.385139] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.392017] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.394085] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.396745] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.402722] pci_bus 0000:00: on NUMA node 0
[    0.404040] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.407146] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.416038] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.421475] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.428388] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.432754] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.434450] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.437479] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.438720] ACPI: \_SB_.PCI0: notify handler is installed
[    0.440154] Found 1 acpi root devices
[    0.442124] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.444012] vgaarb: loaded
[    0.444500] vgaarb: bridge control possible 0000:00:02.0
[    0.448478] ACPI: bus type USB registered
[    0.452123] usbcore: registered new interface driver usbfs
[    0.456086] usbcore: registered new interface driver hub
[    0.468164] usbcore: registered new device driver usb
[    0.472250] pps_core: LinuxPPS API ver. 1 registered
[    0.473870] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.476165] PTP clock support registered
[    0.480566] wmi: Mapper loaded
[    0.481454] PCI: Using ACPI for IRQ routing
[    0.482487] PCI: pci_cache_line_size set to 64 bytes
[    0.484255] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.486282] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.488942] NET: Registered protocol family 23
[    0.490844] cfg80211: Calling CRDA to update world regulatory domain
[    0.492182] nfc: nfc_init: NFC Core ver 0.1
[    0.493349] NET: Registered protocol family 39
[    0.496488] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.500229] Switched to clocksource kvm-clock
[    0.501265] pnp: PnP ACPI init
[    0.501997] ACPI: bus type PNP registered
[    0.503136] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.505464] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.509494] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.516981] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.523543] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.530461] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.536620] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.543317] pnp 00:03: [dma 2]
[    0.546064] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.550160] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.555660] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.557615] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.559875] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.561972] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.565676] pnp: PnP ACPI: found 7 devices
[    0.569924] ACPI: bus type PNP unregistered
[    0.582934] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.584528] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.586996] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.590197] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.592255] NET: Registered protocol family 2
[    0.594374] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    0.598346] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.604358] TCP: Hash tables configured (established 2048 bind 2048)
[    0.615169] TCP: reno registered
[    0.618165] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.619872] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.622136] NET: Registered protocol family 1
[    0.626843] RPC: Registered named UNIX socket transport module.
[    0.628564] RPC: Registered udp transport module.
[    0.630643] RPC: Registered tcp transport module.
[    0.632484] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.634062] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.639682] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.646166] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.651692] pci 0000:00:02.0: Boot video device
[    0.655906] PCI: CLS 0 bytes, default 64
[    0.659859] Unpacking initramfs...
[    2.442292] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    2.446480] has_svm: not amd
[    2.447467] kvm: no hardware support
[    2.448981] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    2.451852] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    2.459805] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    2.467755] cryptomgr_test (24) used greatest stack depth: 6392 bytes left
[    2.469788] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.470768] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.471766] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.472784] AVX or AES-NI instructions are not detected.
[    2.473648] AVX instructions are not detected.
[    2.474309] AVX instructions are not detected.
[    2.475005] AVX instructions are not detected.
[    2.483747] Initializing RT-Tester: OK
[    2.484815] audit: initializing netlink socket (disabled)
[    2.485978] type=2000 audit(1378709048.547:1): initialized
[    2.494294] DLM installed
[    2.498304] NFS: Registering the id_resolver key type
[    2.503211] Key type id_resolver registered
[    2.507151] Key type id_legacy registered
[    2.510764] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.516888] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.520684] fuse init (API version 7.22)
[    2.524098] ceph: loaded (mds proto 32)
[    2.541980] cryptomgr_test (43) used greatest stack depth: 5696 bytes left
[    2.545134] cryptomgr_test (44) used greatest stack depth: 5688 bytes left
[    2.560020] cryptomgr_test (72) used greatest stack depth: 5280 bytes left
[    2.567642] alg: No test for crc32 (crc32-table)
[    2.569663] alg: No test for lz4hc (lz4hc-generic)
[    2.574328] alg: No test for stdrng (krng)
[    2.575723] NET: Registered protocol family 38
[    2.581280] Key type asymmetric registered
[    2.592129] Asymmetric key parser 'x509' registered
[    2.593016] test_string_helpers: Running tests...
[    2.594961] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    2.596202] crc32: self tests passed, processed 225944 bytes in 299463 nsec
[    2.598139] crc32c: CRC_LE_BITS = 32
[    2.599021] crc32c: self tests passed, processed 225944 bytes in 149640 nsec
[    2.603863] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    2.605432] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    2.607597] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    2.609793] vmlfb: initializing
[    2.610718] Could not find Carillo Ranch MCH device.
[    2.612370] no IO addresses supplied
[    2.613697] hgafb: HGA card not detected.
[    2.614872] hgafb: probe of hgafb.0 failed with error -22
[    2.616491] usbcore: registered new interface driver udlfb
[    2.617961] usbcore: registered new interface driver smscufx
[    2.634092] uvesafb: failed to execute /sbin/v86d
[    2.635045] uvesafb: make sure that the v86d helper is installed and executable
[    2.636389] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    2.637608] uvesafb: vbe_init() failed with -22
[    2.638435] uvesafb: probe of uvesafb.0 failed with error -22
[    2.639602] ipmi message handler version 39.2
[    2.640409] ipmi device interface
[    2.641124] IPMI System Interface driver.
[    2.641972] ipmi_si: Adding default-specified kcs state machine
[    2.643089] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    2.644865] ipmi_si: Interface detection failed
[    2.660274] ipmi_si: Adding default-specified smic state machine
[    2.662443] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    2.667679] ipmi_si: Interface detection failed
[    2.680193] ipmi_si: Adding default-specified bt state machine
[    2.681415] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    2.683233] ipmi_si: Interface detection failed
[    2.696377] kobject: 'ipmi_si' (ffff8800077a3600): kobject_release, parent ffff8800001b7648 (delayed)
[    2.698170] kobject: 'ipmi_si' (ffff8800077a3400): kobject_release, parent ffff880000221248 (delayed)
[    2.700018] kobject: 'ipmi_si' (ffff8800077a3800): kobject_release, parent ffff880000189248 (delayed)
[    2.701814] ipmi_si: Unable to find any System Interface(s)
[    2.703268] IPMI Watchdog: driver initialized
[    2.703961] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    2.705571] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.706694] ACPI: Power Button [PWRF]
[    2.782539] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.812478] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.816207] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    2.818059] ac.o: No PCI boards found.
[    2.818997] ac.o: For an ISA board you must supply memory and irq parameters.
[    2.821142] Non-volatile memory driver v1.3
[    2.821764] Linux agpgart interface v0.103
[    2.823044] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    2.823712] kobject: 'drm' (ffff880006da4848): kobject_release, parent ffff880000189648 (delayed)
[    2.824700] kobject: 'drm' (ffff880006da3a00): kobject_release, parent           (null) (delayed)
[    2.825916] [drm] radeon kernel modesetting enabled.
[    2.828167] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
[    2.833783] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/dri.
[    2.841079] kobject: 'controlD64' (ffff880006da4020): kobject_release, parent           (null) (delayed)
[    2.842923] cirrus: probe of 0000:00:02.0 failed with error -1
[    2.844336] usbcore: registered new interface driver udl
[    2.846585] parport_pc 00:04: reported by Plug and Play ACPI
[    2.847712] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    2.849538] kobject: 'parport_pc.956' (ffff880006da4020): kobject_release, parent           (null) (delayed)
[    2.851406] kobject: 'parport_pc.888' (ffff880006db6820): kobject_release, parent           (null) (delayed)
[    2.853555] kobject: 'parport_pc.632' (ffff880006db6020): kobject_release, parent           (null) (delayed)
[    2.856291] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.858913] dummy-irq: no IRQ given.  Use irq=N
[    2.866402] Phantom Linux Driver, version n0.9.8, init OK
[    2.869119] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    2.871778] c2port c2port0: C2 port uc added
[    2.875062] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    2.877705] Guest personality initialized and is inactive
[    2.881121] VMCI host device registered (name=vmci, major=10, minor=56)
[    2.882752] Initialized host personality
[    2.884420] Driver for timberdale has been successfully registered.
[    2.886295] usbcore: registered new interface driver viperboard
[    2.887875] usbcore: registered new interface driver pn533
[    2.892360] mtdoops: mtd device (mtddev=name/number) must be supplied
[    2.895124] device id = 2440
[    2.895830] device id = 2480
[    2.897531] device id = 24c0
[    2.898638] device id = 24d0
[    2.899374] device id = 25a1
[    2.900165] device id = 2670
[    2.901031] platform physmap-flash.0: failed to claim resource 0
[    2.903377] kobject: 'physmap-flash' (ffff880006dcd200): kobject_release, parent ffff880000189248 (delayed)
[    2.905811] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    2.908741] Could not find PAR responsible for SC520CDP Flash Bank #0
[    2.910661] Trying default address 0x8400000
[    2.911724] Could not find PAR responsible for SC520CDP Flash Bank #1
[    2.913702] Trying default address 0x8c00000
[    2.916430] Could not find PAR responsible for SC520CDP DIL Flash
[    2.918204] Trying default address 0x9400000
[    2.919371] SC520 CDP flash device: 0x800000 at 0x8400000
[    2.923272] Failed to ioremap_nocache
[    2.925819] Failed to ioremap_nocache
[    2.926873] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.928621] kobject: 'docg3' (ffff880006dd3600): kobject_release, parent ffff880000189248 (delayed)
[    2.930926] slram: not enough parameters.
[    2.935851] No valid DiskOnChip devices found
[    2.938126] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.940535] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.943281] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.945921] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.948794] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.951161] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.953599] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    2.956823] flash size: 128 MiB
[    2.957653] page size: 512 bytes
[    2.958482] OOB area size: 16 bytes
[    2.959373] sector size: 16 KiB
[    2.960241] pages number: 262144
[    2.963376] pages per sector: 32
[    2.965070] bus width: 8
[    2.965771] bits in sector size: 14
[    2.966664] bits in page size: 9
[    2.967489] bits in OOB size: 4
[    2.968345] flash size with OOB: 135168 KiB
[    2.970221] page address bytes: 4
[    2.970987] sector address bytes: 3
[    2.971858] options: 0x42
[    2.977677] Scanning device for bad blocks
[    3.027804] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.035511] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.045012] parport0: powerup/reset Butterfly
[    3.166485] parport_pc 00:04: registered master spi42
[    3.167676] parport_pc 00:04: master is unqueued, this is deprecated
[    3.170008] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    3.176624] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    3.179890] parport_pc 00:04: registered child spi42.1
[    3.181570] parport0: dataflash at spi42.1
[    3.182617] parport0: AVR Butterfly
[    3.183619] parport0: cannot grant exclusive access for device spi-lm70llp
[    3.185844] spi-lm70llp: spi_lm70llp probe fail, status -12
[    3.190288] usbcore: registered new interface driver irda-usb
[    3.191885] usbcore: registered new interface driver stir4200
[    3.193489] usbcore: registered new interface driver mcs7780
[    3.194983] usbcore: registered new interface driver kingsun-sir
[    3.196533] usbcore: registered new interface driver ksdazzle-sir
[    3.198105] usbcore: registered new interface driver ks959-sir
[    3.201795] usbcore: registered new interface driver hwa-rc
[    3.204459] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.206031] ohci-pci: OHCI PCI platform driver
[    3.207301] ohci-platform: OHCI generic platform driver
[    3.209366] uhci_hcd: USB Universal Host Controller Interface driver
[    3.213560] driver u132_hcd
[    3.221754] usbcore: registered new interface driver hwa-hc
[    3.225963] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    3.228712] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    3.235015] usbcore: registered new interface driver cdc_wdm
[    3.237508] usbcore: registered new interface driver usbtmc
[    3.240189] usbcore: registered new interface driver appledisplay
[    3.241342] usbcore: registered new interface driver emi26 - firmware loader
[    3.242570] usbcore: registered new interface driver emi62 - firmware loader
[    3.248403] driver ftdi-elan
[    3.255594] usbcore: registered new interface driver ftdi-elan
[    3.256977] usbcore: registered new interface driver idmouse
[    3.258135] usbcore: registered new interface driver usblcd
[    3.259222] usbcore: registered new interface driver ldusb
[    3.260822] usbcore: registered new interface driver usbled
[    3.262388] usbcore: registered new interface driver legousbtower
[    3.267945] usbcore: registered new interface driver rio500
[    3.274473] usbcore: registered new interface driver usbtest
[    3.281866] usbcore: registered new interface driver trancevibrator
[    3.284230] usbcore: registered new interface driver uss720
[    3.285656] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[    3.287983] uss720: NOTE: this is a special purpose driver to allow nonstandard
[    3.292595] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[    3.299111] uss720: If you just want to connect to a printer, use usblp instead
[    3.304888] usbcore: registered new interface driver yurex
[    3.307996] kobject: 'gpio-vbus' (ffff880006820e00): kobject_release, parent ffff880000189248 (delayed)
[    3.313655] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.320733] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.330716] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.332459] parport0: cannot grant exclusive access for device parkbd
[    3.423749] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    3.431847] usbcore: registered new interface driver bcm5974
[    3.433160] usbcore: registered new interface driver synaptics_usb
[    3.434671] usbcore: registered new interface driver iforce
[    3.435265] kobject: '(null)' (ffff880006832af0): kobject_release, parent           (null) (delayed)
[    3.441142] parport0: cannot grant exclusive access for device walkera0701
[    3.442492] walkera0701: failed to register parport device
[    3.443934] usbcore: registered new interface driver usbtouchscreen
[    3.445460] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    3.446586] usbcore: registered new interface driver ati_remote2
[    3.447678] cm109: Keymap for Komunikate KIP1000 phone loaded
[    3.448581] tsc: Refined TSC clocksource calibration: 2693.467 MHz
[    3.454012] usbcore: registered new interface driver cm109
[    3.455385] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    3.457012] usbcore: registered new interface driver keyspan_remote
[    3.459778] usbcore: registered new interface driver yealink
[    3.461368] I2O subsystem v1.325
[    3.462308] i2o: max drivers = 8
[    3.465596] I2O Configuration OSM v1.323
[    3.466186] I2O ProcFS OSM v1.316
[    3.466722] kobject: 'proc-osm' (ffff880006855800): kobject_release, parent ffff880006852248 (delayed)
[    3.468877] kobject: 'mc13xxx-rtc' (ffff88000685d800): kobject_release, parent ffff880000189248 (delayed)
[    3.472151] kobject: 'rtc-msm6242' (ffff88000685d600): kobject_release, parent ffff880000189248 (delayed)
[    3.474814] kobject: 'pcap-rtc' (ffff88000685d400): kobject_release, parent ffff880000189248 (delayed)
[    3.477411] kobject: 'rtc-rp5c01' (ffff88000685f400): kobject_release, parent ffff880000189248 (delayed)
[    3.480637] rtc rtc0: test: dev (254:0)
[    3.481358] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    3.483452] rtc rtc1: test: dev (254:1)
[    3.484210] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    3.485360] i2c /dev entries driver
[    3.486383] usbcore: registered new interface driver i2c-diolan-u2c
[    3.487405] i2c-parport: adapter type unspecified
[    3.488248] i2c-parport-light: adapter type unspecified
[    3.489807] pps pps0: new PPS source ktimer
[    3.491165] pps pps0: ktimer PPS source registered
[    3.492364] pps_parport: parallel port PPS client
[    3.493666] parport0: cannot grant exclusive access for device pps_parport
[    3.495451] pps_parport: couldn't register with parport0
[    3.497015] Driver for 1-wire Dallas network protocol.
[    3.498768] usbcore: registered new interface driver DS9490R
[    3.501022] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.502921] power_supply test_ac: uevent
[    3.503845] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    3.505248] power_supply test_ac: prop ONLINE=1
[    3.507933] power_supply test_ac: power_supply_changed
[    3.509605] power_supply test_ac: power_supply_changed_work
[    3.511056] power_supply test_ac: power_supply_update_gen_leds 1
[    3.516074] power_supply test_battery: uevent
[    3.516948] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    3.518036] power_supply test_battery: prop STATUS=Discharging
[    3.518143] power_supply test_ac: uevent
[    3.518146] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    3.518177] power_supply test_ac: prop ONLINE=1
[    3.522359] power_supply test_battery: prop CHARGE_TYPE=Fast
[    3.523823] power_supply test_battery: prop HEALTH=Good
[    3.525206] power_supply test_battery: prop PRESENT=1
[    3.526446] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    3.527932] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    3.529583] power_supply test_battery: prop CHARGE_FULL=100
[    3.531001] power_supply test_battery: prop CHARGE_NOW=50
[    3.532442] power_supply test_battery: prop CAPACITY=50
[    3.533849] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    3.535432] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    3.538219] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    3.539778] power_supply test_battery: prop MODEL_NAME=Test battery
[    3.541439] power_supply test_battery: prop MANUFACTURER=Linux
[    3.542966] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    3.545092] power_supply test_battery: prop TEMP=26
[    3.547618] power_supply test_battery: prop VOLTAGE_NOW=3300
[    3.549536] power_supply test_battery: power_supply_changed
[    3.550995] power_supply test_battery: power_supply_changed_work
[    3.552275] power_supply test_battery: power_supply_update_bat_leds 2
[    3.552467] power_supply test_usb: uevent
[    3.552470] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    3.552496] power_supply test_usb: prop ONLINE=1
[    3.552528] power_supply test_usb: power_supply_changed
[    3.554183] applesmc: supported laptop not found!
[    3.554185] applesmc: driver init failed (ret=-19)!
[    3.554700] f71882fg: Not a Fintek device
[    3.554800] f71882fg: Not a Fintek device
[    3.555736] kobject: 'mc13783-adc' (ffff880006899c00): kobject_release, parent ffff880000189248 (delayed)
[    3.556715] pc87360: PC8736x not detected, module not inserted
[    3.558205] cpuidle: using governor ladder
[    3.558208] cpuidle: using governor menu
[    3.558229] sdhci: Secure Digital Host Controller Interface driver
[    3.558230] sdhci: Copyright(c) Pierre Ossman
[    3.558454] power_supply test_usb: power_supply_changed_work
[    3.558463] power_supply test_usb: power_supply_update_gen_leds 1
[    3.558472] power_supply test_usb: uevent
[    3.558474] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    3.558492] power_supply test_usb: prop ONLINE=1
[    3.610449] power_supply test_battery: uevent
[    3.614403] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    3.614739] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    3.614739] usbcore: registered new interface driver vub300
[    3.614763] usbcore: registered new interface driver ushc
[    3.614764] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.615543] ledtrig-cpu: registered to indicate activity on CPUs
[    3.615896] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    3.617312] usbcore: registered new interface driver usbhid
[    3.617314] usbhid: USB HID core driver
[    3.617390] usbip_core: usbip_core_init:804: USB/IP Core v1.0.0
[    3.617539] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    3.617554] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    3.617658] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 1
[    3.617704] vhci_hcd: vhci_start:884: enter vhci_start
[    3.618643] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.618646] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.618648] usb usb1: Product: USB/IP Virtual Host Controller
[    3.618650] usb usb1: Manufacturer: Linux 3.11.0-rc2-00010-gc817a67-dirty vhci_hcd
[    3.618652] usb usb1: SerialNumber: vhci_hcd
[    3.658590] hub 1-0:1.0: USB hub found
[    3.663495] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIndex 0
[    3.665600] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
[    3.667295] vhci_hcd: vhci_hub_control:398: port -1
[    3.667609] power_supply test_battery: prop STATUS=Discharging
[    3.667614] power_supply test_battery: prop CHARGE_TYPE=Fast
[    3.667618] power_supply test_battery: prop HEALTH=Good
[    3.667622] power_supply test_battery: prop PRESENT=1
[    3.667625] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    3.667629] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    3.667632] power_supply test_battery: prop CHARGE_FULL=100
[    3.667636] power_supply test_battery: prop CHARGE_NOW=50
[    3.667640] power_supply test_battery: prop CAPACITY=50
[    3.667643] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    3.667647] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    3.667651] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    3.667655] power_supply test_battery: prop MODEL_NAME=Test battery
[    3.667658] power_supply test_battery: prop MANUFACTURER=Linux
[    3.667662] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    3.667666] power_supply test_battery: prop TEMP=26
[    3.667669] power_supply test_battery: prop VOLTAGE_NOW=3300
[    3.699843] vhci_hcd: vhci_hub_control:405:  bye
[    3.717393] hub 1-0:1.0: 8 ports detected
[    3.718562] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex 0
[    3.720865] vhci_hcd: vhci_hub_control:309:  GetHubStatus
[    3.722389] vhci_hcd: vhci_hub_control:398: port -1
[    3.723962] vhci_hcd: vhci_hub_control:405:  bye
[    3.725953] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 1
[    3.728313] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.730129] vhci_hcd: vhci_hub_control:398: port 0
[    3.734168] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.739796] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.741285] vhci_hcd: dump_port_status_diff:119:
[    3.743319] vhci_hcd: vhci_hub_control:405:  bye
[    3.744546] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 2
[    3.746277] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.747923] vhci_hcd: vhci_hub_control:398: port 1
[    3.750069] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.752146] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.753506] vhci_hcd: dump_port_status_diff:119:
[    3.754702] vhci_hcd: vhci_hub_control:405:  bye
[    3.755903] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 3
[    3.757739] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.759400] vhci_hcd: vhci_hub_control:398: port 2
[    3.760683] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.762874] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.764282] vhci_hcd: dump_port_status_diff:119:
[    3.765404] vhci_hcd: vhci_hub_control:405:  bye
[    3.767929] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 4
[    3.769540] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.770981] vhci_hcd: vhci_hub_control:398: port 3
[    3.772079] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.774518] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.775829] vhci_hcd: dump_port_status_diff:119:
[    3.777004] vhci_hcd: vhci_hub_control:405:  bye
[    3.778148] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 5
[    3.779854] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.781493] vhci_hcd: vhci_hub_control:398: port 4
[    3.782686] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.784727] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.786054] vhci_hcd: dump_port_status_diff:119:
[    3.787165] vhci_hcd: vhci_hub_control:405:  bye
[    3.788315] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 6
[    3.790017] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.791584] vhci_hcd: vhci_hub_control:398: port 5
[    3.792819] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.794747] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.799213] vhci_hcd: dump_port_status_diff:119:
[    3.803423] vhci_hcd: vhci_hub_control:405:  bye
[    3.809093] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 7
[    3.811149] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.813038] vhci_hcd: vhci_hub_control:398: port 6
[    3.814357] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.816505] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.817821] vhci_hcd: dump_port_status_diff:119:
[    3.819093] vhci_hcd: vhci_hub_control:405:  bye
[    3.820407] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 8
[    3.822036] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.823552] vhci_hcd: vhci_hub_control:398: port 7
[    3.824571] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.826052] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.827562] vhci_hcd: dump_port_status_diff:119:
[    3.829032] vhci_hcd: vhci_hub_control:405:  bye
[    3.830654] vhci_hcd: vhci_hcd_probe:1034: bye
[    3.831747] vhci_hcd: vhci_hcd_init:1156: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.0.0
[    3.834112] usbcore: registered new interface driver usbip-host
[    3.835566] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
[    3.837197] usbcore: registered new interface driver tranzport
[    3.838687] usbcore: registered new interface driver alphatrack
[    3.840279] vme_user: VME User Space Access Driver
[    3.841308] vme_user: No cards, skipping registration
[    3.843723] Loading crystalhd 0.9.27
[    3.844759] usbcore: registered new interface driver ft1000usb
[    3.846152] usbcore: registered new interface driver gdm_wimax
[    3.847863] usbcore: registered new interface driver cedusb
[    3.849326] ------------[ cut here ]------------
[    3.850579] WARNING: CPU: 0 PID: 1 at /c/wfg/linux/kernel/workqueue.c:590 set_work_data+0x35/0x53()
[    3.852742] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc2-00010-gc817a67-dirty #5
[    3.853298]  000000000000024e ffff88000dc03d28 ffffffff8184e69e 0000000000000000
[    3.853298]  0000000000000000 ffff88000dc03d68 ffffffff8108f38d ffff88000dc03da8
[    3.853298]  ffffffff810a09cc ffff880006da4060 ffff88000dc13400 0000000000000005
[    3.853298] Call Trace:
[    3.853298]  <IRQ>  [<ffffffff8184e69e>] dump_stack+0x4f/0x84
[    3.853298]  [<ffffffff8108f38d>] warn_slowpath_common+0x72/0x8c
[    3.853298]  [<ffffffff810a09cc>] ? set_work_data+0x35/0x53
[    3.853298]  [<ffffffff8108f45e>] warn_slowpath_null+0x15/0x17
[    3.853298]  [<ffffffff810a09cc>] set_work_data+0x35/0x53
[    3.853298]  [<ffffffff810a0cc2>] insert_work+0x28/0x66
[    3.853298]  [<ffffffff810a1b64>] __queue_work+0x1d7/0x1ee
[    3.853298]  [<ffffffff810a1b7b>] ? __queue_work+0x1ee/0x1ee
[    3.853298]  [<ffffffff810a1b94>] delayed_work_timer_fn+0x19/0x1b
[    3.853298]  [<ffffffff8109897f>] call_timer_fn+0x6b/0xde
[    3.853298]  [<ffffffff81098914>] ? __internal_add_timer+0xc0/0xc0
[    3.853298]  [<ffffffff81098fa9>] run_timer_softirq+0x16f/0x1da
[    3.853298]  [<ffffffff810a1b7b>] ? __queue_work+0x1ee/0x1ee
[    3.853298]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
[    3.853298]  [<ffffffff81095745>] irq_exit+0x58/0x9e
[    3.853298]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
[    3.853298]  [<ffffffff8185a772>] apic_timer_interrupt+0x72/0x80
[    3.853298]  <EOI>  [<ffffffff8108f47c>] ? arch_local_irq_restore+0x6/0xd
[    3.853298]  [<ffffffff81090db8>] vprintk_emit+0x3f9/0x422
[    3.853298]  [<ffffffff81856c18>] ? mutex_unlock+0x9/0xb
[    3.853298]  [<ffffffff8184c93f>] printk+0x48/0x4a
[    3.853298]  [<ffffffff81522c57>] usb_register_driver+0x125/0x159
[    3.853298]  [<ffffffff81e45520>] ? usb_gdm_wimax_init+0x1b/0x1b
[    3.853298]  [<ffffffff81e45539>] ced_driver_init+0x19/0x1b
[    3.853298]  [<ffffffff81e10e0c>] do_one_initcall+0x8e/0x132
[    3.853298]  [<ffffffff810a6e00>] ? param_array_set+0xd3/0xf2
[    3.853298]  [<ffffffff810a7021>] ? parse_args+0x1ad/0x26c
[    3.853298]  [<ffffffff81e10fe2>] kernel_init_freeable+0x132/0x1bc
[    3.853298]  [<ffffffff81e106e3>] ? do_early_param+0x86/0x86
[    3.853298]  [<ffffffff818484ef>] ? rest_init+0xc3/0xc3
[    3.853298]  [<ffffffff818484f8>] kernel_init+0x9/0xcc
[    3.853298]  [<ffffffff81859a3c>] ret_from_fork+0x7c/0xb0
[    3.853298]  [<ffffffff818484ef>] ? rest_init+0xc3/0xc3
[    3.853298] ---[ end trace d5b6351ae4f4e525 ]---
[    3.965655] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 1
[    3.968494] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 1
[    3.970801] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.970874] ipip: IPv4 over IPv4 tunneling driver
[    3.971302] gre: GRE over IPv4 demultiplexor driver
[    3.971305] IPv4 over IPSec tunneling driver
[    3.971701] TCP: cubic registered
[    3.971706] NET: Registered protocol family 17
[    3.986503] vhci_hcd: vhci_hub_control:398: port 0
[    3.986799] NET: Registered protocol family 9
[    3.986815] X.25 for Linux Version 0.2
[    3.990714] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.993113] NET: Registered protocol family 33
[    3.994410] Key type rxrpc registered
[    3.995472] Key type rxrpc_s registered
[    3.996858] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.998424] vhci_hcd: dump_port_status_diff:119:
[    3.998922] RxRPC: Registered security type 2 'rxkad'
[    3.999017] l2tp_core: L2TP core driver, V2.0
[    3.999019] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    4.009980] vhci_hcd: vhci_hub_control:405:  bye
[    4.013676] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    4.013755] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 2
[    4.013758] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 2
[    4.013760] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.013761] vhci_hcd: vhci_hub_control:398: port 1
[    4.013763] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.013765] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.013766] vhci_hcd: dump_port_status_diff:119:
[    4.013768] vhci_hcd: vhci_hub_control:405:  bye
[    4.013776] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 3
[    4.013778] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 3
[    4.013780] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.013781] vhci_hcd: vhci_hub_control:398: port 2
[    4.013783] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.013784] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.013786] vhci_hcd: dump_port_status_diff:119:
[    4.013787] vhci_hcd: vhci_hub_control:405:  bye
[    4.013795] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 4
[    4.013797] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 4
[    4.013799] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.013800] vhci_hcd: vhci_hub_control:398: port 3
[    4.013802] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.013803] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.013805] vhci_hcd: dump_port_status_diff:119:
[    4.013806] vhci_hcd: vhci_hub_control:405:  bye
[    4.013814] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 5
[    4.013815] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 5
[    4.013817] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.013818] vhci_hcd: vhci_hub_control:398: port 4
[    4.013820] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.013822] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.013823] vhci_hcd: dump_port_status_diff:119:
[    4.013824] vhci_hcd: vhci_hub_control:405:  bye
[    4.013832] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 6
[    4.013834] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 6
[    4.013836] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.013837] vhci_hcd: vhci_hub_control:398: port 5
[    4.013853] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.013856] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.013859] vhci_hcd: dump_port_status_diff:119:
[    4.013861] vhci_hcd: vhci_hub_control:405:  bye
[    4.013879] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 7
[    4.013883] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 7
[    4.013886] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.013890] vhci_hcd: vhci_hub_control:398: port 6
[    4.013893] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.013897] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.013900] vhci_hcd: dump_port_status_diff:119:
[    4.013902] vhci_hcd: vhci_hub_control:405:  bye
[    4.013925] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 8
[    4.013938] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 8
[    4.013940] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    4.013942] vhci_hcd: vhci_hub_control:398: port 7
[    4.013943] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    4.013945] vhci_hcd: dump_port_status_diff:115:   POWER
[    4.013946] vhci_hcd: dump_port_status_diff:119:
[    4.013948] vhci_hcd: vhci_hub_control:405:  bye
[    4.115083] NET: Registered protocol family 12
[    4.115176] usb usb1: vhci_bus_suspend
[    4.115189] vhci_hcd: vhci_hub_status:208: changed 0
[    4.136687] 8021q: 802.1Q VLAN Support v1.8
[    4.137873] sctp: Hash tables configured (established 1024 bind 1024)
[    4.139760] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[    4.140936] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[    4.142046] NET: Registered protocol family 37
[    4.143504] NET: Registered protocol family 36
[    4.149610] Key type dns_resolver registered
[    4.157914] Key type ceph registered
[    4.161455] libceph: loaded (mon/osd proto 15/24)
[    4.173773] mpls_gso: MPLS GSO support
[    4.176849]
[    4.176849] printing PIC contents
[    4.180113] ... PIC  IMR: ffff
[    4.180934] ... PIC  IRR: 1013
[    4.182246] ... PIC  ISR: 0000
[    4.183108] ... PIC ELCR: 0c00
[    4.183941] printing local APIC contents on CPU#0/0:
[    4.184064] ... APIC ID:      00000000 (0)
[    4.184064] ... APIC VERSION: 00050014
[    4.184064] ... APIC TASKPRI: 00000000 (00)
[    4.184064] ... APIC PROCPRI: 00000000
[    4.184064] ... APIC LDR: 01000000
[    4.184064] ... APIC DFR: ffffffff
[    4.184064] ... APIC SPIV: 000001ff
[    4.184064] ... APIC ISR field:
[    4.184064] 0000000000000000000000000000000000000000000000000000000000000000
[    4.184064] ... APIC TMR field:
[    4.184064] 0000000000000000000000000000000000000000000000000000000000000000
[    4.184064] ... APIC IRR field:
[    4.184064] 0000000000000000000000000000000000000000000000000000000000008000
[    4.184064] ... APIC ESR: 00000000
[    4.184064] ... APIC ICR: 000008fd
[    4.184064] ... APIC ICR2: 02000000
[    4.184064] ... APIC LVTT: 000000ef
[    4.184064] ... APIC LVTPC: 00010000
[    4.184064] ... APIC LVT0: 00010700
[    4.184064] ... APIC LVT1: 00000400
[    4.184064] ... APIC LVTERR: 000000fe
[    4.184064] ... APIC TMICT: 0003c09b
[    4.184064] ... APIC TMCCT: 00000000
[    4.184064] ... APIC TDCR: 00000003
[    4.184064]
[    4.261975] number of MP IRQ sources: 15.
[    4.264571] number of IO-APIC #0 registers: 24.
[    4.267427] testing the IO APIC.......................
[    4.270633] IO APIC #0......
[    4.272381] .... register #00: 00000000
[    4.274851] .......    : physical APIC id: 00
[    4.277607] .......    : Delivery Type: 0
[    4.279998] .......    : LTS          : 0
[    4.282531] .... register #01: 00170011
[    4.285015] .......     : max redirection entries: 17
[    4.288108] .......     : PRQ implemented: 0
[    4.291681] .......     : IO APIC version: 11
[    4.295687] .... register #02: 00000000
[    4.299471] .......     : arbitration: 00
[    4.303368] .... IRQ redirection table:
[    4.306989] 1    0    0   0   0    0    0    00
[    4.311343] 0    0    0   0   0    1    1    31
[    4.315681] 0    0    0   0   0    1    1    30
[    4.320355] 0    0    0   0   0    1    1    33
[    4.325637] 1    0    0   0   0    1    1    34
[    4.327184] 1    1    0   0   0    1    1    35
[    4.328500] 0    0    0   0   0    1    1    36
[    4.329471] 0    0    0   0   0    1    1    37
[    4.330558] 0    0    0   0   0    1    1    38
[    4.336219] 0    1    0   0   0    1    1    39
[    4.337651] 1    1    0   0   0    1    1    3A
[    4.338770] 1    1    0   0   0    1    1    3B
[    4.339718] 0    0    0   0   0    1    1    3C
[    4.340793] 0    0    0   0   0    1    1    3D
[    4.341641] 0    0    0   0   0    1    1    3E
[    4.342472] 0    0    0   0   0    1    1    3F
[    4.343298] 1    0    0   0   0    0    0    00
[    4.361386] 1    0    0   0   0    0    0    00
[    4.367156] 1    0    0   0   0    0    0    00
[    4.379387] 1    0    0   0   0    0    0    00
[    4.381987] 1    0    0   0   0    0    0    00
[    4.382423] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[    4.387892] 1    0    0   0   0    0    0    00
[    4.390898] 1    0    0   0   0    0    0    00
[    4.393092] 1    0    0   0   0    0    0    00
[    4.397430] IRQ to pin mappings:
[    4.399237] IRQ0 -> 0:2
[    4.399968] IRQ1 -> 0:1
[    4.400691] IRQ3 -> 0:3
[    4.401340] IRQ4 -> 0:4
[    4.402055] IRQ5 -> 0:5
[    4.402709] IRQ6 -> 0:6
[    4.403396] IRQ7 -> 0:7
[    4.404129] IRQ8 -> 0:8
[    4.404821] IRQ9 -> 0:9
[    4.405501] IRQ10 -> 0:10
[    4.408703] IRQ11 -> 0:11
[    4.414536] IRQ12 -> 0:12
[    4.418238] IRQ13 -> 0:13
[    4.420708] IRQ14 -> 0:14
[    4.421498] IRQ15 -> 0:15
[    4.422609] .................................... done.
[    4.424735] registered taskstats version 1
[    4.430451] rtc-test rtc-test.0: setting system clock to 2013-09-09 06:44:10 UTC (1378709050)
[    4.442982] debug: unmapping init [mem 0xffffffff81dfc000-0xffffffff81ecefff]
/bin/sh: /proc/self/fd/9: No such file or directory
[    4.523581] sh (124) used greatest stack depth: 5096 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
qemu: terminating on signal 2
wfg@bee ~/linux/obj-compiletest% kvm-0day.sh arch/x86/boot/bzImage
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc2-00010-gc817a67-dirty (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #5 SMP PREEMPT Tue Oct 8 09:29:02 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
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
[    0.000000] BRK [0x028a7000, 0x028a7fff] PGTABLE
[    0.000000] BRK [0x028a8000, 0x028a8fff] PGTABLE
[    0.000000] BRK [0x028a9000, 0x028a9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x028aa000, 0x028aafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x028ab000, 0x028abfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128416(97%)
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
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 199068K/261744K available (8557K kernel code, 1784K rwdata, 3968K rodata, 844K init, 10064K bss, 62676K reserved)
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
[    0.000000] ODEBUG: 5 of 5 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.012000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=10774032)
[    0.016020] pid_max: default: 32768 minimum: 301
[    0.020301] Mount-cache hash table entries: 256
[    0.024611] Initializing cgroup subsys devices
[    0.028055] Initializing cgroup subsys perf_event
[    0.032046] Initializing cgroup subsys net_prio
[    0.033378] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.033378] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.033378] tlb_flushall_shift: 6
[    0.036048] debug: unmapping init [mem 0xffffffff81ecf000-0xffffffff81ed2fff]
[    0.044185] ACPI: Core revision 20130517
[    0.048199] ACPI: All ACPI Tables successfully acquired
[    0.050341] Getting VERSION: 50014
[    0.052027] Getting VERSION: 50014
[    0.053093] Getting ID: 0
[    0.053847] Getting ID: ff000000
[    0.054685] Getting LVT0: 8700
[    0.056024] Getting LVT1: 8400
[    0.057128] enabled ExtINT on CPU#0
[    0.061354] ENABLING IO-APIC IRQs
[    0.062247] init IO_APIC IRQs
[    0.063245]  apic 0 pin 0 not connected
[    0.064056] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.068073] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.076058] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.080061] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.084060] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.088061] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.092063] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.096064] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.100059] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.104062] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.106067] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.108049] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.112057] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.114071] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.116061] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.120042]  apic 0 pin 16 not connected
[    0.121016]  apic 0 pin 17 not connected
[    0.124011]  apic 0 pin 18 not connected
[    0.125011]  apic 0 pin 19 not connected
[    0.125993]  apic 0 pin 20 not connected
[    0.126952]  apic 0 pin 21 not connected
[    0.128014]  apic 0 pin 22 not connected
[    0.129007]  apic 0 pin 23 not connected
[    0.129855] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.131611] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.133882] Using local APIC timer interrupts.
[    0.133882] calibrating APIC timer ...
[    0.140000] ... lapic delta = 6293355
[    0.140000] ... PM-Timer delta = 360453
[    0.140000] ... PM-Timer result ok
[    0.140000] ..... delta 6293355
[    0.140000] ..... mult: 270297539
[    0.140000] ..... calibration result: 4027747
[    0.140000] ..... CPU clock speed is 2712.1134 MHz.
[    0.140000] ..... host bus clock speed is 1006.3747 MHz.
[    0.140114] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.164555] SMP alternatives: lockdep: fixing up alternatives
[    0.165627] smpboot: Booting Node   0, Processors  #1 OK
[    0.012000] kvm-clock: cpu 1, msr 0:e896041, secondary cpu clock
[    0.012000] masked ExtINT on CPU#1
[    0.184247] Brought up 2 CPUs
[    0.184165] KVM setup async PF for cpu 1
[    0.184165] kvm-stealtime: cpu 1, msr dd0ccc0
[    0.188013] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.192353] devtmpfs: initialized
[    0.196592] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.200696] regulator-dummy: no parameters
[    0.204355] NET: Registered protocol family 16
[    0.207671] ACPI: bus type PCI registered
[    0.208088] PCI: Using configuration type 1 for base access
[    0.224967] ACPI: Added _OSI(Module Device)
[    0.228013] ACPI: Added _OSI(Processor Device)
[    0.229337] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.230474] ACPI: Added _OSI(Processor Aggregator Device)
[    0.234120] ACPI: EC: Look up EC in DSDT
[    0.241555] ACPI: Interpreter enabled
[    0.243878] ACPI: (supports S0 S5)
[    0.244012] ACPI: Using IOAPIC for interrupt routing
[    0.246372] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.263187] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.264447] PCI host bridge to bus 0000:00
[    0.265434] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.266822] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.268016] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.269549] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.272010] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.273612] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.275602] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.276846] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.281875] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.285799] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.287618] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.288045] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.292499] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.296932] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.303049] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.313988] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.316612] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.320021] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.322511] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.330309] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.332658] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.336727] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.339457] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.346281] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.348477] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.352768] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.360160] pci_bus 0000:00: on NUMA node 0
[    0.361244] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.363123] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.365761] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.368690] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.371217] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.377066] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.378871] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.381379] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.384035] ACPI: \_SB_.PCI0: notify handler is installed
[    0.385779] Found 1 acpi root devices
[    0.389153] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.392018] vgaarb: loaded
[    0.396007] vgaarb: bridge control possible 0000:00:02.0
[    0.398109] ACPI: bus type USB registered
[    0.400126] usbcore: registered new interface driver usbfs
[    0.408099] usbcore: registered new interface driver hub
[    0.416170] usbcore: registered new device driver usb
[    0.418725] pps_core: LinuxPPS API ver. 1 registered
[    0.420017] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.424100] PTP clock support registered
[    0.425908] wmi: Mapper loaded
[    0.428108] PCI: Using ACPI for IRQ routing
[    0.429236] PCI: pci_cache_line_size set to 64 bytes
[    0.431075] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.432035] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.434247] NET: Registered protocol family 23
[    0.436765] cfg80211: Calling CRDA to update world regulatory domain
[    0.444181] nfc: nfc_init: NFC Core ver 0.1
[    0.445131] NET: Registered protocol family 39
[    0.448146] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.449647] Switched to clocksource kvm-clock
[    0.449647] pnp: PnP ACPI init
[    0.449970] ACPI: bus type PNP registered
[    0.450866] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.452407] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.453606] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.455071] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.456345] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.457857] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.459080] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.460483] pnp 00:03: [dma 2]
[    0.461319] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.463083] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.465348] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.467266] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.475108] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.483345] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.485856] pnp: PnP ACPI: found 7 devices
[    0.486856] ACPI: bus type PNP unregistered
[    0.496536] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.497920] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.499239] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.501107] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.503025] NET: Registered protocol family 2
[    0.505946] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    0.507757] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.509663] TCP: Hash tables configured (established 2048 bind 2048)
[    0.514702] TCP: reno registered
[    0.517472] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.524421] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.531758] NET: Registered protocol family 1
[    0.546393] RPC: Registered named UNIX socket transport module.
[    0.550641] RPC: Registered udp transport module.
[    0.553669] RPC: Registered tcp transport module.
[    0.560493] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.567671] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.570046] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.571488] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.573518] pci 0000:00:02.0: Boot video device
[    0.574824] PCI: CLS 0 bytes, default 64
[    0.576238] Unpacking initramfs...
[    2.301630] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    2.307660] has_svm: not amd
[    2.323305] kvm: no hardware support
[    2.327785] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    2.330741] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    2.334433] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    2.334745] cryptomgr_test (24) used greatest stack depth: 6224 bytes left
[    2.344624] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.346334] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.347299] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.351372] AVX or AES-NI instructions are not detected.
[    2.353331] AVX instructions are not detected.
[    2.354445] AVX instructions are not detected.
[    2.361721] AVX instructions are not detected.
[    2.372720] Initializing RT-Tester: OK
[    2.377607] audit: initializing netlink socket (disabled)
[    2.381294] type=2000 audit(1378709047.418:1): initialized
[    2.387953] DLM installed
[    2.391291] NFS: Registering the id_resolver key type
[    2.392246] Key type id_resolver registered
[    2.392833] Key type id_legacy registered
[    2.393575] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.395271] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.396621] fuse init (API version 7.22)
[    2.398686] ceph: loaded (mds proto 32)
[    2.401517] cryptomgr_test (43) used greatest stack depth: 5768 bytes left
[    2.403855] cryptomgr_test (46) used greatest stack depth: 5688 bytes left
[    2.418600] cryptomgr_test (72) used greatest stack depth: 5280 bytes left
[    2.435933] alg: No test for crc32 (crc32-table)
[    2.437624] alg: No test for lz4hc (lz4hc-generic)
[    2.438846] alg: No test for stdrng (krng)
[    2.440156] NET: Registered protocol family 38
[    2.440907] Key type asymmetric registered
[    2.441581] Asymmetric key parser 'x509' registered
[    2.442151] test_string_helpers: Running tests...
[    2.443483] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    2.444426] crc32: self tests passed, processed 225944 bytes in 306717 nsec
[    2.445912] crc32c: CRC_LE_BITS = 32
[    2.446528] crc32c: self tests passed, processed 225944 bytes in 151803 nsec
[    2.449500] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    2.457384] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    2.459456] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    2.463169] vmlfb: initializing
[    2.465094] Could not find Carillo Ranch MCH device.
[    2.466426] no IO addresses supplied
[    2.467536] hgafb: HGA card not detected.
[    2.468619] hgafb: probe of hgafb.0 failed with error -22
[    2.470078] usbcore: registered new interface driver udlfb
[    2.471468] usbcore: registered new interface driver smscufx
[    2.480156] uvesafb: failed to execute /sbin/v86d
[    2.484438] uvesafb: make sure that the v86d helper is installed and executable
[    2.492532] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    2.498101] uvesafb: vbe_init() failed with -22
[    2.501399] uvesafb: probe of uvesafb.0 failed with error -22
[    2.506899] ipmi message handler version 39.2
[    2.511591] ipmi device interface
[    2.515839] IPMI System Interface driver.
[    2.520794] ipmi_si: Adding default-specified kcs state machine
[    2.522268] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    2.524755] ipmi_si: Interface detection failed
[    2.536318] ipmi_si: Adding default-specified smic state machine
[    2.537586] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    2.539435] ipmi_si: Interface detection failed
[    2.552256] ipmi_si: Adding default-specified bt state machine
[    2.553194] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    2.555069] ipmi_si: Interface detection failed
[    2.564386] kobject: 'ipmi_si' (ffff880007715a00): kobject_release, parent ffff8800001b7648 (delayed)
[    2.565841] kobject: 'ipmi_si' (ffff880007715800): kobject_release, parent ffff880000221248 (delayed)
[    2.567178] kobject: 'ipmi_si' (ffff880007715c00): kobject_release, parent ffff880000189248 (delayed)
[    2.570759] ipmi_si: Unable to find any System Interface(s)
[    2.576128] IPMI Watchdog: driver initialized
[    2.580525] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    2.588511] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.595202] ACPI: Power Button [PWRF]
[    2.719042] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.744847] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.748173] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    2.752317] ac.o: No PCI boards found.
[    2.753263] ac.o: For an ISA board you must supply memory and irq parameters.
[    2.755580] Non-volatile memory driver v1.3
[    2.756792] Linux agpgart interface v0.103
[    2.758402] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    2.759920] kobject: 'drm' (ffff880006dc8848): kobject_release, parent ffff880000189648 (delayed)
[    2.762203] kobject: 'drm' (ffff880006dc5000): kobject_release, parent           (null) (delayed)
[    2.764534] [drm] radeon kernel modesetting enabled.
[    2.767605] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
[    2.770755] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/dri.
[    2.773298] kobject: 'controlD64' (ffff880006dc8020): kobject_release, parent           (null) (delayed)
[    2.777055] cirrus: probe of 0000:00:02.0 failed with error -1
[    2.778826] usbcore: registered new interface driver udl
[    2.781344] parport_pc 00:04: reported by Plug and Play ACPI
[    2.782953] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    2.785609] kobject: 'parport_pc.956' (ffff880006dc8020): kobject_release, parent           (null) (delayed)
[    2.790194] kobject: 'parport_pc.888' (ffff880006ddc820): kobject_release, parent           (null) (delayed)
[    2.795424] kobject: 'parport_pc.632' (ffff880006ddc020): kobject_release, parent           (null) (delayed)
[    2.799212] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.805617] dummy-irq: no IRQ given.  Use irq=N
[    2.809070] Phantom Linux Driver, version n0.9.8, init OK
[    2.810972] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    2.813380] c2port c2port0: C2 port uc added
[    2.815573] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    2.817825] Guest personality initialized and is inactive
[    2.820061] VMCI host device registered (name=vmci, major=10, minor=56)
[    2.821681] Initialized host personality
[    2.822927] Driver for timberdale has been successfully registered.
[    2.824850] usbcore: registered new interface driver viperboard
[    2.826446] usbcore: registered new interface driver pn533
[    2.828253] mtdoops: mtd device (mtddev=name/number) must be supplied
[    2.830458] device id = 2440
[    2.831812] device id = 2480
[    2.832789] device id = 24c0
[    2.833531] device id = 24d0
[    2.834246] device id = 25a1
[    2.834985] device id = 2670
[    2.835836] platform physmap-flash.0: failed to claim resource 0
[    2.837397] kobject: 'physmap-flash' (ffff880006df2800): kobject_release, parent ffff880000189248 (delayed)
[    2.839830] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    2.841535] Could not find PAR responsible for SC520CDP Flash Bank #0
[    2.845836] Trying default address 0x8400000
[    2.846911] Could not find PAR responsible for SC520CDP Flash Bank #1
[    2.848601] Trying default address 0x8c00000
[    2.849829] Could not find PAR responsible for SC520CDP DIL Flash
[    2.851322] Trying default address 0x9400000
[    2.852517] SC520 CDP flash device: 0x800000 at 0x8400000
[    2.853897] Failed to ioremap_nocache
[    2.854817] Failed to ioremap_nocache
[    2.855825] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.857577] kobject: 'docg3' (ffff880006df9c00): kobject_release, parent ffff880000189248 (delayed)
[    2.859776] slram: not enough parameters.
[    2.866032] No valid DiskOnChip devices found
[    2.870182] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.881417] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.893220] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.899903] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.911456] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.920385] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    2.924684] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    2.927599] flash size: 128 MiB
[    2.928507] page size: 512 bytes
[    2.929358] OOB area size: 16 bytes
[    2.930485] sector size: 16 KiB
[    2.931340] pages number: 262144
[    2.932198] pages per sector: 32
[    2.932984] bus width: 8
[    2.933626] bits in sector size: 14
[    2.934455] bits in page size: 9
[    2.935283] bits in OOB size: 4
[    2.936124] flash size with OOB: 135168 KiB
[    2.937167] page address bytes: 4
[    2.937963] sector address bytes: 3
[    2.938833] options: 0x42
[    2.945101] Scanning device for bad blocks
[    2.992127] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    2.993739] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.003777] parport0: powerup/reset Butterfly
[    3.125855] parport_pc 00:04: registered master spi42
[    3.126870] parport_pc 00:04: master is unqueued, this is deprecated
[    3.128168] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    3.129274] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    3.130713] parport_pc 00:04: registered child spi42.1
[    3.131684] parport0: dataflash at spi42.1
[    3.132561] parport0: AVR Butterfly
[    3.133353] parport0: cannot grant exclusive access for device spi-lm70llp
[    3.134496] spi-lm70llp: spi_lm70llp probe fail, status -12
[    3.135789] usbcore: registered new interface driver irda-usb
[    3.137119] usbcore: registered new interface driver stir4200
[    3.141095] usbcore: registered new interface driver mcs7780
[    3.142428] usbcore: registered new interface driver kingsun-sir
[    3.143887] usbcore: registered new interface driver ksdazzle-sir
[    3.145488] usbcore: registered new interface driver ks959-sir
[    3.147488] usbcore: registered new interface driver hwa-rc
[    3.152251] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.153759] ohci-pci: OHCI PCI platform driver
[    3.154967] ohci-platform: OHCI generic platform driver
[    3.156647] uhci_hcd: USB Universal Host Controller Interface driver
[    3.158518] driver u132_hcd
[    3.160218] usbcore: registered new interface driver hwa-hc
[    3.161664] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    3.163138] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    3.165959] usbcore: registered new interface driver cdc_wdm
[    3.167408] usbcore: registered new interface driver usbtmc
[    3.169250] usbcore: registered new interface driver appledisplay
[    3.170232] usbcore: registered new interface driver emi26 - firmware loader
[    3.170986] usbcore: registered new interface driver emi62 - firmware loader
[    3.171789] driver ftdi-elan
[    3.173192] usbcore: registered new interface driver ftdi-elan
[    3.174157] usbcore: registered new interface driver idmouse
[    3.174972] usbcore: registered new interface driver usblcd
[    3.175917] usbcore: registered new interface driver ldusb
[    3.176578] usbcore: registered new interface driver usbled
[    3.177606] usbcore: registered new interface driver legousbtower
[    3.178579] usbcore: registered new interface driver rio500
[    3.179487] usbcore: registered new interface driver usbtest
[    3.180531] usbcore: registered new interface driver trancevibrator
[    3.181664] usbcore: registered new interface driver uss720
[    3.182628] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[    3.184252] uss720: NOTE: this is a special purpose driver to allow nonstandard
[    3.191870] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[    3.198976] uss720: If you just want to connect to a printer, use usblp instead
[    3.205389] usbcore: registered new interface driver yurex
[    3.210439] kobject: 'gpio-vbus' (ffff88000682f400): kobject_release, parent ffff880000189248 (delayed)
[    3.221687] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.227546] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.228893] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.229937] parport0: cannot grant exclusive access for device parkbd
[    3.320276] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    3.320366] usbcore: registered new interface driver bcm5974
[    3.320678] usbcore: registered new interface driver synaptics_usb
[    3.321049] usbcore: registered new interface driver iforce
[    3.321314] parport0: cannot grant exclusive access for device walkera0701
[    3.321316] walkera0701: failed to register parport device
[    3.321725] usbcore: registered new interface driver usbtouchscreen
[    3.321982] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    3.322013] usbcore: registered new interface driver ati_remote2
[    3.322033] cm109: Keymap for Komunikate KIP1000 phone loaded
[    3.322069] usbcore: registered new interface driver cm109
[    3.322070] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    3.322108] usbcore: registered new interface driver keyspan_remote
[    3.347177] usbcore: registered new interface driver yealink
[    3.348213] tsc: Refined TSC clocksource calibration: 2693.466 MHz
[    3.349008] I2O subsystem v1.325
[    3.349015] i2o: max drivers = 8
[    3.349647] I2O Configuration OSM v1.323
[    3.349667] I2O ProcFS OSM v1.316
[    3.349696] kobject: 'proc-osm' (ffff880007708400): kobject_release, parent ffff880007708e48 (delayed)
[    3.351268] kobject: 'mc13xxx-rtc' (ffff880007734400): kobject_release, parent ffff880000189248 (delayed)
[    3.351298] kobject: 'rtc-msm6242' (ffff880007734200): kobject_release, parent ffff880000189248 (delayed)
[    3.351332] kobject: 'pcap-rtc' (ffff880007734000): kobject_release, parent ffff880000189248 (delayed)
[    3.351776] kobject: 'rtc-rp5c01' (ffff880007713000): kobject_release, parent ffff880000189248 (delayed)
[    3.386407] kobject: '(null)' (ffff8800077462f0): kobject_release, parent           (null) (delayed)
[    3.388579] rtc rtc0: test: dev (254:0)
[    3.389442] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    3.391571] rtc rtc1: test: dev (254:1)
[    3.392919] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    3.394364] i2c /dev entries driver
[    3.396496] usbcore: registered new interface driver i2c-diolan-u2c
[    3.398004] i2c-parport: adapter type unspecified
[    3.399155] i2c-parport-light: adapter type unspecified
[    3.401602] pps pps0: new PPS source ktimer
[    3.402987] pps pps0: ktimer PPS source registered
[    3.404690] pps_parport: parallel port PPS client
[    3.406494] parport0: cannot grant exclusive access for device pps_parport
[    3.413866] pps_parport: couldn't register with parport0
[    3.420320] Driver for 1-wire Dallas network protocol.
[    3.423081] usbcore: registered new interface driver DS9490R
[    3.425148] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.427086] power_supply test_ac: uevent
[    3.428367] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    3.434718] power_supply test_ac: prop ONLINE=1
[    3.435899] power_supply test_ac: power_supply_changed
[    3.437304] power_supply test_ac: power_supply_changed_work
[    3.438522] power_supply test_ac: power_supply_update_gen_leds 1
[    3.439921] power_supply test_ac: uevent
[    3.440966] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    3.441122] power_supply test_battery: uevent
[    3.441125] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    3.441132] power_supply test_battery: prop STATUS=Discharging
[    3.441136] power_supply test_battery: prop CHARGE_TYPE=Fast
[    3.441150] power_supply test_battery: prop HEALTH=Good
[    3.441154] power_supply test_battery: prop PRESENT=1
[    3.441157] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    3.441161] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    3.441164] power_supply test_battery: prop CHARGE_FULL=100
[    3.441167] power_supply test_battery: prop CHARGE_NOW=50
[    3.441170] power_supply test_battery: prop CAPACITY=50
[    3.441173] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    3.441176] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    3.441180] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    3.441183] power_supply test_battery: prop MODEL_NAME=Test battery
[    3.441186] power_supply test_battery: prop MANUFACTURER=Linux
[    3.441189] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    3.441192] power_supply test_battery: prop TEMP=26
[    3.441195] power_supply test_battery: prop VOLTAGE_NOW=3300
[    3.441526] power_supply test_battery: power_supply_changed
[    3.441552] power_supply test_battery: power_supply_changed_work
[    3.441557] power_supply test_battery: power_supply_update_bat_leds 2
[    3.441564] power_supply test_battery: uevent
[    3.441566] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    3.441574] power_supply test_battery: prop STATUS=Discharging
[    3.441578] power_supply test_battery: prop CHARGE_TYPE=Fast
[    3.441581] power_supply test_battery: prop HEALTH=Good
[    3.441584] power_supply test_battery: prop PRESENT=1
[    3.441587] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    3.441591] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    3.441594] power_supply test_battery: prop CHARGE_FULL=100
[    3.441597] power_supply test_battery: prop CHARGE_NOW=50
[    3.441600] power_supply test_battery: prop CAPACITY=50
[    3.441603] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    3.441606] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    3.441609] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    3.441612] power_supply test_battery: prop MODEL_NAME=Test battery
[    3.441620] power_supply test_battery: prop MANUFACTURER=Linux
[    3.441624] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    3.441628] power_supply test_battery: prop TEMP=26
[    3.441631] power_supply test_battery: prop VOLTAGE_NOW=3300
[    3.441697] power_supply test_usb: uevent
[    3.441699] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    3.441706] power_supply test_usb: prop ONLINE=1
[    3.441720] power_supply test_usb: power_supply_changed
[    3.441758] power_supply test_usb: power_supply_changed_work
[    3.441763] power_supply test_usb: power_supply_update_gen_leds 1
[    3.441769] power_supply test_usb: uevent
[    3.441771] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    3.441779] power_supply test_usb: prop ONLINE=1
[    3.442608] applesmc: supported laptop not found!
[    3.442610] applesmc: driver init failed (ret=-19)!
[    3.442961] f71882fg: Not a Fintek device
[    3.443027] f71882fg: Not a Fintek device
[    3.443804] kobject: 'mc13783-adc' (ffff88000778f200): kobject_release, parent ffff880000189248 (delayed)
[    3.444372] pc87360: PC8736x not detected, module not inserted
[    3.445042] cpuidle: using governor ladder
[    3.445044] cpuidle: using governor menu
[    3.445061] sdhci: Secure Digital Host Controller Interface driver
[    3.445062] sdhci: Copyright(c) Pierre Ossman
[    3.445556] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    3.445556] usbcore: registered new interface driver vub300
[    3.445578] usbcore: registered new interface driver ushc
[    3.445579] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.446222] ledtrig-cpu: registered to indicate activity on CPUs
[    3.446546] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    3.447580] usbcore: registered new interface driver usbhid
[    3.447581] usbhid: USB HID core driver
[    3.447618] usbip_core: usbip_core_init:804: USB/IP Core v1.0.0
[    3.447717] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    3.447726] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    3.447782] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 1
[    3.447805] vhci_hcd: vhci_start:884: enter vhci_start
[    3.449257] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.449260] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.449262] usb usb1: Product: USB/IP Virtual Host Controller
[    3.449263] usb usb1: Manufacturer: Linux 3.11.0-rc2-00010-gc817a67-dirty vhci_hcd
[    3.449264] usb usb1: SerialNumber: vhci_hcd
[    3.618563] hub 1-0:1.0: USB hub found
[    3.619016] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIndex 0
[    3.620536] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
[    3.621063] power_supply test_ac: prop ONLINE=1
[    3.622597] vhci_hcd: vhci_hub_control:398: port -1
[    3.623488] vhci_hcd: vhci_hub_control:405:  bye
[    3.624540] hub 1-0:1.0: 8 ports detected
[    3.625582] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex 0
[    3.629886] vhci_hcd: vhci_hub_control:309:  GetHubStatus
[    3.630822] vhci_hcd: vhci_hub_control:398: port -1
[    3.633874] vhci_hcd: vhci_hub_control:405:  bye
[    3.636104] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 1
[    3.637844] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.638965] vhci_hcd: vhci_hub_control:398: port 0
[    3.639645] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.641214] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.642172] vhci_hcd: dump_port_status_diff:119:
[    3.642878] vhci_hcd: vhci_hub_control:405:  bye
[    3.643545] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 2
[    3.644688] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.645769] vhci_hcd: vhci_hub_control:398: port 1
[    3.646613] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.647986] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.650438] vhci_hcd: dump_port_status_diff:119:
[    3.652700] vhci_hcd: vhci_hub_control:405:  bye
[    3.658625] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 3
[    3.660657] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.663129] vhci_hcd: vhci_hub_control:398: port 2
[    3.664392] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.666351] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.667665] vhci_hcd: dump_port_status_diff:119:
[    3.668871] vhci_hcd: vhci_hub_control:405:  bye
[    3.670020] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 4
[    3.671685] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.673515] vhci_hcd: vhci_hub_control:398: port 3
[    3.674727] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.676791] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.678099] vhci_hcd: dump_port_status_diff:119:
[    3.679320] vhci_hcd: vhci_hub_control:405:  bye
[    3.680528] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 5
[    3.682240] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.683822] vhci_hcd: vhci_hub_control:398: port 4
[    3.686744] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.688837] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.690132] vhci_hcd: dump_port_status_diff:119:
[    3.691287] vhci_hcd: vhci_hub_control:405:  bye
[    3.692412] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 6
[    3.693990] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.695481] vhci_hcd: vhci_hub_control:398: port 5
[    3.696584] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.698452] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.699675] vhci_hcd: dump_port_status_diff:119:
[    3.700819] vhci_hcd: vhci_hub_control:405:  bye
[    3.701890] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 7
[    3.703360] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.704901] vhci_hcd: vhci_hub_control:398: port 6
[    3.705947] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.707385] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.708626] vhci_hcd: dump_port_status_diff:119:
[    3.709720] vhci_hcd: vhci_hub_control:405:  bye
[    3.710806] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 8
[    3.711977] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.713236] vhci_hcd: vhci_hub_control:398: port 7
[    3.714885] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.717191] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.718359] vhci_hcd: dump_port_status_diff:119:
[    3.719197] vhci_hcd: vhci_hub_control:405:  bye
[    3.720323] vhci_hcd: vhci_hcd_probe:1034: bye
[    3.721155] vhci_hcd: vhci_hcd_init:1156: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.0.0
[    3.723224] usbcore: registered new interface driver usbip-host
[    3.724707] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
[    3.726341] usbcore: registered new interface driver tranzport
[    3.727675] usbcore: registered new interface driver alphatrack
[    3.729145] vme_user: VME User Space Access Driver
[    3.730265] vme_user: No cards, skipping registration
[    3.732820] Loading crystalhd 0.9.27
[    3.733910] usbcore: registered new interface driver ft1000usb
[    3.735389] usbcore: registered new interface driver gdm_wimax
[    3.738097] usbcore: registered new interface driver cedusb
[    3.741566] ipip: IPv4 over IPv4 tunneling driver
[    3.743969] gre: GRE over IPv4 demultiplexor driver
[    3.745534] IPv4 over IPSec tunneling driver
[    3.748906] TCP: cubic registered
[    3.749740] NET: Registered protocol family 17
[    3.751043] NET: Registered protocol family 9
[    3.752178] X.25 for Linux Version 0.2
[    3.756943] NET: Registered protocol family 33
[    3.761330] Key type rxrpc registered
[    3.762581] Key type rxrpc_s registered
[    3.764918] RxRPC: Registered security type 2 'rxkad'
[    3.767595] l2tp_core: L2TP core driver, V2.0
[    3.770570] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    3.773342] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    3.775072] NET: Registered protocol family 12
[    3.788153] ------------[ cut here ]------------
[    3.788962] WARNING: CPU: 0 PID: 0 at /c/wfg/linux/kernel/workqueue.c:590 set_work_data+0x35/0x53()
[    3.790261] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.11.0-rc2-00010-gc817a67-dirty #5
[    3.791422]  000000000000024e ffff88000dc03d28 ffffffff8184e69e 0000000000000000
[    3.792123]  0000000000000000 ffff88000dc03d68 ffffffff8108f38d ffff88000dc03da8
[    3.792123]  ffffffff810a09cc ffff880006dc8060 ffff88000dc13400 0000000000000005
[    3.792123] Call Trace:
[    3.792123]  <IRQ>  [<ffffffff8184e69e>] dump_stack+0x4f/0x84
[    3.792123]  [<ffffffff8108f38d>] warn_slowpath_common+0x72/0x8c
[    3.792123]  [<ffffffff810a09cc>] ? set_work_data+0x35/0x53
[    3.792123]  [<ffffffff8108f45e>] warn_slowpath_null+0x15/0x17
[    3.792123]  [<ffffffff810a09cc>] set_work_data+0x35/0x53
[    3.792123]  [<ffffffff810a0cc2>] insert_work+0x28/0x66
[    3.792123]  [<ffffffff810a1b64>] __queue_work+0x1d7/0x1ee
[    3.792123]  [<ffffffff810a1b7b>] ? __queue_work+0x1ee/0x1ee
[    3.792123]  [<ffffffff810a1b94>] delayed_work_timer_fn+0x19/0x1b
[    3.792123]  [<ffffffff8109897f>] call_timer_fn+0x6b/0xde
[    3.792123]  [<ffffffff81098914>] ? __internal_add_timer+0xc0/0xc0
[    3.792123]  [<ffffffff81098fa9>] run_timer_softirq+0x16f/0x1da
[    3.792123]  [<ffffffff810a1b7b>] ? __queue_work+0x1ee/0x1ee
[    3.792123]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
[    3.792123]  [<ffffffff81095745>] irq_exit+0x58/0x9e
[    3.792123]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
[    3.792123]  [<ffffffff8185a772>] apic_timer_interrupt+0x72/0x80
[    3.792123]  <EOI>  [<ffffffff810c8e9e>] ? lock_release+0x16e/0x17a
[    3.792123]  [<ffffffff8104a18f>] ? native_safe_halt+0x6/0x8
[    3.792123]  [<ffffffff810c707f>] ? trace_hardirqs_on+0xd/0xf
[    3.792123]  [<ffffffff8103071c>] default_idle+0x13/0x1c
[    3.792123]  [<ffffffff81030e8c>] arch_cpu_idle+0x13/0x21
[    3.792123]  [<ffffffff810bd2d6>] cpu_startup_entry+0xfc/0x164
[    3.792123]  [<ffffffff818484e8>] rest_init+0xbc/0xc3
[    3.792123]  [<ffffffff8184842c>] ? csum_partial_copy_generic+0x16c/0x16c
[    3.792123]  [<ffffffff81e10d71>] start_kernel+0x441/0x44e
[    3.792123]  [<ffffffff81e10739>] ? repair_env_string+0x56/0x56
[    3.792123]  [<ffffffff81e10120>] ? early_idt_handlers+0x120/0x120
[    3.792123]  [<ffffffff81e10453>] x86_64_start_reservations+0x2a/0x2c
[    3.792123]  [<ffffffff81e10531>] x86_64_start_kernel+0xdc/0xeb
[    3.792123] ---[ end trace fe921abb5a6ab897 ]---
[    3.931504] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 1
[    3.941210] 8021q: 802.1Q VLAN Support v1.8
[    3.945450] sctp: Hash tables configured (established 1024 bind 1024)
[    3.947883] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 1
[    3.951544] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.952999] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[    3.953006] vhci_hcd: vhci_hub_control:398: port 0
[    3.953009] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.953010] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.953012] vhci_hcd: dump_port_status_diff:119:
[    3.953013] vhci_hcd: vhci_hub_control:405:  bye
[    3.953053] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 2
[    3.953056] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 2
[    3.953058] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.953059] vhci_hcd: vhci_hub_control:398: port 1
[    3.953062] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.953063] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.953064] vhci_hcd: dump_port_status_diff:119:
[    3.953066] vhci_hcd: vhci_hub_control:405:  bye
[    3.953075] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 3
[    3.953077] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 3
[    3.953078] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.953080] vhci_hcd: vhci_hub_control:398: port 2
[    3.953082] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.953083] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.953085] vhci_hcd: dump_port_status_diff:119:
[    3.953086] vhci_hcd: vhci_hub_control:405:  bye
[    3.953095] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 4
[    3.953097] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 4
[    3.953098] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.953100] vhci_hcd: vhci_hub_control:398: port 3
[    3.953102] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.953103] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.953105] vhci_hcd: dump_port_status_diff:119:
[    3.953106] vhci_hcd: vhci_hub_control:405:  bye
[    3.953114] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 5
[    3.953116] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 5
[    3.953118] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.953119] vhci_hcd: vhci_hub_control:398: port 4
[    3.953121] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.953123] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.953124] vhci_hcd: dump_port_status_diff:119:
[    3.953125] vhci_hcd: vhci_hub_control:405:  bye
[    3.953133] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 6
[    3.953135] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 6
[    3.953137] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.953139] vhci_hcd: vhci_hub_control:398: port 5
[    3.953140] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.953142] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.953143] vhci_hcd: dump_port_status_diff:119:
[    3.953144] vhci_hcd: vhci_hub_control:405:  bye
[    3.953153] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 7
[    3.953155] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 7
[    3.953156] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.953158] vhci_hcd: vhci_hub_control:398: port 6
[    3.953160] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.953161] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.953163] vhci_hcd: dump_port_status_diff:119:
[    3.953164] vhci_hcd: vhci_hub_control:405:  bye
[    3.953178] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 8
[    3.953180] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 8
[    3.953182] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.953183] vhci_hcd: vhci_hub_control:398: port 7
[    3.953185] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.953187] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.953188] vhci_hcd: dump_port_status_diff:119:
[    3.953190] vhci_hcd: vhci_hub_control:405:  bye
[    4.109169] usb usb1: vhci_bus_suspend
[    4.110160] vhci_hcd: vhci_hub_status:208: changed 0
[    4.111487] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[    4.113260] NET: Registered protocol family 37
[    4.114554] NET: Registered protocol family 36
[    4.115781] Key type dns_resolver registered
[    4.117044] Key type ceph registered
[    4.125493] libceph: loaded (mon/osd proto 15/24)
[    4.127777] mpls_gso: MPLS GSO support
[    4.130124]
[    4.130124] printing PIC contents
[    4.131233] ... PIC  IMR: ffff
[    4.132266] ... PIC  IRR: 1013
[    4.133182] ... PIC  ISR: 0000
[    4.134077] ... PIC ELCR: 0c00
[    4.135125] printing local APIC contents on CPU#0/0:
[    4.135756] ... APIC ID:      00000000 (0)
[    4.136316] ... APIC VERSION: 00050014
[    4.136832] ... APIC TASKPRI: 00000000 (00)
[    4.137333] ... APIC PROCPRI: 00000000
[    4.137827] ... APIC LDR: 01000000
[    4.138268] ... APIC DFR: ffffffff
[    4.138857] ... APIC SPIV: 000001ff
[    4.139109] ... APIC ISR field:
[    4.139109] 0000000000000000000000000000000000000000000000000000000000000000
[    4.139109] ... APIC TMR field:
[    4.139109] 0000000000000000000000000000000000000000000000000000000000000000
[    4.139109] ... APIC IRR field:
[    4.139109] 0000000000000000000000000000000000000000000000000000000020000000
[    4.139109] ... APIC ESR: 00000000
[    4.139109] ... APIC ICR: 000008fd
[    4.139109] ... APIC ICR2: 02000000
[    4.139109] ... APIC LVTT: 000000ef
[    4.139109] ... APIC LVTPC: 00010000
[    4.139109] ... APIC LVT0: 00010700
[    4.139109] ... APIC LVT1: 00000400
[    4.139109] ... APIC LVTERR: 000000fe
[    4.139109] ... APIC TMICT: 005adcea
[    4.139109] ... APIC TMCCT: 00413b1c
[    4.139109] ... APIC TDCR: 00000003
[    4.139109]
[    4.155458] number of MP IRQ sources: 15.
[    4.156906] number of IO-APIC #0 registers: 24.
[    4.157913] testing the IO APIC.......................
[    4.158937] IO APIC #0......
[    4.159523] .... register #00: 00000000
[    4.160366] .......    : physical APIC id: 00
[    4.161272] .......    : Delivery Type: 0
[    4.162082] .......    : LTS          : 0
[    4.163069] .... register #01: 00170011
[    4.163817] .......     : max redirection entries: 17
[    4.165015] .......     : PRQ implemented: 0
[    4.165638] .......     : IO APIC version: 11
[    4.166381] .... register #02: 00000000
[    4.166849] .......     : arbitration: 00
[    4.167462] .... IRQ redirection table:
[    4.167994] 1    0    0   0   0    0    0    00
[    4.168540] 0    0    0   0   0    1    1    31
[    4.169314] 0    0    0   0   0    1    1    30
[    4.173615] 0    0    0   0   0    1    1    33
[    4.174578] 1    0    0   0   0    1    1    34
[    4.175454] 1    1    0   0   0    1    1    35
[    4.176280] 0    0    0   0   0    1    1    36
[    4.177197] 0    0    0   0   0    1    1    37
[    4.178208] 0    0    0   0   0    1    1    38
[    4.180623] 0    1    0   0   0    1    1    39
[    4.181737] 1    1    0   0   0    1    1    3A
[    4.182738] 1    1    0   0   0    1    1    3B
[    4.183690] 0    0    0   0   0    1    1    3C
[    4.184792] 0    0    0   0   0    1    1    3D
[    4.188890] 0    0    0   0   0    1    1    3E
[    4.189851] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[    4.196410] 0    0    0   0   0    1    1    3F
[    4.201065] 1    0    0   0   0    0    0    00
[    4.206327] 1    0    0   0   0    0    0    00
[    4.207905] 1    0    0   0   0    0    0    00
[    4.209072] 1    0    0   0   0    0    0    00
[    4.210206] 1    0    0   0   0    0    0    00
[    4.211273] 1    0    0   0   0    0    0    00
[    4.212761] 1    0    0   0   0    0    0    00
[    4.213870] 1    0    0   0   0    0    0    00
[    4.214977] IRQ to pin mappings:
[    4.215735] IRQ0 -> 0:2
[    4.216447] IRQ1 -> 0:1
[    4.217233] IRQ3 -> 0:3
[    4.217889] IRQ4 -> 0:4
[    4.218552] IRQ5 -> 0:5
[    4.219213] IRQ6 -> 0:6
[    4.219879] IRQ7 -> 0:7
[    4.220692] IRQ8 -> 0:8
[    4.221361] IRQ9 -> 0:9
[    4.222132] IRQ10 -> 0:10
[    4.222827] IRQ11 -> 0:11
[    4.223479] IRQ12 -> 0:12
[    4.224339] IRQ13 -> 0:13
[    4.225013] IRQ14 -> 0:14
[    4.225698] IRQ15 -> 0:15
[    4.226446] .................................... done.
[    4.228612] registered taskstats version 1
[    4.230442] rtc-test rtc-test.0: setting system clock to 2013-09-09 06:44:09 UTC (1378709049)
[    4.235124] debug: unmapping init [mem 0xffffffff81dfc000-0xffffffff81ecefff]
/bin/sh: /proc/self/fd/9: No such file or directory
[    4.312167] sh (122) used greatest stack depth: 5096 bytes left
/bin/sh: /proc/self/fd/9: No such file or directory
/bin/sh: /proc/self/fd/9: No such file or directory
qemu: terminating on signal 2
wfg@bee ~/linux/obj-compiletest% kvm-0day.sh arch/x86/boot/bzImage
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.11.0-rc2-00010-gc817a67-dirty (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #5 SMP PREEMPT Tue Oct 8 09:29:02 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
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
[    0.000000] BRK [0x028a7000, 0x028a7fff] PGTABLE
[    0.000000] BRK [0x028a8000, 0x028a8fff] PGTABLE
[    0.000000] BRK [0x028a9000, 0x028a9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0e600000-0x0e7fffff]
[    0.000000]  [mem 0x0e600000-0x0e7fffff] page 4k
[    0.000000] BRK [0x028aa000, 0x028aafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x0c000000-0x0e5fffff]
[    0.000000]  [mem 0x0c000000-0x0e5fffff] page 4k
[    0.000000] BRK [0x028ab000, 0x028abfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0bffffff]
[    0.000000]  [mem 0x00100000-0x0bffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e800000-0x0fffdfff]
[    0.000000]  [mem 0x0e800000-0x0fffdfff] page 4k
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128416(97%)
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
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 199068K/261744K available (8557K kernel code, 1784K rwdata, 3968K rodata, 844K init, 10064K bss, 62676K reserved)
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
[    0.000000] ODEBUG: 5 of 5 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.01 BogoMIPS (lpj=10774032)
[    0.009008] pid_max: default: 32768 minimum: 301
[    0.010990] Mount-cache hash table entries: 256
[    0.012669] Initializing cgroup subsys devices
[    0.013827] Initializing cgroup subsys perf_event
[    0.016030] Initializing cgroup subsys net_prio
[    0.017284] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.017284] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.017284] tlb_flushall_shift: 6
[    0.020062] debug: unmapping init [mem 0xffffffff81ecf000-0xffffffff81ed2fff]
[    0.024193] ACPI: Core revision 20130517
[    0.027934] ACPI: All ACPI Tables successfully acquired
[    0.029165] Getting VERSION: 50014
[    0.030054] Getting VERSION: 50014
[    0.030919] Getting ID: 0
[    0.032030] Getting ID: ff000000
[    0.032842] Getting LVT0: 8700
[    0.033600] Getting LVT1: 8400
[    0.034458] enabled ExtINT on CPU#0
[    0.036855] ENABLING IO-APIC IRQs
[    0.037751] init IO_APIC IRQs
[    0.038508]  apic 0 pin 0 not connected
[    0.039513] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.040106] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.044052] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.045927] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.048072] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.052092] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.056068] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.059023] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.060062] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.062031] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.064055] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.068053] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.069577] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.070619] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.071485] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.072050]  apic 0 pin 16 not connected
[    0.073041]  apic 0 pin 17 not connected
[    0.076017]  apic 0 pin 18 not connected
[    0.077000]  apic 0 pin 19 not connected
[    0.077983]  apic 0 pin 20 not connected
[    0.079000]  apic 0 pin 21 not connected
[    0.080020]  apic 0 pin 22 not connected
[    0.080712]  apic 0 pin 23 not connected
[    0.081651] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.084020] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.087131] Using local APIC timer interrupts.
[    0.087131] calibrating APIC timer ...
[    0.092000] ... lapic delta = 6245980
[    0.092000] ... PM-Timer delta = 357734
[    0.092000] ... PM-Timer result ok
[    0.092000] ..... delta 6245980
[    0.092000] ..... mult: 268262798
[    0.092000] ..... calibration result: 3997427
[    0.092000] ..... CPU clock speed is 2691.3288 MHz.
[    0.092000] ..... host bus clock speed is 999.1427 MHz.
[    0.092135] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.116557] SMP alternatives: lockdep: fixing up alternatives
[    0.117619] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] kvm-clock: cpu 1, msr 0:e896041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.136187] KVM setup async PF for cpu 1
[    0.136289] Brought up 2 CPUs
[    0.136294] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.140375] kvm-stealtime: cpu 1, msr dd0ccc0
[    0.144491] devtmpfs: initialized
[    0.148541] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.150385] regulator-dummy: no parameters
[    0.151827] NET: Registered protocol family 16
[    0.153425] ACPI: bus type PCI registered
[    0.156152] PCI: Using configuration type 1 for base access
[    0.168588] ACPI: Added _OSI(Module Device)
[    0.169822] ACPI: Added _OSI(Processor Device)
[    0.170879] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.172018] ACPI: Added _OSI(Processor Aggregator Device)
[    0.175478] ACPI: EC: Look up EC in DSDT
[    0.183893] ACPI: Interpreter enabled
[    0.184034] ACPI: (supports S0 S5)
[    0.184931] ACPI: Using IOAPIC for interrupt routing
[    0.186334] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.205875] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.208091] PCI host bridge to bus 0000:00
[    0.209301] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.210712] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.212020] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.213699] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.216023] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebfffff]
[    0.217855] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.221094] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.224148] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.229371] pci 0000:00:01.1: reg 0x20: [io  0xc060-0xc06f]
[    0.233445] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.236140] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.238652] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.244586] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.252962] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.256076] pci 0000:00:02.0: reg 0x14: [mem 0xfebe2000-0xfebe2fff]
[    0.269000] pci 0000:00:02.0: reg 0x30: [mem 0xfebd0000-0xfebdffff pref]
[    0.272575] pci 0000:00:03.0: [1af4:1000] type 00 class 0x020000
[    0.274766] pci 0000:00:03.0: reg 0x10: [io  0xc040-0xc05f]
[    0.276600] pci 0000:00:03.0: reg 0x14: [mem 0xfebe1000-0xfebe1fff]
[    0.284025] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebcffff pref]
[    0.286399] pci 0000:00:04.0: [8086:100e] type 00 class 0x020000
[    0.289247] pci 0000:00:04.0: reg 0x10: [mem 0xfeb80000-0xfeb9ffff]
[    0.292877] pci 0000:00:04.0: reg 0x14: [io  0xc000-0xc03f]
[    0.300026] pci 0000:00:04.0: reg 0x30: [mem 0xfeba0000-0xfebbffff pref]
[    0.302292] pci 0000:00:05.0: [8086:25ab] type 00 class 0x088000
[    0.304875] pci 0000:00:05.0: reg 0x10: [mem 0xfebe0000-0xfebe000f]
[    0.310773] pci_bus 0000:00: on NUMA node 0
[    0.312063] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.320079] acpi PNP0A03:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.329659] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.331337] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.332836] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.334509] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.336467] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.338887] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.340038] ACPI: \_SB_.PCI0: notify handler is installed
[    0.341321] Found 1 acpi root devices
[    0.343144] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.344018] vgaarb: loaded
[    0.344502] vgaarb: bridge control possible 0000:00:02.0
[    0.345822] ACPI: bus type USB registered
[    0.348108] usbcore: registered new interface driver usbfs
[    0.349311] usbcore: registered new interface driver hub
[    0.352000] usbcore: registered new device driver usb
[    0.352000] pps_core: LinuxPPS API ver. 1 registered
[    0.352021] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.353627] PTP clock support registered
[    0.356007] wmi: Mapper loaded
[    0.356103] PCI: Using ACPI for IRQ routing
[    0.357061] PCI: pci_cache_line_size set to 64 bytes
[    0.358256] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.359789] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.365092] NET: Registered protocol family 23
[    0.366762] cfg80211: Calling CRDA to update world regulatory domain
[    0.368003] nfc: nfc_init: NFC Core ver 0.1
[    0.368003] NET: Registered protocol family 39
[    0.368686] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.372190] Switched to clocksource kvm-clock
[    0.373430] pnp: PnP ACPI init
[    0.374312] ACPI: bus type PNP registered
[    0.376122] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.378004] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.379561] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.381515] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.383165] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.385074] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.386609] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.388379] pnp 00:03: [dma 2]
[    0.389162] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.390681] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.392523] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.394070] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.395854] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.398301] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.403840] pnp: PnP ACPI: found 7 devices
[    0.405874] ACPI: bus type PNP unregistered
[    0.412973] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.414386] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.415599] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.417931] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.420829] NET: Registered protocol family 2
[    0.422795] TCP established hash table entries: 2048 (order: 3, 32768 bytes)
[    0.424908] TCP bind hash table entries: 2048 (order: 5, 131072 bytes)
[    0.426509] TCP: Hash tables configured (established 2048 bind 2048)
[    0.428117] TCP: reno registered
[    0.428858] UDP hash table entries: 256 (order: 3, 40960 bytes)
[    0.430660] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
[    0.432627] NET: Registered protocol family 1
[    0.435273] RPC: Registered named UNIX socket transport module.
[    0.436794] RPC: Registered udp transport module.
[    0.437656] RPC: Registered tcp transport module.
[    0.438871] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.440565] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.442282] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.443564] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.445194] pci 0000:00:02.0: Boot video device
[    0.446176] PCI: CLS 0 bytes, default 64
[    0.447688] Unpacking initramfs...
[    2.061244] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    2.063616] has_svm: not amd
[    2.064558] kvm: no hardware support
[    2.066230] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    2.069179] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    2.071916] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
[    2.073628] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.073723] cryptomgr_test (24) used greatest stack depth: 6320 bytes left
[    2.076534] sha256_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.078637] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
[    2.079595] AVX or AES-NI instructions are not detected.
[    2.080743] AVX instructions are not detected.
[    2.082062] AVX instructions are not detected.
[    2.083639] AVX instructions are not detected.
[    2.087344] Initializing RT-Tester: OK
[    2.088881] audit: initializing netlink socket (disabled)
[    2.091323] type=2000 audit(1378709047.831:1): initialized
[    2.100404] DLM installed
[    2.104679] NFS: Registering the id_resolver key type
[    2.106429] Key type id_resolver registered
[    2.108561] Key type id_legacy registered
[    2.110488] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.114815] ROMFS MTD (C) 2007 Red Hat, Inc.
[    2.117999] fuse init (API version 7.22)
[    2.121825] ceph: loaded (mds proto 32)
[    2.128801] cryptomgr_test (43) used greatest stack depth: 5696 bytes left
[    2.132371] cryptomgr_test (44) used greatest stack depth: 5392 bytes left
[    2.150373] cryptomgr_test (72) used greatest stack depth: 5280 bytes left
[    2.158445] alg: No test for crc32 (crc32-table)
[    2.159494] alg: No test for lz4hc (lz4hc-generic)
[    2.160569] alg: No test for stdrng (krng)
[    2.161458] NET: Registered protocol family 38
[    2.162210] Key type asymmetric registered
[    2.162989] Asymmetric key parser 'x509' registered
[    2.163908] test_string_helpers: Running tests...
[    2.165453] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    2.166307] crc32: self tests passed, processed 225944 bytes in 283400 nsec
[    2.167822] crc32c: CRC_LE_BITS = 32
[    2.168509] crc32c: self tests passed, processed 225944 bytes in 141779 nsec
[    2.170311] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[    2.171852] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[    2.173980] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    2.176092] vmlfb: initializing
[    2.177052] Could not find Carillo Ranch MCH device.
[    2.178665] no IO addresses supplied
[    2.180057] hgafb: HGA card not detected.
[    2.181128] hgafb: probe of hgafb.0 failed with error -22
[    2.182628] usbcore: registered new interface driver udlfb
[    2.184167] usbcore: registered new interface driver smscufx
[    2.187861] uvesafb: failed to execute /sbin/v86d
[    2.189143] uvesafb: make sure that the v86d helper is installed and executable
[    2.191192] uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
[    2.193505] uvesafb: vbe_init() failed with -22
[    2.195800] uvesafb: probe of uvesafb.0 failed with error -22
[    2.198820] ipmi message handler version 39.2
[    2.200076] ipmi device interface
[    2.201769] IPMI System Interface driver.
[    2.204350] ipmi_si: Adding default-specified kcs state machine
[    2.207696] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    2.211953] ipmi_si: Interface detection failed
[    2.224137] ipmi_si: Adding default-specified smic state machine
[    2.225221] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    2.227245] ipmi_si: Interface detection failed
[    2.240174] ipmi_si: Adding default-specified bt state machine
[    2.241353] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    2.242814] ipmi_si: Interface detection failed
[    2.252330] kobject: 'ipmi_si' (ffff88000779b800): kobject_release, parent ffff8800001b7648 (delayed)
[    2.254145] kobject: 'ipmi_si' (ffff88000779b600): kobject_release, parent ffff880000221248 (delayed)
[    2.256185] kobject: 'ipmi_si' (ffff88000779ba00): kobject_release, parent ffff880000189248 (delayed)
[    2.257861] ipmi_si: Unable to find any System Interface(s)
[    2.258921] IPMI Watchdog: driver initialized
[    2.259666] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    2.261475] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.263026] ACPI: Power Button [PWRF]
[    2.934894] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.959875] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.963055] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
[    2.965169] ac.o: No PCI boards found.
[    2.966094] ac.o: For an ISA board you must supply memory and irq parameters.
[    2.968209] Non-volatile memory driver v1.3
[    2.969102] Linux agpgart interface v0.103
[    2.970494] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    2.971846] kobject: 'drm' (ffff880006da2848): kobject_release, parent ffff880000189648 (delayed)
[    2.973823] kobject: 'drm' (ffff880006d9f000): kobject_release, parent           (null) (delayed)
[    2.975770] [drm] radeon kernel modesetting enabled.
[    2.977682] [drm:drm_proc_init] *ERROR* Cannot create /proc/dri/0
[    2.979129] [drm:drm_get_minor] *ERROR* DRM: Failed to initialize /proc/dri.
[    2.981337] kobject: 'controlD64' (ffff880006da2020): kobject_release, parent           (null) (delayed)
[    2.983384] cirrus: probe of 0000:00:02.0 failed with error -1
[    2.985019] usbcore: registered new interface driver udl
[    2.987222] parport_pc 00:04: reported by Plug and Play ACPI
[    2.988574] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    2.990338] kobject: 'parport_pc.956' (ffff880006da2020): kobject_release, parent           (null) (delayed)
[    2.992654] kobject: 'parport_pc.888' (ffff880006db5820): kobject_release, parent           (null) (delayed)
[    2.994905] kobject: 'parport_pc.632' (ffff880006db5020): kobject_release, parent           (null) (delayed)
[    2.997725] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.999184] dummy-irq: no IRQ given.  Use irq=N
[    3.000293] Phantom Linux Driver, version n0.9.8, init OK
[    3.001658] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    3.003479] c2port c2port0: C2 port uc added
[    3.004449] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
[    3.006338] Guest personality initialized and is inactive
[    3.007900] VMCI host device registered (name=vmci, major=10, minor=56)
[    3.009140] Initialized host personality
[    3.009901] Driver for timberdale has been successfully registered.
[    3.011149] usbcore: registered new interface driver viperboard
[    3.012136] usbcore: registered new interface driver pn533
[    3.013247] mtdoops: mtd device (mtddev=name/number) must be supplied
[    3.014218] device id = 2440
[    3.014675] device id = 2480
[    3.015103] device id = 24c0
[    3.015531] device id = 24d0
[    3.015963] device id = 25a1
[    3.016445] device id = 2670
[    3.017005] platform physmap-flash.0: failed to claim resource 0
[    3.018449] kobject: 'physmap-flash' (ffff880006dce800): kobject_release, parent ffff880000189248 (delayed)
[    3.020395] SBC-GXx flash: IO:0x258-0x259 MEM:0xdc000-0xdffff
[    3.021398] Could not find PAR responsible for SC520CDP Flash Bank #0
[    3.022299] Trying default address 0x8400000
[    3.023029] Could not find PAR responsible for SC520CDP Flash Bank #1
[    3.023968] Trying default address 0x8c00000
[    3.024710] Could not find PAR responsible for SC520CDP DIL Flash
[    3.025602] Trying default address 0x9400000
[    3.026309] SC520 CDP flash device: 0x800000 at 0x8400000
[    3.027133] Failed to ioremap_nocache
[    3.027752] Failed to ioremap_nocache
[    3.028406] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.029443] kobject: 'docg3' (ffff880006dd5c00): kobject_release, parent ffff880000189248 (delayed)
[    3.030930] slram: not enough parameters.
[    3.035384] No valid DiskOnChip devices found
[    3.036301] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.037601] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.039517] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.041445] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.042893] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.044274] [nandsim] warning: read_byte: unexpected data output cycle, state is STATE_READY return 0x0
[    3.045627] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba NAND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    3.047445] flash size: 128 MiB
[    3.047913] page size: 512 bytes
[    3.048433] OOB area size: 16 bytes
[    3.048950] sector size: 16 KiB
[    3.049410] pages number: 262144
[    3.049885] pages per sector: 32
[    3.050357] bus width: 8
[    3.050748] bits in sector size: 14
[    3.051267] bits in page size: 9
[    3.051748] bits in OOB size: 4
[    3.052252] flash size with OOB: 135168 KiB
[    3.052878] page address bytes: 4
[    3.053361] sector address bytes: 3
[    3.053877] options: 0x42
[    3.057732] Scanning device for bad blocks
[    3.064229] tsc: Refined TSC clocksource calibration: 2693.458 MHz
[    3.089949] Creating 1 MTD partitions on "NAND 128MiB 1,8V 8-bit":
[    3.090983] 0x000000000000-0x000008000000 : "NAND simulator partition 0"
[    3.092696] parport0: powerup/reset Butterfly
[    3.209035] parport_pc 00:04: registered master spi42
[    3.211214] parport_pc 00:04: master is unqueued, this is deprecated
[    3.212706] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    3.214606] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    3.216653] parport_pc 00:04: registered child spi42.1
[    3.218803] parport0: dataflash at spi42.1
[    3.220575] parport0: AVR Butterfly
[    3.222255] parport0: cannot grant exclusive access for device spi-lm70llp
[    3.226128] spi-lm70llp: spi_lm70llp probe fail, status -12
[    3.227736] usbcore: registered new interface driver irda-usb
[    3.228643] usbcore: registered new interface driver stir4200
[    3.229992] usbcore: registered new interface driver mcs7780
[    3.232347] usbcore: registered new interface driver kingsun-sir
[    3.234367] usbcore: registered new interface driver ksdazzle-sir
[    3.236437] usbcore: registered new interface driver ks959-sir
[    3.238095] usbcore: registered new interface driver hwa-rc
[    3.239231] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.240255] ohci-pci: OHCI PCI platform driver
[    3.241058] ohci-platform: OHCI generic platform driver
[    3.242052] uhci_hcd: USB Universal Host Controller Interface driver
[    3.243479] driver u132_hcd
[    3.246169] usbcore: registered new interface driver hwa-hc
[    3.247136] fusbh200_hcd: FUSBH200 Host Controller (EHCI) Driver
[    3.248153] Warning! fusbh200_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    3.250017] usbcore: registered new interface driver cdc_wdm
[    3.251006] usbcore: registered new interface driver usbtmc
[    3.252371] usbcore: registered new interface driver appledisplay
[    3.253300] usbcore: registered new interface driver emi26 - firmware loader
[    3.254432] usbcore: registered new interface driver emi62 - firmware loader
[    3.255605] driver ftdi-elan
[    3.257512] usbcore: registered new interface driver ftdi-elan
[    3.259104] usbcore: registered new interface driver idmouse
[    3.260884] usbcore: registered new interface driver usblcd
[    3.262772] usbcore: registered new interface driver ldusb
[    3.263862] usbcore: registered new interface driver usbled
[    3.264750] usbcore: registered new interface driver legousbtower
[    3.265736] usbcore: registered new interface driver rio500
[    3.266784] usbcore: registered new interface driver usbtest
[    3.267743] usbcore: registered new interface driver trancevibrator
[    3.269057] usbcore: registered new interface driver uss720
[    3.270480] uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
[    3.271875] uss720: NOTE: this is a special purpose driver to allow nonstandard
[    3.272992] uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
[    3.274126] uss720: If you just want to connect to a printer, use usblp instead
[    3.275695] usbcore: registered new interface driver yurex
[    3.276628] kobject: 'gpio-vbus' (ffff880006816a00): kobject_release, parent ffff880000189248 (delayed)
[    3.279018] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    3.282120] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.283570] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.285423] parport0: cannot grant exclusive access for device parkbd
[    3.354942] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    3.357306] usbcore: registered new interface driver bcm5974
[    3.357735] kobject: '(null)' (ffff8800068222f0): kobject_release, parent           (null) (delayed)
[    3.360099] usbcore: registered new interface driver synaptics_usb
[    3.362475] usbcore: registered new interface driver iforce
[    3.366628] parport0: cannot grant exclusive access for device walkera0701
[    3.369354] walkera0701: failed to register parport device
[    3.374489] usbcore: registered new interface driver usbtouchscreen
[    3.380096] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    3.383449] usbcore: registered new interface driver ati_remote2
[    3.385766] cm109: Keymap for Komunikate KIP1000 phone loaded
[    3.387346] usbcore: registered new interface driver cm109
[    3.389956] cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
[    3.392541] usbcore: registered new interface driver keyspan_remote
[    3.396639] usbcore: registered new interface driver yealink
[    3.398708] I2O subsystem v1.325
[    3.399663] i2o: max drivers = 8
[    3.400997] I2O Configuration OSM v1.323
[    3.402157] I2O ProcFS OSM v1.316
[    3.403197] kobject: 'proc-osm' (ffff880006833200): kobject_release, parent ffff880006833c48 (delayed)
[    3.406361] kobject: 'mc13xxx-rtc' (ffff88000683c200): kobject_release, parent ffff880000189248 (delayed)
[    3.411962] kobject: 'rtc-msm6242' (ffff88000683c000): kobject_release, parent ffff880000189248 (delayed)
[    3.417786] kobject: 'pcap-rtc' (ffff88000683ee00): kobject_release, parent ffff880000189248 (delayed)
[    3.424472] kobject: 'rtc-rp5c01' (ffff880006840e00): kobject_release, parent ffff880000189248 (delayed)
[    3.429870] rtc rtc0: test: dev (254:0)
[    3.431383] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    3.434436] rtc rtc1: test: dev (254:1)
[    3.435883] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    3.438398] i2c /dev entries driver
[    3.440660] usbcore: registered new interface driver i2c-diolan-u2c
[    3.442997] i2c-parport: adapter type unspecified
[    3.444834] i2c-parport-light: adapter type unspecified
[    3.447503] pps pps0: new PPS source ktimer
[    3.448188] pps pps0: ktimer PPS source registered
[    3.448976] pps_parport: parallel port PPS client
[    3.449879] parport0: cannot grant exclusive access for device pps_parport
[    3.451464] pps_parport: couldn't register with parport0
[    3.452649] Driver for 1-wire Dallas network protocol.
[    3.453644] usbcore: registered new interface driver DS9490R
[    3.454697] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    3.456043] power_supply test_ac: uevent
[    3.456700] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    3.457658] power_supply test_ac: prop ONLINE=1
[    3.458322] power_supply test_ac: power_supply_changed
[    3.459395] power_supply test_ac: power_supply_changed_work
[    3.460443] power_supply test_ac: power_supply_update_gen_leds 1
[    3.460585] power_supply test_battery: uevent
[    3.460588] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    3.460603] power_supply test_battery: prop STATUS=Discharging
[    3.460607] power_supply test_battery: prop CHARGE_TYPE=Fast
[    3.460610] power_supply test_battery: prop HEALTH=Good
[    3.460617] power_supply test_battery: prop PRESENT=1
[    3.460621] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    3.460625] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    3.460628] power_supply test_battery: prop CHARGE_FULL=100
[    3.460632] power_supply test_battery: prop CHARGE_NOW=50
[    3.460635] power_supply test_battery: prop CAPACITY=50
[    3.460639] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    3.460642] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    3.460645] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    3.460649] power_supply test_battery: prop MODEL_NAME=Test battery
[    3.460652] power_supply test_battery: prop MANUFACTURER=Linux
[    3.460656] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    3.460659] power_supply test_battery: prop TEMP=26
[    3.460662] power_supply test_battery: prop VOLTAGE_NOW=3300
[    3.460966] power_supply test_battery: power_supply_changed
[    3.460983] power_supply test_battery: power_supply_changed_work
[    3.460988] power_supply test_battery: power_supply_update_bat_leds 2
[    3.461001] power_supply test_battery: uevent
[    3.461003] power_supply test_battery: POWER_SUPPLY_NAME=test_battery
[    3.461019] power_supply test_battery: prop STATUS=Discharging
[    3.461023] power_supply test_battery: prop CHARGE_TYPE=Fast
[    3.461027] power_supply test_battery: prop HEALTH=Good
[    3.461030] power_supply test_battery: prop PRESENT=1
[    3.461034] power_supply test_battery: prop TECHNOLOGY=Li-ion
[    3.461038] power_supply test_battery: prop CHARGE_FULL_DESIGN=100
[    3.461042] power_supply test_battery: prop CHARGE_FULL=100
[    3.461045] power_supply test_battery: prop CHARGE_NOW=50
[    3.461049] power_supply test_battery: prop CAPACITY=50
[    3.461052] power_supply test_battery: prop CAPACITY_LEVEL=Normal
[    3.461056] power_supply test_battery: prop TIME_TO_EMPTY_AVG=3600
[    3.461060] power_supply test_battery: prop TIME_TO_FULL_NOW=3600
[    3.461063] power_supply test_battery: prop MODEL_NAME=Test battery
[    3.461067] power_supply test_battery: prop MANUFACTURER=Linux
[    3.461074] power_supply test_battery: prop SERIAL_NUMBER=3.11.0-rc2-00010-gc817a67-dirty
[    3.461078] power_supply test_battery: prop TEMP=26
[    3.461082] power_supply test_battery: prop VOLTAGE_NOW=3300
[    3.461138] power_supply test_usb: uevent
[    3.461140] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    3.461148] power_supply test_usb: prop ONLINE=1
[    3.461161] power_supply test_usb: power_supply_changed
[    3.461181] power_supply test_usb: power_supply_changed_work
[    3.461186] power_supply test_usb: power_supply_update_gen_leds 1
[    3.461192] power_supply test_usb: uevent
[    3.461194] power_supply test_usb: POWER_SUPPLY_NAME=test_usb
[    3.461201] power_supply test_usb: prop ONLINE=1
[    3.462100] applesmc: supported laptop not found!
[    3.462102] applesmc: driver init failed (ret=-19)!
[    3.462550] f71882fg: Not a Fintek device
[    3.462641] f71882fg: Not a Fintek device
[    3.463541] kobject: 'mc13783-adc' (ffff880006884200): kobject_release, parent ffff880000189248 (delayed)
[    3.463859] pc87360: PC8736x not detected, module not inserted
[    3.464817] cpuidle: using governor ladder
[    3.464820] cpuidle: using governor menu
[    3.464840] sdhci: Secure Digital Host Controller Interface driver
[    3.464841] sdhci: Copyright(c) Pierre Ossman
[    3.541445] power_supply test_ac: uevent
[    3.542567] power_supply test_ac: POWER_SUPPLY_NAME=test_ac
[    3.544572] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    3.544573] usbcore: registered new interface driver vub300
[    3.546666] power_supply test_ac: prop ONLINE=1
[    3.547909] usbcore: registered new interface driver ushc
[    3.548963] sdhci-pltfm: SDHCI platform and OF driver helper
[    3.551027] ledtrig-cpu: registered to indicate activity on CPUs
[    3.553713] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    3.558955] usbcore: registered new interface driver usbhid
[    3.562063] usbhid: USB HID core driver
[    3.563823] usbip_core: usbip_core_init:804: USB/IP Core v1.0.0
[    3.566228] vhci_hcd: vhci_hcd_probe:1000: name vhci_hcd id -1
[    3.568100] vhci_hcd vhci_hcd: USB/IP Virtual Host Controller
[    3.569529] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 1
[    3.570944] vhci_hcd: vhci_start:884: enter vhci_start
[    3.574085] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.575520] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.576877] usb usb1: Product: USB/IP Virtual Host Controller
[    3.577977] usb usb1: Manufacturer: Linux 3.11.0-rc2-00010-gc817a67-dirty vhci_hcd
[    3.579961] usb usb1: SerialNumber: vhci_hcd
[    3.581647] hub 1-0:1.0: USB hub found
[    3.582571] vhci_hcd: vhci_hub_control:247: typeReq a006 wValue 2900 wIndex 0
[    3.583775] vhci_hcd: vhci_hub_control:305:  GetHubDescriptor
[    3.584769] vhci_hcd: vhci_hub_control:398: port -1
[    3.585532] vhci_hcd: vhci_hub_control:405:  bye
[    3.586238] hub 1-0:1.0: 8 ports detected
[    3.586960] vhci_hcd: vhci_hub_control:247: typeReq a000 wValue 0 wIndex 0
[    3.588544] vhci_hcd: vhci_hub_control:309:  GetHubStatus
[    3.589404] vhci_hcd: vhci_hub_control:398: port -1
[    3.590169] vhci_hcd: vhci_hub_control:405:  bye
[    3.591348] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 1
[    3.592480] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.593429] vhci_hcd: vhci_hub_control:398: port 0
[    3.594126] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.595405] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.596226] vhci_hcd: dump_port_status_diff:119:
[    3.597347] vhci_hcd: vhci_hub_control:405:  bye
[    3.599116] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 2
[    3.600978] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.602761] vhci_hcd: vhci_hub_control:398: port 1
[    3.604128] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.606289] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.607678] vhci_hcd: dump_port_status_diff:119:
[    3.608407] vhci_hcd: vhci_hub_control:405:  bye
[    3.609130] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 3
[    3.610526] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.612230] vhci_hcd: vhci_hub_control:398: port 2
[    3.613466] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.615735] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.618733] vhci_hcd: dump_port_status_diff:119:
[    3.621268] vhci_hcd: vhci_hub_control:405:  bye
[    3.622937] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 4
[    3.624399] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.625882] vhci_hcd: vhci_hub_control:398: port 3
[    3.627133] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.629159] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.630399] vhci_hcd: dump_port_status_diff:119:
[    3.631547] vhci_hcd: vhci_hub_control:405:  bye
[    3.632710] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 5
[    3.634427] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.635963] vhci_hcd: vhci_hub_control:398: port 4
[    3.636962] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.638226] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.639149] vhci_hcd: dump_port_status_diff:119:
[    3.639885] vhci_hcd: vhci_hub_control:405:  bye
[    3.641202] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 6
[    3.643025] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.644696] vhci_hcd: vhci_hub_control:398: port 5
[    3.645857] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.647915] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.649221] vhci_hcd: dump_port_status_diff:119:
[    3.650314] vhci_hcd: vhci_hub_control:405:  bye
[    3.651430] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 7
[    3.652836] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.654063] vhci_hcd: vhci_hub_control:398: port 6
[    3.654801] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.656223] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.657546] vhci_hcd: dump_port_status_diff:119:
[    3.658672] vhci_hcd: vhci_hub_control:405:  bye
[    3.659749] vhci_hcd: vhci_hub_control:247: typeReq 2303 wValue 8 wIndex 8
[    3.661571] vhci_hcd: vhci_hub_control:384:  SetPortFeature: default 8
[    3.663592] vhci_hcd: vhci_hub_control:398: port 7
[    3.664994] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000000 -> 00000100
[    3.666951] vhci_hcd: dump_port_status_diff:115:  +POWER
[    3.668262] vhci_hcd: dump_port_status_diff:119:
[    3.669336] vhci_hcd: vhci_hub_control:405:  bye
[    3.670815] vhci_hcd: vhci_hcd_probe:1034: bye
[    3.671781] vhci_hcd: vhci_hcd_init:1156: USB/IP 'Virtual' Host Controller (VHCI) Driver v1.0.0
[    3.674357] usbcore: registered new interface driver usbip-host
[    3.676660] usbip_host: usbip_host_init:270: USB/IP Host Driver v1.0.0
[    3.679669] usbcore: registered new interface driver tranzport
[    3.682372] usbcore: registered new interface driver alphatrack
[    3.683842] vme_user: VME User Space Access Driver
[    3.685207] vme_user: No cards, skipping registration
[    3.688037] Loading crystalhd 0.9.27
[    3.689701] usbcore: registered new interface driver ft1000usb
[    3.690980] usbcore: registered new interface driver gdm_wimax
[    3.691864] usbcore: registered new interface driver cedusb
[    3.693740] ipip: IPv4 over IPv4 tunneling driver
[    3.695279] gre: GRE over IPv4 demultiplexor driver
[    3.696489] IPv4 over IPSec tunneling driver
[    3.699102] TCP: cubic registered
[    3.700148] NET: Registered protocol family 17
[    3.703081] NET: Registered protocol family 9
[    3.704456] X.25 for Linux Version 0.2
[    3.711736] NET: Registered protocol family 33
[    3.713002] Key type rxrpc registered
[    3.714029] Key type rxrpc_s registered
[    3.716366] RxRPC: Registered security type 2 'rxkad'
[    3.717419] l2tp_core: L2TP core driver, V2.0
[    3.718251] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    3.719974] DECnet: Routing cache hash table of 256 buckets, 16Kbytes
[    3.720911] NET: Registered protocol family 12
[    3.732457] 8021q: 802.1Q VLAN Support v1.8
[    3.733993] sctp: Hash tables configured (established 1024 bind 1024)
[    3.736198] rds_page_remainder_cpu_notify(): cpu 0 action 0x7
[    3.737224] rds_page_remainder_cpu_notify(): cpu 1 action 0x7
[    3.738418] NET: Registered protocol family 37
[    3.739830] NET: Registered protocol family 36
[    3.740991] Key type dns_resolver registered
[    3.742139] Key type ceph registered
[    3.743101] libceph: loaded (mon/osd proto 15/24)
[    3.744149] mpls_gso: MPLS GSO support
[    3.745366]
[    3.745366] printing PIC contents
[    3.746335] ... PIC  IMR: ffff
[    3.747513] ... PIC  IRR: 1013
[    3.748313] ... PIC  ISR: 0000
[    3.749409] ... PIC ELCR: 0c00
[    3.750677] printing local APIC contents on CPU#0/0:
[    3.752349] ... APIC ID:      00000000 (0)
[    3.753295] ... APIC VERSION: 00050014
[    3.754263] ... APIC TASKPRI: 00000000 (00)
[    3.754663] ... APIC PROCPRI: 00000000
[    3.754663] ... APIC LDR: 01000000
[    3.754663] ... APIC DFR: ffffffff
[    3.754663] ... APIC SPIV: 000001ff
[    3.754663] ... APIC ISR field:
[    3.754663] 0000000000000000000000000000000000000000000000000000000000000000
[    3.754663] ... APIC TMR field:
[    3.754663] 0000000000000000000000000000000000000000000000000000000000000000
[    3.754663] ... APIC IRR field:
[    3.754663] 0000000000000000000000000000000000000000000000000000000000008000
[    3.754663] ... APIC ESR: 00000000
[    3.754663] ... APIC ICR: 000008fd
[    3.754663] ... APIC ICR2: 02000000
[    3.754663] ... APIC LVTT: 000000ef
[    3.754663] ... APIC LVTPC: 00010000
[    3.754663] ... APIC LVT0: 00010700
[    3.754663] ... APIC LVT1: 00000400
[    3.754663] ... APIC LVTERR: 000000fe
[    3.754663] ... APIC TMICT: 0003c2bd
[    3.754663] ... APIC TMCCT: 00000000
[    3.754663] ... APIC TDCR: 00000003
[    3.754663]
[    3.789223] number of MP IRQ sources: 15.
[    3.790722] number of IO-APIC #0 registers: 24.
[    3.791794] testing the IO APIC.......................
[    3.793155] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 1
[    3.794344] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 1
[    3.795773] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.798209] vhci_hcd: vhci_hub_control:398: port 0
[    3.798586] IO APIC #0......
[    3.798588] .... register #00: 00000000
[    3.798588] .......    : physical APIC id: 00
[    3.798589] .......    : Delivery Type: 0
[    3.798603] .......    : LTS          : 0
[    3.798605] .... register #01: 00170011
[    3.798606] .......     : max redirection entries: 17
[    3.798607] .......     : PRQ implemented: 0
[    3.798608] .......     : IO APIC version: 11
[    3.798609] .... register #02: 00000000
[    3.798610] .......     : arbitration: 00
[    3.798610] .... IRQ redirection table:
[    3.798631] 1    0    0   0   0    0    0    00
[    3.798648] 0    0    0   0   0    1    1    31
[    3.798665] 0    0    0   0   0    1    1    30
[    3.798681] 0    0    0   0   0    1    1    33
[    3.798698] 1    0    0   0   0    1    1    34
[    3.798714] 1    1    0   0   0    1    1    35
[    3.798730] 0    0    0   0   0    1    1    36
[    3.798747] 0    0    0   0   0    1    1    37
[    3.798764] 0    0    0   0   0    1    1    38
[    3.798780] 0    1    0   0   0    1    1    39
[    3.798796] 1    1    0   0   0    1    1    3A
[    3.798813] 1    1    0   0   0    1    1    3B
[    3.798829] 0    0    0   0   0    1    1    3C
[    3.798846] 0    0    0   0   0    1    1    3D
[    3.798862] 0    0    0   0   0    1    1    3E
[    3.798880] 0    0    0   0   0    1    1    3F
[    3.798897] 1    0    0   0   0    0    0    00
[    3.798908] 1    0    0   0   0    0    0    00
[    3.798924] 1    0    0   0   0    0    0    00
[    3.798941] 1    0    0   0   0    0    0    00
[    3.798957] 1    0    0   0   0    0    0    00
[    3.798973] 1    0    0   0   0    0    0    00
[    3.798990] 1    0    0   0   0    0    0    00
[    3.799006] 1    0    0   0   0    0    0    00
[    3.799007] IRQ to pin mappings:
[    3.799012] IRQ0 -> 0:2
[    3.799014] IRQ1 -> 0:1
[    3.799017] IRQ3 -> 0:3
[    3.799020] IRQ4 -> 0:4
[    3.799022] IRQ5 -> 0:5
[    3.799024] IRQ6 -> 0:6
[    3.799027] IRQ7 -> 0:7
[    3.799029] IRQ8 -> 0:8
[    3.799036] IRQ9 -> 0:9
[    3.799039] IRQ10 -> 0:10
[    3.799041] IRQ11 -> 0:11
[    3.799043] IRQ12 -> 0:12
[    3.799046] IRQ13 -> 0:13
[    3.799051] IRQ14 -> 0:14
[    3.799054] IRQ15 -> 0:15
[    3.799055] .................................... done.
[    3.860110] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.860754] registered taskstats version 1
[    3.866974] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.869047] rtc-test rtc-test.0: setting system clock to 2013-09-09 06:44:09 UTC (1378709049)
[    3.869104] vhci_hcd: dump_port_status_diff:119:
[    3.869106] vhci_hcd: vhci_hub_control:405:  bye
[    3.869146] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 2
[    3.869148] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 2
[    3.869150] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.869151] vhci_hcd: vhci_hub_control:398: port 1
[    3.869152] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.869154] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.869155] vhci_hcd: dump_port_status_diff:119:
[    3.869156] vhci_hcd: vhci_hub_control:405:  bye
[    3.869161] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 3
[    3.869162] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 3
[    3.869163] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.869163] vhci_hcd: vhci_hub_control:398: port 2
[    3.869165] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.869165] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.869166] vhci_hcd: dump_port_status_diff:119:
[    3.869167] vhci_hcd: vhci_hub_control:405:  bye
[    3.869172] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 4
[    3.869173] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 4
[    3.869173] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.869174] vhci_hcd: vhci_hub_control:398: port 3
[    3.869175] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.869185] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.869186] vhci_hcd: dump_port_status_diff:119:
[    3.869187] vhci_hcd: vhci_hub_control:405:  bye
[    3.869192] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 5
[    3.869193] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 5
[    3.869194] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.869195] vhci_hcd: vhci_hub_control:398: port 4
[    3.869196] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.869197] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.869198] vhci_hcd: dump_port_status_diff:119:
[    3.869198] vhci_hcd: vhci_hub_control:405:  bye
[    3.869203] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 6
[    3.869204] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 6
[    3.869205] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.869205] vhci_hcd: vhci_hub_control:398: port 5
[    3.869206] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.869207] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.869208] vhci_hcd: dump_port_status_diff:119:
[    3.869209] vhci_hcd: vhci_hub_control:405:  bye
[    3.869213] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 7
[    3.869214] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 7
[    3.869215] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.869216] vhci_hcd: vhci_hub_control:398: port 6
[    3.869217] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.869217] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.869218] vhci_hcd: dump_port_status_diff:119:
[    3.869219] vhci_hcd: vhci_hub_control:405:  bye
[    3.869224] vhci_hcd: vhci_hub_control:247: typeReq a300 wValue 0 wIndex 8
[    3.869225] vhci_hcd: vhci_hub_control:313:  GetPortStatus port 8
[    3.869225] vhci_hcd: vhci_hub_control:355:  GetPortStatus bye 100 0
[    3.869226] vhci_hcd: vhci_hub_control:398: port 7
[    3.869227] vhci_hcd: dump_port_status_diff:101: status prev -> new: 00000100 -> 00000100
[    3.869228] vhci_hcd: dump_port_status_diff:115:   POWER
[    3.869229] vhci_hcd: dump_port_status_diff:119:
[    3.869230] vhci_hcd: vhci_hub_control:405:  bye
[    3.869544] usb usb1: vhci_bus_suspend
[    3.869553] vhci_hcd: vhci_hub_status:208: changed 0
[    3.975920] debug: unmapping init [mem 0xffffffff81dfc000-0xffffffff81ecefff]
[    3.992074] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[    3.994126] IP: [<ffffffff81098f60>] run_timer_softirq+0x126/0x1da
[    3.995677] PGD 0
[    3.996037] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[    3.996037] CPU: 1 PID: 1 Comm: init Not tainted 3.11.0-rc2-00010-gc817a67-dirty #5
[    3.996037] task: ffff88000010a040 ti: ffff88000010c000 task.ti: ffff88000010c000
[    3.996037] RIP: 0010:[<ffffffff81098f60>]  [<ffffffff81098f60>] run_timer_softirq+0x126/0x1da
[    3.996037] RSP: 0000:ffff88000dd03ea8  EFLAGS: 00010002
[    3.996037] RAX: ffff880006da20a0 RBX: ffff88000015c000 RCX: ffff88000dd03ec8
[    3.996037] RDX: ffff880006da2060 RSI: ffffffff810a1b7b RDI: 0000000000000000
[    3.996037] RBP: ffff88000dd03f08 R08: 0000000000000002 R09: dead000000200200
[    3.996037] R10: ffff88000015c018 R11: 0000000000000000 R12: ffff88000dd03ec8
[    3.996037] R13: ffff88000015d858 R14: ffff88000015d458 R15: ffff88000015d058
[    3.996037] FS:  00007f0f12067700(0000) GS:ffff88000dd00000(0000) knlGS:0000000000000000
[    3.996037] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    3.996037] CR2: 0000000000000008 CR3: 0000000006970000 CR4: 00000000000006a0
[    3.996037] Stack:
[    3.996037]  ffff88000dd03ee8 ffff88000010a040 ffffffff81095529 000000ef122a4ec0
[    3.996037]  ffff880006da20a0 ffff880006db58a0 ffff88000dd03ef8 ffff88000010dfd8
[    3.996037]  ffffffff81c43088 0000000000000100 0000000000000101 0000000000000001
[    3.996037] Call Trace:
[    3.996037]  <IRQ>
[    3.996037]  [<ffffffff81095529>] ? __do_softirq+0x90/0x18f
[    3.996037]  [<ffffffff8109555f>] __do_softirq+0xc6/0x18f
[    3.996037]  [<ffffffff81095745>] irq_exit+0x58/0x9e
[    3.996037]  [<ffffffff81044e69>] smp_apic_timer_interrupt+0x31/0x3e
[    3.996037]  [<ffffffff8185a772>] apic_timer_interrupt+0x72/0x80
[    3.996037]  <EOI>
[    3.996037]  [<ffffffff8185925c>] ? retint_swapgs+0x13/0x1b
[    3.996037] Code: 08 e9 99 00 00 00 4c 8b 40 18 48 8b 70 20 49 b9 00 02 20 00 00 00 ad de 48 8b 50 28 48 89 43 38 48 8b 38 48 8b 48 08 41 83 e0 02 <48> 89 4f 08 48 89 39 f6 40 18 01 48 c7 00 00 00 00 00 4c 89 48
[    4.048086] RIP  [<ffffffff81098f60>] run_timer_softirq+0x126/0x1da
[    4.048086]  RSP <ffff88000dd03ea8>
[    4.048086] CR2: 0000000000000008
[    4.048086] ---[ end trace 9f1828b51c6366fa ]---
[    4.048086] Kernel panic - not syncing: Fatal exception in interrupt
[    4.048086] Rebooting in 10 seconds..%                                                                                                  wfg@bee ~/linux/obj-compiletest%
