Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab3GANIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:08:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab3GANIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:08:12 -0400
Message-ID: <51D17F2B.7000300@redhat.com>
Date: Mon, 01 Jul 2013 09:07:55 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, athorlton@sgi.com,
        CAI Qian <caiqian@redhat.com>
Subject: Re: BUG: tick device NULL pointer during system initialization and
 shutdown
References: <51C0AB09.2090605@redhat.com> <alpine.DEB.2.02.1306241551020.4013@ionos.tec.linutronix.de> <51CA2CBF.70404@redhat.com> <alpine.DEB.2.02.1306261303260.4013@ionos.tec.linutronix.de> <51CC708B.7040605@redhat.com> <alpine.DEB.2.02.1306281250270.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306281250270.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/28/2013 06:52 AM, Thomas Gleixner wrote:
> On Thu, 27 Jun 2013, Prarit Bhargava wrote:
>> On 06/26/2013 07:05 AM, Thomas Gleixner wrote:
>>> Subject: tick: Make oneshot broadcast robust vs. CPU offlining
>>> From: Thomas Gleixner <tglx@linutronix.de>
>>> Date: Wed, 26 Jun 2013 12:17:32 +0200
>>>
>>> In periodic mode we remove offline cpus from the broadcast propagation
>>> mask. In oneshot mode we fail to do so. This was not a problem so far,
>>> but the recent changes to the broadcast propagation introduced a
>>> constellation which can result in a NULL pointer dereference.
>>>
>>
>> Unfortunately this patch causes an NMI watchdog during system shutdown.  Most of
>> the CPUs are in start_secondary+0x254/0x256.
> 
> Huch. Did the warning in the broadcast code trigger before that?

tglx,

AFAICT it does not.  Log below on the system I'm testing on.  The test on the
system is system boots, sleeps for 30 seconds and then reboots.

P.

[-- MARK -- Thu Jun 27 15:20:00 2013]
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.0-rc4+ (root@intel-s3e37-05) (gcc version
4.8.1 20130612 (Red Hat 4.8.1-2) (GCC) ) #2 SMP Thu Jun 27 09:58:29 EDT 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.10.0-rc4+
root=/dev/mapper/rhel_intel--s3e37--05-root ro rd.md=0 rd.dm=0
console=ttyS0,115200n81 vconsole.keymap=us crashkernel=auto rd.luks=0
vconsole.font=latarcyrheb-sun16 rd.lvm.lv=rhel_intel-s3e37-05/swap
rd.lvm.lv=rhel_intel-s3e37-05/root LANG=en_US.UTF-8 reboot
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x00000000000997ff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000099800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007b43efff] usable
[    0.000000] BIOS-e820: [mem 0x000000007b43f000-0x000000007b441fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007b442000-0x000000007b67dfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007b67e000-0x000000007b691fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007b692000-0x000000007b7bdfff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007b7be000-0x000000007ba3dfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007ba3e000-0x000000007baa7fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007baa8000-0x000000007bcfffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bd00000-0x000000007bd16fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007bd17000-0x000000007bd19fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bd1a000-0x000000007bd49fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007bd4a000-0x000000007bd5efff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bd5f000-0x000000007bdfefff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007bdff000-0x000000007bdfffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007be00000-0x000000007be4efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007be4f000-0x000000007bf70fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bf71000-0x000000007bfcefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007bfcf000-0x000000007bffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007bfff000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000fcffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000107fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x1080000 max_arch_pfn = 0x400000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x7b43f max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd9e0-0x000fd9ef] mapped at
[ffff8800000fd9e0]
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x107fe00000-0x107fffffff]
[    0.000000] init_memory_mapping: [mem 0x107c000000-0x107fdfffff]
[    0.000000] init_memory_mapping: [mem 0x1000000000-0x107bffffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7b43efff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0xfffffffff]
[    0.000000] RAMDISK: [mem 0x3614c000-0x3709dfff]
[    0.000000] Reserving 132MB of memory at 720MB for crashkernel (System RAM:
65459MB)
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02 QUANTA)
[    0.000000] ACPI: XSDT 000000007bffe120 000B4 (v01 QUANTA QSSC-S4R 00000000
    01000013)
[    0.000000] ACPI: FACP 000000007bffd000 000F4 (v04 QUANTA QSSC-S4R 00000000
MSFT 0100000D)
[    0.000000] ACPI: DSDT 000000007bfe1000 1B7B5 (v02 QUANTA QSSC-S4R 00000003
MSFT 0100000D)
[    0.000000] ACPI: FACS 000000007bf71000 00040
[    0.000000] ACPI: APIC 000000007bfe0000 004C4 (v02 QUANTA QSSC-S4R 00000000
MSFT 0100000D)
[    0.000000] ACPI: MSCT 000000007bfdf000 00090 (v01 QUANTA QSSC-S4R 00000001
MSFT 0100000D)
[    0.000000] ACPI: MCFG 000000007bfde000 0003C (v01 QUANTA QSSC-S4R 00000001
MSFT 0100000D)
[    0.000000] ACPI: HPET 000000007bfdd000 00038 (v01 QUANTA QSSC-S4R 00000001
MSFT 0100000D)
[    0.000000] ACPI: SLIT 000000007bfdc000 0003C (v01 QUANTA QSSC-S4R 00000001
MSFT 0100000D)
[    0.000000] ACPI: SRAT 000000007bfdb000 00A30 (v02 QUANTA QSSC-S4R 00000001
MSFT 0100000D)
[    0.000000] ACPI: SPCR 000000007bfda000 00050 (v01 QUANTA QSSC-S4R 00000000
MSFT 0100000D)
[    0.000000] ACPI: WDDT 000000007bfd9000 00040 (v01 QUANTA QSSC-S4R 00000000
MSFT 0100000D)
[    0.000000] ACPI: SSDT 000000007bf24000 4C744 (v02 QUANTA QSSC-S4R 00004000
INTL 20061109)
[    0.000000] ACPI: SSDT 000000007bfd8000 00174 (v02 QUANTA QSSC-S4R 00004000
INTL 20061109)
[    0.000000] ACPI: PMCT 000000007bfd7000 00060 (v01 QUANTA QSSC-S4R 00000000
MSFT 0100000D)
[    0.000000] ACPI: MIGT 000000007bfd6000 00040 (v01 QUANTA QSSC-S4R 00000000
MSFT 0100000D)
[    0.000000] ACPI: TCPA 000000007bfd3000 00032 (v00 QUANTA QSSC-S4R 00000000
    00000000)
[    0.000000] ACPI: HEST 000000007bfd2000 000A8 (v01 QUANTA QSSC-S4R 00000001
INTL 00000001)
[    0.000000] ACPI: BERT 000000007bfd1000 00030 (v01 QUANTA QSSC-S4R 00000001
INTL 00000001)
[    0.000000] ACPI: ERST 000000007bfd0000 00230 (v01 QUANTA QSSC-S4R 00000001
INTL 00000001)
[    0.000000] ACPI: EINJ 000000007bfcf000 00130 (v01 QUANTA QSSC-S4R 00000001
INTL 00000001)
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x06 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x07 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x16 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x17 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x26 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x27 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x36 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x37 -> Node 1
[    0.000000] SRAT: PXM 2 -> APIC 0x40 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x41 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x42 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x43 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x44 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x45 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x46 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x47 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x50 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x51 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x52 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x53 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x54 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x55 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x56 -> Node 2
[    0.000000] SRAT: PXM 2 -> APIC 0x57 -> Node 2
[    0.000000] SRAT: PXM 3 -> APIC 0x60 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x61 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x62 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x63 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x64 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x65 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x66 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x67 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x70 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x71 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x72 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x73 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x74 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x75 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x76 -> Node 3
[    0.000000] SRAT: PXM 3 -> APIC 0x77 -> Node 3
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x47fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x480000000-0x87fffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x880000000-0xc7fffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0xc80000000-0x107fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x1100000000-0x30ffffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x3100000000-0x50ffffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x5100000000-0x70ffffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x7100000000-0x90ffffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0x9100000000-0xb0ffffffff]
[    0.000000] SRAT: Node 2 PXM 2 [mem 0xb100000000-0xd0ffffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0xd100000000-0xf0ffffffff]
[    0.000000] SRAT: Node 3 PXM 3 [mem 0xf100000000-0x110ffffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem
0x100000000-0x47fffffff] -> [mem 0x00000000-0x47fffffff]
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x47fffffff] + [mem
0x480000000-0x87fffffff] -> [mem 0x00000000-0x87fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x87fffffff]
[    0.000000]   NODE_DATA [mem 0x87ffd9000-0x87fffffff]
[    0.000000] Initmem setup node 2 [mem 0x880000000-0xc7fffffff]
[    0.000000]   NODE_DATA [mem 0xc7ffd9000-0xc7fffffff]
[    0.000000] Initmem setup node 3 [mem 0xc80000000-0x107fffffff]
[    0.000000]   NODE_DATA [mem 0x107ff9a000-0x107ffc0fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x107fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00098fff]
[    0.000000]   node   0: [mem 0x00100000-0x7b43efff]
[    0.000000]   node   0: [mem 0x100000000-0x87fffffff]
[    0.000000]   node   2: [mem 0x880000000-0xc7fffffff]
[    0.000000]   node   3: [mem 0xc80000000-0x107fffffff]
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x20] lapic_id[0x40] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x30] lapic_id[0x60] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x28] lapic_id[0x50] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x30] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x38] lapic_id[0x70] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x24] lapic_id[0x44] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x24] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x34] lapic_id[0x64] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2c] lapic_id[0x54] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1c] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3c] lapic_id[0x74] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x22] lapic_id[0x42] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x32] lapic_id[0x62] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2a] lapic_id[0x52] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1a] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3a] lapic_id[0x72] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x26] lapic_id[0x46] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x26] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x36] lapic_id[0x66] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x16] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2e] lapic_id[0x56] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1e] lapic_id[0x36] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3e] lapic_id[0x76] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x21] lapic_id[0x41] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x31] lapic_id[0x61] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x29] lapic_id[0x51] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x19] lapic_id[0x31] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x39] lapic_id[0x71] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x25] lapic_id[0x45] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x35] lapic_id[0x65] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2d] lapic_id[0x55] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1d] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3d] lapic_id[0x75] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x23] lapic_id[0x43] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x33] lapic_id[0x63] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2b] lapic_id[0x53] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1b] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3b] lapic_id[0x73] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x27] lapic_id[0x47] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x27] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x37] lapic_id[0x67] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x2f] lapic_id[0x57] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x1f] lapic_id[0x37] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x3f] lapic_id[0x77] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x40] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x41] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x42] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x43] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x44] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x45] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x46] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x47] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x48] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x49] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4a] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4b] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4c] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4d] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4e] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x4f] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x10] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x11] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x12] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x13] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x14] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x15] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x16] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x17] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x18] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x19] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x1f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x20] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x21] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x22] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x23] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x24] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x25] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x26] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x27] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x28] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x29] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x2f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x30] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x31] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x32] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x33] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x34] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x35] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x36] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x37] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x38] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x39] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x3f] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x40] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x41] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x42] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x43] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x44] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x45] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x46] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x47] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x48] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x49] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x4f] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec04000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec04000, GSI 48-71
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a401 base: 0xfed00000
[    0.000000] smpboot: Allowing 80 CPUs, 16 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 0000000000099000 - 000000000009a000
[    0.000000] PM: Registered nosave memory: 000000000009a000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000007b43f000 - 000000007b442000
[    0.000000] PM: Registered nosave memory: 000000007b442000 - 000000007b67e000
[    0.000000] PM: Registered nosave memory: 000000007b67e000 - 000000007b692000
[    0.000000] PM: Registered nosave memory: 000000007b692000 - 000000007b7be000
[    0.000000] PM: Registered nosave memory: 000000007b7be000 - 000000007ba3e000
[    0.000000] PM: Registered nosave memory: 000000007ba3e000 - 000000007baa8000
[    0.000000] PM: Registered nosave memory: 000000007baa8000 - 000000007bd00000
[    0.000000] PM: Registered nosave memory: 000000007bd00000 - 000000007bd17000
[    0.000000] PM: Registered nosave memory: 000000007bd17000 - 000000007bd1a000
[    0.000000] PM: Registered nosave memory: 000000007bd1a000 - 000000007bd4a000
[    0.000000] PM: Registered nosave memory: 000000007bd4a000 - 000000007bd5f000
[    0.000000] PM: Registered nosave memory: 000000007bd5f000 - 000000007bdff000
[    0.000000] PM: Registered nosave memory: 000000007bdff000 - 000000007be00000
[    0.000000] PM: Registered nosave memory: 000000007be00000 - 000000007be4f000
[    0.000000] PM: Registered nosave memory: 000000007be4f000 - 000000007bf71000
[    0.000000] PM: Registered nosave memory: 000000007bf71000 - 000000007bfcf000
[    0.000000] PM: Registered nosave memory: 000000007bfcf000 - 000000007bfff000
[    0.000000] PM: Registered nosave memory: 000000007bfff000 - 0000000090000000
[    0.000000] PM: Registered nosave memory: 0000000090000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fd000000
[    0.000000] PM: Registered nosave memory: 00000000fd000000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] e820: [mem 0x90000000-0xfbffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:5120 nr_cpumask_bits:80 nr_cpu_ids:80
nr_node_ids:4
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88085f400000 s86720 r8192
d23872 u262144
[    0.000000] Built 3 zonelists in Zone order, mobility grouping on.  Total
pages: 16495857
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.10.0-rc4+
root=/dev/mapper/rhel_intel--s3e37--05-root ro rd.md=0 rd.dm=0
console=ttyS0,115200n81 vconsole.keymap=us crashkernel=auto rd.luks=0
vconsole.font=latarcyrheb-sun16 rd.lvm.lv=rhel_intel-s3e37-05/swap
rd.lvm.lv=rhel_intel-s3e37-05/root LANG=en_US.UTF-8 reboot
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 65740512k/69206016k available (6209k kernel code,
2175140k absent, 1290364k reserved, 4088k data, 1556k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=80, Nodes=4
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=5120 to nr_cpu_ids=80.
[    0.000000] NR_IRQS:327936 nr_irqs:2136 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 268435456 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want
memory cgroups
[    0.000000] Enabling automatic NUMA balancing. Configure with numa_balancing=
or sysctl
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.001000] tsc: Detected 1995.147 MHz processor
[    0.000038] Calibrating delay loop (skipped), value calculated using timer
frequency.. 3990.29 BogoMIPS (lpj=1995147)
[    0.012145] pid_max: default: 81920 minimum: 640
[    0.017656] Security Framework initialized
[    0.022402] SELinux:  Initializing.
[    0.033783] Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
[    0.066978] Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
[    0.085604] Mount-cache hash table entries: 256
[    0.091543] Initializing cgroup subsys memory
[    0.096551] Initializing cgroup subsys devices
[    0.101748] Initializing cgroup subsys freezer
[    0.106950] Initializing cgroup subsys net_cls
[    0.112038] Initializing cgroup subsys blkio
[    0.116949] Initializing cgroup subsys perf_event
[    0.122427] CPU: Physical Processor ID: 0
[    0.127030] CPU: Processor Core ID: 0
[    0.131275] mce: CPU supports 22 MCE banks
[    0.136018] CPU0: Thermal monitoring enabled (TM1)
[    0.141560] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.141560] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.141560] tlb_flushall_shift: 6
[    0.158125] Freeing SMP alternatives: 24k freed
[    0.164898] ACPI: Core revision 20130328
[    0.232535] ACPI: All ACPI Tables successfully acquired
[    0.242387] ftrace: allocating 23780 entries in 93 pages
[    0.265737] Switched APIC routing to physical flat.
[    0.272058] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.288754] smpboot: CPU0: Intel(R) Xeon(R) CPU           X7550  @ 2.00GHz
(fam: 06, model: 2e, stepping: 06)
[    0.400872] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events,
Intel PMU driver.
[    0.410144] perf_event_intel: CPU erratum AAJ80 worked around
[    0.416554] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.424222] ... version:                3
[    0.428694] ... bit width:              48
[    0.433261] ... generic registers:      4
[    0.437730] ... value mask:             0000ffffffffffff
[    0.443653] ... max period:             000000007fffffff
[    0.449575] ... fixed-purpose events:   3
[    0.454044] ... event mask:             000000070000000f
[    0.462863] smpboot: Booting Node   2, Processors  #1[    0.562158] NMI
watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
 OK
