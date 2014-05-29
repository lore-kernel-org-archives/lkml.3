Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbaE2KvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 06:51:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:56549 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbaE2KvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 06:51:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,933,1392192000"; 
   d="out'?scan'208";a="539448236"
Date: Thu, 29 May 2014 13:51:07 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140529105107.GB1938@lahna.fi.intel.com>
References: <20140527070409.GA1801@lahna.fi.intel.com>
 <20140528031955.GW18016@ZenIV.linux.org.uk>
 <20140528073751.GB1757@lahna.fi.intel.com>
 <20140528115701.GY18016@ZenIV.linux.org.uk>
 <20140528131136.GA1643@lahna.fi.intel.com>
 <20140528141937.GZ18016@ZenIV.linux.org.uk>
 <20140528183954.GA18016@ZenIV.linux.org.uk>
 <20140529031149.GE18016@ZenIV.linux.org.uk>
 <20140529035233.GF18016@ZenIV.linux.org.uk>
 <20140529053444.GI18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Yylu36WmvOXNoKYn"
Content-Disposition: inline
In-Reply-To: <20140529053444.GI18016@ZenIV.linux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 29, 2014 at 06:34:44AM +0100, Al Viro wrote:
> On Thu, May 29, 2014 at 04:52:33AM +0100, Al Viro wrote:
> > On Thu, May 29, 2014 at 04:11:49AM +0100, Al Viro wrote:
> > > On Wed, May 28, 2014 at 07:39:54PM +0100, Al Viro wrote:
> > > 
> > > > OK, the warnings about averting your eyes very much apply; the thing below
> > > > definitely needs more massage before it becomes acceptable (and no, it's
> > > > not a single commit; I'm not that insane), but it changes behaviour in the
> > > > way described above.  Could you check if the livelock persists with it?
> > > > No trace-generating code in there, so the logs should be compact enough...
> > > 
> > > Here's an updated patch, hopefully slightly less vomit-inducing.  Should
> > > give the same behaviour as the previous one...  Again, it's a cumulative
> > > diff - I'm still massaging the splitup here.
> > 
> > BTW, it still leaves the "proceed to parent" case in shrink_dentry_list();
> > in theory, it's also vulnerable to the same livelock.  Can be dealt pretty
> > much the same way; I'd rather leave that one for right after -final, though,
> > if the already posted variant turns out to be sufficient...
> 
> ... which is (presumably) dealt with the incremental I'd just sent to Linus;
> seeing what kind of dumb mistakes I'm making, I'd better call it quits for
> tonight - it's 1:30am here and I didn't have anywhere near enough sleep
> yesterday.  I'd appeciate if you could test the patch immediately
> upthread (from Message-ID: <20140529031149.GE18016@ZenIV.linux.org.uk>)
> and see if it helps.  There's an incremental on top of it (from
> Message-ID: <20140529052621.GH18016@ZenIV.linux.org.uk>) that might or
> might not be a good idea.

Thanks for the patch.

I tested patch <20140529031149.GE18016@ZenIV.linux.org.uk> and it seems
to improve things. After first plug/unplug I can see similar behaviour
but after a while it recovered. I did several iterations of plug/unplug
afterwards and didn't see the livelock to trigger.

dmesg is attached.

I'm going to try your incremental patch now.

