Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935402Ab3DHL44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:56:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45046 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935214Ab3DHL4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:56:48 -0400
Date: Mon, 8 Apr 2013 13:55:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Dave Hansen <dave@sr71.net>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, dhillf@gmail.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: kernel BUG at kernel/smpboot.c:134!
Message-ID: <20130408115553.GA4395@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Dave Hansen <dave@sr71.net>, LKML <linux-kernel@vger.kernel.org>,
	Dave Jones <davej@redhat.com>, dhillf@gmail.com,
	Peter Zijlstra <peterz@infradead.org>
References: <515F457E.5050505@sr71.net>
 <515FCAC6.8090806@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1304061019000.21884@ionos>
 <alpine.LFD.2.02.1304071119100.21884@ionos>
 <20130407095025.GA31307@pd.tnic>
 <alpine.LFD.2.02.1304081122040.21884@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1304081122040.21884@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 11:24:14AM +0200, Thomas Gleixner wrote:
> On Sun, 7 Apr 2013, Borislav Petkov wrote:
> 
> > On Sun, Apr 07, 2013 at 11:20:10AM +0200, Thomas Gleixner wrote:
> > > And it's even more bogus because the cpu to which we would bind in
> > > kthread_create_on_cpu() is not yet online.
> > 
> > In case you guys are wondering about reproducibility, I saw the same
> > BUG_ON yesterday on a 32-bit atom smp qemu guest too (don't ask why?
> > :-))
> 
> I don't have to ask.

Yeah, I actually meant "Don't ask why I'm testing 32-bit atom smp qemu
guests." :-)

> ---
> Index: linux-2.6/kernel/kthread.c
> ===================================================================
> --- linux-2.6.orig/kernel/kthread.c
> +++ linux-2.6/kernel/kthread.c
> @@ -131,8 +131,14 @@ static void __kthread_parkme(struct kthr
>  		schedule();
>  		__set_current_state(TASK_INTERRUPTIBLE);
>  	}
> -	clear_bit(KTHREAD_IS_PARKED, &self->flags);
>  	__set_current_state(TASK_RUNNING);
> +	clear_bit(KTHREAD_IS_PARKED, &self->flags);
> +
> +	/* Rebind ourself to the target cpu */
> +	if (test_bit(KTHREAD_IS_PER_CPU, &self->flags)) {
> +		set_cpus_allowed_ptr(currrent, cpumask_of(self->cpu));

"currrent" is a typo, I fixed it up to the obvious "current" so that it
builds.

> +		current->flags |= PF_THREAD_BOUND;
> +	}
>  }
>  
>  void kthread_parkme(void)
> @@ -344,11 +350,8 @@ void kthread_unpark(struct task_struct *
>  		 * park before that happens we'd see the IS_PARKED bit
>  		 * which might be about to be cleared.
>  		 */
> -		if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags)) {
> -			if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
> -				__kthread_bind(k, kthread->cpu);
> +		if (test_and_clear_bit(KTHREAD_IS_PARKED, &kthread->flags))
>  			wake_up_process(k);
> -		}
>  	}
>  	put_task_struct(k);

However, it needs more love, see below.

The thing is, I had to do a couple of runs to actually trigger it again
which means, it does not fire *always*. It seems that increasing the
core count for the qemu guest increases the hit rate. Anyway, this is
the whole qemu command:

$ qemu-system-i386 -gdb tcp::1234 -cpu n270,+movbe -hda /home/boris/kvm/debian/sid-i386.img -name "Debian i386:1235" -boot menu=off,order=c -m 2048 -localtime -net nic -net user,hostfwd=tcp::1235-:22 -usbdevice tablet -kernel /w/kernel/linux-2.6/arch/x86/boot/bzImage -append "root=/dev/sda1 debug ignore_loglevel console=ttyS0,115200 console=tty0" -serial file:/home/boris/kvm/test-i386.log -snapshot -smp 4

and it needs a patched qemu with MOVBE support.

Yep, 4 cores on a single-core atom N270. This doesn't really exist as a
hw platform but it seems to boot. With your patch applied, I get:

