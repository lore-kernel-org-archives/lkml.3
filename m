Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaIMTms (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 15:42:48 -0400
Received: from services.gouders.net ([141.101.32.176]:54199 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaIMTmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 15:42:45 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <gh8ulnn9yo.fsf@quad.gouders.net> (Dirk Gouders's message of
	"Sat, 13 Sep 2014 11:30:55 +0200")
References: <ghvbotd8es.fsf@quad.gouders.net>
	<ghzje5f5zt.fsf@lena.gouders.net> <ghbnqkeh9k.fsf@quad.gouders.net>
	<CAE9FiQXQesrDMqf1b6ZhHdmY_wEEUrOEvNO4N_d6WtaNMGNLww@mail.gmail.com>
	<gh4mwcef0r.fsf@quad.gouders.net>
	<CAE9FiQWgioBeVmfWCaE38BrkjbWKaS+_FYYdmdd+7X8fpeEgnQ@mail.gmail.com>
	<ghoaukcx6b.fsf@quad.gouders.net>
	<CAE9FiQUk-sAHnjfBvNeHQWibJRqbPE1V0UtDtARtwxmS=7aQrw@mail.gmail.com>
	<ghk358crbe.fsf@quad.gouders.net>
	<CAE9FiQUeP84585-4b+Y6WBVD3zqOi7ch_OXytsTmKEz9AyZ3Vg@mail.gmail.com>
	<20140913040716.GA28080@google.com> <gh8ulnn9yo.fsf@quad.gouders.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Sat, 13 Sep 2014 21:41:34 +0200
Message-ID: <gh8uln71g1.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk Gouders <dirk@gouders.net> writes:

> Bjorn Helgaas <bhelgaas@google.com> writes:
>
>> I want to fix this regression before v3.17.  Dirk, can you test the
>> following patch on top of v3.17-rc2?  I'm hoping you can try this on your
>> test machine in conjunction with your acpi_pci_root_add() and
>> pci_scan_device() patches.  If I understand correctly,  you were able to
>> reproduce the FC adapter not showing up, and if you can verify that it does
>> show with those patches + this revert, I think that's good enough for now.
>
> I tried this patch on the test machine but after rebooting I lost remote
> access -- details will have to wait until tonight.
>
> Independent of the result of this test I planned to go to the office,
> this evening to also do this test on the VX50 and to also try Yinghai's
> suggestion to reset the PCIe link on it.  I'd like to see if the
> behavior of the VX50 differs from that of the test machine.
>
> Probably obvious but did I undestand correctly that Yinghai's patches + 
>
> echo 1 > /sys/bus/.../pcie_link_disable
> echo 0 > /sys/bus/.../pcie_link_disable
>
> is exactly identical to this?
>
> setpci -s ... 0xc0.b=0x18
> setpci -s ... 0xc0.b=0x08
>
> Please let me know if there is anything else you want me to test on the
> VX50.

So, I did some tests on the VX50 which probably wasn't the worst idea,
because it behaves different than the test machine.

Summary:

1) Bjorn's back pocket patch works on the VX50.

   On the test machine it causes a trace, mount_root has to do with
   it.  I tried to use netconsole but it complained the interface were
   not ready.

2) Reset with setpci as above did not work on the VX50.

3) Reset with Bjorn's commands

   DEV=00:0e.0
   setpci -s$DEV BRIDGE_CONTROL.W=0x0040
   sleep 1
   setpci -s$DEV BRIDGE_CONTROL.W=0x0000
   sleep 1
   echo 1 > /sys/bus/pci/rescan

   let the FC adapter appear but there are errors that I cannot really
   interpret.

4) Reset with Yinghai's patches and 

   echo 1 > /sys/bus/pci/devices/0000\:00\:0e.0/pcie_link_disable
   echo 0 > /sys/bus/pci/devices/0000\:00\:0e.0/pcie_link_disable
   echo 1 > /sys/bus/pci/rescan

   gives a similar resut to 3).

I will apply dmesg and lspci output at the end, hoping the numbering
above allows proper assignment.

Dirk

------------------------------------------------------------------------
1) lspci and dmesg with back pocket patch

-+-[0000:80]-+-00.0  NVIDIA Corporation CK804 Memory Controller
 |           +-01.0  NVIDIA Corporation CK804 Memory Controller
 |           +-07.0  NVIDIA Corporation CK804 Serial ATA Controller
 |           +-08.0  NVIDIA Corporation CK804 Serial ATA Controller
 |           +-0a.0  NVIDIA Corporation CK804 Ethernet Controller
 |           +-0b.0-[81-85]--
 |           +-0c.0-[86-8a]--
 |           +-0d.0-[8b-8f]--
 |           \-0e.0-[90-94]--
 \-[0000:00]-+-00.0  NVIDIA Corporation CK804 Memory Controller
             +-01.0  NVIDIA Corporation CK804 ISA Bridge
             +-01.1  NVIDIA Corporation CK804 SMBus
             +-02.0  NVIDIA Corporation CK804 USB Controller
             +-02.1  NVIDIA Corporation CK804 USB Controller
             +-06.0  NVIDIA Corporation CK804 IDE
             +-07.0  NVIDIA Corporation CK804 Serial ATA Controller
             +-08.0  NVIDIA Corporation CK804 Serial ATA Controller
             +-09.0-[01]--+-06.0  Intel Corporation 82541GI Gigabit Ethernet Controller
             |            \-09.0  XGI Technology Inc. (eXtreme Graphics Innovation) Z7/Z9 (XG20 core)
             +-0a.0  NVIDIA Corporation CK804 Ethernet Controller
             +-0b.0-[02]--
             +-0c.0-[03]--
             +-0d.0-[05]--
             +-0e.0-[0a]----00.0  LSI Logic / Symbios Logic FC949ES Fibre Channel Adapter
             +-18.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-18.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-18.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-18.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-18.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-19.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-19.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-19.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-19.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-19.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1a.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1a.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1a.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1a.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1a.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1b.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1b.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1b.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1b.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1b.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1c.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1c.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1c.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1c.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1c.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1d.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1d.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1d.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1d.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1d.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1e.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1e.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1e.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1e.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1e.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1f.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1f.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1f.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1f.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             \-1f.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control

