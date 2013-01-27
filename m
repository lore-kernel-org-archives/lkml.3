Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3A0WxZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 17:53:25 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37212 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab3A0WxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 17:53:21 -0500
Message-ID: <5105AFDB.9000200@googlemail.com>
Date: Sun, 27 Jan 2013 22:53:15 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130108 Thunderbird/17.0.2
MIME-Version: 1.0
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
CC: Yijing Wang <wangyijing0307@gmail.com>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz>
In-Reply-To: <510558CE.9000600@fold.natur.cuni.cz>
Content-Type: multipart/mixed;
 boundary="------------060705070907060808000202"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060705070907060808000202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Thanks again, Martin.

Firstly, maybe we should remove the linux-media list from the copy list. 
I imagine this hotplug stuff is just noise to them.

[snip]
> Do you have any other express card around to try if it works at all? Try that always after a cold boot.
>
Not at the moment, but I ordered at USB3 expresscard yesterday, so I 
will have one soon.

> Posting a diff result of the below procedure might help:
>
> # lspci -vvvxxx > lspci.before_insertion.txt
>
> [plug your card into the slot]
>
> # lspci -vvvxxx > lspci.after_insertion.txt
>
> [ unplug your card]
>
> # lspci -vvvxxx > lspci.after_1st_removal.txt
>
> [re-plug your card into the slot]
>
> # lspci -vvvxxx > lspci.after_1st_re-insertion.txt
>
> [ unplug your card]
>
> # lspci -vvvxxx > lspci.after_2nd_removal.txt
>

OK, I've been using kernel 3.8.0-rc kernels so far, but given that is 
still under development, I've switched to 3.7.4, mainly because you are 
having success with 3.7.x, acpiphp and pcie_aspm=off. I verified the 
environment as follows:

[chris:~]$ cat /proc/cmdline
root=/dev/sda5 pcie_aspm=off ro resume=/dev/sda6
[chris:~]$ dmesg | grep ASPM
[    0.000000] PCIe ASPM is disabled
[    0.348959]  pci0000:00: ACPI _OSC support notification failed, 
disabling PCIe ASPM
[chris:~]$ dmesg | grep acpiphp
[    0.400846] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[chris:~]$ dmesg | grep pciehp
[chris:~]$ uname -a
Linux laptop 3.7.4 #13 SMP PREEMPT Sun Jan 27 18:39:39 GMT 2013 i686 
GNU/Linux


> Then compare them using diff. These should have no difference:
>
> diff lspci.after_insertion.txt lspci.after_1st_re-insertion.txt
> diff lspci.after_1st_removal.txt lspci.after_2nd_removal.txt
>
Correct, there were no differences.

>
> These may have only little difference, or none:
>
> diff lspci.before_insertion.txt lspci.after_1st_removal.txt

263c263
<               LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <16us
---
  >               LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <512ns, L1 <16us
265c265
<               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- 
Retrain- CommClk-
---
  >               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
267c267
<               LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
---
  >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- 
SlotClk+ DLActive- BWMgmt+ ABWMgmt-
273c273
<                       Changed: MRL- PresDet- LinkState-
---
  >                       Changed: MRL- PresDet- LinkState+
295,296c295,296
< 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 4c 12 04
< 50: 03 00 01 10 60 b2 1c 00 08 00 00 00 00 00 00 00
---
  > 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 04
  > 50: 40 00 11 50 60 b2 1c 00 08 00 00 01 00 00 00 00

> diff lspci.after_1st_removal.txt lspci.after_2nd_removal.txt
>
No difference.
>
>
> Finally, these should confirm whether the PresDet works for you (for me NOT with pciehp but does work with acpiphp).
> You should see PresDet- to PresDet+ changes in:
>
Yes, I do see the PresDet- to PresDet+ changes

> diff lspci.before_insertion.txt lspci.after_insertion.txt

263c263
<               LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <1us, L1 <16us
---
  >               LnkCap: Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <512ns, L1 <16us
265c265
<               LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- 
Retrain- CommClk-
---
  >               LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
267c267
<               LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
---
  >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- 
SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
272,273c272,273
<               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
<                       Changed: MRL- PresDet- LinkState-
---
  >               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
  >                       Changed: MRL- PresDet- LinkState+
295,296c295,296
< 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 4c 12 04
< 50: 03 00 01 10 60 b2 1c 00 08 00 00 00 00 00 00 00
---
  > 40: 10 80 42 01 00 80 00 00 00 00 10 00 12 3c 12 04
  > 50: 40 00 11 70 60 b2 1c 00 08 00 40 01 00 00 00 00

> diff lspci.after_1st_removal.txt lspci.after_1st_re-insertion.txt
267c267
<               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt+ ABWMgmt-
---
  >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- 