--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.out"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.15.0-rc7+ (westeri@lahna) (gcc version 4.8.2 20131212 (Red Hat 4.8.2-7) (GCC) ) #15 SMP Thu May 29 11:38:56 EEST 2014
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
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.15.0-rc7+ #15
[    0.000000] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[    0.000000]  000000000000000b ffffffff81c01e08 ffffffff8169eae2 ffffffff81c01e50
[    0.000000]  ffffffff81c01e40 ffffffff8108413d ffffffff81ffc01c ffffffff81ffc058
[    0.000000]  0000000000000000 ffffffff81dc92c0 ffffffff81c01fb0 ffffffff81c01ea0
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8169eae2>] dump_stack+0x45/0x56
[    0.000000]  [<ffffffff8108413d>] warn_slowpath_common+0x7d/0xa0
[    0.000000]  [<ffffffff810841f4>] warn_slowpath_fmt_taint+0x44/0x50
[    0.000000]  [<ffffffff813c35c5>] ? acpi_tb_verify_checksum+0x24/0x5b
[    0.000000]  [<ffffffff816a0768>] warn_invalid_dmar+0x81/0x93
[    0.000000]  [<ffffffff81d7385e>] detect_intel_iommu+0x7f/0x172
[    0.000000]  [<ffffffff81d2b265>] pci_iommu_alloc+0x4a/0x6c
[    0.000000]  [<ffffffff81d3a05e>] mem_init+0xf/0x8d
[    0.000000]  [<ffffffff81d21d00>] start_kernel+0x1cd/0x405
[    0.000000]  [<ffffffff81d2193c>] ? repair_env_string+0x5c/0x5c
[    0.000000]  [<ffffffff81d21120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81d215ee>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d2172e>] x86_64_start_kernel+0x13e/0x14d
[    0.000000] ---[ end trace ff0702f4c80bb03b ]---
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
[    0.000000] tsc: Detected 3491.980 MHz processor
[    0.000019] Calibrating delay loop (skipped), value calculated using timer frequency.. 6983.96 BogoMIPS (lpj=3491980)
[    0.000139] pid_max: default: 32768 minimum: 301
[    0.000202] ACPI: Core revision 20140214
[    0.006745] ACPI: All ACPI Tables successfully acquired
[    0.016296] Security Framework initialized
[    0.016358] SELinux:  Initializing.
[    0.016418] SELinux:  Starting in permissive mode
[    0.017161] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.019277] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.020198] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.020713] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.020965] Initializing cgroup subsys memory
[    0.021025] Initializing cgroup subsys devices
[    0.021084] Initializing cgroup subsys freezer
[    0.021143] Initializing cgroup subsys net_cls
[    0.021201] Initializing cgroup subsys blkio
[    0.021260] Initializing cgroup subsys perf_event
[    0.021319] Initializing cgroup subsys hugetlb
[    0.021390] CPU: Physical Processor ID: 0
[    0.021447] CPU: Processor Core ID: 0
[    0.022214] mce: CPU supports 9 MCE banks
[    0.022280] CPU0: Thermal monitoring enabled (TM1)
[    0.022346] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
tlb_flushall_shift: 6
[    0.022548] Freeing SMP alternatives memory: 24K (ffffffff81e6c000 - ffffffff81e72000)
[    0.023270] ftrace: allocating 26176 entries in 103 pages
[    0.030365] dmar: Host address width 39
[    0.030447] dmar: DRHD base: 0x00000000000000 flags: 0x1
[    0.030530] dmar: parse DMAR table failure.
[    0.030984] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.041060] smpboot: CPU0: Intel(R) Core(TM) i7-4770K CPU @ 3.50GHz (fam: 06, model: 3c, stepping: 03)
[    0.041279] TSC deadline timer enabled
[    0.041284] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.041558] ... version:                3
[    0.041638] ... bit width:              48
[    0.041718] ... generic registers:      4
[    0.041799] ... value mask:             0000ffffffffffff
[    0.041881] ... max period:             0000ffffffffffff
[    0.041963] ... fixed-purpose events:   3
[    0.042044] ... event mask:             000000070000000f
[    0.042867] x86: Booting SMP configuration:
[    0.042949] .... node  #0, CPUs:      #1
[    0.056993] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.057244]  #2 #3 #4 #5 #6 #7
[    0.140608] x86: Booted up 1 node, 8 CPUs
[    0.140765] smpboot: Total of 8 processors activated (55871.68 BogoMIPS)
[    0.146948] devtmpfs: initialized
[    0.149032] PM: Registering ACPI NVS region [mem 0x5573f000-0x55745fff] (28672 bytes)
[    0.149166] PM: Registering ACPI NVS region [mem 0x69d88000-0x69e49fff] (794624 bytes)
[    0.149753] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.149840] pinctrl core: initialized pinctrl subsystem
[    0.149949] RTC time: 10:28:29, date: 05/29/14
[    0.150052] NET: Registered protocol family 16
[    0.150182] cpuidle: using governor menu
[    0.150282] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.150415] ACPI: bus type PCI registered
[    0.150495] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.150609] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.150746] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.166321] PCI: Using configuration type 1 for base access
[    0.167321] ACPI: Added _OSI(Module Device)
[    0.167402] ACPI: Added _OSI(Processor Device)
[    0.167483] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.167565] ACPI: Added _OSI(Processor Aggregator Device)
[    0.169947] ACPI: Executed 1 blocks of module-level executable AML code
[    0.171502] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.194906] ACPI: SSDT 0x0000000069D3CC18 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.195357] ACPI: Dynamic OEM Table Load:
[    0.195491] ACPI: SSDT 0x0000000000000000 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.199984] ACPI: SSDT 0x0000000069D3C618 0005AA (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.200531] ACPI: Dynamic OEM Table Load:
[    0.200665] ACPI: SSDT 0x0000000000000000 0005AA (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.204912] ACPI: SSDT 0x0000000069D3BD98 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.205364] ACPI: Dynamic OEM Table Load:
[    0.205498] ACPI: SSDT 0x0000000000000000 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.210565] ACPI: Interpreter enabled
[    0.210649] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    0.210840] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    0.211040] ACPI: (supports S0 S3 S4 S5)
[    0.211120] ACPI: Using IOAPIC for interrupt routing
[    0.211217] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.215910] ACPI: Power Resource [FN00] (off)
[    0.216032] ACPI: Power Resource [FN01] (off)
[    0.216150] ACPI: Power Resource [FN02] (off)
[    0.216268] ACPI: Power Resource [FN03] (off)
[    0.216385] ACPI: Power Resource [FN04] (off)
[    0.216875] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.216961] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.217216] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.217413] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.217802] PCI host bridge to bus 0000:00
[    0.217884] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.217967] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.218052] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.218138] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.218223] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.218309] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.218395] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.218480] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.218565] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.218651] pci_bus 0000:00: root bus resource [mem 0x6fa00000-0xfeafffff]
[    0.218740] pci 0000:00:00.0: [8086:0c00] type 00 class 0x060000
[    0.218790] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.218813] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.218841] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.218949] pci 0000:00:02.0: [8086:0412] type 00 class 0x030000
[    0.218956] pci 0000:00:02.0: reg 0x10: [mem 0xde400000-0xde7fffff 64bit]
[    0.218961] pci 0000:00:02.0: reg 0x18: [mem 0x70000000-0x7fffffff 64bit pref]
[    0.218964] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.219009] pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
[    0.219014] pci 0000:00:03.0: reg 0x10: [mem 0xdef34000-0xdef37fff 64bit]
[    0.219078] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.219092] pci 0000:00:14.0: reg 0x10: [mem 0xdef20000-0xdef2ffff 64bit]
[    0.219141] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.219165] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.219271] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.219286] pci 0000:00:16.0: reg 0x10: [mem 0xdef3f000-0xdef3f00f 64bit]
[    0.219337] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.219386] pci 0000:00:19.0: [8086:153b] type 00 class 0x020000
[    0.219399] pci 0000:00:19.0: reg 0x10: [mem 0xdef00000-0xdef1ffff]
[    0.219405] pci 0000:00:19.0: reg 0x14: [mem 0xdef3d000-0xdef3dfff]
[    0.219411] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    0.219459] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.219482] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.219589] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    0.219605] pci 0000:00:1a.0: reg 0x10: [mem 0xdef3c000-0xdef3c3ff]
[    0.219678] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.219710] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.219816] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    0.219827] pci 0000:00:1b.0: reg 0x10: [mem 0xdef30000-0xdef33fff 64bit]
[    0.219882] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.219906] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.220009] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.220069] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.220095] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.220202] pci 0000:00:1c.4: [8086:8c18] type 01 class 0x060400
[    0.220255] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.220280] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.220383] pci 0000:00:1c.6: [8086:8c1c] type 01 class 0x060400
[    0.220436] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.220461] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    0.220568] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    0.220585] pci 0000:00:1d.0: reg 0x10: [mem 0xdef3b000-0xdef3b3ff]
[    0.220658] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.220689] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.220795] pci 0000:00:1f.0: [8086:8c44] type 00 class 0x060100
[    0.220922] pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
[    0.220934] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    0.220939] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    0.220944] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    0.220949] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    0.220955] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.220960] pci 0000:00:1f.2: reg 0x24: [mem 0xdef3a000-0xdef3a7ff]
[    0.220989] pci 0000:00:1f.2: PME# supported from D3hot
[    0.221026] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.221037] pci 0000:00:1f.3: reg 0x10: [mem 0xdef39000-0xdef390ff 64bit]
[    0.221053] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.221128] pci 0000:01:00.0: [10b5:8747] type 01 class 0x060400
[    0.221135] pci 0000:01:00.0: reg 0x10: [mem 0xdee00000-0xdee3ffff]
[    0.221181] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.221195] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.223207] pci 0000:00:01.0: PCI bridge to [bus 01-04]
[    0.223291] pci 0000:00:01.0:   bridge window [mem 0xdee00000-0xdeefffff]
[    0.223331] pci 0000:02:08.0: [10b5:8747] type 01 class 0x060400
[    0.223382] pci 0000:02:08.0: PME# supported from D0 D3hot D3cold
[    0.223416] pci 0000:02:10.0: [10b5:8747] type 01 class 0x060400
[    0.223467] pci 0000:02:10.0: PME# supported from D0 D3hot D3cold
[    0.223498] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    0.223613] pci 0000:02:08.0: PCI bridge to [bus 03]
[    0.271798] pci 0000:02:10.0: PCI bridge to [bus 04]
[    0.271943] acpiphp: Slot [1] registered
[    0.272026] pci 0000:00:1c.0: PCI bridge to [bus 05-6f]
[    0.272111] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xde0fffff]
[    0.272115] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0xb9ffffff 64bit pref]
[    0.272174] pci 0000:70:00.0: [1b4b:9230] type 00 class 0x010601
[    0.272185] pci 0000:70:00.0: reg 0x10: [io  0xe050-0xe057]
[    0.272193] pci 0000:70:00.0: reg 0x14: [io  0xe040-0xe043]
[    0.272201] pci 0000:70:00.0: reg 0x18: [io  0xe030-0xe037]
[    0.272209] pci 0000:70:00.0: reg 0x1c: [io  0xe020-0xe023]
[    0.272217] pci 0000:70:00.0: reg 0x20: [io  0xe000-0xe01f]
[    0.272225] pci 0000:70:00.0: reg 0x24: [mem 0xded10000-0xded107ff]
[    0.272234] pci 0000:70:00.0: reg 0x30: [mem 0xded00000-0xded0ffff pref]
[    0.272278] pci 0000:70:00.0: PME# supported from D3hot
[    0.272297] pci 0000:70:00.0: System wakeup disabled by ACPI
[    0.273842] pci 0000:00:1c.4: PCI bridge to [bus 70]
[    0.273926] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.273928] pci 0000:00:1c.4:   bridge window [mem 0xded00000-0xdedfffff]
[    0.273991] pci 0000:71:00.0: [10b5:8605] type 01 class 0x060400
[    0.274007] pci 0000:71:00.0: reg 0x10: [mem 0xdec00000-0xdec03fff]
[    0.274132] pci 0000:71:00.0: supports D1 D2
[    0.274132] pci 0000:71:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.274162] pci 0000:71:00.0: System wakeup disabled by ACPI
[    0.275843] pci 0000:00:1c.6: PCI bridge to [bus 71-75]
[    0.275928] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
[    0.275930] pci 0000:00:1c.6:   bridge window [mem 0xde800000-0xdecfffff]
[    0.276016] pci 0000:72:01.0: [10b5:8605] type 01 class 0x060400
[    0.276155] pci 0000:72:01.0: supports D1 D2
[    0.276155] pci 0000:72:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.276214] pci 0000:72:02.0: [10b5:8605] type 01 class 0x060400
[    0.276352] pci 0000:72:02.0: supports D1 D2
[    0.276353] pci 0000:72:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.276411] pci 0000:72:03.0: [10b5:8605] type 01 class 0x060400
[    0.276549] pci 0000:72:03.0: supports D1 D2
[    0.276550] pci 0000:72:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.276629] pci 0000:71:00.0: PCI bridge to [bus 72-75]
[    0.276718] pci 0000:71:00.0:   bridge window [io  0xd000-0xdfff]
[    0.276722] pci 0000:71:00.0:   bridge window [mem 0xde800000-0xdebfffff]
[    0.276791] pci 0000:72:01.0: PCI bridge to [bus 73]
[    0.276987] pci 0000:74:00.0: [8086:08b1] type 00 class 0x028000
[    0.277031] pci 0000:74:00.0: reg 0x10: [mem 0xdeb00000-0xdeb01fff 64bit]
[    0.277281] pci 0000:74:00.0: PME# supported from D0 D3hot D3cold
[    0.278895] pci 0000:72:02.0: PCI bridge to [bus 74]
[    0.278986] pci 0000:72:02.0:   bridge window [mem 0xdeb00000-0xdebfffff]
[    0.279092] pci 0000:75:00.0: [8086:1533] type 00 class 0x020000
[    0.279119] pci 0000:75:00.0: reg 0x10: [mem 0xde900000-0xde9fffff]
[    0.279156] pci 0000:75:00.0: reg 0x18: [io  0xd000-0xd01f]
[    0.279175] pci 0000:75:00.0: reg 0x1c: [mem 0xdea00000-0xdea03fff]
[    0.279230] pci 0000:75:00.0: reg 0x30: [mem 0xde800000-0xde8fffff pref]
[    0.279358] pci 0000:75:00.0: PME# supported from D0 D3hot D3cold
[    0.280890] pci 0000:72:03.0: PCI bridge to [bus 75]
[    0.280978] pci 0000:72:03.0:   bridge window [io  0xd000-0xdfff]
[    0.280982] pci 0000:72:03.0:   bridge window [mem 0xde800000-0xdeafffff]
[    0.281054] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.281473] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.281879] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.282280] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.282683] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.283086] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.283488] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.283993] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.284394] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.284887] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.285069] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.285205] vgaarb: loaded
[    0.285284] vgaarb: bridge control possible 0000:00:02.0
[    0.285396] SCSI subsystem initialized
[    0.285497] libata version 3.00 loaded.
[    0.285512] ACPI: bus type USB registered
[    0.285601] usbcore: registered new interface driver usbfs
[    0.285688] usbcore: registered new interface driver hub
[    0.285779] usbcore: registered new device driver usb
[    0.285896] PCI: Using ACPI for IRQ routing
[    0.291171] PCI: pci_cache_line_size set to 64 bytes
[    0.291228] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.291229] e820: reserve RAM buffer [mem 0x5573f000-0x57ffffff]
[    0.291229] e820: reserve RAM buffer [mem 0x567b0000-0x57ffffff]
[    0.291230] e820: reserve RAM buffer [mem 0x69b33000-0x6bffffff]
[    0.291231] e820: reserve RAM buffer [mem 0x69d88000-0x6bffffff]
[    0.291232] e820: reserve RAM buffer [mem 0x6b000000-0x6bffffff]
[    0.291232] e820: reserve RAM buffer [mem 0x48f600000-0x48fffffff]
[    0.291280] NetLabel: Initializing
[    0.291360] NetLabel:  domain hash size = 128
[    0.291441] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.291531] NetLabel:  unlabeled traffic allowed by default
[    0.291635] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.291962] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.294061] Switched to clocksource hpet
[    0.297388] pnp: PnP ACPI init
[    0.297475] ACPI: bus type PNP registered
[    0.297597] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.297684] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.297689] pnp 00:01: [dma 4]
[    0.297699] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.297709] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.297758] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.297823] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.297908] system 00:04: [io  0xffff] has been reserved
[    0.297991] system 00:04: [io  0xffff] has been reserved
[    0.298078] system 00:04: [io  0xffff] has been reserved
[    0.298161] system 00:04: [io  0x1c00-0x1cfe] has been reserved
[    0.298245] system 00:04: [io  0x1d00-0x1dfe] has been reserved
[    0.298329] system 00:04: [io  0x1e00-0x1efe] has been reserved
[    0.298413] system 00:04: [io  0x1f00-0x1ffe] has been reserved
[    0.298497] system 00:04: [io  0x1800-0x18fe] could not be reserved
[    0.298581] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.298665] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.298682] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.298708] system 00:06: [io  0x1854-0x1857] has been reserved
[    0.298792] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.298858] system 00:07: [io  0x0a00-0x0a0f] has been reserved
[    0.298942] system 00:07: [io  0x0a30-0x0a3f] has been reserved
[    0.300453] system 00:07: [io  0x0a20-0x0a2f] has been reserved
[    0.300537] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.300672] pnp 00:08: [dma 0 disabled]
[    0.300696] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.300725] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.300810] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.300824] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.301061] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.301146] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.301231] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.301316] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.301401] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
[    0.301486] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.301571] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.301656] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.301741] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    0.301827] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.301913] system 00:0b: [mem 0xdffef000-0xdffeffff] has been reserved
[    0.301997] system 00:0b: [mem 0xdfff0000-0xdfff0fff] has been reserved
[    0.302085] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.302215] pnp: PnP ACPI: found 12 devices
[    0.302296] ACPI: bus type PNP unregistered
[    0.307980] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 05-6f] add_size 1000
[    0.307996] pci 0000:72:01.0: bridge window [io  0x1000-0x0fff] to [bus 73] add_size 1000
[    0.307997] pci 0000:72:01.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 73] add_size 200000
[    0.307998] pci 0000:72:01.0: bridge window [mem 0x00100000-0x000fffff] to [bus 73] add_size 200000
[    0.308027] pci 0000:72:01.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.308028] pci 0000:71:00.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 72-75] add_size 200000
[    0.308034] pci 0000:71:00.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.308035] pci 0000:00:1c.6: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 71-75] add_size 200000
[    0.308037] pci 0000:00:1c.6: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.308038] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.308042] pci 0000:00:1c.6: BAR 15: assigned [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.308180] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.308264] pci 0000:02:08.0: PCI bridge to [bus 03]
[    0.308352] pci 0000:02:10.0: PCI bridge to [bus 04]
[    0.308439] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    0.308527] pci 0000:00:01.0: PCI bridge to [bus 01-04]
[    0.308611] pci 0000:00:01.0:   bridge window [mem 0xdee00000-0xdeefffff]
[    0.308698] pci 0000:00:1c.0: PCI bridge to [bus 05-6f]
[    0.308781] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.308868] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xde0fffff]
[    0.308955] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0xb9ffffff 64bit pref]
[    0.309094] pci 0000:00:1c.4: PCI bridge to [bus 70]
[    0.309177] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.309263] pci 0000:00:1c.4:   bridge window [mem 0xded00000-0xdedfffff]
[    0.309353] pci 0000:71:00.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.309354] pci 0000:71:00.0: BAR 15: assigned [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.309489] pci 0000:72:01.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.309490] pci 0000:72:01.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.309491] pci 0000:72:01.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.309492] pci 0000:72:01.0: BAR 14: can't assign mem (size 0x200000)
[    0.309577] pci 0000:72:01.0: BAR 15: assigned [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.309711] pci 0000:72:01.0: BAR 13: can't assign io (size 0x1000)
[    0.309795] pci 0000:72:01.0: BAR 14: can't assign mem (size 0x200000)
[    0.309880] pci 0000:72:01.0: BAR 13: can't assign io (size 0x1000)
[    0.309965] pci 0000:72:01.0: PCI bridge to [bus 73]
[    0.310058] pci 0000:72:01.0:   bridge window [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.310198] pci 0000:72:02.0: PCI bridge to [bus 74]
[    0.310284] pci 0000:72:02.0:   bridge window [mem 0xdeb00000-0xdebfffff]
[    0.310379] pci 0000:72:03.0: PCI bridge to [bus 75]
[    0.310463] pci 0000:72:03.0:   bridge window [io  0xd000-0xdfff]
[    0.310551] pci 0000:72:03.0:   bridge window [mem 0xde800000-0xdeafffff]
[    0.310646] pci 0000:71:00.0: PCI bridge to [bus 72-75]
[    0.310730] pci 0000:71:00.0:   bridge window [io  0xd000-0xdfff]
[    0.310818] pci 0000:71:00.0:   bridge window [mem 0xde800000-0xdebfffff]
[    0.310907] pci 0000:71:00.0:   bridge window [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.311049] pci 0000:00:1c.6: PCI bridge to [bus 71-75]
[    0.311132] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
[    0.311218] pci 0000:00:1c.6:   bridge window [mem 0xde800000-0xdecfffff]
[    0.311305] pci 0000:00:1c.6:   bridge window [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.311442] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.311443] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.311444] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.311445] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.311445] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.311446] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff]
[    0.311447] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000e3fff]
[    0.311448] pci_bus 0000:00: resource 11 [mem 0x000e4000-0x000e7fff]
[    0.311449] pci_bus 0000:00: resource 12 [mem 0x6fa00000-0xfeafffff]
[    0.311449] pci_bus 0000:01: resource 1 [mem 0xdee00000-0xdeefffff]
[    0.311451] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.311451] pci_bus 0000:05: resource 1 [mem 0xc0000000-0xde0fffff]
[    0.311452] pci_bus 0000:05: resource 2 [mem 0x80000000-0xb9ffffff 64bit pref]
[    0.311453] pci_bus 0000:70: resource 0 [io  0xe000-0xefff]
[    0.311454] pci_bus 0000:70: resource 1 [mem 0xded00000-0xdedfffff]
[    0.311455] pci_bus 0000:71: resource 0 [io  0xd000-0xdfff]
[    0.311455] pci_bus 0000:71: resource 1 [mem 0xde800000-0xdecfffff]
[    0.311456] pci_bus 0000:71: resource 2 [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.311457] pci_bus 0000:72: resource 0 [io  0xd000-0xdfff]
[    0.311458] pci_bus 0000:72: resource 1 [mem 0xde800000-0xdebfffff]
[    0.311459] pci_bus 0000:72: resource 2 [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.311460] pci_bus 0000:73: resource 2 [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.311460] pci_bus 0000:74: resource 1 [mem 0xdeb00000-0xdebfffff]
[    0.311461] pci_bus 0000:75: resource 0 [io  0xd000-0xdfff]
[    0.311462] pci_bus 0000:75: resource 1 [mem 0xde800000-0xdeafffff]
[    0.311476] NET: Registered protocol family 2
[    0.311670] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.311938] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.312117] TCP: Hash tables configured (established 131072 bind 65536)
[    0.312211] TCP: reno registered
[    0.312302] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.312420] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.312555] NET: Registered protocol family 1
[    0.312642] pci 0000:00:02.0: Boot video device
[    0.327092] PCI: CLS mismatch (64 != 128), using 64 bytes
[    0.338106] Unpacking initramfs...
[    0.633448] Freeing initrd memory: 30848K (ffff8800343b0000 - ffff8800361d0000)
[    0.633584] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.633669] software IO TLB [mem 0x65b33000-0x69b33000] (64MB) mapped at [ffff880065b33000-ffff880069b32fff]
[    0.634030] RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
[    0.634454] AVX2 version of gcm_enc/dec engaged.
[    0.635647] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.635952] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.636052] Initialise system trusted keyring
[    0.636139] audit: initializing netlink subsys (disabled)
[    0.636231] audit: type=2000 audit(1401359308.560:1): initialized
[    0.650254] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.651079] zbud: loaded
[    0.651245] VFS: Disk quotas dquot_6.5.2
[    0.651343] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.651594] msgmni has been set to 31859
[    0.651702] Key type big_key registered
[    0.651795] SELinux:  Registering netfilter hooks
[    0.652370] alg: No test for stdrng (krng)
[    0.652454] NET: Registered protocol family 38
[    0.652536] Key type asymmetric registered
[    0.652617] Asymmetric key parser 'x509' registered
[    0.652715] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.652885] io scheduler noop registered
[    0.652966] io scheduler deadline registered
[    0.653061] io scheduler cfq registered (default)
[    0.653249] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.653480] pcieport 0000:01:00.0: irq 41 for MSI/MSI-X
[    0.653559] pcieport 0000:02:08.0: irq 42 for MSI/MSI-X
[    0.653636] pcieport 0000:02:10.0: irq 43 for MSI/MSI-X
[    0.653739] pcieport 0000:71:00.0: irq 44 for MSI/MSI-X
[    0.653902] pcieport 0000:72:01.0: irq 45 for MSI/MSI-X
[    0.654047] pcieport 0000:72:02.0: irq 46 for MSI/MSI-X
[    0.654189] pcieport 0000:72:03.0: irq 47 for MSI/MSI-X
[    0.654295] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.654386] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.654488] intel_idle: MWAIT substates: 0x42120
[    0.654489] intel_idle: v0.4 model 0x3C
[    0.654489] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.654692] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.654846] ACPI: Power Button [PWRB]
[    0.654948] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.655081] ACPI: Power Button [PWRF]
[    0.655194] ACPI: Fan [FAN0] (off)
[    0.655287] ACPI: Fan [FAN1] (off)
[    0.655379] ACPI: Fan [FAN2] (off)
[    0.655472] ACPI: Fan [FAN3] (off)
[    0.655563] ACPI: Fan [FAN4] (off)
[    0.655944] thermal LNXTHERM:00: registered as thermal_zone0
[    0.656028] ACPI: Thermal Zone [TZ00] (28 C)
[    0.656219] thermal LNXTHERM:01: registered as thermal_zone1
[    0.656303] ACPI: Thermal Zone [TZ01] (30 C)
[    0.656397] GHES: HEST is not enabled!
[    0.656502] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.677099] 00:08: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.677466] Non-volatile memory driver v1.3
[    0.677547] Linux agpgart interface v0.103
[    0.677696] ahci 0000:00:1f.2: version 3.0
[    0.677769] ahci 0000:00:1f.2: irq 48 for MSI/MSI-X
[    0.677800] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x29 impl SATA mode
[    0.677935] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part ems apst 
[    0.682091] scsi0 : ahci
[    0.682335] scsi1 : ahci
[    0.682587] scsi2 : ahci
[    0.682749] scsi3 : ahci
[    0.682908] scsi4 : ahci
[    0.683068] scsi5 : ahci
[    0.683175] ata1: SATA max UDMA/133 abar m2048@0xdef3a000 port 0xdef3a100 irq 48
[    0.683308] ata2: DUMMY
[    0.683386] ata3: DUMMY
[    0.683464] ata4: SATA max UDMA/133 abar m2048@0xdef3a000 port 0xdef3a280 irq 48
[    0.683596] ata5: DUMMY
[    0.683674] ata6: SATA max UDMA/133 abar m2048@0xdef3a000 port 0xdef3a380 irq 48
[    0.683883] ahci 0000:70:00.0: controller can do FBS, turning on CAP_FBS
[    0.684087] ahci 0000:70:00.0: irq 49 for MSI/MSI-X
[    0.694791] ahci 0000:70:00.0: AHCI 0001.0200 32 slots 8 ports 6 Gbps 0xff impl SATA mode
[    0.694926] ahci 0000:70:00.0: flags: 64bit ncq fbs pio 
[    0.695549] scsi6 : ahci
[    0.695894] scsi7 : ahci
[    0.696156] scsi8 : ahci
[    0.696331] scsi9 : ahci
[    0.696547] scsi10 : ahci
[    0.696815] scsi11 : ahci
[    0.697028] scsi12 : ahci
[    0.697220] scsi13 : ahci
[    0.697319] ata7: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10100 irq 49
[    0.697452] ata8: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10180 irq 49
[    0.697585] ata9: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10200 irq 49
[    0.697722] ata10: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10280 irq 49
[    0.697855] ata11: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10300 irq 49
[    0.697988] ata12: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10380 irq 49
[    0.698121] ata13: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10400 irq 49
[    0.698254] ata14: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10480 irq 49
[    0.698430] libphy: Fixed MDIO Bus: probed
[    0.698723] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.698954] ehci-pci: EHCI PCI platform driver
[    0.699276] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.699581] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.699728] ehci-pci 0000:00:1a.0: debug port 2
[    0.703690] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.703698] ehci-pci 0000:00:1a.0: irq 16, io mem 0xdef3c000
[    0.709714] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.709824] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.709908] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.710041] usb usb1: Product: EHCI Host Controller
[    0.710122] usb usb1: Manufacturer: Linux 3.15.0-rc7+ ehci_hcd
[    0.711620] usb usb1: SerialNumber: 0000:00:1a.0
[    0.711779] hub 1-0:1.0: USB hub found
[    0.711860] hub 1-0:1.0: 2 ports detected
[    0.712040] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.712157] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.712297] ehci-pci 0000:00:1d.0: debug port 2
[    0.716252] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.716260] ehci-pci 0000:00:1d.0: irq 23, io mem 0xdef3b000
[    0.721704] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.721807] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.721891] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.722023] usb usb2: Product: EHCI Host Controller
[    0.722103] usb usb2: Manufacturer: Linux 3.15.0-rc7+ ehci_hcd
[    0.722186] usb usb2: SerialNumber: 0000:00:1d.0
[    0.722420] hub 2-0:1.0: USB hub found
[    0.722503] hub 2-0:1.0: 2 ports detected
[    0.722642] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.722737] ohci-pci: OHCI PCI platform driver
[    0.722822] uhci_hcd: USB Universal Host Controller Interface driver
[    0.722968] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.723140] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    0.723340] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.723350] xhci_hcd 0000:00:14.0: irq 50 for MSI/MSI-X
[    0.723385] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.723469] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.723601] usb usb3: Product: xHCI Host Controller
[    0.723682] usb usb3: Manufacturer: Linux 3.15.0-rc7+ xhci_hcd
[    0.723772] usb usb3: SerialNumber: 0000:00:14.0
[    0.724009] hub 3-0:1.0: USB hub found
[    0.724103] hub 3-0:1.0: 14 ports detected
[    0.725519] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.725698] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    0.725857] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    0.725941] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.726073] usb usb4: Product: xHCI Host Controller
[    0.726154] usb usb4: Manufacturer: Linux 3.15.0-rc7+ xhci_hcd
[    0.726236] usb usb4: SerialNumber: 0000:00:14.0
[    0.726473] hub 4-0:1.0: USB hub found
[    0.726562] hub 4-0:1.0: 6 ports detected
[    0.727264] usbcore: registered new interface driver usbserial
[    0.727351] usbcore: registered new interface driver usbserial_generic
[    0.727437] usbserial: USB Serial support registered for generic
[    0.727533] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.728005] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.728089] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.728319] mousedev: PS/2 mouse device common for all mice
[    0.728675] rtc_cmos 00:05: RTC can wake from S4
[    0.728955] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.729060] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.729224] device-mapper: uevent: version 1.0.3
[    0.729439] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    0.729707] Intel P-state driver initializing.
[    0.729796] Intel pstate controlling: cpu 0
[    0.729886] Intel pstate controlling: cpu 1
[    0.729972] Intel pstate controlling: cpu 2
[    0.730057] Intel pstate controlling: cpu 3
[    0.730144] Intel pstate controlling: cpu 4
[    0.730229] Intel pstate controlling: cpu 5
[    0.730315] Intel pstate controlling: cpu 6
[    0.730401] Intel pstate controlling: cpu 7
[    0.730657] hidraw: raw HID events driver (C) Jiri Kosina
[    0.730790] usbcore: registered new interface driver usbhid
[    0.730872] usbhid: USB HID core driver
[    0.730961] drop_monitor: Initializing network drop monitor service
[    0.731076] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.731219] TCP: cubic registered
[    0.731324] Initializing XFRM netlink socket
[    0.731456] NET: Registered protocol family 10
[    0.731726] mip6: Mobile IPv6
[    0.731805] NET: Registered protocol family 17
[    0.732284] Loading compiled-in X.509 certificates
[    0.732819] Loaded X.509 cert 'Magrathea: Glacier signing key: fb8370f3759ac052fa9fffe28c75a517f71b2f24'
[    0.732958] registered taskstats version 1
[    0.733606]   Magic number: 14:159:478
[    0.733692] rtc rtc0: hash matches
[    0.733777] ata_port ata11: hash matches
[    0.733856]  ata11: hash matches
[    0.734032] rtc_cmos 00:05: setting system clock to 2014-05-29 10:28:29 UTC (1401359309)
[    0.734207] PM: Hibernation image not present or could not be loaded.
[    0.988537] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.988635] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.988756] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.988981] ata1.00: ATA-9: INTEL SSDSC2BB480G4, D2010370, max UDMA/133
[    0.989066] ata1.00: 937703088 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    0.989479] ata1.00: configured for UDMA/133
[    0.989790] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSC2BB48 D201 PQ: 0 ANSI: 5
[    0.990220] sd 0:0:0:0: [sda] 937703088 512-byte logical blocks: (480 GB/447 GiB)
[    0.990222] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.990318] ata4.00: ATA-8: WDC WD5000AAKX-753CA0, 15.01H15, max UDMA/133
[    0.990319] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.990731] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    0.991093] sd 0:0:0:0: [sda] Write Protect is off
[    0.991180] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.991183] ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.991184] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    0.991219] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.991563] ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    0.991590]  sda: sda1 sda2
[    0.991822] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.992180] ata4.00: configured for UDMA/133
[    0.992376] scsi 3:0:0:0: Direct-Access     ATA      WDC WD5000AAKX-7 15.0 PQ: 0 ANSI: 5
[    0.992696] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    0.992701] sd 3:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    0.992860] sd 3:0:0:0: [sdb] Write Protect is off
[    0.992861] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.992941] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.993477] ata6.00: ATAPI: ATAPI   iHAS124   W, HL0G, max UDMA/100
[    0.996025] ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.996027] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    0.996161] ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    0.997842] ata6.00: configured for UDMA/100
[    0.999028] scsi 5:0:0:0: CD-ROM            ATAPI    iHAS124   W      HL0G PQ: 0 ANSI: 5
[    1.002505] ata8: SATA link down (SStatus 0 SControl 300)
[    1.003507] ata13: SATA link down (SStatus 0 SControl 300)
[    1.003610] ata9: SATA link down (SStatus 0 SControl 300)
[    1.004520] ata10: SATA link down (SStatus 0 SControl 300)
[    1.004633] ata11: SATA link down (SStatus 0 SControl 300)
[    1.005529] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.005632] ata12: SATA link down (SStatus 0 SControl 300)
[    1.005750] ata7: SATA link down (SStatus 0 SControl 300)
[    1.005859] ata14.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
[    1.006145] ata14.00: configured for UDMA/66
[    1.013504] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.023074] sr0: scsi3-mmc drive: 188x/125x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.023208] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.023451] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    1.023575] sr 5:0:0:0: Attached scsi generic sg2 type 5
[    1.024072] scsi 13:0:0:0: Processor         Marvell  Console          1.01 PQ: 0 ANSI: 5
[    1.028684]  sdb: sdb1 sdb2 < sdb5 sdb6 >
[    1.029247] sd 3:0:0:0: [sdb] Attached SCSI disk
[    1.035469] ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[    1.035554] ata14.00: irq_stat 0x40000001
[    1.035635] scsi 13:0:0:0: CDB: 
[    1.035714] Inquiry: 12 01 00 00 ff 00
[    1.036009] ata14.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 3 dma 16640 in
         res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)
