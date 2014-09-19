Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaISSW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 14:22:57 -0400
Received: from services.gouders.net ([141.101.32.176]:36254 "EHLO
	services.gouders.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607AbaISSWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 14:22:54 -0400
From: Dirk Gouders <dirk@gouders.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
In-Reply-To: <ghwq8zzm81.fsf@lena.gouders.net> (Dirk Gouders's message of
	"Fri, 19 Sep 2014 17:03:26 +0200")
References: <ghiol53r9u.fsf@lena.gouders.net>
	<ghwq9k3m6z.fsf@lena.gouders.net>
	<CAMxnaaUqTMf1uEQUqrAGjym8ZrQaBf2QbE4Jqxh2t6a2JgJkOQ@mail.gmail.com>
	<ghioku5l29.fsf@lena.gouders.net>
	<CAErSpo7j=a3y2MVsvEQGQ4B63_mNCyZSRNXNEZa-2++xs88NmQ@mail.gmail.com>
	<CAE9FiQUXvuZo2bQSRg0vpuDVYrnkcXDu7KZBNp-YgXbKa2LQhw@mail.gmail.com>
	<ghppf15236.fsf@quad.gouders.net>
	<CAErSpo5SVUOz+qa_x5JTC+-Y5ewTyYzA0N=jyPtK9LaguRrt=w@mail.gmail.com>
	<ghd2b1svdw.fsf@quad.gouders.net>
	<CAErSpo5e0GOdVbZdQYriP+aWziKELpb9BWTgJ4ERPia354CM5w@mail.gmail.com>
	<ghvbotd8es.fsf@quad.gouders.net> <ghzje5f5zt.fsf@lena.gouders.net>
	<ghbnqkeh9k.fsf@quad.gouders.net>
	<CAE9FiQXQesrDMqf1b6ZhHdmY_wEEUrOEvNO4N_d6WtaNMGNLww@mail.gmail.com>
	<gh4mwcef0r.fsf@quad.gouders.net>
	<CAE9FiQWgioBeVmfWCaE38BrkjbWKaS+_FYYdmdd+7X8fpeEgnQ@mail.gmail.com>
	<ghoaukcx6b.fsf@quad.gouders.net>
	<CAE9FiQUk-sAHnjfBvNeHQWibJRqbPE1V0UtDtARtwxmS=7aQrw@mail.gmail.com>
	<ghk358crbe.fsf@quad.gouders.net>
	<CAE9FiQUeP84585-4b+Y6WBVD3zqOi7ch_OXytsTmKEz9AyZ3Vg@mail.gmail.com>
	<ghwq8zzm81.fsf@lena.gouders.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
Date: Fri, 19 Sep 2014 20:21:31 +0200
Message-ID: <gh7g0zii8k.fsf@quad.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk Gouders <dirk@gouders.net> writes:

> Yinghai Lu <yinghai@kernel.org> writes:
>
>> On Fri, Sep 12, 2014 at 5:11 PM, Dirk Gouders <dirk@gouders.net> wrote:
>>> Yinghai Lu <yinghai@kernel.org> writes:
>>>
>>> Yes, I skip them in pci_scan_device() to get the unused bus number space
>>> that 0a.0 and 0b.0 then can use when reconfiguration is triggered.
>>
>> That is not right. Can not let two bridges use same bus num.
>>
>>>
>>>> Proper simulation could be:
>>>> 1. remove 07:00.0
>>>>     echo 1 > /sys/bus/pci/devices/0000:07:00.0/remove
>>>> 2. change bus range in 00:0a.0 bus
>>>>     setpci -s 00:0a.0 0x1c.l=0x00101000
>>>> 3. remove 00:0a.0
>>>>     echo 1 > /sys/bus/pci/devices/0000:00:0a.0/remove
>>>> 4. rescan pci
>>>>     echo 1 > /sys/bus/pci/rescan
>>>> 5. reset pcie link from 00:0a.0
>>>>     setpci -s 00:0a.0 0xc0.b=0x18
>>>>     sleep 1s
>>>>     setpci -s 00:0a.0 0xc0.b=0x08
>>>> 6. rescan pci bus
>>>>     echo 1 > /sys/bus/pci/rescan
>>>
>>> OK, I did that (with 3.16) but the reconfiguration code doesn't
>>> get triggered.  Here is what dmesg and lspci -tv say:
>>
>> 2 should be
>>    setpci -s 00:0a.0 0x18.l=0x00101000
>
> I'm very sorry for the late test result, Yinghai, I totally overlooked
> this correction.
>
> I'm not sure if it is still of interest but
> I now tried these corrected commands on the test machine with a vanilla
> 3.16 kernel.  The FC adapter disappears but I cannot see the 
>
> "bridge configuration invalid ..., reconfiguring" message,
>
> so I assume that the test situation is still not exactly matching that
> on the vx50 or am I missing something?

Some more thoughts while driving home and I think the test machine is
now usable.  I added the following changes:

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index e6ae603..6a90f15 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -556,6 +556,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
        strcpy(acpi_device_name(device), ACPI_PCI_ROOT_DEVICE_NAME);
        strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
        device->driver_data = root;
+       root->secondary.end = 0x09;
 
        pr_info(PREFIX "%s [%s] (domain %04x %pR)\n",
               acpi_device_name(device), acpi_device_bid(device),

And now, the "...reconfiguring" message appears and if I, for example,
run these commands suggested by Bjorn:

DEV=00:0a.0
setpci -s$DEV BRIDGE_CONTROL.W=0x0040
sleep 1
setpci -s$DEV BRIDGE_CONTROL.W=0x0000
sleep 1
echo 1 > /sys/bus/pci/rescan

The FC adapter shows up:

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
           +-0a.0-[09]----00.0  LSI Logic / Symbios Logic FC949ES Fibre Channel Adapter
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

To me this looks as similar behaviour as on the VX50 and I hope that makes
the test machine usable for convenient testing of possible final fixes.

I attach full dmesg output at the end.

Dirk

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.17.0-rc5+ (root@kapro) (gcc version 4.7.3 (Gentoo 4.7.3-r1 p1.4, pie-0.5.5) ) #20 SMP Fri Sep 19 20:00:31 CEST 2014
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
[    0.000000] Memory: 6092248K/6291000K available (8614K kernel code, 970K rwdata, 2840K rodata, 1076K init, 896K bss, 198752K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:4352 nr_irqs:864 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: PIT calibration matches PMTIMER. 1 loops
[    0.000000] tsc: Detected 1994.988 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.003139] Calibrating delay loop (skipped), value calculated using timer frequency.. 3989.97 BogoMIPS (lpj=1994988)
[    0.003410] pid_max: default: 32768 minimum: 301
[    0.004018] ACPI: Core revision 20140724
[    0.007499] ACPI: All ACPI Tables successfully acquired
[    0.008058] Security Framework initialized
[    0.008203] SELinux:  Initializing.
[    0.008340] SELinux:  Starting in permissive mode
[    0.009201] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.017075] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.020582] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.020736] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.021504] Initializing cgroup subsys freezer
[    0.021668] mce: CPU supports 5 MCE banks
[    0.021812] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 4
Last level dTLB entries: 4KB 512, 2MB 8, 4MB 4, 1GB 0
[    0.022148] Freeing SMP alternatives memory: 28K (ffffffff82001000 - ffffffff82008000)
[    0.023461] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.025000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.025000] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.025000] ..... (found apic 0 pin 2) ...
[    0.035137] ....... works.
[    0.035265] smpboot: CPU0: AMD Opteron(tm) Processor 246 (fam: 0f, model: 05, stepping: 0a)
[    0.036000] APIC calibration not consistent with PM-Timer: 96ms instead of 100ms
[    0.036000] APIC delta adjusted to PM-Timer: 1246870 (1209285)
[    0.036000] Performance Events: AMD PMU driver.
[    0.036000] ... version:                0
[    0.036000] ... bit width:              48
[    0.036000] ... generic registers:      4
[    0.036000] ... value mask:             0000ffffffffffff
[    0.036000] ... max period:             00007fffffffffff
[    0.036000] ... fixed-purpose events:   0
[    0.036000] ... event mask:             000000000000000f
[    0.037489] MCE: In-kernel MCE decoding enabled.
[    0.037857] x86: Booting SMP configuration:
[    0.037990] .... node  #1, CPUs:      #1
[    0.109140] x86: Booted up 2 nodes, 2 CPUs
[    0.109394] smpboot: Total of 2 processors activated (7979.81 BogoMIPS)
[    0.110247] devtmpfs: initialized
[    0.111133] PM: Registering ACPI NVS region [mem 0x7fffe000-0x7fffffff] (8192 bytes)
[    0.111846] RTC time: 18:15:46, date: 09/19/14
[    0.112162] NET: Registered protocol family 16
[    0.112511] cpuidle: using governor ladder
[    0.112646] cpuidle: using governor menu
[    0.112790] node 0 link 0: io port [1000, ffffff]
[    0.112797] TOM: 0000000080000000 aka 2048M
[    0.113010] node 0 link 0: mmio [a0000, bffff]
[    0.113014] node 0 link 0: mmio [80000000, ff70ffff]
[    0.113016] TOM2: 0000000200000000 aka 8192M
[    0.113151] bus: [bus 00-ff] on node 0 link 0
[    0.113153] bus: 00 [io  0x0000-0xffff]
[    0.113155] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.113157] bus: 00 [mem 0x80000000-0xffffffff]
[    0.113159] bus: 00 [mem 0x200000000-0xfcffffffff]
[    0.113216] ACPI: bus type PCI registered
[    0.113417] PCI: Using configuration type 1 for base access
[    0.117136] kworker/u9:0 (20) used greatest stack depth: 14944 bytes left
[    0.118059] kworker/u9:0 (23) used greatest stack depth: 14280 bytes left
[    0.118295] kworker/u9:0 (26) used greatest stack depth: 13912 bytes left
[    0.121736] ACPI: Added _OSI(Module Device)
[    0.121736] ACPI: Added _OSI(Processor Device)
[    0.122007] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.122145] ACPI: Added _OSI(Processor Aggregator Device)
[    0.124170] ACPI: Executed 1 blocks of module-level executable AML code
[    0.126648] ACPI: Interpreter enabled
[    0.126798] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    0.127003] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20140724/hwxface-580)
[    0.127337] ACPI: (supports S0 S1 S4 S5)
[    0.127473] ACPI: Using IOAPIC for interrupt routing
[    0.127678] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.136783] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-09])
[    0.136935] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.137014] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.137294] acpi PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.137297] acpi PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.137300] acpi PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.137303] acpi PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.137306] acpi PNP0A03:00: host bridge window [mem 0x80000000-0xffffffff] (ignored)
[    0.137309] PCI: root bus 00: hardware-probed resources
[    0.137316] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.137590] PCI host bridge to bus 0000:00
[    0.137728] pci_bus 0000:00: root bus resource [bus 00-09]
[    0.137867] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.138006] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.138148] pci_bus 0000:00: root bus resource [mem 0x80000000-0xffffffff]
[    0.138290] pci_bus 0000:00: root bus resource [mem 0x200000000-0xfcffffffff]
[    0.140007] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[    0.140030] pci 0000:00:01.0: [1166:0036] type 01 class 0x060400
[    0.140074] fixup_debug_start: pci 0000:00:01.0: calling ht_enable_msi_mapping+0x0/0xb0
[    0.140082] pci 0000:00:01.0: Enabling HT MSI Mapping
[    0.141041] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.141313] pci 0000:00:02.0: [1166:0205] type 00 class 0x060000
[    0.141330] fixup_debug_start: pci 0000:00:02.0: calling quirk_mmio_always_on+0x0/0x10
[    0.141470] pci 0000:00:02.1: [1166:0214] type 00 class 0x01018a
[    0.141476] fixup_debug_start: pci 0000:00:02.1: calling quirk_no_ata_d3+0x0/0x10
[    0.141490] pci 0000:00:02.1: reg 0x10: [io  0x01f0-0x01f7]
[    0.141500] pci 0000:00:02.1: reg 0x14: [io  0x03f4-0x03f7]
[    0.141510] pci 0000:00:02.1: reg 0x18: [io  0x0170-0x0177]
[    0.141520] pci 0000:00:02.1: reg 0x1c: [io  0x0374-0x0377]
[    0.141529] pci 0000:00:02.1: reg 0x20: [io  0xffa0-0xffaf]
[    0.141549] pci 0000:00:02.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.141688] pci 0000:00:02.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.141826] pci 0000:00:02.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.141964] pci 0000:00:02.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.142085] pci 0000:00:02.2: [1166:0234] type 00 class 0x060100
[    0.142233] pci 0000:00:03.0: [1166:0223] type 00 class 0x0c0310
[    0.142251] pci 0000:00:03.0: reg 0x10: [mem 0xff6e8000-0xff6e8fff]
[    0.142262] pci 0000:00:03.0: reg 0x14: [io  0xd400-0xd4ff]
[    0.142362] pci 0000:00:03.0: System wakeup disabled by ACPI
[    0.142554] pci 0000:00:03.1: [1166:0223] type 00 class 0x0c0310
[    0.142572] pci 0000:00:03.1: reg 0x10: [mem 0xff6e9000-0xff6e9fff]
[    0.142583] pci 0000:00:03.1: reg 0x14: [io  0xd800-0xd8ff]
[    0.142681] pci 0000:00:03.1: System wakeup disabled by ACPI
[    0.142873] pci 0000:00:03.2: [1166:0223] type 00 class 0x0c0320
[    0.143020] pci 0000:00:03.2: reg 0x10: [mem 0xff6ea000-0xff6eafff]
[    0.143030] pci 0000:00:03.2: reg 0x14: [io  0xe800-0xe8ff]
[    0.143098] pci 0000:00:03.2: supports D1 D2
[    0.143101] pci 0000:00:03.2: PME# supported from D0 D1 D2 D3hot
[    0.143111] pci_pme_active: pci 0000:00:03.2: PME# disabled
[    0.143147] pci 0000:00:03.2: System wakeup disabled by ACPI
[    0.143346] pci 0000:00:06.0: [1166:0130] type 01 class 0x060400
[    0.143412] pci 0000:00:06.0: System wakeup disabled by ACPI
[    0.143603] pci 0000:00:07.0: [1166:0130] type 01 class 0x060400
[    0.143663] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.143853] pci 0000:00:08.0: [1166:0132] type 01 class 0x060400
[    0.143915] pci 0000:00:08.0: System wakeup disabled by ACPI
[    0.144056] pci 0000:00:09.0: [1166:0132] type 01 class 0x060400
[    0.144113] pci 0000:00:09.0: System wakeup disabled by ACPI
[    0.144299] pci 0000:00:0a.0: [1166:0132] type 01 class 0x060400
[    0.144356] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    0.144544] pci 0000:00:0b.0: [1166:0132] type 01 class 0x060400
[    0.144644] pci 0000:00:0c.0: [1002:515e] type 00 class 0x030000
[    0.144662] pci 0000:00:0c.0: reg 0x10: [mem 0xd8000000-0xdfffffff pref]
[    0.144673] pci 0000:00:0c.0: reg 0x14: [io  0xe000-0xe0ff]
[    0.144683] pci 0000:00:0c.0: reg 0x18: [mem 0xff6f0000-0xff6fffff]
[    0.144717] pci 0000:00:0c.0: reg 0x30: [mem 0xff6c0000-0xff6dffff pref]
[    0.144745] pci 0000:00:0c.0: supports D1 D2
[    0.144825] pci 0000:00:18.0: [1022:1100] type 00 class 0x060000
[    0.144831] fixup_debug_start: pci 0000:00:18.0: calling quirk_mmio_always_on+0x0/0x10
[    0.144907] pci 0000:00:18.1: [1022:1101] type 00 class 0x060000
[    0.144912] fixup_debug_start: pci 0000:00:18.1: calling quirk_mmio_always_on+0x0/0x10
[    0.145040] pci 0000:00:18.2: [1022:1102] type 00 class 0x060000
[    0.145045] fixup_debug_start: pci 0000:00:18.2: calling quirk_mmio_always_on+0x0/0x10
[    0.145119] pci 0000:00:18.3: [1022:1103] type 00 class 0x060000
[    0.145124] fixup_debug_start: pci 0000:00:18.3: calling quirk_mmio_always_on+0x0/0x10
[    0.145200] pci 0000:00:19.0: [1022:1100] type 00 class 0x060000
[    0.145205] fixup_debug_start: pci 0000:00:19.0: calling quirk_mmio_always_on+0x0/0x10
[    0.145287] pci 0000:00:19.1: [1022:1101] type 00 class 0x060000
[    0.145292] fixup_debug_start: pci 0000:00:19.1: calling quirk_mmio_always_on+0x0/0x10
[    0.145365] pci 0000:00:19.2: [1022:1102] type 00 class 0x060000
[    0.145370] fixup_debug_start: pci 0000:00:19.2: calling quirk_mmio_always_on+0x0/0x10
[    0.145491] pci 0000:00:19.3: [1022:1103] type 00 class 0x060000
[    0.145497] fixup_debug_start: pci 0000:00:19.3: calling quirk_mmio_always_on+0x0/0x10
[    0.145577] pci_scan_child_bus: pci_bus 0000:00: fixups for bus
[    0.145582] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 0
[    0.145629] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[    0.145650] pci 0000:01:0d.0: [1166:0104] type 01 class 0x060400
[    0.145753] pci 0000:01:0e.0: [1166:024b] type 00 class 0x01018f
[    0.145761] fixup_debug_start: pci 0000:01:0e.0: calling quirk_no_ata_d3+0x0/0x10
[    0.145770] pci 0000:01:0e.0: reg 0x10: [io  0x8080-0x8087]
[    0.145778] pci 0000:01:0e.0: reg 0x14: [io  0x8000-0x8003]
[    0.145785] pci 0000:01:0e.0: reg 0x18: [io  0x7c00-0x7c07]
[    0.145793] pci 0000:01:0e.0: reg 0x1c: [io  0x7880-0x7883]
[    0.145800] pci 0000:01:0e.0: reg 0x20: [io  0x7800-0x780f]
[    0.145807] pci 0000:01:0e.0: reg 0x24: [mem 0xff1fe000-0xff1fffff]
[    0.145815] pci 0000:01:0e.0: reg 0x30: [mem 0xff1c0000-0xff1dffff pref]
[    0.145899] pci 0000:01:0e.1: [1166:024b] type 00 class 0x01018f
[    0.145907] fixup_debug_start: pci 0000:01:0e.1: calling quirk_no_ata_d3+0x0/0x10
[    0.145916] pci 0000:01:0e.1: reg 0x10: [io  0x8c00-0x8c07]
[    0.145923] pci 0000:01:0e.1: reg 0x14: [io  0x8880-0x8883]
[    0.145930] pci 0000:01:0e.1: reg 0x18: [io  0x8800-0x8807]
[    0.145937] pci 0000:01:0e.1: reg 0x1c: [io  0x8480-0x8483]
[    0.145944] pci 0000:01:0e.1: reg 0x20: [io  0x8400-0x840f]
[    0.146050] pci_scan_child_bus: pci_bus 0000:01: fixups for bus
[    0.146054] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.146193] pci 0000:00:01.0:   bridge window [io  0x7000-0x8fff]
[    0.146198] pci 0000:00:01.0:   bridge window [mem 0xff100000-0xff1fffff]
[    0.146204] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 0
[    0.146243] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[    0.146275] pci_scan_child_bus: pci_bus 0000:02: fixups for bus
[    0.146278] pci 0000:01:0d.0: PCI bridge to [bus 02]
[    0.146420] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[    0.146425] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 1
[    0.146430] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=02
[    0.146434] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 0
[    0.146467] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[    0.146494] pci_scan_child_bus: pci_bus 0000:03: fixups for bus
[    0.146496] pci 0000:00:06.0: PCI bridge to [bus 03]
[    0.146635] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[    0.146639] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 0
[    0.146677] pci_scan_child_bus: pci_bus 0000:04: scanning bus
[    0.146692] pci 0000:04:04.0: [14e4:166a] type 00 class 0x020000
[    0.146704] pci 0000:04:04.0: reg 0x10: [mem 0xff2d0000-0xff2dffff 64bit]
[    0.146713] pci 0000:04:04.0: reg 0x18: [mem 0xff2c0000-0xff2cffff 64bit]
[    0.146749] pci 0000:04:04.0: PME# supported from D3hot D3cold
[    0.146753] pci_pme_active: pci 0000:04:04.0: PME# disabled
[    0.146774] pci 0000:04:04.0: System wakeup disabled by ACPI
[    0.146965] pci 0000:04:04.1: [14e4:166a] type 00 class 0x020000
[    0.146978] pci 0000:04:04.1: reg 0x10: [mem 0xff2f0000-0xff2fffff 64bit]
[    0.146986] pci 0000:04:04.1: reg 0x18: [mem 0xff2e0000-0xff2effff 64bit]
[    0.147031] pci 0000:04:04.1: PME# supported from D3hot D3cold
[    0.147035] pci_pme_active: pci 0000:04:04.1: PME# disabled
[    0.147056] pci 0000:04:04.1: System wakeup disabled by ACPI
[    0.147262] pci_scan_child_bus: pci_bus 0000:04: fixups for bus
[    0.147265] pci 0000:00:07.0: PCI bridge to [bus 04]
[    0.147402] pci 0000:00:07.0:   bridge window [mem 0xff200000-0xff2fffff]
[    0.147407] pci 0000:00:07.0:   bridge window [mem 0xcfd00000-0xcfdfffff 64bit pref]
[    0.147410] pci_scan_child_bus: pci_bus 0000:04: bus scan returning with max=04
[    0.147415] pci_scan_bridge: pci 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 0
[    0.147450] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[    0.147454] pci_scan_child_bus: pci_bus 0000:05: fixups for bus
[    0.147457] pci 0000:00:08.0: PCI bridge to [bus 05]
[    0.147595] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[    0.147599] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 0
[    0.147632] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[    0.147636] pci_scan_child_bus: pci_bus 0000:06: fixups for bus
[    0.147639] pci 0000:00:09.0: PCI bridge to [bus 06]
[    0.147777] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[    0.147781] pci_scan_bridge: pci 0000:00:0a.0: scanning [bus 07-07] behind bridge, pass 0
[    0.147815] pci_scan_child_bus: pci_bus 0000:07: scanning bus
[    0.147828] pci 0000:07:00.0: [1000:0646] type 00 class 0x0c0400
[    0.147840] pci 0000:07:00.0: reg 0x10: [io  0xb000-0xb0ff]
[    0.147851] pci 0000:07:00.0: reg 0x14: [mem 0xff5fc000-0xff5fffff 64bit]
[    0.147863] pci 0000:07:00.0: reg 0x1c: [mem 0xff5e0000-0xff5effff 64bit]
[    0.147878] pci 0000:07:00.0: reg 0x30: [mem 0xff400000-0xff4fffff pref]
[    0.147916] pci 0000:07:00.0: supports D1 D2
[    0.147967] pci 0000:07:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.148010] pci_scan_child_bus: pci_bus 0000:07: fixups for bus
[    0.148013] pci 0000:00:0a.0: PCI bridge to [bus 07]
[    0.148148] pci 0000:00:0a.0:   bridge window [io  0x9000-0xbfff]
[    0.148152] pci 0000:00:0a.0:   bridge window [mem 0xff300000-0xff5fffff]
[    0.148156] pci 0000:00:0a.0:   bridge window [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.148160] pci_scan_child_bus: pci_bus 0000:07: bus scan returning with max=07
[    0.148164] pci_scan_bridge: pci 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 0
[    0.148199] pci_scan_child_bus: pci_bus 0000:08: scanning bus
[    0.148202] pci_scan_child_bus: pci_bus 0000:08: fixups for bus
[    0.148205] pci 0000:00:0b.0: PCI bridge to [bus 08]
[    0.148344] pci_scan_child_bus: pci_bus 0000:08: bus scan returning with max=08
[    0.148349] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 1
[    0.148354] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 1
[    0.148359] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 1
[    0.148364] pci_scan_bridge: pci 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 1
[    0.148368] pci_scan_bridge: pci 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 1
[    0.148373] pci_scan_bridge: pci 0000:00:0a.0: scanning [bus 07-07] behind bridge, pass 1
[    0.148377] pci_scan_bridge: pci 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 1
[    0.148381] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=08
[    0.148387] pci_bus 0000:00: on NUMA node 0
[    0.149353] ACPI: PCI Interrupt Link [LN00] (IRQs 3 4 5 7 9 11 12 14 15) *0, disabled.
[    0.150197] ACPI: PCI Interrupt Link [LN01] (IRQs 3 4 5 6 7 9 *11 12 14 15)
[    0.150913] ACPI: PCI Interrupt Link [LN02] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.151735] ACPI: PCI Interrupt Link [LN03] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.152879] ACPI: PCI Interrupt Link [LN04] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.153779] ACPI: PCI Interrupt Link [LN05] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.154728] ACPI: PCI Interrupt Link [LN06] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.155638] ACPI: PCI Interrupt Link [LN07] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.156546] ACPI: PCI Interrupt Link [LN08] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.157455] ACPI: PCI Interrupt Link [LN09] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.158408] ACPI: PCI Interrupt Link [LN10] (IRQs 3 4 *5 6 7 9 11 12 14 15)
[    0.159064] ACPI: PCI Interrupt Link [LN11] (IRQs 3 4 5 6 7 *9 11 12 14 15)
[    0.159806] ACPI: PCI Interrupt Link [LN12] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.160818] ACPI: PCI Interrupt Link [LN13] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.161726] ACPI: PCI Interrupt Link [LN14] (IRQs *3 4 5 6 7 9 11 12 14 15)
[    0.162463] ACPI: PCI Interrupt Link [LN15] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.163364] ACPI: PCI Interrupt Link [LN16] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.164318] ACPI: PCI Interrupt Link [LN17] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.165192] ACPI: PCI Interrupt Link [LN18] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.166065] ACPI: PCI Interrupt Link [LN19] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.167064] ACPI: PCI Interrupt Link [LN20] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.168008] ACPI: PCI Interrupt Link [LN21] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.168925] ACPI: PCI Interrupt Link [LN22] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.169818] ACPI: PCI Interrupt Link [LN23] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.170726] ACPI: PCI Interrupt Link [LN24] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.171684] ACPI: PCI Interrupt Link [LN25] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.172590] ACPI: PCI Interrupt Link [LN26] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.173862] ACPI: PCI Interrupt Link [LN27] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.174772] ACPI: PCI Interrupt Link [LN28] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.175682] ACPI: PCI Interrupt Link [LN29] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.176636] ACPI: PCI Interrupt Link [LN30] (IRQs 3 4 5 6 7 9 11 12 14 15) *0, disabled.
[    0.177581] ACPI: PCI Interrupt Link [LNUS] (IRQs *10)
[    0.177925] ACPI: PCI Interrupt Link [LNSA] (IRQs *11)
[    0.178544] vgaarb: device added: PCI:0000:00:0c.0,decodes=io+mem,owns=io+mem,locks=none
[    0.178779] vgaarb: loaded
[    0.178911] vgaarb: bridge control possible 0000:00:0c.0
[    0.179162] SCSI subsystem initialized
[    0.179412] libata version 3.00 loaded.
[    0.179485] ACPI: bus type USB registered
[    0.179665] usbcore: registered new interface driver usbfs
[    0.179826] usbcore: registered new interface driver hub
[    0.180065] usbcore: registered new device driver usb
[    0.180236] pps_core: LinuxPPS API ver. 1 registered
[    0.180375] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.180612] PTP clock support registered
[    0.180890] Advanced Linux Sound Architecture Driver Initialized.
[    0.181008] PCI: Using ACPI for IRQ routing
[    0.181147] PCI: pci_cache_line_size set to 64 bytes
[    0.181214] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.181217] e820: reserve RAM buffer [mem 0x7fff0000-0x7fffffff]
[    0.181580] cfg80211: Calling CRDA to update world regulatory domain
[    0.181747] NetLabel: Initializing
[    0.181880] NetLabel:  domain hash size = 128
[    0.182003] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.182162] NetLabel:  unlabeled traffic allowed by default
[    0.182472] Switched to clocksource refined-jiffies
[    0.193930] pnp: PnP ACPI init
[    0.194162] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.194693] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.194834] system 00:01: [io  0x0c00-0x0c01] has been reserved
[    0.195007] system 00:01: [io  0x0cd6-0x0cd7] has been reserved
[    0.195145] system 00:01: [io  0x0cd4-0x0cd5] has been reserved
[    0.195282] system 00:01: [io  0x0cd8-0x0cdf] has been reserved
[    0.195420] system 00:01: [io  0x040b] has been reserved
[    0.195555] system 00:01: [io  0x04d6] has been reserved
[    0.195691] system 00:01: [io  0x0c06-0x0c07] has been reserved
[    0.195827] system 00:01: [io  0x0c14] has been reserved
[    0.196003] system 00:01: [io  0x0c49] has been reserved
[    0.196139] system 00:01: [io  0x0c4a] has been reserved
[    0.196275] system 00:01: [io  0x0c50-0x0c51] has been reserved
[    0.196414] system 00:01: [io  0x0c52] has been reserved
[    0.196549] system 00:01: [io  0x0c6c] has been reserved
[    0.196685] system 00:01: [io  0x0c6f] has been reserved
[    0.196821] system 00:01: [io  0x0500-0x057f] could not be reserved
[    0.197002] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.197178] system 00:02: [io  0x0580-0x058f] has been reserved
[    0.197316] system 00:02: [io  0x0590-0x0593] has been reserved
[    0.197455] system 00:02: [io  0x0700-0x0703] has been reserved
[    0.197592] system 00:02: [io  0x0ca0-0x0caf] has been reserved
[    0.197731] system 00:02: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.197871] system 00:02: [mem 0xfec01000-0xfec01fff] could not be reserved
[    0.198003] system 00:02: [mem 0xfec02000-0xfec02fff] could not be reserved
[    0.198143] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.198282] system 00:02: [mem 0xfff00000-0xffffffff] has been reserved
[    0.198421] system 00:02: [mem 0xff780000-0xffbfffff] has been reserved
[    0.198560] system 00:02: [mem 0xfebfe000-0xfebfefff] has been reserved
[    0.198698] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.198810] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.199159] system 00:04: [io  0x0600-0x061f] has been reserved
[    0.199297] system 00:04: [io  0x0520-0x053f] has been reserved
[    0.199433] system 00:04: [io  0x0540-0x054f] has been reserved
[    0.199570] system 00:04: [io  0x0640-0x065f] has been reserved
[    0.199707] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.199795] system 00:05: [mem 0xe0000000-0xefffffff] has been reserved
[    0.199935] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.200102] system 00:06: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.200242] system 00:06: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.200381] system 00:06: [mem 0x00100000-0x7fffffff] could not be reserved
[    0.200521] system 00:06: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.201175] pnp: PnP ACPI: found 7 devices
[    0.208207] Switched to clocksource acpi_pm
[    0.208421] pci 0000:01:0d.0: PCI bridge to [bus 02]
[    0.208568] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.208708] pci 0000:00:01.0:   bridge window [io  0x7000-0x8fff]
[    0.208850] pci 0000:00:01.0:   bridge window [mem 0xff100000-0xff1fffff]
[    0.208850] pci 0000:00:06.0: PCI bridge to [bus 03]
[    0.208968] pci 0000:00:07.0: PCI bridge to [bus 04]
[    0.209125] pci 0000:00:07.0:   bridge window [mem 0xff200000-0xff2fffff]
[    0.209270] pci 0000:00:07.0:   bridge window [mem 0xcfd00000-0xcfdfffff 64bit pref]
[    0.209496] pci 0000:00:08.0: PCI bridge to [bus 05]
[    0.209638] pci 0000:00:09.0: PCI bridge to [bus 06]
[    0.209781] pci 0000:00:0a.0: PCI bridge to [bus 07]
[    0.209920] pci 0000:00:0a.0:   bridge window [io  0x9000-0xbfff]
[    0.210078] pci 0000:00:0a.0:   bridge window [mem 0xff300000-0xff5fffff]
[    0.210221] pci 0000:00:0a.0:   bridge window [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.210447] pci 0000:00:0b.0: PCI bridge to [bus 08]
[    0.210590] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.210593] pci_bus 0000:00: resource 5 [mem 0x000a0000-0x000bffff]
[    0.210596] pci_bus 0000:00: resource 6 [mem 0x80000000-0xffffffff]
[    0.210598] pci_bus 0000:00: resource 7 [mem 0x200000000-0xfcffffffff]
[    0.210601] pci_bus 0000:01: resource 0 [io  0x7000-0x8fff]
[    0.210604] pci_bus 0000:01: resource 1 [mem 0xff100000-0xff1fffff]
[    0.210608] pci_bus 0000:04: resource 1 [mem 0xff200000-0xff2fffff]
[    0.210610] pci_bus 0000:04: resource 2 [mem 0xcfd00000-0xcfdfffff 64bit pref]
[    0.210614] pci_bus 0000:07: resource 0 [io  0x9000-0xbfff]
[    0.210616] pci_bus 0000:07: resource 1 [mem 0xff300000-0xff5fffff]
[    0.210619] pci_bus 0000:07: resource 2 [mem 0xcfe00000-0xcfefffff 64bit pref]
[    0.210694] NET: Registered protocol family 2
[    0.211293] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.211969] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.212765] TCP: Hash tables configured (established 65536 bind 65536)
[    0.213047] TCP: reno registered
[    0.213212] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.213486] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.213876] NET: Registered protocol family 1
[    0.214205] RPC: Registered named UNIX socket transport module.
[    0.214350] RPC: Registered udp transport module.
[    0.214490] RPC: Registered tcp transport module.
[    0.214631] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.214807] fixup_debug_start: pci 0000:00:02.0: calling quirk_disable_broadcom_boot_interrupt+0x0/0xb0
[    0.214871] pci 0000:00:02.0: disabled boot interrupts on device [1166:0205]
[    0.215043] fixup_debug_start: pci 0000:00:03.0: calling quirk_usb_early_handoff+0x0/0x770
[    0.287068] fixup_debug_start: pci 0000:00:03.1: calling quirk_usb_early_handoff+0x0/0x770
[    0.349062] fixup_debug_start: pci 0000:00:03.2: calling quirk_usb_early_handoff+0x0/0x770
[    0.349153] fixup_debug_start: pci 0000:00:08.0: calling quirk_msi_ht_cap+0x0/0x50
[    0.349159] pci 0000:00:08.0: Found enabled HT MSI Mapping
[    0.349299] fixup_debug_start: pci 0000:00:09.0: calling quirk_msi_ht_cap+0x0/0x50
[    0.349303] pci 0000:00:09.0: Found enabled HT MSI Mapping
[    0.349442] fixup_debug_start: pci 0000:00:0a.0: calling quirk_msi_ht_cap+0x0/0x50
[    0.349447] pci 0000:00:0a.0: Found enabled HT MSI Mapping
[    0.349585] fixup_debug_start: pci 0000:00:0b.0: calling quirk_msi_ht_cap+0x0/0x50
[    0.349590] pci 0000:00:0b.0: Found enabled HT MSI Mapping
[    0.351464] fixup_debug_start: pci 0000:00:0c.0: calling pci_fixup_video+0x0/0x150
[    0.351468] pci 0000:00:0c.0: Boot video device
[    0.351476] fixup_debug_start: pci 0000:00:18.0: calling quirk_amd_nb_node+0x0/0x80
[    0.351484] fixup_debug_start: pci 0000:00:18.1: calling quirk_amd_nb_node+0x0/0x80
[    0.351491] fixup_debug_start: pci 0000:00:18.2: calling quirk_amd_nb_node+0x0/0x80
[    0.351498] fixup_debug_start: pci 0000:00:18.3: calling quirk_amd_nb_node+0x0/0x80
[    0.351504] fixup_debug_start: pci 0000:00:19.0: calling quirk_amd_nb_node+0x0/0x80
[    0.351511] fixup_debug_start: pci 0000:00:19.1: calling quirk_amd_nb_node+0x0/0x80
[    0.351518] fixup_debug_start: pci 0000:00:19.2: calling quirk_amd_nb_node+0x0/0x80
[    0.351524] fixup_debug_start: pci 0000:00:19.3: calling quirk_amd_nb_node+0x0/0x80
[    0.351539] fixup_debug_start: pci 0000:04:04.0: calling quirk_msi_intx_disable_bug+0x0/0x10
[    0.351546] fixup_debug_start: pci 0000:04:04.1: calling quirk_msi_intx_disable_bug+0x0/0x10
[    0.351551] PCI: CLS 64 bytes, default 64
[    0.351640] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.351778] software IO TLB [mem 0x79c00000-0x7dc00000] (64MB) mapped at [ffff880079c00000-ffff88007dbfffff]
[    0.352199] microcode: AMD CPU family 0xf not supported
[    0.352752] Scanning for low memory corruption every 60 seconds
[    0.353359] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.353558] audit: initializing netlink subsys (disabled)
[    0.353724] audit: type=2000 audit(1411150545.352:1): initialized
[    0.354336] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.357365] VFS: Disk quotas dquot_6.5.2
[    0.357580] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.358757] NFS: Registering the id_resolver key type
[    0.358924] Key type id_resolver registered
[    0.359078] Key type id_legacy registered
[    0.359325] msgmni has been set to 11898
[    0.359560] SELinux:  Registering netfilter hooks
[    0.360391] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
[    0.360625] io scheduler noop registered
[    0.360765] io scheduler deadline registered
[    0.361019] io scheduler cfq registered (default)
[    0.361395] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.361730] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.361962] ACPI: Power Button [PWRB]
[    0.362175] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.362403] ACPI: Power Button [PWRF]
[    0.362616] input: Sleep Button as /devices/LNXSYSTM:00/LNXSLPBN:00/input/input2
[    0.362847] ACPI: Sleep Button [SLPF]
[    0.363442] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.364478] Non-volatile memory driver v1.3
[    0.364645] Linux agpgart interface v0.103
[    0.365310] [drm] Initialized drm 1.1.0 20060810
[    0.366604] loop: module loaded
[    0.367019] sata_svw 0000:01:0e.0: version 2.3
[    0.367851] scsi host0: sata_svw
[    0.368417] scsi host1: sata_svw
[    0.368707] scsi host2: sata_svw
[    0.368982] scsi host3: sata_svw
[    0.369208] ata1: SATA max UDMA/133 mmio m8192@0xff1fe000 port 0xff1fe000 irq 11
[    0.369427] ata2: SATA max UDMA/133 mmio m8192@0xff1fe000 port 0xff1fe100 irq 11
[    0.369645] ata3: SATA max UDMA/133 mmio m8192@0xff1fe000 port 0xff1fe200 irq 11
[    0.369863] ata4: SATA max UDMA/133 mmio m8192@0xff1fe000 port 0xff1fe300 irq 11
[    0.370884] scsi host4: pata_serverworks
[    0.371213] scsi host5: pata_serverworks
[    0.371402] ata5: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.371540] ata6: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    0.371817] tg3.c:v3.137 (May 11, 2014)
[    0.383849] tg3 0000:04:04.0 eth0: Tigon3 [partno(BCM95780) rev 8003] (PCIX:133MHz:64-bit) MAC address 00:e0:81:47:5e:b0
[    0.384094] tg3 0000:04:04.0 eth0: attached PHY is 5780 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    0.384318] tg3 0000:04:04.0 eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    0.384537] tg3 0000:04:04.0 eth0: dma_rwctrl[76144000] dma_mask[40-bit]
[    0.399153] tg3 0000:04:04.1 eth1: Tigon3 [partno(BCM95780) rev 8003] (PCIX:133MHz:64-bit) MAC address 00:e0:81:47:5e:b1
[    0.399379] tg3 0000:04:04.1 eth1: attached PHY is 5780 (10/100/1000Base-T Ethernet) (WireSpeed[1], EEE[0])
[    0.399603] tg3 0000:04:04.1 eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    0.399822] tg3 0000:04:04.1 eth1: dma_rwctrl[76144000] dma_mask[40-bit]
[    0.400016] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    0.400177] e100: Copyright(c) 1999-2006 Intel Corporation
[    0.400352] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    0.400493] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    0.400657] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    0.400795] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    0.400966] jme: JMicron JMC2XX ethernet driver version 1.0.8
[    0.401143] sky2: driver version 1.30
[    0.401526] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.401672] ehci-pci: EHCI PCI platform driver
[    0.401901] __pci_set_master: ehci-pci 0000:00:03.2: enabling bus mastering
[    0.401921] ehci-pci 0000:00:03.2: EHCI Host Controller
[    0.402157] ehci-pci 0000:00:03.2: new USB bus registered, assigned bus number 1
[    0.402443] ehci-pci 0000:00:03.2: irq 10, io mem 0xff6ea000
[    0.408022] ehci-pci 0000:00:03.2: USB 2.0 started, EHCI 1.00
[    0.408227] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.408366] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.408584] usb usb1: Product: EHCI Host Controller
[    0.408717] usb usb1: Manufacturer: Linux 3.17.0-rc5+ ehci_hcd
[    0.408853] usb usb1: SerialNumber: 0000:00:03.2
[    0.409177] hub 1-0:1.0: USB hub found
[    0.409319] hub 1-0:1.0: 4 ports detected
[    0.409602] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.409751] ohci-pci: OHCI PCI platform driver
[    0.409959] __pci_set_master: ohci-pci 0000:00:03.0: enabling bus mastering
[    0.409966] ohci-pci 0000:00:03.0: OHCI PCI host controller
[    0.410181] ohci-pci 0000:00:03.0: new USB bus registered, assigned bus number 2
[    0.410436] ohci-pci 0000:00:03.0: irq 10, io mem 0xff6e8000
[    0.465107] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.465246] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.465463] usb usb2: Product: OHCI PCI host controller
[    0.465597] usb usb2: Manufacturer: Linux 3.17.0-rc5+ ohci_hcd
[    0.465733] usb usb2: SerialNumber: 0000:00:03.0
[    0.466036] hub 2-0:1.0: USB hub found
[    0.466178] hub 2-0:1.0: 2 ports detected
[    0.466468] __pci_set_master: ohci-pci 0000:00:03.1: enabling bus mastering
[    0.466474] ohci-pci 0000:00:03.1: OHCI PCI host controller
[    0.466665] ohci-pci 0000:00:03.1: new USB bus registered, assigned bus number 3
[    0.466902] ohci-pci 0000:00:03.1: irq 10, io mem 0xff6e9000
[    0.533692] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.533831] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.534057] usb usb3: Product: OHCI PCI host controller
[    0.534191] usb usb3: Manufacturer: Linux 3.17.0-rc5+ ohci_hcd
[    0.534327] usb usb3: SerialNumber: 0000:00:03.1
[    0.534613] hub 3-0:1.0: USB hub found
[    0.534752] hub 3-0:1.0: 2 ports detected
[    0.534991] uhci_hcd: USB Universal Host Controller Interface driver
[    0.535217] usbcore: registered new interface driver usblp
[    0.535389] usbcore: registered new interface driver usb-storage
[    0.535582] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.535723] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.536554] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.536822] mousedev: PS/2 mouse device common for all mice
[    0.537276] rtc_cmos 00:00: RTC can wake from S4
[    0.537614] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    0.537788] rtc_cmos 00:00: alarms up to one year, y3k, 114 bytes nvram
[    0.538138] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    0.538416] hidraw: raw HID events driver (C) Jiri Kosina
[    0.538865] usbcore: registered new interface driver usbhid
[    0.539021] usbhid: USB HID core driver
[    0.539517] Netfilter messages via NETLINK v0.30.
[    0.539672] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    0.540031] ctnetlink v0.93: registering with nfnetlink.
[    0.540340] ip_tables: (C) 2000-2006 Netfilter Core Team
[    0.540588] TCP: cubic registered
[    0.540723] Initializing XFRM netlink socket
[    0.541106] NET: Registered protocol family 10
[    0.541671] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    0.541933] sit: IPv6 over IPv4 tunneling driver
[    0.542315] NET: Registered protocol family 17
[    0.542491] Key type dns_resolver registered
[    0.543132] registered taskstats version 1
[    0.543781]   Magic number: 14:76:292
[    0.543974] tty tty25: hash matches
[    0.544191] console [netcon0] enabled
[    0.544330] netconsole: network logging started
[    0.544589] PM: Hibernation image not present or could not be loaded.
[    0.544592] ALSA device list:
[    0.544727]   No soundcards found.
[    0.560077] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    0.685594] ata1: SATA link down (SStatus 4 SControl 300)
[    1.000543] ata2: SATA link down (SStatus 4 SControl 300)
[    1.305039] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.308315] ata3.00: ATA-8: WDC WD3200AAJS-07M0A0, 01.03E01, max UDMA/133
[    1.308454] ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.314609] ata3.00: configured for UDMA/133
[    1.314865] scsi 2:0:0:0: Direct-Access     ATA      WDC WD3200AAJS-0 3E01 PQ: 0 ANSI: 5
[    1.315369] sd 2:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.315648] sd 2:0:0:0: [sda] Write Protect is off
[    1.315783] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.315811] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.316115] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    1.323952]  sda: sda1 sda2 sda3 sda4
[    1.324559] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.631585] ata4: SATA link down (SStatus 4 SControl 300)
[    1.782109] md: Waiting for all devices to be available before autodetect
[    1.782247] md: If you don't use raid, use raid=noautodetect
[    1.782594] md: Autodetecting RAID arrays.
[    1.782732] md: Scanned 0 and added 0 devices.
[    1.782867] md: autorun ...
[    1.782999] md: ... autorun DONE.
[    1.793066] EXT4-fs (sda2): couldn't mount as ext3 due to feature incompatibilities
[    1.793518] EXT4-fs (sda2): couldn't mount as ext2 due to feature incompatibilities
[    1.809681] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: (null)
[    1.811717] VFS: Mounted root (ext4 filesystem) readonly on device 8:2.
[    1.834901] devtmpfs: mounted
[    1.837127] Freeing unused kernel memory: 1076K (ffffffff81ef4000 - ffffffff82001000)
[    1.837360] Write protecting the kernel read-only data: 14336k
[    1.844691] Freeing unused kernel memory: 1612K (ffff88000186d000 - ffff880001a00000)
[    1.850349] Freeing unused kernel memory: 1256K (ffff880001cc6000 - ffff880001e00000)
[    2.374886] random: nonblocking pool is initialized
[    2.380754] loadkeys (1023) used greatest stack depth: 13232 bytes left
[    2.381229] init-early.sh (1021) used greatest stack depth: 12576 bytes left
[    3.227714] systemd-udevd[1193]: starting version 215
[    3.531667] tg3 0000:04:04.0 enp4s4f0: renamed from eth0
[    3.535186] systemd-udevd[1208]: renamed network interface eth0 to enp4s4f0
[    3.539134] tg3 0000:04:04.1 enp4s4f1: renamed from eth1
[    3.543740] systemd-udevd[1209]: renamed network interface eth1 to enp4s4f1
[    5.227315] EXT4-fs (sda2): re-mounted. Opts: (null)
[    5.442732] EXT4-fs (sda1): mounting ext2 file system using the ext4 subsystem
[    5.444074] EXT4-fs (sda1): mounted filesystem without journal. Opts: (null)
[    6.415352] tg3 0000:04:04.0: irq 18 for MSI/MSI-X
[    6.443427] IPv6: ADDRCONF(NETDEV_UP): enp4s4f0: link is not ready
[    9.670271] tg3 0000:04:04.0 enp4s4f0: Link is up at 1000 Mbps, full duplex
[    9.670283] tg3 0000:04:04.0 enp4s4f0: Flow control is off for TX and off for RX
[    9.670305] IPv6: ADDRCONF(NETDEV_CHANGE): enp4s4f0: link becomes ready
[  132.913102] pci_bus 0000:07: busn_res: [bus 07] is released
[  132.918112] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[  132.918155] pci 0000:00:0a.0: [1166:0132] type 01 class 0x060400
[  132.918258] pci 0000:00:0a.0: System wakeup disabled by ACPI
[  132.918351] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 0
[  132.918357] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[  132.918387] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 0
[  132.918392] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[  132.918425] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[  132.918430] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 1
[  132.918436] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=02
[  132.918441] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 0
[  132.918445] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[  132.918473] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[  132.918477] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 0
[  132.918481] pci_scan_child_bus: pci_bus 0000:04: scanning bus
[  132.918506] pci_scan_child_bus: pci_bus 0000:04: bus scan returning with max=04
[  132.918510] pci_scan_bridge: pcieport 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 0
[  132.918515] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[  132.918519] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[  132.918523] pci_scan_bridge: pcieport 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 0
[  132.918527] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[  132.918531] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[  132.918536] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 0
[  132.918540] pci_scan_child_bus: pci_bus 0000:08: scanning bus
[  132.918543] pci_scan_child_bus: pci_bus 0000:08: bus scan returning with max=08
[  132.918549] pci_scan_bridge: pci 0000:00:0a.0: scanning [bus 10-10] behind bridge, pass 0
[  132.918552] pci 0000:00:0a.0: bridge configuration invalid ([bus 10-10]), reconfiguring
[  132.918557] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 1
[  132.918563] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 1
[  132.918568] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 1
[  132.918572] pci_scan_bridge: pcieport 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 1
[  132.918577] pci_scan_bridge: pcieport 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 1
[  132.918582] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 1
[  132.918586] pci_scan_bridge: pci 0000:00:0a.0: scanning [bus 00-00] behind bridge, pass 1
[  132.918625] pci_scan_child_bus: pci_bus 0000:09: scanning bus
[  132.918630] pci_scan_child_bus: pci_bus 0000:09: fixups for bus
[  132.918633] pci 0000:00:0a.0: PCI bridge to [bus 09]
[  132.918639] pci 0000:00:0a.0:   bridge window [io  0x9000-0xbfff]
[  132.918643] pci 0000:00:0a.0:   bridge window [mem 0xff300000-0xff5fffff]
[  132.918648] pci 0000:00:0a.0:   bridge window [mem 0xcfe00000-0xcfefffff 64bit pref]
[  132.918651] pci_scan_child_bus: pci_bus 0000:09: bus scan returning with max=09
[  132.918654] pci_bus 0000:09: busn_res: [bus 09] end is updated to 09
[  132.918659] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=09
[  132.918705] pci 0000:00:0a.0: BAR 8: assigned [mem 0x80000000-0x802fffff]
[  132.918711] pci 0000:00:0a.0: BAR 9: assigned [mem 0x200000000-0x2000fffff 64bit pref]
[  132.918716] pci 0000:00:0a.0: BAR 7: assigned [io  0x1000-0x3fff]
[  132.918720] pci 0000:01:0d.0: PCI bridge to [bus 02]
[  132.918729] pci 0000:00:06.0: PCI bridge to [bus 03]
[  132.918736] pci 0000:00:0a.0: PCI bridge to [bus 09]
[  132.918740] pci 0000:00:0a.0:   bridge window [io  0x1000-0x3fff]
[  132.918744] pci 0000:00:0a.0:   bridge window [mem 0x80000000-0x802fffff]
[  132.918747] pci 0000:00:0a.0:   bridge window [mem 0x200000000-0x2000fffff 64bit pref]
[  132.918761] fixup_debug_start: pci 0000:00:0a.0: calling quirk_msi_ht_cap+0x0/0x50
[  132.918766] pci 0000:00:0a.0: Found enabled HT MSI Mapping
[  133.935556] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[  133.935612] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 0
[  133.935619] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[  133.935649] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 0
[  133.935653] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[  133.935686] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[  133.935692] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 1
[  133.935696] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=02
[  133.935701] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 0
[  133.935705] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[  133.935733] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[  133.935737] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 0
[  133.935741] pci_scan_child_bus: pci_bus 0000:04: scanning bus
[  133.935764] pci_scan_child_bus: pci_bus 0000:04: bus scan returning with max=04
[  133.935769] pci_scan_bridge: pcieport 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 0
[  133.935773] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[  133.935777] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[  133.935781] pci_scan_bridge: pcieport 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 0
[  133.935785] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[  133.935789] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[  133.935794] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 0
[  133.935798] pci_scan_child_bus: pci_bus 0000:08: scanning bus
[  133.935802] pci_scan_child_bus: pci_bus 0000:08: bus scan returning with max=08
[  133.935806] pci_scan_bridge: pcieport 0000:00:0a.0: scanning [bus 09-09] behind bridge, pass 0
[  133.935810] pci_scan_child_bus: pci_bus 0000:09: scanning bus
[  133.935814] pci_scan_child_bus: pci_bus 0000:09: bus scan returning with max=09
[  133.935819] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 1
[  133.935824] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 1
[  133.935829] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 1
[  133.935834] pci_scan_bridge: pcieport 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 1
[  133.935839] pci_scan_bridge: pcieport 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 1
[  133.935843] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 1
[  133.935848] pci_scan_bridge: pcieport 0000:00:0a.0: scanning [bus 09-09] behind bridge, pass 1
[  133.935852] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=09
[  133.935889] pci 0000:01:0d.0: PCI bridge to [bus 02]
[  133.935900] pci 0000:00:06.0: PCI bridge to [bus 03]
[  142.403737] pci_scan_child_bus: pci_bus 0000:00: scanning bus
[  142.403806] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 0
[  142.403814] pci_scan_child_bus: pci_bus 0000:01: scanning bus
[  142.403846] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 0
[  142.403851] pci_scan_child_bus: pci_bus 0000:02: scanning bus
[  142.403885] pci_scan_child_bus: pci_bus 0000:02: bus scan returning with max=02
[  142.403891] pci_scan_bridge: pci 0000:01:0d.0: scanning [bus 02-02] behind bridge, pass 1
[  142.403896] pci_scan_child_bus: pci_bus 0000:01: bus scan returning with max=02
[  142.403902] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 0
[  142.403906] pci_scan_child_bus: pci_bus 0000:03: scanning bus
[  142.403935] pci_scan_child_bus: pci_bus 0000:03: bus scan returning with max=03
[  142.403940] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 0
[  142.403944] pci_scan_child_bus: pci_bus 0000:04: scanning bus
[  142.403970] pci_scan_child_bus: pci_bus 0000:04: bus scan returning with max=04
[  142.403975] pci_scan_bridge: pcieport 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 0
[  142.403979] pci_scan_child_bus: pci_bus 0000:05: scanning bus
[  142.403982] pci_scan_child_bus: pci_bus 0000:05: bus scan returning with max=05
[  142.403987] pci_scan_bridge: pcieport 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 0
[  142.403991] pci_scan_child_bus: pci_bus 0000:06: scanning bus
[  142.403995] pci_scan_child_bus: pci_bus 0000:06: bus scan returning with max=06
[  142.404000] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 0
[  142.404043] pci_scan_child_bus: pci_bus 0000:08: scanning bus
[  142.404047] pci_scan_child_bus: pci_bus 0000:08: bus scan returning with max=08
[  142.404053] pci_scan_bridge: pcieport 0000:00:0a.0: scanning [bus 09-09] behind bridge, pass 0
[  142.404057] pci_scan_child_bus: pci_bus 0000:09: scanning bus
[  142.404077] pci 0000:09:00.0: [1000:0646] type 00 class 0x0c0400
[  142.404093] pci 0000:09:00.0: reg 0x10: [io  0x0000-0x00ff]
[  142.404105] pci 0000:09:00.0: reg 0x14: [mem 0x00000000-0x00003fff 64bit]
[  142.404116] pci 0000:09:00.0: reg 0x1c: [mem 0x00000000-0x0000ffff 64bit]
[  142.404128] pci 0000:09:00.0: reg 0x30: [mem 0x00000000-0x000fffff pref]
[  142.404177] pci 0000:09:00.0: supports D1 D2
[  142.406042] pci_scan_child_bus: pci_bus 0000:09: bus scan returning with max=09
[  142.406049] pci_scan_bridge: pci 0000:00:01.0: scanning [bus 01-02] behind bridge, pass 1
[  142.406055] pci_scan_bridge: pci 0000:00:06.0: scanning [bus 03-03] behind bridge, pass 1
[  142.406061] pci_scan_bridge: pci 0000:00:07.0: scanning [bus 04-04] behind bridge, pass 1
[  142.406066] pci_scan_bridge: pcieport 0000:00:08.0: scanning [bus 05-05] behind bridge, pass 1
[  142.406071] pci_scan_bridge: pcieport 0000:00:09.0: scanning [bus 06-06] behind bridge, pass 1
[  142.406076] pci_scan_bridge: pcieport 0000:00:0b.0: scanning [bus 08-08] behind bridge, pass 1
[  142.406082] pci_scan_bridge: pcieport 0000:00:0a.0: scanning [bus 09-09] behind bridge, pass 1
[  142.406086] pci_scan_child_bus: pci_bus 0000:00: bus scan returning with max=09
[  142.406137] pci 0000:01:0d.0: PCI bridge to [bus 02]
[  142.406147] pci 0000:00:06.0: PCI bridge to [bus 03]
[  142.406163] pci 0000:09:00.0: BAR 6: assigned [mem 0x80000000-0x800fffff pref]
[  142.406168] pci 0000:09:00.0: BAR 3: assigned [mem 0x80100000-0x8010ffff 64bit]
[  142.406179] pci 0000:09:00.0: BAR 1: assigned [mem 0x80110000-0x80113fff 64bit]
[  142.406188] pci 0000:09:00.0: BAR 0: assigned [io  0x1000-0x10ff]
