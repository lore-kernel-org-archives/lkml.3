Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaIKNpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:45:07 -0400
Received: from services.gouders.net ([141.101.32.176]:51967 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbaIKNpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:45:01 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
	(Andreas Noever's message of "Wed, 3 Sep 2014 17:54:17 +0200")
References: <ghiol53r9u.fsf@lena.gouders.net>
	<CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
	<ghwq9k3m6z.fsf@lena.gouders.net>
	<CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Thu, 11 Sep 2014 15:43:58 +0200
Message-ID: <ghioku5l29.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Andreas Noever <andreas.noever@gmail.com> writes:

> On Wed, Sep 3, 2014 at 2:47 PM, Dirk Gouders <dirk@gouders.net> wrote:
>> Andreas Noever <andreas.noever@gmail.com> writes:
>>
>>> On Wed, Sep 3, 2014 at 12:57 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>>> On a Tyan VX50 (B4985) I ran into problems when updating the kernel: the
>>>> PCI FC Adapter is no longer recognized.
>>>
>>> Can you provide the output of lspci -vvv and the output of dmesg from
>>> a working boot? Which card is the one that is not recognized?
>>
>> Sure, the card that disappeared is:
>>
>> 0a:00.0 Fibre Channel: LSI Logic / Symbios Logic FC949ES Fibre Channel Adapter (rev 02)
>
> As far as I can tell the following is happening:
> The root bus resource window (advertised by the bios?) is to small:
> pci_bus 0000:00: root bus resource [bus 00-07]
> Previously we didn't really care. There is a resource conflict but we
> ignored it:
> pci_bus 0000:0a: busn_res: can not insert [bus 0a] under [bus 00-07]
> (conflicts with (null) [bus 00-07])
> With the patch we mark the bridge as broken and reassign the bus to 06:
> pci 0000:00:0e.0: bridge configuration invalid ([bus 0a-0a]), reconfiguring
> pci 0000:00:0e.0: PCI bridge to [bus 06-07]
> pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
> pci 0000:00:0e.0:   bridge window [mem 0xd4200000-0xd42fffff]
> pci_bus 0000:06: busn_res: [bus 06-07] end is updated to 06
>
> We still scan for children but nothing shows up ("PCI bridge to" is
> from pci_scan_child_bus -> pcibios_fixup_bus -> pci_read_bridge_base,
> after pci_scan_slot). I have no idea why the device does not respond.

Andreas,

I found an identical FC Adapter here (backup) and was hoping to be able to
setup a test-machine where I can easily reproduce the problem, but
on that machine, the problem does not occur. So, I have to stick to the
busy machine for testing and diagnosis.

What I further did was rebooting the problematic machine and
enabling more messages (dyndbg="file drivers/pci/* +pf") with
the working and problematic kernel; the dmesg output is attached.

Dirk


--=-=-=
Content-Disposition: inline; filename=dmesg.problem
Content-Description: dmesg.problem

[    0.000000] Linux version 3.14.0-rc1-00005-g1820ffd (root@quad) (gcc version 4.7.3 (Gentoo 4.7.3-r1 p1.4, pie-0.5.5) ) #19 SMP Thu Sep 11 14:18:11 CEST 2014
[    0.000000] Command line: root=/dev/sda2 dyndbg="file drivers/pci/* +pf" log_buf_len=10M pci=nocrs
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x00000000000997ff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000099800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000ca000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffdffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ffe0000-0x000000007ffe9fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007ffea000-0x000000007fffffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x00000000cfbfffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfc00000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff80000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000a2fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: NVIDIA  CK8 /Tyan Transport VX50-B4985, BIOS TYAN Transport VX50 B4985 BIOS V3.01.B30 11/27/2009
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xa30000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000a30000000 aka 41728M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcfc00 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f7770-0x000f777f] mapped at [ffff8800000f7770]
[    0.000000] Base memory trampoline at [ffff880000093000] 93000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01929000, 0x01929fff] PGTABLE
[    0.000000] BRK [0x0192a000, 0x0192afff] PGTABLE
[    0.000000] BRK [0x0192b000, 0x0192bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xa2fe00000-0xa2fffffff]
[    0.000000]  [mem 0xa2fe00000-0xa2fffffff] page 2M
[    0.000000] BRK [0x0192c000, 0x0192cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xa2c000000-0xa2fdfffff]
[    0.000000]  [mem 0xa2c000000-0xa2fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0xa00000000-0xa2bffffff]
[    0.000000]  [mem 0xa00000000-0xa2bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7ffdffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x7fdfffff] page 2M
[    0.000000]  [mem 0x7fe00000-0x7ffdffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x80000000-0xcfbfffff]
[    0.000000]  [mem 0x80000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xcfbfffff] page 2M
[    0.000000] BRK [0x0192d000, 0x0192dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x9ffffffff]
[    0.000000]  [mem 0x100000000-0x9ffffffff] page 1G
[    0.000000] log_buf_len: 16777216
[    0.000000] early log buf free: 257872(98%)
[    0.000000] ACPI: RSDP 00000000000f77f0 000014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 000000007ffe0aab 000038 (v01 PTLTD    RSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 000000007ffe4c98 000074 (v01 NVIDIA CK8S     06040000 PTL_ 000F4240)
[    0.000000] ACPI: DSDT 000000007ffe0ae3 0041B5 (v01 NVIDIA      CK8 06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 000000007ffeafc0 000040
[    0.000000] ACPI: SSDT 000000007ffe4d0c 005084 (v01 AMD    POWERNOW 06040000 AMD  00000001)
[    0.000000] ACPI: SPCR 000000007ffe9d90 000050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: APIC 000000007ffe9de0 0001F8 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 000000007ffe9fd8 000028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] Number of physical nodes 8
[    0.000000] Node 0 MemBase 0000000000000000 Limit 0000000130000000
[    0.000000] Node 1 MemBase 0000000130000000 Limit 0000000230000000
[    0.000000] Node 2 MemBase 0000000230000000 Limit 0000000330000000
[    0.000000] Node 3 MemBase 0000000330000000 Limit 0000000430000000
[    0.000000] Node 4 MemBase 0000000430000000 Limit 0000000530000000
[    0.000000] Node 5 MemBase 0000000530000000 Limit 0000000630000000
[    0.000000] Node 6 MemBase 0000000630000000 Limit 0000000830000000
[    0.000000] Node 7 MemBase 0000000830000000 Limit 0000000a30000000
[    0.000000] BSP APIC ID: 04
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x12fffffff]
[    0.000000]   NODE_DATA [mem 0x12fffc000-0x12fffffff]
[    0.000000] Initmem setup node 1 [mem 0x130000000-0x22fffffff]
[    0.000000]   NODE_DATA [mem 0x22fffc000-0x22fffffff]
[    0.000000] Initmem setup node 2 [mem 0x230000000-0x32fffffff]
[    0.000000]   NODE_DATA [mem 0x32fffc000-0x32fffffff]
[    0.000000] Initmem setup node 3 [mem 0x330000000-0x42fffffff]
[    0.000000]   NODE_DATA [mem 0x42fffc000-0x42fffffff]
[    0.000000] Initmem setup node 4 [mem 0x430000000-0x52fffffff]
[    0.000000]   NODE_DATA [mem 0x52fffc000-0x52fffffff]
[    0.000000] Initmem setup node 5 [mem 0x530000000-0x62fffffff]
[    0.000000]   NODE_DATA [mem 0x62fffc000-0x62fffffff]
[    0.000000] Initmem setup node 6 [mem 0x630000000-0x82fffffff]
[    0.000000]   NODE_DATA [mem 0x82fffc000-0x82fffffff]
[    0.000000] Initmem setup node 7 [mem 0x830000000-0xa2fffffff]
[    0.000000]   NODE_DATA [mem 0xa2effa000-0xa2effdfff]
[    0.000000] [ffffea0004280000-ffffea00043fffff] potential offnode page_structs
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff88012be00000-ffff88012f7fffff] on node 0
[    0.000000] [ffffea0007a80000-ffffea0007bfffff] potential offnode page_structs
[    0.000000]  [ffffea0004400000-ffffea0007bfffff] PMD -> [ffff88022be00000-ffff88022f5fffff] on node 1
[    0.000000] [ffffea000b280000-ffffea000b3fffff] potential offnode page_structs
[    0.000000]  [ffffea0007c00000-ffffea000b3fffff] PMD -> [ffff88032be00000-ffff88032f5fffff] on node 2
[    0.000000] [ffffea000ea80000-ffffea000ebfffff] potential offnode page_structs
[    0.000000]  [ffffea000b400000-ffffea000ebfffff] PMD -> [ffff88042be00000-ffff88042f5fffff] on node 3
[    0.000000] [ffffea0012280000-ffffea00123fffff] potential offnode page_structs
[    0.000000]  [ffffea000ec00000-ffffea00123fffff] PMD -> [ffff88052be00000-ffff88052f5fffff] on node 4
[    0.000000] [ffffea0015a80000-ffffea0015bfffff] potential offnode page_structs
[    0.000000]  [ffffea0012400000-ffffea0015bfffff] PMD -> [ffff88062be00000-ffff88062f5fffff] on node 5
[    0.000000] [ffffea001ca80000-ffffea001cbfffff] potential offnode page_structs
[    0.000000]  [ffffea0015c00000-ffffea001cbfffff] PMD -> [ffff880827e00000-ffff88082edfffff] on node 6
[    0.000000]  [ffffea001cc00000-ffffea0023bfffff] PMD -> [ffff880a26600000-ffff880a2d5fffff] on node 7
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0xa2fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00098fff]
[    0.000000]   node   0: [mem 0x00100000-0x7ffdffff]
[    0.000000]   node   0: [mem 0x80000000-0xcfbfffff]
[    0.000000]   node   0: [mem 0x100000000-0x12fffffff]
[    0.000000]   node   1: [mem 0x130000000-0x22fffffff]
[    0.000000]   node   2: [mem 0x230000000-0x32fffffff]
[    0.000000]   node   3: [mem 0x330000000-0x42fffffff]
[    0.000000]   node   4: [mem 0x430000000-0x52fffffff]
[    0.000000]   node   5: [mem 0x530000000-0x62fffffff]
[    0.000000]   node   6: [mem 0x630000000-0x82fffffff]
[    0.000000]   node   7: [mem 0x830000000-0xa2fffffff]
[    0.000000] On node 0 totalpages: 1047416
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3992 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11578 pages used for memmap
[    0.000000]   DMA32 zone: 846816 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 196608 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 4 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 5 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 6 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] On node 7 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x18] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x19] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x1a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x1b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x1c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x1d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x1e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 32 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x00099000-0x00099fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000c9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000ca000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ffe0000-0x7ffe9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ffea000-0x7fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfc00000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfff7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfff80000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xdfffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:32 nr_node_ids:8
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88012fc00000 s79552 r8192 d22848 u524288
[    0.000000] pcpu-alloc: s79552 r8192 d22848 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 [1] 04 05 06 07 
[    0.000000] pcpu-alloc: [2] 08 09 10 11 [3] 12 13 14 15 
[    0.000000] pcpu-alloc: [4] 16 17 18 19 [5] 20 21 22 23 
[    0.000000] pcpu-alloc: [6] 24 25 26 27 [7] 28 29 30 31 
[    0.000000] Built 8 zonelists in Zone order, mobility grouping on.  Total pages: 10341233
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda2 dyndbg="file drivers/pci/* +pf" log_buf_len=10M pci=nocrs
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ d0000000 size 64 MB
[    0.000000] Node 1: aperture @ d0000000 size 64 MB
[    0.000000] Node 2: aperture @ d0000000 size 64 MB
[    0.000000] Node 3: aperture @ d0000000 size 64 MB
[    0.000000] Node 4: aperture @ d0000000 size 64 MB
[    0.000000] Node 5: aperture @ d0000000 size 64 MB
[    0.000000] Node 6: aperture @ d0000000 size 64 MB
[    0.000000] Node 7: aperture @ d0000000 size 64 MB
[    0.000000] Memory: 41266608K/41938400K available (4440K kernel code, 648K rwdata, 2420K rodata, 932K init, 892K bss, 671792K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:936 16
[    0.000000] ACPI: Core revision 20131218
[    0.000000] ACPI: All ACPI Tables successfully acquired
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1908.652 MHz processor
[    0.000019] Calibrating delay loop (skipped), value calculated using timer frequency.. 3817.30 BogoMIPS (lpj=7634608)
[    0.000318] pid_max: default: 32768 minimum: 301
[    0.008035] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.058607] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.082168] Mount-cache hash table entries: 256
[    0.083035] tseg: 00cfc00000
[    0.083041] CPU: Physical Processor ID: 0
[    0.083196] CPU: Processor Core ID: 0
[    0.083344] mce: CPU supports 6 MCE banks
[    0.083502] LVT offset 0 assigned for vector 0xf9
[    0.083644] process: using AMD E400 aware idle routine
[    0.083797] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
tlb_flushall_shift: 4
[    0.084330] Freeing SMP alternatives memory: 20K (ffffffff81843000 - ffffffff81848000)
[    0.084668] Switched APIC routing to physical flat.
[    0.085285] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.125188] smpboot: CPU0: Quad-Core AMD Opteron(tm) Processor 8347 HE (fam: 10, model: 02, stepping: 03)
[    0.229895] Performance Events: AMD PMU driver.
[    0.230108] ... version:                0
[    0.230252] ... bit width:              48
[    0.230386] ... generic registers:      4
[    0.230520] ... value mask:             0000ffffffffffff
[    0.230667] ... max period:             00007fffffffffff
[    0.230813] ... fixed-purpose events:   0
[    0.230959] ... event mask:             000000000000000f
[    0.233147] x86: Booting SMP configuration:
[    0.233327] .... node  #0, CPUs:        #1  #2  #3
[    0.274004] .... node  #1, CPUs:    #4  #5  #6  #7
[    0.423122] .... node  #2, CPUs:    #8  #9 #10 #11
[    0.575317] .... node  #3, CPUs:   #12 #13 #14 #15
[    0.727420] .... node  #4, CPUs:   #16 #17 #18 #19
[    0.879626] .... node  #5, CPUs:   #20 #21 #22 #23
[    1.031828] .... node  #6, CPUs:   #24 #25 #26 #27
[    1.183961] .... node  #7, CPUs:   #28 #29 #30 #31
[    1.335483] x86: Booted up 8 nodes, 32 CPUs
[    1.335777] smpboot: Total of 32 processors activated (122204.43 BogoMIPS)
[    1.357676] devtmpfs: initialized
[    1.358544] PM: Registering ACPI NVS region [mem 0x7ffea000-0x7fffffff] (90112 bytes)
[    1.360047] NET: Registered protocol family 16
[    1.360838] cpuidle: using governor ladder
[    1.360986] cpuidle: using governor menu
[    1.361140] node 0 link 1: io port [1000, 3fff]
[    1.361145] node 1 link 1: io port [b000, bfff]
[    1.361147] node 1 link 1: io port [9000, 9fff]
[    1.361151] TOM: 00000000d0000000 aka 3328M
[    1.361300] node 0 link 1: mmio [d4000000, dbffffff]
[    1.361304] node 1 link 1: mmio [dc000000, dc3fffff]
[    1.361307] node 0 link 1: mmio [a0000, bffff]
[    1.361310] node 0 link 1: mmio [e0000000, e7ffffff]
[    1.361312] node 1 link 1: mmio [e8000000, efffffff]
[    1.361315] TOM2: 0000000a30000000 aka 41728M
[    1.361467] bus: [bus 00-7f] on node 0 link 1
[    1.361469] bus: 00 [io  0x0000-0x8fff]
[    1.361471] bus: 00 [io  0xc000-0xffff]
[    1.361472] bus: 00 [io  0xa000-0xafff]
[    1.361473] bus: 00 [mem 0xd0000000-0xdbffffff]
[    1.361475] bus: 00 [mem 0x000a0000-0x000bffff]
[    1.361476] bus: 00 [mem 0xdc400000-0xe7ffffff]
[    1.361477] bus: 00 [mem 0xf0000000-0xffffffff]
[    1.361479] bus: 00 [mem 0xa30000000-0xfcffffffff]
[    1.361480] bus: [bus 80-ff] on node 1 link 1
[    1.361482] bus: 80 [io  0xb000-0xbfff]
[    1.361483] bus: 80 [io  0x9000-0x9fff]
[    1.361484] bus: 80 [mem 0xdc000000-0xdc3fffff]
[    1.361485] bus: 80 [mem 0xe8000000-0xefffffff]
[    1.361661] ACPI: bus type PCI registered
[    1.362040] PCI: Using configuration type 1 for base access
[    1.362188] PCI: Using configuration type 1 for extended access
[    1.378586] bio: create slab <bio-0> at 0
[    1.379664] ACPI: Added _OSI(Module Device)
[    1.379811] ACPI: Added _OSI(Processor Device)
[    1.379965] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.380113] ACPI: Added _OSI(Processor Aggregator Device)
[    1.396206] ACPI: Interpreter enabled
[    1.396423] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
[    1.396776] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20131218/hwxface-580)
[    1.397112] ACPI: (supports S0 S1 S4 S5)
[    1.397274] ACPI: Using IOAPIC for interrupt routing
[    1.397550] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    1.398033] ACPI: No dock devices found.
[    1.417780] ACPI: \_PR_.C020: failed to get CPU APIC ID.
[    1.417791] ACPI: \_PR_.C021: failed to get CPU APIC ID.
[    1.417799] ACPI: \_PR_.C022: failed to get CPU APIC ID.
[    1.417806] ACPI: \_PR_.C023: failed to get CPU APIC ID.
[    1.417815] ACPI: \_PR_.C024: failed to get CPU APIC ID.
[    1.417822] ACPI: \_PR_.C025: failed to get CPU APIC ID.
[    1.417829] ACPI: \_PR_.C026: failed to get CPU APIC ID.
[    1.417835] ACPI: \_PR_.C027: failed to get CPU APIC ID.
[    1.417842] ACPI: \_PR_.C028: failed to get CPU APIC ID.
[    1.417848] ACPI: \_PR_.C029: failed to get CPU APIC ID.
[    1.417856] ACPI: \_PR_.C02A: failed to get CPU APIC ID.
[    1.417862] ACPI: \_PR_.C02B: failed to get CPU APIC ID.
[    1.417869] ACPI: \_PR_.C02C: failed to get CPU APIC ID.
[    1.417875] ACPI: \_PR_.C02D: failed to get CPU APIC ID.
[    1.417883] ACPI: \_PR_.C02E: failed to get CPU APIC ID.
[    1.417890] ACPI: \_PR_.C02F: failed to get CPU APIC ID.
[    1.418178] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-07])
[    1.418370] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.418536] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.419031] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.419034] acpi PNP0A03:00: host bridge window [io  0x0d00-0x3fff] (ignored)
[    1.419037] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.419040] acpi PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    1.419043] acpi PNP0A03:00: host bridge window [mem 0xd4000000-0xdbffffff] (ignored)
[    1.419047] PCI: root bus 00: hardware-probed resources
[    1.419170] PCI host bridge to bus 0000:00
[    1.419324] pci_bus 0000:00: root bus resource [bus 00-07]
[    1.419478] pci_bus 0000:00: root bus resource [io  0x0000-0x8fff]
[    1.419626] pci_bus 0000:00: root bus resource [io  0xc000-0xffff]
[    1.419766] pci_bus 0000:00: root bus resource [io  0xa000-0xafff]
[    1.419927] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xdbffffff]
[    1.420069] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.420221] pci_bus 0000:00: root bus resource [mem 0xdc400000-0xe7ffffff]
[    1.420374] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xffffffff]
[    1.420526] pci_bus 0000:00: root bus resource [mem 0xa30000000-0xfcffffffff]
[    1.420691] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[    1.420712] pci 0000:00:00.0: [10de:005e] type 00 class 0x058000
[    1.420971] pci 0000:00:01.0: [10de:0051] type 00 class 0x060100
[    1.421040] fixup_debug_start: pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xaa
[    1.421042] HPET not enabled in BIOS. You might try hpet=force boot option
[    1.421373] pci 0000:00:01.1: [10de:0052] type 00 class 0x0c0500
[    1.421387] pci 0000:00:01.1: reg 0x10: [io  0x0000-0x001f]
[    1.421399] pci 0000:00:01.1: reg 0x20: [io  0xa000-0xa03f]
[    1.421423] pci 0000:00:01.1: reg 0x24: [io  0xa040-0xa07f]
[    1.421464] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    1.421470] pci_pme_active: pci 0000:00:01.1: PME# disabled
[    1.421653] pci 0000:00:02.0: [10de:005a] type 00 class 0x0c0310
[    1.421664] pci 0000:00:02.0: reg 0x10: [mem 0xd4000000-0xd4000fff]
[    1.421700] pci 0000:00:02.0: supports D1 D2
[    1.421709] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.421717] pci_pme_active: pci 0000:00:02.0: PME# disabled
[    1.421797] pci 0000:00:02.0: System wakeup disabled by ACPI
[    1.422084] pci 0000:00:02.1: [10de:005b] type 00 class 0x0c0320
[    1.422098] pci 0000:00:02.1: reg 0x10: [mem 0xd4001000-0xd40010ff]
[    1.422133] pci 0000:00:02.1: supports D1 D2
[    1.422136] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.422139] pci_pme_active: pci 0000:00:02.1: PME# disabled
[    1.422207] pci 0000:00:02.1: System wakeup disabled by ACPI
[    1.422475] pci 0000:00:06.0: [10de:0053] type 00 class 0x01018a
[    1.422503] pci 0000:00:06.0: reg 0x20: [io  0x1400-0x140f]
[    1.422703] pci 0000:00:07.0: [10de:0054] type 00 class 0x010185
[    1.422710] pci 0000:00:07.0: reg 0x10: [io  0x1440-0x1447]
[    1.422717] pci 0000:00:07.0: reg 0x14: [io  0x1434-0x1437]
[    1.422722] pci 0000:00:07.0: reg 0x18: [io  0x1438-0x143f]
[    1.422726] pci 0000:00:07.0: reg 0x1c: [io  0x1430-0x1433]
[    1.422731] pci 0000:00:07.0: reg 0x20: [io  0x1410-0x141f]
[    1.422736] pci 0000:00:07.0: reg 0x24: [mem 0xd4002000-0xd4002fff]
[    1.422950] pci 0000:00:08.0: [10de:0055] type 00 class 0x010185
[    1.422961] pci 0000:00:08.0: reg 0x10: [io  0x1458-0x145f]
[    1.422966] pci 0000:00:08.0: reg 0x14: [io  0x144c-0x144f]
[    1.422970] pci 0000:00:08.0: reg 0x18: [io  0x1450-0x1457]
[    1.422975] pci 0000:00:08.0: reg 0x1c: [io  0x1448-0x144b]
[    1.422979] pci 0000:00:08.0: reg 0x20: [io  0x1420-0x142f]
[    1.422984] pci 0000:00:08.0: reg 0x24: [mem 0xd4003000-0xd4003fff]
[    1.423227] pci 0000:00:09.0: [10de:005c] type 01 class 0x060401
[    1.423334] pci 0000:00:09.0: System wakeup disabled by ACPI
[    1.423591] pci 0000:00:0a.0: [10de:0057] type 00 class 0x068000
[    1.423599] pci 0000:00:0a.0: reg 0x10: [mem 0xd4004000-0xd4004fff]
[    1.423604] pci 0000:00:0a.0: reg 0x14: [io  0x1460-0x1467]
[    1.423628] pci 0000:00:0a.0: supports D1 D2
[    1.423647] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.423651] pci_pme_active: pci 0000:00:0a.0: PME# disabled
[    1.423774] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    1.424042] pci 0000:00:0b.0: [10de:005d] type 01 class 0x060400
[    1.424101] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.424106] pci_pme_active: pci 0000:00:0b.0: PME# disabled
[    1.424305] pci 0000:00:0c.0: [10de:005d] type 01 class 0x060400
[    1.424347] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.424368] pci_pme_active: pci 0000:00:0c.0: PME# disabled
[    1.424596] pci 0000:00:0d.0: [10de:005d] type 01 class 0x060400
[    1.424650] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.424653] pci_pme_active: pci 0000:00:0d.0: PME# disabled
[    1.424853] pci 0000:00:0e.0: [10de:005d] type 01 class 0x060400
[    1.424893] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.424913] pci_pme_active: pci 0000:00:0e.0: PME# disabled
[    1.425132] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    1.425144] fixup_debug_start: pci 0000:00:18.0: calling quirk_mmio_always_on+0x0/0x5
[    1.425413] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    1.425418] fixup_debug_start: pci 0000:00:18.1: calling quirk_mmio_always_on+0x0/0x5
[    1.425629] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    1.425633] fixup_debug_start: pci 0000:00:18.2: calling quirk_mmio_always_on+0x0/0x5
[    1.425833] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    1.425838] fixup_debug_start: pci 0000:00:18.3: calling quirk_mmio_always_on+0x0/0x5
[    1.426022] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    1.426026] fixup_debug_start: pci 0000:00:18.4: calling quirk_mmio_always_on+0x0/0x5
[    1.426241] pci 0000:00:19.0: [1022:1200] type 00 class 0x060000
[    1.426245] fixup_debug_start: pci 0000:00:19.0: calling quirk_mmio_always_on+0x0/0x5
[    1.426474] pci 0000:00:19.1: [1022:1201] type 00 class 0x060000
[    1.426478] fixup_debug_start: pci 0000:00:19.1: calling quirk_mmio_always_on+0x0/0x5
[    1.426686] pci 0000:00:19.2: [1022:1202] type 00 class 0x060000
[    1.426691] fixup_debug_start: pci 0000:00:19.2: calling quirk_mmio_always_on+0x0/0x5
[    1.426912] pci 0000:00:19.3: [1022:1203] type 00 class 0x060000
[    1.426916] fixup_debug_start: pci 0000:00:19.3: calling quirk_mmio_always_on+0x0/0x5
[    1.427133] pci 0000:00:19.4: [1022:1204] type 00 class 0x060000
[    1.427137] fixup_debug_start: pci 0000:00:19.4: calling quirk_mmio_always_on+0x0/0x5
[    1.427369] pci 0000:00:1a.0: [1022:1200] type 00 class 0x060000
[    1.427373] fixup_debug_start: pci 0000:00:1a.0: calling quirk_mmio_always_on+0x0/0x5
[    1.427593] pci 0000:00:1a.1: [1022:1201] type 00 class 0x060000
[    1.427597] fixup_debug_start: pci 0000:00:1a.1: calling quirk_mmio_always_on+0x0/0x5
[    1.427770] pci 0000:00:1a.2: [1022:1202] type 00 class 0x060000
[    1.427774] fixup_debug_start: pci 0000:00:1a.2: calling quirk_mmio_always_on+0x0/0x5
[    1.427989] pci 0000:00:1a.3: [1022:1203] type 00 class 0x060000
[    1.427993] fixup_debug_start: pci 0000:00:1a.3: calling quirk_mmio_always_on+0x0/0x5
[    1.428222] pci 0000:00:1a.4: [1022:1204] type 00 class 0x060000
[    1.428226] fixup_debug_start: pci 0000:00:1a.4: calling quirk_mmio_always_on+0x0/0x5
[    1.428438] pci 0000:00:1b.0: [1022:1200] type 00 class 0x060000
[    1.428442] fixup_debug_start: pci 0000:00:1b.0: calling quirk_mmio_always_on+0x0/0x5
[    1.428667] pci 0000:00:1b.1: [1022:1201] type 00 class 0x060000
[    1.428672] fixup_debug_start: pci 0000:00:1b.1: calling quirk_mmio_always_on+0x0/0x5
[    1.428861] pci 0000:00:1b.2: [1022:1202] type 00 class 0x060000
[    1.428866] fixup_debug_start: pci 0000:00:1b.2: calling quirk_mmio_always_on+0x0/0x5
[    1.429071] pci 0000:00:1b.3: [1022:1203] type 00 class 0x060000
[    1.429075] fixup_debug_start: pci 0000:00:1b.3: calling quirk_mmio_always_on+0x0/0x5
[    1.429302] pci 0000:00:1b.4: [1022:1204] type 00 class 0x060000
[    1.429306] fixup_debug_start: pci 0000:00:1b.4: calling quirk_mmio_always_on+0x0/0x5
[    1.429559] pci 0000:00:1c.0: [1022:1200] type 00 class 0x060000
[    1.429564] fixup_debug_start: pci 0000:00:1c.0: calling quirk_mmio_always_on+0x0/0x5
[    1.429799] pci 0000:00:1c.1: [1022:1201] type 00 class 0x060000
[    1.429803] fixup_debug_start: pci 0000:00:1c.1: calling quirk_mmio_always_on+0x0/0x5
[    1.430015] pci 0000:00:1c.2: [1022:1202] type 00 class 0x060000
[    1.430020] fixup_debug_start: pci 0000:00:1c.2: calling quirk_mmio_always_on+0x0/0x5
[    1.430244] pci 0000:00:1c.3: [1022:1203] type 00 class 0x060000
[    1.430248] fixup_debug_start: pci 0000:00:1c.3: calling quirk_mmio_always_on+0x0/0x5
[    1.430477] pci 0000:00:1c.4: [1022:1204] type 00 class 0x060000
[    1.430482] fixup_debug_start: pci 0000:00:1c.4: calling quirk_mmio_always_on+0x0/0x5
[    1.430700] pci 0000:00:1d.0: [1022:1200] type 00 class 0x060000
[    1.430705] fixup_debug_start: pci 0000:00:1d.0: calling quirk_mmio_always_on+0x0/0x5
[    1.430953] pci 0000:00:1d.1: [1022:1201] type 00 class 0x060000
[    1.430957] fixup_debug_start: pci 0000:00:1d.1: calling quirk_mmio_always_on+0x0/0x5
[    1.431133] pci 0000:00:1d.2: [1022:1202] type 00 class 0x060000
[    1.431137] fixup_debug_start: pci 0000:00:1d.2: calling quirk_mmio_always_on+0x0/0x5
[    1.431346] pci 0000:00:1d.3: [1022:1203] type 00 class 0x060000
[    1.431350] fixup_debug_start: pci 0000:00:1d.3: calling quirk_mmio_always_on+0x0/0x5
[    1.431582] pci 0000:00:1d.4: [1022:1204] type 00 class 0x060000
[    1.431586] fixup_debug_start: pci 0000:00:1d.4: calling quirk_mmio_always_on+0x0/0x5
[    1.431771] pci 0000:00:1e.0: [1022:1200] type 00 class 0x060000
[    1.431776] fixup_debug_start: pci 0000:00:1e.0: calling quirk_mmio_always_on+0x0/0x5
[    1.432010] pci 0000:00:1e.1: [1022:1201] type 00 class 0x060000
[    1.432014] fixup_debug_start: pci 0000:00:1e.1: calling quirk_mmio_always_on+0x0/0x5
[    1.432226] pci 0000:00:1e.2: [1022:1202] type 00 class 0x060000
[    1.432230] fixup_debug_start: pci 0000:00:1e.2: calling quirk_mmio_always_on+0x0/0x5
[    1.432446] pci 0000:00:1e.3: [1022:1203] type 00 class 0x060000
[    1.432451] fixup_debug_start: pci 0000:00:1e.3: calling quirk_mmio_always_on+0x0/0x5
[    1.432692] pci 0000:00:1e.4: [1022:1204] type 00 class 0x060000
[    1.432697] fixup_debug_start: pci 0000:00:1e.4: calling quirk_mmio_always_on+0x0/0x5
[    1.432918] pci 0000:00:1f.0: [1022:1200] type 00 class 0x060000
[    1.432923] fixup_debug_start: pci 0000:00:1f.0: calling quirk_mmio_always_on+0x0/0x5
[    1.433149] pci 0000:00:1f.1: [1022:1201] type 00 class 0x060000
[    1.433154] fixup_debug_start: pci 0000:00:1f.1: calling quirk_mmio_always_on+0x0/0x5
[    1.433370] pci 0000:00:1f.2: [1022:1202] type 00 class 0x060000
[    1.433374] fixup_debug_start: pci 0000:00:1f.2: calling quirk_mmio_always_on+0x0/0x5
[    1.433596] pci 0000:00:1f.3: [1022:1203] type 00 class 0x060000
[    1.433601] fixup_debug_start: pci 0000:00:1f.3: calling quirk_mmio_always_on+0x0/0x5
[    1.433822] pci 0000:00:1f.4: [1022:1204] type 00 class 0x060000
[    1.433826] fixup_debug_start: pci 0000:00:1f.4: calling quirk_mmio_always_on+0x0/0x5
[    1.434028] pci_scan_child_bus: pci_bus 0000:00: fixups for bus
[    1.434034] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 01-01] behind bridge, pass 0
[    1.434112] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[    1.434137] pci 0000:01:06.0: [8086:1076] type 00 class 0x020000
[    1.434154] pci 0000:01:06.0: reg 0x10: [mem 0xd4120000-0xd413ffff]
[    1.434168] pci 0000:01:06.0: reg 0x14: [mem 0xd4100000-0xd411ffff]
[    1.434175] pci 0000:01:06.0: reg 0x18: [io  0x2080-0x20bf]
[    1.434197] pci 0000:01:06.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    1.434231] pci 0000:01:06.0: PME# supported from D0 D3hot D3cold
[    1.434240] pci_pme_active: pci 0000:01:06.0: PME# disabled
[    1.434379] pci 0000:01:09.0: [18ca:0020] type 00 class 0x030000
[    1.434400] pci 0000:01:09.0: reg 0x10: [mem 0xd8000000-0xdbffffff pref]
[    1.434414] pci 0000:01:09.0: reg 0x14: [mem 0xd4140000-0xd417ffff]
[    1.434421] pci 0000:01:09.0: reg 0x18: [io  0x2000-0x207f]
[    1.434468] pci 0000:01:09.0: supports D1 D2
[    1.434623] pci_scan_child_bus: pci_bus 0000:01: fixups for bus
[    1.434653] pci 0000:00:09.0: PCI bridge to [bus 01] (subtractive decode)
[    1.434836] pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
[    1.434840] pci 0000:00:09.0:   bridge window [mem 0xd4100000-0xd41fffff]
[    1.434843] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdbffffff pref]
[    1.434846] pci 0000:00:09.0:   bridge window [io  0x0000-0x8fff] (subtractive decode)
[    1.434849] pci 0000:00:09.0:   bridge window [io  0xc000-0xffff] (subtractive decode)
[    1.434856] pci 0000:00:09.0:   bridge window [io  0xa000-0xafff] (subtractive decode)
[    1.434859] pci 0000:00:09.0:   bridge window [mem 0xd0000000-0xdbffffff] (subtractive decode)
[    1.434861] pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.434864] pci 0000:00:09.0:   bridge window [mem 0xdc400000-0xe7ffffff] (subtractive decode)
[    1.434867] pci 0000:00:09.0:   bridge window [mem 0xf0000000-0xffffffff] (subtractive decode)
[    1.434870] pci 0000:00:09.0:   bridge window [mem 0xa30000000-0xfcffffffff] (subtractive decode)
[    1.434873] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=01
[    1.434877] pci_scan_bridge: pci 0000:00:0b.0: scanning [bus 02-02] behind bridge, pass 0
[    1.434976] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[    1.434980] pci_scan_child_bus: pci_bus 0000:02: fixups for bus
[    1.434983] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    1.435125] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[    1.435138] pci_scan_bridge: pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 0
[    1.435231] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[    1.435234] pci_scan_child_bus: pci_bus 0000:03: fixups for bus
[    1.435237] pci 0000:00:0c.0: PCI bridge to [bus 03]
[    1.435381] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[    1.435394] pci_scan_bridge: pci 0000:00:0d.0: scanning [bus 05-05] behind bridge, pass 0
[    1.435495] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[    1.435499] pci_scan_child_bus: pci_bus 0000:05: fixups for bus
[    1.435501] pci 0000:00:0d.0: PCI bridge to [bus 05]
[    1.435653] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[    1.435664] pci_scan_bridge: pci 0000:00:0e.0: scanning [bus 0a-0a] behind bridge, pass 0
[    1.435666] pci 0000:00:0e.0: bridge configuration invalid ([bus 0a-0a]), reconfiguring
[    1.435836] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 01-01] behind bridge, pass 1
[    1.435855] pci_scan_bridge: pci 0000:00:0b.0: scanning [bus 02-02] behind bridge, pass 1
[    1.435864] pci_scan_bridge: pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 1
[    1.435868] pci_scan_bridge: pci 0000:00:0d.0: scanning [bus 05-05] behind bridge, pass 1
[    1.435872] pci_scan_bridge: pci 0000:00:0e.0: scanning [bus 00-00] behind bridge, pass 1
[    1.435974] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[    1.435978] pci_scan_child_bus: pci_bus 0000:06: fixups for bus
[    1.435981] pci 0000:00:0e.0: PCI bridge to [bus 06-07]
[    1.436137] pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
[    1.436147] pci 0000:00:0e.0:   bridge window [mem 0xd4200000-0xd42fffff]
[    1.436164] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[    1.436175] pci_bus 0000:06: busn_res: [bus 06-07] end is updated to 06
[    1.436179] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=06
[    1.437102] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    1.437668] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
[    1.438181] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
[    1.438691] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0, disabled.
[    1.439239] ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
[    1.439764] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0, disabled.
[    1.440298] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
[    1.440800] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0
[    1.441292] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0
[    1.441802] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
[    1.442339] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
[    1.442880] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
[    1.443416] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
[    1.443927] ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0, disabled.
[    1.444465] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    1.445190] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-ff])
[    1.445345] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.445510] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.446111] acpi PNP0A03:01: host bridge window [io  0xb000-0xffff] (ignored)
[    1.446114] acpi PNP0A03:01: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.446116] acpi PNP0A03:01: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
[    1.446119] acpi PNP0A03:01: host bridge window [mem 0xdc000000-0xdc3fffff] (ignored)
[    1.446122] PCI: root bus 80: hardware-probed resources
[    1.446224] PCI host bridge to bus 0000:80
[    1.446380] pci_bus 0000:80: root bus resource [bus 80-ff]
[    1.446530] pci_bus 0000:80: root bus resource [io  0xb000-0xbfff]
[    1.446685] pci_bus 0000:80: root bus resource [io  0x9000-0x9fff]
[    1.446826] pci_bus 0000:80: root bus resource [mem 0xdc000000-0xdc3fffff]
[    1.446978] pci_bus 0000:80: root bus resource [mem 0xe8000000-0xefffffff]
[    1.447142] pci_scan_child_bus: pci_bus 0000:80: scanning bus
[    1.447163] pci 0000:80:00.0: [10de:005e] type 00 class 0x058000
[    1.447404] pci 0000:80:01.0: [10de:00d3] type 00 class 0x058000
[    1.447604] pci 0000:80:07.0: [10de:0054] type 00 class 0x010185
[    1.447621] pci 0000:80:07.0: reg 0x10: [io  0xb030-0xb037]
[    1.447626] pci 0000:80:07.0: reg 0x14: [io  0xb024-0xb027]
[    1.447632] pci 0000:80:07.0: reg 0x18: [io  0xb028-0xb02f]
[    1.447641] pci 0000:80:07.0: reg 0x1c: [io  0xb020-0xb023]
[    1.447646] pci 0000:80:07.0: reg 0x20: [io  0xb000-0xb00f]
[    1.447651] pci 0000:80:07.0: reg 0x24: [mem 0xdc000000-0xdc000fff]
[    1.447843] pci 0000:80:08.0: [10de:0055] type 00 class 0x010185
[    1.447860] pci 0000:80:08.0: reg 0x10: [io  0xb048-0xb04f]
[    1.447865] pci 0000:80:08.0: reg 0x14: [io  0xb03c-0xb03f]
[    1.447881] pci 0000:80:08.0: reg 0x18: [io  0xb040-0xb047]
[    1.447886] pci 0000:80:08.0: reg 0x1c: [io  0xb038-0xb03b]
[    1.447891] pci 0000:80:08.0: reg 0x20: [io  0xb010-0xb01f]
[    1.447896] pci 0000:80:08.0: reg 0x24: [mem 0xdc001000-0xdc001fff]
[    1.448083] pci 0000:80:0a.0: [10de:0057] type 00 class 0x068000
[    1.448094] pci 0000:80:0a.0: reg 0x10: [mem 0xdc002000-0xdc002fff]
[    1.448118] pci 0000:80:0a.0: reg 0x14: [io  0xb050-0xb057]
[    1.448146] pci 0000:80:0a.0: supports D1 D2
[    1.448165] pci 0000:80:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.448175] pci_pme_active: pci 0000:80:0a.0: PME# disabled
[    1.448227] pci 0000:80:0a.0: System wakeup disabled by ACPI
[    1.448495] pci 0000:80:0b.0: [10de:005d] type 01 class 0x060400
[    1.448561] pci 0000:80:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.448574] pci_pme_active: pci 0000:80:0b.0: PME# disabled
[    1.448765] pci 0000:80:0c.0: [10de:005d] type 01 class 0x060400
[    1.448809] pci 0000:80:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.448819] pci_pme_active: pci 0000:80:0c.0: PME# disabled
[    1.448977] pci 0000:80:0d.0: [10de:005d] type 01 class 0x060400
[    1.449031] pci 0000:80:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.449034] pci_pme_active: pci 0000:80:0d.0: PME# disabled
[    1.449184] pci 0000:80:0e.0: [10de:005d] type 01 class 0x060400
[    1.449237] pci 0000:80:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.449240] pci_pme_active: pci 0000:80:0e.0: PME# disabled
[    1.449404] pci_scan_child_bus: pci_bus 0000:80: fixups for bus
[    1.449408] pci_scan_bridge: pci 0000:80:0b.0: scanning [bus 81-85] behind bridge, pass 0
[    1.449522] pci_scan_child_bus: pci_bus 0000:81: scanning bus
[    1.449526] pci_scan_child_bus: pci_bus 0000:81: fixups for bus
[    1.449529] pci 0000:80:0b.0: PCI bridge to [bus 81-85]
[    1.449681] pci_scan_child_bus: pci_bus 0000:81: bus scan returning with max=81
[    1.449704] pci_scan_bridge: pci 0000:80:0c.0: scanning [bus 86-8a] behind bridge, pass 0
[    1.449836] pci_scan_child_bus: pci_bus 0000:86: scanning bus
[    1.449841] pci_scan_child_bus: pci_bus 0000:86: fixups for bus
[    1.449843] pci 0000:80:0c.0: PCI bridge to [bus 86-8a]
[    1.450000] pci_scan_child_bus: pci_bus 0000:86: bus scan returning with max=86
[    1.450004] pci_scan_bridge: pci 0000:80:0d.0: scanning [bus 8b-8f] behind bridge, pass 0
[    1.450114] pci_scan_child_bus: pci_bus 0000:8b: scanning bus
[    1.450118] pci_scan_child_bus: pci_bus 0000:8b: fixups for bus
[    1.450120] pci 0000:80:0d.0: PCI bridge to [bus 8b-8f]
[    1.450264] pci_scan_child_bus: pci_bus 0000:8b: bus scan returning with max=8b
[    1.450281] pci_scan_bridge: pci 0000:80:0e.0: scanning [bus 90-94] behind bridge, pass 0
[    1.450401] pci_scan_child_bus: pci_bus 0000:90: scanning bus
[    1.450405] pci_scan_child_bus: pci_bus 0000:90: fixups for bus
[    1.450407] pci 0000:80:0e.0: PCI bridge to [bus 90-94]
[    1.450556] pci_scan_child_bus: pci_bus 0000:90: bus scan returning with max=90
[    1.450570] pci_scan_bridge: pci 0000:80:0b.0: scanning [bus 81-85] behind bridge, pass 1
[    1.450574] pci_scan_bridge: pci 0000:80:0c.0: scanning [bus 86-8a] behind bridge, pass 1
[    1.450578] pci_scan_bridge: pci 0000:80:0d.0: scanning [bus 8b-8f] behind bridge, pass 1
[    1.450583] pci_scan_bridge: pci 0000:80:0e.0: scanning [bus 90-94] behind bridge, pass 1
[    1.450586] pci_scan_child_bus: pci_bus 0000:80: bus scan returning with max=94
[    1.451206] vgaarb: device added: PCI:0000:01:09.0,decodes=io+mem,owns=io+mem,locks=none
[    1.451362] vgaarb: loaded
[    1.451509] vgaarb: bridge control possible 0000:01:09.0
[    1.452457] SCSI subsystem initialized
[    1.452940] libata version 3.00 loaded.
[    1.452956] ACPI: bus type USB registered
[    1.453255] usbcore: registered new interface driver usbfs
[    1.453478] usbcore: registered new interface driver hub
[    1.453722] usbcore: registered new device driver usb
[    1.454050] PCI: Using ACPI for IRQ routing
[    1.454203] PCI: pci_cache_line_size set to 64 bytes
[    1.454341] Expanded resource reserved due to conflict with PCI Bus #00
[    1.454498] e820: reserve RAM buffer [mem 0x00099800-0x0009ffff]
[    1.454502] e820: reserve RAM buffer [mem 0x7ffe0000-0x7fffffff]
[    1.454505] e820: reserve RAM buffer [mem 0xcfc00000-0xcfffffff]
[    1.455358] Switched to clocksource refined-jiffies
[    1.463231] pnp: PnP ACPI init
[    1.463459] ACPI: bus type PNP registered
[    1.464153] system 00:00: [mem 0xff800000-0xffffffff] could not be reserved
[    1.464340] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.464503] system 00:00: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.464661] system 00:00: [mem 0xfefff000-0xfeffffff] has been reserved
[    1.464810] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.465428] pnp 00:01: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.465939] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.466394] pnp 00:03: [dma 2]
[    1.466513] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.467054] pnp 00:04: [dma 1]
[    1.467301] pnp 00:04: Plug and Play ACPI device, IDs PNP0401 (active)
[    1.467443] pnp 00:05: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.467565] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.468052] system 00:07: [io  0x8000-0x807f] could not be reserved
[    1.468208] system 00:07: [io  0x8080-0x80ff] has been reserved
[    1.468350] system 00:07: [io  0x8400-0x847f] has been reserved
[    1.468509] system 00:07: [io  0x8480-0x84ff] has been reserved
[    1.468653] system 00:07: [io  0x8800-0x887f] has been reserved
[    1.468803] system 00:07: [io  0x8880-0x88ff] has been reserved
[    1.468955] system 00:07: [io  0xa000-0xa03f] has been reserved
[    1.469105] system 00:07: [io  0xa040-0xa07f] has been reserved
[    1.469246] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.469290] pnp 00:08: disabling [io  0x0010-0x001f] because it overlaps 0000:00:01.1 BAR 0 [io  0x0000-0x001f]
[    1.469726] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    1.469869] system 00:08: [io  0x0400-0x045e] has been reserved
[    1.470019] system 00:08: [io  0x9000-0x907f] has been reserved
[    1.470169] system 00:08: [io  0x9080-0x90ff] has been reserved
[    1.470320] system 00:08: [io  0x9200-0x927f] has been reserved
[    1.470471] system 00:08: [io  0x9280-0x92ff] has been reserved
[    1.470621] system 00:08: [io  0x9400-0x947f] has been reserved
[    1.470772] system 00:08: [io  0x9480-0x94ff] has been reserved
[    1.470913] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.470953] pnp 00:09: [dma 4]
[    1.471035] pnp 00:09: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.471137] pnp 00:0a: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.471257] pnp 00:0b: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.471359] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.471922] pnp: PnP ACPI: found 13 devices
[    1.472088] ACPI: bus type PNP unregistered
[    1.483364] Switched to clocksource acpi_pm
[    1.483600] pci 0000:00:01.1: BAR 0: assigned [io  0x1000-0x101f]
[    1.483795] pci_update_resource: pci 0000:00:01.1: BAR 0: set to [io  0x1000-0x101f] (PCI address [0x1000-0x101f])
[    1.483804] pci 0000:01:06.0: BAR 6: assigned [mem 0xd4180000-0xd419ffff pref]
[    1.483967] pci 0000:00:09.0: PCI bridge to [bus 01]
[    1.484117] pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
[    1.484271] pci 0000:00:09.0:   bridge window [mem 0xd4100000-0xd41fffff]
[    1.484426] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdbffffff pref]
[    1.484582] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    1.484735] pci 0000:00:0c.0: PCI bridge to [bus 03]
[    1.484929] pci 0000:00:0d.0: PCI bridge to [bus 05]
[    1.488514] pci 0000:00:0e.0: PCI bridge to [bus 06]
[    1.488666] pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
[    1.488816] pci 0000:00:0e.0:   bridge window [mem 0xd4200000-0xd42fffff]
[    1.488973] pci_bus 0000:00: resource 4 [io  0x0000-0x8fff]
[    1.488976] pci_bus 0000:00: resource 5 [io  0xc000-0xffff]
[    1.488978] pci_bus 0000:00: resource 6 [io  0xa000-0xafff]
[    1.488981] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xdbffffff]
[    1.488984] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    1.488986] pci_bus 0000:00: resource 9 [mem 0xdc400000-0xe7ffffff]
[    1.488989] pci_bus 0000:00: resource 10 [mem 0xf0000000-0xffffffff]
[    1.488991] pci_bus 0000:00: resource 11 [mem 0xa30000000-0xfcffffffff]
[    1.488994] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    1.488997] pci_bus 0000:01: resource 1 [mem 0xd4100000-0xd41fffff]
[    1.489000] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdbffffff pref]
[    1.489002] pci_bus 0000:01: resource 4 [io  0x0000-0x8fff]
[    1.489004] pci_bus 0000:01: resource 5 [io  0xc000-0xffff]
[    1.489007] pci_bus 0000:01: resource 6 [io  0xa000-0xafff]
[    1.489009] pci_bus 0000:01: resource 7 [mem 0xd0000000-0xdbffffff]
[    1.489012] pci_bus 0000:01: resource 8 [mem 0x000a0000-0x000bffff]
[    1.489014] pci_bus 0000:01: resource 9 [mem 0xdc400000-0xe7ffffff]
[    1.489017] pci_bus 0000:01: resource 10 [mem 0xf0000000-0xffffffff]
[    1.489019] pci_bus 0000:01: resource 11 [mem 0xa30000000-0xfcffffffff]
[    1.489023] pci_bus 0000:06: resource 0 [io  0x3000-0x3fff]
[    1.489025] pci_bus 0000:06: resource 1 [mem 0xd4200000-0xd42fffff]
[    1.489042] pci 0000:80:0b.0: PCI bridge to [bus 81-85]
[    1.489199] pci 0000:80:0c.0: PCI bridge to [bus 86-8a]
[    1.489357] pci 0000:80:0d.0: PCI bridge to [bus 8b-8f]
[    1.489510] pci 0000:80:0e.0: PCI bridge to [bus 90-94]
[    1.489665] pci_bus 0000:80: resource 4 [io  0xb000-0xbfff]
[    1.489668] pci_bus 0000:80: resource 5 [io  0x9000-0x9fff]
[    1.489670] pci_bus 0000:80: resource 6 [mem 0xdc000000-0xdc3fffff]
[    1.489673] pci_bus 0000:80: resource 7 [mem 0xe8000000-0xefffffff]
[    1.490241] NET: Registered protocol family 2
[    1.491703] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    1.494949] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.496028] TCP: Hash tables configured (established 524288 bind 65536)
[    1.496301] TCP: reno registered
[    1.496613] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.497753] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.499257] NET: Registered protocol family 1
[    1.500195] RPC: Registered named UNIX socket transport module.
[    1.500348] RPC: Registered udp transport module.
[    1.500505] RPC: Registered tcp transport module.
[    1.500652] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.500830] fixup_debug_start: pci 0000:00:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.500856] fixup_debug_start: pci 0000:00:01.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.500864] fixup_debug_start: pci 0000:00:01.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.500873] fixup_debug_start: pci 0000:00:02.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.500885] fixup_debug_start: pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x64d
[    1.501341] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 23
[    1.759812] fixup_debug_start: pci 0000:00:02.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.759820] fixup_debug_start: pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x64d
[    1.760057] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
[    1.760291] fixup_debug_start: pci 0000:00:06.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.760300] fixup_debug_start: pci 0000:00:07.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.760309] fixup_debug_start: pci 0000:00:08.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.760318] fixup_debug_start: pci 0000:00:09.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.760325] fixup_debug_start: pci 0000:00:0a.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.760334] fixup_debug_start: pci 0000:00:0b.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.760398] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.760567] fixup_debug_start: pci 0000:00:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.760572] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    1.760729] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.760879] fixup_debug_start: pci 0000:00:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.760886] fixup_debug_start: pci 0000:00:0c.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.760939] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.761094] fixup_debug_start: pci 0000:00:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.761099] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    1.761241] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.761392] fixup_debug_start: pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.761407] fixup_debug_start: pci 0000:00:0d.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.761463] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.761615] fixup_debug_start: pci 0000:00:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.761619] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    1.761768] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.761926] fixup_debug_start: pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.761933] fixup_debug_start: pci 0000:00:0e.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.761974] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.762127] fixup_debug_start: pci 0000:00:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.762132] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    1.762286] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.762435] fixup_debug_start: pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.762445] fixup_debug_start: pci 0000:00:18.0: calling quirk_amd_nb_node+0x0/0x65
[    1.762454] fixup_debug_start: pci 0000:00:18.1: calling quirk_amd_nb_node+0x0/0x65
[    1.762461] fixup_debug_start: pci 0000:00:18.2: calling quirk_amd_nb_node+0x0/0x65
[    1.762468] fixup_debug_start: pci 0000:00:18.3: calling quirk_amd_nb_node+0x0/0x65
[    1.762475] fixup_debug_start: pci 0000:00:18.4: calling quirk_amd_nb_node+0x0/0x65
[    1.762482] fixup_debug_start: pci 0000:00:19.0: calling quirk_amd_nb_node+0x0/0x65
[    1.762489] fixup_debug_start: pci 0000:00:19.1: calling quirk_amd_nb_node+0x0/0x65
[    1.762497] fixup_debug_start: pci 0000:00:19.2: calling quirk_amd_nb_node+0x0/0x65
[    1.762504] fixup_debug_start: pci 0000:00:19.3: calling quirk_amd_nb_node+0x0/0x65
[    1.762511] fixup_debug_start: pci 0000:00:19.4: calling quirk_amd_nb_node+0x0/0x65
[    1.762518] fixup_debug_start: pci 0000:00:1a.0: calling quirk_amd_nb_node+0x0/0x65
[    1.762525] fixup_debug_start: pci 0000:00:1a.1: calling quirk_amd_nb_node+0x0/0x65
[    1.762533] fixup_debug_start: pci 0000:00:1a.2: calling quirk_amd_nb_node+0x0/0x65
[    1.762540] fixup_debug_start: pci 0000:00:1a.3: calling quirk_amd_nb_node+0x0/0x65
[    1.762547] fixup_debug_start: pci 0000:00:1a.4: calling quirk_amd_nb_node+0x0/0x65
[    1.762554] fixup_debug_start: pci 0000:00:1b.0: calling quirk_amd_nb_node+0x0/0x65
[    1.762562] fixup_debug_start: pci 0000:00:1b.1: calling quirk_amd_nb_node+0x0/0x65
[    1.762569] fixup_debug_start: pci 0000:00:1b.2: calling quirk_amd_nb_node+0x0/0x65
[    1.762577] fixup_debug_start: pci 0000:00:1b.3: calling quirk_amd_nb_node+0x0/0x65
[    1.762584] fixup_debug_start: pci 0000:00:1b.4: calling quirk_amd_nb_node+0x0/0x65
[    1.762591] fixup_debug_start: pci 0000:00:1c.0: calling quirk_amd_nb_node+0x0/0x65
[    1.762599] fixup_debug_start: pci 0000:00:1c.1: calling quirk_amd_nb_node+0x0/0x65
[    1.762606] fixup_debug_start: pci 0000:00:1c.2: calling quirk_amd_nb_node+0x0/0x65
[    1.762614] fixup_debug_start: pci 0000:00:1c.3: calling quirk_amd_nb_node+0x0/0x65
[    1.762621] fixup_debug_start: pci 0000:00:1c.4: calling quirk_amd_nb_node+0x0/0x65
[    1.762628] fixup_debug_start: pci 0000:00:1d.0: calling quirk_amd_nb_node+0x0/0x65
[    1.762636] fixup_debug_start: pci 0000:00:1d.1: calling quirk_amd_nb_node+0x0/0x65
[    1.762644] fixup_debug_start: pci 0000:00:1d.2: calling quirk_amd_nb_node+0x0/0x65
[    1.762651] fixup_debug_start: pci 0000:00:1d.3: calling quirk_amd_nb_node+0x0/0x65
[    1.762658] fixup_debug_start: pci 0000:00:1d.4: calling quirk_amd_nb_node+0x0/0x65
[    1.762666] fixup_debug_start: pci 0000:00:1e.0: calling quirk_amd_nb_node+0x0/0x65
[    1.762674] fixup_debug_start: pci 0000:00:1e.1: calling quirk_amd_nb_node+0x0/0x65
[    1.762681] fixup_debug_start: pci 0000:00:1e.2: calling quirk_amd_nb_node+0x0/0x65
[    1.762689] fixup_debug_start: pci 0000:00:1e.3: calling quirk_amd_nb_node+0x0/0x65
[    1.762696] fixup_debug_start: pci 0000:00:1e.4: calling quirk_amd_nb_node+0x0/0x65
[    1.762704] fixup_debug_start: pci 0000:00:1f.0: calling quirk_amd_nb_node+0x0/0x65
[    1.762712] fixup_debug_start: pci 0000:00:1f.1: calling quirk_amd_nb_node+0x0/0x65
[    1.762719] fixup_debug_start: pci 0000:00:1f.2: calling quirk_amd_nb_node+0x0/0x65
[    1.762727] fixup_debug_start: pci 0000:00:1f.3: calling quirk_amd_nb_node+0x0/0x65
[    1.762735] fixup_debug_start: pci 0000:00:1f.4: calling quirk_amd_nb_node+0x0/0x65
[    1.762744] fixup_debug_start: pci 0000:01:06.0: calling quirk_e100_interrupt+0x0/0x143
[    1.762757] fixup_debug_start: pci 0000:01:09.0: calling pci_fixup_video+0x0/0xa6
[    1.762762] pci 0000:01:09.0: Boot video device
[    1.762769] fixup_debug_start: pci 0000:80:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.762798] fixup_debug_start: pci 0000:80:01.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.762806] fixup_debug_start: pci 0000:80:07.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.762815] fixup_debug_start: pci 0000:80:08.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.762823] fixup_debug_start: pci 0000:80:0a.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.762833] fixup_debug_start: pci 0000:80:0b.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.762877] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.763038] fixup_debug_start: pci 0000:80:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.763044] pci 0000:80:0b.0: Found disabled HT MSI Mapping
[    1.763206] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.763346] fixup_debug_start: pci 0000:80:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.763361] fixup_debug_start: pci 0000:80:0c.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.763403] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.763556] fixup_debug_start: pci 0000:80:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.763561] pci 0000:80:0c.0: Found disabled HT MSI Mapping
[    1.763878] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.764036] fixup_debug_start: pci 0000:80:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.764043] fixup_debug_start: pci 0000:80:0d.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.764089] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.764251] fixup_debug_start: pci 0000:80:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.764260] pci 0000:80:0d.0: Found disabled HT MSI Mapping
[    1.764408] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.764567] fixup_debug_start: pci 0000:80:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.764574] fixup_debug_start: pci 0000:80:0e.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.764634] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.764787] fixup_debug_start: pci 0000:80:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.764792] pci 0000:80:0e.0: Found disabled HT MSI Mapping
[    1.764940] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.765099] fixup_debug_start: pci 0000:80:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.765102] PCI: CLS 64 bytes, default 64
[    1.768072] PCI-DMA: Disabling AGP.
[    1.769543] PCI-DMA: aperture base @ d0000000 size 65536 KB
[    1.769695] init_memory_mapping: [mem 0xd0000000-0xd3ffffff]
[    1.769846]  [mem 0xd0000000-0xd3ffffff] page 2M
[    1.769863] PCI-DMA: using GART IOMMU.
[    1.770013] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.778973] Simple Boot Flag at 0x37 set to 0x80
[    1.782178] LVT offset 1 assigned for vector 0x400
[    1.782408] IBS: LVT offset 1 assigned
[    1.782678] perf: AMD IBS detected (0x00000007)
[    1.793063] futex hash table entries: 8192 (order: 7, 524288 bytes)
[    1.831346] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.835946] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.836389] msgmni has been set to 32768
[    1.837108] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.837299] io scheduler noop registered
[    1.837457] io scheduler deadline registered
[    1.837801] io scheduler cfq registered (default)
[    1.838329] __pci_set_master: pcieport 0000:00:0b.0: enabling bus mastering
[    1.838373] pcieport 0000:00:0b.0: irq 40 for MSI/MSI-X
[    1.838583] __pci_set_master: pcieport 0000:00:0c.0: enabling bus mastering
[    1.838642] pcieport 0000:00:0c.0: irq 41 for MSI/MSI-X
[    1.838887] pcieport 0000:00:0d.0: irq 42 for MSI/MSI-X
[    1.839039] pcieport 0000:00:0e.0: irq 43 for MSI/MSI-X
[    1.839232] __pci_set_master: pcieport 0000:80:0b.0: enabling bus mastering
[    1.839285] pcieport 0000:80:0b.0: irq 44 for MSI/MSI-X
[    1.839464] __pci_set_master: pcieport 0000:80:0c.0: enabling bus mastering
[    1.839477] pcieport 0000:80:0c.0: irq 45 for MSI/MSI-X
[    1.839626] pcieport 0000:80:0d.0: irq 46 for MSI/MSI-X
[    1.839957] pcieport 0000:80:0e.0: irq 47 for MSI/MSI-X
[    1.840666] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.840896] ACPI: Power Button [PWRB]
[    1.841281] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.841464] ACPI: Power Button [PWRF]
[    1.841858] ACPI: acpi_idle registered with cpuidle
[    1.887878] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.908472] 00:01: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.929077] 00:02: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    1.930870] Linux agpgart interface v0.103
[    1.932649] Floppy drive(s): fd0 is 1.44M
[    1.936553] brd: module loaded
[    1.938905] loop: module loaded
[    1.940168] sata_nv 0000:00:07.0: version 3.5
[    1.940704] ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
[    1.941961] scsi0 : sata_nv
[    1.942628] scsi1 : sata_nv
[    1.942944] ata1: SATA max UDMA/133 cmd 0x1440 ctl 0x1434 bmdma 0x1410 irq 21
[    1.943099] ata2: SATA max UDMA/133 cmd 0x1438 ctl 0x1430 bmdma 0x1418 irq 21
[    1.943593] ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 20
[    1.944813] scsi2 : sata_nv
[    1.945217] scsi3 : sata_nv
[    1.945527] ata3: SATA max UDMA/133 cmd 0x1458 ctl 0x144c bmdma 0x1420 irq 20
[    1.945679] ata4: SATA max UDMA/133 cmd 0x1450 ctl 0x1448 bmdma 0x1428 irq 20
[    1.946217] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 19
[    1.947263] scsi4 : sata_nv
[    1.947667] scsi5 : sata_nv
[    1.948143] ata5: SATA max UDMA/133 cmd 0xb030 ctl 0xb024 bmdma 0xb000 irq 19
[    1.948316] ata6: SATA max UDMA/133 cmd 0xb028 ctl 0xb020 bmdma 0xb008 irq 19
[    1.948704] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 18
[    1.949591] scsi6 : sata_nv
[    1.949988] scsi7 : sata_nv
[    1.950277] ata7: SATA max UDMA/133 cmd 0xb048 ctl 0xb03c bmdma 0xb010 irq 18
[    1.950659] ata8: SATA max UDMA/133 cmd 0xb040 ctl 0xb038 bmdma 0xb018 irq 18
[    1.951363] pata_amd 0000:00:06.0: version 0.4.1
[    1.951989] FDC 0 is a post-1991 82077
[    1.953880] scsi8 : pata_amd
[    1.954357] scsi9 : pata_amd
[    1.954725] ata9: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1400 irq 14
[    1.954882] ata10: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x1408 irq 15
[    1.955321] tun: Universal TUN/TAP device driver, 1.6
[    1.955470] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.956166] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.956342] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.408436] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.412428] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.416423] ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.416568] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.417071] ata1.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.417289] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.421002] ata3.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.421163] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.424998] ata5.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.425004] ata7.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.425007] ata7.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.425499] ata5.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.433001] ata1.00: configured for UDMA/133
[    2.433481] scsi 0:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    2.434060] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.434466] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.434488] sd 0:0:0:0: [sda] Write Protect is off
[    2.434491] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.434565] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.437006] ata3.00: configured for UDMA/133
[    2.438943] e1000 0000:01:06.0 eth0: (PCI:33MHz:32-bit) 00:e0:81:b0:4d:69
[    2.439124] e1000 0000:01:06.0 eth0: Intel(R) PRO/1000 Network Connection
[    2.439388] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    2.439881] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
[    2.440806]  sda: sda1 sda2 sda3
[    2.440916] ata5.00: configured for UDMA/133
[    2.440920] ata7.00: configured for UDMA/133
[    2.442034] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.776790] tsc: Refined TSC clocksource calibration: 1908.795 MHz
[    2.900915] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.909433] ata2.00: ATA-6: ST31000340NS, SN04, max UDMA/133
[    2.909585] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.925445] ata2.00: configured for UDMA/133
[    2.925757] scsi 1:0:0:0: Direct-Access     ATA      ST31000340NS     SN04 PQ: 0 ANSI: 5
[    2.926313] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.926438] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.926703] scsi 2:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    2.926777] sd 1:0:0:0: [sdb] Write Protect is off
[    2.926781] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.926843] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.927570] sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.927696] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    2.928032] sd 2:0:0:0: [sdc] Write Protect is off
[    2.928206] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.928262] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.943758]  sdc: unknown partition table
[    2.944379] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.946060]  sdb: unknown partition table
[    2.946514] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.965721] forcedeth 0000:00:0a.0: ifname eth1, PHY OUI 0x5043 @ 1, addr 00:e0:81:b0:4d:67
[    2.965906] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[    2.966343] ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 17
[    3.393413] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.401967] ata4.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    3.402118] ata4.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.417983] ata4.00: configured for UDMA/133
[    3.418284] scsi 3:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.418743] sd 3:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.418889] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    3.419083] sd 3:0:0:0: [sdd] Write Protect is off
[    3.419225] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    3.419251] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.419306] scsi 4:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.419804] sd 4:0:0:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.420045] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    3.420177] sd 4:0:0:0: [sde] Write Protect is off
[    3.420180] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    3.420248] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.433998]  sdd: unknown partition table
[    3.434423] sd 3:0:0:0: [sdd] Attached SCSI disk
[    3.434470]  sde: sde1 sde2 sde3
[    3.435289] sd 4:0:0:0: [sde] Attached SCSI disk
[    3.490038] forcedeth 0000:80:0a.0: ifname eth2, PHY OUI 0x5043 @ 1, addr 00:e0:81:b0:4d:68
[    3.490281] forcedeth 0000:80:0a.0: highdma csum gbit lnktim desc-v3
[    3.491055] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.491290] ehci-pci: EHCI PCI platform driver
[    3.491623] __pci_set_master: ehci-pci 0000:00:02.1: enabling bus mastering
[    3.491670] ehci-pci 0000:00:02.1: EHCI Host Controller
[    3.491972] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus number 1
[    3.495509] ehci-pci 0000:00:02.1: debug port 1
[    3.495701] ehci-pci 0000:00:02.1: cache line size of 64 is not supported
[    3.495731] ehci-pci 0000:00:02.1: irq 22, io mem 0xd4001000
[    3.505514] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    3.505987] hub 1-0:1.0: USB hub found
[    3.506169] hub 1-0:1.0: 10 ports detected
[    3.506640] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.506853] ohci-pci: OHCI PCI platform driver
[    3.507097] __pci_set_master: ohci-pci 0000:00:02.0: enabling bus mastering
[    3.507102] ohci-pci 0000:00:02.0: OHCI PCI host controller
[    3.507424] ohci-pci 0000:00:02.0: new USB bus registered, assigned bus number 2
[    3.507621] ohci-pci 0000:00:02.0: irq 23, io mem 0xd4000000
[    3.563849] hub 2-0:1.0: USB hub found
[    3.564004] hub 2-0:1.0: 10 ports detected
[    3.564467] uhci_hcd: USB Universal Host Controller Interface driver
[    3.564988] usbcore: registered new interface driver usblp
[    3.565246] usbcore: registered new interface driver usb-storage
[    3.565783] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.568672] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.568868] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.569376] mousedev: PS/2 mouse device common for all mice
[    3.570779] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    3.572240] usbcore: registered new interface driver usbhid
[    3.572418] usbhid: USB HID core driver
[    3.572680] oprofile: AMD IBS detected (0x00000007)
[    3.572839] oprofile: using NMI interrupt.
[    3.573024] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.574030] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.574301] arp_tables: (C) 2002 David S. Miller
[    3.574464] TCP: cubic registered
[    3.574640] NET: Registered protocol family 17
[    3.579326] registered taskstats version 1
[    3.580476] console [netcon0] enabled
[    3.580646] netconsole: network logging started
[    3.581256] acpi-cpufreq: overriding BIOS provided _PSD data
[    3.632353] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.777986] Switched to clocksource tsc
[    3.885762] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.894330] ata6.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    3.894506] ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.910339] ata6.00: configured for UDMA/133
[    3.910674] scsi 5:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.911182] sd 5:0:0:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.911334] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    3.911532] sd 5:0:0:0: [sdf] Write Protect is off
[    3.911577] scsi 6:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.911837] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    3.911858] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.911925] sd 6:0:0:0: [sdg] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.912083] sd 6:0:0:0: Attached scsi generic sg6 type 0
[    3.912096] sd 6:0:0:0: [sdg] Write Protect is off
[    3.912099] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    3.912150] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.925601]  sdg: unknown partition table
[    3.926215] sd 6:0:0:0: [sdg] Attached SCSI disk
[    3.929711]  sdf: sdf1 sdf2 sdf3
[    3.930615] sd 5:0:0:0: [sdf] Attached SCSI disk
[    4.194076] usb 2-1: new low-speed USB device number 2 using ohci-pci
[    4.200158] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input4
[    4.378249] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.402554] ata8.00: ATA-7: Hitachi HUA721010KLA330, GKAOA70M, max UDMA/133
[    4.402718] ata8.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.418550] ata8.00: configured for UDMA/133
[    4.418851] scsi 7:0:0:0: Direct-Access     ATA      Hitachi HUA72101 GKAO PQ: 0 ANSI: 5
[    4.419392] sd 7:0:0:0: [sdh] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    4.419529] sd 7:0:0:0: Attached scsi generic sg7 type 0
[    4.419821] sd 7:0:0:0: [sdh] Write Protect is off
[    4.420005] sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    4.420057] sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.440324]  sdh: unknown partition table
[    4.440835] sd 7:0:0:0: [sdh] Attached SCSI disk
[    4.606770] ata10.00: ATAPI: TEAC DV-516GB, HT13, max UDMA/33
[    4.606961] ata10: nv_mode_filter: 0x739f&0x739f->0x739f, BIOS=0x7000 (0xc000) ACPI=0x701f (60:600:0x13)
[    4.646718] ata10.00: configured for UDMA/33
[    4.648815] scsi 9:0:0:0: CD-ROM            TEAC     DV-516GB         HT13 PQ: 0 ANSI: 5
[    4.655768] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    4.655948] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.656353] sr 9:0:0:0: Attached scsi CD-ROM sr0
[    4.656552] sr 9:0:0:0: Attached scsi generic sg8 type 5
[    4.660278] EXT3-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    4.661280] EXT2-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    4.689887] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    4.690080] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    4.706980] devtmpfs: mounted
[    4.708192] Freeing unused kernel memory: 932K (ffffffff8175a000 - ffffffff81843000)
[    5.507783] random: nonblocking pool is initialized
[    5.893932] hid-generic 0003:051D:0002.0001: device has no listeners, quitting
[    6.385298] systemd-udevd[1975]: starting version 216
[    6.800777] systemd-udevd[2007]: renamed network interface eth1 to enp0s10
[    6.848808] systemd-udevd[2034]: renamed network interface eth2 to enp128s10
[    6.880867] systemd-udevd[1994]: renamed network interface eth0 to enp1s6
[    7.251681] kvm: Nested Virtualization enabled
[    7.251702] kvm: Nested Paging enabled
[    7.843107] EXT4-fs (sda2): re-mounted. Opts: (null)
[    9.855736] end_request: I/O error, dev fd0, sector 0
[    9.855745] floppy: error -5 while reading block 0
[    9.879747] end_request: I/O error, dev fd0, sector 0
[    9.879749] floppy: error -5 while reading block 0
[   10.312775] Bridge firewalling registered
[   10.335564] device enp1s6 entered promiscuous mode
[   10.345640] device br0 entered promiscuous mode
[   10.357896] e1000: enp1s6 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   10.358024] br0: port 1(enp1s6) entered forwarding state
[   10.358035] br0: port 1(enp1s6) entered forwarding state