[    0.000000] Linux version 3.17.0-rc4-00346-g186cec3-dirty (root@quad) (gcc version 4.7.3 (Gentoo 4.7.3-r1 p1.4, pie-0.5.5) ) #21 SMP Sat Sep 13 20:20:40 CEST 2014
[    0.000000] Command line: root=/dev/sda2 dyndbg="file drivers/pci/* +pf" log_buf_len=10M
[    0.000000] tseg: 00cfc00000
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
[    0.000000] AGP: No AGP bridge found
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
[    0.000000] BRK [0x01937000, 0x01937fff] PGTABLE
[    0.000000] BRK [0x01938000, 0x01938fff] PGTABLE
[    0.000000] BRK [0x01939000, 0x01939fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xa2fe00000-0xa2fffffff]
[    0.000000]  [mem 0xa2fe00000-0xa2fffffff] page 2M
[    0.000000] BRK [0x0193a000, 0x0193afff] PGTABLE
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
[    0.000000] BRK [0x0193b000, 0x0193bfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x9ffffffff]
[    0.000000]  [mem 0x100000000-0x9ffffffff] page 1G
[    0.000000] log_buf_len: 16777216 bytes
[    0.000000] early log buf free: 257840(98%)
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F77F0 000014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 0x000000007FFE0AAB 000038 (v01 PTLTD    RSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 0x000000007FFE4C98 000074 (v01 NVIDIA CK8S     06040000 PTL_ 000F4240)
[    0.000000] ACPI: DSDT 0x000000007FFE0AE3 0041B5 (v01 NVIDIA CK8      06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 0x000000007FFEAFC0 000040
[    0.000000] ACPI: SSDT 0x000000007FFE4D0C 005084 (v01 AMD    POWERNOW 06040000 AMD  00000001)
[    0.000000] ACPI: SPCR 0x000000007FFE9D90 000050 (v01 PTLTD  $UCRTBL$ 06040000 PTL  00000001)
[    0.000000] ACPI: APIC 0x000000007FFE9DE0 0001F8 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 0x000000007FFE9FD8 000028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
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
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88012fc00000 s79296 r8192 d23104 u524288
[    0.000000] pcpu-alloc: s79296 r8192 d23104 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 [1] 04 05 06 07 
[    0.000000] pcpu-alloc: [2] 08 09 10 11 [3] 12 13 14 15 
[    0.000000] pcpu-alloc: [4] 16 17 18 19 [5] 20 21 22 23 
[    0.000000] pcpu-alloc: [6] 24 25 26 27 [7] 28 29 30 31 
[    0.000000] Built 8 zonelists in Zone order, mobility grouping on.  Total pages: 10341233
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda2 dyndbg="file drivers/pci/* +pf" log_buf_len=10M
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] AGP: Node 0: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] AGP: Node 1: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] AGP: Node 2: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] AGP: Node 3: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] AGP: Node 4: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] AGP: Node 5: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] AGP: Node 6: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] AGP: Node 7: aperture [bus addr 0xd0000000-0xd3ffffff] (64MB)
[    0.000000] Memory: 41266556K/41938400K available (4485K kernel code, 694K rwdata, 2500K rodata, 936K init, 776K bss, 671844K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:680 0
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: PIT calibration matches PMTIMER. 1 loops
[    0.000000] tsc: Detected 1908.775 MHz processor
[    0.000017] Calibrating delay loop (skipped), value calculated using timer frequency.. 3817.55 BogoMIPS (lpj=7635100)
[    0.000317] pid_max: default: 32768 minimum: 301
[    0.000565] ACPI: Core revision 20140724
[    0.008550] ACPI: All ACPI Tables successfully acquired
[    0.017392] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.067262] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.091507] Mount-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.091848] Mountpoint-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.094117] CPU: Physical Processor ID: 0
[    0.094316] CPU: Processor Core ID: 0
[    0.094466] mce: CPU supports 6 MCE banks
[    0.094621] LVT offset 0 assigned for vector 0xf9
[    0.094777] process: using AMD E400 aware idle routine
[    0.094930] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64, 1GB 0
[    0.095389] Freeing SMP alternatives memory: 20K (ffffffff8186e000 - ffffffff81873000)
[    0.095746] Switched APIC routing to physical flat.
[    0.096365] ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.136186] smpboot: CPU0: Quad-Core AMD Opteron(tm) Processor 8347 HE (fam: 10, model: 02, stepping: 03)
[    0.242242] Performance Events: AMD PMU driver.
[    0.242454] ... version:                0
[    0.242604] ... bit width:              48
[    0.242738] ... generic registers:      4
[    0.242883] ... value mask:             0000ffffffffffff
[    0.243030] ... max period:             00007fffffffffff
[    0.243177] ... fixed-purpose events:   0
[    0.243311] ... event mask:             000000000000000f
[    0.245659] x86: Booting SMP configuration:
[    0.245831] .... node  #0, CPUs:        #1  #2  #3
[    0.286465] .... node  #1, CPUs:    #4  #5  #6  #7
[    0.435176] .... node  #2, CPUs:    #8  #9 #10 #11
[    0.589003] .... node  #3, CPUs:   #12 #13 #14 #15
[    0.738981] .... node  #4, CPUs:   #16 #17 #18 #19
[    0.890916] .... node  #5, CPUs:   #20 #21 #22 #23
[    1.042696] .... node  #6, CPUs:   #24 #25 #26 #27
[    1.194565] .... node  #7, CPUs:   #28 #29 #30 #31
[    1.345951] x86: Booted up 8 nodes, 32 CPUs
[    1.346259] smpboot: Total of 32 processors activated (122183.78 BogoMIPS)
[    1.368246] devtmpfs: initialized
[    1.369104] PM: Registering ACPI NVS region [mem 0x7ffea000-0x7fffffff] (90112 bytes)
[    1.370659] NET: Registered protocol family 16
[    1.371198] cpuidle: using governor ladder
[    1.371346] cpuidle: using governor menu
[    1.371519] node 0 link 1: io port [1000, 3fff]
[    1.371523] node 1 link 1: io port [b000, bfff]
[    1.371525] node 1 link 1: io port [9000, 9fff]
[    1.371528] TOM: 00000000d0000000 aka 3328M
[    1.371676] node 0 link 1: mmio [d4000000, dbffffff]
[    1.371680] node 1 link 1: mmio [dc000000, dc3fffff]
[    1.371682] node 0 link 1: mmio [a0000, bffff]
[    1.371685] node 0 link 1: mmio [e0000000, e7ffffff]
[    1.371688] node 1 link 1: mmio [e8000000, efffffff]
[    1.371690] TOM2: 0000000a30000000 aka 41728M
[    1.371840] bus: [bus 00-7f] on node 0 link 1
[    1.371841] bus: 00 [io  0x0000-0x8fff]
[    1.371843] bus: 00 [io  0xc000-0xffff]
[    1.371844] bus: 00 [io  0xa000-0xafff]
[    1.371846] bus: 00 [mem 0xd0000000-0xdbffffff]
[    1.371847] bus: 00 [mem 0x000a0000-0x000bffff]
[    1.371848] bus: 00 [mem 0xdc400000-0xe7ffffff]
[    1.371849] bus: 00 [mem 0xf0000000-0xffffffff]
[    1.371851] bus: 00 [mem 0xa30000000-0xfcffffffff]
[    1.371852] bus: [bus 80-ff] on node 1 link 1
[    1.371854] bus: 80 [io  0xb000-0xbfff]
[    1.371855] bus: 80 [io  0x9000-0x9fff]
[    1.371856] bus: 80 [mem 0xdc000000-0xdc3fffff]
[    1.371857] bus: 80 [mem 0xe8000000-0xefffffff]
[    1.372036] ACPI: bus type PCI registered
[    1.372326] PCI: Using configuration type 1 for base access
[    1.372475] PCI: Using configuration type 1 for extended access
[    1.390837] ACPI: Added _OSI(Module Device)
[    1.391017] ACPI: Added _OSI(Processor Device)
[    1.391165] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.391313] ACPI: Added _OSI(Processor Aggregator Device)
[    1.407617] ACPI: Interpreter enabled
[    1.407822] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    1.408165] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140724/hwxface-580)
[    1.408509] ACPI: (supports S0 S1 S4 S5)
[    1.408658] ACPI: Using IOAPIC for interrupt routing
[    1.408882] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.421221] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-07])
[    1.421452] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.421620] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.422134] acpi PNP0A03:00: ignoring host bridge window [mem 0x000c0000-0x000dffff] (conflicts with reserved [mem 0x000ca000-0x000fffff])
[    1.422481] PCI host bridge to bus 0000:00
[    1.422630] pci_bus 0000:00: root bus resource [bus 00-07]
[    1.422783] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.422934] pci_bus 0000:00: root bus resource [io  0x0d00-0x3fff]
[    1.423075] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.423226] pci_bus 0000:00: root bus resource [mem 0xd4000000-0xdbffffff]
[    1.423390] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[    1.423409] pci 0000:00:00.0: [10de:005e] type 00 class 0x058000
[    1.423681] pci 0000:00:01.0: [10de:0051] type 00 class 0x060100
[    1.423714] fixup_debug_start: pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xaa
[    1.423716] HPET not enabled in BIOS. You might try hpet=force boot option
[    1.424015] pci 0000:00:01.1: [10de:0052] type 00 class 0x0c0500
[    1.424024] pci 0000:00:01.1: reg 0x10: [io  0x0000-0x001f]
[    1.424037] pci 0000:00:01.1: reg 0x20: [io  0xa000-0xa03f]
[    1.424042] pci 0000:00:01.1: reg 0x24: [io  0xa040-0xa07f]
[    1.424085] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    1.424090] pci_pme_active: pci 0000:00:01.1: PME# disabled
[    1.424244] pci 0000:00:02.0: [10de:005a] type 00 class 0x0c0310
[    1.424252] pci 0000:00:02.0: reg 0x10: [mem 0xd4000000-0xd4000fff]
[    1.424287] pci 0000:00:02.0: supports D1 D2
[    1.424298] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.424304] pci_pme_active: pci 0000:00:02.0: PME# disabled
[    1.424396] pci 0000:00:02.0: System wakeup disabled by ACPI
[    1.424627] pci 0000:00:02.1: [10de:005b] type 00 class 0x0c0320
[    1.424636] pci 0000:00:02.1: reg 0x10: [mem 0xd4001000-0xd40010ff]
[    1.424679] pci 0000:00:02.1: supports D1 D2
[    1.424688] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.424692] pci_pme_active: pci 0000:00:02.1: PME# disabled
[    1.424804] pci 0000:00:02.1: System wakeup disabled by ACPI
[    1.425037] pci 0000:00:06.0: [10de:0053] type 00 class 0x01018a
[    1.425055] pci 0000:00:06.0: reg 0x20: [io  0x1400-0x140f]
[    1.425063] pci 0000:00:06.0: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    1.425216] pci 0000:00:06.0: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    1.425382] pci 0000:00:06.0: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    1.425536] pci 0000:00:06.0: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    1.425862] pci 0000:00:07.0: [10de:0054] type 00 class 0x010185
[    1.425870] pci 0000:00:07.0: reg 0x10: [io  0x1440-0x1447]
[    1.425875] pci 0000:00:07.0: reg 0x14: [io  0x1434-0x1437]
[    1.425880] pci 0000:00:07.0: reg 0x18: [io  0x1438-0x143f]
[    1.425884] pci 0000:00:07.0: reg 0x1c: [io  0x1430-0x1433]
[    1.425889] pci 0000:00:07.0: reg 0x20: [io  0x1410-0x141f]
[    1.425894] pci 0000:00:07.0: reg 0x24: [mem 0xd4002000-0xd4002fff]
[    1.426113] pci 0000:00:08.0: [10de:0055] type 00 class 0x010185
[    1.426120] pci 0000:00:08.0: reg 0x10: [io  0x1458-0x145f]
[    1.426125] pci 0000:00:08.0: reg 0x14: [io  0x144c-0x144f]
[    1.426130] pci 0000:00:08.0: reg 0x18: [io  0x1450-0x1457]
[    1.426134] pci 0000:00:08.0: reg 0x1c: [io  0x1448-0x144b]
[    1.426139] pci 0000:00:08.0: reg 0x20: [io  0x1420-0x142f]
[    1.426143] pci 0000:00:08.0: reg 0x24: [mem 0xd4003000-0xd4003fff]
[    1.426345] pci 0000:00:09.0: [10de:005c] type 01 class 0x060401
[    1.426437] pci 0000:00:09.0: System wakeup disabled by ACPI
[    1.426661] pci 0000:00:0a.0: [10de:0057] type 00 class 0x068000
[    1.426669] pci 0000:00:0a.0: reg 0x10: [mem 0xd4004000-0xd4004fff]
[    1.426674] pci 0000:00:0a.0: reg 0x14: [io  0x1460-0x1467]
[    1.426707] pci 0000:00:0a.0: supports D1 D2
[    1.426709] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.426720] pci_pme_active: pci 0000:00:0a.0: PME# disabled
[    1.426845] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    1.427069] pci 0000:00:0b.0: [10de:005d] type 01 class 0x060400
[    1.427104] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.427109] pci_pme_active: pci 0000:00:0b.0: PME# disabled
[    1.427266] pci 0000:00:0c.0: [10de:005d] type 01 class 0x060400
[    1.427297] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.427303] pci_pme_active: pci 0000:00:0c.0: PME# disabled
[    1.427462] pci 0000:00:0d.0: [10de:005d] type 01 class 0x060400
[    1.427495] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.427498] pci_pme_active: pci 0000:00:0d.0: PME# disabled
[    1.427659] pci 0000:00:0e.0: [10de:005d] type 01 class 0x060400
[    1.427691] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.427694] pci_pme_active: pci 0000:00:0e.0: PME# disabled
[    1.427853] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    1.427862] fixup_debug_start: pci 0000:00:18.0: calling quirk_mmio_always_on+0x0/0x5
[    1.428026] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    1.428031] fixup_debug_start: pci 0000:00:18.1: calling quirk_mmio_always_on+0x0/0x5
[    1.428179] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    1.428184] fixup_debug_start: pci 0000:00:18.2: calling quirk_mmio_always_on+0x0/0x5
[    1.428328] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    1.428333] fixup_debug_start: pci 0000:00:18.3: calling quirk_mmio_always_on+0x0/0x5
[    1.428472] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    1.428477] fixup_debug_start: pci 0000:00:18.4: calling quirk_mmio_always_on+0x0/0x5
[    1.428617] pci 0000:00:19.0: [1022:1200] type 00 class 0x060000
[    1.428622] fixup_debug_start: pci 0000:00:19.0: calling quirk_mmio_always_on+0x0/0x5
[    1.428772] pci 0000:00:19.1: [1022:1201] type 00 class 0x060000
[    1.428777] fixup_debug_start: pci 0000:00:19.1: calling quirk_mmio_always_on+0x0/0x5
[    1.428913] pci 0000:00:19.2: [1022:1202] type 00 class 0x060000
[    1.428917] fixup_debug_start: pci 0000:00:19.2: calling quirk_mmio_always_on+0x0/0x5
[    1.429057] pci 0000:00:19.3: [1022:1203] type 00 class 0x060000
[    1.429062] fixup_debug_start: pci 0000:00:19.3: calling quirk_mmio_always_on+0x0/0x5
[    1.429208] pci 0000:00:19.4: [1022:1204] type 00 class 0x060000
[    1.429213] fixup_debug_start: pci 0000:00:19.4: calling quirk_mmio_always_on+0x0/0x5
[    1.429360] pci 0000:00:1a.0: [1022:1200] type 00 class 0x060000
[    1.429366] fixup_debug_start: pci 0000:00:1a.0: calling quirk_mmio_always_on+0x0/0x5
[    1.429515] pci 0000:00:1a.1: [1022:1201] type 00 class 0x060000
[    1.429520] fixup_debug_start: pci 0000:00:1a.1: calling quirk_mmio_always_on+0x0/0x5
[    1.429658] pci 0000:00:1a.2: [1022:1202] type 00 class 0x060000
[    1.429663] fixup_debug_start: pci 0000:00:1a.2: calling quirk_mmio_always_on+0x0/0x5
[    1.429803] pci 0000:00:1a.3: [1022:1203] type 00 class 0x060000
[    1.429808] fixup_debug_start: pci 0000:00:1a.3: calling quirk_mmio_always_on+0x0/0x5
[    1.429950] pci 0000:00:1a.4: [1022:1204] type 00 class 0x060000
[    1.429955] fixup_debug_start: pci 0000:00:1a.4: calling quirk_mmio_always_on+0x0/0x5
[    1.430099] pci 0000:00:1b.0: [1022:1200] type 00 class 0x060000
[    1.430104] fixup_debug_start: pci 0000:00:1b.0: calling quirk_mmio_always_on+0x0/0x5
[    1.430261] pci 0000:00:1b.1: [1022:1201] type 00 class 0x060000
[    1.430266] fixup_debug_start: pci 0000:00:1b.1: calling quirk_mmio_always_on+0x0/0x5
[    1.430403] pci 0000:00:1b.2: [1022:1202] type 00 class 0x060000
[    1.430408] fixup_debug_start: pci 0000:00:1b.2: calling quirk_mmio_always_on+0x0/0x5
[    1.430548] pci 0000:00:1b.3: [1022:1203] type 00 class 0x060000
[    1.430553] fixup_debug_start: pci 0000:00:1b.3: calling quirk_mmio_always_on+0x0/0x5
[    1.430700] pci 0000:00:1b.4: [1022:1204] type 00 class 0x060000
[    1.430705] fixup_debug_start: pci 0000:00:1b.4: calling quirk_mmio_always_on+0x0/0x5
[    1.430846] pci 0000:00:1c.0: [1022:1200] type 00 class 0x060000
[    1.430852] fixup_debug_start: pci 0000:00:1c.0: calling quirk_mmio_always_on+0x0/0x5
[    1.431013] pci 0000:00:1c.1: [1022:1201] type 00 class 0x060000
[    1.431018] fixup_debug_start: pci 0000:00:1c.1: calling quirk_mmio_always_on+0x0/0x5
[    1.431164] pci 0000:00:1c.2: [1022:1202] type 00 class 0x060000
[    1.431169] fixup_debug_start: pci 0000:00:1c.2: calling quirk_mmio_always_on+0x0/0x5
[    1.431317] pci 0000:00:1c.3: [1022:1203] type 00 class 0x060000
[    1.431322] fixup_debug_start: pci 0000:00:1c.3: calling quirk_mmio_always_on+0x0/0x5
[    1.431468] pci 0000:00:1c.4: [1022:1204] type 00 class 0x060000
[    1.431473] fixup_debug_start: pci 0000:00:1c.4: calling quirk_mmio_always_on+0x0/0x5
[    1.431624] pci 0000:00:1d.0: [1022:1200] type 00 class 0x060000
[    1.431629] fixup_debug_start: pci 0000:00:1d.0: calling quirk_mmio_always_on+0x0/0x5
[    1.431807] pci 0000:00:1d.1: [1022:1201] type 00 class 0x060000
[    1.431812] fixup_debug_start: pci 0000:00:1d.1: calling quirk_mmio_always_on+0x0/0x5
[    1.431968] pci 0000:00:1d.2: [1022:1202] type 00 class 0x060000
[    1.431973] fixup_debug_start: pci 0000:00:1d.2: calling quirk_mmio_always_on+0x0/0x5
[    1.432120] pci 0000:00:1d.3: [1022:1203] type 00 class 0x060000
[    1.432125] fixup_debug_start: pci 0000:00:1d.3: calling quirk_mmio_always_on+0x0/0x5
[    1.432272] pci 0000:00:1d.4: [1022:1204] type 00 class 0x060000
[    1.432277] fixup_debug_start: pci 0000:00:1d.4: calling quirk_mmio_always_on+0x0/0x5
[    1.432417] pci 0000:00:1e.0: [1022:1200] type 00 class 0x060000
[    1.432422] fixup_debug_start: pci 0000:00:1e.0: calling quirk_mmio_always_on+0x0/0x5
[    1.432592] pci 0000:00:1e.1: [1022:1201] type 00 class 0x060000
[    1.432597] fixup_debug_start: pci 0000:00:1e.1: calling quirk_mmio_always_on+0x0/0x5
[    1.432756] pci 0000:00:1e.2: [1022:1202] type 00 class 0x060000
[    1.432761] fixup_debug_start: pci 0000:00:1e.2: calling quirk_mmio_always_on+0x0/0x5
[    1.432913] pci 0000:00:1e.3: [1022:1203] type 00 class 0x060000
[    1.432918] fixup_debug_start: pci 0000:00:1e.3: calling quirk_mmio_always_on+0x0/0x5
[    1.433072] pci 0000:00:1e.4: [1022:1204] type 00 class 0x060000
[    1.433077] fixup_debug_start: pci 0000:00:1e.4: calling quirk_mmio_always_on+0x0/0x5
[    1.433225] pci 0000:00:1f.0: [1022:1200] type 00 class 0x060000
[    1.433230] fixup_debug_start: pci 0000:00:1f.0: calling quirk_mmio_always_on+0x0/0x5
[    1.433424] pci 0000:00:1f.1: [1022:1201] type 00 class 0x060000
[    1.433429] fixup_debug_start: pci 0000:00:1f.1: calling quirk_mmio_always_on+0x0/0x5
[    1.433572] pci 0000:00:1f.2: [1022:1202] type 00 class 0x060000
[    1.433577] fixup_debug_start: pci 0000:00:1f.2: calling quirk_mmio_always_on+0x0/0x5
[    1.433752] pci 0000:00:1f.3: [1022:1203] type 00 class 0x060000
[    1.433757] fixup_debug_start: pci 0000:00:1f.3: calling quirk_mmio_always_on+0x0/0x5
[    1.433897] pci 0000:00:1f.4: [1022:1204] type 00 class 0x060000
[    1.433902] fixup_debug_start: pci 0000:00:1f.4: calling quirk_mmio_always_on+0x0/0x5
[    1.434048] pci_scan_child_bus: pci_bus 0000:00: fixups for bus
[    1.434053] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 01-01] behind bridge, pass 0
[    1.434097] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[    1.434114] pci 0000:01:06.0: [8086:1076] type 00 class 0x020000
[    1.434128] pci 0000:01:06.0: reg 0x10: [mem 0xd4120000-0xd413ffff]
[    1.434136] pci 0000:01:06.0: reg 0x14: [mem 0xd4100000-0xd411ffff]
[    1.434145] pci 0000:01:06.0: reg 0x18: [io  0x2080-0x20bf]
[    1.434190] pci 0000:01:06.0: reg 0x30: [mem 0x00000000-0x0001ffff pref]
[    1.434214] pci 0000:01:06.0: PME# supported from D0 D3hot D3cold
[    1.434227] pci_pme_active: pci 0000:01:06.0: PME# disabled
[    1.434320] pci 0000:01:09.0: [18ca:0020] type 00 class 0x030000
[    1.434332] pci 0000:01:09.0: reg 0x10: [mem 0xd8000000-0xdbffffff pref]
[    1.434338] pci 0000:01:09.0: reg 0x14: [mem 0xd4140000-0xd417ffff]
[    1.434345] pci 0000:01:09.0: reg 0x18: [io  0x2000-0x207f]
[    1.434380] pci 0000:01:09.0: supports D1 D2
[    1.434505] pci_scan_child_bus: pci_bus 0000:01: fixups for bus
[    1.434507] pci 0000:00:09.0: PCI bridge to [bus 01] (subtractive decode)
[    1.434687] pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
[    1.434693] pci 0000:00:09.0:   bridge window [mem 0xd4100000-0xd41fffff]
[    1.434697] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdbffffff pref]
[    1.434700] pci 0000:00:09.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.434702] pci 0000:00:09.0:   bridge window [io  0x0d00-0x3fff] (subtractive decode)
[    1.434705] pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.434708] pci 0000:00:09.0:   bridge window [mem 0xd4000000-0xdbffffff] (subtractive decode)
[    1.434711] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=01
[    1.434716] pci_scan_bridge: pci 0000:00:0b.0: scanning [bus 02-02] behind bridge, pass 0
[    1.434782] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[    1.434785] pci_scan_child_bus: pci_bus 0000:02: fixups for bus
[    1.434787] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    1.434941] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[    1.434964] pci_scan_bridge: pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 0
[    1.435043] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[    1.435046] pci_scan_child_bus: pci_bus 0000:03: fixups for bus
[    1.435049] pci 0000:00:0c.0: PCI bridge to [bus 03]
[    1.435201] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[    1.435208] pci_scan_bridge: pci 0000:00:0d.0: scanning [bus 05-05] behind bridge, pass 0
[    1.435269] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[    1.435273] pci_scan_child_bus: pci_bus 0000:05: fixups for bus
[    1.435275] pci 0000:00:0d.0: PCI bridge to [bus 05]
[    1.435430] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[    1.435434] pci_scan_bridge: pci 0000:00:0e.0: scanning [bus 0a-0a] behind bridge, pass 0
[    1.435503] pci_bus 0000:0a: busn_res: can not insert [bus 0a] under [bus 00-07] (conflicts with (null) [bus 00-07])
[    1.435505] pci_scan_child_bus: pci_bus 0000:0a: scanning bus
[    1.435520] pci 0000:0a:00.0: [1000:0646] type 00 class 0x0c0400
[    1.435531] pci 0000:0a:00.0: reg 0x10: [io  0x3000-0x30ff]
[    1.435541] pci 0000:0a:00.0: reg 0x14: [mem 0xd4210000-0xd4213fff 64bit]
[    1.435560] pci 0000:0a:00.0: reg 0x1c: [mem 0xd4200000-0xd420ffff 64bit]
[    1.435572] pci 0000:0a:00.0: reg 0x30: [mem 0x00000000-0x000fffff pref]
[    1.435628] pci 0000:0a:00.0: supports D1 D2
[    1.435720] pci 0000:0a:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    1.435985] pci_scan_child_bus: pci_bus 0000:0a: fixups for bus
[    1.435988] pci 0000:00:0e.0: PCI bridge to [bus 0a]
[    1.436139] pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
[    1.436142] pci 0000:00:0e.0:   bridge window [mem 0xd4200000-0xd42fffff]
[    1.436146] pci_scan_child_bus: pci_bus 0000:0a: bus scan returning with max=0a
[    1.436151] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 01-01] behind bridge, pass 1
[    1.436164] pci_scan_bridge: pci 0000:00:0b.0: scanning [bus 02-02] behind bridge, pass 1
[    1.436175] pci_scan_bridge: pci 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 1
[    1.436183] pci_scan_bridge: pci 0000:00:0d.0: scanning [bus 05-05] behind bridge, pass 1
[    1.436187] pci_scan_bridge: pci 0000:00:0e.0: scanning [bus 0a-0a] behind bridge, pass 1
[    1.436191] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=0a
[    1.436196] pci_bus 0000:00: on NUMA node 0
[    1.437370] ACPI: PCI Interrupt Link [LNK1] (IRQs 16 17 18 19) *0
[    1.437960] ACPI: PCI Interrupt Link [LNK2] (IRQs 16 17 18 19) *0
[    1.438472] ACPI: PCI Interrupt Link [LNK3] (IRQs 16 17 18 19) *0
[    1.438994] ACPI: PCI Interrupt Link [LNK4] (IRQs 16 17 18 19) *0, disabled.
[    1.439541] ACPI: PCI Interrupt Link [LNK5] (IRQs 16 17 18 19) *0, disabled.
[    1.440074] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *0, disabled.
[    1.440610] ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22 23) *0
[    1.441122] ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22 23) *0
[    1.441648] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0
[    1.442157] ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
[    1.442697] ACPI: PCI Interrupt Link [LMCI] (IRQs 20 21 22 23) *0, disabled.
[    1.443232] ACPI: PCI Interrupt Link [LPID] (IRQs 20 21 22 23) *0, disabled.
[    1.443784] ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22 23) *0
[    1.444315] ACPI: PCI Interrupt Link [LSI1] (IRQs 20 21 22 23) *0, disabled.
[    1.444875] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    1.445586] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-ff])
[    1.445736] acpi PNP0A03:01: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    1.445899] acpi PNP0A03:01: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    1.446061] acpi PNP0A03:01: [Firmware Bug]: no _PXM; falling back to node 1 from hardware (may be inconsistent with ACPI node numbers)
[    1.446794] acpi PNP0A03:01: ignoring host bridge window [mem 0x000c0000-0x000dffff] (conflicts with reserved [mem 0x000ca000-0x000fffff])
[    1.447119] PCI host bridge to bus 0000:80
[    1.447266] pci_bus 0000:80: root bus resource [bus 80-ff]
[    1.447418] pci_bus 0000:80: root bus resource [io  0xb000-0xffff]
[    1.447563] pci_bus 0000:80: root bus resource [mem 0x000a0000-0x000bffff]
[    1.447705] pci_bus 0000:80: root bus resource [mem 0xdc000000-0xdc3fffff]
[    1.447857] pci_scan_child_bus: pci_bus 0000:80: scanning bus
[    1.447875] pci 0000:80:00.0: [10de:005e] type 00 class 0x058000
[    1.448064] pci 0000:80:01.0: [10de:00d3] type 00 class 0x058000
[    1.448198] pci 0000:80:07.0: [10de:0054] type 00 class 0x010185
[    1.448207] pci 0000:80:07.0: reg 0x10: [io  0xb030-0xb037]
[    1.448212] pci 0000:80:07.0: reg 0x14: [io  0xb024-0xb027]
[    1.448217] pci 0000:80:07.0: reg 0x18: [io  0xb028-0xb02f]
[    1.448222] pci 0000:80:07.0: reg 0x1c: [io  0xb020-0xb023]
[    1.448227] pci 0000:80:07.0: reg 0x20: [io  0xb000-0xb00f]
[    1.448232] pci 0000:80:07.0: reg 0x24: [mem 0xdc000000-0xdc000fff]
[    1.448384] pci 0000:80:08.0: [10de:0055] type 00 class 0x010185
[    1.448393] pci 0000:80:08.0: reg 0x10: [io  0xb048-0xb04f]
[    1.448397] pci 0000:80:08.0: reg 0x14: [io  0xb03c-0xb03f]
[    1.448402] pci 0000:80:08.0: reg 0x18: [io  0xb040-0xb047]
[    1.448407] pci 0000:80:08.0: reg 0x1c: [io  0xb038-0xb03b]
[    1.448412] pci 0000:80:08.0: reg 0x20: [io  0xb010-0xb01f]
[    1.448417] pci 0000:80:08.0: reg 0x24: [mem 0xdc001000-0xdc001fff]
[    1.448553] pci 0000:80:0a.0: [10de:0057] type 00 class 0x068000
[    1.448562] pci 0000:80:0a.0: reg 0x10: [mem 0xdc002000-0xdc002fff]
[    1.448567] pci 0000:80:0a.0: reg 0x14: [io  0xb050-0xb057]
[    1.448594] pci 0000:80:0a.0: supports D1 D2
[    1.448606] pci 0000:80:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.448623] pci_pme_active: pci 0000:80:0a.0: PME# disabled
[    1.448663] pci 0000:80:0a.0: System wakeup disabled by ACPI
[    1.448914] pci 0000:80:0b.0: [10de:005d] type 01 class 0x060400
[    1.448955] pci 0000:80:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.448958] pci_pme_active: pci 0000:80:0b.0: PME# disabled
[    1.449083] pci 0000:80:0c.0: [10de:005d] type 01 class 0x060400
[    1.449123] pci 0000:80:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.449132] pci_pme_active: pci 0000:80:0c.0: PME# disabled
[    1.449253] pci 0000:80:0d.0: [10de:005d] type 01 class 0x060400
[    1.449300] pci 0000:80:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.449303] pci_pme_active: pci 0000:80:0d.0: PME# disabled
[    1.449415] pci 0000:80:0e.0: [10de:005d] type 01 class 0x060400
[    1.449455] pci 0000:80:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.449459] pci_pme_active: pci 0000:80:0e.0: PME# disabled
[    1.449587] pci_scan_child_bus: pci_bus 0000:80: fixups for bus
[    1.449591] pci_scan_bridge: pci 0000:80:0b.0: scanning [bus 81-85] behind bridge, pass 0
[    1.449641] pci_scan_child_bus: pci_bus 0000:81: scanning bus
[    1.449644] pci_scan_child_bus: pci_bus 0000:81: fixups for bus
[    1.449647] pci 0000:80:0b.0: PCI bridge to [bus 81-85]
[    1.449793] pci_scan_child_bus: pci_bus 0000:81: bus scan returning with max=81
[    1.449799] pci_scan_bridge: pci 0000:80:0c.0: scanning [bus 86-8a] behind bridge, pass 0
[    1.449849] pci_scan_child_bus: pci_bus 0000:86: scanning bus
[    1.449852] pci_scan_child_bus: pci_bus 0000:86: fixups for bus
[    1.449855] pci 0000:80:0c.0: PCI bridge to [bus 86-8a]
[    1.450007] pci_scan_child_bus: pci_bus 0000:86: bus scan returning with max=86
[    1.450011] pci_scan_bridge: pci 0000:80:0d.0: scanning [bus 8b-8f] behind bridge, pass 0
[    1.450090] pci_scan_child_bus: pci_bus 0000:8b: scanning bus
[    1.450093] pci_scan_child_bus: pci_bus 0000:8b: fixups for bus
[    1.450095] pci 0000:80:0d.0: PCI bridge to [bus 8b-8f]
[    1.450239] pci_scan_child_bus: pci_bus 0000:8b: bus scan returning with max=8b
[    1.450253] pci_scan_bridge: pci 0000:80:0e.0: scanning [bus 90-94] behind bridge, pass 0
[    1.450332] pci_scan_child_bus: pci_bus 0000:90: scanning bus
[    1.450335] pci_scan_child_bus: pci_bus 0000:90: fixups for bus
[    1.450337] pci 0000:80:0e.0: PCI bridge to [bus 90-94]
[    1.450479] pci_scan_child_bus: pci_bus 0000:90: bus scan returning with max=90
[    1.450502] pci_scan_bridge: pci 0000:80:0b.0: scanning [bus 81-85] behind bridge, pass 1
[    1.450517] pci_scan_bridge: pci 0000:80:0c.0: scanning [bus 86-8a] behind bridge, pass 1
[    1.450530] pci_scan_bridge: pci 0000:80:0d.0: scanning [bus 8b-8f] behind bridge, pass 1
[    1.450551] pci_scan_bridge: pci 0000:80:0e.0: scanning [bus 90-94] behind bridge, pass 1
[    1.450554] pci_scan_child_bus: pci_bus 0000:80: bus scan returning with max=94
[    1.450565] pci_bus 0000:80: on NUMA node 1
[    1.451091] vgaarb: device added: PCI:0000:01:09.0,decodes=io+mem,owns=io+mem,locks=none
[    1.451251] vgaarb: loaded
[    1.451396] vgaarb: bridge control possible 0000:01:09.0
[    1.452217] SCSI subsystem initialized
[    1.452565] libata version 3.00 loaded.
[    1.452583] ACPI: bus type USB registered
[    1.452805] usbcore: registered new interface driver usbfs
[    1.452986] usbcore: registered new interface driver hub
[    1.453190] usbcore: registered new device driver usb
[    1.453437] PCI: Using ACPI for IRQ routing
[    1.453589] PCI: pci_cache_line_size set to 64 bytes
[    1.453603] pci 0000:00:01.1: can't claim BAR 4 [io  0xa000-0xa03f]: no compatible bridge window
[    1.453863] pci 0000:00:01.1: can't claim BAR 5 [io  0xa040-0xa07f]: no compatible bridge window
[    1.454245] e820: reserve RAM buffer [mem 0x00099800-0x0009ffff]
[    1.454250] e820: reserve RAM buffer [mem 0x7ffe0000-0x7fffffff]
[    1.454252] e820: reserve RAM buffer [mem 0xcfc00000-0xcfffffff]
[    1.455022] Switched to clocksource refined-jiffies
[    1.463509] pnp: PnP ACPI init
[    1.464248] system 00:00: [mem 0xff800000-0xffffffff] could not be reserved
[    1.464444] system 00:00: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.464625] system 00:00: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.464826] system 00:00: [mem 0xfefff000-0xfeffffff] has been reserved
[    1.465010] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.465583] pnp 00:01: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.466059] pnp 00:02: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.466543] pnp 00:03: [dma 2]
[    1.466610] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    1.467155] pnp 00:04: [dma 1]
[    1.467348] pnp 00:04: Plug and Play ACPI device, IDs PNP0401 (active)
[    1.467425] pnp 00:05: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.467509] pnp 00:06: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.467986] system 00:07: [io  0x8000-0x807f] could not be reserved
[    1.468169] system 00:07: [io  0x8080-0x80ff] has been reserved
[    1.468348] system 00:07: [io  0x8400-0x847f] has been reserved
[    1.468526] system 00:07: [io  0x8480-0x84ff] has been reserved
[    1.468706] system 00:07: [io  0x8800-0x887f] has been reserved
[    1.468884] system 00:07: [io  0x8880-0x88ff] has been reserved
[    1.469071] system 00:07: [io  0xa000-0xa03f] has been reserved
[    1.469262] system 00:07: [io  0xa040-0xa07f] has been reserved
[    1.469446] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.469490] pnp 00:08: disabling [io  0x0010-0x001f] because it overlaps 0000:00:01.1 BAR 0 [io  0x0000-0x001f]
[    1.469811] pnp 00:08: disabling [io  0x0010-0x001f disabled] because it overlaps 0000:00:01.1 BAR 4 [io  0x0000-0x003f]
[    1.470114] pnp 00:08: disabling [io  0x0022-0x003f] because it overlaps 0000:00:01.1 BAR 4 [io  0x0000-0x003f]
[    1.470427] pnp 00:08: disabling [io  0x0010-0x001f disabled] because it overlaps 0000:00:01.1 BAR 5 [io  0x0000-0x003f]
[    1.470730] pnp 00:08: disabling [io  0x0022-0x003f disabled] because it overlaps 0000:00:01.1 BAR 5 [io  0x0000-0x003f]
[    1.474932] system 00:08: [io  0x04d0-0x04d1] has been reserved
[    1.475112] system 00:08: [io  0x0400-0x045e] has been reserved
[    1.475300] system 00:08: [io  0x9000-0x907f] has been reserved
[    1.475486] system 00:08: [io  0x9080-0x90ff] has been reserved
[    1.475659] system 00:08: [io  0x9200-0x927f] has been reserved
[    1.475847] system 00:08: [io  0x9280-0x92ff] has been reserved
[    1.476015] system 00:08: [io  0x9400-0x947f] has been reserved
[    1.476204] system 00:08: [io  0x9480-0x94ff] has been reserved
[    1.476382] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.476471] pnp 00:09: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.477110] pnp: PnP ACPI: found 10 devices
[    1.485776] Switched to clocksource acpi_pm
[    1.486113] pci 0000:00:01.1: BAR 4: assigned [io  0x1000-0x103f]
[    1.486300] pci 0000:00:01.1: BAR 5: assigned [io  0x1040-0x107f]
[    1.486477] pci 0000:00:01.1: BAR 0: assigned [io  0x1080-0x109f]
[    1.486664] pci 0000:01:06.0: BAR 6: assigned [mem 0xd4180000-0xd419ffff pref]
[    1.486860] pci 0000:00:09.0: PCI bridge to [bus 01]
[    1.487045] pci 0000:00:09.0:   bridge window [io  0x2000-0x2fff]
[    1.487224] pci 0000:00:09.0:   bridge window [mem 0xd4100000-0xd41fffff]
[    1.487403] pci 0000:00:09.0:   bridge window [mem 0xd8000000-0xdbffffff pref]
[    1.487588] pci 0000:00:0b.0: PCI bridge to [bus 02]
[    1.487772] pci 0000:00:0c.0: PCI bridge to [bus 03]
[    1.487950] pci 0000:00:0d.0: PCI bridge to [bus 05]
[    1.488133] pci 0000:0a:00.0: BAR 6: no space for [mem size 0x00100000 pref]
[    1.488322] pci 0000:0a:00.0: BAR 6: failed to assign [mem size 0x00100000 pref]
[    1.488507] pci 0000:00:0e.0: PCI bridge to [bus 0a]
[    1.488678] pci 0000:00:0e.0:   bridge window [io  0x3000-0x3fff]
[    1.488864] pci 0000:00:0e.0:   bridge window [mem 0xd4200000-0xd42fffff]
[    1.489055] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.489057] pci_bus 0000:00: resource 5 [io  0x0d00-0x3fff]
[    1.489059] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.489062] pci_bus 0000:00: resource 7 [mem 0xd4000000-0xdbffffff]
[    1.489065] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    1.489067] pci_bus 0000:01: resource 1 [mem 0xd4100000-0xd41fffff]
[    1.489069] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdbffffff pref]
[    1.489071] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    1.489073] pci_bus 0000:01: resource 5 [io  0x0d00-0x3fff]
[    1.489075] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    1.489078] pci_bus 0000:01: resource 7 [mem 0xd4000000-0xdbffffff]
[    1.489081] pci_bus 0000:0a: resource 0 [io  0x3000-0x3fff]
[    1.489083] pci_bus 0000:0a: resource 1 [mem 0xd4200000-0xd42fffff]
[    1.489108] pci 0000:80:0b.0: PCI bridge to [bus 81-85]
[    1.489318] pci 0000:80:0c.0: PCI bridge to [bus 86-8a]
[    1.489508] pci 0000:80:0d.0: PCI bridge to [bus 8b-8f]
[    1.489687] pci 0000:80:0e.0: PCI bridge to [bus 90-94]
[    1.490061] pci_bus 0000:80: resource 4 [io  0xb000-0xffff]
[    1.490063] pci_bus 0000:80: resource 5 [mem 0x000a0000-0x000bffff]
[    1.490065] pci_bus 0000:80: resource 6 [mem 0xdc000000-0xdc3fffff]
[    1.490671] NET: Registered protocol family 2
[    1.492089] TCP established hash table entries: 524288 (order: 10, 4194304 bytes)
[    1.495368] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.496277] TCP: Hash tables configured (established 524288 bind 65536)
[    1.496576] TCP: reno registered
[    1.496898] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.498190] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.499766] NET: Registered protocol family 1
[    1.500522] RPC: Registered named UNIX socket transport module.
[    1.500697] RPC: Registered udp transport module.
[    1.500868] RPC: Registered tcp transport module.
[    1.501040] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.501245] fixup_debug_start: pci 0000:00:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.501273] fixup_debug_start: pci 0000:00:01.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.501281] fixup_debug_start: pci 0000:00:01.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.501290] fixup_debug_start: pci 0000:00:02.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.501300] fixup_debug_start: pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x660
[    1.501952] ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 23
[    1.757865] fixup_debug_start: pci 0000:00:02.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.757888] fixup_debug_start: pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x660
[    1.758321] ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 22
[    1.758673] fixup_debug_start: pci 0000:00:06.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.758683] fixup_debug_start: pci 0000:00:07.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.758692] fixup_debug_start: pci 0000:00:08.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.758701] fixup_debug_start: pci 0000:00:09.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.758709] fixup_debug_start: pci 0000:00:0a.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.758718] fixup_debug_start: pci 0000:00:0b.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.758799] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.758977] fixup_debug_start: pci 0000:00:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.758988] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    1.759165] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.759351] fixup_debug_start: pci 0000:00:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.759359] fixup_debug_start: pci 0000:00:0c.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.759412] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.759587] fixup_debug_start: pci 0000:00:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.759603] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    1.759783] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.759956] fixup_debug_start: pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.759972] fixup_debug_start: pci 0000:00:0d.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.760038] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.760213] fixup_debug_start: pci 0000:00:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.760219] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    1.760400] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.760574] fixup_debug_start: pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.760591] fixup_debug_start: pci 0000:00:0e.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.760662] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.760837] fixup_debug_start: pci 0000:00:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.760843] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    1.761015] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.761190] fixup_debug_start: pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.761211] fixup_debug_start: pci 0000:00:18.0: calling quirk_amd_nb_node+0x0/0x74
[    1.761219] fixup_debug_start: pci 0000:00:18.1: calling quirk_amd_nb_node+0x0/0x74
[    1.761227] fixup_debug_start: pci 0000:00:18.2: calling quirk_amd_nb_node+0x0/0x74
[    1.761234] fixup_debug_start: pci 0000:00:18.3: calling quirk_amd_nb_node+0x0/0x74
[    1.761241] fixup_debug_start: pci 0000:00:18.4: calling quirk_amd_nb_node+0x0/0x74
[    1.761248] fixup_debug_start: pci 0000:00:19.0: calling quirk_amd_nb_node+0x0/0x74
[    1.761256] fixup_debug_start: pci 0000:00:19.1: calling quirk_amd_nb_node+0x0/0x74
[    1.761263] fixup_debug_start: pci 0000:00:19.2: calling quirk_amd_nb_node+0x0/0x74
[    1.761270] fixup_debug_start: pci 0000:00:19.3: calling quirk_amd_nb_node+0x0/0x74
[    1.761277] fixup_debug_start: pci 0000:00:19.4: calling quirk_amd_nb_node+0x0/0x74
[    1.761284] fixup_debug_start: pci 0000:00:1a.0: calling quirk_amd_nb_node+0x0/0x74
[    1.761291] fixup_debug_start: pci 0000:00:1a.1: calling quirk_amd_nb_node+0x0/0x74
[    1.761298] fixup_debug_start: pci 0000:00:1a.2: calling quirk_amd_nb_node+0x0/0x74
[    1.761305] fixup_debug_start: pci 0000:00:1a.3: calling quirk_amd_nb_node+0x0/0x74
[    1.761312] fixup_debug_start: pci 0000:00:1a.4: calling quirk_amd_nb_node+0x0/0x74
[    1.761319] fixup_debug_start: pci 0000:00:1b.0: calling quirk_amd_nb_node+0x0/0x74
[    1.761327] fixup_debug_start: pci 0000:00:1b.1: calling quirk_amd_nb_node+0x0/0x74
[    1.761334] fixup_debug_start: pci 0000:00:1b.2: calling quirk_amd_nb_node+0x0/0x74
[    1.761341] fixup_debug_start: pci 0000:00:1b.3: calling quirk_amd_nb_node+0x0/0x74
[    1.761348] fixup_debug_start: pci 0000:00:1b.4: calling quirk_amd_nb_node+0x0/0x74
[    1.761355] fixup_debug_start: pci 0000:00:1c.0: calling quirk_amd_nb_node+0x0/0x74
[    1.761362] fixup_debug_start: pci 0000:00:1c.1: calling quirk_amd_nb_node+0x0/0x74
[    1.761370] fixup_debug_start: pci 0000:00:1c.2: calling quirk_amd_nb_node+0x0/0x74
[    1.761377] fixup_debug_start: pci 0000:00:1c.3: calling quirk_amd_nb_node+0x0/0x74
[    1.761384] fixup_debug_start: pci 0000:00:1c.4: calling quirk_amd_nb_node+0x0/0x74
[    1.761392] fixup_debug_start: pci 0000:00:1d.0: calling quirk_amd_nb_node+0x0/0x74
[    1.761399] fixup_debug_start: pci 0000:00:1d.1: calling quirk_amd_nb_node+0x0/0x74
[    1.761406] fixup_debug_start: pci 0000:00:1d.2: calling quirk_amd_nb_node+0x0/0x74
[    1.761413] fixup_debug_start: pci 0000:00:1d.3: calling quirk_amd_nb_node+0x0/0x74
[    1.761420] fixup_debug_start: pci 0000:00:1d.4: calling quirk_amd_nb_node+0x0/0x74
[    1.761427] fixup_debug_start: pci 0000:00:1e.0: calling quirk_amd_nb_node+0x0/0x74
[    1.761435] fixup_debug_start: pci 0000:00:1e.1: calling quirk_amd_nb_node+0x0/0x74
[    1.761442] fixup_debug_start: pci 0000:00:1e.2: calling quirk_amd_nb_node+0x0/0x74
[    1.761449] fixup_debug_start: pci 0000:00:1e.3: calling quirk_amd_nb_node+0x0/0x74
[    1.761457] fixup_debug_start: pci 0000:00:1e.4: calling quirk_amd_nb_node+0x0/0x74
[    1.761652] fixup_debug_start: pci 0000:00:1f.0: calling quirk_amd_nb_node+0x0/0x74
[    1.761659] fixup_debug_start: pci 0000:00:1f.1: calling quirk_amd_nb_node+0x0/0x74
[    1.761666] fixup_debug_start: pci 0000:00:1f.2: calling quirk_amd_nb_node+0x0/0x74
[    1.761673] fixup_debug_start: pci 0000:00:1f.3: calling quirk_amd_nb_node+0x0/0x74
[    1.761680] fixup_debug_start: pci 0000:00:1f.4: calling quirk_amd_nb_node+0x0/0x74
[    1.761688] fixup_debug_start: pci 0000:01:06.0: calling quirk_e100_interrupt+0x0/0x143
[    1.761700] fixup_debug_start: pci 0000:01:09.0: calling pci_fixup_video+0x0/0x11b
[    1.761705] pci 0000:01:09.0: Boot video device
[    1.761716] fixup_debug_start: pci 0000:80:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.761750] fixup_debug_start: pci 0000:80:01.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.761757] fixup_debug_start: pci 0000:80:07.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.761766] fixup_debug_start: pci 0000:80:08.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.761774] fixup_debug_start: pci 0000:80:0a.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.761783] fixup_debug_start: pci 0000:80:0b.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.761841] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.762015] fixup_debug_start: pci 0000:80:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.762030] pci 0000:80:0b.0: Found disabled HT MSI Mapping
[    1.762200] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.762386] fixup_debug_start: pci 0000:80:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.762393] fixup_debug_start: pci 0000:80:0c.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.762428] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.762603] fixup_debug_start: pci 0000:80:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.762618] pci 0000:80:0c.0: Found disabled HT MSI Mapping
[    1.762788] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.762963] fixup_debug_start: pci 0000:80:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.762980] fixup_debug_start: pci 0000:80:0d.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.763019] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.763194] fixup_debug_start: pci 0000:80:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.763209] pci 0000:80:0d.0: Found disabled HT MSI Mapping
[    1.763389] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.763555] fixup_debug_start: pci 0000:80:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.763572] fixup_debug_start: pci 0000:80:0e.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x27
[    1.763616] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.763790] fixup_debug_start: pci 0000:80:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/0x66
[    1.763805] pci 0000:80:0e.0: Found disabled HT MSI Mapping
[    1.763979] pci 0000:80:00.0: Found enabled HT MSI Mapping
[    1.764154] fixup_debug_start: pci 0000:80:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_cap+0x0/0x5d
[    1.764167] PCI: CLS 64 bytes, default 64
[    1.767552] PCI-DMA: Disabling AGP.
[    1.769063] PCI-DMA: aperture base @ d0000000 size 65536 KB
[    1.769237] init_memory_mapping: [mem 0xd0000000-0xd3ffffff]
[    1.769411]  [mem 0xd0000000-0xd3ffffff] page 2M
[    1.769428] PCI-DMA: using GART IOMMU.
[    1.769793] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    1.779877] Simple Boot Flag at 0x37 set to 0x80
[    1.783190] LVT offset 1 assigned for vector 0x400
[    1.783438] IBS: LVT offset 1 assigned
[    1.783700] perf: AMD IBS detected (0x00000007)
[    1.789228] futex hash table entries: 8192 (order: 7, 524288 bytes)
[    1.791102] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.795044] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.795483] msgmni has been set to 32768
[    1.796156] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.796325] io scheduler noop registered
[    1.796483] io scheduler deadline registered
[    1.796804] io scheduler cfq registered (default)
[    1.797260] __pci_set_master: pcieport 0000:00:0b.0: enabling bus mastering
[    1.797295] pcieport 0000:00:0b.0: irq 24 for MSI/MSI-X
[    1.797392] __pci_set_master: pcieport 0000:00:0c.0: enabling bus mastering
[    1.797404] pcieport 0000:00:0c.0: irq 25 for MSI/MSI-X
[    1.797667] pcieport 0000:00:0d.0: irq 26 for MSI/MSI-X
[    1.797754] pcieport 0000:00:0e.0: irq 27 for MSI/MSI-X
[    1.797861] __pci_set_master: pcieport 0000:80:0b.0: enabling bus mastering
[    1.797901] pcieport 0000:80:0b.0: irq 28 for MSI/MSI-X
[    1.797988] __pci_set_master: pcieport 0000:80:0c.0: enabling bus mastering
[    1.797999] pcieport 0000:80:0c.0: irq 29 for MSI/MSI-X
[    1.798074] pcieport 0000:80:0d.0: irq 30 for MSI/MSI-X
[    1.798156] pcieport 0000:80:0e.0: irq 31 for MSI/MSI-X
[    1.798611] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.798801] ACPI: Power Button [PWRB]
[    1.799111] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.799277] ACPI: Power Button [PWRF]
[    1.799586] ACPI: acpi_idle registered with cpuidle
[    1.823491] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.844065] 00:01: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.864631] 00:02: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    1.866097] Linux agpgart interface v0.103
[    1.867580] Floppy drive(s): fd0 is 1.44M
[    1.870252] brd: module loaded
[    1.871755] loop: module loaded
[    1.872354] sata_nv 0000:00:07.0: version 3.5
[    1.872903] ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
[    1.873919] scsi host0: sata_nv
[    1.874433] scsi host1: sata_nv
[    1.874663] ata1: SATA max UDMA/133 cmd 0x1440 ctl 0x1434 bmdma 0x1410 irq 21
[    1.874820] ata2: SATA max UDMA/133 cmd 0x1438 ctl 0x1430 bmdma 0x1418 irq 21
[    1.875338] ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 20
[    1.876045] scsi host2: sata_nv
[    1.876385] scsi host3: sata_nv
[    1.876618] ata3: SATA max UDMA/133 cmd 0x1458 ctl 0x144c bmdma 0x1420 irq 20
[    1.876773] ata4: SATA max UDMA/133 cmd 0x1450 ctl 0x1448 bmdma 0x1428 irq 20
[    1.877322] ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 19
[    1.878377] scsi host4: sata_nv
[    1.878749] scsi host5: sata_nv
[    1.878972] ata5: SATA max UDMA/133 cmd 0xb030 ctl 0xb024 bmdma 0xb000 irq 19
[    1.879137] ata6: SATA max UDMA/133 cmd 0xb028 ctl 0xb020 bmdma 0xb008 irq 19
[    1.879544] ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 18
[    1.880165] scsi host6: sata_nv
[    1.880518] scsi host7: sata_nv
[    1.880737] ata7: SATA max UDMA/133 cmd 0xb048 ctl 0xb03c bmdma 0xb010 irq 18
[    1.880903] ata8: SATA max UDMA/133 cmd 0xb040 ctl 0xb038 bmdma 0xb018 irq 18
[    1.881141] pata_amd 0000:00:06.0: version 0.4.1
[    1.882598] scsi host8: pata_amd
[    1.883002] scsi host9: pata_amd
[    1.883404] ata9: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1400 irq 14
[    1.883556] ata10: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x1408 irq 15
[    1.883851] tun: Universal TUN/TAP device driver, 1.6
[    1.884215] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.884829] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    1.885185] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    1.885574] FDC 0 is a post-1991 82077
[    2.341167] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.341175] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.345122] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.345148] ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.349778] ata3.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.349786] ata1.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.349788] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.350309] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.353704] ata5.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.353930] ata5.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.353946] ata7.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    2.353950] ata7.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.363509] e1000 0000:01:06.0 eth0: (PCI:33MHz:32-bit) 00:e0:81:b0:4d:69
[    2.363694] e1000 0000:01:06.0 eth0: Intel(R) PRO/1000 Network Connection
[    2.363940] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    2.364508] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
[    2.365675] ata1.00: configured for UDMA/133
[    2.365696] ata3.00: configured for UDMA/133
[    2.366259] scsi 0:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    2.366871] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.366968] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.367235] sd 0:0:0:0: [sda] Write Protect is off
[    2.367386] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.367408] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.369686] ata7.00: configured for UDMA/133
[    2.369688] ata5.00: configured for UDMA/133
[    2.378898]  sda: sda1 sda2 sda3
[    2.379466] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.776778] tsc: Refined TSC clocksource calibration: 1908.796 MHz
[    2.832733] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.841248] ata2.00: ATA-6: ST31000340NS, SN04, max UDMA/133
[    2.841401] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.857230] ata2.00: configured for UDMA/133
[    2.857486] scsi 1:0:0:0: Direct-Access     ATA      ST31000340NS     SN04 PQ: 0 ANSI: 5
[    2.858006] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.858239] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.858324] sd 1:0:0:0: [sdb] Write Protect is off
[    2.858327] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.858396] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.859042] scsi 2:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    2.859498] sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.859554] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    2.859922] sd 2:0:0:0: [sdc] Write Protect is off
[    2.860105] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.860175] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.871978]  sdb: unknown partition table
[    2.872725] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.876720]  sdc: unknown partition table
[    2.877280] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.889268] forcedeth 0000:00:0a.0: ifname eth1, PHY OUI 0x5043 @ 1, addr 00:e0:81:b0:4d:67
[    2.889457] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
[    2.889883] ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 17
[    3.324302] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.332836] ata4.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    3.336309] ata4.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.352827] ata4.00: configured for UDMA/133
[    3.353103] scsi 3:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.353592] sd 3:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.353632] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    3.353979] scsi 4:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.354025] sd 3:0:0:0: [sdd] Write Protect is off
[    3.354027] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    3.354084] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.355092] sd 4:0:0:0: [sde] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.355095] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    3.355469] sd 4:0:0:0: [sde] Write Protect is off
[    3.355628] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    3.355653] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.365453]  sdd: unknown partition table
[    3.365956] sd 3:0:0:0: [sdd] Attached SCSI disk
[    3.371746]  sde: sde1 sde2 sde3
[    3.372514] sd 4:0:0:0: [sde] Attached SCSI disk
[    3.412734] forcedeth 0000:80:0a.0: ifname eth2, PHY OUI 0x5043 @ 1, addr 00:e0:81:b0:4d:68
[    3.412934] forcedeth 0000:80:0a.0: highdma csum gbit lnktim desc-v3
[    3.413538] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.413720] ehci-pci: EHCI PCI platform driver
[    3.414026] __pci_set_master: ehci-pci 0000:00:02.1: enabling bus mastering
[    3.414073] ehci-pci 0000:00:02.1: EHCI Host Controller
[    3.414343] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus number 1
[    3.414511] ehci-pci 0000:00:02.1: debug port 1
[    3.414709] ehci-pci 0000:00:02.1: cache line size of 64 is not supported
[    3.414735] ehci-pci 0000:00:02.1: irq 22, io mem 0xd4001000
[    3.424209] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    3.424630] hub 1-0:1.0: USB hub found
[    3.424789] hub 1-0:1.0: 10 ports detected
[    3.425219] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.425407] ohci-pci: OHCI PCI platform driver
[    3.425639] __pci_set_master: ohci-pci 0000:00:02.0: enabling bus mastering
[    3.425643] ohci-pci 0000:00:02.0: OHCI PCI host controller
[    3.425908] ohci-pci 0000:00:02.0: new USB bus registered, assigned bus number 2
[    3.426099] ohci-pci 0000:00:02.0: irq 23, io mem 0xd4000000
[    3.482367] hub 2-0:1.0: USB hub found
[    3.482520] hub 2-0:1.0: 10 ports detected
[    3.482952] uhci_hcd: USB Universal Host Controller Interface driver
[    3.483381] usbcore: registered new interface driver usblp
[    3.483614] usbcore: registered new interface driver usb-storage
[    3.483884] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.486916] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.487135] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.487520] mousedev: PS/2 mouse device common for all mice
[    3.488711] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    3.489698] usbcore: registered new interface driver usbhid
[    3.489853] usbhid: USB HID core driver
[    3.490081] oprofile: AMD IBS detected (0x00000007)
[    3.490239] oprofile: using NMI interrupt.
[    3.490436] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.491242] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.491516] arp_tables: (C) 2002 David S. Miller
[    3.491689] TCP: cubic registered
[    3.491849] NET: Registered protocol family 17
[    3.495185] registered taskstats version 1
[    3.496715] console [netcon0] enabled
[    3.496872] netconsole: network logging started
[    3.497494] acpi-cpufreq: overriding BIOS provided _PSD data
[    3.549578] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.776134] Switched to clocksource tsc
[    3.819735] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.828277] ata6.00: ATA-8: ST31000340NS, SN05, max UDMA/133
[    3.828491] ata6.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.844261] ata6.00: configured for UDMA/133
[    3.844563] scsi 5:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.845112] sd 5:0:0:0: [sdf] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.845171] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    3.845373] scsi 6:0:0:0: Direct-Access     ATA      ST31000340NS     SN05 PQ: 0 ANSI: 5
[    3.845655] sd 5:0:0:0: [sdf] Write Protect is off
[    3.845662] sd 6:0:0:0: [sdg] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    3.845751] sd 6:0:0:0: Attached scsi generic sg6 type 0
[    3.845757] sd 6:0:0:0: [sdg] Write Protect is off
[    3.845760] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    3.845828] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.846532] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    3.846581] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.861515]  sdg: unknown partition table
[    3.862056] sd 6:0:0:0: [sdg] Attached SCSI disk
[    3.863241]  sdf: sdf1 sdf2 sdf3
[    3.864029] sd 5:0:0:0: [sdf] Attached SCSI disk
[    4.111486] usb 2-1: new low-speed USB device number 2 using ohci-pci
[    4.117444] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input4
[    4.311299] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.335571] ata8.00: ATA-7: Hitachi HUA721010KLA330, GKAOA70M, max UDMA/133
[    4.335768] ata8.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.351572] ata8.00: configured for UDMA/133
[    4.351819] scsi 7:0:0:0: Direct-Access     ATA      Hitachi HUA72101 A70M PQ: 0 ANSI: 5
[    4.352330] sd 7:0:0:0: [sdh] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    4.352343] sd 7:0:0:0: Attached scsi generic sg7 type 0
[    4.352779] sd 7:0:0:0: [sdh] Write Protect is off
[    4.352984] sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    4.353042] sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.372103]  sdh: unknown partition table
[    4.372588] sd 7:0:0:0: [sdh] Attached SCSI disk
[    4.539392] ata10.00: ATAPI: TEAC DV-516GB, HT13, max UDMA/33
[    4.539563] ata10: nv_mode_filter: 0x739f&0x739f->0x739f, BIOS=0x7000 (0xc000) ACPI=0x701f (60:600:0x13)
[    4.579279] ata10.00: configured for UDMA/33
[    4.581349] scsi 9:0:0:0: CD-ROM            TEAC     DV-516GB         HT13 PQ: 0 ANSI: 5
[    4.596303] sr 9:0:0:0: [sr0] scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    4.596455] cdrom: Uniform CD-ROM driver Revision: 3.20
[    4.596757] sr 9:0:0:0: Attached scsi CD-ROM sr0
[    4.596862] sr 9:0:0:0: Attached scsi generic sg8 type 5
[    4.610895] EXT3-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    4.612015] EXT2-fs (sda2): error: couldn't mount because of unsupported optional features (240)
[    4.632148] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    4.632335] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    4.649149] devtmpfs: mounted
[    4.650411] Freeing unused kernel memory: 936K (ffffffff81784000 - ffffffff8186e000)
[    5.523160] random: nonblocking pool is initialized
[    5.882112] hid-generic 0003:051D:0002.0001: device has no listeners, quitting
[    6.349324] systemd-udevd[1988]: starting version 216
[    6.862074] forcedeth 0000:80:0a.0 enp128s10: renamed from eth2
[    6.889198] forcedeth 0000:00:0a.0 enp0s10: renamed from eth1
[    6.889207] systemd-udevd[2059]: renamed network interface eth2 to enp128s10
[    6.893288] kvm: Nested Virtualization enabled
[    6.893309] kvm: Nested Paging enabled
[    6.913139] systemd-udevd[2064]: renamed network interface eth1 to enp0s10
[    6.934363] Fusion MPT base driver 3.04.20
[    6.934370] Copyright (c) 1999-2008 LSI Corporation
[    6.941071] e1000 0000:01:06.0 enp1s6: renamed from eth0
[    6.950959] Fusion MPT FC Host driver 3.04.20
[    6.951377] mptbase: ioc0: Initiating bringup
[    6.969088] systemd-udevd[2001]: renamed network interface eth0 to enp1s6
[    7.508521] ioc0: LSIFC949E: Capabilities={Initiator,Target,LAN}
[    8.596047] scsi host10: ioc0: LSIFC949E, FwRev=01031400h, Ports=1, MaxQ=1023, IRQ=17
[    8.596649] mptfc: ioc0: FC Link Established, Speed = 4 Gbps
[    8.597446] scsi 10:0:0:0: Direct-Access     ES-6600S Backup           R001 PQ: 0 ANSI: 5
[    8.598001] sd 10:0:0:0: Attached scsi generic sg9 type 0
[    8.598205] sd 10:0:0:0: [sdi] 3906249216 512-byte logical blocks: (1.99 TB/1.81 TiB)
[    8.598317] scsi 10:0:0:1: Direct-Access     ES-6600S Data             R001 PQ: 0 ANSI: 5
[    8.598426] sd 10:0:0:0: [sdi] Write Protect is off
[    8.598431] sd 10:0:0:0: [sdi] Mode Sense: bf 00 00 08
[    8.598552] sd 10:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.598608] mptscsih: ioc0: [10:0:0:0] FCP_ResponseInfo=02000000h
[    8.598858] sd 10:0:0:1: [sdj] 15624996864 512-byte logical blocks: (7.99 TB/7.27 TiB)
[    8.598916] sd 10:0:0:1: Attached scsi generic sg10 type 0
[    8.599068] sd 10:0:0:1: [sdj] Write Protect is off
[    8.599073] sd 10:0:0:1: [sdj] Mode Sense: bf 00 00 08
[    8.599214] sd 10:0:0:1: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.599259] scsi 10:0:0:2: Direct-Access     ES-6600S Systems          R001 PQ: 0 ANSI: 5
[    8.599296] mptscsih: ioc0: [10:0:0:1] FCP_ResponseInfo=02000000h
[    8.600262] sd 10:0:0:2: [sdk] 7812498432 512-byte logical blocks: (3.99 TB/3.63 TiB)
[    8.600299] sd 10:0:0:2: Attached scsi generic sg11 type 0
[    8.600325]  sdj: unknown partition table
[    8.600468] sd 10:0:0:2: [sdk] Write Protect is off
[    8.600471] sd 10:0:0:2: [sdk] Mode Sense: bf 00 00 08
[    8.600581] sd 10:0:0:2: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.600633] mptscsih: ioc0: [10:0:0:2] FCP_ResponseInfo=02000000h
[    8.601166] sd 10:0:0:1: [sdj] Attached SCSI disk
[    8.601582]  sdk: unknown partition table
[    8.602186] sd 10:0:0:2: [sdk] Attached SCSI disk
[    8.620850]  sdi: sdi1
[    8.621549] sd 10:0:0:0: [sdi] Attached SCSI disk
[    9.335401] EXT4-fs (sda2): re-mounted. Opts: (null)
[   10.969544] end_request: I/O error, dev fd0, sector 0
[   10.969553] floppy: error -5 while reading block 0
[   10.969592] floppy0: do_fd_request: timeout handler died.  old request running
[   10.993516] end_request: I/O error, dev fd0, sector 0
[   10.993518] floppy: error -5 while reading block 0
[   14.504737] Bridge firewalling registered
[   14.552217] e1000: enp1s6 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   14.560288] device enp1s6 entered promiscuous mode
[   14.571000] device br0 entered promiscuous mode
[   14.598198] br0: port 1(enp1s6) entered forwarding state
[   14.598212] br0: port 1(enp1s6) entered forwarding state

