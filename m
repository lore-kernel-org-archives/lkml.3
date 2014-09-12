Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaILLM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:12:58 -0400
Received: from services.gouders.net ([141.101.32.176]:52954 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaILLMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:12:54 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <ghvbotd8es.fsf@quad.gouders.net> (Dirk Gouders's message of
	"Fri, 12 Sep 2014 01:50:03 +0200")
References: <ghiol53r9u.fsf@lena.gouders.net>
	<CAMxnaaXiEZeJOsgQ6ZSbiqy5Z1zNoXonwNSQNRyRhV0t5jveYQ@mail.gmail.com>
	<ghwq9k3m6z.fsf@lena.gouders.net>
	<CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
	<ghioku5l29.fsf@lena.gouders.net>
	<CAErSpo7j=a3y2MVsvEQGQ4B63_mNCyZSRNXNEZa-2++xs88NmQ@mail.gmail.com>
	<CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
	<ghppf15236.fsf@quad.gouders.net>
	<CAErSpo5SVUOz+qa_x5JTC+-Y5ewTyYzA0N=jyPtK9LaguRrt=w@mail.gmail.com>
	<ghd2b1svdw.fsf@quad.gouders.net>
	<CAErSpo5e0GOdVbZdQYriP+aWziKELpb9BWTgJ4ERPia354CM5w@mail.gmail.com>
	<ghvbotd8es.fsf@quad.gouders.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Fri, 12 Sep 2014 13:11:34 +0200
Message-ID: <ghzje5f5zt.fsf@lena.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk Gouders <dirk@gouders.net> writes:

> Bjorn Helgaas <bhelgaas@google.com> writes:
>
>> On Thu, Sep 11, 2014 at 3:24 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>> Bjorn Helgaas <bhelgaas@google.com> writes:
>>>
>>>> On Thu, Sep 11, 2014 at 2:33 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>>>> What I was currently trying was to construct a test-environment so that
>>>>> I do not need to do tests and diagnosis on a busy machine.
>>>>>
>>>>> I noticed that this problem seems to start with the narrow Root
>>>>> Bridge window (00-07) but every other machine that I had a look at,
>>>>> starts with (00-ff), so those will not trigger my problem.
>>>>>
>>>>> I thought I could perhaps try to shrink the window in
>>>>> acpi_pci_root_add() to trigger the problem and that kind of works: it
>>>>> triggers it but not exactly the same way, because it basically ends at
>>>>> this code in pci_scan_bridge():
>>>>>
>>>>>         if (max >= bus->busn_res.end) {
>>>>>                 dev_warn(&dev->dev, "can't allocate child bus %02x from %pR (pass %d)\n",
>>>>>                          max, &bus->busn_res, pass);
>>>>>                 goto out;
>>>>>         }
>>>>>
>>>>> If this could work but I am just missing a small detail, I would be
>>>>> glad to hear about it and do the first tests this way.  If it is
>>>>> complete nonsense, I will just use the machine that triggers the problem
>>>>> for the tests.
>>>>
>>>> I was about to suggest the same thing.  If the problem is related to
>>>> the bus number change, we should be able to force that to happen on a
>>>> different machine.  Your approach sounds good, so I'm guessing we just
>>>> need a tweak.
>>>>
>>>> I would first double-check that the PCI adapters are identical,
>>>> including the firmware on the card.  Can you also include your patch
>>>> and the resulting dmesg (with debug enabled as before)?
>>>
>>> Currently I am at home doing just tests for understanding and that I can
>>> hopefully use when I am back in the office.
>>>
>>> I already noticed the the backup FC Adapter on the test machine is not
>>> exactly the same: it is Rev. 1 whereas the one on the failing machine is
>>> Rev. 2.
>>>
>>> So, here at home my tests let a NIC disappear.  Different from the
>>> original problem but I was just trying to reconstruct the szenario of a
>>> misconfigured bridge causing a reconfiguration.
>>>
>>> What I was trying is:
>>>
>>> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
>>> index e6ae603..fd146b3 100644
>>> --- a/drivers/acpi/pci_root.c
>>> +++ b/drivers/acpi/pci_root.c
>>> @@ -556,6 +556,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>>>         strcpy(acpi_device_name(device), ACPI_PCI_ROOT_DEVICE_NAME);
>>>         strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
>>>         device->driver_data = root;
>>> +       root->secondary.end = 0x02;
>>>
>>>         pr_info(PREFIX "%s [%s] (domain %04x %pR)\n",
>>>                acpi_device_name(device), acpi_device_bid(device),
>>>
>>> The device that disappears is a NIC:
>>>
>>> 00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor DRAM Controller (rev 09)
>>> 00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor Graphics Controller (rev 09)
>>> 00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB xHCI Host Controller (rev 04)
>>> 00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series Chipset Family MEI Controller #1 (rev 04)
>>> 00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #2 (rev 04)
>>> 00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset Family High Definition Audio Controller (rev 04)
>>> 00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 1 (rev c4)
>>> 00:1c.4 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 5 (rev c4)
>>> 00:1c.5 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset Family PCI Express Root Port 6 (rev c4)
>>> 00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset Family USB Enhanced Host Controller #1 (rev 04)
>>> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev a4)
>>> 00:1f.0 ISA bridge: Intel Corporation B75 Express Chipset LPC Controller (rev 04)
>>> 00:1f.2 SATA controller: Intel Corporation 7 Series/C210 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)
>>> 00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family SMBus Controller (rev 04)
>>> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
>>>
>>> This is the one that is missing with the above change:
>>> 03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
>>
>> This situation is a little different, so I don't think you're
>> reproducing the situation we want to test.  On this box, you have:
>>
>>     pci_bus 0000:00: root bus resource [bus 00-02]
>>     pci 0000:00:1c.0: PCI bridge to [bus 01]
>>     pci 0000:00:1c.4: PCI bridge to [bus 02]
>>
>> so we find all the devices on bus 00 and bus 02 (there's nothing on
>> bus 01).  My guess is the 03:00.0 device is normally behind the
>> 00:1c.5 bridge, but we don't even scan behind that bridge because we
>> can't allocate a secondary bus number for it (we're not smart enough
>> to take advantage of the empty bus 01).
>>
>> On the failing box, it's different because we *do* have unused bus
>> number space, and we do actually reconfigure the bridge to use it.
>> It's just that the FC adapter doesn't respond when we use the new bus
>> number for it.
>>
>> You might be able to do something similar on the test box by:
>>
>>   - Keeping your root->secondary.end = 02 patch, so you still have [bus 00-02].
>>   - Ignoring bridges 00:1c.0 and 00:1c.4.  I would just test for those
>> devfns in pci_scan_device() and when you see them, return NULL instead
>> of trying to read the vendor ID.
>>
>> Then 00:1c.5 is probably configured by the BIOS for [bus 03], but
>> that's outside the root bridge range, so we should reconfigure it to
>> use [bus 01].  Then we should scan behind it, and we'll probably
>> discover the NIC that was previously at 03:00.0.  The device *should*
>> just work at the new bus number, since it probably doesn't have the
>> same bug the FC adapter does.
>
> Thanks for the explanation.  I tried to ignore the two bridges but the
> machine stopped with the "reconfiguring" message.
>
> Anyway, if I understood you correctly with the backup FC adapter I have
> good chances, because there is the needed unused bus number space and I
> don't have to ignore bridges.  I will test in a few hours and report.