[    1.036247] ata14: hard resetting link
[    1.127738] usb 1-1: New USB device found, idVendor=8087, idProduct=8008
[    1.127823] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.128129] hub 1-1:1.0: USB hub found
[    1.128365] hub 1-1:1.0: 6 ports detected
[    1.231296] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.342219] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.342573] ata14.00: configured for UDMA/66
[    1.342736] ata14: EH complete
[    1.342903] scsi 13:0:0:0: Attached scsi generic sg3 type 3
[    1.343741] Freeing unused kernel memory: 1412K (ffffffff81d0b000 - ffffffff81e6c000)
[    1.343875] Write protecting the kernel read-only data: 12288k
[    1.345527] usb 2-1: New USB device found, idVendor=8087, idProduct=8000
[    1.345613] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.345904] Freeing unused kernel memory: 1324K (ffff8800016b5000 - ffff880001800000)
[    1.345918] hub 2-1:1.0: USB hub found
[    1.346032] hub 2-1:1.0: 8 ports detected
[    1.347793] Freeing unused kernel memory: 1088K (ffff880001af0000 - ffff880001c00000)
[    1.349377] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    1.349618] systemd[1]: Running in initial RAM disk.
[    1.350058] systemd[1]: Set hostname to <lahna>.
[    1.351823] random: systemd urandom read with 88 bits of entropy available
[    1.366065] systemd[1]: Expecting device dev-mapper-fedora\x2droot.device...
[    1.366380] systemd[1]: Starting -.slice.
[    1.366808] systemd[1]: Created slice -.slice.
[    1.366894] systemd[1]: Starting System Slice.
[    1.367280] systemd[1]: Created slice System Slice.
[    1.367366] systemd[1]: Starting Slices.
[    1.367671] systemd[1]: Reached target Slices.
[    1.367755] systemd[1]: Starting Timers.
[    1.368059] systemd[1]: Reached target Timers.
[    1.368145] systemd[1]: Starting udev Kernel Socket.
[    1.368513] systemd[1]: Listening on udev Kernel Socket.
[    1.368601] systemd[1]: Starting udev Control Socket.
[    1.368919] systemd[1]: Listening on udev Control Socket.
[    1.369006] systemd[1]: Starting Journal Socket.
[    1.369378] systemd[1]: Listening on Journal Socket.
[    1.369503] systemd[1]: Starting dracut cmdline hook...
[    1.369904] systemd[1]: Starting Apply Kernel Variables...
[    1.370387] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    1.370857] systemd[1]: Starting Sockets.
[    1.371213] systemd[1]: Reached target Sockets.
[    1.371317] systemd[1]: Starting Setup Virtual Console...
[    1.371729] systemd[1]: Starting Journal Service...
[    1.372403] systemd[1]: Started Journal Service.
[    1.443821] systemd-udevd[316]: starting version 208
[    1.465496] pps_core: LinuxPPS API ver. 1 registered
[    1.465590] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.470271] PTP clock support registered
[    1.473617] dca service started, version 1.12.1
[    1.496505] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    1.496594] igb: Copyright (c) 2007-2014 Intel Corporation.
[    1.499534] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    1.499623] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    1.499820] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.499975] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[    1.500070] usb 3-9: new high-speed USB device number 2 using xhci_hcd
[    1.507509] [drm] Initialized drm 1.1.0 20060810
[    1.526825] random: nonblocking pool is initialized
[    1.605162] igb 0000:75:00.0: irq 52 for MSI/MSI-X
[    1.605165] igb 0000:75:00.0: irq 53 for MSI/MSI-X
[    1.605167] igb 0000:75:00.0: irq 54 for MSI/MSI-X
[    1.605169] igb 0000:75:00.0: irq 55 for MSI/MSI-X
[    1.605171] igb 0000:75:00.0: irq 56 for MSI/MSI-X
[    1.634554] igb 0000:75:00.0: added PHC on eth0
[    1.634659] igb 0000:75:00.0: Intel(R) Gigabit Ethernet Network Connection
[    1.634762] igb 0000:75:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 74:d4:35:1b:fc:39
[    1.634939] igb 0000:75:00.0: eth0: PBA No: 000200-000
[    1.634946] tsc: Refined TSC clocksource calibration: 3491.910 MHz
[    1.635145] igb 0000:75:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    1.648994] systemd-udevd[324]: renamed network interface eth0 to p4p1
[    1.667234] usb 3-9: New USB device found, idVendor=045b, idProduct=0209
[    1.667385] usb 3-9: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.668127] hub 3-9:1.0: USB hub found
[    1.668302] hub 3-9:1.0: 4 ports detected
[    1.668411] e1000e 0000:00:19.0 eth0: registered PHC clock
[    1.668417] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 74:d4:35:1b:fc:26
[    1.668421] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    1.668472] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: FFFFFF-0FF
[    1.671101] [drm] Memory usable by graphics device = 2048M
[    1.739955] i915 0000:00:02.0: irq 57 for MSI/MSI-X
[    1.739966] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.740077] [drm] Driver supports precise vblank timestamp query.
[    1.740211] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.742954] systemd-udevd[318]: renamed network interface eth0 to em1
[    1.789606] fbcon: inteldrmfb (fb0) is primary device
[    1.822883] usb 3-10: new high-speed USB device number 3 using xhci_hcd
[    1.836591] Console: switching to colour frame buffer device 240x75
[    1.849446] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.849500] i915 0000:00:02.0: registered panic notifier
[    1.858463] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.859685] acpi device:70: registered as cooling_device13
[    1.859977] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    1.860243] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.987868] usb 3-10: New USB device found, idVendor=045b, idProduct=0209
[    1.987915] usb 3-10: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.988342] hub 3-10:1.0: USB hub found
[    1.988386] hub 3-10:1.0: 4 ports detected
[    2.090993] usb 4-5: new SuperSpeed USB device number 2 using xhci_hcd
[    2.103448] usb 4-5: New USB device found, idVendor=045b, idProduct=0210
[    2.103461] usb 4-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.104244] hub 4-5:1.0: USB hub found
[    2.104500] hub 4-5:1.0: 4 ports detected
[    2.207926] usb 4-6: new SuperSpeed USB device number 3 using xhci_hcd
[    2.219981] usb 4-6: New USB device found, idVendor=045b, idProduct=0210
[    2.219990] usb 4-6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.220787] hub 4-6:1.0: USB hub found
[    2.221058] hub 4-6:1.0: 4 ports detected
[    2.221711] PM: Starting manual resume from disk
[    2.221720] PM: Hibernation image partition 253:0 present
[    2.221722] PM: Looking for hibernation image.
[    2.221929] PM: Image not found (code -22)
[    2.221934] PM: Hibernation image not present or could not be loaded.
[    2.242822] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[    2.295477] usb 3-10.1: new low-speed USB device number 4 using xhci_hcd
[    2.385974] usb 3-10.1: New USB device found, idVendor=046d, idProduct=c52a
[    2.385984] usb 3-10.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.385989] usb 3-10.1: Product: 2.4GHz Cordless Desktop
[    2.385993] usb 3-10.1: Manufacturer: Logitech
[    2.386237] usb 3-10.1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    2.386244] usb 3-10.1: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
[    2.391982] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.1/3-10.1:1.0/0003:046D:C52A.0001/input/input6
[    2.392221] hid-generic 0003:046D:C52A.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:14.0-10.1/input0
[    2.401325] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.1/3-10.1:1.1/0003:046D:C52A.0002/input/input7
[    2.401808] hid-generic 0003:046D:C52A.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:14.0-10.1/input1
[    2.474317] usb 3-10.2: new high-speed USB device number 5 using xhci_hcd
[    2.556966] systemd-journald[177]: Received SIGTERM
[    2.559051] systemd-cgroups-agent[523]: Failed to get D-Bus connection: Failed to connect to socket /run/systemd/private: No such file or directory
[    2.559310] usb 3-10.2: New USB device found, idVendor=0409, idProduct=005a
[    2.559317] usb 3-10.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.559893] hub 3-10.2:1.0: USB hub found
[    2.559945] hub 3-10.2:1.0: 4 ports detected
[    2.627422] audit: type=1404 audit(1401359311.393:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    2.634310] Switched to clocksource tsc
[    2.664637] SELinux: 2048 avtab hash slots, 100018 rules.
[    2.698046] SELinux: 2048 avtab hash slots, 100018 rules.
[    2.738430] SELinux:  8 users, 86 roles, 4805 types, 281 bools, 1 sens, 1024 cats
[    2.738434] SELinux:  83 classes, 100018 rules
[    2.744282] SELinux:  Completing initialization.
[    2.744283] SELinux:  Setting up existing superblocks.
[    2.744292] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    2.744302] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    2.744309] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    2.744341] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.744406] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    2.745769] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    2.746937] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    2.746940] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    2.746945] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    2.746948] SELinux: initialized (dev aio, type aio), not configured for labeling
[    2.746951] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    2.746973] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    2.746988] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    2.746998] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    2.747013] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    2.747620] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    2.747622] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.747634] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.747782] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.747830] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.747835] SELinux: initialized (dev pstore, type pstore), uses genfs_contexts
[    2.747838] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.747840] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.747843] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.747851] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.747855] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.747857] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.747860] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.747868] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.747870] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.747874] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[    2.747877] SELinux: initialized (dev drm, type drm), not configured for labeling
[    2.747884] SELinux: initialized (dev dm-1, type ext4), uses xattr
[    2.766172] audit: type=1403 audit(1401359311.532:3): policy loaded auid=4294967295 ses=4294967295
[    2.772064] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    2.779073] systemd[1]: Successfully loaded SELinux policy in 153.311ms.
[    2.847471] systemd[1]: Relabelled /dev and /run in 39.540ms.
[    3.048755] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.048764] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    3.088968] systemd-udevd[573]: starting version 208
[    3.091143] EXT4-fs (dm-1): re-mounted. Opts: (null)
[    3.180222] wmi: Mapper loaded
[    3.233283] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.251546] i801_smbus 0000:00:1f.3: enabling device (0001 -> 0003)
[    3.251630] ACPI Warning: SystemIO range 0x000000000000f040-0x000000000000f05f conflicts with OpRegion 0x000000000000f040-0x000000000000f04f (\_SB_.PCI0.SBUS.SMBI) (20140214/utaddress-258)
[    3.251635] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.252784] mei_me 0000:00:16.0: irq 58 for MSI/MSI-X
[    3.280185] microcode: CPU0 sig=0x306c3, pf=0x2, revision=0x9
[    3.284855] microcode: CPU0 sig=0x306c3, pf=0x2, revision=0x9
[    3.286293] microcode: CPU0 updated to revision 0x17, date = 2013-08-16
[    3.291351] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x9
[    3.291384] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x9
[    3.292115] microcode: CPU1 updated to revision 0x17, date = 2013-08-16
[    3.292123] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x9
[    3.292151] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x9
[    3.292883] microcode: CPU2 updated to revision 0x17, date = 2013-08-16
[    3.292891] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x9
[    3.292915] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x9
[    3.293644] microcode: CPU3 updated to revision 0x17, date = 2013-08-16
[    3.293651] microcode: CPU4 sig=0x306c3, pf=0x2, revision=0x9
[    3.293673] microcode: CPU4 sig=0x306c3, pf=0x2, revision=0x9
[    3.294406] microcode: CPU4 updated to revision 0x17, date = 2013-08-16
[    3.294413] microcode: CPU5 sig=0x306c3, pf=0x2, revision=0x9
[    3.294439] microcode: CPU5 sig=0x306c3, pf=0x2, revision=0x9
[    3.295137] microcode: CPU5 updated to revision 0x17, date = 2013-08-16
[    3.295213] microcode: CPU6 sig=0x306c3, pf=0x2, revision=0x9
[    3.295237] microcode: CPU6 sig=0x306c3, pf=0x2, revision=0x9
[    3.295972] microcode: CPU6 updated to revision 0x17, date = 2013-08-16
[    3.296111] microcode: CPU7 sig=0x306c3, pf=0x2, revision=0x9
[    3.296136] microcode: CPU7 sig=0x306c3, pf=0x2, revision=0x9
[    3.296867] microcode: CPU7 updated to revision 0x17, date = 2013-08-16
[    3.296933] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.322579] alg: No test for crc32 (crc32-pclmul)
[    3.378072] iTCO_vendor_support: vendor-support=0
[    3.382665] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    3.382692] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[    3.387756] snd_hda_intel 0000:00:03.0: irq 59 for MSI/MSI-X
[    3.387855] snd_hda_intel 0000:00:1b.0: irq 60 for MSI/MSI-X
[    3.392949] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.393431] SELinux: initialized (dev sda1, type ext4), uses xattr
[    3.420171] Adding 8200188k swap on /dev/mapper/fedora-swap.  Priority:-1 extents:1 across:8200188k SSFS
[    3.475963] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input8
[    3.477624] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input9
[    3.478568] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input10
[    3.492640] sound hdaudioC1D2: autoconfig: line_outs=3 (0x14/0x15/0x16/0x0/0x0) type:line
[    3.492643] sound hdaudioC1D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    3.492644] sound hdaudioC1D2:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    3.492645] sound hdaudioC1D2:    mono: mono_out=0x0
[    3.492645] sound hdaudioC1D2:    dig-out=0x11/0x1e
[    3.492646] sound hdaudioC1D2:    inputs:
[    3.492648] sound hdaudioC1D2:      Front Mic=0x19
[    3.492650] sound hdaudioC1D2:      Rear Mic=0x18
[    3.492651] sound hdaudioC1D2:      Line=0x1a
[    3.492653] sound hdaudioC1D2:    dig-in=0x1f
[    3.505356] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input11
[    3.505412] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input12
[    3.505455] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card1/input13
[    3.505520] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card1/input14
[    3.505584] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card1/input15
[    3.505676] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card1/input16
[    3.505756] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input17
[    3.989559] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[    3.989575] SELinux: initialized (dev dm-2, type ext4), uses xattr
[    4.008542] systemd-journald[565]: Received request to flush runtime journal from PID 1
[    4.014267] audit: type=1305 audit(1401359312.781:4): audit_pid=833 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[    4.317343] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    4.362626] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    4.413622] Ebtables v2.0 registered
[    4.472262] Bridge firewalling registered
[    4.641902] cfg80211: Calling CRDA to update world regulatory domain
[    4.645595] cfg80211: World regulatory domain updated:
[    4.645599] cfg80211:  DFS Master region: unset
[    4.645600] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    4.645603] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    4.645605] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    4.645606] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    4.645607] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    4.645609] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    4.645611] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    4.910910] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[    5.014237] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[    5.115072] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[    5.115225] IPv6: ADDRCONF(NETDEV_UP): em1: link is not ready
[    5.262605] Bluetooth: Core ver 2.19
[    5.262673] NET: Registered protocol family 31
[    5.262675] Bluetooth: HCI device and connection manager initialized
[    5.262681] Bluetooth: HCI socket layer initialized
[    5.262683] Bluetooth: L2CAP socket layer initialized
[    5.262689] Bluetooth: SCO socket layer initialized
[    5.276135] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.276138] Bluetooth: BNEP filters: protocol multicast
[    5.276146] Bluetooth: BNEP socket layer initialized
[   12.731461] fuse init (API version 7.23)
[   12.735753] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[   12.752731] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   13.249800] e1000e: em1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   13.249846] IPv6: ADDRCONF(NETDEV_CHANGE): em1: link becomes ready
[   44.225502] usb 3-10.4: new high-speed USB device number 6 using xhci_hcd
[   44.317214] usb 3-10.4: New USB device found, idVendor=8564, idProduct=1000
[   44.317222] usb 3-10.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   44.317227] usb 3-10.4: Product: Mass Storage Device
[   44.317230] usb 3-10.4: Manufacturer: JetFlash
[   44.317233] usb 3-10.4: SerialNumber: 9EAOZJ51
[   44.388821] usb-storage 3-10.4:1.0: USB Mass Storage device detected
[   44.388999] scsi14 : usb-storage 3-10.4:1.0
[   44.389156] usbcore: registered new interface driver usb-storage
[   45.390066] scsi 14:0:0:0: Direct-Access     JetFlash Transcend 4GB    8.07 PQ: 0 ANSI: 4
[   45.391078] sd 14:0:0:0: Attached scsi generic sg4 type 0
[   45.391466] sd 14:0:0:0: [sdc] 7864320 512-byte logical blocks: (4.02 GB/3.75 GiB)
[   45.392180] sd 14:0:0:0: [sdc] Write Protect is off
[   45.392191] sd 14:0:0:0: [sdc] Mode Sense: 23 00 00 00
[   45.392946] sd 14:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   45.397427]  sdc: sdc1
[   45.400500] sd 14:0:0:0: [sdc] Attached SCSI removable disk
[   48.397724] usb 3-10.4: USB disconnect, device number 6
[   75.914061] BUG: soft lockup - CPU#4 stuck for 22s! [systemd-udevd:1692]
[   75.914063] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal coretemp kvm_intel snd_hda_codec_hdmi kvm snd_hda_intel iTCO_wdt iTCO_vendor_support snd_hda_controller mxm_wmi snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul crc32c_intel snd_seq_device ghash_clmulni_intel snd_pcm microcode serio_raw snd_timer joydev snd mei_me i2c_i801 mei lpc_ich mfd_core
[   75.914085]  shpchp soundcore wmi i915 drm_kms_helper drm e1000e igb dca i2c_algo_bit ptp i2c_core pps_core video
[   75.914091] CPU: 4 PID: 1692 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[   75.914092] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[   75.914093] task: ffff8804718012a0 ti: ffff88047706a000 task.ti: ffff88047706a000
[   75.914094] RIP: 0010:[<ffffffff816a5283>]  [<ffffffff816a5283>] _raw_spin_lock+0x13/0x30
[   75.914097] RSP: 0018:ffff88047706bb50  EFLAGS: 00000202
[   75.914098] RAX: 0000000000007170 RBX: ffffffff812460f6 RCX: 0000000100007170
[   75.914099] RDX: 000000000000fbf8 RSI: 0000000000000001 RDI: ffff88044f293358
[   75.914099] RBP: ffff88047706bb50 R08: ffff8804764f99a0 R09: 0000000180240008
[   75.914100] R10: ffffffff812460f6 R11: ffffea0011d93e40 R12: ffff88047706bae8
[   75.914100] R13: ffff88047706bb40 R14: ffff88044fdc6c00 R15: ffff8804764f9930
[   75.914101] FS:  00007fce62933880(0000) GS:ffff88048f300000(0000) knlGS:0000000000000000
[   75.914102] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   75.914103] CR2: 00007fce62943000 CR3: 000000047535f000 CR4: 00000000001407e0
[   75.914104] Stack:
[   75.914104]  ffff88047706bb68 ffffffff81338328 ffff88044f293300 ffff88047706bba0
[   75.914105]  ffffffff811e79dd ffff88047706bbb8 ffff88044f0cf000 000000000000002e
[   75.914107]  ffff88047706bdd0 0000000000000001 ffff88047706bbe8 ffffffff811e8294
[   75.914108] Call Trace:
[   75.914112]  [<ffffffff81338328>] lockref_put_or_lock+0x48/0x70
[   75.914113]  [<ffffffff811e79dd>] shrink_dentry_list+0x12d/0x1e0
[   75.914115]  [<ffffffff811e8294>] check_submounts_and_drop+0x74/0xa0
[   75.914117]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[   75.914119]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[   75.914121]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[   75.914122]  [<ffffffff811e7638>] ? __dentry_kill+0x148/0x1c0
[   75.914125]  [<ffffffff811efd04>] ? mntput+0x24/0x40
[   75.914126]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[   75.914128]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[   75.914131]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[   75.914132]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[   75.914134]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[   75.914135]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[   75.914136]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[   75.914137]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[   75.914139]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[   75.914140]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[   75.914142]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[   75.914144]  [<ffffffff811d65ff>] SYSC_newstat+0x1f/0x40
[   75.914146]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[   75.914148]  [<ffffffff811d683e>] SyS_newstat+0xe/0x10
[   75.914150]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[   75.914150] Code: 00 00 f0 81 2f 00 00 10 00 74 05 e8 58 2c c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 <0f> b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 38 d0 75 f7 5d c3 66 
[  103.885208] BUG: soft lockup - CPU#4 stuck for 22s! [systemd-udevd:1692]
[  103.885211] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal coretemp kvm_intel snd_hda_codec_hdmi kvm snd_hda_intel iTCO_wdt iTCO_vendor_support snd_hda_controller mxm_wmi snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul crc32c_intel snd_seq_device ghash_clmulni_intel snd_pcm microcode serio_raw snd_timer joydev snd mei_me i2c_i801 mei lpc_ich mfd_core
[  103.885234]  shpchp soundcore wmi i915 drm_kms_helper drm e1000e igb dca i2c_algo_bit ptp i2c_core pps_core video
[  103.885240] CPU: 4 PID: 1692 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  103.885241] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  103.885242] task: ffff8804718012a0 ti: ffff88047706a000 task.ti: ffff88047706a000
[  103.885243] RIP: 0010:[<ffffffff816a5283>]  [<ffffffff816a5283>] _raw_spin_lock+0x13/0x30
[  103.885246] RSP: 0018:ffff88047706bb50  EFLAGS: 00000286
[  103.885247] RAX: 000000000000a9a9 RBX: ffffffff812460f6 RCX: 000000010000a9a9
[  103.885248] RDX: 000000000000a9a9 RSI: 0000000000000001 RDI: ffff88044f293358
[  103.885249] RBP: ffff88047706bb50 R08: ffff8804764f99a0 R09: 0000000180240008
[  103.885249] R10: ffffffff812460f6 R11: ffffea0011d93e40 R12: ffff88047706bae8
[  103.885250] R13: ffff88047706bb40 R14: ffff88044fdc6c00 R15: ffff8804764f9930
[  103.885251] FS:  00007fce62933880(0000) GS:ffff88048f300000(0000) knlGS:0000000000000000
[  103.885251] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  103.885252] CR2: 00007fce62943000 CR3: 000000047535f000 CR4: 00000000001407e0
[  103.885253] Stack:
[  103.885254]  ffff88047706bb68 ffffffff81338328 ffff88044f293300 ffff88047706bba0
[  103.885255]  ffffffff811e79dd ffff88047706bbb8 ffff88044f0cf000 000000000000002e
[  103.885256]  ffff88047706bdd0 0000000000000001 ffff88047706bbe8 ffffffff811e8294
[  103.885257] Call Trace:
[  103.885261]  [<ffffffff81338328>] lockref_put_or_lock+0x48/0x70
[  103.885263]  [<ffffffff811e79dd>] shrink_dentry_list+0x12d/0x1e0
[  103.885264]  [<ffffffff811e8294>] check_submounts_and_drop+0x74/0xa0
[  103.885267]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  103.885268]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  103.885270]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  103.885272]  [<ffffffff811e7638>] ? __dentry_kill+0x148/0x1c0
[  103.885274]  [<ffffffff811efd04>] ? mntput+0x24/0x40
[  103.885275]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  103.885278]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  103.885280]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  103.885282]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  103.885283]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  103.885284]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  103.885286]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  103.885287]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  103.885288]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  103.885289]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  103.885291]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  103.885293]  [<ffffffff811d65ff>] SYSC_newstat+0x1f/0x40
[  103.885296]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  103.885297]  [<ffffffff811d683e>] SyS_newstat+0xe/0x10
[  103.885299]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  103.885300] Code: 00 00 f0 81 2f 00 00 10 00 74 05 e8 58 2c c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 <0f> b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 38 d0 75 f7 5d c3 66 
[  109.494356] INFO: rcu_sched self-detected stall on CPU { 4}  (t=60001 jiffies g=1145 c=1144 q=25966)
[  109.494360] sending NMI to all CPUs:
[  109.494363] NMI backtrace for cpu 5
[  109.494366] CPU: 5 PID: 1689 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  109.494368] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  109.494369] task: ffff8804718037e0 ti: ffff880473eb2000 task.ti: ffff880473eb2000
[  109.494371] RIP: 0010:[<ffffffff816a5291>]  [<ffffffff816a5291>] _raw_spin_lock+0x21/0x30
[  109.494375] RSP: 0018:ffff880473eb3b20  EFLAGS: 00000287
[  109.494376] RAX: 000000000000002f RBX: ffff88044f0cf0a0 RCX: ffff88044f0cf058
[  109.494377] RDX: 0000000000000030 RSI: ffff88044f0cf000 RDI: ffff88044f293358
[  109.494378] RBP: ffff880473eb3b20 R08: ffff880473eb2000 R09: 0000000000000001
[  109.494380] R10: dfed4b3078b505a0 R11: 0000000000001ffe R12: ffff88044f293300
[  109.494381] R13: ffff88044f293358 R14: ffff88044f0cf000 R15: ffff88044f293390
[  109.494382] FS:  00007fce62933880(0000) GS:ffff88048f340000(0000) knlGS:0000000000000000
[  109.494383] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  109.494385] CR2: 00007fce62943000 CR3: 00000004737d8000 CR4: 00000000001407e0
[  109.494386] Stack:
[  109.494387]  ffff880473eb3ba0 ffffffff811e7edf ffffffff811e7480 01ffffff816a1dea
[  109.494389]  ffff88044f0cf058 ffff88044f0cf058 ffff88044f0cf000 ffff88044f2938d0
[  109.494391]  ffffffff811e6ef0 ffff880473eb3bb0 0000051a00000000 ffff880473eb3bb8
[  109.494393] Call Trace:
[  109.494396]  [<ffffffff811e7edf>] d_walk+0xcf/0x280
[  109.494399]  [<ffffffff811e7480>] ? __d_drop+0xb0/0xb0
[  109.494401]  [<ffffffff811e6ef0>] ? select_collect+0xb0/0xb0
[  109.494403]  [<ffffffff811e8282>] check_submounts_and_drop+0x62/0xa0
[  109.494406]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  109.494408]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  109.494410]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  109.494413]  [<ffffffff811e7638>] ? __dentry_kill+0x148/0x1c0
[  109.494416]  [<ffffffff811efd04>] ? mntput+0x24/0x40
[  109.494418]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  109.494421]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  109.494424]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  109.494426]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  109.494428]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  109.494430]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  109.494432]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  109.494434]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  109.494436]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  109.494438]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  109.494440]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  109.494443]  [<ffffffff811d65ff>] SYSC_newstat+0x1f/0x40
[  109.494446]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  109.494448]  [<ffffffff811d683e>] SyS_newstat+0xe/0x10
[  109.494451]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  109.494452] Code: c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 <38> d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 
[  109.494473] NMI backtrace for cpu 7
[  109.494476] CPU: 7 PID: 573 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  109.494478] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  109.494479] task: ffff880470a4c130 ti: ffff88047458e000 task.ti: ffff88047458e000
[  109.494480] RIP: 0010:[<ffffffff816a528e>]  [<ffffffff816a528e>] _raw_spin_lock+0x1e/0x30
[  109.494483] RSP: 0018:ffff88047458fbc0  EFLAGS: 00000297
[  109.494485] RAX: 00000000000000b4 RBX: ffff88047458fc58 RCX: ffffffff811e7480
[  109.494486] RDX: 00000000000000b5 RSI: ffff88047458fc50 RDI: ffff88044f0cf058
[  109.494487] RBP: ffff88047458fbc0 R08: ffff88047458e000 R09: 0000000000000001
[  109.494488] R10: dfed4b1078bd05a0 R11: 0000000000000000 R12: ffff88044f0cf000
[  109.494489] R13: 0000000000000025 R14: ffff88047458fe50 R15: 0000000000000001
[  109.494490] FS:  00007fce62933880(0000) GS:ffff88048f3c0000(0000) knlGS:0000000000000000
[  109.494492] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  109.494493] CR2: 00007f5b5e38b000 CR3: 0000000472f3f000 CR4: 00000000001407e0
[  109.494494] Stack:
[  109.494495]  ffff88047458fc40 ffffffff811e7e6c ffffffff811e7480 01ffffff816a1dea
[  109.494497]  ffff88044f0cf058 ffff88044f0cf058 ffff88044f0cf000 ffff88044f0cf0a0
[  109.494499]  ffffffff811e6ef0 ffff88047458fc50 0000051a00000000 ffff88047458fc58
[  109.494501] Call Trace:
[  109.494503]  [<ffffffff811e7e6c>] d_walk+0x5c/0x280
[  109.494506]  [<ffffffff811e7480>] ? __d_drop+0xb0/0xb0
[  109.494508]  [<ffffffff811e6ef0>] ? select_collect+0xb0/0xb0
[  109.494510]  [<ffffffff811e8282>] check_submounts_and_drop+0x62/0xa0
[  109.494513]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  109.494514]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  109.494517]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  109.494519]  [<ffffffff812c5c26>] ? security_file_alloc+0x16/0x20
[  109.494521]  [<ffffffff811e0cbc>] path_openat+0x9c/0x660
[  109.494525]  [<ffffffff81163c81>] ? __generic_file_aio_write+0x1d1/0x3f0
[  109.494527]  [<ffffffff811e1a7a>] do_filp_open+0x3a/0x90
[  109.494529]  [<ffffffff811eddfd>] ? __alloc_fd+0x7d/0x120
[  109.494531]  [<ffffffff811d0ade>] do_sys_open+0x12e/0x210
[  109.494533]  [<ffffffff811d0bde>] SyS_open+0x1e/0x20
[  109.494535]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  109.494536] Code: e8 58 2c c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 <0f> b6 07 38 d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 
[  109.494558] NMI backtrace for cpu 2
[  109.494561] CPU: 2 PID: 1696 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  109.494562] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  109.494564] task: ffff880471804a80 ti: ffff8804777f0000 task.ti: ffff8804777f0000
[  109.494565] RIP: 0010:[<ffffffff816a5291>]  [<ffffffff816a5291>] _raw_spin_lock+0x21/0x30
[  109.494568] RSP: 0018:ffff8804777f1bb0  EFLAGS: 00000293
[  109.494569] RAX: 00000000000000b4 RBX: ffff8804777f1c48 RCX: ffffffff811e7480
[  109.494570] RDX: 00000000000000b6 RSI: ffff8804777f1c40 RDI: ffff88044f0cf058
[  109.494571] RBP: ffff8804777f1bb0 R08: ffff8804777f0000 R09: 0000000000000001
[  109.494572] R10: dfedaa2ec4d56ca8 R11: 0000000000001ffe R12: ffff88044f0cf000
[  109.494573] R13: 0000000000000025 R14: ffff8804777f1e60 R15: 0000000000000001
[  109.494575] FS:  00007fce62933880(0000) GS:ffff88048f280000(0000) knlGS:0000000000000000
[  109.494576] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  109.494577] CR2: 00007fce62943000 CR3: 00000004736fe000 CR4: 00000000001407e0
[  109.494578] Stack:
[  109.494579]  ffff8804777f1c30 ffffffff811e7e6c ffffffff811e7480 0100000000001ffe
[  109.494581]  ffff88044f0cf058 ffff88044f0cf058 ffff88044f0cf000 ffff88044f0cf0a0
[  109.494583]  ffffffff811e6ef0 ffff8804777f1c40 0000051a00000000 ffff8804777f1c48
[  109.494585] Call Trace:
[  109.494588]  [<ffffffff811e7e6c>] d_walk+0x5c/0x280
[  109.494590]  [<ffffffff811e7480>] ? __d_drop+0xb0/0xb0
[  109.494592]  [<ffffffff811e6ef0>] ? select_collect+0xb0/0xb0
[  109.494594]  [<ffffffff811e8282>] check_submounts_and_drop+0x62/0xa0
[  109.494596]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  109.494598]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  109.494600]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  109.494603]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  109.494605]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  109.494607]  [<ffffffff8118896c>] ? tlb_flush_mmu_free+0x2c/0x50
[  109.494609]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  109.494611]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  109.494613]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  109.494615]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  109.494618]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  109.494620]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  109.494623]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  109.494625]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  109.494626] Code: c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 <38> d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 
[  109.494647] NMI backtrace for cpu 4
[  109.494649] CPU: 4 PID: 1692 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  109.494650] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  109.494651] task: ffff8804718012a0 ti: ffff88047706a000 task.ti: ffff88047706a000
[  109.494653] RIP: 0010:[<ffffffff81336ad2>]  [<ffffffff81336ad2>] __const_udelay+0x12/0x30
[  109.494656] RSP: 0018:ffff88048f303df0  EFLAGS: 00000086
[  109.494657] RAX: 0000000001062560 RBX: 0000000000002710 RCX: 00000000ff000000
[  109.494659] RDX: 000000000035488c RSI: ffffffff81c27ec0 RDI: 0000000000418958
[  109.494660] RBP: ffff88048f303e08 R08: 000000000000000a R09: 00000000000004d6
[  109.494661] R10: 0000000000000000 R11: ffff88048f303b3e R12: ffffffff81c4f7c0
[  109.494662] R13: ffffffff81cfdb38 R14: ffffffff81c4f7c0 R15: 0000000000000004
[  109.494663] FS:  00007fce62933880(0000) GS:ffff88048f300000(0000) knlGS:0000000000000000
[  109.494665] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  109.494666] CR2: 00007fce62943000 CR3: 000000047535f000 CR4: 00000000001407e0
[  109.494667] Stack:
[  109.494668]  ffff88048f303e08 ffffffff810448ce ffff88048f30eac0 ffff88048f303e60
[  109.494670]  ffffffff810e415e ffff88048f303e60 ffffffff810b8a01 000000198a642120
[  109.494672]  000000000000656e ffff8804718012a0 0000000000000000 0000000000000004
[  109.494674] Call Trace:
[  109.494675]  <IRQ> 