2) dmesg of reset with setpci

[  224.485365] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[  224.485517] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 01-01] behind bridge, pass 0
[  224.485524] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[  224.485575] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=01
[  224.485581] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 02-02] behind bridge, pass 0
[  224.485588] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[  224.485593] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[  224.485598] pci_scan_bridge: pcieport 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 0
[  224.485602] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[  224.485606] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[  224.485611] pci_scan_bridge: pcieport 0000:00:0d.0: scanning [bus 05-05] behind bridge, pass 0
[  224.485615] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[  224.485619] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[  224.485623] pci_scan_bridge: pcieport 0000:00:0e.0: scanning [bus 06-06] behind bridge, pass 0
[  224.485627] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[  224.485631] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[  224.485637] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 01-01] behind bridge, pass 1
[  224.485644] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 02-02] behind bridge, pass 1
[  224.485649] pci_scan_bridge: pcieport 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 1
[  224.485653] pci_scan_bridge: pcieport 0000:00:0d.0: scanning [bus 05-05] behind bridge, pass 1
[  224.485657] pci_scan_bridge: pcieport 0000:00:0e.0: scanning [bus 06-06] behind bridge, pass 1
[  224.485661] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=06
[  224.485709] pci 0000:01:09.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  224.485715] pci_scan_child_bus: pci_bus 0000:80: scanning bus
[  224.485774] pci_scan_bridge: pcieport 0000:80:0b.0: scanning [bus 81-85] behind bridge, pass 0
[  224.485778] pci_scan_child_bus: pci_bus 0000:81: scanning bus
[  224.485782] pci_scan_child_bus: pci_bus 0000:81: bus scan returning with max=81
[  224.485787] pci_scan_bridge: pcieport 0000:80:0c.0: scanning [bus 86-8a] behind bridge, pass 0
[  224.485791] pci_scan_child_bus: pci_bus 0000:86: scanning bus
[  224.485795] pci_scan_child_bus: pci_bus 0000:86: bus scan returning with max=86
[  224.485799] pci_scan_bridge: pcieport 0000:80:0d.0: scanning [bus 8b-8f] behind bridge, pass 0
[  224.485803] pci_scan_child_bus: pci_bus 0000:8b: scanning bus
[  224.485807] pci_scan_child_bus: pci_bus 0000:8b: bus scan returning with max=8b
[  224.485811] pci_scan_bridge: pcieport 0000:80:0e.0: scanning [bus 90-94] behind bridge, pass 0
[  224.485815] pci_scan_child_bus: pci_bus 0000:90: scanning bus
[  224.485819] pci_scan_child_bus: pci_bus 0000:90: bus scan returning with max=90
[  224.485823] pci_scan_bridge: pcieport 0000:80:0b.0: scanning [bus 81-85] behind bridge, pass 1
[  224.485827] pci_scan_bridge: pcieport 0000:80:0c.0: scanning [bus 86-8a] behind bridge, pass 1
[  224.485831] pci_scan_bridge: pcieport 0000:80:0d.0: scanning [bus 8b-8f] behind bridge, pass 1
[  224.485835] pci_scan_bridge: pcieport 0000:80:0e.0: scanning [bus 90-94] behind bridge, pass 1
[  224.485838] pci_scan_child_bus: pci_bus 0000:80: bus scan returning with max=94