SlotClk+ DLActive+ BWMgmt+ ABWMgmt-
272c272
<               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
---
  >               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
296c296
< 50: 40 00 11 50 60 b2 1c 00 08 00 00 01 00 00 00 00
---
  > 50: 40 00 11 70 60 b2 1c 00 08 00 40 01 00 00 00 00

>
> You should see PresDet+ to PresDet- changes in:
Yes, I see those changes too.
> diff lspci.after_insertion.txt lspci.after_1st_removal.txt
267c267
<               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
---
  >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- 
SlotClk+ DLActive- BWMgmt+ ABWMgmt-
272c272
<               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
---
  >               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
296c296
< 50: 40 00 11 70 60 b2 1c 00 08 00 40 01 00 00 00 00
---
  > 50: 40 00 11 50 60 b2 1c 00 08 00 00 01 00 00 00 00

> diff lspci.after_1st_re-insertion.txt lspci.after_2nd_removal.txt
267c267
<               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive+ BWMgmt+ ABWMgmt-
---
  >               LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- 
SlotClk+ DLActive- BWMgmt+ ABWMgmt-
272c272
<               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet+ Interlock-
---
  >               SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- 
PresDet- Interlock-
296c296
< 50: 40 00 11 70 60 b2 1c 00 08 00 40 01 00 00 00 00
---
  > 50: 40 00 11 50 60 b2 1c 00 08 00 00 01 00 00 00 00
>
> I did plenty of these with my laptop using 3.3.x and 3.7.1 and the conclusion was
> that pciehp got broken since some 3.6? (commit 0d52f54e2ef64c189dedc332e680b2eb4a34590a)
> but I can live on 3.7.x with acpiphp and pcie_aspm=off.

I could live with that too, but despite my findings being in line with 
your predictions, hotplug does not work for me.

> The above test could tell you what
> works in your case. Of course, you can try separately pciehp and acpiphp. With 3.4
> series I lived with pciehp and pcie_aspm=force.
Need sleep now, but tomorrow, I'll build a 3.4 kernel and try pciehp and 
pcie_aspm=force.
>
> Martin
> BTW: Re-post your dmesg output so that we can see if you those OSC errors
> (for details see "Re: Dell Vostro 3550: pci_hotplug+acpiphp require 'pcie_aspm=force' on kernel command-line for hotplug to work" thread).
>
I've attached a file containing the output from dmesg. I does contain 
errors related to OSC.