[  109.494679]  [<ffffffff810448ce>] ? arch_trigger_all_cpu_backtrace+0x5e/0x80
[  109.494682]  [<ffffffff810e415e>] rcu_check_callbacks+0x3fe/0x660
[  109.494685]  [<ffffffff810b8a01>] ? account_process_tick+0x121/0x1b0
[  109.494688]  [<ffffffff81091627>] update_process_times+0x47/0x70
[  109.494691]  [<ffffffff810ee935>] tick_sched_handle.isra.16+0x25/0x60
[  109.494693]  [<ffffffff810ee9b1>] tick_sched_timer+0x41/0x60
[  109.494696]  [<ffffffff810a8493>] __run_hrtimer+0x73/0x1d0
[  109.494698]  [<ffffffff810ee970>] ? tick_sched_handle.isra.16+0x60/0x60
[  109.494700]  [<ffffffff810a8c67>] hrtimer_interrupt+0xf7/0x240
[  109.494703]  [<ffffffff81042c37>] local_apic_timer_interrupt+0x37/0x60
[  109.494705]  [<ffffffff816b01af>] smp_apic_timer_interrupt+0x3f/0x60
[  109.494707]  [<ffffffff816aeb9d>] apic_timer_interrupt+0x6d/0x80
[  109.494708]  <EOI> 