It turned out that there is no unused bus number space on the test
machine:

-[0000:00]-+-01.0-[01-02]--+-0d.0-[02]--
           |               +-0e.0  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
           |               \-0e.1  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
           +-02.0  Broadcom BCM5785 [HT1000] Legacy South Bridge
           +-02.1  Broadcom BCM5785 [HT1000] IDE
           +-02.2  Broadcom BCM5785 [HT1000] LPC
           +-03.0  Broadcom BCM5785 [HT1000] USB
           +-03.1  Broadcom BCM5785 [HT1000] USB
           +-03.2  Broadcom BCM5785 [HT1000] USB
           +-06.0-[03]--
           +-07.0-[04]--+-04.0  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
           |            \-04.1  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
           +-08.0-[05]--
           +-09.0-[06]--
           +-0a.0-[07]----00.0  LSI Logic / Symbios Logic FC949ES Fibre Channel Adapter
           +-0b.0-[08]--
           +-0c.0  Advanced Micro Devices, Inc. [AMD/ATI] ES1000
           +-18.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-18.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-18.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           +-18.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
           +-19.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-19.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-19.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           \-19.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control

So, I used the following changes to create the space and limit the root
bridge window:

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index e6ae603..a41066b 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -556,6 +556,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	strcpy(acpi_device_name(device), ACPI_PCI_ROOT_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
 	device->driver_data = root;
+	root->secondary.end = 0x06;
 
 	pr_info(PREFIX "%s [%s] (domain %04x %pR)\n",
 	       acpi_device_name(device), acpi_device_bid(device),
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e3cf8a2..d8dc02d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1323,6 +1323,9 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 	struct pci_dev *dev;
 	u32 l;
 
+	if (devfn == PCI_DEVFN(0x08, 0) || devfn == PCI_DEVFN(0x09,0))
+		return NULL;
+
 	if (!pci_bus_read_dev_vendor_id(bus, devfn, &l, 60*1000))
 		return NULL;
 
And to me it looks as if that is the situation, I need for testing
Yinghai's patches; the FC Adapter disappeared similar to that on the
other machine (find the dmesg output at the end):

-[0000:00]-+-01.0-[01-02]--+-0d.0-[02]--
           |               +-0e.0  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
           |               \-0e.1  Broadcom BCM5785 [HT1000] SATA (PATA/IDE Mode)
           +-02.0  Broadcom BCM5785 [HT1000] Legacy South Bridge
           +-02.1  Broadcom BCM5785 [HT1000] IDE
           +-02.2  Broadcom BCM5785 [HT1000] LPC
           +-03.0  Broadcom BCM5785 [HT1000] USB
           +-03.1  Broadcom BCM5785 [HT1000] USB
           +-03.2  Broadcom BCM5785 [HT1000] USB
           +-06.0-[03]--
           +-07.0-[04]--+-04.0  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
           |            \-04.1  Broadcom Corporation NetXtreme BCM5780 Gigabit Ethernet
           +-0a.0-[05]--
           +-0b.0-[06]--
           +-0c.0  Advanced Micro Devices, Inc. [AMD/ATI] ES1000
           +-18.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-18.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-18.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           +-18.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
           +-19.0  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
           +-19.1  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Address Map
           +-19.2  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] DRAM Controller
           \-19.3  Advanced Micro Devices, Inc. [AMD] K8 [Athlon64/Opteron] Miscellaneous Control


So, I wanted to test the patches but unfortunately, the patches do not
apply cleanly; git am refuses to take the files (unknown format) and git
apply gives errors. I tried to apply them against Linus' current, v3.16,
v3.15 and v3.14.  What am I probably doing wrong, Yinghai?

Dirk

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.17.0-rc4+ (root@kapro) (gcc version 4.7.3 (Gentoo 4.7.3-r1 p1.4, pie-0.5.5) ) #8 SMP Fri Sep 12 12:56:42 CEST 2014
[    0.000000] Command line: root=/dev/sda2 dyndbg="file drivers/pci/* +fp" log_buf_len=10M
[    0.000000] tseg: 0000000000
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ffeffff] usable
[    0.000000] BIOS-e820: [mem 0x000000007fff0000-0x000000007fffdfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007fffe000-0x000000007fffffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec02fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x00000001ffffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.3 present.
[    0.000000] DMI: empty empty/TYAN Thunder K8HM S3892, BIOS 080011  09/20/2006
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x200000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0100000000 mask FF00000000 write-back
[    0.000000]   1 base 0000000000 mask FF80000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0x80000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0x7fff0 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x020ea000, 0x020eafff] PGTABLE
[    0.000000] BRK [0x020eb000, 0x020ebfff] PGTABLE
[    0.000000] BRK [0x020ec000, 0x020ecfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1ffe00000-0x1ffffffff]
[    0.000000]  [mem 0x1ffe00000-0x1ffffffff] page 2M
[    0.000000] BRK [0x020ed000, 0x020edfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x1fc000000-0x1ffdfffff]
[    0.000000]  [mem 0x1fc000000-0x1ffdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x180000000-0x1fbffffff]
[    0.000000]  [mem 0x180000000-0x1fbffffff] page 2M
[    0.000000] BRK [0x020ee000, 0x020eefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7ffeffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x7fdfffff] page 2M
[    0.000000]  [mem 0x7fe00000-0x7ffeffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x17fffffff]
[    0.000000]  [mem 0x100000000-0x17fffffff] page 2M
[    0.000000] BRK [0x020ef000, 0x020effff] PGTABLE
[    0.000000] log_buf_len: 16777216 bytes
[    0.000000] early log buf free: 258396(98%)
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F75F0 000024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 0x000000007FFF0100 000034 (v01 A M I  OEMXSDT  09000620 MSFT 00000097)
[    0.000000] ACPI: FACP 0x000000007FFF0290 0000F4 (v03 A M I  OEMFACP  09000620 MSFT 00000097)
[    0.000000] ACPI: DSDT 0x000000007FFF0480 003D81 (v01 0AAAA  0AAAA000 00000000 INTL 02002026)
[    0.000000] ACPI: FACS 0x000000007FFFE000 000040
[    0.000000] ACPI: APIC 0x000000007FFF0390 000080 (v01 A M I  OEMAPIC  09000620 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] Number of physical nodes 2
[    0.000000] Node 0 MemBase 0000000000000000 Limit 0000000080000000
[    0.000000] Node 1 MemBase 0000000100000000 Limit 0000000200000000
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x7fffffff]
[    0.000000]   NODE_DATA [mem 0x7ffec000-0x7ffeffff]
[    0.000000] Initmem setup node 1 [mem 0x100000000-0x1ffffffff]
[    0.000000]   NODE_DATA [mem 0x1feff9000-0x1feffcfff]
[    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007de00000-ffff88007fdfffff] on node 0
[    0.000000]  [ffffea0004000000-ffffea0007ffffff] PMD -> [ffff8801fa600000-ffff8801fe5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x1ffffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x7ffeffff]
[    0.000000]   node   1: [mem 0x100000000-0x1ffffffff]
[    0.000000] On node 0 totalpages: 524174
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8128 pages used for memmap
[    0.000000]   DMA32 zone: 520176 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 1048576
[    0.000000]   Normal zone: 16384 pages used for memmap
[    0.000000]   Normal zone: 1048576 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x508
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-15
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec01000] gsi_base[16])
[    0.000000] IOAPIC[1]: apic_id 3, version 17, address 0xfec01000, GSI 16-31
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec02000] gsi_base[32])
[    0.000000] IOAPIC[2]: apic_id 4, version 17, address 0xfec02000, GSI 32-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x7fff0000-0x7fffdfff]
[    0.000000] PM: Registered nosave memory: [mem 0x7fffe000-0x7fffffff]
[    0.000000] PM: Registered nosave memory: [mem 0x80000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec02fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec03000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffffffff]
[    0.000000] e820: [mem 0x80000000-0xfebfffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88007dc00000 s79424 r8192 d22976 u1048576
[    0.000000] pcpu-alloc: s79424 r8192 d22976 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 2 [1] 1 3 
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 1548153
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda2 dyndbg="file drivers/pci/* +fp" log_buf_len=10M
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 6092248K/6291000K available (8607K kernel code, 969K rwdata, 2840K rodata, 1076K init, 896K bss, 198752K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:4352 nr_irqs:864 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 1995.191 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.001141] Calibrating delay loop (skipped), value calculated using timer frequency.. 3990.38 BogoMIPS (lpj=1995191)
[    0.001412] pid_max: default: 32768 minimum: 301
[    0.001558] ACPI: Core revision 20140724
[    0.005499] ACPI: All ACPI Tables successfully acquired
[    0.006058] Security Framework initialized
[    0.006204] SELinux:  Initializing.
[    0.006341] SELinux:  Starting in permissive mode
[    0.007278] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.015222] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.018744] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.018899] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.019530] Initializing cgroup subsys freezer
[    0.019692] mce: CPU supports 5 MCE banks
[    0.019836] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4, 1GB 0
[    0.020148] Freeing SMP alternatives memory: 28K (ffffffff82001000 - ffffffff82008000)
[    0.021613] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.022000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.022000] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.022000] ..... (found apic 0 pin 2) ...
[    0.033518] ....... works.
[    0.033648] smpboot: CPU0: AMD Opteron(tm) Processor 246 (fam: 0f, model: 05, stepping: 0a)
[    0.035000] APIC calibration not consistent with PM-Timer: 96ms instead of 100ms
[    0.035000] APIC delta adjusted to PM-Timer: 1246873 (1209285)
[    0.035000] Performance Events: AMD PMU driver.
[    0.035000] ... version:                0
[    0.035000] ... bit width:              48
[    0.035000] ... generic registers:      4
[    0.035000] ... value mask:             0000ffffffffffff
[    0.035000] ... max period:             00007fffffffffff
[    0.035000] ... fixed-purpose events:   0
[    0.035000] ... event mask:             000000000000000f
[    0.036443] MCE: In-kernel MCE decoding enabled.
[    0.036814] x86: Booting SMP configuration:
[    0.036948] .... node  #1, CPUs:      #1
[    0.108137] x86: Booted up 2 nodes, 2 CPUs
[    0.108392] smpboot: Total of 2 processors activated (7980.22 BogoMIPS)
[    0.109252] devtmpfs: initialized
[    0.110139] PM: Registering ACPI NVS region [mem 0x7fffe000-0x7fffffff] (8192 bytes)
[    0.111005] RTC time: 10:57:51, date: 09/12/14
[    0.111292] NET: Registered protocol family 16
[    0.111644] cpuidle: using governor ladder
[    0.111779] cpuidle: using governor menu
[    0.111924] node 0 link 0: io port [1000, ffffff]
[    0.111931] TOM: 0000000080000000 aka 2048M
[    0.112010] node 0 link 0: mmio [a0000, bffff]
[    0.112014] node 0 link 0: mmio [80000000, ff70ffff]
[    0.112016] TOM2: 0000000200000000 aka 8192M
[    0.112150] bus: [bus 00-ff] on node 0 link 0
[    0.112152] bus: 00 [io  0x0000-0xffff]
[    0.112154] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.112156] bus: 00 [mem 0x80000000-0xffffffff]
[    0.112157] bus: 00 [mem 0x200000000-0xfcffffffff]
[    0.112216] ACPI: bus type PCI registered
[    0.112419] PCI: Using configuration type 1 for base access
[    0.116037] kworker/u9:0 (20) used greatest stack depth: 14912 bytes left
[    0.117311] kworker/u9:0 (23) used greatest stack depth: 14280 bytes left
[    0.117556] kworker/u9:0 (26) used greatest stack depth: 13880 bytes left
[    0.121799] ACPI: Added _OSI(Module Device)
[    0.121799] ACPI: Added _OSI(Processor Device)
[    0.122004] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.122141] ACPI: Added _OSI(Processor Aggregator Device)
[    0.124332] ACPI: Executed 1 blocks of module-level executable AML code
[    0.126802] ACPI: Interpreter enabled
[    0.126955] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    0.127270] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140724/hwxface-580)
[    0.127600] ACPI: (supports S0 S1 S4 S5)
[    0.127736] ACPI: Using IOAPIC for interrupt routing
[    0.127938] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.136770] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-06])
[    0.136925] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.137012] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.137301] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.137304] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.137307] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.137310] acpi PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.137312] acpi PNP0A03:00: host bridge window [mem 0x80000000-0xffffffff] (ignored)
[    0.137315] PCI: root bus 00: hardware-probed resources
[    0.137322] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.137598] PCI host bridge to bus 0000:00
[    0.137736] pci_bus 0000:00: root bus resource [bus 00-06]
[    0.137876] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.138007] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.138149] pci_bus 0000:00: root bus resource [mem 0x80000000-0xffffffff]
[    0.138291] pci_bus 0000:00: root bus resource [mem 0x200000000-0xfcffffffff]
[    0.138436] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[    0.138458] pci 0000:00:01.0: [1166:0036] type 01 class 0x060400
[    0.138501] fixup_debug_start: pci 0000:00:01.0: calling ht_enable_msi_mapping+0x0/0xb0
[    0.138509] pci 0000:00:01.0: Enabling HT MSI Mapping
[    0.140117] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.140366] pci 0000:00:02.0: [1166:0205] type 00 class 0x060000
[    0.140381] fixup_debug_start: pci 0000:00:02.0: calling quirk_mmio_always_on+0x0/0x10
[    0.141124] pci 0000:00:02.1: [1166:0214] type 00 class 0x01018a
[    0.141131] fixup_debug_start: pci 0000:00:02.1: calling quirk_no_ata_d3+0x0/0x10
[    0.141145] pci 0000:00:02.1: reg 0x10: [io  0x01f0-0x01f7]
[    0.141156] pci 0000:00:02.1: reg 0x14: [io  0x03f4-0x03f7]
[    0.141166] pci 0000:00:02.1: reg 0x18: [io  0x0170-0x0177]
[    0.141175] pci 0000:00:02.1: reg 0x1c: [io  0x0374-0x0377]
[    0.141185] pci 0000:00:02.1: reg 0x20: [io  0xffa0-0xffaf]
[    0.141206] pci 0000:00:02.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.141346] pci 0000:00:02.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.141484] pci 0000:00:02.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.141622] pci 0000:00:02.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.141834] pci 0000:00:02.2: [1166:0234] type 00 class 0x060100
[    0.141986] pci 0000:00:03.0: [1166:0223] type 00 class 0x0c0310
[    0.142010] pci 0000:00:03.0: reg 0x10: [mem 0xff6e8000-0xff6e8fff]
[    0.142020] pci 0000:00:03.0: reg 0x14: [io  0xd400-0xd4ff]
[    0.142124] pci 0000:00:03.0: System wakeup disabled by ACPI
[    0.142321] pci 0000:00:03.1: [1166:0223] type 00 class 0x0c0310
[    0.142340] pci 0000:00:03.1: reg 0x10: [mem 0xff6e9000-0xff6e9fff]
[    0.142350] pci 0000:00:03.1: reg 0x14: [io  0xd800-0xd8ff]
[    0.142453] pci 0000:00:03.1: System wakeup disabled by ACPI
[    0.142645] pci 0000:00:03.2: [1166:0223] type 00 class 0x0c0320
[    0.142663] pci 0000:00:03.2: reg 0x10: [mem 0xff6ea000-0xff6eafff]
[    0.142673] pci 0000:00:03.2: reg 0x14: [io  0xe800-0xe8ff]
[    0.142740] pci 0000:00:03.2: supports D1 D2
[    0.142743] pci 0000:00:03.2: PME# supported from D0 D1 D2 D3hot
[    0.142750] pci_pme_active: pci 0000:00:03.2: PME# disabled
[    0.142789] pci 0000:00:03.2: System wakeup disabled by ACPI
[    0.142985] pci 0000:00:06.0: [1166:0130] type 01 class 0x060400
[    0.143067] pci 0000:00:06.0: System wakeup disabled by ACPI
[    0.143256] pci 0000:00:07.0: [1166:0130] type 01 class 0x060400
[    0.143321] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.143509] pci 0000:00:0a.0: [1166:0132] type 01 class 0x060400
[    0.143571] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    0.143760] pci 0000:00:0b.0: [1166:0132] type 01 class 0x060400
[    0.143864] pci 0000:00:0c.0: [1002:515e] type 00 class 0x030000
[    0.143883] pci 0000:00:0c.0: reg 0x10: [mem 0xd8000000-0xdfffffff pref]
[    0.143894] pci 0000:00:0c.0: reg 0x14: [io  0xe000-0xe0ff]
[    0.143905] pci 0000:00:0c.0: reg 0x18: [mem 0xff6f0000-0xff6fffff]
[    0.143939] pci 0000:00:0c.0: reg 0x30: [mem 0xff6c0000-0xff6dffff pref]
[    0.143968] pci 0000:00:0c.0: supports D1 D2
[    0.144059] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.144064] fixup_debug_start: pci 0000:00:18.0: calling quirk_mmio_always_on+0x0/0x10
[    0.144150] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.144155] fixup_debug_start: pci 0000:00:18.1: calling quirk_mmio_always_on+0x0/0x10
[    0.144227] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.144232] fixup_debug_start: pci 0000:00:18.2: calling quirk_mmio_always_on+0x0/0x10
[    0.144306] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.144311] fixup_debug_start: pci 0000:00:18.3: calling quirk_mmio_always_on+0x0/0x10
[    0.144389] pci 0000:00:19.0: [1022:1100] type 00 class 0x060000
[    0.144394] fixup_debug_start: pci 0000:00:19.0: calling quirk_mmio_always_on+0x0/0x10
[    0.144528] pci 0000:00:19.1: [1022:1101] type 00 class 0x060000
[    0.144533] fixup_debug_start: pci 0000:00:19.1: calling quirk_mmio_always_on+0x0/0x10
[    0.144614] pci 0000:00:19.2: [1022:1102] type 00 class 0x060000
[    0.144619] fixup_debug_start: pci 0000:00:19.2: calling quirk_mmio_always_on+0x0/0x10
[    0.144696] pci 0000:00:19.3: [1022:1103] type 00 class 0x060000
[    0.144701] fixup_debug_start: pci 0000:00:19.3: calling quirk_mmio_always_on+0x0/0x10
[    0.144783] pci_scan_child_bus: pci_bus 0000:00: fixups for bus
[    0.144788] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 0
[    0.144841] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[    0.144862] pci 0000:01:0d.0: [1166:0104] type 01 class 0x060400
[    0.144966] pci 0000:01:0e.0: [1166:024b] type 00 class 0x01018f
[    0.144974] fixup_debug_start: pci 0000:01:0e.0: calling quirk_no_ata_d3+0x0/0x10
[    0.144983] pci 0000:01:0e.0: reg 0x10: [io  0x8080-0x8087]
[    0.144991] pci 0000:01:0e.0: reg 0x14: [io  0x8000-0x8003]
[    0.144998] pci 0000:01:0e.0: reg 0x18: [io  0x7c00-0x7c07]
[    0.145008] pci 0000:01:0e.0: reg 0x1c: [io  0x7880-0x7883]
[    0.145015] pci 0000:01:0e.0: reg 0x20: [io  0x7800-0x780f]
[    0.145023] pci 0000:01:0e.0: reg 0x24: [mem 0xff1fe000-0xff1fffff]
[    0.145031] pci 0000:01:0e.0: reg 0x30: [mem 0xff1c0000-0xff1dffff pref]
[    0.145119] pci 0000:01:0e.1: [1166:024b] type 00 class 0x01018f
[    0.145126] fixup_debug_start: pci 0000:01:0e.1: calling quirk_no_ata_d3+0x0/0x10
[    0.145136] pci 0000:01:0e.1: reg 0x10: [io  0x8c00-0x8c07]
[    0.145143] pci 0000:01:0e.1: reg 0x14: [io  0x8880-0x8883]
[    0.145150] pci 0000:01:0e.1: reg 0x18: [io  0x8800-0x8807]
[    0.145158] pci 0000:01:0e.1: reg 0x1c: [io  0x8480-0x8483]
[    0.145165] pci 0000:01:0e.1: reg 0x20: [io  0x8400-0x840f]
[    0.145267] pci_scan_child_bus: pci_bus 0000:01: fixups for bus
[    0.145270] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.145409] pci 0000:00:01.0:   bridge window [io  0x7000-0x8fff]
[    0.145413] pci 0000:00:01.0:   bridge window [mem 0xff100000-0xff1fffff]
[    0.145420] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 0
[    0.145458] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[    0.145490] pci_scan_child_bus: pci_bus 0000:02: fixups for bus
[    0.145493] pci 0000:01:0d.0: PCI bridge to [bus 02]
[    0.145634] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[    0.145640] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 1
[    0.145644] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=02
[    0.145649] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 0
[    0.145686] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[    0.145714] pci_scan_child_bus: pci_bus 0000:03: fixups for bus
[    0.145716] pci 0000:00:06.0: PCI bridge to [bus 03]
[    0.145856] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[    0.145860] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 0
[    0.145893] pci_scan_child_bus: pci_bus 0000:04: scanning bus
[    0.145908] pci 0000:04:04.0: [14e4:166a] type 00 class 0x020000
[    0.145921] pci 0000:04:04.0: reg 0x10: [mem 0xff2d0000-0xff2dffff 64bit]
[    0.145930] pci 0000:04:04.0: reg 0x18: [mem 0xff2c0000-0xff2cffff 64bit]
[    0.145968] pci 0000:04:04.0: PME# supported from D3hot D3cold
[    0.145972] pci_pme_active: pci 0000:04:04.0: PME# disabled
[    0.145993] pci 0000:04:04.0: System wakeup disabled by ACPI
[    0.146061] pci 0000:04:04.1: [14e4:166a] type 00 class 0x020000
[    0.146073] pci 0000:04:04.1: reg 0x10: [mem 0xff2f0000-0xff2fffff 64bit]
[    0.146082] pci 0000:04:04.1: reg 0x18: [mem 0xff2e0000-0xff2effff 64bit]
[    0.146120] pci 0000:04:04.1: PME# supported from D3hot D3cold
[    0.146124] pci_pme_active: pci 0000:04:04.1: PME# disabled
[    0.146146] pci 0000:04:04.1: System wakeup disabled by ACPI
[    0.146347] pci_scan_child_bus: pci_bus 0000:04: fixups for bus
[    0.146350] pci 0000:00:07.0: PCI bridge to [bus 04]
[    0.146487] pci 0000:00:07.0:   bridge window [mem 0xff200000-0xff2fffff]
[    0.146492] pci 0000:00:07.0:   bridge window [mem 0xcfd00000-0xcfdfffff 64bit pref]
[    0.146495] pci_scan_child_bus: pci_bus 0000:04: bus scan returning with max=04
[    0.146500] pci_scan_bridge: pci 0000:00:0a.0: scanning [bus 07-07] behind bridge, pass 0
[    0.146503] pci 0000:00:0a.0: bridge configuration invalid ([bus 07-07]), reconfiguring
[    0.146725] pci_scan_bridge: pci 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 0
[    0.146727] pci 0000:00:0b.0: bridge configuration invalid ([bus 08-08]), reconfiguring
[    0.147010] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 1
[    0.147016] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 1
[    0.147021] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 1
[    0.147026] pci_scan_bridge: pci 0000:00:0a.0: scanning [bus 00-00] behind bridge, pass 1
[    0.147065] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[    0.147069] pci_scan_child_bus: pci_bus 0000:05: fixups for bus
[    0.147072] pci 0000:00:0a.0: PCI bridge to [bus 05-06]
[    0.147210] pci 0000:00:0a.0:   bridge window [io  0x9000-0xbfff]
[    0.147214] pci 0000:00:0a.0:   bridge window [mem 0xff300000-0xff5fffff]
[    0.147218] pci 0000:00:0a.0:   bridge window [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.147222] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[    0.147226] pci_bus 0000:05: busn_res: [bus 05-06] end is updated to 05
[    0.147231] pci_scan_bridge: pci 0000:00:0b.0: scanning [bus 00-00] behind bridge, pass 1
[    0.147271] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[    0.147275] pci_scan_child_bus: pci_bus 0000:06: fixups for bus
[    0.147278] pci 0000:00:0b.0: PCI bridge to [bus 06]
[    0.147417] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[    0.147420] pci_bus 0000:06: busn_res: [bus 06] end is updated to 06
[    0.147424] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=06
[    0.147428] pci_bus 0000:00: on NUMA node 0
[    0.148297] ACPI: PCI Interrupt Link [LN00] (IRQs 3 4 5 7 9 11 12 14 15) *0, disabled.
[    0.149072] ACPI: PCI Interrupt Link [LN01] (IRQs 3 4 5 6 7 9 *11 12 14 15)
[    0.149794] ACPI: PCI Interrupt Link [LN02] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.150758] ACPI: PCI Interrupt Link [LN03] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.152063] ACPI: PCI Interrupt Link [LN04] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.153118] ACPI: PCI Interrupt Link [LN05] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.154046] ACPI: PCI Interrupt Link [LN06] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.154970] ACPI: PCI Interrupt Link [LN07] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.155867] ACPI: PCI Interrupt Link [LN08] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.156776] ACPI: PCI Interrupt Link [LN09] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.157729] ACPI: PCI Interrupt Link [LN10] (IRQs 3 4 *5 6 7 9 11 12 14 15)
[    0.158465] ACPI: PCI Interrupt Link [LN11] (IRQs 3 4 5 6 7 *9 11 12 14 15)
[    0.159238] ACPI: PCI Interrupt Link [LN12] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.160066] ACPI: PCI Interrupt Link [LN13] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.161065] ACPI: PCI Interrupt Link [LN14] (IRQs *3 4 5 6 7 9 11 12 14 15)
[    0.161813] ACPI: PCI Interrupt Link [LN15] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.162730] ACPI: PCI Interrupt Link [LN16] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.163684] ACPI: PCI Interrupt Link [LN17] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.164594] ACPI: PCI Interrupt Link [LN18] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.165502] ACPI: PCI Interrupt Link [LN19] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.166458] ACPI: PCI Interrupt Link [LN20] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.167365] ACPI: PCI Interrupt Link [LN21] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.168193] ACPI: PCI Interrupt Link [LN22] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.169192] ACPI: PCI Interrupt Link [LN23] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.170065] ACPI: PCI Interrupt Link [LN24] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.171066] ACPI: PCI Interrupt Link [LN25] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.172018] ACPI: PCI Interrupt Link [LN26] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.172937] ACPI: PCI Interrupt Link [LN27] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.173821] ACPI: PCI Interrupt Link [LN28] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.174776] ACPI: PCI Interrupt Link [LN29] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.175684] ACPI: PCI Interrupt Link [LN30] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.176616] ACPI: PCI Interrupt Link [LNUS] (IRQs *10)
[    0.177008] ACPI: PCI Interrupt Link [LNSA] (IRQs *11)
[    0.177640] vgaarb: device added: PCI:0000:00:0c.0,decodes=io+mem,owns=io+mem,locks=none
[    0.177875] vgaarb: loaded
[    0.178006] vgaarb: bridge control possible 0000:00:0c.0
[    0.178300] SCSI subsystem initialized
[    0.178542] libata version 3.00 loaded.
[    0.178618] ACPI: bus type USB registered
[    0.178799] usbcore: registered new interface driver usbfs
[    0.178959] usbcore: registered new interface driver hub
[    0.179040] usbcore: registered new device driver usb
[    0.179232] pps_core: LinuxPPS API ver. 1 registered
[    0.179369] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.179603] PTP clock support registered
[    0.179787] Advanced Linux Sound Architecture Driver Initialized.
[    0.180009] PCI: Using ACPI for IRQ routing
[    0.180150] PCI: pci_cache_line_size set to 64 bytes
[    0.180213] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.180217] e820: reserve RAM buffer [mem 0x7fff0000-0x7fffffff]
[    0.180583] NetLabel: Initializing
[    0.180720] NetLabel:  domain hash size = 128
[    0.180857] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.181022] NetLabel:  unlabeled traffic allowed by default
[    0.181184] cfg80211: Calling CRDA to update world regulatory domain
[    0.181478] Switched to clocksource refined-jiffies
[    0.193198] pnp: PnP ACPI init
[    0.193479] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.194046] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.194184] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.194322] system 00:01: [io  0x0cd6-0x0cd7] has been reserved
[    0.194459] system 00:01: [io  0x0cd4-0x0cd5] has been reserved
[    0.194596] system 00:01: [io  0x0cd8-0x0cdf] has been reserved
[    0.194733] system 00:01: [io  0x040b] has been reserved
[    0.194868] system 00:01: [io  0x04d6] has been reserved
[    0.195003] system 00:01: [io  0x0c06-0x0c07] has been reserved
[    0.195139] system 00:01: [io  0x0c14] has been reserved
[    0.195277] system 00:01: [io  0x0c49] has been reserved
[    0.195413] system 00:01: [io  0x0c4a] has been reserved
[    0.195548] system 00:01: [io  0x0c50-0x0c51] has been reserved
[    0.195685] system 00:01: [io  0x0c52] has been reserved
[    0.195820] system 00:01: [io  0x0c6c] has been reserved
[    0.195957] system 00:01: [io  0x0c6f] has been reserved
[    0.196001] system 00:01: [io  0x0500-0x057f] could not be reserved
[    0.196141] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.196318] system 00:02: [io  0x0580-0x058f] has been reserved
[    0.196456] system 00:02: [io  0x0590-0x0593] has been reserved
[    0.196593] system 00:02: [io  0x0700-0x0703] has been reserved
[    0.196730] system 00:02: [io  0x0ca0-0x0caf] has been reserved
[    0.196869] system 00:02: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.197005] system 00:02: [mem 0xfec01000-0xfec01fff] could not be reserved
[    0.197145] system 00:02: [mem 0xfec02000-0xfec02fff] could not be reserved
[    0.197284] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.197422] system 00:02: [mem 0xfff00000-0xffffffff] has been reserved
[    0.197561] system 00:02: [mem 0xff780000-0xffbfffff] has been reserved
[    0.197700] system 00:02: [mem 0xfebfe000-0xfebfefff] has been reserved
[    0.197842] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.198105] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.198400] system 00:04: [io  0x0600-0x061f] has been reserved
[    0.198538] system 00:04: [io  0x0520-0x053f] has been reserved
[    0.198674] system 00:04: [io  0x0540-0x054f] has been reserved
[    0.198811] system 00:04: [io  0x0640-0x065f] has been reserved
[    0.198950] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.199046] system 00:05: [mem 0xe0000000-0xefffffff] has been reserved
[    0.199185] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.199348] system 00:06: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.199488] system 00:06: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.199627] system 00:06: [mem 0x00100000-0x7fffffff] could not be reserved
[    0.199766] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.200423] pnp: PnP ACPI: found 7 devices
[    0.207338] Switched to clocksource acpi_pm
[    0.207547] pci 0000:01:0d.0: PCI bridge to [bus 02]
[    0.207694] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.207834] pci 0000:00:01.0:   bridge window [io  0x7000-0x8fff]
[    0.207985] pci 0000:00:01.0:   bridge window [mem 0xff100000-0xff1fffff]
[    0.207985] pci 0000:00:06.0: PCI bridge to [bus 03]
[    0.207985] pci 0000:00:07.0: PCI bridge to [bus 04]
[    0.208124] pci 0000:00:07.0:   bridge window [mem 0xff200000-0xff2fffff]
[    0.208267] pci 0000:00:07.0:   bridge window [mem 0xcfd00000-0xcfdfffff 64bit pref]
[    0.208493] pci 0000:00:0a.0: PCI bridge to [bus 05]
[    0.208633] pci 0000:00:0a.0:   bridge window [io  0x9000-0xbfff]
[    0.208774] pci 0000:00:0a.0:   bridge window [mem 0xff300000-0xff5fffff]
[    0.208919] pci 0000:00:0a.0:   bridge window [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.209162] pci 0000:00:0b.0: PCI bridge to [bus 06]
[    0.209305] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.209307] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
[    0.209310] pci_bus 0000:00: resource 6 [mem 0x80000000-0xffffffff]
[    0.209313] pci_bus 0000:00: resource 7 [mem 0x200000000-0xfcffffffff]
[    0.209315] pci_bus 0000:01: resource 0 [io  0x7000-0x8fff]
[    0.209318] pci_bus 0000:01: resource 1 [mem 0xff100000-0xff1fffff]
[    0.209322] pci_bus 0000:04: resource 1 [mem 0xff200000-0xff2fffff]
[    0.209324] pci_bus 0000:04: resource 2 [mem 0xcfd00000-0xcfdfffff 64bit pref]
[    0.209327] pci_bus 0000:05: resource 0 [io  0x9000-0xbfff]
[    0.209330] pci_bus 0000:05: resource 1 [mem 0xff300000-0xff5fffff]
[    0.209333] pci_bus 0000:05: resource 2 [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.209409] NET: Registered protocol family 2
[    0.209985] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.210693] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.211506] TCP: Hash tables configured (established 65536 bind 65536)
[    0.211769] TCP: reno registered
[    0.211936] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.212224] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.212596] NET: Registered protocol family 1
[    0.212912] RPC: Registered named UNIX socket transport module.
[    0.213066] RPC: Registered udp transport module.
[    0.213203] RPC: Registered tcp transport module.
[    0.213344] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.213508] fixup_debug_start: pci 0000:00:02.0: calling quirk_disable_broadcom_boot_interrupt+0x0/0xb0
[    0.213576] pci 0000:00:02.0: disabled boot interrupts on device [1166:0205]
[    0.213733] fixup_debug_start: pci 0000:00:03.0: calling quirk_usb_early_handoff+0x0/0x770
[    0.286071] fixup_debug_start: pci 0000:00:03.1: calling quirk_usb_early_handoff+0x0/0x770
[    0.358062] fixup_debug_start: pci 0000:00:03.2: calling quirk_usb_early_handoff+0x0/0x770
[    0.358157] fixup_debug_start: pci 0000:00:0a.0: calling quirk_msi_ht_cap+0x0/0x50
[    0.358163] pci 0000:00:0a.0: Found enabled HT MSI Mapping
[    0.358302] fixup_debug_start: pci 0000:00:0b.0: calling quirk_msi_ht_cap+0x0/0x50
[    0.358307] pci 0000:00:0b.0: Found enabled HT MSI Mapping
[    0.358447] fixup_debug_start: pci 0000:00:0c.0: calling pci_fixup_video+0x0/0x150
[    0.358452] pci 0000:00:0c.0: Boot video device
[    0.358460] fixup_debug_start: pci 0000:00:18.0: calling quirk_amd_nb_node+0x0/0x80
[    0.358467] fixup_debug_start: pci 0000:00:18.1: calling quirk_amd_nb_node+0x0/0x80
[    0.358474] fixup_debug_start: pci 0000:00:18.2: calling quirk_amd_nb_node+0x0/0x80
[    0.358480] fixup_debug_start: pci 0000:00:18.3: calling quirk_amd_nb_node+0x0/0x80
[    0.358487] fixup_debug_start: pci 0000:00:19.0: calling quirk_amd_nb_node+0x0/0x80
[    0.358494] fixup_debug_start: pci 0000:00:19.1: calling quirk_amd_nb_node+0x0/0x80
[    0.358501] fixup_debug_start: pci 0000:00:19.2: calling quirk_amd_nb_node+0x0/0x80
[    0.358507] fixup_debug_start: pci 0000:00:19.3: calling quirk_amd_nb_node+0x0/0x80
[    0.358522] fixup_debug_start: pci 0000:04:04.0: calling quirk_msi_intx_disable_bug+0x0/0x10
[    0.358528] fixup_debug_start: pci 0000:04:04.1: calling quirk_msi_intx_disable_bug+0x0/0x10
[    0.358532] PCI: CLS 64 bytes, default 64
[    0.358633] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.358771] software IO TLB [mem 0x79c00000-0x7dc00000] (64MB) mapped at [ffff880079c00000-ffff88007dbfffff]
[    0.359199] microcode: AMD CPU family 0xf not supported
[    0.359749] Scanning for low memory corruption every 60 seconds
[    0.360352] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.360550] audit: initializing netlink subsys (disabled)
[    0.362531] audit: type=2000 audit(1410519471.361:1): initialized
[    0.363140] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.366344] VFS: Disk quotas dquot_6.5.2
[    0.366557] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.367716] NFS: Registering the id_resolver key type
[    0.367877] Key type id_resolver registered
[    0.368040] Key type id_legacy registered
[    0.368285] msgmni has been set to 11898
[    0.368524] SELinux:  Registering netfilter hooks
[    0.369260] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    0.369496] io scheduler noop registered
[    0.369637] io scheduler deadline registered
[    0.369871] io scheduler cfq registered (default)
[    0.370232] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.370570] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.370807] ACPI: Power Button [PWRB]
[    0.371022] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.371248] ACPI: Power Button [PWRF]
[    0.371462] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input2
[    0.371693] ACPI: Sleep Button [SLPF]
[    0.372335] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.373326] Non-volatile memory driver v1.3
[    0.373489] Linux agpgart interface v0.103
[    0.374133] [drm] Initialized drm 1.1.0 20060810
[    0.375605] loop: module loaded
[    0.376025] sata_svw 0000:01:0e.0: version 2.3
[    0.376812] scsi host0: sata_svw
[    0.377315] scsi host1: sata_svw
[    0.377618] scsi host2: sata_svw
[    0.377890] scsi host3: sata_svw
[    0.378156] ata1: SATA max UDMA/133 mmio m8192@0xff1fe000 port 0xff1fe000 irq 11
[    0.378375] ata2: SATA max UDMA/133 mmio m8192@0xff1fe000 port 0xff1fe100 irq 11
[    0.378593] ata3: SATA max UDMA/133 mmio m8192@0xff1fe000 port 0xff1fe200 irq 11
[    0.378810] ata4: SATA max UDMA/133 mmio m8192@0xff1fe000 port 0xff1fe300 irq 11
[    0.379863] scsi host4: pata_serverworks
[    0.380195] scsi host5: pata_serverworks
[    0.380380] ata5: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.380518] ata6: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    0.380807] tg3.c:v3.137 (May 11, 2014)
[    0.393817] tg3 0000:04:04.0 eth0: Tigon3 [partno(BCM95780) rev 8003] (PCIX:133MHz:64-bit) MAC address 00:e0:81:47:5e:b0
[    0.394063] tg3 0000:04:04.0 eth0: attached PHY is 5780 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    0.394286] tg3 0000:04:04.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    0.394505] tg3 0000:04:04.0 eth0: dma_rwctrl[76144000] dma_mask[40-bit]
[    0.409165] tg3 0000:04:04.1 eth1: Tigon3 [partno(BCM95780) rev 8003] (PCIX:133MHz:64-bit) MAC address 00:e0:81:47:5e:b1
[    0.409393] tg3 0000:04:04.1 eth1: attached PHY is 5780 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    0.409616] tg3 0000:04:04.1 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    0.409834] tg3 0000:04:04.1 eth1: dma_rwctrl[76144000] dma_mask[40-bit]
[    0.410033] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    0.410189] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.410367] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    0.410508] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    0.410673] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    0.410811] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    0.410979] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    0.411156] sky2: driver version 1.30
[    0.411540] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.411686] ehci-pci: EHCI PCI platform driver
[    0.411916] __pci_set_master: ehci-pci 0000:00:03.2: enabling bus mastering
[    0.411935] ehci-pci 0000:00:03.2: EHCI Host Controller
[    0.412168] ehci-pci 0000:00:03.2: new USB bus registered, assigned bus number 1
[    0.412459] ehci-pci 0000:00:03.2: irq 10, io mem 0xff6ea000
[    0.418023] ehci-pci 0000:00:03.2: USB 2.0 started, EHCI 1.00
[    0.418227] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.418365] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.418583] usb usb1: Product: EHCI Host Controller
[    0.418716] usb usb1: Manufacturer: Linux 3.17.0-rc4+ ehci_hcd
[    0.418852] usb usb1: SerialNumber: 0000:00:03.2
[    0.419191] hub 1-0:1.0: USB hub found
[    0.419333] hub 1-0:1.0: 4 ports detected
[    0.419616] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.419765] ohci-pci: OHCI PCI platform driver
[    0.419975] __pci_set_master: ohci-pci 0000:00:03.0: enabling bus mastering
[    0.419981] ohci-pci 0000:00:03.0: OHCI PCI host controller
[    0.420194] ohci-pci 0000:00:03.0: new USB bus registered, assigned bus number 2
[    0.420436] ohci-pci 0000:00:03.0: irq 10, io mem 0xff6e8000
[    0.475085] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.475224] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.475441] usb usb2: Product: OHCI PCI host controller
[    0.475576] usb usb2: Manufacturer: Linux 3.17.0-rc4+ ohci_hcd
[    0.475711] usb usb2: SerialNumber: 0000:00:03.0
[    0.476021] hub 2-0:1.0: USB hub found
[    0.476163] hub 2-0:1.0: 2 ports detected
[    0.476450] __pci_set_master: ohci-pci 0000:00:03.1: enabling bus mastering
[    0.476456] ohci-pci 0000:00:03.1: OHCI PCI host controller
[    0.476645] ohci-pci 0000:00:03.1: new USB bus registered, assigned bus number 3
[    0.476883] ohci-pci 0000:00:03.1: irq 10, io mem 0xff6e9000
[    0.532112] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.532264] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.532504] usb usb3: Product: OHCI PCI host controller
[    0.532653] usb usb3: Manufacturer: Linux 3.17.0-rc4+ ohci_hcd
[    0.532802] usb usb3: SerialNumber: 0000:00:03.1
[    0.543911] hub 3-0:1.0: USB hub found
[    0.544066] hub 3-0:1.0: 2 ports detected
[    0.544300] uhci_hcd: USB Universal Host Controller Interface driver
[    0.544510] usbcore: registered new interface driver usblp
[    0.544685] usbcore: registered new interface driver usb-storage
[    0.544874] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.545035] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.546074] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.546345] mousedev: PS/2 mouse device common for all mice
[    0.546773] rtc_cmos 00:00: RTC can wake from S4
[    0.547137] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    0.547312] rtc_cmos 00:00: alarms up to one year, y3k, 114 bytes nvram
[    0.547648] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    0.547920] hidraw: raw HID events driver (C) Jiri Kosina
[    0.548422] usbcore: registered new interface driver usbhid
[    0.548560] usbhid: USB HID core driver
[    0.549071] Netfilter messages via NETLINK v0.30.
[    0.549226] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.549576] ctnetlink v0.93: registering with nfnetlink.
[    0.549897] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.550155] TCP: cubic registered
[    0.550291] Initializing XFRM netlink socket
[    0.550645] NET: Registered protocol family 10
[    0.551219] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.551481] sit: IPv6 over IPv4 tunneling driver
[    0.551826] NET: Registered protocol family 17
[    0.552022] Key type dns_resolver registered
[    0.552543] registered taskstats version 1
[    0.553289]   Magic number: 14:421:982
[    0.553528] console [netcon0] enabled
[    0.553663] netconsole: network logging started
[    0.553905] PM: Hibernation image not present or could not be loaded.
[    0.553909] ALSA device list:
[    0.554063]   No soundcards found.
[    0.569755] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.694597] ata1: SATA link down (SStatus 4 SControl 300)
[    1.009547] ata2: SATA link down (SStatus 4 SControl 300)
[    1.314040] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.317439] ata3.00: ATA-8: WDC WD3200AAJS-07M0A0, 01.03E01, max UDMA/133
[    1.317578] ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.323443] ata3.00: configured for UDMA/133
[    1.323704] scsi 2:0:0:0: Direct-Access     ATA      WDC WD3200AAJS-0 3E01 PQ: 0 ANSI: 5
[    1.324209] sd 2:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.324489] sd 2:0:0:0: [sda] Write Protect is off
[    1.324624] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.324652] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.324959] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    1.340706]  sda: sda1 sda2 sda3 sda4
[    1.341334] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.640589] ata4: SATA link down (SStatus 4 SControl 300)
[    1.791111] md: Waiting for all devices to be available before autodetect
[    1.791250] md: If you don't use raid, use raid=noautodetect
[    1.791602] md: Autodetecting RAID arrays.
[    1.791739] md: Scanned 0 and added 0 devices.
[    1.791875] md: autorun ...
[    1.792028] md: ... autorun DONE.
[    1.801475] EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
[    1.801933] EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
[    1.818098] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    1.818336] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    1.843320] devtmpfs: mounted
[    1.845531] Freeing unused kernel memory: 1076K (ffffffff81ef4000 - ffffffff82001000)
[    1.845765] Write protecting the kernel read-only data: 14336k
[    1.853118] Freeing unused kernel memory: 1620K (ffff88000186b000 - ffff880001a00000)
[    1.858789] Freeing unused kernel memory: 1256K (ffff880001cc6000 - ffff880001e00000)
[    2.318895] random: nonblocking pool is initialized
[    2.339345] loadkeys (1016) used greatest stack depth: 13232 bytes left
[    2.339801] init-early.sh (1014) used greatest stack depth: 12576 bytes left
[    3.177720] systemd-udevd[1186]: starting version 215
[    3.506767] tg3 0000:04:04.0 enp4s4f0: renamed from eth0
[    3.510183] systemd-udevd[1202]: renamed network interface eth0 to enp4s4f0
[    3.517031] tg3 0000:04:04.1 enp4s4f1: renamed from eth1
[    3.522106] systemd-udevd[1203]: renamed network interface eth1 to enp4s4f1
[    4.961476] EXT4-fs (sda2): re-mounted. Opts: (null)
[    5.183664] EXT4-fs (sda1): mounting ext2 file system using the ext4 subsystem
[    5.185169] EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
[    6.198537] tg3 0000:04:04.0: irq 18 for MSI/MSI-X
[    6.236136] IPv6: ADDRCONF(NETDEV_UP): enp4s4f0: link is not ready
[    9.434173] tg3 0000:04:04.0 enp4s4f0: Link is up at 1000 Mbps, full duplex
[    9.434185] tg3 0000:04:04.0 enp4s4f0: Flow control is off for TX and off for RX
[    9.434208] IPv6: ADDRCONF(NETDEV_CHANGE): enp4s4f0: link becomes ready
