Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaE0HEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 03:04:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:51274 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbaE0HEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 03:04:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,917,1392192000"; 
   d="al'?scan'208";a="437204102"
Date: Tue, 27 May 2014 10:04:09 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140527070409.GA1801@lahna.fi.intel.com>
References: <20140526093741.GA1765@lahna.fi.intel.com>
 <20140526135746.GM18016@ZenIV.linux.org.uk>
 <20140526142948.GA1685@lahna.fi.intel.com>
 <20140526152703.GN18016@ZenIV.linux.org.uk>
 <CA+55aFyz1oQQ+uz9DPSEmYBBby1VKTRFz81mTt3mVSLN+tMK+A@mail.gmail.com>
 <20140526182644.GP18016@ZenIV.linux.org.uk>
 <CA+55aFxq-=xyNOLKQhS5kwy5FKZ=Jp2XSRnyZLU9e8neBLk_2A@mail.gmail.com>
 <20140527014054.GR18016@ZenIV.linux.org.uk>
 <20140527031415.GS18016@ZenIV.linux.org.uk>
 <20140527040026.GT18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <20140527040026.GT18016@ZenIV.linux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 27, 2014 at 05:00:26AM +0100, Al Viro wrote:
> On Tue, May 27, 2014 at 04:14:15AM +0100, Al Viro wrote:
> 
> > As the matter of fact, let's try this instead - retry the same sucker
> > immediately in case if trylocks fail.  Comments?
> 
> Better yet, let's take "move back to shrink list" into dentry_kill()
> itself.  Then we get consistent locking rules for dentry_kill() and
> instead of unlock_on_failure we simply pass it NULL or the shrink
> list to put the sucker back.  Mika, could you test this one and see
> if it fixes that livelock?  The difference in behaviour is that in
> case of trylock failure we hit that sucker again without letting
> it ride all the way around the list, same as we do for other dentry_kill()
> callers.

I tried this patch and unfortunately it still results the same sort of
livelock. I've attached the dmesg.

I also tried the serialization patch from Linus and it seemed to fix the
problem. After several rounds of USB memory stick plug/unplug I haven't
seen a single "soft lockup" warning in dmesg.

I'm able to reproduce the problem pretty easily, so if you have
something else to try I'm more than happy to give it a try.