[  109.494711]  [<ffffffff812460f6>] ? kernfs_put+0x106/0x1d0
[  109.494713]  [<ffffffff812460f6>] ? kernfs_put+0x106/0x1d0
[  109.494715]  [<ffffffff811e771a>] ? dentry_kill+0x6a/0x80
[  109.494717]  [<ffffffff811e79c8>] shrink_dentry_list+0x118/0x1e0
[  109.494719]  [<ffffffff811e8294>] check_submounts_and_drop+0x74/0xa0
[  109.494721]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  109.494723]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  109.494725]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  109.494727]  [<ffffffff811e7638>] ? __dentry_kill+0x148/0x1c0
[  109.494729]  [<ffffffff811efd04>] ? mntput+0x24/0x40
[  109.494731]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  109.494733]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  109.494736]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  109.494737]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  109.494739]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  109.494741]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  109.494743]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  109.494745]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  109.494747]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  109.494749]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  109.494751]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  109.494753]  [<ffffffff811d65ff>] SYSC_newstat+0x1f/0x40
[  109.494756]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  109.494758]  [<ffffffff811d683e>] SyS_newstat+0xe/0x10
[  109.494760]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  109.494761] Code: 89 e5 ff 15 09 1b 96 00 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 8d 04 bd 00 00 00 00 65 48 8b 14 25 60 3e 01 00 <48> 89 e5 48 69 d2 fa 00 00 00 f7 e2 48 8d 7a 01 ff 15 d0 1a 96 
[  109.494782] NMI backtrace for cpu 0
[  109.494784] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G          I   3.15.0-rc7+ #15
[  109.494785] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  109.494786] task: ffffffff81c16460 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[  109.494787] RIP: 0010:[<ffffffff8139d6ba>]  [<ffffffff8139d6ba>] intel_idle+0xda/0x160
[  109.494791] RSP: 0018:ffffffff81c01e60  EFLAGS: 00000046
[  109.494792] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  109.494793] RDX: 0000000000000000 RSI: ffffffff81c9c9a0 RDI: 0000000000000000
[  109.494794] RBP: ffffffff81c01e88 R08: 00000000ffffffff R09: 0000000000001aae
[  109.494795] R10: 00000000000019ef R11: 0000000000000008 R12: 0000000000000005
[  109.494796] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c9cb70
[  109.494797] FS:  0000000000000000(0000) GS:ffff88048f200000(0000) knlGS:0000000000000000
[  109.494798] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  109.494799] CR2: 00007f204a0eb000 CR3: 0000000001c0f000 CR4: 00000000001407f0
[  109.494800] Stack:
[  109.494801]  0000000081c01e88 ffff88048f21a840 ffffffff81c9c9a0 000000198a736a3c
[  109.494803]  0000000000000005 ffffffff81c01ec0 ffffffff81546470 ffffffff81cfdb30
[  109.494805]  ffff88048f21a840 ffffffff81c9c9a0 ffffffff81c01fd8 ffffffff81c00000
[  109.494807] Call Trace:
[  109.494809]  [<ffffffff81546470>] cpuidle_enter_state+0x40/0xc0
[  109.494811]  [<ffffffff81546527>] cpuidle_enter+0x17/0x20
[  109.494814]  [<ffffffff810c8410>] cpu_startup_entry+0x2c0/0x3d0
[  109.494816]  [<ffffffff816901e7>] rest_init+0x77/0x80
[  109.494819]  [<ffffffff81d21f2d>] start_kernel+0x3fa/0x405
[  109.494821]  [<ffffffff81d2193c>] ? repair_env_string+0x5c/0x5c
[  109.494823]  [<ffffffff81d21120>] ? early_idt_handlers+0x120/0x120
[  109.494825]  [<ffffffff81d215ee>] x86_64_start_reservations+0x2a/0x2c
[  109.494827]  [<ffffffff81d2172e>] x86_64_start_kernel+0x13e/0x14d
[  109.494828] Code: c7 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 65 48 8b 04 25 c8 c7 00 00 48 8b 80 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 04 25 c8 c7 00 00 83 a0 3c e0 ff ff fb 0f ae f0 65 48 
[  109.494848] NMI backtrace for cpu 1
[  109.494850] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G          I   3.15.0-rc7+ #15
[  109.494851] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  109.494852] task: ffff880478d55d20 ti: ffff880478e10000 task.ti: ffff880478e10000
[  109.494853] RIP: 0010:[<ffffffff8139d6ba>]  [<ffffffff8139d6ba>] intel_idle+0xda/0x160
[  109.494856] RSP: 0018:ffff880478e11e58  EFLAGS: 00000046
[  109.494857] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  109.494858] RDX: 0000000000000000 RSI: ffffffff81c9c9a0 RDI: 0000000000000001
[  109.494859] RBP: ffff880478e11e80 R08: 00000000ffffffff R09: 0000000000001ab0
[  109.494860] R10: 00000000000019fd R11: 0000000000000008 R12: 0000000000000005
[  109.494861] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c9cb70
[  109.494862] FS:  0000000000000000(0000) GS:ffff88048f240000(0000) knlGS:0000000000000000
[  109.494863] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  109.494864] CR2: 00007fbd6efdccb0 CR3: 0000000001c0f000 CR4: 00000000001407e0
[  109.494865] Stack:
[  109.494866]  0000000178e11e80 ffff88048f25a840 ffffffff81c9c9a0 000000198a736a37
[  109.494868]  0000000000000005 ffff880478e11eb8 ffffffff81546470 ffffffff81cfdb30
[  109.494870]  ffff88048f25a840 ffffffff81c9c9a0 ffff880478e11fd8 ffff880478e10000
[  109.494872] Call Trace:
[  109.494874]  [<ffffffff81546470>] cpuidle_enter_state+0x40/0xc0
[  109.494876]  [<ffffffff81546527>] cpuidle_enter+0x17/0x20
[  109.494878]  [<ffffffff810c8410>] cpu_startup_entry+0x2c0/0x3d0
[  109.494881]  [<ffffffff81040d64>] start_secondary+0x1c4/0x280
[  109.494882] Code: c7 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 65 48 8b 04 25 c8 c7 00 00 48 8b 80 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 04 25 c8 c7 00 00 83 a0 3c e0 ff ff fb 0f ae f0 65 48 
[  109.494902] NMI backtrace for cpu 6
[  109.494905] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G          I   3.15.0-rc7+ #15
[  109.494906] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  109.494907] task: ffff880478e192a0 ti: ffff880478e22000 task.ti: ffff880478e22000
[  109.494908] RIP: 0010:[<ffffffff8139d6ba>]  [<ffffffff8139d6ba>] intel_idle+0xda/0x160
[  109.494910] RSP: 0018:ffff880478e23e58  EFLAGS: 00000046
[  109.494911] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  109.494912] RDX: 0000000000000000 RSI: ffffffff81c9c9a0 RDI: 0000000000000006
[  109.494913] RBP: ffff880478e23e80 R08: 00000000ffffffff R09: 0000000000001ab0
[  109.494914] R10: 00000000000019fe R11: 0000000000000008 R12: 0000000000000005
[  109.494915] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c9cb70
[  109.494917] FS:  0000000000000000(0000) GS:ffff88048f380000(0000) knlGS:0000000000000000
[  109.494918] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  109.494919] CR2: 00007f3154366780 CR3: 0000000001c0f000 CR4: 00000000001407e0
[  109.494920] Stack:
[  109.494921]  0000000678e23e80 ffff88048f39a840 ffffffff81c9c9a0 000000198a736aa6
[  109.494923]  0000000000000005 ffff880478e23eb8 ffffffff81546470 ffffffff81cfdb30
[  109.494924]  ffff88048f39a840 ffffffff81c9c9a0 ffff880478e23fd8 ffff880478e22000
[  109.494926] Call Trace:
[  109.494928]  [<ffffffff81546470>] cpuidle_enter_state+0x40/0xc0
[  109.494930]  [<ffffffff81546527>] cpuidle_enter+0x17/0x20
[  109.494933]  [<ffffffff810c8410>] cpu_startup_entry+0x2c0/0x3d0
[  109.494935]  [<ffffffff81040d64>] start_secondary+0x1c4/0x280
[  109.494936] Code: c7 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 65 48 8b 04 25 c8 c7 00 00 48 8b 80 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 04 25 c8 c7 00 00 83 a0 3c e0 ff ff fb 0f ae f0 65 48 
[  109.494956] NMI backtrace for cpu 3
[  109.494958] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G          I   3.15.0-rc7+ #15
[  109.494959] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  109.494961] task: ffff880478d56fc0 ti: ffff880478e14000 task.ti: ffff880478e14000
[  109.494961] RIP: 0010:[<ffffffff8139d6ba>]  [<ffffffff8139d6ba>] intel_idle+0xda/0x160
[  109.494964] RSP: 0018:ffff880478e15e58  EFLAGS: 00000046
[  109.494965] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  109.494966] RDX: 0000000000000000 RSI: ffffffff81c9c9a0 RDI: 0000000000000003
[  109.494967] RBP: ffff880478e15e80 R08: 00000000ffffffff R09: 0000000000001aae
[  109.494968] R10: 00000000000019ef R11: 0000000000000008 R12: 0000000000000005
[  109.494969] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c9cb70
[  109.494971] FS:  0000000000000000(0000) GS:ffff88048f2c0000(0000) knlGS:0000000000000000
[  109.494972] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  109.494973] CR2: 00000000014ae818 CR3: 0000000001c0f000 CR4: 00000000001407e0
[  109.494974] Stack:
[  109.494974]  0000000378e15e80 ffff88048f2da840 ffffffff81c9c9a0 000000198a737087
[  109.494976]  0000000000000005 ffff880478e15eb8 ffffffff81546470 ffffffff81cfdb30
[  109.494978]  ffff88048f2da840 ffffffff81c9c9a0 ffff880478e15fd8 ffff880478e14000
[  109.494980] Call Trace:
[  109.494982]  [<ffffffff81546470>] cpuidle_enter_state+0x40/0xc0
[  109.494984]  [<ffffffff81546527>] cpuidle_enter+0x17/0x20
[  109.494987]  [<ffffffff810c8410>] cpu_startup_entry+0x2c0/0x3d0
[  109.494989]  [<ffffffff81040d64>] start_secondary+0x1c4/0x280
[  109.494990] Code: c7 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 65 48 8b 04 25 c8 c7 00 00 48 8b 80 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 04 25 c8 c7 00 00 83 a0 3c e0 ff ff fb 0f ae f0 65 48 
[  109.495356] INFO: rcu_sched detected stalls on CPUs/tasks: { 4} (detected by 1, t=60002 jiffies, g=1145, c=1144, q=25966)
[  135.858199] BUG: soft lockup - CPU#4 stuck for 22s! [systemd-udevd:1692]
[  135.858201] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal coretemp kvm_intel snd_hda_codec_hdmi kvm snd_hda_intel iTCO_wdt iTCO_vendor_support snd_hda_controller mxm_wmi snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul crc32c_intel snd_seq_device ghash_clmulni_intel snd_pcm microcode serio_raw snd_timer joydev snd mei_me i2c_i801 mei lpc_ich mfd_core
[  135.858243]  shpchp soundcore wmi i915 drm_kms_helper drm e1000e igb dca i2c_algo_bit ptp i2c_core pps_core video
[  135.858249] CPU: 4 PID: 1692 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  135.858250] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  135.858251] task: ffff8804718012a0 ti: ffff88047706a000 task.ti: ffff88047706a000
[  135.858251] RIP: 0010:[<ffffffff811e79c0>]  [<ffffffff811e79c0>] shrink_dentry_list+0x110/0x1e0
[  135.858254] RSP: 0018:ffff88047706bb78  EFLAGS: 00000246
[  135.858255] RAX: 0000000000000000 RBX: 0000000000001d1c RCX: 0000000100004141
[  135.858256] RDX: 0000000000000041 RSI: 0000000000000001 RDI: ffff88044f293358
[  135.858256] RBP: ffff88047706bba0 R08: ffff8804764f99a0 R09: 0000000180240008
[  135.858257] R10: ffffffff812460f6 R11: ffffea0011d93e40 R12: ffff8804764f99a0
[  135.858258] R13: 0000000180240008 R14: ffffffff812460f6 R15: ffffea0011d93e40
[  135.858259] FS:  00007fce62933880(0000) GS:ffff88048f300000(0000) knlGS:0000000000000000
[  135.858259] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  135.858260] CR2: 00007fce62943000 CR3: 000000047535f000 CR4: 00000000001407e0
[  135.858261] Stack:
[  135.858262]  ffff88047706bbb8 ffff88044f0cf000 000000000000002e ffff88047706bdd0
[  135.858263]  0000000000000001 ffff88047706bbe8 ffffffff811e8294 ffff88044f0cf000
[  135.858264]  ffff88044f0cf680 ffff88044f2938c0 000000000000002e ffff88044f0cf000
[  135.858265] Call Trace:
[  135.858267]  [<ffffffff811e8294>] check_submounts_and_drop+0x74/0xa0
[  135.858270]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  135.858272]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  135.858273]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  135.858275]  [<ffffffff811e7638>] ? __dentry_kill+0x148/0x1c0
[  135.858277]  [<ffffffff811efd04>] ? mntput+0x24/0x40
[  135.858279]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  135.858281]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  135.858284]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  135.858285]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  135.858286]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  135.858288]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  135.858289]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  135.858290]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  135.858291]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  135.858292]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  135.858295]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  135.858296]  [<ffffffff811d65ff>] SYSC_newstat+0x1f/0x40
[  135.858299]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  135.858301]  [<ffffffff811d683e>] SyS_newstat+0xe/0x10
[  135.858303]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  135.858303] Code: 00 00 e8 f4 d7 4b 00 85 c0 0f 84 a9 00 00 00 4c 89 f7 e8 44 fb ff ff 48 85 db 75 23 e9 0f ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 <48> 89 df e8 e8 fc ff ff 48 85 c0 48 89 c3 0f 84 f1 fe ff ff 48 
[  163.834547] BUG: soft lockup - CPU#4 stuck for 22s! [systemd-udevd:1692]
[  163.834550] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal coretemp kvm_intel snd_hda_codec_hdmi kvm snd_hda_intel iTCO_wdt iTCO_vendor_support snd_hda_controller mxm_wmi snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul crc32c_intel snd_seq_device ghash_clmulni_intel snd_pcm microcode serio_raw snd_timer joydev snd mei_me i2c_i801 mei lpc_ich mfd_core
[  163.834582]  shpchp soundcore wmi i915 drm_kms_helper drm e1000e igb dca i2c_algo_bit ptp i2c_core pps_core video
[  163.834597] CPU: 4 PID: 1692 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  163.834598] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  163.834599] task: ffff8804718012a0 ti: ffff88047706a000 task.ti: ffff88047706a000
[  163.834600] RIP: 0010:[<ffffffff816a5283>]  [<ffffffff816a5283>] _raw_spin_lock+0x13/0x30
[  163.834603] RSP: 0018:ffff88047706bb50  EFLAGS: 00000282
[  163.834604] RAX: 000000000000f4f4 RBX: ffffffff812460f6 RCX: 000000010000f4f4
[  163.834605] RDX: 000000000000f4f4 RSI: 0000000000000001 RDI: ffff88044f293358
[  163.834605] RBP: ffff88047706bb50 R08: ffff8804764f99a0 R09: 0000000180240008
[  163.834606] R10: ffffffff812460f6 R11: ffffea0011d93e40 R12: ffff88047706bae8
[  163.834607] R13: ffff88047706bb40 R14: ffff88044fdc6c00 R15: ffff8804764f9930
[  163.834608] FS:  00007fce62933880(0000) GS:ffff88048f300000(0000) knlGS:0000000000000000
[  163.834608] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  163.834609] CR2: 00007fce62943000 CR3: 000000047535f000 CR4: 00000000001407e0
[  163.834610] Stack:
[  163.834610]  ffff88047706bb68 ffffffff81338328 ffff88044f293300 ffff88047706bba0
[  163.834612]  ffffffff811e79dd ffff88047706bbb8 ffff88044f0cf000 000000000000002e
[  163.834613]  ffff88047706bdd0 0000000000000001 ffff88047706bbe8 ffffffff811e8294
[  163.834614] Call Trace:
[  163.834618]  [<ffffffff81338328>] lockref_put_or_lock+0x48/0x70
[  163.834620]  [<ffffffff811e79dd>] shrink_dentry_list+0x12d/0x1e0
[  163.834621]  [<ffffffff811e8294>] check_submounts_and_drop+0x74/0xa0
[  163.834624]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  163.834625]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  163.834627]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  163.834629]  [<ffffffff811e7638>] ? __dentry_kill+0x148/0x1c0
[  163.834631]  [<ffffffff811efd04>] ? mntput+0x24/0x40
[  163.834632]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  163.834635]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  163.834637]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  163.834639]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  163.834640]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  163.834641]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  163.834643]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  163.834644]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  163.834645]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  163.834646]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  163.834648]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  163.834650]  [<ffffffff811d65ff>] SYSC_newstat+0x1f/0x40
[  163.834653]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  163.834654]  [<ffffffff811d683e>] SyS_newstat+0xe/0x10
[  163.834656]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  163.834657] Code: 00 00 f0 81 2f 00 00 10 00 74 05 e8 58 2c c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 <0f> b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 38 d0 75 f7 5d c3 66 
[  191.810649] BUG: soft lockup - CPU#4 stuck for 22s! [systemd-udevd:1692]
[  191.810651] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal coretemp kvm_intel snd_hda_codec_hdmi kvm snd_hda_intel iTCO_wdt iTCO_vendor_support snd_hda_controller mxm_wmi snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul crc32c_intel snd_seq_device ghash_clmulni_intel snd_pcm microcode serio_raw snd_timer joydev snd mei_me i2c_i801 mei lpc_ich mfd_core
[  191.810693]  shpchp soundcore wmi i915 drm_kms_helper drm e1000e igb dca i2c_algo_bit ptp i2c_core pps_core video
[  191.810699] CPU: 4 PID: 1692 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  191.810699] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  191.810700] task: ffff8804718012a0 ti: ffff88047706a000 task.ti: ffff88047706a000
[  191.810701] RIP: 0010:[<ffffffff816a51b5>]  [<ffffffff816a51b5>] _raw_spin_trylock+0x25/0x40
[  191.810705] RSP: 0018:ffff88047706bb40  EFLAGS: 00000246
[  191.810705] RAX: 0000000000004b4b RBX: ffff88047706bae8 RCX: 0000000000004c4b
[  191.810706] RDX: 0000000000004b4b RSI: 0000000000000001 RDI: ffff88045a883688
[  191.810707] RBP: ffff88047706bb40 R08: ffff8804764f99a0 R09: 0000000180240008
[  191.810707] R10: ffffffff812460f6 R11: ffffea0011d93e40 R12: ffff88044fdc6c00
[  191.810708] R13: ffff8804764f9930 R14: ffff88047e84cf00 R15: ffff8804764f99a0
[  191.810709] FS:  00007fce62933880(0000) GS:ffff88048f300000(0000) knlGS:0000000000000000
[  191.810709] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  191.810710] CR2: 00007fce62943000 CR3: 000000047535f000 CR4: 00000000001407e0
[  191.810711] Stack:
[  191.810711]  ffff88047706bb68 ffffffff811e76d6 ffff88044f293300 ffff88044fdc6c80
[  191.810713]  ffff88047706bbb8 ffff88047706bba0 ffffffff811e79c8 ffff88047706bbb8
[  191.810714]  ffff88044f0cf000 000000000000002e ffff88047706bdd0 0000000000000001
[  191.810715] Call Trace:
[  191.810718]  [<ffffffff811e76d6>] dentry_kill+0x26/0x80
[  191.810719]  [<ffffffff811e79c8>] shrink_dentry_list+0x118/0x1e0
[  191.810720]  [<ffffffff811e8294>] check_submounts_and_drop+0x74/0xa0
[  191.810723]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  191.810725]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  191.810726]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  191.810728]  [<ffffffff811e7638>] ? __dentry_kill+0x148/0x1c0
[  191.810730]  [<ffffffff811efd04>] ? mntput+0x24/0x40
[  191.810731]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  191.810734]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  191.810736]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  191.810738]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  191.810739]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  191.810740]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  191.810742]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  191.810743]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  191.810744]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  191.810745]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  191.810747]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  191.810749]  [<ffffffff811d65ff>] SYSC_newstat+0x1f/0x40
[  191.810751]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  191.810753]  [<ffffffff811d683e>] SyS_newstat+0xe/0x10
[  191.810755]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  191.810755] Code: e2 41 9e ff 5d c3 0f 1f 44 00 00 55 48 89 e5 0f b7 17 38 d6 74 08 31 c0 5d c3 0f 1f 40 00 8d 8a 00 01 00 00 89 d0 f0 66 0f b1 0f <66> 39 d0 75 e6 b8 01 00 00 00 5d c3 66 66 66 66 66 66 2e 0f 1f 
[  219.786999] BUG: soft lockup - CPU#4 stuck for 22s! [systemd-udevd:1692]
[  219.787002] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal coretemp kvm_intel snd_hda_codec_hdmi kvm snd_hda_intel iTCO_wdt iTCO_vendor_support snd_hda_controller mxm_wmi snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul crc32c_intel snd_seq_device ghash_clmulni_intel snd_pcm microcode serio_raw snd_timer joydev snd mei_me i2c_i801 mei lpc_ich mfd_core
[  219.787042]  shpchp soundcore wmi i915 drm_kms_helper drm e1000e igb dca i2c_algo_bit ptp i2c_core pps_core video
[  219.787048] CPU: 4 PID: 1692 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  219.787049] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  219.787050] task: ffff8804718012a0 ti: ffff88047706a000 task.ti: ffff88047706a000
[  219.787051] RIP: 0010:[<ffffffff811e771a>]  [<ffffffff811e771a>] dentry_kill+0x6a/0x80
[  219.787054] RSP: 0018:ffff88047706bb50  EFLAGS: 00000286
[  219.787054] RAX: 0000000000000000 RBX: ffffffff812460f6 RCX: 000000000000edec
[  219.787055] RDX: 0000000000009390 RSI: 0000000000000001 RDI: ffff88044f0cf058
[  219.787056] RBP: ffff88047706bb68 R08: ffff8804764f99a0 R09: 0000000180240008
[  219.787056] R10: ffffffff812460f6 R11: ffffea0011d93e40 R12: ffff88047706bae8
[  219.787057] R13: ffff88047706bb40 R14: ffff88044fdc6c00 R15: ffff8804764f9930
[  219.787058] FS:  00007fce62933880(0000) GS:ffff88048f300000(0000) knlGS:0000000000000000
[  219.787059] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  219.787059] CR2: 00007fce62943000 CR3: 000000047535f000 CR4: 00000000001407e0
[  219.787060] Stack:
[  219.787060]  ffff88044f293300 ffff88044fdc6c80 ffff88047706bbb8 ffff88047706bba0
[  219.787062]  ffffffff811e79c8 ffff88047706bbb8 ffff88044f0cf000 000000000000002e
[  219.787063]  ffff88047706bdd0 0000000000000001 ffff88047706bbe8 ffffffff811e8294
[  219.787064] Call Trace:
[  219.787066]  [<ffffffff811e79c8>] shrink_dentry_list+0x118/0x1e0
[  219.787068]  [<ffffffff811e8294>] check_submounts_and_drop+0x74/0xa0
[  219.787070]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  219.787072]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  219.787073]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  219.787075]  [<ffffffff811e7638>] ? __dentry_kill+0x148/0x1c0
[  219.787078]  [<ffffffff811efd04>] ? mntput+0x24/0x40
[  219.787079]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  219.787081]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  219.787084]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  219.787085]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  219.787086]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  219.787088]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  219.787089]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  219.787090]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  219.787091]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  219.787093]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  219.787095]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  219.787096]  [<ffffffff811d65ff>] SYSC_newstat+0x1f/0x40
[  219.787099]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  219.787100]  [<ffffffff811d683e>] SyS_newstat+0xe/0x10
[  219.787102]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  219.787103] Code: 74 1c 48 89 df e8 f7 fd ff ff 4c 89 e0 5b 41 5c 41 5d 5d c3 0f 1f 44 00 00 45 31 e4 eb e4 4d 85 ed 74 08 41 80 85 88 00 00 00 01 <80> 43 58 01 f3 90 48 89 d8 eb d7 66 66 2e 0f 1f 84 00 00 00 00 
[  247.763040] BUG: soft lockup - CPU#4 stuck for 22s! [systemd-udevd:1692]
[  247.763042] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal coretemp kvm_intel snd_hda_codec_hdmi kvm snd_hda_intel iTCO_wdt iTCO_vendor_support snd_hda_controller mxm_wmi snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul crc32c_intel snd_seq_device ghash_clmulni_intel snd_pcm microcode serio_raw snd_timer joydev snd mei_me i2c_i801 mei lpc_ich mfd_core
[  247.763075]  shpchp soundcore wmi i915 drm_kms_helper drm e1000e igb dca i2c_algo_bit ptp i2c_core pps_core video
[  247.763090] CPU: 4 PID: 1692 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  247.763091] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  247.763092] task: ffff8804718012a0 ti: ffff88047706a000 task.ti: ffff88047706a000
[  247.763093] RIP: 0010:[<ffffffff816a5291>]  [<ffffffff816a5291>] _raw_spin_lock+0x21/0x30
[  247.763096] RSP: 0018:ffff88047706bb50  EFLAGS: 00000297
[  247.763097] RAX: 00000000000000e6 RBX: ffffffff812460f6 RCX: 000000010000e6e5
[  247.763098] RDX: 00000000000000e6 RSI: 0000000000000001 RDI: ffff88044f293358
[  247.763098] RBP: ffff88047706bb50 R08: ffff8804764f99a0 R09: 0000000180240008
[  247.763099] R10: ffffffff812460f6 R11: ffffea0011d93e40 R12: ffff88047706bae8
[  247.763100] R13: ffff88047706bb40 R14: ffff88044fdc6c00 R15: ffff8804764f9930
[  247.763100] FS:  00007fce62933880(0000) GS:ffff88048f300000(0000) knlGS:0000000000000000
[  247.763101] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  247.763102] CR2: 00007fce62943000 CR3: 000000047535f000 CR4: 00000000001407e0
[  247.763103] Stack:
[  247.763103]  ffff88047706bb68 ffffffff81338328 ffff88044f293300 ffff88047706bba0
[  247.763104]  ffffffff811e79dd ffff88047706bbb8 ffff88044f0cf000 000000000000002e
[  247.763106]  ffff88047706bdd0 0000000000000001 ffff88047706bbe8 ffffffff811e8294
[  247.763107] Call Trace:
[  247.763111]  [<ffffffff81338328>] lockref_put_or_lock+0x48/0x70
[  247.763113]  [<ffffffff811e79dd>] shrink_dentry_list+0x12d/0x1e0
[  247.763114]  [<ffffffff811e8294>] check_submounts_and_drop+0x74/0xa0
[  247.763116]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  247.763118]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  247.763120]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  247.763121]  [<ffffffff811e7638>] ? __dentry_kill+0x148/0x1c0
[  247.763123]  [<ffffffff811efd04>] ? mntput+0x24/0x40
[  247.763125]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  247.763127]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  247.763130]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  247.763131]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  247.763132]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  247.763134]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  247.763135]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  247.763136]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  247.763137]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  247.763138]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  247.763140]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  247.763142]  [<ffffffff811d65ff>] SYSC_newstat+0x1f/0x40
[  247.763144]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  247.763146]  [<ffffffff811d683e>] SyS_newstat+0xe/0x10
[  247.763148]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  247.763148] Code: c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 <38> d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 
[  275.739344] BUG: soft lockup - CPU#4 stuck for 22s! [systemd-udevd:1692]
[  275.739357] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw snd_hda_codec_realtek snd_hda_codec_generic x86_pkg_temp_thermal coretemp kvm_intel snd_hda_codec_hdmi kvm snd_hda_intel iTCO_wdt iTCO_vendor_support snd_hda_controller mxm_wmi snd_hda_codec snd_hwdep snd_seq crct10dif_pclmul crc32_pclmul crc32c_intel snd_seq_device ghash_clmulni_intel snd_pcm microcode serio_raw snd_timer joydev snd mei_me i2c_i801 mei lpc_ich mfd_core
[  275.739388]  shpchp soundcore wmi i915 drm_kms_helper drm e1000e igb dca i2c_algo_bit ptp i2c_core pps_core video
[  275.739394] CPU: 4 PID: 1692 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  275.739395] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  275.739396] task: ffff8804718012a0 ti: ffff88047706a000 task.ti: ffff88047706a000
[  275.739396] RIP: 0010:[<ffffffff811e7720>]  [<ffffffff811e7720>] dentry_kill+0x70/0x80
[  275.739399] RSP: 0018:ffff88047706bb50  EFLAGS: 00000286
[  275.739400] RAX: 0000000000000000 RBX: ffffffff812460f6 RCX: 000000000000adac
[  275.739401] RDX: 000000000000ece9 RSI: 0000000000000001 RDI: ffff88044f0cf058
[  275.739401] RBP: ffff88047706bb68 R08: ffff8804764f99a0 R09: 0000000180240008
[  275.739402] R10: ffffffff812460f6 R11: ffffea0011d93e40 R12: ffff88047706bae8
[  275.739403] R13: ffff88047706bb40 R14: ffff88044fdc6c00 R15: ffff8804764f9930
[  275.739404] FS:  00007fce62933880(0000) GS:ffff88048f300000(0000) knlGS:0000000000000000
[  275.739404] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  275.739405] CR2: 00007fce62943000 CR3: 000000047535f000 CR4: 00000000001407e0
[  275.739406] Stack:
[  275.739406]  ffff88044f293300 ffff88044fdc6c80 ffff88047706bbb8 ffff88047706bba0
[  275.739408]  ffffffff811e79c8 ffff88047706bbb8 ffff88044f0cf000 000000000000002e
[  275.739409]  ffff88047706bdd0 0000000000000001 ffff88047706bbe8 ffffffff811e8294
[  275.739410] Call Trace:
[  275.739412]  [<ffffffff811e79c8>] shrink_dentry_list+0x118/0x1e0
[  275.739413]  [<ffffffff811e8294>] check_submounts_and_drop+0x74/0xa0
[  275.739416]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  275.739418]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  275.739419]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  275.739421]  [<ffffffff811e7638>] ? __dentry_kill+0x148/0x1c0
[  275.739423]  [<ffffffff811efd04>] ? mntput+0x24/0x40
[  275.739424]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  275.739427]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  275.739429]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  275.739431]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  275.739432]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  275.739433]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  275.739434]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  275.739436]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  275.739437]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  275.739438]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  275.739440]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  275.739442]  [<ffffffff811d65ff>] SYSC_newstat+0x1f/0x40
[  275.739444]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  275.739446]  [<ffffffff811d683e>] SyS_newstat+0xe/0x10
[  275.739448]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  275.739449] Code: f7 fd ff ff 4c 89 e0 5b 41 5c 41 5d 5d c3 0f 1f 44 00 00 45 31 e4 eb e4 4d 85 ed 74 08 41 80 85 88 00 00 00 01 80 43 58 01 f3 90 <48> 89 d8 eb d7 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 
[  289.345882] INFO: rcu_sched self-detected stall on CPU { 4}  (t=240005 jiffies g=1145 c=1144 q=97256)
[  289.345886] sending NMI to all CPUs:
[  289.345899] NMI backtrace for cpu 7
[  289.345902] CPU: 7 PID: 573 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  289.345904] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  289.345905] task: ffff880470a4c130 ti: ffff88047458e000 task.ti: ffff88047458e000
[  289.345906] RIP: 0010:[<ffffffff816a528e>]  [<ffffffff816a528e>] _raw_spin_lock+0x1e/0x30
[  289.345911] RSP: 0018:ffff88047458fbc0  EFLAGS: 00000297
[  289.345912] RAX: 00000000000000a3 RBX: ffff88047458fc58 RCX: ffffffff811e7480
[  289.345913] RDX: 00000000000000a4 RSI: ffff88047458fc50 RDI: ffff88044f0cf058
[  289.345914] RBP: ffff88047458fbc0 R08: ffff88047458e000 R09: 0000000000000001
[  289.345915] R10: dfed4b1078bd05a0 R11: 0000000000000000 R12: ffff88044f0cf000
[  289.345916] R13: 0000000000000025 R14: ffff88047458fe50 R15: 0000000000000001
[  289.345918] FS:  00007fce62933880(0000) GS:ffff88048f3c0000(0000) knlGS:0000000000000000
[  289.345919] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  289.345920] CR2: 00007f5b5e38b000 CR3: 0000000472f3f000 CR4: 00000000001407e0
[  289.345921] Stack:
[  289.345922]  ffff88047458fc40 ffffffff811e7e6c ffffffff811e7480 01ffffff816a1dea
[  289.345925]  ffff88044f0cf058 ffff88044f0cf058 ffff88044f0cf000 ffff88044f0cf0a0
[  289.345927]  ffffffff811e6ef0 ffff88047458fc50 0000051a00000000 ffff88047458fc58
[  289.345929] Call Trace:
[  289.345932]  [<ffffffff811e7e6c>] d_walk+0x5c/0x280
[  289.345935]  [<ffffffff811e7480>] ? __d_drop+0xb0/0xb0
[  289.345937]  [<ffffffff811e6ef0>] ? select_collect+0xb0/0xb0
[  289.345939]  [<ffffffff811e8282>] check_submounts_and_drop+0x62/0xa0
[  289.345942]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  289.345945]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  289.345947]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  289.345950]  [<ffffffff812c5c26>] ? security_file_alloc+0x16/0x20
[  289.345952]  [<ffffffff811e0cbc>] path_openat+0x9c/0x660
[  289.345955]  [<ffffffff81163c81>] ? __generic_file_aio_write+0x1d1/0x3f0
[  289.345957]  [<ffffffff811e1a7a>] do_filp_open+0x3a/0x90
[  289.345960]  [<ffffffff811eddfd>] ? __alloc_fd+0x7d/0x120
[  289.345963]  [<ffffffff811d0ade>] do_sys_open+0x12e/0x210
[  289.345965]  [<ffffffff811d0bde>] SyS_open+0x1e/0x20
[  289.345967]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  289.345968] Code: e8 58 2c c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 <0f> b6 07 38 d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 
[  289.345989] NMI backtrace for cpu 3
[  289.345991] CPU: 3 PID: 1696 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  289.345992] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  289.345994] task: ffff880471804a80 ti: ffff8804777f0000 task.ti: ffff8804777f0000
[  289.345995] RIP: 0010:[<ffffffff816a5283>]  [<ffffffff816a5283>] _raw_spin_lock+0x13/0x30
[  289.345997] RSP: 0018:ffff8804777f1bb0  EFLAGS: 00000286
[  289.345998] RAX: 000000000000e7e7 RBX: ffff88044f0cf0a0 RCX: ffff88044f0cf058
[  289.345999] RDX: 00000000000000c5 RSI: ffff88044f293300 RDI: ffff88044f293898
[  289.346000] RBP: ffff8804777f1bb0 R08: ffff8804777f0000 R09: 0000000000000001
[  289.346001] R10: dfed4b5078ad05a0 R11: 0000000000000008 R12: ffff88044f293840
[  289.346002] R13: ffff88044f293898 R14: ffff88044f0cf000 R15: ffff88044f2938d0
[  289.346003] FS:  00007fce62933880(0000) GS:ffff88048f2c0000(0000) knlGS:0000000000000000
[  289.346005] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  289.346006] CR2: 00007f5b5e38b000 CR3: 00000004736fe000 CR4: 00000000001407e0
[  289.346006] Stack:
[  289.346007]  ffff8804777f1c30 ffffffff811e7edf ffffffff811e7480 01ffffff816a1dea
[  289.346009]  ffff88044f0cf058 ffff88044f0cf058 ffff88044f0cf000 ffff88044f293990
[  289.346011]  ffffffff811e6ef0 ffff8804777f1c40 0000051a00000000 ffff8804777f1c48
[  289.346013] Call Trace:
[  289.346015]  [<ffffffff811e7edf>] d_walk+0xcf/0x280
[  289.346017]  [<ffffffff811e7480>] ? __d_drop+0xb0/0xb0
[  289.346019]  [<ffffffff811e6ef0>] ? select_collect+0xb0/0xb0
[  289.346021]  [<ffffffff811e8282>] check_submounts_and_drop+0x62/0xa0
[  289.346023]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  289.346025]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  289.346026]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  289.346029]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  289.346031]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  289.346033]  [<ffffffff8118896c>] ? tlb_flush_mmu_free+0x2c/0x50
[  289.346035]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  289.346037]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  289.346039]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  289.346041]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  289.346043]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  289.346045]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  289.346048]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  289.346050]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  289.346051] Code: 00 00 f0 81 2f 00 00 10 00 74 05 e8 58 2c c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 <0f> b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 38 d0 75 f7 5d c3 66 
[  289.346071] NMI backtrace for cpu 4
[  289.346073] CPU: 4 PID: 1692 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  289.346074] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  289.346075] task: ffff8804718012a0 ti: ffff88047706a000 task.ti: ffff88047706a000
[  289.346076] RIP: 0010:[<ffffffff81336ad2>]  [<ffffffff81336ad2>] __const_udelay+0x12/0x30
[  289.346080] RSP: 0018:ffff88048f303df0  EFLAGS: 00000086
[  289.346081] RAX: 0000000001062560 RBX: 0000000000002710 RCX: 00000000ff000000
[  289.346083] RDX: 000000000035488c RSI: ffffffff81c27ec0 RDI: 0000000000418958
[  289.346084] RBP: ffff88048f303e08 R08: 000000000000000a R09: 00000000000006fa
[  289.346085] R10: 0000000000000000 R11: ffff88048f303b3e R12: ffffffff81c4f7c0
[  289.346086] R13: ffffffff81cfdb38 R14: ffffffff81c4f7c0 R15: 0000000000000004
[  289.346087] FS:  00007fce62933880(0000) GS:ffff88048f300000(0000) knlGS:0000000000000000
[  289.346089] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  289.346090] CR2: 00007fce62943000 CR3: 000000047535f000 CR4: 00000000001407e0
[  289.346091] Stack:
[  289.346092]  ffff88048f303e08 ffffffff810448ce ffff88048f30eac0 ffff88048f303e60
[  289.346094]  ffffffff810e415e ffff88048f303e60 ffffffff810b8a01 0000004373773204
[  289.346096]  0000000000017be8 ffff8804718012a0 0000000000000000 0000000000000004
[  289.346098] Call Trace:
[  289.346099]  <IRQ> 

