Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaK1LeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:34:12 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41989 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaK1LeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:34:05 -0500
Date: Fri, 28 Nov 2014 12:33:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: tip-bot for Jiang Liu <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org, mingo@kernel.org,
        rdunlap@infradead.org, bhelgaas@google.com, hpa@zytor.com,
        tony.luck@intel.com, rjw@rjwysocki.net, grant.likely@linaro.org,
        konrad.wilk@oracle.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        yinghai@kernel.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, jroedel@suse.de
Subject: Re: [tip:x86/apic] x86, irq: Use cached IOAPIC entry instead of
 reading from hardware
Message-ID: <20141128113358.GB30997@pd.tnic>
References: <1416901802-24211-30-git-send-email-jiang.liu@linux.intel.com>
 <tip-fda7c08b1349cc4c65f8a5240b10f7e9938604b8@git.kernel.org>
 <20141127193213.GB4190@pd.tnic>
 <5477DE90.5090500@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <5477DE90.5090500@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, Nov 28, 2014 at 10:31:44AM +0800, Jiang Liu wrote:
> 	Thanks for tracking down to this line of change. I have no
> platform to reproduce this bug, so could you please help to revert this
> commit and apply following patch to get some data about IOAPIC entry?

Yep, the cached data differs from what's in the hw reg sometimes:

dmesg | grep -i ioapic
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.429355] ioapic0 pin9, hardware reg a939, cached data 1a939
[    0.506249] ioapic0 pin9, hardware reg 1a939, cached data 1a939
[    0.521547] ACPI: Using IOAPIC for interrupt routing
[    1.313959] ioapic0 pin19, hardware reg a9c1, cached data 1a9c1
[    1.357875] ioapic0 pin12, hardware reg 93c, cached data 93c
[    1.359204] ioapic0 pin1, hardware reg 931, cached data 931
[    1.367423] ioapic0 pin8, hardware reg 938, cached data 938
[    7.560846] ioapic0 pin17, hardware reg a981, cached data 1a981
[    7.866814] ioapic0 pin18, hardware reg a9a1, cached data 1a9a1
[   10.141662] ioapic0 pin16, hardware reg a942, cached data 1a942

This would explain the failure because the ahci ioapic pin19 has that
discrepancy:

[    1.311476] ahci 0000:00:11.0: version 3.0
[    1.313374] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 1 ports 3 Gbps 0x1 impl SATA mode
[    1.313556] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    1.313959] ioapic0 pin19, hardware reg a9c1, cached data 1a9c1
[    1.317281] scsi host0: ahci

Btw, that's 32-bit.

