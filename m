Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaEZOaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 10:30:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:55020 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752506AbaEZO35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 10:29:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,913,1392192000"; 
   d="out'?scan'208";a="545077029"
Date: Mon, 26 May 2014 17:29:48 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>, linux-fsdevel@vger.kernel.org
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140526142948.GA1685@lahna.fi.intel.com>
References: <20140526093741.GA1765@lahna.fi.intel.com>
 <20140526135746.GM18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <20140526135746.GM18016@ZenIV.linux.org.uk>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 26, 2014 at 02:57:47PM +0100, Al Viro wrote:
> [fsdevel and folks who'd been on d_lru corruption thread Cc'd - that's
> a continuation of the same mess]
> 
> On Mon, May 26, 2014 at 12:37:41PM +0300, Mika Westerberg wrote:
> > Hi,
> > 
> > After v3.15-rc4 my Fedora 20 system with mainline kernel has been suffering
> > from the above lockup.
> > 
> > This is easy to reproduce:
> > 
> >  1) Plug in USB memory stick (to xHCI port)
> >  2) Unplug it
> > 
> > Typically only one iteration is needed and suddenly I can see
> > systemd-udev taking 100% CPU and eventually the whole system becomes
> > unusable.
> > 
> > I've tried to investigate and it looks like we just spin in
> > shrink_dentry_list() forever. Reverting following fs/dcache.c commits
> > the issue goes away:
> > 
> > 60942f2f235ce7b817166cdf355eed729094834d dcache: don't need rcu in shrink_dentry_list()
> > 9c8c10e262e0f62cb2530f1b076de979123183dd more graceful recovery in umount_collect()
> > fe91522a7ba82ca1a51b07e19954b3825e4aaa22 don't remove from shrink list in select_collect()
> 
> Which means that we very likely have a reproducer for d_lru-corrupting
> races in earlier kernels here.  I wonder if it can be simulated under KVM...
> 
> > (The first two commits themselves don't seem to be related but reverting
> > them is needed so that the last one can be cleanly reverted).
> 
> What I really wonder is what else is going on there; it keeps finding a bunch
> of dentries _already_ on shrink list(s) of somebody else.  And spins (with
> eviction of everything worthy not already on shrink lists and cond_resched()
> thrown in) to give whoever's trying to evict those suckers do their job.
> 
> This means that we either have somebody stuck trying to evict a dentry, or
> that more and more dentries keep being added and evicted there.  Is somebody
> sitting in a subdirectory of invalid one and trying to do lookups there,
> perhaps?  But in that case we would have the same livelock in the older
> kernels, possibly harder to hit, but still there...

Not sure if this helps, but I did 'udevadm monitor' and here is the list
of events when I unplugged the USB stick:

KERNEL[134.584296] remove /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.3/3-10.3:1.0/host15/target15:0:0/15:0:0:0/bsg/15:0:0:0 (bsg)
KERNEL[134.584442] remove /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.3/3-10.3:1.0/host15/target15:0:0/15:0:0:0/scsi_generic/sg4 (scsi_generic)
KERNEL[134.584501] remove /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.3/3-10.3:1.0/host15/target15:0:0/15:0:0:0/scsi_device/15:0:0:0 (scsi_device)
KERNEL[134.584572] remove /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.3/3-10.3:1.0/host15/target15:0:0/15:0:0:0/scsi_disk/15:0:0:0 (scsi_disk)
KERNEL[134.584773] remove /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.3/3-10.3:1.0/host15/target15:0:0/15:0:0:0/block/sdc/sdc1 (block)
KERNEL[134.584914] remove    /devices/virtual/bdi/8:32 (bdi)
KERNEL[134.586116] remove /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.3/3-10.3:1.0/host15/target15:0:0/15:0:0:0/block/sdc (block)
KERNEL[134.586176] remove /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.3/3-10.3:1.0/host15/target15:0:0/15:0:0:0 (scsi)
KERNEL[134.586203] remove /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.3/3-10.3:1.0/host15/target15:0:0 (scsi)
KERNEL[134.586225] remove /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.3/3-10.3:1.0/host15/scsi_host/host15 (scsi_host)
KERNEL[134.586249] remove /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.3/3-10.3:1.0/host15 (scsi)
KERNEL[134.586284] remove /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.3/3-10.3:1.0 (usb)
KERNEL[134.586329] remove /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.3 (usb)
UDEV  [134.589069] remove   /devices/virtual/bdi/8:32 (bdi)

And right after that the systemd-udev starts consuming 100% CPU, if I
check from htop or top.

> FWIW, older kernels just went ahead, picked those already-on-shrink-list
> dentries and did dentry_kill(), hopefully not at the time when the owner of
> shrink list got around to removing the neighbor from that list.  With
> list corruption in case it happened at just the wrong moment.
> 
> I don't have Fedora anywhere outside of KVM test images, and it'll take
> a while to inflict it on actual hardware; in the meanwhile, could you
> hit alt-sysrq-t after it gets stuck and post the results?  At least that
> would give some idea whether it's somebody stuck on trying to evict a dentry
> or a stream of new dentries being added and killed there.

I attached the dmesg with 'echo t > /proc/sysrq-trigger' included.

--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.out"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.15.0-rc7 (westeri@lahna) (gcc version 4.8.2 20131212 (Red Hat 4.8.2-7) (GCC) ) #55 SMP Mon May 26 12:19:38 EEST 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.15.0-rc7 root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/swap vconsole.font=latarcyrheb-sun16 rd.lvm.lv=fedora/root rhgb LANG=en_US.UTF-8
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
[    0.000000] BRK [0x0203d000, 0x0203dfff] PGTABLE
[    0.000000] BRK [0x0203e000, 0x0203efff] PGTABLE
[    0.000000] BRK [0x0203f000, 0x0203ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x48f400000-0x48f5fffff]
[    0.000000]  [mem 0x48f400000-0x48f5fffff] page 2M
[    0.000000] BRK [0x02040000, 0x02040fff] PGTABLE
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
[    0.000000] BRK [0x02041000, 0x02041fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x56d36000-0x69b32fff]
[    0.000000]  [mem 0x56d36000-0x56dfffff] page 4k
[    0.000000]  [mem 0x56e00000-0x699fffff] page 2M
[    0.000000]  [mem 0x69a00000-0x69b32fff] page 4k
[    0.000000] BRK [0x02042000, 0x02042fff] PGTABLE
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
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.15.0-rc7 root=/dev/mapper/fedora-root ro rd.lvm.lv=fedora/swap vconsole.font=latarcyrheb-sun16 rd.lvm.lv=fedora/root rhgb LANG=en_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: CPU: 0 PID: 0 at drivers/iommu/dmar.c:761 warn_invalid_dmar+0x81/0x93()
[    0.000000] Your BIOS is broken; DMAR reported at address 0!
BIOS vendor: American Megatrends Inc.; Ver: F4; Product Version: To be filled by O.E.M.
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.15.0-rc7 #55
[    0.000000] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[    0.000000]  000000000000000b ffffffff81c01e08 ffffffff8169ea22 ffffffff81c01e50
[    0.000000]  ffffffff81c01e40 ffffffff8108413d ffffffff8203c01c ffffffff8203c058
[    0.000000]  0000000000000000 ffffffff81dc92c0 ffffffff81c01fb0 ffffffff81c01ea0
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8169ea22>] dump_stack+0x45/0x56
[    0.000000]  [<ffffffff8108413d>] warn_slowpath_common+0x7d/0xa0
[    0.000000]  [<ffffffff810841f4>] warn_slowpath_fmt_taint+0x44/0x50
[    0.000000]  [<ffffffff813c3505>] ? acpi_tb_verify_checksum+0x24/0x5b
[    0.000000]  [<ffffffff816a06a8>] warn_invalid_dmar+0x81/0x93
[    0.000000]  [<ffffffff81d7385e>] detect_intel_iommu+0x7f/0x172
[    0.000000]  [<ffffffff81d2b265>] pci_iommu_alloc+0x4a/0x6c
[    0.000000]  [<ffffffff81d3a05e>] mem_init+0xf/0x8d
[    0.000000]  [<ffffffff81d21d00>] start_kernel+0x1cd/0x405
[    0.000000]  [<ffffffff81d2193c>] ? repair_env_string+0x5c/0x5c
[    0.000000]  [<ffffffff81d21120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81d215ee>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81d2172e>] x86_64_start_kernel+0x13e/0x14d
[    0.000000] ---[ end trace e540cdab704f35e6 ]---
[    0.000000] Memory: 16280872K/16657936K available (6856K kernel code, 1060K rwdata, 3008K rodata, 1412K init, 1828K bss, 377064K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3492.133 MHz processor
[    0.000019] Calibrating delay loop (skipped), value calculated using timer frequency.. 6984.26 BogoMIPS (lpj=3492133)
[    0.000139] pid_max: default: 32768 minimum: 301
[    0.000203] ACPI: Core revision 20140214
[    0.006699] ACPI: All ACPI Tables successfully acquired
[    0.016208] Security Framework initialized
[    0.016271] SELinux:  Initializing.
[    0.016331] SELinux:  Starting in permissive mode
[    0.017073] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.019186] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.020102] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.020620] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.020871] Initializing cgroup subsys memory
[    0.020931] Initializing cgroup subsys devices
[    0.020990] Initializing cgroup subsys freezer
[    0.021048] Initializing cgroup subsys net_cls
[    0.021107] Initializing cgroup subsys blkio
[    0.021165] Initializing cgroup subsys perf_event
[    0.021224] Initializing cgroup subsys hugetlb
[    0.021295] CPU: Physical Processor ID: 0
[    0.021352] CPU: Processor Core ID: 0
[    0.022119] mce: CPU supports 9 MCE banks
[    0.022185] CPU0: Thermal monitoring enabled (TM1)
[    0.022251] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
tlb_flushall_shift: 6
[    0.022453] Freeing SMP alternatives memory: 24K (ffffffff81e6c000 - ffffffff81e72000)
[    0.023176] ftrace: allocating 26174 entries in 103 pages
[    0.030329] dmar: Host address width 39
[    0.030410] dmar: DRHD base: 0x00000000000000 flags: 0x1
[    0.030493] dmar: parse DMAR table failure.
[    0.030946] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.041023] smpboot: CPU0: Intel(R) Core(TM) i7-4770K CPU @ 3.50GHz (fam: 06, model: 3c, stepping: 03)
[    0.041242] TSC deadline timer enabled
[    0.041246] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.041520] ... version:                3
[    0.041601] ... bit width:              48
[    0.041681] ... generic registers:      4
[    0.041761] ... value mask:             0000ffffffffffff
[    0.041844] ... max period:             0000ffffffffffff
[    0.041926] ... fixed-purpose events:   3
[    0.042006] ... event mask:             000000070000000f
[    0.042832] x86: Booting SMP configuration:
[    0.042913] .... node  #0, CPUs:      #1
[    0.056956] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.057206]  #2 #3 #4 #5 #6 #7
[    0.140675] x86: Booted up 1 node, 8 CPUs
[    0.140833] smpboot: Total of 8 processors activated (55874.12 BogoMIPS)
[    0.147033] devtmpfs: initialized
[    0.149049] PM: Registering ACPI NVS region [mem 0x5573f000-0x55745fff] (28672 bytes)
[    0.149183] PM: Registering ACPI NVS region [mem 0x69d88000-0x69e49fff] (794624 bytes)
[    0.149770] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.149856] pinctrl core: initialized pinctrl subsystem
[    0.149966] RTC time: 14:14:57, date: 05/26/14
[    0.150069] NET: Registered protocol family 16
[    0.150199] cpuidle: using governor menu
[    0.150298] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.150432] ACPI: bus type PCI registered
[    0.150512] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.150627] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.150763] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.166341] PCI: Using configuration type 1 for base access
[    0.167341] ACPI: Added _OSI(Module Device)
[    0.167422] ACPI: Added _OSI(Processor Device)
[    0.167503] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.167584] ACPI: Added _OSI(Processor Aggregator Device)
[    0.169965] ACPI: Executed 1 blocks of module-level executable AML code
[    0.171522] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.193994] ACPI: SSDT 0x0000000069D3CC18 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.194445] ACPI: Dynamic OEM Table Load:
[    0.194579] ACPI: SSDT 0x0000000000000000 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.199071] ACPI: SSDT 0x0000000069D3C618 0005AA (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.199619] ACPI: Dynamic OEM Table Load:
[    0.199754] ACPI: SSDT 0x0000000000000000 0005AA (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.203999] ACPI: SSDT 0x0000000069D3BD98 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.204451] ACPI: Dynamic OEM Table Load:
[    0.204586] ACPI: SSDT 0x0000000000000000 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.209652] ACPI: Interpreter enabled
[    0.209736] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    0.209928] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    0.210127] ACPI: (supports S0 S3 S4 S5)
[    0.210207] ACPI: Using IOAPIC for interrupt routing
[    0.210304] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.214982] ACPI: Power Resource [FN00] (off)
[    0.215103] ACPI: Power Resource [FN01] (off)
[    0.215221] ACPI: Power Resource [FN02] (off)
[    0.215338] ACPI: Power Resource [FN03] (off)
[    0.215455] ACPI: Power Resource [FN04] (off)
[    0.215943] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.216031] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.216286] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.216483] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.216872] PCI host bridge to bus 0000:00
[    0.216954] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.217037] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.217122] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.217208] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.217293] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.217379] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.217464] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.217549] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.217635] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.217720] pci_bus 0000:00: root bus resource [mem 0x6fa00000-0xfeafffff]
[    0.217809] pci 0000:00:00.0: [8086:0c00] type 00 class 0x060000
[    0.217860] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.217882] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.217910] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.218018] pci 0000:00:02.0: [8086:0412] type 00 class 0x030000
[    0.218025] pci 0000:00:02.0: reg 0x10: [mem 0xde400000-0xde7fffff 64bit]
[    0.218029] pci 0000:00:02.0: reg 0x18: [mem 0x70000000-0x7fffffff 64bit pref]
[    0.218033] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.218078] pci 0000:00:03.0: [8086:0c0c] type 00 class 0x040300
[    0.218083] pci 0000:00:03.0: reg 0x10: [mem 0xdef34000-0xdef37fff 64bit]
[    0.218146] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.218161] pci 0000:00:14.0: reg 0x10: [mem 0xdef20000-0xdef2ffff 64bit]
[    0.218211] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.218234] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.218339] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.218355] pci 0000:00:16.0: reg 0x10: [mem 0xdef3f000-0xdef3f00f 64bit]
[    0.218406] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.218455] pci 0000:00:19.0: [8086:153b] type 00 class 0x020000
[    0.218468] pci 0000:00:19.0: reg 0x10: [mem 0xdef00000-0xdef1ffff]
[    0.218474] pci 0000:00:19.0: reg 0x14: [mem 0xdef3d000-0xdef3dfff]
[    0.218480] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    0.218528] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.218551] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.218657] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    0.218674] pci 0000:00:1a.0: reg 0x10: [mem 0xdef3c000-0xdef3c3ff]
[    0.218747] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.218778] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.218884] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    0.218895] pci 0000:00:1b.0: reg 0x10: [mem 0xdef30000-0xdef33fff 64bit]
[    0.218951] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.218975] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.219078] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.219138] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.219164] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.219271] pci 0000:00:1c.4: [8086:8c18] type 01 class 0x060400
[    0.219324] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.219349] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.219452] pci 0000:00:1c.6: [8086:8c1c] type 01 class 0x060400
[    0.219505] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.219530] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    0.219637] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    0.219653] pci 0000:00:1d.0: reg 0x10: [mem 0xdef3b000-0xdef3b3ff]
[    0.219726] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.219758] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.219864] pci 0000:00:1f.0: [8086:8c44] type 00 class 0x060100
[    0.219991] pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
[    0.220003] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    0.220008] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    0.220013] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    0.220019] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    0.220024] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.220029] pci 0000:00:1f.2: reg 0x24: [mem 0xdef3a000-0xdef3a7ff]
[    0.220058] pci 0000:00:1f.2: PME# supported from D3hot
[    0.220096] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.220107] pci 0000:00:1f.3: reg 0x10: [mem 0xdef39000-0xdef390ff 64bit]
[    0.220123] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.220197] pci 0000:01:00.0: [10b5:8747] type 01 class 0x060400
[    0.220204] pci 0000:01:00.0: reg 0x10: [mem 0xdee00000-0xdee3ffff]
[    0.220250] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.220264] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.222279] pci 0000:00:01.0: PCI bridge to [bus 01-04]
[    0.222363] pci 0000:00:01.0:   bridge window [mem 0xdee00000-0xdeefffff]
[    0.222403] pci 0000:02:08.0: [10b5:8747] type 01 class 0x060400
[    0.222454] pci 0000:02:08.0: PME# supported from D0 D3hot D3cold
[    0.222489] pci 0000:02:10.0: [10b5:8747] type 01 class 0x060400
[    0.222540] pci 0000:02:10.0: PME# supported from D0 D3hot D3cold
[    0.222571] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    0.222685] pci 0000:02:08.0: PCI bridge to [bus 03]
[    0.270871] pci 0000:02:10.0: PCI bridge to [bus 04]
[    0.271016] acpiphp: Slot [1] registered
[    0.271098] pci 0000:00:1c.0: PCI bridge to [bus 05-6f]
[    0.271184] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xde0fffff]
[    0.271188] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0xb9ffffff 64bit pref]
[    0.271247] pci 0000:70:00.0: [1b4b:9230] type 00 class 0x010601
[    0.271258] pci 0000:70:00.0: reg 0x10: [io  0xe050-0xe057]
[    0.271266] pci 0000:70:00.0: reg 0x14: [io  0xe040-0xe043]
[    0.271275] pci 0000:70:00.0: reg 0x18: [io  0xe030-0xe037]
[    0.271283] pci 0000:70:00.0: reg 0x1c: [io  0xe020-0xe023]
[    0.271291] pci 0000:70:00.0: reg 0x20: [io  0xe000-0xe01f]
[    0.271299] pci 0000:70:00.0: reg 0x24: [mem 0xded10000-0xded107ff]
[    0.271307] pci 0000:70:00.0: reg 0x30: [mem 0xded00000-0xded0ffff pref]
[    0.271352] pci 0000:70:00.0: PME# supported from D3hot
[    0.271371] pci 0000:70:00.0: System wakeup disabled by ACPI
[    0.272902] pci 0000:00:1c.4: PCI bridge to [bus 70]
[    0.272986] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.272988] pci 0000:00:1c.4:   bridge window [mem 0xded00000-0xdedfffff]
[    0.273050] pci 0000:71:00.0: [10b5:8605] type 01 class 0x060400
[    0.273067] pci 0000:71:00.0: reg 0x10: [mem 0xdec00000-0xdec03fff]
[    0.273191] pci 0000:71:00.0: supports D1 D2
[    0.273192] pci 0000:71:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.273221] pci 0000:71:00.0: System wakeup disabled by ACPI
[    0.274906] pci 0000:00:1c.6: PCI bridge to [bus 71-75]
[    0.274990] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
[    0.274992] pci 0000:00:1c.6:   bridge window [mem 0xde800000-0xdecfffff]
[    0.275077] pci 0000:72:01.0: [10b5:8605] type 01 class 0x060400
[    0.275216] pci 0000:72:01.0: supports D1 D2
[    0.275216] pci 0000:72:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.275275] pci 0000:72:02.0: [10b5:8605] type 01 class 0x060400
[    0.275413] pci 0000:72:02.0: supports D1 D2
[    0.275414] pci 0000:72:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.275472] pci 0000:72:03.0: [10b5:8605] type 01 class 0x060400
[    0.275610] pci 0000:72:03.0: supports D1 D2
[    0.275610] pci 0000:72:03.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.275689] pci 0000:71:00.0: PCI bridge to [bus 72-75]
[    0.275778] pci 0000:71:00.0:   bridge window [io  0xd000-0xdfff]
[    0.275782] pci 0000:71:00.0:   bridge window [mem 0xde800000-0xdebfffff]
[    0.275850] pci 0000:72:01.0: PCI bridge to [bus 73]
[    0.276047] pci 0000:74:00.0: [8086:08b1] type 00 class 0x028000
[    0.276091] pci 0000:74:00.0: reg 0x10: [mem 0xdeb00000-0xdeb01fff 64bit]
[    0.276342] pci 0000:74:00.0: PME# supported from D0 D3hot D3cold
[    0.277955] pci 0000:72:02.0: PCI bridge to [bus 74]
[    0.278046] pci 0000:72:02.0:   bridge window [mem 0xdeb00000-0xdebfffff]
[    0.278152] pci 0000:75:00.0: [8086:1533] type 00 class 0x020000
[    0.278178] pci 0000:75:00.0: reg 0x10: [mem 0xde900000-0xde9fffff]
[    0.278215] pci 0000:75:00.0: reg 0x18: [io  0xd000-0xd01f]
[    0.278234] pci 0000:75:00.0: reg 0x1c: [mem 0xdea00000-0xdea03fff]
[    0.278289] pci 0000:75:00.0: reg 0x30: [mem 0xde800000-0xde8fffff pref]
[    0.278417] pci 0000:75:00.0: PME# supported from D0 D3hot D3cold
[    0.279950] pci 0000:72:03.0: PCI bridge to [bus 75]
[    0.280038] pci 0000:72:03.0:   bridge window [io  0xd000-0xdfff]
[    0.280042] pci 0000:72:03.0:   bridge window [mem 0xde800000-0xdeafffff]
[    0.280113] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.280533] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.280940] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.281342] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.281745] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.282148] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.282550] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.283056] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.283457] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.283949] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.284132] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.284268] vgaarb: loaded
[    0.284346] vgaarb: bridge control possible 0000:00:02.0
[    0.284459] SCSI subsystem initialized
[    0.284559] libata version 3.00 loaded.
[    0.284574] ACPI: bus type USB registered
[    0.284663] usbcore: registered new interface driver usbfs
[    0.284750] usbcore: registered new interface driver hub
[    0.284841] usbcore: registered new device driver usb
[    0.284958] PCI: Using ACPI for IRQ routing
[    0.290268] PCI: pci_cache_line_size set to 64 bytes
[    0.290325] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.290326] e820: reserve RAM buffer [mem 0x5573f000-0x57ffffff]
[    0.290327] e820: reserve RAM buffer [mem 0x567b0000-0x57ffffff]
[    0.290327] e820: reserve RAM buffer [mem 0x69b33000-0x6bffffff]
[    0.290328] e820: reserve RAM buffer [mem 0x69d88000-0x6bffffff]
[    0.290329] e820: reserve RAM buffer [mem 0x6b000000-0x6bffffff]
[    0.290330] e820: reserve RAM buffer [mem 0x48f600000-0x48fffffff]
[    0.290378] NetLabel: Initializing
[    0.290457] NetLabel:  domain hash size = 128
[    0.290538] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.290628] NetLabel:  unlabeled traffic allowed by default
[    0.290732] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.291059] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.293157] Switched to clocksource hpet
[    0.296476] pnp: PnP ACPI init
[    0.296563] ACPI: bus type PNP registered
[    0.296684] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.296770] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.296776] pnp 00:01: [dma 4]
[    0.296785] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.296795] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.296844] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.296910] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.296994] system 00:04: [io  0xffff] has been reserved
[    0.297077] system 00:04: [io  0xffff] has been reserved
[    0.297164] system 00:04: [io  0xffff] has been reserved
[    0.297247] system 00:04: [io  0x1c00-0x1cfe] has been reserved
[    0.297331] system 00:04: [io  0x1d00-0x1dfe] has been reserved
[    0.297415] system 00:04: [io  0x1e00-0x1efe] has been reserved
[    0.297499] system 00:04: [io  0x1f00-0x1ffe] has been reserved
[    0.297583] system 00:04: [io  0x1800-0x18fe] could not be reserved
[    0.297668] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.297752] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.297769] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.297794] system 00:06: [io  0x1854-0x1857] has been reserved
[    0.297878] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.297944] system 00:07: [io  0x0a00-0x0a0f] has been reserved
[    0.298028] system 00:07: [io  0x0a30-0x0a3f] has been reserved
[    0.299540] system 00:07: [io  0x0a20-0x0a2f] has been reserved
[    0.299624] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.299759] pnp 00:08: [dma 0 disabled]
[    0.299783] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.299812] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.299896] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.299910] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.300145] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.300234] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.300319] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.300404] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.300489] system 00:0b: [mem 0xe0000000-0xefffffff] has been reserved
[    0.300574] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.300659] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.300744] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.300829] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    0.300915] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.301001] system 00:0b: [mem 0xdffef000-0xdffeffff] has been reserved
[    0.301085] system 00:0b: [mem 0xdfff0000-0xdfff0fff] has been reserved
[    0.301173] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.301304] pnp: PnP ACPI: found 12 devices
[    0.301384] ACPI: bus type PNP unregistered
[    0.307076] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus 05-6f] add_size 1000
[    0.307091] pci 0000:72:01.0: bridge window [io  0x1000-0x0fff] to [bus 73] add_size 1000
[    0.307093] pci 0000:72:01.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 73] add_size 200000
[    0.307094] pci 0000:72:01.0: bridge window [mem 0x00100000-0x000fffff] to [bus 73] add_size 200000
[    0.307123] pci 0000:72:01.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.307124] pci 0000:71:00.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 72-75] add_size 200000
[    0.307130] pci 0000:71:00.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.307131] pci 0000:00:1c.6: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 71-75] add_size 200000
[    0.307133] pci 0000:00:1c.6: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.307134] pci 0000:00:1c.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.307138] pci 0000:00:1c.6: BAR 15: assigned [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.307276] pci 0000:00:1c.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.307360] pci 0000:02:08.0: PCI bridge to [bus 03]
[    0.307447] pci 0000:02:10.0: PCI bridge to [bus 04]
[    0.307535] pci 0000:01:00.0: PCI bridge to [bus 02-04]
[    0.307623] pci 0000:00:01.0: PCI bridge to [bus 01-04]
[    0.307706] pci 0000:00:01.0:   bridge window [mem 0xdee00000-0xdeefffff]
[    0.307793] pci 0000:00:1c.0: PCI bridge to [bus 05-6f]
[    0.307876] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.307963] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xde0fffff]
[    0.308050] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0xb9ffffff 64bit pref]
[    0.308190] pci 0000:00:1c.4: PCI bridge to [bus 70]
[    0.308272] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.308359] pci 0000:00:1c.4:   bridge window [mem 0xded00000-0xdedfffff]
[    0.308448] pci 0000:71:00.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.308450] pci 0000:71:00.0: BAR 15: assigned [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.308584] pci 0000:72:01.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    0.308585] pci 0000:72:01.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    0.308586] pci 0000:72:01.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    0.308587] pci 0000:72:01.0: BAR 14: can't assign mem (size 0x200000)
[    0.308672] pci 0000:72:01.0: BAR 15: assigned [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.308806] pci 0000:72:01.0: BAR 13: can't assign io (size 0x1000)
[    0.308891] pci 0000:72:01.0: BAR 14: can't assign mem (size 0x200000)
[    0.308975] pci 0000:72:01.0: BAR 13: can't assign io (size 0x1000)
[    0.309060] pci 0000:72:01.0: PCI bridge to [bus 73]
[    0.309153] pci 0000:72:01.0:   bridge window [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.309293] pci 0000:72:02.0: PCI bridge to [bus 74]
[    0.309379] pci 0000:72:02.0:   bridge window [mem 0xdeb00000-0xdebfffff]
[    0.309474] pci 0000:72:03.0: PCI bridge to [bus 75]
[    0.309557] pci 0000:72:03.0:   bridge window [io  0xd000-0xdfff]
[    0.309646] pci 0000:72:03.0:   bridge window [mem 0xde800000-0xdeafffff]
[    0.309741] pci 0000:71:00.0: PCI bridge to [bus 72-75]
[    0.309825] pci 0000:71:00.0:   bridge window [io  0xd000-0xdfff]
[    0.309913] pci 0000:71:00.0:   bridge window [mem 0xde800000-0xdebfffff]
[    0.310002] pci 0000:71:00.0:   bridge window [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.310144] pci 0000:00:1c.6: PCI bridge to [bus 71-75]
[    0.310227] pci 0000:00:1c.6:   bridge window [io  0xd000-0xdfff]
[    0.310313] pci 0000:00:1c.6:   bridge window [mem 0xde800000-0xdecfffff]
[    0.310400] pci 0000:00:1c.6:   bridge window [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.310537] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.310538] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.310538] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.310539] pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
[    0.310540] pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
[    0.310541] pci_bus 0000:00: resource 9 [mem 0x000dc000-0x000dffff]
[    0.310542] pci_bus 0000:00: resource 10 [mem 0x000e0000-0x000e3fff]
[    0.310542] pci_bus 0000:00: resource 11 [mem 0x000e4000-0x000e7fff]
[    0.310543] pci_bus 0000:00: resource 12 [mem 0x6fa00000-0xfeafffff]
[    0.310544] pci_bus 0000:01: resource 1 [mem 0xdee00000-0xdeefffff]
[    0.310545] pci_bus 0000:05: resource 0 [io  0x2000-0x2fff]
[    0.310546] pci_bus 0000:05: resource 1 [mem 0xc0000000-0xde0fffff]
[    0.310547] pci_bus 0000:05: resource 2 [mem 0x80000000-0xb9ffffff 64bit pref]
[    0.310548] pci_bus 0000:70: resource 0 [io  0xe000-0xefff]
[    0.310549] pci_bus 0000:70: resource 1 [mem 0xded00000-0xdedfffff]
[    0.310549] pci_bus 0000:71: resource 0 [io  0xd000-0xdfff]
[    0.310550] pci_bus 0000:71: resource 1 [mem 0xde800000-0xdecfffff]
[    0.310551] pci_bus 0000:71: resource 2 [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.310552] pci_bus 0000:72: resource 0 [io  0xd000-0xdfff]
[    0.310553] pci_bus 0000:72: resource 1 [mem 0xde800000-0xdebfffff]
[    0.310554] pci_bus 0000:72: resource 2 [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.310554] pci_bus 0000:73: resource 2 [mem 0x6fa00000-0x6fbfffff 64bit pref]
[    0.310555] pci_bus 0000:74: resource 1 [mem 0xdeb00000-0xdebfffff]
[    0.310556] pci_bus 0000:75: resource 0 [io  0xd000-0xdfff]
[    0.310557] pci_bus 0000:75: resource 1 [mem 0xde800000-0xdeafffff]
[    0.310571] NET: Registered protocol family 2
[    0.310765] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.311033] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.311213] TCP: Hash tables configured (established 131072 bind 65536)
[    0.311306] TCP: reno registered
[    0.311397] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.311515] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.311651] NET: Registered protocol family 1
[    0.311738] pci 0000:00:02.0: Boot video device
[    0.326190] PCI: CLS mismatch (64 != 128), using 64 bytes
[    0.337200] Unpacking initramfs...
[    0.632274] Freeing initrd memory: 30848K (ffff8800343b0000 - ffff8800361d0000)
[    0.632411] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.632496] software IO TLB [mem 0x65b33000-0x69b33000] (64MB) mapped at [ffff880065b33000-ffff880069b32fff]
[    0.632852] RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
[    0.633283] AVX2 version of gcm_enc/dec engaged.
[    0.634538] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    0.634827] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.634940] Initialise system trusted keyring
[    0.635027] audit: initializing netlink subsys (disabled)
[    0.635119] audit: type=2000 audit(1401113696.557:1): initialized
[    0.649135] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.649956] zbud: loaded
[    0.650122] VFS: Disk quotas dquot_6.5.2
[    0.650220] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.650471] msgmni has been set to 31858
[    0.650579] Key type big_key registered
[    0.650659] SELinux:  Registering netfilter hooks
[    0.651246] alg: No test for stdrng (krng)
[    0.651330] NET: Registered protocol family 38
[    0.651412] Key type asymmetric registered
[    0.651492] Asymmetric key parser 'x509' registered
[    0.651590] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.651748] io scheduler noop registered
[    0.651828] io scheduler deadline registered
[    0.651937] io scheduler cfq registered (default)
[    0.652127] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.652357] pcieport 0000:01:00.0: irq 41 for MSI/MSI-X
[    0.652435] pcieport 0000:02:08.0: irq 42 for MSI/MSI-X
[    0.652512] pcieport 0000:02:10.0: irq 43 for MSI/MSI-X
[    0.652615] pcieport 0000:71:00.0: irq 44 for MSI/MSI-X
[    0.652758] pcieport 0000:72:01.0: irq 45 for MSI/MSI-X
[    0.652916] pcieport 0000:72:02.0: irq 46 for MSI/MSI-X
[    0.653059] pcieport 0000:72:03.0: irq 47 for MSI/MSI-X
[    0.653164] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.653255] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.653357] intel_idle: MWAIT substates: 0x42120
[    0.653357] intel_idle: v0.4 model 0x3C
[    0.653358] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.653562] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.653698] ACPI: Power Button [PWRB]
[    0.653797] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.653949] ACPI: Power Button [PWRF]
[    0.654063] ACPI: Fan [FAN0] (off)
[    0.654156] ACPI: Fan [FAN1] (off)
[    0.654248] ACPI: Fan [FAN2] (off)
[    0.654341] ACPI: Fan [FAN3] (off)
[    0.654433] ACPI: Fan [FAN4] (off)
[    0.654790] thermal LNXTHERM:00: registered as thermal_zone0
[    0.654892] ACPI: Thermal Zone [TZ00] (28 C)
[    0.655084] thermal LNXTHERM:01: registered as thermal_zone1
[    0.655168] ACPI: Thermal Zone [TZ01] (30 C)
[    0.655262] GHES: HEST is not enabled!
[    0.655369] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.675965] 00:08: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.676335] Non-volatile memory driver v1.3
[    0.676416] Linux agpgart interface v0.103
[    0.676565] ahci 0000:00:1f.2: version 3.0
[    0.676620] ahci 0000:00:1f.2: irq 48 for MSI/MSI-X
[    0.676651] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x29 impl SATA mode
[    0.676787] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part ems apst 
[    0.681152] scsi0 : ahci
[    0.681367] scsi1 : ahci
[    0.681667] scsi2 : ahci
[    0.681969] scsi3 : ahci
[    0.682269] scsi4 : ahci
[    0.682528] scsi5 : ahci
[    0.682644] ata1: SATA max UDMA/133 abar m2048@0xdef3a000 port 0xdef3a100 irq 48
[    0.682776] ata2: DUMMY
[    0.682863] ata3: DUMMY
[    0.682942] ata4: SATA max UDMA/133 abar m2048@0xdef3a000 port 0xdef3a280 irq 48
[    0.683074] ata5: DUMMY
[    0.683152] ata6: SATA max UDMA/133 abar m2048@0xdef3a000 port 0xdef3a380 irq 48
[    0.683354] ahci 0000:70:00.0: controller can do FBS, turning on CAP_FBS
[    0.683557] ahci 0000:70:00.0: irq 49 for MSI/MSI-X
[    0.693869] ahci 0000:70:00.0: AHCI 0001.0200 32 slots 8 ports 6 Gbps 0xff impl SATA mode
[    0.694003] ahci 0000:70:00.0: flags: 64bit ncq fbs pio 
[    0.694620] scsi6 : ahci
[    0.694967] scsi7 : ahci
[    0.695228] scsi8 : ahci
[    0.695403] scsi9 : ahci
[    0.695618] scsi10 : ahci
[    0.695834] scsi11 : ahci
[    0.696025] scsi12 : ahci
[    0.696232] scsi13 : ahci
[    0.696331] ata7: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10100 irq 49
[    0.696464] ata8: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10180 irq 49
[    0.696598] ata9: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10200 irq 49
[    0.696730] ata10: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10280 irq 49
[    0.696868] ata11: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10300 irq 49
[    0.697001] ata12: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10380 irq 49
[    0.697134] ata13: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10400 irq 49
[    0.697267] ata14: SATA max UDMA/133 abar m2048@0xded10000 port 0xded10480 irq 49
[    0.697455] libphy: Fixed MDIO Bus: probed
[    0.697779] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.698065] ehci-pci: EHCI PCI platform driver
[    0.698263] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.698374] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.698515] ehci-pci 0000:00:1a.0: debug port 2
[    0.702476] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.702485] ehci-pci 0000:00:1a.0: irq 16, io mem 0xdef3c000
[    0.707812] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.707922] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.708007] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.708139] usb usb1: Product: EHCI Host Controller
[    0.708221] usb usb1: Manufacturer: Linux 3.15.0-rc7 ehci_hcd
[    0.709726] usb usb1: SerialNumber: 0000:00:1a.0
[    0.709922] hub 1-0:1.0: USB hub found
[    0.710005] hub 1-0:1.0: 2 ports detected
[    0.710194] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.710300] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.710440] ehci-pci 0000:00:1d.0: debug port 2
[    0.714398] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.714405] ehci-pci 0000:00:1d.0: irq 23, io mem 0xdef3b000
[    0.719802] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.719906] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.719991] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.720123] usb usb2: Product: EHCI Host Controller
[    0.720204] usb usb2: Manufacturer: Linux 3.15.0-rc7 ehci_hcd
[    0.720287] usb usb2: SerialNumber: 0000:00:1d.0
[    0.720425] hub 2-0:1.0: USB hub found
[    0.720507] hub 2-0:1.0: 2 ports detected
[    0.720643] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.720728] ohci-pci: OHCI PCI platform driver
[    0.720820] uhci_hcd: USB Universal Host Controller Interface driver
[    0.720966] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.721071] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    0.721267] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    0.721277] xhci_hcd 0000:00:14.0: irq 50 for MSI/MSI-X
[    0.721310] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.721395] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.721527] usb usb3: Product: xHCI Host Controller
[    0.721609] usb usb3: Manufacturer: Linux 3.15.0-rc7 xhci_hcd
[    0.721692] usb usb3: SerialNumber: 0000:00:14.0
[    0.721830] hub 3-0:1.0: USB hub found
[    0.721922] hub 3-0:1.0: 14 ports detected
[    0.723352] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    0.723455] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    0.723610] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    0.723695] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.723834] usb usb4: Product: xHCI Host Controller
[    0.723915] usb usb4: Manufacturer: Linux 3.15.0-rc7 xhci_hcd
[    0.723998] usb usb4: SerialNumber: 0000:00:14.0
[    0.724128] hub 4-0:1.0: USB hub found
[    0.724216] hub 4-0:1.0: 6 ports detected
[    0.724913] usbcore: registered new interface driver usbserial
[    0.725000] usbcore: registered new interface driver usbserial_generic
[    0.725087] usbserial: USB Serial support registered for generic
[    0.725183] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.725616] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.725699] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.725829] mousedev: PS/2 mouse device common for all mice
[    0.726028] rtc_cmos 00:05: RTC can wake from S4
[    0.726224] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.726328] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.726490] device-mapper: uevent: version 1.0.3
[    0.726611] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    0.726800] Intel P-state driver initializing.
[    0.726885] Intel pstate controlling: cpu 0
[    0.726976] Intel pstate controlling: cpu 1
[    0.727062] Intel pstate controlling: cpu 2
[    0.727147] Intel pstate controlling: cpu 3
[    0.727234] Intel pstate controlling: cpu 4
[    0.727319] Intel pstate controlling: cpu 5
[    0.727405] Intel pstate controlling: cpu 6
[    0.727491] Intel pstate controlling: cpu 7
[    0.727745] hidraw: raw HID events driver (C) Jiri Kosina
[    0.727876] usbcore: registered new interface driver usbhid
[    0.727958] usbhid: USB HID core driver
[    0.728047] drop_monitor: Initializing network drop monitor service
[    0.728162] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.728308] TCP: cubic registered
[    0.728413] Initializing XFRM netlink socket
[    0.728544] NET: Registered protocol family 10
[    0.728784] mip6: Mobile IPv6
[    0.728870] NET: Registered protocol family 17
[    0.729163] Loading compiled-in X.509 certificates
[    0.729695] Loaded X.509 cert 'Magrathea: Glacier signing key: b2d725434700af2dc331734897eb86db6cc53062'
[    0.729842] registered taskstats version 1
[    0.730486]   Magic number: 14:599:233
[    0.730592] acpi device:4d: hash matches
[    0.730687] memory memory111: hash matches
[    0.730829] rtc_cmos 00:05: setting system clock to 2014-05-26 14:14:57 UTC (1401113697)
[    0.731005] PM: Hibernation image not present or could not be loaded.
[    0.987615] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.987713] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.987832] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.988055] ata1.00: ATA-9: INTEL SSDSC2BB480G4, D2010370, max UDMA/133
[    0.988140] ata1.00: 937703088 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    0.988556] ata1.00: configured for UDMA/133
[    0.988871] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSC2BB48 D201 PQ: 0 ANSI: 5
[    0.989317] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.989322] sd 0:0:0:0: [sda] 937703088 512-byte logical blocks: (480 GB/447 GiB)
[    0.989323] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    0.989464] sd 0:0:0:0: [sda] Write Protect is off
[    0.989465] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.989521] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.989923] ata4.00: ATA-8: WDC WD5000AAKX-753CA0, 15.01H15, max UDMA/133
[    0.989924] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.990263] ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.990264] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    0.990265] ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    0.990274]  sda: sda1 sda2
[    0.990666] sd 0:0:0:0: [sda] Attached SCSI disk
[    0.991173] ata4.00: configured for UDMA/133
[    0.991372] scsi 3:0:0:0: Direct-Access     ATA      WDC WD5000AAKX-7 15.0 PQ: 0 ANSI: 5
[    0.991619] sd 3:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    0.991664] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    0.991907] ata6.00: ATAPI: ATAPI   iHAS124   W, HL0G, max UDMA/100
[    0.991915] sd 3:0:0:0: [sdb] Write Protect is off
[    0.991916] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    0.991920] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.994716] ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    0.994718] ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    0.994851] ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    0.996518] ata6.00: configured for UDMA/100
[    0.997722] scsi 5:0:0:0: CD-ROM            ATAPI    iHAS124   W      HL0G PQ: 0 ANSI: 5
[    1.001617] ata9: SATA link down (SStatus 0 SControl 300)
[    1.001720] ata8: SATA link down (SStatus 0 SControl 300)
[    1.002621] ata13: SATA link down (SStatus 0 SControl 300)
[    1.002724] ata11: SATA link down (SStatus 0 SControl 300)
[    1.002838] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.003020] ata14.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
[    1.003276] ata14.00: configured for UDMA/66
[    1.003609] ata7: SATA link down (SStatus 0 SControl 300)
[    1.003724] ata10: SATA link down (SStatus 0 SControl 300)
[    1.004617] ata12: SATA link down (SStatus 0 SControl 300)
[    1.011601] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.021171] sr0: scsi3-mmc drive: 188x/125x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.021305] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.021544] sr 5:0:0:0: Attached scsi CD-ROM sr0
[    1.021673] sr 5:0:0:0: Attached scsi generic sg2 type 5
[    1.022222] scsi 13:0:0:0: Processor         Marvell  Console          1.01 PQ: 0 ANSI: 5
[    1.023528]  sdb: sdb1 sdb2 < sdb5 sdb6 >
[    1.023802] sd 3:0:0:0: [sdb] Attached SCSI disk
[    1.033568] ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[    1.033653] ata14.00: irq_stat 0x40000001
[    1.033733] scsi 13:0:0:0: CDB: 
[    1.033812] Inquiry: 12 01 00 00 ff 00
[    1.034107] ata14.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 3 dma 16640 in
         res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)
[    1.034345] ata14: hard resetting link
[    1.125898] usb 1-1: New USB device found, idVendor=8087, idProduct=8008
[    1.125983] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.126288] hub 1-1:1.0: USB hub found
[    1.126522] hub 1-1:1.0: 6 ports detected
[    1.229396] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.340316] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.340669] ata14.00: configured for UDMA/66
[    1.340833] ata14: EH complete
[    1.341001] scsi 13:0:0:0: Attached scsi generic sg3 type 3
[    1.341766] Freeing unused kernel memory: 1412K (ffffffff81d0b000 - ffffffff81e6c000)
[    1.341899] Write protecting the kernel read-only data: 12288k
[    1.343711] usb 2-1: New USB device found, idVendor=8087, idProduct=8000
[    1.343832] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.343842] Freeing unused kernel memory: 1324K (ffff8800016b5000 - ffff880001800000)
[    1.344195] hub 2-1:1.0: USB hub found
[    1.344448] hub 2-1:1.0: 8 ports detected
[    1.345494] Freeing unused kernel memory: 1088K (ffff880001af0000 - ffff880001c00000)
[    1.347187] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    1.347449] systemd[1]: Running in initial RAM disk.
[    1.347892] systemd[1]: Set hostname to <lahna>.
[    1.348238] random: systemd urandom read with 88 bits of entropy available
[    1.363637] systemd[1]: Expecting device dev-mapper-fedora\x2droot.device...
[    1.363907] systemd[1]: Starting -.slice.
[    1.364390] systemd[1]: Created slice -.slice.
[    1.364476] systemd[1]: Starting System Slice.
[    1.364810] systemd[1]: Created slice System Slice.
[    1.364895] systemd[1]: Starting Slices.
[    1.365201] systemd[1]: Reached target Slices.
[    1.365338] systemd[1]: Starting Timers.
[    1.365644] systemd[1]: Reached target Timers.
[    1.365730] systemd[1]: Starting udev Kernel Socket.
[    1.366047] systemd[1]: Listening on udev Kernel Socket.
[    1.366134] systemd[1]: Starting udev Control Socket.
[    1.366500] systemd[1]: Listening on udev Control Socket.
[    1.366586] systemd[1]: Starting Journal Socket.
[    1.366910] systemd[1]: Listening on Journal Socket.
[    1.367037] systemd[1]: Starting dracut cmdline hook...
[    1.367489] systemd[1]: Starting Apply Kernel Variables...
[    1.367927] systemd[1]: Starting Create list of required static device nodes for the current kernel...
[    1.368445] systemd[1]: Starting Sockets.
[    1.368769] systemd[1]: Reached target Sockets.
[    1.368860] systemd[1]: Starting Setup Virtual Console...
[    1.369278] systemd[1]: Starting Journal Service...
[    1.370006] systemd[1]: Started Journal Service.
[    1.443655] systemd-udevd[320]: starting version 208
[    1.464820] pps_core: LinuxPPS API ver. 1 registered
[    1.464923] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    1.471316] PTP clock support registered
[    1.476535] dca service started, version 1.12.1
[    1.495953] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    1.496042] igb: Copyright (c) 2007-2014 Intel Corporation.
[    1.498173] usb 3-9: new high-speed USB device number 2 using xhci_hcd
[    1.522505] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    1.522598] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    1.522833] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    1.522990] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[    1.539721] [drm] Initialized drm 1.1.0 20060810
[    1.564451] random: nonblocking pool is initialized
[    1.604718] igb 0000:75:00.0: irq 52 for MSI/MSI-X
[    1.604721] igb 0000:75:00.0: irq 53 for MSI/MSI-X
[    1.604722] igb 0000:75:00.0: irq 54 for MSI/MSI-X
[    1.604724] igb 0000:75:00.0: irq 55 for MSI/MSI-X
[    1.604726] igb 0000:75:00.0: irq 56 for MSI/MSI-X
[    1.633059] tsc: Refined TSC clocksource calibration: 3491.915 MHz
[    1.633534] igb 0000:75:00.0: added PHC on eth0
[    1.633630] igb 0000:75:00.0: Intel(R) Gigabit Ethernet Network Connection
[    1.633716] igb 0000:75:00.0: eth0: (PCIe:2.5Gb/s:Width x1) 74:d4:35:1b:fc:39
[    1.633862] igb 0000:75:00.0: eth0: PBA No: 000200-000
[    1.633945] igb 0000:75:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
[    1.647126] systemd-udevd[328]: renamed network interface eth0 to p4p1
[    1.663444] usb 3-9: New USB device found, idVendor=045b, idProduct=0209
[    1.663536] usb 3-9: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.663908] hub 3-9:1.0: USB hub found
[    1.664033] hub 3-9:1.0: 4 ports detected
[    1.692128] e1000e 0000:00:19.0 eth0: registered PHC clock
[    1.692221] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 74:d4:35:1b:fc:26
[    1.692364] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    1.692477] e1000e 0000:00:19.0 eth0: MAC: 11, PHY: 12, PBA No: FFFFFF-0FF
[    1.693418] [drm] Memory usable by graphics device = 2048M
[    1.719023] systemd-udevd[328]: renamed network interface eth0 to em1
[    1.720033] i915 0000:00:02.0: irq 57 for MSI/MSI-X
[    1.720039] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.720124] [drm] Driver supports precise vblank timestamp query.
[    1.720220] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.810543] fbcon: inteldrmfb (fb0) is primary device
[    1.816904] usb 3-10: new high-speed USB device number 3 using xhci_hcd
[    1.844828] Console: switching to colour frame buffer device 240x75
[    1.850018] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.850033] i915 0000:00:02.0: registered panic notifier
[    1.855623] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.855899] acpi device:70: registered as cooling_device13
[    1.855960] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input5
[    1.856056] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.981014] usb 3-10: New USB device found, idVendor=045b, idProduct=0209
[    1.981020] usb 3-10: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.981620] hub 3-10:1.0: USB hub found
[    1.981645] hub 3-10:1.0: 4 ports detected
[    2.084037] usb 4-5: new SuperSpeed USB device number 2 using xhci_hcd
[    2.096581] usb 4-5: New USB device found, idVendor=045b, idProduct=0210
[    2.096590] usb 4-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.097344] hub 4-5:1.0: USB hub found
[    2.097605] hub 4-5:1.0: 4 ports detected
[    2.202060] usb 4-6: new SuperSpeed USB device number 3 using xhci_hcd
[    2.214451] usb 4-6: New USB device found, idVendor=045b, idProduct=0210
[    2.214460] usb 4-6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.215307] hub 4-6:1.0: USB hub found
[    2.215584] hub 4-6:1.0: 4 ports detected
[    2.248104] PM: Starting manual resume from disk
[    2.248115] PM: Hibernation image partition 253:0 present
[    2.248118] PM: Looking for hibernation image.
[    2.248373] PM: Image not found (code -22)
[    2.248380] PM: Hibernation image not present or could not be loaded.
[    2.268290] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[    2.290561] usb 3-10.1: new low-speed USB device number 4 using xhci_hcd
[    2.381930] usb 3-10.1: New USB device found, idVendor=046d, idProduct=c52a
[    2.381939] usb 3-10.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.381943] usb 3-10.1: Product: 2.4GHz Cordless Desktop
[    2.381947] usb 3-10.1: Manufacturer: Logitech
[    2.382173] usb 3-10.1: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    2.382179] usb 3-10.1: ep 0x82 - rounding interval to 64 microframes, ep desc says 80 microframes
[    2.387662] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.1/3-10.1:1.0/0003:046D:C52A.0001/input/input6
[    2.387873] hid-generic 0003:046D:C52A.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:14.0-10.1/input0
[    2.396996] input: Logitech 2.4GHz Cordless Desktop as /devices/pci0000:00/0000:00:14.0/usb3/3-10/3-10.1/3-10.1:1.1/0003:046D:C52A.0002/input/input7
[    2.397630] hid-generic 0003:046D:C52A.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech 2.4GHz Cordless Desktop] on usb-0000:00:14.0-10.1/input1
[    2.470404] usb 3-10.2: new high-speed USB device number 5 using xhci_hcd
[    2.555420] usb 3-10.2: New USB device found, idVendor=0409, idProduct=005a
[    2.555429] usb 3-10.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.556118] hub 3-10.2:1.0: USB hub found
[    2.556149] hub 3-10.2:1.0: 4 ports detected
[    2.590190] systemd-journald[176]: Received SIGTERM
[    2.632424] Switched to clocksource tsc
[    2.635711] audit: type=1404 audit(1401113699.405:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[    2.675311] SELinux: 2048 avtab hash slots, 100018 rules.
[    2.709375] SELinux: 2048 avtab hash slots, 100018 rules.
[    2.750533] SELinux:  8 users, 86 roles, 4805 types, 281 bools, 1 sens, 1024 cats
[    2.750536] SELinux:  83 classes, 100018 rules
[    2.756235] SELinux:  Completing initialization.
[    2.756237] SELinux:  Setting up existing superblocks.
[    2.756245] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    2.756255] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    2.756262] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    2.756295] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.756377] SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SIDs
[    2.757713] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    2.758877] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    2.758880] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    2.758885] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    2.758888] SELinux: initialized (dev aio, type aio), not configured for labeling
[    2.758892] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    2.758913] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    2.758923] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    2.758933] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    2.758948] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    2.759568] SELinux: initialized (dev securityfs, type securityfs), uses genfs_contexts
[    2.759571] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.759583] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.759734] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    2.759785] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.759790] SELinux: initialized (dev pstore, type pstore), uses genfs_contexts
[    2.759792] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.759795] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.759798] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.759806] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.759810] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.759812] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.759815] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.759823] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.759825] SELinux: initialized (dev cgroup, type cgroup), uses genfs_contexts
[    2.759829] SELinux: initialized (dev configfs, type configfs), uses genfs_contexts
[    2.759832] SELinux: initialized (dev drm, type drm), not configured for labeling
[    2.759839] SELinux: initialized (dev dm-1, type ext4), uses xattr
[    2.777332] audit: type=1403 audit(1401113699.547:3): policy loaded auid=4294967295 ses=4294967295
[    2.778143] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    2.790011] systemd[1]: Successfully loaded SELinux policy in 155.893ms.
[    2.859594] systemd[1]: Relabelled /dev and /run in 41.314ms.
[    3.056016] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.056858] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition SIDs
[    3.088768] systemd-udevd[577]: starting version 208
[    3.091341] EXT4-fs (dm-1): re-mounted. Opts: (null)
[    3.145139] i801_smbus 0000:00:1f.3: enabling device (0001 -> 0003)
[    3.145202] ACPI Warning: SystemIO range 0x000000000000f040-0x000000000000f05f conflicts with OpRegion 0x000000000000f040-0x000000000000f04f (\_SB_.PCI0.SBUS.SMBI) (20140214/utaddress-258)
[    3.145205] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.153370] microcode: CPU0 sig=0x306c3, pf=0x2, revision=0x9
[    3.168106] wmi: Mapper loaded
[    3.169258] microcode: CPU0 sig=0x306c3, pf=0x2, revision=0x9
[    3.170691] microcode: CPU0 updated to revision 0x17, date = 2013-08-16
[    3.170699] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x9
[    3.170731] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x9
[    3.171458] microcode: CPU1 updated to revision 0x17, date = 2013-08-16
[    3.171463] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x9
[    3.171478] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x9
[    3.172209] microcode: CPU2 updated to revision 0x17, date = 2013-08-16
[    3.172215] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x9
[    3.172234] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x9
[    3.172967] microcode: CPU3 updated to revision 0x17, date = 2013-08-16
[    3.172971] microcode: CPU4 sig=0x306c3, pf=0x2, revision=0x9
[    3.172989] microcode: CPU4 sig=0x306c3, pf=0x2, revision=0x9
[    3.173718] microcode: CPU4 updated to revision 0x17, date = 2013-08-16
[    3.173723] microcode: CPU5 sig=0x306c3, pf=0x2, revision=0x9
[    3.173743] microcode: CPU5 sig=0x306c3, pf=0x2, revision=0x9
[    3.174471] microcode: CPU5 updated to revision 0x17, date = 2013-08-16
[    3.174474] microcode: CPU6 sig=0x306c3, pf=0x2, revision=0x9
[    3.174488] microcode: CPU6 sig=0x306c3, pf=0x2, revision=0x9
[    3.175186] microcode: CPU6 updated to revision 0x17, date = 2013-08-16
[    3.175199] microcode: CPU7 sig=0x306c3, pf=0x2, revision=0x9
[    3.175219] microcode: CPU7 sig=0x306c3, pf=0x2, revision=0x9
[    3.175953] microcode: CPU7 updated to revision 0x17, date = 2013-08-16
[    3.176071] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    3.177100] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.193427] mei_me 0000:00:16.0: irq 58 for MSI/MSI-X
[    3.203625] alg: No test for crc32 (crc32-pclmul)
[    3.272801] snd_hda_intel 0000:00:03.0: irq 59 for MSI/MSI-X
[    3.272909] snd_hda_intel 0000:00:1b.0: irq 60 for MSI/MSI-X
[    3.305434] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input8
[    3.305492] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input9
[    3.305529] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input10
[    3.315340] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.315472] SELinux: initialized (dev sda1, type ext4), uses xattr
[    3.346341] iTCO_vendor_support: vendor-support=0
[    3.348392] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    3.348419] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by hardware/BIOS
[    3.367769] sound hdaudioC1D2: autoconfig: line_outs=3 (0x14/0x15/0x16/0x0/0x0) type:line
[    3.367771] sound hdaudioC1D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    3.367772] sound hdaudioC1D2:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    3.367773] sound hdaudioC1D2:    mono: mono_out=0x0
[    3.367774] sound hdaudioC1D2:    dig-out=0x11/0x1e
[    3.367775] sound hdaudioC1D2:    inputs:
[    3.367776] sound hdaudioC1D2:      Front Mic=0x19
[    3.367777] sound hdaudioC1D2:      Rear Mic=0x18
[    3.367778] sound hdaudioC1D2:      Line=0x1a
[    3.367778] sound hdaudioC1D2:    dig-in=0x1f
[    3.370501] Adding 8200188k swap on /dev/mapper/fedora-swap.  Priority:-1 extents:1 across:8200188k SSFS
[    3.384793] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input11
[    3.384847] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input12
[    3.384887] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.0/sound/card1/input13
[    3.384928] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0000:00:1b.0/sound/card1/input14
[    3.384971] input: HDA Intel PCH Line Out Surround as /devices/pci0000:00/0000:00:1b.0/sound/card1/input15
[    3.385010] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/0000:00:1b.0/sound/card1/input16
[    3.385048] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card1/input17
[    4.486035] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[    4.486053] SELinux: initialized (dev dm-2, type ext4), uses xattr
[    4.507560] systemd-journald[568]: Received request to flush runtime journal from PID 1
[    4.508434] audit: type=1305 audit(1401113701.279:4): audit_pid=837 old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=1
[    4.779708] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    4.808426] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    4.849510] Ebtables v2.0 registered
[    4.898500] Bridge firewalling registered
[    5.038404] cfg80211: Calling CRDA to update world regulatory domain
[    5.041532] cfg80211: World regulatory domain updated:
[    5.041535] cfg80211:  DFS Master region: unset
[    5.041536] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    5.041538] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    5.041539] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    5.041540] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    5.041542] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    5.041543] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    5.041544] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    5.303858] IPv6: ADDRCONF(NETDEV_UP): p4p1: link is not ready
[    5.410538] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[    5.510834] e1000e 0000:00:19.0: irq 51 for MSI/MSI-X
[    5.510965] IPv6: ADDRCONF(NETDEV_UP): em1: link is not ready
[    5.605018] Bluetooth: Core ver 2.19
[    5.605084] NET: Registered protocol family 31
[    5.605085] Bluetooth: HCI device and connection manager initialized
[    5.605091] Bluetooth: HCI socket layer initialized
[    5.605092] Bluetooth: L2CAP socket layer initialized
[    5.605099] Bluetooth: SCO socket layer initialized
[    5.612169] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    5.612173] Bluetooth: BNEP filters: protocol multicast
[    5.612181] Bluetooth: BNEP socket layer initialized
[   12.238334] fuse init (API version 7.23)
[   12.242340] SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
[   12.265682] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   13.052018] e1000e: em1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[   13.052063] IPv6: ADDRCONF(NETDEV_CHANGE): em1: link becomes ready
[   35.271729] usb 3-10.3: new high-speed USB device number 6 using xhci_hcd
[   35.363803] usb 3-10.3: New USB device found, idVendor=8564, idProduct=1000
[   35.363813] usb 3-10.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   35.363817] usb 3-10.3: Product: Mass Storage Device
[   35.363821] usb 3-10.3: Manufacturer: JetFlash
[   35.363824] usb 3-10.3: SerialNumber: 9EAOZJ51
[   35.437056] usb-storage 3-10.3:1.0: USB Mass Storage device detected
[   35.437225] scsi14 : usb-storage 3-10.3:1.0
[   35.437422] usbcore: registered new interface driver usb-storage
[   36.445863] scsi 14:0:0:0: Direct-Access     JetFlash Transcend 4GB    8.07 PQ: 0 ANSI: 4
[   36.446564] sd 14:0:0:0: Attached scsi generic sg4 type 0
[   36.447014] sd 14:0:0:0: [sdc] 7864320 512-byte logical blocks: (4.02 GB/3.75 GiB)
[   36.447810] sd 14:0:0:0: [sdc] Write Protect is off
[   36.447821] sd 14:0:0:0: [sdc] Mode Sense: 23 00 00 00
[   36.448538] sd 14:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   36.452683]  sdc: sdc1
[   36.455623] sd 14:0:0:0: [sdc] Attached SCSI removable disk
[  103.388758] usb 3-10.3: USB disconnect, device number 6
[  124.794841] usb 3-10.3: new high-speed USB device number 7 using xhci_hcd
[  124.886519] usb 3-10.3: New USB device found, idVendor=8564, idProduct=1000
[  124.886528] usb 3-10.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  124.886533] usb 3-10.3: Product: Mass Storage Device
[  124.886537] usb 3-10.3: Manufacturer: JetFlash
[  124.886540] usb 3-10.3: SerialNumber: 9EAOZJ51
[  124.887596] usb-storage 3-10.3:1.0: USB Mass Storage device detected
[  124.887864] scsi15 : usb-storage 3-10.3:1.0
[  125.890646] scsi 15:0:0:0: Direct-Access     JetFlash Transcend 4GB    8.07 PQ: 0 ANSI: 4
[  125.891684] sd 15:0:0:0: Attached scsi generic sg4 type 0
[  125.892048] sd 15:0:0:0: [sdc] 7864320 512-byte logical blocks: (4.02 GB/3.75 GiB)
[  125.892783] sd 15:0:0:0: [sdc] Write Protect is off
[  125.892796] sd 15:0:0:0: [sdc] Mode Sense: 23 00 00 00
[  125.893530] sd 15:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[  125.899573]  sdc: sdc1
[  125.902341] sd 15:0:0:0: [sdc] Attached SCSI removable disk
[  133.826957] usb 3-10.3: USB disconnect, device number 7
[  159.326769] BUG: soft lockup - CPU#6 stuck for 22s! [systemd-udevd:1824]
[  159.326772] Modules linked in: usb_storage fuse ip6t_rpfilter bnep bluetooth ip6t_REJECT cfg80211 xt_conntrack rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw x86_pkg_temp_thermal coretemp snd_hda_codec_realtek snd_hda_codec_generic iTCO_wdt mxm_wmi iTCO_vendor_support kvm_intel kvm snd_hda_codec_hdmi snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm crct10dif_pclmul crc32_pclmul mei_me snd_timer snd mei crc32c_intel ghash_clmulni_intel shpchp wmi microcode joydev serio_raw i2c_i801 soundcore
[  159.326802]  lpc_ich mfd_core i915 drm_kms_helper drm e1000e igb dca ptp i2c_algo_bit i2c_core pps_core video
[  159.326809] CPU: 6 PID: 1824 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7 #55
[  159.326810] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
[  159.326812] task: ffff880472854a80 ti: ffff8804747ec000 task.ti: ffff8804747ec000
[  159.326813] RIP: 0010:[<ffffffff816a50f5>]  [<ffffffff816a50f5>] _raw_spin_trylock+0x25/0x40
[  159.326817] RSP: 0018:ffff8804747edc70  EFLAGS: 00000246
[  159.326819] RAX: 0000000000002727 RBX: ffffffff81246036 RCX: 0000000000002827
[  159.326820] RDX: 0000000000002727 RSI: 0000000000000000 RDI: ffff880451b802c8
[  159.326821] RBP: ffff8804747edc70 R08: ffff88047782f2c0 R09: 0000000180240001
[  159.326822] R10: ffffffff81246036 R11: ffffea0011ca6b00 R12: ffff88045cf7fad8
[  159.326823] R13: ffff8804747edc80 R14: ffff88047e84cf00 R15: ffff8804729ac9a0
[  159.326824] FS:  00007f54d2461880(0000) GS:ffff88048f380000(0000) knlGS:0000000000000000
[  159.326825] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  159.326826] CR2: 00007f54d2471000 CR3: 0000000471b8c000 CR4: 00000000001407e0
[  159.326828] Stack:
[  159.326828]  ffff8804747edca0 ffffffff811e74e6 ffff88047782f2c0 ffff88047782fa80
[  159.326830]  ffff8804747edce8 ffff88047782f240 ffff8804747edcd0 ffffffff811e793a
[  159.326832]  ffff8804747edce8 ffff88045cfd0cc0 0000000000000025 ffff8804747ede60
[  159.326834] Call Trace:
[  159.326838]  [<ffffffff811e74e6>] dentry_kill+0x36/0x280
[  159.326840]  [<ffffffff811e793a>] shrink_dentry_list+0x8a/0x110
[  159.326842]  [<ffffffff811e81c4>] check_submounts_and_drop+0x74/0xa0
[  159.326845]  [<ffffffff81245c5d>] kernfs_dop_revalidate+0x5d/0xd0
[  159.326847]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
[  159.326849]  [<ffffffff811dd2b5>] path_lookupat+0x155/0x780
[  159.326851]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
[  159.326853]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
[  159.326856]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  159.326858]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  159.326860]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
[  159.326862]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
[  159.326865]  [<ffffffff811d65ff>] ? SYSC_newstat+0x1f/0x40
[  159.326867]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
[  159.326870]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  159.326872]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  159.326873] Code: a2 42 9e ff 5d c3 0f 1f 44 00 00 55 48 89 e5 0f b7 17 38 d6 74 08 31 c0 5d c3 0f 1f 40 00 8d 8a 00 01 00 00 89 d0 f0 66 0f b1 0f <66> 39 d0 75 e6 b8 01 00 00 00 5d c3 66 66 66 66 66 66 2e 0f 1f 
[  169.572729] SysRq : Show State
[  169.572732]   task                        PC stack   pid father
[  169.572734] systemd         S ffff88048f3d4640     0     1      0 0x00000000
[  169.572737]  ffff880478d59dd8 0000000000000082 ffff880478d50000 ffff880478d59fd8
[  169.572739]  0000000000014640 0000000000014640 ffff880478e19bf0 0000000000000000
[  169.572741]  0000000000000000 ffff880472ec6ae0 ffff880478d50000 0000000000000000
[  169.572743] Call Trace:
[  169.572749]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.572752]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.572755]  [<ffffffff81216769>] ? ep_scan_ready_list.isra.9+0x199/0x1c0
[  169.572757]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.572759]  [<ffffffff812169ce>] ep_poll+0x21e/0x330
[  169.572762]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.572764]  [<ffffffff81217dc5>] SyS_epoll_wait+0xb5/0xe0
[  169.572767]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.572768] kthreadd        S ffff88048f354640     0     2      0 0x00000000
[  169.572770]  ffff880478d5beb0 0000000000000046 ffff880478d50950 ffff880478d5bfd8
[  169.572772]  0000000000014640 0000000000014640 ffff880478e18950 ffff8804775a2340
[  169.572773]  ffff880478d50950 0000000000000000 ffff880478d50950 ffffffff81c496c0
[  169.572775] Call Trace:
[  169.572777]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.572780]  [<ffffffff810a5f1f>] kthreadd+0x23f/0x250
[  169.572781]  [<ffffffff810a5ce0>] ? kthread_create_on_cpu+0x60/0x60
[  169.572783]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.572785]  [<ffffffff810a5ce0>] ? kthread_create_on_cpu+0x60/0x60
[  169.572786] ksoftirqd/0     S ffff88048f214640     0     3      2 0x00000000
[  169.572787]  ffff880478dd9e68 0000000000000046 ffff880478d512a0 ffff880478dd9fd8
[  169.572789]  0000000000014640 0000000000014640 ffff8804728537e0 ffff880478d512a0
[  169.572791]  ffff88047e8014b0 ffffffff81c3d260 ffff880478d512a0 ffff880478d512a0
[  169.572793] Call Trace:
[  169.572795]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.572797]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.572799]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.572801]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.572803]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572804]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.572806]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572807] kworker/0:0     S ffff88048f214640     0     4      2 0x00000000
[  169.572811]  ffff880478ddbe58 0000000000000046 ffff880478d51bf0 ffff880478ddbfd8
[  169.572813]  0000000000014640 0000000000014640 ffff880478d50000 ffff88048f213ec0
[  169.572815]  ffff88048f213ed8 ffff880478d15430 ffff880478d51bf0 ffff880478d15400
[  169.572817] Call Trace:
[  169.572819]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.572822]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.572823]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.572825]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.572826]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572828]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.572830]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572831] kworker/0:0H    S ffff88048f214640     0     5      2 0x00000000
[  169.572834]  ffff880478ddde58 0000000000000046 ffff880478d52540 ffff880478dddfd8
[  169.572836]  0000000000014640 0000000000014640 ffff880472cdd3d0 ffff88048f214280
[  169.572838]  ffff88048f214298 ffff880478d15530 ffff880478d52540 ffff880478d15500
[  169.572840] Call Trace:
[  169.572842]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.572843]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.572845]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.572846]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.572848]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572850]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.572851]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572852] kworker/u16:0   S ffff88048f2d4640     0     6      2 0x00000000
[  169.572856]  ffff880478ddfe58 0000000000000046 ffff880478d52e90 ffff880478ddffd8
[  169.572857]  0000000000014640 0000000000014640 ffff880478d56fc0 ffff88047e821400
[  169.572859]  ffff88047e821418 ffff880478d15630 ffff880478d52e90 ffff880478d15600
[  169.572861] Call Trace:
[  169.572863]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.572865]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.572867]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.572868]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.572870]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572871]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.572873]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572874] rcu_sched       S ffff88048f254640     0     7      2 0x00000000
[  169.572875]  ffff880478de9d80 0000000000000046 ffff880478d537e0 ffff880478de9fd8
[  169.572877]  0000000000014640 0000000000014640 ffff880472ee6670 ffff880478e38000
[  169.572879]  ffff880478de9db0 00000000fffe059a ffff880478e38000 000000000000e498
[  169.572881] Call Trace:
[  169.572883]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.572885]  [<ffffffff816a15d1>] schedule_timeout+0x151/0x270
[  169.572887]  [<ffffffff8108f460>] ? internal_add_timer+0x70/0x70
[  169.572889]  [<ffffffff810c7d27>] ? prepare_to_wait_event+0x87/0xf0
[  169.572892]  [<ffffffff810e31bf>] rcu_gp_kthread+0x28f/0x630
[  169.572894]  [<ffffffff810c7eb0>] ? abort_exclusive_wait+0xb0/0xb0
[  169.572896]  [<ffffffff810e2f30>] ? rcu_cpu_notify+0x570/0x570
[  169.572898]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.572899]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572901]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.572903]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572904] rcu_bh          S ffff88048f214640     0     8      2 0x00000000
[  169.572905]  ffff880478debe20 0000000000000046 ffff880478d54130 ffff880478debfd8
[  169.572907]  0000000000014640 0000000000014640 ffff880478d54a80 ffffffff81c4f480
[  169.572909]  ffffffff81c4f5a0 ffffffff810e2f30 0000000000000000 0000000000000000
[  169.572911] Call Trace:
[  169.572913]  [<ffffffff810e2f30>] ? rcu_cpu_notify+0x570/0x570
[  169.572915]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.572917]  [<ffffffff810e2faa>] rcu_gp_kthread+0x7a/0x630
[  169.572918]  [<ffffffff816a1d2a>] ? __schedule+0x2aa/0x710
[  169.572921]  [<ffffffff810c7eb0>] ? abort_exclusive_wait+0xb0/0xb0
[  169.572923]  [<ffffffff810e2f30>] ? rcu_cpu_notify+0x570/0x570
[  169.572924]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.572926]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572927]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.572929]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572930] migration/0     S ffff88048f214640     0     9      2 0x00000000
[  169.572931]  ffff880478dede68 0000000000000046 ffff880478d54a80 ffff880478dedfd8
[  169.572933]  0000000000014640 0000000000014640 ffffffff81c16460 ffff880478d54a80
[  169.572935]  ffff88047e8014c0 ffffffff81c557e0 ffff880478d54a80 ffff880478d54a80
[  169.572937] Call Trace:
[  169.572939]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.572941]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.572943]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.572944]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.572946]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572947]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.572949]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572950] watchdog/0      S ffff88048f214640     0    10      2 0x00000000
[  169.572952]  ffff880478e0fe68 0000000000000046 ffff880478d553d0 ffff880478e0ffd8
[  169.572953]  0000000000014640 0000000000014640 ffff8804728537e0 ffff880478d553d0
[  169.572955]  ffff88047e801990 ffffffff81c56120 ffff880478d553d0 ffff880478d553d0
[  169.572957] Call Trace:
[  169.572959]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.572961]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.572963]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.572964]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.572966]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572968]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.572969]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572970] watchdog/1      S ffff88048f254640     0    11      2 0x00000000
[  169.572972]  ffff880478e27e68 0000000000000046 ffff880478e1a540 ffff880478e27fd8
[  169.572974]  0000000000014640 0000000000014640 ffff880472ee6670 ffff880478e1a540
[  169.572976]  ffff88047e8019a0 ffffffff81c56120 ffff880478e1a540 ffff880478e1a540
[  169.572977] Call Trace:
[  169.572979]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.572981]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.572983]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.572985]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.572986]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572988]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.572989]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.572991] migration/1     S ffff88048f254640     0    12      2 0x00000000
[  169.572992]  ffff880478e31e68 0000000000000046 ffff880478e1ae90 ffff880478e31fd8
[  169.572994]  0000000000014640 0000000000014640 ffff880478d55d20 ffff880478e1ae90
[  169.572996]  ffff88047e8019b0 ffffffff81c557e0 ffff880478e1ae90 ffff880478e1ae90
[  169.572998] Call Trace:
[  169.573000]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573002]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573003]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573005]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573007]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573008]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573010]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573011] ksoftirqd/1     S ffff88048f254640     0    13      2 0x00000000
[  169.573012]  ffff880478e33e68 0000000000000046 ffff880478e1b7e0 ffff880478e33fd8
[  169.573014]  0000000000014640 0000000000014640 ffff8804728537e0 ffff880478e1b7e0
[  169.573016]  ffff88047e8019c0 ffffffff81c3d260 ffff880478e1b7e0 ffff880478e1b7e0
[  169.573018] Call Trace:
[  169.573020]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573022]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573024]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573025]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573027]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573028]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573030]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573031] kworker/1:0     S ffff88048f254640     0    14      2 0x00000000
[  169.573034]  ffff880478e35e58 0000000000000046 ffff880478e1c130 ffff880478e35fd8
[  169.573036]  0000000000014640 0000000000014640 ffff880472cdb7e0 ffff88048f253ec0
[  169.573038]  ffff88048f253ed8 ffff880478d15ab0 ffff880478e1c130 ffff880478d15a80
[  169.573040] Call Trace:
[  169.573042]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573044]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.573046]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.573047]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573049]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573050]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573052]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573053] kworker/1:0H    S ffff88048f254640     0    15      2 0x00000000
[  169.573057]  ffff880478e37e58 0000000000000046 ffff880478e1ca80 ffff880478e37fd8
[  169.573058]  0000000000014640 0000000000014640 ffff880471990950 ffff88048f254280
[  169.573060]  ffff88048f254298 ffff880478d15bb0 ffff880478e1ca80 ffff880478d15b80
[  169.573062] Call Trace:
[  169.573064]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573066]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.573068]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.573069]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573071]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573072]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573074]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573075] watchdog/2      S ffff88048f294640     0    16      2 0x00000000
[  169.573076]  ffff880478ef3e68 0000000000000046 ffff880478e1d3d0 ffff880478ef3fd8
[  169.573078]  0000000000014640 0000000000014640 ffff880472852540 ffff880478e1d3d0
[  169.573080]  ffff88047e8019d0 ffffffff81c56120 ffff880478e1d3d0 ffff880478e1d3d0
[  169.573082] Call Trace:
[  169.573084]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573086]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573088]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573089]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573091]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573092]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573094]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573095] migration/2     S ffff88048f294640     0    17      2 0x00000000
[  169.573096]  ffff880478ef5e68 0000000000000046 ffff880478e1dd20 ffff880478ef5fd8
[  169.573098]  0000000000014640 0000000000014640 ffff880472852540 ffff880478e1dd20
[  169.573100]  ffff88047e8019e0 ffffffff81c557e0 ffff880478e1dd20 ffff880478e1dd20
[  169.573102] Call Trace:
[  169.573104]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573106]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573108]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573109]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573111]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573112]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573114]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573114] ksoftirqd/2     S ffff88048f294640     0    18      2 0x00000000
[  169.573116]  ffff880478ef7e68 0000000000000046 ffff880478e1e670 ffff880478ef7fd8
[  169.573118]  0000000000014640 0000000000014640 ffff880478d537e0 ffff880478e1e670
[  169.573120]  ffff88047e8019f0 ffffffff81c3d260 ffff880478e1e670 ffff880478e1e670
[  169.573121] Call Trace:
[  169.573123]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573125]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573127]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573129]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573130]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573132]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573133]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573134] kworker/2:0     S ffff88048f294640     0    19      2 0x00000000
[  169.573138]  ffff880478ef9e58 0000000000000046 ffff880478e1efc0 ffff880478ef9fd8
[  169.573140]  0000000000014640 0000000000014640 ffff880478d56670 ffff88048f293ec0
[  169.573141]  ffff88048f293ed8 ffff880478dfc230 ffff880478e1efc0 ffff880478dfc200
[  169.573143] Call Trace:
[  169.573145]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573147]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.573149]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.573150]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573152]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573153]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573155]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573156] kworker/2:0H    S ffff88048f294640     0    20      2 0x00000000
[  169.573159]  ffff880478efbe58 0000000000000046 ffff880478f00000 ffff880478efbfd8
[  169.573161]  0000000000014640 0000000000014640 ffff880478d56670 ffff88048f294280
[  169.573163]  ffff88048f294298 ffff880478dfc330 ffff880478f00000 ffff880478dfc300
[  169.573165] Call Trace:
[  169.573167]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573168]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.573170]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.573172]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573173]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573175]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573176]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573177] watchdog/3      S ffff88048f2d4640     0    21      2 0x00000000
[  169.573179]  ffff880478f39e68 0000000000000046 ffff880478f00950 ffff880478f39fd8
[  169.573181]  0000000000014640 0000000000014640 ffff880472856670 ffff880478f00950
[  169.573183]  ffff88047e801a00 ffffffff81c56120 ffff880478f00950 ffff880478f00950
[  169.573184] Call Trace:
[  169.573186]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573188]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573190]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573192]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573193]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573195]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573196]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573197] migration/3     S ffff88048f2d4640     0    22      2 0x00000000
[  169.573199]  ffff880478f3be68 0000000000000046 ffff880478f012a0 ffff880478f3bfd8
[  169.573201]  0000000000014640 0000000000014640 ffff880478d56fc0 ffff880478f012a0
[  169.573202]  ffff88047e801a10 ffffffff81c557e0 ffff880478f012a0 ffff880478f012a0
[  169.573204] Call Trace:
[  169.573206]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573208]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573210]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573212]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573213]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573215]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573216]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573217] ksoftirqd/3     S ffff88048f2d4640     0    23      2 0x00000000
[  169.573219]  ffff880478f3de68 0000000000000046 ffff880478f01bf0 ffff880478f3dfd8
[  169.573221]  0000000000014640 0000000000014640 ffff880478d56fc0 ffff880478f01bf0
[  169.573223]  ffff88047e801a20 ffffffff81c3d260 ffff880478f01bf0 ffff880478f01bf0
[  169.573224] Call Trace:
[  169.573226]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573228]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573230]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573232]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573233]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573235]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573236]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573237] kworker/3:0     S ffff88048f2d4640     0    24      2 0x00000000
[  169.573241]  ffff880478f3fe58 0000000000000046 ffff880478f02540 ffff880478f3ffd8
[  169.573243]  0000000000014640 0000000000014640 ffff880472856670 ffff88048f2d3ec0
[  169.573244]  ffff88048f2d3ed8 ffff880478dfc5b0 ffff880478f02540 ffff880478dfc580
[  169.573246] Call Trace:
[  169.573248]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573250]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.573252]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.573253]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573255]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573256]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573258]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573259] kworker/3:0H    S ffff88048f2d4640     0    25      2 0x00000000
[  169.573262]  ffff880478f49e58 0000000000000046 ffff880478f02e90 ffff880478f49fd8
[  169.573264]  0000000000014640 0000000000014640 ffff8800648d6fc0 ffff88048f2d4280
[  169.573266]  ffff88048f2d4298 ffff880478dfc6b0 ffff880478f02e90 ffff880478dfc680
[  169.573268] Call Trace:
[  169.573270]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573271]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.573273]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.573275]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573276]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573278]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573279]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573280] watchdog/4      S ffff88048f314640     0    26      2 0x00000000
[  169.573282]  ffff880478f75e68 0000000000000046 ffff880478f037e0 ffff880478f75fd8
[  169.573284]  0000000000014640 0000000000014640 ffff880472ee6fc0 ffff880478f037e0
[  169.573286]  ffff88047e801a30 ffffffff81c56120 ffff880478f037e0 ffff880478f037e0
[  169.573287] Call Trace:
[  169.573289]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573291]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573293]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573295]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573296]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573298]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573299]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573301] migration/4     S ffff88048f314640     0    27      2 0x00000000
[  169.573302]  ffff880478fa7e68 0000000000000046 ffff880478f04130 ffff880478fa7fd8
[  169.573304]  0000000000014640 0000000000014640 ffff880472dad3d0 ffff880478f04130
[  169.573306]  ffff88047e801a40 ffffffff81c557e0 ffff880478f04130 ffff880478f04130
[  169.573308] Call Trace:
[  169.573310]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573312]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573314]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573315]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573317]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573318]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573320]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573321] ksoftirqd/4     S ffff88048f314640     0    28      2 0x00000000
[  169.573322]  ffff880478fa9e68 0000000000000046 ffff880478f04a80 ffff880478fa9fd8
[  169.573324]  0000000000014640 0000000000014640 ffff880478d537e0 ffff880478f04a80
[  169.573326]  ffff88047e801a50 ffffffff81c3d260 ffff880478f04a80 ffff880478f04a80
[  169.573328] Call Trace:
[  169.573330]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573332]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573333]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573335]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573337]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573338]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573340]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573341] kworker/4:0     S ffff88048f314640     0    29      2 0x00000000
[  169.573344]  ffff880478fabe58 0000000000000046 ffff880478f053d0 ffff880478fabfd8
[  169.573346]  0000000000014640 0000000000014640 ffff880472ee6fc0 ffff88048f313ec0
[  169.573348]  ffff88048f313ed8 ffff880478dfc930 ffff880478f053d0 ffff880478dfc900
[  169.573350] Call Trace:
[  169.573352]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573353]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.573355]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.573357]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573358]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573360]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573361]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573362] kworker/4:0H    S ffff88048f314640     0    30      2 0x00000000
[  169.573366]  ffff880478fade58 0000000000000046 ffff880478f05d20 ffff880478fadfd8
[  169.573368]  0000000000014640 0000000000014640 ffff880471990000 ffff88048f314280
[  169.573369]  ffff88048f314298 ffff880478dfca30 ffff880478f05d20 ffff880478dfca00
[  169.573371] Call Trace:
[  169.573373]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573375]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.573377]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.573378]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573380]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573381]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573383]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573384] watchdog/5      S ffff88048f354640     0    31      2 0x00000000
[  169.573385]  ffff880478fe9e68 0000000000000046 ffff880478f06670 ffff880478fe9fd8
[  169.573387]  0000000000014640 0000000000014640 ffff880472ee5d20 ffff880478f06670
[  169.573389]  ffff88047e801a60 ffffffff81c56120 ffff880478f06670 ffff880478f06670
[  169.573391] Call Trace:
[  169.573393]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573395]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573397]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573398]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573400]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573401]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573403]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573404] migration/5     S ffff88048f354640     0    32      2 0x00000000
[  169.573405]  ffff880478febe68 0000000000000046 ffff880478f06fc0 ffff880478febfd8
[  169.573407]  0000000000014640 0000000000014640 ffff88047331b7e0 ffff880478f06fc0
[  169.573409]  ffff88047e801a70 ffffffff81c557e0 ffff880478f06fc0 ffff880478f06fc0
[  169.573411] Call Trace:
[  169.573413]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573415]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573417]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573418]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573419]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573421]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573423]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573424] ksoftirqd/5     S ffff88048f354640     0    33      2 0x00000000
[  169.573425]  ffff880478fede68 0000000000000046 ffff880478ff0000 ffff880478fedfd8
[  169.573427]  0000000000014640 0000000000014640 ffff8804728553d0 ffff880478ff0000
[  169.573429]  ffff88047e801a80 ffffffff81c3d260 ffff880478ff0000 ffff880478ff0000
[  169.573431] Call Trace:
[  169.573433]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573435]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573436]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573438]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573440]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573441]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573443]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573444] kworker/5:0     S ffff88048f354640     0    34      2 0x00000000
[  169.573447]  ffff880478fefe58 0000000000000046 ffff880478ff0950 ffff880478feffd8
[  169.573449]  0000000000014640 0000000000014640 ffff88047331b7e0 ffff88048f353ec0
[  169.573451]  ffff88048f353ed8 ffff880478dfccb0 ffff880478ff0950 ffff880478dfcc80
[  169.573453] Call Trace:
[  169.573455]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573456]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.573458]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.573460]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573461]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573463]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573464]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573465] kworker/5:0H    S ffff88048f354640     0    35      2 0x00000000
[  169.573469]  ffff880478801e58 0000000000000046 ffff880478ff12a0 ffff880478801fd8
[  169.573471]  0000000000014640 0000000000014640 ffff880478e18950 ffff88048f354280
[  169.573473]  ffff88048f354298 ffff880478dfcdb0 ffff880478ff12a0 ffff880478dfcd80
[  169.573474] Call Trace:
[  169.573476]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573478]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.573480]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.573481]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573483]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573484]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573486]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573487] watchdog/6      R  running task        0    36      2 0x00000000
[  169.573489]  ffff880478837e68 0000000000000046 ffff880478ff1bf0 ffff880478837fd8
[  169.573490]  0000000000014640 0000000000014640 ffff880478e192a0 ffff880478ff1bf0
[  169.573492]  ffff88047e801a90 ffffffff81c56120 ffff880478ff1bf0 ffff880478ff1bf0
[  169.573494] Call Trace:
[  169.573496]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573498]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573500]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573501]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573503]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573504]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573506]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573507] migration/6     R  running task        0    37      2 0x00000000
[  169.573509]  ffff880478839e68 0000000000000046 ffff880478ff2540 ffff880478839fd8
[  169.573510]  0000000000014640 0000000000014640 ffff8804728553d0 ffff880478ff2540
[  169.573512]  ffff88047e801aa0 ffffffff81c557e0 ffff880478ff2540 ffff880478ff2540
[  169.573514] Call Trace:
[  169.573516]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573518]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573520]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573521]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573523]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573524]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573526]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573527] ksoftirqd/6     S ffff88048f394640     0    38      2 0x00000000
[  169.573529]  ffff88047883be68 0000000000000046 ffff880478ff2e90 ffff88047883bfd8
[  169.573530]  0000000000014640 0000000000014640 ffff880478d537e0 ffff880478ff2e90
[  169.573532]  ffff88047e801ab0 ffffffff81c3d260 ffff880478ff2e90 ffff880478ff2e90
[  169.573534] Call Trace:
[  169.573536]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573538]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573540]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573542]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573543]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573544]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573546]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573547] kworker/6:0     S ffff88048f394640     0    39      2 0x00000000
[  169.573550]  ffff88047883de58 0000000000000046 ffff880478ff37e0 ffff88047883dfd8
[  169.573552]  0000000000014640 0000000000014640 ffff880478e192a0 ffff88048f393ec0
[  169.573554]  ffff88048f393ed8 ffff880478f6d030 ffff880478ff37e0 ffff880478f6d000
[  169.573556] Call Trace:
[  169.573558]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573560]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.573561]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.573563]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573564]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573566]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573567]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573569] kworker/6:0H    S ffff88048f394640     0    40      2 0x00000000
[  169.573572]  ffff88047883fe58 0000000000000046 ffff880478ff4130 ffff88047883ffd8
[  169.573574]  0000000000014640 0000000000014640 ffff8804784d5d20 ffff88048f394280
[  169.573576]  ffff88048f394298 ffff880478f6d130 ffff880478ff4130 ffff880478f6d100
[  169.573578] Call Trace:
[  169.573580]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573581]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.573583]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.573585]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573586]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573588]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573589]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573590] watchdog/7      S ffff88048f3d4640     0    41      2 0x00000000
[  169.573592]  ffff88047889fe68 0000000000000046 ffff880478ff4a80 ffff88047889ffd8
[  169.573593]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff880478ff4a80
[  169.573595]  ffff88047e801ac0 ffffffff81c56120 ffff880478ff4a80 ffff880478ff4a80
[  169.573597] Call Trace:
[  169.573599]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573601]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573603]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573604]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573606]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573607]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573609]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573610] migration/7     S ffff88048f3d4640     0    42      2 0x00000000
[  169.573612]  ffff8804788a1e68 0000000000000046 ffff880478ff53d0 ffff8804788a1fd8
[  169.573613]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff880478ff53d0
[  169.573615]  ffff88047e801ad0 ffffffff81c557e0 ffff880478ff53d0 ffff880478ff53d0
[  169.573617] Call Trace:
[  169.573619]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573621]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573623]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573624]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573626]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573627]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573629]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573630] ksoftirqd/7     S ffff88048f3d4640     0    43      2 0x00000000
[  169.573631]  ffff8804788a3e68 0000000000000046 ffff880478ff5d20 ffff8804788a3fd8
[  169.573633]  0000000000014640 0000000000014640 ffff880478d537e0 ffff880478ff5d20
[  169.573635]  ffff88047e801ae0 ffffffff81c3d260 ffff880478ff5d20 ffff880478ff5d20
[  169.573637] Call Trace:
[  169.573639]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573641]  [<ffffffff810ac443>] smpboot_thread_fn+0xd3/0x1b0
[  169.573643]  [<ffffffff810ac370>] ? SyS_setgroups+0x1a0/0x1a0
[  169.573644]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573646]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573647]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573649]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573650] kworker/7:0     S ffff88048f3d4640     0    44      2 0x00000000
[  169.573653]  ffff8804788a5e58 0000000000000046 ffff880478ff6670 ffff8804788a5fd8
[  169.573655]  0000000000014640 0000000000014640 ffff88047171ae90 ffff88048f3d3ec0
[  169.573657]  ffff88048f3d3ed8 ffff880478f6d3b0 ffff880478ff6670 ffff880478f6d380
[  169.573659] Call Trace:
[  169.573661]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573663]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.573665]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.573666]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573668]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573669]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573671]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573672] kworker/7:0H    S ffff88048f3d4640     0    45      2 0x00000000
[  169.573675]  ffff8804788a7e58 0000000000000046 ffff880478ff6fc0 ffff8804788a7fd8
[  169.573677]  0000000000014640 0000000000014640 ffff8804765cefc0 ffff88048f3d4280
[  169.573679]  ffff88048f3d4298 ffff880478f6d4b0 ffff880478ff6fc0 ffff880478f6d480
[  169.573681] Call Trace:
[  169.573683]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573684]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.573686]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.573688]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573689]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573691]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573692]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573693] khelper         S ffff88048f3d4640     0    46      2 0x00000000
[  169.573697]  ffff8804788dde28 0000000000000046 ffff8804788e0000 ffff8804788ddfd8
[  169.573699]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff880478f6d580
[  169.573701]  ffff8804788e0000 ffffffff8109ea60 ffff88047884e880 0000000000000000
[  169.573703] Call Trace:
[  169.573705]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573706]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573708]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.573710]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573711]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573713]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573714]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573716]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573717] kdevtmpfs       S ffff88048f2d4640     0    47      2 0x00000000
[  169.573719]  ffff8804788dfe80 0000000000000046 ffff8804788e0950 ffff8804788dffd8
[  169.573720]  0000000000014640 0000000000014640 ffff880478d56fc0 0000000000000000
[  169.573722]  0000000000000000 ffff8804788e0950 0000000000000000 0000000000000000
[  169.573724] Call Trace:
[  169.573726]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573729]  [<ffffffff81432c9b>] devtmpfsd+0x13b/0x140
[  169.573731]  [<ffffffff81432b60>] ? handle_create.isra.2+0x1f0/0x1f0
[  169.573732]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573734]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573735]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573737]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573738] netns           S ffff88048f3d4640     0    48      2 0x00000000
[  169.573741]  ffff880478999e28 0000000000000046 ffff8804788e12a0 ffff880478999fd8
[  169.573743]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff88047897d780
[  169.573745]  ffff8804788e12a0 ffffffff8109ea60 ffff88047884f280 0000000000000000
[  169.573747] Call Trace:
[  169.573749]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573750]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573752]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.573754]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573756]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573757]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573759]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573760]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573761] writeback       S ffff88048f3d4640     0    49      2 0x00000000
[  169.573765]  ffff880478a69e28 0000000000000046 ffff8804788e1bf0 ffff880478a69fd8
[  169.573767]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff8804789afb80
[  169.573768]  ffff8804788e1bf0 ffffffff8109ea60 ffff880478a64880 0000000000000000
[  169.573770] Call Trace:
[  169.573772]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573774]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573776]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.573778]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573779]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573781]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573782]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573784]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573785] ksmd            S ffff88048f3d4640     0    50      2 0x00000000
[  169.573786]  ffff880478a6be10 0000000000000046 ffff8804788e2540 ffff880478a6bfd8
[  169.573788]  0000000000014640 0000000000014640 ffff880478e19bf0 0000000000000000
[  169.573790]  0000000000000000 ffffffff811b1540 0000000000000000 0000000000000000
[  169.573792] Call Trace:
[  169.573795]  [<ffffffff811b1540>] ? try_to_merge_with_ksm_page+0x650/0x650
[  169.573797]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573798]  [<ffffffff811b1b45>] ksm_scan_thread+0x605/0xf30
[  169.573800]  [<ffffffff816a1d2a>] ? __schedule+0x2aa/0x710
[  169.573802]  [<ffffffff810c7eb0>] ? abort_exclusive_wait+0xb0/0xb0
[  169.573804]  [<ffffffff811b1540>] ? try_to_merge_with_ksm_page+0x650/0x650
[  169.573806]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573807]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573809]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573810]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573811] khugepaged      S ffff88048f254640     0    51      2 0x00000000
[  169.573813]  ffff880478a6dd00 0000000000000046 ffff8804788e2e90 ffff880478a6dfd8
[  169.573815]  0000000000014640 0000000000014640 ffff880478d55d20 ffff880478e38000
[  169.573817]  ffff880478a6dd30 00000000fffe0b58 ffff880478e38000 000000000000e498
[  169.573818] Call Trace:
[  169.573820]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573822]  [<ffffffff816a15d1>] schedule_timeout+0x151/0x270
[  169.573824]  [<ffffffff8108f460>] ? internal_add_timer+0x70/0x70
[  169.573826]  [<ffffffff810c7d27>] ? prepare_to_wait_event+0x87/0xf0
[  169.573828]  [<ffffffff811be980>] khugepaged+0x8e0/0x1330
[  169.573830]  [<ffffffff810c7eb0>] ? abort_exclusive_wait+0xb0/0xb0
[  169.573832]  [<ffffffff811be0a0>] ? maybe_pmd_mkwrite+0x30/0x30
[  169.573833]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573835]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573836]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573838]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573839] kintegrityd     S ffff88048f3d4640     0    52      2 0x00000000
[  169.573842]  ffff880478a6fe28 0000000000000046 ffff8804788e37e0 ffff880478a6ffd8
[  169.573844]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff8804789afc00
[  169.573846]  ffff8804788e37e0 ffffffff8109ea60 ffff880478a64a80 0000000000000000
[  169.573848] Call Trace:
[  169.573850]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573852]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573853]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.573855]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573857]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573858]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573860]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573862]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573863] bioset          S ffff88048f3d4640     0    53      2 0x00000000
[  169.573866]  ffff880478a71e28 0000000000000046 ffff8804788e4130 ffff880478a71fd8
[  169.573868]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff8804789afd00
[  169.573870]  ffff8804788e4130 ffffffff8109ea60 ffff880478a64c80 0000000000000000
[  169.573872] Call Trace:
[  169.573874]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573876]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573877]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.573879]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573880]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573882]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573884]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573885]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573886] crypto          S ffff88048f3d4640     0    54      2 0x00000000
[  169.573890]  ffff880478a73e28 0000000000000046 ffff8804788e4a80 ffff880478a73fd8
[  169.573891]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff8804789afd80
[  169.573893]  ffff8804788e4a80 ffffffff8109ea60 ffff880478a64e80 0000000000000000
[  169.573895] Call Trace:
[  169.573897]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573899]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573900]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.573902]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573904]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573905]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573907]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573908]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573909] kblockd         S ffff88048f3d4640     0    55      2 0x00000000
[  169.573913]  ffff880478a75e28 0000000000000046 ffff8804788e53d0 ffff880478a75fd8
[  169.573914]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff8804789afe00
[  169.573916]  ffff8804788e53d0 ffffffff8109ea60 ffff880478a65280 0000000000000000
[  169.573918] Call Trace:
[  169.573920]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573922]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573923]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.573925]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573927]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573928]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573930]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573931]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573932] ata_sff         S ffff88048f3d4640     0    56      2 0x00000000
[  169.573936]  ffff880478bb9e28 0000000000000046 ffff8804788e5d20 ffff880478bb9fd8
[  169.573938]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff880478b96000
[  169.573940]  ffff8804788e5d20 ffffffff8109ea60 ffff880478a67680 0000000000000000
[  169.573941] Call Trace:
[  169.573943]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573945]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573947]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.573949]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573950]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573952]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573953]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573955]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573956] khubd           S ffff88048f214640     0    57      2 0x00000000
[  169.573957]  ffff880478bbbda0 0000000000000046 ffff8804788e6670 ffff880478bbbfd8
[  169.573959]  0000000000014640 0000000000014640 ffffffff81c16460 0000000000000000
[  169.573961]  0000000000000000 0000000000000005 ffff880472df4000 ffffffff81cb6e70
[  169.573963] Call Trace:
[  169.573965]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573968]  [<ffffffff8149c7eb>] hub_thread+0x113b/0x16c0
[  169.573971]  [<ffffffff8101a769>] ? sched_clock+0x9/0x10
[  169.573973]  [<ffffffff810b7f35>] ? sched_clock_cpu+0x85/0xc0
[  169.573975]  [<ffffffff810c7eb0>] ? abort_exclusive_wait+0xb0/0xb0
[  169.573977]  [<ffffffff8149b6b0>] ? usb_reset_device+0x1c0/0x1c0
[  169.573979]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.573980]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573982]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.573983]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.573984] md              S ffff88048f3d4640     0    58      2 0x00000000
[  169.573988]  ffff880478bc1e28 0000000000000046 ffff8804788e6fc0 ffff880478bc1fd8
[  169.573990]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff880478b96380
[  169.573992]  ffff8804788e6fc0 ffffffff8109ea60 ffff880478bbd280 0000000000000000
[  169.573993] Call Trace:
[  169.573995]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.573997]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.573999]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574001]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574002]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574004]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574005]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574007]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574008] kworker/0:1     S ffff88048f214640     0    59      2 0x00000000
[  169.574011]  ffff8804784d9e58 0000000000000046 ffff8804784d0000 ffff8804784d9fd8
[  169.574013]  0000000000014640 0000000000014640 ffff880472cd8950 ffff88048f213ec0
[  169.574015]  ffff88048f213ed8 ffff8804784abdb0 ffff8804784d0000 ffff8804784abd80
[  169.574017] Call Trace:
[  169.574019]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574020]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.574022]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.574023]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574025]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574027]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574028]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574029] kworker/u16:1   S ffff88048f294640     0    66      2 0x00000000
[  169.574033]  ffff8800648a3e58 0000000000000046 ffff8804784d4130 ffff8800648a3fd8
[  169.574035]  0000000000014640 0000000000014640 ffff880478d56670 ffff88047e821400
[  169.574036]  ffff88047e821418 ffff88006486f030 ffff8804784d4130 ffff88006486f000
[  169.574038] Call Trace:
[  169.574040]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574042]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.574044]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.574045]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574047]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574048]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574050]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574051] kswapd0         S ffff88048f3d4640     0    82      2 0x00000000
[  169.574052]  ffff880473183dd0 0000000000000046 ffff8804787ab7e0 ffff880473183fd8
[  169.574054]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff88048f5faea8
[  169.574056]  0000000000000000 0000000000000000 ffff88048f5faec8 ffff88048f5e7000
[  169.574058] Call Trace:
[  169.574060]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574063]  [<ffffffff8117802a>] kswapd+0x7ba/0x830
[  169.574066]  [<ffffffff810c7eb0>] ? abort_exclusive_wait+0xb0/0xb0
[  169.574068]  [<ffffffff81177870>] ? mem_cgroup_shrink_node_zone+0x120/0x120
[  169.574069]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574071]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574072]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574074]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574075] fsnotify_mark   S ffff88048f254640     0    83      2 0x00000000
[  169.574076]  ffff8804731dbe40 0000000000000046 ffff8804787ac130 ffff8804731dbfd8
[  169.574078]  0000000000014640 0000000000014640 ffff880478d55d20 ffff8804731dbe68
[  169.574080]  ffff880472bbe0f0 ffff8804731dbe68 ffff8804731dbe68 ffff8804731dbe10
[  169.574082] Call Trace:
[  169.574084]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574086]  [<ffffffff8121179a>] fsnotify_mark_destroy+0x10a/0x150
[  169.574088]  [<ffffffff810c7eb0>] ? abort_exclusive_wait+0xb0/0xb0
[  169.574090]  [<ffffffff81211690>] ? fsnotify_put_mark+0x40/0x40
[  169.574091]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574093]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574094]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574096]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574097] kthrotld        S ffff88048f3d4640     0    93      2 0x00000000
[  169.574101]  ffff880473209e28 0000000000000046 ffff8804787a8950 ffff880473209fd8
[  169.574102]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff8804731e3100
[  169.574104]  ffff8804787a8950 ffffffff8109ea60 ffff88006484a480 0000000000000000
[  169.574106] Call Trace:
[  169.574108]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574110]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574111]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574113]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574115]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574116]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574118]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574119]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574120] acpi_thermal_pm S ffff88048f3d4640     0    94      2 0x00000000
[  169.574124]  ffff880473229e28 0000000000000046 ffff8804787a8000 ffff880473229fd8
[  169.574126]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff88047321a000
[  169.574128]  ffff8804787a8000 ffffffff8109ea60 ffff88006484a880 0000000000000000
[  169.574130] Call Trace:
[  169.574131]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574133]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574135]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574137]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574138]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574140]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574141]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574143]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574144] scsi_eh_0       S ffff88048f214640     0    95      2 0x00000000
[  169.574145]  ffff88047315fe30 0000000000000046 ffff8804787a92a0 ffff88047315ffd8
[  169.574147]  0000000000014640 0000000000014640 ffffffff81c16460 ffff880473195800
[  169.574149]  0000000000000246 ffff8804787a9768 0000000000000000 0000000000000000
[  169.574151] Call Trace:
[  169.574153]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574156]  [<ffffffff8144b079>] scsi_error_handler+0x89/0x7e0
[  169.574158]  [<ffffffff8144aff0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  169.574159]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574161]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574163]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574164]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574165] scsi_tmf_0      S ffff88048f3d4640     0    96      2 0x00000000
[  169.574169]  ffff8804787b9e28 0000000000000046 ffff8804787a9bf0 ffff8804787b9fd8
[  169.574171]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff88047321ac80
[  169.574172]  ffff8804787a9bf0 ffffffff8109ea60 ffff88006484b480 0000000000000000
[  169.574174] Call Trace:
[  169.574176]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574178]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574180]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574182]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574183]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574185]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574186]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574188]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574189] scsi_eh_1       S ffff88048f2d4640     0    97      2 0x00000000
[  169.574190]  ffff8804787a1e30 0000000000000046 ffff8804787aa540 ffff8804787a1fd8
[  169.574192]  0000000000014640 0000000000014640 ffff880478d56fc0 ffff880473196000
[  169.574194]  0000000000000246 ffff8804787aaa08 0000000000000000 0000000000000000
[  169.574196] Call Trace:
[  169.574198]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574200]  [<ffffffff8144b079>] scsi_error_handler+0x89/0x7e0
[  169.574202]  [<ffffffff8144aff0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  169.574203]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574205]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574206]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574208]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574209] scsi_tmf_1      S ffff88048f3d4640     0    98      2 0x00000000
[  169.574212]  ffff8804787a3e28 0000000000000046 ffff8804787aae90 ffff8804787a3fd8
[  169.574214]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff88047321ad80
[  169.574216]  ffff8804787aae90 ffffffff8109ea60 ffff88006484b680 0000000000000000
[  169.574218] Call Trace:
[  169.574219]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574221]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574223]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574225]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574226]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574228]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574229]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574231]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574232] scsi_eh_2       S ffff88048f294640     0    99      2 0x00000000
[  169.574234]  ffff88047328de30 0000000000000046 ffff8804787aefc0 ffff88047328dfd8
[  169.574235]  0000000000014640 0000000000014640 ffff880478d56670 ffff880473196800
[  169.574237]  0000000000000246 ffff8804787af488 0000000000000000 0000000000000000
[  169.574239] Call Trace:
[  169.574241]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574243]  [<ffffffff8144b079>] scsi_error_handler+0x89/0x7e0
[  169.574244]  [<ffffffff8144aff0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  169.574246]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574247]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574249]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574250]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574252] scsi_tmf_2      S ffff88048f3d4640     0   100      2 0x00000000
[  169.574255]  ffff88047328fe28 0000000000000046 ffff8804787ae670 ffff88047328ffd8
[  169.574257]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff88047321ae80
[  169.574259]  ffff8804787ae670 ffffffff8109ea60 ffff88006484b880 0000000000000000
[  169.574261] Call Trace:
[  169.574263]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574264]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574266]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574268]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574269]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574271]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574272]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574274]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574275] scsi_eh_3       S ffff88048f254640     0   101      2 0x00000000
[  169.574277]  ffff880473311e30 0000000000000046 ffff8804787add20 ffff880473311fd8
[  169.574278]  0000000000014640 0000000000014640 ffff880478d55d20 ffff880473197000
[  169.574280]  0000000000000246 ffff8804787ae1e8 0000000000000000 0000000000000000
[  169.574282] Call Trace:
[  169.574284]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574286]  [<ffffffff8144b079>] scsi_error_handler+0x89/0x7e0
[  169.574288]  [<ffffffff8144aff0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  169.574289]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574291]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574292]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574294]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574295] scsi_tmf_3      S ffff88048f3d4640     0   102      2 0x00000000
[  169.574298]  ffff880473313e28 0000000000000046 ffff8804787ad3d0 ffff880473313fd8
[  169.574300]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff88047321af80
[  169.574302]  ffff8804787ad3d0 ffffffff8109ea60 ffff88006484ba80 0000000000000000
[  169.574304] Call Trace:
[  169.574305]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574307]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574309]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574311]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574312]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574314]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574315]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574317]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574318] scsi_eh_4       S ffff88048f3d4640     0   103      2 0x00000000
[  169.574320]  ffff880473315e30 0000000000000046 ffff8804787aca80 ffff880473315fd8
[  169.574321]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff880473197800
[  169.574323]  0000000000000246 ffff8804787acf48 0000000000000000 0000000000000000
[  169.574325] Call Trace:
[  169.574327]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574329]  [<ffffffff8144b079>] scsi_error_handler+0x89/0x7e0
[  169.574331]  [<ffffffff8144aff0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  169.574332]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574334]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574335]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574337]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574338] scsi_tmf_4      S ffff88048f3d4640     0   104      2 0x00000000
[  169.574341]  ffff880473317e28 0000000000000046 ffff880473318000 ffff880473317fd8
[  169.574343]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff880473291100
[  169.574345]  ffff880473318000 ffffffff8109ea60 ffff88006484bc80 0000000000000000
[  169.574347] Call Trace:
[  169.574348]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574350]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574352]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574354]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574355]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574357]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574358]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574360]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574361] scsi_eh_5       S ffff88048f214640     0   105      2 0x00000000
[  169.574362]  ffff880473329e30 0000000000000046 ffff880473318950 ffff880473329fd8
[  169.574364]  0000000000014640 0000000000014640 ffffffff81c16460 ffff880473320000
[  169.574366]  0000000000000246 ffff880473318e18 0000000000000000 0000000000000000
[  169.574368] Call Trace:
[  169.574370]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574371]  [<ffffffff8144b079>] scsi_error_handler+0x89/0x7e0
[  169.574373]  [<ffffffff8144aff0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  169.574375]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574376]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574378]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574379]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574380] scsi_tmf_5      S ffff88048f3d4640     0   106      2 0x00000000
[  169.574384]  ffff88047332be28 0000000000000046 ffff8804733192a0 ffff88047332bfd8
[  169.574386]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff880473291200
[  169.574387]  ffff8804733192a0 ffffffff8109ea60 ffff88006484be80 0000000000000000
[  169.574389] Call Trace:
[  169.574391]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574393]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574395]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574396]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574398]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574399]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574401]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574402]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574403] kworker/u16:2   S ffff88048f3d4640     0   107      2 0x00000000
[  169.574407]  ffff88047332de58 0000000000000046 ffff8800648b12a0 ffff88047332dfd8
[  169.574409]  0000000000014640 0000000000014640 ffff88006499e670 ffff88047e821400
[  169.574410]  ffff88047e821418 ffff8804788c20b0 ffff8800648b12a0 ffff8804788c2080
[  169.574412] Call Trace:
[  169.574414]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574416]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.574418]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.574419]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574421]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574422]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574424]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574425] kworker/u16:3   S ffff88048f3d4640     0   108      2 0x00000000
[  169.574428]  ffff88047332fe58 0000000000000046 ffff8800648b1bf0 ffff88047332ffd8
[  169.574430]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff88047e821400
[  169.574432]  ffff88047e821418 ffff8804788c2130 ffff8800648b1bf0 ffff8804788c2100
[  169.574434] Call Trace:
[  169.574436]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574437]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.574439]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.574441]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574442]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574444]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574445]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574446] kworker/u16:4   S ffff88048f254640     0   109      2 0x00000000
[  169.574450]  ffff880473339e58 0000000000000046 ffff8800648b2540 ffff880473339fd8
[  169.574452]  0000000000014640 0000000000014640 ffff880478d55d20 ffff88047e821400
[  169.574454]  ffff88047e821418 ffff8804788c21b0 ffff8800648b2540 ffff8804788c2180
[  169.574455] Call Trace:
[  169.574457]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574459]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.574461]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.574462]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574464]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574465]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574467]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574468] kworker/u16:5   S ffff88048f214640     0   110      2 0x00000000
[  169.574471]  ffff88047333be58 0000000000000046 ffff880473348000 ffff88047333bfd8
[  169.574473]  0000000000014640 0000000000014640 ffff88006499dd20 ffff88047e821400
[  169.574475]  ffff88047e821418 ffff8800648e30b0 ffff880473348000 ffff8800648e3080
[  169.574477] Call Trace:
[  169.574479]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574481]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.574482]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.574484]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574485]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574487]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574488]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574489] kworker/u16:6   S ffff88048f294640     0   111      2 0x00000000
[  169.574493]  ffff88047333de58 0000000000000046 ffff880473348950 ffff88047333dfd8
[  169.574495]  0000000000014640 0000000000014640 ffff88006499e670 ffff88047e821400
[  169.574497]  ffff88047e821418 ffff880478803030 ffff880473348950 ffff880478803000
[  169.574499] Call Trace:
[  169.574501]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574502]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.574504]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.574505]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574507]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574509]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574510]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574511] scsi_eh_6       S ffff88048f314640     0   112      2 0x00000000
[  169.574513]  ffff880064979e30 0000000000000046 ffff8804733492a0 ffff880064979fd8
[  169.574515]  0000000000014640 0000000000014640 ffff880478e18000 ffff880473320800
[  169.574516]  0000000000000246 ffff880473349768 0000000000000000 0000000000000000
[  169.574518] Call Trace:
[  169.574520]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574522]  [<ffffffff8144b079>] scsi_error_handler+0x89/0x7e0
[  169.574524]  [<ffffffff8144aff0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  169.574525]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574527]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574528]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574530]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574531] scsi_tmf_6      S ffff88048f314640     0   113      2 0x00000000
[  169.574535]  ffff88006497be28 0000000000000046 ffff880473349bf0 ffff88006497bfd8
[  169.574536]  0000000000014640 0000000000014640 ffff880478e18000 ffff880473291580
[  169.574538]  ffff880473349bf0 ffffffff8109ea60 ffff88006497c080 0000000000000000
[  169.574540] Call Trace:
[  169.574542]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574544]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574545]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574547]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574549]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574550]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574552]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574553]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574554] scsi_eh_7       S ffff88048f254640     0   114      2 0x00000000
[  169.574556]  ffff880064981e30 0000000000000046 ffff88047334a540 ffff880064981fd8
[  169.574558]  0000000000014640 0000000000014640 ffff880478d55d20 ffff880473321000
[  169.574560]  0000000000000246 ffff88047334aa08 0000000000000000 0000000000000000
[  169.574562] Call Trace:
[  169.574563]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574565]  [<ffffffff8144b079>] scsi_error_handler+0x89/0x7e0
[  169.574567]  [<ffffffff8144aff0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  169.574568]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574570]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574572]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574573]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574574] scsi_tmf_7      S ffff88048f314640     0   115      2 0x00000000
[  169.574578]  ffff880064983e28 0000000000000046 ffff88047334ae90 ffff880064983fd8
[  169.574579]  0000000000014640 0000000000014640 ffff880478e18000 ffff880473291700
[  169.574581]  ffff88047334ae90 ffffffff8109ea60 ffff88006497c280 0000000000000000
[  169.574583] Call Trace:
[  169.574585]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574587]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574588]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574590]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574592]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574593]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574595]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574596]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574597] scsi_eh_8       S ffff88048f294640     0   116      2 0x00000000
[  169.574599]  ffff880064985e30 0000000000000046 ffff88047334b7e0 ffff880064985fd8
[  169.574601]  0000000000014640 0000000000014640 ffff880478d56670 ffff880473321800
[  169.574603]  0000000000000246 ffff88047334bca8 0000000000000000 0000000000000000
[  169.574604] Call Trace:
[  169.574606]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574608]  [<ffffffff8144b079>] scsi_error_handler+0x89/0x7e0
[  169.574610]  [<ffffffff8144aff0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  169.574611]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574613]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574615]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574616]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574617] scsi_tmf_8      S ffff88048f314640     0   117      2 0x00000000
[  169.574621]  ffff880064987e28 0000000000000046 ffff88047334c130 ffff880064987fd8
[  169.574623]  0000000000014640 0000000000014640 ffff880478e18000 ffff880473291800
[  169.574624]  ffff88047334c130 ffffffff8109ea60 ffff88006497c480 0000000000000000
[  169.574626] Call Trace:
[  169.574628]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574630]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574632]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574634]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574635]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574637]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574638]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574640]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574641] scsi_eh_9       S ffff88048f394640     0   118      2 0x00000000
[  169.574642]  ffff880064989e30 0000000000000046 ffff88047334ca80 ffff880064989fd8
[  169.574644]  0000000000014640 0000000000014640 ffff880478e192a0 ffff880473322000
[  169.574646]  0000000000000246 ffff88047334cf48 0000000000000000 0000000000000000
[  169.574648] Call Trace:
[  169.574650]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574651]  [<ffffffff8144b079>] scsi_error_handler+0x89/0x7e0
[  169.574653]  [<ffffffff8144aff0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  169.574655]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574656]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574658]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574659]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574660] scsi_tmf_9      S ffff88048f314640     0   119      2 0x00000000
[  169.574664]  ffff88006498be28 0000000000000046 ffff88047334d3d0 ffff88006498bfd8
[  169.574666]  0000000000014640 0000000000014640 ffff880478e18000 ffff880473291900
[  169.574668]  ffff88047334d3d0 ffffffff8109ea60 ffff88006497c680 0000000000000000
[  169.574669] Call Trace:
[  169.574671]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574673]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574675]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574676]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574678]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574680]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574681]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574682]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574684] scsi_eh_10      S ffff88048f2d4640     0   120      2 0x00000000
[  169.574685]  ffff88006498de30 0000000000000046 ffff88047334dd20 ffff88006498dfd8
[  169.574687]  0000000000014640 0000000000014640 ffff880478d56fc0 ffff880473322800
[  169.574689]  0000000000000246 ffff88047334e1e8 0000000000000000 0000000000000000
[  169.574691] Call Trace:
[  169.574693]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574694]  [<ffffffff8144b079>] scsi_error_handler+0x89/0x7e0
[  169.574696]  [<ffffffff8144aff0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  169.574698]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574699]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574701]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574702]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574704] scsi_tmf_10     S ffff88048f314640     0   121      2 0x00000000
[  169.574707]  ffff88006498fe28 0000000000000046 ffff88047334e670 ffff88006498ffd8
[  169.574709]  0000000000014640 0000000000014640 ffff880478e18000 ffff880473291a00
[  169.574711]  ffff88047334e670 ffffffff8109ea60 ffff88006497c880 0000000000000000
[  169.574713] Call Trace:
[  169.574714]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574716]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574718]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574720]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574721]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574723]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574724]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574726]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574727] scsi_eh_11      S ffff88048f294640     0   122      2 0x00000000
[  169.574729]  ffff880064991e30 0000000000000046 ffff88047334efc0 ffff880064991fd8
[  169.574730]  0000000000014640 0000000000014640 ffff880478d56670 ffff880473323000
[  169.574732]  0000000000000246 ffff88047334f488 0000000000000000 0000000000000000
[  169.574734] Call Trace:
[  169.574736]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574738]  [<ffffffff8144b079>] scsi_error_handler+0x89/0x7e0
[  169.574740]  [<ffffffff8144aff0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  169.574741]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574743]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574744]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574746]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574747] scsi_tmf_11     S ffff88048f314640     0   123      2 0x00000000
[  169.574750]  ffff880064993e28 0000000000000046 ffff880064998000 ffff880064993fd8
[  169.574752]  0000000000014640 0000000000014640 ffff880478e18000 ffff880473291b00
[  169.574754]  ffff880064998000 ffffffff8109ea60 ffff88006497ca80 0000000000000000
[  169.574756] Call Trace:
[  169.574758]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574760]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574761]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574763]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574765]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574766]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574768]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574769]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574770] scsi_eh_12      S ffff88048f254640     0   124      2 0x00000000
[  169.574772]  ffff880064995e30 0000000000000046 ffff880064998950 ffff880064995fd8
[  169.574774]  0000000000014640 0000000000014640 ffff880478d55d20 ffff880473323800
[  169.574776]  0000000000000246 ffff880064998e18 0000000000000000 0000000000000000
[  169.574777] Call Trace:
[  169.574779]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574781]  [<ffffffff8144b079>] scsi_error_handler+0x89/0x7e0
[  169.574783]  [<ffffffff8144aff0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  169.574784]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574786]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574788]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574789]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574790] scsi_tmf_12     S ffff88048f314640     0   125      2 0x00000000
[  169.574794]  ffff880064997e28 0000000000000046 ffff8800649992a0 ffff880064997fd8
[  169.574796]  0000000000014640 0000000000014640 ffff880478e18000 ffff880473291c00
[  169.574797]  ffff8800649992a0 ffffffff8109ea60 ffff88006497cc80 0000000000000000
[  169.574799] Call Trace:
[  169.574801]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574803]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574805]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574806]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574808]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574809]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574811]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574812]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574813] scsi_eh_13      S ffff88048f214640     0   126      2 0x00000000
[  169.574815]  ffff8800649a9e30 0000000000000046 ffff880064999bf0 ffff8800649a9fd8
[  169.574817]  0000000000014640 0000000000014640 ffffffff81c16460 ffff880473324000
[  169.574819]  0000000000000246 ffff88006499a0b8 0000000000000000 0000000000000000
[  169.574820] Call Trace:
[  169.574822]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574824]  [<ffffffff8144b079>] scsi_error_handler+0x89/0x7e0
[  169.574826]  [<ffffffff8144aff0>] ? scsi_eh_get_sense+0x2a0/0x2a0
[  169.574827]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574829]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574830]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574832]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574833] scsi_tmf_13     S ffff88048f314640     0   127      2 0x00000000
[  169.574837]  ffff8800649abe28 0000000000000046 ffff88006499a540 ffff8800649abfd8
[  169.574838]  0000000000014640 0000000000014640 ffff880478e18000 ffff880473291d00
[  169.574840]  ffff88006499a540 ffffffff8109ea60 ffff88006497ce80 0000000000000000
[  169.574842] Call Trace:
[  169.574844]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574846]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574847]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.574849]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.574851]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574852]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574854]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574855]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574856] kworker/u16:7   S ffff88048f394640     0   128      2 0x00000000
[  169.574860]  ffff8800649ade58 0000000000000046 ffff88006499ae90 ffff8800649adfd8
[  169.574862]  0000000000014640 0000000000014640 ffff880478e192a0 ffff88047e821400
[  169.574864]  ffff88047e821418 ffff8804788030b0 ffff88006499ae90 ffff880478803080
[  169.574865] Call Trace:
[  169.574867]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574869]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.574871]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.574872]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574874]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574875]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574877]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574878] kworker/u16:8   S ffff88048f3d4640     0   129      2 0x00000000
[  169.574881]  ffff8800649afe58 0000000000000046 ffff88006499b7e0 ffff8800649affd8
[  169.574883]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff88047e821400
[  169.574885]  ffff88047e821418 ffff880478803130 ffff88006499b7e0 ffff880478803100
[  169.574887] Call Trace:
[  169.574889]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574890]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.574892]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.574894]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574895]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574897]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574898]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574899] kworker/u16:9   S ffff88048f254640     0   130      2 0x00000000
[  169.574903]  ffff8800649b1e58 0000000000000046 ffff88006499c130 ffff8800649b1fd8
[  169.574905]  0000000000014640 0000000000014640 ffff880478d55d20 ffff88047e821400
[  169.574906]  ffff88047e821418 ffff8804788031b0 ffff88006499c130 ffff880478803180
[  169.574908] Call Trace:
[  169.574910]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574912]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.574914]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.574915]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574917]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574918]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574920]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574921] kworker/u16:10  S ffff88048f314640     0   131      2 0x00000000
[  169.574924]  ffff8800649b3e58 0000000000000046 ffff88006499ca80 ffff8800649b3fd8
[  169.574926]  0000000000014640 0000000000014640 ffff880478e18000 ffff88047e821400
[  169.574928]  ffff88047e821418 ffff880478803230 ffff88006499ca80 ffff880478803200
[  169.574930] Call Trace:
[  169.574932]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574934]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.574935]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.574937]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574938]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574940]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574941]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574942] kworker/u16:11  S ffff88048f2d4640     0   132      2 0x00000000
[  169.574946]  ffff8800649d5e58 0000000000000046 ffff88006499d3d0 ffff8800649d5fd8
[  169.574948]  0000000000014640 0000000000014640 ffff880478d56fc0 ffff88047e821400
[  169.574949]  ffff88047e821418 ffff8804788032b0 ffff88006499d3d0 ffff880478803280
[  169.574951] Call Trace:
[  169.574953]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574955]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.574957]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.574958]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574960]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574961]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574963]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574964] kworker/u16:12  S ffff88048f214640     0   133      2 0x00000000
[  169.574967]  ffff8800649d7e58 0000000000000046 ffff88006499dd20 ffff8800649d7fd8
[  169.574969]  0000000000014640 0000000000014640 ffff880472daa540 ffff88047e821400
[  169.574971]  ffff88047e821418 ffff880478803330 ffff88006499dd20 ffff880478803300
[  169.574973] Call Trace:
[  169.574975]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574976]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.574978]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.574980]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.574981]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574983]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.574984]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.574985] kworker/u16:13  S ffff88048f3d4640     0   134      2 0x00000000
[  169.574989]  ffff8800649d9e58 0000000000000046 ffff88006499e670 ffff8800649d9fd8
[  169.574990]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff88047e821400
[  169.574992]  ffff88047e821418 ffff8804788033b0 ffff88006499e670 ffff880478803380
[  169.574994] Call Trace:
[  169.574996]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.574998]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.574999]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575001]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575002]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575004]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575005]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575006] kworker/u16:14  S ffff88048f354640     0   135      2 0x00000000
[  169.575010]  ffff8800649dbe58 0000000000000046 ffff88006499efc0 ffff8800649dbfd8
[  169.575012]  0000000000014640 0000000000014640 ffff880478e18950 ffff88047e821400
[  169.575014]  ffff88047e821418 ffff880478803430 ffff88006499efc0 ffff880478803400
[  169.575015] Call Trace:
[  169.575017]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575019]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575021]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575022]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575024]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575025]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575027]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575028] kpsmoused       S ffff88048f314640     0   136      2 0x00000000
[  169.575032]  ffff880472ce1e28 0000000000000046 ffff880472cd8000 ffff880472ce1fd8
[  169.575033]  0000000000014640 0000000000014640 ffff880478e18000 ffff88047339d780
[  169.575035]  ffff880472cd8000 ffffffff8109ea60 ffff88006497d680 0000000000000000
[  169.575037] Call Trace:
[  169.575039]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575041]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575042]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.575044]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575046]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575047]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575049]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575050]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575051] kworker/0:2     S ffff88048f214640     0   137      2 0x00000000
[  169.575055]  ffff880472ce3e58 0000000000000046 ffff880472cd8950 ffff880472ce3fd8
[  169.575056]  0000000000014640 0000000000014640 ffff8804728537e0 ffff88048f213ec0
[  169.575058]  ffff88048f213ed8 ffff88047339d830 ffff880472cd8950 ffff88047339d800
[  169.575060] Call Trace:
[  169.575062]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575064]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575065]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575067]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575068]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575070]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575071]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575072] dm_bufio_cache  S ffff88048f314640     0   138      2 0x00000000
[  169.575076]  ffff880472ce5e28 0000000000000046 ffff880472cd92a0 ffff880472ce5fd8
[  169.575078]  0000000000014640 0000000000014640 ffff880478e18000 ffff88047339da80
[  169.575080]  ffff880472cd92a0 ffffffff8109ea60 ffff88006497d880 0000000000000000
[  169.575081] Call Trace:
[  169.575083]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575085]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575087]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.575089]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575090]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575092]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575093]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575095]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575096] ipv6_addrconf   S ffff88048f314640     0   139      2 0x00000000
[  169.575099]  ffff880472d49e28 0000000000000046 ffff880472cd9bf0 ffff880472d49fd8
[  169.575101]  0000000000014640 0000000000014640 ffff880478e18000 ffff880472cf9780
[  169.575103]  ffff880472cd9bf0 ffffffff8109ea60 ffff880472d44680 0000000000000000
[  169.575105] Call Trace:
[  169.575106]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575108]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575110]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.575112]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575113]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575115]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575116]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575118]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575119] deferwq         S ffff88048f314640     0   140      2 0x00000000
[  169.575122]  ffff880472d4be28 0000000000000046 ffff880472cda540 ffff880472d4bfd8
[  169.575124]  0000000000014640 0000000000014640 ffff880478e18000 ffff880472cf9c00
[  169.575126]  ffff880472cda540 ffffffff8109ea60 ffff880472d45280 0000000000000000
[  169.575128] Call Trace:
[  169.575130]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575132]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575133]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.575135]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575136]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575138]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575140]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575141]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575142] kworker/u16:15  S ffff88048f214640     0   141      2 0x00000000
[  169.575146]  ffff880472d4de58 0000000000000046 ffff880472cdae90 ffff880472d4dfd8
[  169.575147]  0000000000014640 0000000000014640 ffffffff81c16460 ffff88047e821400
[  169.575149]  ffff88047e821418 ffff8804788034b0 ffff880472cdae90 ffff880478803480
[  169.575151] Call Trace:
[  169.575153]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575155]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575157]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575158]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575160]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575161]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575163]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575164] kworker/1:1     S ffff88048f254640     0   142      2 0x00000000
[  169.575168]  ffff880472d7fe58 0000000000000046 ffff880472cdb7e0 ffff880472d7ffd8
[  169.575170]  0000000000014640 0000000000014640 ffff880473c0b7e0 ffff88048f253ec0
[  169.575171]  ffff88048f253ed8 ffff88006486f430 ffff880472cdb7e0 ffff88006486f400
[  169.575173] Call Trace:
[  169.575175]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575177]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575179]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575180]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575182]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575183]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575185]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575186] kworker/u16:16  S ffff88048f394640     0   143      2 0x00000000
[  169.575189]  ffff880472db1e58 0000000000000046 ffff880472da8000 ffff880472db1fd8
[  169.575191]  0000000000014640 0000000000014640 ffff880478e192a0 ffff88047e821400
[  169.575193]  ffff88047e821418 ffff880478803530 ffff880472da8000 ffff880478803500
[  169.575195] Call Trace:
[  169.575197]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575199]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575200]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575202]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575203]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575205]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575206]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575207] kworker/7:1     R  running task        0   144      2 0x00000000
[  169.575211]  ffff880472de5e58 0000000000000046 ffff880472da8950 ffff880472de5fd8
[  169.575212]  0000000000014640 0000000000014640 ffff8804776e8950 ffff88048f3d3ec0
[  169.575214]  ffff88048f3d3ed8 ffff8804788c22b0 ffff880472da8950 ffff8804788c2280
[  169.575216] Call Trace:
[  169.575218]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575220]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575221]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575223]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575224]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575226]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575227]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575228] kworker/2:1     S ffff88048f294640     0   145      2 0x00000000
[  169.575232]  ffff880472de7e58 0000000000000046 ffff880472da92a0 ffff880472de7fd8
[  169.575234]  0000000000014640 0000000000014640 ffff880472852540 ffff88048f293ec0
[  169.575236]  ffff88048f293ed8 ffff880478f1cdb0 ffff880472da92a0 ffff880478f1cd80
[  169.575237] Call Trace:
[  169.575239]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575241]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575243]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575244]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575246]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575247]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575249]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575250] kworker/6:1     S ffff88048f394640     0   146      2 0x00000000
[  169.575254]  ffff880472e65e58 0000000000000046 ffff880472da9bf0 ffff880472e65fd8
[  169.575256]  0000000000014640 0000000000014640 ffff880478ff37e0 ffff88048f393ec0
[  169.575257]  ffff88048f393ed8 ffff8800648e3030 ffff880472da9bf0 ffff8800648e3000
[  169.575259] Call Trace:
[  169.575261]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575263]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575265]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575266]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575268]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575269]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575271]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575272] kworker/4:1     S ffff88048f314640     0   177      2 0x00000000
[  169.575275]  ffff880064a5be58 0000000000000046 ffff880472850950 ffff880064a5bfd8
[  169.575277]  0000000000014640 0000000000014640 ffff8804728512a0 ffff88048f313ec0
[  169.575279]  ffff88048f313ed8 ffff8800649220b0 ffff880472850950 ffff880064922080
[  169.575281] Call Trace:
[  169.575283]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575284]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575286]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575288]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575289]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575291]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575292]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575293] kworker/4:2     S ffff88048f314640     0   179      2 0x00000000
[  169.575297]  ffff880064a39e58 0000000000000046 ffff8804728512a0 ffff880064a39fd8
[  169.575299]  0000000000014640 0000000000014640 ffff8804765c9bf0 ffff88048f313ec0
[  169.575301]  ffff88048f313ed8 ffff8800649221b0 ffff8804728512a0 ffff880064922180
[  169.575302] Call Trace:
[  169.575304]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575306]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575308]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575309]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575311]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575312]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575314]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575315] kauditd         S ffff88048f214640     0   184      2 0x00000000
[  169.575317]  ffff880064a77e50 0000000000000046 ffff8800648b37e0 ffff880064a77fd8
[  169.575318]  0000000000014640 0000000000014640 ffffffff81c16460 ffff8800648b37e0
[  169.575320]  ffff8800648b37e0 ffff8800648b37e0 ffff8800648b37e0 0000000000000000
[  169.575322] Call Trace:
[  169.575324]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575327]  [<ffffffff8110c434>] kauditd_thread+0x184/0x1e0
[  169.575329]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.575330]  [<ffffffff8110c2b0>] ? audit_printk_skb+0x70/0x70
[  169.575332]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575333]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575335]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575337]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575338] kworker/1:2     S ffff88048f254640     0   197      2 0x00000000
[  169.575341]  ffff880064a71e58 0000000000000046 ffff88047331a540 ffff880064a71fd8
[  169.575343]  0000000000014640 0000000000014640 ffff880472ee6670 ffff88048f253ec0
[  169.575345]  ffff88048f253ed8 ffff8804784ab3b0 ffff88047331a540 ffff8804784ab380
[  169.575347] Call Trace:
[  169.575348]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575350]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575352]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575353]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575355]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575357]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575358]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575359] kworker/5:1     S ffff88048f354640     0   203      2 0x00000000
[  169.575363]  ffff880472fdde58 0000000000000046 ffff88047331ae90 ffff880472fddfd8
[  169.575364]  0000000000014640 0000000000014640 ffff880478ff0950 ffff88048f353ec0
[  169.575366]  ffff88048f353ed8 ffff880478803cb0 ffff88047331ae90 ffff880478803c80
[  169.575368] Call Trace:
[  169.575370]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575372]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575373]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575375]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575377]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575378]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575380]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575381] kworker/5:2     S ffff88048f354640     0   205      2 0x00000000
[  169.575384]  ffff880478821e58 0000000000000046 ffff88047331b7e0 ffff880478821fd8
[  169.575386]  0000000000014640 0000000000014640 ffff880472ee5d20 ffff88048f353ec0
[  169.575388]  ffff88048f353ed8 ffff880478803db0 ffff88047331b7e0 ffff880478803d80
[  169.575389] Call Trace:
[  169.575391]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575393]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575395]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575396]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575398]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575399]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575401]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575402] kworker/3:1     S ffff88048f2d4640     0   346      2 0x00000000
[  169.575405]  ffff880472b5de58 0000000000000046 ffff88047331d3d0 ffff880472b5dfd8
[  169.575407]  0000000000014640 0000000000014640 ffff88047331efc0 ffff88048f2d3ec0
[  169.575409]  ffff88048f2d3ed8 ffff880478f8a230 ffff88047331d3d0 ffff880478f8a200
[  169.575411] Call Trace:
[  169.575413]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575415]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575416]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575418]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575419]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575421]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575422]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575424] kworker/0:1H    S ffff88048f214640     0   366      2 0x00000000
[  169.575427]  ffff880470de7e58 0000000000000046 ffff880472cdd3d0 ffff880470de7fd8
[  169.575429]  0000000000014640 0000000000014640 ffff880478d512a0 ffff88048f214280
[  169.575431]  ffff88048f214298 ffff880064a8f430 ffff880472cdd3d0 ffff880064a8f400
[  169.575433] Call Trace:
[  169.575435]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575436]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575438]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575439]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575441]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575442]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575444]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575445] kworker/4:1H    S ffff88048f314640     0   393      2 0x00000000
[  169.575449]  ffff8804718c5e58 0000000000000046 ffff880471990000 ffff8804718c5fd8
[  169.575451]  0000000000014640 0000000000014640 ffff880478f04a80 ffff88048f314280
[  169.575452]  ffff88048f314298 ffff8800648e3f30 ffff880471990000 ffff8800648e3f00
[  169.575454] Call Trace:
[  169.575456]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575458]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575460]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575461]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575463]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575464]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575466]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575467] kworker/1:1H    S ffff88048f254640     0   394      2 0x00000000
[  169.575470]  ffff8804717f3e58 0000000000000046 ffff880471990950 ffff8804717f3fd8
[  169.575472]  0000000000014640 0000000000014640 ffff880472ee6670 ffff88048f254280
[  169.575474]  ffff88048f254298 ffff880478f9a9b0 ffff880471990950 ffff880478f9a980
[  169.575476] Call Trace:
[  169.575478]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575480]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575481]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575483]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575484]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575486]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575487]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575488] kworker/3:2     S ffff88048f2d4640     0   397      2 0x00000000
[  169.575492]  ffff880472b8be58 0000000000000046 ffff88047331efc0 ffff880472b8bfd8
[  169.575494]  0000000000014640 0000000000014640 ffff880478f02540 ffff88048f2d3ec0
[  169.575495]  ffff88048f2d3ed8 ffff880478f8a730 ffff88047331efc0 ffff880478f8a700
[  169.575497] Call Trace:
[  169.575499]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575501]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575503]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575504]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575506]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575507]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575509]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575510] kdmflush        S ffff88048f314640     0   438      2 0x00000000
[  169.575513]  ffff880470991e28 0000000000000046 ffff88047331e670 ffff880470991fd8
[  169.575515]  0000000000014640 0000000000014640 ffff880478e18000 ffff880472a6a980
[  169.575517]  ffff88047331e670 ffffffff8109ea60 ffff88047283a880 0000000000000000
[  169.575519] Call Trace:
[  169.575521]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575522]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575524]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.575526]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575527]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575529]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575530]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575532]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575533] bioset          S ffff88048f314640     0   439      2 0x00000000
[  169.575536]  ffff880470893e28 0000000000000046 ffff88047331dd20 ffff880470893fd8
[  169.575538]  0000000000014640 0000000000014640 ffff880478e18000 ffff8804718f9b80
[  169.575540]  ffff88047331dd20 ffffffff8109ea60 ffff880472e01080 0000000000000000
[  169.575542] Call Trace:
[  169.575544]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575545]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575547]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.575549]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575550]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575552]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575554]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575555]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575556] kdmflush        S ffff88048f314640     0   446      2 0x00000000
[  169.575560]  ffff88047059de28 0000000000000046 ffff88047331c130 ffff88047059dfd8
[  169.575562]  0000000000014640 0000000000014640 ffff880478e18000 ffff880472e2b300
[  169.575563]  ffff88047331c130 ffffffff8109ea60 ffff88047188c080 0000000000000000
[  169.575565] Call Trace:
[  169.575567]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575569]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575571]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.575572]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575574]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575575]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575577]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575578]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575579] bioset          S ffff88048f314640     0   447      2 0x00000000
[  169.575583]  ffff88047089be28 0000000000000046 ffff88047331ca80 ffff88047089bfd8
[  169.575585]  0000000000014640 0000000000014640 ffff880478e18000 ffff880472e2b000
[  169.575587]  ffff88047331ca80 ffffffff8109ea60 ffff88047188fe80 0000000000000000
[  169.575588] Call Trace:
[  169.575590]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575592]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575594]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.575596]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575597]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575599]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575600]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575602]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575603] kworker/3:3     S ffff88048f2d4640     0   460      2 0x00000000
[  169.575606]  ffff880471847e58 0000000000000046 ffff880473319bf0 ffff880471847fd8
[  169.575608]  0000000000014640 0000000000014640 ffff880478d56fc0 ffff88048f2d3ec0
[  169.575610]  ffff88048f2d3ed8 ffff880470962530 ffff880473319bf0 ffff880470962500
[  169.575612] Call Trace:
[  169.575614]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575615]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575617]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575619]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575620]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575622]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575623]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575624] jbd2/dm-1-8     S ffff88048f214640     0   470      2 0x00000000
[  169.575626]  ffff880471767e40 0000000000000046 ffff8804717192a0 ffff880471767fd8
[  169.575628]  0000000000014640 0000000000014640 ffff8804728537e0 ffff880472d1d024
[  169.575630]  ffff880472d1d3e0 ffff880472d1d0a0 ffff880471767e90 ffff880472d1d000
[  169.575631] Call Trace:
[  169.575633]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575636]  [<ffffffff812a2b86>] kjournald2+0x1e6/0x250
[  169.575638]  [<ffffffff810c7eb0>] ? abort_exclusive_wait+0xb0/0xb0
[  169.575639]  [<ffffffff812a29a0>] ? commit_timeout+0x10/0x10
[  169.575641]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575642]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575644]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575645]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575646] ext4-rsv-conver S ffff88048f314640     0   471      2 0x00000000
[  169.575650]  ffff88047178de28 0000000000000046 ffff8804719912a0 ffff88047178dfd8
[  169.575652]  0000000000014640 0000000000014640 ffff880478e18000 ffff88047060d400
[  169.575654]  ffff8804719912a0 ffffffff8109ea60 ffff880064afd280 0000000000000000
[  169.575656] Call Trace:
[  169.575657]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575659]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575661]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.575663]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575664]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575666]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575667]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575669]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575670] kworker/2:2     S ffff88048f294640     0   519      2 0x00000000
[  169.575673]  ffff8804717ffe58 0000000000000046 ffff880471991bf0 ffff8804717fffd8
[  169.575675]  0000000000014640 0000000000014640 ffff880471992540 ffff88048f293ec0
[  169.575677]  ffff88048f293ed8 ffff880478f1b9b0 ffff880471991bf0 ffff880478f1b980
[  169.575679] Call Trace:
[  169.575681]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575683]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575684]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575686]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575687]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575689]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575690]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575691] kworker/2:3     S ffff88048f294640     0   520      2 0x00000000
[  169.575695]  ffff880471789e58 0000000000000046 ffff880471992540 ffff880471789fd8
[  169.575697]  0000000000014640 0000000000014640 ffff880478d56670 ffff88048f293ec0
[  169.575698]  ffff88048f293ed8 ffff880478f1bb30 ffff880471992540 ffff880478f1bb00
[  169.575700] Call Trace:
[  169.575702]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575704]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575706]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575707]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575709]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575710]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575712]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575713] systemd-journal S ffff88048f214640     0   568      1 0x00000000
[  169.575714]  ffff880471899dd8 0000000000000086 ffff8804776292a0 ffff880471899fd8
[  169.575716]  0000000000014640 0000000000014640 ffffffff81c16460 0000000000000000
[  169.575718]  0000000000000000 ffff880478802660 ffff8804776292a0 0000000000000000
[  169.575720] Call Trace:
[  169.575722]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575724]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.575726]  [<ffffffff81216769>] ? ep_scan_ready_list.isra.9+0x199/0x1c0
[  169.575728]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.575730]  [<ffffffff812169ce>] ep_poll+0x21e/0x330
[  169.575732]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.575734]  [<ffffffff81217dc5>] SyS_epoll_wait+0xb5/0xe0
[  169.575736]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.575737] systemd-udevd   S ffff88048f3d4640     0   577      1 0x00000000
[  169.575738]  ffff880472a83dd8 0000000000000082 ffff880472dad3d0 ffff880472a83fd8
[  169.575740]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff880472a83ec0
[  169.575742]  00000000002dc6bf 0000000000000000 ffff880472dad3d0 ffff880472a83ec0
[  169.575744] Call Trace:
[  169.575746]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575748]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.575750]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.575752]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.575754]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.575756]  [<ffffffff812169ce>] ep_poll+0x21e/0x330
[  169.575758]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.575760]  [<ffffffff81217dc5>] SyS_epoll_wait+0xb5/0xe0
[  169.575761]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.575762] lvmetad         S ffff88048f3d4640     0   578      1 0x00000000
[  169.575764]  ffff880477625928 0000000000000086 ffff880472dadd20 ffff880477625fd8
[  169.575766]  0000000000014640 0000000000014640 ffff880471718950 0000000000000000
[  169.575768]  0000000000000040 0000000000000010 0000000000000004 0000000000000004
[  169.575769] Call Trace:
[  169.575771]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575773]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.575775]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.575778]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.575780]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.575782]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.575784]  [<ffffffff811e530e>] do_select+0x5ae/0x770
[  169.575786]  [<ffffffff811c2c0e>] ? lookup_page_cgroup_used+0xe/0x30
[  169.575789]  [<ffffffff811ca4f1>] ? mem_cgroup_bad_page_check+0x21/0x30
[  169.575791]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.575793]  [<ffffffff8116a606>] ? __rmqueue+0x106/0x4b0
[  169.575796]  [<ffffffff812dc877>] ? type_attribute_bounds_av.isra.10+0x57/0x2b0
[  169.575798]  [<ffffffff811c2c0e>] ? lookup_page_cgroup_used+0xe/0x30
[  169.575800]  [<ffffffff811ca4f1>] ? mem_cgroup_bad_page_check+0x21/0x30
[  169.575802]  [<ffffffff8116ae72>] ? get_page_from_freelist+0x4c2/0x9b0
[  169.575804]  [<ffffffff8169de43>] ? avc_alloc_node+0x24/0x125
[  169.575806]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.575808]  [<ffffffff8101a705>] ? native_sched_clock+0x35/0x90
[  169.575809]  [<ffffffff8101a769>] ? sched_clock+0x9/0x10
[  169.575811]  [<ffffffff810b7f35>] ? sched_clock_cpu+0x85/0xc0
[  169.575813]  [<ffffffff810b958e>] ? sched_slice.isra.54+0x4e/0x90
[  169.575815]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  169.575817]  [<ffffffff811e569c>] core_sys_select+0x1cc/0x2e0
[  169.575819]  [<ffffffff810b1c0c>] ? resched_task+0x4c/0x60
[  169.575821]  [<ffffffff810be986>] ? check_preempt_wakeup+0x146/0x220
[  169.575823]  [<ffffffff810b26a5>] ? check_preempt_curr+0x85/0xa0
[  169.575825]  [<ffffffff810b520c>] ? wake_up_new_task+0x10c/0x170
[  169.575827]  [<ffffffff8108342f>] ? do_fork+0x12f/0x300
[  169.575829]  [<ffffffff811e585b>] SyS_select+0xab/0x100
[  169.575831]  [<ffffffff81083686>] ? SyS_clone+0x16/0x20
[  169.575833]  [<ffffffff816ae1c9>] ? stub_clone+0x69/0x90
[  169.575834]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.575835] kworker/6:1H    S ffff88048f394640     0   579      2 0x00000000
[  169.575839]  ffff8804774a1e58 0000000000000046 ffff8804784d5d20 ffff8804774a1fd8
[  169.575841]  0000000000014640 0000000000014640 ffff88047171d3d0 ffff88048f394280
[  169.575843]  ffff88048f394298 ffff880472e53930 ffff8804784d5d20 ffff880472e53900
[  169.575845] Call Trace:
[  169.575847]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575848]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575850]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575852]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575853]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575855]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575856]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575857] kworker/6:2     R  running task        0   627      2 0x00000000
[  169.575861]  ffff880035db5e58 0000000000000046 ffff8800648d5d20 ffff880035db5fd8
[  169.575863]  0000000000014640 0000000000014640 ffff8804728553d0 ffff88048f393ec0
[  169.575865]  ffff88048f393ed8 ffff880472e53ab0 ffff8800648d5d20 ffff880472e53a80
[  169.575867] Call Trace:
[  169.575869]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575870]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575872]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575873]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575875]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575877]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575878]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575879] kworker/3:1H    S ffff88048f2d4640     0   634      2 0x00000000
[  169.575883]  ffff8804745ebe58 0000000000000046 ffff8800648d6fc0 ffff8804745ebfd8
[  169.575885]  0000000000014640 0000000000014640 ffff880478d56fc0 ffff88048f2d4280
[  169.575886]  ffff88048f2d4298 ffff880471803db0 ffff8800648d6fc0 ffff880471803d80
[  169.575888] Call Trace:
[  169.575890]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575892]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575894]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575895]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575897]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575898]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575900]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575901] kworker/7:2     S ffff88048f3d4640     0   659      2 0x00000000
[  169.575904]  ffff880470c93e58 0000000000000046 ffff88047171ae90 ffff880470c93fd8
[  169.575906]  0000000000014640 0000000000014640 ffff8804765c8950 ffff88048f3d3ec0
[  169.575908]  ffff88048f3d3ed8 ffff8800649224b0 ffff88047171ae90 ffff880064922480
[  169.575910] Call Trace:
[  169.575912]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575913]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.575915]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.575917]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575918]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575919]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575921]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575922] irq/58-mei_me   S ffff88048f3d4640     0   668      2 0x00000000
[  169.575924]  ffff880470c49e58 0000000000000046 ffff880471719bf0 ffff880470c49fd8
[  169.575926]  0000000000014640 0000000000014640 ffff88047171ae90 ffff880471719bf0
[  169.575928]  ffff880478f8a180 ffff880472accf00 ffff880471719bf0 ffffffff810dbad0
[  169.575930] Call Trace:
[  169.575932]  [<ffffffff810dbad0>] ? irq_finalize_oneshot.part.30+0xe0/0xe0
[  169.575934]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575935]  [<ffffffff810dbd5f>] irq_thread+0xaf/0x150
[  169.575937]  [<ffffffff810dbb80>] ? irq_forced_thread_fn+0x60/0x60
[  169.575939]  [<ffffffff810dbcb0>] ? irq_thread_check_affinity+0x80/0x80
[  169.575940]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575942]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575943]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575945]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575946] hd-audio0       S ffff88048f214640     0   775      2 0x00000000
[  169.575949]  ffff880475387e28 0000000000000046 ffff880035e0e670 ffff880475387fd8
[  169.575951]  0000000000014640 0000000000014640 ffffffff81c16460 ffff880470869e00
[  169.575953]  ffff880035e0e670 ffffffff8109ea60 ffff880064944a80 0000000000000000
[  169.575955] Call Trace:
[  169.575957]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575958]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575960]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.575962]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575963]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575965]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575967]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575968]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575969] hd-audio1       S ffff88048f314640     0   781      2 0x00000000
[  169.575973]  ffff880473959e28 0000000000000046 ffff880471850000 ffff880473959fd8
[  169.575974]  0000000000014640 0000000000014640 ffff8804718512a0 ffff880470869d80
[  169.575976]  ffff880471850000 ffffffff8109ea60 ffff880064947c80 0000000000000000
[  169.575978] Call Trace:
[  169.575980]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575982]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.575984]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.575985]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.575987]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.575988]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575990]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.575991]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.575993] jbd2/sda1-8     S ffff88048f3d4640     0   782      2 0x00000000
[  169.575994]  ffff880473b9fe40 0000000000000046 ffff880471851bf0 ffff880473b9ffd8
[  169.575996]  0000000000014640 0000000000014640 ffff880471854130 ffff8804787c4824
[  169.575998]  ffff8804787c4be0 ffff8804787c48a0 ffff880473b9fe90 ffff8804787c4800
[  169.576000] Call Trace:
[  169.576001]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576003]  [<ffffffff812a2b86>] kjournald2+0x1e6/0x250
[  169.576005]  [<ffffffff810c7eb0>] ? abort_exclusive_wait+0xb0/0xb0
[  169.576007]  [<ffffffff812a29a0>] ? commit_timeout+0x10/0x10
[  169.576008]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.576010]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.576011]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.576013]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.576014] kvm-irqfd-clean S ffff88048f314640     0   783      2 0x00000000
[  169.576017]  ffff88047395de28 0000000000000046 ffff8804718512a0 ffff88047395dfd8
[  169.576019]  0000000000014640 0000000000014640 ffff880035e0ca80 ffff880471782800
[  169.576021]  ffff8804718512a0 ffffffff8109ea60 ffff880471762280 0000000000000000
[  169.576023] Call Trace:
[  169.576024]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.576026]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576028]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.576030]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.576031]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.576033]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.576034]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.576036]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.576037] ext4-rsv-conver S ffff88048f314640     0   785      2 0x00000000
[  169.576041]  ffff880470453e28 0000000000000046 ffff880471856670 ffff880470453fd8
[  169.576042]  0000000000014640 0000000000014640 ffff880478e18000 ffff880470576480
[  169.576044]  ffff880471856670 ffffffff8109ea60 ffff880471843480 0000000000000000
[  169.576046] Call Trace:
[  169.576048]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.576050]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576051]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.576053]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.576055]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.576056]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.576058]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.576059]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.576060] kdmflush        S ffff88048f3d4640     0   817      2 0x00000000
[  169.576064]  ffff880470445e28 0000000000000046 ffff8804730ab7e0 ffff880470445fd8
[  169.576066]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff880065502800
[  169.576068]  ffff8804730ab7e0 ffffffff8109ea60 ffff880472e02a80 0000000000000000
[  169.576069] Call Trace:
[  169.576071]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.576073]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576075]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.576077]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.576078]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.576080]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.576081]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.576083]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.576084] bioset          S ffff88048f3d4640     0   818      2 0x00000000
[  169.576087]  ffff880473943e28 0000000000000046 ffff8804730a8950 ffff880473943fd8
[  169.576089]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff880065502d00
[  169.576091]  ffff8804730a8950 ffffffff8109ea60 ffff880472e02280 0000000000000000
[  169.576093] Call Trace:
[  169.576094]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.576096]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576098]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.576100]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.576101]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.576103]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.576104]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.576106]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.576107] jbd2/dm-2-8     S ffff88048f254640     0   831      2 0x00000000
[  169.576109]  ffff880477fbbe40 0000000000000046 ffff8804730aa540 ffff880477fbbfd8
[  169.576111]  0000000000014640 0000000000014640 ffff880478d55d20 ffff8804787c8024
[  169.576112]  ffff8804787c83e0 ffff8804787c80a0 ffff880477fbbe90 ffff8804787c8000
[  169.576114] Call Trace:
[  169.576116]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576118]  [<ffffffff812a2b86>] kjournald2+0x1e6/0x250
[  169.576120]  [<ffffffff810c7eb0>] ? abort_exclusive_wait+0xb0/0xb0
[  169.576121]  [<ffffffff812a29a0>] ? commit_timeout+0x10/0x10
[  169.576123]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.576124]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.576126]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.576127]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.576128] ext4-rsv-conver S ffff88048f314640     0   832      2 0x00000000
[  169.576132]  ffff8804712ffe28 0000000000000046 ffff8804753792a0 ffff8804712fffd8
[  169.576134]  0000000000014640 0000000000014640 ffff880478e18000 ffff880477fc3f80
[  169.576136]  ffff8804753792a0 ffffffff8109ea60 ffff8804729a2e80 0000000000000000
[  169.576137] Call Trace:
[  169.576139]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.576141]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576143]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.576145]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.576146]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.576148]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.576149]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.576151]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.576152] auditd          S ffff88048f254640     0   837      1 0x00000000
[  169.576153]  ffff880477ff5dd8 0000000000000082 ffff8804730aca80 ffff880477ff5fd8
[  169.576155]  0000000000014640 0000000000014640 ffff880478d55d20 ffff880477ff5ec0
[  169.576157]  00000000038f9b17 0000000000000000 ffff8804730aca80 ffff880477ff5ec0
[  169.576159] Call Trace:
[  169.576161]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576163]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.576165]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.576167]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.576169]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.576171]  [<ffffffff812169ce>] ep_poll+0x21e/0x330
[  169.576173]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.576175]  [<ffffffff81217dc5>] SyS_epoll_wait+0xb5/0xe0
[  169.576177]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576177] auditd          S ffff88048f394640     0   844      1 0x00000000
[  169.576179]  ffff8804756e7ca8 0000000000000082 ffff880472cdca80 ffff8804756e7fd8
[  169.576181]  0000000000014640 0000000000014640 ffff880478e192a0 ffff880472cdca80
[  169.576183]  0000000000000000 ffffc900018eeac0 ffff880472cdca80 ffff8804756e7db8
[  169.576185] Call Trace:
[  169.576187]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576189]  [<ffffffff810f035a>] futex_wait_queue_me+0xda/0x140
[  169.576190]  [<ffffffff810f0635>] futex_wait+0x165/0x250
[  169.576192]  [<ffffffff8169de43>] ? avc_alloc_node+0x24/0x125
[  169.576194]  [<ffffffff8169e0e7>] ? avc_compute_av+0x1a3/0x1b5
[  169.576195]  [<ffffffff810f0177>] ? get_futex_key+0x1d7/0x2e0
[  169.576197]  [<ffffffff810f2766>] do_futex+0xe6/0xb00
[  169.576200]  [<ffffffff812005a8>] ? do_statfs_native+0x98/0xb0
[  169.576201]  [<ffffffff810f31f1>] SyS_futex+0x71/0x150
[  169.576203]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576204] audispd         S ffff88048f214640     0   845    837 0x00000000
[  169.576206]  ffff880477fb5ca8 0000000000000086 ffff880472cde670 ffff880477fb5fd8
[  169.576207]  0000000000014640 0000000000014640 ffffffff81c16460 ffff880472cde670
[  169.576209]  0000000000000000 ffffc900018d7800 ffff880472cde670 ffff880477fb5db8
[  169.576211] Call Trace:
[  169.576213]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576215]  [<ffffffff810f035a>] futex_wait_queue_me+0xda/0x140
[  169.576216]  [<ffffffff810f0635>] futex_wait+0x165/0x250
[  169.576219]  [<ffffffff8158497a>] ? sock_def_readable+0x3a/0x70
[  169.576221]  [<ffffffff810f2766>] do_futex+0xe6/0xb00
[  169.576223]  [<ffffffff81210898>] ? fsnotify+0x228/0x2f0
[  169.576225]  [<ffffffff811d0fba>] ? do_sync_write+0x5a/0x90
[  169.576226]  [<ffffffff810f31f1>] SyS_futex+0x71/0x150
[  169.576228]  [<ffffffff811d229a>] ? SyS_write+0x6a/0xb0
[  169.576230]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576231] audispd         S ffff88048f214640     0   850    837 0x00000080
[  169.576233]  ffff88047058ba60 0000000000000086 ffff880472f91bf0 ffff88047058bfd8
[  169.576234]  0000000000014640 0000000000014640 ffff8804728537e0 ffff88047058bb98
[  169.576236]  0000000001312cff 0000000000000000 ffff88047058bbb4 0000000000000000
[  169.576238] Call Trace:
[  169.576240]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576242]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.576244]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.576246]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.576248]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.576250]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.576252]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.576254]  [<ffffffff81588fe7>] ? kfree_skbmem+0x37/0xa0
[  169.576256]  [<ffffffff8158bf84>] ? consume_skb+0x34/0x80
[  169.576259]  [<ffffffff8164065c>] ? unix_stream_recvmsg+0x75c/0x880
[  169.576260]  [<ffffffff810bd877>] ? update_curr+0x67/0x160
[  169.576263]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576264]  [<ffffffff810be941>] ? check_preempt_wakeup+0x101/0x220
[  169.576266]  [<ffffffff810b26a5>] ? check_preempt_curr+0x85/0xa0
[  169.576268]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.576270]  [<ffffffff810b282d>] ? ttwu_do_activate.constprop.97+0x5d/0x70
[  169.576271]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.576273]  [<ffffffff811d103c>] ? do_sync_readv_writev+0x4c/0x80
[  169.576275]  [<ffffffff810b4e40>] ? wake_up_state+0x10/0x20
[  169.576277]  [<ffffffff810f07d6>] ? wake_futex+0x66/0x90
[  169.576278]  [<ffffffff810f2f2c>] ? do_futex+0x8ac/0xb00
[  169.576280]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.576282]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.576284]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.576286]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576287] sedispatch      S ffff88048f254640     0   848    845 0x00000080
[  169.576288]  ffff880472875bf0 0000000000000086 ffff880472f90000 ffff880472875fd8
[  169.576290]  0000000000014640 0000000000014640 ffff880478d55d20 ffff880472f51f80
[  169.576292]  7fffffffffffffff ffff880472f90000 ffff880472f52288 ffff880472f90000
[  169.576294] Call Trace:
[  169.576296]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576298]  [<ffffffff816a1679>] schedule_timeout+0x1f9/0x270
[  169.576300]  [<ffffffff810c7b16>] ? prepare_to_wait+0x56/0x90
[  169.576302]  [<ffffffff816401e4>] unix_stream_recvmsg+0x2e4/0x880
[  169.576304]  [<ffffffff810c7eb0>] ? abort_exclusive_wait+0xb0/0xb0
[  169.576306]  [<ffffffff8158122e>] sock_aio_read.part.10+0xfe/0x120
[  169.576308]  [<ffffffff81581271>] sock_aio_read+0x21/0x40
[  169.576310]  [<ffffffff811d0f2a>] do_sync_read+0x5a/0x90
[  169.576312]  [<ffffffff811d1655>] vfs_read+0x145/0x160
[  169.576314]  [<ffffffff811d21c6>] SyS_read+0x46/0xb0
[  169.576316]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.576317]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576318] alsactl         S ffff88048f2d4640     0   854      1 0x00000080
[  169.576320]  ffff88047086fa60 0000000000000086 ffff88047537b7e0 ffff88047086ffd8
[  169.576322]  0000000000014640 0000000000014640 ffff880478d56fc0 ffff88047086fb98
[  169.576324]  0000000005f5e100 0000000000000000 ffff88047086fbbc 0000000000000000
[  169.576325] Call Trace:
[  169.576327]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576329]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.576331]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.576333]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.576335]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.576337]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.576339]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.576341]  [<ffffffff810bf331>] ? put_prev_entity+0x31/0x3b0
[  169.576342]  [<ffffffff810c228e>] ? pick_next_task_fair+0x47e/0x840
[  169.576345]  [<ffffffff810115f9>] ? __switch_to+0x169/0x4c0
[  169.576347]  [<ffffffff816a1d2a>] ? __schedule+0x2aa/0x710
[  169.576349]  [<ffffffff816a2629>] ? schedule_preempt_disabled+0x29/0x70
[  169.576351]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576353]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576356]  [<ffffffff8169ca7c>] ? __slab_free+0xfe/0x252
[  169.576367]  [<ffffffffa022e2bb>] ? snd_ctl_read+0x29b/0x320 [snd]
[  169.576369]  [<ffffffff811b609f>] ? kfree+0xff/0x140
[  169.576373]  [<ffffffffa022e09e>] ? snd_ctl_read+0x7e/0x320 [snd]
[  169.576375]  [<ffffffff812c5b34>] ? security_file_permission+0x84/0xa0
[  169.576377]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.576378]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.576380]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.576382]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576383] firewalld       S ffff88048f3d4640     0   855      1 0x00000080
[  169.576385]  ffff880475b31a60 0000000000000082 ffff88047537c130 ffff880475b31fd8
[  169.576387]  0000000000014640 0000000000014640 ffff880472ae6670 0000000000000000
[  169.576389]  0000000000000000 ffff880475b31bbc ffff880475b31bbc 0000000000000000
[  169.576390] Call Trace:
[  169.576392]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576394]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.576396]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.576398]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.576400]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.576402]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.576404]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.576406]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.576409]  [<ffffffff8158251a>] ? sock_recvmsg+0x9a/0xd0
[  169.576411]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576413]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576415]  [<ffffffff815827f5>] ? ___sys_recvmsg+0x115/0x290
[  169.576417]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.576419]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.576421]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.576423]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.576425]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.576427]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576428] gmain           S ffff88048f3d4640     0  1383      1 0x00000080
[  169.576429]  ffff880473851a60 0000000000000082 ffff8804730ad3d0 ffff880473851fd8
[  169.576431]  0000000000014640 0000000000014640 ffff880478e19bf0 0000000000000000
[  169.576433]  0000000000000000 ffff880473851bbc ffff880473851bbc 0000000000000000
[  169.576435] Call Trace:
[  169.576437]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576439]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.576441]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.576443]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.576445]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.576447]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.576449]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.576450]  [<ffffffff81169ac8>] ? free_pcppages_bulk+0x168/0x420
[  169.576452]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576454]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576456]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  169.576459]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  169.576461]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.576463]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.576465]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.576467]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.576468]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.576470]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576471] accounts-daemon S ffff88048f254640     0   857      1 0x00000080
[  169.576473]  ffff880477219a60 0000000000000086 ffff88047537d3d0 ffff880477219fd8
[  169.576475]  0000000000014640 0000000000014640 ffff880478d55d20 0000000000000000
[  169.576476]  0000000000000000 ffff880477219bb4 ffff880477219bb4 0000000000000000
[  169.576478] Call Trace:
[  169.576480]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576482]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.576484]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.576486]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.576488]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.576490]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.576492]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.576493]  [<ffffffff810f0177>] ? get_futex_key+0x1d7/0x2e0
[  169.576496]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576497]  [<ffffffff810b2695>] ? check_preempt_curr+0x75/0xa0
[  169.576499]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.576501]  [<ffffffff810b282d>] ? ttwu_do_activate.constprop.97+0x5d/0x70
[  169.576503]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.576504]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.576506]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.576508]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.576510]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.576512]  [<ffffffff810c77e8>] ? __wake_up_common+0x58/0x90
[  169.576514]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.576515]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.576517]  [<ffffffff8121a59d>] ? eventfd_read+0x3d/0x70
[  169.576519]  [<ffffffff811d15ab>] ? vfs_read+0x9b/0x160
[  169.576521]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.576522]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576523] gmain           S ffff88048f294640     0   865      1 0x00000080
[  169.576525]  ffff8804728c5a60 0000000000000086 ffff8804750e8950 ffff8804728c5fd8
[  169.576527]  0000000000014640 0000000000014640 ffff880478d56670 0000000000000000
[  169.576528]  0000000000000000 ffff8804728c5bbc ffff8804728c5bbc 0000000000000000
[  169.576530] Call Trace:
[  169.576532]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576534]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.576536]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.576538]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.576540]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.576542]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.576544]  [<ffffffff810b7f35>] ? sched_clock_cpu+0x85/0xc0
[  169.576546]  [<ffffffff810bf331>] ? put_prev_entity+0x31/0x3b0
[  169.576547]  [<ffffffff810c228e>] ? pick_next_task_fair+0x47e/0x840
[  169.576549]  [<ffffffff810115f9>] ? __switch_to+0x169/0x4c0
[  169.576551]  [<ffffffff816a1d2a>] ? __schedule+0x2aa/0x710
[  169.576553]  [<ffffffff810f0177>] ? get_futex_key+0x1d7/0x2e0
[  169.576555]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576557]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576559]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.576561]  [<ffffffff810b282d>] ? ttwu_do_activate.constprop.97+0x5d/0x70
[  169.576562]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.576564]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.576566]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.576568]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.576570]  [<ffffffff810c77e8>] ? __wake_up_common+0x58/0x90
[  169.576572]  [<ffffffff81210898>] ? fsnotify+0x228/0x2f0
[  169.576573]  [<ffffffff810c7858>] ? __wake_up_locked_key+0x18/0x20
[  169.576575]  [<ffffffff811d17cc>] ? vfs_write+0x15c/0x1e0
[  169.576577]  [<ffffffff811d15ab>] ? vfs_read+0x9b/0x160
[  169.576579]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.576580]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576581] gdbus           S ffff88048f294640     0   883      1 0x00000080
[  169.576583]  ffff880471473a60 0000000000000086 ffff880472f96fc0 ffff880471473fd8
[  169.576585]  0000000000014640 0000000000014640 ffff880478d56670 0000000000000000
[  169.576587]  0000000000000000 ffff880471473bc4 ffff880471473bc4 0000000000000000
[  169.576589] Call Trace:
[  169.576591]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576593]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.576594]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.576596]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.576598]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.576600]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.576602]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.576604]  [<ffffffff8163fec6>] ? unix_stream_sendmsg+0x3c6/0x400
[  169.576606]  [<ffffffff81581eeb>] ? sock_sendmsg+0x8b/0xc0
[  169.576609]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576611]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576613]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576614]  [<ffffffff810f0872>] ? futex_wake+0x72/0x140
[  169.576616]  [<ffffffff811b7246>] ? kmem_cache_alloc_trace+0x1d6/0x200
[  169.576618]  [<ffffffff812cbfac>] ? selinux_file_alloc_security+0x3c/0x60
[  169.576620]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.576622]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.576624]  [<ffffffff811ed7a5>] ? __fget_light+0x25/0x70
[  169.576626]  [<ffffffff81583075>] ? __sys_sendmsg+0x65/0x80
[  169.576628]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.576630]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576631] rtkit-daemon    S ffff88048f294640     0   858      1 0x00000080
[  169.576633]  ffff880475b33a60 0000000000000082 ffff880472cddd20 ffff880475b33fd8
[  169.576634]  0000000000014640 0000000000014640 ffff880478d56670 0000000000000000
[  169.576636]  0000000000000000 ffff880475b33bb4 ffff880475b33bb4 0000000000000000
[  169.576638] Call Trace:
[  169.576640]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576642]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.576644]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.576646]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.576648]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.576650]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.576652]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.576654]  [<ffffffff8163fec6>] ? unix_stream_sendmsg+0x3c6/0x400
[  169.576656]  [<ffffffff81581eeb>] ? sock_sendmsg+0x8b/0xc0
[  169.576658]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576660]  [<ffffffff812d41d9>] ? hashtab_search+0x59/0x80
[  169.576662]  [<ffffffff81581c2e>] ? move_addr_to_kernel.part.19+0x1e/0x60
[  169.576664]  [<ffffffff81582991>] ? move_addr_to_kernel+0x21/0x30
[  169.576666]  [<ffffffff815822e3>] ? ___sys_sendmsg+0x373/0x380
[  169.576668]  [<ffffffff8121115f>] ? fsnotify_clear_marks_by_inode+0x2f/0x110
[  169.576670]  [<ffffffff811eb7ed>] ? evict+0xfd/0x160
[  169.576672]  [<ffffffff811e664f>] ? __d_free+0x3f/0x60
[  169.576674]  [<ffffffff811e76b5>] ? dentry_kill+0x205/0x280
[  169.576676]  [<ffffffff811efc34>] ? mntput+0x24/0x40
[  169.576678]  [<ffffffff811d31ca>] ? __fput+0x17a/0x1e0
[  169.576680]  [<ffffffff811ed7a5>] ? __fget_light+0x25/0x70
[  169.576682]  [<ffffffff81583075>] ? __sys_sendmsg+0x65/0x80
[  169.576684]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.576685]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576686] rtkit-daemon    S ffff88048f294640     0   886      1 0x00000080
[  169.576688]  ffff8804751afa60 0000000000000082 ffff8800648b53d0 ffff8804751affd8
[  169.576690]  0000000000014640 0000000000014640 ffff880472852540 ffff8804751afb98
[  169.576692]  000000009502f900 0000000000000000 ffff8804751afbb4 0000000000000000
[  169.576694] Call Trace:
[  169.576696]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576698]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.576699]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.576701]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.576703]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.576705]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.576707]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.576710]  [<ffffffff81216bd3>] ? ep_poll_callback+0xf3/0x160
[  169.576712]  [<ffffffff810c77e8>] ? __wake_up_common+0x58/0x90
[  169.576715]  [<ffffffff81332c20>] ? timerqueue_add+0x60/0xb0
[  169.576716]  [<ffffffff810a7fb5>] ? enqueue_hrtimer+0x25/0x80
[  169.576718]  [<ffffffff810a88b6>] ? __hrtimer_start_range_ns+0x1e6/0x3a0
[  169.576720]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576723]  [<ffffffff81040047>] ? native_smp_send_reschedule+0x47/0x60
[  169.576724]  [<ffffffff810b1c0c>] ? resched_task+0x4c/0x60
[  169.576726]  [<ffffffff810b2695>] ? check_preempt_curr+0x75/0xa0
[  169.576728]  [<ffffffff810b26fc>] ? ttwu_do_wakeup+0x3c/0xc0
[  169.576730]  [<ffffffff810b282d>] ? ttwu_do_activate.constprop.97+0x5d/0x70
[  169.576732]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.576734]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.576735]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.576737]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.576739]  [<ffffffff810c77e8>] ? __wake_up_common+0x58/0x90
[  169.576741]  [<ffffffff81210898>] ? fsnotify+0x228/0x2f0
[  169.576743]  [<ffffffff810c7858>] ? __wake_up_locked_key+0x18/0x20
[  169.576744]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.576746]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.576748]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.576750]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576751] rtkit-daemon    S ffff88048f354640     0   887      1 0x00000080
[  169.576752]  ffff88047090da60 0000000000000082 ffff8800648b4a80 ffff88047090dfd8
[  169.576754]  0000000000014640 0000000000014640 ffff880472ee5d20 ffff88047090db98
[  169.576756]  0000000000000000 0000000000000000 ffff88047090dbbc 0000000000000000
[  169.576758] Call Trace:
[  169.576760]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576762]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.576764]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.576766]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.576768]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.576770]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.576772]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.576774]  [<ffffffff81216bd3>] ? ep_poll_callback+0xf3/0x160
[  169.576776]  [<ffffffff810c77e8>] ? __wake_up_common+0x58/0x90
[  169.576778]  [<ffffffff810c7c70>] ? __wake_up_sync_key+0x50/0x60
[  169.576779]  [<ffffffff8158497a>] ? sock_def_readable+0x3a/0x70
[  169.576782]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576784]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576786]  [<ffffffff81581eeb>] ? sock_sendmsg+0x8b/0xc0
[  169.576788]  [<ffffffff811ed7a5>] ? __fget_light+0x25/0x70
[  169.576789]  [<ffffffff811ed803>] ? __fdget+0x13/0x20
[  169.576791]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.576793]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.576794]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.576796]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.576798]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576799] rngd            S ffff88048f3d4640     0   859      1 0x00000080
[  169.576801]  ffff880476f59a60 0000000000000082 ffff880472cdefc0 ffff880476f59fd8
[  169.576802]  0000000000014640 0000000000014640 ffff880472855d20 0000000000000000
[  169.576804]  0000000000000000 ffff880476f59bb4 ffff880476f59bb4 0000000000000000
[  169.576806] Call Trace:
[  169.576808]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576810]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.576812]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.576814]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.576816]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.576818]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.576820]  [<ffffffff8133bd79>] ? flex_array_get_ptr+0x9/0x20
[  169.576822]  [<ffffffff810bd877>] ? update_curr+0x67/0x160
[  169.576824]  [<ffffffff810b9338>] ? __enqueue_entity+0x78/0x80
[  169.576825]  [<ffffffff810bf917>] ? enqueue_entity+0x237/0x8c0
[  169.576828]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576830]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576832]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.576833]  [<ffffffff810b4e13>] ? wake_up_process+0x23/0x40
[  169.576835]  [<ffffffff8109b894>] ? wake_up_worker+0x24/0x30
[  169.576837]  [<ffffffff8109c3e2>] ? insert_work+0x62/0xa0
[  169.576839]  [<ffffffff8109c546>] ? __queue_work+0x126/0x310
[  169.576841]  [<ffffffff81416a8d>] ? credit_entropy_bits+0x1fd/0x2d0
[  169.576843]  [<ffffffff81417000>] ? random_ioctl+0x170/0x1b0
[  169.576844]  [<ffffffff81417000>] ? random_ioctl+0x170/0x1b0
[  169.576846]  [<ffffffff811e3ea8>] ? do_vfs_ioctl+0x2d8/0x4b0
[  169.576848]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.576850]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576851] avahi-daemon    S ffff88048f214640     0   861      1 0x00000080
[  169.576852]  ffff880476f83a60 0000000000000086 ffff880476f08000 ffff880476f83fd8
[  169.576854]  0000000000014640 0000000000014640 ffffffff81c16460 ffff880476f83b98
[  169.576856]  0000000005b7b307 0000000000000000 ffff880476f83bec 0000000000000000
[  169.576858] Call Trace:
[  169.576860]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576862]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.576864]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.576866]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.576868]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.576869]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.576871]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.576874]  [<ffffffff81601bf0>] ? udp_recvmsg+0x170/0x380
[  169.576876]  [<ffffffff8160cccc>] ? inet_recvmsg+0x6c/0x80
[  169.576878]  [<ffffffff8158251a>] ? sock_recvmsg+0x9a/0xd0
[  169.576880]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576882]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576884]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576886]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576888]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576890]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576892]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576894]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576896]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.576897]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.576899]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.576901]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576902] irqbalance      S ffff88048f214640     0   862      1 0x00000080
[  169.576903]  ffff880476f85e68 0000000000000086 ffff880476f08950 ffff880476f85fd8
[  169.576905]  0000000000014640 0000000000014640 ffff8804728537e0 ffff880476f85ec8
[  169.576907]  ffff880476f08950 ffff880476f08950 ffff880476f08950 ffff880476f08950
[  169.576909] Call Trace:
[  169.576911]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576913]  [<ffffffff816a1815>] do_nanosleep+0xc5/0x130
[  169.576915]  [<ffffffff810a9346>] hrtimer_nanosleep+0xa6/0x160
[  169.576916]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.576918]  [<ffffffff816a17c1>] ? do_nanosleep+0x71/0x130
[  169.576920]  [<ffffffff810a9466>] SyS_nanosleep+0x66/0x80
[  169.576922]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576923] chronyd         S ffff88048f214640     0   867      1 0x00000080
[  169.576925]  ffff88047759f928 0000000000000082 ffff8804750e8000 ffff88047759ffd8
[  169.576926]  0000000000014640 0000000000014640 ffff8804728537e0 ffff88047759fae8
[  169.576928]  0000000003d68268 0000000000000000 0000000000000006 0000000000000006
[  169.576930] Call Trace:
[  169.576932]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576934]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.576936]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.576938]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.576940]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.576942]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.576943]  [<ffffffff811e530e>] do_select+0x5ae/0x770
[  169.576946]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576948]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576950]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576952]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.576954]  [<ffffffff811b7042>] ? kmem_cache_alloc+0x1c2/0x1f0
[  169.576956]  [<ffffffff8169de43>] ? avc_alloc_node+0x24/0x125
[  169.576957]  [<ffffffff8169e0e7>] ? avc_compute_av+0x1a3/0x1b5
[  169.576959]  [<ffffffff812c7b54>] ? avc_has_perm_noaudit+0xc4/0x110
[  169.576961]  [<ffffffff812cb07c>] ? cred_has_capability+0x5c/0x100
[  169.576963]  [<ffffffff811e569c>] core_sys_select+0x1cc/0x2e0
[  169.576965]  [<ffffffff810e79a3>] ? ntp_notify_cmos_timer+0x23/0x30
[  169.576967]  [<ffffffff810e748c>] ? do_adjtimex+0xec/0x100
[  169.576969]  [<ffffffff81087d9d>] ? SYSC_adjtimex+0x4d/0x80
[  169.576971]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.576972]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.576974]  [<ffffffff811e585b>] SyS_select+0xab/0x100
[  169.576976]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.576977] avahi-daemon    S ffff88048f2d4640     0   868    861 0x00000080
[  169.576978]  ffff880473717bf0 0000000000000082 ffff88047537dd20 ffff880473717fd8
[  169.576980]  0000000000014640 0000000000014640 ffff8800648b4130 ffff880472b37000
[  169.576982]  7fffffffffffffff ffff88047537dd20 ffff880472b37308 ffff88047537dd20
[  169.576984] Call Trace:
[  169.576986]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.576988]  [<ffffffff816a1679>] schedule_timeout+0x1f9/0x270
[  169.576990]  [<ffffffff810c7b16>] ? prepare_to_wait+0x56/0x90
[  169.576992]  [<ffffffff816401e4>] unix_stream_recvmsg+0x2e4/0x880
[  169.576994]  [<ffffffff810c7eb0>] ? abort_exclusive_wait+0xb0/0xb0
[  169.576996]  [<ffffffff8158122e>] sock_aio_read.part.10+0xfe/0x120
[  169.576998]  [<ffffffff81581271>] sock_aio_read+0x21/0x40
[  169.577000]  [<ffffffff811d0f2a>] do_sync_read+0x5a/0x90
[  169.577002]  [<ffffffff811d1655>] vfs_read+0x145/0x160
[  169.577003]  [<ffffffff811d21c6>] SyS_read+0x46/0xb0
[  169.577005]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.577007]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577008] ModemManager    S ffff88048f254640     0   870      1 0x00000080
[  169.577010]  ffff880064aefa60 0000000000000086 ffff8800648b6670 ffff880064aeffd8
[  169.577011]  0000000000014640 0000000000014640 ffff880478d55d20 0000000000000000
[  169.577013]  0000000000000000 ffff880064aefbbc ffff880064aefbbc 0000000000000000
[  169.577015] Call Trace:
[  169.577017]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577019]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577021]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.577023]  [<ffffffff816a508a>] ? _raw_spin_unlock_bh+0x1a/0x20
[  169.577025]  [<ffffffff815c68ee>] ? netlink_poll+0x13e/0x1e0
[  169.577027]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577029]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577031]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577033]  [<ffffffff815c54d4>] ? netlink_rcv_wake+0x44/0x60
[  169.577035]  [<ffffffff815c65b7>] ? netlink_recvmsg+0x1c7/0x3c0
[  169.577037]  [<ffffffff8158251a>] ? sock_recvmsg+0x9a/0xd0
[  169.577039]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577041]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577043]  [<ffffffff81580e12>] ? move_addr_to_user+0xb2/0xd0
[  169.577045]  [<ffffffff81582824>] ? ___sys_recvmsg+0x144/0x290
[  169.577047]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.577049]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.577050]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.577052]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.577054]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577056]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577057] gmain           S ffff88048f254640     0   875      1 0x00000080
[  169.577058]  ffff880471821a60 0000000000000086 ffff8804730add20 ffff880471821fd8
[  169.577060]  0000000000014640 0000000000014640 ffff8804730ac130 0000000000000000
[  169.577062]  0000000000000000 ffff880471821bb4 ffff880471821bb4 0000000000000000
[  169.577064] Call Trace:
[  169.577066]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577068]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577070]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577072]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577074]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577076]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577078]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.577079]  [<ffffffff8120d940>] ? mpage_alloc+0x90/0x90
[  169.577082]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577084]  [<ffffffff811c69d0>] ? __mem_cgroup_commit_charge+0x150/0x2d0
[  169.577086]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  169.577088]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  169.577089]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.577091]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.577093]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.577095]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.577097]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577098]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577099] gdbus           S ffff88048f2d4640     0   882      1 0x00000080
[  169.577101]  ffff880472f25a60 0000000000000086 ffff880472ae2540 ffff880472f25fd8
[  169.577103]  0000000000014640 0000000000014640 ffff880478d56fc0 0000000000000000
[  169.577105]  0000000000000000 ffff880472f25bc4 ffff880472f25bc4 0000000000000000
[  169.577107] Call Trace:
[  169.577109]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577110]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577112]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577114]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577116]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577118]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577120]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577122]  [<ffffffff8163fec6>] ? unix_stream_sendmsg+0x3c6/0x400
[  169.577124]  [<ffffffff81581eeb>] ? sock_sendmsg+0x8b/0xc0
[  169.577126]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577128]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577130]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577132]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.577134]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.577136]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.577138]  [<ffffffff811b7246>] ? kmem_cache_alloc_trace+0x1d6/0x200
[  169.577140]  [<ffffffff812cbfac>] ? selinux_file_alloc_security+0x3c/0x60
[  169.577142]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.577143]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.577145]  [<ffffffff811ed7a5>] ? __fget_light+0x25/0x70
[  169.577147]  [<ffffffff81583075>] ? __sys_sendmsg+0x65/0x80
[  169.577149]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577151]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577152] dbus-daemon     S ffff88048f3d4640     0   872      1 0x00000080
[  169.577154]  ffff880035db7dd8 0000000000000086 ffff8800648b6fc0 ffff880035db7fd8
[  169.577155]  0000000000014640 0000000000014640 ffff8800648b4130 0000000000000000
[  169.577157]  0000000000000000 ffff880472ed3420 ffff8800648b6fc0 0000000000000000
[  169.577159] Call Trace:
[  169.577161]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577163]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577165]  [<ffffffff811b62ba>] ? kmem_cache_free+0x1da/0x200
[  169.577167]  [<ffffffff811e664f>] ? __d_free+0x3f/0x60
[  169.577169]  [<ffffffff811e76b5>] ? dentry_kill+0x205/0x280
[  169.577171]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577173]  [<ffffffff812169ce>] ep_poll+0x21e/0x330
[  169.577175]  [<ffffffff811efc34>] ? mntput+0x24/0x40
[  169.577177]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.577179]  [<ffffffff81217dc5>] SyS_epoll_wait+0xb5/0xe0
[  169.577181]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.577183]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577184] dbus-daemon     S ffff88048f294640     0   881      1 0x00000080
[  169.577185]  ffff880473ba1a60 0000000000000086 ffff880472ae2e90 ffff880473ba1fd8
[  169.577187]  0000000000014640 0000000000014640 ffff880478d50000 0000000000000000
[  169.577189]  0000000000000000 ffff880473ba1bb4 ffff880473ba1bb4 0000000000000000
[  169.577191] Call Trace:
[  169.577193]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577195]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577197]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.577198]  [<ffffffff816a508a>] ? _raw_spin_unlock_bh+0x1a/0x20
[  169.577200]  [<ffffffff815c68ee>] ? netlink_poll+0x13e/0x1e0
[  169.577202]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577204]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577206]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577208]  [<ffffffff810b9338>] ? __enqueue_entity+0x78/0x80
[  169.577210]  [<ffffffff810bf917>] ? enqueue_entity+0x237/0x8c0
[  169.577212]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577214]  [<ffffffff810b2695>] ? check_preempt_curr+0x75/0xa0
[  169.577215]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.577217]  [<ffffffff810b282d>] ? ttwu_do_activate.constprop.97+0x5d/0x70
[  169.577219]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.577221]  [<ffffffff810b4e40>] ? wake_up_state+0x10/0x20
[  169.577222]  [<ffffffff810f07d6>] ? wake_futex+0x66/0x90
[  169.577224]  [<ffffffff810f0872>] ? futex_wake+0x72/0x140
[  169.577225]  [<ffffffff810f278a>] ? do_futex+0x10a/0xb00
[  169.577228]  [<ffffffff8101d438>] ? __restore_xstate_sig+0x88/0x510
[  169.577230]  [<ffffffff811b7042>] ? kmem_cache_alloc+0x1c2/0x1f0
[  169.577231]  [<ffffffff81091869>] ? alloc_uid+0x79/0x110
[  169.577233]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.577235]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577237]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577238] systemd-logind  S ffff88048f3d4640     0   873      1 0x00000080
[  169.577240]  ffff880470f7ddd8 0000000000000086 ffff8800648b4130 ffff880470f7dfd8
[  169.577241]  0000000000014640 0000000000014640 ffff880476f08000 0000000000000000
[  169.577243]  0000000000000000 ffff880471ad1120 ffff8800648b4130 0000000000000000
[  169.577245] Call Trace:
[  169.577247]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577249]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577251]  [<ffffffff81216769>] ? ep_scan_ready_list.isra.9+0x199/0x1c0
[  169.577253]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577255]  [<ffffffff812169ce>] ep_poll+0x21e/0x330
[  169.577257]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.577259]  [<ffffffff81217dc5>] SyS_epoll_wait+0xb5/0xe0
[  169.577261]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.577263]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577264] atd             S ffff88048f254640     0   878      1 0x00000080
[  169.577266]  ffff880472a8be68 0000000000000082 ffff8804750eb7e0 ffff880472a8bfd8
[  169.577267]  0000000000014640 0000000000014640 ffff880478d55d20 ffff880472a8bec8
[  169.577269]  ffff8804750eb7e0 ffff8804750eb7e0 ffff8804750eb7e0 ffff8804750eb7e0
[  169.577271] Call Trace:
[  169.577273]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577275]  [<ffffffff816a1815>] do_nanosleep+0xc5/0x130
[  169.577277]  [<ffffffff810a9346>] hrtimer_nanosleep+0xa6/0x160
[  169.577279]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.577280]  [<ffffffff816a17c1>] ? do_nanosleep+0x71/0x130
[  169.577282]  [<ffffffff810a9466>] SyS_nanosleep+0x66/0x80
[  169.577284]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577285] crond           S ffff88048f214640     0   879      1 0x00000080
[  169.577287]  ffff880472bb9e68 0000000000000086 ffff8804750ec130 ffff880472bb9fd8
[  169.577288]  0000000000014640 0000000000014640 ffffffff81c16460 ffff880472bb9ec8
[  169.577290]  ffff8804750ec130 ffff8804750ec130 ffff8804750ec130 ffff8804750ec130
[  169.577292] Call Trace:
[  169.577294]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577296]  [<ffffffff816a1815>] do_nanosleep+0xc5/0x130
[  169.577298]  [<ffffffff810a9346>] hrtimer_nanosleep+0xa6/0x160
[  169.577299]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.577301]  [<ffffffff816a17c1>] ? do_nanosleep+0x71/0x130
[  169.577303]  [<ffffffff810a9466>] SyS_nanosleep+0x66/0x80
[  169.577304]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577306] mcelog          S ffff88048f254640     0   891      1 0x00000080
[  169.577307]  ffff880477df9a30 0000000000000082 ffff8804730a92a0 ffff880477df9fd8
[  169.577309]  0000000000014640 0000000000014640 ffff880478d55d20 0000000000000000
[  169.577311]  0000000000000000 ffff880477df9b8c ffff880477df9b8c 0000000000000000
[  169.577312] Call Trace:
[  169.577314]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577316]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577318]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577320]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577322]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577324]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577326]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577329]  [<ffffffff811785ef>] ? shmem_alloc_page+0x5f/0x90
[  169.577331]  [<ffffffff8132fd62>] ? radix_tree_insert+0x32/0xe0
[  169.577333]  [<ffffffff8117fcc5>] ? __inc_zone_page_state+0x35/0x40
[  169.577335]  [<ffffffff811c2c0e>] ? lookup_page_cgroup_used+0xe/0x30
[  169.577337]  [<ffffffff811ca4f1>] ? mem_cgroup_bad_page_check+0x21/0x30
[  169.577339]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577341]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577343]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  169.577345]  [<ffffffff8119f925>] ? free_pages_and_swap_cache+0x95/0xb0
[  169.577346]  [<ffffffff8118896c>] ? tlb_flush_mmu_free+0x2c/0x50
[  169.577348]  [<ffffffff81189210>] ? tlb_flush_mmu+0x20/0x30
[  169.577350]  [<ffffffff81189234>] ? tlb_finish_mmu+0x14/0x40
[  169.577351]  [<ffffffff811919a3>] ? unmap_region+0xd3/0x110
[  169.577353]  [<ffffffff810927ab>] ? recalc_sigpending+0x1b/0x50
[  169.577355]  [<ffffffff810930b2>] ? __set_task_blocked+0x32/0x70
[  169.577357]  [<ffffffff810962c8>] ? do_sigaction+0x88/0x1c0
[  169.577359]  [<ffffffff81095806>] ? __set_current_blocked+0x36/0x50
[  169.577361]  [<ffffffff811e623f>] SyS_ppoll+0xbf/0x1c0
[  169.577363]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.577364]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577365] abrtd           S ffff88048f2d4640     0   893      1 0x00000080
[  169.577367]  ffff880473129a60 0000000000000086 ffff8804730a9bf0 ffff880473129fd8
[  169.577369]  0000000000014640 0000000000014640 ffff880478d56fc0 0000000000000000
[  169.577371]  0000000000000000 ffff880473129bcc ffff880473129bcc 0000000000000000
[  169.577373] Call Trace:
[  169.577375]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577377]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577379]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577381]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577382]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577384]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577386]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577389]  [<ffffffff812dc877>] ? type_attribute_bounds_av.isra.10+0x57/0x2b0
[  169.577390]  [<ffffffff81332f52>] ? put_dec+0x72/0x90
[  169.577392]  [<ffffffff81333e20>] ? number.isra.2+0x2f0/0x320
[  169.577394]  [<ffffffff8121115f>] ? fsnotify_clear_marks_by_inode+0x2f/0x110
[  169.577396]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577398]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577400]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577402]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577404]  [<ffffffff810e29b7>] ? call_rcu_sched+0x17/0x20
[  169.577406]  [<ffffffff8108515b>] ? release_task+0x2db/0x440
[  169.577408]  [<ffffffff81085b53>] ? wait_consider_task+0x893/0xaf0
[  169.577409]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.577411]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.577413]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.577415]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577416]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577417] abrt-watch-log  S ffff88048f354640     0   894      1 0x00000080
[  169.577419]  ffff88047744be40 0000000000000086 ffff8804730a8000 ffff88047744bfd8
[  169.577421]  0000000000014640 0000000000014640 ffff880478e18950 ffff880472f39800
[  169.577423]  00007fff43f48b60 ffff88047744bf50 0000000000000000 00007fff43f48b60
[  169.577424] Call Trace:
[  169.577426]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577428]  [<ffffffff8121329a>] inotify_read+0x29a/0x3b0
[  169.577431]  [<ffffffff810c7eb0>] ? abort_exclusive_wait+0xb0/0xb0
[  169.577432]  [<ffffffff811d15ab>] vfs_read+0x9b/0x160
[  169.577434]  [<ffffffff811d21c6>] SyS_read+0x46/0xb0
[  169.577436]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.577437]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577438] abrt-watch-log  S ffff88048f254640     0   895      1 0x00000080
[  169.577440]  ffff880473bede68 0000000000000082 ffff8804730aefc0 ffff880473bedfd8
[  169.577442]  0000000000014640 0000000000014640 ffff880478d55d20 ffff880473bedec8
[  169.577444]  ffff8804730aefc0 ffff8804730aefc0 ffff8804730aefc0 ffff8804730aefc0
[  169.577446] Call Trace:
[  169.577447]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577449]  [<ffffffff816a1815>] do_nanosleep+0xc5/0x130
[  169.577451]  [<ffffffff810a9346>] hrtimer_nanosleep+0xa6/0x160
[  169.577453]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.577455]  [<ffffffff816a17c1>] ? do_nanosleep+0x71/0x130
[  169.577456]  [<ffffffff810a9466>] SyS_nanosleep+0x66/0x80
[  169.577458]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577459] gdm             S ffff88048f354640     0   897      1 0x00000080
[  169.577461]  ffff8804741c9a60 0000000000000082 ffff880477629bf0 ffff8804741c9fd8
[  169.577463]  0000000000014640 0000000000014640 ffff880478e18950 0000000000000000
[  169.577464]  0000000000000000 ffff8804741c9bb4 ffff8804741c9bb4 0000000000000000
[  169.577466] Call Trace:
[  169.577468]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577470]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577472]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577474]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577476]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577478]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577480]  [<ffffffff8132fd62>] ? radix_tree_insert+0x32/0xe0
[  169.577482]  [<ffffffff8132fed3>] ? radix_tree_lookup_slot+0x13/0x30
[  169.577485]  [<ffffffff81161aae>] ? find_get_entry+0x1e/0xc0
[  169.577487]  [<ffffffff81161d50>] ? find_lock_entry+0x30/0x80
[  169.577489]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577491]  [<ffffffff810b2695>] ? check_preempt_curr+0x75/0xa0
[  169.577493]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.577494]  [<ffffffff810b282d>] ? ttwu_do_activate.constprop.97+0x5d/0x70
[  169.577496]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.577498]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.577500]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.577502]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.577504]  [<ffffffff810c77e8>] ? __wake_up_common+0x58/0x90
[  169.577505]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.577507]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.577509]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577511]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577512] gdbus           S ffff88048f2d4640     0   908      1 0x00000080
[  169.577513]  ffff880475327a60 0000000000000082 ffff880035e0ca80 ffff880475327fd8
[  169.577515]  0000000000014640 0000000000014640 ffff880478d56fc0 0000000000000000
[  169.577517]  0000000000000000 ffff880475327bc4 ffff880475327bc4 0000000000000000
[  169.577519] Call Trace:
[  169.577521]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577523]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577524]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577526]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577528]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577530]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577532]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577535]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577537]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577539]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577541]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.577542]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.577544]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.577546]  [<ffffffff811b7246>] ? kmem_cache_alloc_trace+0x1d6/0x200
[  169.577548]  [<ffffffff812cbfac>] ? selinux_file_alloc_security+0x3c/0x60
[  169.577550]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.577552]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.577554]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.577555]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577557]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577558] gmain           S ffff88048f254640     0   911      1 0x00000080
[  169.577560]  ffff880475225a60 0000000000000082 ffff880035e0efc0 ffff880475225fd8
[  169.577562]  0000000000014640 0000000000014640 ffff88047762d3d0 0000000000000000
[  169.577563]  0000000000000000 ffff880475225bb4 ffff880475225bb4 0000000000000000
[  169.577565] Call Trace:
[  169.577567]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577569]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577571]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577573]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577575]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577577]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577579]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.577581]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577583]  [<ffffffff811c69d0>] ? __mem_cgroup_commit_charge+0x150/0x2d0
[  169.577585]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  169.577587]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  169.577588]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.577590]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.577592]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.577594]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.577596]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577597]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577598] gdm-simple-slav S ffff88048f354640     0   913    897 0x00000080
[  169.577600]  ffff8804743bda60 0000000000000082 ffff880035e0ae90 ffff8804743bdfd8
[  169.577602]  0000000000014640 0000000000014640 ffff880478e18950 0000000000000000
[  169.577604]  0000000000000000 ffff8804743bdbd4 ffff8804743bdbd4 0000000000000000
[  169.577606] Call Trace:
[  169.577608]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577610]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577611]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577613]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577615]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577617]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577619]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577621]  [<ffffffff81332f52>] ? put_dec+0x72/0x90
[  169.577622]  [<ffffffff81333e20>] ? number.isra.2+0x2f0/0x320
[  169.577625]  [<ffffffff8169ca7c>] ? __slab_free+0xfe/0x252
[  169.577627]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577629]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577631]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577633]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577635]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577637]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.577638]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.577640]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.577642]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577644]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577645] gdbus           S ffff88048f354640     0   915    897 0x00000080
[  169.577646]  ffff8800655d1a60 0000000000000082 ffff880035e0c130 ffff8800655d1fd8
[  169.577648]  0000000000014640 0000000000014640 ffff880035e0ae90 0000000000000000
[  169.577650]  0000000000000000 ffff8800655d1bd4 ffff8800655d1bd4 0000000000000000
[  169.577652] Call Trace:
[  169.577654]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577656]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577658]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577660]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577662]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577663]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577665]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577667]  [<ffffffff810bd877>] ? update_curr+0x67/0x160
[  169.577669]  [<ffffffff810bdc5e>] ? update_cfs_shares+0xae/0x100
[  169.577671]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577673]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577675]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577677]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577679]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577681]  [<ffffffff811b62ba>] ? kmem_cache_free+0x1da/0x200
[  169.577683]  [<ffffffff811e664f>] ? __d_free+0x3f/0x60
[  169.577685]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.577687]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.577689]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577690]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577691] gmain           S ffff88048f2d4640     0   916    897 0x00000080
[  169.577693]  ffff880035d03a60 0000000000000082 ffff880035e0b7e0 ffff880035d03fd8
[  169.577695]  0000000000014640 0000000000014640 ffff880478d56fc0 0000000000000000
[  169.577697]  0000000000000000 ffff880035d03bb4 ffff880035d03bb4 0000000000000000
[  169.577698] Call Trace:
[  169.577700]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577702]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577704]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577706]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577708]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577710]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577712]  [<ffffffff812dc877>] ? type_attribute_bounds_av.isra.10+0x57/0x2b0
[  169.577714]  [<ffffffff81332f52>] ? put_dec+0x72/0x90
[  169.577715]  [<ffffffff81333e20>] ? number.isra.2+0x2f0/0x320
[  169.577717]  [<ffffffff812dbf2f>] ? constraint_expr_eval+0x8f/0x540
[  169.577719]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577721]  [<ffffffff81161d0a>] ? unlock_page+0x2a/0x40
[  169.577723]  [<ffffffff8118ab5f>] ? do_wp_page+0x38f/0x770
[  169.577724]  [<ffffffff8169e0e7>] ? avc_compute_av+0x1a3/0x1b5
[  169.577726]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  169.577728]  [<ffffffff812cc2b0>] ? selinux_task_wait+0x40/0x50
[  169.577730]  [<ffffffff812c6056>] ? security_task_wait+0x16/0x20
[  169.577732]  [<ffffffff81085345>] ? wait_consider_task+0x85/0xaf0
[  169.577733]  [<ffffffff81341b3d>] ? list_del+0xd/0x30
[  169.577735]  [<ffffffff810c7c11>] ? remove_wait_queue+0x31/0x40
[  169.577737]  [<ffffffff81085edb>] ? do_wait+0x12b/0x240
[  169.577739]  [<ffffffff81086fbf>] ? SyS_wait4+0x6f/0xe0
[  169.577741]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577742]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577743] polkitd         S ffff88048f3d4640     0   914      1 0x00000080
[  169.577745]  ffff880471b93a60 0000000000000086 ffff880035e0dd20 ffff880471b93fd8
[  169.577747]  0000000000014640 0000000000014640 ffff880471994a80 0000000000000000
[  169.577748]  0000000000000000 ffff880471b93bbc ffff880471b93bbc 0000000000000000
[  169.577750] Call Trace:
[  169.577752]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577754]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577756]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577758]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577760]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577762]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577764]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.577766]  [<ffffffff810b282d>] ? ttwu_do_activate.constprop.97+0x5d/0x70
[  169.577767]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.577769]  [<ffffffff811c2c0e>] ? lookup_page_cgroup_used+0xe/0x30
[  169.577771]  [<ffffffff811ca4f1>] ? mem_cgroup_bad_page_check+0x21/0x30
[  169.577773]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577775]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577777]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.577779]  [<ffffffff810b282d>] ? ttwu_do_activate.constprop.97+0x5d/0x70
[  169.577781]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.577783]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.577785]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.577786]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.577788]  [<ffffffff810c77e8>] ? __wake_up_common+0x58/0x90
[  169.577790]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.577792]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.577794]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577795]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577796] gmain           S ffff88048f294640     0   917      1 0x00000080
[  169.577798]  ffff880064b37a60 0000000000000086 ffff880472ae0000 ffff880064b37fd8
[  169.577800]  0000000000014640 0000000000014640 ffff880478d56670 0000000000000000
[  169.577802]  0000000000000000 ffff880064b37bbc ffff880064b37bbc 0000000000000000
[  169.577803] Call Trace:
[  169.577805]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577807]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577809]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577811]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577813]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577815]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577817]  [<ffffffff81332f52>] ? put_dec+0x72/0x90
[  169.577818]  [<ffffffff81333e20>] ? number.isra.2+0x2f0/0x320
[  169.577820]  [<ffffffff8121115f>] ? fsnotify_clear_marks_by_inode+0x2f/0x110
[  169.577822]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577824]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577826]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  169.577828]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.577830]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.577832]  [<ffffffff81210898>] ? fsnotify+0x228/0x2f0
[  169.577833]  [<ffffffff811d17cc>] ? vfs_write+0x15c/0x1e0
[  169.577835]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577837]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577838] gdbus           S ffff88048f3d4640     0   918      1 0x00000080
[  169.577840]  ffff880064a73a60 0000000000000086 ffff880472ae6670 ffff880064a73fd8
[  169.577841]  0000000000014640 0000000000014640 ffff880035e0dd20 0000000000000000
[  169.577843]  0000000000000000 ffff880064a73bc4 ffff880064a73bc4 0000000000000000
[  169.577845] Call Trace:
[  169.577847]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577849]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577851]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577853]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577855]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577857]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577859]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577861]  [<ffffffff810bd877>] ? update_curr+0x67/0x160
[  169.577862]  [<ffffffff810bdc5e>] ? update_cfs_shares+0xae/0x100
[  169.577864]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577866]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577869]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577870]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.577872]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.577874]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.577876]  [<ffffffff811b7246>] ? kmem_cache_alloc_trace+0x1d6/0x200
[  169.577878]  [<ffffffff812cbfac>] ? selinux_file_alloc_security+0x3c/0x60
[  169.577880]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.577882]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.577883]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.577885]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577887]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577888] JS GC Helper    S ffff88048f354640     0   922      1 0x00000080
[  169.577890]  ffff880470407ca8 0000000000000086 ffff88047537e670 ffff880470407fd8
[  169.577891]  0000000000014640 0000000000014640 ffff880478e18950 ffff88047537e670
[  169.577893]  0000000000000000 ffffc900018d7a00 ffff88047537e670 ffff880470407db8
[  169.577895] Call Trace:
[  169.577897]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577899]  [<ffffffff810f035a>] futex_wait_queue_me+0xda/0x140
[  169.577900]  [<ffffffff810f0635>] futex_wait+0x165/0x250
[  169.577902]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  169.577904]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  169.577906]  [<ffffffff810f2766>] do_futex+0xe6/0xb00
[  169.577908]  [<ffffffff812c9bdb>] ? selinux_cred_prepare+0x1b/0x30
[  169.577910]  [<ffffffff810e29b7>] ? call_rcu_sched+0x17/0x20
[  169.577911]  [<ffffffff810f31f1>] SyS_futex+0x71/0x150
[  169.577913]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.577915]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577916] JS Sour~ Thread S ffff88048f3d4640     0   923      1 0x00000080
[  169.577918]  ffff880477fd5ca8 0000000000000086 ffff88047537ae90 ffff880477fd5fd8
[  169.577919]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff88047537ae90
[  169.577921]  0000000000000000 ffffc900018cf4c0 ffff88047537ae90 ffff880477fd5db8
[  169.577923] Call Trace:
[  169.577925]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577926]  [<ffffffff810f035a>] futex_wait_queue_me+0xda/0x140
[  169.577928]  [<ffffffff810f0635>] futex_wait+0x165/0x250
[  169.577930]  [<ffffffff81040047>] ? native_smp_send_reschedule+0x47/0x60
[  169.577932]  [<ffffffff810b1c0c>] ? resched_task+0x4c/0x60
[  169.577934]  [<ffffffff810b2695>] ? check_preempt_curr+0x75/0xa0
[  169.577935]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.577937]  [<ffffffff810f0177>] ? get_futex_key+0x1d7/0x2e0
[  169.577938]  [<ffffffff810f2766>] do_futex+0xe6/0xb00
[  169.577940]  [<ffffffff810bf35b>] ? put_prev_entity+0x5b/0x3b0
[  169.577942]  [<ffffffff810f31f1>] SyS_futex+0x71/0x150
[  169.577944]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.577945]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577946] runaway-killer- S ffff88048f294640     0   925      1 0x00000080
[  169.577948]  ffff8804712d7a60 0000000000000086 ffff880475378000 ffff8804712d7fd8
[  169.577950]  0000000000014640 0000000000014640 ffff880478d56670 0000000000000000
[  169.577952]  0000000000000000 ffff8804712d7bb4 ffff8804712d7bb4 0000000000000000
[  169.577954] Call Trace:
[  169.577956]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577958]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.577960]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.577962]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.577964]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.577965]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.577968]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.577970]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  169.577971]  [<ffffffff811c2098>] ? do_huge_pmd_wp_page+0x728/0x9b0
[  169.577973]  [<ffffffff8118d718>] ? handle_mm_fault+0x7a8/0x1070
[  169.577975]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.577977]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.577978]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.577980]  [<ffffffff8121a59d>] ? eventfd_read+0x3d/0x70
[  169.577982]  [<ffffffff811d15ab>] ? vfs_read+0x9b/0x160
[  169.577984]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.577985]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.577986] NetworkManager  S ffff88048f2d4640     0   984      1 0x00000080
[  169.577988]  ffff88047348fa60 0000000000000086 ffff880035e09bf0 ffff88047348ffd8
[  169.577990]  0000000000014640 0000000000014640 ffff880478d56fc0 ffff88047348fb98
[  169.577992]  000000000098967f 0000000000000000 ffff88047348fc04 0000000000000000
[  169.577993] Call Trace:
[  169.577995]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.577997]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.577999]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.578001]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.578003]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578005]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578007]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578009]  [<ffffffff81663110>] ? rawv6_sendmsg+0x390/0xb70
[  169.578012]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578014]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578016]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578018]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578020]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578022]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578024]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578026]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578028]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578030]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578031]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578032] NetworkManager  S ffff88048f394640     0   989      1 0x00000080
[  169.578034]  ffff880473951db0 0000000000000086 ffff880472f94a80 ffff880473951fd8
[  169.578036]  0000000000014640 0000000000014640 ffff880478e192a0 ffff880472f94a80
[  169.578038]  7fffffffffffffff ffff880473951ed8 ffff880472f94a80 00007f5b41ea2700
[  169.578040] Call Trace:
[  169.578041]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578043]  [<ffffffff816a1679>] schedule_timeout+0x1f9/0x270
[  169.578045]  [<ffffffff811c2c0e>] ? lookup_page_cgroup_used+0xe/0x30
[  169.578047]  [<ffffffff810927ab>] ? recalc_sigpending+0x1b/0x50
[  169.578049]  [<ffffffff816a170e>] schedule_timeout_interruptible+0x1e/0x20
[  169.578051]  [<ffffffff81096011>] do_sigtimedwait+0x161/0x200
[  169.578053]  [<ffffffff81096126>] SYSC_rt_sigtimedwait+0x76/0xd0
[  169.578055]  [<ffffffff81080e52>] ? __mmdrop+0x62/0x90
[  169.578057]  [<ffffffff810b1438>] ? finish_task_switch+0xb8/0xf0
[  169.578059]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.578060]  [<ffffffff8109618e>] SyS_rt_sigtimedwait+0xe/0x10
[  169.578062]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578063] gmain           S ffff88048f2d4640     0  1070      1 0x00000080
[  169.578065]  ffff880471a57a60 0000000000000086 ffff880470fea540 ffff880471a57fd8
[  169.578066]  0000000000014640 0000000000014640 ffff880478d56fc0 0000000000000000
[  169.578068]  0000000000000000 ffff880471a57bbc ffff880471a57bbc 0000000000000000
[  169.578070] Call Trace:
[  169.578072]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578074]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578076]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578078]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578080]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578082]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578084]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.578086]  [<ffffffff8101a705>] ? native_sched_clock+0x35/0x90
[  169.578088]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578090]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578092]  [<ffffffff8169ca7c>] ? __slab_free+0xfe/0x252
[  169.578094]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  169.578096]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.578098]  [<ffffffff81212d9e>] ? inotify_free_event+0xe/0x10
[  169.578100]  [<ffffffff810c7de6>] ? finish_wait+0x56/0x70
[  169.578102]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.578103]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.578105]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.578107]  [<ffffffff8121a59d>] ? eventfd_read+0x3d/0x70
[  169.578108]  [<ffffffff811d15ab>] ? vfs_read+0x9b/0x160
[  169.578110]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578112]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578113] gdbus           S ffff88048f354640     0  1072      1 0x00000080
[  169.578115]  ffff880474399a60 0000000000000086 ffff880035e08000 ffff880474399fd8
[  169.578116]  0000000000014640 0000000000014640 ffff880478e18950 0000000000000000
[  169.578118]  0000000000000000 ffff880474399bc4 ffff880474399bc4 0000000000000000
[  169.578120] Call Trace:
[  169.578122]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578124]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578126]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578128]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578130]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578132]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578134]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578136]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578138]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578140]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578142]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.578144]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.578146]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.578148]  [<ffffffff811b7246>] ? kmem_cache_alloc_trace+0x1d6/0x200
[  169.578150]  [<ffffffff812cbfac>] ? selinux_file_alloc_security+0x3c/0x60
[  169.578152]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.578153]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.578155]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.578157]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578159]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578160] cfg80211        S ffff88048f394640     0  1066      2 0x00000080
[  169.578164]  ffff880470ef3e28 0000000000000046 ffff880472f953d0 ffff880470ef3fd8
[  169.578165]  0000000000014640 0000000000014640 ffff880478e192a0 ffff880475182980
[  169.578167]  ffff880472f953d0 ffffffff8109ea60 ffff880475308a80 0000000000000000
[  169.578169] Call Trace:
[  169.578171]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.578173]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578175]  [<ffffffff8109ecd1>] rescuer_thread+0x271/0x370
[  169.578177]  [<ffffffff8109ea60>] ? manage_workers.isra.25+0x2b0/0x2b0
[  169.578178]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.578180]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.578182]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.578183]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.578184] sshd            S ffff88048f214640     0  1090      1 0x00000080
[  169.578186]  ffff880478eef928 0000000000000082 ffff8804744d12a0 ffff880478eeffd8
[  169.578188]  0000000000014640 0000000000014640 ffffffff81c16460 0000000000000000
[  169.578190]  0000000000000040 0000000000000020 0000000000000005 0000000000000005
[  169.578191] Call Trace:
[  169.578193]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578195]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578197]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578199]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.578202]  [<ffffffff815e241b>] ? tcp_poll+0x5b/0x230
[  169.578204]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578206]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578208]  [<ffffffff811e530e>] do_select+0x5ae/0x770
[  169.578210]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578212]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578214]  [<ffffffff811785ef>] ? shmem_alloc_page+0x5f/0x90
[  169.578216]  [<ffffffff8132fd62>] ? radix_tree_insert+0x32/0xe0
[  169.578218]  [<ffffffff8117fcc5>] ? __inc_zone_page_state+0x35/0x40
[  169.578220]  [<ffffffff811c2c0e>] ? lookup_page_cgroup_used+0xe/0x30
[  169.578222]  [<ffffffff811ca4f1>] ? mem_cgroup_bad_page_check+0x21/0x30
[  169.578224]  [<ffffffff81168aab>] ? free_pages_prepare+0xab/0x1b0
[  169.578226]  [<ffffffff8116a086>] ? free_hot_cold_page_list+0x46/0xa0
[  169.578228]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  169.578230]  [<ffffffff811e569c>] core_sys_select+0x1cc/0x2e0
[  169.578232]  [<ffffffff811919a3>] ? unmap_region+0xd3/0x110
[  169.578234]  [<ffffffff81191f81>] ? vma_rb_erase+0x121/0x220
[  169.578236]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  169.578238]  [<ffffffff811e585b>] SyS_select+0xab/0x100
[  169.578240]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.578241]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578242] Xorg            S ffff88048f3d4640     0  1118    913 0x00400080
[  169.578244]  ffff880470a3b928 0000000000000086 ffff880473c0ca80 ffff880470a3bfd8
[  169.578246]  0000000000014640 0000000000014640 ffff880472cdefc0 ffff880470a3bae8
[  169.578247]  000000000007a11f 0000000000000000 000000000000001a 000000000000001a
[  169.578249] Call Trace:
[  169.578251]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578253]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.578255]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.578257]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.578259]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578261]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578263]  [<ffffffff811e530e>] do_select+0x5ae/0x770
[  169.578265]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578267]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578269]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578271]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578273]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578275]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578277]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578279]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578281]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578283]  [<ffffffff811e569c>] core_sys_select+0x1cc/0x2e0
[  169.578285]  [<ffffffff811d26b9>] ? do_readv_writev+0x169/0x220
[  169.578287]  [<ffffffff814f5df8>] ? evdev_read+0xd8/0x2f0
[  169.578289]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.578291]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.578293]  [<ffffffff811e585b>] SyS_select+0xab/0x100
[  169.578294]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578295] bluetoothd      S ffff88048f294640     0  1122      1 0x00000080
[  169.578297]  ffff880477d65a60 0000000000000082 ffff8804744d0000 ffff880477d65fd8
[  169.578299]  0000000000014640 0000000000014640 ffff880478d56670 0000000000000000
[  169.578300]  0000000000000000 ffff880477d65bec ffff880477d65bec 0000000000000000
[  169.578302] Call Trace:
[  169.578304]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578306]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578308]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578310]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.578312]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578314]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578316]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578318]  [<ffffffff8158251a>] ? sock_recvmsg+0x9a/0xd0
[  169.578320]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578322]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578324]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578326]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578328]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578330]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578332]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578334]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578336]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.578338]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578340]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578341] systemd-hostnam S ffff88048f2d4640     0  1176      1 0x00000080
[  169.578342]  ffff8804713f5a60 0000000000000082 ffff8804765cca80 ffff8804713f5fd8
[  169.578344]  0000000000014640 0000000000014640 ffff880478d56fc0 ffff8804713f5b98
[  169.578346]  0000000005f5e100 0000000000000000 ffff8804713f5bb4 0000000000000000
[  169.578348] Call Trace:
[  169.578350]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578352]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.578354]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.578356]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.578358]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578360]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578361]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578363]  [<ffffffff8163fec6>] ? unix_stream_sendmsg+0x3c6/0x400
[  169.578366]  [<ffffffff81581eeb>] ? sock_sendmsg+0x8b/0xc0
[  169.578368]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578369]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  169.578372]  [<ffffffff815822e3>] ? ___sys_sendmsg+0x373/0x380
[  169.578373]  [<ffffffff8118896c>] ? tlb_flush_mmu_free+0x2c/0x50
[  169.578375]  [<ffffffff81189234>] ? tlb_finish_mmu+0x14/0x40
[  169.578377]  [<ffffffff811919a3>] ? unmap_region+0xd3/0x110
[  169.578379]  [<ffffffff81338268>] ? lockref_put_or_lock+0x48/0x70
[  169.578380]  [<ffffffff81191f81>] ? vma_rb_erase+0x121/0x220
[  169.578382]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.578384]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.578386]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578387]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578388] systemd         S ffff88048f254640     0  1212      1 0x00000080
[  169.578390]  ffff880474707dd8 0000000000000082 ffff8804750eefc0 ffff880474707fd8
[  169.578392]  0000000000014640 0000000000014640 ffff880478d55d20 0000000000000000
[  169.578394]  0000000000000000 ffff88047342f720 ffff8804750eefc0 0000000000000000
[  169.578395] Call Trace:
[  169.578397]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578399]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578402]  [<ffffffff81216769>] ? ep_scan_ready_list.isra.9+0x199/0x1c0
[  169.578404]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578405]  [<ffffffff812169ce>] ep_poll+0x21e/0x330
[  169.578407]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.578409]  [<ffffffff81217dc5>] SyS_epoll_wait+0xb5/0xe0
[  169.578411]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.578413]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578414] (sd-pam)        S ffff88048f394640     0  1225   1212 0x00000080
[  169.578416]  ffff880477cd9db0 0000000000000082 ffff8804765cb7e0 ffff880477cd9fd8
[  169.578417]  0000000000014640 0000000000014640 ffff880478e192a0 ffff8804765cb7e0
[  169.578419]  7fffffffffffffff ffff880477cd9ed8 ffff8804765cb7e0 00007f8b99d4da00
[  169.578421] Call Trace:
[  169.578423]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578425]  [<ffffffff816a1679>] schedule_timeout+0x1f9/0x270
[  169.578427]  [<ffffffff810927ab>] ? recalc_sigpending+0x1b/0x50
[  169.578429]  [<ffffffff816a170e>] schedule_timeout_interruptible+0x1e/0x20
[  169.578431]  [<ffffffff81096011>] do_sigtimedwait+0x161/0x200
[  169.578433]  [<ffffffff81096126>] SYSC_rt_sigtimedwait+0x76/0xd0
[  169.578434]  [<ffffffff810aa56f>] ? __put_cred+0x3f/0x50
[  169.578436]  [<ffffffff810aa5a5>] ? abort_creds+0x25/0x30
[  169.578439]  [<ffffffff812c4a40>] ? cap_task_prctl+0xd0/0x1f0
[  169.578441]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.578443]  [<ffffffff8109618e>] SyS_rt_sigtimedwait+0xe/0x10
[  169.578445]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578446] upowerd         S ffff88048f3d4640     0  1289      1 0x00000080
[  169.578447]  ffff880477345a60 0000000000000082 ffff880471994a80 ffff880477345fd8
[  169.578449]  0000000000014640 0000000000014640 ffff880478d50000 0000000000000000
[  169.578451]  0000000000000000 ffff880477345bcc ffff880477345bcc 0000000000000000
[  169.578453] Call Trace:
[  169.578455]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578457]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578458]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578460]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.578462]  [<ffffffff816a508a>] ? _raw_spin_unlock_bh+0x1a/0x20
[  169.578464]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578466]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578468]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578470]  [<ffffffff8158251a>] ? sock_recvmsg+0x9a/0xd0
[  169.578472]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578474]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578476]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578478]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578480]  [<ffffffff811b62ba>] ? kmem_cache_free+0x1da/0x200
[  169.578482]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.578484]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.578486]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.578488]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578489]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578490] gmain           S ffff88048f3d4640     0  1295      1 0x00000080
[  169.578492]  ffff880477cdda60 0000000000000082 ffff880473c092a0 ffff880477cddfd8
[  169.578494]  0000000000014640 0000000000014640 ffff880478e19bf0 0000000000000000
[  169.578496]  0000000000000000 ffff880477cddbb4 ffff880477cddbb4 0000000000000000
[  169.578497] Call Trace:
[  169.578499]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578501]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578503]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578505]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578507]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578509]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578511]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.578513]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578515]  [<ffffffff811c69d0>] ? __mem_cgroup_commit_charge+0x150/0x2d0
[  169.578517]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  169.578519]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  169.578521]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.578523]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.578524]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.578526]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.578528]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578530]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578530] gdbus           S ffff88048f294640     0  1297      1 0x00000080
[  169.578532]  ffff8804744c7a60 0000000000000082 ffff880473c0d3d0 ffff8804744c7fd8
[  169.578534]  0000000000014640 0000000000014640 ffff880478d56670 0000000000000000
[  169.578536]  0000000000000000 ffff8804744c7bc4 ffff8804744c7bc4 0000000000000000
[  169.578537] Call Trace:
[  169.578540]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578541]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578543]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578545]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578547]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578549]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578551]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578554]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578556]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578558]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578559]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.578561]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.578563]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.578565]  [<ffffffff811b7246>] ? kmem_cache_alloc_trace+0x1d6/0x200
[  169.578567]  [<ffffffff812cbfac>] ? selinux_file_alloc_security+0x3c/0x60
[  169.578569]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.578571]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.578572]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.578574]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578576]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578577] colord          S ffff88048f2d4640     0  1377      1 0x00000080
[  169.578579]  ffff8800657c3a60 0000000000000082 ffff8804744d2540 ffff8800657c3fd8
[  169.578580]  0000000000014640 0000000000014640 ffff880478d56fc0 0000000000000000
[  169.578582]  0000000000000000 ffff8800657c3bcc ffff8800657c3bcc 0000000000000000
[  169.578584] Call Trace:
[  169.578586]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578588]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578590]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.578591]  [<ffffffff816a508a>] ? _raw_spin_unlock_bh+0x1a/0x20
[  169.578593]  [<ffffffff815c68ee>] ? netlink_poll+0x13e/0x1e0
[  169.578595]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578597]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578599]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578601]  [<ffffffff815c54d4>] ? netlink_rcv_wake+0x44/0x60
[  169.578603]  [<ffffffff815c65b7>] ? netlink_recvmsg+0x1c7/0x3c0
[  169.578605]  [<ffffffff8158251a>] ? sock_recvmsg+0x9a/0xd0
[  169.578607]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578609]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578611]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578613]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578615]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.578617]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.578619]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.578620]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.578622]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578624]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578625] gdbus           S ffff88048f254640     0  1385      1 0x00000080
[  169.578626]  ffff8804741f3a60 0000000000000082 ffff8804730aae90 ffff8804741f3fd8
[  169.578628]  0000000000014640 0000000000014640 ffff880478d55d20 0000000000000000
[  169.578630]  0000000000000000 ffff8804741f3bc4 ffff8804741f3bc4 0000000000000000
[  169.578632] Call Trace:
[  169.578634]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578636]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578638]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578640]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578642]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578644]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578645]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578648]  [<ffffffff8158251a>] ? sock_recvmsg+0x9a/0xd0
[  169.578650]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578652]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578654]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578656]  [<ffffffff815827f5>] ? ___sys_recvmsg+0x115/0x290
[  169.578657]  [<ffffffff810f0872>] ? futex_wake+0x72/0x140
[  169.578659]  [<ffffffff811b7246>] ? kmem_cache_alloc_trace+0x1d6/0x200
[  169.578661]  [<ffffffff812cbfac>] ? selinux_file_alloc_security+0x3c/0x60
[  169.578663]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.578665]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.578666]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.578668]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578670]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578671] gmain           S ffff88048f354640     0  1386      1 0x00000080
[  169.578673]  ffff880470a41a60 0000000000000082 ffff8804744d37e0 ffff880470a41fd8
[  169.578674]  0000000000014640 0000000000014640 ffff880478e18950 0000000000000000
[  169.578676]  0000000000000000 ffff880470a41bbc ffff880470a41bbc 0000000000000000
[  169.578678] Call Trace:
[  169.578680]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578682]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578684]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578686]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578688]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578690]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578692]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.578694]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578696]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578698]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  169.578700]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  169.578701]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.578703]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.578705]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.578707]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.578709]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578710]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578711] kworker/7:1H    S ffff88048f3d4640     0  1380      2 0x00000080
[  169.578715]  ffff880470ac3e58 0000000000000046 ffff8804765cefc0 ffff880470ac3fd8
[  169.578717]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff88048f3d4280
[  169.578719]  ffff88048f3d4298 ffff8804735251b0 ffff8804765cefc0 ffff880473525180
[  169.578720] Call Trace:
[  169.578722]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578724]  [<ffffffff8109ef92>] worker_thread+0x1c2/0x3a0
[  169.578726]  [<ffffffff8109edd0>] ? rescuer_thread+0x370/0x370
[  169.578728]  [<ffffffff810a55c2>] kthread+0xd2/0xf0
[  169.578729]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.578731]  [<ffffffff816addbc>] ret_from_fork+0x7c/0xb0
[  169.578732]  [<ffffffff810a54f0>] ? insert_kthread_work+0x40/0x40
[  169.578733] systemd-localed S ffff88048f254640     0  1416      1 0x00000080
[  169.578735]  ffff88047381da60 0000000000000082 ffff880472856fc0 ffff88047381dfd8
[  169.578737]  0000000000014640 0000000000014640 ffff880478d55d20 ffff88047381db98
[  169.578739]  0000000005f5e100 0000000000000000 ffff88047381dbb4 0000000000000000
[  169.578740] Call Trace:
[  169.578742]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578744]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.578746]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.578748]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.578750]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578752]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578754]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578756]  [<ffffffff8163fec6>] ? unix_stream_sendmsg+0x3c6/0x400
[  169.578758]  [<ffffffff81581eeb>] ? sock_sendmsg+0x8b/0xc0
[  169.578760]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578762]  [<ffffffff815822e3>] ? ___sys_sendmsg+0x373/0x380
[  169.578764]  [<ffffffff811ed803>] ? __fdget+0x13/0x20
[  169.578766]  [<ffffffff81582402>] ? SYSC_sendto+0x112/0x190
[  169.578768]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.578770]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.578772]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578773]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578774] gdm-session-wor S ffff88048f214640     0  1477    913 0x00000080
[  169.578776]  ffff880473451a60 0000000000000086 ffff880472ae4130 ffff880473451fd8
[  169.578778]  0000000000014640 0000000000014640 ffffffff81c16460 0000000000000000
[  169.578780]  0000000000000000 ffff880473451bbc ffff880473451bbc 0000000000000000
[  169.578782] Call Trace:
[  169.578784]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578786]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578788]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578790]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578791]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578793]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578795]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.578797]  [<ffffffff811c2c0e>] ? lookup_page_cgroup_used+0xe/0x30
[  169.578799]  [<ffffffff811ca4f1>] ? mem_cgroup_bad_page_check+0x21/0x30
[  169.578801]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578803]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578805]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.578807]  [<ffffffff810b282d>] ? ttwu_do_activate.constprop.97+0x5d/0x70
[  169.578809]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.578811]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.578812]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.578814]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.578816]  [<ffffffff810c77e8>] ? __wake_up_common+0x58/0x90
[  169.578818]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.578820]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.578822]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578823]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578824] gdbus           S ffff88048f3d4640     0  1478    913 0x00000080
[  169.578826]  ffff880470b27a60 0000000000000086 ffff8804784d2540 ffff880470b27fd8
[  169.578828]  0000000000014640 0000000000014640 ffff880478e19bf0 0000000000000000
[  169.578829]  0000000000000000 ffff880470b27bd4 ffff880470b27bd4 0000000000000000
[  169.578831] Call Trace:
[  169.578833]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578835]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578837]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578839]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578841]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578843]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578845]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578847]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578849]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578851]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578853]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578855]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578857]  [<ffffffff812cbfac>] ? selinux_file_alloc_security+0x3c/0x60
[  169.578859]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.578861]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.578863]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.578865]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578866]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578867] gmain           S ffff88048f394640     0  1479    913 0x00000080
[  169.578869]  ffff880473ee1a60 0000000000000086 ffff8804784d4a80 ffff880473ee1fd8
[  169.578871]  0000000000014640 0000000000014640 ffff880478e192a0 0000000000000000
[  169.578873]  0000000000000000 ffff880473ee1bb4 ffff880473ee1bb4 0000000000000000
[  169.578874] Call Trace:
[  169.578876]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578878]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578880]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578882]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578884]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578886]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.578888]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  169.578890]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.578892]  [<ffffffff8169ca7c>] ? __slab_free+0xfe/0x252
[  169.578894]  [<ffffffff810bf917>] ? enqueue_entity+0x237/0x8c0
[  169.578896]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.578898]  [<ffffffff81091f93>] ? __sigqueue_free.part.11+0x33/0x40
[  169.578899]  [<ffffffff810926ac>] ? __dequeue_signal+0x13c/0x220
[  169.578901]  [<ffffffff810927ab>] ? recalc_sigpending+0x1b/0x50
[  169.578903]  [<ffffffff81092882>] ? dequeue_signal+0x32/0x170
[  169.578904]  [<ffffffff810f0177>] ? get_futex_key+0x1d7/0x2e0
[  169.578906]  [<ffffffff810927ab>] ? recalc_sigpending+0x1b/0x50
[  169.578907]  [<ffffffff810f0872>] ? futex_wake+0x72/0x140
[  169.578909]  [<ffffffff81095806>] ? __set_current_blocked+0x36/0x50
[  169.578911]  [<ffffffff810f278a>] ? do_futex+0x10a/0xb00
[  169.578913]  [<ffffffff8101d438>] ? __restore_xstate_sig+0x88/0x510
[  169.578915]  [<ffffffff812c9bdb>] ? selinux_cred_prepare+0x1b/0x30
[  169.578917]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.578919]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.578920]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578921] systemd         S ffff88048f394640     0  1483      1 0x00000080
[  169.578923]  ffff880472d87dd8 0000000000000082 ffff8800648d2e90 ffff880472d87fd8
[  169.578925]  0000000000014640 0000000000014640 ffff880478e192a0 0000000000000000
[  169.578926]  0000000000000000 ffff880471786360 ffff8800648d2e90 0000000000000000
[  169.578928] Call Trace:
[  169.578930]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578932]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578934]  [<ffffffff81216769>] ? ep_scan_ready_list.isra.9+0x199/0x1c0
[  169.578936]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578938]  [<ffffffff812169ce>] ep_poll+0x21e/0x330
[  169.578940]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.578942]  [<ffffffff81217dc5>] SyS_epoll_wait+0xb5/0xe0
[  169.578944]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.578946]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578947] (sd-pam)        S ffff88048f254640     0  1488   1483 0x00000080
[  169.578949]  ffff8800654e1db0 0000000000000082 ffff880473c0dd20 ffff8800654e1fd8
[  169.578950]  0000000000014640 0000000000014640 ffff880478d55d20 ffff880473c0dd20
[  169.578952]  7fffffffffffffff ffff8800654e1ed8 ffff880473c0dd20 00007f8b99d42790
[  169.578954] Call Trace:
[  169.578956]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578958]  [<ffffffff816a1679>] schedule_timeout+0x1f9/0x270
[  169.578960]  [<ffffffff810927ab>] ? recalc_sigpending+0x1b/0x50
[  169.578962]  [<ffffffff816a170e>] schedule_timeout_interruptible+0x1e/0x20
[  169.578963]  [<ffffffff81096011>] do_sigtimedwait+0x161/0x200
[  169.578965]  [<ffffffff81096126>] SYSC_rt_sigtimedwait+0x76/0xd0
[  169.578967]  [<ffffffff810aa56f>] ? __put_cred+0x3f/0x50
[  169.578969]  [<ffffffff810aa5a5>] ? abort_creds+0x25/0x30
[  169.578971]  [<ffffffff812c4a40>] ? cap_task_prctl+0xd0/0x1f0
[  169.578973]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.578975]  [<ffffffff8109618e>] SyS_rt_sigtimedwait+0xe/0x10
[  169.578976]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.578977] dwm             S ffff88048f254640     0  1491   1477 0x00000080
[  169.578979]  ffff88047381ba60 0000000000000086 ffff8804765c8950 ffff88047381bfd8
[  169.578981]  0000000000014640 0000000000014640 ffff880478d55d20 0000000000000000
[  169.578983]  0000000000000000 ffff88047381bbb4 ffff88047381bbb4 0000000000000000
[  169.578984] Call Trace:
[  169.578986]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.578988]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.578990]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.578992]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.578994]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.578996]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.578998]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579000]  [<ffffffff8158ba3e>] ? skb_free_head+0x1e/0x80
[  169.579002]  [<ffffffff8158bb76>] ? skb_release_data+0xd6/0x110
[  169.579004]  [<ffffffff81588fe7>] ? kfree_skbmem+0x37/0xa0
[  169.579005]  [<ffffffff8158bf84>] ? consume_skb+0x34/0x80
[  169.579007]  [<ffffffff816a36b2>] ? mutex_lock_interruptible+0x12/0x3c
[  169.579009]  [<ffffffff8164065c>] ? unix_stream_recvmsg+0x75c/0x880
[  169.579011]  [<ffffffff8158497a>] ? sock_def_readable+0x3a/0x70
[  169.579013]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579015]  [<ffffffff8158251a>] ? sock_recvmsg+0x9a/0xd0
[  169.579017]  [<ffffffff811d103c>] ? do_sync_readv_writev+0x4c/0x80
[  169.579019]  [<ffffffff81582679>] ? SYSC_recvfrom+0xd9/0x140
[  169.579021]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579023]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579024] dbus-launch     S ffff88048f254640     0  1501      1 0x00000080
[  169.579025]  ffff880472a4f928 0000000000000086 ffff8804784d37e0 ffff880472a4ffd8
[  169.579027]  0000000000014640 0000000000014640 ffff880478d55d20 0000000000000000
[  169.579029]  0000000000000040 0000000000000010 0000000000000004 0000000000000004
[  169.579031] Call Trace:
[  169.579033]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579035]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579037]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579038]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.579040]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579042]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579044]  [<ffffffff811e530e>] do_select+0x5ae/0x770
[  169.579046]  [<ffffffff816a1a25>] ? schedule_hrtimeout_range_clock+0x135/0x150
[  169.579049]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579050]  [<ffffffff8158ba3e>] ? skb_free_head+0x1e/0x80
[  169.579052]  [<ffffffff811b609f>] ? kfree+0xff/0x140
[  169.579054]  [<ffffffff811b62ba>] ? kmem_cache_free+0x1da/0x200
[  169.579056]  [<ffffffff81588fe7>] ? kfree_skbmem+0x37/0xa0
[  169.579058]  [<ffffffff8158bf84>] ? consume_skb+0x34/0x80
[  169.579060]  [<ffffffff816a36b2>] ? mutex_lock_interruptible+0x12/0x3c
[  169.579062]  [<ffffffff8164065c>] ? unix_stream_recvmsg+0x75c/0x880
[  169.579063]  [<ffffffff8158497a>] ? sock_def_readable+0x3a/0x70
[  169.579065]  [<ffffffff8158251a>] ? sock_recvmsg+0x9a/0xd0
[  169.579067]  [<ffffffff811e569c>] core_sys_select+0x1cc/0x2e0
[  169.579070]  [<ffffffff81582679>] ? SYSC_recvfrom+0xd9/0x140
[  169.579072]  [<ffffffff812ca707>] ? inode_has_perm.isra.32+0x27/0x30
[  169.579073]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.579075]  [<ffffffff811e585b>] SyS_select+0xab/0x100
[  169.579077]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.579079]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579080] dbus-daemon     S ffff88048f214640     0  1502      1 0x00000080
[  169.579081]  ffff880474629dd8 0000000000000082 ffff8804784d0950 ffff880474629fd8
[  169.579083]  0000000000014640 0000000000014640 ffffffff81c16460 0000000000000000
[  169.579085]  0000000000000000 ffff8804777acde0 ffff8804784d0950 0000000000000000
[  169.579087] Call Trace:
[  169.579089]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579091]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579093]  [<ffffffff81216769>] ? ep_scan_ready_list.isra.9+0x199/0x1c0
[  169.579095]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579097]  [<ffffffff812169ce>] ep_poll+0x21e/0x330
[  169.579099]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.579101]  [<ffffffff81217dc5>] SyS_epoll_wait+0xb5/0xe0
[  169.579103]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.579104]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579105] dbus-daemon     S ffff88048f3d4640     0  1503      1 0x00000080
[  169.579107]  ffff88047691ba60 0000000000000082 ffff8800648d12a0 ffff88047691bfd8
[  169.579109]  0000000000014640 0000000000014640 ffff880478e19bf0 0000000000000000
[  169.579111]  0000000000000000 ffff88047691bbb4 ffff88047691bbb4 0000000000000000
[  169.579112] Call Trace:
[  169.579114]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579116]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579118]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.579120]  [<ffffffff816a508a>] ? _raw_spin_unlock_bh+0x1a/0x20
[  169.579122]  [<ffffffff815c68ee>] ? netlink_poll+0x13e/0x1e0
[  169.579124]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579126]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579128]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579130]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579133]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579134]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579135] ssh-agent       S ffff88048f3d4640     0  1510   1491 0x00000080
[  169.579137]  ffff880473c45928 0000000000000086 ffff8800648d4130 ffff880473c45fd8
[  169.579139]  0000000000014640 0000000000014640 ffff880472856670 ffff880473c45ae8
[  169.579140]  000000000098967f 0000000000000000 0000000000000004 0000000000000004
[  169.579142] Call Trace:
[  169.579144]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579146]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.579148]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.579150]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.579152]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579154]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579156]  [<ffffffff811e530e>] do_select+0x5ae/0x770
[  169.579158]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579160]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.579161]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.579163]  [<ffffffff8118bcc7>] ? do_set_pte+0x97/0xd0
[  169.579165]  [<ffffffff81161d0a>] ? unlock_page+0x2a/0x40
[  169.579167]  [<ffffffff81188b1d>] ? lock_page+0xd/0x30
[  169.579168]  [<ffffffff81188bd4>] ? __do_fault+0x94/0xa0
[  169.579170]  [<ffffffff8118bcc7>] ? do_set_pte+0x97/0xd0
[  169.579172]  [<ffffffff81161d0a>] ? unlock_page+0x2a/0x40
[  169.579173]  [<ffffffff8118bfa4>] ? do_read_fault.isra.59+0x2a4/0x2d0
[  169.579175]  [<ffffffff811e569c>] core_sys_select+0x1cc/0x2e0
[  169.579177]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.579179]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.579181]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.579182]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.579184]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.579186]  [<ffffffff811e585b>] SyS_select+0xab/0x100
[  169.579187]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579188] gnome-screensav S ffff88048f3d4640     0  1530   1491 0x00000080
[  169.579190]  ffff8804747c5a60 0000000000000086 ffff880471850950 ffff8804747c5fd8
[  169.579192]  0000000000014640 0000000000014640 ffff880472ae37e0 ffff8804747c5b98
[  169.579194]  0000000005f5e100 0000000000000000 ffff8804747c5bd4 0000000000000000
[  169.579195] Call Trace:
[  169.579197]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579199]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.579201]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.579203]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.579205]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579207]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579209]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579211]  [<ffffffff8158ba3e>] ? skb_free_head+0x1e/0x80
[  169.579213]  [<ffffffff8158bb76>] ? skb_release_data+0xd6/0x110
[  169.579215]  [<ffffffff81588fe7>] ? kfree_skbmem+0x37/0xa0
[  169.579216]  [<ffffffff8158bf84>] ? consume_skb+0x34/0x80
[  169.579218]  [<ffffffff816a36b2>] ? mutex_lock_interruptible+0x12/0x3c
[  169.579220]  [<ffffffff8164065c>] ? unix_stream_recvmsg+0x75c/0x880
[  169.579222]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579224]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579226]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579228]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579230]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579232]  [<ffffffff811ed7a5>] ? __fget_light+0x25/0x70
[  169.579234]  [<ffffffff815826b8>] ? SYSC_recvfrom+0x118/0x140
[  169.579236]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.579238]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.579240]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579241]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579242] dconf worker    S ffff88048f3d4640     0  1545   1491 0x00000080
[  169.579244]  ffff880470a83a60 0000000000000086 ffff8804784d6fc0 ffff880470a83fd8
[  169.579246]  0000000000014640 0000000000014640 ffff880478e19bf0 0000000000000000
[  169.579247]  0000000000000000 ffff880470a83bb4 ffff880470a83bb4 0000000000000000
[  169.579249] Call Trace:
[  169.579251]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579253]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579255]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579257]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579259]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579261]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579263]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.579265]  [<ffffffff810b9338>] ? __enqueue_entity+0x78/0x80
[  169.579267]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579268]  [<ffffffff810b2695>] ? check_preempt_curr+0x75/0xa0
[  169.579270]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.579272]  [<ffffffff810b282d>] ? ttwu_do_activate.constprop.97+0x5d/0x70
[  169.579274]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.579276]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.579277]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.579279]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.579281]  [<ffffffff810c77e8>] ? __wake_up_common+0x58/0x90
[  169.579283]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.579285]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.579287]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579288]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579289] gdbus           S ffff88048f314640     0  1546   1491 0x00000080
[  169.579291]  ffff880064a93a60 0000000000000086 ffff880472ae0950 ffff880064a93fd8
[  169.579292]  0000000000014640 0000000000014640 ffff880478e18000 0000000000000000
[  169.579294]  0000000000000000 ffff880064a93bc4 ffff880064a93bc4 0000000000000000
[  169.579296] Call Trace:
[  169.579298]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579300]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579302]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579304]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579306]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579308]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579309]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579312]  [<ffffffff8158251a>] ? sock_recvmsg+0x9a/0xd0
[  169.579314]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579316]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579318]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579320]  [<ffffffff815827f5>] ? ___sys_recvmsg+0x115/0x290
[  169.579322]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.579324]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.579325]  [<ffffffff811b7246>] ? kmem_cache_alloc_trace+0x1d6/0x200
[  169.579328]  [<ffffffff812cbfac>] ? selinux_file_alloc_security+0x3c/0x60
[  169.579329]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.579331]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.579333]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.579335]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579336]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579337] gmain           S ffff88048f354640     0  1553   1491 0x00000080
[  169.579339]  ffff880474627a60 0000000000000086 ffff880476f0ae90 ffff880474627fd8
[  169.579341]  0000000000014640 0000000000014640 ffff880478e18950 0000000000000000
[  169.579342]  0000000000000000 ffff880474627bbc ffff880474627bbc 0000000000000000
[  169.579344] Call Trace:
[  169.579346]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579348]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579350]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579352]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579354]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579356]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579358]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.579360]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579362]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579364]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  169.579366]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  169.579367]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.579369]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.579371]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.579373]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.579375]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579376]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579377] update-titlebar S ffff88048f254640     0  1531   1491 0x00000080
[  169.579379]  ffff880470979e78 0000000000000082 ffff880471855d20 ffff880470979fd8
[  169.579381]  0000000000014640 0000000000014640 ffff880473c0ca80 ffff880470979f00
[  169.579382]  ffff880471856078 ffff880471855d20 ffff880471855d20 ffff880471855d10
[  169.579384] Call Trace:
[  169.579386]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579388]  [<ffffffff81085f92>] do_wait+0x1e2/0x240
[  169.579390]  [<ffffffff81086fb4>] SyS_wait4+0x64/0xe0
[  169.579391]  [<ffffffff81084c70>] ? task_stopped_code+0x60/0x60
[  169.579393]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579394] at-spi-bus-laun S ffff88048f214640     0  1536      1 0x00000080
[  169.579396]  ffff8804718afa60 0000000000000086 ffff880472ae6fc0 ffff8804718affd8
[  169.579398]  0000000000014640 0000000000014640 ffffffff81c16460 0000000000000000
[  169.579399]  0000000000000000 ffff8804718afbbc ffff8804718afbbc 0000000000000000
[  169.579401] Call Trace:
[  169.579403]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579405]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579407]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579409]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579411]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579413]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579415]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579417]  [<ffffffff811b62ba>] ? kmem_cache_free+0x1da/0x200
[  169.579419]  [<ffffffff81588fe7>] ? kfree_skbmem+0x37/0xa0
[  169.579420]  [<ffffffff8158bf84>] ? consume_skb+0x34/0x80
[  169.579422]  [<ffffffff816a36b2>] ? mutex_lock_interruptible+0x12/0x3c
[  169.579424]  [<ffffffff8164065c>] ? unix_stream_recvmsg+0x75c/0x880
[  169.579427]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579429]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579430]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.579432]  [<ffffffff810f0177>] ? get_futex_key+0x1d7/0x2e0
[  169.579433]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  169.579435]  [<ffffffff810f0872>] ? futex_wake+0x72/0x140
[  169.579437]  [<ffffffff810f278a>] ? do_futex+0x10a/0xb00
[  169.579438]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.579440]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579442]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579443] dconf worker    S ffff88048f354640     0  1537      1 0x00000080
[  169.579445]  ffff880470e5ba60 0000000000000086 ffff880476f0efc0 ffff880470e5bfd8
[  169.579447]  0000000000014640 0000000000014640 ffff880478e18950 0000000000000000
[  169.579448]  0000000000000000 ffff880470e5bbb4 ffff880470e5bbb4 0000000000000000
[  169.579450] Call Trace:
[  169.579452]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579454]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579456]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579458]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579460]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579462]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579464]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.579465]  [<ffffffff810b9338>] ? __enqueue_entity+0x78/0x80
[  169.579467]  [<ffffffff810bf917>] ? enqueue_entity+0x237/0x8c0
[  169.579469]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579471]  [<ffffffff811c69d0>] ? __mem_cgroup_commit_charge+0x150/0x2d0
[  169.579473]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  169.579475]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  169.579476]  [<ffffffff810f0177>] ? get_futex_key+0x1d7/0x2e0
[  169.579478]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.579479]  [<ffffffff810f0872>] ? futex_wake+0x72/0x140
[  169.579481]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.579483]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.579485]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579486]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579487] gdbus           S ffff88048f394640     0  1539      1 0x00000080
[  169.579489]  ffff880473d39a60 0000000000000086 ffff8804784d12a0 ffff880473d39fd8
[  169.579491]  0000000000014640 0000000000014640 ffff880478e192a0 0000000000000000
[  169.579493]  0000000000000000 ffff880473d39bc4 ffff880473d39bc4 0000000000000000
[  169.579494] Call Trace:
[  169.579496]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579498]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579500]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579502]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579504]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579506]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579508]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579510]  [<ffffffff8163fec6>] ? unix_stream_sendmsg+0x3c6/0x400
[  169.579512]  [<ffffffff81581eeb>] ? sock_sendmsg+0x8b/0xc0
[  169.579514]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579516]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579518]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579520]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  169.579522]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.579524]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.579525]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.579527]  [<ffffffff811ed7a5>] ? __fget_light+0x25/0x70
[  169.579529]  [<ffffffff81583075>] ? __sys_sendmsg+0x65/0x80
[  169.579531]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579533]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579534] gmain           S ffff88048f354640     0  1541      1 0x00000080
[  169.579535]  ffff880473a97a60 0000000000000086 ffff880476f0e670 ffff880473a97fd8
[  169.579537]  0000000000014640 0000000000014640 ffff880478e18950 0000000000000000
[  169.579539]  0000000000000000 ffff880473a97bb4 ffff880473a97bb4 0000000000000000
[  169.579541] Call Trace:
[  169.579543]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579545]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579547]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579549]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579551]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579553]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579554]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.579557]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579559]  [<ffffffff811c69d0>] ? __mem_cgroup_commit_charge+0x150/0x2d0
[  169.579560]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  169.579562]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  169.579564]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.579566]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.579567]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.579569]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.579571]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579573]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579574] dbus-daemon     S ffff88048f214640     0  1540   1536 0x00000080
[  169.579575]  ffff880470461dd8 0000000000000082 ffff880476f0d3d0 ffff880470461fd8
[  169.579577]  0000000000014640 0000000000014640 ffff880472852540 ffff880470461ec0
[  169.579579]  0000000005f5e100 0000000000000000 ffff880476f0d3d0 ffff880470461ec0
[  169.579581] Call Trace:
[  169.579583]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579585]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.579586]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.579588]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.579590]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579592]  [<ffffffff812169ce>] ep_poll+0x21e/0x330
[  169.579594]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.579596]  [<ffffffff81217dc5>] SyS_epoll_wait+0xb5/0xe0
[  169.579598]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.579600]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579601] dbus-daemon     S ffff88048f3d4640     0  1542   1536 0x00000080
[  169.579602]  ffff880473a77a60 0000000000000082 ffff8800648d53d0 ffff880473a77fd8
[  169.579604]  0000000000014640 0000000000014640 ffff880478e19bf0 0000000000000000
[  169.579606]  0000000000000000 ffff880473a77bb4 ffff880473a77bb4 0000000000000000
[  169.579608] Call Trace:
[  169.579610]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579612]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579614]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.579615]  [<ffffffff816a508a>] ? _raw_spin_unlock_bh+0x1a/0x20
[  169.579617]  [<ffffffff815c68ee>] ? netlink_poll+0x13e/0x1e0
[  169.579619]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579621]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579623]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579625]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579627]  [<ffffffff811c2c0e>] ? lookup_page_cgroup_used+0xe/0x30
[  169.579630]  [<ffffffff8169ca7c>] ? __slab_free+0xfe/0x252
[  169.579631]  [<ffffffff8116a13a>] ? __free_pages+0x5a/0x70
[  169.579633]  [<ffffffff811b62ba>] ? kmem_cache_free+0x1da/0x200
[  169.579635]  [<ffffffff81080e52>] ? __mmdrop+0x62/0x90
[  169.579637]  [<ffffffff810b1438>] ? finish_task_switch+0xb8/0xf0
[  169.579639]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579640]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579642] at-spi2-registr S ffff88048f3d4640     0  1544      1 0x00000080
[  169.579643]  ffff880470743a60 0000000000000082 ffff880472ae37e0 ffff880470743fd8
[  169.579645]  0000000000014640 0000000000014640 ffff880478e19bf0 0000000000000000
[  169.579647]  0000000000000000 ffff880470743bcc ffff880470743bcc 0000000000000000
[  169.579648] Call Trace:
[  169.579650]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579652]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579654]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579656]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.579658]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579660]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579662]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579664]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579666]  [<ffffffff8158ba3e>] ? skb_free_head+0x1e/0x80
[  169.579668]  [<ffffffff8158bb76>] ? skb_release_data+0xd6/0x110
[  169.579669]  [<ffffffff81588fe7>] ? kfree_skbmem+0x37/0xa0
[  169.579671]  [<ffffffff8158bf84>] ? consume_skb+0x34/0x80
[  169.579673]  [<ffffffff816a36b2>] ? mutex_lock_interruptible+0x12/0x3c
[  169.579675]  [<ffffffff8164065c>] ? unix_stream_recvmsg+0x75c/0x880
[  169.579677]  [<ffffffff8158497a>] ? sock_def_readable+0x3a/0x70
[  169.579679]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579681]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579683]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579685]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579687]  [<ffffffff811d103c>] ? do_sync_readv_writev+0x4c/0x80
[  169.579688]  [<ffffffff811ed7a5>] ? __fget_light+0x25/0x70
[  169.579690]  [<ffffffff815826b8>] ? SYSC_recvfrom+0x118/0x140
[  169.579692]  [<ffffffff811ed7a5>] ? __fget_light+0x25/0x70
[  169.579694]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579696]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579697] gdbus           S ffff88048f214640     0  1547      1 0x00000080
[  169.579699]  ffff88006566da60 0000000000000082 ffff8800648d0950 ffff88006566dfd8
[  169.579700]  0000000000014640 0000000000014640 ffffffff81c16460 0000000000000000
[  169.579702]  0000000000000000 ffff88006566dbc4 ffff88006566dbc4 0000000000000000
[  169.579704] Call Trace:
[  169.579706]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579708]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579710]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579712]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579714]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579716]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579718]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579720]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579722]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579724]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579726]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.579728]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.579730]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.579732]  [<ffffffff811b7246>] ? kmem_cache_alloc_trace+0x1d6/0x200
[  169.579734]  [<ffffffff812cbfac>] ? selinux_file_alloc_security+0x3c/0x60
[  169.579736]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.579737]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.579739]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.579741]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579743]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579744] gvfsd           S ffff88048f2d4640     0  1549      1 0x00000080
[  169.579745]  ffff8800656d9a60 0000000000000082 ffff880472850000 ffff8800656d9fd8
[  169.579747]  0000000000014640 0000000000014640 ffff880478d56fc0 0000000000000000
[  169.579749]  0000000000000000 ffff8800656d9bbc ffff8800656d9bbc 0000000000000000
[  169.579751] Call Trace:
[  169.579753]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579755]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579757]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579759]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579760]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579762]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579764]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.579766]  [<ffffffff810bddca>] ? dequeue_entity+0x11a/0x550
[  169.579768]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579770]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579772]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.579773]  [<ffffffff810b282d>] ? ttwu_do_activate.constprop.97+0x5d/0x70
[  169.579775]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.579777]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.579779]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.579781]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.579782]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.579784]  [<ffffffff810c77e8>] ? __wake_up_common+0x58/0x90
[  169.579786]  [<ffffffff81210898>] ? fsnotify+0x228/0x2f0
[  169.579788]  [<ffffffff810c7858>] ? __wake_up_locked_key+0x18/0x20
[  169.579790]  [<ffffffff811d17cc>] ? vfs_write+0x15c/0x1e0
[  169.579792]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579793]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579794] gdbus           S ffff88048f254640     0  1550      1 0x00000080
[  169.579796]  ffff880064d0ba60 0000000000000082 ffff8800648d0000 ffff880064d0bfd8
[  169.579798]  0000000000014640 0000000000014640 ffff880478d55d20 0000000000000000
[  169.579800]  0000000000000000 ffff880064d0bbc4 ffff880064d0bbc4 0000000000000000
[  169.579801] Call Trace:
[  169.579803]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579805]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579807]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579809]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579811]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579813]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579815]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579817]  [<ffffffff8163fec6>] ? unix_stream_sendmsg+0x3c6/0x400
[  169.579819]  [<ffffffff81581eeb>] ? sock_sendmsg+0x8b/0xc0
[  169.579821]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579823]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579825]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579827]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.579829]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.579831]  [<ffffffff811b7246>] ? kmem_cache_alloc_trace+0x1d6/0x200
[  169.579833]  [<ffffffff812cbfac>] ? selinux_file_alloc_security+0x3c/0x60
[  169.579835]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.579836]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.579838]  [<ffffffff811ed7a5>] ? __fget_light+0x25/0x70
[  169.579840]  [<ffffffff81583075>] ? __sys_sendmsg+0x65/0x80
[  169.579842]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579844]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579845] gvfsd-fuse      S ffff88048f2d4640     0  1554      1 0x00000080
[  169.579846]  ffff880473477ca8 0000000000000086 ffff880472ae5d20 ffff880473477fd8
[  169.579848]  0000000000014640 0000000000014640 ffff880478d56fc0 ffff880472ae5d20
[  169.579850]  0000000000000000 ffffc900018e1040 ffff880472ae5d20 ffff880473477db8
[  169.579852] Call Trace:
[  169.579854]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579855]  [<ffffffff810f035a>] futex_wait_queue_me+0xda/0x140
[  169.579857]  [<ffffffff810f0635>] futex_wait+0x165/0x250
[  169.579859]  [<ffffffff8101a705>] ? native_sched_clock+0x35/0x90
[  169.579860]  [<ffffffff810b958e>] ? sched_slice.isra.54+0x4e/0x90
[  169.579862]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  169.579864]  [<ffffffff810a1d2e>] ? alloc_pid+0x2e/0x4d0
[  169.579866]  [<ffffffff810f2766>] do_futex+0xe6/0xb00
[  169.579868]  [<ffffffff810ae54c>] ? enqueue_task+0x2c/0x70
[  169.579869]  [<ffffffff810b2695>] ? check_preempt_curr+0x75/0xa0
[  169.579871]  [<ffffffff810b520c>] ? wake_up_new_task+0x10c/0x170
[  169.579873]  [<ffffffff810927ab>] ? recalc_sigpending+0x1b/0x50
[  169.579875]  [<ffffffff810f31f1>] SyS_futex+0x71/0x150
[  169.579876]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.579878]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579879] gvfsd-fuse      S ffff88048f2d4640     0  1559      1 0x00000080
[  169.579881]  ffff88047534fd40 0000000000000086 ffff8804765cd3d0 ffff88047534ffd8
[  169.579883]  0000000000014640 0000000000014640 ffff880478d56fc0 ffff8804765cd3d0
[  169.579884]  ffff8804765cd3d0 ffff880470b0f048 ffff8804765cd3d0 ffff880470b0f000
[  169.579886] Call Trace:
[  169.579888]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579891]  [<ffffffffa057dd76>] fuse_dev_do_read.isra.16+0x226/0x800 [fuse]
[  169.579893]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.579896]  [<ffffffffa057e5fd>] fuse_dev_read+0x6d/0x80 [fuse]
[  169.579898]  [<ffffffff811d0f2a>] do_sync_read+0x5a/0x90
[  169.579899]  [<ffffffff811d15ab>] vfs_read+0x9b/0x160
[  169.579901]  [<ffffffff811d21c6>] SyS_read+0x46/0xb0
[  169.579903]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.579904]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579905] gvfsd-fuse      S ffff88048f3d4640     0  1560      1 0x00000080
[  169.579907]  ffff8804738b9d40 0000000000000086 ffff8800648d6670 ffff8804738b9fd8
[  169.579909]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff8800648d6670
[  169.579911]  ffff8800648d6670 ffff880470b0f048 ffff8800648d6670 ffff880470b0f000
[  169.579912] Call Trace:
[  169.579914]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579917]  [<ffffffffa057dd76>] fuse_dev_do_read.isra.16+0x226/0x800 [fuse]
[  169.579919]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.579921]  [<ffffffffa057e5fd>] fuse_dev_read+0x6d/0x80 [fuse]
[  169.579923]  [<ffffffff811d0f2a>] do_sync_read+0x5a/0x90
[  169.579925]  [<ffffffff811d15ab>] vfs_read+0x9b/0x160
[  169.579926]  [<ffffffff811d21c6>] SyS_read+0x46/0xb0
[  169.579928]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.579930]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579931] gdbus           S ffff88048f254640     0  1564      1 0x00000080
[  169.579932]  ffff8804742e3a60 0000000000000086 ffff8804718537e0 ffff8804742e3fd8
[  169.579934]  0000000000014640 0000000000014640 ffff880478d55d20 0000000000000000
[  169.579936]  0000000000000000 ffff8804742e3bc4 ffff8804742e3bc4 0000000000000000
[  169.579938] Call Trace:
[  169.579940]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579942]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579944]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579946]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579948]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579950]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579952]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579954]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579956]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579958]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.579960]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.579962]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.579964]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.579966]  [<ffffffff811b7246>] ? kmem_cache_alloc_trace+0x1d6/0x200
[  169.579968]  [<ffffffff812cbfac>] ? selinux_file_alloc_security+0x3c/0x60
[  169.579969]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.579971]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.579973]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.579975]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.579976]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.579978] gvfs-fuse-sub   S ffff88048f314640     0  1566      1 0x00000080
[  169.579979]  ffff880477e65a60 0000000000000086 ffff8804765cdd20 ffff880477e65fd8
[  169.579981]  0000000000014640 0000000000014640 ffff880478e18000 0000000000000000
[  169.579983]  0000000000000000 ffff880477e65bb4 ffff880477e65bb4 0000000000000000
[  169.579985] Call Trace:
[  169.579987]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.579989]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.579991]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.579993]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.579994]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.579996]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.579998]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.580000]  [<ffffffff811c2c0e>] ? lookup_page_cgroup_used+0xe/0x30
[  169.580002]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580004]  [<ffffffff810b2695>] ? check_preempt_curr+0x75/0xa0
[  169.580006]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.580007]  [<ffffffff810b282d>] ? ttwu_do_activate.constprop.97+0x5d/0x70
[  169.580009]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.580011]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.580013]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.580015]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.580016]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.580018]  [<ffffffff810c77e8>] ? __wake_up_common+0x58/0x90
[  169.580020]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.580022]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.580024]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.580025]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580026] xterm           S ffff88048f3d4640     0  1568   1491 0x00000080
[  169.580028]  ffff880473d81928 0000000000000082 ffff880472851bf0 ffff880473d81fd8
[  169.580030]  0000000000014640 0000000000014640 ffff880478e19bf0 0000000000000000
[  169.580032]  0000000000000040 0000000000000020 0000000000000005 0000000000000005
[  169.580033] Call Trace:
[  169.580035]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.580037]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.580039]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.580042]  [<ffffffff813f705f>] ? pty_write_room+0x2f/0x50
[  169.580044]  [<ffffffff813f2dbd>] ? tty_write_room+0x1d/0x20
[  169.580046]  [<ffffffff813ef367>] ? n_tty_poll+0x1b7/0x1d0
[  169.580048]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.580050]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.580052]  [<ffffffff811e530e>] do_select+0x5ae/0x770
[  169.580054]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580056]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580058]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580060]  [<ffffffff8158bb76>] ? skb_release_data+0xd6/0x110
[  169.580062]  [<ffffffff81588fe7>] ? kfree_skbmem+0x37/0xa0
[  169.580064]  [<ffffffff8158bf84>] ? consume_skb+0x34/0x80
[  169.580066]  [<ffffffff816a36b2>] ? mutex_lock_interruptible+0x12/0x3c
[  169.580067]  [<ffffffff8164065c>] ? unix_stream_recvmsg+0x75c/0x880
[  169.580069]  [<ffffffff8158497a>] ? sock_def_readable+0x3a/0x70
[  169.580071]  [<ffffffff8158251a>] ? sock_recvmsg+0x9a/0xd0
[  169.580073]  [<ffffffff811e569c>] core_sys_select+0x1cc/0x2e0
[  169.580075]  [<ffffffff81582679>] ? SYSC_recvfrom+0xd9/0x140
[  169.580077]  [<ffffffff813ec33c>] ? tty_read+0x9c/0x100
[  169.580079]  [<ffffffff811e585b>] SyS_select+0xab/0x100
[  169.580081]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.580082]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580084] bash            S ffff88048f314640     0  1573   1568 0x00000080
[  169.580085]  ffff8804757a3e78 0000000000000086 ffff8804750ee670 ffff8804757a3fd8
[  169.580087]  0000000000014640 0000000000014640 ffff880478f053d0 ffff8804757a3f00
[  169.580089]  ffff8804750ee9c8 ffff8804750ee670 ffff8804750ee670 ffff8804750ee660
[  169.580091] Call Trace:
[  169.580093]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.580094]  [<ffffffff81085f92>] do_wait+0x1e2/0x240
[  169.580096]  [<ffffffff81086fb4>] SyS_wait4+0x64/0xe0
[  169.580097]  [<ffffffff81084c70>] ? task_stopped_code+0x60/0x60
[  169.580099]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580100] xterm           S ffff88048f3d4640     0  1601   1491 0x00000080
[  169.580102]  ffff880470a0b928 0000000000000086 ffff880472855d20 ffff880470a0bfd8
[  169.580104]  0000000000014640 0000000000014640 ffff880472da8950 0000000000000000
[  169.580105]  0000000000000040 0000000000000020 0000000000000005 0000000000000005
[  169.580107] Call Trace:
[  169.580109]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.580111]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.580113]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.580115]  [<ffffffff813f705f>] ? pty_write_room+0x2f/0x50
[  169.580116]  [<ffffffff813f2dbd>] ? tty_write_room+0x1d/0x20
[  169.580118]  [<ffffffff813ef367>] ? n_tty_poll+0x1b7/0x1d0
[  169.580120]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.580122]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.580124]  [<ffffffff811e530e>] do_select+0x5ae/0x770
[  169.580126]  [<ffffffff810b26a5>] ? check_preempt_curr+0x85/0xa0
[  169.580128]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580130]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580132]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580134]  [<ffffffff810be96a>] ? check_preempt_wakeup+0x12a/0x220
[  169.580136]  [<ffffffff816a36b2>] ? mutex_lock_interruptible+0x12/0x3c
[  169.580137]  [<ffffffff8164065c>] ? unix_stream_recvmsg+0x75c/0x880
[  169.580140]  [<ffffffff8158251a>] ? sock_recvmsg+0x9a/0xd0
[  169.580142]  [<ffffffff811e569c>] core_sys_select+0x1cc/0x2e0
[  169.580144]  [<ffffffff81582679>] ? SYSC_recvfrom+0xd9/0x140
[  169.580145]  [<ffffffff813ef8e0>] ? process_echoes+0x70/0x70
[  169.580148]  [<ffffffff811e585b>] SyS_select+0xab/0x100
[  169.580149]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.580151]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580152] bash            S ffff88048f254640     0  1611   1601 0x00000080
[  169.580154]  ffff880474033e78 0000000000000086 ffff8804750eae90 ffff880474033fd8
[  169.580155]  0000000000014640 0000000000014640 ffff88047331a540 ffff880474033f00
[  169.580157]  ffff8804750eb1e8 ffff8804750eae90 ffff8804750eae90 ffff8804750eae80
[  169.580159] Call Trace:
[  169.580161]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.580163]  [<ffffffff81085f92>] do_wait+0x1e2/0x240
[  169.580164]  [<ffffffff81086fb4>] SyS_wait4+0x64/0xe0
[  169.580166]  [<ffffffff81084c70>] ? task_stopped_code+0x60/0x60
[  169.580168]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580169] dhclient        S ffff88048f214640     0  1627    984 0x00000080
[  169.580170]  ffff8804787ed928 0000000000000082 ffff880477248950 ffff8804787edfd8
[  169.580172]  0000000000014640 0000000000014640 ffffffff81c16460 ffff8804787edae8
[  169.580174]  0000000005f5e100 0000000000000000 0000000000000008 0000000000000008
[  169.580176] Call Trace:
[  169.580178]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.580180]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.580182]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.580183]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.580185]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.580187]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.580189]  [<ffffffff811e530e>] do_select+0x5ae/0x770
[  169.580192]  [<ffffffff8169ca7c>] ? __slab_free+0xfe/0x252
[  169.580194]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580196]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580198]  [<ffffffff8158bb76>] ? skb_release_data+0xd6/0x110
[  169.580200]  [<ffffffff81588fe7>] ? kfree_skbmem+0x37/0xa0
[  169.580201]  [<ffffffff8158bf84>] ? consume_skb+0x34/0x80
[  169.580203]  [<ffffffff81591685>] ? skb_free_datagram+0x15/0x40
[  169.580206]  [<ffffffff8168010e>] ? packet_recvmsg+0x1ae/0x390
[  169.580208]  [<ffffffff8158251a>] ? sock_recvmsg+0x9a/0xd0
[  169.580210]  [<ffffffff8116a086>] ? free_hot_cold_page_list+0x46/0xa0
[  169.580212]  [<ffffffff81161d0a>] ? unlock_page+0x2a/0x40
[  169.580214]  [<ffffffff8118ab5f>] ? do_wp_page+0x38f/0x770
[  169.580216]  [<ffffffff811e569c>] core_sys_select+0x1cc/0x2e0
[  169.580218]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.580219]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.580221]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.580223]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.580224]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.580226]  [<ffffffff811e585b>] SyS_select+0xab/0x100
[  169.580228]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580229] sudo            S ffff88048f3d4640     0  1728   1611 0x00000080
[  169.580231]  ffff880472baf928 0000000000000082 ffff880473c0efc0 ffff880472baffd8
[  169.580232]  0000000000014640 0000000000014640 ffff880478e19bf0 0000000000000000
[  169.580234]  0000000000000040 0000000000000080 0000000000000007 0000000000000007
[  169.580236] Call Trace:
[  169.580238]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.580240]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.580242]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.580244]  [<ffffffff8163f962>] ? unix_dgram_poll+0x42/0x1e0
[  169.580246]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.580248]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.580250]  [<ffffffff811e530e>] do_select+0x5ae/0x770
[  169.580252]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580254]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580256]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.580258]  [<ffffffff811ab644>] ? alloc_pages_current+0xa4/0x170
[  169.580260]  [<ffffffff8132a8e1>] ? cpumask_any_but+0x31/0x40
[  169.580262]  [<ffffffff8105891e>] ? flush_tlb_page+0x3e/0xa0
[  169.580264]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  169.580266]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  169.580268]  [<ffffffff8118aacc>] ? do_wp_page+0x2fc/0x770
[  169.580270]  [<ffffffff811e569c>] core_sys_select+0x1cc/0x2e0
[  169.580272]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.580273]  [<ffffffff810ae54c>] ? enqueue_task+0x2c/0x70
[  169.580275]  [<ffffffff810b2695>] ? check_preempt_curr+0x75/0xa0
[  169.580277]  [<ffffffff810b520c>] ? wake_up_new_task+0x10c/0x170
[  169.580279]  [<ffffffff8108342f>] ? do_fork+0x12f/0x300
[  169.580281]  [<ffffffff811e585b>] SyS_select+0xab/0x100
[  169.580283]  [<ffffffff816a90a2>] ? do_page_fault+0x22/0x30
[  169.580284]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580285] bash            R  running task        0  1729   1728 0x00000080
[  169.580287]  0000000000000000 ffff880470d13e48 ffffffff810b4838 ffff8804776e8950
[  169.580289]  0000000000000000 ffff880470d13e78 ffffffff810b4912 ffff8804776e8bb0
[  169.580291]  ffffffff81ca4940 0000000000000074 0000000000000246 ffff880470d13e88
[  169.580292] Call Trace:
[  169.580294]  [<ffffffff810b4838>] sched_show_task+0xa8/0x110
[  169.580296]  [<ffffffff810b4912>] show_state_filter+0x72/0xb0
[  169.580298]  [<ffffffff813f82c0>] sysrq_handle_showstate+0x10/0x20
[  169.580300]  [<ffffffff813f8952>] __handle_sysrq+0xa2/0x170
[  169.580302]  [<ffffffff813f8e5f>] write_sysrq_trigger+0x2f/0x40
[  169.580305]  [<ffffffff81237b4d>] proc_reg_write+0x3d/0x80
[  169.580307]  [<ffffffff811d172a>] vfs_write+0xba/0x1e0
[  169.580309]  [<ffffffff811d2276>] SyS_write+0x46/0xb0
[  169.580310]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580311] xterm           S ffff88048f214640     0  1755   1491 0x00000080
[  169.580313]  ffff880473edf928 0000000000000082 ffff880471b08000 ffff880473edffd8
[  169.580315]  0000000000014640 0000000000014640 ffff880472855d20 0000000000000000
[  169.580316]  0000000000000040 0000000000000020 0000000000000005 0000000000000005
[  169.580318] Call Trace:
[  169.580320]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.580322]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.580324]  [<ffffffff811e487f>] ? __pollwait+0x7f/0xf0
[  169.580326]  [<ffffffff813f705f>] ? pty_write_room+0x2f/0x50
[  169.580327]  [<ffffffff813f2dbd>] ? tty_write_room+0x1d/0x20
[  169.580329]  [<ffffffff813ef367>] ? n_tty_poll+0x1b7/0x1d0
[  169.580331]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.580333]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.580335]  [<ffffffff811e530e>] do_select+0x5ae/0x770
[  169.580337]  [<ffffffff810b26a5>] ? check_preempt_curr+0x85/0xa0
[  169.580339]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580341]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580343]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580345]  [<ffffffff810c7c70>] ? __wake_up_sync_key+0x50/0x60
[  169.580347]  [<ffffffff816a36b2>] ? mutex_lock_interruptible+0x12/0x3c
[  169.580349]  [<ffffffff8164065c>] ? unix_stream_recvmsg+0x75c/0x880
[  169.580351]  [<ffffffff8158497a>] ? sock_def_readable+0x3a/0x70
[  169.580353]  [<ffffffff8158251a>] ? sock_recvmsg+0x9a/0xd0
[  169.580355]  [<ffffffff811e569c>] core_sys_select+0x1cc/0x2e0
[  169.580357]  [<ffffffff81582679>] ? SYSC_recvfrom+0xd9/0x140
[  169.580358]  [<ffffffff813ec33c>] ? tty_read+0x9c/0x100
[  169.580360]  [<ffffffff811e585b>] SyS_select+0xab/0x100
[  169.580362]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.580364]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580365] bash            S ffff88048f3d4640     0  1760   1755 0x00000080
[  169.580367]  ffff880471b87d00 0000000000000082 ffff8804776eefc0 ffff880471b87fd8
[  169.580368]  0000000000014640 0000000000014640 ffff880472da8950 ffff880477cb4cd8
[  169.580370]  ffff880477cb4c00 7fffffffffffffff 00007fffc6a5af17 ffffc90011d2b000
[  169.580372] Call Trace:
[  169.580374]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.580376]  [<ffffffff816a1679>] schedule_timeout+0x1f9/0x270
[  169.580378]  [<ffffffff8109c3e2>] ? insert_work+0x62/0xa0
[  169.580380]  [<ffffffff810c77e8>] ? __wake_up_common+0x58/0x90
[  169.580381]  [<ffffffff8109c546>] ? __queue_work+0x126/0x310
[  169.580383]  [<ffffffff813f0e6c>] n_tty_read+0x49c/0xb70
[  169.580385]  [<ffffffff81341b3d>] ? list_del+0xd/0x30
[  169.580387]  [<ffffffff810c7c11>] ? remove_wait_queue+0x31/0x40
[  169.580388]  [<ffffffff813efc72>] ? n_tty_write+0x392/0x500
[  169.580390]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.580392]  [<ffffffff813ec32d>] tty_read+0x8d/0x100
[  169.580394]  [<ffffffff811d15ab>] vfs_read+0x9b/0x160
[  169.580395]  [<ffffffff811d21c6>] SyS_read+0x46/0xb0
[  169.580397]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.580399]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580400] packagekitd     S ffff88048f3d4640     0  1793      1 0x00000080
[  169.580402]  ffff880473edda60 0000000000000086 ffff880471b0a540 ffff880473eddfd8
[  169.580403]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff880473eddb98
[  169.580405]  00000000004c37b7 0000000000000000 ffff880473eddbbc 0000000000000000
[  169.580407] Call Trace:
[  169.580409]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.580411]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.580413]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.580415]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.580417]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.580418]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.580420]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.580422]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.580424]  [<ffffffff810b9338>] ? __enqueue_entity+0x78/0x80
[  169.580426]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580428]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580430]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.580432]  [<ffffffff810b282d>] ? ttwu_do_activate.constprop.97+0x5d/0x70
[  169.580433]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.580435]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.580437]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.580439]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.580441]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.580443]  [<ffffffff810c77e8>] ? __wake_up_common+0x58/0x90
[  169.580444]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.580446]  [<ffffffff810b4e50>] ? wake_up_state+0x20/0x20
[  169.580448]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.580449]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.580451]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.580453]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580454] gdbus           S ffff88048f214640     0  1794      1 0x00000080
[  169.580456]  ffff880470a87a60 0000000000000086 ffff880473c08950 ffff880470a87fd8
[  169.580457]  0000000000014640 0000000000014640 ffffffff81c16460 0000000000000000
[  169.580459]  0000000000000000 ffff880470a87bc4 ffff880470a87bc4 0000000000000000
[  169.580461] Call Trace:
[  169.580463]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.580465]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.580467]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.580469]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.580471]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.580473]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.580475]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.580477]  [<ffffffff8163fec6>] ? unix_stream_sendmsg+0x3c6/0x400
[  169.580479]  [<ffffffff81581eeb>] ? sock_sendmsg+0x8b/0xc0
[  169.580481]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580483]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580485]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580487]  [<ffffffff811d330c>] ? get_empty_filp+0x5c/0x1c0
[  169.580489]  [<ffffffff810b4e62>] ? default_wake_function+0x12/0x20
[  169.580491]  [<ffffffff811e4b26>] ? pollwake+0x66/0x70
[  169.580493]  [<ffffffff811b7246>] ? kmem_cache_alloc_trace+0x1d6/0x200
[  169.580495]  [<ffffffff812cbfac>] ? selinux_file_alloc_security+0x3c/0x60
[  169.580496]  [<ffffffff812ca826>] ? file_has_perm+0x86/0xa0
[  169.580498]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.580500]  [<ffffffff811ed7a5>] ? __fget_light+0x25/0x70
[  169.580502]  [<ffffffff81583075>] ? __sys_sendmsg+0x65/0x80
[  169.580504]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.580506]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580507] gmain           S ffff88048f394640     0  1796      1 0x00000080
[  169.580508]  ffff880035cd3a60 0000000000000086 ffff880473c0a540 ffff880035cd3fd8
[  169.580510]  0000000000014640 0000000000014640 ffff880478e192a0 0000000000000000
[  169.580512]  0000000000000000 ffff880035cd3bbc ffff880035cd3bbc 0000000000000000
[  169.580514] Call Trace:
[  169.580516]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.580518]  [<ffffffff816a1a25>] schedule_hrtimeout_range_clock+0x135/0x150
[  169.580520]  [<ffffffff810c796c>] ? add_wait_queue+0x3c/0x50
[  169.580522]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.580524]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.580525]  [<ffffffff811e5ef2>] do_sys_poll+0x422/0x540
[  169.580527]  [<ffffffff8116b4d1>] ? __alloc_pages_nodemask+0x171/0xb30
[  169.580529]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580531]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580533]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  169.580535]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  169.580537]  [<ffffffff8118d978>] ? handle_mm_fault+0xa08/0x1070
[  169.580539]  [<ffffffff816a8d4c>] ? __do_page_fault+0x1ec/0x520
[  169.580540]  [<ffffffff8121a3e8>] ? eventfd_ctx_read+0x58/0x1d0
[  169.580542]  [<ffffffff811d1604>] ? vfs_read+0xf4/0x160
[  169.580544]  [<ffffffff811e60e5>] SyS_poll+0x65/0x100
[  169.580546]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580547] htop            S ffff88048f3d4640     0  1798   1573 0x00000080
[  169.580548]  ffff8804740a9928 0000000000000082 ffff880472852e90 ffff8804740a9fd8
[  169.580550]  0000000000014640 0000000000014640 ffff880478e19bf0 ffff8804740a9ae8
[  169.580552]  00000000000aae5f 0000000000000000 0000000000000001 0000000000000001
[  169.580554] Call Trace:
[  169.580556]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.580558]  [<ffffffff816a19fc>] schedule_hrtimeout_range_clock+0x10c/0x150
[  169.580559]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.580561]  [<ffffffff816a1987>] ? schedule_hrtimeout_range_clock+0x97/0x150
[  169.580563]  [<ffffffff816a1a53>] schedule_hrtimeout_range+0x13/0x20
[  169.580565]  [<ffffffff811e4939>] poll_schedule_timeout+0x49/0x70
[  169.580567]  [<ffffffff811e530e>] do_select+0x5ae/0x770
[  169.580570]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580572]  [<ffffffff811e4ac0>] ? poll_select_copy_remaining+0x130/0x130
[  169.580573]  [<ffffffff810b9338>] ? __enqueue_entity+0x78/0x80
[  169.580575]  [<ffffffff810bf917>] ? enqueue_entity+0x237/0x8c0
[  169.580577]  [<ffffffff810be986>] ? check_preempt_wakeup+0x146/0x220
[  169.580578]  [<ffffffff810b26a5>] ? check_preempt_curr+0x85/0xa0
[  169.580580]  [<ffffffff810b26d9>] ? ttwu_do_wakeup+0x19/0xc0
[  169.580582]  [<ffffffff810b282d>] ? ttwu_do_activate.constprop.97+0x5d/0x70
[  169.580584]  [<ffffffff810b4d4d>] ? try_to_wake_up+0x1dd/0x280
[  169.580585]  [<ffffffff810b4e13>] ? wake_up_process+0x23/0x40
[  169.580587]  [<ffffffff8109b894>] ? wake_up_worker+0x24/0x30
[  169.580589]  [<ffffffff8109c3e2>] ? insert_work+0x62/0xa0
[  169.580591]  [<ffffffff811e569c>] core_sys_select+0x1cc/0x2e0
[  169.580592]  [<ffffffff810b9338>] ? __enqueue_entity+0x78/0x80
[  169.580594]  [<ffffffff810bf35b>] ? put_prev_entity+0x5b/0x3b0
[  169.580596]  [<ffffffff810b96e9>] ? pick_next_entity+0xa9/0x190
[  169.580597]  [<ffffffff810ba5bf>] ? set_next_entity+0x5f/0x80
[  169.580599]  [<ffffffff8101beb9>] ? __switch_to_xtra+0x159/0x170
[  169.580601]  [<ffffffff8101a179>] ? read_tsc+0x9/0x20
[  169.580602]  [<ffffffff810e6578>] ? ktime_get_ts+0x48/0xe0
[  169.580604]  [<ffffffff811e585b>] SyS_select+0xab/0x100
[  169.580606]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580607] systemd-udevd   R  running task        0  1824    577 0x0000008c
[  169.580609]  00007fff2fc589f0 0000000000000400 00007f54d2c642a0 00007f54d24ac970
[  169.580610]  00007fff2fc589f0 ffffffff816ade69 0000000000000246 00007f54d2c76770
[  169.580612]  0000000000000005 0000000000000000 0000000000000059 ffffffffffffffff
[  169.580614] Call Trace:
[  169.580616]  [<ffffffff816ade69>] ? system_call_fastpath+0x16/0x1b
[  169.580617] systemd-udevd   R  running task        0  1825    577 0x00000084
[  169.580618]  ffffffff811e7440 01ff88045cfd0cc0 ffff88045cfd0d18 ffff88045cfd0d18
[  169.580620]  ffff88045cfd0cc0 ffff88045cfd0d60 ffffffff811e6eb0 ffff880470bdfc40
[  169.580622]  0000055200000000 ffff880470bdfc48 ffff88045cfd0cc0 0000000000000010
[  169.580624] Call Trace:
[  169.580626]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  169.580628]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  169.580630]  [<ffffffff811e81b2>] ? check_submounts_and_drop+0x62/0xa0
[  169.580633]  [<ffffffff81245c5d>] ? kernfs_dop_revalidate+0x5d/0xd0
[  169.580634]  [<ffffffff811dba4d>] ? lookup_fast+0x26d/0x2c0
[  169.580636]  [<ffffffff811dcaa3>] ? link_path_walk+0x1a3/0x860
[  169.580638]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  169.580640]  [<ffffffff811dd1bb>] ? path_lookupat+0x5b/0x780
[  169.580641]  [<ffffffff8118896c>] ? tlb_flush_mmu_free+0x2c/0x50
[  169.580643]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  169.580645]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  169.580647]  [<ffffffff811dd90b>] ? filename_lookup+0x2b/0xc0
[  169.580648]  [<ffffffff811e1984>] ? user_path_at_empty+0x54/0x90
[  169.580650]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  169.580653]  [<ffffffff811d69ec>] ? SyS_readlink+0x4c/0x130
[  169.580655]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.580656]  [<ffffffff816ade69>] ? system_call_fastpath+0x16/0x1b
[  169.580657] systemd-udevd   R  running task        0  1826    577 0x00000084
[  169.580659]  ffffffff811e7440 01ffffff816a1d2a ffff88045cfd0d18 ffff88045cfd0d18
[  169.580661]  ffff88045cfd0cc0 ffff88045cfd0d60 ffffffff811e6eb0 ffff8804707f3c40
[  169.580662]  0000055200000000 ffff8804707f3c48 ffff88045cfd0cc0 0000000000000010
[  169.580664] Call Trace:
[  169.580666]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  169.580668]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  169.580670]  [<ffffffff811e81b2>] ? check_submounts_and_drop+0x62/0xa0
[  169.580672]  [<ffffffff81245c5d>] ? kernfs_dop_revalidate+0x5d/0xd0
[  169.580673]  [<ffffffff811dba4d>] ? lookup_fast+0x26d/0x2c0
[  169.580675]  [<ffffffff811dcaa3>] ? link_path_walk+0x1a3/0x860
[  169.580677]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  169.580679]  [<ffffffff811dd1bb>] ? path_lookupat+0x5b/0x780
[  169.580680]  [<ffffffff8118896c>] ? tlb_flush_mmu_free+0x2c/0x50
[  169.580682]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  169.580684]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  169.580686]  [<ffffffff811dd90b>] ? filename_lookup+0x2b/0xc0
[  169.580687]  [<ffffffff811e1984>] ? user_path_at_empty+0x54/0x90
[  169.580689]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  169.580691]  [<ffffffff811d69ec>] ? SyS_readlink+0x4c/0x130
[  169.580693]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.580695]  [<ffffffff816ade69>] ? system_call_fastpath+0x16/0x1b
[  169.580696] systemd-udevd   R  running task        0  1827    577 0x00000084
[  169.580697]  ffffffff811e7440 01ffffff816a1d2a ffff88045cfd0d18 ffff88045cfd0d18
[  169.580699]  ffff88045cfd0cc0 ffff88045cfd0d60 ffffffff811e6eb0 ffff880470aebc40
[  169.580701]  0000055200000000 ffff880470aebc48 ffff88045cfd0cc0 0000000000000010
[  169.580703] Call Trace:
[  169.580705]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  169.580707]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  169.580708]  [<ffffffff811e81b2>] ? check_submounts_and_drop+0x62/0xa0
[  169.580710]  [<ffffffff81245c5d>] ? kernfs_dop_revalidate+0x5d/0xd0
[  169.580712]  [<ffffffff811dba4d>] ? lookup_fast+0x26d/0x2c0
[  169.580714]  [<ffffffff811dcaa3>] ? link_path_walk+0x1a3/0x860
[  169.580716]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  169.580717]  [<ffffffff811dd1bb>] ? path_lookupat+0x5b/0x780
[  169.580719]  [<ffffffff8118896c>] ? tlb_flush_mmu_free+0x2c/0x50
[  169.580721]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  169.580722]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  169.580724]  [<ffffffff811dd90b>] ? filename_lookup+0x2b/0xc0
[  169.580726]  [<ffffffff811e1984>] ? user_path_at_empty+0x54/0x90
[  169.580728]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  169.580730]  [<ffffffff811d69ec>] ? SyS_readlink+0x4c/0x130
[  169.580732]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.580733]  [<ffffffff816ade69>] ? system_call_fastpath+0x16/0x1b
[  169.580734] systemd-udevd   R  running task        0  1828    577 0x00000084
[  169.580736]  ffffffff811e7440 01ffffff816a1d2a ffff88045cfd0d18 ffff88045cfd0d18
[  169.580738]  ffff88045cfd0cc0 ffff88045cfd0d60 ffffffff811e6eb0 ffff880472b91c40
[  169.580740]  0000055200000000 ffff880472b91c48 ffff88045cfd0cc0 0000000000000010
[  169.580742] Call Trace:
[  169.580744]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  169.580746]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  169.580747]  [<ffffffff811e81b2>] ? check_submounts_and_drop+0x62/0xa0
[  169.580749]  [<ffffffff81245c5d>] ? kernfs_dop_revalidate+0x5d/0xd0
[  169.580751]  [<ffffffff811dba4d>] ? lookup_fast+0x26d/0x2c0
[  169.580753]  [<ffffffff811dcaa3>] ? link_path_walk+0x1a3/0x860
[  169.580754]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  169.580756]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  169.580758]  [<ffffffff811dd1bb>] ? path_lookupat+0x5b/0x780
[  169.580760]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  169.580762]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  169.580763]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  169.580765]  [<ffffffff811dd90b>] ? filename_lookup+0x2b/0xc0
[  169.580767]  [<ffffffff811e1984>] ? user_path_at_empty+0x54/0x90
[  169.580769]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  169.580771]  [<ffffffff811d69ec>] ? SyS_readlink+0x4c/0x130
[  169.580772]  [<ffffffff816ade69>] ? system_call_fastpath+0x16/0x1b
[  169.580773] systemd-udevd   R  running task        0  1829    577 0x00000080
[  169.580775]  ffffffff811e7440 01ffffff816a1d2a ffff88045cfd0d18 ffff88045cfd0d18
[  169.580777]  ffff88045cfd0cc0 ffff88045cfd0d60 ffffffff811e6eb0 ffff880471aefc40
[  169.580779]  0000055200000000 ffff880471aefc48 ffff88045cfd0cc0 0000000000000010
[  169.580780] Call Trace:
[  169.580782]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  169.580784]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  169.580786]  [<ffffffff811e81b2>] ? check_submounts_and_drop+0x62/0xa0
[  169.580788]  [<ffffffff81245c5d>] ? kernfs_dop_revalidate+0x5d/0xd0
[  169.580790]  [<ffffffff811dba4d>] ? lookup_fast+0x26d/0x2c0
[  169.580791]  [<ffffffff811dcaa3>] ? link_path_walk+0x1a3/0x860
[  169.580793]  [<ffffffff811707fc>] ? lru_cache_add+0x1c/0x40
[  169.580795]  [<ffffffff81198202>] ? page_add_new_anon_rmap+0x112/0x1c0
[  169.580797]  [<ffffffff811dd1bb>] ? path_lookupat+0x5b/0x780
[  169.580798]  [<ffffffff8118d75c>] ? handle_mm_fault+0x7ec/0x1070
[  169.580800]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  169.580802]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  169.580804]  [<ffffffff811dd90b>] ? filename_lookup+0x2b/0xc0
[  169.580805]  [<ffffffff811e1984>] ? user_path_at_empty+0x54/0x90
[  169.580807]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  169.580809]  [<ffffffff811d69ec>] ? SyS_readlink+0x4c/0x130
[  169.580811]  [<ffffffff816ade69>] ? system_call_fastpath+0x16/0x1b
[  169.580812] systemd-udevd   R  running task        0  1830    577 0x00000084
[  169.580813]  ffffffff811e7440 01ffffff816a1d2a ffff88045cfd0d18 ffff88045cfd0d18
[  169.580815]  ffff88045cfd0cc0 ffff88045cfd0d60 ffffffff811e6eb0 ffff880477e2bc40
[  169.580817]  0000055200000000 ffff880477e2bc48 ffff88045cfd0cc0 0000000000000010
[  169.580819] Call Trace:
[  169.580821]  [<ffffffff811e7440>] ? __d_drop+0xb0/0xb0
[  169.580823]  [<ffffffff811e6eb0>] ? select_collect+0xb0/0xb0
[  169.580824]  [<ffffffff811e81b2>] ? check_submounts_and_drop+0x62/0xa0
[  169.580827]  [<ffffffff81245c5d>] ? kernfs_dop_revalidate+0x5d/0xd0
[  169.580828]  [<ffffffff811dba4d>] ? lookup_fast+0x26d/0x2c0
[  169.580830]  [<ffffffff811dcaa3>] ? link_path_walk+0x1a3/0x860
[  169.580832]  [<ffffffff8116f8de>] ? release_pages+0x8e/0x240
[  169.580833]  [<ffffffff811dd1bb>] ? path_lookupat+0x5b/0x780
[  169.580835]  [<ffffffff8118896c>] ? tlb_flush_mmu_free+0x2c/0x50
[  169.580837]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
[  169.580838]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
[  169.580840]  [<ffffffff811dd90b>] ? filename_lookup+0x2b/0xc0
[  169.580842]  [<ffffffff811e1984>] ? user_path_at_empty+0x54/0x90
[  169.580844]  [<ffffffff81193e7f>] ? do_munmap+0x29f/0x3b0
[  169.580846]  [<ffffffff811d69ec>] ? SyS_readlink+0x4c/0x130
[  169.580848]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
[  169.580849]  [<ffffffff816ade69>] ? system_call_fastpath+0x16/0x1b
[  169.580850] sleep           S ffff88048f2d4640     0  1838   1531 0x00000080
[  169.580852]  ffff8800657a7e68 0000000000000082 ffff880473c09bf0 ffff8800657a7fd8
[  169.580854]  0000000000014640 0000000000014640 ffff880478d56fc0 ffff8800657a7ec8
[  169.580856]  ffff880473c09bf0 ffff880473c09bf0 ffff880473c09bf0 ffff880473c09bf0
[  169.580858] Call Trace:
[  169.580860]  [<ffffffff816a21b9>] schedule+0x29/0x70
[  169.580862]  [<ffffffff816a1815>] do_nanosleep+0xc5/0x130
[  169.580863]  [<ffffffff810a9346>] hrtimer_nanosleep+0xa6/0x160
[  169.580865]  [<ffffffff810a81d0>] ? hrtimer_get_res+0x50/0x50
[  169.580867]  [<ffffffff816a17c1>] ? do_nanosleep+0x71/0x130
[  169.580869]  [<ffffffff810a9466>] SyS_nanosleep+0x66/0x80
[  169.580871]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b
[  169.580872] Sched Debug Version: v0.11, 3.15.0-rc7 #55
[  169.580874] ktime                                   : 170367.717696
[  169.580875] sched_clk                               : 169580.872211
[  169.580876] cpu_clk                                 : 169580.872232
[  169.580877] jiffies                                 : 4294837664
[  169.580878] sched_clock_stable()                    : 1

[  169.580879] sysctl_sched
[  169.580880]   .sysctl_sched_latency                    : 24.000000
[  169.580881]   .sysctl_sched_min_granularity            : 3.000000
[  169.580882]   .sysctl_sched_wakeup_granularity         : 4.000000
[  169.580883]   .sysctl_sched_child_runs_first           : 0
[  169.580884]   .sysctl_sched_features                   : 77435
[  169.580885]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)

[  169.580887] cpu#0, 3492.133 MHz
[  169.580888]   .nr_running                    : 1
[  169.580889]   .load                          : 146
[  169.580890]   .nr_switches                   : 47612
[  169.580891]   .nr_load_updates               : 46013
[  169.580892]   .nr_uninterruptible            : -142
[  169.580893]   .next_balance                  : 4294.837722
[  169.580894]   .curr->pid                     : 1827
[  169.580895]   .clock                         : 169580.155891
[  169.580896]   .cpu_load[0]                   : 146
[  169.580896]   .cpu_load[1]                   : 146
[  169.580897]   .cpu_load[2]                   : 146
[  169.580898]   .cpu_load[3]                   : 146
[  169.580899]   .cpu_load[4]                   : 146
[  169.580901] 
cfs_rq[0]:/autogroup-37
[  169.580902]   .exec_clock                    : 0.000000
[  169.580903]   .MIN_vruntime                  : 0.000001
[  169.580904]   .min_vruntime                  : 17995.883653
[  169.580905]   .max_vruntime                  : 0.000001
[  169.580906]   .spread                        : 0.000000
[  169.580907]   .spread0                       : -99723.138976
[  169.580908]   .nr_spread_over                : 0
[  169.580909]   .nr_running                    : 1
[  169.580910]   .load                          : 1024
[  169.580911]   .runnable_load_avg             : 1023
[  169.580912]   .blocked_load_avg              : 0
[  169.580912]   .tg_load_contrib               : 1023
[  169.580913]   .tg_runnable_contrib           : 1022
[  169.580914]   .tg_load_avg                   : 7161
[  169.580915]   .tg->runnable_avg              : 6514
[  169.580916]   .tg->cfs_bandwidth.timer_active: 0
[  169.580917]   .throttled                     : 0
[  169.580918]   .throttle_count                : 0
[  169.580919]   .se->exec_start                : 169287.434215
[  169.580920]   .se->vruntime                  : 117719.022629
[  169.580921]   .se->sum_exec_runtime          : 17941.142214
[  169.580922]   .se->load.weight               : 146
[  169.580923]   .se->avg.runnable_avg_sum      : 46813
[  169.580924]   .se->avg.runnable_avg_period   : 46828
[  169.580924]   .se->avg.load_avg_contrib      : 146
[  169.580925]   .se->avg.decay_count           : 0
[  169.580926] 
cfs_rq[0]:/
[  169.580928]   .exec_clock                    : 0.000000
[  169.580929]   .MIN_vruntime                  : 0.000001
[  169.580930]   .min_vruntime                  : 117719.022629
[  169.580931]   .max_vruntime                  : 0.000001
[  169.580932]   .spread                        : 0.000000
[  169.580932]   .spread0                       : 0.000000
[  169.580933]   .nr_spread_over                : 0
[  169.580934]   .nr_running                    : 1
[  169.580935]   .load                          : 146
[  169.580936]   .runnable_load_avg             : 146
[  169.580937]   .blocked_load_avg              : 0
[  169.580938]   .tg_load_contrib               : 146
[  169.580938]   .tg_runnable_contrib           : 1017
[  169.580939]   .tg_load_avg                   : 1024
[  169.580940]   .tg->runnable_avg              : 6523
[  169.580941]   .tg->cfs_bandwidth.timer_active: 0
[  169.580942]   .throttled                     : 0
[  169.580943]   .throttle_count                : 0
[  169.580944]   .avg->runnable_avg_sum         : 46728
[  169.580944]   .avg->runnable_avg_period      : 46743
[  169.580949] 
rt_rq[0]:/
[  169.580950]   .rt_nr_running                 : 0
[  169.580951]   .rt_throttled                  : 0
[  169.580952]   .rt_time                       : 0.000000
[  169.580953]   .rt_runtime                    : 950.000000
[  169.580953] 
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[  169.580956]      ksoftirqd/0     3    103521.338639      1018   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.580959]      kworker/0:0     4       752.842677        19   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.580963]     kworker/0:0H     5      1050.740360         6   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.580966]           rcu_bh     8        25.785348         2   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.580969]      migration/0     9         0.000000       330     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.580972]       watchdog/0    10        -5.750011        46     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.580976]            khubd    57      5027.723322       413   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.580979]      kworker/0:1    59      4788.176419       495   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.580982]        scsi_eh_0    95       757.777045        27   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.580985]        scsi_eh_5   105      2731.763289        62   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.580988]    kworker/u16:5   110       770.338100        14   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.580991]       scsi_eh_13   126       759.713765        52   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.580994]   kworker/u16:12   133      4832.138578         9   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.580998]      kworker/0:2   137    117653.971669      2509   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581001]   kworker/u16:15   141       758.334292        40   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581004]          kauditd   184      4820.093722       749   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581007]     kworker/0:1H   366      4833.452909      4393   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581010]      jbd2/dm-1-8   470     85123.926837       250   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581013]  systemd-journal   568       102.249477       575   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-33
[  169.581016]        hd-audio0   775      2380.326015         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581020]          audispd   845         5.075706       664   112               0               0               0.000000               0.000000               0.000000 0 /autogroup-54
[  169.581023]          audispd   850         5.030783       729   112               0               0               0.000000               0.000000               0.000000 0 /autogroup-54
[  169.581026]     avahi-daemon   861         8.325868       206   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-64
[  169.581029]       irqbalance   862        24.509026        20   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-61
[  169.581033]          chronyd   867         0.220885        19   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-65
[  169.581036]            crond   879         4.931600        20   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-73
[  169.581039]             sshd  1090         1.398028         5   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-85
[  169.581043]  gdm-session-wor  1477       136.848797        80   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-81
[  169.581046]      dbus-daemon  1502         5.043312        72   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.581049]  at-spi-bus-laun  1536         3.076686        31   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.581053]      dbus-daemon  1540         0.622837        26   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.581056]            gdbus  1547         3.446316        13   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.581059]         dhclient  1627         3.182205        18   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-83
[  169.581062]            xterm  1755         8.230380       837   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-110
[  169.581066]            gdbus  1794         6.462765        48   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-112
[  169.581069] R  systemd-udevd  1827     17995.883653      1116   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-37

[  169.581073] cpu#1, 3492.133 MHz
[  169.581074]   .nr_running                    : 1
[  169.581075]   .load                          : 146
[  169.581076]   .nr_switches                   : 28867
[  169.581077]   .nr_load_updates               : 43635
[  169.581078]   .nr_uninterruptible            : -15
[  169.581079]   .next_balance                  : 4294.837694
[  169.581080]   .curr->pid                     : 1829
[  169.581081]   .clock                         : 169580.160887
[  169.581081]   .cpu_load[0]                   : 146
[  169.581082]   .cpu_load[1]                   : 146
[  169.581083]   .cpu_load[2]                   : 146
[  169.581084]   .cpu_load[3]                   : 146
[  169.581085]   .cpu_load[4]                   : 146
[  169.581086] 
cfs_rq[1]:/autogroup-37
[  169.581087]   .exec_clock                    : 0.000000
[  169.581088]   .MIN_vruntime                  : 0.000001
[  169.581089]   .min_vruntime                  : 22312.641276
[  169.581090]   .max_vruntime                  : 0.000001
[  169.581091]   .spread                        : 0.000000
[  169.581092]   .spread0                       : -95406.381353
[  169.581093]   .nr_spread_over                : 0
[  169.581093]   .nr_running                    : 1
[  169.581094]   .load                          : 1024
[  169.581095]   .runnable_load_avg             : 1023
[  169.581096]   .blocked_load_avg              : 0
[  169.581097]   .tg_load_contrib               : 1023
[  169.581098]   .tg_runnable_contrib           : 1010
[  169.581099]   .tg_load_avg                   : 7161
[  169.581099]   .tg->runnable_avg              : 6514
[  169.581100]   .tg->cfs_bandwidth.timer_active: 0
[  169.581101]   .throttled                     : 0
[  169.581102]   .throttle_count                : 0
[  169.581103]   .se->exec_start                : 169464.237146
[  169.581104]   .se->vruntime                  : 143638.424184
[  169.581105]   .se->sum_exec_runtime          : 22345.577456
[  169.581106]   .se->load.weight               : 146
[  169.581107]   .se->avg.runnable_avg_sum      : 46518
[  169.581108]   .se->avg.runnable_avg_period   : 46533
[  169.581109]   .se->avg.load_avg_contrib      : 146
[  169.581109]   .se->avg.decay_count           : 0
[  169.581110] 
cfs_rq[1]:/
[  169.581111]   .exec_clock                    : 0.000000
[  169.581112]   .MIN_vruntime                  : 0.000001
[  169.581113]   .min_vruntime                  : 143638.424184
[  169.581114]   .max_vruntime                  : 0.000001
[  169.581115]   .spread                        : 0.000000
[  169.581116]   .spread0                       : 25919.401555
[  169.581117]   .nr_spread_over                : 0
[  169.581118]   .nr_running                    : 1
[  169.581119]   .load                          : 146
[  169.581119]   .runnable_load_avg             : 146
[  169.581120]   .blocked_load_avg              : 0
[  169.581121]   .tg_load_contrib               : 146
[  169.581122]   .tg_runnable_contrib           : 1013
[  169.581123]   .tg_load_avg                   : 1024
[  169.581124]   .tg->runnable_avg              : 6523
[  169.581124]   .tg->cfs_bandwidth.timer_active: 0
[  169.581125]   .throttled                     : 0
[  169.581126]   .throttle_count                : 0
[  169.581127]   .avg->runnable_avg_sum         : 46160
[  169.581128]   .avg->runnable_avg_period      : 46175
[  169.581129] 
rt_rq[1]:/
[  169.581130]   .rt_nr_running                 : 0
[  169.581131]   .rt_throttled                  : 0
[  169.581132]   .rt_time                       : 0.000000
[  169.581133]   .rt_runtime                    : 950.000000
[  169.581134] 
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[  169.581136]        rcu_sched     7    143626.427952     15744   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581139]       watchdog/1    11        -2.954378        46     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.581142]      migration/1    12         0.000000       226     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.581144]      ksoftirqd/1    13     88870.560489       179   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581147]      kworker/1:0    14        11.437794        21   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581150]     kworker/1:0H    15       621.714354         7   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581154]       khugepaged    51     94468.598042        19   139               0               0               0.000000               0.000000               0.000000 0 /
[  169.581157]    fsnotify_mark    83      4358.045718       187   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581160]        scsi_eh_3   101       -12.305781        29   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581163]    kworker/u16:4   109       -12.905309        11   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581166]        scsi_eh_7   114       -12.542052        23   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581169]       scsi_eh_12   124       -12.906056        23   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581172]    kworker/u16:9   130         0.922776         7   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581175]      kworker/1:1   142      3840.471960        21   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581178]      kworker/1:2   197    138984.624082       426   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581181]     kworker/1:1H   394    111082.225084       308   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581185]      jbd2/dm-2-8   831     54500.612872        42   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581188]           auditd   837         1.082878       754   116               0               0               0.000000               0.000000               0.000000 0 /autogroup-52
[  169.581191]       sedispatch   848         1.296284       563   116               0               0               0.000000               0.000000               0.000000 0 /autogroup-54
[  169.581194]  accounts-daemon   857        64.507591       127   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-59
[  169.581198]     ModemManager   870        12.600617        14   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-67
[  169.581201]            gmain   875        -1.021104         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-67
[  169.581204]              atd   878         2.948776         4   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-72
[  169.581207]           mcelog   891         0.036001         2   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-75
[  169.581211]   abrt-watch-log   895        21.546210         9   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-79
[  169.581214]            gmain   911        11.776483         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-81
[  169.581217]          systemd  1212         2.811251        26   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-90
[  169.581220]            gdbus  1385         3.329535        98   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-94
[  169.581224]  systemd-localed  1416         0.941384         8   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-97
[  169.581227]         (sd-pam)  1488         5.125623         2   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-99
[  169.581230]              dwm  1491        43.085224      1290   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-101
[  169.581233]      dbus-launch  1501         1.119110         8   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-101
[  169.581237]  update-titlebar  1531        31.182799        31   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-101
[  169.581240]            gdbus  1550         3.014069        14   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.581243]            gdbus  1564        14.102433        28   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.581246]             bash  1611         0.254981        69   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-107
[  169.581249] R  systemd-udevd  1829     22313.635530      1926   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-37

[  169.581254] cpu#2, 3492.133 MHz
[  169.581254]   .nr_running                    : 1
[  169.581255]   .load                          : 146
[  169.581256]   .nr_switches                   : 30466
[  169.581257]   .nr_load_updates               : 41582
[  169.581258]   .nr_uninterruptible            : 13
[  169.581259]   .next_balance                  : 4294.837782
[  169.581260]   .curr->pid                     : 1825
[  169.581261]   .clock                         : 169581.154963
[  169.581261]   .cpu_load[0]                   : 146
[  169.581262]   .cpu_load[1]                   : 146
[  169.581263]   .cpu_load[2]                   : 146
[  169.581264]   .cpu_load[3]                   : 146
[  169.581265]   .cpu_load[4]                   : 146
[  169.581266] 
cfs_rq[2]:/autogroup-37
[  169.581267]   .exec_clock                    : 0.000000
[  169.581268]   .MIN_vruntime                  : 0.000001
[  169.581269]   .min_vruntime                  : 35754.984534
[  169.581270]   .max_vruntime                  : 0.000001
[  169.581271]   .spread                        : 0.000000
[  169.581272]   .spread0                       : -81971.037226
[  169.581273]   .nr_spread_over                : 0
[  169.581273]   .nr_running                    : 1
[  169.581274]   .load                          : 1024
[  169.581275]   .runnable_load_avg             : 1023
[  169.581276]   .blocked_load_avg              : 0
[  169.581277]   .tg_load_contrib               : 1023
[  169.581278]   .tg_runnable_contrib           : 1021
[  169.581278]   .tg_load_avg                   : 7161
[  169.581279]   .tg->runnable_avg              : 6514
[  169.581280]   .tg->cfs_bandwidth.timer_active: 0
[  169.581281]   .throttled                     : 0
[  169.581282]   .throttle_count                : 0
[  169.581283]   .se->exec_start                : 169492.073348
[  169.581284]   .se->vruntime                  : 221675.291166
[  169.581285]   .se->sum_exec_runtime          : 35754.209426
[  169.581286]   .se->load.weight               : 146
[  169.581287]   .se->avg.runnable_avg_sum      : 46615
[  169.581287]   .se->avg.runnable_avg_period   : 46630
[  169.581288]   .se->avg.load_avg_contrib      : 146
[  169.581289]   .se->avg.decay_count           : 0
[  169.581290] 
cfs_rq[2]:/
[  169.581291]   .exec_clock                    : 0.000000
[  169.581292]   .MIN_vruntime                  : 0.000001
[  169.581293]   .min_vruntime                  : 221675.291166
[  169.581294]   .max_vruntime                  : 0.000001
[  169.581295]   .spread                        : 0.000000
[  169.581296]   .spread0                       : 103949.269406
[  169.581297]   .nr_spread_over                : 0
[  169.581297]   .nr_running                    : 1
[  169.581298]   .load                          : 146
[  169.581299]   .runnable_load_avg             : 146
[  169.581300]   .blocked_load_avg              : 0
[  169.581301]   .tg_load_contrib               : 146
[  169.581302]   .tg_runnable_contrib           : 1013
[  169.581303]   .tg_load_avg                   : 1024
[  169.581303]   .tg->runnable_avg              : 6523
[  169.581304]   .tg->cfs_bandwidth.timer_active: 0
[  169.581305]   .throttled                     : 0
[  169.581306]   .throttle_count                : 0
[  169.581307]   .avg->runnable_avg_sum         : 46327
[  169.581308]   .avg->runnable_avg_period      : 46342
[  169.581309] 
rt_rq[2]:/
[  169.581310]   .rt_nr_running                 : 0
[  169.581311]   .rt_throttled                  : 0
[  169.581312]   .rt_time                       : 0.000000
[  169.581313]   .rt_runtime                    : 950.000000
[  169.581314] 
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[  169.581316]       watchdog/2    16        -5.981262        45     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.581318]      migration/2    17         0.000000        60     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.581322]      ksoftirqd/2    18      2474.266943       101   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581325]      kworker/2:0    19      2359.748879        49   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581328]     kworker/2:0H    20        -7.048535         5   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581331]    kworker/u16:1    66       -12.734925         8   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581334]        scsi_eh_2    99       -13.038395         3   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581338]    kworker/u16:6   111         0.918668        14   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581340]        scsi_eh_8   116       -12.607800        23   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581343]       scsi_eh_11   122       -12.593558        24   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581347]      kworker/2:1   145    216980.485764      2244   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581350]      kworker/2:2   519       311.695382         4   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581353]      kworker/2:3   520       312.386173         4   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581356]            gmain   865        -8.258410        66   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-59
[  169.581360]            gdbus   883        -8.169951       168   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-59
[  169.581363]     rtkit-daemon   858         2.447863        33   121               0               0               0.000000               0.000000               0.000000 0 /autogroup-60
[  169.581366]     rtkit-daemon   886         2.634178        23   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-60
[  169.581369]      dbus-daemon   881        10.987416         4   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-69
[  169.581372]            gmain   917        -8.597728        12   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-82
[  169.581376]  runaway-killer-   925         0.200800        18   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-82
[  169.581379]       bluetoothd  1122        -1.001230        18   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-87
[  169.581382]            gdbus  1297         1.404229        25   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-93
[  169.581386] R  systemd-udevd  1825     35754.984534      2968   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-37

[  169.581390] cpu#3, 3492.133 MHz
[  169.581391]   .nr_running                    : 1
[  169.581392]   .load                          : 146
[  169.581393]   .nr_switches                   : 23167
[  169.581394]   .nr_load_updates               : 41387
[  169.581394]   .nr_uninterruptible            : 10
[  169.581395]   .next_balance                  : 4294.837748
[  169.581396]   .curr->pid                     : 1826
[  169.581397]   .clock                         : 169581.155176
[  169.581398]   .cpu_load[0]                   : 146
[  169.581399]   .cpu_load[1]                   : 146
[  169.581400]   .cpu_load[2]                   : 146
[  169.581400]   .cpu_load[3]                   : 146
[  169.581401]   .cpu_load[4]                   : 146
[  169.581402] 
cfs_rq[3]:/autogroup-37
[  169.581403]   .exec_clock                    : 0.000000
[  169.581404]   .MIN_vruntime                  : 0.000001
[  169.581405]   .min_vruntime                  : 24626.792031
[  169.581406]   .max_vruntime                  : 0.000001
[  169.581407]   .spread                        : 0.000000
[  169.581408]   .spread0                       : -93099.229729
[  169.581409]   .nr_spread_over                : 0
[  169.581410]   .nr_running                    : 1
[  169.581410]   .load                          : 1024
[  169.581411]   .runnable_load_avg             : 1023
[  169.581412]   .blocked_load_avg              : 0
[  169.581413]   .tg_load_contrib               : 1023
[  169.581414]   .tg_runnable_contrib           : 1017
[  169.581415]   .tg_load_avg                   : 7161
[  169.581416]   .tg->runnable_avg              : 6514
[  169.581416]   .tg->cfs_bandwidth.timer_active: 0
[  169.581417]   .throttled                     : 0
[  169.581418]   .throttle_count                : 0
[  169.581419]   .se->exec_start                : 169504.481801
[  169.581420]   .se->vruntime                  : 156196.919387
[  169.581421]   .se->sum_exec_runtime          : 24579.229432
[  169.581422]   .se->load.weight               : 146
[  169.581423]   .se->avg.runnable_avg_sum      : 46605
[  169.581424]   .se->avg.runnable_avg_period   : 46620
[  169.581424]   .se->avg.load_avg_contrib      : 146
[  169.581425]   .se->avg.decay_count           : 0
[  169.581426] 
cfs_rq[3]:/
[  169.581427]   .exec_clock                    : 0.000000
[  169.581428]   .MIN_vruntime                  : 0.000001
[  169.581429]   .min_vruntime                  : 156196.919387
[  169.581430]   .max_vruntime                  : 0.000001
[  169.581431]   .spread                        : 0.000000
[  169.581432]   .spread0                       : 38470.897627
[  169.581433]   .nr_spread_over                : 0
[  169.581434]   .nr_running                    : 1
[  169.581434]   .load                          : 146
[  169.581435]   .runnable_load_avg             : 146
[  169.581436]   .blocked_load_avg              : 0
[  169.581437]   .tg_load_contrib               : 146
[  169.581438]   .tg_runnable_contrib           : 1011
[  169.581439]   .tg_load_avg                   : 1024
[  169.581439]   .tg->runnable_avg              : 6523
[  169.581440]   .tg->cfs_bandwidth.timer_active: 0
[  169.581441]   .throttled                     : 0
[  169.581442]   .throttle_count                : 0
[  169.581443]   .avg->runnable_avg_sum         : 46733
[  169.581444]   .avg->runnable_avg_period      : 46748
[  169.581445] 
rt_rq[3]:/
[  169.581446]   .rt_nr_running                 : 0
[  169.581447]   .rt_throttled                  : 0
[  169.581448]   .rt_time                       : 0.000000
[  169.581449]   .rt_runtime                    : 950.000000
[  169.581450] 
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[  169.581451]    kworker/u16:0     6       -10.434334        26   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581455]       watchdog/3    21        -5.982237        46     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.581457]      migration/3    22         0.000000       175     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.581460]      ksoftirqd/3    23      3603.768176        92   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581463]      kworker/3:0    24    151473.598289       384   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581466]     kworker/3:0H    25       629.120203         7   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581469]        kdevtmpfs    47      3641.697366       224   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581473]        scsi_eh_1    97       -13.039326         3   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581476]       scsi_eh_10   120       -12.591599        23   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581479]   kworker/u16:11   132         0.992255         7   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581482]      kworker/3:1   346       208.805122        17   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581485]      kworker/3:2   397      2724.198553        36   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581488]      kworker/3:3   460       220.732405         2   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581491]     kworker/3:1H   634       641.120157         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581494]          alsactl   854         0.625050        43   139               0               0               0.000000               0.000000               0.000000 0 /autogroup-56
[  169.581498]     avahi-daemon   868         5.638913         3   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-64
[  169.581501]            gdbus   882         0.976484         6   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-67
[  169.581504]            abrtd   893        10.338825         8   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-77
[  169.581507]            gdbus   908        19.533555        63   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-81
[  169.581510]            gmain   916        19.354731         6   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-81
[  169.581513]   NetworkManager   984        25.909664       298   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-83
[  169.581517]            gmain  1070        11.571577         6   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-83
[  169.581520]  systemd-hostnam  1176         0.548626         6   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-89
[  169.581523]           colord  1377         3.571080        81   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-94
[  169.581527]            gvfsd  1549        -5.996329        13   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.581530]       gvfsd-fuse  1554        -1.878081         5   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.581533]       gvfsd-fuse  1559         4.850804        15   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.581536] R  systemd-udevd  1826     24626.792031      2300   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-37
[  169.581539]            sleep  1838         8.118495         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-101

[  169.581543] cpu#4, 3492.133 MHz
[  169.581544]   .nr_running                    : 1
[  169.581545]   .load                          : 146
[  169.581546]   .nr_switches                   : 10753
[  169.581547]   .nr_load_updates               : 41422
[  169.581548]   .nr_uninterruptible            : 40
[  169.581549]   .next_balance                  : 4294.837705
[  169.581549]   .curr->pid                     : 1828
[  169.581550]   .clock                         : 169581.154788
[  169.581551]   .cpu_load[0]                   : 146
[  169.581552]   .cpu_load[1]                   : 146
[  169.581553]   .cpu_load[2]                   : 146
[  169.581554]   .cpu_load[3]                   : 146
[  169.581555]   .cpu_load[4]                   : 146
[  169.581556] 
cfs_rq[4]:/autogroup-37
[  169.581557]   .exec_clock                    : 0.000000
[  169.581558]   .MIN_vruntime                  : 0.000001
[  169.581559]   .min_vruntime                  : 36016.257172
[  169.581560]   .max_vruntime                  : 0.000001
[  169.581560]   .spread                        : 0.000000
[  169.581561]   .spread0                       : -81709.764588
[  169.581562]   .nr_spread_over                : 0
[  169.581563]   .nr_running                    : 1
[  169.581564]   .load                          : 1024
[  169.581565]   .runnable_load_avg             : 1023
[  169.581566]   .blocked_load_avg              : 0
[  169.581566]   .tg_load_contrib               : 1023
[  169.581567]   .tg_runnable_contrib           : 1011
[  169.581568]   .tg_load_avg                   : 7161
[  169.581569]   .tg->runnable_avg              : 6514
[  169.581570]   .tg->cfs_bandwidth.timer_active: 0
[  169.581571]   .throttled                     : 0
[  169.581572]   .throttle_count                : 0
[  169.581572]   .se->exec_start                : 169494.028227
[  169.581573]   .se->vruntime                  : 224222.278774
[  169.581574]   .se->sum_exec_runtime          : 35897.763194
[  169.581575]   .se->load.weight               : 146
[  169.581576]   .se->avg.runnable_avg_sum      : 46883
[  169.581577]   .se->avg.runnable_avg_period   : 46898
[  169.581578]   .se->avg.load_avg_contrib      : 146
[  169.581579]   .se->avg.decay_count           : 0
[  169.581580] 
cfs_rq[4]:/
[  169.581581]   .exec_clock                    : 0.000000
[  169.581582]   .MIN_vruntime                  : 0.000001
[  169.581583]   .min_vruntime                  : 224222.278774
[  169.581583]   .max_vruntime                  : 0.000001
[  169.581584]   .spread                        : 0.000000
[  169.581585]   .spread0                       : 106496.257014
[  169.581586]   .nr_spread_over                : 0
[  169.581587]   .nr_running                    : 1
[  169.581588]   .load                          : 146
[  169.581589]   .runnable_load_avg             : 146
[  169.581590]   .blocked_load_avg              : 0
[  169.581590]   .tg_load_contrib               : 146
[  169.581591]   .tg_runnable_contrib           : 1019
[  169.581592]   .tg_load_avg                   : 1024
[  169.581593]   .tg->runnable_avg              : 6523
[  169.581594]   .tg->cfs_bandwidth.timer_active: 0
[  169.581594]   .throttled                     : 0
[  169.581595]   .throttle_count                : 0
[  169.581596]   .avg->runnable_avg_sum         : 46822
[  169.581597]   .avg->runnable_avg_period      : 46837
[  169.581598] 
rt_rq[4]:/
[  169.581599]   .rt_nr_running                 : 0
[  169.581600]   .rt_throttled                  : 0
[  169.581601]   .rt_time                       : 0.000000
[  169.581602]   .rt_runtime                    : 950.000000
[  169.581603] 
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[  169.581605]       watchdog/4    26        -8.977837        45     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.581608]      migration/4    27         0.000000       194     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.581611]      ksoftirqd/4    28      3318.548166       117   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581614]      kworker/4:0    29    219485.231424       392   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581617]     kworker/4:0H    30       542.628911         7   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581620]        scsi_eh_6   112       248.928840        24   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581624]       scsi_tmf_6   113        24.374153         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581626]       scsi_tmf_7   115        48.513779         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581629]       scsi_tmf_8   117        72.601015         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581632]       scsi_tmf_9   119        96.613697         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581635]      scsi_tmf_10   121       120.627169         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581638]      scsi_tmf_11   123       144.641045         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581641]      scsi_tmf_12   125       168.668656         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581644]      scsi_tmf_13   127       192.683799         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581647]   kworker/u16:10   131       260.266424         7   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581650]        kpsmoused   136       204.694415         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581653]   dm_bufio_cache   138       216.704990         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581656]    ipv6_addrconf   139       224.725144         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581659]          deferwq   140       236.746136         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581662]      kworker/4:1   177       272.801471         4   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581665]      kworker/4:2   179      3323.361280         7   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581668]     kworker/4:1H   393      3181.908129         4   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581671]         kdmflush   438       599.930139         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581674]           bioset   439       611.954924         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581677]         kdmflush   446       620.063964         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581679]           bioset   447       632.080682         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581682]  ext4-rsv-conver   471       681.811673         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581685]        hd-audio1   781      1727.967624         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581688]  kvm-irqfd-clean   783      1946.894967         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581691]  ext4-rsv-conver   785      1744.900588         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581694]  ext4-rsv-conver   832      2068.321714         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581698]            gdbus  1546       115.883316        33   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-101
[  169.581701]    gvfs-fuse-sub  1566        38.738019         2   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.581704]             bash  1573        27.233742        70   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-105
[  169.581708] R  systemd-udevd  1828     36016.257172        45   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-37

[  169.581712] cpu#5, 3492.133 MHz
[  169.581712]   .nr_running                    : 1
[  169.581713]   .load                          : 146
[  169.581714]   .nr_switches                   : 12397
[  169.581715]   .nr_load_updates               : 41042
[  169.581716]   .nr_uninterruptible            : 31
[  169.581717]   .next_balance                  : 4294.837792
[  169.581718]   .curr->pid                     : 1830
[  169.581719]   .clock                         : 169581.154747
[  169.581720]   .cpu_load[0]                   : 146
[  169.581720]   .cpu_load[1]                   : 146
[  169.581721]   .cpu_load[2]                   : 146
[  169.581722]   .cpu_load[3]                   : 146
[  169.581723]   .cpu_load[4]                   : 146
[  169.581724] 
cfs_rq[5]:/autogroup-37
[  169.581725]   .exec_clock                    : 0.000000
[  169.581726]   .MIN_vruntime                  : 0.000001
[  169.581727]   .min_vruntime                  : 29993.872733
[  169.581728]   .max_vruntime                  : 0.000001
[  169.581729]   .spread                        : 0.000000
[  169.581730]   .spread0                       : -87732.149027
[  169.581731]   .nr_spread_over                : 0
[  169.581731]   .nr_running                    : 1
[  169.581732]   .load                          : 1024
[  169.581733]   .runnable_load_avg             : 1023
[  169.581734]   .blocked_load_avg              : 0
[  169.581735]   .tg_load_contrib               : 1023
[  169.581736]   .tg_runnable_contrib           : 1014
[  169.581736]   .tg_load_avg                   : 7161
[  169.581737]   .tg->runnable_avg              : 6514
[  169.581738]   .tg->cfs_bandwidth.timer_active: 0
[  169.581739]   .throttled                     : 0
[  169.581740]   .throttle_count                : 0
[  169.581741]   .se->exec_start                : 169494.915083
[  169.581742]   .se->vruntime                  : 188138.714965
[  169.581743]   .se->sum_exec_runtime          : 29862.825609
[  169.581743]   .se->load.weight               : 146
[  169.581744]   .se->avg.runnable_avg_sum      : 46802
[  169.581745]   .se->avg.runnable_avg_period   : 46817
[  169.581746]   .se->avg.load_avg_contrib      : 146
[  169.581747]   .se->avg.decay_count           : 0
[  169.581748] 
cfs_rq[5]:/
[  169.581749]   .exec_clock                    : 0.000000
[  169.581750]   .MIN_vruntime                  : 0.000001
[  169.581751]   .min_vruntime                  : 188138.714965
[  169.581752]   .max_vruntime                  : 0.000001
[  169.581753]   .spread                        : 0.000000
[  169.581754]   .spread0                       : 70412.693205
[  169.581754]   .nr_spread_over                : 0
[  169.581755]   .nr_running                    : 1
[  169.581756]   .load                          : 146
[  169.581757]   .runnable_load_avg             : 146
[  169.581758]   .blocked_load_avg              : 0
[  169.581759]   .tg_load_contrib               : 146
[  169.581759]   .tg_runnable_contrib           : 1022
[  169.581760]   .tg_load_avg                   : 1024
[  169.581761]   .tg->runnable_avg              : 6523
[  169.581762]   .tg->cfs_bandwidth.timer_active: 0
[  169.581763]   .throttled                     : 0
[  169.581764]   .throttle_count                : 0
[  169.581765]   .avg->runnable_avg_sum         : 46864
[  169.581765]   .avg->runnable_avg_period      : 46879
[  169.581767] 
rt_rq[5]:/
[  169.581768]   .rt_nr_running                 : 0
[  169.581769]   .rt_throttled                  : 0
[  169.581769]   .rt_time                       : 0.000000
[  169.581770]   .rt_runtime                    : 950.000000
[  169.581771] 
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[  169.581773]         kthreadd     2      3409.013652       194   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581776]       watchdog/5    31        -8.983818        45     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.581779]      migration/5    32         0.000000       312     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.581783]      ksoftirqd/5    33      3406.526950        52   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581785]      kworker/5:0    34      1904.595252        30   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581788]     kworker/5:0H    35        -5.977353         5   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581792]   kworker/u16:14   135       119.764668         9   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581796]      kworker/5:1   203       192.918706         3   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581798]      kworker/5:2   205    183418.147676       238   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581802]     rtkit-daemon   887         0.000000        23     0               0               0               0.000000               0.000000               0.000000 0 /autogroup-60
[  169.581805]   abrt-watch-log   894         3.807641        13   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-78
[  169.581808]              gdm   897       200.023552        35   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-81
[  169.581812]  gdm-simple-slav   913       201.211710       108   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-81
[  169.581815]            gdbus   915       200.103321       180   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-81
[  169.581818]     JS GC Helper   922        10.633573         2   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-82
[  169.581821]            gdbus  1072        96.441383        76   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-83
[  169.581824]            gmain  1386        11.610845         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-94
[  169.581827]            gmain  1553       256.056967         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-101
[  169.581830]     dconf worker  1537        25.893567        14   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.581834]            gmain  1541        51.712999         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.581837] R  systemd-udevd  1830     29993.872733       943   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-37

[  169.581841] cpu#6, 3492.133 MHz
[  169.581842]   .nr_running                    : 4
[  169.581843]   .load                          : 1170
[  169.581844]   .nr_switches                   : 10337
[  169.581845]   .nr_load_updates               : 41580
[  169.581846]   .nr_uninterruptible            : 25
[  169.581847]   .next_balance                  : 4294.837774
[  169.581847]   .curr->pid                     : 1824
[  169.581848]   .clock                         : 133854.116633
[  169.581849]   .cpu_load[0]                   : 148
[  169.581850]   .cpu_load[1]                   : 148
[  169.581851]   .cpu_load[2]                   : 148
[  169.581852]   .cpu_load[3]                   : 148
[  169.581852]   .cpu_load[4]                   : 148
[  169.581854] 
cfs_rq[6]:/autogroup-37
[  169.581855]   .exec_clock                    : 0.000000
[  169.581856]   .MIN_vruntime                  : 0.000001
[  169.581857]   .min_vruntime                  : 576.762689
[  169.581858]   .max_vruntime                  : 0.000001
[  169.581858]   .spread                        : 0.000000
[  169.581859]   .spread0                       : -117149.259071
[  169.581860]   .nr_spread_over                : 0
[  169.581861]   .nr_running                    : 1
[  169.581862]   .load                          : 1024
[  169.581863]   .runnable_load_avg             : 1023
[  169.581864]   .blocked_load_avg              : 0
[  169.581864]   .tg_load_contrib               : 1023
[  169.581865]   .tg_runnable_contrib           : 419
[  169.581866]   .tg_load_avg                   : 7161
[  169.581867]   .tg->runnable_avg              : 6514
[  169.581868]   .tg->cfs_bandwidth.timer_active: 0
[  169.581869]   .throttled                     : 0
[  169.581869]   .throttle_count                : 0
[  169.581870]   .se->exec_start                : 133802.519223
[  169.581871]   .se->vruntime                  : 4931.961524
[  169.581872]   .se->sum_exec_runtime          : 191.725568
[  169.581873]   .se->load.weight               : 146
[  169.581874]   .se->avg.runnable_avg_sum      : 19329
[  169.581875]   .se->avg.runnable_avg_period   : 47228
[  169.581876]   .se->avg.load_avg_contrib      : 148
[  169.581877]   .se->avg.decay_count           : 0
[  169.581878] 
cfs_rq[6]:/autogroup-111
[  169.581879]   .exec_clock                    : 0.000000
[  169.581880]   .MIN_vruntime                  : 0.000001
[  169.581881]   .min_vruntime                  : 80.498725
[  169.581882]   .max_vruntime                  : 0.000001
[  169.581883]   .spread                        : 0.000000
[  169.581884]   .spread0                       : -117645.523035
[  169.581885]   .nr_spread_over                : 0
[  169.581885]   .nr_running                    : 0
[  169.581886]   .load                          : 0
[  169.581887]   .runnable_load_avg             : 0
[  169.581888]   .blocked_load_avg              : 0
[  169.581889]   .tg_load_contrib               : 0
[  169.581890]   .tg_runnable_contrib           : 17
[  169.581890]   .tg_load_avg                   : 0
[  169.581891]   .tg->runnable_avg              : 17
[  169.581892]   .tg->cfs_bandwidth.timer_active: 0
[  169.581893]   .throttled                     : 0
[  169.581894]   .throttle_count                : 0
[  169.581895]   .se->exec_start                : 133776.830952
[  169.581896]   .se->vruntime                  : 4771.775069
[  169.581897]   .se->sum_exec_runtime          : 57.547319
[  169.581898]   .se->load.weight               : 2
[  169.581899]   .se->avg.runnable_avg_sum      : 836
[  169.581899]   .se->avg.runnable_avg_period   : 47883
[  169.581900]   .se->avg.load_avg_contrib      : 0
[  169.581901]   .se->avg.decay_count           : 127581
[  169.581902] 
cfs_rq[6]:/autogroup-62
[  169.581904]   .exec_clock                    : 0.000000
[  169.581905]   .MIN_vruntime                  : 0.000001
[  169.581905]   .min_vruntime                  : 8.593411
[  169.581906]   .max_vruntime                  : 0.000001
[  169.581907]   .spread                        : 0.000000
[  169.581908]   .spread0                       : -117717.428349
[  169.581909]   .nr_spread_over                : 0
[  169.581910]   .nr_running                    : 0
[  169.581911]   .load                          : 0
[  169.581912]   .runnable_load_avg             : 0
[  169.581912]   .blocked_load_avg              : 0
[  169.581913]   .tg_load_contrib               : 0
[  169.581914]   .tg_runnable_contrib           : 1
[  169.581915]   .tg_load_avg                   : 0
[  169.581916]   .tg->runnable_avg              : 1
[  169.581917]   .tg->cfs_bandwidth.timer_active: 0
[  169.581918]   .throttled                     : 0
[  169.581918]   .throttle_count                : 0
[  169.581919]   .se->exec_start                : 133776.762722
[  169.581920]   .se->vruntime                  : 4759.798713
[  169.581921]   .se->sum_exec_runtime          : 9.647052
[  169.581922]   .se->load.weight               : 2
[  169.581923]   .se->avg.runnable_avg_sum      : 67
[  169.581924]   .se->avg.runnable_avg_period   : 47671
[  169.581925]   .se->avg.load_avg_contrib      : 0
[  169.581926]   .se->avg.decay_count           : 127580
[  169.581926] 
cfs_rq[6]:/
[  169.581928]   .exec_clock                    : 0.000000
[  169.581929]   .MIN_vruntime                  : 4919.961524
[  169.581930]   .min_vruntime                  : 4931.961524
[  169.581931]   .max_vruntime                  : 4919.961524
[  169.581931]   .spread                        : 0.000000
[  169.581932]   .spread0                       : -112794.060236
[  169.581933]   .nr_spread_over                : 0
[  169.581934]   .nr_running                    : 2
[  169.581935]   .load                          : 1170
[  169.581936]   .runnable_load_avg             : 148
[  169.581936]   .blocked_load_avg              : 0
[  169.581937]   .tg_load_contrib               : 148
[  169.581938]   .tg_runnable_contrib           : 427
[  169.581939]   .tg_load_avg                   : 1024
[  169.581940]   .tg->runnable_avg              : 6523
[  169.581941]   .tg->cfs_bandwidth.timer_active: 0
[  169.581942]   .throttled                     : 0
[  169.581942]   .throttle_count                : 0
[  169.581943]   .avg->runnable_avg_sum         : 19571
[  169.581944]   .avg->runnable_avg_period      : 46830
[  169.581945] 
rt_rq[6]:/
[  169.581946]   .rt_nr_running                 : 1
[  169.581947]   .rt_throttled                  : 0
[  169.581948]   .rt_time                       : 0.000000
[  169.581949]   .rt_runtime                    : 950.000000
[  169.581950] 
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[  169.581952]       watchdog/6    36        -8.983353        36     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.581955]      migration/6    37         0.000000       236     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.581958]      ksoftirqd/6    38      4659.854783        77   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581961]      kworker/6:0    39      2569.181633        24   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581964]     kworker/6:0H    40      1465.244249         7   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581967]        scsi_eh_9   118        35.415852        23   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581970]    kworker/u16:7   128        46.972978         6   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581973]   kworker/u16:16   143        47.064898         2   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581977]      kworker/6:1   146      1613.948700       102   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581980]     kworker/6:1H   579      2216.902894         5   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581983]      kworker/6:2   627      4919.961524       212   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.581986]           auditd   844         4.837425       899   116               0               0               0.000000               0.000000               0.000000 0 /autogroup-52
[  169.581989]   NetworkManager   989        10.960183         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-83
[  169.581993]         cfg80211  1066      2917.101889         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.581996]         (sd-pam)  1225        11.024551         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-90
[  169.581999]            gmain  1479        61.101959         5   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-81
[  169.582002]          systemd  1483        24.074988        28   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-99
[  169.582005]            gdbus  1539        33.267483        10   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.582008]            gmain  1796        37.439927         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-112
[  169.582012] R  systemd-udevd  1824       576.762689         0   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-37

[  169.582016] cpu#7, 3492.133 MHz
[  169.582016]   .nr_running                    : 2
[  169.582017]   .load                          : 2048
[  169.582018]   .nr_switches                   : 21148
[  169.582019]   .nr_load_updates               : 42917
[  169.582020]   .nr_uninterruptible            : 38
[  169.582021]   .next_balance                  : 4294.837657
[  169.582022]   .curr->pid                     : 1729
[  169.582023]   .clock                         : 169572.664695
[  169.582024]   .cpu_load[0]                   : 0
[  169.582024]   .cpu_load[1]                   : 0
[  169.582025]   .cpu_load[2]                   : 0
[  169.582026]   .cpu_load[3]                   : 0
[  169.582027]   .cpu_load[4]                   : 0
[  169.582028] 
cfs_rq[7]:/autogroup-107
[  169.582029]   .exec_clock                    : 0.000000
[  169.582030]   .MIN_vruntime                  : 0.000001
[  169.582031]   .min_vruntime                  : 462.345031
[  169.582032]   .max_vruntime                  : 0.000001
[  169.582033]   .spread                        : 0.000000
[  169.582034]   .spread0                       : -117263.676729
[  169.582035]   .nr_spread_over                : 0
[  169.582035]   .nr_running                    : 1
[  169.582036]   .load                          : 1024
[  169.582037]   .runnable_load_avg             : 0
[  169.582038]   .blocked_load_avg              : 0
[  169.582039]   .tg_load_contrib               : 0
[  169.582040]   .tg_runnable_contrib           : 0
[  169.582040]   .tg_load_avg                   : 0
[  169.582041]   .tg->runnable_avg              : 0
[  169.582042]   .tg->cfs_bandwidth.timer_active: 0
[  169.582043]   .throttled                     : 0
[  169.582044]   .throttle_count                : 0
[  169.582045]   .se->exec_start                : 169453.293773
[  169.582046]   .se->vruntime                  : 116838.588821
[  169.582047]   .se->sum_exec_runtime          : 58.851954
[  169.582048]   .se->load.weight               : 1024
[  169.582048]   .se->avg.runnable_avg_sum      : 0
[  169.582049]   .se->avg.runnable_avg_period   : 47110
[  169.582050]   .se->avg.load_avg_contrib      : 0
[  169.582051]   .se->avg.decay_count           : 0
[  169.582052] 
cfs_rq[7]:/autogroup-106
[  169.582053]   .exec_clock                    : 0.000000
[  169.582054]   .MIN_vruntime                  : 0.000001
[  169.582055]   .min_vruntime                  : 61.114302
[  169.582056]   .max_vruntime                  : 0.000001
[  169.582057]   .spread                        : 0.000000
[  169.582058]   .spread0                       : -117664.907458
[  169.582059]   .nr_spread_over                : 0
[  169.582060]   .nr_running                    : 0
[  169.582060]   .load                          : 0
[  169.582061]   .runnable_load_avg             : 0
[  169.582062]   .blocked_load_avg              : 0
[  169.582063]   .tg_load_contrib               : 0
[  169.582064]   .tg_runnable_contrib           : 0
[  169.582065]   .tg_load_avg                   : 0
[  169.582065]   .tg->runnable_avg              : 0
[  169.582066]   .tg->cfs_bandwidth.timer_active: 0
[  169.582067]   .throttled                     : 0
[  169.582068]   .throttle_count                : 0
[  169.582069]   .se->exec_start                : 169453.288432
[  169.582070]   .se->vruntime                  : 116835.705481
[  169.582071]   .se->sum_exec_runtime          : 49.301235
[  169.582072]   .se->load.weight               : 2
[  169.582073]   .se->avg.runnable_avg_sum      : 22
[  169.582073]   .se->avg.runnable_avg_period   : 48516
[  169.582074]   .se->avg.load_avg_contrib      : 0
[  169.582075]   .se->avg.decay_count           : 161604
[  169.582076] 
cfs_rq[7]:/autogroup-62
[  169.582077]   .exec_clock                    : 0.000000
[  169.582078]   .MIN_vruntime                  : 0.000001
[  169.582079]   .min_vruntime                  : 0.666231
[  169.582080]   .max_vruntime                  : 0.000001
[  169.582081]   .spread                        : 0.000000
[  169.582082]   .spread0                       : -117725.355529
[  169.582083]   .nr_spread_over                : 0
[  169.582084]   .nr_running                    : 0
[  169.582084]   .load                          : 0
[  169.582085]   .runnable_load_avg             : 0
[  169.582086]   .blocked_load_avg              : 0
[  169.582087]   .tg_load_contrib               : 0
[  169.582088]   .tg_runnable_contrib           : 0
[  169.582089]   .tg_load_avg                   : 0
[  169.582089]   .tg->runnable_avg              : 1
[  169.582090]   .tg->cfs_bandwidth.timer_active: 0
[  169.582091]   .throttled                     : 0
[  169.582092]   .throttle_count                : 0
[  169.582093]   .se->exec_start                : 169453.271783
[  169.582094]   .se->vruntime                  : 116834.788849
[  169.582095]   .se->sum_exec_runtime          : 1.732953
[  169.582096]   .se->load.weight               : 2
[  169.582096]   .se->avg.runnable_avg_sum      : 64
[  169.582097]   .se->avg.runnable_avg_period   : 47818
[  169.582098]   .se->avg.load_avg_contrib      : 0
[  169.582099]   .se->avg.decay_count           : 161604
[  169.582100] 
cfs_rq[7]:/autogroup-86
[  169.582101]   .exec_clock                    : 0.000000
[  169.582102]   .MIN_vruntime                  : 0.000001
[  169.582103]   .min_vruntime                  : 541.364884
[  169.582104]   .max_vruntime                  : 0.000001
[  169.582105]   .spread                        : 0.000000
[  169.582106]   .spread0                       : -117184.656876
[  169.582107]   .nr_spread_over                : 0
[  169.582108]   .nr_running                    : 0
[  169.582108]   .load                          : 0
[  169.582109]   .runnable_load_avg             : 0
[  169.582110]   .blocked_load_avg              : 0
[  169.582111]   .tg_load_contrib               : 0
[  169.582112]   .tg_runnable_contrib           : 0
[  169.582112]   .tg_load_avg                   : 0
[  169.582113]   .tg->runnable_avg              : 0
[  169.582114]   .tg->cfs_bandwidth.timer_active: 0
[  169.582115]   .throttled                     : 0
[  169.582116]   .throttle_count                : 0
[  169.582117]   .se->exec_start                : 169453.270538
[  169.582118]   .se->vruntime                  : 116838.562770
[  169.582119]   .se->sum_exec_runtime          : 494.413492
[  169.582120]   .se->load.weight               : 2
[  169.582120]   .se->avg.runnable_avg_sum      : 65
[  169.582121]   .se->avg.runnable_avg_period   : 47802
[  169.582122]   .se->avg.load_avg_contrib      : 0
[  169.582123]   .se->avg.decay_count           : 161604
[  169.582124] 
cfs_rq[7]:/
[  169.582125]   .exec_clock                    : 0.000000
[  169.582126]   .MIN_vruntime                  : 116834.799772
[  169.582127]   .min_vruntime                  : 116846.700962
[  169.582128]   .max_vruntime                  : 116834.799772
[  169.582129]   .spread                        : 0.000000
[  169.582130]   .spread0                       : -879.320798
[  169.582131]   .nr_spread_over                : 0
[  169.582131]   .nr_running                    : 2
[  169.582132]   .load                          : 2048
[  169.582133]   .runnable_load_avg             : 0
[  169.582134]   .blocked_load_avg              : 0
[  169.582135]   .tg_load_contrib               : 0
[  169.582136]   .tg_runnable_contrib           : 1
[  169.582137]   .tg_load_avg                   : 1024
[  169.582137]   .tg->runnable_avg              : 6523
[  169.582138]   .tg->cfs_bandwidth.timer_active: 0
[  169.582139]   .throttled                     : 0
[  169.582140]   .throttle_count                : 0
[  169.582141]   .avg->runnable_avg_sum         : 85
[  169.582142]   .avg->runnable_avg_period      : 46560
[  169.582143] 
rt_rq[7]:/
[  169.582144]   .rt_nr_running                 : 0
[  169.582145]   .rt_throttled                  : 0
[  169.582146]   .rt_time                       : 0.000000
[  169.582147]   .rt_runtime                    : 950.000000
[  169.582147] 
runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
[  169.582149]          systemd     1       307.868272      2478   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-1
[  169.582153]       watchdog/7    41        -8.983765        45     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.582156]      migration/7    42         0.000000       363     0               0               0               0.000000               0.000000               0.000000 0 /
[  169.582159]      ksoftirqd/7    43    111415.636980       135   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.582162]      kworker/7:0    44      1941.862029        21   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.582165]     kworker/7:0H    45      3507.323907         7   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582168]          khelper    46        10.956274         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582171]            netns    48        34.998203         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582174]        writeback    49        47.001449         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582177]             ksmd    50        59.006524         2   125               0               0               0.000000               0.000000               0.000000 0 /
[  169.582180]      kintegrityd    52        83.059164         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582183]           bioset    53        95.062257         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582186]           crypto    54       107.065281         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582189]          kblockd    55       119.068298         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582192]          ata_sff    56       131.071442         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582195]               md    58       155.077896         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582198]          kswapd0    82       719.792394         3   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.582201]         kthrotld    93       551.595592         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582203]  acpi_thermal_pm    94       563.600251         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582206]       scsi_tmf_0    96       587.611359         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582209]       scsi_tmf_1    98       611.622396         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582212]       scsi_tmf_2   100       635.660458         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582215]       scsi_tmf_3   102       659.701901         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582218]        scsi_eh_4   103       719.796899         3   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.582221]       scsi_tmf_4   104       683.740751         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582224]       scsi_tmf_5   106       707.765367         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582227]    kworker/u16:2   107    116834.752221       576   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.582230]    kworker/u16:3   108       731.971699        13   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.582233]    kworker/u16:8   129       731.965539         6   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.582236]   kworker/u16:13   134    116834.703709       486   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.582239]      kworker/7:1   144    116834.799772       464   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.582242]    systemd-udevd   577     18958.931354       660   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-37
[  169.582246]          lvmetad   578         0.728467         3   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-38
[  169.582249]      kworker/7:2   659      3643.761310        10   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.582252]    irq/58-mei_me   668         0.000000        15    49               0               0               0.000000               0.000000               0.000000 0 /
[  169.582255]      jbd2/sda1-8   782      2413.828232         2   120               0               0               0.000000               0.000000               0.000000 0 /
[  169.582258]         kdmflush   817      2682.464522         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582261]           bioset   818      2690.485538         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582264]        firewalld   855      1227.552281       467   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-57
[  169.582267]            gmain  1383      1101.707154         2   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-57
[  169.582270]             rngd   859         0.666231      2516   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-62
[  169.582273]      dbus-daemon   872        40.317479      1135   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-69
[  169.582276]   systemd-logind   873         8.745468       267   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-70
[  169.582280]          polkitd   914       103.885801       308   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-82
[  169.582283]            gdbus   918       106.391823       304   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-82
[  169.582286]  JS Sour~ Thread   923        91.819088        41   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-82
[  169.582289]             Xorg  1118       541.364884      7271   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-86
[  169.582292]          upowerd  1289       215.859630       181   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-93
[  169.582296]            gmain  1295        11.928377         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-93
[  169.582299]     kworker/7:1H  1380      3519.323851         2   100               0               0               0.000000               0.000000               0.000000 0 /
[  169.582302]            gdbus  1478       146.188608       103   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-81
[  169.582305]      dbus-daemon  1503        10.974727         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.582308]        ssh-agent  1510         0.689999        16   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-103
[  169.582311]  gnome-screensav  1530       179.422348       158   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-101
[  169.582314]     dconf worker  1545       131.477523        10   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-101
[  169.582318]      dbus-daemon  1542        35.461133         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.582321]  at-spi2-registr  1544       106.204217       224   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.582324]       gvfsd-fuse  1560       107.107457         1   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-102
[  169.582327]            xterm  1568        87.512953       560   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-104
[  169.582330]            xterm  1601        61.114302       885   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-106
[  169.582333]             sudo  1728       320.028128         2   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-107
[  169.582336] R           bash  1729       450.628887       108   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-107
[  169.582339]             bash  1760       136.121277       142   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-111
[  169.582342]      packagekitd  1793         0.995683        65   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-112
[  169.582345]             htop  1798       155.841499       165   120               0               0               0.000000               0.000000               0.000000 0 /autogroup-105


--opJtzjQTFsWo+cga--