3) dmesg of Bjorn's reset

[  109.654999] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[  109.655133] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 01-01] behind bridge, pass 0
[  109.655139] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[  109.655198] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=01
[  109.655208] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 02-02] behind bridge, pass 0
[  109.655212] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[  109.655216] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[  109.655221] pci_scan_bridge: pcieport 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 0
[  109.655225] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[  109.655228] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[  109.655233] pci_scan_bridge: pcieport 0000:00:0d.0: scanning [bus 05-05] behind bridge, pass 0
[  109.655237] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[  109.655241] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[  109.655245] pci_scan_bridge: pcieport 0000:00:0e.0: scanning [bus 06-06] behind bridge, pass 0
[  109.655249] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[  109.655269] pci 0000:06:00.0: [1000:0646] type 00 class 0x0c0400
[  109.655288] pci 0000:06:00.0: reg 0x10: [io  0x0000-0x00ff]
[  109.655300] pci 0000:06:00.0: reg 0x14: [mem 0x00000000-0x00003fff 64bit]
[  109.655311] pci 0000:06:00.0: reg 0x1c: [mem 0x00000000-0x0000ffff 64bit]
[  109.655320] pci 0000:06:00.0: reg 0x30: [mem 0x00000000-0x000fffff pref]
[  109.655382] pci 0000:06:00.0: supports D1 D2
[  109.660246] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[  109.660254] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 01-01] behind bridge, pass 1
[  109.660258] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 02-02] behind bridge, pass 1
[  109.660262] pci_scan_bridge: pcieport 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 1
[  109.660266] pci_scan_bridge: pcieport 0000:00:0d.0: scanning [bus 05-05] behind bridge, pass 1
[  109.660270] pci_scan_bridge: pcieport 0000:00:0e.0: scanning [bus 06-06] behind bridge, pass 1
[  109.660274] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=06
[  109.660316] pci 0000:01:09.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  109.660328] pci 0000:06:00.0: BAR 6: assigned [mem 0xd4200000-0xd42fffff pref]
[  109.660334] pci 0000:06:00.0: BAR 3: no space for [mem size 0x00010000 64bit]
[  109.660337] pci 0000:06:00.0: BAR 3: failed to assign [mem size 0x00010000 64bit]
[  109.660340] pci 0000:06:00.0: BAR 1: no space for [mem size 0x00004000 64bit]
[  109.660342] pci 0000:06:00.0: BAR 1: failed to assign [mem size 0x00004000 64bit]
[  109.660345] pci 0000:06:00.0: BAR 0: assigned [io  0x3000-0x30ff]
[  109.660439] pci_scan_child_bus: pci_bus 0000:80: scanning bus
[  109.660518] pci_scan_bridge: pcieport 0000:80:0b.0: scanning [bus 81-85] behind bridge, pass 0
[  109.660522] pci_scan_child_bus: pci_bus 0000:81: scanning bus
[  109.660526] pci_scan_child_bus: pci_bus 0000:81: bus scan returning with max=81
[  109.660531] pci_scan_bridge: pcieport 0000:80:0c.0: scanning [bus 86-8a] behind bridge, pass 0
[  109.660536] pci_scan_child_bus: pci_bus 0000:86: scanning bus
[  109.660539] pci_scan_child_bus: pci_bus 0000:86: bus scan returning with max=86
[  109.660545] pci_scan_bridge: pcieport 0000:80:0d.0: scanning [bus 8b-8f] behind bridge, pass 0
[  109.660549] pci_scan_child_bus: pci_bus 0000:8b: scanning bus
[  109.660553] pci_scan_child_bus: pci_bus 0000:8b: bus scan returning with max=8b
[  109.660558] pci_scan_bridge: pcieport 0000:80:0e.0: scanning [bus 90-94] behind bridge, pass 0
[  109.660562] pci_scan_child_bus: pci_bus 0000:90: scanning bus
[  109.660565] pci_scan_child_bus: pci_bus 0000:90: bus scan returning with max=90
[  109.660570] pci_scan_bridge: pcieport 0000:80:0b.0: scanning [bus 81-85] behind bridge, pass 1
[  109.660574] pci_scan_bridge: pcieport 0000:80:0c.0: scanning [bus 86-8a] behind bridge, pass 1
[  109.660578] pci_scan_bridge: pcieport 0000:80:0d.0: scanning [bus 8b-8f] behind bridge, pass 1
[  109.660582] pci_scan_bridge: pcieport 0000:80:0e.0: scanning [bus 90-94] behind bridge, pass 1
[  109.660586] pci_scan_child_bus: pci_bus 0000:80: bus scan returning with max=94
[  109.714004] Fusion MPT base driver 3.04.20
[  109.714010] Copyright (c) 1999-2008 LSI Corporation
[  109.722383] Fusion MPT FC Host driver 3.04.20
[  109.722816] mptbase: ioc0: Initiating bringup
[  109.722821] mptbase: ioc0: WARNING - Unexpected doorbell active!
[  169.908097] mptbase: ioc0: ERROR - Failed to come READY after reset! IocState=f0000000
[  169.908107] mptbase: ioc0: WARNING - ResetHistory bit failed to clear!
[  169.908111] mptbase: ioc0: ERROR - Diagnostic reset FAILED! (ffffffffh)
[  169.908114] mptbase: ioc0: WARNING - NOT READY WARNING!
[  169.908116] mptbase: ioc0: ERROR - didn't initialize properly! (-1)
[  169.908209] mptfc: probe of 0000:06:00.0 failed with error -1