--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.al"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.15.0-rc7+ (westeri@lahna) (gcc version 4.8.2 20131212 (Red Hat 4.8.2-7) (GCC) ) #4 SMP Tue May 27 09:44:16 EEST 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.15.0-rc7+ root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/swap vconsole.font=latarcyrheb-sun16 rd.lvm.lv=fedora/root rhgb LANG=en_US.UTF-8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000005573efff] usable
[    0.000000] BIOS-e820: [mem 0x000000005573f000-0x0000000055745fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000055746000-0x00000000567affff] usable
[    0.000000] BIOS-e820: [mem 0x00000000567b0000-0x0000000056d35fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000056d36000-0x0000000069b32fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000069b33000-0x0000000069d46fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000069d47000-0x0000000069d87fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000069d88000-0x0000000069e49fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000069e4a000-0x000000006affefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000006afff000-0x000000006affffff] usable
[    0.000000] BIOS-e820: [mem 0x000000006b800000-0x000000006f9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000048f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x48f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7C00000000 write-back
[    0.000000]   1 base 0400000000 mask 7F80000000 write-back
[    0.000000]   2 base 0480000000 mask 7FF0000000 write-back
[    0.000000]   3 base 0080000000 mask 7F80000000 uncachable
[    0.000000]   4 base 0070000000 mask 7FF0000000 uncachable
[    0.000000]   5 base 006C000000 mask 7FFC000000 uncachable
[    0.000000]   6 base 006B800000 mask 7FFF800000 uncachable
[    0.000000]   7 base 048F800000 mask 7FFF800000 uncachable
[    0.000000]   8 base 048F600000 mask 7FFFE00000 uncachable
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0x6b800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x6b000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd780-0x000fd78f] mapped at [ffff8800000fd780]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01ffd000, 0x01ffdfff] PGTABLE
[    0.000000] BRK [0x01ffe000, 0x01ffefff] PGTABLE
[    0.000000] BRK [0x01fff000, 0x01ffffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x48f400000-0x48f5fffff]
[    0.000000]  [mem 0x48f400000-0x48f5fffff] page 2M
[    0.000000] BRK [0x02000000, 0x02000fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x48c000000-0x48f3fffff]
[    0.000000]  [mem 0x48c000000-0x48f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x480000000-0x48bffffff]
[    0.000000]  [mem 0x480000000-0x48bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x5573efff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x555fffff] page 2M
[    0.000000]  [mem 0x55600000-0x5573efff] page 4k
[    0.000000] init_memory_mapping: [mem 0x55746000-0x567affff]
[    0.000000]  [mem 0x55746000-0x557fffff] page 4k
[    0.000000]  [mem 0x55800000-0x565fffff] page 2M
[    0.000000]  [mem 0x56600000-0x567affff] page 4k
[    0.000000] BRK [0x02001000, 0x02001fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x56d36000-0x69b32fff]
[    0.000000]  [mem 0x56d36000-0x56dfffff] page 4k
[    0.000000]  [mem 0x56e00000-0x699fffff] page 2M
[    0.000000]  [mem 0x69a00000-0x69b32fff] page 4k
[    0.000000] BRK [0x02002000, 0x02002fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x69d47000-0x69d87fff]
[    0.000000]  [mem 0x69d47000-0x69d87fff] page 4k
[    0.000000] init_memory_mapping: [mem 0x6afff000-0x6affffff]
[    0.000000]  [mem 0x6afff000-0x6affffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x47fffffff]
[    0.000000]  [mem 0x100000000-0x47fffffff] page 1G
[    0.000000] RAMDISK: [mem 0x343b0000-0x361cffff]
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x0000000069E1F080 00007C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x0000000069E2B6A8 00010C (v05 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x0000000069E1F190 00C518 (v02 ALASKA A M I    00000088 INTL 20091112)
[    0.000000] ACPI: FACS 0x0000000069E48080 000040
[    0.000000] ACPI: APIC 0x0000000069E2B7B8 000092 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x0000000069E2B850 000044 (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 0x0000000069E2B898 000539 (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x0000000069E2BDD8 000AD8 (v01 PmRef  CpuPm    00003000 INTL 20051117)
[    0.000000] ACPI: MCFG 0x0000000069E2C8B0 00003C (v01 ALASKA A M I    01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x0000000069E2C8F0 000038 (v01 ALASKA A M I    01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x0000000069E2C928 00036D (v01 SataRe SataTabl 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x0000000069E2CC98 003299 (v01 SaSsdt SaSsdt   00003000 INTL 20091112)
[    0.000000] ACPI: DMAR 0x0000000069E2FF38 000090 (v01 INTEL  HSW      00000001 INTL 00000001)
[    0.000000] ACPI: MATS 0x0000000069E2FFC8 000034 (v02 ALASKA A M I    00000002 w?x2 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000048f5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x48f5fffff]
[    0.000000]   NODE_DATA [mem 0x48f5e7000-0x48f5fafff]
[    0.000000]  [ffffea0000000000-ffffea00123fffff] PMD -> [ffff88047ec00000-ffff88048ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x48f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x5573efff]
[    0.000000]   node   0: [mem 0x55746000-0x567affff]
[    0.000000]   node   0: [mem 0x56d36000-0x69b32fff]
[    0.000000]   node   0: [mem 0x69d47000-0x69d87fff]
[    0.000000]   node   0: [mem 0x6afff000-0x6affffff]
[    0.000000]   node   0: [mem 0x100000000-0x48f5fffff]
[    0.000000] On node 0 totalpages: 4164484
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6680 pages used for memmap
[    0.000000]   DMA32 zone: 427496 pages, LIFO batch:31
[    0.000000]   Normal zone: 58328 pages used for memmap
[    0.000000]   Normal zone: 3732992 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0x6ba00000-0x6f9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x5573f000-0x55745fff]
[    0.000000] PM: Registered nosave memory: [mem 0x567b0000-0x56d35fff]
[    0.000000] PM: Registered nosave memory: [mem 0x69b33000-0x69d46fff]
[    0.000000] PM: Registered nosave memory: [mem 0x69d88000-0x69e49fff]
[    0.000000] PM: Registered nosave memory: [mem 0x69e4a000-0x6affefff]
[    0.000000] PM: Registered nosave memory: [mem 0x6b000000-0x6b7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x6b800000-0x6f9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x6fa00000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0x6fa00000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88048f200000 s86848 r8192 d23744 u262144
[    0.000000] pcpu-alloc: s86848 r8192 d23744 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4099391
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.15.0-rc7+ root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/swap vconsole.font=latarcyrheb-sun16 rd.lvm.lv=fedora/root rhgb LANG=en_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at drivers/iommu/dmar.c:761 warn_invalid_dmar+0x81/0x93()
[    0.000000] Your BIOS is broken; DMAR reported at address 0!
BIOS vendor: American Megatrends Inc.; Ver: F4; Product Version: To be filled by O.E.M.
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.15.0-rc7+ #4
[    0.000000] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[    0.000000]  000000000000000b ffffffff81c01e08 ffffffff8169ea12 ffffffff81c01e50
[    0.000000]  ffffffff81c01e40 ffffffff8108413d ffffffff81ffc01c ffffffff81ffc058
[    0.000000]  0000000000000000 ffffffff81dc92c0 ffffffff81c01fb0 ffffffff81c01ea0
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8169ea12>] dump_stack+0x45/0x56
[    0.000000]  [<ffffffff8108413d>] warn_slowpath_common+0x7d/0xa0
[    0.000000]  [<ffffffff810841f4>] warn_slowpath_fmt_taint+0x44/0x50
[    0.000000]  [<ffffffff813c34f5>] ? acpi_tb_verify_checksum+0x24/0x5b
[    0.000000]  [<ffffffff816a0698>] warn_invalid_dmar+0x81/0x93
[    0.000000]  [<ffffffff81d7385e>] detect_intel_iommu+0x7f/0x172
[    0.000000]  [<ffffffff81d2b265>] pci_iommu_alloc+0x4a/0x6c
[    0.000000]  [<ffffffff81d3a05e>] mem_init+0xf/0x8d
[    0.000000]  [<ffffffff81d21d00>] start_kernel+0x1cd/0x405
[    0.000000]  [<ffffffff81d2193c>] ? repair_env_string+0x5c/0x5c
[    0.000000]  [<ffffffff81d21120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81d215ee>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d2172e>] x86_64_start_kernel+0x13e/0x14d
[    0.000000] ---[ end trace 6f9b62aeb2e98791 ]---
[    0.000000] Memory: 16281128K/16657936K available (6856K kernel code, 1060K rwdata, 3008K rodata, 1412K init, 1572K bss, 376808K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3491.911 MHz processor
[    0.000018] Calibrating delay loop (skipped), value calculated using timer frequency.. 6983.82 BogoMIPS (lpj=3491911)
[    0.000139] pid_max: default: 32768 minimum: 301
[    0.000201] ACPI: Core revision 20140214
[    0.006727] ACPI: All ACPI Tables successfully acquired
[    0.016305] Security Framework initialized
[    0.016368] SELinux:  Initializing.
[    0.016428] SELinux:  Starting in permissive mode
[    0.017170] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.019281] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.020201] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.020717] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.020968] Initializing cgroup subsys memory
[    0.021028] Initializing cgroup subsys devices
[    0.021087] Initializing cgroup subsys freezer
[    0.021145] Initializing cgroup subsys net_cls
[    0.021204] Initializing cgroup subsys blkio
[    0.021262] Initializing cgroup subsys perf_event
[    0.021321] Initializing cgroup subsys hugetlb
[    0.021392] CPU: Physical Processor ID: 0
[    0.021449] CPU: Processor Core ID: 0
[    0.022215] mce: CPU supports 9 MCE banks
[    0.022282] CPU0: Thermal monitoring enabled (TM1)
[    0.022348] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
tlb_flushall_shift: 6
[    0.022549] Freeing SMP alternatives memory: 24K (ffffffff81e6c000 - ffffffff81e72000)
[    0.023271] ftrace: allocating 26174 entries in 103 pages
[    0.030284] dmar: Host address width 39
[    0.030365] dmar: DRHD base: 0x00000000000000 flags: 0x1
[    0.030448] dmar: parse DMAR table failure.
[    0.030899] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.040976] smpboot: CPU0: Intel(R) Core(TM) i7-4770K CPU @ 3.50GHz (fam: 06, model: 3c, stepping: 03)
[    0.041195] TSC deadline timer enabled
[    0.041199] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.041473] ... version:                3
[    0.041554] ... bit width:              48
[    0.041634] ... generic registers:      4
[    0.041714] ... value mask:             0000ffffffffffff
[    0.041796] ... max period:             0000ffffffffffff
[    0.041878] ... fixed-purpose events:   3
[    0.041959] ... event mask:             000000070000000f
[    0.042838] x86: Booting SMP configuration:
[    0.042919] .... node  #0, CPUs:      #1
[    0.056960] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.057211]  #2 #3 #4 #5 #6 #7
[    0.140483] x86: Booted up 1 node, 8 CPUs
[    0.140639] smpboot: Total of 8 processors activated (55870.57 BogoMIPS)
[    0.146915] devtmpfs: initialized
[    0.148992] PM: Registering ACPI NVS region [mem 0x5573f000-0x55745fff] (28672 bytes)
[    0.149126] PM: Registering ACPI NVS region [mem 0x69d88000-0x69e49fff] (794624 bytes)
[    0.149712] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.149800] pinctrl core: initialized pinctrl subsystem
[    0.149908] RTC time:  6:45:59, date: 05/27/14
[    0.150011] NET: Registered protocol family 16
[    0.150140] cpuidle: using governor menu
[    0.150239] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.150372] ACPI: bus type PCI registered
[    0.150453] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.150567] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.150704] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.166284] PCI: Using configuration type 1 for base access
[    0.167284] ACPI: Added _OSI(Module Device)
[    0.167366] ACPI: Added _OSI(Processor Device)
[    0.167447] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.167528] ACPI: Added _OSI(Processor Aggregator Device)
[    0.169896] ACPI: Executed 1 blocks of module-level executable AML code
[    0.171465] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.193870] ACPI: SSDT 0x0000000069D3CC18 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.194317] ACPI: Dynamic OEM Table Load:
[    0.194451] ACPI: SSDT 0x0000000000000000 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.198947] ACPI: SSDT 0x0000000069D3C618 0005AA (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.199492] ACPI: Dynamic OEM Table Load:
[    0.199627] ACPI: SSDT 0x0000000000000000 0005AA (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.203875] ACPI: SSDT 0x0000000069D3BD98 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.204325] ACPI: Dynamic OEM Table Load:
[    0.204459] ACPI: SSDT 0x0000000000000000 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.209528] ACPI: Interpreter enabled
[    0.209612] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    0.209803] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    0.210002] ACPI: (supports S0 S3 S4 S5)
[    0.210083] ACPI: Using IOAPIC for interrupt routing
[    0.210179] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.214876] ACPI: Power Resource [FN00] (off)
[    0.214998] ACPI: Power Resource [FN01] (off)
[    0.215117] ACPI: Power Resource [FN02] (off)
[    0.215234] ACPI: Power Resource [FN03] (off)
[    0.215351] ACPI: Power Resource [FN04] (off)
[    0.215842] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.215928] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.216183] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.216380] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.216768] PCI host bridge to bus 0000:00
[    0.216850] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.216933] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.217018] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.217103] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.217189] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.217274] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.217359] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.217445] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.217530] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.217616] pci_bus 0000:00: root bus resource [mem 0x6fa00000-0xfeafffff]
[    0.217705] pci 0000:00:00.0: [8086:0c00] type 00 class 0x060000
[    0.217755] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.217778] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.217806] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.217915] pci 0000:00:02.0: [8086:0412] type 00 class 0x030000
[    0.217922] pci 0000:00:02.0: reg 0x10: [mem 0xde400000-0xde7fffff 64bit]
[    0.217926] pci 0000:00:02.0: reg 0x18: [mem 0x70000000-0x7fffffff 64bit pref]
[    0.217929] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.217975] pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
[    0.217980] pci 0000:00:03.0: reg 0x10: [mem 0xdef34000-0xdef37fff 64bit]
[    0.218044] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.218058] pci 0000:00:14.0: reg 0x10: [mem 0xdef20000-0xdef2ffff 64bit]
[    0.218108] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.218131] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.218237] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.218252] pci 0000:00:16.0: reg 0x10: [mem 0xdef3f000-0xdef3f00f 64bit]
[    0.218303] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.218352] pci 0000:00:19.0: [8086:153b] type 00 class 0x020000
[    0.218365] pci 0000:00:19.0: reg 0x10: [mem 0xdef00000-0xdef1ffff]
[    0.218371] pci 0000:00:19.0: reg 0x14: [mem 0xdef3d000-0xdef3dfff]
[    0.218377] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    0.218425] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.218448] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.218555] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    0.218571] pci 0000:00:1a.0: reg 0x10: [mem 0xdef3c000-0xdef3c3ff]
[    0.218645] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.218676] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.218782] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    0.218793] pci 0000:00:1b.0: reg 0x10: [mem 0xdef30000-0xdef33fff 64bit]
[    0.218849] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.218873] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.218976] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.219036] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.219062] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.219169] pci 0000:00:1c.4: [8086:8c18] type 01 class 0x060400
[    0.219222] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.219247] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.219349] pci 0000:00:1c.6: [8086:8c1c] type 01 class 0x060400
[    0.219402] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.219427] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    0.219535] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    0.219551] pci 0000:00:1d.0: reg 0x10: [mem 0xdef3b000-0xdef3b3ff]
[    0.219624] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.219656] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.219762] pci 0000:00:1f.0: [8086:8c44] type 00 class 0x060100
[    0.219888] pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
[    0.219900] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    0.219905] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    0.219911] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    0.219916] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    0.219921] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.219926] pci 0000:00:1f.2: reg 0x24: [mem 0xdef3a000-0xdef3a7ff]
[    0.219955] pci 0000:00:1f.2: PME# supported from D3hot
[    0.219993] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.220004] pci 0000:00:1f.3: reg 0x10: [mem 0xdef39000-0xdef390ff 64bit]
[    0.220020] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.220094] pci 0000:01:00.0: [10b5:8747] type 01 class 0x060400
[    0.220101] pci 0000:01:00.0: reg 0x10: [mem 0xdee00000-0xdee3ffff]
[    0.220148] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.220161] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.222173] pci 0000:00:01.0: PCI bridge to [bus 01-04]
[    0.222257] pci 0000:00:01.0:   bridge window [mem 0xdee00000-0xdeefffff]
[    0.222298] pci 0000:02:08.0: [10b5:8747] type 01 class 0x060400
[    0.222349] pci 0000:02:08.0: PME# supported from D0 D3hot D3cold
[    0.222383] pci 0000:02:10.0: [10b5:8747] type 01 class 0x060400
[    0.222434] pci 0000:02:10.0: PME# supported from D0 D3hot D3cold
[    0.222465] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    0.222579] pci 0000:02:08.0: PCI bridge to [bus 03]
[    0.270765] pci 0000:02:10.0: PCI bridge to [bus 04]
[    0.270909] acpiphp: Slot [1] registered
[    0.270992] pci 0000:00:1c.0: PCI bridge to [bus 05-6f]
[    0.271077] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xde0fffff]
[    0.271081] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0xb9ffffff 64bit pref]
[    0.271140] pci 0000:70:00.0: [1b4b:9230] type 00 class 0x010601
[    0.271151] pci 0000:70:00.0: reg 0x10: [io  0xe050-0xe057]
[    0.271159] pci 0000:70:00.0: reg 0x14: [io  0xe040-0xe043]
[    0.271167] pci 0000:70:00.0: reg 0x18: [io  0xe030-0xe037]
[    0.271175] pci 0000:70:00.0: reg 0x1c: [io  0xe020-0xe023]
[    0.271183] pci 0000:70:00.0: reg 0x20: [io  0xe000-0xe01f]
[    0.271191] pci 0000:70:00.0: reg 0x24: [mem 0xded10000-0xded107ff]
[    0.271199] pci 0000:70:00.0: reg 0x30: [mem 0xded00000-0xded0ffff pref]
[    0.271244] pci 0000:70:00.0: PME# supported from D3hot
[    0.271263] pci 0000:70:00.0: System wakeup disabled by ACPI
[    0.272795] pci 0000:00:1c.4: PCI bridge to [bus 70]
[    0.272879] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.272881] pci 0000:00:1c.4:   bridge window [mem 0xded00000-0xdedfffff]
[    0.272944] pci 0000:71:00.0: [10b5:8605] type 01 class 0x060400
[    0.272960] pci 0000:71:00.0: reg 0x10: [mem 0xdec00000-0xdec03fff]
[    0.273084] pci 0000:71:00.0: supports D1 D2
[    0.273085] pci 0000:71:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.273114] pci 0000:71:00.0: System wakeup disabled by ACPI
[    0.274798] pci 0000:00:1c.6: PCI bridge to [bus 71-75]
[    0.274882] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
[    0.274884] pci 0000:00:1c.6:   bridge window [mem 0xde800000-0xdecfffff]
[    0.274970] pci 0000:72:01.0: [10b5:8605] type 01 class 0x060400
[    0.275108] pci 0000:72:01.0: supports D1 D2
[    0.275109] pci 0000:72:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.275167] pci 0000:72:02.0: [10b5:8605] type 01 class 0x060400
[    0.275305] pci 0000:72:02.0: supports D1 D2
[    0.275305] pci 0000:72:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.275363] pci 0000:72:03.0: [10b5:8605] type 01 class 0x060400
[    0.275501] pci 0000:72:03.0: supports D1 D2
[    0.275501] pci 0000:72:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.275580] pci 0000:71:00.0: PCI bridge to [bus 72-75]
[    0.275669] pci 0000:71:00.0:   bridge window [io  0xd000-0xdfff]
[    0.275673] pci 0000:71:00.0:   bridge window [mem 0xde800000-0xdebfffff]
[    0.275741] pci 0000:72:01.0: PCI bridge to [bus 73]
[    0.275937] pci 0000:74:00.0: [8086:08b1] type 00 class 0x028000
[    0.275981] pci 0000:74:00.0: reg 0x10: [mem 0xdeb00000-0xdeb01fff 64bit]
[    0.276231] pci 0000:74:00.0: PME# supported from D0 D3hot D3cold
[    0.277845] pci 0000:72:02.0: PCI bridge to [bus 74]
[    0.277936] pci 0000:72:02.0:   bridge window [mem 0xdeb00000-0xdebfffff]
[    0.278041] pci 0000:75:00.0: [8086:1533] type 00 class 0x020000
[    0.278068] pci 0000:75:00.0: reg 0x10: [mem 0xde900000-0xde9fffff]
[    0.278104] pci 0000:75:00.0: reg 0x18: [io  0xd000-0xd01f]
[    0.278123] pci 0000:75:00.0: reg 0x1c: [mem 0xdea00000-0xdea03fff]
[    0.278177] pci 0000:75:00.0: reg 0x30: [mem 0xde800000-0xde8fffff pref]
[    0.278303] pci 0000:75:00.0: PME# supported from D0 D3hot D3cold
[    0.279840] pci 0000:72:03.0: PCI bridge to [bus 75]
[    0.279928] pci 0000:72:03.0:   bridge window [io  0xd000-0xdfff]
[    0.279932] pci 0000:72:03.0:   bridge window [mem 0xde800000-0xdeafffff]
[    0.280003] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.280426] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.280832] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.281233] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.281635] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.282038] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.282439] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.282944] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.283344] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.283838] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.284020] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.284156] vgaarb: loaded
[    0.284234] vgaarb: bridge control possible 0000:00:02.0
[    0.284347] SCSI subsystem initialized
[    0.284448] libata version 3.00 loaded.
[    0.284462] ACPI: bus type USB registered
[    0.284551] usbcore: registered new interface driver usbfs
[    0.284638] usbcore: registered new interface driver hub
[    0.284729] usbcore: registered new device driver usb
[    0.284846] PCI: Using ACPI for IRQ routing
[    0.290125] PCI: pci_cache_line_size set to 64 bytes
[    0.290181] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.290182] e820: reserve RAM buffer [mem 0x5573f000-0x57ffffff]
[    0.290183] e820: reserve RAM buffer [mem 0x567b0000-0x57ffffff]
[    0.290184] e820: reserve RAM buffer [mem 0x69b33000-0x6bffffff]
[    0.290184] e820: reserve RAM buffer [mem 0x69d88000-0x6bffffff]
[    0.290185] e820: reserve RAM buffer [mem 0x6b000000-0x6bffffff]
[    0.290186] e820: reserve RAM buffer [mem 0x48f600000-0x48fffffff]
[    0.290234] NetLabel: Initializing
[    0.290314] NetLabel:  domain hash size = 128
[    0.290395] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.290484] NetLabel:  unlabeled traffic allowed by default
[    0.290589] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.290915] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.293013] Switched to clocksource hpet
[    0.296346] pnp: PnP ACPI init
[    0.296432] ACPI: bus type PNP registered
[    0.296554] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.296640] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.296646] pnp 00:01: [dma 4]
[    0.296655] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.296665] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.296715] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.296780] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.296865] system 00:04: [io  0xffff] has been reserved
[    0.296948] system 00:04: [io  0xffff] has been reserved
[    0.297035] system 00:04: [io  0xffff] has been reserved
[    0.297118] system 00:04: [io  0x1c00-0x1cfe] has been reserved
[    0.297202] system 00:04: [io  0x1d00-0x1dfe] has been reserved
[    0.297285] system 00:04: [io  0x1e00-0x1efe] has been reserved
[    0.297369] system 00:04: [io  0x1f00-0x1ffe] has been reserved
[    0.297453] system 00:04: [io  0x1800-0x18fe] could not be reserved
[    0.297537] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.297622] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.297638] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.297664] system 00:06: [io  0x1854-0x1857] has been reserved
[    0.297749] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.297815] system 00:07: [io  0x0a00-0x0a0f] has been reserved
[    0.297899] system 00:07: [io  0x0a30-0x0a3f] has been reserved
[    0.299411] system 00:07: [io  0x0a20-0x0a2f] has been reserved
[    0.299495] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.299631] pnp 00:08: [dma 0 disabled]
[    0.299655] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.299684] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.299768] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.299782] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.300021] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.300107] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.300192] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.300277] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.300362] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
[    0.300447] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.300531] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.300616] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.300701] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    0.300788] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.300873] system 00:0b: [mem 0xdffef000-0xdffeffff] has been reserved
[    0.300958] system 00:0b: [mem 0xdfff0000-0xdfff0fff] has been reserved
[    0.301046] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.301176] pnp: PnP ACPI: found 12 devices
[    0.301257] ACPI: bus type PNP unregistered
[    0.306943] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 05-6f] add_size 1000
[    0.306958] pci 0000:72:01.0: bridge window [io  0x1000-0x0fff] to [bus 73] add_size 1000
[    0.306960] pci 0000:72:01.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 73] add_size 200000
[    0.306961] pci 0000:72:01.0: bridge window [mem 0x00100000-0x000fffff] to [bus 73] add_size 200000
[    0.306990] pci 0000:72:01.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.306991] pci 0000:71:00.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 72-75] add_size 200000
[    0.306996] pci 0000:71:00.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.306997] pci 0000:00:1c.6: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 71-75] add_size 200000
[    0.307002] pci 0000:00:1c.6: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.307003] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.307008] pci 0000:00:1c.6: BAR 15: assigned [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.307142] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.307226] pci 0000:02:08.0: PCI bridge to [bus 03]
[    0.307314] pci 0000:02:10.0: PCI bridge to [bus 04]
[    0.307401] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    0.307489] pci 0000:00:01.0: PCI bridge to [bus 01-04]
[    0.307572] pci 0000:00:01.0:   bridge window [mem 0xdee00000-0xdeefffff]
[    0.307659] pci 0000:00:1c.0: PCI bridge to [bus 05-6f]
[    0.307742] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.307829] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xde0fffff]
[    0.307916] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0xb9ffffff 64bit pref]
[    0.308055] pci 0000:00:1c.4: PCI bridge to [bus 70]
[    0.308138] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.308224] pci 0000:00:1c.4:   bridge window [mem 0xded00000-0xdedfffff]
[    0.308313] pci 0000:71:00.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.308315] pci 0000:71:00.0: BAR 15: assigned [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.308449] pci 0000:72:01.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.308450] pci 0000:72:01.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.308451] pci 0000:72:01.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.308452] pci 0000:72:01.0: BAR 14: can't assign mem (size 0x200000)
[    0.308537] pci 0000:72:01.0: BAR 15: assigned [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.308671] pci 0000:72:01.0: BAR 13: can't assign io (size 0x1000)
[    0.308756] pci 0000:72:01.0: BAR 14: can't assign mem (size 0x200000)
[    0.308840] pci 0000:72:01.0: BAR 13: can't assign io (size 0x1000)
[    0.308925] pci 0000:72:01.0: PCI bridge to [bus 73]
[    0.309017] pci 0000:72:01.0:   bridge window [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.309157] pci 0000:72:02.0: PCI bridge to [bus 74]
[    0.309244] pci 0000:72:02.0:   bridge window [mem 0xdeb00000-0xdebfffff]
[    0.309338] pci 0000:72:03.0: PCI bridge to [bus 75]
[    0.309422] pci 0000:72:03.0:   bridge window [io  0xd000-0xdfff]
[    0.309510] pci 0000:72:03.0:   bridge window [mem 0xde800000-0xdeafffff]
[    0.309605] pci 0000:71:00.0: PCI bridge to [bus 72-75]
[    0.309689] pci 0000:71:00.0:   bridge window [io  0xd000-0xdfff]
[    0.309777] pci 0000:71:00.0:   bridge window [mem 0xde800000-0xdebfffff]
[    0.309865] pci 0000:71:00.0:   bridge window [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.310008] pci 0000:00:1c.6: PCI bridge to [bus 71-75]
[    0.310091] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
[    0.310177] pci 0000:00:1c.6:   bridge window [mem 0xde800000-0xdecfffff]
[    0.310263] pci 0000:00:1c.6:   bridge window [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.310400] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.310401] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.310402] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.310402] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.310403] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.310404] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff]
[    0.310405] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000e3fff]
[    0.310406] pci_bus 0000:00: resource 11 [mem 0x000e4000-0x000e7fff]
[    0.310406] pci_bus 0000:00: resource 12 [mem 0x6fa00000-0xfeafffff]
[    0.310407] pci_bus 0000:01: resource 1 [mem 0xdee00000-0xdeefffff]
[    0.310408] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.310409] pci_bus 0000:05: resource 1 [mem 0xc0000000-0xde0fffff]
[    0.310410] pci_bus 0000:05: resource 2 [mem 0x80000000-0xb9ffffff 64bit pref]
[    0.310411] pci_bus 0000:70: resource 0 [io  0xe000-0xefff]
[    0.310412] pci_bus 0000:70: resource 1 [mem 0xded00000-0xdedfffff]
[    0.310412] pci_bus 0000:71: resource 0 [io  0xd000-0xdfff]
[    0.310413] pci_bus 0000:71: resource 1 [mem 0xde800000-0xdecfffff]
[    0.310414] pci_bus 0000:71: resource 2 [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.310415] pci_bus 0000:72: resource 0 [io  0xd000-0xdfff]
[    0.310416] pci_bus 0000:72: resource 1 [mem 0xde800000-0xdebfffff]
[    0.310416] pci_bus 0000:72: resource 2 [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.310417] pci_bus 0000:73: resource 2 [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.310418] pci_bus 0000:74: resource 1 [mem 0xdeb00000-0xdebfffff]
[    0.310419] pci_bus 0000:75: resource 0 [io  0xd000-0xdfff]
[    0.310420] pci_bus 0000:75: resource 1 [mem 0xde800000-0xdeafffff]
[    0.310434] NET: Registered protocol family 2
[    0.310628] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.310897] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.311077] TCP: Hash tables configured (established 131072 bind 65536)
[    0.311170] TCP: reno registered
[    0.311261] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.311378] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.311513] NET: Registered protocol family 1
[    0.311601] pci 0000:00:02.0: Boot video device
[    0.326045] PCI: CLS mismatch (64 != 128), using 64 bytes
[    0.341055] Unpacking initramfs...
[    0.636616] Freeing initrd memory: 30848K (ffff8800343b0000 - ffff8800361d0000)
[    0.636761] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.636847] software IO TLB [mem 0x65b33000-0x69b33000] (64MB) mapped at [ffff880065b33000-ffff880069b32fff]
[    0.637202] RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
[    0.637626] AVX2 version of gcm_enc/dec engaged.
[    0.638876] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.639167] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.639266] Initialise system trusted keyring
[    0.639353] audit: initializing netlink subsys (disabled)
[    0.639445] audit: type=2000 audit(1401173159.562:1): initialized
[    0.653477] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.654300] zbud: loaded
[    0.654466] VFS: Disk quotas dquot_6.5.2
[    0.654564] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.654830] msgmni has been set to 31859
[    0.654937] Key type big_key registered
[    0.655017] SELinux:  Registering netfilter hooks
[    0.655594] alg: No test for stdrng (krng)
[    0.655679] NET: Registered protocol family 38
[    0.655774] Key type asymmetric registered
[    0.655855] Asymmetric key parser 'x509' registered
[    0.655953] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.656111] io scheduler noop registered
[    0.656192] io scheduler deadline registered
[    0.656287] io scheduler cfq registered (default)
[    0.656476] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.656717] pcieport 0000:01:00.0: irq 41 for MSI/MSI-X
[    0.656798] pcieport 0000:02:08.0: irq 42 for MSI/MSI-X
[    0.656876] pcieport 0000:02:10.0: irq 43 for MSI/MSI-X
[    0.656979] pcieport 0000:71:00.0: irq 44 for MSI/MSI-X
[    0.657121] pcieport 0000:72:01.0: irq 45 for MSI/MSI-X
[    0.657264] pcieport 0000:72:02.0: irq 46 for MSI/MSI-X
[    0.657406] pcieport 0000:72:03.0: irq 47 for MSI/MSI-X
[    0.657511] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.657602] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.657717] intel_idle: MWAIT substates: 0x42120
[    0.657718] intel_idle: v0.4 model 0x3C
[    0.657719] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.657923] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.658059] ACPI: Power Button [PWRB]
[    0.658158] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.658292] ACPI: Power Button [PWRF]
[    0.658405] ACPI: Fan [FAN0] (off)
[    0.658499] ACPI: Fan [FAN1] (off)
[    0.658591] ACPI: Fan [FAN2] (off)
[    0.658684] ACPI: Fan [FAN3] (off)
[    0.658795] ACPI: Fan [FAN4] (off)
[    0.659158] thermal LNXTHERM:00: registered as thermal_zone0
[    0.659242] ACPI: Thermal Zone [TZ00] (28 C)
[    0.659433] thermal LNXTHERM:01: registered as thermal_zone1
[    0.659516] ACPI: Thermal Zone [TZ01] (30 C)
[    0.659610] GHES: HEST is not enabled!
[    0.659729] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.680310] 00:08: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.680675] Non-volatile memory driver v1.3
[    0.680773] Linux agpgart interface v0.103
[    0.680925] ahci 0000:00:1f.2: version 3.0
[    0.680980] ahci 0000:00:1f.2: irq 48 for MSI/MSI-X
[    0.681011] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x29 impl SATA mode
[    0.681146] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part ems apst 
[    0.685008] scsi0 : ahci
[    0.685222] scsi1 : ahci
[    0.685522] scsi2 : ahci
[    0.685822] scsi3 : ahci
[    0.686122] scsi4 : ahci
[    0.686383] scsi5 : ahci
[    0.686497] ata1: SATA max UDMA/133 abar m2048@0xdef3a000 port 0xdef3a100 irq 48
[    0.686630] ata2: DUMMY
[    0.686715] ata3: DUMMY
[    0.686793] ata4: SATA max UDMA/133 abar m2048@0xdef3a000 port 0xdef3a280 irq 48
[    0.686925] ata5: DUMMY
[    0.687003] ata6: SATA max UDMA/133 abar m2048@0xdef3a000 port 0xdef3a380 irq 48
[    0.687204] ahci 0000:70:00.0: controller can do FBS, turning on CAP_FBS
[    0.687394] ahci 0000:70:00.0: irq 49 for MSI/MSI-X
[    0.697720] ahci 0000:70:00.0: AHCI 0001.0200 32 slots 8 ports 6 Gbps 0xff impl SATA mode
[    0.697854] ahci 0000:70:00.0: flags: 64bit ncq fbs pio 
[    0.698500] scsi6 : ahci
[    0.698779] scsi7 : ahci
[    0.699104] scsi8 : ahci
[    0.699420] scsi9 : ahci
[    0.699687] scsi10 : ahci
[    0.699965] scsi11 : ahci
[    0.700220] scsi12 : ahci
[    0.700476] scsi13 : ahci
[    0.700574] ata7: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10100 irq 49
[    0.700712] ata8: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10180 irq 49
[    0.700845] ata9: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10200 irq 49
[    0.700978] ata10: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10280 irq 49
[    0.701111] ata11: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10300 irq 49
[    0.701243] ata12: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10380 irq 49
[    0.701376] ata13: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10400 irq 49
[    0.701509] ata14: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10480 irq 49
[    0.701689] libphy: Fixed MDIO Bus: probed
[    0.702031] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.702291] ehci-pci: EHCI PCI platform driver
[    0.702487] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.702605] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.702750] ehci-pci 0000:00:1a.0: debug port 2
[    0.706727] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.706735] ehci-pci 0000:00:1a.0: irq 16, io mem 0xdef3c000
[    0.712684] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.712802] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.712897] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.713029] usb usb1: Product: EHCI Host Controller
[    0.713111] usb usb1: Manufacturer: Linux 3.15.0-rc7+ ehci_hcd
[    0.714608] usb usb1: SerialNumber: 0000:00:1a.0
[    0.714804] hub 1-0:1.0: USB hub found
[    0.714887] hub 1-0:1.0: 2 ports detected
[    0.715077] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.715183] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.715323] ehci-pci 0000:00:1d.0: debug port 2
[    0.719289] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.719298] ehci-pci 0000:00:1d.0: irq 23, io mem 0xdef3b000
[    0.724674] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.724787] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.724882] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.725014] usb usb2: Product: EHCI Host Controller
[    0.725095] usb usb2: Manufacturer: Linux 3.15.0-rc7+ ehci_hcd
[    0.725178] usb usb2: SerialNumber: 0000:00:1d.0
[    0.725320] hub 2-0:1.0: USB hub found
[    0.725402] hub 2-0:1.0: 2 ports detected
[    0.725543] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.725628] ohci-pci: OHCI PCI platform driver
[    0.725721] uhci_hcd: USB Universal Host Controller Interface driver
[    0.725868] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.725974] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    0.726173] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.726183] xhci_hcd 0000:00:14.0: irq 50 for MSI/MSI-X
[    0.726218] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.726302] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.726435] usb usb3: Product: xHCI Host Controller
[    0.726516] usb usb3: Manufacturer: Linux 3.15.0-rc7+ xhci_hcd
[    0.726599] usb usb3: SerialNumber: 0000:00:14.0
[    0.726739] hub 3-0:1.0: USB hub found
[    0.726831] hub 3-0:1.0: 14 ports detected
[    0.728269] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.728370] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    0.728525] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    0.728610] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.728749] usb usb4: Product: xHCI Host Controller
[    0.728830] usb usb4: Manufacturer: Linux 3.15.0-rc7+ xhci_hcd
[    0.728913] usb usb4: SerialNumber: 0000:00:14.0
[    0.729044] hub 4-0:1.0: USB hub found
[    0.729132] hub 4-0:1.0: 6 ports detected
[    0.729832] usbcore: registered new interface driver usbserial
[    0.729918] usbcore: registered new interface driver usbserial_generic
[    0.730004] usbserial: USB Serial support registered for generic
[    0.730101] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.730565] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.730658] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.730788] mousedev: PS/2 mouse device common for all mice
[    0.731046] rtc_cmos 00:05: RTC can wake from S4
[    0.731238] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.731342] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.731508] device-mapper: uevent: version 1.0.3
[    0.731621] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    0.731866] Intel P-state driver initializing.
[    0.731981] Intel pstate controlling: cpu 0
[    0.732069] Intel pstate controlling: cpu 1
[    0.732155] Intel pstate controlling: cpu 2
[    0.732241] Intel pstate controlling: cpu 3
[    0.732327] Intel pstate controlling: cpu 4
[    0.732412] Intel pstate controlling: cpu 5
[    0.732498] Intel pstate controlling: cpu 6
[    0.732584] Intel pstate controlling: cpu 7
[    0.732850] hidraw: raw HID events driver (C) Jiri Kosina
[    0.732977] usbcore: registered new interface driver usbhid
[    0.733059] usbhid: USB HID core driver
[    0.733149] drop_monitor: Initializing network drop monitor service
[    0.733266] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.733406] TCP: cubic registered
[    0.733510] Initializing XFRM netlink socket
[    0.733646] NET: Registered protocol family 10
[    0.733923] mip6: Mobile IPv6
[    0.734003] NET: Registered protocol family 17
[    0.734456] Loading compiled-in X.509 certificates
[    0.734991] Loaded X.509 cert 'Magrathea: Glacier signing key: fb8370f3759ac052fa9fffe28c75a517f71b2f24'
[    0.735130] registered taskstats version 1
[    0.735846]   Magic number: 14:891:772
[    0.736055] rtc_cmos 00:05: setting system clock to 2014-05-27 06:46:00 UTC (1401173160)
[    0.736246] PM: Hibernation image not present or could not be loaded.
[    0.991489] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.992034] ata1.00: ATA-9: INTEL SSDSC2BB480G4, D2010370, max UDMA/133
[    0.992183] ata1.00: 937703088 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    0.992451] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.992622] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.993044] ata1.00: configured for UDMA/133
[    0.993461] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSC2BB48 D201 PQ: 0 ANSI: 5
[    0.994068] ata4.00: ATA-8: WDC WD5000AAKX-753CA0, 15.01H15, max UDMA/133
[    0.994221] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.994345] sd 0:0:0:0: [sda] 937703088 512-byte logical blocks: (480 GB/447 GiB)
[    0.994349] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.994351] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    0.994826] sd 0:0:0:0: [sda] Write Protect is off
[    0.994831] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.994913] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.995837]  sda: sda1 sda2
[    0.996246] ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.996255] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    0.996540] ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    0.996773] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.997251] ata4.00: configured for UDMA/133
[    0.997566] scsi 3:0:0:0: Direct-Access     ATA      WDC WD5000AAKX-7 15.0 PQ: 0 ANSI: 5
[    0.998149] sd 3:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    0.998165] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    0.998478] ata6.00: ATAPI: ATAPI   iHAS124   W, HL0G, max UDMA/100
[    0.999044] sd 3:0:0:0: [sdb] Write Protect is off
[    0.999190] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.999329] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.001392] ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.001400] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.001645] ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.003420] ata6.00: configured for UDMA/100
[    1.004798] scsi 5:0:0:0: CD-ROM            ATAPI    iHAS124   W      HL0G PQ: 0 ANSI: 5
[    1.006483] ata13: SATA link down (SStatus 0 SControl 300)
[    1.008485] ata10: SATA link down (SStatus 0 SControl 300)
[    1.008667] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.008844] ata9: SATA link down (SStatus 0 SControl 300)
[    1.009032] ata8: SATA link down (SStatus 0 SControl 300)
[    1.009212] ata12: SATA link down (SStatus 0 SControl 300)
[    1.009391] ata11: SATA link down (SStatus 0 SControl 300)
[    1.009574] ata7: SATA link down (SStatus 0 SControl 300)
[    1.009740] ata14.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
[    1.010036] ata14.00: configured for UDMA/66
[    1.016510] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.029047] sr0: scsi3-mmc drive: 188x/125x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.029282] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.029748] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    1.029955] sr 5:0:0:0: Attached scsi generic sg2 type 5
[    1.030787] scsi 13:0:0:0: Processor         Marvell  Console          1.01 PQ: 0 ANSI: 5
[    1.038226]  sdb: sdb1 sdb2 < sdb5 sdb6 >
[    1.039331] sd 3:0:0:0: [sdb] Attached SCSI disk
[    1.042441] ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[    1.042589] ata14.00: irq_stat 0x40000001
[    1.042726] scsi 13:0:0:0: CDB: 
[    1.042858] Inquiry: 12 01 00 00 ff 00
[    1.043295] ata14.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 3 dma 16640 in
         res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)