--=-=-=
Content-Disposition: inline; filename=dmesg.working
Content-Description: dmesg.working

[    0.000000] Linux version 3.14.17-gentoo (root@quad) (gcc version 4.7.3 (Gentoo 4.7.3-r1 p1.4, pie-0.5.5) ) #2 SMP Thu Sep 11 15:13:52 CEST 2014
[    0.000000] Command line: root=/dev/sda2 dyndbg="file drivers/pci/* +pf" log_buf_len=10M
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x00000000000997ff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000099800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000ca000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffdffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007ffe0000-0x000000007ffe9fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007ffea000-0x000000007fffffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x00000000cfbfffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfc00000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fff80000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000a2fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: NVIDIA  CK8 /Tyan Transport VX50-B4985, BIOS TYAN Transport VX50 B4985 BIOS V3.01.B30 11/27/2009
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xa30000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000a30000000 aka 41728M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcfc00 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f7770-0x000f777f] mapped at [ffff8800000f7770]
[    0.000000] Base memory trampoline at [ffff880000093000] 93000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01930000, 0x01930fff] PGTABLE
[    0.000000] BRK [0x01931000, 0x01931fff] PGTABLE
[    0.000000] BRK [0x01932000, 0x01932fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xa2fe00000-0xa2fffffff]
[    0.000000]  [mem 0xa2fe00000-0xa2fffffff] page 2M
[    0.000000] BRK [0x01933000, 0x01933fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xa2c000000-0xa2fdfffff]
[    0.000000]  [mem 0xa2c000000-0xa2fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0xa00000000-0xa2bffffff]
[    0.000000]  [mem 0xa00000000-0xa2bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7ffdffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x7fdfffff] page 2M
[    0.000000]  [mem 0x7fe00000-0x7ffdffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x80000000-0xcfbfffff]
[    0.000000]  [mem 0x80000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xcfbfffff] page 2M
[    0.000000] BRK [0x01934000, 0x01934fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x9ffffffff]
[    0.000000]  [mem 0x100000000-0x9ffffffff] page 1G
[    0.000000] log_buf_len: 16777216
[    0.000000] early log buf free: 257896(98%)
[    0.000000] ACPI: RSDP 00000000000f77f0 000014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 000000007ffe0aab 000038 (v01 PTLTD    RSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 000000007ffe4c98 000074 (v01 NVIDIA CK8S     06040000 PTL_ 000F4240)
[    0.000000] ACPI: DSDT 000000007ffe0ae3 0041B5 (v01 NVIDIA      CK8 06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 000000007ffeafc0 000040
[    0.000000] ACPI: SSDT 000000007ffe4d0c 005084 (v01 AMD    POWERNOW 06040000 AMD  00000001)
[    0.000000] ACPI: SPCR 000000007ffe9d90 000050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: APIC 000000007ffe9de0 0001F8 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 000000007ffe9fd8 000028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] Number of physical nodes 8
[    0.000000] Node 0 MemBase 0000000000000000 Limit 0000000130000000
[    0.000000] Node 1 MemBase 0000000130000000 Limit 0000000230000000
[    0.000000] Node 2 MemBase 0000000230000000 Limit 0000000330000000
[    0.000000] Node 3 MemBase 0000000330000000 Limit 0000000430000000
[    0.000000] Node 4 MemBase 0000000430000000 Limit 0000000530000000
[    0.000000] Node 5 MemBase 0000000530000000 Limit 0000000630000000
[    0.000000] Node 6 MemBase 0000000630000000 Limit 0000000830000000
[    0.000000] Node 7 MemBase 0000000830000000 Limit 0000000a30000000
[    0.000000] BSP APIC ID: 04
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x12fffffff]
[    0.000000]   NODE_DATA [mem 0x12fffc000-0x12fffffff]
[    0.000000] Initmem setup node 1 [mem 0x130000000-0x22fffffff]
[    0.000000]   NODE_DATA [mem 0x22fffc000-0x22fffffff]
[    0.000000] Initmem setup node 2 [mem 0x230000000-0x32fffffff]
[    0.000000]   NODE_DATA [mem 0x32fffc000-0x32fffffff]
[    0.000000] Initmem setup node 3 [mem 0x330000000-0x42fffffff]
[    0.000000]   NODE_DATA [mem 0x42fffc000-0x42fffffff]
[    0.000000] Initmem setup node 4 [mem 0x430000000-0x52fffffff]
[    0.000000]   NODE_DATA [mem 0x52fffc000-0x52fffffff]
[    0.000000] Initmem setup node 5 [mem 0x530000000-0x62fffffff]
[    0.000000]   NODE_DATA [mem 0x62fffc000-0x62fffffff]
[    0.000000] Initmem setup node 6 [mem 0x630000000-0x82fffffff]
[    0.000000]   NODE_DATA [mem 0x82fffc000-0x82fffffff]
[    0.000000] Initmem setup node 7 [mem 0x830000000-0xa2fffffff]
[    0.000000]   NODE_DATA [mem 0xa2effa000-0xa2effdfff]
[    0.000000] [ffffea0004280000-ffffea00043fffff] potential offnode page_structs
[    0.000000]  [ffffea0000000000-ffffea00043fffff] PMD -> [ffff88012be00000-ffff88012f7fffff] on node 0
[    0.000000] [ffffea0007a80000-ffffea0007bfffff] potential offnode page_structs
[    0.000000]  [ffffea0004400000-ffffea0007bfffff] PMD -> [ffff88022be00000-ffff88022f5fffff] on node 1
[    0.000000] [ffffea000b280000-ffffea000b3fffff] potential offnode page_structs
[    0.000000]  [ffffea0007c00000-ffffea000b3fffff] PMD -> [ffff88032be00000-ffff88032f5fffff] on node 2
[    0.000000] [ffffea000ea80000-ffffea000ebfffff] potential offnode page_structs
[    0.000000]  [ffffea000b400000-ffffea000ebfffff] PMD -> [ffff88042be00000-ffff88042f5fffff] on node 3
[    0.000000] [ffffea0012280000-ffffea00123fffff] potential offnode page_structs
[    0.000000]  [ffffea000ec00000-ffffea00123fffff] PMD -> [ffff88052be00000-ffff88052f5fffff] on node 4
[    0.000000] [ffffea0015a80000-ffffea0015bfffff] potential offnode page_structs
[    0.000000]  [ffffea0012400000-ffffea0015bfffff] PMD -> [ffff88062be00000-ffff88062f5fffff] on node 5
[    0.000000] [ffffea001ca80000-ffffea001cbfffff] potential offnode page_structs
[    0.000000]  [ffffea0015c00000-ffffea001cbfffff] PMD -> [ffff880827e00000-ffff88082edfffff] on node 6
[    0.000000]  [ffffea001cc00000-ffffea0023bfffff] PMD -> [ffff880a26600000-ffff880a2d5fffff] on node 7
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0xa2fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00098fff]
[    0.000000]   node   0: [mem 0x00100000-0x7ffdffff]
[    0.000000]   node   0: [mem 0x80000000-0xcfbfffff]
[    0.000000]   node   0: [mem 0x100000000-0x12fffffff]
[    0.000000]   node   1: [mem 0x130000000-0x22fffffff]
[    0.000000]   node   2: [mem 0x230000000-0x32fffffff]
[    0.000000]   node   3: [mem 0x330000000-0x42fffffff]
[    0.000000]   node   4: [mem 0x430000000-0x52fffffff]
[    0.000000]   node   5: [mem 0x530000000-0x62fffffff]
[    0.000000]   node   6: [mem 0x630000000-0x82fffffff]
[    0.000000]   node   7: [mem 0x830000000-0xa2fffffff]
[    0.000000] On node 0 totalpages: 1047416
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3992 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11578 pages used for memmap
[    0.000000]   DMA32 zone: 846816 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 196608 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 4 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 5 totalpages: 1048576
[    0.000000]   Normal zone: 14336 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] On node 6 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] On node 7 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x8008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x08] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x09] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x0a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x0c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x0d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x18] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x19] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x1a] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x1b] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x1c] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x1d] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x1e] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x1f] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 32 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x00099000-0x00099fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009a000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000c9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x000ca000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ffe0000-0x7ffe9fff]
[    0.000000] PM: Registered nosave memory: [mem 0x7ffea000-0x7fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xcfc00000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec10000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfff7ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfff80000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xdfffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:32 nr_node_ids:8
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88012fc00000 s79488 r8192 d22912 u524288
[    0.000000] pcpu-alloc: s79488 r8192 d22912 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 [1] 04 05 06 07 
[    0.000000] pcpu-alloc: [2] 08 09 10 11 [3] 12 13 14 15 
[    0.000000] pcpu-alloc: [4] 16 17 18 19 [5] 20 21 22 23 
[    0.000000] pcpu-alloc: [6] 24 25 26 27 [7] 28 29 30 31 
[    0.000000] Built 8 zonelists in Zone order, mobility grouping on.  Total pages: 10341233
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda2 dyndbg="file drivers/pci/* +pf" log_buf_len=10M
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ d0000000 size 64 MB
[    0.000000] Node 1: aperture @ d0000000 size 64 MB
[    0.000000] Node 2: aperture @ d0000000 size 64 MB
[    0.000000] Node 3: aperture @ d0000000 size 64 MB
[    0.000000] Node 4: aperture @ d0000000 size 64 MB
[    0.000000] Node 5: aperture @ d0000000 size 64 MB
[    0.000000] Node 6: aperture @ d0000000 size 64 MB
[    0.000000] Node 7: aperture @ d0000000 size 64 MB
[    0.000000] Memory: 41266584K/41938400K available (4454K kernel code, 649K rwdata, 2432K rodata, 932K init, 896K bss, 671816K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:936 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1908.658 MHz processor
[    0.000027] Calibrating delay loop (skipped), value calculated using timer frequency.. 3817.31 BogoMIPS (lpj=7634632)
[    0.000329] pid_max: default: 32768 minimum: 301
[    0.000579] ACPI: Core revision 20131218
[    0.006528] ACPI: All ACPI Tables successfully acquired
[    0.015465] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.066707] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.090158] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.090484] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.092728] tseg: 00cfc00000
[    0.092734] CPU: Physical Processor ID: 0
[    0.092879] CPU: Processor Core ID: 0
[    0.093027] mce: CPU supports 6 MCE banks
[    0.093207] LVT offset 0 assigned for vector 0xf9
[    0.093364] process: using AMD E400 aware idle routine
[    0.093518] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
tlb_flushall_shift: 6
[    0.094072] Freeing SMP alternatives memory: 20K (ffffffff81849000 - ffffffff8184e000)
[    0.094437] Switched APIC routing to physical flat.
[    0.095043] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.135586] smpboot: CPU0: Quad-Core AMD Opteron(tm) Processor 8347 HE (fam: 10, model: 02, stepping: 03)
[    0.241922] Performance Events: AMD PMU driver.
[    0.242124] ... version:                0
[    0.242259] ... bit width:              48
[    0.242404] ... generic registers:      4
[    0.242550] ... value mask:             0000ffffffffffff
[    0.242698] ... max period:             00007fffffffffff
[    0.242845] ... fixed-purpose events:   0
[    0.242980] ... event mask:             000000000000000f
[    0.245184] x86: Booting SMP configuration:
[    0.245357] .... node  #0, CPUs:        #1  #2  #3
[    0.287335] .... node  #1, CPUs:    #4  #5  #6  #7
[    0.439816] .... node  #2, CPUs:    #8  #9 #10 #11
[    0.593471] .... node  #3, CPUs:   #12 #13 #14 #15
[    0.744071] .... node  #4, CPUs:   #16 #17 #18 #19
[    0.895677] .... node  #5, CPUs:   #20 #21 #22 #23
[    1.047829] .... node  #6, CPUs:   #24 #25 #26 #27
[    1.200042] .... node  #7, CPUs:   #28 #29 #30 #31
[    1.351581] x86: Booted up 8 nodes, 32 CPUs
[    1.351890] smpboot: Total of 32 processors activated (122217.63 BogoMIPS)
[    1.373768] devtmpfs: initialized
[    1.374599] PM: Registering ACPI NVS region [mem 0x7ffea000-0x7fffffff] (90112 bytes)
[    1.376069] NET: Registered protocol family 16
[    1.376875] cpuidle: using governor ladder
[    1.377024] cpuidle: using governor menu
[    1.377178] node 0 link 1: io port [1000, 3fff]
[    1.377182] node 1 link 1: io port [b000, bfff]
[    1.377185] node 1 link 1: io port [9000, 9fff]
[    1.377189] TOM: 00000000d0000000 aka 3328M
[    1.377340] node 0 link 1: mmio [d4000000, dbffffff]
[    1.377345] node 1 link 1: mmio [dc000000, dc3fffff]
[    1.377348] node 0 link 1: mmio [a0000, bffff]
[    1.377351] node 0 link 1: mmio [e0000000, e7ffffff]
[    1.377353] node 1 link 1: mmio [e8000000, efffffff]
[    1.377356] TOM2: 0000000a30000000 aka 41728M
[    1.377508] bus: [bus 00-7f] on node 0 link 1
[    1.377510] bus: 00 [io  0x0000-0x8fff]
[    1.377512] bus: 00 [io  0xc000-0xffff]
[    1.377513] bus: 00 [io  0xa000-0xafff]
[    1.377515] bus: 00 [mem 0xd0000000-0xdbffffff]
[    1.377516] bus: 00 [mem 0x000a0000-0x000bffff]
[    1.377518] bus: 00 [mem 0xdc400000-0xe7ffffff]
[    1.377519] bus: 00 [mem 0xf0000000-0xffffffff]
[    1.377520] bus: 00 [mem 0xa30000000-0xfcffffffff]
[    1.377522] bus: [bus 80-ff] on node 1 link 1
[    1.377523] bus: 80 [io  0xb000-0xbfff]
[    1.377524] bus: 80 [io  0x9000-0x9fff]
[    1.377526] bus: 80 [mem 0xdc000000-0xdc3fffff]
[    1.377527] bus: 80 [mem 0xe8000000-0xefffffff]
[    1.377696] ACPI: bus type PCI registered
[    1.378072] PCI: Using configuration type 1 for base access
[    1.378217] PCI: Using configuration type 1 for extended access
[    1.395387] bio: create slab <bio-0> at 0
[    1.396595] ACPI: Added _OSI(Module Device)
[    1.396745] ACPI: Added _OSI(Processor Device)
[    1.396892] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.397039] ACPI: Added _OSI(Processor Aggregator Device)
[    1.413235] ACPI: Interpreter enabled
[    1.413419] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131218/hwxface-580)
[    1.413758] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20131218/hwxface-580)
[    1.414097] ACPI: (supports S0 S1 S4 S5)
[    1.414239] ACPI: Using IOAPIC for interrupt routing
[    1.414498] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.414984] ACPI: No dock devices found.
[    1.435180] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-07])
[    1.435377] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.435541] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.436054] acpi PNP0A03:00: ignoring host bridge window [mem 0x000c0000-0x000dffff] (conflicts with reserved [mem 0x000ca000-0x000fffff])
[    1.436432] PCI host bridge to bus 0000:00
[    1.436608] pci_bus 0000:00: root bus resource [bus 00-07]
[    1.436764] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.436916] pci_bus 0000:00: root bus resource [io  0x0d00-0x3fff]
[    1.437070] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.437221] pci_bus 0000:00: root bus resource [mem 0xd4000000-0xdbffffff]
[    1.437377] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[    1.437400] pci 0000:00:00.0: [10de:005e] type 00 class 0x058000
[    1.437691] pci 0000:00:01.0: [10de:0051] type 00 class 0x060100
[    1.437749] fixup_debug_start: pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xaa
[    1.437751] HPET not enabled in BIOS. You might try hpet=force boot option
[    1.438156] pci 0000:00:01.1: [10de:0052] type 00 class 0x0c0500
[    1.438169] pci 0000:00:01.1: reg 0x10: [io  0x0000-0x001f]
[    1.438202] pci 0000:00:01.1: reg 0x20: [io  0xa000-0xa03f]
[    1.438207] pci 0000:00:01.1: reg 0x24: [io  0xa040-0xa07f]
[    1.438239] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    1.438244] pci_pme_active: pci 0000:00:01.1: PME# disabled
[    1.438447] pci 0000:00:02.0: [10de:005a] type 00 class 0x0c0310
[    1.438458] pci 0000:00:02.0: reg 0x10: [mem 0xd4000000-0xd4000fff]
[    1.438504] pci 0000:00:02.0: supports D1 D2
[    1.438506] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.438525] pci_pme_active: pci 0000:00:02.0: PME# disabled
[    1.438609] pci 0000:00:02.0: System wakeup disabled by ACPI
[    1.438886] pci 0000:00:02.1: [10de:005b] type 00 class 0x0c0320
[    1.438900] pci 0000:00:02.1: reg 0x10: [mem 0xd4001000-0xd40010ff]
[    1.438942] pci 0000:00:02.1: supports D1 D2
[    1.438954] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.438973] pci_pme_active: pci 0000:00:02.1: PME# disabled
[    1.439083] pci 0000:00:02.1: System wakeup disabled by ACPI
[    1.439352] pci 0000:00:06.0: [10de:0053] type 00 class 0x01018a
[    1.439388] pci 0000:00:06.0: reg 0x20: [io  0x1400-0x140f]
[    1.439626] pci 0000:00:07.0: [10de:0054] type 00 class 0x010185
[    1.439633] pci 0000:00:07.0: reg 0x10: [io  0x1440-0x1447]
[    1.439646] pci 0000:00:07.0: reg 0x14: [io  0x1434-0x1437]
[    1.439652] pci 0000:00:07.0: reg 0x18: [io  0x1438-0x143f]
[    1.439657] pci 0000:00:07.0: reg 0x1c: [io  0x1430-0x1433]
[    1.439662] pci 0000:00:07.0: reg 0x20: [io  0x1410-0x141f]
[    1.439667] pci 0000:00:07.0: reg 0x24: [mem 0xd4002000-0xd4002fff]
[    1.439909] pci 0000:00:08.0: [10de:0055] type 00 class 0x010185
[    1.439923] pci 0000:00:08.0: reg 0x10: [io  0x1458-0x145f]
[    1.439933] pci 0000:00:08.0: reg 0x14: [io  0x144c-0x144f]
[    1.439947] pci 0000:00:08.0: reg 0x18: [io  0x1450-0x1457]
[    1.439970] pci 0000:00:08.0: reg 0x1c: [io  0x1448-0x144b]
[    1.439974] pci 0000:00:08.0: reg 0x20: [io  0x1420-0x142f]
[    1.439980] pci 0000:00:08.0: reg 0x24: [mem 0xd4003000-0xd4003fff]
[    1.440218] pci 0000:00:09.0: [10de:005c] type 01 class 0x060401
[    1.440341] pci 0000:00:09.0: System wakeup disabled by ACPI
[    1.440607] pci 0000:00:0a.0: [10de:0057] type 00 class 0x068000
[    1.440621] pci 0000:00:0a.0: reg 0x10: [mem 0xd4004000-0xd4004fff]
[    1.440630] pci 0000:00:0a.0: reg 0x14: [io  0x1460-0x1467]
[    1.440664] pci 0000:00:0a.0: supports D1 D2
[    1.440667] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.440677] pci_pme_active: pci 0000:00:0a.0: PME# disabled
[    1.440787] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    1.441056] pci 0000:00:0b.0: [10de:005d] type 01 class 0x060400
[    1.441130] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.441143] pci_pme_active: pci 0000:00:0b.0: PME# disabled
[    1.441364] pci 0000:00:0c.0: [10de:005d] type 01 class 0x060400
[    1.441404] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.441416] pci_pme_active: pci 0000:00:0c.0: PME# disabled
[    1.441654] pci 0000:00:0d.0: [10de:005d] type 01 class 0x060400
[    1.441705] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.441709] pci_pme_active: pci 0000:00:0d.0: PME# disabled
[    1.441915] pci 0000:00:0e.0: [10de:005d] type 01 class 0x060400
[    1.441959] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.441962] pci_pme_active: pci 0000:00:0e.0: PME# disabled
[    1.442200] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    1.442209] fixup_debug_start: pci 0000:00:18.0: calling quirk_mmio_always_on+0x0/0x5
[    1.442409] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    1.442414] fixup_debug_start: pci 0000:00:18.1: calling quirk_mmio_always_on+0x0/0x5
[    1.442634] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    1.442639] fixup_debug_start: pci 0000:00:18.2: calling quirk_mmio_always_on+0x0/0x5
[    1.442887] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    1.442892] fixup_debug_start: pci 0000:00:18.3: calling quirk_mmio_always_on+0x0/0x5
[    1.443099] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    1.443104] fixup_debug_start: pci 0000:00:18.4: calling quirk_mmio_always_on+0x0/0x5
[    1.443328] pci 0000:00:19.0: [1022:1200] type 00 class 0x060000
[    1.443333] fixup_debug_start: pci 0000:00:19.0: calling quirk_mmio_always_on+0x0/0x5
[    1.443547] pci 0000:00:19.1: [1022:1201] type 00 class 0x060000
[    1.443561] fixup_debug_start: pci 0000:00:19.1: calling quirk_mmio_always_on+0x0/0x5
[    1.443748] pci 0000:00:19.2: [1022:1202] type 00 class 0x060000
[    1.443752] fixup_debug_start: pci 0000:00:19.2: calling quirk_mmio_always_on+0x0/0x5
[    1.443960] pci 0000:00:19.3: [1022:1203] type 00 class 0x060000
[    1.443964] fixup_debug_start: pci 0000:00:19.3: calling quirk_mmio_always_on+0x0/0x5
[    1.444191] pci 0000:00:19.4: [1022:1204] type 00 class 0x060000
[    1.444196] fixup_debug_start: pci 0000:00:19.4: calling quirk_mmio_always_on+0x0/0x5
[    1.444414] pci 0000:00:1a.0: [1022:1200] type 00 class 0x060000
[    1.444418] fixup_debug_start: pci 0000:00:1a.0: calling quirk_mmio_always_on+0x0/0x5
[    1.444640] pci 0000:00:1a.1: [1022:1201] type 00 class 0x060000
[    1.444645] fixup_debug_start: pci 0000:00:1a.1: calling quirk_mmio_always_on+0x0/0x5
[    1.444855] pci 0000:00:1a.2: [1022:1202] type 00 class 0x060000
[    1.444860] fixup_debug_start: pci 0000:00:1a.2: calling quirk_mmio_always_on+0x0/0x5
[    1.445085] pci 0000:00:1a.3: [1022:1203] type 00 class 0x060000
[    1.445090] fixup_debug_start: pci 0000:00:1a.3: calling quirk_mmio_always_on+0x0/0x5
[    1.445337] pci 0000:00:1a.4: [1022:1204] type 00 class 0x060000
[    1.445341] fixup_debug_start: pci 0000:00:1a.4: calling quirk_mmio_always_on+0x0/0x5
[    1.445569] pci 0000:00:1b.0: [1022:1200] type 00 class 0x060000
[    1.445574] fixup_debug_start: pci 0000:00:1b.0: calling quirk_mmio_always_on+0x0/0x5
[    1.445799] pci 0000:00:1b.1: [1022:1201] type 00 class 0x060000
[    1.445803] fixup_debug_start: pci 0000:00:1b.1: calling quirk_mmio_always_on+0x0/0x5
[    1.446024] pci 0000:00:1b.2: [1022:1202] type 00 class 0x060000
[    1.446029] fixup_debug_start: pci 0000:00:1b.2: calling quirk_mmio_always_on+0x0/0x5
[    1.446260] pci 0000:00:1b.3: [1022:1203] type 00 class 0x060000
[    1.446265] fixup_debug_start: pci 0000:00:1b.3: calling quirk_mmio_always_on+0x0/0x5
[    1.446477] pci 0000:00:1b.4: [1022:1204] type 00 class 0x060000
[    1.446482] fixup_debug_start: pci 0000:00:1b.4: calling quirk_mmio_always_on+0x0/0x5
[    1.446811] pci 0000:00:1c.0: [1022:1200] type 00 class 0x060000
[    1.446831] fixup_debug_start: pci 0000:00:1c.0: calling quirk_mmio_always_on+0x0/0x5
[    1.447216] pci 0000:00:1c.1: [1022:1201] type 00 class 0x060000
[    1.447222] fixup_debug_start: pci 0000:00:1c.1: calling quirk_mmio_always_on+0x0/0x5
[    1.447447] pci 0000:00:1c.2: [1022:1202] type 00 class 0x060000
[    1.447451] fixup_debug_start: pci 0000:00:1c.2: calling quirk_mmio_always_on+0x0/0x5
[    1.447672] pci 0000:00:1c.3: [1022:1203] type 00 class 0x060000
[    1.447677] fixup_debug_start: pci 0000:00:1c.3: calling quirk_mmio_always_on+0x0/0x5
[    1.447906] pci 0000:00:1c.4: [1022:1204] type 00 class 0x060000
[    1.447911] fixup_debug_start: pci 0000:00:1c.4: calling quirk_mmio_always_on+0x0/0x5
[    1.448132] pci 0000:00:1d.0: [1022:1200] type 00 class 0x060000
[    1.448140] fixup_debug_start: pci 0000:00:1d.0: calling quirk_mmio_always_on+0x0/0x5
[    1.448389] pci 0000:00:1d.1: [1022:1201] type 00 class 0x060000
[    1.448393] fixup_debug_start: pci 0000:00:1d.1: calling quirk_mmio_always_on+0x0/0x5
[    1.448590] pci 0000:00:1d.2: [1022:1202] type 00 class 0x060000
[    1.448595] fixup_debug_start: pci 0000:00:1d.2: calling quirk_mmio_always_on+0x0/0x5
[    1.448825] pci 0000:00:1d.3: [1022:1203] type 00 class 0x060000
[    1.448829] fixup_debug_start: pci 0000:00:1d.3: calling quirk_mmio_always_on+0x0/0x5
[    1.449077] pci 0000:00:1d.4: [1022:1204] type 00 class 0x060000
[    1.449082] fixup_debug_start: pci 0000:00:1d.4: calling quirk_mmio_always_on+0x0/0x5
[    1.449330] pci 0000:00:1e.0: [1022:1200] type 00 class 0x060000
[    1.449334] fixup_debug_start: pci 0000:00:1e.0: calling quirk_mmio_always_on+0x0/0x5
[    1.449544] pci 0000:00:1e.1: [1022:1201] type 00 class 0x060000
[    1.449549] fixup_debug_start: pci 0000:00:1e.1: calling quirk_mmio_always_on+0x0/0x5
[    1.449774] pci 0000:00:1e.2: [1022:1202] type 00 class 0x060000
[    1.449778] fixup_debug_start: pci 0000:00:1e.2: calling quirk_mmio_always_on+0x0/0x5
[    1.450031] pci 0000:00:1e.3: [1022:1203] type 00 class 0x060000
[    1.450036] fixup_debug_start: pci 0000:00:1e.3: calling quirk_mmio_always_on+0x0/0x5
[    1.450263] pci 0000:00:1e.4: [1022:1204] type 00 class 0x060000
[    1.450268] fixup_debug_start: pci 0000:00:1e.4: calling quirk_mmio_always_on+0x0/0x5
[    1.450507] pci 0000:00:1f.0: [1022:1200] type 00 class 0x060000
[    1.450514] fixup_debug_start: pci 0000:00:1f.0: calling quirk_mmio_always_on+0x0/0x5
[    1.450743] pci 0000:00:1f.1: [1022:1201] type 00 class 0x060000
[    1.450748] fixup_debug_start: pci 0000:00:1f.1: calling quirk_mmio_always_on+0x0/0x5
[    1.450963] pci 0000:00:1f.2: [1022:1202] type 00 class 0x060000
[    1.450973] fixup_debug_start: pci 0000:00:1f.2: calling quirk_mmio_always_on+0x0/0x5
[    1.451178] pci 0000:00:1f.3: [1022:1203] type 00 class 0x060000
[    1.451183] fixup_debug_start: pci 0000:00:1f.3: calling quirk_mmio_always_on+0x0/0x5
[    1.451388] pci 0000:00:1f.4: [1022:1204] type 00 class 0x060000
[    1.451393] fixup_debug_start: pci 0000:00:1f.4: calling quirk_mmio_always_on+0x0/0x5
[    1.451578] pci_scan_child_bus: pci_bus 0000:00: fixups for bus
[    1.451583] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 01-01] behind bridge, pass 0
[    1.451662] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[    1.451690] pci 0000:01:06.0: [8086:1076] type 00 class 0x020000
[    1.451730] pci 0000:01:06.0: reg 0x10: [mem 0xd4120000-0xd413ffff]
[    1.451746] pci 0000:01:06.0: reg 0x14: [mem 0xd4100000-0xd411ffff]
[    1.451763] pci 0000:01:06.0: reg 0x18: [io  0x2080-0x20bf]
[    1.451785] pci 0000:01:06.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    1.451829] pci 0000:01:06.0: PME# supported from D0 D3hot D3cold
[    1.451833] pci_pme_active: pci 0000:01:06.0: PME# disabled
[    1.451959] pci 0000:01:09.0: [18ca:0020] type 00 class 0x030000
[    1.451984] pci 0000:01:09.0: reg 0x10: [mem 0xd8000000-0xdbffffff pref]
[    1.451991] pci 0000:01:09.0: reg 0x14: [mem 0xd4140000-0xd417ffff]
[    1.452003] pci 0000:01:09.0: reg 0x18: [io  0x2000-0x207f]
[    1.452039] pci 0000:01:09.0: supports D1 D2
[    1.452209] pci_scan_child_bus: pci_bus 0000:01: fixups for bus
[    1.452228] pci 0000:00:09.0: PCI bridge to [bus 01] (subtractive decode)
[    1.452385] pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
[    1.452389] pci 0000:00:09.0:   bridge window [mem 0xd4100000-0xd41fffff]
[    1.452392] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdbffffff pref]
[    1.452395] pci 0000:00:09.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.452398] pci 0000:00:09.0:   bridge window [io  0x0d00-0x3fff] (subtractive decode)
[    1.452401] pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.452404] pci 0000:00:09.0:   bridge window [mem 0xd4000000-0xdbffffff] (subtractive decode)
[    1.452407] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=01
[    1.452412] pci_scan_bridge: pci 0000:00:0b.0: scanning [bus 02-02] behind bridge, pass 0
[    1.452517] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[    1.452520] pci_scan_child_bus: pci_bus 0000:02: fixups for bus
[    1.452529] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    1.452681] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[    1.452685] pci_scan_bridge: pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 0
[    1.452787] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[    1.452795] pci_scan_child_bus: pci_bus 0000:03: fixups for bus
[    1.452797] pci 0000:00:0c.0: PCI bridge to [bus 03]
[    1.452948] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[    1.452952] pci_scan_bridge: pci 0000:00:0d.0: scanning [bus 05-05] behind bridge, pass 0
[    1.453051] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[    1.453059] pci_scan_child_bus: pci_bus 0000:05: fixups for bus
[    1.453062] pci 0000:00:0d.0: PCI bridge to [bus 05]
[    1.453215] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[    1.453220] pci_scan_bridge: pci 0000:00:0e.0: scanning [bus 0a-0a] behind bridge, pass 0
[    1.453323] pci_bus 0000:0a: busn_res: can not insert [bus 0a] under [bus 00-07] (conflicts with (null) [bus 00-07])
[    1.453326] pci_scan_child_bus: pci_bus 0000:0a: scanning bus
[    1.453343] pci 0000:0a:00.0: [1000:0646] type 00 class 0x0c0400
[    1.453361] pci 0000:0a:00.0: reg 0x10: [io  0x3000-0x30ff]
[    1.453380] pci 0000:0a:00.0: reg 0x14: [mem 0xd4210000-0xd4213fff 64bit]
[    1.453391] pci 0000:0a:00.0: reg 0x1c: [mem 0xd4200000-0xd420ffff 64bit]
[    1.453418] pci 0000:0a:00.0: reg 0x30: [mem 0x00000000-0x000fffff pref]
[    1.453476] pci 0000:0a:00.0: supports D1 D2
[    1.453612] pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.453885] pci_scan_child_bus: pci_bus 0000:0a: fixups for bus
[    1.453887] pci 0000:00:0e.0: PCI bridge to [bus 0a]
[    1.454042] pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
[    1.454045] pci 0000:00:0e.0:   bridge window [mem 0xd4200000-0xd42fffff]
[    1.454049] pci_scan_child_bus: pci_bus 0000:0a: bus scan returning with max=0a
[    1.454054] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 01-01] behind bridge, pass 1
[    1.454068] pci_scan_bridge: pci 0000:00:0b.0: scanning [bus 02-02] behind bridge, pass 1
[    1.454075] pci_scan_bridge: pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 1
[    1.454079] pci_scan_bridge: pci 0000:00:0d.0: scanning [bus 05-05] behind bridge, pass 1
[    1.454083] pci_scan_bridge: pci 0000:00:0e.0: scanning [bus 0a-0a] behind bridge, pass 1
[    1.454087] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=0a
[    1.455036] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    1.455602] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
[    1.456117] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
[    1.456634] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0, disabled.
[    1.457183] ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
[    1.457739] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0, disabled.
[    1.458286] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
[    1.458787] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0
[    1.459294] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0
[    1.459785] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
[    1.460365] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
[    1.460901] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
[    1.461451] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
[    1.461956] ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0, disabled.
[    1.462487] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    1.463202] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-ff])
[    1.463358] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.463520] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.464151] acpi PNP0A03:01: ignoring host bridge window [mem 0x000c0000-0x000dffff] (conflicts with reserved [mem 0x000ca000-0x000fffff])
[    1.464519] PCI host bridge to bus 0000:80
[    1.464667] pci_bus 0000:80: root bus resource [bus 80-ff]
[    1.464827] pci_bus 0000:80: root bus resource [io  0xb000-0xffff]
[    1.464978] pci_bus 0000:80: root bus resource [mem 0x000a0000-0x000bffff]
[    1.465120] pci_bus 0000:80: root bus resource [mem 0xdc000000-0xdc3fffff]
[    1.465284] pci_scan_child_bus: pci_bus 0000:80: scanning bus
[    1.465298] pci 0000:80:00.0: [10de:005e] type 00 class 0x058000
[    1.465511] pci 0000:80:01.0: [10de:00d3] type 00 class 0x058000
[    1.465757] pci 0000:80:07.0: [10de:0054] type 00 class 0x010185
[    1.465771] pci 0000:80:07.0: reg 0x10: [io  0xb030-0xb037]
[    1.465781] pci 0000:80:07.0: reg 0x14: [io  0xb024-0xb027]
[    1.465790] pci 0000:80:07.0: reg 0x18: [io  0xb028-0xb02f]
[    1.465795] pci 0000:80:07.0: reg 0x1c: [io  0xb020-0xb023]
[    1.465800] pci 0000:80:07.0: reg 0x20: [io  0xb000-0xb00f]
[    1.465810] pci 0000:80:07.0: reg 0x24: [mem 0xdc000000-0xdc000fff]
[    1.466008] pci 0000:80:08.0: [10de:0055] type 00 class 0x010185
[    1.466019] pci 0000:80:08.0: reg 0x10: [io  0xb048-0xb04f]
[    1.466043] pci 0000:80:08.0: reg 0x14: [io  0xb03c-0xb03f]
[    1.466058] pci 0000:80:08.0: reg 0x18: [io  0xb040-0xb047]
[    1.466063] pci 0000:80:08.0: reg 0x1c: [io  0xb038-0xb03b]
[    1.466078] pci 0000:80:08.0: reg 0x20: [io  0xb010-0xb01f]
[    1.466092] pci 0000:80:08.0: reg 0x24: [mem 0xdc001000-0xdc001fff]
[    1.466284] pci 0000:80:0a.0: [10de:0057] type 00 class 0x068000
[    1.466303] pci 0000:80:0a.0: reg 0x10: [mem 0xdc002000-0xdc002fff]
[    1.466318] pci 0000:80:0a.0: reg 0x14: [io  0xb050-0xb057]
[    1.466349] pci 0000:80:0a.0: supports D1 D2
[    1.466368] pci 0000:80:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.466378] pci_pme_active: pci 0000:80:0a.0: PME# disabled
[    1.466432] pci 0000:80:0a.0: System wakeup disabled by ACPI
[    1.466707] pci 0000:80:0b.0: [10de:005d] type 01 class 0x060400
[    1.466776] pci 0000:80:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.466786] pci_pme_active: pci 0000:80:0b.0: PME# disabled
[    1.466957] pci 0000:80:0c.0: [10de:005d] type 01 class 0x060400
[    1.467023] pci 0000:80:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.467026] pci_pme_active: pci 0000:80:0c.0: PME# disabled
[    1.467202] pci 0000:80:0d.0: [10de:005d] type 01 class 0x060400
[    1.467261] pci 0000:80:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.467264] pci_pme_active: pci 0000:80:0d.0: PME# disabled
[    1.467424] pci 0000:80:0e.0: [10de:005d] type 01 class 0x060400
[    1.467479] pci 0000:80:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.467487] pci_pme_active: pci 0000:80:0e.0: PME# disabled
[    1.467660] pci_scan_child_bus: pci_bus 0000:80: fixups for bus
[    1.467664] pci_scan_bridge: pci 0000:80:0b.0: scanning [bus 81-85] behind bridge, pass 0
[    1.467770] pci_scan_child_bus: pci_bus 0000:81: scanning bus
[    1.467773] pci_scan_child_bus: pci_bus 0000:81: fixups for bus
[    1.467776] pci 0000:80:0b.0: PCI bridge to [bus 81-85]
[    1.467920] pci_scan_child_bus: pci_bus 0000:81: bus scan returning with max=81
[    1.467938] pci_scan_bridge: pci 0000:80:0c.0: scanning [bus 86-8a] behind bridge, pass 0
[    1.468072] pci_scan_child_bus: pci_bus 0000:86: scanning bus
[    1.468076] pci_scan_child_bus: pci_bus 0000:86: fixups for bus
[    1.468079] pci 0000:80:0c.0: PCI bridge to [bus 86-8a]
[    1.468233] pci_scan_child_bus: pci_bus 0000:86: bus scan returning with max=86
[    1.468237] pci_scan_bridge: pci 0000:80:0d.0: scanning [bus 8b-8f] behind bridge, pass 0
[    1.468368] pci_scan_child_bus: pci_bus 0000:8b: scanning bus
[    1.468371] pci_scan_child_bus: pci_bus 0000:8b: fixups for bus
[    1.468374] pci 0000:80:0d.0: PCI bridge to [bus 8b-8f]
[    1.468516] pci_scan_child_bus: pci_bus 0000:8b: bus scan returning with max=8b
[    1.468530] pci_scan_bridge: pci 0000:80:0e.0: scanning [bus 90-94] behind bridge, pass 0
[    1.468642] pci_scan_child_bus: pci_bus 0000:90: scanning bus
[    1.468645] pci_scan_child_bus: pci_bus 0000:90: fixups for bus
[    1.468648] pci 0000:80:0e.0: PCI bridge to [bus 90-94]
[    1.468793] pci_scan_child_bus: pci_bus 0000:90: bus scan returning with max=90
[    1.468800] pci_scan_bridge: pci 0000:80:0b.0: scanning [bus 81-85] behind bridge, pass 1
[    1.468805] pci_scan_bridge: pci 0000:80:0c.0: scanning [bus 86-8a] behind bridge, pass 1
[    1.468809] pci_scan_bridge: pci 0000:80:0d.0: scanning [bus 8b-8f] behind bridge, pass 1
[    1.468813] pci_scan_bridge: pci 0000:80:0e.0: scanning [bus 90-94] behind bridge, pass 1
[    1.468817] pci_scan_child_bus: pci_bus 0000:80: bus scan returning with max=94
[    1.469384] vgaarb: device added: PCI:0000:01:09.0,decodes=io+mem,owns=io+mem,locks=none
[    1.469542] vgaarb: loaded
[    1.469678] vgaarb: bridge control possible 0000:01:09.0
[    1.470672] SCSI subsystem initialized
[    1.471157] libata version 3.00 loaded.
[    1.471179] ACPI: bus type USB registered
[    1.471489] usbcore: registered new interface driver usbfs
[    1.471716] usbcore: registered new interface driver hub
[    1.471963] usbcore: registered new device driver usb
[    1.472305] PCI: Using ACPI for IRQ routing
[    1.472448] PCI: pci_cache_line_size set to 64 bytes
[    1.472462] pci 0000:00:01.1: no compatible bridge window for [io  0xa000-0xa03f]
[    1.472621] pci 0000:00:01.1: no compatible bridge window for [io  0xa040-0xa07f]
[    1.472907] e820: reserve RAM buffer [mem 0x00099800-0x0009ffff]
[    1.472911] e820: reserve RAM buffer [mem 0x7ffe0000-0x7fffffff]
[    1.472914] e820: reserve RAM buffer [mem 0xcfc00000-0xcfffffff]
[    1.473847] Switched to clocksource refined-jiffies
[    1.488268] pnp: PnP ACPI init
[    1.488458] ACPI: bus type PNP registered
[    1.489165] system 00:00: [mem 0xff800000-0xffffffff] could not be reserved
[    1.489338] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.489502] system 00:00: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.489657] system 00:00: [mem 0xfefff000-0xfeffffff] has been reserved
[    1.489818] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.490417] pnp 00:01: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.490922] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.491371] pnp 00:03: [dma 2]
[    1.491482] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.492044] pnp 00:04: [dma 1]
[    1.492278] pnp 00:04: Plug and Play ACPI device, IDs PNP0401 (active)
[    1.492405] pnp 00:05: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.492522] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.493007] system 00:07: [io  0x8000-0x807f] could not be reserved
[    1.493185] system 00:07: [io  0x8080-0x80ff] has been reserved
[    1.493339] system 00:07: [io  0x8400-0x847f] has been reserved
[    1.493491] system 00:07: [io  0x8480-0x84ff] has been reserved
[    1.493648] system 00:07: [io  0x8800-0x887f] has been reserved
[    1.493797] system 00:07: [io  0x8880-0x88ff] has been reserved
[    1.493948] system 00:07: [io  0xa000-0xa03f] has been reserved
[    1.494098] system 00:07: [io  0xa040-0xa07f] has been reserved
[    1.494238] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.494294] pnp 00:08: disabling [io  0x0010-0x001f] because it overlaps 0000:00:01.1 BAR 0 [io  0x0000-0x001f]
[    1.494564] pnp 00:08: disabling [io  0x0010-0x001f disabled] because it overlaps 0000:00:01.1 BAR 4 [io  0x0000-0x003f]
[    1.494815] pnp 00:08: disabling [io  0x0022-0x003f] because it overlaps 0000:00:01.1 BAR 4 [io  0x0000-0x003f]
[    1.495085] pnp 00:08: disabling [io  0x0010-0x001f disabled] because it overlaps 0000:00:01.1 BAR 5 [io  0x0000-0x003f]
[    1.495336] pnp 00:08: disabling [io  0x0022-0x003f disabled] because it overlaps 0000:00:01.1 BAR 5 [io  0x0000-0x003f]
[    1.495776] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    1.495929] system 00:08: [io  0x0400-0x045e] has been reserved
[    1.496092] system 00:08: [io  0x9000-0x907f] has been reserved
[    1.496246] system 00:08: [io  0x9080-0x90ff] has been reserved
[    1.496403] system 00:08: [io  0x9200-0x927f] has been reserved
[    1.496554] system 00:08: [io  0x9280-0x92ff] has been reserved
[    1.496706] system 00:08: [io  0x9400-0x947f] has been reserved
[    1.496848] system 00:08: [io  0x9480-0x94ff] has been reserved
[    1.497008] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.497038] pnp 00:09: [dma 4]
[    1.497119] pnp 00:09: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.497216] pnp 00:0a: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.497319] pnp 00:0b: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.497420] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.498022] pnp: PnP ACPI: found 13 devices
[    1.498185] ACPI: bus type PNP unregistered
[    1.503134] Switched to clocksource acpi_pm
[    1.506704] pci 0000:00:0e.0: BAR 15: assigned [mem 0xd4300000-0xd43fffff pref]
[    1.506863] pci 0000:00:01.1: BAR 4: assigned [io  0x1000-0x103f]
[    1.507025] pci_update_resource: pci 0000:00:01.1: BAR 4: set to [io  0x1000-0x103f] (PCI address [0x1000-0x103f])
[    1.507029] pci 0000:00:01.1: BAR 5: assigned [io  0x1040-0x107f]
[    1.507336] pci_update_resource: pci 0000:00:01.1: BAR 5: set to [io  0x1040-0x107f] (PCI address [0x1040-0x107f])
[    1.507342] pci 0000:00:01.1: BAR 0: assigned [io  0x1080-0x109f]
[    1.507495] pci_update_resource: pci 0000:00:01.1: BAR 0: set to [io  0x1080-0x109f] (PCI address [0x1080-0x109f])
[    1.507526] pci 0000:01:06.0: BAR 6: assigned [mem 0xd4180000-0xd419ffff pref]
[    1.507686] pci 0000:00:09.0: PCI bridge to [bus 01]
[    1.507835] pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
[    1.507987] pci 0000:00:09.0:   bridge window [mem 0xd4100000-0xd41fffff]
[    1.508141] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdbffffff pref]
[    1.508296] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    1.508448] pci 0000:00:0c.0: PCI bridge to [bus 03]
[    1.508601] pci 0000:00:0d.0: PCI bridge to [bus 05]
[    1.508755] pci 0000:0a:00.0: BAR 6: assigned [mem 0xd4300000-0xd43fffff pref]
[    1.508912] pci 0000:00:0e.0: PCI bridge to [bus 0a]
[    1.509061] pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
[    1.509213] pci 0000:00:0e.0:   bridge window [mem 0xd4200000-0xd42fffff]
[    1.509355] pci 0000:00:0e.0:   bridge window [mem 0xd4300000-0xd43fffff pref]
[    1.509520] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.509523] pci_bus 0000:00: resource 5 [io  0x0d00-0x3fff]
[    1.509525] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.509528] pci_bus 0000:00: resource 7 [mem 0xd4000000-0xdbffffff]
[    1.509531] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    1.509534] pci_bus 0000:01: resource 1 [mem 0xd4100000-0xd41fffff]
[    1.509537] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdbffffff pref]
[    1.509539] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    1.509542] pci_bus 0000:01: resource 5 [io  0x0d00-0x3fff]
[    1.509544] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    1.509547] pci_bus 0000:01: resource 7 [mem 0xd4000000-0xdbffffff]
[    1.509550] pci_bus 0000:0a: resource 0 [io  0x3000-0x3fff]
[    1.509552] pci_bus 0000:0a: resource 1 [mem 0xd4200000-0xd42fffff]
[    1.509555] pci_bus 0000:0a: resource 2 [mem 0xd4300000-0xd43fffff pref]
[    1.509571] pci 0000:80:0b.0: PCI bridge to [bus 81-85]
[    1.509728] pci 0000:80:0c.0: PCI bridge to [bus 86-8a]
[    1.509888] pci 0000:80:0d.0: PCI bridge to [bus 8b-8f]
[    1.510043] pci 0000:80:0e.0: PCI bridge to [bus 90-94]
[    1.510197] pci_bus 0000:80: resource 4 [io  0xb000-0xffff]
[    1.510200] pci_bus 0000:80: resource 5 [mem 0x000a0000-0x000bffff]
[    1.510203] pci_bus 0000:80: resource 6 [mem 0xdc000000-0xdc3fffff]
[    1.510759] NET: Registered protocol family 2
[    1.512341] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    1.515754] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.516687] TCP: Hash tables configured (established 524288 bind 65536)
[    1.516958] TCP: reno registered
[    1.517244] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.518401] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.520069] NET: Registered protocol family 1
[    1.520801] RPC: Registered named UNIX socket transport module.
[    1.520963] RPC: Registered udp transport module.
[    1.521110] RPC: Registered tcp transport module.
[    1.521257] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.521435] fixup_debug_start: pci 0000:00:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.521462] fixup_debug_start: pci 0000:00:01.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.521470] fixup_debug_start: pci 0000:00:01.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.521479] fixup_debug_start: pci 0000:00:02.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.521491] fixup_debug_start: pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x660
[    1.521949] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 23
[    1.783723] fixup_debug_start: pci 0000:00:02.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.783745] fixup_debug_start: pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x660
[    1.784161] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
[    1.784489] fixup_debug_start: pci 0000:00:06.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.784499] fixup_debug_start: pci 0000:00:07.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.784508] fixup_debug_start: pci 0000:00:08.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.784518] fixup_debug_start: pci 0000:00:09.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.784526] fixup_debug_start: pci 0000:00:0a.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.784535] fixup_debug_start: pci 0000:00:0b.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.784599] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.784757] fixup_debug_start: pci 0000:00:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.784762] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    1.784912] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.785074] fixup_debug_start: pci 0000:00:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.785082] fixup_debug_start: pci 0000:00:0c.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.785117] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.785272] fixup_debug_start: pci 0000:00:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.785281] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    1.785426] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.785585] fixup_debug_start: pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.785592] fixup_debug_start: pci 0000:00:0d.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.785630] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.785773] fixup_debug_start: pci 0000:00:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.785788] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    1.785946] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.786086] fixup_debug_start: pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.786104] fixup_debug_start: pci 0000:00:0e.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.786155] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.786308] fixup_debug_start: pci 0000:00:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.786313] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    1.786456] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.786607] fixup_debug_start: pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.786627] fixup_debug_start: pci 0000:00:18.0: calling quirk_amd_nb_node+0x0/0x74
[    1.786636] fixup_debug_start: pci 0000:00:18.1: calling quirk_amd_nb_node+0x0/0x74
[    1.786644] fixup_debug_start: pci 0000:00:18.2: calling quirk_amd_nb_node+0x0/0x74
[    1.786653] fixup_debug_start: pci 0000:00:18.3: calling quirk_amd_nb_node+0x0/0x74
[    1.786660] fixup_debug_start: pci 0000:00:18.4: calling quirk_amd_nb_node+0x0/0x74
[    1.786668] fixup_debug_start: pci 0000:00:19.0: calling quirk_amd_nb_node+0x0/0x74
[    1.786676] fixup_debug_start: pci 0000:00:19.1: calling quirk_amd_nb_node+0x0/0x74
[    1.786684] fixup_debug_start: pci 0000:00:19.2: calling quirk_amd_nb_node+0x0/0x74
[    1.786692] fixup_debug_start: pci 0000:00:19.3: calling quirk_amd_nb_node+0x0/0x74
[    1.786700] fixup_debug_start: pci 0000:00:19.4: calling quirk_amd_nb_node+0x0/0x74
[    1.786708] fixup_debug_start: pci 0000:00:1a.0: calling quirk_amd_nb_node+0x0/0x74
[    1.786716] fixup_debug_start: pci 0000:00:1a.1: calling quirk_amd_nb_node+0x0/0x74
[    1.786724] fixup_debug_start: pci 0000:00:1a.2: calling quirk_amd_nb_node+0x0/0x74
[    1.786732] fixup_debug_start: pci 0000:00:1a.3: calling quirk_amd_nb_node+0x0/0x74
[    1.786740] fixup_debug_start: pci 0000:00:1a.4: calling quirk_amd_nb_node+0x0/0x74
[    1.786748] fixup_debug_start: pci 0000:00:1b.0: calling quirk_amd_nb_node+0x0/0x74
[    1.786756] fixup_debug_start: pci 0000:00:1b.1: calling quirk_amd_nb_node+0x0/0x74
[    1.786764] fixup_debug_start: pci 0000:00:1b.2: calling quirk_amd_nb_node+0x0/0x74
[    1.786772] fixup_debug_start: pci 0000:00:1b.3: calling quirk_amd_nb_node+0x0/0x74
[    1.786780] fixup_debug_start: pci 0000:00:1b.4: calling quirk_amd_nb_node+0x0/0x74
[    1.786788] fixup_debug_start: pci 0000:00:1c.0: calling quirk_amd_nb_node+0x0/0x74
[    1.786796] fixup_debug_start: pci 0000:00:1c.1: calling quirk_amd_nb_node+0x0/0x74
[    1.786805] fixup_debug_start: pci 0000:00:1c.2: calling quirk_amd_nb_node+0x0/0x74
[    1.786813] fixup_debug_start: pci 0000:00:1c.3: calling quirk_amd_nb_node+0x0/0x74
[    1.786821] fixup_debug_start: pci 0000:00:1c.4: calling quirk_amd_nb_node+0x0/0x74
[    1.786829] fixup_debug_start: pci 0000:00:1d.0: calling quirk_amd_nb_node+0x0/0x74
[    1.786838] fixup_debug_start: pci 0000:00:1d.1: calling quirk_amd_nb_node+0x0/0x74
[    1.786846] fixup_debug_start: pci 0000:00:1d.2: calling quirk_amd_nb_node+0x0/0x74
[    1.786855] fixup_debug_start: pci 0000:00:1d.3: calling quirk_amd_nb_node+0x0/0x74
[    1.786863] fixup_debug_start: pci 0000:00:1d.4: calling quirk_amd_nb_node+0x0/0x74
[    1.786871] fixup_debug_start: pci 0000:00:1e.0: calling quirk_amd_nb_node+0x0/0x74
[    1.786880] fixup_debug_start: pci 0000:00:1e.1: calling quirk_amd_nb_node+0x0/0x74
[    1.786888] fixup_debug_start: pci 0000:00:1e.2: calling quirk_amd_nb_node+0x0/0x74
[    1.786897] fixup_debug_start: pci 0000:00:1e.3: calling quirk_amd_nb_node+0x0/0x74
[    1.786905] fixup_debug_start: pci 0000:00:1e.4: calling quirk_amd_nb_node+0x0/0x74
[    1.786914] fixup_debug_start: pci 0000:00:1f.0: calling quirk_amd_nb_node+0x0/0x74
[    1.786922] fixup_debug_start: pci 0000:00:1f.1: calling quirk_amd_nb_node+0x0/0x74
[    1.786931] fixup_debug_start: pci 0000:00:1f.2: calling quirk_amd_nb_node+0x0/0x74
[    1.786939] fixup_debug_start: pci 0000:00:1f.3: calling quirk_amd_nb_node+0x0/0x74
[    1.786948] fixup_debug_start: pci 0000:00:1f.4: calling quirk_amd_nb_node+0x0/0x74
[    1.786958] fixup_debug_start: pci 0000:01:06.0: calling quirk_e100_interrupt+0x0/0x143
[    1.786972] fixup_debug_start: pci 0000:01:09.0: calling pci_fixup_video+0x0/0xa6
[    1.786977] pci 0000:01:09.0: Boot video device
[    1.786988] fixup_debug_start: pci 0000:80:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.787014] fixup_debug_start: pci 0000:80:01.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.787023] fixup_debug_start: pci 0000:80:07.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.787032] fixup_debug_start: pci 0000:80:08.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.787042] fixup_debug_start: pci 0000:80:0a.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.787052] fixup_debug_start: pci 0000:80:0b.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.787102] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.787265] fixup_debug_start: pci 0000:80:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.787270] pci 0000:80:0b.0: Found disabled HT MSI Mapping
[    1.787628] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.787780] fixup_debug_start: pci 0000:80:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.787789] fixup_debug_start: pci 0000:80:0c.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.787825] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.787983] fixup_debug_start: pci 0000:80:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.787998] pci 0000:80:0c.0: Found disabled HT MSI Mapping
[    1.788146] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.788297] fixup_debug_start: pci 0000:80:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.788314] fixup_debug_start: pci 0000:80:0d.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.788351] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.788512] fixup_debug_start: pci 0000:80:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.788522] pci 0000:80:0d.0: Found disabled HT MSI Mapping
[    1.788677] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.788826] fixup_debug_start: pci 0000:80:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.788833] fixup_debug_start: pci 0000:80:0e.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.788875] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.789039] fixup_debug_start: pci 0000:80:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.789044] pci 0000:80:0e.0: Found disabled HT MSI Mapping
[    1.789193] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.789352] fixup_debug_start: pci 0000:80:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.789356] PCI: CLS 64 bytes, default 64
[    1.792583] PCI-DMA: Disabling AGP.
[    1.794090] PCI-DMA: aperture base @ d0000000 size 65536 KB
[    1.794243] init_memory_mapping: [mem 0xd0000000-0xd3ffffff]
[    1.794393]  [mem 0xd0000000-0xd3ffffff] page 2M
[    1.794408] PCI-DMA: using GART IOMMU.
[    1.794558] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.804131] Simple Boot Flag at 0x37 set to 0x80
[    1.807113] LVT offset 1 assigned for vector 0x400
[    1.807331] IBS: LVT offset 1 assigned
[    1.807794] perf: AMD IBS detected (0x00000007)
[    1.818106] futex hash table entries: 8192 (order: 7, 524288 bytes)
[    1.855700] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.860055] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.860511] msgmni has been set to 32768
[    1.861228] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.861394] io scheduler noop registered
[    1.861549] io scheduler deadline registered
[    1.861873] io scheduler cfq registered (default)
[    1.862511] __pci_set_master: pcieport 0000:00:0b.0: enabling bus mastering
[    1.862559] pcieport 0000:00:0b.0: irq 40 for MSI/MSI-X
[    1.862775] __pci_set_master: pcieport 0000:00:0c.0: enabling bus mastering
[    1.862829] pcieport 0000:00:0c.0: irq 41 for MSI/MSI-X
[    1.863108] pcieport 0000:00:0d.0: irq 42 for MSI/MSI-X
[    1.863269] pcieport 0000:00:0e.0: irq 43 for MSI/MSI-X
[    1.863653] __pci_set_master: pcieport 0000:80:0b.0: enabling bus mastering
[    1.863706] pcieport 0000:80:0b.0: irq 44 for MSI/MSI-X
[    1.863882] __pci_set_master: pcieport 0000:80:0c.0: enabling bus mastering
[    1.863902] pcieport 0000:80:0c.0: irq 45 for MSI/MSI-X
[    1.864038] pcieport 0000:80:0d.0: irq 46 for MSI/MSI-X
[    1.864194] pcieport 0000:80:0e.0: irq 47 for MSI/MSI-X
[    1.907648] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.928268] 00:01: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.948884] 00:02: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    1.950732] Linux agpgart interface v0.103
[    1.951250] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.951442] ACPI: Power Button [PWRB]
[    1.951955] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.952116] ACPI: Power Button [PWRF]
[    1.952497] ACPI: acpi_idle registered with cpuidle
[    1.957370] Floppy drive(s): fd0 is 1.44M
[    1.961453] brd: module loaded
[    1.963955] loop: module loaded
[    1.965077] sata_nv 0000:00:07.0: version 3.5
[    1.965580] ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
[    1.966666] scsi0 : sata_nv
[    1.967285] scsi1 : sata_nv
[    1.967781] ata1: SATA max UDMA/133 cmd 0x1440 ctl 0x1434 bmdma 0x1410 irq 21
[    1.967936] ata2: SATA max UDMA/133 cmd 0x1438 ctl 0x1430 bmdma 0x1418 irq 21
[    1.968454] ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 20
[    1.969691] scsi2 : sata_nv
[    1.970145] scsi3 : sata_nv
[    1.970492] ata3: SATA max UDMA/133 cmd 0x1458 ctl 0x144c bmdma 0x1420 irq 20
[    1.970645] ata4: SATA max UDMA/133 cmd 0x1450 ctl 0x1448 bmdma 0x1428 irq 20
[    1.971197] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 19
[    1.972448] scsi4 : sata_nv
[    1.972875] scsi5 : sata_nv
[    1.973172] ata5: SATA max UDMA/133 cmd 0xb030 ctl 0xb024 bmdma 0xb000 irq 19
[    1.973341] ata6: SATA max UDMA/133 cmd 0xb028 ctl 0xb020 bmdma 0xb008 irq 19
[    1.973723] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 18
[    1.974669] scsi6 : sata_nv
[    1.975223] scsi7 : sata_nv
[    1.975774] FDC 0 is a post-1991 82077
[    1.975919] ata7: SATA max UDMA/133 cmd 0xb048 ctl 0xb03c bmdma 0xb010 irq 18
[    1.976096] ata8: SATA max UDMA/133 cmd 0xb040 ctl 0xb038 bmdma 0xb018 irq 18
[    1.976430] pata_amd 0000:00:06.0: version 0.4.1
[    1.978144] scsi8 : pata_amd
[    1.978596] scsi9 : pata_amd
[    1.978901] ata9: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1400 irq 14
[    1.979044] ata10: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x1408 irq 15
[    1.979454] tun: Universal TUN/TAP device driver, 1.6
[    1.979783] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.980316] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.980474] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    2.436214] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.436222] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.440209] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.444219] ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.444832] ata3.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.444837] ata1.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.444841] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.445357] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.448836] ata5.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.449045] ata5.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.452738] ata7.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.452899] ata7.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.460779] ata3.00: configured for UDMA/133
[    2.460782] ata1.00: configured for UDMA/133
[    2.461054] scsi 0:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    2.461469] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.461834] sd 0:0:0:0: [sda] Write Protect is off
[    2.461855] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.462202] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.462275] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.462748] e1000 0000:01:06.0 eth0: (PCI:33MHz:32-bit) 00:e0:81:b0:4d:69
[    2.462904] e1000 0000:01:06.0 eth0: Intel(R) PRO/1000 Network Connection
[    2.463190] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    2.463689] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
[    2.464779] ata5.00: configured for UDMA/133
[    2.468755] ata7.00: configured for UDMA/133
[    2.469921]  sda: sda1 sda2 sda3
[    2.470860] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.804577] tsc: Refined TSC clocksource calibration: 1908.795 MHz
[    2.928699] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.937203] ata2.00: ATA-6: ST31000340NS, SN04, max UDMA/133
[    2.937356] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.957250] ata2.00: configured for UDMA/133
[    2.957531] scsi 1:0:0:0: Direct-Access     ATA      ST31000340NS     SN04 PQ: 0 ANSI: 5
[    2.958119] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.958241] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.958515] scsi 2:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    2.958567] sd 1:0:0:0: [sdb] Write Protect is off
[    2.958570] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.958627] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.959396] sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.959561] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    2.959680] sd 2:0:0:0: [sdc] Write Protect is off
[    2.959683] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.959757] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.974005]  sdc: unknown partition table
[    2.974638] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.982377]  sdb: unknown partition table
[    2.982979] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.989477] forcedeth 0000:00:0a.0: ifname eth1, PHY OUI 0x5043 @ 1, addr 00:e0:81:b0:4d:67
[    2.989670] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[    2.990090] ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 17
[    3.425192] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.433734] ata4.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    3.433885] ata4.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.449766] ata4.00: configured for UDMA/133
[    3.450071] scsi 3:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.450615] sd 3:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.450715] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    3.451049] sd 3:0:0:0: [sdd] Write Protect is off
[    3.451108] scsi 4:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.451342] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    3.451401] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.451587] sd 4:0:0:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.451630] sd 4:0:0:0: [sde] Write Protect is off
[    3.451633] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    3.451652] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.451720] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    3.464721]  sde: sde1 sde2 sde3
[    3.465803] sd 4:0:0:0: [sde] Attached SCSI disk
[    3.471109]  sdd: unknown partition table
[    3.471579] sd 3:0:0:0: [sdd] Attached SCSI disk
[    3.513925] forcedeth 0000:80:0a.0: ifname eth2, PHY OUI 0x5043 @ 1, addr 00:e0:81:b0:4d:68
[    3.514158] forcedeth 0000:80:0a.0: highdma csum gbit lnktim desc-v3
[    3.514919] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.515112] ehci-pci: EHCI PCI platform driver
[    3.515377] __pci_set_master: ehci-pci 0000:00:02.1: enabling bus mastering
[    3.515426] ehci-pci 0000:00:02.1: EHCI Host Controller
[    3.515719] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus number 1
[    3.515884] ehci-pci 0000:00:02.1: debug port 1
[    3.516085] ehci-pci 0000:00:02.1: cache line size of 64 is not supported
[    3.516124] ehci-pci 0000:00:02.1: irq 22, io mem 0xd4001000
[    3.525289] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    3.526140] hub 1-0:1.0: USB hub found
[    3.526314] hub 1-0:1.0: 10 ports detected
[    3.527150] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.527311] ohci-pci: OHCI PCI platform driver
[    3.527585] __pci_set_master: ohci-pci 0000:00:02.0: enabling bus mastering
[    3.527590] ohci-pci 0000:00:02.0: OHCI PCI host controller
[    3.527882] ohci-pci 0000:00:02.0: new USB bus registered, assigned bus number 2
[    3.528111] ohci-pci 0000:00:02.0: irq 23, io mem 0xd4000000
[    3.583776] hub 2-0:1.0: USB hub found
[    3.583935] hub 2-0:1.0: 10 ports detected
[    3.584416] uhci_hcd: USB Universal Host Controller Interface driver
[    3.584864] usbcore: registered new interface driver usblp
[    3.585112] usbcore: registered new interface driver usb-storage
[    3.585635] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.588680] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.588866] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.589556] mousedev: PS/2 mouse device common for all mice
[    3.590718] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    3.592119] usbcore: registered new interface driver usbhid
[    3.592259] usbhid: USB HID core driver
[    3.592503] oprofile: AMD IBS detected (0x00000007)
[    3.592653] oprofile: using NMI interrupt.
[    3.592832] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.593774] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.594029] arp_tables: (C) 2002 David S. Miller
[    3.594183] TCP: cubic registered
[    3.594333] NET: Registered protocol family 17
[    3.598896] registered taskstats version 1
[    3.600053] console [netcon0] enabled
[    3.600201] netconsole: network logging started
[    3.600783] acpi-cpufreq: overriding BIOS provided _PSD data
[    3.651880] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.805792] Switched to clocksource tsc
[    3.917525] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.926109] ata6.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    3.926269] ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.942129] ata6.00: configured for UDMA/133
[    3.942491] scsi 5:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.943013] sd 5:0:0:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.943184] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    3.943301] sd 5:0:0:0: [sdf] Write Protect is off
[    3.943304] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    3.943356] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.943998] scsi 6:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.944534] sd 6:0:0:0: [sdg] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.944671] sd 6:0:0:0: Attached scsi generic sg6 type 0
[    3.944974] sd 6:0:0:0: [sdg] Write Protect is off
[    3.945168] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    3.945219] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.964285]  sdf: sdf1 sdf2 sdf3
[    3.965186] sd 5:0:0:0: [sdf] Attached SCSI disk
[    3.967335]  sdg: unknown partition table
[    3.967855] sd 6:0:0:0: [sdg] Attached SCSI disk
[    4.201833] usb 2-1: new low-speed USB device number 2 using ohci-pci
[    4.219974] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input4
[    4.410030] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.434324] ata8.00: ATA-7: Hitachi HUA721010KLA330, GKAOA70M, max UDMA/133
[    4.434477] ata8.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.450330] ata8.00: configured for UDMA/133
[    4.450605] scsi 7:0:0:0: Direct-Access     ATA      Hitachi HUA72101 GKAO PQ: 0 ANSI: 5
[    4.451128] sd 7:0:0:0: [sdh] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    4.451282] sd 7:0:0:0: Attached scsi generic sg7 type 0
[    4.451499] sd 7:0:0:0: [sdh] Write Protect is off
[    4.451686] sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    4.451712] sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.465417]  sdh: unknown partition table
[    4.465827] sd 7:0:0:0: [sdh] Attached SCSI disk
[    4.638580] ata10.00: ATAPI: TEAC DV-516GB, HT13, max UDMA/33
[    4.638790] ata10: nv_mode_filter: 0x739f&0x739f->0x739f, BIOS=0x7000 (0xc000) ACPI=0x701f (60:600:0x13)
[    4.678538] ata10.00: configured for UDMA/33
[    4.680623] scsi 9:0:0:0: CD-ROM            TEAC     DV-516GB         HT13 PQ: 0 ANSI: 5
[    4.687617] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    4.687765] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.688183] sr 9:0:0:0: Attached scsi CD-ROM sr0
[    4.688400] sr 9:0:0:0: Attached scsi generic sg8 type 5
[    4.697728] EXT3-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    4.706048] EXT2-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    4.727325] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    4.727484] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    4.744410] devtmpfs: mounted
[    4.745635] Freeing unused kernel memory: 932K (ffffffff81760000 - ffffffff81849000)
[    5.666481] random: nonblocking pool is initialized
[    5.901696] hid-generic 0003:051D:0002.0001: device has no listeners, quitting
[    6.381042] systemd-udevd[1977]: starting version 216
[    6.831701] kvm: Nested Virtualization enabled
[    6.831727] kvm: Nested Paging enabled
[    6.833157] systemd-udevd[2065]: renamed network interface eth1 to enp0s10
[    6.848841] Fusion MPT base driver 3.04.20
[    6.848847] Copyright (c) 1999-2008 LSI Corporation
[    6.868611] systemd-udevd[2004]: renamed network interface eth2 to enp128s10
[    6.870183] Fusion MPT FC Host driver 3.04.20
[    6.870572] mptbase: ioc0: Initiating bringup
[    6.916601] systemd-udevd[2011]: renamed network interface eth0 to enp1s6
[    7.441048] ioc0: LSIFC949E: Capabilities={Initiator,Target,LAN}
[    8.434532] scsi10 : ioc0: LSIFC949E, FwRev=01031400h, Ports=1, MaxQ=1023, IRQ=17
[    8.435153] mptfc: ioc0: FC Link Established, Speed = 4 Gbps
[    8.435973] scsi 10:0:0:0: Direct-Access     ES-6600S Backup           R001 PQ: 0 ANSI: 5
[    8.436292] sd 10:0:0:0: Attached scsi generic sg9 type 0
[    8.436303] sd 10:0:0:0: [sdi] 3906249216 512-byte logical blocks: (1.99 TB/1.81 TiB)
[    8.436541] sd 10:0:0:0: [sdi] Write Protect is off
[    8.436546] sd 10:0:0:0: [sdi] Mode Sense: bf 00 00 08
[    8.436659] sd 10:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.436704] scsi 10:0:0:1: Direct-Access     ES-6600S Data             R001 PQ: 0 ANSI: 5
[    8.436720] mptscsih: ioc0: [10:0:0:0] FCP_ResponseInfo=02000000h
[    8.437110] sd 10:0:0:1: [sdj] 15624996864 512-byte logical blocks: (7.99 TB/7.27 TiB)
[    8.437163] sd 10:0:0:1: Attached scsi generic sg10 type 0
[    8.437324] sd 10:0:0:1: [sdj] Write Protect is off
[    8.437328] sd 10:0:0:1: [sdj] Mode Sense: bf 00 00 08
[    8.437449] sd 10:0:0:1: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.437493] scsi 10:0:0:2: Direct-Access     ES-6600S Systems          R001 PQ: 0 ANSI: 5
[    8.437506] mptscsih: ioc0: [10:0:0:1] FCP_ResponseInfo=02000000h
[    8.437841]  sdi: sdi1
[    8.437974] sd 10:0:0:2: [sdk] 7812498432 512-byte logical blocks: (3.99 TB/3.63 TiB)
[    8.438205] sd 10:0:0:2: [sdk] Write Protect is off
[    8.438208] sd 10:0:0:2: [sdk] Mode Sense: bf 00 00 08
[    8.438223] sd 10:0:0:2: Attached scsi generic sg11 type 0
[    8.438329] sd 10:0:0:2: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.438395] mptscsih: ioc0: [10:0:0:2] FCP_ResponseInfo=02000000h
[    8.438545]  sdj: unknown partition table
[    8.439072] sd 10:0:0:0: [sdi] Attached SCSI disk
[    8.439644] sd 10:0:0:1: [sdj] Attached SCSI disk
[    8.439706]  sdk: unknown partition table
[    8.440417] sd 10:0:0:2: [sdk] Attached SCSI disk
[    9.131267] EXT4-fs (sda2): re-mounted. Opts: (null)
[   11.076719] end_request: I/O error, dev fd0, sector 0
[   11.076728] floppy: error -5 while reading block 0
[   11.100725] end_request: I/O error, dev fd0, sector 0
[   11.100736] floppy: error -5 while reading block 0
[   11.278014] bio: create slab <bio-1> at 1
[   12.073679] Bridge firewalling registered
[   12.096561] device enp1s6 entered promiscuous mode
[   12.106868] device br0 entered promiscuous mode
[   12.119426] e1000: enp1s6 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   12.119556] br0: port 1(enp1s6) entered forwarding state
[   12.119575] br0: port 1(enp1s6) entered forwarding state

--=-=-=--
