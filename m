Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaIKV0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:26:05 -0400
Received: from services.gouders.net ([141.101.32.176]:52428 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaIKVZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:25:58 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <CAErSpo5SVUOz+qa_x5JTC+-Y5ewTyYzA0N=jyPtK9LaguRrt=w@mail.gmail.com>
	(Bjorn Helgaas's message of "Thu, 11 Sep 2014 14:42:47 -0600")
References: <ghiol53r9u.fsf@lena.gouders.net>
	<CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
	<ghwq9k3m6z.fsf@lena.gouders.net>
	<CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
	<ghioku5l29.fsf@lena.gouders.net>
	<CAErSpo7j=a3y2MVsvEQGQ4B63_mNCyZSRNXNEZa-2++xs88NmQ@mail.gmail.com>
	<CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
	<ghppf15236.fsf@quad.gouders.net>
	<CAErSpo5SVUOz+qa_x5JTC+-Y5ewTyYzA0N=jyPtK9LaguRrt=w@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Thu, 11 Sep 2014 23:24:43 +0200
Message-ID: <ghd2b1svdw.fsf@quad.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas <bhelgaas@google.com> writes:

> On Thu, Sep 11, 2014 at 2:33 PM, Dirk Gouders <dirk@gouders.net> wrote:
>> What I was currently trying was to construct a test-environment so that
>> I do not need to do tests and diagnosis on a busy machine.
>>
>> I noticed that this problem seems to start with the narrow Root
>> Bridge window (00-07) but every other machine that I had a look at,
>> starts with (00-ff), so those will not trigger my problem.
>>
>> I thought I could perhaps try to shrink the window in
>> acpi_pci_root_add() to trigger the problem and that kind of works: it
>> triggers it but not exactly the same way, because it basically ends at
>> this code in pci_scan_bridge():
>>
>>         if (max >= bus->busn_res.end) {
>>                 dev_warn(&dev->dev, "can't allocate child bus %02x from %pR (pass %d)\n",
>>                          max, &bus->busn_res, pass);
>>                 goto out;
>>         }
>>
>> If this could work but I am just missing a small detail, I would be
>> glad to hear about it and do the first tests this way.  If it is
>> complete nonsense, I will just use the machine that triggers the problem
>> for the tests.
>
> I was about to suggest the same thing.  If the problem is related to
> the bus number change, we should be able to force that to happen on a
> different machine.  Your approach sounds good, so I'm guessing we just
> need a tweak.
>
> I would first double-check that the PCI adapters are identical,
> including the firmware on the card.  Can you also include your patch
> and the resulting dmesg (with debug enabled as before)?

Currently I am at home doing just tests for understanding and that I can
hopefully use when I am back in the office.

I already noticed the the backup FC Adapter on the test machine is not
exactly the same: it is Rev. 1 whereas the one on the failing machine is
Rev. 2.

So, here at home my tests let a NIC disappear.  Different from the
original problem but I was just trying to reconstruct the szenario of a
misconfigured bridge causing a reconfiguration.

What I was trying is:

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index e6ae603..fd146b3 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -556,6 +556,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	strcpy(acpi_device_name(device), ACPI_PCI_ROOT_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
 	device->driver_data = root;
+	root->secondary.end = 0x02;
 
 	pr_info(PREFIX "%s [%s] (domain %04x %pR)\n",
 	       acpi_device_name(device), acpi_device_bid(device),

The device that disappears is a NIC:

00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor DRAM Controller (rev 09)
00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor Graphics Controller (rev 09)
00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
00:1c.4 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 5 (rev c4)
00:1c.5 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 6 (rev c4)
00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a4)
00:1f.0 ISA bridge: Intel Corporation B75 Express Chipset LPC Controller (rev 04)
00:1f.2 SATA controller: Intel Corporation 7 Series/C210 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)

This is the one that is missing with the above change:
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)

I will attach the dmesg at the end.

> Is the test machine itself similar to the failing one?  Do they have
> the same BIOS version?  From [1], it looks like you already have the
> latest BIOS on the failing machine.  It's interesting that the notes
> for your version mention "Fixed a PCI Bus Number re-allocation error."

No, the test machine is very different.  A Tyan board as well, but only
two CPUs and ServerWorks chipset if I remember correctly.

Dirk

>
> Bjorn
>
> [1] http://www.tyan.com/support_download_bios.aspx?model=B.VX50B4985-E

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.16.0-11383-gc9d2642-dirty (dirk@quad) (gcc version 4.8.3 (Gentoo 4.8.3 p1.1, pie-0.5.9) ) #18 SMP PREEMPT Thu Sep 11 22:53:39 CEST 2014
[    0.000000] Command line: root=/dev/sda2 log_buf_len=10M dyndbg="file drivers/pci/* +pf"
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000d8db1fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d8db2000-0x00000000d91c7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d91c8000-0x00000000d91d2fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000d91d3000-0x00000000d923efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000d923f000-0x00000000d9243fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000d9244000-0x00000000d9387fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d9388000-0x00000000d9723fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000d9724000-0x00000000da2befff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000da2bf000-0x00000000da2bffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da2c0000-0x00000000da302fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da303000-0x00000000dac88fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dac89000-0x00000000dafdbfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dafdc000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db800000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. To be filled by O.E.M./B75N, BIOS F5 11/14/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x11f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 100000000 mask FE0000000 write-back
[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0DB800000 mask FFF800000 uncachable
[    0.000000]   5 base 11F800000 mask FFF800000 uncachable
[    0.000000]   6 base 11F600000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xdb800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01ac5000, 0x01ac5fff] PGTABLE
[    0.000000] BRK [0x01ac6000, 0x01ac6fff] PGTABLE
[    0.000000] BRK [0x01ac7000, 0x01ac7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11f400000-0x11f5fffff]
[    0.000000]  [mem 0x11f400000-0x11f5fffff] page 2M
[    0.000000] BRK [0x01ac8000, 0x01ac8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x11c000000-0x11f3fffff]
[    0.000000]  [mem 0x11c000000-0x11f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
[    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] BRK [0x01ac9000, 0x01ac9fff] PGTABLE
[    0.000000] BRK [0x01aca000, 0x01acafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x40005000-0xd8db1fff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0xd8bfffff] page 2M
[    0.000000]  [mem 0xd8c00000-0xd8db1fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xd9244000-0xd9387fff]
[    0.000000]  [mem 0xd9244000-0xd9387fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xda2bf000-0xda2bffff]
[    0.000000]  [mem 0xda2bf000-0xda2bffff] page 4k
[    0.000000] init_memory_mapping: [mem 0xda303000-0xdac88fff]
[    0.000000]  [mem 0xda303000-0xda3fffff] page 4k
[    0.000000]  [mem 0xda400000-0xdabfffff] page 2M
[    0.000000]  [mem 0xdac00000-0xdac88fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdafdc000-0xdaffffff]
[    0.000000]  [mem 0xdafdc000-0xdaffffff] page 4k
[    0.000000] log_buf_len: 16777216 bytes
[    0.000000] early log buf free: 256020(97%)
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000D91C8070 00005C (v01 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000D91D1498 0000F4 (v04 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000D91C8158 00933B (v02 ALASKA A M I    00000012 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000D9722F80 000040
[    0.000000] ACPI: APIC 0x00000000D91D1590 000072 (v03 ALASKA A M I    01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x00000000D91D1608 00003C (v01 ALASKA A M I    01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000D91D1648 000038 (v01 ALASKA A M I    01072009 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000D91D1680 00036D (v01 SataRe SataTabl 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000D91D19F0 0009AA (v01 PmRef  Cpu0Ist  00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000D91D23A0 000A92 (v01 PmRef  CpuPm    00003000 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011f5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x11f5fffff]
[    0.000000]   NODE_DATA [mem 0x11e5f5000-0x11e5f8fff]
[    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff880119c00000-ffff88011dbfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x11f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xd8db1fff]
[    0.000000]   node   0: [mem 0xd9244000-0xd9387fff]
[    0.000000]   node   0: [mem 0xda2bf000-0xda2bffff]
[    0.000000]   node   0: [mem 0xda303000-0xdac88fff]
[    0.000000]   node   0: [mem 0xdafdc000-0xdaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x11f5fffff]
[    0.000000] On node 0 totalpages: 1018940
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13851 pages used for memmap
[    0.000000]   DMA32 zone: 886432 pages, LIFO batch:31
[    0.000000]   Normal zone: 2008 pages used for memmap
[    0.000000]   Normal zone: 128512 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xdba00000-0xdf9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff88011e200000 s75712 r8192 d22592 u524288
[    0.000000] pcpu-alloc: s75712 r8192 d22592 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1002996
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda2 log_buf_len=10M dyndbg="file drivers/pci/* +pf"
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Memory: 3916120K/4075760K available (6165K kernel code, 763K rwdata, 2500K rodata, 860K init, 692K bss, 159640K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:4352 nr_irqs:456 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3292.612 MHz processor
[    0.000001] Calibrating delay loop (skipped), value calculated using timer frequency.. 6585.22 BogoMIPS (lpj=13170448)
[    0.000150] pid_max: default: 32768 minimum: 301
[    0.000225] ACPI: Core revision 20140724
[    0.004227] ACPI: All ACPI Tables successfully acquired
[    0.005710] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.006513] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.006922] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.007000] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.007197] Initializing cgroup subsys devices
[    0.007283] CPU: Physical Processor ID: 0
[    0.007354] CPU: Processor Core ID: 0
[    0.007428] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.007550] mce: CPU supports 7 MCE banks
[    0.007629] CPU0: Thermal monitoring enabled (TM1)
[    0.007707] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.007937] Freeing SMP alternatives memory: 28K (ffffffff81a10000 - ffffffff81a17000)
[    0.008444] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.048200] smpboot: CPU0: Intel(R) Core(TM) i3-3225 CPU @ 3.30GHz (fam: 06, model: 3a, stepping: 09)
[    0.048407] TSC deadline timer enabled
[    0.048417] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.048692] ... version:                3
[    0.048764] ... bit width:              48
[    0.048835] ... generic registers:      4
[    0.048907] ... value mask:             0000ffffffffffff
[    0.048980] ... max period:             0000ffffffffffff
[    0.049053] ... fixed-purpose events:   3
[    0.049125] ... event mask:             000000070000000f
[    0.072474] x86: Booting SMP configuration:
[    0.072560] .... node  #0, CPUs:      #1 #2 #3
[    0.128030] x86: Booted up 1 node, 4 CPUs
[    0.128172] smpboot: Total of 4 processors activated (26340.89 BogoMIPS)
[    0.130291] devtmpfs: initialized
[    0.130515] PM: Registering ACPI NVS region [mem 0xd9388000-0xd9723fff] (3784704 bytes)
[    0.130618] PM: Registering ACPI NVS region [mem 0xda2c0000-0xda302fff] (274432 bytes)
[    0.130821] NET: Registered protocol family 16
[    0.131022] cpuidle: using governor ladder
[    0.131096] cpuidle: using governor menu
[    0.131206] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.131282] ACPI: bus type PCI registered
[    0.131354] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.131468] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.131587] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.131699] PCI: Using configuration type 1 for base access
[    0.133681] ACPI: Added _OSI(Module Device)
[    0.133754] ACPI: Added _OSI(Processor Device)
[    0.133827] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.133900] ACPI: Added _OSI(Processor Aggregator Device)
[    0.135805] ACPI: Executed 1 blocks of module-level executable AML code
[    0.152309] ACPI: Dynamic OEM Table Load:
[    0.152442] ACPI: SSDT 0xFFFF880118C41000 00083B (v01 PmRef  Cpu0Cst  00003001 INTL 20051117)
[    0.164207] ACPI: Dynamic OEM Table Load:
[    0.164338] ACPI: SSDT 0xFFFF880118AF1800 000303 (v01 PmRef  ApIst    00003000 INTL 20051117)
[    0.176120] ACPI: Dynamic OEM Table Load:
[    0.176261] ACPI: SSDT 0xFFFF880118990A00 000119 (v01 PmRef  ApCst    00003000 INTL 20051117)
[    0.188472] ACPI: Interpreter enabled
[    0.188548] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
[    0.188726] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    0.188908] ACPI: (supports S0 S3 S5)
[    0.188979] ACPI: Using IOAPIC for interrupt routing
[    0.189073] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.193816] ACPI: Power Resource [FN00] (off)
[    0.195077] ACPI: Power Resource [FN01] (off)
[    0.195211] ACPI: Power Resource [FN02] (off)
[    0.195344] ACPI: Power Resource [FN03] (off)
[    0.195478] ACPI: Power Resource [FN04] (off)
[    0.195912] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-02])
[    0.195989] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.196198] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug PME]
[    0.196346] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.196760] PCI host bridge to bus 0000:00
[    0.196833] pci_bus 0000:00: root bus resource [bus 00-02]
[    0.196907] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.196982] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.197056] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.197132] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.197208] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.197283] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.197359] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.197435] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.197510] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.197586] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.197662] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[    0.197668] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.197673] fixup_debug_start: pci 0000:00:00.0: calling quirk_mmio_always_on+0x0/0x5
[    0.197737] pci 0000:00:02.0: [8086:0162] type 00 class 0x030000
[    0.197746] pci 0000:00:02.0: reg 0x10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.197750] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.197753] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.197833] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.197853] pci 0000:00:14.0: reg 0x10: [mem 0xf7c00000-0xf7c0ffff 64bit]
[    0.197918] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.197922] pci_pme_active: pci 0000:00:14.0: PME# disabled
[    0.197949] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.198057] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.198078] pci 0000:00:16.0: reg 0x10: [mem 0xf7c19000-0xf7c1900f 64bit]
[    0.198147] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.198150] pci_pme_active: pci 0000:00:16.0: PME# disabled
[    0.198217] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.198236] pci 0000:00:1a.0: reg 0x10: [mem 0xf7c18000-0xf7c183ff]
[    0.198319] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.198322] pci_pme_active: pci 0000:00:1a.0: PME# disabled
[    0.198361] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.198468] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.198483] pci 0000:00:1b.0: reg 0x10: [mem 0xf7c10000-0xf7c13fff 64bit]
[    0.198552] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.198555] pci_pme_active: pci 0000:00:1b.0: PME# disabled
[    0.198584] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.198687] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.198726] fixup_debug_start: pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x14
[    0.198768] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.198770] pci_pme_active: pci 0000:00:1c.0: PME# disabled
[    0.198802] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.198908] pci 0000:00:1c.4: [8086:1e18] type 01 class 0x060400
[    0.198946] fixup_debug_start: pci 0000:00:1c.4: calling pci_fixup_transparent_bridge+0x0/0x14
[    0.198987] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.198990] pci_pme_active: pci 0000:00:1c.4: PME# disabled
[    0.199021] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.199125] pci 0000:00:1c.5: [8086:1e1a] type 01 class 0x060400
[    0.199162] fixup_debug_start: pci 0000:00:1c.5: calling pci_fixup_transparent_bridge+0x0/0x14
[    0.199203] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.199206] pci_pme_active: pci 0000:00:1c.5: PME# disabled
[    0.199237] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.199346] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.199365] pci 0000:00:1d.0: reg 0x10: [mem 0xf7c17000-0xf7c173ff]
[    0.199449] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.199452] pci_pme_active: pci 0000:00:1d.0: PME# disabled
[    0.199489] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.199593] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.199622] fixup_debug_start: pci 0000:00:1e.0: calling quirk_use_pcie_bridge_dma_alias+0x0/0x38
[    0.199624] fixup_debug_start: pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x14
[    0.199667] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.199772] pci 0000:00:1f.0: [8086:1e49] type 00 class 0x060100
[    0.199926] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
[    0.199941] pci 0000:00:1f.2: reg 0x10: [io  0xf0b0-0xf0b7]
[    0.199948] pci 0000:00:1f.2: reg 0x14: [io  0xf0a0-0xf0a3]
[    0.199954] pci 0000:00:1f.2: reg 0x18: [io  0xf090-0xf097]
[    0.199960] pci 0000:00:1f.2: reg 0x1c: [io  0xf080-0xf083]
[    0.199967] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.199973] pci 0000:00:1f.2: reg 0x24: [mem 0xf7c16000-0xf7c167ff]
[    0.200013] pci 0000:00:1f.2: PME# supported from D3hot
[    0.200016] pci_pme_active: pci 0000:00:1f.2: PME# disabled
[    0.200072] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.200085] pci 0000:00:1f.3: reg 0x10: [mem 0xf7c15000-0xf7c150ff 64bit]
[    0.200104] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.200165] pci_scan_child_bus: pci_bus 0000:00: fixups for bus
[    0.200168] pci_scan_bridge: pci 0000:00:1c.0: scanning [bus 01-01] behind bridge, pass 0
[    0.200221] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[    0.200223] pci_scan_child_bus: pci_bus 0000:01: fixups for bus
[    0.200225] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.200307] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=01
[    0.200310] pci_scan_bridge: pci 0000:00:1c.4: scanning [bus 02-02] behind bridge, pass 0
[    0.200362] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[    0.200385] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
[    0.200407] pci 0000:02:00.0: reg 0x10: [io  0xe000-0xe0ff]
[    0.200439] pci 0000:02:00.0: reg 0x18: [mem 0xf0104000-0xf0104fff 64bit pref]
[    0.200459] pci 0000:02:00.0: reg 0x20: [mem 0xf0100000-0xf0103fff 64bit pref]
[    0.200566] pci 0000:02:00.0: supports D1 D2
[    0.200567] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.200571] pci_pme_active: pci 0000:02:00.0: PME# disabled
[    0.200597] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.208095] pci_scan_child_bus: pci_bus 0000:02: fixups for bus
[    0.208097] pci 0000:00:1c.4: PCI bridge to [bus 02]
[    0.208188] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.208195] pci 0000:00:1c.4:   bridge window [mem 0xf0100000-0xf01fffff 64bit pref]
[    0.208196] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[    0.208200] pci_scan_bridge: pci 0000:00:1c.5: scanning [bus 03-03] behind bridge, pass 0
[    0.208201] pci 0000:00:1c.5: bridge configuration invalid ([bus 03-03]), reconfiguring
[    0.208283] pci_scan_bridge: pci 0000:00:1e.0: scanning [bus 04-04] behind bridge, pass 0
[    0.208283] pci 0000:00:1e.0: bridge configuration invalid ([bus 04-04]), reconfiguring
[    0.208365] pci_scan_bridge: pci 0000:00:1c.0: scanning [bus 01-01] behind bridge, pass 1
[    0.208370] pci_scan_bridge: pci 0000:00:1c.4: scanning [bus 02-02] behind bridge, pass 1
[    0.208375] pci_scan_bridge: pci 0000:00:1c.5: scanning [bus 00-00] behind bridge, pass 1
[    0.208378] pci 0000:00:1c.5: can't allocate child bus 02 from [bus 00-02]
[    0.208455] pci_scan_bridge: pci 0000:00:1e.0: scanning [bus 00-00] behind bridge, pass 1
[    0.208458] pci 0000:00:1e.0: can't allocate child bus 02 from [bus 00-02]
[    0.208535] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=02
[    0.208539] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
[    0.208935] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.209355] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.209772] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.210189] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.210605] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.211082] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.211558] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.211974] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.212551] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.212750] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.212829] vgaarb: loaded
[    0.212899] vgaarb: bridge control possible 0000:00:02.0
[    0.213025] SCSI subsystem initialized
[    0.213127] libata version 3.00 loaded.
[    0.213154] ACPI: bus type USB registered
[    0.213248] usbcore: registered new interface driver usbfs
[    0.213330] usbcore: registered new interface driver hub
[    0.213419] usbcore: registered new device driver usb
[    0.213573] PCI: Using ACPI for IRQ routing
[    0.215099] PCI: pci_cache_line_size set to 64 bytes
[    0.215133] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.215134] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.215135] e820: reserve RAM buffer [mem 0xd8db2000-0xdbffffff]
[    0.215136] e820: reserve RAM buffer [mem 0xd9388000-0xdbffffff]
[    0.215137] e820: reserve RAM buffer [mem 0xda2c0000-0xdbffffff]
[    0.215138] e820: reserve RAM buffer [mem 0xdac89000-0xdbffffff]
[    0.215139] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.215140] e820: reserve RAM buffer [mem 0x11f600000-0x11fffffff]
[    0.215228] Bluetooth: Core ver 2.19
[    0.215305] NET: Registered protocol family 31
[    0.215377] Bluetooth: HCI device and connection manager initialized
[    0.215452] Bluetooth: HCI socket layer initialized
[    0.215525] Bluetooth: L2CAP socket layer initialized
[    0.215601] Bluetooth: SCO socket layer initialized
[    0.215721] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.216055] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.219152] Switched to clocksource hpet
[    0.219294] pnp: PnP ACPI init
[    0.219419] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.219498] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.219544] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.219621] system 00:01: [io  0x0200-0x020f] has been reserved
[    0.219695] system 00:01: [io  0xffff] has been reserved
[    0.219769] system 00:01: [io  0xffff] has been reserved
[    0.219843] system 00:01: [io  0x0400-0x0453] could not be reserved
[    0.219917] system 00:01: [io  0x0458-0x047f] has been reserved
[    0.219992] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.220071] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.220089] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.220120] system 00:03: [io  0x0454-0x0457] has been reserved
[    0.220200] system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.220275] system 00:04: [io  0x0a00-0x0a0f] has been reserved
[    0.220354] system 00:04: [io  0x0a30-0x0a3f] has been reserved
[    0.220428] system 00:04: [io  0x0a20-0x0a2f] has been reserved
[    0.220503] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.220530] pnp 00:05: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.220675] pnp 00:06: [dma 0 disabled]
[    0.220708] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.220739] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.220818] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.220944] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.221024] system 00:08: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.221100] system 00:08: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.221175] system 00:08: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.221250] system 00:08: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.221326] system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.221401] system 00:08: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.221477] system 00:08: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.221552] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.221628] system 00:08: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.221703] system 00:08: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.221779] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.221862] system 00:09: [mem 0x20000000-0x201fffff] has been reserved
[    0.221943] system 00:09: [mem 0x40004000-0x40004fff] has been reserved
[    0.222018] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.222032] pnp: PnP ACPI: found 10 devices
[    0.228286] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.228368] pci 0000:00:1c.4: PCI bridge to [bus 02]
[    0.228442] pci 0000:00:1c.4:   bridge window [io  0xe000-0xefff]
[    0.228522] pci 0000:00:1c.4:   bridge window [mem 0xf0100000-0xf01fffff 64bit pref]
[    0.228603] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.228604] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.228605] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.228606] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.228607] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.228608] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.228609] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.228610] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.228611] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.228612] pci_bus 0000:00: resource 13 [mem 0xdfa00000-0xfeafffff]
[    0.228614] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.228615] pci_bus 0000:02: resource 2 [mem 0xf0100000-0xf01fffff 64bit pref]
[    0.228634] NET: Registered protocol family 2
[    0.228828] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.228955] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.229082] TCP: Hash tables configured (established 32768 bind 32768)
[    0.229166] TCP: reno registered
[    0.229241] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.229327] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.229432] NET: Registered protocol family 1
[    0.229562] RPC: Registered named UNIX socket transport module.
[    0.229637] RPC: Registered udp transport module.
[    0.229709] RPC: Registered tcp transport module.
[    0.229782] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.229864] fixup_debug_start: pci 0000:00:02.0: calling pci_fixup_video+0x0/0x111
[    0.229866] pci 0000:00:02.0: Boot video device
[    0.229869] fixup_debug_start: pci 0000:00:14.0: calling quirk_usb_early_handoff+0x0/0x60c
[    0.230003] fixup_debug_start: pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x60c
[    0.251281] fixup_debug_start: pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x60c
[    0.271266] PCI: CLS 64 bytes, default 64
[    0.271299] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.271376] software IO TLB [mem 0xd4db2000-0xd8db2000] (64MB) mapped at [ffff8800d4db2000-ffff8800d8db1fff]
[    0.271645] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    0.272234] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.272327] audit: initializing netlink subsys (disabled)
[    0.272409] audit: type=2000 audit(1410469107.268:1): initialized
[    0.272635] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.274479] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.274698] SGI XFS with ACLs, security attributes, realtime, debug enabled
[    0.275013] msgmni has been set to 7648
[    0.275343] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.275429] io scheduler noop registered
[    0.275501] io scheduler deadline registered
[    0.275576] io scheduler cfq registered (default)
[    0.275964] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.276061] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.276147] cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
[    0.276234] cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
[    0.276314] cpcihp_generic: not configured, disabling.
[    0.276397] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    0.276478] ibm_acpiphp_init: acpiphp_ibm: ibm_acpiphp_init
[    0.277234] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    0.277378] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.277461] ACPI: Power Button [PWRB]
[    0.277561] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.277641] ACPI: Power Button [PWRF]
[    0.277758] ACPI: Fan [FAN0] (off)
[    0.277852] ACPI: Fan [FAN1] (off)
[    0.277946] ACPI: Fan [FAN2] (off)
[    0.278039] ACPI: Fan [FAN3] (off)
[    0.278133] ACPI: Fan [FAN4] (off)
[    0.291368] Monitor-Mwait will be used to enter C-1 state
[    0.291374] Monitor-Mwait will be used to enter C-3 state
[    0.291384] ACPI: acpi_idle registered with cpuidle
[    0.303409] thermal LNXTHERM:00: registered as thermal_zone0
[    0.303483] ACPI: Thermal Zone [TZ00] (28 C)
[    0.303681] thermal LNXTHERM:01: registered as thermal_zone1
[    0.303762] ACPI: Thermal Zone [TZ01] (30 C)
[    0.315144] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.335658] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    0.336199] Linux agpgart interface v0.103
[    0.336298] [drm] Initialized drm 1.1.0 20060810
[    0.337349] brd: module loaded
[    0.337893] loop: module loaded
[    0.338066] ahci 0000:00:1f.2: version 3.0
[    0.338175] ahci 0000:00:1f.2: irq 24 for MSI/MSI-X
[    0.338209] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3 impl SATA mode
[    0.338288] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part ems apst 
[    0.343726] scsi host0: ahci
[    0.343888] scsi host1: ahci
[    0.344037] scsi host2: ahci
[    0.344186] scsi host3: ahci
[    0.344333] scsi host4: ahci
[    0.344477] scsi host5: ahci
[    0.344587] ata1: SATA max UDMA/133 abar m2048@0xf7c16000 port 0xf7c16100 irq 24
[    0.344669] ata2: SATA max UDMA/133 abar m2048@0xf7c16000 port 0xf7c16180 irq 24
[    0.344745] ata3: DUMMY
[    0.344814] ata4: DUMMY
[    0.344883] ata5: DUMMY
[    0.344953] ata6: DUMMY
[    0.345284] scsi host6: pata_legacy
[    0.345393] ata7: PATA max PIO4 cmd 0x1f0 ctl 0x3f6 irq 14
[    0.663194] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.663305] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.664195] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140724/psargs-359)
[    0.664374] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT1._GTF] (Node ffff8801198377a8), AE_NOT_FOUND (20140724/psparse-536)
[    0.664773] ata2.00: ATA-8: WDC WD10EZRX-00A8LB0, 01.01A01, max UDMA/133
[    0.664869] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    0.666755] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140724/psargs-359)
[    0.666935] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT1._GTF] (Node ffff8801198377a8), AE_NOT_FOUND (20140724/psparse-536)
[    0.667206] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140724/psargs-359)
[    0.667377] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff880119837730), AE_NOT_FOUND (20140724/psparse-536)
[    0.667623] ata1.00: ATAPI: TSSTcorp CDDVDW SN-208FB, SB00, max UDMA/100
[    0.667776] ata2.00: configured for UDMA/133
[    0.674367] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (20140724/psargs-359)
[    0.674546] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.SPT0._GTF] (Node ffff880119837730), AE_NOT_FOUND (20140724/psparse-536)
[    0.674788] ata1.00: configured for UDMA/100
[    1.271182] tsc: Refined TSC clocksource calibration: 3292.520 MHz
[    2.271302] Switched to clocksource tsc
[    3.359223] floppy0: no floppy controllers found
[    3.361603] scsi 0:0:0:0: CD-ROM            TSSTcorp CDDVDW SN-208FB  SB00 PQ: 0 ANSI: 5
[    3.389657] sr 0:0:0:0: [sr0] scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.389796] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.389951] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    3.390006] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    3.390159] scsi 1:0:0:0: Direct-Access     ATA      WDC WD10EZRX-00A 1A01 PQ: 0 ANSI: 5
[    3.390344] sd 1:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.390368] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.390499] sd 1:0:0:0: [sda] 4096-byte physical blocks
[    3.390606] sd 1:0:0:0: [sda] Write Protect is off
[    3.390680] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.390694] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.436527]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[    3.437498] sd 1:0:0:0: [sda] Attached SCSI disk
[    3.437841] scsi host7: pata_legacy
[    3.437958] ata8: PATA max PIO4 cmd 0x170 ctl 0x376 irq 15
[    3.591283] tun: Universal TUN/TAP device driver, 1.6
[    3.591357] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.591507] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.591586] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
[    3.591702] pci_set_mwi: r8169 0000:02:00.0: enabling Mem-Wr-Inval
[    3.591865] r8169 0000:02:00.0: irq 25 for MSI/MSI-X
[    3.591980] r8169 0000:02:00.0 eth0: RTL8168evl/8111evl at 0xffffc9000067a000, 74:d4:35:1c:8e:7f, XID 0c900800 IRQ 25
[    3.592100] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    3.592228] PPP generic driver version 2.4.2
[    3.592329] PPP BSD Compression module registered
[    3.592404] PPP Deflate Compression module registered
[    3.592479] NET: Registered protocol family 24
[    3.592604] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.592684] ehci-pci: EHCI PCI platform driver
[    3.592824] __pci_set_master: ehci-pci 0000:00:1a.0: enabling bus mastering
[    3.592831] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    3.592930] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    3.593018] ehci-pci 0000:00:1a.0: debug port 2
[    3.596975] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    3.596986] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7c18000
[    3.607104] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    3.607381] hub 1-0:1.0: USB hub found
[    3.607459] hub 1-0:1.0: 2 ports detected
[    3.607670] __pci_set_master: ehci-pci 0000:00:1d.0: enabling bus mastering
[    3.607676] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    3.607850] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.607939] ehci-pci 0000:00:1d.0: debug port 2
[    3.611898] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    3.611908] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7c17000
[    3.623103] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.623375] hub 2-0:1.0: USB hub found
[    3.623453] hub 2-0:1.0: 2 ports detected
[    3.623610] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.623693] ohci-pci: OHCI PCI platform driver
[    3.623775] uhci_hcd: USB Universal Host Controller Interface driver
[    3.623925] __pci_set_master: xhci_hcd 0000:00:14.0: enabling bus mastering
[    3.623930] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.624056] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    3.624209] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    3.624223] xhci_hcd 0000:00:14.0: irq 26 for MSI/MSI-X
[    3.624392] hub 3-0:1.0: USB hub found
[    3.624474] hub 3-0:1.0: 4 ports detected
[    3.624751] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    3.624870] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    3.625113] hub 4-0:1.0: USB hub found
[    3.625193] hub 4-0:1.0: 4 ports detected
[    3.625534] usbcore: registered new interface driver cdc_wdm
[    3.625627] usbcore: registered new interface driver usb-storage
[    3.625724] usbcore: registered new interface driver usbserial
[    3.625805] usbcore: registered new interface driver usbserial_generic
[    3.625886] usbserial: USB Serial support registered for generic
[    3.625968] usbcore: registered new interface driver aircable
[    3.626047] usbserial: USB Serial support registered for aircable
[    3.626129] usbcore: registered new interface driver ark3116
[    3.626208] usbserial: USB Serial support registered for ark3116
[    3.626289] usbcore: registered new interface driver belkin_sa
[    3.626369] usbserial: USB Serial support registered for Belkin / Peracom / GoHubs USB Serial Adapter
[    3.626494] usbcore: registered new interface driver ch341
[    3.626573] usbserial: USB Serial support registered for ch341-uart
[    3.626656] usbcore: registered new interface driver cp210x
[    3.626734] usbserial: USB Serial support registered for cp210x
[    3.626818] usbcore: registered new interface driver cyberjack
[    3.626897] usbserial: USB Serial support registered for Reiner SCT Cyberjack USB card reader
[    3.627021] usbcore: registered new interface driver cypress_m8
[    3.627104] usbserial: USB Serial support registered for DeLorme Earthmate USB
[    3.627186] usbserial: USB Serial support registered for HID->COM RS232 Adapter
[    3.627267] usbserial: USB Serial support registered for Nokia CA-42 V2 Adapter
[    3.627351] usbcore: registered new interface driver usb_debug
[    3.627430] usbserial: USB Serial support registered for debug
[    3.627511] usbcore: registered new interface driver digi_acceleport
[    3.627591] usbserial: USB Serial support registered for Digi 2 port USB adapter
[    3.627672] usbserial: USB Serial support registered for Digi 4 port USB adapter
[    3.627756] usbcore: registered new interface driver io_edgeport
[    3.627836] usbserial: USB Serial support registered for Edgeport 2 port adapter
[    3.627917] usbserial: USB Serial support registered for Edgeport 4 port adapter
[    3.627998] usbserial: USB Serial support registered for Edgeport 8 port adapter
[    3.628079] usbserial: USB Serial support registered for EPiC device
[    3.628162] usbcore: registered new interface driver io_ti
[    3.628241] usbserial: USB Serial support registered for Edgeport TI 1 port adapter
[    3.628324] usbserial: USB Serial support registered for Edgeport TI 2 port adapter
[    3.628409] usbcore: registered new interface driver empeg
[    3.628487] usbserial: USB Serial support registered for empeg
[    3.628569] usbcore: registered new interface driver ftdi_sio
[    3.628648] usbserial: USB Serial support registered for FTDI USB Serial Device
[    3.628747] usbcore: registered new interface driver ipaq
[    3.628826] usbserial: USB Serial support registered for PocketPC PDA
[    3.628918] usbcore: registered new interface driver ipw
[    3.628998] usbserial: USB Serial support registered for IPWireless converter
[    3.629081] usbcore: registered new interface driver ir_usb
[    3.629160] usbserial: USB Serial support registered for IR Dongle
[    3.629242] usbcore: registered new interface driver iuu_phoenix
[    3.629322] usbserial: USB Serial support registered for iuu_phoenix
[    3.629404] usbcore: registered new interface driver keyspan_pda
[    3.629483] usbserial: USB Serial support registered for Keyspan PDA
[    3.629564] usbserial: USB Serial support registered for Keyspan PDA - (prerenumeration)
[    3.629646] usbserial: USB Serial support registered for Xircom / Entregra PGS - (prerenumeration)
[    3.629771] usbcore: registered new interface driver kl5kusb105
[    3.629851] usbserial: USB Serial support registered for KL5KUSB105D / PalmConnect
[    3.629935] usbcore: registered new interface driver kobil_sct
[    3.630014] usbserial: USB Serial support registered for KOBIL USB smart card terminal
[    3.630098] usbcore: registered new interface driver mct_u232
[    3.630178] usbserial: USB Serial support registered for MCT U232
[    3.630261] usbcore: registered new interface driver mos7720
[    3.630340] usbserial: USB Serial support registered for Moschip 2 port adapter
[    3.630423] usbcore: registered new interface driver mos7840
[    3.630502] usbserial: USB Serial support registered for Moschip 7840/7820 USB Serial Driver
[    3.630588] usbcore: registered new interface driver navman
[    3.630667] usbserial: USB Serial support registered for navman
[    3.630748] usbcore: registered new interface driver omninet
[    3.630828] usbserial: USB Serial support registered for ZyXEL - omni.net lcd plus usb
[    3.630913] usbcore: registered new interface driver opticon
[    3.630992] usbserial: USB Serial support registered for opticon
[    3.631078] usbcore: registered new interface driver option
[    3.631157] usbserial: USB Serial support registered for GSM modem (1-port)
[    3.631262] usbcore: registered new interface driver oti6858
[    3.631342] usbserial: USB Serial support registered for oti6858
[    3.631424] usbcore: registered new interface driver pl2303
[    3.631504] usbserial: USB Serial support registered for pl2303
[    3.631587] usbcore: registered new interface driver qcaux
[    3.631666] usbserial: USB Serial support registered for qcaux
[    3.631748] usbcore: registered new interface driver qcserial
[    3.631827] usbserial: USB Serial support registered for Qualcomm USB modem
[    3.631913] usbcore: registered new interface driver safe_serial
[    3.631992] usbserial: USB Serial support registered for safe_serial
[    3.632076] usbcore: registered new interface driver sierra
[    3.632155] usbserial: USB Serial support registered for Sierra USB modem
[    3.632239] usbcore: registered new interface driver spcp8x5
[    3.632319] usbserial: USB Serial support registered for SPCP8x5
[    3.632401] usbcore: registered new interface driver ssu100
[    3.632480] usbserial: USB Serial support registered for Quatech SSU-100 USB to Serial Driver
[    3.632605] usbcore: registered new interface driver symbolserial
[    3.632684] usbserial: USB Serial support registered for symbol
[    3.632768] usbcore: registered new interface driver ti_usb_3410_5052
[    3.632848] usbserial: USB Serial support registered for TI USB 3410 1 port adapter
[    3.632930] usbserial: USB Serial support registered for TI USB 5052 2 port adapter
[    3.633014] usbcore: registered new interface driver visor
[    3.633093] usbserial: USB Serial support registered for Handspring Visor / Palm OS
[    3.633175] usbserial: USB Serial support registered for Sony Clie 5.0
[    3.633256] usbserial: USB Serial support registered for Sony Clie 3.5
[    3.633340] usbcore: registered new interface driver whiteheat
[    3.633420] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[    3.633543] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT
[    3.633649] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    3.633725] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    3.633975] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.634129] mousedev: PS/2 mouse device common for all mice
[    3.634324] rtc_cmos 00:02: RTC can wake from S4
[    3.634502] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    3.634602] rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    3.634686] i2c /dev entries driver
[    3.634764] md: raid1 personality registered for level 1
[    3.634895] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    3.635271] usbcore: registered new interface driver usbhid
[    3.635345] usbhid: USB HID core driver
[    3.635420] oprofile: using NMI interrupt.
[    3.635503] Netfilter messages via NETLINK v0.30.
[    3.635581] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.635745] ip_set: protocol 6
[    3.637016] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.637110] TCP: cubic registered
[    3.637284] NET: Registered protocol family 10
[    3.637514] mip6: Mobile IPv6
[    3.637589] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.637693] sit: IPv6 over IPv4 tunneling driver
[    3.637948] NET: Registered protocol family 17
[    3.638030] Bridge firewalling registered
[    3.638110] 8021q: 802.1Q VLAN Support v1.8
[    3.638187] Key type dns_resolver registered
[    3.638512] registered taskstats version 1
[    3.638819] rtc_cmos 00:02: setting system clock to 2014-09-11 20:58:31 UTC (1410469111)
[    3.655485] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.655815] md: Waiting for all devices to be available before autodetect
[    3.655906] md: If you don't use raid, use raid=noautodetect
[    3.656226] md: Autodetecting RAID arrays.
[    3.656313] md: Scanned 0 and added 0 devices.
[    3.656398] md: autorun ...
[    3.656479] md: ... autorun DONE.
[    3.677753] kjournald starting.  Commit interval 5 seconds
[    3.677791] EXT3-fs (sda2): mounted filesystem with writeback data mode
[    3.677798] VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
[    3.698312] devtmpfs: mounted
[    3.698572] Freeing unused kernel memory: 860K (ffffffff81939000 - ffffffff81a10000)
[    3.919101] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    4.051889] hub 1-1:1.0: USB hub found
[    4.052108] hub 1-1:1.0: 6 ports detected
[    4.163135] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    4.296015] hub 2-1:1.0: USB hub found
[    4.296258] hub 2-1:1.0: 6 ports detected
[    4.367237] usb 1-1.3: new low-speed USB device number 3 using ehci-pci
[    4.475025] input: HID 04d9:1133 as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/0003:04D9:1133.0001/input/input3
[    4.475289] hid-generic 0003:04D9:1133.0001: input: USB HID v1.10 Mouse [HID 04d9:1133] on usb-0000:00:1a.0-1.3/input0
[    5.453181] random: nonblocking pool is initialized
[    6.103926] systemd-udevd[1840]: starting version 216
[    6.928421] [drm] Memory usable by graphics device = 2048M
[    6.928422] [drm] Replacing VGA console driver
[    6.929218] Console: switching to colour dummy device 80x25
[    6.951051] i915 0000:00:02.0: irq 27 for MSI/MSI-X
[    6.951062] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    6.951063] [drm] Driver supports precise vblank timestamp query.
[    6.951162] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    6.963655] r8169 0000:02:00.0 enp2s0: renamed from eth0
[    6.983100] systemd-udevd[1861]: renamed network interface eth0 to enp2s0
[    7.052207] fbcon: inteldrmfb (fb0) is primary device
[    7.086496] Console: switching to colour frame buffer device 240x67
[    7.086640] [drm:cpt_set_fifo_underrun_reporting] *ERROR* uncleared pch fifo underrun on pch transcoder A
[    7.086641] [drm:cpt_serr_int_handler] *ERROR* PCH transcoder A FIFO underrun
[    7.090026] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    7.090027] i915 0000:00:02.0: registered panic notifier
[    7.099190] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    7.099338] acpi device:49: registered as cooling_device9
[    7.099390] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    7.099448] [drm] Initialized i915 1.6.0 20140725 for 0000:00:02.0 on minor 0
[    7.099583] snd_hda_intel 0000:00:1b.0: irq 28 for MSI/MSI-X
[    7.212995] sound hdaudioC0D2: autoconfig: line_outs=3 (0x14/0x15/0x16/0x0/0x0) type:line
[    7.212997] sound hdaudioC0D2:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    7.212998] sound hdaudioC0D2:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    7.212999] sound hdaudioC0D2:    mono: mono_out=0x0
[    7.213000] sound hdaudioC0D2:    dig-out=0x11/0x1e
[    7.213000] sound hdaudioC0D2:    inputs:
[    7.213002] sound hdaudioC0D2:      Front Mic=0x19
[    7.213003] sound hdaudioC0D2:      Rear Mic=0x18
[    7.213004] sound hdaudioC0D2:      Line=0x1a
[   18.501876] NET: Registered protocol family 38
[   18.816746] EXT3-fs (sda2): using internal journal
[   18.992341] Adding 4194300k swap on /dev/sda5.  Priority:-1 extents:1 across:4194300k 
[   19.086469] EXT4-fs (dm-6): warning: maximal mount count reached, running e2fsck is recommended
[   19.091368] EXT4-fs (dm-6): mounted filesystem with ordered data mode. Opts: (null)
[   21.008037] r8169 0000:02:00.0: Direct firmware load for rtl_nic/rtl8168e-3.fw failed with error -2
[   21.008042] r8169 0000:02:00.0 enp2s0: unable to load firmware patch rtl_nic/rtl8168e-3.fw (-2)
[   21.020695] r8169 0000:02:00.0 enp2s0: link down
[   21.020717] r8169 0000:02:00.0 enp2s0: link down
[   21.020729] IPv6: ADDRCONF(NETDEV_UP): enp2s0: link is not ready
[   21.351804] device enp2s0 entered promiscuous mode
[   21.357149] device br0 entered promiscuous mode
[   21.368704] IPv6: ADDRCONF(NETDEV_UP): br0: link is not ready
[   23.404036] r8169 0000:02:00.0 enp2s0: link up
[   23.404044] IPv6: ADDRCONF(NETDEV_CHANGE): enp2s0: link becomes ready
[   23.404559] br0: port 1(enp2s0) entered forwarding state
[   23.404566] br0: port 1(enp2s0) entered forwarding state
[   23.404600] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
[   29.864164] NFS: Registering the id_resolver key type
[   29.864174] Key type id_resolver registered
[   29.864175] Key type id_legacy registered
[   33.725187] fuse init (API version 7.23)
[   38.430190] br0: port 1(enp2s0) entered forwarding state