Full dmesg attached.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc6+ (boris@pd) (gcc version 4.9.1 (Debian 4.9.1-19) ) #25 SMP PREEMPT Fri Nov 28 12:15:46 CET 2014
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000c6cf5fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c6cf6000-0x00000000c7105fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000c7106000-0x00000000c7185fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000c7186000-0x00000000c71e5fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000c71e6000-0x00000000c7bfffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000c7c00000-0x00000000c7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fecfffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed80fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011effffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: LENOVO 30515QG/30515QG, BIOS 8RET30WW (1.12 ) 09/15/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xc7c00 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FF8000000 write-back
[    0.000000]   3 base 0FFF90000 mask FFFFF0000 uncachable
[    0.000000]   4 base 0FED80000 mask FFFFFF000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000] TOM2: 000000011f000000 aka 4592M
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC  
[    0.000000] initial memory mapped: [mem 0x00000000-0x027fffff]
[    0.000000] Base memory trampoline at [c0099000] 99000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37000000-0x373fffff]
[    0.000000]  [mem 0x37000000-0x373fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x30000000-0x36ffffff]
[    0.000000]  [mem 0x30000000-0x36ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x2fffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x2fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x37400000-0x377fdfff]
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] BRK [0x023bf000, 0x023bffff] PGTABLE
[    0.000000] log_buf_len: 16777216 bytes
[    0.000000] early log buf free: 2093776(99%)
[    0.000000] RAMDISK: [mem 0x37a42000-0x37d18fff]
[    0.000000] Allocated new RAMDISK: [mem 0x36527000-0x367fd4f7]
[    0.000000] Move RAMDISK from [mem 0x37a42000-0x37d184f7] to [mem 0x36527000-0x367fd4f7]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F00E0 000024 (v04 LENOVO)
[    0.000000] ACPI: XSDT 0xC71E5120 000074 (v01 LENOVO TP-8R    00000003 PTEC 00000002)
[    0.000000] ACPI: FACP 0xC71D3000 0000F4 (v04 LENOVO TP-8R    00001130 PTL  00000002)
[    0.000000] ACPI: DSDT 0xC71D5000 00EABE (v01 LENOVO TP-8R    00001000 PTEC 00001130)
[    0.000000] ACPI: FACS 0xC7171000 000040
[    0.000000] ACPI: SLIC 0xC71E4000 000176 (v01 LENOVO TP-8R    00001130 PTEC 00000001)
[    0.000000] ACPI: HPET 0xC71D2000 000038 (v01 LENOVO TP-8R    00001130 PTL  00000002)
[    0.000000] ACPI: APIC 0xC71D1000 00005E (v02 LENOVO TP-8R    00001130 PTL  00000002)
[    0.000000] ACPI: MCFG 0xC71D0000 00003C (v01 LENOVO TP-8R    00001130 PTL  00000002)
[    0.000000] ACPI: UEFI 0xC71CF000 00003E (v01 LENOVO TP-8R    00001130 PTL  00000002)
[    0.000000] ACPI: UEFI 0xC71CE000 000042 (v01 PTL    COMBUF   00000001 PTL  00000001)
[    0.000000] ACPI: SSDT 0xC71CD000 0003DE (v01 AMD    POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: SSDT 0xC71CB000 00168E (v02 AMD    ALIB     00000001 MSFT 04000000)
[    0.000000] ACPI: UEFI 0xC71CA000 00013E (v01 LENOVO TP-8R    00001130 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2308MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] BRK [0x023c0000, 0x023c0fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0xc7bfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xc6cf5fff]
[    0.000000]   node   0: [mem 0xc71e6000-0xc7bfffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0xc7bfffff]
[    0.000000] On node 0 totalpages: 816812
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 223230 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4617 pages used for memmap
[    0.000000]   HighMem zone: 589586 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x43538210 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] e820: [mem 0xc8000000-0xfebfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 16 pages/cpu @f4bd2000 s34304 r0 d31232 u65536
[    0.000000] pcpu-alloc: s34304 r0 d31232 u65536 alloc=16*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 815036
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.18.0-rc6+ root=/dev/sda9 ro debug ignore_loglevel log_buf_len=10M
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:000c7c00)
[    0.000000] Initializing Movable for node 0 (00000000:00000000)
[    0.000000] Memory: 3200920K/3267248K available (5950K kernel code, 578K rwdata, 2416K rodata, 620K init, 10576K bss, 66328K reserved, 2358344K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8f000 - 0xfffff000   ( 448 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc18c0000 - 0xc195b000   ( 620 kB)
[    0.000000]       .data : 0xc15cfe1e - 0xc18beac0   (3003 kB)
[    0.000000]       .text : 0xc1000000 - 0xc15cfe1e   (5951 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] Running RCU self tests
[    0.000000] NR_IRQS:2304 nr_irqs:440 16
[    0.000000] CPU 0 irqstacks, hard=f440a000 soft=f440c000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 4911 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
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
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]   | Wound/wait tests |
[    0.000000]   ---------------------
[    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
[    0.000000]                ww contexts mixing:  ok  |  ok  |
[    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
[    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
[    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]            spinlock nest unlocked:  ok  |
[    0.000000]   -----------------------------------------------------
[    0.000000]                                  |block | try  |context|
[    0.000000]   -----------------------------------------------------
[    0.000000]                           context:  ok  |  ok  |  ok  |
[    0.000000]                               try:  ok  |  ok  |  ok  |
[    0.000000]                             block:  ok  |  ok  |  ok  |
[    0.000000]                          spinlock:  ok  |  ok  |  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 253 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] kmemleak: Early log buffer exceeded (806), please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1596.614 MHz processor
[    0.000005] Calibrating delay loop (skipped), value calculated using timer frequency.. 3193.22 BogoMIPS (lpj=6386456)
[    0.000180] pid_max: default: 32768 minimum: 301
[    0.000341] ACPI: Core revision 20140926
[    0.086010] ACPI: All ACPI Tables successfully acquired
[    0.091341] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.091484] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.093627] CPU: Physical Processor ID: 0
[    0.093764] CPU: Processor Core ID: 0
[    0.093897] mce: CPU supports 6 MCE banks
[    0.094052] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
[    0.094052] Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4, 1GB 0
[    0.094857] Freeing SMP alternatives memory: 20K (c195b000 - c1960000)
[    0.094999] ftrace: allocating 20962 entries in 41 pages
[    0.116271] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.117451] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.157254] smpboot: CPU0: AMD E-350 Processor (fam: 14, model: 01, stepping: 00)
[    0.262763] Performance Events: AMD PMU driver.
[    0.263006] ... version:                0
[    0.263138] ... bit width:              48
[    0.263268] ... generic registers:      4
[    0.263398] ... value mask:             0000ffffffffffff
[    0.263485] ... max period:             00007fffffffffff
[    0.263571] ... fixed-purpose events:   0
[    0.263655] ... event mask:             000000000000000f
[    0.281937] MCE: In-kernel MCE decoding enabled.
[    0.287924] CPU 1 irqstacks, hard=f455a000 soft=f455c000
[    0.288119] x86: Booting SMP configuration:
[    0.288251] .... node  #0, CPUs:      #1
[    0.304710] Initializing CPU#1
[    0.307281] x86: Booted up 1 node, 2 CPUs
[    0.307672] ----------------
[    0.307803] | NMI testsuite:
[    0.307930] --------------------
[    0.308059]   remote IPI:  ok  |
[    0.319242]    local IPI:  ok  |
[    0.342982] --------------------
[    0.343172] Good, all   2 testcases passed! |
[    0.343303] ---------------------------------
[    0.343436] smpboot: Total of 2 processors activated (6386.45 BogoMIPS)
[    0.346863] devtmpfs: initialized
[    0.348982] PM: Registering ACPI NVS region [mem 0xc7106000-0xc7185fff] (524288 bytes)
[    0.354336] NET: Registered protocol family 16
[    0.367499] cpuidle: using governor ladder
[    0.379023] cpuidle: using governor menu
[    0.379687] ACPI: bus type PCI registered
[    0.379867] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.380565] PCI: MMCONFIG for domain 0000 [bus 00-1f] at [mem 0xf8000000-0xf9ffffff] (base 0xf8000000)
[    0.380769] PCI: not using MMCONFIG
[    0.381217] PCI: PCI BIOS revision 3.00 entry at 0xfc030, last bus=31
[    0.381398] PCI: Using configuration type 1 for base access
[    0.381514] PCI: Using configuration type 1 for extended access
[    0.382075] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.382256] mtrr: probably your BIOS does not setup all CPUs.
[    0.382389] mtrr: corrected configuration.
[    0.408062] ACPI: Added _OSI(Module Device)
[    0.408254] ACPI: Added _OSI(Processor Device)
[    0.408388] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.408476] ACPI: Added _OSI(Processor Aggregator Device)
[    0.429355] ioapic0 pin9, hardware reg a939, cached data 1a939
[    0.496923] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.506249] ioapic0 pin9, hardware reg 1a939, cached data 1a939
[    0.520591] ACPI: Interpreter enabled
[    0.520805] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140926/hwxface-580)
[    0.521116] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140926/hwxface-580)
[    0.521461] ACPI: (supports S0 S3 S4 S5)
[    0.521547] ACPI: Using IOAPIC for interrupt routing
[    0.522731] PCI: MMCONFIG for domain 0000 [bus 00-1f] at [mem 0xf8000000-0xf9ffffff] (base 0xf8000000)
[    0.527039] PCI: MMCONFIG at [mem 0xf8000000-0xf9ffffff] reserved in ACPI motherboard resources
[    0.527250] PCI: Using MMCONFIG for extended config space
[    0.527436] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.533157] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.585723] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    0.601088] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.601298] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.604618] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME PCIeCapability]
[    0.614418] acpi PNP0A08:00: ignoring host bridge window [mem 0x000ce000-0x000cffff] (conflicts with Video ROM [mem 0x000c0000-0x000ce5ff])
[    0.614696] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-1f] only partially covers this bridge
[    0.616938] PCI host bridge to bus 0000:00
[    0.617124] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.617261] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.617384] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c1fff]
[    0.617476] pci_bus 0000:00: root bus resource [mem 0x000c2000-0x000c3fff]
[    0.617615] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c5fff]
[    0.617753] pci_bus 0000:00: root bus resource [mem 0x000c6000-0x000c7fff]
[    0.617892] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000c9fff]
[    0.618030] pci_bus 0000:00: root bus resource [mem 0x000ca000-0x000cbfff]
[    0.618168] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cdfff]
[    0.618298] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d1fff]
[    0.618440] pci_bus 0000:00: root bus resource [mem 0x000d2000-0x000d3fff]
[    0.618578] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d5fff]
[    0.618717] pci_bus 0000:00: root bus resource [mem 0x000d6000-0x000d7fff]
[    0.618855] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000d9fff]
[    0.619002] pci_bus 0000:00: root bus resource [mem 0x000da000-0x000dbfff]
[    0.619137] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000ddfff]
[    0.619272] pci_bus 0000:00: root bus resource [mem 0x000de000-0x000dffff]
[    0.619359] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e1fff]
[    0.619478] pci_bus 0000:00: root bus resource [mem 0x000e2000-0x000e3fff]
[    0.619611] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e5fff]
[    0.619744] pci_bus 0000:00: root bus resource [mem 0x000e6000-0x000e7fff]
[    0.619878] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000e9fff]
[    0.620011] pci_bus 0000:00: root bus resource [mem 0x000ea000-0x000ebfff]
[    0.620143] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000edfff]
[    0.620277] pci_bus 0000:00: root bus resource [mem 0x000ee000-0x000effff]
[    0.620364] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xf7ffffff]
[    0.620480] pci_bus 0000:00: root bus resource [mem 0xf8000000-0xffffffff]
[    0.620614] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.620747] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.620938] pci 0000:00:00.0: [1022:1510] type 00 class 0x060000
[    0.622146] pci 0000:00:01.0: [1002:9802] type 00 class 0x030000
[    0.622326] pci 0000:00:01.0: reg 0x10: [mem 0xe0000000-0xefffffff pref]
[    0.622473] pci 0000:00:01.0: reg 0x14: [io  0x4000-0x40ff]
[    0.622620] pci 0000:00:01.0: reg 0x18: [mem 0xf0300000-0xf033ffff]
[    0.622927] pci 0000:00:01.0: supports D1 D2
[    0.624134] pci 0000:00:01.1: [1002:1314] type 00 class 0x040300
[    0.624321] pci 0000:00:01.1: reg 0x10: [mem 0xf0344000-0xf0347fff]
[    0.624655] pci 0000:00:01.1: supports D1 D2
[    0.625507] pci 0000:00:05.0: [1022:1513] type 01 class 0x060400
[    0.625849] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.626652] pci 0000:00:05.0: System wakeup disabled by ACPI
[    0.627214] pci 0000:00:06.0: [1022:1514] type 01 class 0x060400
[    0.627509] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.628097] pci 0000:00:06.0: System wakeup disabled by ACPI
[    0.628633] pci 0000:00:07.0: [1022:1515] type 01 class 0x060400
[    0.629019] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.629645] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.630234] pci 0000:00:11.0: [1002:4391] type 00 class 0x010601
[    0.630408] pci 0000:00:11.0: reg 0x10: [io  0x4118-0x411f]
[    0.630560] pci 0000:00:11.0: reg 0x14: [io  0x4124-0x4127]
[    0.630710] pci 0000:00:11.0: reg 0x18: [io  0x4110-0x4117]
[    0.630861] pci 0000:00:11.0: reg 0x1c: [io  0x4120-0x4123]
[    0.631020] pci 0000:00:11.0: reg 0x20: [io  0x4100-0x410f]
[    0.631170] pci 0000:00:11.0: reg 0x24: [mem 0xf034a000-0xf034a3ff]
[    0.632156] pci 0000:00:12.0: [1002:4397] type 00 class 0x0c0310
[    0.632316] pci 0000:00:12.0: reg 0x10: [mem 0xf0349000-0xf0349fff]
[    0.633115] pci 0000:00:12.0: System wakeup disabled by ACPI
[    0.633703] pci 0000:00:12.2: [1002:4396] type 00 class 0x0c0320
[    0.633877] pci 0000:00:12.2: reg 0x10: [mem 0xf034a500-0xf034a5ff]
[    0.634231] pci 0000:00:12.2: supports D1 D2
[    0.634360] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.634978] pci 0000:00:12.2: System wakeup disabled by ACPI
[    0.635526] pci 0000:00:13.0: [1002:4397] type 00 class 0x0c0310
[    0.635688] pci 0000:00:13.0: reg 0x10: [mem 0xf0348000-0xf0348fff]
[    0.636474] pci 0000:00:13.0: System wakeup disabled by ACPI
[    0.637021] pci 0000:00:13.2: [1002:4396] type 00 class 0x0c0320
[    0.637194] pci 0000:00:13.2: reg 0x10: [mem 0xf034a400-0xf034a4ff]
[    0.637499] pci 0000:00:13.2: supports D1 D2
[    0.637627] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.638532] pci 0000:00:14.0: [1002:4385] type 00 class 0x0c0500
[    0.639512] pci 0000:00:14.2: [1002:4383] type 00 class 0x040300
[    0.639691] pci 0000:00:14.2: reg 0x10: [mem 0xf0340000-0xf0343fff 64bit]
[    0.640005] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.640577] pci 0000:00:14.2: System wakeup disabled by ACPI
[    0.641159] pci 0000:00:14.3: [1002:439d] type 00 class 0x060100
[    0.642181] pci 0000:00:14.4: [1002:4384] type 01 class 0x060401
[    0.642804] pci 0000:00:14.4: System wakeup disabled by ACPI
[    0.643368] pci 0000:00:18.0: [1022:1700] type 00 class 0x060000
[    0.644250] pci 0000:00:18.1: [1022:1701] type 00 class 0x060000
[    0.645095] pci 0000:00:18.2: [1022:1702] type 00 class 0x060000
[    0.646023] pci 0000:00:18.3: [1022:1703] type 00 class 0x060000
[    0.646956] pci 0000:00:18.4: [1022:1704] type 00 class 0x060000
[    0.647882] pci 0000:00:18.5: [1022:1718] type 00 class 0x060000
[    0.648804] pci 0000:00:18.6: [1022:1716] type 00 class 0x060000
[    0.649733] pci 0000:00:18.7: [1022:1719] type 00 class 0x060000
[    0.651119] pci 0000:01:00.0: [10ec:8176] type 00 class 0x028000
[    0.651317] pci 0000:01:00.0: reg 0x10: [io  0x3000-0x30ff]
[    0.651506] pci 0000:01:00.0: reg 0x18: [mem 0xf0200000-0xf0203fff 64bit]
[    0.651947] pci 0000:01:00.0: supports D1 D2
[    0.652126] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.659292] pci 0000:00:05.0: PCI bridge to [bus 01]
[    0.659451] pci 0000:00:05.0:   bridge window [io  0x3000-0x3fff]
[    0.659594] pci 0000:00:05.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.660203] pci 0000:02:00.0: [1969:1083] type 00 class 0x020000
[    0.660400] pci 0000:02:00.0: reg 0x10: [mem 0xf0100000-0xf013ffff 64bit]
[    0.660589] pci 0000:02:00.0: reg 0x18: [io  0x2000-0x207f]
[    0.660990] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.667250] pci 0000:00:06.0: PCI bridge to [bus 02]
[    0.667364] pci 0000:00:06.0:   bridge window [io  0x2000-0x2fff]
[    0.667460] pci 0000:00:06.0:   bridge window [mem 0xf0100000-0xf01fffff]
[    0.668070] pci 0000:03:00.0: [10ec:5209] type 00 class 0xff0000
[    0.668298] pci 0000:03:00.0: reg 0x10: [mem 0xf0000000-0xf0000fff]
[    0.668570] pci 0000:03:00.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
[    0.668933] pci 0000:03:00.0: supports D1 D2
[    0.669113] pci 0000:03:00.0: PME# supported from D1 D2 D3hot
[    0.675256] pci 0000:00:07.0: PCI bridge to [bus 03]
[    0.675425] pci 0000:00:07.0:   bridge window [mem 0xf0000000-0xf00fffff]
[    0.676023] pci 0000:00:14.4: PCI bridge to [bus 04] (subtractive decode)
[    0.676182] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.676350] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000c1fff] (subtractive decode)
[    0.676529] pci 0000:00:14.4:   bridge window [mem 0x000c2000-0x000c3fff] (subtractive decode)
[    0.676706] pci 0000:00:14.4:   bridge window [mem 0x000c4000-0x000c5fff] (subtractive decode)
[    0.676883] pci 0000:00:14.4:   bridge window [mem 0x000c6000-0x000c7fff] (subtractive decode)
[    0.677061] pci 0000:00:14.4:   bridge window [mem 0x000c8000-0x000c9fff] (subtractive decode)
[    0.677238] pci 0000:00:14.4:   bridge window [mem 0x000ca000-0x000cbfff] (subtractive decode)
[    0.677415] pci 0000:00:14.4:   bridge window [mem 0x000cc000-0x000cdfff] (subtractive decode)
[    0.677593] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000d1fff] (subtractive decode)
[    0.677769] pci 0000:00:14.4:   bridge window [mem 0x000d2000-0x000d3fff] (subtractive decode)
[    0.677942] pci 0000:00:14.4:   bridge window [mem 0x000d4000-0x000d5fff] (subtractive decode)
[    0.678115] pci 0000:00:14.4:   bridge window [mem 0x000d6000-0x000d7fff] (subtractive decode)
[    0.678263] pci 0000:00:14.4:   bridge window [mem 0x000d8000-0x000d9fff] (subtractive decode)
[    0.678435] pci 0000:00:14.4:   bridge window [mem 0x000da000-0x000dbfff] (subtractive decode)
[    0.678607] pci 0000:00:14.4:   bridge window [mem 0x000dc000-0x000ddfff] (subtractive decode)
[    0.678780] pci 0000:00:14.4:   bridge window [mem 0x000de000-0x000dffff] (subtractive decode)
[    0.678965] pci 0000:00:14.4:   bridge window [mem 0x000e0000-0x000e1fff] (subtractive decode)
[    0.679137] pci 0000:00:14.4:   bridge window [mem 0x000e2000-0x000e3fff] (subtractive decode)
[    0.679276] pci 0000:00:14.4:   bridge window [mem 0x000e4000-0x000e5fff] (subtractive decode)
[    0.679444] pci 0000:00:14.4:   bridge window [mem 0x000e6000-0x000e7fff] (subtractive decode)
[    0.679616] pci 0000:00:14.4:   bridge window [mem 0x000e8000-0x000e9fff] (subtractive decode)
[    0.679789] pci 0000:00:14.4:   bridge window [mem 0x000ea000-0x000ebfff] (subtractive decode)
[    0.679960] pci 0000:00:14.4:   bridge window [mem 0x000ec000-0x000edfff] (subtractive decode)
[    0.680133] pci 0000:00:14.4:   bridge window [mem 0x000ee000-0x000effff] (subtractive decode)
[    0.680274] pci 0000:00:14.4:   bridge window [mem 0xe0000000-0xf7ffffff] (subtractive decode)
[    0.680444] pci 0000:00:14.4:   bridge window [mem 0xf8000000-0xffffffff] (subtractive decode)
[    0.680616] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.682457] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.682786] pci_bus 0000:00: on NUMA node 0
[    0.685975] ACPI: PCI Interrupt Link [LNKA] (IRQs 10 11) *0
[    0.686979] ACPI: PCI Interrupt Link [LNKB] (IRQs 10 11) *0
[    0.688008] ACPI: PCI Interrupt Link [LNKC] (IRQs 10 11) *0
[    0.689018] ACPI: PCI Interrupt Link [LNKD] (IRQs 10 11) *0
[    0.689940] ACPI: PCI Interrupt Link [LNKE] (IRQs 10 11) *0
[    0.690755] ACPI: PCI Interrupt Link [LNKF] (IRQs 10 11) *0
[    0.691534] ACPI: PCI Interrupt Link [LNKG] (IRQs 10 11) *0
[    0.692317] ACPI: PCI Interrupt Link [LNKH] (IRQs 10 11) *0
[    0.696755] ACPI: Enabled 2 GPEs in block 00 to 1F
[    0.697765] ACPI : EC: GPE = 0x3, I/O: command/status = 0x66, data = 0x62
[    0.699607] vgaarb: setting as boot device: PCI:0000:00:01.0
[    0.699802] vgaarb: device added: PCI:0000:00:01.0,decodes=io+mem,owns=io+mem,locks=none
[    0.700011] vgaarb: loaded
[    0.700141] vgaarb: bridge control possible 0000:00:01.0
[    0.700650] SCSI subsystem initialized
[    0.701437] libata version 3.00 loaded.
[    0.701637] ACPI: bus type USB registered
[    0.702025] usbcore: registered new interface driver usbfs
[    0.702301] usbcore: registered new interface driver hub
[    0.702571] usbcore: registered new device driver usb
[    0.703069] PCI: Using ACPI for IRQ routing
[    0.704929] PCI: pci_cache_line_size set to 64 bytes
[    0.705261] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.705417] e820: reserve RAM buffer [mem 0xc6cf6000-0xc7ffffff]
[    0.705554] e820: reserve RAM buffer [mem 0xc7c00000-0xc7ffffff]
[    0.707797] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.708045] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.711390] Switched to clocksource hpet
[    0.819906] pnp: PnP ACPI init
[    0.820982] system 00:00: [io  0x0f50-0x0f51] has been reserved
[    0.821180] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.821276] system 00:00: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.821371] system 00:00: [mem 0xf8000000-0xf9ffffff] has been reserved
[    0.821582] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.825014] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.825431] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.825892] pnp 00:03: Plug and Play ACPI device, IDs LEN0026 PNP0f13 (active)
[    0.826462] system 00:04: [io  0x04d0-0x04d1] has been reserved
[    0.826650] system 00:04: [io  0x0530-0x0537] has been reserved
[    0.826793] system 00:04: [io  0x0800-0x0827] could not be reserved
[    0.826933] system 00:04: [io  0x0830] has been reserved
[    0.827071] system 00:04: [io  0x0840-0x0847] has been reserved
[    0.827164] system 00:04: [io  0x0b00-0x0b1f] has been reserved
[    0.827256] system 00:04: [io  0x0b20-0x0b3f] has been reserved
[    0.827368] system 00:04: [io  0x0c00-0x0c01] has been reserved
[    0.827507] system 00:04: [io  0x0c14] has been reserved
[    0.827645] system 00:04: [io  0x0c50-0x0c52] has been reserved
[    0.827784] system 00:04: [io  0x0cd0-0x0cd1] has been reserved
[    0.827923] system 00:04: [io  0x0cd2-0x0cd3] has been reserved
[    0.828062] system 00:04: [io  0x0cd4-0x0cd5] has been reserved
[    0.828182] system 00:04: [io  0x0cd6-0x0cd7] has been reserved
[    0.828322] system 00:04: [io  0x0cd8-0x0cdf] has been reserved
[    0.828464] system 00:04: [io  0x0cf9] could not be reserved
[    0.828602] system 00:04: [io  0x8100-0x81ff window] has been reserved
[    0.828739] system 00:04: [io  0x8200-0x82ff window] has been reserved
[    0.828882] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.829734] system 00:05: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.829920] system 00:05: [mem 0xffe00000-0xffffffff] has been reserved
[    0.830056] system 00:05: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.830180] system 00:05: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.830321] system 00:05: [mem 0xfed61000-0xfed613ff] has been reserved
[    0.830458] system 00:05: [mem 0xfed80000-0xfed80fff] has been reserved
[    0.830601] system 00:05: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.831658] pnp: PnP ACPI: found 6 devices
[    0.907825] pci 0000:03:00.0: can't claim BAR 6 [mem 0xffff0000-0xffffffff pref]: no compatible bridge window
[    0.908089] pci 0000:00:07.0: bridge window [io  0x1000-0x0fff] to [bus 03] add_size 1000
[    0.908288] pci 0000:00:07.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 03] add_size 200000
[    0.908485] pci 0000:00:07.0: res[9]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.908665] pci 0000:00:07.0: res[7]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.908878] pci 0000:00:07.0: BAR 9: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.909107] pci 0000:00:07.0: BAR 7: assigned [io  0x1000-0x1fff]
[    0.909207] pci 0000:00:05.0: PCI bridge to [bus 01]
[    0.909298] pci 0000:00:05.0:   bridge window [io  0x3000-0x3fff]
[    0.909441] pci 0000:00:05.0:   bridge window [mem 0xf0200000-0xf02fffff]
[    0.909590] pci 0000:00:06.0: PCI bridge to [bus 02]
[    0.909722] pci 0000:00:06.0:   bridge window [io  0x2000-0x2fff]
[    0.909861] pci 0000:00:06.0:   bridge window [mem 0xf0100000-0xf01fffff]
[    0.910010] pci 0000:03:00.0: BAR 6: assigned [mem 0xf0010000-0xf001ffff pref]
[    0.910148] pci 0000:00:07.0: PCI bridge to [bus 03]
[    0.910280] pci 0000:00:07.0:   bridge window [io  0x1000-0x1fff]
[    0.910419] pci 0000:00:07.0:   bridge window [mem 0xf0000000-0xf00fffff]
[    0.910557] pci 0000:00:07.0:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.910733] pci 0000:00:14.4: PCI bridge to [bus 04]
[    0.910888] pci_bus 0000:00: resource 4 [mem 0x000a0000-0x000bffff]
[    0.911020] pci_bus 0000:00: resource 5 [mem 0x000c0000-0x000c1fff]
[    0.911106] pci_bus 0000:00: resource 6 [mem 0x000c2000-0x000c3fff]
[    0.911191] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000c5fff]
[    0.911327] pci_bus 0000:00: resource 8 [mem 0x000c6000-0x000c7fff]
[    0.911460] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000c9fff]
[    0.911592] pci_bus 0000:00: resource 10 [mem 0x000ca000-0x000cbfff]
[    0.911724] pci_bus 0000:00: resource 11 [mem 0x000cc000-0x000cdfff]
[    0.911855] pci_bus 0000:00: resource 12 [mem 0x000d0000-0x000d1fff]
[    0.911988] pci_bus 0000:00: resource 13 [mem 0x000d2000-0x000d3fff]
[    0.912119] pci_bus 0000:00: resource 14 [mem 0x000d4000-0x000d5fff]
[    0.912205] pci_bus 0000:00: resource 15 [mem 0x000d6000-0x000d7fff]
[    0.912290] pci_bus 0000:00: resource 16 [mem 0x000d8000-0x000d9fff]
[    0.912422] pci_bus 0000:00: resource 17 [mem 0x000da000-0x000dbfff]
[    0.912554] pci_bus 0000:00: resource 18 [mem 0x000dc000-0x000ddfff]
[    0.912686] pci_bus 0000:00: resource 19 [mem 0x000de000-0x000dffff]
[    0.912817] pci_bus 0000:00: resource 20 [mem 0x000e0000-0x000e1fff]
[    0.912949] pci_bus 0000:00: resource 21 [mem 0x000e2000-0x000e3fff]
[    0.913035] pci_bus 0000:00: resource 22 [mem 0x000e4000-0x000e5fff]
[    0.913120] pci_bus 0000:00: resource 23 [mem 0x000e6000-0x000e7fff]
[    0.913206] pci_bus 0000:00: resource 24 [mem 0x000e8000-0x000e9fff]
[    0.913291] pci_bus 0000:00: resource 25 [mem 0x000ea000-0x000ebfff]
[    0.913423] pci_bus 0000:00: resource 26 [mem 0x000ec000-0x000edfff]
[    0.913555] pci_bus 0000:00: resource 27 [mem 0x000ee000-0x000effff]
[    0.913687] pci_bus 0000:00: resource 28 [mem 0xe0000000-0xf7ffffff]
[    0.913819] pci_bus 0000:00: resource 29 [mem 0xf8000000-0xffffffff]
[    0.913951] pci_bus 0000:00: resource 30 [io  0x0000-0x0cf7]
[    0.914035] pci_bus 0000:00: resource 31 [io  0x0d00-0xffff]
[    0.914120] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.914205] pci_bus 0000:01: resource 1 [mem 0xf0200000-0xf02fffff]
[    0.914291] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.914422] pci_bus 0000:02: resource 1 [mem 0xf0100000-0xf01fffff]
[    0.914554] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    0.914685] pci_bus 0000:03: resource 1 [mem 0xf0000000-0xf00fffff]
[    0.914818] pci_bus 0000:03: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.914987] pci_bus 0000:04: resource 4 [mem 0x000a0000-0x000bffff]
[    0.915119] pci_bus 0000:04: resource 5 [mem 0x000c0000-0x000c1fff]
[    0.915205] pci_bus 0000:04: resource 6 [mem 0x000c2000-0x000c3fff]
[    0.915303] pci_bus 0000:04: resource 7 [mem 0x000c4000-0x000c5fff]
[    0.915436] pci_bus 0000:04: resource 8 [mem 0x000c6000-0x000c7fff]
[    0.915568] pci_bus 0000:04: resource 9 [mem 0x000c8000-0x000c9fff]
[    0.915700] pci_bus 0000:04: resource 10 [mem 0x000ca000-0x000cbfff]
[    0.915832] pci_bus 0000:04: resource 11 [mem 0x000cc000-0x000cdfff]
[    0.915964] pci_bus 0000:04: resource 12 [mem 0x000d0000-0x000d1fff]
[    0.916096] pci_bus 0000:04: resource 13 [mem 0x000d2000-0x000d3fff]
[    0.916212] pci_bus 0000:04: resource 14 [mem 0x000d4000-0x000d5fff]
[    0.916297] pci_bus 0000:04: resource 15 [mem 0x000d6000-0x000d7fff]
[    0.916429] pci_bus 0000:04: resource 16 [mem 0x000d8000-0x000d9fff]
[    0.916561] pci_bus 0000:04: resource 17 [mem 0x000da000-0x000dbfff]
[    0.916693] pci_bus 0000:04: resource 18 [mem 0x000dc000-0x000ddfff]
[    0.916825] pci_bus 0000:04: resource 19 [mem 0x000de000-0x000dffff]
[    0.916957] pci_bus 0000:04: resource 20 [mem 0x000e0000-0x000e1fff]
[    0.917089] pci_bus 0000:04: resource 21 [mem 0x000e2000-0x000e3fff]
[    0.917211] pci_bus 0000:04: resource 22 [mem 0x000e4000-0x000e5fff]
[    0.917297] pci_bus 0000:04: resource 23 [mem 0x000e6000-0x000e7fff]
[    0.917429] pci_bus 0000:04: resource 24 [mem 0x000e8000-0x000e9fff]
[    0.917561] pci_bus 0000:04: resource 25 [mem 0x000ea000-0x000ebfff]
[    0.917693] pci_bus 0000:04: resource 26 [mem 0x000ec000-0x000edfff]
[    0.917825] pci_bus 0000:04: resource 27 [mem 0x000ee000-0x000effff]
[    0.917957] pci_bus 0000:04: resource 28 [mem 0xe0000000-0xf7ffffff]
[    0.918089] pci_bus 0000:04: resource 29 [mem 0xf8000000-0xffffffff]
[    0.918211] pci_bus 0000:04: resource 30 [io  0x0000-0x0cf7]
[    0.918295] pci_bus 0000:04: resource 31 [io  0x0d00-0xffff]
[    0.918577] NET: Registered protocol family 2
[    0.920007] TCP established hash table entries: 8192 (order: 3, 32768 bytes)
[    0.920294] TCP bind hash table entries: 8192 (order: 6, 294912 bytes)
[    0.921910] TCP: Hash tables configured (established 8192 bind 8192)
[    0.922252] TCP: reno registered
[    0.922431] UDP hash table entries: 512 (order: 3, 40960 bytes)
[    0.922763] UDP-Lite hash table entries: 512 (order: 3, 40960 bytes)
[    0.923781] NET: Registered protocol family 1
[    0.924024] pci 0000:00:01.0: Video device with shadowed ROM
[    1.075419] PCI: CLS 32 bytes, default 64
[    1.076342] Unpacking initramfs...
[    1.206863] microcode: updated early to new patch_level=0x05000029
[    1.210911] Freeing initrd memory: 2908K (f6527000 - f67fe000)
[    1.212951] microcode: CPU0: patch_level=0x05000029
[    1.213134] microcode: CPU1: patch_level=0x05000029
[    1.213970] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.214219] LVT offset 0 assigned for vector 0x400
[    1.214528] perf: AMD IBS detected (0x000000ff)
[    1.221088] cryptomgr_test (30) used greatest stack depth: 7060 bytes left
[    1.222584] futex hash table entries: 512 (order: 3, 32768 bytes)
[    1.225405] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.252619] ntfs: driver 2.1.31 [Flags: R/O].
[    1.253485] fuse init (API version 7.23)
[    1.254944] msgmni has been set to 1651
[    1.255930] cryptomgr_test (33) used greatest stack depth: 7056 bytes left
[    1.263469] bounce: pool size: 64 pages
[    1.264018] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.264327] io scheduler noop registered
[    1.264511] io scheduler deadline registered
[    1.264994] io scheduler cfq registered (default)
[    1.271652] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
[    1.271845] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    1.271987] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
[    1.272254] pcieport 0000:00:06.0: Signaling PME through PCIe PME interrupt
[    1.272439] pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
[    1.272580] pcie_pme 0000:00:06.0:pcie01: service driver pcie_pme loaded
[    1.272841] pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
[    1.273026] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    1.273168] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
[    1.273354] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.287759] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    1.289086] ACPI: acpi_idle registered with cpuidle
[    1.291455] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.297519] Linux agpgart interface v0.103
[    1.298512] [drm] Initialized drm 1.1.0 20060810
[    1.310340] loop: module loaded
[    1.311182] SCSI Media Changer driver v0.25 
[    1.311476] ahci 0000:00:11.0: version 3.0
[    1.313374] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 1 ports 3 Gbps 0x1 impl SATA mode
[    1.313556] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    1.313959] ioapic0 pin19, hardware reg a9c1, cached data 1a9c1
[    1.317281] scsi host0: ahci
[    1.318460] ata1: SATA max UDMA/133 abar m1024@0xf034a000 port 0xf034a100 irq 19
[    1.353632] atl1c 0000:02:00.0: version 1.0.1.1-NAPI
[    1.354565] i8042: PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    1.357595] i8042: Detected active multiplexing controller, rev 1.1
[    1.357875] ioapic0 pin12, hardware reg 93c, cached data 93c
[    1.359204] ioapic0 pin1, hardware reg 931, cached data 931
[    1.359459] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.360527] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.360981] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.361425] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.361867] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.363879] mousedev: PS/2 mouse device common for all mice
[    1.365659] rtc_cmos 00:01: RTC can wake from S4
[    1.367188] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    1.367423] ioapic0 pin8, hardware reg 938, cached data 938
[    1.367589] rtc_cmos 00:01: alarms up to one month, 114 bytes nvram, hpet irqs
[    1.369339] device-mapper: ioctl: 4.28.0-ioctl (2014-09-17) initialised: dm-devel@redhat.com
[    1.370363] TCP: cubic registered
[    1.370549] NET: Registered protocol family 17
[    1.370728] 9pnet: Installing 9P2000 support
[    1.372682] Using IPI No-Shortcut mode
[    1.375337] registered taskstats version 1
[    1.379629] console [netcon0] enabled
[    1.379818] netconsole: network logging started
[    1.380074] rtc_cmos 00:01: setting system clock to 2014-11-28 11:24:29 UTC (1417173869)
[    1.380851] acpi-cpufreq: overriding BIOS provided _PSD data
[    1.407330] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.811383] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.815473] ata1.00: ATA-8: ST320LT007-9ZV142, 0004LVM1, max UDMA/133
[    1.815698] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.820237] ata1.00: configured for UDMA/133
[    1.824293] scsi 0:0:0:0: Direct-Access     ATA      ST320LT007-9ZV14 LVM1 PQ: 0 ANSI: 5
[    1.829523] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.829702] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.829942] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.830707] sd 0:0:0:0: [sda] Write Protect is off
[    1.831090] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.831535] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.947609]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    1.960091] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.211148] tsc: Refined TSC clocksource calibration: 1596.599 MHz
[    2.633586] psmouse serio4: synaptics: Touchpad model: 1, fw: 8.0, id: 0x1e2b1, caps: 0xd001a3/0x940300/0x121c00, board id: 1811, fw id: 797391
[    2.633922] psmouse serio4: synaptics: serio: Synaptics pass-through port at isa0060/serio4/input0
[    2.680165] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input8
[    2.726787] Freeing unused kernel memory: 620K (c18c0000 - c195b000)
[    2.727627] Write protecting the kernel text: 5952k
[    2.728276] Write protecting the kernel read-only data: 2424k
[    2.737667] init (53) used greatest stack depth: 7032 bytes left
[    2.743600] init (56) used greatest stack depth: 6872 bytes left
[    2.791080] all_generic_ide (65) used greatest stack depth: 6812 bytes left
[    2.797155] blacklist (67) used greatest stack depth: 6736 bytes left
[    2.827465] udev[71]: starting version 164
[    2.827505] udevd (70) used greatest stack depth: 6636 bytes left
[    2.960944] udevadm (72) used greatest stack depth: 6472 bytes left
[    3.039491] thermal LNXTHERM:00: registered as thermal_zone0
[    3.039693] ACPI: Thermal Zone [THZ0] (51 C)
[    3.040648] modprobe (104) used greatest stack depth: 5596 bytes left
[    3.214603] Switched to clocksource tsc
[    4.814671] PM: Starting manual resume from disk
[    4.914326] EXT4-fs (sda9): mounted filesystem with ordered data mode. Opts: (null)
[    5.156825] random: nonblocking pool is initialized
[    6.967790] udev[339]: starting version 164
[    6.977783] psmouse serio5: trackpoint: IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    7.204008] input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio4/serio5/input/input9
[    7.429487] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.531405] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input10
[    7.532815] ACPI: Video Device [VGA1] (multi-head: yes  rom: no  post: no)
[    7.533376] ACPI: Power Button [PWRB]
[    7.534276] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    7.538980] ehci-pci: EHCI PCI platform driver
[    7.539051] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input11
[    7.539463] ACPI: Sleep Button [SLPB]
[    7.557264] QUIRK: Enable AMD PLL fix
[    7.557616] ehci-pci 0000:00:12.2: EHCI Host Controller
[    7.558839] ehci-pci 0000:00:12.2: new USB bus registered, assigned bus number 1
[    7.559417] ACPI: AC Adapter [ACAD] (off-line)
[    7.560078] ehci-pci 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    7.560360] ehci-pci 0000:00:12.2: debug port 1
[    7.560846] ioapic0 pin17, hardware reg a981, cached data 1a981
[    7.561142] ehci-pci 0000:00:12.2: irq 17, io mem 0xf034a500
[    7.562481] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input12
[    7.565935] ACPI: Lid Switch [LID]
[    7.567009] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input13
[    7.568940] ACPI: Power Button [PWRF]
[    7.580061] ehci-pci 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    7.580707] acpi device:37: registered as cooling_device2
[    7.582808] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input14
[    7.606434] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.606840] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.607865] usb usb1: Product: EHCI Host Controller
[    7.608019] usb usb1: Manufacturer: Linux 3.18.0-rc6+ ehci_hcd
[    7.610245] usb usb1: SerialNumber: 0000:00:12.2
[    7.617323] modprobe (486) used greatest stack depth: 5236 bytes left
[    7.619779] ACPI: Battery Slot [BAT1] (battery present)
[    7.628237] hub 1-0:1.0: USB hub found
[    7.628637] hub 1-0:1.0: 5 ports detected
[    7.630662] rtsx_pci 0000:03:00.0: rtsx_pci_acquire_irq: pcr->msi_en = 1, pci->irq = 27
[    7.670398] ehci-pci 0000:00:13.2: EHCI Host Controller
[    7.670592] ehci-pci 0000:00:13.2: new USB bus registered, assigned bus number 2
[    7.670741] ehci-pci 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    7.670925] ehci-pci 0000:00:13.2: debug port 1
[    7.671117] ehci-pci 0000:00:13.2: irq 17, io mem 0xf034a400
[    7.679663] ehci-pci 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    7.680263] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    7.680451] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.680626] usb usb2: Product: EHCI Host Controller
[    7.680759] usb usb2: Manufacturer: Linux 3.18.0-rc6+ ehci_hcd
[    7.680894] usb usb2: SerialNumber: 0000:00:13.2
[    7.702451] hub 2-0:1.0: USB hub found
[    7.709743] hub 2-0:1.0: 5 ports detected
[    7.746424] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.747298] modprobe (422) used greatest stack depth: 5092 bytes left
[    7.754910] input: PC Speaker as /devices/platform/pcspkr/input/input15
[    7.766786] cfg80211: Calling CRDA to update world regulatory domain
[    7.864447] ohci-pci: OHCI PCI platform driver
[    7.866316] ohci-pci 0000:00:12.0: OHCI PCI host controller
[    7.866509] ohci-pci 0000:00:12.0: new USB bus registered, assigned bus number 3
[    7.866814] ioapic0 pin18, hardware reg a9a1, cached data 1a9a1
[    7.866980] ohci-pci 0000:00:12.0: irq 18, io mem 0xf0349000
[    7.927492] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    7.927646] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.927823] usb usb3: Product: OHCI PCI host controller
[    7.927959] usb usb3: Manufacturer: Linux 3.18.0-rc6+ ohci_hcd
[    7.928095] usb usb3: SerialNumber: 0000:00:12.0
[    7.934168] hub 3-0:1.0: USB hub found
[    7.935789] hub 3-0:1.0: 5 ports detected
[    7.986086] ohci-pci 0000:00:13.0: OHCI PCI host controller
[    7.986279] ohci-pci 0000:00:13.0: new USB bus registered, assigned bus number 4
[    7.986638] ohci-pci 0000:00:13.0: irq 18, io mem 0xf0348000
[    8.046235] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    8.046340] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.046465] usb usb4: Product: OHCI PCI host controller
[    8.046551] usb usb4: Manufacturer: Linux 3.18.0-rc6+ ohci_hcd
[    8.046701] usb usb4: SerialNumber: 0000:00:13.0
[    8.054243] hub 4-0:1.0: USB hub found
[    8.056090] hub 4-0:1.0: 5 ports detected
[    8.105779] rtsx_pci_sdmmc rtsx_pci_sdmmc.0: : Realtek PCI-E SDMMC controller found
[    8.106715] rtsx_pci_sdmmc rtsx_pci_sdmmc.0: pcr->extra_caps = 0x23
[    8.108382] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[    8.111657] rtsx_pci_sdmmc rtsx_pci_sdmmc.0: sdmmc_get_cd: RTSX_BIPR = 0x00000000
[    8.651212] Non-volatile memory driver v1.3
[    8.767992] thinkpad_acpi: ThinkPad ACPI Extras v0.25
[    8.768113] thinkpad_acpi: http://ibm-acpi.sf.net/
[    8.768201] thinkpad_acpi: ThinkPad BIOS 8RET30WW (1.12 ), EC unknown
[    8.768292] thinkpad_acpi: Lenovo ThinkPad X120e, model 30515QG
[    8.793859] thinkpad_acpi: Unsupported brightness interface, please contact ibm-acpi-devel@lists.sourceforge.net
[    8.795340] thinkpad_acpi: radio switch found; radios are enabled
[    8.795591] thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
[    8.795938] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    8.796163] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    8.824337] thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
[    8.848560] input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input16
[    9.393545] Error: Driver 'pcspkr' is already registered, aborting...
[   10.141662] ioapic0 pin16, hardware reg a942, cached data 1a942
[   10.540977] sound hdaudioC1D0: CX20590: BIOS auto-probing.
[   10.543174] sound hdaudioC1D0: autoconfig: line_outs=1 (0x1f/0x0/0x0/0x0/0x0) type:speaker
[   10.543390] sound hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   10.543552] sound hdaudioC1D0:    hp_outs=1 (0x19/0x0/0x0/0x0/0x0)
[   10.543712] sound hdaudioC1D0:    mono: mono_out=0x0
[   10.543864] sound hdaudioC1D0:    inputs:
[   10.544023] sound hdaudioC1D0:      Internal Mic=0x23
[   10.544183] sound hdaudioC1D0:      Mic=0x1b
[   10.570012] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:14.2/sound/card1/hdaudioC1D0/input17
[   10.585456] input: HDA ATI SB Mic as /devices/pci0000:00/0000:00:14.2/sound/card1/input18
[   10.587011] input: HDA ATI SB Headphone as /devices/pci0000:00/0000:00:14.2/sound/card1/input19
[   10.636465] input: HD-Audio Generic HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.1/sound/card0/input20
[   11.189171] [drm] radeon kernel modesetting enabled.
[   11.195188] [drm] initializing kernel modesetting (PALM 0x1002:0x9802 0x17AA:0x21EC).
[   11.195533] [drm] register mmio base: 0xF0300000
[   11.195712] [drm] register mmio size: 262144
[   11.196001] ATOM BIOS: Lenovo
[   11.196628] radeon 0000:00:01.0: VRAM: 384M 0x0000000000000000 - 0x0000000017FFFFFF (384M used)
[   11.196855] radeon 0000:00:01.0: GTT: 1024M 0x0000000018000000 - 0x0000000057FFFFFF
[   11.197029] [drm] Detected VRAM RAM=384M, BAR=256M
[   11.197159] [drm] RAM width 32bits DDR
[   11.198869] [TTM] Zone  kernel: Available graphics memory: 423062 kiB
[   11.198969] [TTM] Zone highmem: Available graphics memory: 1602234 kiB
[   11.199058] [TTM] Initializing pool allocator
[   11.200573] [drm] radeon: 384M of VRAM memory ready
[   11.200764] [drm] radeon: 1024M of GTT memory ready.
[   11.201078] [drm] Loading PALM Microcode
[   11.224639] radeon 0000:00:01.0: Direct firmware load for radeon/PALM_pfp.bin failed with error -2
[   11.224931] r600_cp: Failed to load firmware "radeon/PALM_pfp.bin"
[   11.225091] [drm:evergreen_init] *ERROR* Failed to load firmware!
[   11.225251] radeon 0000:00:01.0: Fatal error during GPU init
[   11.225722] [drm] radeon: finishing device.
[   11.234855] [TTM] Finalizing pool allocator
[   11.238378] [TTM] Zone  kernel: Used memory at exit: 0 kiB
[   11.238636] [TTM] Zone highmem: Used memory at exit: 0 kiB
[   11.238883] [drm] radeon: ttm finalized
[   11.248925] radeon: probe of 0000:00:01.0 failed with error -2
[   11.318298] rtl8192ce: Using firmware rtlwifi/rtl8192cfw.bin
[   11.360819] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[   11.365004] rtlwifi: rtlwifi: wireless switch is on
[   12.705311] Adding 15625212k swap on /dev/sda2.  Priority:-1 extents:1 across:15625212k 
[   12.786895] EXT4-fs (sda9): re-mounted. Opts: (null)
[   13.326407] EXT4-fs (sda9): re-mounted. Opts: errors=remount-ro
[   14.287930] EXT4-fs (sda10): mounted filesystem with ordered data mode. Opts: (null)
[   15.338388] atl1c 0000:02:00.0: atl1c: eth0 NIC Link is Up<100 Mbps Full Duplex>
[   16.576090] NET: Registered protocol family 10

--UlVJffcvxoiEqYs2--