[  289.346103]  [<ffffffff810448ce>] ? arch_trigger_all_cpu_backtrace+0x5e/0x80
[  289.346106]  [<ffffffff810e415e>] rcu_check_callbacks+0x3fe/0x660
[  289.346109]  [<ffffffff810b8a01>] ? account_process_tick+0x121/0x1b0
[  289.346112]  [<ffffffff81091627>] update_process_times+0x47/0x70
[  289.346115]  [<ffffffff810ee935>] tick_sched_handle.isra.16+0x25/0x60
[  289.346117]  [<ffffffff810ee9b1>] tick_sched_timer+0x41/0x60
[  289.346120]  [<ffffffff810a8493>] __run_hrtimer+0x73/0x1d0
[  289.346122]  [<ffffffff810ee970>] ? tick_sched_handle.isra.16+0x60/0x60
[  289.346124]  [<ffffffff810a8c67>] hrtimer_interrupt+0xf7/0x240
[  289.346127]  [<ffffffff81042c37>] local_apic_timer_interrupt+0x37/0x60
[  289.346130]  [<ffffffff816b01af>] smp_apic_timer_interrupt+0x3f/0x60
[  289.346132]  [<ffffffff816aeb9d>] apic_timer_interrupt+0x6d/0x80
[  289.346133]  <EOI> 