[    0.000000] Linux version 3.9.0-rc5+ (boris@pd) (gcc version 4.7.2 (Debian 4.7.2-5) ) #5 SMP PREEMPT Mon Apr 8 13:46:14 CEST 2013
[    0.000000] Atom PSE erratum detected, BIOS microcode update recommended
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fffe000-0x000000007fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x7fffe max_arch_pfn = 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 080000000 mask 080000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37000000-0x373fffff]
[    0.000000]  [mem 0x37000000-0x373fffff] page 4k
[    0.000000] BRK [0x020b3000, 0x020b3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x30000000-0x36ffffff]
[    0.000000]  [mem 0x30000000-0x36ffffff] page 4k
[    0.000000] BRK [0x020b4000, 0x020b4fff] PGTABLE
[    0.000000] BRK [0x020b5000, 0x020b5fff] PGTABLE
[    0.000000] BRK [0x020b6000, 0x020b6fff] PGTABLE
[    0.000000] BRK [0x020b7000, 0x020b7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x2fffffff]
[    0.000000]  [mem 0x00100000-0x2fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37400000-0x377fdfff]
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] ACPI: RSDP 000fd8d0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 7fffe380 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 7fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 7fffe3c0 011A9 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 7fffff40 00040
[    0.000000] ACPI: SSDT 7ffff6e0 00858 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 7ffff5b0 00090 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 7ffff570 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1160MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0x7fffdfff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x7fffdfff]
[    0.000000] On node 0 totalpages: 524188
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 223230 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2320 pages used for memmap
[    0.000000]   HighMem zone: 296960 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0 already used, trying 4
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
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x80000000-0xfffbffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 334 pages/cpu @f6178000 s1343936 r0 d24128 u1368064
[    0.000000] pcpu-alloc: s1343936 r0 d24128 u1368064 alloc=334*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 522412
[    0.000000] Kernel command line: root=/dev/sda1 debug ignore_loglevel console=ttyS0,115200 console=tty0
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0007fffe)
[    0.000000] Memory: 2056060k/2097144k available (5202k kernel code, 40692k reserved, 2447k data, 1756k init, 1187840k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff17000 - 0xfffff000   ( 928 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc1779000 - 0xc1930000   (1756 kB)
[    0.000000]       .data : 0xc1514bfa - 0xc1778940   (2447 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1514bfa   (5202 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:2304 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f5c08000 soft=f5c0a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: Unable to calibrate against PIT
[    0.000000] tsc: using HPET reference calibration
[    0.000000] tsc: Detected 4013.467 MHz processor
[    0.016000] Calibrating delay loop (skipped), value calculated using timer frequency.. 8026.93 BogoMIPS (lpj=4013467)
[    0.019168] pid_max: default: 32768 minimum: 301
[    0.031115] Mount-cache hash table entries: 512
[    0.108223] Atom PSE erratum detected, BIOS microcode update recommended
[    0.116305] mce: CPU supports 10 MCE banks
[    0.127569] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.127569] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.127569] tlb_flushall_shift: 6
[    0.142361] Freeing SMP alternatives: 20k freed
[    0.152465] ACPI: Core revision 20130117
[    0.406397] ACPI: All ACPI Tables successfully acquired
[    0.419468] ftrace: allocating 19508 entries in 39 pages
[    0.810447] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.841000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.852146] smpboot: CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz (fam: 06, model: 1c, stepping: 02)
[    0.862000] APIC calibration not consistent with PM-Timer: 111ms instead of 100ms
[    0.862000] APIC delta adjusted to PM-Timer: 6249993 (6937930)
[    0.868380] Performance Events: unsupported p6 CPU model 28 no PMU driver, software events only.
[    0.932068] SMP alternatives: lockdep: fixing up alternatives
[    0.933327] CPU 1 irqstacks, hard=f5cf4000 soft=f5cf6000
[    0.934073] smpboot: Booting Node   0, Processors  #1[    0.016000] Initializing CPU#1
[    0.016000] Atom PSE erratum detected, BIOS microcode update recommended

[    1.156192] SMP alternatives: lockdep: fixing up alternatives
[    1.161141] CPU 2 irqstacks, hard=f5d08000 soft=f5d0a000
[    1.162733]  #2[    0.016000] Initializing CPU#2
[    0.016000] Atom PSE erratum detected, BIOS microcode update recommended
[    0.016000] calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.
[    0.016000] Probably due to long platform interrupts. Consider using "lpj=" boot option.

[    1.522125] SMP alternatives: lockdep: fixing up alternatives
[    1.525834] CPU 3 irqstacks, hard=f5d28000 soft=f5d2a000
[    1.527101]  #3 OK
[    0.016000] Initializing CPU#3
[    0.016000] Atom PSE erratum detected, BIOS microcode update recommended
[    0.016000] calibrate_delay_direct() failed to get a good estimate for loops_per_jiffy.
[    0.016000] Probably due to long platform interrupts. Consider using "lpj=" boot option.
[    1.635184] Brought up 4 CPUs
[    1.636126] smpboot: Total of 4 processors activated (28540.37 BogoMIPS)
[    1.639142] ------------[ cut here ]------------
[    1.640000] WARNING: at kernel/sched/core.c:963 set_task_cpu+0x12c/0x280()
[    1.640000] Hardware name: Bochs
[    1.640000] Modules linked in:
[    1.640000] Pid: 8, comm: migration/0 Not tainted 3.9.0-rc5+ #5
[    1.640000] Call Trace:
[    1.640000]  [<c1035633>] warn_slowpath_common+0x73/0xb0
[    1.640000]  [<c106a6cc>] ? set_task_cpu+0x12c/0x280
[    1.640000]  [<c106a6cc>] ? set_task_cpu+0x12c/0x280
[    1.640000]  [<c1035693>] warn_slowpath_null+0x23/0x30
[    1.640000]  [<c106a6cc>] set_task_cpu+0x12c/0x280
[    1.640000]  [<c1068e2b>] ? update_rq_clock+0x3b/0x70
[    1.640000]  [<c1068ee1>] ? dequeue_task+0x81/0xc0
[    1.640000]  [<c106a922>] __migrate_task+0x102/0x140
[    1.640000]  [<c106a960>] ? __migrate_task+0x140/0x140
[    1.640000]  [<c106a982>] migration_cpu_stop+0x22/0x30
[    1.640000]  [<c10a0a88>] cpu_stopper_thread+0x68/0x130
[    1.640000]  [<c106ea11>] ? sched_clock_cpu+0xf1/0x180
[    1.640000]  [<c106a20d>] ? sub_preempt_count+0x4d/0xb0
[    1.640000]  [<c106eaee>] ? local_clock+0x4e/0x60
[    1.640000]  [<c108cf4a>] ? trace_hardirqs_off_caller+0x1a/0x110
[    1.640000]  [<c108d22d>] ? put_lock_stats.isra.17+0xd/0x30
[    1.640000]  [<c1512b25>] ? _raw_spin_unlock_irqrestore+0x55/0x70
[    1.640000]  [<c1512b0b>] ? _raw_spin_unlock_irqrestore+0x3b/0x70
[    1.640000]  [<c1063f06>] smpboot_thread_fn+0x176/0x260
[    1.640000]  [<c1063d90>] ? lg_lock_init+0x20/0x20
[    1.640000]  [<c105b305>] kthread+0x95/0xa0
[    1.640000]  [<c1510303>] ? schedule_hrtimeout_range_clock+0x163/0x170
[    1.640000]  [<c151077f>] ? wait_for_common+0xcf/0x110
[    1.640000]  [<c1060000>] ? hrtimer_run_pending+0x110/0x110
[    1.640000]  [<c15137b7>] ret_from_kernel_thread+0x1b/0x28
[    1.640000]  [<c105b270>] ? __kthread_parkme+0xa0/0xa0
[    1.640000] 
[    1.640000] =================================
[    1.640000] [ INFO: inconsistent lock state ]
[    1.640000] 3.9.0-rc5+ #5 Not tainted
[    1.640000] ---------------------------------
[    1.640000] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[    1.640000] migration/0/8 [HC0[0]:SC0[0]:HE1:SE1] takes:
[    1.640000]  (&p->pi_lock){?.-...}, at: [<c106a86e>] __migrate_task+0x4e/0x140
[    1.640000] {IN-HARDIRQ-W} state was registered at:
[    1.640000]   [<c109123d>] __lock_acquire+0x77d/0x1910
[    1.640000]   [<c10929c3>] lock_acquire+0x83/0x1b0
[    1.640000]   [<c15121f5>] _raw_spin_lock_irqsave+0x55/0x90
[    1.640000]   [<c106c635>] try_to_wake_up+0x25/0x270
[    1.640000]   [<c106c8bf>] wake_up_process+0x1f/0x40
[    1.640000]   [<c105e7ed>] hrtimer_wakeup+0x1d/0x30
[    1.640000]   [<c105ebfd>] __run_hrtimer+0x7d/0x3c0
[    1.640000]   [<c1060077>] hrtimer_run_queues+0x77/0x170
[    1.640000]   [<c104787d>] run_local_timers+0xd/0x20
[    1.640000]   [<c10478c3>] update_process_times+0x33/0x70
[    1.640000]   [<c108911a>] tick_periodic+0x2a/0x80
[    1.640000]   [<c10891ee>] tick_handle_periodic+0x1e/0x80
[    1.640000]   [<c1513e95>] smp_apic_timer_interrupt+0x55/0x87
[    1.640000]   [<c1513352>] apic_timer_interrupt+0x32/0x38
[    1.640000]   [<c103e6f6>] irq_exit+0x86/0xa0
[    1.640000]   [<c1513e9a>] smp_apic_timer_interrupt+0x5a/0x87
[    1.640000]   [<c1513352>] apic_timer_interrupt+0x32/0x38
[    1.640000]   [<c105f686>] __hrtimer_start_range_ns+0x1b6/0x560
[    1.640000]   [<c105fa87>] hrtimer_start_range_ns+0x27/0x30
[    1.640000]   [<c1510251>] schedule_hrtimeout_range_clock+0xb1/0x170
[    1.640000]   [<c1510328>] schedule_hrtimeout_range+0x18/0x20
[    1.640000]   [<c1510341>] schedule_hrtimeout+0x11/0x20
[    1.640000]   [<c106ab40>] wait_task_inactive+0x1b0/0x1d0
[    1.640000]   [<c105b620>] kthread_bind+0x20/0x70
[    1.640000]   [<c10530d3>] create_worker+0x1d3/0x200
[    1.640000]   [<c17892be>] init_workqueues+0x235/0x401
[    1.640000]   [<c1000202>] do_one_initcall+0x112/0x160
[    1.640000]   [<c17799e7>] kernel_init_freeable+0x58/0x184
[    1.640000]   [<c14fd0e1>] kernel_init+0x11/0xe0
[    1.640000]   [<c15137b7>] ret_from_kernel_thread+0x1b/0x28
[    1.640000] irq event stamp: 410
[    1.640000] hardirqs last  enabled at (409): [<c1512b67>] _raw_spin_unlock_irq+0x27/0x50
[    1.640000] hardirqs last disabled at (410): [<c106a971>] migration_cpu_stop+0x11/0x30
[    1.640000] softirqs last  enabled at (394): [<c103e3a6>] __do_softirq+0x136/0x340
[    1.640000] softirqs last disabled at (389): [<c103e6f6>] irq_exit+0x86/0xa0
[    1.640000] 
[    1.640000] other info that might help us debug this:
[    1.640000]  Possible unsafe locking scenario:
[    1.640000] 
[    1.640000]        CPU0
[    1.640000]        ----
[    1.640000]   lock(&p->pi_lock);
[    1.640000]   <Interrupt>
[    1.640000]     lock(&p->pi_lock);
[    1.640000] 
[    1.640000]  *** DEADLOCK ***
[    1.640000] 
[    1.640000] 4 locks held by migration/0/8:
[    1.640000]  #0:  (&p->pi_lock){?.-...}, at: [<c106a86e>] __migrate_task+0x4e/0x140
[    1.640000]  #1:  (&rq->lock){-.-...}, at: [<c106a8d7>] __migrate_task+0xb7/0x140
[    1.640000]  #2:  (&rq->lock/1){......}, at: [<c106a8e3>] __migrate_task+0xc3/0x140
[    1.640000]  #3:  (nonblocking_pool.lock){......}, at: [<c12fd41b>] extract_buf+0x3b/0x140
[    1.640000] 
[    1.640000] stack backtrace:
[    1.640000] Pid: 8, comm: migration/0 Not tainted 3.9.0-rc5+ #5
[    1.640000] Call Trace:
[    1.640000]  [<c150b5c4>] print_usage_bug.part.34+0x239/0x242
[    1.640000]  [<c108ee53>] mark_lock+0x4e3/0x5f0
[    1.640000]  [<c106eaee>] ? local_clock+0x4e/0x60
[    1.640000]  [<c108ded0>] ? print_shortest_lock_dependencies+0x1c0/0x1c0
[    1.640000]  [<c108efd5>] mark_held_locks+0x75/0xe0
[    1.640000]  [<c1001dd5>] ? math_state_restore+0x85/0x160
[    1.640000]  [<c1002b00>] ? do_spurious_interrupt_bug+0x40/0x40
[    1.640000]  [<c108f0de>] trace_hardirqs_on_caller+0x9e/0x1b0
[    1.640000]  [<c108f1fc>] trace_hardirqs_on+0xc/0x10
[    1.640000]  [<c1001dd5>] math_state_restore+0x85/0x160
[    1.640000]  [<c1002b00>] ? do_spurious_interrupt_bug+0x40/0x40
[    1.640000]  [<c1002b15>] do_device_not_available+0x15/0x30
[    1.640000]  [<c1513593>] error_code+0x5f/0x64
[    1.640000]  [<c1002b00>] ? do_spurious_interrupt_bug+0x40/0x40
[    1.640000]  [<c14fbee3>] ? sha_transform+0x33/0x1090
[    1.640000]  [<c12fd41b>] ? extract_buf+0x3b/0x140
[    1.640000]  [<c12fd443>] extract_buf+0x63/0x140
[    1.640000]  [<c1512b01>] ? _raw_spin_unlock_irqrestore+0x31/0x70
[    1.640000]  [<c1512b0b>] ? _raw_spin_unlock_irqrestore+0x3b/0x70
[    1.640000]  [<c1065316>] ? __wake_up+0x46/0x60
[    1.640000]  [<c12fd2d4>] ? account+0xa4/0x1b0
[    1.640000]  [<c1003968>] ? dump_trace+0x78/0xf0
[    1.640000]  [<c12fe64b>] extract_entropy+0x7b/0x1b0
[    1.640000]  [<c12fe919>] ? get_random_bytes+0x29/0x30
[    1.640000]  [<c1004c00>] ? show_trace+0x20/0x30
[    1.640000]  [<c12fe919>] get_random_bytes+0x29/0x30
[    1.640000]  [<c103530f>] init_oops_id+0x3f/0x50
[    1.640000]  [<c1035591>] print_oops_end_marker+0x11/0x40
[    1.640000]  [<c1035638>] warn_slowpath_common+0x78/0xb0
[    1.640000]  [<c106a6cc>] ? set_task_cpu+0x12c/0x280
[    1.640000]  [<c106a6cc>] ? set_task_cpu+0x12c/0x280
[    1.640000]  [<c1035693>] warn_slowpath_null+0x23/0x30
[    1.640000]  [<c106a6cc>] set_task_cpu+0x12c/0x280
[    1.640000]  [<c1068e2b>] ? update_rq_clock+0x3b/0x70
[    1.640000]  [<c1068ee1>] ? dequeue_task+0x81/0xc0
[    1.640000]  [<c106a922>] __migrate_task+0x102/0x140
[    1.640000]  [<c106a960>] ? __migrate_task+0x140/0x140
[    1.640000]  [<c106a982>] migration_cpu_stop+0x22/0x30
[    1.640000]  [<c10a0a88>] cpu_stopper_thread+0x68/0x130
[    1.640000]  [<c106ea11>] ? sched_clock_cpu+0xf1/0x180
[    1.640000]  [<c106a20d>] ? sub_preempt_count+0x4d/0xb0
[    1.640000]  [<c106eaee>] ? local_clock+0x4e/0x60
[    1.640000]  [<c108cf4a>] ? trace_hardirqs_off_caller+0x1a/0x110
[    1.640000]  [<c108d22d>] ? put_lock_stats.isra.17+0xd/0x30
[    1.640000]  [<c1512b25>] ? _raw_spin_unlock_irqrestore+0x55/0x70
[    1.640000]  [<c1512b0b>] ? _raw_spin_unlock_irqrestore+0x3b/0x70
[    1.640000]  [<c1063f06>] smpboot_thread_fn+0x176/0x260
[    1.640000]  [<c1063d90>] ? lg_lock_init+0x20/0x20
[    1.640000]  [<c105b305>] kthread+0x95/0xa0
[    1.640000]  [<c1510303>] ? schedule_hrtimeout_range_clock+0x163/0x170
[    1.640000]  [<c151077f>] ? wait_for_common+0xcf/0x110
[    1.640000]  [<c1060000>] ? hrtimer_run_pending+0x110/0x110
[    1.640000]  [<c15137b7>] ret_from_kernel_thread+0x1b/0x28
[    1.640000]  [<c105b270>] ? __kthread_parkme+0xa0/0xa0

HTH and thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
