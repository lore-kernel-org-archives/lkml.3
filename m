Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305Ab3LXDx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 22:53:27 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:29646 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758041Ab3LXDxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 22:53:25 -0500
Message-ID: <52B9051A.3090701@huawei.com>
Date: Tue, 24 Dec 2013 11:52:58 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Bin <huawei.libin@huawei.com>
Subject: Re: [PATCH v2][TRIVIAL] x86/smpboot: fix cpu bootup message
References: <52B7F53C.5020001@huawei.com> <20131223133402.GA4487@pd.tnic> <52B8DEAE.2040100@huawei.com> <CAE9FiQWUfu6kNvpeN+e_Gp7L2NxddYnvG2oy9YB7CpqbeMgp-Q@mail.gmail.com>
In-Reply-To: <CAE9FiQWUfu6kNvpeN+e_Gp7L2NxddYnvG2oy9YB7CpqbeMgp-Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/24 9:34, Yinghai Lu wrote:
> On Mon, Dec 23, 2013 at 5:09 PM, Xie XiuQi <xiexiuqi@huawei.com> wrote:
>> On 2013/12/23 21:34, Borislav Petkov wrote:
>>> On Mon, Dec 23, 2013 at 04:33:00PM +0800, Xie XiuQi wrote:
>>>> When CPU0 and CPU1 aren't in same package, we got message
>>>> like this:
>>>>
>>
>> [...]
>>
>>>>
>>>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>>>> index 85dc05a..9e82c1e 100644
>>>> --- a/arch/x86/kernel/smpboot.c
>>>> +++ b/arch/x86/kernel/smpboot.c
>>>> @@ -639,7 +639,7 @@ static void announce_cpu(int cpu, int apicid)
>>>>  {
>>>>      static int current_node = -1;
>>>>      int node = early_cpu_to_node(cpu);
>>>> -    static int width, node_width;
>>>> +    static int width, node_width, padding;
>>>>
>>>>      if (!width)
>>>>              width = num_digits(num_possible_cpus()) + 1; /* + '#' sign */
>>>> @@ -658,11 +658,13 @@ static void announce_cpu(int cpu, int apicid)
>>>>
>>>>                      printk(KERN_INFO ".... node %*s#%d, CPUs:  ",
>>>>                             node_width - num_digits(node), " ", node);
>>>> -            }
>>>>
>>>> -            /* Add padding for the BSP */
>>>> -            if (cpu == 1)
>>>> -                    pr_cont("%*s", width + 1, " ");
>>>> +                    /* Add padding for the BSP */
>>>> +                    if (!padding && (early_cpu_to_node(0) == current_node)) {
>>>
>>> You don't need "padding".
>>>
>>
>> On another machine, the configuration is:
>>
>> xiexiuqi@localhost:~> lscpu
>> [...]
>> NUMA node0 CPU(s):     4-7,12-15
>> NUMA node1 CPU(s):     0-3,8-11
>>
>> Without "padding", we'll get message like this:
>>
>> [    0.349339] x86: Booting SMP configuration:
>> [    0.353504] .... node  #1, CPUs:        #1  #2  #3
>> [    0.398812] .... node  #0, CPUs:    #4  #5  #6  #7
>> [    0.535186] .... node  #1, CPUs:        #8  #9 #10 #11
>> [    0.594312] .... node  #0, CPUs:   #12 #13 #14 #15
>> [    0.652398] x86: Booted up 2 nodes, 16 CPUs
>>
> 
> What does your MADT look like?
> 
> you can you post head of bootlog with MADT print out?
> 

This's my boot log, could you find any problems?

[    0.000000] DMI: Huawei Technologies Co., Ltd. Tecal RH2285          /BC11BTSA              , BIOS CTSAV036 04/27/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0xc40000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-through
[    0.000000]   E8000-EBFFF write-protect
[    0.000000]   EC000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask F800000000 write-back
[    0.000000]   1 base 0800000000 mask FC00000000 write-back
[    0.000000]   2 base 0C00000000 mask FFC0000000 write-back
[    0.000000]   3 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   4 base 00BF800000 mask FFFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xbf800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xbf790 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000ff780-0x000ff78f] mapped at [ffff8800000ff780]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000093000] 93000 size 28672
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01ed2000, 0x01ed2fff] PGTABLE
[    0.000000] BRK [0x01ed3000, 0x01ed3fff] PGTABLE
[    0.000000] BRK [0x01ed4000, 0x01ed4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xc3fe00000-0xc3fffffff]
[    0.000000]  [mem 0xc3fe00000-0xc3fffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0xc3c000000-0xc3fdfffff]
[    0.000000]  [mem 0xc3c000000-0xc3fdfffff] page 1G
[    0.000000] init_memory_mapping: [mem 0xc00000000-0xc3bffffff]
[    0.000000]  [mem 0xc00000000-0xc3bffffff] page 1G
[    0.000000] init_memory_mapping: [mem 0x00100000-0xbf78ffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xbf5fffff] page 2M
[    0.000000]  [mem 0xbf600000-0xbf78ffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0xbffffffff]
[    0.000000]  [mem 0x100000000-0xbffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x3708a000-0x37feffff]
[    0.000000] ACPI: RSDP 00000000000fa0d0 000024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf790100 00005C (v01 042711 XSDT1631 20110427 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf790290 0000F4 (v04 042711 FACP1631 20110427 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7904f0 004E48 (v02  CTSAV CTSAV036 00000036 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf79e000 000040
[    0.000000] ACPI: APIC 00000000bf790390 000118 (v02 042711 APIC1631 20110427 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf7904b0 00003C (v01 042711 OEMMCFG  20110427 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf79e040 000082 (v01 042711 OEMB1631 20110427 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000bf79a4f0 0001D0 (v02 042711 OEMSRAT  00000001 INTL 00000001)
[    0.000000] ACPI: HPET 00000000bf79a6c0 000038 (v01 042711 OEMHPET  20110427 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf7a19e0 000363 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x0009ffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00100000-0xbfffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x63fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x640000000-0xc3fffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xbfffffff] -> [mem 0x00000000-0xbfffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x63fffffff] -> [mem 0x00000000-0x63fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x63fffffff]
[    0.000000]   NODE_DATA [mem 0x63ffd9000-0x63fffffff]
[    0.000000] Initmem setup node 1 [mem 0x640000000-0xc3fffffff]
[    0.000000]   NODE_DATA [mem 0xc3ffd7000-0xc3fffdfff]
[    0.000000] Reserving 128MB of memory at 752MB for crashkernel (System RAM: 49143MB)
[    0.000000]  [ffffea0000000000-ffffea0015dfffff] PMD -> [ffff880627e00000-ffff88063cdfffff] on node 0
[    0.000000]  [ffffea0015e00000-ffffea002adfffff] PMD -> [ffff880c27600000-ffff880c3c5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0xc3fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00099fff]
[    0.000000]   node   0: [mem 0x00100000-0xbf78ffff]
[    0.000000]   node   0: [mem 0x100000000-0x63fffffff]
[    0.000000]   node   1: [mem 0x640000000-0xc3fffffff]
[    0.000000] On node 0 totalpages: 6289193
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3993 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10667 pages used for memmap
[    0.000000]   DMA32 zone: 780176 pages, LIFO batch:31
[    0.000000]   Normal zone: 75264 pages used for memmap
[    0.000000]   Normal zone: 5505024 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 6291456
[    0.000000]   Normal zone: 86016 pages used for memmap
[    0.000000]   Normal zone: 6291456 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x90] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x91] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x92] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x93] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x94] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x95] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x96] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x97] disabled)
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 6, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec8a000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 7, version 32, address 0xfec8a000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 24 CPUs, 8 hotplug CPUs

> wonder if your system have x2apic and xapic mixing.
> then
> 
> https://lkml.org/lkml/2012/1/31/57
> [PATCH -v2] x86, acpi: Handle xapic/x2apic entries in MADT at same time
> 
> could help.
> 
> Thanks
> 
> Yinghai
> 