4) lspci and dmesg of reset with Yinghai's patches

-+-[0000:80]-+-00.0  NVIDIA Corporation CK804 Memory Controller
 |           +-01.0  NVIDIA Corporation CK804 Memory Controller
 |           +-07.0  NVIDIA Corporation CK804 Serial ATA Controller
 |           +-08.0  NVIDIA Corporation CK804 Serial ATA Controller
 |           +-0a.0  NVIDIA Corporation CK804 Ethernet Controller
 |           +-0b.0-[81-85]--
 |           +-0c.0-[86-8a]--
 |           +-0d.0-[8b-8f]--
 |           \-0e.0-[90-94]--
 \-[0000:00]-+-00.0  NVIDIA Corporation CK804 Memory Controller
             +-01.0  NVIDIA Corporation CK804 ISA Bridge
             +-01.1  NVIDIA Corporation CK804 SMBus
             +-02.0  NVIDIA Corporation CK804 USB Controller
             +-02.1  NVIDIA Corporation CK804 USB Controller
             +-06.0  NVIDIA Corporation CK804 IDE
             +-07.0  NVIDIA Corporation CK804 Serial ATA Controller
             +-08.0  NVIDIA Corporation CK804 Serial ATA Controller
             +-09.0-[01]--+-06.0  Intel Corporation 82541GI Gigabit Ethernet Controller
             |            \-09.0  XGI Technology Inc. (eXtreme Graphics Innovation) Z7/Z9 (XG20 core)
             +-0a.0  NVIDIA Corporation CK804 Ethernet Controller
             +-0b.0-[02]--
             +-0c.0-[03]--
             +-0d.0-[05]--
             +-0e.0-[06]----00.0  LSI Logic / Symbios Logic FC949ES Fibre Channel Adapter
             +-18.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-18.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-18.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-18.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-18.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-19.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-19.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-19.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-19.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-19.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1a.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1a.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1a.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1a.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1a.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1b.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1b.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1b.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1b.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1b.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1c.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1c.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1c.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1c.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1c.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1d.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1d.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1d.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1d.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1d.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1e.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1e.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1e.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1e.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             +-1e.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control
             +-1f.0  Advanced Micro Devices, Inc. [AMD] Family 10h Processor HyperTransport Configuration
             +-1f.1  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Address Map
             +-1f.2  Advanced Micro Devices, Inc. [AMD] Family 10h Processor DRAM Controller
             +-1f.3  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Miscellaneous Control
             \-1f.4  Advanced Micro Devices, Inc. [AMD] Family 10h Processor Link Control