[    0.571736] smpboot: Booting Node   0, Processors  #2 OK
[    0.669380] smpboot: Booting Node   3, Processors  #3 OK
[    0.767307] smpboot: Booting Node   0, Processors  #4 OK
[    0.787642] smpboot: Booting Node   2, Processors  #5 OK
[    0.807955] smpboot: Booting Node   0, Processors  #6 OK
[    0.828272] smpboot: Booting Node   3, Processors  #7 OK
[    0.848586] smpboot: Booting Node   0, Processors  #8 OK
[    0.869022] smpboot: Booting Node   2, Processors  #9 OK
[    0.889348] smpboot: Booting Node   0, Processors  #10 OK
[    0.909763] smpboot: Booting Node   3, Processors  #11 OK
[    0.930178] smpboot: Booting Node   0, Processors  #12 OK
[    0.950692] smpboot: Booting Node   2, Processors  #13 OK
[    0.971086] smpboot: Booting Node   0, Processors  #14 OK
[    0.991516] smpboot: Booting Node   3, Processors  #15 OK
[    1.011832] smpboot: Booting Node   0, Processors  #16 OK
[    1.032246] smpboot: Booting Node   2, Processors  #17 OK
[    1.052674] smpboot: Booting Node   0, Processors  #18 OK
[    1.072992] smpboot: Booting Node   3, Processors  #19 OK
[    1.093287] smpboot: Booting Node   0, Processors  #20 OK
[    1.113712] smpboot: Booting Node   2, Processors  #21 OK
[    1.134008] smpboot: Booting Node   0, Processors  #22 OK
[    1.154420] smpboot: Booting Node   3, Processors  #23 OK
[    1.174742] smpboot: Booting Node   0, Processors  #24 OK
[    1.195172] smpboot: Booting Node   2, Processors  #25 OK
[    1.215588] smpboot: Booting Node   0, Processors  #26 OK
[    1.236035] smpboot: Booting Node   3, Processors  #27 OK
[    1.256443] smpboot: Booting Node   0, Processors  #28 OK
[    1.276873] smpboot: Booting Node   2, Processors  #29 OK
[    1.297193] smpboot: Booting Node   0, Processors  #30 OK
[    1.317519] smpboot: Booting Node   3, Processors  #31 OK
[    1.337835] smpboot: Booting Node   0, Processors  #32 OK
[    1.358530] smpboot: Booting Node   2, Processors  #33 OK
[    1.378858] smpboot: Booting Node   0, Processors  #34 OK
[    1.399192] smpboot: Booting Node   3, Processors  #35 OK
[    1.419508] smpboot: Booting Node   0, Processors  #36 OK
[    1.439925] smpboot: Booting Node   2, Processors  #37 OK
[    1.460241] smpboot: Booting Node   0, Processors  #38 OK
[    1.480581] smpboot: Booting Node   3, Processors  #39 OK
[    1.500996] smpboot: Booting Node   0, Processors  #40 OK
[    1.521421] smpboot: Booting Node   2, Processors  #41 OK
[    1.541754] smpboot: Booting Node   0, Processors  #42 OK
[    1.562179] smpboot: Booting Node   3, Processors  #43 OK
[    1.582502] smpboot: Booting Node   0, Processors  #44 OK
[    1.602934] smpboot: Booting Node   2, Processors  #45 OK
[    1.623249] smpboot: Booting Node   0, Processors  #46 OK
[    1.643659] smpboot: Booting Node   3, Processors  #47 OK
[    1.664091] smpboot: Booting Node   0, Processors  #48 OK
[    1.684529] smpboot: Booting Node   2, Processors  #49 OK
[    1.704842] smpboot: Booting Node   0, Processors  #50 OK
[    1.725270] smpboot: Booting Node   3, Processors  #51 OK
[    1.745664] smpboot: Booting Node   0, Processors  #52 OK
[    1.766103] smpboot: Booting Node   2, Processors  #53 OK
[    1.786417] smpboot: Booting Node   0, Processors  #54 OK
[    1.806846] smpboot: Booting Node   3, Processors  #55 OK
[    1.827267] smpboot: Booting Node   0, Processors  #56 OK
[    1.847703] smpboot: Booting Node   2, Processors  #57 OK
[    1.868118] smpboot: Booting Node   0, Processors  #58 OK
[    1.888534] smpboot: Booting Node   3, Processors  #59 OK
[    1.908946] smpboot: Booting Node   0, Processors  #60 OK
[    1.929393] smpboot: Booting Node   2, Processors  #61 OK
[    1.949802] smpboot: Booting Node   0, Processors  #62 OK
[    1.970223] smpboot: Booting Node   3, Processors  #63
[    1.990019] Brought up 64 CPUs
[    1.993633] smpboot: Total of 64 processors activated (255335.00 BogoMIPS)
[    2.326851] devtmpfs: initialized
[    2.337589] PM: Registering ACPI NVS region [mem 0x7b442000-0x7b67dfff]
(2342912 bytes)
[    2.346598] PM: Registering ACPI NVS region [mem 0x7b7be000-0x7ba3dfff]
(2621440 bytes)
[    2.355607] PM: Registering ACPI NVS region [mem 0x7bf71000-0x7bfcefff]
(385024 bytes)
[    2.365980] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    2.373799] NET: Registered protocol family 16
[    2.379041] ACPI FADT declares the system doesn't support PCIe ASPM, so
disable it
[    2.387488] ACPI: bus type PCI registered
[    2.391961] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    2.399291] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0x80000000-0x8fffffff] (base 0x80000000)
[    2.409677] PCI: MMCONFIG at [mem 0x80000000-0x8fffffff] reserved in E820
[    2.448123] PCI: Using configuration type 1 for base access
[    2.457977] bio: create slab <bio-0> at 0
[    2.463433] ACPI: Added _OSI(Module Device)
[    2.468104] ACPI: Added _OSI(Processor Device)
[    2.473059] ACPI: Added _OSI(3.0 _SCP Extensions)
[    2.478307] ACPI: Added _OSI(Processor Aggregator Device)
[    2.574813] ACPI: Interpreter enabled
[    2.578908] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State
[\_S2_] (20130328/hwxface-568)
[    2.589218] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State
[\_S3_] (20130328/hwxface-568)
[    2.599525] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State
[\_S4_] (20130328/hwxface-568)
[    2.609834] ACPI: (supports S0 S1 S5)
[    2.613918] ACPI: Using IOAPIC for interrupt routing
[    2.619510] HEST: Table parsing has been initialized.
[    2.625150] PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
[    2.660555] ACPI: PCI Root Bridge [IOH0] (domain 0000 [bus 00-7f])
[    2.667965] acpi PNP0A08:00: ignoring host bridge window [mem
0x000c4000-0x000cbfff] (conflicts with Video ROM [mem 0x000c0000-0x000c7fff])
[    2.682125] PCI host bridge to bus 0000:00
[    2.686698] pci_bus 0000:00: root bus resource [bus 00-7f]
[    2.692820] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    2.699715] pci_bus 0000:00: root bus resource [io  0x1000-0x9fff]
[    2.706610] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    2.714281] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfedfffff]
[    2.721945] pci_bus 0000:00: root bus resource [mem 0x90000000-0xcfffffff]
[    2.729615] pci_bus 0000:00: root bus resource [mem 0xfc000000000-0xfc07fffffff]
[    2.738084] pci 0000:00:01.0: System wakeup disabled by ACPI
[    2.744526] pci 0000:00:02.0: System wakeup disabled by ACPI
[    2.751088] pci 0000:00:05.0: System wakeup disabled by ACPI
[    2.757532] pci 0000:00:07.0: System wakeup disabled by ACPI
[    2.763986] pci 0000:00:09.0: System wakeup disabled by ACPI
[    2.770436] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    2.779565] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    2.786058] pci 0000:00:1a.1: System wakeup disabled by ACPI
[    2.792553] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    2.799087] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    2.805569] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    2.812054] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    2.818562] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    2.825068] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    2.831585] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    2.838137] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    2.844601] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    2.851038] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6
ACPI/GPIO/TCO
[    2.859875] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    2.867838] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask
000f)
[    2.876287] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask
000f)
[    2.884734] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0600 (mask
001f)
[    2.897049] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[    2.907042] pci 0000:00:02.0: PCI bridge to [bus 04-06]
[    2.916041] pci 0000:00:03.0: PCI bridge to [bus 07]
[    2.921813] acpiphp: Slot [1] registered
[    2.926338] pci 0000:00:05.0: PCI bridge to [bus 08-0a]
[    2.932396] acpiphp: Slot [2] registered
[    2.936916] pci 0000:00:07.0: PCI bridge to [bus 0b-0d]
[    2.942947] pci 0000:00:09.0: PCI bridge to [bus 0e]
[    2.948698] pci 0000:00:0a.0: PCI bridge to [bus 0f]
[    2.954350] pci 0000:00:1c.0: PCI bridge to [bus 10]
[    2.962014] pci 0000:00:1c.4: PCI bridge to [bus 11]
[    2.967643] pci 0000:00:1e.0: PCI bridge to [bus 12] (subtractive decode)
[    2.975353] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    2.982260] acpi PNP0A08:00: ACPI _OSC control (0x14) granted
[    2.989190] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    2.997453] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    3.005711] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    3.013970] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    3.022228] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15)
*0, disabled.
[    3.031768] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    3.040027] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15)
*0, disabled.
[    3.049568] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    3.058050] ACPI: PCI Root Bridge [IOH1] (domain 0000 [bus 80-f7])
[    3.065128] PCI host bridge to bus 0000:80
[    3.069691] pci_bus 0000:80: root bus resource [bus 80-f7]
[    3.075802] pci_bus 0000:80: root bus resource [io  0xa000-0xffff]
[    3.082697] pci_bus 0000:80: root bus resource [mem 0xd0000000-0xfbffffff]
[    3.090367] pci_bus 0000:80: root bus resource [mem 0xfc080000000-0xfc0ffffffff]
[    3.098837] pci 0000:80:01.0: System wakeup disabled by ACPI
[    3.105282] pci 0000:80:03.0: System wakeup disabled by ACPI
[    3.111732] pci 0000:80:07.0: System wakeup disabled by ACPI
[    3.118186] pci 0000:80:09.0: System wakeup disabled by ACPI
[    3.126742] pci 0000:80:00.0: PCI bridge to [bus 81]
[    3.132484] pci 0000:80:01.0: PCI bridge to [bus 82]
[    3.138228] pci 0000:80:03.0: PCI bridge to [bus 83]
[    3.143982] acpiphp: Slot [6] registered
[    3.148507] pci 0000:80:07.0: PCI bridge to [bus 84-86]
[    3.154589] acpiphp: Slot [7] registered
[    3.159115] pci 0000:80:09.0: PCI bridge to [bus 87-89]
[    3.165050] acpi PNP0A08:01: Requesting ACPI _OSC control (0x1d)
[    3.171960] acpi PNP0A08:01: ACPI _OSC control (0x14) granted
[    3.178842] ACPI: PCI Root Bridge [PRB3] (domain 0000 [bus fc])
[    3.185487] PCI host bridge to bus 0000:fc
[    3.190059] pci_bus 0000:fc: root bus resource [bus fc]
[    3.198179] acpi PNP0A03:00: ACPI _OSC support notification failed, disabling
PCIe ASPM
[    3.207109] acpi PNP0A03:00: Unable to request _OSC control (_OSC support
mask: 0x08)
[    3.215904] ACPI: PCI Root Bridge [PRB2] (domain 0000 [bus fd])
[    3.222547] PCI host bridge to bus 0000:fd
[    3.227120] pci_bus 0000:fd: root bus resource [bus fd]
[    3.235265] acpi PNP0A03:01: ACPI _OSC support notification failed, disabling
PCIe ASPM
[    3.244196] acpi PNP0A03:01: Unable to request _OSC control (_OSC support
mask: 0x08)
[    3.252981] ACPI: PCI Root Bridge [PRB1] (domain 0000 [bus fe])
[    3.259626] PCI host bridge to bus 0000:fe
[    3.264198] pci_bus 0000:fe: root bus resource [bus fe]
[    3.272326] acpi PNP0A03:02: ACPI _OSC support notification failed, disabling
PCIe ASPM
[    3.281257] acpi PNP0A03:02: Unable to request _OSC control (_OSC support
mask: 0x08)
[    3.290043] ACPI: PCI Root Bridge [PRB0] (domain 0000 [bus ff])
[    3.296678] PCI host bridge to bus 0000:ff
[    3.301249] pci_bus 0000:ff: root bus resource [bus ff]
[    3.309268] acpi PNP0A03:03: ACPI _OSC support notification failed, disabling
PCIe ASPM
[    3.318198] acpi PNP0A03:03: Unable to request _OSC control (_OSC support
mask: 0x08)
[    3.341616] System RAM resource [mem 0x01000000-0x7bffffff] cannot be added
[    3.349377] System RAM resource [mem 0x100000000-0x47fffffff] cannot be added
[    3.371955] System RAM resource [mem 0x480000000-0x87fffffff] cannot be added
[    3.396841] System RAM resource [mem 0x880000000-0xc7fffffff] cannot be added
[    3.420551] System RAM resource [mem 0xc80000000-0x107fffffff] cannot be added
[    3.429935] ACPI: Enabled 34 GPEs in block 00 to 3F
[    3.441833] ACPI: No dock devices found.
[    3.446525] vgaarb: device added:
PCI:0000:11:00.0,decodes=io+mem,owns=io+mem,locks=none
[    3.455589] vgaarb: loaded
[    3.458607] vgaarb: bridge control possible 0000:11:00.0
[    3.464636] SCSI subsystem initialized
[    3.468841] ACPI: bus type USB registered
[    3.473328] usbcore: registered new interface driver usbfs
[    3.479461] usbcore: registered new interface driver hub
[    3.485438] usbcore: registered new device driver usb
[    3.491445] PCI: Using ACPI for IRQ routing
[    3.501335] NetLabel: Initializing
[    3.505122] NetLabel:  domain hash size = 128
[    3.509981] NetLabel:  protocols = UNLABELED CIPSOv4
[    3.515530] NetLabel:  unlabeled traffic allowed by default
[    3.521799] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    3.529665] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    3.535447] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    3.550214] Switching to clocksource hpet
[    3.564909] pnp: PnP ACPI init
[    3.568338] ACPI: bus type PNP registered
[    3.573680] system 00:06: [io  0x0500-0x057f] could not be reserved
[    3.580678] system 00:06: [io  0x0400-0x047f] has been reserved
[    3.587285] system 00:06: [io  0x0540-0x057f] has been reserved
[    3.593890] system 00:06: [io  0x0600-0x061f] has been reserved
[    3.600486] system 00:06: [io  0x0880-0x0883] has been reserved
[    3.607083] system 00:06: [io  0x0ca4-0x0ca5] has been reserved
[    3.613689] system 00:06: [io  0x0800-0x081f] has been reserved
[    3.620299] system 00:06: [mem 0xfed1c000-0xfed3ffff] could not be reserved
[    3.628069] system 00:06: [mem 0xfed45000-0xfed8bfff] has been reserved
[    3.635450] system 00:06: [mem 0xff000000-0xffffffff] has been reserved
[    3.642831] system 00:06: [mem 0xfee00000-0xfeefffff] has been reserved
[    3.650213] system 00:06: [mem 0xfed12000-0xfed1200f] has been reserved
[    3.657594] system 00:06: [mem 0xfed12010-0xfed1201f] has been reserved
[    3.664975] system 00:06: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    3.732287] pnp: PnP ACPI: found 15 devices
[    3.736958] ACPI: bus type PNP unregistered
[    3.749427] pci 0000:07:00.0: no compatible bridge window for [mem
0xfffe0000-0xffffffff pref]
[    3.759042] pci 0000:11:00.0: no compatible bridge window for [mem
0xffff0000-0xffffffff pref]
[    3.768819] pci 0000:00:03.0: BAR 15: assigned [mem 0x95d00000-0x95dfffff pref]
[    3.776978] pci 0000:00:1c.0: BAR 14: assigned [mem 0x95e00000-0x95ffffff]
[    3.784652] pci 0000:00:1c.0: BAR 15: assigned [mem 0x96000000-0x961fffff
64bit pref]
[    3.793391] pci 0000:00:1c.0: BAR 13: assigned [io  0x7000-0x7fff]
[    3.800289] pci 0000:00:1c.4: BAR 13: assigned [io  0x8000-0x8fff]
[    3.807189] pci 0000:00:01.0: PCI bridge to [bus 01-03]
[    3.813024] pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
[    3.819827] pci 0000:00:01.0:   bridge window [mem 0x95b00000-0x95bfffff]
[    3.827408] pci 0000:00:02.0: PCI bridge to [bus 04-06]
[    3.833238] pci 0000:00:02.0:   bridge window [io  0x4000-0x4fff]
[    3.840030] pci 0000:00:02.0:   bridge window [mem 0x95a00000-0x95afffff]
[    3.847610] pci 0000:07:00.0: BAR 6: assigned [mem 0x95d00000-0x95d1ffff pref]
[    3.855670] pci 0000:00:03.0: PCI bridge to [bus 07]
[    3.861212] pci 0000:00:03.0:   bridge window [io  0x3000-0x3fff]
[    3.868012] pci 0000:00:03.0:   bridge window [mem 0x95900000-0x959fffff]
[    3.875588] pci 0000:00:03.0:   bridge window [mem 0x95d00000-0x95dfffff pref]
[    3.883650] pci 0000:00:05.0: PCI bridge to [bus 08-0a]
[    3.889480] pci 0000:00:05.0:   bridge window [io  0x2000-0x2fff]
[    3.896281] pci 0000:00:05.0:   bridge window [mem 0x94900000-0x958fffff]
[    3.903857] pci 0000:00:05.0:   bridge window [mem 0x91900000-0x928fffff
64bit pref]
[    3.912501] pci 0000:00:07.0: PCI bridge to [bus 0b-0d]
[    3.918333] pci 0000:00:07.0:   bridge window [io  0x1000-0x1fff]
[    3.925133] pci 0000:00:07.0:   bridge window [mem 0x93900000-0x948fffff]
[    3.932710] pci 0000:00:07.0:   bridge window [mem 0x92900000-0x938fffff
64bit pref]
[    3.941357] pci 0000:00:09.0: PCI bridge to [bus 0e]
[    3.946902] pci 0000:00:0a.0: PCI bridge to [bus 0f]
[    3.952450] pci 0000:00:1c.0: PCI bridge to [bus 10]
[    3.957991] pci 0000:00:1c.0:   bridge window [io  0x7000-0x7fff]
[    3.964793] pci 0000:00:1c.0:   bridge window [mem 0x95e00000-0x95ffffff]
[    3.972370] pci 0000:00:1c.0:   bridge window [mem 0x96000000-0x961fffff
64bit pref]
[    3.981016] pci 0000:11:00.0: BAR 6: assigned [mem 0x91810000-0x9181ffff pref]
[    3.989075] pci 0000:00:1c.4: PCI bridge to [bus 11]
[    3.994610] pci 0000:00:1c.4:   bridge window [io  0x8000-0x8fff]
[    4.001412] pci 0000:00:1c.4:   bridge window [mem 0x91000000-0x918fffff]
[    4.008987] pci 0000:00:1c.4:   bridge window [mem 0x90000000-0x90ffffff
64bit pref]
[    4.017632] pci 0000:00:1e.0: PCI bridge to [bus 12]
[    4.023188] pci 0000:80:00.0: PCI bridge to [bus 81]
[    4.028727] pci 0000:80:01.0: PCI bridge to [bus 82]
[    4.034274] pci 0000:80:03.0: PCI bridge to [bus 83]
[    4.039822] pci 0000:80:07.0: PCI bridge to [bus 84-86]
[    4.045654] pci 0000:80:07.0:   bridge window [io  0xb000-0xbfff]
[    4.052455] pci 0000:80:07.0:   bridge window [mem 0xd3000000-0xd3ffffff]
[    4.060032] pci 0000:80:07.0:   bridge window [mem 0xd0000000-0xd0ffffff
64bit pref]
[    4.068678] pci 0000:80:09.0: PCI bridge to [bus 87-89]
[    4.074510] pci 0000:80:09.0:   bridge window [io  0xa000-0xafff]
[    4.081310] pci 0000:80:09.0:   bridge window [mem 0xd2000000-0xd2ffffff]
[    4.088886] pci 0000:80:09.0:   bridge window [mem 0xd1000000-0xd1ffffff
64bit pref]
[    4.104792] NET: Registered protocol family 2
[    4.110748] TCP established hash table entries: 524288 (order: 11, 8388608
bytes)
[    4.121510] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    4.129289] TCP: Hash tables configured (established 524288 bind 65536)
[    4.136737] TCP: reno registered
[    4.140457] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    4.147852] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[    4.156066] NET: Registered protocol family 1
[    4.163956] Unpacking initramfs...
[    4.522244] Freeing initrd memory: 15688k freed
[    4.534122] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.541321] software IO TLB [mem 0x7743f000-0x7b43f000] (64MB) mapped at
[ffff88007743f000-ffff88007b43efff]
[    4.562393] Initialise module verification
[    4.567059] audit: initializing netlink socket (disabled)
[    4.573103] type=2000 audit(1372346407.880:1): initialized
[    4.609840] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.621649] VFS: Disk quotas dquot_6.5.2
[    4.626148] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.634164] msgmni has been set to 32768
[    4.643066] alg: No test for stdrng (krng)
[    4.647662] NET: Registered protocol family 38
[    4.652627] Key type asymmetric registered
[    4.657199] Asymmetric key parser 'x509' registered
[    4.662738] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    4.671196] io scheduler noop registered
[    4.675579] io scheduler deadline registered (default)
[    4.681358] io scheduler cfq registered
[    4.687400] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    4.695172] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    4.702456] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    4.709760] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
[    4.717529] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    4.724814] pci 0000:04:00.1: Signaling PME through PCIe PME interrupt
[    4.732123] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    4.739892] pci 0000:07:00.0: Signaling PME through PCIe PME interrupt
[    4.747207] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
[    4.755007] pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
[    4.762795] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
[    4.770586] pcieport 0000:00:0a.0: Signaling PME through PCIe PME interrupt
[    4.778374] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    4.786163] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    4.793933] pci 0000:11:00.0: Signaling PME through PCIe PME interrupt
[    4.801235] pcieport 0000:80:00.0: Signaling PME through PCIe PME interrupt
[    4.809023] pcieport 0000:80:01.0: Signaling PME through PCIe PME interrupt
[    4.816810] pcieport 0000:80:03.0: Signaling PME through PCIe PME interrupt
[    4.824597] pcieport 0000:80:07.0: Signaling PME through PCIe PME interrupt
[    4.832398] pcieport 0000:80:09.0: Signaling PME through PCIe PME interrupt
[    4.840183] ioapic: probe of 0000:00:13.0 failed with error -22
[    4.846783] ioapic: probe of 0000:00:15.0 failed with error -22
[    4.853393] ioapic: probe of 0000:80:13.0 failed with error -22
[    4.860001] ioapic: probe of 0000:80:15.0 failed with error -22
[    4.866624] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.872857] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.881347] input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    4.890479] ACPI: Sleep Button [SLPB]
[    4.894616] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.902873] ACPI: Power Button [PWRF]
[    4.907259] ACPI: Requesting acpi_cpufreq
[    4.977707] ERST: Error Record Serialization Table (ERST) support is
initialized.
[    4.987734] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
[    4.996119] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.023764] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    5.050635] 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    5.057551] Non-volatile memory driver v1.3
[    5.062223] Linux agpgart interface v0.103
[    5.067202] tpm_tis 00:09: 1.2 TPM (device-id 0x0, rev-id 78)
[    5.109026] tpm_tis 00:09: TPM is disabled/deactivated (0x6)
[    5.115395] crash memory driver: version 1.1
[    5.120529] rdac: device handler registered
[    5.125287] hp_sw: device handler registered
[    5.130056] emc: device handler registered
[    5.134626] alua: device handler registered
[    5.139322] libphy: Fixed MDIO Bus: probed
[    5.143950] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.151239] ehci-pci: EHCI PCI platform driver
[    5.156499] ehci-pci 0000:00:1a.7: EHCI Host Controller
[    5.162397] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    5.170668] ehci-pci 0000:00:1a.7: debug port 1
[    5.179667] ehci-pci 0000:00:1a.7: irq 18, io mem 0x95c02000
[    5.191958] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    5.198397] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.205974] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.214035] usb usb1: Product: EHCI Host Controller
[    5.219478] usb usb1: Manufacturer: Linux 3.10.0-rc4+ ehci_hcd
[    5.225987] usb usb1: SerialNumber: 0000:00:1a.7
[    5.231248] hub 1-0:1.0: USB hub found
[    5.235452] hub 1-0:1.0: 6 ports detected
[    5.240281] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    5.246165] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    5.254435] ehci-pci 0000:00:1d.7: debug port 1
[    5.263403] ehci-pci 0000:00:1d.7: irq 23, io mem 0x95c01000
[    5.274912] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.281336] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.288914] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.296974] usb usb2: Product: EHCI Host Controller
[    5.302416] usb usb2: Manufacturer: Linux 3.10.0-rc4+ ehci_hcd
[    5.308916] usb usb2: SerialNumber: 0000:00:1d.7
[    5.314158] hub 2-0:1.0: USB hub found
[    5.318346] hub 2-0:1.0: 6 ports detected
[    5.322984] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.329918] uhci_hcd: USB Universal Host Controller Interface driver
[    5.337173] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.343078] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    5.351370] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000060e0
[    5.357819] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.365396] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.373458] usb usb3: Product: UHCI Host Controller
[    5.378900] usb usb3: Manufacturer: Linux 3.10.0-rc4+ uhci_hcd
[    5.385399] usb usb3: SerialNumber: 0000:00:1a.0
[    5.390645] hub 3-0:1.0: USB hub found
[    5.394832] hub 3-0:1.0: 2 ports detected
[    5.399561] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.405451] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    5.413754] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000060c0
[    5.420204] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.427782] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.435843] usb usb4: Product: UHCI Host Controller
[    5.441288] usb usb4: Manufacturer: Linux 3.10.0-rc4+ uhci_hcd
[    5.447801] usb usb4: SerialNumber: 0000:00:1a.1
[    5.453155] hub 4-0:1.0: USB hub found
[    5.457351] hub 4-0:1.0: 2 ports detected
[    5.462094] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    5.468012] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    5.476307] uhci_hcd 0000:00:1a.2: irq 19, io base 0x000060a0
[    5.482759] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.490335] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.498394] usb usb5: Product: UHCI Host Controller
[    5.503841] usb usb5: Manufacturer: Linux 3.10.0-rc4+ uhci_hcd
[    5.510353] usb usb5: SerialNumber: 0000:00:1a.2
[    5.515605] hub 5-0:1.0: USB hub found
[    5.519793] hub 5-0:1.0: 2 ports detected
[    5.524519] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.530404] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    5.538685] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00006080
[    5.545131] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    5.552708] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.554802] tsc: Refined TSC clocksource calibration: 1994.998 MHz
[    5.554805] Switching to clocksource tsc
[    5.572063] usb usb6: Product: UHCI Host Controller
[    5.577512] usb usb6: Manufacturer: Linux 3.10.0-rc4+ uhci_hcd
[    5.584027] usb usb6: SerialNumber: 0000:00:1d.0
[    5.589467] hub 6-0:1.0: USB hub found
[    5.593655] hub 6-0:1.0: 2 ports detected
[    5.598402] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.604312] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    5.612594] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00006060
[    5.619046] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    5.626619] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.634677] usb usb7: Product: UHCI Host Controller
[    5.640118] usb usb7: Manufacturer: Linux 3.10.0-rc4+ uhci_hcd
[    5.646633] usb usb7: SerialNumber: 0000:00:1d.1
[    5.651892] hub 7-0:1.0: USB hub found
[    5.656078] hub 7-0:1.0: 2 ports detected
[    5.660809] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.666694] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    5.674971] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006040
[    5.681413] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    5.688987] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.697045] usb usb8: Product: UHCI Host Controller
[    5.702487] usb usb8: Manufacturer: Linux 3.10.0-rc4+ uhci_hcd
[    5.708989] usb usb8: SerialNumber: 0000:00:1d.2
[    5.714254] hub 8-0:1.0: USB hub found
[    5.718441] hub 8-0:1.0: 2 ports detected
[    5.723099] usbcore: registered new interface driver usbserial
[    5.729616] usbcore: registered new interface driver usbserial_generic
[    5.736914] usbserial: USB Serial support registered for generic
[    5.743650] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    5.961531] usb 4-1: new full-speed USB device number 2 using uhci_hcd
[    6.119821] usb 4-1: New USB device found, idVendor=046b, idProduct=ff10
[    6.127310] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    6.135267] usb 4-1: Product: Virtual Keyboard and Mouse
[    6.141194] usb 4-1: Manufacturer: American Megatrends Inc.
[    6.147412] usb 4-1: SerialNumber: serial
[    6.787126] i8042: No controller found
[    6.791400] mousedev: PS/2 mouse device common for all mice
[    6.797860] rtc_cmos 00:02: RTC can wake from S4
[    6.803154] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    6.809985] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram,
hpet irqs
[    6.819708] cpuidle: using governor ladder
[    6.825591] cpuidle: using governor menu
[    6.831994] hidraw: raw HID events driver (C) Jiri Kosina
[    6.842633] input: American Megatrends Inc. Virtual Keyboard and Mouse as
/devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.0/input/input2
[    6.856450] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10
Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on
usb-0000:00:1a.1-1/input0
[    6.876536] input: American Megatrends Inc. Virtual Keyboard and Mouse as
/devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.1/input/input3
[    6.890341] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10
Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on
usb-0000:00:1a.1-1/input1
[    6.906566] usbcore: registered new interface driver usbhid
[    6.912784] usbhid: USB HID core driver
[    6.917346] drop_monitor: Initializing network drop monitor service
[    6.924581] TCP: cubic registered
[    6.928271] Initializing XFRM netlink socket
[    6.933181] NET: Registered protocol family 10
[    6.938592] NET: Registered protocol family 17
[    6.945281] Loading module verification certificates
[    6.952023] MODSIGN: Loaded cert 'Magrathea: Glacier signing key:
36a06d872de54a72e9c6892be8bdac8df503ab80'
[    6.962905] registered taskstats version 1
[    6.976000] tpm_tis 00:09: A TPM error (6) occurred attempting to read a pcr
value
[    6.984447] IMA: No TPM chip found, activating TPM-bypass!
[    6.991315] ACPI Warning: For \_SB_.IOH1.IOHP._DSM: Parameter count mismatch
- ASL declared 3, ACPI requires 4[    6.996731] usb 7-2: new low-speed USB
device number 2 using uhci_hcd
 (20130328/nspredef-307)