[  289.346136]  [<ffffffff812460f6>] ? kernfs_put+0x106/0x1d0
[  289.346138]  [<ffffffff813382e5>] ? lockref_put_or_lock+0x5/0x70
[  289.346140]  [<ffffffff811e79dd>] shrink_dentry_list+0x12d/0x1e0
[  289.346142]  [<ffffffff811e8294>] check_submounts_and_drop+0x74/0xa0
[  289.346144]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  289.346146]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  289.346148]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  289.346151]  [<ffffffff811e7638>] ? __dentry_kill+0x148/0x1c0
[  289.346153]  [<ffffffff811efd04>] ? mntput+0x24/0x40
[  289.346155]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  289.346157]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  289.346159]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  289.346161]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  289.346163]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  289.346165]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  289.346167]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  289.346169]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  289.346171]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  289.346173]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  289.346175]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  289.346177]  [<ffffffff811d65ff>] SYSC_newstat+0x1f/0x40
[  289.346180]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  289.346182]  [<ffffffff811d683e>] SyS_newstat+0xe/0x10
[  289.346184]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  289.346185] Code: 89 e5 ff 15 09 1b 96 00 5d c3 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 8d 04 bd 00 00 00 00 65 48 8b 14 25 60 3e 01 00 <48> 89 e5 48 69 d2 fa 00 00 00 f7 e2 48 8d 7a 01 ff 15 d0 1a 96 
[  289.346206] NMI backtrace for cpu 0
[  289.346208] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G          I   3.15.0-rc7+ #15
[  289.346209] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  289.346210] task: ffffffff81c16460 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[  289.346211] RIP: 0010:[<ffffffff8139d6ba>]  [<ffffffff8139d6ba>] intel_idle+0xda/0x160
[  289.346214] RSP: 0018:ffffffff81c01e60  EFLAGS: 00000046
[  289.346215] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  289.346216] RDX: 0000000000000000 RSI: ffffffff81c9c9a0 RDI: 0000000000000000
[  289.346218] RBP: ffffffff81c01e88 R08: 00000000ffffffff R09: 0000000000001aaf
[  289.346219] R10: 00000000000019f8 R11: 0000000000000008 R12: 0000000000000005
[  289.346220] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c9cb70
[  289.346221] FS:  0000000000000000(0000) GS:ffff88048f200000(0000) knlGS:0000000000000000
[  289.346222] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  289.346223] CR2: 00007f204a0eb000 CR3: 0000000001c0f000 CR4: 00000000001407f0
[  289.346224] Stack:
[  289.346225]  0000000081c01e88 ffff88048f21a840 ffffffff81c9c9a0 0000004373867df5
[  289.346227]  0000000000000005 ffffffff81c01ec0 ffffffff81546470 ffffffff81cfdb30
[  289.346228]  ffff88048f21a840 ffffffff81c9c9a0 ffffffff81c01fd8 ffffffff81c00000
[  289.346230] Call Trace:
[  289.346233]  [<ffffffff81546470>] cpuidle_enter_state+0x40/0xc0
[  289.346235]  [<ffffffff81546527>] cpuidle_enter+0x17/0x20
[  289.346237]  [<ffffffff810c8410>] cpu_startup_entry+0x2c0/0x3d0
[  289.346240]  [<ffffffff816901e7>] rest_init+0x77/0x80
[  289.346243]  [<ffffffff81d21f2d>] start_kernel+0x3fa/0x405
[  289.346245]  [<ffffffff81d2193c>] ? repair_env_string+0x5c/0x5c
[  289.346247]  [<ffffffff81d21120>] ? early_idt_handlers+0x120/0x120
[  289.346249]  [<ffffffff81d215ee>] x86_64_start_reservations+0x2a/0x2c
[  289.346250]  [<ffffffff81d2172e>] x86_64_start_kernel+0x13e/0x14d
[  289.346251] Code: c7 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 65 48 8b 04 25 c8 c7 00 00 48 8b 80 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 04 25 c8 c7 00 00 83 a0 3c e0 ff ff fb 0f ae f0 65 48 
[  289.346271] NMI backtrace for cpu 1
[  289.346274] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G          I   3.15.0-rc7+ #15
[  289.346275] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  289.346277] task: ffff880478d55d20 ti: ffff880478e10000 task.ti: ffff880478e10000
[  289.346278] RIP: 0010:[<ffffffff8139d6ba>]  [<ffffffff8139d6ba>] intel_idle+0xda/0x160
[  289.346281] RSP: 0018:ffff880478e11e58  EFLAGS: 00000046
[  289.346282] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  289.346283] RDX: 0000000000000000 RSI: ffffffff81c9c9a0 RDI: 0000000000000001
[  289.346285] RBP: ffff880478e11e80 R08: 00000000ffffffff R09: 0000000000001aaf
[  289.346286] R10: 00000000000019fe R11: 0000000000000008 R12: 0000000000000005
[  289.346287] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c9cb70
[  289.346288] FS:  0000000000000000(0000) GS:ffff88048f240000(0000) knlGS:0000000000000000
[  289.346289] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  289.346290] CR2: 00007fbd6f343ac0 CR3: 0000000001c0f000 CR4: 00000000001407e0
[  289.346291] Stack:
[  289.346292]  0000000178e11e80 ffff88048f25a840 ffffffff81c9c9a0 0000004373867b39
[  289.346294]  0000000000000005 ffff880478e11eb8 ffffffff81546470 ffffffff81cfdb30
[  289.346296]  ffff88048f25a840 ffffffff81c9c9a0 ffff880478e11fd8 ffff880478e10000
[  289.346299] Call Trace:
[  289.346301]  [<ffffffff81546470>] cpuidle_enter_state+0x40/0xc0
[  289.346303]  [<ffffffff81546527>] cpuidle_enter+0x17/0x20
[  289.346306]  [<ffffffff810c8410>] cpu_startup_entry+0x2c0/0x3d0
[  289.346309]  [<ffffffff81040d64>] start_secondary+0x1c4/0x280
[  289.346310] Code: c7 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 65 48 8b 04 25 c8 c7 00 00 48 8b 80 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 04 25 c8 c7 00 00 83 a0 3c e0 ff ff fb 0f ae f0 65 48 
[  289.346331] NMI backtrace for cpu 5
[  289.346333] CPU: 5 PID: 1689 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7+ #15
[  289.346334] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  289.346335] task: ffff8804718037e0 ti: ffff880473eb2000 task.ti: ffff880473eb2000
[  289.346335] RIP: 0010:[<ffffffff816a5291>]  [<ffffffff816a5291>] _raw_spin_lock+0x21/0x30
[  289.346337] RSP: 0018:ffff880473eb3b20  EFLAGS: 00000293
[  289.346338] RAX: 00000000000000a3 RBX: ffff880473eb3bb8 RCX: ffffffff811e7480
[  289.346339] RDX: 00000000000000a5 RSI: ffff880473eb3bb0 RDI: ffff88044f0cf058
[  289.346339] RBP: ffff880473eb3b20 R08: ffff880473eb2000 R09: 0000000000000001
[  289.346340] R10: dfed4b3078b505a0 R11: 0000000000001ffe R12: ffff88044f0cf000
[  289.346340] R13: 0000000000000025 R14: ffff880473eb3dd0 R15: 0000000000000001
[  289.346341] FS:  00007fce62933880(0000) GS:ffff88048f340000(0000) knlGS:0000000000000000
[  289.346342] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  289.346343] CR2: 00007fce62943000 CR3: 00000004737d8000 CR4: 00000000001407e0
[  289.346343] Stack:
[  289.346344]  ffff880473eb3ba0 ffffffff811e7e6c ffffffff811e7480 01ffffff816a1dea
[  289.346345]  ffff88044f0cf058 ffff88044f0cf058 ffff88044f0cf000 ffff88044f0cf0a0
[  289.346346]  ffffffff811e6ef0 ffff880473eb3bb0 0000051a00000000 ffff880473eb3bb8
[  289.346347] Call Trace:
[  289.346349]  [<ffffffff811e7e6c>] d_walk+0x5c/0x280
[  289.346350]  [<ffffffff811e7480>] ? __d_drop+0xb0/0xb0
[  289.346352]  [<ffffffff811e6ef0>] ? select_collect+0xb0/0xb0
[  289.346353]  [<ffffffff811e8282>] check_submounts_and_drop+0x62/0xa0
[  289.346355]  [<ffffffff81245d1d>] kernfs_dop_revalidate+0x5d/0xd0
[  289.346356]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  289.346357]  [<ffffffff811dcaa3>] link_path_walk+0x1a3/0x860
[  289.346359]  [<ffffffff811e7638>] ? __dentry_kill+0x148/0x1c0
[  289.346361]  [<ffffffff811efd04>] ? mntput+0x24/0x40
[  289.346362]  [<ffffffff811dd1bb>] path_lookupat+0x5b/0x780
[  289.346363]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  289.346365]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  289.346366]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  289.346367]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  289.346368]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  289.346370]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  289.346371]  [<ffffffff811dc3f9>] ? putname+0x29/0x40
[  289.346372]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  289.346373]  [<ffffffff811e19d1>] user_path_at+0x11/0x20
[  289.346375]  [<ffffffff811d6160>] vfs_fstatat+0x50/0xa0
[  289.346377]  [<ffffffff811d65ff>] SYSC_newstat+0x1f/0x40
[  289.346378]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  289.346380]  [<ffffffff811d683e>] SyS_newstat+0xe/0x10
[  289.346381]  [<ffffffff816adf29>] system_call_fastpath+0x16/0x1b
[  289.346382] Code: c9 ff 48 89 d0 5d c3 0f 1f 00 0f 1f 44 00 00 55 48 89 e5 b8 00 01 00 00 f0 66 0f c1 07 0f b6 d4 38 c2 75 04 5d c3 f3 90 0f b6 07 <38> d0 75 f7 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 
[  289.346395] NMI backtrace for cpu 6
[  289.346398] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G          I   3.15.0-rc7+ #15
[  289.346399] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  289.346400] task: ffff880478e192a0 ti: ffff880478e22000 task.ti: ffff880478e22000
[  289.346401] RIP: 0010:[<ffffffff8139d6ba>]  [<ffffffff8139d6ba>] intel_idle+0xda/0x160
[  289.346405] RSP: 0018:ffff880478e23e58  EFLAGS: 00000046
[  289.346406] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  289.346407] RDX: 0000000000000000 RSI: ffffffff81c9c9a0 RDI: 0000000000000006
[  289.346408] RBP: ffff880478e23e80 R08: 000000000000033d R09: 0000000000000018
[  289.346409] R10: 000000000000102b R11: 0000000000000006 R12: 0000000000000005
[  289.346410] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c9cb70
[  289.346412] FS:  0000000000000000(0000) GS:ffff88048f380000(0000) knlGS:0000000000000000
[  289.346413] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  289.346414] CR2: 00007f4187a9117e CR3: 0000000001c0f000 CR4: 00000000001407e0
[  289.346415] Stack:
[  289.346416]  0000000678e23e80 ffff88048f39a840 ffffffff81c9c9a0 0000004373778522
[  289.346418]  0000000000000005 ffff880478e23eb8 ffffffff81546470 ffffffff81cfdb30
[  289.346420]  ffff88048f39a840 ffffffff81c9c9a0 ffff880478e23fd8 ffff880478e22000
[  289.346422] Call Trace:
[  289.346425]  [<ffffffff81546470>] cpuidle_enter_state+0x40/0xc0
[  289.346427]  [<ffffffff81546527>] cpuidle_enter+0x17/0x20
[  289.346429]  [<ffffffff810c8410>] cpu_startup_entry+0x2c0/0x3d0
[  289.346432]  [<ffffffff81040d64>] start_secondary+0x1c4/0x280
[  289.346433] Code: c7 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 65 48 8b 04 25 c8 c7 00 00 48 8b 80 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 04 25 c8 c7 00 00 83 a0 3c e0 ff ff fb 0f ae f0 65 48 
[  289.346454] NMI backtrace for cpu 2
[  289.346456] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G          I   3.15.0-rc7+ #15
[  289.346457] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  289.346459] task: ffff880478d56670 ti: ffff880478e12000 task.ti: ffff880478e12000
[  289.346460] RIP: 0010:[<ffffffff8139d6ba>]  [<ffffffff8139d6ba>] intel_idle+0xda/0x160
[  289.346462] RSP: 0018:ffff880478e13e58  EFLAGS: 00000046
[  289.346463] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  289.346465] RDX: 0000000000000000 RSI: ffffffff81c9c9a0 RDI: 0000000000000002
[  289.346466] RBP: ffff880478e13e80 R08: 00000000ffffffff R09: 0000000000001a8f
[  289.346467] R10: 00000000000019d4 R11: 0000000000000008 R12: 0000000000000005
[  289.346468] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c9cb70
[  289.346470] FS:  0000000000000000(0000) GS:ffff88048f280000(0000) knlGS:0000000000000000
[  289.346471] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  289.346472] CR2: 00007f5b5e38b000 CR3: 0000000001c0f000 CR4: 00000000001407e0
[  289.346473] Stack:
[  289.346473]  0000000278e13e80 ffff88048f29a840 ffffffff81c9c9a0 000000437377851a
[  289.346475]  0000000000000005 ffff880478e13eb8 ffffffff81546470 ffffffff81cfdb30
[  289.346477]  ffff88048f29a840 ffffffff81c9c9a0 ffff880478e13fd8 ffff880478e12000
[  289.346479] Call Trace:
[  289.346481]  [<ffffffff81546470>] cpuidle_enter_state+0x40/0xc0
[  289.346483]  [<ffffffff81546527>] cpuidle_enter+0x17/0x20
[  289.346486]  [<ffffffff810c8410>] cpu_startup_entry+0x2c0/0x3d0
[  289.346488]  [<ffffffff81040d64>] start_secondary+0x1c4/0x280
[  289.346489] Code: c7 00 00 48 89 d1 48 2d c8 1f 00 00 0f 01 c8 65 48 8b 04 25 c8 c7 00 00 48 8b 80 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 04 25 c8 c7 00 00 83 a0 3c e0 ff ff fb 0f ae f0 65 48 
[  418.947763] usb 3-10.4: new high-speed USB device number 7 using xhci_hcd
[  419.039492] usb 3-10.4: New USB device found, idVendor=8564, idProduct=1000
[  419.039502] usb 3-10.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  419.039506] usb 3-10.4: Product: Mass Storage Device
[  419.039510] usb 3-10.4: Manufacturer: JetFlash
[  419.039513] usb 3-10.4: SerialNumber: 9EAOZJ51
[  419.040926] usb-storage 3-10.4:1.0: USB Mass Storage device detected
[  419.041242] scsi15 : usb-storage 3-10.4:1.0
[  420.043585] scsi 15:0:0:0: Direct-Access     JetFlash Transcend 4GB    8.07 PQ: 0 ANSI: 4
[  420.044420] sd 15:0:0:0: Attached scsi generic sg4 type 0
[  420.044962] sd 15:0:0:0: [sdc] 7864320 512-byte logical blocks: (4.02 GB/3.75 GiB)
[  420.045684] sd 15:0:0:0: [sdc] Write Protect is off
[  420.045691] sd 15:0:0:0: [sdc] Mode Sense: 23 00 00 00
[  420.046431] sd 15:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  420.050628]  sdc: sdc1
[  420.053671] sd 15:0:0:0: [sdc] Attached SCSI removable disk
[  462.510257] usb 3-10.4: USB disconnect, device number 7
[  477.010961] usb 3-10.4: new high-speed USB device number 8 using xhci_hcd
[  477.102648] usb 3-10.4: New USB device found, idVendor=8564, idProduct=1000
[  477.102657] usb 3-10.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  477.102662] usb 3-10.4: Product: Mass Storage Device
[  477.102666] usb 3-10.4: Manufacturer: JetFlash
[  477.102669] usb 3-10.4: SerialNumber: 9EAOZJ51
[  477.103670] usb-storage 3-10.4:1.0: USB Mass Storage device detected
[  477.103952] scsi16 : usb-storage 3-10.4:1.0
[  478.106742] scsi 16:0:0:0: Direct-Access     JetFlash Transcend 4GB    8.07 PQ: 0 ANSI: 4
[  478.107535] sd 16:0:0:0: Attached scsi generic sg4 type 0
[  478.108070] sd 16:0:0:0: [sdc] 7864320 512-byte logical blocks: (4.02 GB/3.75 GiB)
[  478.108797] sd 16:0:0:0: [sdc] Write Protect is off
[  478.108803] sd 16:0:0:0: [sdc] Mode Sense: 23 00 00 00
[  478.109531] sd 16:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  478.113528]  sdc: sdc1
[  478.116704] sd 16:0:0:0: [sdc] Attached SCSI removable disk
[  483.996024] usb 3-10.4: USB disconnect, device number 8
[  493.636026] usb 3-10.4: new high-speed USB device number 9 using xhci_hcd
[  493.727740] usb 3-10.4: New USB device found, idVendor=8564, idProduct=1000
[  493.727749] usb 3-10.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  493.727754] usb 3-10.4: Product: Mass Storage Device
[  493.727758] usb 3-10.4: Manufacturer: JetFlash
[  493.727761] usb 3-10.4: SerialNumber: 9EAOZJ51
[  493.728777] usb-storage 3-10.4:1.0: USB Mass Storage device detected
[  493.729076] scsi17 : usb-storage 3-10.4:1.0
[  494.730849] scsi 17:0:0:0: Direct-Access     JetFlash Transcend 4GB    8.07 PQ: 0 ANSI: 4
[  494.731652] sd 17:0:0:0: Attached scsi generic sg4 type 0
[  494.732190] sd 17:0:0:0: [sdc] 7864320 512-byte logical blocks: (4.02 GB/3.75 GiB)
[  494.732925] sd 17:0:0:0: [sdc] Write Protect is off
[  494.732932] sd 17:0:0:0: [sdc] Mode Sense: 23 00 00 00
[  494.733670] sd 17:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  494.738695]  sdc: sdc1
[  494.741316] sd 17:0:0:0: [sdc] Attached SCSI removable disk
[  499.598780] usb 3-10.4: USB disconnect, device number 9
[  509.750524] usb 3-10.4: new high-speed USB device number 10 using xhci_hcd
[  509.842235] usb 3-10.4: New USB device found, idVendor=8564, idProduct=1000
[  509.842244] usb 3-10.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  509.842249] usb 3-10.4: Product: Mass Storage Device
[  509.842253] usb 3-10.4: Manufacturer: JetFlash
[  509.842256] usb 3-10.4: SerialNumber: 9EAOZJ51
[  509.843257] usb-storage 3-10.4:1.0: USB Mass Storage device detected
[  509.843677] scsi18 : usb-storage 3-10.4:1.0
[  510.845288] scsi 18:0:0:0: Direct-Access     JetFlash Transcend 4GB    8.07 PQ: 0 ANSI: 4
[  510.846107] sd 18:0:0:0: Attached scsi generic sg4 type 0
[  510.846675] sd 18:0:0:0: [sdc] 7864320 512-byte logical blocks: (4.02 GB/3.75 GiB)
[  510.847400] sd 18:0:0:0: [sdc] Write Protect is off
[  510.847408] sd 18:0:0:0: [sdc] Mode Sense: 23 00 00 00
[  510.848141] sd 18:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  510.851970]  sdc: sdc1
[  510.855171] sd 18:0:0:0: [sdc] Attached SCSI removable disk
[  513.666845] usb 3-10.4: USB disconnect, device number 10
[  520.493510] usb 3-10.4: new high-speed USB device number 11 using xhci_hcd
[  520.585068] usb 3-10.4: New USB device found, idVendor=8564, idProduct=1000
[  520.585076] usb 3-10.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  520.585080] usb 3-10.4: Product: Mass Storage Device
[  520.585084] usb 3-10.4: Manufacturer: JetFlash
[  520.585087] usb 3-10.4: SerialNumber: 9EAOZJ51
[  520.586000] usb-storage 3-10.4:1.0: USB Mass Storage device detected
[  520.586747] scsi19 : usb-storage 3-10.4:1.0
[  521.588210] scsi 19:0:0:0: Direct-Access     JetFlash Transcend 4GB    8.07 PQ: 0 ANSI: 4
[  521.589132] sd 19:0:0:0: Attached scsi generic sg4 type 0
[  521.589490] sd 19:0:0:0: [sdc] 7864320 512-byte logical blocks: (4.02 GB/3.75 GiB)
[  521.590206] sd 19:0:0:0: [sdc] Write Protect is off
[  521.590212] sd 19:0:0:0: [sdc] Mode Sense: 23 00 00 00
[  521.590903] sd 19:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  521.594869]  sdc: sdc1
[  521.597996] sd 19:0:0:0: [sdc] Attached SCSI removable disk
[  524.921289] usb 3-10.4: USB disconnect, device number 11
[  535.584848] usb 3-10.4: new high-speed USB device number 12 using xhci_hcd
[  535.676571] usb 3-10.4: New USB device found, idVendor=8564, idProduct=1000
[  535.676580] usb 3-10.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  535.676585] usb 3-10.4: Product: Mass Storage Device
[  535.676588] usb 3-10.4: Manufacturer: JetFlash
[  535.676592] usb 3-10.4: SerialNumber: 9EAOZJ51
[  535.677586] usb-storage 3-10.4:1.0: USB Mass Storage device detected
[  535.679379] scsi20 : usb-storage 3-10.4:1.0
[  536.681671] scsi 20:0:0:0: Direct-Access     JetFlash Transcend 4GB    8.07 PQ: 0 ANSI: 4
[  536.682575] sd 20:0:0:0: Attached scsi generic sg4 type 0
[  536.683238] sd 20:0:0:0: [sdc] 7864320 512-byte logical blocks: (4.02 GB/3.75 GiB)
[  536.684006] sd 20:0:0:0: [sdc] Write Protect is off
[  536.684016] sd 20:0:0:0: [sdc] Mode Sense: 23 00 00 00
[  536.684773] sd 20:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  536.689664]  sdc: sdc1
[  536.692249] sd 20:0:0:0: [sdc] Attached SCSI removable disk
[  541.547176] usb 3-10.4: USB disconnect, device number 12

--Yylu36WmvOXNoKYn--