[    1.043730] ata14: hard resetting link
[    1.130799] usb 1-1: New USB device found, idVendor=8087, idProduct=8008
[    1.130949] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.131480] hub 1-1:1.0: USB hub found
[    1.131768] hub 1-1:1.0: 6 ports detected
[    1.235310] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.349614] usb 2-1: New USB device found, idVendor=8087, idProduct=8000
[    1.349763] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.350194] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.350297] hub 2-1:1.0: USB hub found
[    1.350484] hub 2-1:1.0: 8 ports detected
[    1.350876] ata14.00: configured for UDMA/66
[    1.351148] ata14: EH complete
[    1.351584] scsi 13:0:0:0: Attached scsi generic sg3 type 3
[    1.354049] Freeing unused kernel memory: 1412K (ffffffff81d0b000 - ffffffff81e6c000)
[    1.354293] Write protecting the kernel read-only data: 12288k
[    1.362729] Freeing unused kernel memory: 1324K (ffff8800016b5000 - ffff880001800000)
[    1.368742] Freeing unused kernel memory: 1088K (ffff880001af0000 - ffff880001c00000)
[    1.373943] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    1.374601] systemd[1]: Running in initial RAM disk.
[    1.375400] systemd[1]: Set hostname to <lahna>.
[    1.376580] random: systemd urandom read with 88 bits of entropy available
[    1.437763] systemd[1]: Expecting device dev-mapper-fedora\x2droot.device...
[    1.440740] systemd[1]: Starting -.slice.
[    1.441799] systemd[1]: Created slice -.slice.
[    1.441956] systemd[1]: Starting System Slice.
[    1.442621] systemd[1]: Created slice System Slice.
[    1.442770] systemd[1]: Starting Slices.
[    1.443264] systemd[1]: Reached target Slices.
[    1.443406] systemd[1]: Starting Timers.
[    1.443886] systemd[1]: Reached target Timers.
[    1.444042] systemd[1]: Starting udev Kernel Socket.
[    1.444566] systemd[1]: Listening on udev Kernel Socket.
[    1.444718] systemd[1]: Starting udev Control Socket.
[    1.445260] systemd[1]: Listening on udev Control Socket.
[    1.445409] systemd[1]: Starting Journal Socket.
[    1.445961] systemd[1]: Listening on Journal Socket.
[    1.446313] systemd[1]: Starting dracut cmdline hook...
[    1.447344] systemd[1]: Starting Apply Kernel Variables...
[    1.448435] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    1.449529] systemd[1]: Starting Sockets.
[    1.450053] systemd[1]: Reached target Sockets.
[    1.450214] systemd[1]: Starting Setup Virtual Console...
[    1.451168] systemd[1]: Starting Journal Service...
[    1.452824] systemd[1]: Started Journal Service.
[    1.505027] usb 3-9: new high-speed USB device number 2 using xhci_hcd
[    1.637913] tsc: Refined TSC clocksource calibration: 3491.913 MHz
[    1.669086] usb 3-9: New USB device found, idVendor=045b, idProduct=0209
[    1.669248] usb 3-9: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.669987] hub 3-9:1.0: USB hub found
[    1.670170] hub 3-9:1.0: 4 ports detected
[    1.688578] systemd-udevd[318]: starting version 208
[    1.752680] pps_core: LinuxPPS API ver. 1 registered
[    1.752803] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.758929] PTP clock support registered
[    1.768688] dca service started, version 1.12.1
[    1.793123] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    1.793214] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    1.793429] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.793588] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[    1.812598] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    1.812688] igb: Copyright (c) 2007-2014 Intel Corporation.
[    1.819419] random: nonblocking pool is initialized
[    1.823788] usb 3-10: new high-speed USB device number 3 using xhci_hcd
[    1.834614] [drm] Initialized drm 1.1.0 20060810
[    1.921433] igb 0000:75:00.0: irq 52 for MSI/MSI-X
[    1.921437] igb 0000:75:00.0: irq 53 for MSI/MSI-X
[    1.921439] igb 0000:75:00.0: irq 54 for MSI/MSI-X
[    1.921440] igb 0000:75:00.0: irq 55 for MSI/MSI-X
[    1.921442] igb 0000:75:00.0: irq 56 for MSI/MSI-X
[    1.951170] igb 0000:75:00.0: added PHC on eth0
[    1.951273] igb 0000:75:00.0: Intel(R) Gigabit Ethernet Network Connection
[    1.951371] igb 0000:75:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 74:d4:35:1b:fc:39
[    1.951535] igb 0000:75:00.0: eth0: PBA No: 000200-000
[    1.951642] igb 0000:75:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    1.955271] e1000e 0000:00:19.0 eth1: registered PHC clock
[    1.956125] e1000e 0000:00:19.0 eth1: (PCI Express:2.5GT/s:Width x1) 74:d4:35:1b:fc:26
[    1.957605] e1000e 0000:00:19.0 eth1: Intel(R) PRO/1000 Network Connection
[    1.957922] e1000e 0000:00:19.0 eth1: MAC: 11, PHY: 12, PBA No: FFFFFF-0FF
[    1.958663] [drm] Memory usable by graphics device = 2048M
[    1.987669] i915 0000:00:02.0: irq 57 for MSI/MSI-X
[    1.987677] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.987695] systemd-udevd[327]: renamed network interface eth0 to p4p1
[    1.987874] [drm] Driver supports precise vblank timestamp query.
[    1.987992] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.989776] usb 3-10: New USB device found, idVendor=045b, idProduct=0209
[    1.990652] usb 3-10: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.992756] hub 3-10:1.0: USB hub found
[    1.992862] hub 3-10:1.0: 4 ports detected
[    1.993721] systemd-udevd[323]: renamed network interface eth1 to em1
[    2.038498] fbcon: inteldrmfb (fb0) is primary device
[    2.088814] Console: switching to colour frame buffer device 240x75
[    2.094942] usb 4-5: new SuperSpeed USB device number 2 using xhci_hcd
[    2.101286] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    2.101289] i915 0000:00:02.0: registered panic notifier
[    2.107215] usb 4-5: New USB device found, idVendor=045b, idProduct=0210
[    2.107293] usb 4-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.108066] hub 4-5:1.0: USB hub found
[    2.108380] hub 4-5:1.0: 4 ports detected
[    2.112454] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.113553] acpi device:70: registered as cooling_device13
[    2.113792] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    2.114103] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.212692] usb 4-6: new SuperSpeed USB device number 3 using xhci_hcd
[    2.224862] usb 4-6: New USB device found, idVendor=045b, idProduct=0210
[    2.224910] usb 4-6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.225507] hub 4-6:1.0: USB hub found
[    2.225778] hub 4-6:1.0: 4 ports detected
[    2.300374] usb 3-10.1: new low-speed USB device number 4 using xhci_hcd
[    2.391838] usb 3-10.1: New USB device found, idVendor=046d, idProduct=c52a
[    2.391848] usb 3-10.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.391867] usb 3-10.1: Product: 2.4GHz Cordless Desktop
[    2.391871] usb 3-10.1: Manufacturer: Logitech
[    2.392149] usb 3-10.1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    2.392156] usb 3-10.1: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
[    2.397830] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.1/3-10.1:1.0/0003:046D:C52A.0001/input/input6
[    2.398057] hid-generic 0003:046D:C52A.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:14.0-10.1/input0
[    2.406688] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.1/3-10.1:1.1/0003:046D:C52A.0002/input/input7
[    2.407274] hid-generic 0003:046D:C52A.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:14.0-10.1/input1
[    2.480296] usb 3-10.2: new high-speed USB device number 5 using xhci_hcd
[    2.562913] PM: Starting manual resume from disk
[    2.562925] PM: Hibernation image partition 253:0 present
[    2.562928] PM: Looking for hibernation image.
[    2.563151] PM: Image not found (code -22)
[    2.563154] PM: Hibernation image not present or could not be loaded.
[    2.564341] usb 3-10.2: New USB device found, idVendor=0409, idProduct=005a
[    2.564351] usb 3-10.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.565014] hub 3-10.2:1.0: USB hub found
[    2.565055] hub 3-10.2:1.0: 4 ports detected
[    2.579912] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[    2.637294] Switched to clocksource tsc
[    2.890314] systemd-journald[175]: Received SIGTERM
[    2.892499] systemd-cgroups-agent[527]: Failed to get D-Bus connection: Failed to connect to socket /run/systemd/private: No such file or directory
[    2.958113] audit: type=1404 audit(1401173162.722:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    2.995655] SELinux: 2048 avtab hash slots, 100018 rules.
[    3.030521] SELinux: 2048 avtab hash slots, 100018 rules.
[    3.071880] SELinux:  8 users, 86 roles, 4805 types, 281 bools, 1 sens, 1024 cats
[    3.071884] SELinux:  83 classes, 100018 rules
[    3.077684] SELinux:  Completing initialization.
[    3.077686] SELinux:  Setting up existing superblocks.
[    3.077695] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    3.077705] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    3.077712] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    3.077745] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.077809] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    3.079134] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    3.080334] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    3.080337] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    3.080342] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    3.080345] SELinux: initialized (dev aio, type aio), not configured for labeling
[    3.080348] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    3.080371] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    3.080381] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    3.080392] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    3.080408] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    3.081028] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    3.081030] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.081042] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.081191] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.081241] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.081246] SELinux: initialized (dev pstore, type pstore), uses genfs_contexts
[    3.081248] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.081251] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.081253] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.081261] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.081265] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.081267] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.081270] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.081277] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.081280] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    3.081283] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[    3.081286] SELinux: initialized (dev drm, type drm), not configured for labeling
[    3.081294] SELinux: initialized (dev dm-1, type ext4), uses xattr
[    3.098845] audit: type=1403 audit(1401173162.863:3): policy loaded auid=4294967295 ses=4294967295
[    3.111336] systemd[1]: Successfully loaded SELinux policy in 154.865ms.
[    3.183001] systemd[1]: Relabelled /dev and /run in 42.870ms.
[    3.372121] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    3.378215] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.415677] systemd-udevd[577]: starting version 208
[    3.419012] EXT4-fs (dm-1): re-mounted. Opts: (null)
[    3.450697] wmi: Mapper loaded
[    3.473732] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.488524] mei_me 0000:00:16.0: irq 58 for MSI/MSI-X
[    3.499329] i801_smbus 0000:00:1f.3: enabling device (0001 -> 0003)
[    3.499394] ACPI Warning: SystemIO range 0x000000000000f040-0x000000000000f05f conflicts with OpRegion 0x000000000000f040-0x000000000000f04f (\_SB_.PCI0.SBUS.SMBI) (20140214/utaddress-258)
[    3.499397] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.509393] microcode: CPU0 sig=0x306c3, pf=0x2, revision=0x9
[    3.511602] microcode: CPU0 sig=0x306c3, pf=0x2, revision=0x9
[    3.513043] microcode: CPU0 updated to revision 0x17, date = 2013-08-16
[    3.513120] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x9
[    3.513148] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x9
[    3.513882] microcode: CPU1 updated to revision 0x17, date = 2013-08-16
[    3.513888] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x9
[    3.513910] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x9
[    3.514647] microcode: CPU2 updated to revision 0x17, date = 2013-08-16
[    3.514670] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x9
[    3.514691] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x9
[    3.515429] microcode: CPU3 updated to revision 0x17, date = 2013-08-16
[    3.515522] microcode: CPU4 sig=0x306c3, pf=0x2, revision=0x9
[    3.515544] microcode: CPU4 sig=0x306c3, pf=0x2, revision=0x9
[    3.516276] microcode: CPU4 updated to revision 0x17, date = 2013-08-16
[    3.516282] microcode: CPU5 sig=0x306c3, pf=0x2, revision=0x9
[    3.516353] microcode: CPU5 sig=0x306c3, pf=0x2, revision=0x9
[    3.517086] microcode: CPU5 updated to revision 0x17, date = 2013-08-16
[    3.517149] microcode: CPU6 sig=0x306c3, pf=0x2, revision=0x9
[    3.517169] microcode: CPU6 sig=0x306c3, pf=0x2, revision=0x9
[    3.517906] microcode: CPU6 updated to revision 0x17, date = 2013-08-16
[    3.517985] microcode: CPU7 sig=0x306c3, pf=0x2, revision=0x9
[    3.518008] microcode: CPU7 sig=0x306c3, pf=0x2, revision=0x9
[    3.518755] microcode: CPU7 updated to revision 0x17, date = 2013-08-16
[    3.522067] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.534354] alg: No test for crc32 (crc32-pclmul)
[    3.584501] snd_hda_intel 0000:00:03.0: irq 59 for MSI/MSI-X
[    3.584634] snd_hda_intel 0000:00:1b.0: irq 60 for MSI/MSI-X
[    3.613586] sound hdaudioC1D2: autoconfig: line_outs=3 (0x14/0x15/0x16/0x0/0x0) type:line
[    3.613590] sound hdaudioC1D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    3.613592] sound hdaudioC1D2:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    3.613594] sound hdaudioC1D2:    mono: mono_out=0x0
[    3.613595] sound hdaudioC1D2:    dig-out=0x11/0x1e
[    3.613596] sound hdaudioC1D2:    inputs:
[    3.613598] sound hdaudioC1D2:      Front Mic=0x19
[    3.613600] sound hdaudioC1D2:      Rear Mic=0x18
[    3.613602] sound hdaudioC1D2:      Line=0x1a
[    3.613603] sound hdaudioC1D2:    dig-in=0x1f
[    3.662158] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.663665] SELinux: initialized (dev sda1, type ext4), uses xattr
[    3.699304] iTCO_vendor_support: vendor-support=0
[    3.701553] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    3.701575] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[    3.726880] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input8
[    3.726967] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input9
[    3.727048] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card1/input10
[    3.727127] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card1/input11
[    3.727190] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card1/input12
[    3.727266] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card1/input13
[    3.727318] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input15
[    3.727359] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input14
[    3.727454] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input16
[    3.727514] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input17
[    3.727761] Adding 8200188k swap on /dev/mapper/fedora-swap.  Priority:-1 extents:1 across:8200188k SSFS
[    3.764131] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    4.062919] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[    4.062937] SELinux: initialized (dev dm-2, type ext4), uses xattr
[    4.080903] systemd-journald[567]: Received request to flush runtime journal from PID 1
[    4.091920] audit: type=1305 audit(1401173163.857:4): audit_pid=839 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[    4.359859] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    4.387907] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    4.426896] Ebtables v2.0 registered
[    4.473874] Bridge firewalling registered
[    4.618102] cfg80211: Calling CRDA to update world regulatory domain
[    4.621440] cfg80211: World regulatory domain updated:
[    4.621444] cfg80211:  DFS Master region: unset
[    4.621445] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    4.621447] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    4.621448] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    4.621449] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    4.621451] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    4.621452] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    4.621453] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    4.886075] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[    4.991875] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[    5.091999] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[    5.092093] IPv6: ADDRCONF(NETDEV_UP): em1: link is not ready
[    5.156211] Bluetooth: Core ver 2.19
[    5.156306] NET: Registered protocol family 31
[    5.156307] Bluetooth: HCI device and connection manager initialized
[    5.156314] Bluetooth: HCI socket layer initialized
[    5.156315] Bluetooth: L2CAP socket layer initialized
[    5.156320] Bluetooth: SCO socket layer initialized
[    5.163132] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.163135] Bluetooth: BNEP filters: protocol multicast
[    5.163142] Bluetooth: BNEP socket layer initialized
[   11.245404] e1000e: em1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   11.245451] IPv6: ADDRCONF(NETDEV_CHANGE): em1: link becomes ready
[   14.513307] fuse init (API version 7.23)
[   14.516360] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[   14.536744] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   40.647722] usb 3-10.4: new high-speed USB device number 6 using xhci_hcd
[   40.739451] usb 3-10.4: New USB device found, idVendor=8564, idProduct=1000
[   40.739460] usb 3-10.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   40.739464] usb 3-10.4: Product: Mass Storage Device
[   40.739468] usb 3-10.4: Manufacturer: JetFlash
[   40.739472] usb 3-10.4: SerialNumber: 9EAOZJ51
[   40.810178] usb-storage 3-10.4:1.0: USB Mass Storage device detected
[   40.810341] scsi14 : usb-storage 3-10.4:1.0
[   40.810470] usbcore: registered new interface driver usb-storage
[   41.812457] scsi 14:0:0:0: Direct-Access     JetFlash Transcend 4GB    8.07 PQ: 0 ANSI: 4
[   41.813484] sd 14:0:0:0: Attached scsi generic sg4 type 0
[   41.814129] sd 14:0:0:0: [sdc] 7864320 512-byte logical blocks: (4.02 GB/3.75 GiB)
[   41.814848] sd 14:0:0:0: [sdc] Write Protect is off
[   41.814857] sd 14:0:0:0: [sdc] Mode Sense: 23 00 00 00
[   41.815584] sd 14:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   41.821168]  sdc: sdc1
[   41.823757] sd 14:0:0:0: [sdc] Attached SCSI removable disk
[   47.377730] usb 3-10.4: USB disconnect, device number 6
[   72.188159] BUG: soft lockup - CPU#5 stuck for 23s! [systemd-udevd:1702]
[   72.188162] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw x86_pkg_temp_thermal coretemp iTCO_wdt iTCO_vendor_support mxm_wmi snd_hda_codec_hdmi kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul crc32c_intel snd_seq_device snd_pcm ghash_clmulni_intel microcode serio_raw lpc_ich snd_timer i2c_i801 mfd_core snd mei_me joydev soundcore
[   72.188193]  mei shpchp wmi i915 drm_kms_helper drm igb e1000e dca i2c_algo_bit ptp i2c_core pps_core video
[   72.188201] CPU: 5 PID: 1702 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #4
[   72.188202] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[   72.188204] task: ffff8800648b0950 ti: ffff880475c8c000 task.ti: ffff880475c8c000
[   72.188205] RIP: 0010:[<ffffffff811e7527>]  [<ffffffff811e7527>] dentry_kill+0x77/0x280
[   72.188210] RSP: 0018:ffff880475c8db48  EFLAGS: 00000282
[   72.188211] RAX: 0000000000000000 RBX: ffffffff81246026 RCX: 000000000000dddc
[   72.188212] RDX: ffff8804537fd380 RSI: ffff880475c8dbb8 RDI: ffff88045b46ce00
[   72.188213] RBP: ffff880475c8db68 R08: ffff8804537fd380 R09: 0000000180240022
[   72.188214] R10: ffffffff81246026 R11: ffffea0011cae000 R12: 0000000000000706
[   72.188215] R13: ffff880475c8db38 R14: ffff8804537fd380 R15: 0000000180240022
[   72.188217] FS:  00007f9e78d5b880(0000) GS:ffff88048f340000(0000) knlGS:0000000000000000
[   72.188218] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   72.188219] CR2: 00007f9e79bb7ad8 CR3: 00000004763fe000 CR4: 00000000001407e0
[   72.188220] Stack:
[   72.188221]  ffff88045b46ce00 ffff88045b46cd80 ffff880475c8dbb8 ffff88045b46cdd8
[   72.188223]  ffff880475c8dba0 ffffffff811e793b ffff880475c8dbb8 ffff8804537fd240
[   72.188225]  0000000000000025 ffff880475c8ddd0 0000000000000001 ffff880475c8dbe8
[   72.188226] Call Trace:
[   72.188229]  [<ffffffff811e793b>] shrink_dentry_list+0x8b/0x100
[   72.188231]  [<ffffffff811e81b4>] check_submounts_and_drop+0x74/0xa0
[   72.188234]  [<ffffffff81245c4d>] kernfs_dop_revalidate+0x5d/0xd0
[   72.188236]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[   72.188238]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[   72.188240]  [<ffffffff81245a07>] ? kernfs_name_hash+0x17/0xd0
[   72.188245]  [<ffffffff816a3e8c>] ? __mutex_unlock_slowpath+0x1c/0x40
[   72.188246]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[   72.188248]  [<ffffffff811e66bf>] ? __d_free+0x3f/0x60
[   72.188251]  [<ffffffff811e76b5>] ? dentry_kill+0x205/0x280
[   72.188254]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[   72.188255]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[   72.188257]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[   72.188259]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[   72.188261]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[   72.188263]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[   72.188265]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[   72.188266]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[   72.188269]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[   72.188271]  [<ffffffff811d6642>] SYSC_newlstat+0x22/0x40
[   72.188274]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[   72.188276]  [<ffffffff811d684e>] SyS_newlstat+0xe/0x10
[   72.188279]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[   72.188280] Code: 58 e8 be db 4b 00 85 c0 75 35 4d 85 ed 74 08 41 80 85 88 00 00 00 01 4d 85 f6 74 0b 4c 89 f6 48 89 df e8 ed f0 ff ff 80 43 58 01 <f3> 90 48 89 d8 5b 41 5c 41 5d 41 5e 5d c3 0f 1f 00 45 31 e4 4c 
[  100.164017] BUG: soft lockup - CPU#5 stuck for 23s! [systemd-udevd:1702]
[  100.164020] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw x86_pkg_temp_thermal coretemp iTCO_wdt iTCO_vendor_support mxm_wmi snd_hda_codec_hdmi kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul crc32c_intel snd_seq_device snd_pcm ghash_clmulni_intel microcode serio_raw lpc_ich snd_timer i2c_i801 mfd_core snd mei_me joydev soundcore
[  100.164051]  mei shpchp wmi i915 drm_kms_helper drm igb e1000e dca i2c_algo_bit ptp i2c_core pps_core video
[  100.164059] CPU: 5 PID: 1702 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #4
[  100.164060] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  100.164062] task: ffff8800648b0950 ti: ffff880475c8c000 task.ti: ffff880475c8c000
[  100.164063] RIP: 0010:[<ffffffff816a50e5>]  [<ffffffff816a50e5>] _raw_spin_trylock+0x25/0x40
[  100.164067] RSP: 0018:ffff880475c8db38  EFLAGS: 00000246
[  100.164068] RAX: 0000000000008181 RBX: 0000000000004746 RCX: 0000000000008281
[  100.164069] RDX: 0000000000008181 RSI: ffff880475c8dbb8 RDI: ffff880457d15b88
[  100.164070] RBP: ffff880475c8db38 R08: ffff88045b46ce00 R09: 0000000180240022
[  100.164071] R10: ffffffff81246026 R11: ffffea0011cae000 R12: ffff8804537fd380
[  100.164073] R13: 0000000180240022 R14: ffffffff81246026 R15: ffffea0011cae000
[  100.164074] FS:  00007f9e78d5b880(0000) GS:ffff88048f340000(0000) knlGS:0000000000000000
[  100.164075] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  100.164076] CR2: 00007f9e79bb7ad8 CR3: 00000004763fe000 CR4: 00000000001407e0
[  100.164077] Stack:
[  100.164078]  ffff880475c8db68 ffffffff811e74e6 ffff88045b46ce00 ffff88045b46cd80
[  100.164080]  ffff880475c8dbb8 ffff88045b46cdd8 ffff880475c8dba0 ffffffff811e793b
[  100.164082]  ffff880475c8dbb8 ffff8804537fd240 0000000000000025 ffff880475c8ddd0
[  100.164084] Call Trace:
[  100.164089]  [<ffffffff811e74e6>] dentry_kill+0x36/0x280
[  100.164091]  [<ffffffff811e793b>] shrink_dentry_list+0x8b/0x100
[  100.164092]  [<ffffffff811e81b4>] check_submounts_and_drop+0x74/0xa0
[  100.164096]  [<ffffffff81245c4d>] kernfs_dop_revalidate+0x5d/0xd0
[  100.164098]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  100.164099]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  100.164102]  [<ffffffff81245a07>] ? kernfs_name_hash+0x17/0xd0
[  100.164105]  [<ffffffff816a3e8c>] ? __mutex_unlock_slowpath+0x1c/0x40
[  100.164107]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  100.164109]  [<ffffffff811e66bf>] ? __d_free+0x3f/0x60
[  100.164111]  [<ffffffff811e76b5>] ? dentry_kill+0x205/0x280
[  100.164114]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  100.164116]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  100.164118]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  100.164120]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  100.164122]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  100.164124]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  100.164125]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  100.164127]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  100.164130]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  100.164132]  [<ffffffff811d6642>] SYSC_newlstat+0x22/0x40
[  100.164135]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  100.164138]  [<ffffffff811d684e>] SyS_newlstat+0xe/0x10
[  100.164140]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  100.164141] Code: b2 42 9e ff 5d c3 0f 1f 44 00 00 55 48 89 e5 0f b7 17 38 d6 74 08 31 c0 5d c3 0f 1f 40 00 8d 8a 00 01 00 00 89 d0 f0 66 0f b1 0f <66> 39 d0 75 e6 b8 01 00 00 00 5d c3 66 66 66 66 66 66 2e 0f 1f 
[  107.331926] INFO: rcu_sched self-detected stall on CPU { 5}  (t=60001 jiffies g=1245 c=1244 q=25350)
[  107.331931] sending NMI to all CPUs:
[  107.331934] NMI backtrace for cpu 7
[  107.331937] CPU: 7 PID: 1706 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #4
[  107.331939] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  107.331940] task: ffff8800648d4a80 ti: ffff880475352000 task.ti: ffff880475352000
[  107.331941] RIP: 0010:[<ffffffff816a51c1>]  [<ffffffff816a51c1>] _raw_spin_lock+0x21/0x30
[  107.331946] RSP: 0018:ffff880475353bb0  EFLAGS: 00000283
[  107.331947] RAX: 000000000000001f RBX: ffff880475353c48 RCX: ffffffff811e7440
[  107.331948] RDX: 0000000000000023 RSI: ffff880475353c40 RDI: ffff8804537fd298
[  107.331949] RBP: ffff880475353bb0 R08: ffff880475352000 R09: 0000000000000001
[  107.331950] R10: dfed4b1078bd05a0 R11: 0000000000000000 R12: ffff8804537fd240
[  107.331951] R13: 0000000000000023 R14: ffff880475353e60 R15: 0000000000000001
[  107.331953] FS:  00007f9e78d5b880(0000) GS:ffff88048f3c0000(0000) knlGS:0000000000000000
[  107.331954] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  107.331955] CR2: 00000000006dde20 CR3: 00000004787ed000 CR4: 00000000001407e0
[  107.331956] Stack:
[  107.331957]  ffff880475353c30 ffffffff811e7d8c ffffffff811e7440 01ffffff816a1d1a
[  107.331959]  ffff8804537fd298 ffff8804537fd298 ffff8804537fd240 ffff8804537fd2e0
[  107.331961]  ffffffff811e6eb0 ffff880475353c40 0000052e00000000 ffff880475353c48
[  107.331964] Call Trace:
[  107.331967]  [<ffffffff811e7d8c>] d_walk+0x5c/0x280
[  107.331970]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  107.331972]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  107.331974]  [<ffffffff811e81a2>] check_submounts_and_drop+0x62/0xa0
[  107.331977]  [<ffffffff81245c4d>] kernfs_dop_revalidate+0x5d/0xd0
[  107.331979]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  107.331981]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  107.331985]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  107.331988]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  107.331990]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  107.331992]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  107.331995]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  107.331997]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  107.331999]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  107.332001]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  107.332003]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  107.332006]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  107.332009]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  107.332010] Code: c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 <38> d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 
[  107.332031] NMI backtrace for cpu 3
[  107.332033] CPU: 3 PID: 1705 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #4
[  107.332034] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  107.332036] task: ffff8800648d12a0 ti: ffff8804704a4000 task.ti: ffff8804704a4000
[  107.332037] RIP: 0010:[<ffffffff816a51c1>]  [<ffffffff816a51c1>] _raw_spin_lock+0x21/0x30
[  107.332039] RSP: 0018:ffff8804704a5bb0  EFLAGS: 00000283
[  107.332040] RAX: 000000000000001f RBX: ffff8804704a5c48 RCX: ffffffff811e7440
[  107.332041] RDX: 0000000000000021 RSI: ffff8804704a5c40 RDI: ffff8804537fd298
[  107.332042] RBP: ffff8804704a5bb0 R08: ffff8804704a4000 R09: 0000000000000001
[  107.332043] R10: dfed4b5078ad05a0 R11: 0000000000000008 R12: ffff8804537fd240
[  107.332044] R13: 0000000000000023 R14: ffff8804704a5e60 R15: 0000000000000001
[  107.332045] FS:  00007f9e78d5b880(0000) GS:ffff88048f2c0000(0000) knlGS:0000000000000000
[  107.332047] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  107.332048] CR2: 00007f8f838a9038 CR3: 000000047718c000 CR4: 00000000001407e0
[  107.332049] Stack:
[  107.332049]  ffff8804704a5c30 ffffffff811e7d8c ffffffff811e7440 01ffffff816a1d1a
[  107.332051]  ffff8804537fd298 ffff8804537fd298 ffff8804537fd240 ffff8804537fd2e0
[  107.332053]  ffffffff811e6eb0 ffff8804704a5c40 0000052e00000000 ffff8804704a5c48
[  107.332055] Call Trace:
[  107.332057]  [<ffffffff811e7d8c>] d_walk+0x5c/0x280
[  107.332059]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  107.332061]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  107.332063]  [<ffffffff811e81a2>] check_submounts_and_drop+0x62/0xa0
[  107.332065]  [<ffffffff81245c4d>] kernfs_dop_revalidate+0x5d/0xd0
[  107.332067]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  107.332069]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  107.332071]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  107.332073]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  107.332075]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  107.332076]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  107.332078]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  107.332080]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  107.332082]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  107.332084]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  107.332086]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  107.332088]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  107.332090]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  107.332091] Code: c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 <38> d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 
[  107.332111] NMI backtrace for cpu 0
[  107.332114] CPU: 0 PID: 1707 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #4
[  107.332116] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  107.332117] task: ffff8800648d2540 ti: ffff880475548000 task.ti: ffff880475548000
[  107.332118] RIP: 0010:[<ffffffff816a51b3>]  [<ffffffff816a51b3>] _raw_spin_lock+0x13/0x30
[  107.332121] RSP: 0018:ffff880475549bb0  EFLAGS: 00000202
[  107.332123] RAX: 000000000000241f RBX: ffff880475549c48 RCX: ffffffff811e7440
[  107.332124] RDX: ffffffff811e6eb0 RSI: ffff880475549c40 RDI: ffff8804537fd298
[  107.332125] RBP: ffff880475549bb0 R08: ffff880475548000 R09: 0000000000000001
[  107.332126] R10: dfed4b8078a105a0 R11: 0000000000000293 R12: ffff8804537fd240
[  107.332127] R13: 0000000000000023 R14: ffff880475549e60 R15: 0000000000000001
[  107.332129] FS:  00007f9e78d5b880(0000) GS:ffff88048f200000(0000) knlGS:0000000000000000
[  107.332130] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  107.332131] CR2: 0000000000909cfc CR3: 00000004757a7000 CR4: 00000000001407f0
[  107.332132] Stack:
[  107.332133]  ffff880475549c30 ffffffff811e7d8c ffffffff811e7440 01ffffff816a1d1a
[  107.332135]  ffff8804537fd298 ffff8804537fd298 ffff8804537fd240 ffff8804537fd2e0
[  107.332137]  ffffffff811e6eb0 ffff880475549c40 0000052e00000000 ffff880475549c48
[  107.332139] Call Trace:
[  107.332142]  [<ffffffff811e7d8c>] d_walk+0x5c/0x280
[  107.332144]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  107.332147]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  107.332148]  [<ffffffff811e81a2>] check_submounts_and_drop+0x62/0xa0
[  107.332151]  [<ffffffff81245c4d>] kernfs_dop_revalidate+0x5d/0xd0
[  107.332153]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  107.332155]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  107.332157]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  107.332159]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  107.332161]  [<ffffffff8118896c>] ? tlb_flush_mmu_free+0x2c/0x50
[  107.332164]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  107.332166]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  107.332167]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  107.332169]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  107.332172]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  107.332174]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  107.332177]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  107.332179]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  107.332180] Code: 00 00 f0 81 2f 00 00 10 00 74 05 e8 58 2c c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 <0f> b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 38 d0 75 f7 5d c3 66 
[  107.332202] NMI backtrace for cpu 4
[  107.332204] CPU: 4 PID: 1704 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #4
[  107.332205] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  107.332206] task: ffff8800648b37e0 ti: ffff880473fbc000 task.ti: ffff880473fbc000
[  107.332207] RIP: 0010:[<ffffffff816a51c1>]  [<ffffffff816a51c1>] _raw_spin_lock+0x21/0x30
[  107.332210] RSP: 0018:ffff880473fbdc50  EFLAGS: 00000287
[  107.332211] RAX: 000000000000001f RBX: ffff880473fbdce8 RCX: ffffffff811e7440
[  107.332212] RDX: 0000000000000020 RSI: ffff880473fbdce0 RDI: ffff8804537fd298
[  107.332213] RBP: ffff880473fbdc50 R08: ffff880473fbc000 R09: 0000000000000001
[  107.332214] R10: dfed4b4078b105a0 R11: ffffffff8144ccc9 R12: ffff8804537fd240
[  107.332215] R13: 0000000000000023 R14: ffff880473fbde60 R15: 0000000000000001
[  107.332216] FS:  00007f9e78d5b880(0000) GS:ffff88048f300000(0000) knlGS:0000000000000000
[  107.332217] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  107.332218] CR2: 00007f9e78d6b000 CR3: 00000004761e7000 CR4: 00000000001407e0
[  107.332219] Stack:
[  107.332220]  ffff880473fbdcd0 ffffffff811e7d8c ffffffff811e7440 01ffffff816a1d1a
[  107.332222]  ffff8804537fd298 ffff8804537fd298 ffff8804537fd240 ffff8804537fd2e0
[  107.332224]  ffffffff811e6eb0 ffff880473fbdce0 0000052e00000000 ffff880473fbdce8
[  107.332226] Call Trace:
[  107.332228]  [<ffffffff811e7d8c>] d_walk+0x5c/0x280
[  107.332230]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  107.332232]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  107.332233]  [<ffffffff811e81a2>] check_submounts_and_drop+0x62/0xa0
[  107.332236]  [<ffffffff81245c4d>] kernfs_dop_revalidate+0x5d/0xd0
[  107.332237]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  107.332239]  [<ffffffff811dd2b5>] path_lookupat+0x155/0x780
[  107.332241]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  107.332243]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  107.332245]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  107.332247]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  107.332248]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  107.332250]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  107.332253]  [<ffffffff811d65ff>] ? SYSC_newstat+0x1f/0x40
[  107.332255]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  107.332257]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  107.332259]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  107.332259] Code: c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 <38> d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 
[  107.332280] NMI backtrace for cpu 5
[  107.332282] CPU: 5 PID: 1702 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #4
[  107.332283] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  107.332284] task: ffff8800648b0950 ti: ffff880475c8c000 task.ti: ffff880475c8c000
[  107.332286] RIP: 0010:[<ffffffff81336a02>]  [<ffffffff81336a02>] __const_udelay+0x12/0x30
[  107.332289] RSP: 0018:ffff88048f343df0  EFLAGS: 00000086
[  107.332290] RAX: 0000000001062560 RBX: 0000000000002710 RCX: 00000000ff000000
[  107.332292] RDX: 0000000000354847 RSI: ffffffff81c27ec0 RDI: 0000000000418958
[  107.332293] RBP: ffff88048f343e08 R08: 000000000000000a R09: 00000000000004d4
[  107.332294] R10: 0000000000000000 R11: ffff88048f343b3e R12: ffffffff81c4f7c0
[  107.332295] R13: ffffffff81cfdb38 R14: ffffffff81c4f7c0 R15: 0000000000000005
[  107.332297] FS:  00007f9e78d5b880(0000) GS:ffff88048f340000(0000) knlGS:0000000000000000
[  107.332298] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  107.332299] CR2: 00007f9e79bb7ad8 CR3: 00000004763fe000 CR4: 00000000001407e0
[  107.332300] Stack:
[  107.332301]  ffff88048f343e08 ffffffff810448ce ffff88048f34eac0 ffff88048f343e60
[  107.332303]  ffffffff810e415e ffff88048f343e60 ffffffff810b8a01 00000018f99c87ab
[  107.332305]  0000000000006306 ffff8800648b0950 0000000000000000 0000000000000005
[  107.332307] Call Trace:
[  107.332308]  <IRQ> 