[    7.012828] rtc_cmos 00:02: setting system clock to 2013-06-27 15:20:15 UTC
(1372346415)
[    7.028725] Freeing unused kernel memory: 1556k freed
[    7.338086] systemd[1]: systemd 204 running in system mode. (+PAM +LIBWRAP
+AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    7.352220] systemd[1]: Running in initial RAM disk.

Welcome to [0;34mRed Hat Enterprise Linux Workstation 7.0 (Maipo)
dracut-029-1.el7 (Initramfs)[0m!

[    7.371095] systemd[1]: Set hostname to <intel-s3e37-05>.
[    7.387482] systemd[1]: Expecting device
dev-mapper-rhel_intel\x2d\x2ds3e37\x2d\x2d05\x2droot.device...
         Expecting device dev-mapper-rhel_intel\x2d\x2ds3e37\...droot.device...
[    7.407956] systemd[1]: Expecting device
dev-mapper-rhel_intel\x2d\x2ds3e37\x2d\x2d05\x2dswap.device...
         Expecting device dev-mapper-rhel_intel\x2d\x2ds3e37\...dswap.device...
[    7.427877] systemd[1]: Starting Timers.
[[32m  OK  [0m] Reached target Timers.
[    7.436762] systemd[1]: Reached target Timers.
[    7.441905] systemd[1]: Starting udev Kernel Socket.
[[32m  OK  [0m] Listening on udev Kernel Socket.
[    7.453860] systemd[1]: Listening on udev Kernel Socket.
[    7.459902] systemd[1]: Starting udev Control Socket.
[[32m  OK  [0m] Listening on udev Control Socket.
[    7.471804] systemd[1]: Listening on udev Control Socket.
[    7.472064] usb 7-2: New USB device found, idVendor=0624, idProduct=0307
[    7.472065] usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    7.472067] usb 7-2: Product: Avocent DSRIQ-USB
[    7.472068] usb 7-2: Manufacturer: Avocent
[    7.503004] systemd[1]: Starting Journal Socket.
[    7.507197] input: Avocent Avocent DSRIQ-USB as
/devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.0/input/input4
[    7.507375] hid-generic 0003:0624:0307.0003: input,hidraw2: USB HID v1.10
Keyboard [Avocent Avocent DSRIQ-USB] on usb-0000:00:1d.1-2/input0
[[32m  OK  [0m] Listening on Journal Socket.
[    7.537251] input: Avocent Avocent DSRIQ-USB as
/devices/pci0000:00/0000:00:1d.1/usb7/7-2/7-2:1.1/input/input5
[    7.549619] hid-generic 0003:0624:0307.0004: input,hidraw3: USB HID v1.10
Mouse [Avocent Avocent DSRIQ-USB] on usb-0000:00:1d.1-2/input1
[    7.563400] systemd[1]: Listening on Journal Socket.
[    7.569250] systemd[1]: Starting dracut cmdline hook...
         Starting dracut cmdline hook...
[    7.581062] systemd[1]: Starting Sockets.
[[32m  OK  [0m] Reached target Sockets.
[    7.590842] systemd[1]: Reached target Sockets.
[    7.595989] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[[32m  OK  [0m] Started Journal Service.
[    7.613370] systemd[1]: Started Journal Service.
[    7.619332] systemd[1]: Started Load Kernel Modules.
[    7.624891] systemd[1]: Starting Swap.
[[32m  OK  [0m] Reached target Swap.
[    7.633985] systemd[1]: Reached target Swap.
[    7.638883] systemd[1]: Starting Local File Systems.
[[32m  OK  [0m] Reached target Local File Systems.
[    7.651737] systemd[1]: Reached target Local File Systems.
[[32m  OK  [0m] Started dracut cmdline hook.
         Starting Setup Virtual Console...
         Starting dracut pre-udev hook...
[[32m  OK  [0m] Started Setup Virtual Console.
[    7.785613] device-mapper: uevent: version 1.0.3
[    7.790978] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised:
dm-devel@redhat.com
[[32m  OK  [0m] Started dracut pre-udev hook.
         Starting udev Kernel Device Manager...
[    7.871582] systemd-udevd[522]: starting version 204
[[32m  OK  [0m] Started udev Kernel Device Manager.
         Starting udev Coldplug all Devices...
[[32m  OK  [0m] Started udev Coldplug all Devices.
         Starting dracut initqueue hook...
[[32m  OK  [0m] Reached target System Initialization.
         Starting Show Plymouth Boot Screen...
[    7.970999] megasas: 06.506.00.00-rc1 Sat. Feb. 9 17:00:00 PDT 2013
[    7.978099] megasas: 0x1000:0x0060:0x8086:0x1013: bus 7:slot 0:func 0
[    7.984014] megasas: FW now in Ready state
[    8.001064] ACPI: bus type ATA registered
[    8.027705] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x1
impl SATA mode
[    8.034676] megasas_init_mfi: fw_support_ieee=0
[    8.034676] megasas: INIT adapter done
[    8.045976] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part
ccc
[    8.055091] scsi1 : ahci
[    8.058188] scsi2 : ahci
[    8.061305] scsi3 : ahci
[    8.064374] scsi4 : ahci
[    8.068030] scsi5 : ahci
[    8.071124] scsi6 : ahci
[    8.074065] ata1: SATA max UDMA/133 abar m2048@0x95c00000 port 0x95c00100 irq
102
[    8.082460] ata2: DUMMY
[    8.085213] ata3: DUMMY
[    8.087948] ata4: DUMMY
[    8.087981] [drm] Initialized drm 1.1.0 20060810
[    8.095913] ata5: DUMMY
[    8.097893] scsi0 : LSI SAS based MegaRAID driver
[    8.102148] scsi 0:0:8:0: Direct-Access     SEAGATE  ST9146802SS      0003
PQ: 0 ANSI: 5
[    8.104146] scsi 0:0:9:0: Direct-Access     SEAGATE  ST9146802SS      0003
PQ: 0 ANSI: 5
[    8.121986] ata6: DUMMY
[    8.175057] scsi 0:2:0:0: Direct-Access     INTEL    SRCSASBB8I       1.12
PQ: 0 ANSI: 5
[    8.284045] [TTM] Zone  kernel: Available graphics memory: 32878890 kiB
[    8.291466] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    8.298776] [TTM] Initializing pool allocator
[    8.303639] [TTM] Initializing DMA pool allocator
[    8.640031] fbcon: mgadrmfb (fb0) is primary device
[    8.682202] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    8.695328] ata1.00: ATAPI: Optiarc DVD RW AD-7580S, FX04, max UDMA/100
[    8.712150] ata1.00: configured for UDMA/100
[    8.716872] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7580S  FX04
PQ: 0 ANSI: 5
[    8.748059] [drm] mga base 0
[    8.765667] sd 0:2:0:0: [sda] 570310656 512-byte logical blocks: (291 GB/271
GiB)
[    8.766165] sd 0:2:0:0: [sda] Write Protect is off
[    8.766255] sd 0:2:0:0: [sda] Write cache: disabled, read cache: enabled,
supports DPO and FUA
[    8.775457] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda
tray
[    8.775459] cdrom: Uniform CD-ROM driver Revision: 3.20
[    8.778520]  sda: sda1 sda2
[    8.779106] sd 0:2:0:0: [sda] Attached SCSI disk
[    8.906323] Console: switching to colour frame buffer device 128x48
[    9.042584] mgag200 0000:11:00.0: fb0: mgadrmfb frame buffer device
[    9.042585] mgag200 0000:11:00.0: registered panic notifier
[    9.042635] [drm] Initialized mgag200 1.0.0 20110418 for 0000:11:00.0 on minor 0
[[32m  OK  [0m] Started Show Plymouth Boot Screen.
[[32m  OK  [0m] Reached target Paths.
[[32m  OK  [0m] Reached target Basic System.
[    9.253663] bio: create slab <bio-1> at 1
[[32m  OK  [0m] Started dracut initqueue hook.
         Mounting /sysroot...
[    9.544999] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts:
(null)
[[32m  OK  [0m] Mounted /sysroot.
[[32m  OK  [0m] Reached target Initrd Root File System.
         Starting Reload Configuration from the Real Root...
[[32m  OK  [0m] Started Reload Configuration from the Real Root.
[[32m  OK  [0m] Reached target Initrd File Systems.
[[32m  OK  [0m] Reached target Initrd Default Target.
[    9.673937] systemd-journald[438]: Received SIGTERM
[   10.190535] type=1404 audit(1372346418.678:2): enforcing=1 old_enforcing=0
auid=4294967295 ses=4294967295
[   10.792718] type=1403 audit(1372346419.280:3): policy loaded auid=4294967295
ses=4294967295
[   10.809663] systemd[1]: Successfully loaded SELinux policy in 631.185ms.
[   10.946945] systemd[1]: Relabelled /dev and /run in 44.990ms.

Welcome to [0;31mRed Hat Enterprise Linux Workstation 7.0 (Maipo)[0m!

[   11.019388] systemd-fstab-generator[688]: Failed to create mount unit file
/run/systemd/generator/bigpapi.mount, as it already exists. Duplicate entry in
/etc/fstab?
[   11.035929] systemd-fstab-generator[688]: Failed to create mount unit file
/run/systemd/generator/mnt-engarchive_iso.mount, as it already exists. Duplicate
entry in /etc/fstab?
[   11.053518] systemd-fstab-generator[688]: Failed to create mount unit file
/run/systemd/generator/mnt-brew_archive01.mount, as it already exists. Duplicate
entry in /etc/fstab?
[   11.071093] systemd-fstab-generator[688]: Failed to create mount unit file
/run/systemd/generator/mnt-eng_kernelarchive.mount, as it already exists.
Duplicate entry in /etc/fstab?
[   11.089034] systemd-fstab-generator[688]: Failed to create mount unit file
/run/systemd/generator/mnt-redhat.mount, as it already exists. Duplicate entry
in /etc/fstab?
[   11.188213] LVM: Activation generator successfully completed.
[[32m  OK  [0m] Stopped Switch Root.
[[32m  OK  [0m] Stopped target Switch Root.
[[32m  OK  [0m] Stopped target Initrd File Systems.
[[32m  OK  [0m] Stopped target Initrd Root File System.
         Expecting device dev-ttyS0.device...
[[32m  OK  [0m] Listening on Syslog Socket.
[[32m  OK  [0m] Reached target Network is Online.
         Starting Replay Read-Ahead Data...
         Starting Collect Read-Ahead Data...
[[32m  OK  [0m] Listening on /dev/initctl Compatibility Named Pipe.
[[32m  OK  [0m] Listening on Delayed Shutdown Socket.
[[32m  OK  [0m] Reached target Paths.
[[32m  OK  [0m] Set up automount Arbitrary Executable File Formats
F...utomount Point.
         Mounting POSIX Message Queue File System...
         Mounting Huge Pages File System...
         Starting Create static device nodes in /dev...
         Mounting Debug File System...
[[32m  OK  [0m] Listening on LVM2 metadata daemon socket.
[[32m  OK  [0m] Listening on Device-mapper event daemon FIFOs.
         Expecting device dev-mapper-rhel_intel\x2d\x2ds3e37\...dswap.device...
         Mounting Temporary Directory...
[[32m  OK  [0m] Listening on udev Kernel Socket.
[[32m  OK  [0m] Listening on udev Control Socket.
         Starting udev Coldplug all Devices...
         Expecting device dev-mapper-rhel_intel\x2d\x2ds3e37\...dhome.device...
[[32m  OK  [0m] Started Collect Read-Ahead Data.
[[32m  OK  [0m] Started Replay Read-Ahead Data.
[[32m  OK  [0m] Mounted POSIX Message Queue File System.
[[32m  OK  [0m] Mounted Huge Pages File System.
[[32m  OK  [0m] Mounted Debug File System.
[[32m  OK  [0m] Mounted Temporary Directory.
         Starting File System Check on Root Device...
         Starting Apply Kernel Variables...
         Mounting Configuration File System...
[[32m  OK  [0m] Stopped Trigger Flushing of Journal to Persistent Storage.
         Stopping Journal Service...
[[32m  OK  [0m] Stopped Journal Service.
         Starting Journal Service...
[[32m  OK  [0m] Started Journal Service.
[[32m  OK  [0m] Mounted Configuration File System.
[[32m  OK  [0m] Started File System Check on Root Device.
[[32m  OK  [0m] Started Apply Kernel Variables. [   11.874605] EXT4-fs (dm-1):
re-mounted. Opts: (null)

[[32m  OK  [0m] Started udev Coldplug all Devices.
         Starting udev Wait for Complete Device Initialization...
         Starting Remount Root and Kernel File Systems...
[[32m  OK  [0m] Started Create static device nodes in /dev.
         Starting udev Kernel Device Manager...
[[32m  OK  [0m] Started Remount Root and Kernel File Systems.
         Starting Configure read-only root support...
systemd-fsck[703]: /dev/mapper/rhel_intel--s3e37--05-root: clean, 64647/3276800
files, 1149620/13107200 blocks
[   11.953419] systemd-udevd[717]: starting version 204
[[32m  OK  [0m] Started udev Kernel Device Manager.
[[32m  OK  [0m] Reached target Local File Systems (Pre).
[[32m  OK  [0m] Started Configure read-only root support.
         Starting Load Random Seed...
[[32m  OK  [0m] Started Load Random Seed.
[[32m  OK  [0m] Started udev Wait for Complete Device Initialization.
         Starting Activation of LVM2 logical volumes...
[   12.427081] dca service started, version 1.12.1
[   12.438446] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   12.446121] EDAC MC: Ver: 3.0.0
[   12.450841] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO
conflicts with Region \GPE0 1 (20130328/utaddress-251)
[   12.463742] ACPI: If an ACPI driver is available for this device, you should
use it instead of the native driver
[   12.475184] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO
conflicts with Region \GPIV 1 (20130328/utaddress-251)
[   12.488053] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO
conflicts with Region \_SI_.SIOR 2 (20130328/utaddress-251)
[   12.498761] ACPI: If an ACPI driver is available for this device, you should
use it instead of the native driver
[   12.498791] pps_core: LinuxPPS API ver. 1 registered
[   12.498792] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo
Giometti <giometti@linux.it>
[   12.499075] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   12.512765] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   12.542014] input: PC Speaker as /devices/platform/pcspkr/input/input6
[[32m  OK  [0m] Found device /dev/ttyS0.
[   12.553223] PTP clock support registered
[   12.558714] microcode: CPU0 sig=0x206e6, pf=0x4, revision=0x8
[   12.616255] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.3-k
[   12.624074] igb: Copyright (c) 2007-2013 Intel Corporation.
[   12.712610] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly.
Using workaround
[   12.804521] igb 0000:01:00.0: added PHC on eth0
[   12.809593] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
[   12.817276] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x2) 00:23:8b:e0:09:80
[   12.825334] igb 0000:01:00.0: eth0: PBA No: 1040FF-0FF
[   12.831141] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx
queue(s)
[   12.836218] microcode: CPU1 sig=0x206e6, pf=0x4, revision=0x8
[   12.836330] microcode: CPU2 sig=0x206e6, pf=0x4, revision=0x8
[   12.836393] microcode: CPU3 sig=0x206e6, pf=0x4, revision=0x8
[   12.836427] microcode: CPU4 sig=0x206e6, pf=0x4, revision=0x8
[   12.836450] microcode: CPU5 sig=0x206e6, pf=0x4, revision=0x8
[   12.836499] microcode: CPU6 sig=0x206e6, pf=0x4, revision=0x8
[   12.836607] microcode: CPU7 sig=0x206e6, pf=0x4, revision=0x8
[   12.836645] microcode: CPU8 sig=0x206e6, pf=0x4, revision=0x8
[   12.836702] microcode: CPU9 sig=0x206e6, pf=0x4, revision=0x8
[   12.836731] microcode: CPU10 sig=0x206e6, pf=0x4, revision=0x8
[   12.836747] microcode: CPU11 sig=0x206e6, pf=0x4, revision=0x8
[   12.837022] microcode: CPU12 sig=0x206e6, pf=0x4, revision=0x8
[   12.837045] microcode: CPU13 sig=0x206e6, pf=0x4, revision=0x8
[   12.837129] microcode: CPU14 sig=0x206e6, pf=0x4, revision=0x8
[   12.837152] microcode: CPU15 sig=0x206e6, pf=0x4, revision=0x8
[   12.837172] microcode: CPU16 sig=0x206e6, pf=0x4, revision=0x8
[   12.837248] microcode: CPU17 sig=0x206e6, pf=0x4, revision=0x8
[   12.837318] microcode: CPU18 sig=0x206e6, pf=0x4, revision=0x8
[   12.837334] microcode: CPU19 sig=0x206e6, pf=0x4, revision=0x8
[   12.837352] microcode: CPU20 sig=0x206e6, pf=0x4, revision=0x8
[   12.837377] microcode: CPU21 sig=0x206e6, pf=0x4, revision=0x8
[   12.837452] microcode: CPU22 sig=0x206e6, pf=0x4, revision=0x8
[   12.837474] microcode: CPU23 sig=0x206e6, pf=0x4, revision=0x8
[   12.837492] microcode: CPU24 sig=0x206e6, pf=0x4, revision=0x8
[   12.837515] microcode: CPU25 sig=0x206e6, pf=0x4, revision=0x8
[   12.837596] microcode: CPU26 sig=0x206e6, pf=0x4, revision=0x8
[   12.837669] microcode: CPU27 sig=0x206e6, pf=0x4, revision=0x8
[   12.837689] microcode: CPU28 sig=0x206e6, pf=0x4, revision=0x8
[   12.837778] microcode: CPU29 sig=0x206e6, pf=0x4, revision=0x8
[   12.837795] microcode: CPU30 sig=0x206e6, pf=0x4, revision=0x8
[   12.838009] microcode: CPU31 sig=0x206e6, pf=0x4, revision=0x8
[   12.838048] microcode: CPU32 sig=0x206e6, pf=0x4, revision=0x8
[   12.838124] microcode: CPU33 sig=0x206e6, pf=0x4, revision=0x8
[   12.838193] microcode: CPU34 sig=0x206e6, pf=0x4, revision=0x8
[   12.838264] microcode: CPU35 sig=0x206e6, pf=0x4, revision=0x8
[   12.838287] microcode: CPU36 sig=0x206e6, pf=0x4, revision=0x8
[   12.838304] microcode: CPU37 sig=0x206e6, pf=0x4, revision=0x8
[   12.838380] microcode: CPU38 sig=0x206e6, pf=0x4, revision=0x8
[   12.838453] microcode: CPU39 sig=0x206e6, pf=0x4, revision=0x8
[   12.838481] microcode: CPU40 sig=0x206e6, pf=0x4, revision=0x8
[   12.838501] microcode: CPU41 sig=0x206e6, pf=0x4, revision=0x8
[   12.838523] microcode: CPU42 sig=0x206e6, pf=0x4, revision=0x8
[   12.838542] microcode: CPU43 sig=0x206e6, pf=0x4, revision=0x8
[   12.838625] microcode: CPU44 sig=0x206e6, pf=0x4, revision=0x8
[   12.838644] microcode: CPU45 sig=0x206e6, pf=0x4, revision=0x8
[   12.838714] microcode: CPU46 sig=0x206e6, pf=0x4, revision=0x8
[   12.838738] microcode: CPU47 sig=0x206e6, pf=0x4, revision=0x8
[   12.838805] microcode: CPU48 sig=0x206e6, pf=0x4, revision=0x8
[   12.838950] microcode: CPU49 sig=0x206e6, pf=0x4, revision=0x8
[   12.839034] microcode: CPU50 sig=0x206e6, pf=0x4, revision=0x8
[   12.839054] microcode: CPU51 sig=0x206e6, pf=0x4, revision=0x8
[   12.839072] microcode: CPU52 sig=0x206e6, pf=0x4, revision=0x8
[   12.839089] microcode: CPU53 sig=0x206e6, pf=0x4, revision=0x8
[   12.839159] microcode: CPU54 sig=0x206e6, pf=0x4, revision=0x8
[   12.839175] microcode: CPU55 sig=0x206e6, pf=0x4, revision=0x8
[   12.839254] microcode: CPU56 sig=0x206e6, pf=0x4, revision=0x8
[   12.839270] microcode: CPU57 sig=0x206e6, pf=0x4, revision=0x8
[   12.839341] microcode: CPU58 sig=0x206e6, pf=0x4, revision=0x8
[   12.839423] microcode: CPU59 sig=0x206e6, pf=0x4, revision=0x8
[   13.222553] microcode: CPU60 sig=0x206e6, pf=0x4, revision=0x8
[   13.229140] microcode: CPU61 sig=0x206e6, pf=0x4, revision=0x8
[   13.235787] microcode: CPU62 sig=0x206e6, pf=0x4, revision=0x8
[   13.242646] microcode: CPU63 sig=0x206e6, pf=0x4, revision=0x8
[   13.249162] iTCO_vendor_support: vendor-support=0
[   13.249285] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   13.273100] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[   13.279399] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled by
hardware/BIOS
[   13.391496] igb 0000:01:00.1: added PHC on eth1
[   13.396616] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
[   13.404295] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x2) 00:23:8b:e0:09:81
[   13.412343] igb 0000:01:00.1: eth1: PBA No: 1040FF-0FF
[   13.418078] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx
queue(s)
[   13.589145] igb 0000:04:00.0: added PHC on eth2
[   13.594272] igb 0000:04:00.0: Intel(R) Gigabit Ethernet Network Connection
[   13.601999] igb 0000:04:00.0: eth2: (PCIe:2.5Gb/s:Width x2) 00:23:8b:e0:09:82
[   13.610091] igb 0000:04:00.0: eth2: PBA No: 1040FF-0FF
[   13.615877] igb 0000:04:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx
queue(s)
[[32m  OK  [0m] Found device /dev/mapper/rhel_intel--s3e37--05-swap.
         Activating swap /dev/mapper/rhel_intel--s3e37--05-swap...
[   13.732262] Adding 32972796k swap on /dev/mapper/rhel_intel--s3e37--05-swap.
 Priority:-1 extents:1 across:32972796k FS
[[32m  OK  [0m] Activated swap /dev/mapper/rhel_intel--s3e37--05-swap.
[[32m  OK  [0m] Reached target Swap.
[   13.787177] igb 0000:04:00.1: added PHC on eth3
[   13.792268] igb 0000:04:00.1: Intel(R) Gigabit Ethernet Network Connection
[   13.800034] igb 0000:04:00.1: eth3: (PCIe:2.5Gb/s:Width x2) 00:23:8b:e0:09:83
[   13.808159] igb 0000:04:00.1: eth3: PBA No: 1040FF-0FF
[   13.813944] igb 0000:04:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx
queue(s)
[   13.919721] systemd-udevd[734]: renamed network interface eth3 to em4
[   13.934575] systemd-udevd[730]: renamed network interface eth1 to em2
[   14.014310] systemd-udevd[732]: renamed network interface eth2 to em3
[   14.042699] systemd-udevd[736]: renamed network interface eth0 to em1
[[32m  OK  [0m] Found device /dev/mapper/rhel_intel--s3e37--05-home.
         Starting File System Check on /dev/mapper/rhel_intel...e37--05-home...
[[32m  OK  [0m] Started Activation of LVM2 logical volumes.
[[32m  OK  [0m] Reached target Encrypted Volumes.
         Starting Activation of LVM2 logical volumes...
systemd-fsck[1411]: /dev/mapper/rhel_intel--s3e37--05-home: clean,
83681/12460032 files, 2840188/49809408 blocks
[[32m  OK  [0m] Started File System Check on
/dev/mapper/rhel_intel--s3e37--05-home.
         Mounting /home...
[   14.812165] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts:
(null)
[[32m  OK  [0m] Mounted /home.
[[32m  OK  [0m] Started Activation of LVM2 logical volumes.
         Starting Monitoring of LVM2 mirrors, snapshots etc. ...ress polling...
[[32m  OK  [0m] Started Monitoring of LVM2 mirrors, snapshots etc. u...ogress
polling.
[[32m  OK  [0m] Reached target Local File Systems.
         Starting Security Auditing Service...
         Starting Recreate Volatile Files and Directories...
         Starting Tell Plymouth To Write Out Runtime Data...
[[32m  OK  [0m] Started Tell Plymouth To Write Out Runtime Data.
[[32m  OK  [0m] Started Security Auditing Service.
[[32m  OK  [0m] Started Recreate Volatile Files and Directories.
[[32m  OK  [0m] Reached target System Initialization.
[[32m  OK  [0m] Reached target Timers.
[[32m  OK  [0m] Listening on RPCbind Server Activation Socket.
[[32m  OK  [0m] Listening on PC/SC Smart Card Daemon Activation Socket.
[[32m  OK  [0m] Listening on Avahi mDNS/DNS-SD Stack Activation Socket.
[[32m  OK  [0m] Listening on D-Bus System Message Bus Socket.
[[32m  OK  [0m] Reached target Sockets.
[[32m  OK  [0m] Reached target Basic System.
         Starting firewalld - dynamic firewall daemon...
         Starting /etc/rc.local Compatibility...
         Starting Machine Check Exception Logging Daemon...
         Starting irqbalance daemon...
[[32m  OK  [0m] Started irqbalance daemon.
         Starting Login Service...
[   17.463997] type=1305 audit(1372346425.955:4): audit_pid=1430 old=0
auid=4294967295 ses=4294967295
[   17.463997]  subj=system_u:system_r:auditd_t:s0 res=1
         Starting System Logging Service...
[[32m  OK  [0m] Started System Logging Service.
         Starting Avahi mDNS/DNS-SD Stack...
         Starting D-Bus System Message Bus...
[[32m  OK  [0m] Started D-Bus System Message Bus.
[[32m  OK  [0m] Started Login Service.
[[32m  OK  [0m] Started Avahi mDNS/DNS-SD Stack.
[[32m  OK  [0m] Started Machine Check Exception Logging Daemon.
[[32m  OK  [0m] Started firewalld - dynamic firewall daemon.
         Starting Network Manager...
[   17.823464] ip_tables: (C) 2000-2006 Netfilter Core Team
[   17.888797] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   17.957077] Ebtables v2.0 registered
         Starting Authorization Manager...
[[32m  OK  [0m] Started Authorization Manager.
[   18.150712] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[[32m  OK  [0m] Started Network Manager.
         Starting Network Manager Wait Online...
[   18.291924] IPv6: ADDRCONF(NETDEV_UP): em1: link is not ready
[   18.475034] IPv6: ADDRCONF(NETDEV_UP): em2: link is not ready
[   18.596803] IPv6: ADDRCONF(NETDEV_UP): em3: link is not ready
[   18.718650] IPv6: ADDRCONF(NETDEV_UP): em4: link is not ready
[   21.260622] igb: em1 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
[   21.268890] IPv6: ADDRCONF(NETDEV_CHANGE): em1: link becomes ready
[[32m  OK  [0m] Started Network Manager Wait Online.
[[32m  OK  [0m] Reached target Network.
         Starting Postfix Mail Transport Agent...
         Starting OpenSSH server daemon...
         Starting Crash recovery kernel arming...
         Starting Enable periodic update of entitlement certificates....
         Starting RPC bind service...
         Mounting /mnt/engarchive2...
         Mounting /mnt/redhat...
         Mounting /mnt/eng_kernelarchive...
         Mounting /mnt/brew_archive01...
         Mounting /mnt/engarchive_iso...
         Mounting /bigpapi...
[[32m  OK  [0m] Started OpenSSH server daemon.
[[32m  OK  [0m] Started Enable periodic update of entitlement certificates..
[[32m  OK  [0m] Started RPC bind service.
[   22.551930] FS-Cache: Loaded
[   22.564429] Key type dns_resolver registered
[   22.674784] RPC: Registered named UNIX socket transport module.
[   22.681506] RPC: Registered udp transport module.
[   22.686883] RPC: Registered tcp transport module.
[   22.692181] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   22.852816] FS-Cache: Netfs 'nfs' registered for caching
[   22.968868] NFS: Registering the id_resolver key type
[   22.974584] Key type id_resolver registered
[   22.979274] Key type id_legacy registered
[[32m  OK  [0m] Mounted /bigpapi.
[[32m  OK  [0m] Mounted /mnt/engarchive_iso.
[[32m  OK  [0m] Mounted /mnt/brew_archive01.
[[32m  OK  [0m] Started Postfix Mail Transport Agent.
[[32m  OK  [0m] Mounted /mnt/redhat.
[[32m  OK  [0m] Mounted /mnt/engarchive2.
[   26.789401] dm-1: WRITE SAME failed. Manually zeroing.
[   38.049286] RPC: AUTH_GSS upcall timed out.
[   38.049286] Please check user daemon is running.
[[32m  OK  [0m] Mounted /mnt/eng_kernelarchive.
[[32m  OK  [0m] Reached target Remote File Systems.
         Starting LSB: Start the iprupdate utility...
         Starting LSB: Start the ipr init daemon...
         Starting Trigger Flushing of Journal to Persistent Storage...
[[32m  OK  [0m] Started Trigger Flushing of Journal to Persistent Storage.
         Starting Permit User Sessions...
[[32m  OK  [0m] Started Permit User Sessions.
         Starting Command Scheduler...
[[32m  OK  [0m] Started Command Scheduler.
[   38.212068] sd 0:2:0:0: Attached scsi generic sg0 type 0
[   38.218224] sr 1:0:0:0: Attached scsi generic sg1 type 5
[[32m  OK  [0m] Started LSB: Start the iprupdate utility.
[[32m  OK  [0m] Started LSB: Start the ipr init daemon.
         Starting LSB: Start the ipr dump daemon...
[[32m  OK  [0m] Started LSB: Start the ipr dump daemon.
BOOT_IMAGE=/boot/vmlinuz-3.10.0-rc4+ root=/dev/mapper/rhel_intel--s3e37--05-root
ro rd.md=0 rd.dm=0 console=ttyS0,115200n81 vconsole.keymap=us crashkernel=auto
rd.luks=0 vconsole.font=latarcyrheb-sun16 rd.lvm.lv=rhel_intel-s3e37-05/swap
rd.lvm.lv=rhel_intel-s3e37-05/root LANG=en_US.UTF-8 reboot
         Deactivating swap /dev/dm-0...
         Deactivating swap /[   47.193811] systemd[1]:
bus_connection_get_unix_fd failed Broken pipe
dev/dm-0...
         Deactivat[   47.201460] systemd[1]: Failed to get caller's security
context on: Broken pipe
ing swap /dev/dm[   47.213891] systemd[1]: Unit firewalld.service entered failed
state.
-0...
         Deactivating swap /dev/dm-0... [   47.227531] systemd[1]: Unit
mcelog.service entered failed state.

         Deactivating swap /de[   47.238160] systemd[1]: Unit rpcbind.service
entered failed state.
v/dm-0...
[[32m  OK  [0m] Stopped target Multi-User System.
         Stopping LSB: Start the ipr dump daemon...
         Stopping LSB: Start the iprupdate utility...
         Stopping Command Scheduler...
         Stopping Postfix Mail Transport Agent...
         Stopping OpenSSH server daemon...
         Stopping Machine Check Exception Logging Daemon...
         Stopping irqbalance daemon...
         Stopping Crash recovery kernel arming...
         Stopping Enable periodic update of entitlement certificates....
[[32m  OK  [0m] Stopped target Login Prompts.
[[32m  OK  [0m] Stopped Getty on tty1.
         Starting Show Plymouth Reboot Screen...
[[32m  OK  [0m] Stopped Serial Getty on ttyS0.
[[32m  OK  [0m] Stopped Wait for Plymouth Boot Screen to Quit.
[[32m  OK  [0m] Stopped Terminate Plymouth Boot Screen.
         Stopping /etc/rc.local Compatibility...
         Stopping System Logging Service...
         Stopping RPC bind service...
         Stopping Authorization Manager...
         Stopping Login Service...
         Stopping D-Bus System Message Bus...
         Stopping Avahi mDNS/DNS-SD Stack...
         Starting Restore /run/initramfs...
[[32m  OK  [0m] Stopped firewalld - dynamic firewall daemon.
[[32m  OK  [0m] Stopped /etc/rc.local Compatibility.
[[32m  OK  [0m] Stopped irqbalance daemon.
[[32m  OK  [0m] Stopped System Logging Service.
[[32m  OK  [0m] Stopped Avahi mDNS/DNS-SD Stack.
[[32m  OK  [0m] Stopped D-Bus System Message Bus.
[[32m  OK  [0m] Stopped Machine Check Exception Logging Daemon.
[[32m  OK  [0m] Stopped Authorization Manager.
[[32m  OK  [0m] Stopped Crash recovery kernel arming.
[[32m  OK  [0m] Stopped Enable periodic update of entitlement certificates..
[[32m  OK  [0m] Stopped RPC bind service.
[[32m  OK  [0m] Stopped OpenSSH server daemon.
[[32m  OK  [0m] Stopped Command Scheduler.
[[32m  OK  [0m] Deactivated swap /dev/dm-0.
[[32m  OK  [0m] Stopped LSB: Start the ipr dump daemon.
[[32m  OK  [0m] Stopped LSB: Start the iprupdate utility.
[[32m  OK  [0m] Stopped Login Service.
         Stopping LSB: Start the ipr init daemon...
         Stopping Permit User Sessions...
[[32m  OK  [0m] Deactivated swap /dev/rhel_intel-s3e37-05/swap.
[[32m  OK  [0m] Deactivated swap
/dev/disk/by-uuid/a91934ef-9bc4-400...6-9e134d1073ff.
[[32m  OK  [0m] Deactivated swap
/dev/disk/by-id/dm-uuid-LVM-gvYoL3k...jf4PTidFECD5JQ.
[[32m  OK  [0m] Deactivated swap
/dev/disk/by-id/dm-name-rhel_intel--s3e37--05-swap.
[[32m  OK  [0m] Deactivated swap /dev/mapper/rhel_intel--s3e37--05-swap.
[[32m  OK  [0m] Stopped Permit User Sessions.
[[32m  OK  [0m] Stopped LSB: Start the ipr init daemon.
[[32m  OK  [0m] Stopped target Remote File Systems.
         Unmounting /mnt/redhat...
         Unmounting /mnt/eng_kernelarchive...
         Unmounting /mnt/brew_archive01...
         Unmounting /mnt/engarchive_iso...
         Unmounting /bigpapi...
[[32m  OK  [0m] Stopped Postfix Mail Transport Agent.
[[32m  OK  [0m] Unmounted /mnt/eng_kernelarchive.
[[32m  OK  [0m] Unmounted /mnt/brew_archive01.
[[32m  OK  [0m] Unmounted /mnt/engarchive_iso.
[[32m  OK  [0m] Started Show Plymouth Reboot Screen.
[[32m  OK  [0m] Unmounted /mnt/redhat.
[[32m  OK  [0m] Unmounted /bigpapi.
[[32m  OK  [0m] Stopped target Network is Online.
[[32m  OK  [0m] Stopped target Network.
         Stopping Network Manager...
[[32m  OK  [0m] Stopped Network Manager.
[[32m  OK  [0m] Stopped target Basic System.
[[32m  OK  [0m] Stopped target Paths.
[[32m  OK  [0m] Stopped target Timers.
[[32m  OK  [   47.953697] type=1305 audit(1372346456.462:395): audit_pid=0
old=1430 auid=4294967295 ses=4294967295
[   47.953697]  subj=system_u:system_r:auditd_t:s0 res=1
[0m] Stopped tar[   47.971026] type=1131 audit(1372346456.479:396): pid=1 uid=0
auid=4294967295 ses=4294967295
[   47.971026]  subj=system_u:system_r:init_t:s0 msg=' comm="auditd"
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
get Sockets.
[[32m  OK  [0m][   47.998200] type=1131 audit(1372346456.506:397): pid=1 uid=0
auid=4294967295 ses=4294967295
[   47.998200]  subj=system_u:system_r:init_t:s0 msg=' comm="fedora-readonly"
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
 Closed Syslog Socket.
[[32m  OK  [0m] Close[   48.026710] type=1131 audit(1372346456.535:398): pid=1
uid=0 auid=4294967295 ses=4294967295
[   48.026710]  subj=system_u:system_r:init_t:s0 msg=' comm="systemd-remount-fs"
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
d RPCbind Server Activation Sock[   48.055126] type=1131
audit(1372346456.563:399): pid=1 uid=0 auid=4294967295 ses=4294967295
[   48.055126]  subj=system_u:system_r:init_t:s0 msg='
comm="systemd-readahead-replay" exe="/usr/lib/systemd/systemd" hostname=? addr=?
terminal=? res=success'
et.
[[32m  OK  [0m] Closed P[   48.083509] type=1130 audit(1372346456.592:400):
pid=1 uid=0 auid=4294967295 ses=4294967295
[   48.083509]  subj=system_u:system_r:init_t:s0 msg='
comm="systemd-random-seed-save" exe="/usr/lib/systemd/systemd" hostname=? addr=?
terminal=? res=success'
C/SC Smart Card [   48.108485] type=1131 audit(1372346456.617:401): pid=1 uid=0
auid=4294967295 ses=4294967295
[   48.108485]  subj=system_u:system_r:init_t:s0 msg='
comm="systemd-random-seed-save" exe="/usr/lib/systemd/systemd" hostname=? addr=?
terminal=? res=success'
Daemon Activation Socket.
[[3[   48.136585] type=1131 audit(1372346456.645:402): pid=1 uid=0
auid=4294967295 ses=4294967295
[   48.136585]  subj=system_u:system_r:init_t:s0 msg='
comm="systemd-readahead-collect" exe="/usr/lib/systemd/systemd" hostname=?
addr=? terminal=? res=success'
2m  OK  [0m] Closed Avahi mDNS/[   48.165841] type=1130
audit(1372346456.674:403): pid=1 uid=0 auid=4294967295 ses=4294967295
[   48.165841]  subj=system_u:system_r:init_t:s0 msg=' comm="dracut-shutdown"
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
DNS-SD Stack Activation Socket.
[[32m  OK  [0m] Closed D-Bus System Message Bus Socket.
[[32m  OK  [0m] Stopped target System Initialization.
         Stopping Security Auditing Service...
[[32m  OK  [0m] Stopped target Encrypted Volumes.
         Stopping Setup Virtual Console...
[[32m  OK  [0m] Stopped Setup Virtual Console.
         Stopping Apply Kernel Variables...
[[32m  OK  [0m] Stopped Apply Kernel Variables.
[[32m  OK  [0m] Stopped target Swap.
[[32m  OK  [0m] Stopped Security Auditing Service.
[[32m  OK  [0m] Stopped target Local File Systems.
         Unmounting /home...
         Stopping Configure read-only root support...
[[32m  OK  [0m] Stopped Configure read-only root support.
         Unmounting Temporary Directory...
         Stopping Monitoring of LVM2 mirrors, snapshots etc. ...ress polling...
[[32m  OK  [0m] Unmounted /home.
[[32m  OK  [0m] Stopped target Local File Systems (Pre).
         Stopping Remount Root and Kernel File Systems...
[[32m  OK  [0m] Stopped Remount Root and Kernel File Systems.
         Starting Update UTMP about System Runlevel Changes...
         Starting Save Random Seed...
         Stopping Replay Read-Ahead Data...
[[32m  OK  [0m] Stopped Rep[   48.320879] systemd-journald[708]: Received SIGTERM
lay Read-Ahead Data.
         Stopping Collect Read-Ahead Data...
[[32m  OK  [0m] Unmounted Temporary Directory.
[[32m  OK  [0m] Started Save Random Seed.
[[32m  OK  [0m] Stopped Collect Read-Ahead Data.
[[32m  OK  [0m] Started Restore /run/initramfs.
[[32m  OK  [0m] Reached target Shutdown.
Sending SIGTERM to remaining processes...
Sending SIGKILL to remaining processes...
Unmounting file systems.
Unmounting /bigpapi.
Unmounting /sys/kernel/config.
Unmounting /dev/hugepages.
Unmounting /dev/mqueue.
Unmounting /sys/kernel/debug.
All filesystems unmounted.
Deactivating swaps.
All swaps deactivated.
Detaching loop devices.
All loop devices detached.
Detaching DM Successfully changed into root pivot.
Returning to initrd...
[   48.787276] dracut Warning: Killing all remaining processes
dracut Warning: Killing all remaining processes
[   48.967623] dracut Warning: Unmounted /oldroot.
[   49.006607] dracut: Disassembling device-mapper devices
Rebooting.
[   49.025803] kvm: exiting hardware virtualization
[   49.348313] Disabling non-boot CPUs ...
[   52.050497] Broke affinity for irq 102
[  270.563197] INFO: rcu_sched detected stalls on CPUs/tasks: { 51} (detected by
63, t=217205 jiffies, g=3583, c=3582, q=578)
[  270.575583] sending NMI to all CPUs:
[  270.579581] NMI backtrace for cpu 0
[  270.583480] CPU: 0 PID: 595 Comm: kworker/0:2 Not tainted 3.10.0-rc4+ #2
[  270.590954] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS
QSSC-S4R.QCI.01.00.T030.072620111404 07/26/2011
[  270.601345] task: ffff880851c50000 ti: ffff880851c72000 task.ti:
ffff880851c72000
[  270.609691] RIP: 0010:[<ffffffff8109a8c0>]  [<ffffffff8109a8c0>]
update_cfs_shares+0xf0/0xf0
[  270.619126] RSP: 0018:ffff880851c73d78  EFLAGS: 00000086
[  270.625049] RAX: ffffffff81626180 RBX: ffff880851c50048 RCX: 0000000000000000
[  270.633007] RDX: 0000000000000001 RSI: ffff880851c50048 RDI: ffff88085f414670
[  270.640965] RBP: ffff880851c73dc0 R08: 0000003effcc9cfd R09: 0000000000000000
[  270.648923] R10: 0000000000000000 R11: 0000000000000005 R12: ffff88085f414670
[  270.656881] R13: ffff88085f414600 R14: 0000000000000001 R15: 0000000000000001
[  270.664841] FS:  0000000000000000(0000) GS:ffff88085f400000(0000)
knlGS:0000000000000000
[  270.673865] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  270.680272] CR2: 00000000000000b8 CR3: 00000000018f8000 CR4: 00000000000007f0
[  270.688229] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  270.696188] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  270.704146] Stack:
[  270.706388]  ffffffff8109b019 ffff88085f414600 ffff88085f414600 0000000000000000
[  270.714684]  ffff88085f414600 ffff88085f414600 0000000000000000 ffff880851c50000
[  270.722981]  ffff8808521ec700 ffff880851c73de8 ffffffff8108ed39 0000000168d36c00
[  270.731276] Call Trace:
[  270.734007]  [<ffffffff8109b019>] ? dequeue_task_fair+0x59/0x640
[  270.740713]  [<ffffffff8108ed39>] dequeue_task+0x79/0xa0
[  270.746638]  [<ffffffff81091be3>] deactivate_task+0x23/0x30
[  270.752857]  [<ffffffff816023f9>] __schedule+0x589/0x7d0
[  270.758782]  [<ffffffff81602669>] schedule+0x29/0x70
[  270.764323]  [<ffffffff8107de03>] worker_thread+0x1c3/0x3a0
[  270.770541]  [<ffffffff8107dc40>] ? rescuer_thread+0x350/0x350
[  270.777041]  [<ffffffff81084300>] kthread+0xc0/0xd0
[  270.782474]  [<ffffffff81084240>] ? insert_kthread_work+0x40/0x40
[  270.789272]  [<ffffffff8160c56c>] ret_from_fork+0x7c/0xb0
[  270.795295]  [<ffffffff81084240>] ? insert_kthread_work+0x40/0x40
[  270.802091] Code: 0f 1f 00 48 89 13 48 c7 43 08 00 00 00 00 5b 41 5c 41 5d 5d
c3 66 0f 1f 44 00 00 4c 89 e7 e8 88 fb ff ff eb 97 66 0f 1f 44 00 00 <66> 66 66
66 90 55 48 89 e5 41 57 41 56 41 55 41 89 d5 41 83 e5
[  270.823785] NMI backtrace for cpu 53
[  270.827775] CPU: 53 PID: 0 Comm: swapper/53 Not tainted 3.10.0-rc4+ #2
[  270.835056] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS
QSSC-S4R.QCI.01.00.T030.072620111404 07/26/2011
[  270.845440] task: ffff880854dcd900 ti: ffff880854dde000 task.ti:
ffff880854dde000
[  270.853788] RIP: 0010:[<ffffffff810b0432>]  [<ffffffff810b0432>]
cpu_startup_entry+0x132/0x230
[  270.863418] RSP: 0018:ffff880854ddfef8  EFLAGS: 00000246
[  270.869344] RAX: 0000000400000000 RBX: ffff880854ddffd8 RCX: 0100000000000000
[  270.877304] RDX: ffff880854ddffd8 RSI: 0000000000000000 RDI: 0000000000000086
[  270.885265] RBP: ffff880854ddff30 R08: 0000000000000000 R09: 000000000014a341
[  270.893223] R10: 0000000000000000 R11: 0000000000016d87 R12: ffff880854ddffd8
[  270.901183] R13: ffff880854ddffd8 R14: ffff880854ddffd8 R15: ffff880854ddffd8
[  270.909144] FS:  0000000000000000(0000) GS:ffff880c6fb40000(0000)
knlGS:0000000000000000
[  270.918162] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  270.924571] CR2: 00007f6f46edb414 CR3: 00000000018f8000 CR4: 00000000000007e0
[  270.932532] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  270.940494] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  270.948453] Stack:
[  270.950695]  0000000000000000 0000003500000000 0000000000000000 0000000000000000
[  270.958998]  0000000000000000 0000000000000000 0000000000000000 ffff880854ddff48
[  270.967303]  ffffffff815ed4e8 3247dcda93428677 0000000000000000 0000000000000000
[  270.975602] Call Trace:
[  270.978342]  [<ffffffff815ed4e8>] start_secondary+0x254/0x256
[  270.984751] Code: 00 89 45 d4 66 66 66 66 90 fb 66 66 90 66 66 90 49 8b 87 38
e0 ff ff a8 08 75 1b 65 48 8b 14 25 f0 c6 00 00 0f 1f 44 00 00 f3 90 <48> 8b 82
38 e0 ff ff a8 08 74 f3 65 8b 04 25 1c b0 00 00 89 45
[  271.006538] NMI backtrace for cpu 54
[  271.010534] CPU: 54 PID: 0 Comm: swapper/54 Not tainted 3.10.0-rc4+ #2
[  271.017817] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS
QSSC-S4R.QCI.01.00.T030.072620111404 07/26/2011
[  271.028200] task: ffff880854dce420 ti: ffff880854de8000 task.ti:
ffff880854de8000
[  271.036549] RIP: 0010:[<ffffffff810b0439>]  [<ffffffff810b0439>]
cpu_startup_entry+0x139/0x230
[  271.046176] RSP: 0018:ffff880854de9ef8  EFLAGS: 00000246
[  271.052102] RAX: 0000000400000000 RBX: ffff880854de9fd8 RCX: 0100000000000000
[  271.060064] RDX: ffff880854de9fd8 RSI: 0000000000000000 RDI: 0000000000000086
[  271.068022] RBP: ffff880854de9f30 R08: 0000000000000000 R09: 000000000014ddd7
[  271.075981] R10: 0000000000000001 R11: 00000000000009c2 R12: ffff880854de9fd8
[  271.083939] R13: ffff880854de9fd8 R14: ffff880854de9fd8 R15: ffff880854de9fd8
[  271.091899] FS:  0000000000000000(0000) GS:ffff88085fac0000(0000)
knlGS:0000000000000000
[  271.100926] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  271.107336] CR2: 00007fc4f0e8192c CR3: 00000000018f8000 CR4: 00000000000007e0
[  271.115295] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  271.123253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  271.131211] Stack:
[  271.133452]  0000000000000000 0000003600000000 0000000000000000 0000000000000000
[  271.141752]  0000000000000000 0000000000000000 0000000000000000 ffff880854de9f48
[  271.150050]  ffffffff815ed4e8 b4499cdcd9d036ee 0000000000000000 0000000000000000
[  271.158348] Call Trace:
[  271.161086]  [<ffffffff815ed4e8>] start_secondary+0x254/0x256
[  271.167496] Code: 66 90 fb 66 66 90 66 66 90 49 8b 87 38 e0 ff ff a8 08 75 1b
65 48 8b 14 25 f0 c6 00 00 0f 1f 44 00 00 f3 90 48 8b 82 38 e0 ff ff <a8> 08 74
f3 65 8b 04 25 1c b0 00 00 89 45 d4 66 66 66 66 90 e8
[  271.189343] NMI backtrace for cpu 55
[  271.193337] CPU: 55 PID: 0 Comm: swapper/55 Not tainted 3.10.0-rc4+ #2
[  271.200619] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS
QSSC-S4R.QCI.01.00.T030.072620111404 07/26/2011
[  271.211002] task: ffff880854dcef40 ti: ffff880854dea000 task.ti:
ffff880854dea000
[  271.219351] RIP: 0010:[<ffffffff810b0432>]  [<ffffffff810b0432>]
cpu_startup_entry+0x132/0x230
[  271.228981] RSP: 0018:ffff880854debef8  EFLAGS: 00000246
[  271.234906] RAX: 0000000400000000 RBX: ffff880854debfd8 RCX: 0100000000000000
[  271.242867] RDX: ffff880854debfd8 RSI: 0000000000000000 RDI: 0000000000000086
[  271.250826] RBP: ffff880854debf30 R08: 0000000000000000 R09: 00000000000009e7
[  271.258787] R10: 0000000000000000 R11: 0000000000000079 R12: ffff880854debfd8
[  271.266748] R13: ffff880854debfd8 R14: ffff880854debfd8 R15: ffff880854debfd8
[  271.274710] FS:  0000000000000000(0000) GS:ffff88106f340000(0000)
knlGS:0000000000000000
[  271.283736] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  271.290145] CR2: 00007ff1a360f414 CR3: 00000000018f8000 CR4: 00000000000007e0
[  271.298106] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  271.306067] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  271.314027] Stack:
[  271.316269]  0000000000000000 0000003700000000 0000000000000000 0000000000000000
[  271.324569]  0000000000000000 0000000000000000 0000000000000000 ffff880854debf48
[  271.332871]  ffffffff815ed4e8 98ebeba263d0f167 0000000000000000 0000000000000000
[  271.341172] Call Trace:
[  271.343910]  [<ffffffff815ed4e8>] start_secondary+0x254/0x256
[  271.350319] Code: 00 89 45 d4 66 66 66 66 90 fb 66 66 90 66 66 90 49 8b 87 38
e0 ff ff a8 08 75 1b 65 48 8b 14 25 f0 c6 00 00 0f 1f 44 00 00 f3 90 <48> 8b 82
38 e0 ff ff a8 08 74 f3 65 8b 04 25 1c b0 00 00 89 45
[  271.372082] NMI backtrace for cpu 56
[  271.376073] CPU: 56 PID: 0 Comm: swapper/56 Not tainted 3.10.0-rc4+ #2
[  271.383344] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS
QSSC-S4R.QCI.01.00.T030.072620111404 07/26/2011
[  271.393727] task: ffff880854df0000 ti: ffff880854dec000 task.ti:
ffff880854dec000
[  271.402074] RIP: 0010:[<ffffffff810b0432>]  [<ffffffff810b0432>]
cpu_startup_entry+0x132/0x230
[  271.411696] RSP: 0018:ffff880854dedef8  EFLAGS: 00000246
[  271.417618] RAX: 0000000400000000 RBX: ffff880854dedfd8 RCX: 0100000000000000
[  271.425577] RDX: ffff880854dedfd8 RSI: 0000000000000000 RDI: 0000000000000086
[  271.433535] RBP: ffff880854dedf30 R08: 0000000000000000 R09: 0000000000154b17
[  271.441494] R10: 0000000000000000 R11: 0000000000000079 R12: ffff880854dedfd8
[  271.449452] R13: ffff880854dedfd8 R14: ffff880854dedfd8 R15: ffff880854dedfd8
[  271.457411] FS:  0000000000000000(0000) GS:ffff88085fb00000(0000)
knlGS:0000000000000000
[  271.466436] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  271.472843] CR2: 00007f3caa7f13cc CR3: 00000000018f8000 CR4: 00000000000007e0
[  271.480802] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  271.488761] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  271.496718] Stack:
[  271.498959]  0000000000000000 0000003800000000 0000000000000000 0000000000000000
[  271.507254]  0000000000000000 0000000000000000 0000000000000000 ffff880854dedf48
[  271.515546]  ffffffff815ed4e8 43d374aa2890638b 0000000000000000 0000000000000000
[  271.523840] Call Trace:
[  271.526573]  [<ffffffff815ed4e8>] start_secondary+0x254/0x256
[  271.532980] Code: 00 89 45 d4 66 66 66 66 90 fb 66 66 90 66 66 90 49 8b 87 38
e0 ff ff a8 08 75 1b 65 48 8b 14 25 f0 c6 00 00 0f 1f 44 00 00 f3 90 <48> 8b 82
38 e0 ff ff a8 08 74 f3 65 8b 04 25 1c b0 00 00 89 45
[  271.554693] NMI backtrace for cpu 57
[  271.558685] CPU: 57 PID: 0 Comm: swapper/57 Not tainted 3.10.0-rc4+ #2
[  271.565968] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS
QSSC-S4R.QCI.01.00.T030.072620111404 07/26/2011
[  271.576351] task: ffff880854df0b20 ti: ffff880854dee000 task.ti:
ffff880854dee000
[  271.584699] RIP: 0010:[<ffffffff810b0432>]  [<ffffffff810b0432>]
cpu_startup_entry+0x132/0x230
[  271.594324] RSP: 0018:ffff880854defef8  EFLAGS: 00000246
[  271.600250] RAX: 0000000400000000 RBX: ffff880854deffd8 RCX: 0100000000000000
[  271.608211] RDX: ffff880854deffd8 RSI: 0000000000000000 RDI: 0000000000000086
[  271.616172] RBP: ffff880854deff30 R08: 0000000000000000 R09: 00000000000003b7
[  271.624133] R10: 0000000000000001 R11: 00000000000001f0 R12: ffff880854deffd8
[  271.632094] R13: ffff880854deffd8 R14: ffff880854deffd8 R15: ffff880854deffd8
[  271.640056] FS:  0000000000000000(0000) GS:ffff880c6fb80000(0000)
knlGS:0000000000000000
[  271.649074] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  271.655482] CR2: 00007fb64da15920 CR3: 00000000018f8000 CR4: 00000000000007e0
[  271.663441] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  271.671401] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  271.679362] Stack:
[  271.681604]  0000000000000000 0000003900000000 0000000000000000 0000000000000000
[  271.689907]  0000000000000000 0000000000000000 0000000000000000 ffff880854deff48
[  271.698207]  ffffffff815ed4e8 f7fc6183db3c57d0 0000000000000000 0000000000000000
[  271.706507] Call Trace:
[  271.709239]  [<ffffffff815ed4e8>] start_secondary+0x254/0x256
[  271.715650] Code: 00 89 45 d4 66 66 66 66 90 fb 66 66 90 66 66 90 49 8b 87 38
e0 ff ff a8 08 75 1b 65 48 8b 14 25 f0 c6 00 00 0f 1f 44 00 00 f3 90 <48> 8b 82
38 e0 ff ff a8 08 74 f3 65 8b 04 25 1c b0 00 00 89 45
[  271.737418] NMI backtrace for cpu 58
[  271.741410] CPU: 58 PID: 0 Comm: swapper/58 Not tainted 3.10.0-rc4+ #2
[  271.748694] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS
QSSC-S4R.QCI.01.00.T030.072620111404 07/26/2011
[  271.759077] task: ffff880854df1640 ti: ffff880854df8000 task.ti:
ffff880854df8000
[  271.767425] RIP: 0010:[<ffffffff810b0432>]  [<ffffffff810b0432>]
cpu_startup_entry+0x132/0x230
[  271.777051] RSP: 0018:ffff880854df9ef8  EFLAGS: 00000246
[  271.782977] RAX: 0000000400000000 RBX: ffff880854df9fd8 RCX: 0100000000000000
[  271.790938] RDX: ffff880854df9fd8 RSI: 0000000000000000 RDI: 0000000000000086
[  271.798899] RBP: ffff880854df9f30 R08: 0000000000000000 R09: 000000000015cc1a
[  271.806859] R10: 0000000000000001 R11: 0000000000000a10 R12: ffff880854df9fd8
[  271.814819] R13: ffff880854df9fd8 R14: ffff880854df9fd8 R15: ffff880854df9fd8
[  271.822781] FS:  0000000000000000(0000) GS:ffff88085fb40000(0000)
knlGS:0000000000000000
[  271.831807] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  271.838217] CR2: 00007f92543b4e70 CR3: 00000000018f8000 CR4: 00000000000007e0
[  271.846178] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  271.854138] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  271.862098] Stack:
[  271.864341]  0000000000000000 0000003a00000000 0000000000000000 0000000000000000
[  271.872636]  0000000000000000 0000000000000000 0000000000000000 ffff880854df9f48
[  271.880932]  ffffffff815ed4e8 351a6aa2b82e81e1 0000000000000000 0000000000000000
[  271.889228] Call Trace:
[  271.891962]  [<ffffffff815ed4e8>] start_secondary+0x254/0x256
[  271.898372] Code: 00 89 45 d4 66 66 66 66 90 fb 66 66 90 66 66 90 49 8b 87 38
e0 ff ff a8 08 75 1b 65 48 8b 14 25 f0 c6 00 00 0f 1f 44 00 00 f3 90 <48> 8b 82
38 e0 ff ff a8 08 74 f3 65 8b 04 25 1c b0 00 00 89 45
[  271.920214] NMI backtrace for cpu 59
[  271.924208] CPU: 59 PID: 0 Comm: swapper/59 Not tainted 3.10.0-rc4+ #2
[  271.931491] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS
QSSC-S4R.QCI.01.00.T030.072620111404 07/26/2011
[  271.941873] task: ffff880854df2160 ti: ffff880854dfa000 task.ti:
ffff880854dfa000
[  271.950221] RIP: 0010:[<ffffffff810b0439>]  [<ffffffff810b0439>]
cpu_startup_entry+0x139/0x230
[  271.959846] RSP: 0018:ffff880854dfbef8  EFLAGS: 00000246
[  271.965764] RAX: 0000000400000000 RBX: ffff880854dfbfd8 RCX: 0100000000000000
[  271.973726] RDX: ffff880854dfbfd8 RSI: 0000000000000000 RDI: 0000000000000086
[  271.981677] RBP: ffff880854dfbf30 R08: 0000000000000000 R09: 00000000000003e1
[  271.989636] R10: 0000000000000000 R11: 00000000000000c3 R12: ffff880854dfbfd8
[  271.997597] R13: ffff880854dfbfd8 R14: ffff880854dfbfd8 R15: ffff880854dfbfd8
[  272.005558] FS:  0000000000000000(0000) GS:ffff88106f380000(0000)
knlGS:0000000000000000
[  272.014584] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  272.020994] CR2: 00000000016ffd68 CR3: 00000000018f8000 CR4: 00000000000007e0
[  272.028955] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  272.036915] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  272.044875] Stack:
[  272.047118]  0000000000000000 0000003b00000000 0000000000000000 0000000000000000
[  272.055421]  0000000000000000 0000000000000000 0000000000000000 ffff880854dfbf48
[  272.063724]  ffffffff815ed4e8 9ff7536847e8e0c3 0000000000000000 0000000000000000
[  272.072027] Call Trace:
[  272.074761]  [<ffffffff815ed4e8>] start_secondary+0x254/0x256
[  272.081172] Code: 66 90 fb 66 66 90 66 66 90 49 8b 87 38 e0 ff ff a8 08 75 1b
65 48 8b 14 25 f0 c6 00 00 0f 1f 44 00 00 f3 90 48 8b 82 38 e0 ff ff <a8> 08 74
f3 65 8b 04 25 1c b0 00 00 89 45 d4 66 66 66 66 90 e8
[  272.102935] NMI backtrace for cpu 60
[  272.106923] CPU: 60 PID: 0 Comm: swapper/60 Not tainted 3.10.0-rc4+ #2
[  272.114205] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS
QSSC-S4R.QCI.01.00.T030.072620111404 07/26/2011
[  272.124586] task: ffff880854df2c80 ti: ffff880854dfc000 task.ti:
ffff880854dfc000
[  272.132932] RIP: 0010:[<ffffffff810b0432>]  [<ffffffff810b0432>]
cpu_startup_entry+0x132/0x230
[  272.142552] RSP: 0018:ffff880854dfdef8  EFLAGS: 00000246
[  272.148474] RAX: 0000000400000000 RBX: ffff880854dfdfd8 RCX: 0100000000000000
[  272.156432] RDX: ffff880854dfdfd8 RSI: 0000000000000000 RDI: 0000000000000086
[  272.164390] RBP: ffff880854dfdf30 R08: 0000000000000000 R09: 000000000016360c
[  272.172349] R10: 0000000000000000 R11: 0000000000000079 R12: ffff880854dfdfd8
[  272.180308] R13: ffff880854dfdfd8 R14: ffff880854dfdfd8 R15: ffff880854dfdfd8
[  272.188267] FS:  0000000000000000(0000) GS:ffff88085fb80000(0000)
knlGS:0000000000000000
[  272.197293] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  272.203700] CR2: 00007f3caa7f13cc CR3: 00000000018f8000 CR4: 00000000000007e0
[  272.211658] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  272.219616] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  272.227574] Stack:
[  272.229815]  0000000000000000 0000003c00000000 0000000000000000 0000000000000000
[  272.238107]  0000000000000000 0000000000000000 0000000000000000 ffff880854dfdf48
[  272.246403]  ffffffff815ed4e8 ef21e67e86cacec4 0000000000000000 0000000000000000
[  272.254697] Call Trace:
[  272.257429]  [<ffffffff815ed4e8>] start_secondary+0x254/0x256
[  272.263837] Code: 00 89 45 d4 66 66 66 66 90 fb 66 66 90 66 66 90 49 8b 87 38
e0 ff ff a8 08 75 1b 65 48 8b 14 25 f0 c6 00 00 0f 1f 44 00 00 f3 90 <48> 8b 82
38 e0 ff ff a8 08 74 f3 65 8b 04 25 1c b0 00 00 89 45
[  272.285528] NMI backtrace for cpu 61
[  272.289521] CPU: 61 PID: 0 Comm: swapper/61 Not tainted 3.10.0-rc4+ #2
[  272.296802] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS
QSSC-S4R.QCI.01.00.T030.072620111404 07/26/2011
[  272.307185] task: ffff880854df37a0 ti: ffff880854dfe000 task.ti:
ffff880854dfe000
[  272.315533] RIP: 0010:[<ffffffff810b0439>]  [<ffffffff810b0439>]
cpu_startup_entry+0x139/0x230
[  272.325158] RSP: 0018:ffff880854dffef8  EFLAGS: 00000246
[  272.331085] RAX: 0000000400000000 RBX: ffff880854dfffd8 RCX: 0100000000000000
[  272.339045] RDX: ffff880854dfffd8 RSI: 0000000000000000 RDI: 0000000000000086
[  272.347006] RBP: ffff880854dfff30 R08: 0000000000000000 R09: 000000000002c119
[  272.354968] R10: 0000000000000000 R11: 0000000000016e79 R12: ffff880854dfffd8
[  272.362927] R13: ffff880854dfffd8 R14: ffff880854dfffd8 R15: ffff880854dfffd8
[  272.370888] FS:  0000000000000000(0000) GS:ffff880c6fbc0000(0000)
knlGS:0000000000000000
[  272.379916] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  272.386326] CR2: 00007f2437ca2ac0 CR3: 00000000018f8000 CR4: 00000000000007e0
[  272.394287] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  272.402248] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  272.410208] Stack:
[  272.412450]  0000000000000000 0000003d00000000 0000000000000000 0000000000000000
[  272.420750]  0000000000000000 0000000000000000 0000000000000000 ffff880854dfff48
[  272.429050]  ffffffff815ed4e8 d03ef77c0ca42f8a 0000000000000000 0000000000000000
[  272.437353] Call Trace:
[  272.440086]  [<ffffffff815ed4e8>] start_secondary+0x254/0x256
[  272.446495] Code: 66 90 fb 66 66 90 66 66 90 49 8b 87 38 e0 ff ff a8 08 75 1b
65 48 8b 14 25 f0 c6 00 00 0f 1f 44 00 00 f3 90 48 8b 82 38 e0 ff ff <a8> 08 74
f3 65 8b 04 25 1c b0 00 00 89 45 d4 66 66 66 66 90 e8
[  272.468273] NMI backtrace for cpu 62
[  272.472264] CPU: 62 PID: 0 Comm: swapper/62 Not tainted 3.10.0-rc4+ #2
[  272.479547] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS
QSSC-S4R.QCI.01.00.T030.072620111404 07/26/2011
[  272.489931] task: ffff880854df42c0 ti: ffff880854e00000 task.ti:
ffff880854e00000
[  272.498279] RIP: 0010:[<ffffffff810b0439>]  [<ffffffff810b0439>]
cpu_startup_entry+0x139/0x230
[  272.507904] RSP: 0018:ffff880854e01ef8  EFLAGS: 00000246
[  272.513830] RAX: 0000000400000000 RBX: ffff880854e01fd8 RCX: 0100000000000000
[  272.521789] RDX: ffff880854e01fd8 RSI: 0000000000000000 RDI: 0000000000000086
[  272.529749] RBP: ffff880854e01f30 R08: 0000000000000000 R09: 000000000016ba67
[  272.537708] R10: 0000000000000001 R11: 0000000000000a7a R12: ffff880854e01fd8
[  272.545667] R13: ffff880854e01fd8 R14: ffff880854e01fd8 R15: ffff880854e01fd8
[  272.553628] FS:  0000000000000000(0000) GS:ffff88085fbc0000(0000)
knlGS:0000000000000000
[  272.562653] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  272.569063] CR2: 00007f3caa7f13cc CR3: 00000000018f8000 CR4: 00000000000007e0
[  272.577022] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  272.584982] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  272.592940] Stack:
[  272.595183]  0000000000000000 0000003e00000000 0000000000000000 0000000000000000
[  272.603479]  0000000000000000 0000000000000000 0000000000000000 ffff880854e01f48
[  272.611776]  ffffffff815ed4e8 c4c458214bdad6c7 0000000000000000 0000000000000000
[  272.620078] Call Trace:
[  272.622812]  [<ffffffff815ed4e8>] start_secondary+0x254/0x256
[  272.629222] Code: 66 90 fb 66 66 90 66 66 90 49 8b 87 38 e0 ff ff a8 08 75 1b
65 48 8b 14 25 f0 c6 00 00 0f 1f 44 00 00 f3 90 48 8b 82 38 e0 ff ff <a8> 08 74
f3 65 8b 04 25 1c b0 00 00 89 45 d4 66 66 66 66 90 e8
[  272.651061] NMI backtrace for cpu 63
[  272.655049] CPU: 63 PID: 0 Comm: swapper/63 Not tainted 3.10.0-rc4+ #2
[  272.662331] Hardware name: QCI QSSC-S4R/QSSC-S4R, BIOS
QSSC-S4R.QCI.01.00.T030.072620111404 07/26/2011
[  272.672714] task: ffff880854df4de0 ti: ffff880854e02000 task.ti:
ffff880854e02000
[  272.681062] RIP: 0010:[<ffffffff812f3c82>]  [<ffffffff812f3c82>]
delay_tsc+0x32/0x80
[  272.689720] RSP: 0018:ffff88106f3c3dd0  EFLAGS: 00000083
[  272.695647] RAX: 000000000000009e RBX: 00000000cea08f3d RCX: 0000000000000001
[  272.703607] RDX: 00000000cea08fdb RSI: 0000000000000050 RDI: 00000000001e7000
[  272.711569] RBP: ffff88106f3c3de8 R08: ffffffff81a02928 R09: 000000000000070e
[  272.719529] R10: 0000000000000000 R11: ffff88106f3c3b46 R12: 00000000001e7000
[  272.727491] R13: 000000000000003f R14: ffff88106f3cec80 R15: ffffffff81949480
[  272.735452] FS:  0000000000000000(0000) GS:ffff88106f3c0000(0000)
knlGS:0000000000000000
[  272.744470] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  272.750879] CR2: 00007f114a8f7920 CR3: 0000000c61b5f000 CR4: 00000000000007e0
[  272.758841] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  272.766801] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  272.774759] Stack:
[  272.777001]  0000000000002710 ffffffff81949300 ffffffff81949000 ffff88106f3c3df8
[  272.785303]  ffffffff812f3be8 ffff88106f3c3e10 ffffffff81036faa ffffffff81a02ba0
[  272.793605]  ffff88106f3c3e70 ffffffff810f8060 0000000354df4de0 0000000000000242
[  272.801908] Call Trace:
[  272.804634]  <IRQ>
[  272.806782]  [<ffffffff812f3be8>] __const_udelay+0x28/0x30
[  272.813122]  [<ffffffff81036faa>] arch_trigger_all_cpu_backtrace+0x7a/0xa0
[  272.820799]  [<ffffffff810f8060>] rcu_check_callbacks+0x5b0/0x600
[  272.827603]  [<ffffffff81070217>] update_process_times+0x47/0x80
[  272.834313]  [<ffffffff810b94f5>] tick_sched_handle.isra.15+0x25/0x60
[  272.841500]  [<ffffffff810b9571>] tick_sched_timer+0x41/0x60
[  272.847821]  [<ffffffff81087c74>] __run_hrtimer+0x74/0x1d0
[  272.853943]  [<ffffffff810b9530>] ? tick_sched_handle.isra.15+0x60/0x60
[  272.861325]  [<ffffffff81088457>] hrtimer_interrupt+0xf7/0x240
[  272.867841]  [<ffffffff8160e429>] smp_apic_timer_interrupt+0x69/0x9c
[  272.874933]  [<ffffffff8160d29d>] apic_timer_interrupt+0x6d/0x80
[  272.881634]  <EOI>
[  272.883781]  [<ffffffff810b0432>] ? cpu_startup_entry+0x132/0x230
[  272.890803]  [<ffffffff810b0400>] ? cpu_startup_entry+0x100/0x230
[  272.897605]  [<ffffffff815ed4e8>] start_secondary+0x254/0x256
[  272.904014] Code: 89 e5 41 55 41 54 41 89 fc 53 65 44 8b 2c 25 1c b0 00 00 66
66 90 0f ae e8 e8 5b 46 d2 ff 66 90 89 c3 eb 14 0f 1f 44 00 00 f3 90 <65> 8b 04
25 1c b0 00 00 41 39 c5 75 1d 66 66 90 0f ae e8 e8 36
[-- MARK -- Thu Jun 27 15:25:00 2013]