--------------060705070907060808000202
Content-Type: text/plain; charset=us-ascii;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.txt"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.7.4 (chris@laptop) (gcc version 4.7.3 20130126 (prerelease) (GCC) ) #13 SMP PREEMPT Sun Jan 27 18:39:39 GMT 2013
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000008ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dab0efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dab0f000-0x00000000dad4efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dad4f000-0x00000000dad6efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dad6f000-0x00000000daf1efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000daf1f000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd80000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: FUJITSU LIFEBOOK AH531/FJNBB0F, BIOS 1.27 12/08/2011
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x21fe00 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask F00000000 write-back
[    0.000000]   7 base 200000000 mask FE0000000 write-back
[    0.000000]   8 base 21FE00000 mask FFFE00000 uncachable
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x01bfffff]
[    0.000000] Base memory trampoline at [c008c000] 8c000 size 16384
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] init_memory_mapping: [mem 0x00000000-0x37bfdfff]
[    0.000000]  [mem 0x00000000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x379fffff] page 2M
[    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x37bfdfff @ [mem 0x01bfa000-0x01bfffff]
[    0.000000] ACPI: RSDP 000f00e0 00024 (v02 FUJ   )
[    0.000000] ACPI: XSDT daffe120 00084 (v01 FUJ    PC       00000001 FUJ  00000001)
[    0.000000] ACPI: FACP daff0000 000F4 (v03 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: DSDT daff3000 0794A (v02 FUJ    FJNBB0F  00000000 INTL 20061109)
[    0.000000] ACPI: FACS daf3d000 00040
[    0.000000] ACPI: SLIC daffd000 00176 (v01 FUJ    PC       00000001 FUJ  00000001)
[    0.000000] ACPI: SSDT daffb000 01068 (v01 FUJ    PtidDevc 00001000 INTL 20061109)
[    0.000000] ACPI: ASF! daff2000 000A5 (v32 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: HPET dafef000 00038 (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: APIC dafee000 00098 (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: MCFG dafed000 0003C (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: SSDT dafec000 007C2 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT dafeb000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: UEFI dafea000 0003E (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: UEFI dafe9000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: UEFI dafe8000 00242 (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 7810MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]
[    0.000000]   HighMem  [mem 0x37bfe000-0x1fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0008ffff]
[    0.000000]   node   0: [mem 0x00100000-0xdab0efff]
[    0.000000]   node   0: [mem 0xdafff000-0xdaffffff]
[    0.000000]   node   0: [mem 0x00000000-0x1fdfffff]
[    0.000000] On node 0 totalpages: 2074768
[    0.000000] free_area_init_node: node 0, pgdat c156a780, node_mem_map f37fd200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3936 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 222502 pages, LIFO batch:31
[    0.000000]   HighMem zone: 15621 pages used for memmap
[    0.000000]   HighMem zone: 1830925 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 14, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: 8 Processors exceeds NR_CPUS limit of 4
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000090000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f37bb000 s25792 r0 d23360 u49152
[    0.000000] pcpu-alloc: s25792 r0 d23360 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2057363
[    0.000000] Kernel command line: root=/dev/sda5 pcie_aspm=off ro resume=/dev/sda6
[    0.000000] PCIe ASPM is disabled
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (00037bfe:0021fe00)
[    0.000000] Memory: 8221556k/8910848k available (4093k kernel code, 77512k reserved, 1474k data, 372k init, 7386180k highmem)
[    0.000000] virtual kernel memory layout:
    fixmap  : 0xfff67000 - 0xfffff000   ( 608 kB)
    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
    vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
      .init : 0xc1570000 - 0xc15cd000   ( 372 kB)
      .data : 0xc13ff690 - 0xc156fec0   (1474 kB)
      .text : 0xc1000000 - 0xc13ff690   (4093 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:2304 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f3008000 soft=f300a000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2494.153 MHz processor
[    0.000001] Calibrating delay loop (skipped), value calculated using timer frequency.. 4988.30 BogoMIPS (lpj=9976612)
[    0.000115] pid_max: default: 32768 minimum: 301
[    0.000197] Mount-cache hash table entries: 512
[    0.000404] Disabled fast string operations
[    0.000459] CPU: Physical Processor ID: 0
[    0.000521] CPU: Processor Core ID: 0
[    0.000579] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.000658] mce: CPU supports 7 MCE banks
[    0.000720] CPU0: Thermal monitoring enabled (TM1)
[    0.000780] process: using mwait in idle threads
[    0.000841] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 5
[    0.001040] Freeing SMP alternatives: 16k freed
[    0.001098] ACPI: Core revision 20120913
[    0.005809] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.006284] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.045971] smpboot: CPU0: Intel(R) Core(TM) i5-2450M CPU @ 2.50GHz (fam: 06, model: 2a, stepping: 07)
[    0.152281] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.152513] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.152574] ... version:                3
[    0.152629] ... bit width:              48
[    0.152683] ... generic registers:      4
[    0.152738] ... value mask:             0000ffffffffffff
[    0.152794] ... max period:             000000007fffffff
[    0.152851] ... fixed-purpose events:   3
[    0.152906] ... event mask:             000000070000000f
[    0.184322] CPU 1 irqstacks, hard=f309a000 soft=f309c000
[    0.194584] Initializing CPU#1
[    0.195337] Disabled fast string operations
[    0.184325] smpboot: Booting Node   0, Processors  #1
[    0.204295] CPU 2 irqstacks, hard=f30b2000 soft=f30b4000
[    0.214730] Initializing CPU#2
[    0.215518] Disabled fast string operations
[    0.204464]  #2
[    0.224271] CPU 3 irqstacks, hard=f30be000 soft=f30c8000
[    0.224441]  #3 OK
[    0.234718] Initializing CPU#3
[    0.235505] Disabled fast string operations
[    0.237613] Brought up 4 CPUs
[    0.237775] smpboot: Total of 4 processors activated (19953.22 BogoMIPS)
[    0.240453] devtmpfs: initialized
[    0.240677] PM: Registering ACPI NVS region [mem 0xdad4f000-0xdad6efff] (131072 bytes)
[    0.240740] PM: Registering ACPI NVS region [mem 0xdaf1f000-0xdaf9efff] (524288 bytes)
[    0.240865] NET: Registered protocol family 16
[    0.241064] ACPI: bus type pci registered
[    0.241159] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.241234] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.241293] PCI: Using MMCONFIG for extended config space
[    0.241350] PCI: Using configuration type 1 for base access
[    0.242532] bio: create slab <bio-0> at 0
[    0.242626] ACPI: Added _OSI(Module Device)
[    0.242681] ACPI: Added _OSI(Processor Device)
[    0.242737] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.242793] ACPI: Added _OSI(Processor Aggregator Device)
[    0.244072] ACPI: EC: Look up EC in DSDT
[    0.245320] ACPI: Executed 1 blocks of module-level executable AML code
[    0.264186] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.264622] ACPI: SSDT dad4d718 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.265074] ACPI: Dynamic OEM Table Load:
[    0.265206] ACPI: SSDT   (null) 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.284370] ACPI: SSDT daf0fa98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.284847] ACPI: Dynamic OEM Table Load:
[    0.284980] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.304224] ACPI: SSDT dad4cd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.304667] ACPI: Dynamic OEM Table Load:
[    0.304800] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.324680] ACPI: Interpreter enabled
[    0.324738] ACPI: (supports S0 S3 S4 S5)
[    0.324962] ACPI: Using IOAPIC for interrupt routing
[    0.328321] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.328514] ACPI: No dock devices found.
[    0.328572] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.328920] \_SB_.PCI0:_OSC invalid UUID
[    0.328921] _OSC request data:1 8 1f 
[    0.328924] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.329438] PCI host bridge to bus 0000:00
[    0.329495] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.329553] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.329611] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.329670] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.329730] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.329789] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.329855] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.329887] pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
[    0.329896] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.329902] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.329906] pci 0000:00:02.0: reg 20: [io  0x4000-0x403f]
[    0.329953] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.329976] pci 0000:00:16.0: reg 10: [mem 0xf1605000-0xf160500f 64bit]
[    0.330038] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.330071] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.330092] pci 0000:00:1a.0: reg 10: [mem 0xf160a000-0xf160a3ff]
[    0.330165] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.330190] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.330205] pci 0000:00:1b.0: reg 10: [mem 0xf1600000-0xf1603fff 64bit]
[    0.330259] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.330285] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.330385] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.330422] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
[    0.330523] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.330556] pci 0000:00:1c.5: [8086:1c1a] type 01 class 0x060400
[    0.330616] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.330647] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.330667] pci 0000:00:1d.0: reg 10: [mem 0xf1609000-0xf16093ff]
[    0.330739] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.330766] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
[    0.330878] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
[    0.330896] pci 0000:00:1f.2: reg 10: [io  0x4088-0x408f]
[    0.330904] pci 0000:00:1f.2: reg 14: [io  0x4094-0x4097]
[    0.330912] pci 0000:00:1f.2: reg 18: [io  0x4080-0x4087]
[    0.330920] pci 0000:00:1f.2: reg 1c: [io  0x4090-0x4093]
[    0.330927] pci 0000:00:1f.2: reg 20: [io  0x4060-0x407f]
[    0.330935] pci 0000:00:1f.2: reg 24: [mem 0xf1608000-0xf16087ff]
[    0.330967] pci 0000:00:1f.2: PME# supported from D3hot
[    0.330986] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.331001] pci 0000:00:1f.3: reg 10: [mem 0xf1604000-0xf16040ff 64bit]
[    0.331022] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.331276] pci 0000:01:00.0: [8086:008a] type 00 class 0x028000
[    0.331424] pci 0000:01:00.0: reg 10: [mem 0xf1500000-0xf1501fff 64bit]
[    0.331976] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.340174] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.340238] pci 0000:00:1c.0:   bridge window [mem 0xf1500000-0xf15fffff]
[    0.340316] pci 0000:00:1c.3: PCI bridge to [bus 02-06]
[    0.340376] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.340381] pci 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.340389] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.340456] pci 0000:07:00.0: [10ec:8168] type 00 class 0x020000
[    0.340476] pci 0000:07:00.0: reg 10: [io  0x2000-0x20ff]
[    0.340510] pci 0000:07:00.0: reg 18: [mem 0xf0c04000-0xf0c04fff 64bit pref]
[    0.340531] pci 0000:07:00.0: reg 20: [mem 0xf0c00000-0xf0c03fff 64bit pref]
[    0.340591] pci 0000:07:00.0: supports D1 D2
[    0.340592] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.348055] pci 0000:00:1c.5: PCI bridge to [bus 07]
[    0.348681] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.348689] pci 0000:00:1c.5:   bridge window [mem 0xf0c00000-0xf0cfffff 64bit pref]
[    0.348710] pci_bus 0000:00: on NUMA node 0
[    0.348712] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.348826] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.348857] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.348885] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.348956] \_SB_.PCI0:_OSC invalid UUID
[    0.348957] _OSC request data:1 9 1f 
[    0.348959]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.349021]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.351134] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    0.351698] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    0.352262] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.352822] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    0.353384] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.354024] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.354664] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.355226] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.355802] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.355865] vgaarb: loaded
[    0.355917] vgaarb: bridge control possible 0000:00:02.0
[    0.356025] SCSI subsystem initialized
[    0.356079] ACPI: bus type scsi registered
[    0.356146] libata version 3.00 loaded.
[    0.356149] ACPI: bus type usb registered
[    0.356220] usbcore: registered new interface driver usbfs
[    0.356285] usbcore: registered new interface driver hub
[    0.356359] usbcore: registered new device driver usb
[    0.356430] Linux video capture interface: v2.00
[    0.356511] Advanced Linux Sound Architecture Driver Initialized.
[    0.356569] PCI: Using ACPI for IRQ routing
[    0.358248] PCI: pci_cache_line_size set to 64 bytes
[    0.358345] e820: reserve RAM buffer [mem 0xdab0f000-0xdbffffff]
[    0.358347] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.358348] e820: reserve RAM buffer [mem 0x21fe00000-0x21fffffff]
[    0.358468] Switching to clocksource hpet
[    0.358566] pnp: PnP ACPI init
[    0.358622] ACPI: bus type pnp registered
[    0.358918] pnp 00:00: [bus 00-3e]
[    0.358920] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.358921] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.358923] pnp 00:00: [io  0x0d00-0xffff window]
[    0.358924] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.358925] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.358928] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.358929] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.358930] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.358932] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.358933] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.358934] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.358935] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.358937] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.358938] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.358939] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.358940] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.358941] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.358943] pnp 00:00: [mem 0xdfa00000-0xfeafffff window]
[    0.358944] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.358964] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.358978] pnp 00:01: [io  0x0000-0x001f]
[    0.358979] pnp 00:01: [io  0x0081-0x0091]
[    0.358980] pnp 00:01: [io  0x0093-0x009f]
[    0.358981] pnp 00:01: [io  0x00c0-0x00df]
[    0.358983] pnp 00:01: [dma 4]
[    0.358994] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.358999] pnp 00:02: [mem 0xff000000-0xffffffff]
[    0.359010] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.359063] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    0.359075] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.359081] pnp 00:04: [io  0x00f0]
[    0.359088] pnp 00:04: [irq 13]
[    0.359099] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.359108] pnp 00:05: [io  0x002e-0x002f]
[    0.359109] pnp 00:05: [io  0x004e-0x004f]
[    0.359110] pnp 00:05: [io  0x0061]
[    0.359111] pnp 00:05: [io  0x0063]
[    0.359112] pnp 00:05: [io  0x0065]
[    0.359113] pnp 00:05: [io  0x0067]
[    0.359114] pnp 00:05: [io  0x0070]
[    0.359115] pnp 00:05: [io  0x0080]
[    0.359116] pnp 00:05: [io  0x0092]
[    0.359117] pnp 00:05: [io  0x00b2-0x00b3]
[    0.359118] pnp 00:05: [io  0x0680-0x069f]
[    0.359119] pnp 00:05: [io  0x1000-0x100f]
[    0.359120] pnp 00:05: [io  0xffff]
[    0.359122] pnp 00:05: [io  0xffff]
[    0.359123] pnp 00:05: [io  0x0400-0x0453]
[    0.359124] pnp 00:05: [io  0x0458-0x047f]
[    0.359125] pnp 00:05: [io  0x0500-0x057f]
[    0.359126] pnp 00:05: [io  0x164e-0x164f]
[    0.359127] pnp 00:05: [io  0x0068-0x0077]
[    0.359148] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.359206] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.359264] system 00:05: [io  0xffff] has been reserved
[    0.359322] system 00:05: [io  0xffff] has been reserved
[    0.359379] system 00:05: [io  0x0400-0x0453] has been reserved
[    0.359436] system 00:05: [io  0x0458-0x047f] has been reserved
[    0.359494] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.359552] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.359611] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.359616] pnp 00:06: [io  0x0070-0x0077]
[    0.359620] pnp 00:06: [irq 8]
[    0.359631] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.359651] pnp 00:07: [io  0x0454-0x0457]
[    0.359669] system 00:07: [io  0x0454-0x0457] has been reserved
[    0.359727] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.359733] pnp 00:08: [io  0x0060]
[    0.359734] pnp 00:08: [io  0x0064]
[    0.359738] pnp 00:08: [irq 1]
[    0.359749] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.359757] pnp 00:09: [irq 12]
[    0.359768] pnp 00:09: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.359854] pnp 00:0a: [mem 0xfed1c000-0xfed1ffff]
[    0.359855] pnp 00:0a: [mem 0xfed10000-0xfed17fff]
[    0.359857] pnp 00:0a: [mem 0xfed18000-0xfed18fff]
[    0.359858] pnp 00:0a: [mem 0xfed19000-0xfed19fff]
[    0.359859] pnp 00:0a: [mem 0xf8000000-0xfbffffff]
[    0.359860] pnp 00:0a: [mem 0xfed20000-0xfed3ffff]
[    0.359861] pnp 00:0a: [mem 0xfed90000-0xfed93fff]
[    0.359862] pnp 00:0a: [mem 0xfed45000-0xfed8ffff]
[    0.359863] pnp 00:0a: [mem 0xff000000-0xffffffff]
[    0.359865] pnp 00:0a: [mem 0xfee00000-0xfeefffff]
[    0.359866] pnp 00:0a: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.359886] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.359946] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.360005] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.360074] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.360134] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.360194] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.360253] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.360313] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.360373] system 00:0a: [mem 0xff000000-0xffffffff] could not be reserved
[    0.360433] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.360493] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.360642] pnp 00:0b: [mem 0x20000000-0x201fffff]
[    0.360643] pnp 00:0b: [mem 0x40000000-0x401fffff]
[    0.360665] system 00:0b: [mem 0x20000000-0x201fffff] could not be reserved
[    0.360725] system 00:0b: [mem 0x40000000-0x401fffff] could not be reserved
[    0.360785] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.360817] pnp: PnP ACPI: found 12 devices
[    0.360872] ACPI: ACPI bus type pnp unregistered
[    0.396678] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.396741] pci 0000:00:1c.0:   bridge window [mem 0xf1500000-0xf15fffff]
[    0.396811] pci 0000:00:1c.3: PCI bridge to [bus 02-06]
[    0.396871] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.396934] pci 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.396998] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.397066] pci 0000:00:1c.5: PCI bridge to [bus 07]
[    0.397123] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.397185] pci 0000:00:1c.5:   bridge window [mem 0xf0c00000-0xf0cfffff 64bit pref]
[    0.397274] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.397276] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.397277] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.397278] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfeafffff]
[    0.397280] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.397281] pci_bus 0000:01: resource 1 [mem 0xf1500000-0xf15fffff]
[    0.397282] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.397284] pci_bus 0000:02: resource 1 [mem 0xf0d00000-0xf14fffff]
[    0.397285] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.397286] pci_bus 0000:07: resource 0 [io  0x2000-0x2fff]
[    0.397288] pci_bus 0000:07: resource 2 [mem 0xf0c00000-0xf0cfffff 64bit pref]
[    0.397310] NET: Registered protocol family 2
[    0.397457] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.397703] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.397849] TCP: Hash tables configured (established 131072 bind 65536)
[    0.397922] TCP: reno registered
[    0.397977] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.398038] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.398133] NET: Registered protocol family 1
[    0.398196] pci 0000:00:02.0: Boot video device
[    0.398293] PCI: CLS 64 bytes, default 64
[    0.398912] bounce pool size: 64 pages
[    0.400057] fuse init (API version 7.20)
[    0.400171] msgmni has been set to 1631
[    0.400453] io scheduler noop registered
[    0.400528] io scheduler cfq registered (default)
[    0.400788] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.400846] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.401204] ACPI: AC Adapter [ACAD] (on-line)
[    0.401302] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.401366] ACPI: Power Button [PWRB]
[    0.401445] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    0.401520] ACPI: Lid Switch [LID]
[    0.401598] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.401659] ACPI: Power Button [PWRF]
[    0.404598] thermal LNXTHERM:00: registered as thermal_zone0
[    0.404657] ACPI: Thermal Zone [THRM] (58 C)
[    0.404724] isapnp: Scanning for PnP cards...
[    0.405301] ACPI: Battery Slot [BAT1] (battery present)
[    0.758276] isapnp: No Plug & Play device found
[    0.762777] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.763137] Real Time Clock Driver v1.12b
[    0.763192] Linux agpgart interface v0.103
[    0.763269] [drm] Initialized drm 1.1.0 20060810
[    0.763467] pci 0000:00:00.0: Intel Sandybridge Chipset
[    0.763552] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    0.764350] pci 0000:00:00.0: detected 65536K stolen memory
[    0.764450] i915 0000:00:02.0: setting latency timer to 64
[    0.764618] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.764677] [drm] Driver supports precise vblank timestamp query.
[    0.764767] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.950840] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    1.121073] fbcon: inteldrmfb (fb0) is primary device
[    1.393219] tsc: Refined TSC clocksource calibration: 2494.337 MHz
[    1.393225] Switching to clocksource tsc
[    2.301651] Console: switching to colour frame buffer device 170x48
[    2.304426] fb0: inteldrmfb frame buffer device
[    2.304441] drm: registered panic notifier
[    2.336754] acpi device:31: registered as cooling_device4
[    2.336887] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.336940] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    2.336984] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.337077] ahci 0000:00:1f.2: version 3.0
[    2.351993] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x9 impl SATA mode
[    2.352066] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    2.352098] ahci 0000:00:1f.2: setting latency timer to 64
[    2.360245] scsi0 : ahci
[    2.360297] scsi1 : ahci
[    2.360338] scsi2 : ahci
[    2.360379] scsi3 : ahci
[    2.360419] scsi4 : ahci
[    2.360462] scsi5 : ahci
[    2.360495] ata1: SATA max UDMA/133 abar m2048@0xf1608000 port 0xf1608100 irq 19
[    2.360522] ata2: DUMMY
[    2.360529] ata3: DUMMY
[    2.360539] ata4: SATA max UDMA/133 abar m2048@0xf1608000 port 0xf1608280 irq 19
[    2.360565] ata5: DUMMY
[    2.360572] ata6: DUMMY
[    2.360607] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.361483] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.361485] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    2.362308] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.363138] ehci_hcd 0000:00:1a.0: debug port 2
[    2.367834] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    2.367838] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf160a000
[    2.379932] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.380791] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.381576] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.382360] usb usb1: Product: EHCI Host Controller
[    2.383143] usb usb1: Manufacturer: Linux 3.7.4 ehci_hcd
[    2.383927] usb usb1: SerialNumber: 0000:00:1a.0
[    2.384781] hub 1-0:1.0: USB hub found
[    2.385552] hub 1-0:1.0: 2 ports detected
[    2.386366] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.386369] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    2.387136] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.387924] ehci_hcd 0000:00:1d.0: debug port 2
[    2.392582] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    2.392594] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf1609000
[    2.403903] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.404733] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.405495] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.406253] usb usb2: Product: EHCI Host Controller
[    2.406997] usb usb2: Manufacturer: Linux 3.7.4 ehci_hcd
[    2.407726] usb usb2: SerialNumber: 0000:00:1d.0
[    2.408508] hub 2-0:1.0: USB hub found
[    2.409222] hub 2-0:1.0: 2 ports detected
[    2.409974] uhci_hcd: USB Universal Host Controller Interface driver
[    2.410732] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.417631] i8042: Detected active multiplexing controller, rev 1.1
[    2.421750] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.422491] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    2.423221] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    2.423938] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    2.424625] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    2.425324] mousedev: PS/2 mouse device common for all mice
[    2.426045] i2c /dev entries driver
[    2.426811] ACPI Warning: 0x0000efa0-0x0000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120913/utaddress-251)
[    2.427493] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    2.428222] IR NEC protocol handler initialized
[    2.428941] IR RC5(x) protocol handler initialized
[    2.429660] IR RC6 protocol handler initialized
[    2.430388] IR JVC protocol handler initialized
[    2.431116] IR Sony protocol handler initialized
[    2.431839] IR RC5 (streamzap) protocol handler initialized
[    2.432553] IR SANYO protocol handler initialized
[    2.433274] IR MCE Keyboard/mouse protocol handler initialized
[    2.434021] usbcore: registered new interface driver uvcvideo
[    2.434740] USB Video Class driver (1.1.1)
[    2.435465] cpuidle: using governor ladder
[    2.436180] cpuidle: using governor menu
[    2.437050] usbcore: registered new interface driver usbhid
[    2.437761] usbhid: USB HID core driver
[    2.438549] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.439262] TCP: cubic registered
[    2.439986] NET: Registered protocol family 17
[    2.440699] NET: Registered protocol family 15
[    2.441512] Using IPI No-Shortcut mode
[    2.448477] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.679555] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.686216] ata4.00: ATAPI: TSSTcorp CDDVDW SN-208AB, FC01, max UDMA/100
[    2.687543] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.692366] ata4.00: configured for UDMA/100
[    2.695530] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    2.741379] ata1.00: ATA-8: TOSHIBA MK7575GSX, GT001A, max UDMA/100
[    2.742196] ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.743038] ata1.00: failed to get Identify Device Data, Emask 0x1
[    2.743875] ata1.00: failed to get Identify Device Data, Emask 0x1
[    2.743881] ata1.00: configured for UDMA/100
[    2.751592] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK7575GS GT00 PQ: 0 ANSI: 5
[    2.752481] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    2.753274] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    2.754078] sd 0:0:0:0: [sda] Write Protect is off
[    2.754832] scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW SN-208AB  FC01 PQ: 0 ANSI: 5
[    2.755657] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.755668] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.757804] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.758704] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.759607] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.827708] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    2.828600] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.829631] hub 1-1:1.0: USB hub found
[    2.830577] hub 1-1:1.0: 6 ports detected
[    2.906897]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 >
[    2.908086] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.928769] registered taskstats version 1
[    2.929918] ALSA device list:
[    2.930772]   No soundcards found.
[    2.943212] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    2.965688] kjournald starting.  Commit interval 5 seconds
[    2.965740] EXT3-fs (sda5): mounted filesystem with writeback data mode
[    2.965746] VFS: Mounted root (ext3 filesystem) readonly on device 8:5.
[    2.986497] devtmpfs: mounted
[    2.987374] Freeing unused kernel memory: 372k freed
[    3.075386] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    3.076290] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.077306] hub 2-1:1.0: USB hub found
[    3.078251] hub 2-1:1.0: 6 ports detected
[    3.151039] usb 1-1.3: new high-speed USB device number 3 using ehci_hcd
[    3.276623] usb 1-1.3: New USB device found, idVendor=04f2, idProduct=b213
[    3.277538] usb 1-1.3: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    3.278405] usb 1-1.3: Product: FJ Camera
[    3.279270] usb 1-1.3: Manufacturer: Sonix Technology Co., Ltd.
[    3.280133] usb 1-1.3: SerialNumber: SN0001
[    3.283036] uvcvideo: Found UVC 1.00 device FJ Camera (04f2:b213)
[    3.293457] input: FJ Camera as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.3/1-1.3:1.0/input/input5
[    3.366757] usb 2-1.2: new low-speed USB device number 3 using ehci_hcd
[    3.462008] usb 2-1.2: New USB device found, idVendor=0461, idProduct=4d20
[    3.462987] usb 2-1.2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    3.463891] usb 2-1.2: Product: USB Optical Mouse
[    3.467189] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input6
[    3.468145] hid-generic 0003:0461:4D20.0001: input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.0-1.2/input0
[    3.538532] usb 2-1.6: new high-speed USB device number 4 using ehci_hcd
[    3.892326] usb 2-1.6: New USB device found, idVendor=0bda, idProduct=0138
[    3.893341] usb 2-1.6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.894295] usb 2-1.6: Product: USB2.0-CRW
[    3.895228] usb 2-1.6: Manufacturer: Generic
[    3.896149] usb 2-1.6: SerialNumber: 20090516388200000
[    4.319631] EXT3-fs (sda5): using internal journal
[    5.083366] udevd[93]: starting version 182
[    5.378272] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x23
[    5.525501] input: Fujitsu FUJ02B1 as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:01/FUJ02B1:00/input/input7
[    5.526976] hda_codec: ALC269VB: SKU not ready 0x90970130
[    5.527608] fujitsu_laptop: ACPI: Fujitsu FUJ02B1 [FJEX] (on)
[    5.527777] input: Fujitsu FUJ02E3 as /devices/LNXSYSTM:00/LNXSYBUS:00/FUJ02E3:00/input/input8
[    5.528329] fujitsu_laptop: ACPI: Fujitsu FUJ02E3 [FEXT] (on)
[    5.528428] fujitsu_laptop: BTNI: [0x80001]
[    5.528481] fujitsu_laptop: driver 0.6.0 successfully loaded
[    5.532532] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.532820] r8169 0000:07:00.0 eth0: RTL8168e/8111e at 0xf841c000, 5c:9a:d8:5c:63:31, XID 0c200000 IRQ 17
[    5.532822] r8169 0000:07:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    5.752278] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x23
[    5.914907] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x23
[    5.920413] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x23
[    5.926595] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    6.196068] Initializing USB Mass Storage driver...
[    6.197172] scsi6 : usb-storage 2-1.6:1.0
[    6.198261] usbcore: registered new interface driver usb-storage
[    6.199272] USB Mass Storage support registered.
[    6.554409] r8169 0000:07:00.0 eth0: link down
[    6.555360] r8169 0000:07:00.0 eth0: link down
[    7.196560] scsi 6:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
[    7.203146] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[    7.910425] microcode: CPU0 updated to revision 0x25, date = 2011-10-11
[    7.911814] microcode: CPU1 updated to revision 0x25, date = 2011-10-11
[    7.913586] microcode: CPU2 updated to revision 0x25, date = 2011-10-11
[    7.914919] microcode: CPU3 updated to revision 0x25, date = 2011-10-11
[    8.126477] r8169 0000:07:00.0 eth0: link up
[    8.392416] kjournald starting.  Commit interval 5 seconds
[    8.392442] EXT3-fs (sda8): warning: maximal mount count reached, running e2fsck is recommended
[    8.392558] EXT3-fs (sda8): using internal journal
[    8.392558] EXT3-fs (sda8): mounted filesystem with writeback data mode
[    8.421945] kjournald starting.  Commit interval 5 seconds
[    8.421985] EXT3-fs (sda9): warning: maximal mount count reached, running e2fsck is recommended
[    8.422104] EXT3-fs (sda9): using internal journal
[    8.422104] EXT3-fs (sda9): mounted filesystem with writeback data mode
[    8.448634] kjournald starting.  Commit interval 5 seconds
[    8.448801] EXT3-fs (sda10): using internal journal
[    8.448802] EXT3-fs (sda10): mounted filesystem with writeback data mode
[    8.534607] Adding 8191996k swap on /dev/sda6.  Priority:-1 extents:1 across:8191996k 
[   19.053917] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)

--------------060705070907060808000202--