[  107.332312]  [<ffffffff810448ce>] ? arch_trigger_all_cpu_backtrace+0x5e/0x80
[  107.332316]  [<ffffffff810e415e>] rcu_check_callbacks+0x3fe/0x660
[  107.332319]  [<ffffffff810b8a01>] ? account_process_tick+0x121/0x1b0
[  107.332322]  [<ffffffff81091627>] update_process_times+0x47/0x70
[  107.332325]  [<ffffffff810ee935>] tick_sched_handle.isra.16+0x25/0x60
[  107.332327]  [<ffffffff810ee9b1>] tick_sched_timer+0x41/0x60
[  107.332329]  [<ffffffff810a8493>] __run_hrtimer+0x73/0x1d0
[  107.332332]  [<ffffffff810ee970>] ? tick_sched_handle.isra.16+0x60/0x60
[  107.332334]  [<ffffffff810a8c67>] hrtimer_interrupt+0xf7/0x240
[  107.332337]  [<ffffffff81042c37>] local_apic_timer_interrupt+0x37/0x60
[  107.332339]  [<ffffffff816b00ef>] smp_apic_timer_interrupt+0x3f/0x60
[  107.332341]  [<ffffffff816aeadd>] apic_timer_interrupt+0x6d/0x80
[  107.332342]  <EOI> 