[  217.421381] pcieport 0000:00:0e.0: pcie_link_disable_set: lnk_ctrl = 10
[  231.385669] pcieport 0000:00:0e.0: pcie_link_disable_set: lnk_ctrl = 0
[  245.327763] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[  245.327906] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 01-01] behind bridge, pass 0
[  245.327912] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[  245.327959] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=01
[  245.327964] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 02-02] behind bridge, pass 0
[  245.327969] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[  245.327973] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[  245.327977] pci_scan_bridge: pcieport 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 0
[  245.327981] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[  245.327984] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[  245.327991] pci_scan_bridge: pcieport 0000:00:0d.0: scanning [bus 05-05] behind bridge, pass 0
[  245.327995] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[  245.327999] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[  245.328003] pci_scan_bridge: pcieport 0000:00:0e.0: scanning [bus 06-06] behind bridge, pass 0
[  245.328007] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[  245.328028] pci 0000:06:00.0: [1000:0646] type 00 class 0x0c0400
[  245.328046] pci 0000:06:00.0: reg 0x10: [io  0x0000-0x00ff]
[  245.328058] pci 0000:06:00.0: reg 0x14: [mem 0x00000000-0x00003fff 64bit]
[  245.328067] pci 0000:06:00.0: reg 0x1c: [mem 0x00000000-0x0000ffff 64bit]
[  245.328088] pci 0000:06:00.0: reg 0x30: [mem 0x00000000-0x000fffff pref]
[  245.328168] pci 0000:06:00.0: supports D1 D2
[  245.335389] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[  245.335397] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 01-01] behind bridge, pass 1
[  245.335401] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 02-02] behind bridge, pass 1
[  245.335405] pci_scan_bridge: pcieport 0000:00:0c.0: scanning [bus 03-03] behind bridge, pass 1
[  245.335409] pci_scan_bridge: pcieport 0000:00:0d.0: scanning [bus 05-05] behind bridge, pass 1
[  245.335414] pci_scan_bridge: pcieport 0000:00:0e.0: scanning [bus 06-06] behind bridge, pass 1
[  245.335417] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=06
[  245.335460] pci 0000:01:09.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus alignment
[  245.335473] pci 0000:06:00.0: BAR 6: assigned [mem 0xd4200000-0xd42fffff pref]
[  245.335478] pci 0000:06:00.0: BAR 3: no space for [mem size 0x00010000 64bit]
[  245.335481] pci 0000:06:00.0: BAR 3: failed to assign [mem size 0x00010000 64bit]
[  245.335484] pci 0000:06:00.0: BAR 1: no space for [mem size 0x00004000 64bit]
[  245.335486] pci 0000:06:00.0: BAR 1: failed to assign [mem size 0x00004000 64bit]
[  245.335489] pci 0000:06:00.0: BAR 0: assigned [io  0x3000-0x30ff]
[  245.335579] pci_scan_child_bus: pci_bus 0000:80: scanning bus
[  245.335647] pci_scan_bridge: pcieport 0000:80:0b.0: scanning [bus 81-85] behind bridge, pass 0
[  245.335651] pci_scan_child_bus: pci_bus 0000:81: scanning bus
[  245.335656] pci_scan_child_bus: pci_bus 0000:81: bus scan returning with max=81
[  245.335661] pci_scan_bridge: pcieport 0000:80:0c.0: scanning [bus 86-8a] behind bridge, pass 0
[  245.335665] pci_scan_child_bus: pci_bus 0000:86: scanning bus
[  245.335668] pci_scan_child_bus: pci_bus 0000:86: bus scan returning with max=86
[  245.335673] pci_scan_bridge: pcieport 0000:80:0d.0: scanning [bus 8b-8f] behind bridge, pass 0
[  245.335677] pci_scan_child_bus: pci_bus 0000:8b: scanning bus
[  245.335681] pci_scan_child_bus: pci_bus 0000:8b: bus scan returning with max=8b
[  245.335686] pci_scan_bridge: pcieport 0000:80:0e.0: scanning [bus 90-94] behind bridge, pass 0
[  245.335690] pci_scan_child_bus: pci_bus 0000:90: scanning bus
[  245.335694] pci_scan_child_bus: pci_bus 0000:90: bus scan returning with max=90
[  245.335698] pci_scan_bridge: pcieport 0000:80:0b.0: scanning [bus 81-85] behind bridge, pass 1
[  245.335702] pci_scan_bridge: pcieport 0000:80:0c.0: scanning [bus 86-8a] behind bridge, pass 1
[  245.335706] pci_scan_bridge: pcieport 0000:80:0d.0: scanning [bus 8b-8f] behind bridge, pass 1
[  245.335710] pci_scan_bridge: pcieport 0000:80:0e.0: scanning [bus 90-94] behind bridge, pass 1
[  245.335714] pci_scan_child_bus: pci_bus 0000:80: bus scan returning with max=94
[  245.388012] Fusion MPT base driver 3.04.20
[  245.388018] Copyright (c) 1999-2008 LSI Corporation
[  245.401039] Fusion MPT FC Host driver 3.04.20
[  245.401481] mptbase: ioc0: Initiating bringup
[  245.401486] mptbase: ioc0: WARNING - Unexpected doorbell active!
[  305.587210] mptbase: ioc0: ERROR - Failed to come READY after reset! IocState=f0000000
[  305.587220] mptbase: ioc0: WARNING - ResetHistory bit failed to clear!
[  305.587223] mptbase: ioc0: ERROR - Diagnostic reset FAILED! (ffffffffh)
[  305.587226] mptbase: ioc0: WARNING - NOT READY WARNING!
[  305.587229] mptbase: ioc0: ERROR - didn't initialize properly! (-1)
[  305.587318] mptfc: probe of 0000:06:00.0 failed with error -1