[  107.332345]  [<ffffffff81246026>] ? kernfs_put+0x106/0x1d0
[  107.332346]  [<ffffffff816a51a0>] ? _raw_write_lock_irqsave+0x30/0x30
[  107.332348]  [<ffffffff811e78df>] ? shrink_dentry_list+0x2f/0x100
[  107.332350]  [<ffffffff811e81b4>] check_submounts_and_drop+0x74/0xa0
[  107.332352]  [<ffffffff81245c4d>] kernfs_dop_revalidate+0x5d/0xd0
[  107.332354]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  107.332356]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  107.332359]  [<ffffffff81245a07>] ? kernfs_name_hash+0x17/0xd0
[  107.332362]  [<ffffffff816a3e8c>] ? __mutex_unlock_slowpath+0x1c/0x40
[  107.332364]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  107.332366]  [<ffffffff811e66bf>] ? __d_free+0x3f/0x60
[  107.332368]  [<ffffffff811e76b5>] ? dentry_kill+0x205/0x280
[  107.332370]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  107.332372]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  107.332374]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  107.332376]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  107.332378]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  107.332380]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  107.332382]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  107.332384]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  107.332386]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  107.332388]  [<ffffffff811d6642>] SYSC_newlstat+0x22/0x40
[  107.332391]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  107.332393]  [<ffffffff811d684e>] SyS_newlstat+0xe/0x10
[  107.332395]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  107.332396] Code: 89 e5 ff 15 d9 1b 96 00 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 8d 04 bd 00 00 00 00 65 48 8b 14 25 60 3e 01 00 <48> 89 e5 48 69 d2 fa 00 00 00 f7 e2 48 8d 7a 01 ff 15 a0 1b 96 
[  107.332417] NMI backtrace for cpu 1
[  107.332419] CPU: 1 PID: 1701 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #4
[  107.332420] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  107.332422] task: ffff8800648b5d20 ti: ffff880473448000 task.ti: ffff880473448000
[  107.332422] RIP: 0010:[<ffffffff816a51c1>]  [<ffffffff816a51c1>] _raw_spin_lock+0x21/0x30
[  107.332425] RSP: 0018:ffff880473449bc0  EFLAGS: 00000297
[  107.332426] RAX: 000000000000001f RBX: ffff880473449c58 RCX: ffffffff811e7440
[  107.332427] RDX: 000000000000001f RSI: ffff880473449c50 RDI: ffff8804537fd298
[  107.332428] RBP: ffff880473449bc0 R08: ffff880473448000 R09: 0000000000000001
[  107.332429] R10: 00000000000019ef R11: 0000000000000008 R12: ffff8804537fd240
[  107.332430] R13: 0000000000000023 R14: ffff880473449e50 R15: 0000000000000001
[  107.332431] FS:  00007f9e78d5b880(0000) GS:ffff88048f240000(0000) knlGS:0000000000000000
[  107.332432] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  107.332433] CR2: 00007fe87e42a000 CR3: 0000000477cb7000 CR4: 00000000001407e0
[  107.332434] Stack:
[  107.332435]  ffff880473449c40 ffffffff811e7d8c ffffffff811e7440 01ffffff816a1d1a
[  107.332437]  ffff8804537fd298 ffff8804537fd298 ffff8804537fd240 ffff8804537fd2e0
[  107.332438]  ffffffff811e6eb0 ffff880473449c50 0000052e00000000 ffff880473449c58
[  107.332440] Call Trace:
[  107.332442]  [<ffffffff811e7d8c>] d_walk+0x5c/0x280
[  107.332444]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  107.332446]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  107.332448]  [<ffffffff811e81a2>] check_submounts_and_drop+0x62/0xa0
[  107.332450]  [<ffffffff81245c4d>] kernfs_dop_revalidate+0x5d/0xd0
[  107.332451]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  107.332453]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  107.332456]  [<ffffffff812c5b56>] ? security_file_alloc+0x16/0x20
[  107.332458]  [<ffffffff811e0cbc>] path_openat+0x9c/0x660
[  107.332460]  [<ffffffff811788ad>] ? shmem_destroy_inode+0x2d/0x40
[  107.332462]  [<ffffffff811e1a7a>] do_filp_open+0x3a/0x90
[  107.332464]  [<ffffffff811edd1d>] ? __alloc_fd+0x7d/0x120
[  107.332466]  [<ffffffff811d0ade>] do_sys_open+0x12e/0x210
[  107.332468]  [<ffffffff811d0bde>] SyS_open+0x1e/0x20
[  107.332470]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  107.332470] Code: c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 <38> d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 
[  107.332490] NMI backtrace for cpu 6
[  107.332493] CPU: 6 PID: 1703 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #4
[  107.332495] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  107.332496] task: ffff8800648b4130 ti: ffff8804735e2000 task.ti: ffff8804735e2000
[  107.332497] RIP: 0010:[<ffffffff816a51c1>]  [<ffffffff816a51c1>] _raw_spin_lock+0x21/0x30
[  107.332500] RSP: 0018:ffff8804735e3b20  EFLAGS: 00000287
[  107.332501] RAX: 000000000000001f RBX: ffff8804735e3bb8 RCX: ffffffff811e7440
[  107.332503] RDX: 0000000000000022 RSI: ffff8804735e3bb0 RDI: ffff8804537fd298
[  107.332504] RBP: ffff8804735e3b20 R08: ffff8804735e2000 R09: 0000000000000001
[  107.332505] R10: dfed4b2078b905a0 R11: 0000000000000008 R12: ffff8804537fd240
[  107.332506] R13: 0000000000000023 R14: ffff8804735e3dd0 R15: 0000000000000001
[  107.332507] FS:  00007f9e78d5b880(0000) GS:ffff88048f380000(0000) knlGS:0000000000000000
[  107.332509] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  107.332510] CR2: 00007fa355ff3000 CR3: 000000047119e000 CR4: 00000000001407e0
[  107.332511] Stack:
[  107.332512]  ffff8804735e3ba0 ffffffff811e7d8c ffffffff811e7440 0100000000000001
[  107.332514]  ffff8804537fd298 ffff8804537fd298 ffff8804537fd240 ffff8804537fd2e0
[  107.332516]  ffffffff811e6eb0 ffff8804735e3bb0 0000052e00000000 ffff8804735e3bb8
[  107.332518] Call Trace:
[  107.332520]  [<ffffffff811e7d8c>] d_walk+0x5c/0x280
[  107.332523]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  107.332525]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  107.332527]  [<ffffffff811e81a2>] check_submounts_and_drop+0x62/0xa0
[  107.332529]  [<ffffffff81245c4d>] kernfs_dop_revalidate+0x5d/0xd0
[  107.332531]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  107.332533]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  107.332535]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  107.332538]  [<ffffffff81245a07>] ? kernfs_name_hash+0x17/0xd0
[  107.332540]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  107.332542]  [<ffffffff811e66bf>] ? __d_free+0x3f/0x60
[  107.332544]  [<ffffffff811e76b5>] ? dentry_kill+0x205/0x280
[  107.332546]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  107.332548]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  107.332550]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  107.332552]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  107.332554]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  107.332556]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  107.332558]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  107.332560]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  107.332562]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  107.332564]  [<ffffffff811d6642>] SYSC_newlstat+0x22/0x40
[  107.332566]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  107.332569]  [<ffffffff811d684e>] SyS_newlstat+0xe/0x10
[  107.332570]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  107.332571] Code: c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 <38> d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 
[  107.332593] NMI backtrace for cpu 2
[  107.332595] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G          I   3.15.0-rc7+ #4
[  107.332596] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  107.332597] task: ffff880478d56670 ti: ffff880478e12000 task.ti: ffff880478e12000
[  107.332598] RIP: 0010:[<ffffffff8139d5ea>]  [<ffffffff8139d5ea>] intel_idle+0xda/0x160
[  107.332602] RSP: 0018:ffff880478e13e58  EFLAGS: 00000046
[  107.332603] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  107.332604] RDX: 0000000000000000 RSI: ffffffff81c9c9a0 RDI: 0000000000000002
[  107.332605] RBP: ffff880478e13e80 R08: 00000000ffffffff R09: 0000000000001aaf
[  107.332606] R10: 00000000000019f4 R11: 0000000000000008 R12: 0000000000000005
[  107.332607] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c9cb70
[  107.332608] FS:  0000000000000000(0000) GS:ffff88048f280000(0000) knlGS:0000000000000000
[  107.332609] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  107.332610] CR2: 00007f47b7bb12d0 CR3: 0000000001c0f000 CR4: 00000000001407e0
[  107.332611] Stack:
[  107.332612]  0000000278e13e80 ffff88048f29a840 ffffffff81c9c9a0 00000018f9abd6d9
[  107.332614]  0000000000000005 ffff880478e13eb8 ffffffff815463a0 ffffffff81cfdb30
[  107.332616]  ffff88048f29a840 ffffffff81c9c9a0 ffff880478e13fd8 ffff880478e12000
[  107.332618] Call Trace:
[  107.332621]  [<ffffffff815463a0>] cpuidle_enter_state+0x40/0xc0
[  107.332623]  [<ffffffff81546457>] cpuidle_enter+0x17/0x20
[  107.332625]  [<ffffffff810c8410>] cpu_startup_entry+0x2c0/0x3d0
[  107.332628]  [<ffffffff81040d64>] start_secondary+0x1c4/0x280
[  107.332629] Code: c7 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 65 48 8b 04 25 c8 c7 00 00 48 8b 80 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 04 25 c8 c7 00 00 83 a0 3c e0 ff ff fb 0f ae f0 65 48 
[  107.332926] INFO: rcu_sched detected stalls on CPUs/tasks: { 5} (detected by 2, t=60002 jiffies, g=1245, c=1244, q=25350)
[  132.136967] BUG: soft lockup - CPU#5 stuck for 23s! [systemd-udevd:1702]
[  132.136970] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw x86_pkg_temp_thermal coretemp iTCO_wdt iTCO_vendor_support mxm_wmi snd_hda_codec_hdmi kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul crc32c_intel snd_seq_device snd_pcm ghash_clmulni_intel microcode serio_raw lpc_ich snd_timer i2c_i801 mfd_core snd mei_me joydev soundcore
[  132.137001]  mei shpchp wmi i915 drm_kms_helper drm igb e1000e dca i2c_algo_bit ptp i2c_core pps_core video
[  132.137010] CPU: 5 PID: 1702 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #4
[  132.137011] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  132.137013] task: ffff8800648b0950 ti: ffff880475c8c000 task.ti: ffff880475c8c000
[  132.137014] RIP: 0010:[<ffffffff811e7513>]  [<ffffffff811e7513>] dentry_kill+0x63/0x280
[  132.137019] RSP: 0018:ffff880475c8db48  EFLAGS: 00000202
[  132.137020] RAX: 0000000000000000 RBX: ffffffff81246026 RCX: 0000000000005453
[  132.137021] RDX: 000000000000dcd5 RSI: ffff880475c8dbb8 RDI: ffff8804537fd298
[  132.137022] RBP: ffff880475c8db68 R08: ffff88045b46ce00 R09: 0000000180240022
[  132.137023] R10: ffffffff81246026 R11: ffffea0011cae000 R12: 000000000000e2e1
[  132.137024] R13: ffff880475c8db38 R14: ffff8804537fd380 R15: 0000000180240022
[  132.137026] FS:  00007f9e78d5b880(0000) GS:ffff88048f340000(0000) knlGS:0000000000000000
[  132.137027] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  132.137028] CR2: 00007f9e79bb7ad8 CR3: 00000004763fe000 CR4: 00000000001407e0
[  132.137029] Stack:
[  132.137030]  ffff88045b46ce00 ffff88045b46cd80 ffff880475c8dbb8 ffff88045b46cdd8
[  132.137032]  ffff880475c8dba0 ffffffff811e793b ffff880475c8dbb8 ffff8804537fd240
[  132.137034]  0000000000000025 ffff880475c8ddd0 0000000000000001 ffff880475c8dbe8
[  132.137036] Call Trace:
[  132.137039]  [<ffffffff811e793b>] shrink_dentry_list+0x8b/0x100
[  132.137041]  [<ffffffff811e81b4>] check_submounts_and_drop+0x74/0xa0
[  132.137044]  [<ffffffff81245c4d>] kernfs_dop_revalidate+0x5d/0xd0
[  132.137046]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  132.137048]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  132.137050]  [<ffffffff81245a07>] ? kernfs_name_hash+0x17/0xd0
[  132.137054]  [<ffffffff816a3e8c>] ? __mutex_unlock_slowpath+0x1c/0x40
[  132.137056]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  132.137058]  [<ffffffff811e66bf>] ? __d_free+0x3f/0x60
[  132.137060]  [<ffffffff811e76b5>] ? dentry_kill+0x205/0x280
[  132.137064]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  132.137065]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  132.137067]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  132.137070]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  132.137071]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  132.137073]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  132.137075]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  132.137077]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  132.137080]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  132.137082]  [<ffffffff811d6642>] SYSC_newlstat+0x22/0x40
[  132.137085]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  132.137087]  [<ffffffff811d684e>] SyS_newlstat+0xe/0x10
[  132.137090]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  132.137091] Code: 74 29 4c 8b 63 18 49 39 dc 74 45 4d 85 e4 74 43 49 8d 7c 24 58 e8 be db 4b 00 85 c0 75 35 4d 85 ed 74 08 41 80 85 88 00 00 00 01 <4d> 85 f6 74 0b 4c 89 f6 48 89 df e8 ed f0 ff ff 80 43 58 01 f3 
[  160.113507] BUG: soft lockup - CPU#5 stuck for 23s! [systemd-udevd:1702]
[  160.113510] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw x86_pkg_temp_thermal coretemp iTCO_wdt iTCO_vendor_support mxm_wmi snd_hda_codec_hdmi kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul crc32c_intel snd_seq_device snd_pcm ghash_clmulni_intel microcode serio_raw lpc_ich snd_timer i2c_i801 mfd_core snd mei_me joydev soundcore
[  160.113541]  mei shpchp wmi i915 drm_kms_helper drm igb e1000e dca i2c_algo_bit ptp i2c_core pps_core video
[  160.113549] CPU: 5 PID: 1702 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #4
[  160.113550] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  160.113552] task: ffff8800648b0950 ti: ffff880475c8c000 task.ti: ffff880475c8c000
[  160.113553] RIP: 0010:[<ffffffff811e7529>]  [<ffffffff811e7529>] dentry_kill+0x79/0x280
[  160.113558] RSP: 0018:ffff880475c8db48  EFLAGS: 00000286
[  160.113559] RAX: 0000000000000000 RBX: ffffffff81246026 RCX: 000000000000ebea
[  160.113560] RDX: ffff8804537fd380 RSI: ffff880475c8dbb8 RDI: ffff88045b46ce00
[  160.113561] RBP: ffff880475c8db68 R08: ffff8804537fd380 R09: 0000000180240022
[  160.113562] R10: ffffffff81246026 R11: ffffea0011cae000 R12: ffffffff81246026
[  160.113563] R13: ffff880475c8db38 R14: ffffffff81246026 R15: ffff880475c8db38
[  160.113565] FS:  00007f9e78d5b880(0000) GS:ffff88048f340000(0000) knlGS:0000000000000000
[  160.113566] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  160.113567] CR2: 00007f9e79bb7ad8 CR3: 00000004763fe000 CR4: 00000000001407e0
[  160.113568] Stack:
[  160.113569]  ffff88045b46ce00 ffff88045b46cd80 ffff880475c8dbb8 ffff88045b46cdd8
[  160.113571]  ffff880475c8dba0 ffffffff811e793b ffff880475c8dbb8 ffff8804537fd240
[  160.113573]  0000000000000025 ffff880475c8ddd0 0000000000000001 ffff880475c8dbe8
[  160.113575] Call Trace:
[  160.113578]  [<ffffffff811e793b>] shrink_dentry_list+0x8b/0x100
[  160.113580]  [<ffffffff811e81b4>] check_submounts_and_drop+0x74/0xa0
[  160.113583]  [<ffffffff81245c4d>] kernfs_dop_revalidate+0x5d/0xd0
[  160.113585]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  160.113587]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  160.113589]  [<ffffffff81245a07>] ? kernfs_name_hash+0x17/0xd0
[  160.113593]  [<ffffffff816a3e8c>] ? __mutex_unlock_slowpath+0x1c/0x40
[  160.113595]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  160.113597]  [<ffffffff811e66bf>] ? __d_free+0x3f/0x60
[  160.113599]  [<ffffffff811e76b5>] ? dentry_kill+0x205/0x280
[  160.113602]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  160.113604]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  160.113606]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  160.113608]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  160.113610]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  160.113611]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  160.113613]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  160.113615]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  160.113618]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  160.113620]  [<ffffffff811d6642>] SYSC_newlstat+0x22/0x40
[  160.113623]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  160.113625]  [<ffffffff811d684e>] SyS_newlstat+0xe/0x10
[  160.113627]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  160.113628] Code: be db 4b 00 85 c0 75 35 4d 85 ed 74 08 41 80 85 88 00 00 00 01 4d 85 f6 74 0b 4c 89 f6 48 89 df e8 ed f0 ff ff 80 43 58 01 f3 90 <48> 89 d8 5b 41 5c 41 5d 41 5e 5d c3 0f 1f 00 45 31 e4 4c 8d 73 
[  188.090018] BUG: soft lockup - CPU#5 stuck for 23s! [systemd-udevd:1702]
[  188.090021] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw x86_pkg_temp_thermal coretemp iTCO_wdt iTCO_vendor_support mxm_wmi snd_hda_codec_hdmi kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul crc32c_intel snd_seq_device snd_pcm ghash_clmulni_intel microcode serio_raw lpc_ich snd_timer i2c_i801 mfd_core snd mei_me joydev soundcore
[  188.090052]  mei shpchp wmi i915 drm_kms_helper drm igb e1000e dca i2c_algo_bit ptp i2c_core pps_core video
[  188.090060] CPU: 5 PID: 1702 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #4
[  188.090061] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  188.090063] task: ffff8800648b0950 ti: ffff880475c8c000 task.ti: ffff880475c8c000
[  188.090064] RIP: 0010:[<ffffffff816a51b3>]  [<ffffffff816a51b3>] _raw_spin_lock+0x13/0x30
[  188.090068] RSP: 0018:ffff880475c8db68  EFLAGS: 00000286
[  188.090069] RAX: 0000000000008281 RBX: ffff8804537fd380 RCX: 000000000000d1d0
[  188.090071] RDX: ffff8804537fd380 RSI: ffff880475c8dbb8 RDI: ffff88045b46cdd8
[  188.090072] RBP: ffff880475c8db68 R08: ffff8804537fd380 R09: 0000000180240022
[  188.090073] R10: ffffffff81246026 R11: ffffea0011cae000 R12: ffffffff81246026
[  188.090074] R13: ffffea0011cae000 R14: ffffffff81246026 R15: ffff880475c8db68
[  188.090075] FS:  00007f9e78d5b880(0000) GS:ffff88048f340000(0000) knlGS:0000000000000000
[  188.090076] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  188.090078] CR2: 00007f9e79bb7ad8 CR3: 00000004763fe000 CR4: 00000000001407e0
[  188.090079] Stack:
[  188.090079]  ffff880475c8dba0 ffffffff811e78df ffff880475c8dbb8 ffff8804537fd240
[  188.090082]  0000000000000025 ffff880475c8ddd0 0000000000000001 ffff880475c8dbe8
[  188.090083]  ffffffff811e81b4 ffff8804537fd240 ffff88045b46ce00 ffff88045b46ca40
[  188.090085] Call Trace:
[  188.090089]  [<ffffffff811e78df>] shrink_dentry_list+0x2f/0x100
[  188.090091]  [<ffffffff811e81b4>] check_submounts_and_drop+0x74/0xa0
[  188.090094]  [<ffffffff81245c4d>] kernfs_dop_revalidate+0x5d/0xd0
[  188.090096]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  188.090098]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  188.090101]  [<ffffffff81245a07>] ? kernfs_name_hash+0x17/0xd0
[  188.090104]  [<ffffffff816a3e8c>] ? __mutex_unlock_slowpath+0x1c/0x40
[  188.090106]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  188.090108]  [<ffffffff811e66bf>] ? __d_free+0x3f/0x60
[  188.090110]  [<ffffffff811e76b5>] ? dentry_kill+0x205/0x280
[  188.090113]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  188.090115]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  188.090117]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  188.090119]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  188.090121]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  188.090122]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  188.090124]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  188.090126]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  188.090129]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  188.090131]  [<ffffffff811d6642>] SYSC_newlstat+0x22/0x40
[  188.090134]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  188.090136]  [<ffffffff811d684e>] SyS_newlstat+0xe/0x10
[  188.090139]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  188.090140] Code: 00 00 f0 81 2f 00 00 10 00 74 05 e8 58 2c c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 <0f> b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 38 d0 75 f7 5d c3 66 
[  216.066482] BUG: soft lockup - CPU#5 stuck for 23s! [systemd-udevd:1702]
[  216.066484] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw x86_pkg_temp_thermal coretemp iTCO_wdt iTCO_vendor_support mxm_wmi snd_hda_codec_hdmi kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul crc32c_intel snd_seq_device snd_pcm ghash_clmulni_intel microcode serio_raw lpc_ich snd_timer i2c_i801 mfd_core snd mei_me joydev soundcore
[  216.066514]  mei shpchp wmi i915 drm_kms_helper drm igb e1000e dca i2c_algo_bit ptp i2c_core pps_core video
[  216.066521] CPU: 5 PID: 1702 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #4
[  216.066522] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  216.066524] task: ffff8800648b0950 ti: ffff880475c8c000 task.ti: ffff880475c8c000
[  216.066525] RIP: 0010:[<ffffffff816a51b3>]  [<ffffffff816a51b3>] _raw_spin_lock+0x13/0x30
[  216.066529] RSP: 0018:ffff880475c8db68  EFLAGS: 00000282
[  216.066530] RAX: 000000000000fefe RBX: 0000000000007271 RCX: 0000000000001413
[  216.066531] RDX: ffff8804537fd380 RSI: ffff880475c8dbb8 RDI: ffff88045b46cdd8
[  216.066532] RBP: ffff880475c8db68 R08: ffff8804537fd380 R09: 0000000180240022
[  216.066533] R10: ffffffff81246026 R11: ffffea0011cae000 R12: ffff88045b46ce00
[  216.066534] R13: 0000000180240022 R14: ffffffff81246026 R15: ffffea0011cae000
[  216.066536] FS:  00007f9e78d5b880(0000) GS:ffff88048f340000(0000) knlGS:0000000000000000
[  216.066537] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  216.066538] CR2: 00007f9e79bb7ad8 CR3: 00000004763fe000 CR4: 00000000001407e0
[  216.066539] Stack:
[  216.066540]  ffff880475c8dba0 ffffffff811e78df ffff880475c8dbb8 ffff8804537fd240
[  216.066542]  0000000000000025 ffff880475c8ddd0 0000000000000001 ffff880475c8dbe8
[  216.066544]  ffffffff811e81b4 ffff8804537fd240 ffff88045b46ce00 ffff88045b46ca40
[  216.066546] Call Trace:
[  216.066549]  [<ffffffff811e78df>] shrink_dentry_list+0x2f/0x100
[  216.066551]  [<ffffffff811e81b4>] check_submounts_and_drop+0x74/0xa0
[  216.066554]  [<ffffffff81245c4d>] kernfs_dop_revalidate+0x5d/0xd0
[  216.066556]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  216.066558]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  216.066561]  [<ffffffff81245a07>] ? kernfs_name_hash+0x17/0xd0
[  216.066564]  [<ffffffff816a3e8c>] ? __mutex_unlock_slowpath+0x1c/0x40
[  216.066566]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  216.066568]  [<ffffffff811e66bf>] ? __d_free+0x3f/0x60
[  216.066570]  [<ffffffff811e76b5>] ? dentry_kill+0x205/0x280
[  216.066573]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  216.066575]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  216.066577]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  216.066579]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  216.066581]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  216.066583]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  216.066584]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  216.066586]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  216.066589]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  216.066591]  [<ffffffff811d6642>] SYSC_newlstat+0x22/0x40
[  216.066594]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  216.066597]  [<ffffffff811d684e>] SyS_newlstat+0xe/0x10
[  216.066599]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  216.066600] Code: 00 00 f0 81 2f 00 00 10 00 74 05 e8 58 2c c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 <0f> b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 38 d0 75 f7 5d c3 66 

--6TrnltStXW4iwmi0--
