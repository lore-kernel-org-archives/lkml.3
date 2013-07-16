Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933865Ab3GPT3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:29:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933705Ab3GPT3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:29:13 -0400
Date: Tue, 16 Jul 2013 20:32:08 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
Message-ID: <20130716183207.GA6402@dhcp-26-207.brq.redhat.com>
References: <cover.1369155164.git.agordeev@redhat.com>
 <20130521235003.GE6985@mtj.dyndns.org>
 <20130522143923.GD19383@dhcp-26-207.brq.redhat.com>
 <20130522170305.GD9563@kernel.dk>
 <20130711102630.GA11133@dhcp-26-207.brq.redhat.com>
 <1373583637.7397.370.camel@haakon3.risingtidesystems.com>
 <20130712074559.GA8727@dhcp-26-207.brq.redhat.com>
 <1373692812.7397.625.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <1373692812.7397.625.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2013 at 10:20:12PM -0700, Nicholas A. Bellinger wrote:
> On Fri, 2013-07-12 at 09:46 +0200, Alexander Gordeev wrote:
> > > > diff --git a/drivers/scsi/scsi-mq.c b/drivers/scsi/scsi-mq.c
> > > > index ca6ff67..d8cc7a4 100644
> > > > --- a/drivers/scsi/scsi-mq.c
> > > > +++ b/drivers/scsi/scsi-mq.c
> > > > @@ -155,6 +155,7 @@ void scsi_mq_done(struct scsi_cmnd *sc)
> > > >  static struct blk_mq_ops scsi_mq_ops = {
> > > >  	.queue_rq	= scsi_mq_queue_rq,
> > > >  	.map_queue	= blk_mq_map_queue,
> > > > +	.timeout	= scsi_times_out,
> > > >  	.alloc_hctx	= blk_mq_alloc_single_hw_queue,
> > > >  	.free_hctx	= blk_mq_free_single_hw_queue,
> > > >  };
> 
> So your actually triggering a blk-mq timeout with ata_piix..?

No.
That is to avoid a NULL-pointer assignment from ->timeout elsewhere.
In fact I return -ENODEV for sr_probe() to not hit it.

> That is why scsi-mq still uses blk_execute_rq() for this reason, and
> this will need be addressed in order to safely use blk_mq_execute_rq()
> in the above context.

Got it.

> Do you have an OOPs backtrace handy to post w/o the last two changes in
> place..?

Attaching the output. No oops actually (due to aforementioned .timeout).

> I *very* much recommend doing the same if at all possible for ata_piix
> scsi-mq development + testing, as you'll want to be very careful when
> using a real file-system on top of this early alpha code.

Thank you for the warning.
Getting to writing CDBs would be of success :)

> --nab
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="output_for_nab.txt"

Loading Fedora (3.10.0-rc5.nab+)
Loading initial ramdisk ...
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.0-rc5.nab+ (agordeev@dhcp47-148.lab.bos.redhat.com) (gcc version 4.7.2 20120921 (Red Hat 4.7.2-2) (GCC) ) #11 SMP Tue Jul 16 14:06:45 EDT 2013
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.10.0-rc5.nab+ root=/dev/mapper/vg_dhcp47--148-lv_root ro rd.md=0 rd.dm=0 KEYTABLE=us rd.lvm.lv=vg_dhcp47-148/lv_root console=ttyS0,115200 SYSFONT=True rd.luks=0 rd.lvm.lv=vg_dhcp47-148/lv_swap LANG=en_US.UTF-8 debug
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009bfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009c000-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000008bd5cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000008bd5d000-0x000000008be4efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008be4f000-0x000000008c26dfff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008c26e000-0x000000008d66dfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008d66e000-0x000000008f601fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008f602000-0x000000008f64efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008f64f000-0x000000008f6e1fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008f6e2000-0x000000008f6ecfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008f6ed000-0x000000008f6effff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008f6f0000-0x000000008f7cefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008f7cf000-0x000000008f7fffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008f800000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000a0000000-0x00000000afffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000fcffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000046fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI: Cisco Systems Inc R210-2121605W/R210-2121605W, BIOS C200.1.4.3j.0.020720132258 02/07/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x470000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFF0000000 write-back
[    0.000000]   2 base 0100000000 mask FF00000000 write-back
[    0.000000]   3 base 0200000000 mask FE00000000 write-back
[    0.000000]   4 base 0400000000 mask FFC0000000 write-back
[    0.000000]   5 base 0440000000 mask FFE0000000 write-back
[    0.000000]   6 base 0460000000 mask FFF0000000 write-back
[    0.000000]   7 base 00B0000000 mask FFFF000000 write-combining
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0x8bd5d max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fc640-0x000fc64f] mapped at [ffff8800000fc640]
[    0.000000] Base memory trampoline at [ffff880000095000] 95000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fba000, 0x01fbafff] PGTABLE
[    0.000000] BRK [0x01fbb000, 0x01fbbfff] PGTABLE
[    0.000000] BRK [0x01fbc000, 0x01fbcfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x46fe00000-0x46fffffff]
[    0.000000]  [mem 0x46fe00000-0x46fffffff] page 2M
[    0.000000] BRK [0x01fbd000, 0x01fbdfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x46c000000-0x46fdfffff]
[    0.000000]  [mem 0x46c000000-0x46fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x46bffffff]
[    0.000000]  [mem 0x400000000-0x43fffffff] page 1G
[    0.000000]  [mem 0x440000000-0x46bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x8bd5cfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0x8bbfffff] page 2M
[    0.000000]  [mem 0x8bc00000-0x8bd5cfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 1G
[    0.000000] RAMDISK: [mem 0x363ca000-0x371dcfff]
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02 Cisco0)
[    0.000000] ACPI: XSDT 000000008f7fe120 000A4 (v01 Cisco0 CiscoUCS 00000000      01000013)
[    0.000000] ACPI: FACP 000000008f7fc000 000F4 (v04 Cisco0 CiscoUCS 00000000 MSFT 0100000D)
[    0.000000] ACPI: DSDT 000000008f7f6000 05EC4 (v02 Cisco0 CiscoUCS 00000003 MSFT 0100000D)
[    0.000000] ACPI: FACS 000000008f6f0000 00040
[    0.000000] ACPI: APIC 000000008f7f5000 001A8 (v02 Cisco0 CiscoUCS 00000000 MSFT 0100000D)
[    0.000000] ACPI: MCFG 000000008f7f4000 0003C (v01 Cisco0 CiscoUCS 00000001 MSFT 0100000D)
[    0.000000] ACPI: HPET 000000008f7f3000 00038 (v01 Cisco0 CiscoUCS 00000001 MSFT 0100000D)
[    0.000000] ACPI: SLIT 000000008f7f2000 00030 (v01 Cisco0 CiscoUCS 00000001 MSFT 0100000D)
[    0.000000] ACPI: SRAT 000000008f7f1000 00430 (v02 Cisco0 CiscoUCS 00000001 MSFT 0100000D)
[    0.000000] ACPI: SPCR 000000008f7f0000 00050 (v01 Cisco0 CiscoUCS 00000000 MSFT 0100000D)
[    0.000000] ACPI: WDDT 000000008f7ef000 00040 (v01 Cisco0 CiscoUCS 00000000 MSFT 0100000D)
[    0.000000] ACPI: SSDT 000000008f7d4000 1AFC4 (v02  Cisco SSDT  PM 00004000 INTL 20090730)
[    0.000000] ACPI: SSDT 000000008f7d3000 001D8 (v02  Cisco IPMI     00004000 INTL 20090730)
[    0.000000] ACPI: SSDT 000000008f7d2000 00962 (v02 CISCO  PMETER   00004000 INTL 20090730)
[    0.000000] ACPI: HEST 000000008f7d0000 000A8 (v01 Cisco  CiscoTbl 00000001 CISC 00000001)
[    0.000000] ACPI: BERT 000000008f7cf000 00030 (v01 Cisco  CiscoTbl 00000001 CISC 00000001)
[    0.000000] ACPI: ERST 000000008f6ef000 00230 (v01 Cisco  CiscoTbl 00000001 CISC 00000001)
[    0.000000] ACPI: EINJ 000000008f6ee000 00130 (v01 Cisco  CiscoTbl 00000001 CISC 00000001)
[    0.000000] ACPI: DMAR 000000008f6ed000 001A8 (v01 Cisco0 CiscoUCS 00000001 MSFT 0100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x8fffffff]
[    0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x26fffffff]
[    0.000000] SRAT: Node 1 PXM 1 [mem 0x270000000-0x46fffffff]
[    0.000000] NUMA: Initialized distance table, cnt=2
[    0.000000] NUMA: Node 0 [mem 0x00000000-0x8fffffff] + [mem 0x100000000-0x26fffffff] -> [mem 0x00000000-0x26fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x26fffffff]
[    0.000000]   NODE_DATA [mem 0x26ffec000-0x26fffffff]
[    0.000000] Initmem setup node 1 [mem 0x270000000-0x46fffffff]
[    0.000000]   NODE_DATA [mem 0x46ffe9000-0x46fffcfff]
[    0.000000]  [ffffea0000000000-ffffea0009bfffff] PMD -> [ffff880267e00000-ffff88026fdfffff] on node 0
[    0.000000]  [ffffea0009c00000-ffffea0011bfffff] PMD -> [ffff880467600000-ffff88046f5fffff] on node 1
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x46fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0x8bd5cfff]
[    0.000000]   node   0: [mem 0x100000000-0x26fffffff]
[    0.000000]   node   1: [mem 0x270000000-0x46fffffff]
[    0.000000] On node 0 totalpages: 2079992
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 8886 pages used for memmap
[    0.000000]   DMA32 zone: 568669 pages, LIFO batch:31
[    0.000000]   Normal zone: 23552 pages used for memmap
[    0.000000]   Normal zone: 1507328 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   Normal zone: 32768 pages used for memmap
[    0.000000]   Normal zone: 2097152 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x32] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x34] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x21] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x23] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x13] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x33] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x15] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x35] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0xff] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0xff] disabled)
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
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec90000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec90000, GSI 24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a401 base: 0xfed00000
[    0.000000] smpboot: Allowing 24 CPUs, 8 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 000000008bd5d000 - 000000008be4f000
[    0.000000] PM: Registered nosave memory: 000000008be4f000 - 000000008c26e000
[    0.000000] PM: Registered nosave memory: 000000008c26e000 - 000000008d66e000
[    0.000000] PM: Registered nosave memory: 000000008d66e000 - 000000008f602000
[    0.000000] PM: Registered nosave memory: 000000008f602000 - 000000008f64f000
[    0.000000] PM: Registered nosave memory: 000000008f64f000 - 000000008f6e2000
[    0.000000] PM: Registered nosave memory: 000000008f6e2000 - 000000008f6ed000
[    0.000000] PM: Registered nosave memory: 000000008f6ed000 - 000000008f6f0000
[    0.000000] PM: Registered nosave memory: 000000008f6f0000 - 000000008f7cf000
[    0.000000] PM: Registered nosave memory: 000000008f7cf000 - 000000008f800000
[    0.000000] PM: Registered nosave memory: 000000008f800000 - 0000000090000000
[    0.000000] PM: Registered nosave memory: 0000000090000000 - 00000000a0000000
[    0.000000] PM: Registered nosave memory: 00000000a0000000 - 00000000b0000000
[    0.000000] PM: Registered nosave memory: 00000000b0000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fd000000
[    0.000000] PM: Registered nosave memory: 00000000fd000000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] e820: [mem 0xb0000000-0xfbffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 nr_cpu_ids:24 nr_node_ids:2
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880267c00000 s81216 r8192 d21184 u131072
[    0.000000] pcpu-alloc: s81216 r8192 d21184 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 02 04 06 08 10 12 14 16 18 20 22 -- -- -- -- 
[    0.000000] pcpu-alloc: [1] 01 03 05 07 09 11 13 15 17 19 21 23 -- -- -- -- 
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 4111852
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.10.0-rc5.nab+ root=/dev/mapper/vg_dhcp47--148-lv_root ro rd.md=0 rd.dm=0 KEYTABLE=us rd.lvm.lv=vg_dhcp47-148/lv_root console=ttyS0,115200 SYSFONT=True rd.luks=0 rd.lvm.lv=vg_dhcp47-148/lv_swap LANG=en_US.UTF-8 debug
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16346740k/18612224k available (6396k kernel code, 1903648k absent, 361836k reserved, 6834k data, 1312k init)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=24, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=24.
[    0.000000] NR_IRQS:8448 nr_irqs:1280 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Enabling automatic NUMA balancing. Configure with numa_balancing= or sysctl
[    0.000000] hpet clockevent registered
[    0.001000] tsc: Fast TSC calibration using PIT
[    0.002000] tsc: Detected 2400.120 MHz processor
[    0.000006] Calibrating delay loop (skipped), value calculated using timer frequency.. 4800.24 BogoMIPS (lpj=2400120)
[    0.011880] pid_max: default: 32768 minimum: 301
[    0.017103] Security Framework initialized
[    0.021690] SELinux:  Initializing.
[    0.025604] SELinux:  Starting in permissive mode
[    0.032441] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.044914] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.054586] Mount-cache hash table entries: 256
[    0.059896] Initializing cgroup subsys memory
[    0.064787] Initializing cgroup subsys devices
[    0.069754] Initializing cgroup subsys freezer
[    0.074720] Initializing cgroup subsys net_cls
[    0.079686] Initializing cgroup subsys blkio
[    0.084459] Initializing cgroup subsys perf_event
[    0.089749] CPU: Physical Processor ID: 0
[    0.094230] CPU: Processor Core ID: 0
[    0.098326] mce: CPU supports 9 MCE banks
[    0.102814] CPU0: Thermal monitoring enabled (TM1)
[    0.108176] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.108176] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.108176] tlb_flushall_shift: 6
[    0.124388] Freeing SMP alternatives: 24k freed
[    0.129457] ACPI: Core revision 20130328
[    0.146166] ACPI: All ACPI Tables successfully acquired
[    0.157144] ftrace: allocating 24325 entries in 96 pages
[    0.175780] dmar: Host address width 40
[    0.180071] dmar: DRHD base: 0x000000fe710000 flags: 0x1
[    0.186014] dmar: IOMMU 0: reg_base_addr fe710000 ver 1:0 cap c90780106f0462 ecap f020fe
[    0.195056] dmar: RMRR base: 0x0000008f62f000 end: 0x0000008f631fff
[    0.202061] dmar: RMRR base: 0x0000008f61a000 end: 0x0000008f61afff
[    0.209065] dmar: RMRR base: 0x0000008f617000 end: 0x0000008f617fff
[    0.216068] dmar: RMRR base: 0x0000008f614000 end: 0x0000008f614fff
[    0.223072] dmar: RMRR base: 0x0000008f611000 end: 0x0000008f611fff
[    0.230077] dmar: RMRR base: 0x0000008f60e000 end: 0x0000008f60efff
[    0.237082] dmar: RMRR base: 0x0000008f60b000 end: 0x0000008f60bfff
[    0.244085] dmar: RMRR base: 0x0000008f608000 end: 0x0000008f608fff
[    0.251089] dmar: RMRR base: 0x0000008f605000 end: 0x0000008f605fff
[    0.258195] IOAPIC id 8 under DRHD base  0xfe710000 IOMMU 0
[    0.264407] IOAPIC id 9 under DRHD base  0xfe710000 IOMMU 0
[    0.270820] Enabled IRQ remapping in xapic mode
[    0.275886] Switched APIC routing to physical flat.
[    0.281928] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.298646] smpboot: CPU0: Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz (fam: 06, model: 2c, stepping: 02)
[    0.411839] Performance Events: PEBS fmt1+, 16-deep LBR, Westmere events, Intel PMU driver.
[    0.421215] perf_event_intel: CPUID marked event: 'bus cycles' unavailable
[    0.428893] ... version:                3
[    0.433367] ... bit width:              48
[    0.437940] ... generic registers:      4
[    0.442416] ... value mask:             0000ffffffffffff
[    0.448347] ... max period:             000000007fffffff
[    0.454279] ... fixed-purpose events:   3
[    0.458755] ... event mask:             000000070000000f
[    0.466272] smpboot: Booting Node   1, Processors  #1[    0.562463] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
 OK
[    0.571999] smpboot: Booting Node   0, Processors  #2 OK
[    0.591330] smpboot: Booting Node   1, Processors  #3 OK
[    0.610596] smpboot: Booting Node   0, Processors  #4 OK
[    0.629920] smpboot: Booting Node   1, Processors  #5 OK
[    0.649202] smpboot: Booting Node   0, Processors  #6 OK
[    0.668532] smpboot: Booting Node   1, Processors  #7 OK
[    0.687810] smpboot: Booting Node   0, Processors  #8 OK
[    0.707145] smpboot: Booting Node   1, Processors  #9 OK
[    0.726403] smpboot: Booting Node   0, Processors  #10 OK
[    0.745806] smpboot: Booting Node   1, Processors  #11 OK
[    0.765195] smpboot: Booting Node   0, Processors  #12 OK
[    0.784617] smpboot: Booting Node   1, Processors  #13 OK
[    0.803988] smpboot: Booting Node   0, Processors  #14 OK
[    0.823413] smpboot: Booting Node   1, Processors  #15
[    0.842210] Brought up 16 CPUs
[    0.845824] smpboot: Total of 16 processors activated (76801.07 BogoMIPS)
[    0.870916] devtmpfs: initialized
[    0.874904] PM: Registering ACPI NVS region [mem 0x8bd5d000-0x8be4efff] (991232 bytes)
[    0.883778] PM: Registering ACPI NVS region [mem 0x8c26e000-0x8d66dfff] (20971520 bytes)
[    0.893458] PM: Registering ACPI NVS region [mem 0x8f6e2000-0x8f6ecfff] (45056 bytes)
[    0.902205] PM: Registering ACPI NVS region [mem 0x8f6f0000-0x8f7cefff] (913408 bytes)
[    0.912322] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.920026] RTC time: 14:17:10, date: 07/16/13
[    0.925053] NET: Registered protocol family 16
[    0.930189] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.938647] ACPI: bus type PCI registered
[    0.943123] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.950399] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xa0000000-0xafffffff] (base 0xa0000000)
[    0.960797] PCI: MMCONFIG at [mem 0xa0000000-0xafffffff] reserved in E820
[    0.991889] PCI: Using configuration type 1 for base access
[    0.999361] bio: create slab <bio-0> at 0
[    1.004097] ACPI: Added _OSI(Module Device)
[    1.008770] ACPI: Added _OSI(Processor Device)
[    1.013734] ACPI: Added _OSI(3.0 _SCP Extensions)
[    1.018988] ACPI: Added _OSI(Processor Aggregator Device)
[    1.026534] ACPI: EC: Look up EC in DSDT
[    1.052643] ACPI: Interpreter enabled
[    1.056728] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
[    1.067052] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
[    1.077376] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S3_] (20130328/hwxface-568)
[    1.087701] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] (20130328/hwxface-568)
[    1.098029] ACPI: (supports S0 S5)
[    1.101827] ACPI: Using IOAPIC for interrupt routing
[    1.107414] HEST: Table parsing has been initialized.
[    1.113056] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.131160] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fd])
[    1.138489] acpi PNP0A08:00: ignoring host bridge window [mem 0x000c4000-0x000cbfff] (conflicts with Video ROM [mem 0x000c0000-0x000c7fff])
[    1.152629] PCI host bridge to bus 0000:00
[    1.157204] pci_bus 0000:00: root bus resource [bus 00-fd]
[    1.163332] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    1.170236] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    1.177139] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    1.184819] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfedfffff]
[    1.192499] pci_bus 0000:00: root bus resource [mem 0xb0000000-0xfdffffff]
[    1.200191] pci 0000:00:00.0: [8086:3406] type 00 class 0x060000
[    1.206952] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.213809] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    1.220570] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.227397] pci 0000:00:01.0: System wakeup disabled by ACPI
[    1.233751] pci 0000:00:02.0: [8086:3409] type 01 class 0x060400
[    1.240512] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    1.247373] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    1.254135] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.260963] pci 0000:00:03.0: System wakeup disabled by ACPI
[    1.267316] pci 0000:00:04.0: [8086:340b] type 01 class 0x060400
[    1.274075] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    1.280904] pci 0000:00:04.0: System wakeup disabled by ACPI
[    1.287257] pci 0000:00:05.0: [8086:340c] type 01 class 0x060400
[    1.294016] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    1.300845] pci 0000:00:05.0: System wakeup disabled by ACPI
[    1.307200] pci 0000:00:06.0: [8086:340d] type 01 class 0x060400
[    1.313960] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    1.320795] pci 0000:00:06.0: System wakeup disabled by ACPI
[    1.327150] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    1.333911] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.340750] pci 0000:00:07.0: System wakeup disabled by ACPI
[    1.347103] pci 0000:00:08.0: [8086:340f] type 01 class 0x060400
[    1.353863] pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
[    1.360695] pci 0000:00:08.0: System wakeup disabled by ACPI
[    1.367050] pci 0000:00:09.0: [8086:3410] type 01 class 0x060400
[    1.373811] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    1.380645] pci 0000:00:09.0: System wakeup disabled by ACPI
[    1.386994] pci 0000:00:0a.0: [8086:3411] type 01 class 0x060400
[    1.393744] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    1.400581] pci 0000:00:0a.0: System wakeup disabled by ACPI
[    1.406937] pci 0000:00:10.0: [8086:3425] type 00 class 0x080000
[    1.413778] pci 0000:00:10.1: [8086:3426] type 00 class 0x080000
[    1.420600] pci 0000:00:11.0: [8086:3427] type 00 class 0x080000
[    1.427436] pci 0000:00:11.1: [8086:3428] type 00 class 0x080000
[    1.434265] pci 0000:00:13.0: [8086:342d] type 00 class 0x080020
[    1.440984] pci 0000:00:13.0: reg 10: [mem 0xb2423000-0xb2423fff]
[    1.447833] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    1.454725] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    1.461561] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    1.468354] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    1.475189] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    1.482018] pci 0000:00:16.0: [8086:3430] type 00 class 0x088000
[    1.488739] pci 0000:00:16.0: reg 10: [mem 0xb2400000-0xb2403fff 64bit]
[    1.496222] pci 0000:00:16.1: [8086:3431] type 00 class 0x088000
[    1.502942] pci 0000:00:16.1: reg 10: [mem 0xb2404000-0xb2407fff 64bit]
[    1.510450] pci 0000:00:16.2: [8086:3432] type 00 class 0x088000
[    1.517170] pci 0000:00:16.2: reg 10: [mem 0xb2408000-0xb240bfff 64bit]
[    1.524685] pci 0000:00:16.3: [8086:3433] type 00 class 0x088000
[    1.531404] pci 0000:00:16.3: reg 10: [mem 0xb240c000-0xb240ffff 64bit]
[    1.538924] pci 0000:00:16.4: [8086:3429] type 00 class 0x088000
[    1.545645] pci 0000:00:16.4: reg 10: [mem 0xb2410000-0xb2413fff 64bit]
[    1.553167] pci 0000:00:16.5: [8086:342a] type 00 class 0x088000
[    1.559885] pci 0000:00:16.5: reg 10: [mem 0xb2414000-0xb2417fff 64bit]
[    1.567398] pci 0000:00:16.6: [8086:342b] type 00 class 0x088000
[    1.574117] pci 0000:00:16.6: reg 10: [mem 0xb2418000-0xb241bfff 64bit]
[    1.581639] pci 0000:00:16.7: [8086:342c] type 00 class 0x088000
[    1.588357] pci 0000:00:16.7: reg 10: [mem 0xb241c000-0xb241ffff 64bit]
[    1.595878] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    1.602627] pci 0000:00:1a.0: reg 20: [io  0x50c0-0x50df]
[    1.608742] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    1.615104] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    1.621853] pci 0000:00:1a.1: reg 20: [io  0x50a0-0x50bf]
[    1.627965] pci 0000:00:1a.1: System wakeup disabled by ACPI
[    1.634321] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    1.641069] pci 0000:00:1a.2: reg 20: [io  0x5080-0x509f]
[    1.647181] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    1.653546] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    1.660273] pci 0000:00:1a.7: reg 10: [mem 0xb2421000-0xb24213ff]
[    1.667162] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.674027] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    1.680384] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    1.687158] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.694019] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    1.700383] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    1.707157] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.714011] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    1.720371] pci 0000:00:1c.5: [8086:3a4a] type 01 class 0x060400
[    1.727145] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.734002] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    1.740363] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    1.747111] pci 0000:00:1d.0: reg 20: [io  0x5060-0x507f]
[    1.753234] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    1.759591] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    1.766339] pci 0000:00:1d.1: reg 20: [io  0x5040-0x505f]
[    1.772472] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    1.778829] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    1.785568] pci 0000:00:1d.2: reg 20: [io  0x5020-0x503f]
[    1.791691] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    1.798062] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    1.804790] pci 0000:00:1d.7: reg 10: [mem 0xb2420000-0xb24203ff]
[    1.811679] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.818557] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    1.824915] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    1.831718] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    1.838076] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    1.844858] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
[    1.853704] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    1.861668] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
[    1.870124] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    1.878582] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0600 (mask 003f)
[    1.887135] pci 0000:00:1f.2: [8086:3a20] type 00 class 0x01018f
[    1.893858] pci 0000:00:1f.2: reg 10: [io  0x5138-0x513f]
[    1.899893] pci 0000:00:1f.2: reg 14: [io  0x514c-0x514f]
[    1.905928] pci 0000:00:1f.2: reg 18: [io  0x5130-0x5137]
[    1.911964] pci 0000:00:1f.2: reg 1c: [io  0x5148-0x514b]
[    1.917999] pci 0000:00:1f.2: reg 20: [io  0x5110-0x511f]
[    1.924035] pci 0000:00:1f.2: reg 24: [io  0x5100-0x510f]
[    1.930182] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    1.936905] pci 0000:00:1f.3: reg 10: [mem 0xb2422000-0xb24220ff 64bit]
[    1.944310] pci 0000:00:1f.3: reg 20: [io  0x5000-0x501f]
[    1.950443] pci 0000:00:1f.5: [8086:3a26] type 00 class 0x010185
[    1.957167] pci 0000:00:1f.5: reg 10: [io  0x5128-0x512f]
[    1.963203] pci 0000:00:1f.5: reg 14: [io  0x5144-0x5147]
[    1.969238] pci 0000:00:1f.5: reg 18: [io  0x5120-0x5127]
[    1.975272] pci 0000:00:1f.5: reg 1c: [io  0x5140-0x5143]
[    1.981307] pci 0000:00:1f.5: reg 20: [io  0x50f0-0x50ff]
[    1.987342] pci 0000:00:1f.5: reg 24: [io  0x50e0-0x50ef]
[    1.993531] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.999131] pci 0000:00:02.0: PCI bridge to [bus 02]
[    2.004722] pci 0000:00:03.0: PCI bridge to [bus 03]
[    2.010319] pci 0000:00:04.0: PCI bridge to [bus 04]
[    2.015921] pci 0000:05:00.0: [10b5:8624] type 01 class 0x060400
[    2.022639] pci 0000:05:00.0: reg 10: [mem 0xb2300000-0xb231ffff]
[    2.029499] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    2.036635] pci 0000:00:05.0: PCI bridge to [bus 05-14]
[    2.042473] pci 0000:00:05.0:   bridge window [io  0x3000-0x4fff]
[    2.049272] pci 0000:00:05.0:   bridge window [mem 0xb1c00000-0xb23fffff]
[    2.056916] pci 0000:06:04.0: [10b5:8624] type 01 class 0x060400
[    2.063685] pci 0000:06:04.0: PME# supported from D0 D3hot D3cold
[    2.070542] pci 0000:06:05.0: [10b5:8624] type 01 class 0x060400
[    2.077311] pci 0000:06:05.0: PME# supported from D0 D3hot D3cold
[    2.084172] pci 0000:06:08.0: [10b5:8624] type 01 class 0x060400
[    2.090941] pci 0000:06:08.0: PME# supported from D0 D3hot D3cold
[    2.097803] pci 0000:05:00.0: PCI bridge to [bus 06-14]
[    2.103644] pci 0000:05:00.0:   bridge window [io  0x3000-0x4fff]
[    2.110451] pci 0000:05:00.0:   bridge window [mem 0xb1c00000-0xb22fffff]
[    2.118084] pci 0000:06:04.0: PCI bridge to [bus 07]
[    2.123688] pci 0000:06:05.0: PCI bridge to [bus 08]
[    2.129301] pci 0000:09:00.0: [10b5:8632] type 01 class 0x060400
[    2.136023] pci 0000:09:00.0: reg 10: [mem 0xb2200000-0xb221ffff]
[    2.142899] pci 0000:09:00.0: PME# supported from D0 D3hot D3cold
[    2.151136] pci 0000:06:08.0: PCI bridge to [bus 09-14]
[    2.156976] pci 0000:06:08.0:   bridge window [io  0x3000-0x4fff]
[    2.163786] pci 0000:06:08.0:   bridge window [mem 0xb1c00000-0xb22fffff]
[    2.171448] pci 0000:0a:01.0: [10b5:8632] type 01 class 0x060400
[    2.178228] pci 0000:0a:01.0: PME# supported from D0 D3hot D3cold
[    2.185094] pci 0000:0a:04.0: [10b5:8632] type 01 class 0x060400
[    2.191881] pci 0000:0a:04.0: PME# supported from D0 D3hot D3cold
[    2.198760] pci 0000:09:00.0: PCI bridge to [bus 0a-14]
[    2.204600] pci 0000:09:00.0:   bridge window [io  0x3000-0x4fff]
[    2.211408] pci 0000:09:00.0:   bridge window [mem 0xb1c00000-0xb21fffff]
[    2.219051] pci 0000:0a:01.0: PCI bridge to [bus 0b]
[    2.224681] pci 0000:0c:00.0: [1137:0023] type 01 class 0x060400
[    2.231479] pci 0000:0c:00.0: PME# supported from D0 D3hot D3cold
[    2.240201] pci 0000:0a:04.0: PCI bridge to [bus 0c-14]
[    2.246042] pci 0000:0a:04.0:   bridge window [io  0x3000-0x4fff]
[    2.252851] pci 0000:0a:04.0:   bridge window [mem 0xb1c00000-0xb21fffff]
[    2.260544] pci 0000:0d:00.0: [1137:0041] type 01 class 0x060400
[    2.267330] pci 0000:0d:00.0: reg 10: [mem 0xb2100000-0xb210ffff 64bit]
[    2.274816] pci 0000:0d:00.0: PME# supported from D0 D3hot D3cold
[    2.281696] pci 0000:0d:01.0: [1137:0041] type 01 class 0x060400
[    2.288549] pci 0000:0d:01.0: PME# supported from D0 D3hot D3cold
[    2.295442] pci 0000:0c:00.0: PCI bridge to [bus 0d-14]
[    2.301282] pci 0000:0c:00.0:   bridge window [io  0x3000-0x4fff]
[    2.308092] pci 0000:0c:00.0:   bridge window [mem 0xb1c00000-0xb21fffff]
[    2.315782] pci 0000:0e:00.0: [1137:0042] type 00 class 0x00ff00
[    2.322563] pci 0000:0e:00.0: reg 10: [mem 0xb2002000-0xb2002fff 64bit]
[    2.330008] pci 0000:0e:00.0: reg 18: [mem 0xb2000000-0xb2001fff 64bit]
[    2.337521] pci 0000:0e:00.0: reg 30: [mem 0xffff8000-0xffffffff pref]
[    2.344955] pci 0000:0d:00.0: PCI bridge to [bus 0e]
[    2.350505] pci 0000:0d:00.0:   bridge window [mem 0xb2000000-0xb20fffff]
[    2.358187] pci 0000:0f:00.0: [1137:0040] type 01 class 0x060400
[    2.365042] pci 0000:0f:00.0: PME# supported from D0 D3hot D3cold
[    2.371903] pci 0000:0d:01.0: PCI bridge to [bus 0f-14]
[    2.377742] pci 0000:0d:01.0:   bridge window [io  0x3000-0x4fff]
[    2.384553] pci 0000:0d:01.0:   bridge window [mem 0xb1c00000-0xb1ffffff]
[    2.392227] pci 0000:10:00.0: [1137:0041] type 01 class 0x060400
[    2.399075] pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
[    2.405948] pci 0000:10:01.0: [1137:0041] type 01 class 0x060400
[    2.412812] pci 0000:10:01.0: PME# supported from D0 D3hot D3cold
[    2.419685] pci 0000:10:02.0: [1137:0041] type 01 class 0x060400
[    2.426533] pci 0000:10:02.0: PME# supported from D0 D3hot D3cold
[    2.433419] pci 0000:10:03.0: [1137:0041] type 01 class 0x060400
[    2.440265] pci 0000:10:03.0: PME# supported from D0 D3hot D3cold
[    2.447158] pci 0000:0f:00.0: PCI bridge to [bus 10-14]
[    2.452996] pci 0000:0f:00.0:   bridge window [io  0x3000-0x4fff]
[    2.459796] pci 0000:0f:00.0:   bridge window [mem 0xb1c00000-0xb1ffffff]
[    2.467471] pci 0000:11:00.0: [1137:0043] type 00 class 0x020000
[    2.474260] pci 0000:11:00.0: reg 10: [mem 0xb1f00000-0xb1f07fff 64bit]
[    2.481714] pci 0000:11:00.0: reg 18: [mem 0xb1f08000-0xb1f09fff 64bit]
[    2.489155] pci 0000:11:00.0: reg 20: [io  0x4000-0x407f]
[    2.495286] pci 0000:11:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    2.502733] pci 0000:10:00.0: PCI bridge to [bus 11]
[    2.508281] pci 0000:10:00.0:   bridge window [io  0x4000-0x4fff]
[    2.515090] pci 0000:10:00.0:   bridge window [mem 0xb1f00000-0xb1ffffff]
[    2.522777] pci 0000:12:00.0: [1137:0043] type 00 class 0x020000
[    2.529564] pci 0000:12:00.0: reg 10: [mem 0xb1e00000-0xb1e07fff 64bit]
[    2.537016] pci 0000:12:00.0: reg 18: [mem 0xb1e08000-0xb1e09fff 64bit]
[    2.544460] pci 0000:12:00.0: reg 20: [io  0x3000-0x307f]
[    2.550591] pci 0000:12:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    2.558034] pci 0000:10:01.0: PCI bridge to [bus 12]
[    2.563584] pci 0000:10:01.0:   bridge window [io  0x3000-0x3fff]
[    2.570394] pci 0000:10:01.0:   bridge window [mem 0xb1e00000-0xb1efffff]
[    2.578083] pci 0000:13:00.0: [1137:0045] type 00 class 0x0c0400
[    2.584875] pci 0000:13:00.0: reg 10: [mem 0xb1d00000-0xb1d07fff 64bit]
[    2.592323] pci 0000:13:00.0: reg 18: [mem 0xb1d08000-0xb1d09fff 64bit]
[    2.600010] pci 0000:10:02.0: PCI bridge to [bus 13]
[    2.605561] pci 0000:10:02.0:   bridge window [mem 0xb1d00000-0xb1dfffff]
[    2.613255] pci 0000:14:00.0: [1137:0045] type 00 class 0x0c0400
[    2.620041] pci 0000:14:00.0: reg 10: [mem 0xb1c00000-0xb1c07fff 64bit]
[    2.627491] pci 0000:14:00.0: reg 18: [mem 0xb1c08000-0xb1c09fff 64bit]
[    2.635158] pci 0000:10:03.0: PCI bridge to [bus 14]
[    2.640708] pci 0000:10:03.0:   bridge window [mem 0xb1c00000-0xb1cfffff]
[    2.648476] pci 0000:00:06.0: PCI bridge to [bus 15]
[    2.654095] pci 0000:16:00.0: [1077:2432] type 00 class 0x0c0400
[    2.660816] pci 0000:16:00.0: reg 10: [io  0x2200-0x22ff]
[    2.666858] pci 0000:16:00.0: reg 14: [mem 0xb1b00000-0xb1b03fff 64bit]
[    2.674275] pci 0000:16:00.0: reg 30: [mem 0xfffc0000-0xffffffff pref]
[    2.681658] pci 0000:16:00.1: [1077:2432] type 00 class 0x0c0400
[    2.688379] pci 0000:16:00.1: reg 10: [io  0x2000-0x20ff]
[    2.694421] pci 0000:16:00.1: reg 14: [mem 0xb1b04000-0xb1b07fff 64bit]
[    2.701839] pci 0000:16:00.1: reg 30: [mem 0xfffc0000-0xffffffff pref]
[    2.709497] pci 0000:00:07.0: PCI bridge to [bus 16]
[    2.715035] pci 0000:00:07.0:   bridge window [io  0x2000-0x2fff]
[    2.721842] pci 0000:00:07.0:   bridge window [mem 0xb1b00000-0xb1bfffff]
[    2.729478] pci 0000:00:08.0: PCI bridge to [bus 17]
[    2.735072] pci 0000:00:09.0: PCI bridge to [bus 18]
[    2.740669] pci 0000:00:0a.0: PCI bridge to [bus 19]
[    2.746295] pci 0000:1a:00.0: [8086:10c9] type 00 class 0x020000
[    2.753018] pci 0000:1a:00.0: reg 10: [mem 0xb1960000-0xb197ffff]
[    2.759835] pci 0000:1a:00.0: reg 14: [mem 0xb1940000-0xb195ffff]
[    2.766652] pci 0000:1a:00.0: reg 18: [io  0x1020-0x103f]
[    2.772691] pci 0000:1a:00.0: reg 1c: [mem 0xb1a04000-0xb1a07fff]
[    2.779526] pci 0000:1a:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    2.786874] pci 0000:1a:00.0: PME# supported from D0 D3hot D3cold
[    2.793723] pci 0000:1a:00.0: reg 184: [mem 0xb1980000-0xb1983fff 64bit]
[    2.801229] pci 0000:1a:00.0: reg 190: [mem 0xb19a0000-0xb19a3fff 64bit]
[    2.808786] pci 0000:1a:00.1: [8086:10c9] type 00 class 0x020000
[    2.815500] pci 0000:1a:00.1: reg 10: [mem 0xb1920000-0xb193ffff]
[    2.822316] pci 0000:1a:00.1: reg 14: [mem 0xb1900000-0xb191ffff]
[    2.829133] pci 0000:1a:00.1: reg 18: [io  0x1000-0x101f]
[    2.835163] pci 0000:1a:00.1: reg 1c: [mem 0xb1a00000-0xb1a03fff]
[    2.841997] pci 0000:1a:00.1: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    2.849337] pci 0000:1a:00.1: PME# supported from D0 D3hot D3cold
[    2.856185] pci 0000:1a:00.1: reg 184: [mem 0xb19c0000-0xb19c3fff 64bit]
[    2.863692] pci 0000:1a:00.1: reg 190: [mem 0xb19e0000-0xb19e3fff 64bit]
[    2.872673] pci 0000:00:1c.0: PCI bridge to [bus 1a-1c]
[    2.878513] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    2.885322] pci 0000:00:1c.0:   bridge window [mem 0xb1900000-0xb1afffff]
[    2.892986] pci 0000:1d:00.0: [102b:0522] type 00 class 0x030000
[    2.899715] pci 0000:1d:00.0: reg 10: [mem 0xb0000000-0xb0ffffff pref]
[    2.907011] pci 0000:1d:00.0: reg 14: [mem 0xb1800000-0xb1803fff]
[    2.913829] pci 0000:1d:00.0: reg 18: [mem 0xb1000000-0xb17fffff]
[    2.920686] pci 0000:1d:00.0: reg 30: [mem 0xffff0000-0xffffffff pref]
[    2.929714] pci 0000:00:1c.4: PCI bridge to [bus 1d]
[    2.935264] pci 0000:00:1c.4:   bridge window [mem 0xb1000000-0xb18fffff]
[    2.942852] pci 0000:00:1c.4:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
[    2.951551] pci 0000:00:1c.5: PCI bridge to [bus 1e]
[    2.957175] pci 0000:00:1e.0: PCI bridge to [bus 1f] (subtractive decode)
[    2.964766] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    2.973609] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    2.982454] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    2.992074] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
[    3.001693] pci 0000:00:1e.0:   bridge window [mem 0xb0000000-0xfdffffff] (subtractive decode)
[    3.011408] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    3.018207] acpi PNP0A08:00: ACPI _OSC control (0x1d) granted
[    3.024769] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    3.033015] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    3.041259] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    3.049503] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    3.057750] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    3.067280] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    3.075520] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    3.085046] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    3.094830] acpi root: \_SB_.PCI0 notify handler is installed
[    3.101284] Found 1 acpi root devices
[    3.105475] ACPI: No dock devices found.
[    3.109940] vgaarb: device added: PCI:0000:1d:00.0,decodes=io+mem,owns=io+mem,locks=none
[    3.118980] vgaarb: loaded
[    3.122002] vgaarb: bridge control possible 0000:1d:00.0
[    3.128017] SCSI subsystem initialized
[    3.132204] ACPI: bus type ATA registered
[    3.136744] libata version 3.00 loaded.
[    3.141056] ACPI: bus type USB registered
[    3.145539] usbcore: registered new interface driver usbfs
[    3.151672] usbcore: registered new interface driver hub
[    3.157632] usbcore: registered new device driver usb
[    3.163406] PCI: Using ACPI for IRQ routing
[    3.173349] PCI: Discovered peer bus fe
[    3.177631] PCI: root bus fe: using default resources
[    3.183272] PCI: Probing PCI hardware (bus fe)
[    3.188259] PCI host bridge to bus 0000:fe
[    3.192834] pci_bus 0000:fe: root bus resource [io  0x0000-0xffff]
[    3.199739] pci_bus 0000:fe: root bus resource [mem 0x00000000-0xffffffffff]
[    3.207612] pci_bus 0000:fe: No busn resource found for root bus, will use [bus fe-ff]
[    3.216459] pci 0000:fe:00.0: [8086:2c70] type 00 class 0x060000
[    3.223212] pci 0000:fe:00.1: [8086:2d81] type 00 class 0x060000
[    3.229967] pci 0000:fe:02.0: [8086:2d90] type 00 class 0x060000
[    3.236718] pci 0000:fe:02.1: [8086:2d91] type 00 class 0x060000
[    3.243472] pci 0000:fe:02.2: [8086:2d92] type 00 class 0x060000
[    3.250222] pci 0000:fe:02.3: [8086:2d93] type 00 class 0x060000
[    3.256973] pci 0000:fe:02.4: [8086:2d94] type 00 class 0x060000
[    3.263723] pci 0000:fe:02.5: [8086:2d95] type 00 class 0x060000
[    3.270475] pci 0000:fe:03.0: [8086:2d98] type 00 class 0x060000
[    3.277226] pci 0000:fe:03.1: [8086:2d99] type 00 class 0x060000
[    3.283979] pci 0000:fe:03.2: [8086:2d9a] type 00 class 0x060000
[    3.290732] pci 0000:fe:03.4: [8086:2d9c] type 00 class 0x060000
[    3.297484] pci 0000:fe:04.0: [8086:2da0] type 00 class 0x060000
[    3.304232] pci 0000:fe:04.1: [8086:2da1] type 00 class 0x060000
[    3.310982] pci 0000:fe:04.2: [8086:2da2] type 00 class 0x060000
[    3.317724] pci 0000:fe:04.3: [8086:2da3] type 00 class 0x060000
[    3.324473] pci 0000:fe:05.0: [8086:2da8] type 00 class 0x060000
[    3.331220] pci 0000:fe:05.1: [8086:2da9] type 00 class 0x060000
[    3.337967] pci 0000:fe:05.2: [8086:2daa] type 00 class 0x060000
[    3.344715] pci 0000:fe:05.3: [8086:2dab] type 00 class 0x060000
[    3.351466] pci 0000:fe:06.0: [8086:2db0] type 00 class 0x060000
[    3.358212] pci 0000:fe:06.1: [8086:2db1] type 00 class 0x060000
[    3.364949] pci 0000:fe:06.2: [8086:2db2] type 00 class 0x060000
[    3.371687] pci 0000:fe:06.3: [8086:2db3] type 00 class 0x060000
[    3.378449] pci_bus 0000:fe: busn_res: [bus fe-ff] end is updated to fe
[    3.385841] PCI: Discovered peer bus ff
[    3.390124] PCI: root bus ff: using default resources
[    3.395763] PCI: Probing PCI hardware (bus ff)
[    3.400748] PCI host bridge to bus 0000:ff
[    3.405322] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    3.412226] pci_bus 0000:ff: root bus resource [mem 0x00000000-0xffffffffff]
[    3.420101] pci_bus 0000:ff: No busn resource found for root bus, will use [bus ff-ff]
[    3.428948] pci 0000:ff:00.0: [8086:2c70] type 00 class 0x060000
[    3.435690] pci 0000:ff:00.1: [8086:2d81] type 00 class 0x060000
[    3.442439] pci 0000:ff:02.0: [8086:2d90] type 00 class 0x060000
[    3.449183] pci 0000:ff:02.1: [8086:2d91] type 00 class 0x060000
[    3.455929] pci 0000:ff:02.2: [8086:2d92] type 00 class 0x060000
[    3.462666] pci 0000:ff:02.3: [8086:2d93] type 00 class 0x060000
[    3.469415] pci 0000:ff:02.4: [8086:2d94] type 00 class 0x060000
[    3.476160] pci 0000:ff:02.5: [8086:2d95] type 00 class 0x060000
[    3.482904] pci 0000:ff:03.0: [8086:2d98] type 00 class 0x060000
[    3.489650] pci 0000:ff:03.1: [8086:2d99] type 00 class 0x060000
[    3.496394] pci 0000:ff:03.2: [8086:2d9a] type 00 class 0x060000
[    3.503141] pci 0000:ff:03.4: [8086:2d9c] type 00 class 0x060000
[    3.509890] pci 0000:ff:04.0: [8086:2da0] type 00 class 0x060000
[    3.516631] pci 0000:ff:04.1: [8086:2da1] type 00 class 0x060000
[    3.523375] pci 0000:ff:04.2: [8086:2da2] type 00 class 0x060000
[    3.530123] pci 0000:ff:04.3: [8086:2da3] type 00 class 0x060000
[    3.536870] pci 0000:ff:05.0: [8086:2da8] type 00 class 0x060000
[    3.543615] pci 0000:ff:05.1: [8086:2da9] type 00 class 0x060000
[    3.550365] pci 0000:ff:05.2: [8086:2daa] type 00 class 0x060000
[    3.557114] pci 0000:ff:05.3: [8086:2dab] type 00 class 0x060000
[    3.563860] pci 0000:ff:06.0: [8086:2db0] type 00 class 0x060000
[    3.570605] pci 0000:ff:06.1: [8086:2db1] type 00 class 0x060000
[    3.577351] pci 0000:ff:06.2: [8086:2db2] type 00 class 0x060000
[    3.584098] pci 0000:ff:06.3: [8086:2db3] type 00 class 0x060000
[    3.590854] pci_bus 0000:ff: busn_res: [bus ff] end is updated to ff
[    3.597954] PCI: pci_cache_line_size set to 64 bytes
[    3.603770] e820: reserve RAM buffer [mem 0x0009c000-0x0009ffff]
[    3.610478] e820: reserve RAM buffer [mem 0x8bd5d000-0x8bffffff]
[    3.617275] NetLabel: Initializing
[    3.621064] NetLabel:  domain hash size = 128
[    3.625929] NetLabel:  protocols = UNLABELED CIPSOv4
[    3.631482] NetLabel:  unlabeled traffic allowed by default
[    3.637747] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    3.643534] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    3.652074] Switching to clocksource hpet
[    3.663947] pnp: PnP ACPI init
[    3.667378] ACPI: bus type PNP registered
[    3.671942] pnp 00:00: Plug and Play ACPI device, IDs PNP0003 (active)
[    3.679412] pnp 00:01: [dma 4]
[    3.682852] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    3.690190] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    3.697515] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    3.704839] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    3.712201] pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
[    3.719662] system 00:06: [io  0x0500-0x057f] could not be reserved
[    3.726664] system 00:06: [io  0x0400-0x047f] has been reserved
[    3.733271] system 00:06: [io  0x0800-0x081f] has been reserved
[    3.739885] system 00:06: [io  0x0ca2-0x0ca3] has been reserved
[    3.746490] system 00:06: [io  0x0600-0x063f] has been reserved
[    3.753108] system 00:06: [io  0x0880-0x0883] has been reserved
[    3.759723] system 00:06: [io  0x0ca4-0x0ca5] has been reserved
[    3.766339] system 00:06: [mem 0xfed1c000-0xfed3fffe] could not be reserved
[    3.774118] system 00:06: [mem 0xff000000-0xffffffff] could not be reserved
[    3.781897] system 00:06: [mem 0xfee00000-0xfeefffff] has been reserved
[    3.789288] system 00:06: [mem 0xfe900000-0xfe90001f] has been reserved
[    3.796678] system 00:06: [mem 0xfea00000-0xfea0001f] has been reserved
[    3.804068] system 00:06: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    3.811459] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    3.819214] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    3.826573] pnp 00:08: Plug and Play ACPI device, IDs IPI0001 (active)
[    3.833960] pnp: PnP ACPI: found 9 devices
[    3.838536] ACPI: bus type PNP unregistered
[    3.849623] pci 0000:0e:00.0: no compatible bridge window for [mem 0xffff8000-0xffffffff pref]
[    3.859248] pci 0000:11:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    3.868871] pci 0000:12:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    3.878495] pci 0000:16:00.0: no compatible bridge window for [mem 0xfffc0000-0xffffffff pref]
[    3.888117] pci 0000:16:00.1: no compatible bridge window for [mem 0xfffc0000-0xffffffff pref]
[    3.897743] pci 0000:1a:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    3.907366] pci 0000:1a:00.1: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    3.916987] pci 0000:1d:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    3.926649] pci 0000:06:05.0: bridge window [io  0x1000-0x0fff] to [bus 08] add_size 1000
[    3.935788] pci 0000:06:05.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 08] add_size 200000
[    3.946962] pci 0000:06:05.0: bridge window [mem 0x00100000-0x000fffff] to [bus 08] add_size 200000
[    3.957077] pci 0000:0a:01.0: bridge window [io  0x1000-0x0fff] to [bus 0b] add_size 1000
[    3.966216] pci 0000:0a:01.0: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 0b] add_size 200000
[    3.977392] pci 0000:0a:01.0: bridge window [mem 0x00100000-0x000fffff] to [bus 0b] add_size 200000
[    3.987624] pci 0000:0a:04.0: bridge window [mem 0x00100000-0x003fffff pref] to [bus 0c-14] add_size 200000
[    3.998515] pci 0000:0a:01.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    4.009593] pci 0000:0a:04.0: res[15]=[mem 0x00100000-0x003fffff pref] get_res_add_size add_size 200000
[    4.020089] pci 0000:09:00.0: bridge window [mem 0x00100000-0x003fffff pref] to [bus 0a-14] add_size 400000
[    4.030979] pci 0000:09:00.0: res[15]=[mem 0x00100000-0x003fffff pref] get_res_add_size add_size 400000
[    4.041475] pci 0000:06:08.0: bridge window [mem 0x00100000-0x003fffff pref] to [bus 09-14] add_size 400000
[    4.052355] pci 0000:06:05.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    4.063433] pci 0000:06:08.0: res[15]=[mem 0x00100000-0x003fffff pref] get_res_add_size add_size 400000
[    4.073929] pci 0000:05:00.0: bridge window [mem 0x00100000-0x003fffff pref] to [bus 06-14] add_size 600000
[    4.084808] pci 0000:05:00.0: res[15]=[mem 0x00100000-0x003fffff pref] get_res_add_size add_size 600000
[    4.095305] pci 0000:00:05.0: bridge window [mem 0x00100000-0x003fffff pref] to [bus 05-14] add_size 600000
[    4.106217] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x001fffff pref] to [bus 1a-1c] add_size 200000
[    4.117106] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to [bus 1d] add_size 1000
[    4.126248] pci 0000:00:1c.5: bridge window [io  0x1000-0x0fff] to [bus 1e] add_size 1000
[    4.135386] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 1e] add_size 200000
[    4.146562] pci 0000:00:1c.5: bridge window [mem 0x00100000-0x000fffff] to [bus 1e] add_size 200000
[    4.156690] pci 0000:00:05.0: res[15]=[mem 0x00100000-0x003fffff pref] get_res_add_size add_size 600000
[    4.167187] pci 0000:00:1c.0: res[15]=[mem 0x00100000-0x001fffff pref] get_res_add_size add_size 200000
[    4.177683] pci 0000:00:1c.5: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    4.187695] pci 0000:00:1c.5: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    4.198774] pci 0000:00:1c.4: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    4.207814] pci 0000:00:1c.5: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    4.216848] pci 0000:00:05.0: BAR 15: assigned [mem 0xb2500000-0xb2dfffff pref]
[    4.225015] pci 0000:00:07.0: BAR 15: assigned [mem 0xb2e00000-0xb2efffff pref]
[    4.233183] pci 0000:00:1c.0: BAR 15: assigned [mem 0xb2f00000-0xb31fffff pref]
[    4.241350] pci 0000:00:1c.5: BAR 14: assigned [mem 0xb3200000-0xb33fffff]
[    4.249024] pci 0000:00:1c.5: BAR 15: assigned [mem 0xb3400000-0xb35fffff 64bit pref]
[    4.257774] pci 0000:00:1c.4: BAR 13: assigned [io  0x6000-0x6fff]
[    4.264679] pci 0000:00:1c.5: BAR 13: assigned [io  0x7000-0x7fff]
[    4.271576] pci 0000:00:01.0: PCI bridge to [bus 01]
[    4.277131] pci 0000:00:02.0: PCI bridge to [bus 02]
[    4.282682] pci 0000:00:03.0: PCI bridge to [bus 03]
[    4.288235] pci 0000:00:04.0: PCI bridge to [bus 04]
[    4.293787] pci 0000:05:00.0: res[15]=[mem 0x00100000-0x003fffff pref] get_res_add_size add_size 600000
[    4.304283] pci 0000:05:00.0: BAR 15: assigned [mem 0xb2500000-0xb2dfffff pref]
[    4.312442] pci 0000:06:05.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    4.322455] pci 0000:06:05.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    4.333534] pci 0000:06:08.0: res[15]=[mem 0x00100000-0x003fffff pref] get_res_add_size add_size 400000
[    4.344029] pci 0000:06:05.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    4.353069] pci 0000:06:05.0: BAR 14: can't assign mem (size 0x200000)
[    4.360363] pci 0000:06:05.0: BAR 15: assigned [mem 0xb2500000-0xb26fffff 64bit pref]
[    4.369113] pci 0000:06:08.0: BAR 15: assigned [mem 0xb2700000-0xb2dfffff pref]
[    4.377281] pci 0000:06:05.0: BAR 13: can't assign io (size 0x1000)
[    4.384284] pci 0000:06:08.0: BAR 15: assigned [mem 0xb2500000-0xb27fffff pref]
[    4.392450] pci 0000:06:08.0: BAR 15: reassigned [mem 0xb2500000-0xb2bfffff pref]
[    4.400810] pci 0000:06:05.0: BAR 14: can't assign mem (size 0x200000)
[    4.408104] pci 0000:06:05.0: BAR 15: assigned [mem 0xb2c00000-0xb2dfffff 64bit pref]
[    4.416845] pci 0000:06:05.0: BAR 13: can't assign io (size 0x1000)
[    4.423848] pci 0000:06:04.0: PCI bridge to [bus 07]
[    4.429400] pci 0000:06:05.0: PCI bridge to [bus 08]
[    4.434949] pci 0000:06:05.0:   bridge window [mem 0xb2c00000-0xb2dfffff 64bit pref]
[    4.443606] pci 0000:09:00.0: res[15]=[mem 0x00100000-0x003fffff pref] get_res_add_size add_size 400000
[    4.454101] pci 0000:09:00.0: BAR 15: assigned [mem 0xb2500000-0xb2bfffff pref]
[    4.462269] pci 0000:0a:01.0: res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
[    4.472280] pci 0000:0a:01.0: res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size 200000
[    4.483358] pci 0000:0a:04.0: res[15]=[mem 0x00100000-0x003fffff pref] get_res_add_size add_size 200000
[    4.493853] pci 0000:0a:01.0: res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
[    4.502891] pci 0000:0a:01.0: BAR 14: can't assign mem (size 0x200000)
[    4.510186] pci 0000:0a:01.0: BAR 15: assigned [mem 0xb2500000-0xb26fffff 64bit pref]
[    4.518933] pci 0000:0a:04.0: BAR 15: assigned [mem 0xb2700000-0xb2bfffff pref]
[    4.527099] pci 0000:0a:01.0: BAR 13: can't assign io (size 0x1000)
[    4.534101] pci 0000:0a:04.0: BAR 15: assigned [mem 0xb2500000-0xb27fffff pref]
[    4.542269] pci 0000:0a:04.0: BAR 15: reassigned [mem 0xb2500000-0xb29fffff pref]
[    4.550631] pci 0000:0a:01.0: BAR 14: can't assign mem (size 0x200000)
[    4.557925] pci 0000:0a:01.0: BAR 15: assigned [mem 0xb2a00000-0xb2bfffff 64bit pref]
[    4.566675] pci 0000:0a:01.0: BAR 13: can't assign io (size 0x1000)
[    4.573677] pci 0000:0a:01.0: PCI bridge to [bus 0b]
[    4.579221] pci 0000:0a:01.0:   bridge window [mem 0xb2a00000-0xb2bfffff 64bit pref]
[    4.587879] pci 0000:0c:00.0: BAR 15: assigned [mem 0xb2500000-0xb27fffff pref]
[    4.596046] pci 0000:0d:00.0: BAR 15: assigned [mem 0xb2500000-0xb25fffff pref]
[    4.604213] pci 0000:0d:01.0: BAR 15: assigned [mem 0xb2600000-0xb27fffff pref]
[    4.612371] pci 0000:0e:00.0: BAR 6: assigned [mem 0xb2500000-0xb2507fff pref]
[    4.620432] pci 0000:0d:00.0: PCI bridge to [bus 0e]
[    4.626002] pci 0000:0d:00.0:   bridge window [mem 0xb2000000-0xb20fffff]
[    4.633594] pci 0000:0d:00.0:   bridge window [mem 0xb2500000-0xb25fffff pref]
[    4.641682] pci 0000:0f:00.0: BAR 15: assigned [mem 0xb2600000-0xb27fffff pref]
[    4.649850] pci 0000:10:00.0: BAR 15: assigned [mem 0xb2600000-0xb26fffff pref]
[    4.658016] pci 0000:10:01.0: BAR 15: assigned [mem 0xb2700000-0xb27fffff pref]
[    4.666184] pci 0000:11:00.0: BAR 6: assigned [mem 0xb2600000-0xb260ffff pref]
[    4.674253] pci 0000:10:00.0: PCI bridge to [bus 11]
[    4.679800] pci 0000:10:00.0:   bridge window [io  0x4000-0x4fff]
[    4.686618] pci 0000:10:00.0:   bridge window [mem 0xb1f00000-0xb1ffffff]
[    4.694212] pci 0000:10:00.0:   bridge window [mem 0xb2600000-0xb26fffff pref]
[    4.702299] pci 0000:12:00.0: BAR 6: assigned [mem 0xb2700000-0xb270ffff pref]
[    4.710368] pci 0000:10:01.0: PCI bridge to [bus 12]
[    4.715917] pci 0000:10:01.0:   bridge window [io  0x3000-0x3fff]
[    4.722743] pci 0000:10:01.0:   bridge window [mem 0xb1e00000-0xb1efffff]
[    4.730338] pci 0000:10:01.0:   bridge window [mem 0xb2700000-0xb27fffff pref]
[    4.738426] pci 0000:10:02.0: PCI bridge to [bus 13]
[    4.743987] pci 0000:10:02.0:   bridge window [mem 0xb1d00000-0xb1dfffff]
[    4.751596] pci 0000:10:03.0: PCI bridge to [bus 14]
[    4.757154] pci 0000:10:03.0:   bridge window [mem 0xb1c00000-0xb1cfffff]
[    4.764763] pci 0000:0f:00.0: PCI bridge to [bus 10-14]
[    4.770602] pci 0000:0f:00.0:   bridge window [io  0x3000-0x4fff]
[    4.777428] pci 0000:0f:00.0:   bridge window [mem 0xb1c00000-0xb1ffffff]
[    4.785012] pci 0000:0f:00.0:   bridge window [mem 0xb2600000-0xb27fffff pref]
[    4.793103] pci 0000:0d:01.0: PCI bridge to [bus 0f-14]
[    4.798943] pci 0000:0d:01.0:   bridge window [io  0x3000-0x4fff]
[    4.805764] pci 0000:0d:01.0:   bridge window [mem 0xb1c00000-0xb1ffffff]
[    4.813356] pci 0000:0d:01.0:   bridge window [mem 0xb2600000-0xb27fffff pref]
[    4.821447] pci 0000:0c:00.0: PCI bridge to [bus 0d-14]
[    4.827286] pci 0000:0c:00.0:   bridge window [io  0x3000-0x4fff]
[    4.834097] pci 0000:0c:00.0:   bridge window [mem 0xb1c00000-0xb21fffff]
[    4.841684] pci 0000:0c:00.0:   bridge window [mem 0xb2500000-0xb27fffff pref]
[    4.849759] pci 0000:0a:04.0: PCI bridge to [bus 0c-14]
[    4.855598] pci 0000:0a:04.0:   bridge window [io  0x3000-0x4fff]
[    4.862409] pci 0000:0a:04.0:   bridge window [mem 0xb1c00000-0xb21fffff]
[    4.869996] pci 0000:0a:04.0:   bridge window [mem 0xb2500000-0xb29fffff pref]
[    4.878070] pci 0000:09:00.0: PCI bridge to [bus 0a-14]
[    4.883909] pci 0000:09:00.0:   bridge window [io  0x3000-0x4fff]
[    4.890711] pci 0000:09:00.0:   bridge window [mem 0xb1c00000-0xb21fffff]
[    4.898297] pci 0000:09:00.0:   bridge window [mem 0xb2500000-0xb2bfffff pref]
[    4.906370] pci 0000:06:08.0: PCI bridge to [bus 09-14]
[    4.912208] pci 0000:06:08.0:   bridge window [io  0x3000-0x4fff]
[    4.919010] pci 0000:06:08.0:   bridge window [mem 0xb1c00000-0xb22fffff]
[    4.926596] pci 0000:06:08.0:   bridge window [mem 0xb2500000-0xb2bfffff pref]
[    4.934668] pci 0000:05:00.0: PCI bridge to [bus 06-14]
[    4.940506] pci 0000:05:00.0:   bridge window [io  0x3000-0x4fff]
[    4.947316] pci 0000:05:00.0:   bridge window [mem 0xb1c00000-0xb22fffff]
[    4.954900] pci 0000:05:00.0:   bridge window [mem 0xb2500000-0xb2dfffff pref]
[    4.962965] pci 0000:00:05.0: PCI bridge to [bus 05-14]
[    4.968803] pci 0000:00:05.0:   bridge window [io  0x3000-0x4fff]
[    4.975604] pci 0000:00:05.0:   bridge window [mem 0xb1c00000-0xb23fffff]
[    4.983189] pci 0000:00:05.0:   bridge window [mem 0xb2500000-0xb2dfffff pref]
[    4.991252] pci 0000:00:06.0: PCI bridge to [bus 15]
[    4.996804] pci 0000:16:00.0: BAR 6: assigned [mem 0xb2e00000-0xb2e3ffff pref]
[    5.004874] pci 0000:16:00.1: BAR 6: assigned [mem 0xb2e40000-0xb2e7ffff pref]
[    5.012936] pci 0000:00:07.0: PCI bridge to [bus 16]
[    5.018483] pci 0000:00:07.0:   bridge window [io  0x2000-0x2fff]
[    5.025293] pci 0000:00:07.0:   bridge window [mem 0xb1b00000-0xb1bfffff]
[    5.032878] pci 0000:00:07.0:   bridge window [mem 0xb2e00000-0xb2efffff pref]
[    5.040950] pci 0000:00:08.0: PCI bridge to [bus 17]
[    5.046501] pci 0000:00:09.0: PCI bridge to [bus 18]
[    5.052055] pci 0000:00:0a.0: PCI bridge to [bus 19]
[    5.057608] pci 0000:1a:00.0: BAR 6: assigned [mem 0xb2f00000-0xb2f1ffff pref]
[    5.065679] pci 0000:1a:00.1: BAR 6: assigned [mem 0xb2f20000-0xb2f3ffff pref]
[    5.073749] pci 0000:00:1c.0: PCI bridge to [bus 1a-1c]
[    5.079587] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    5.086389] pci 0000:00:1c.0:   bridge window [mem 0xb1900000-0xb1afffff]
[    5.093974] pci 0000:00:1c.0:   bridge window [mem 0xb2f00000-0xb31fffff pref]
[    5.102039] pci 0000:1d:00.0: BAR 6: assigned [mem 0xb1810000-0xb181ffff pref]
[    5.110109] pci 0000:00:1c.4: PCI bridge to [bus 1d]
[    5.115657] pci 0000:00:1c.4:   bridge window [io  0x6000-0x6fff]
[    5.122469] pci 0000:00:1c.4:   bridge window [mem 0xb1000000-0xb18fffff]
[    5.130054] pci 0000:00:1c.4:   bridge window [mem 0xb0000000-0xb0ffffff 64bit pref]
[    5.138710] pci 0000:00:1c.5: PCI bridge to [bus 1e]
[    5.144257] pci 0000:00:1c.5:   bridge window [io  0x7000-0x7fff]
[    5.151067] pci 0000:00:1c.5:   bridge window [mem 0xb3200000-0xb33fffff]
[    5.158652] pci 0000:00:1c.5:   bridge window [mem 0xb3400000-0xb35fffff 64bit pref]
[    5.167307] pci 0000:00:1e.0: PCI bridge to [bus 1f]
[    5.179614] pci 0000:00:1e.0: setting latency timer to 64
[    5.185651] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    5.191878] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    5.198105] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    5.205106] pci_bus 0000:00: resource 7 [mem 0xfed40000-0xfedfffff]
[    5.212109] pci_bus 0000:00: resource 8 [mem 0xb0000000-0xfdffffff]
[    5.219114] pci_bus 0000:05: resource 0 [io  0x3000-0x4fff]
[    5.225338] pci_bus 0000:05: resource 1 [mem 0xb1c00000-0xb23fffff]
[    5.232339] pci_bus 0000:05: resource 2 [mem 0xb2500000-0xb2dfffff pref]
[    5.239825] pci_bus 0000:06: resource 0 [io  0x3000-0x4fff]
[    5.246050] pci_bus 0000:06: resource 1 [mem 0xb1c00000-0xb22fffff]
[    5.253052] pci_bus 0000:06: resource 2 [mem 0xb2500000-0xb2dfffff pref]
[    5.260539] pci_bus 0000:08: resource 2 [mem 0xb2c00000-0xb2dfffff 64bit pref]
[    5.268600] pci_bus 0000:09: resource 0 [io  0x3000-0x4fff]
[    5.274827] pci_bus 0000:09: resource 1 [mem 0xb1c00000-0xb22fffff]
[    5.281828] pci_bus 0000:09: resource 2 [mem 0xb2500000-0xb2bfffff pref]
[    5.289315] pci_bus 0000:0a: resource 0 [io  0x3000-0x4fff]
[    5.295541] pci_bus 0000:0a: resource 1 [mem 0xb1c00000-0xb21fffff]
[    5.302544] pci_bus 0000:0a: resource 2 [mem 0xb2500000-0xb2bfffff pref]
[    5.310031] pci_bus 0000:0b: resource 2 [mem 0xb2a00000-0xb2bfffff 64bit pref]
[    5.318102] pci_bus 0000:0c: resource 0 [io  0x3000-0x4fff]
[    5.324326] pci_bus 0000:0c: resource 1 [mem 0xb1c00000-0xb21fffff]
[    5.331329] pci_bus 0000:0c: resource 2 [mem 0xb2500000-0xb29fffff pref]
[    5.338815] pci_bus 0000:0d: resource 0 [io  0x3000-0x4fff]
[    5.345042] pci_bus 0000:0d: resource 1 [mem 0xb1c00000-0xb21fffff]
[    5.352045] pci_bus 0000:0d: resource 2 [mem 0xb2500000-0xb27fffff pref]
[    5.359532] pci_bus 0000:0e: resource 1 [mem 0xb2000000-0xb20fffff]
[    5.366535] pci_bus 0000:0e: resource 2 [mem 0xb2500000-0xb25fffff pref]
[    5.374021] pci_bus 0000:0f: resource 0 [io  0x3000-0x4fff]
[    5.380246] pci_bus 0000:0f: resource 1 [mem 0xb1c00000-0xb1ffffff]
[    5.387249] pci_bus 0000:0f: resource 2 [mem 0xb2600000-0xb27fffff pref]
[    5.394736] pci_bus 0000:10: resource 0 [io  0x3000-0x4fff]
[    5.400962] pci_bus 0000:10: resource 1 [mem 0xb1c00000-0xb1ffffff]
[    5.407956] pci_bus 0000:10: resource 2 [mem 0xb2600000-0xb27fffff pref]
[    5.415435] pci_bus 0000:11: resource 0 [io  0x4000-0x4fff]
[    5.421651] pci_bus 0000:11: resource 1 [mem 0xb1f00000-0xb1ffffff]
[    5.428653] pci_bus 0000:11: resource 2 [mem 0xb2600000-0xb26fffff pref]
[    5.436141] pci_bus 0000:12: resource 0 [io  0x3000-0x3fff]
[    5.442367] pci_bus 0000:12: resource 1 [mem 0xb1e00000-0xb1efffff]
[    5.449370] pci_bus 0000:12: resource 2 [mem 0xb2700000-0xb27fffff pref]
[    5.456857] pci_bus 0000:13: resource 1 [mem 0xb1d00000-0xb1dfffff]
[    5.463859] pci_bus 0000:14: resource 1 [mem 0xb1c00000-0xb1cfffff]
[    5.470853] pci_bus 0000:16: resource 0 [io  0x2000-0x2fff]
[    5.477078] pci_bus 0000:16: resource 1 [mem 0xb1b00000-0xb1bfffff]
[    5.484079] pci_bus 0000:16: resource 2 [mem 0xb2e00000-0xb2efffff pref]
[    5.491566] pci_bus 0000:1a: resource 0 [io  0x1000-0x1fff]
[    5.497783] pci_bus 0000:1a: resource 1 [mem 0xb1900000-0xb1afffff]
[    5.504776] pci_bus 0000:1a: resource 2 [mem 0xb2f00000-0xb31fffff pref]
[    5.512263] pci_bus 0000:1d: resource 0 [io  0x6000-0x6fff]
[    5.518480] pci_bus 0000:1d: resource 1 [mem 0xb1000000-0xb18fffff]
[    5.525481] pci_bus 0000:1d: resource 2 [mem 0xb0000000-0xb0ffffff 64bit pref]
[    5.533550] pci_bus 0000:1e: resource 0 [io  0x7000-0x7fff]
[    5.539777] pci_bus 0000:1e: resource 1 [mem 0xb3200000-0xb33fffff]
[    5.546778] pci_bus 0000:1e: resource 2 [mem 0xb3400000-0xb35fffff 64bit pref]
[    5.554849] pci_bus 0000:1f: resource 4 [io  0x0000-0x0cf7]
[    5.561075] pci_bus 0000:1f: resource 5 [io  0x0d00-0xffff]
[    5.567300] pci_bus 0000:1f: resource 6 [mem 0x000a0000-0x000bffff]
[    5.574301] pci_bus 0000:1f: resource 7 [mem 0xfed40000-0xfedfffff]
[    5.581302] pci_bus 0000:1f: resource 8 [mem 0xb0000000-0xfdffffff]
[    5.588306] pci_bus 0000:fe: resource 4 [io  0x0000-0xffff]
[    5.594533] pci_bus 0000:fe: resource 5 [mem 0x00000000-0xffffffffff]
[    5.601730] pci_bus 0000:ff: resource 4 [io  0x0000-0xffff]
[    5.607956] pci_bus 0000:ff: resource 5 [mem 0x00000000-0xffffffffff]
[    5.615218] NET: Registered protocol family 2
[    5.620472] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    5.629206] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    5.636879] TCP: Hash tables configured (established 131072 bind 65536)
[    5.644305] TCP: reno registered
[    5.647943] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    5.654826] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    5.662298] NET: Registered protocol family 1
[    5.669299] pci 0000:1d:00.0: Boot video device
[    5.674414] PCI: CLS 64 bytes, default 64
[    5.678930] Unpacking initramfs...
[    5.950385] Freeing initrd memory: 14412k freed
[    5.959081] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.966287] software IO TLB [mem 0x87d5d000-0x8bd5d000] (64MB) mapped at [ffff880087d5d000-ffff88008bd5cfff]
[    5.981757] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    5.989377] audit: initializing netlink socket (disabled)
[    5.995432] type=2000 audit(1373984231.242:1): initialized
[    6.037818] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    6.046864] VFS: Disk quotas dquot_6.5.2
[    6.051307] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    6.058995] msgmni has been set to 31955
[    6.063460] SELinux:  Registering netfilter hooks
[    6.069889] alg: No test for stdrng (krng)
[    6.074477] NET: Registered protocol family 38
[    6.079482] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    6.087816] io scheduler noop registered
[    6.092200] io scheduler deadline registered
[    6.097005] io scheduler cfq registered (default)
[    6.102528] pcieport 0000:00:01.0: irq 65 for MSI/MSI-X
[    6.108444] pcieport 0000:00:02.0: irq 66 for MSI/MSI-X
[    6.114346] pcieport 0000:00:03.0: irq 67 for MSI/MSI-X
[    6.120260] pcieport 0000:00:04.0: irq 68 for MSI/MSI-X
[    6.126168] pcieport 0000:00:05.0: irq 69 for MSI/MSI-X
[    6.132078] pcieport 0000:00:06.0: irq 70 for MSI/MSI-X
[    6.137999] pcieport 0000:00:07.0: irq 71 for MSI/MSI-X
[    6.143908] pcieport 0000:00:08.0: irq 72 for MSI/MSI-X
[    6.149816] pcieport 0000:00:09.0: irq 73 for MSI/MSI-X
[    6.155725] pcieport 0000:00:0a.0: irq 74 for MSI/MSI-X
[    6.161653] pcieport 0000:00:1c.0: irq 75 for MSI/MSI-X
[    6.167584] pcieport 0000:00:1c.4: irq 76 for MSI/MSI-X
[    6.173509] pcieport 0000:00:1c.5: irq 77 for MSI/MSI-X
[    6.179428] pcieport 0000:05:00.0: irq 78 for MSI/MSI-X
[    6.185345] pcieport 0000:06:04.0: irq 79 for MSI/MSI-X
[    6.191264] pcieport 0000:06:05.0: irq 80 for MSI/MSI-X
[    6.197196] pcieport 0000:06:08.0: irq 81 for MSI/MSI-X
[    6.203127] pcieport 0000:09:00.0: irq 82 for MSI/MSI-X
[    6.209069] pcieport 0000:0a:01.0: irq 83 for MSI/MSI-X
[    6.215014] pcieport 0000:0a:04.0: irq 84 for MSI/MSI-X
[    6.220955] pcieport 0000:0c:00.0: irq 85 for MSI/MSI-X
[    6.227250] aer 0000:00:01.0:pcie02: service driver aer loaded
[    6.233787] aer 0000:00:02.0:pcie02: service driver aer loaded
[    6.240321] aer 0000:00:03.0:pcie02: service driver aer loaded
[    6.246855] aer 0000:00:04.0:pcie02: service driver aer loaded
[    6.253419] aer 0000:00:05.0:pcie02: service driver aer loaded
[    6.259955] aer 0000:00:06.0:pcie02: service driver aer loaded
[    6.266491] aer 0000:00:07.0:pcie02: service driver aer loaded
[    6.273026] aer 0000:00:08.0:pcie02: service driver aer loaded
[    6.279557] aer 0000:00:09.0:pcie02: service driver aer loaded
[    6.286091] aer 0000:00:0a.0:pcie02: service driver aer loaded
[    6.292622] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    6.300403] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    6.307900] pcieport 0000:00:02.0: Signaling PME through PCIe PME interrupt
[    6.315680] pcie_pme 0000:00:02.0:pcie01: service driver pcie_pme loaded
[    6.323173] pcieport 0000:00:03.0: Signaling PME through PCIe PME interrupt
[    6.330951] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme loaded
[    6.338442] pcieport 0000:00:04.0: Signaling PME through PCIe PME interrupt
[    6.346223] pcie_pme 0000:00:04.0:pcie01: service driver pcie_pme loaded
[    6.353720] pcieport 0000:00:05.0: Signaling PME through PCIe PME interrupt
[    6.361499] pcieport 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    6.369269] pcieport 0000:06:04.0: Signaling PME through PCIe PME interrupt
[    6.377038] pcieport 0000:06:05.0: Signaling PME through PCIe PME interrupt
[    6.384816] pcieport 0000:06:08.0: Signaling PME through PCIe PME interrupt
[    6.392585] pcieport 0000:09:00.0: Signaling PME through PCIe PME interrupt
[    6.400362] pcieport 0000:0a:01.0: Signaling PME through PCIe PME interrupt
[    6.408139] pcieport 0000:0a:04.0: Signaling PME through PCIe PME interrupt
[    6.415918] pcieport 0000:0c:00.0: Signaling PME through PCIe PME interrupt
[    6.423696] pcieport 0000:0d:00.0: Signaling PME through PCIe PME interrupt
[    6.431466] pci 0000:0e:00.0: Signaling PME through PCIe PME interrupt
[    6.438758] pcieport 0000:0d:01.0: Signaling PME through PCIe PME interrupt
[    6.446534] pcieport 0000:0f:00.0: Signaling PME through PCIe PME interrupt
[    6.454311] pcieport 0000:10:00.0: Signaling PME through PCIe PME interrupt
[    6.462087] pci 0000:11:00.0: Signaling PME through PCIe PME interrupt
[    6.469379] pcieport 0000:10:01.0: Signaling PME through PCIe PME interrupt
[    6.477157] pci 0000:12:00.0: Signaling PME through PCIe PME interrupt
[    6.484448] pcieport 0000:10:02.0: Signaling PME through PCIe PME interrupt
[    6.492226] pci 0000:13:00.0: Signaling PME through PCIe PME interrupt
[    6.499518] pcieport 0000:10:03.0: Signaling PME through PCIe PME interrupt
[    6.507294] pci 0000:14:00.0: Signaling PME through PCIe PME interrupt
[    6.514588] pcie_pme 0000:00:05.0:pcie01: service driver pcie_pme loaded
[    6.522071] pcieport 0000:00:06.0: Signaling PME through PCIe PME interrupt
[    6.529850] pcie_pme 0000:00:06.0:pcie01: service driver pcie_pme loaded
[    6.537332] pcieport 0000:00:07.0: Signaling PME through PCIe PME interrupt
[    6.545110] pci 0000:16:00.0: Signaling PME through PCIe PME interrupt
[    6.552404] pci 0000:16:00.1: Signaling PME through PCIe PME interrupt
[    6.559690] pcie_pme 0000:00:07.0:pcie01: service driver pcie_pme loaded
[    6.567181] pcieport 0000:00:08.0: Signaling PME through PCIe PME interrupt
[    6.574963] pcie_pme 0000:00:08.0:pcie01: service driver pcie_pme loaded
[    6.582455] pcieport 0000:00:09.0: Signaling PME through PCIe PME interrupt
[    6.590236] pcie_pme 0000:00:09.0:pcie01: service driver pcie_pme loaded
[    6.597728] pcieport 0000:00:0a.0: Signaling PME through PCIe PME interrupt
[    6.605507] pcie_pme 0000:00:0a.0:pcie01: service driver pcie_pme loaded
[    6.613016] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    6.620795] pci 0000:1a:00.0: Signaling PME through PCIe PME interrupt
[    6.628080] pci 0000:1a:00.1: Signaling PME through PCIe PME interrupt
[    6.635366] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    6.642865] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    6.650645] pci 0000:1d:00.0: Signaling PME through PCIe PME interrupt
[    6.657940] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    6.665440] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
[    6.673219] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
[    6.680731] ioapic: probe of 0000:00:13.0 failed with error -22
[    6.687356] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    6.693638] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 3a40 ss_vid 1137 ss_did 101
[    6.703504] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    6.710615] pciehp 0000:00:1c.4:pcie04: HPC vendor_id 8086 device_id 3a48 ss_vid 1137 ss_did 101
[    6.720481] pciehp 0000:00:1c.4:pcie04: service driver pciehp loaded
[    6.727591] pciehp 0000:00:1c.5:pcie04: HPC vendor_id 8086 device_id 3a4a ss_vid 1137 ss_did 101
[    6.737449] pciehp 0000:00:1c.5:pcie04: service driver pciehp loaded
[    6.744561] pciehp 0000:06:05.0:pcie24: HPC vendor_id 10b5 device_id 8624 ss_vid 10b5 ss_did 8624
[    6.754545] pciehp 0000:06:05.0:pcie24: service driver pciehp loaded
[    6.761668] pciehp 0000:06:08.0:pcie24: HPC vendor_id 10b5 device_id 8624 ss_vid 10b5 ss_did 8624
[    6.771649] pciehp 0000:06:08.0:pcie24: service driver pciehp loaded
[    6.778764] pciehp 0000:0a:01.0:pcie24: HPC vendor_id 10b5 device_id 8632 ss_vid 10b5 ss_did 8632
[    6.788736] pciehp 0000:0a:01.0:pcie24: service driver pciehp loaded
[    6.795850] pciehp 0000:0a:04.0:pcie24: HPC vendor_id 10b5 device_id 8632 ss_vid 10b5 ss_did 8632
[    6.805823] pciehp 0000:0a:04.0:pcie24: service driver pciehp loaded
[    6.812936] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    6.820407] intel_idle: MWAIT substates: 0x1120
[    6.825470] intel_idle: v0.4 model 0x2C
[    6.829746] intel_idle: lapic_timer_reliable_states 0xffffffff
[    6.836414] ACPI Error: No handler for Region [POWS] (ffff88046484cb88) [IPMI] (20130328/evregion-161)
[    6.846843] ACPI Error: Region IPMI (ID=7) has no handler (20130328/exfldio-305)
[    6.855133] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPC0.P111._PSR] (Node ffff88046483d5f0), AE_NOT_EXIST (20130328/psparse-537)
[    6.869466] ACPI Exception: AE_NOT_EXIST, Error reading AC Adapter state (20130328/ac-126)
[    6.878755] ACPI Error: No handler for Region [POWS] (ffff88046484cbd0) [IPMI] (20130328/evregion-161)
[    6.889183] ACPI Error: Region IPMI (ID=7) has no handler (20130328/exfldio-305)
[    6.897477] ACPI Error: Method parse/execution failed [\_SB_.PCI0.LPC0.P112._PSR] (Node ffff88046483d7a8), AE_NOT_EXIST (20130328/psparse-537)
[    6.911816] ACPI Exception: AE_NOT_EXIST, Error reading AC Adapter state (20130328/ac-126)
[    6.921128] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    6.930275] ACPI: Sleep Button [SLPB]
[    6.934403] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    6.942667] ACPI: Power Button [PWRF]
[    6.946795] ACPI: Requesting acpi_cpufreq
[    6.955727] ERST: Error Record Serialization Table (ERST) support is initialized.
[    6.964304] GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
[    6.972636] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    6.980307] tsc: Refined TSC clocksource calibration: 2400.084 MHz
[    7.000267] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    7.013378] Switching to clocksource tsc
[    7.028126] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    7.035260] Non-volatile memory driver v1.3
[    7.039934] Linux agpgart interface v0.103
[    7.045560] loop: module loaded
[    7.049227] ata_piix 0000:00:1f.2: version 2.13
[    7.054453] ata_piix 0000:00:1f.2: MAP [
[    7.058834]  P0 P2 P1 P3 ]
[    7.061937] ata_piix 0000:00:1f.2: setting latency timer to 64
[    7.068672] scsi0 : ata_piix
[    7.072204] scsi1 : ata_piix
[    7.075654] ata1: SATA max UDMA/133 cmd 0x5138 ctl 0x514c bmdma 0x5110 irq 18
[    7.083629] ata2: SATA max UDMA/133 cmd 0x5130 ctl 0x5148 bmdma 0x5118 irq 18
[    7.091733] ata_piix 0000:00:1f.5: MAP [
[    7.096116]  P0 -- P1 -- ]
[    7.249526] ata_piix 0000:00:1f.5: SCR access via SIDPR is available but doesn't work
[    7.258281] ata_piix 0000:00:1f.5: setting latency timer to 64
[    7.264981] scsi2 : ata_piix
[    7.268387] scsi3 : ata_piix
[    7.271797] ata3: SATA max UDMA/133 cmd 0x5128 ctl 0x5144 bmdma 0x50f0 irq 21
[    7.279770] ata4: SATA max UDMA/133 cmd 0x5120 ctl 0x5140 bmdma 0x50f8 irq 21
[    7.287792] libphy: Fixed MDIO Bus: probed
[    7.292447] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    7.299741] ehci-pci: EHCI PCI platform driver
[    7.304844] ehci-pci 0000:00:1a.7: setting latency timer to 64
[    7.311376] ehci-pci 0000:00:1a.7: EHCI Host Controller
[    7.317250] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    7.325524] ehci-pci 0000:00:1a.7: debug port 1
[    7.334483] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[    7.342076] ehci-pci 0000:00:1a.7: irq 19, io mem 0xb2421000
[    7.353598] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    7.360039] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    7.367621] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.375688] usb usb1: Product: EHCI Host Controller
[    7.381136] usb usb1: Manufacturer: Linux 3.10.0-rc5.nab+ ehci_hcd
[    7.388038] usb usb1: SerialNumber: 0000:00:1a.7
[    7.393283] hub 1-0:1.0: USB hub found
[    7.397467] hub 1-0:1.0: 6 ports detected
[    7.402194] ehci-pci 0000:00:1d.7: setting latency timer to 64
[    7.408725] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    7.414600] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    7.422875] ehci-pci 0000:00:1d.7: debug port 1
[    7.431821] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    7.439416] ehci-pci 0000:00:1d.7: irq 16, io mem 0xb2420000
[    7.451678] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    7.458116] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    7.465702] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.467885] ata4.00: ATAPI: Optiarc DVD RW AD-7580S, FX04, max UDMA/100
[    7.481153] usb usb2: Product: EHCI Host Controller
[    7.486599] usb usb2: Manufacturer: Linux 3.10.0-rc5.nab+ ehci_hcd
[    7.489900] ata4.00: configured for UDMA/100
[    7.498270] usb usb2: SerialNumber: 0000:00:1d.7
[    7.503525] hub 2-0:1.0: USB hub found
[    7.507719] hub 2-0:1.0: 6 ports detected
[    7.512308] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.519224] uhci_hcd: USB Universal Host Controller Interface driver
[    7.526451] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    7.532971] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    7.538845] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    7.547131] uhci_hcd 0000:00:1a.0: irq 19, io base 0x000050c0
[    7.553580] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    7.561164] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.569230] usb usb3: Product: UHCI Host Controller
[    7.574675] usb usb3: Manufacturer: Linux 3.10.0-rc5.nab+ uhci_hcd
[    7.581579] usb usb3: SerialNumber: 0000:00:1a.0
[    7.586811] hub 3-0:1.0: USB hub found
[    7.591001] hub 3-0:1.0: 2 ports detected
[    7.595669] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    7.602189] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    7.608073] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    7.616382] uhci_hcd 0000:00:1a.1: irq 19, io base 0x000050a0
[    7.622827] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    7.630409] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.638475] usb usb4: Product: UHCI Host Controller
[    7.643925] usb usb4: Manufacturer: Linux 3.10.0-rc5.nab+ uhci_hcd
[    7.650819] usb usb4: SerialNumber: 0000:00:1a.1
[    7.656051] hub 4-0:1.0: USB hub found
[    7.660241] hub 4-0:1.0: 2 ports detected
[    7.664907] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    7.671424] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    7.677293] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    7.685578] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00005080
[    7.692021] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    7.699606] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.707687] usb usb5: Product: UHCI Host Controller
[    7.713134] usb usb5: Manufacturer: Linux 3.10.0-rc5.nab+ uhci_hcd
[    7.720038] usb usb5: SerialNumber: 0000:00:1a.2
[    7.725308] hub 5-0:1.0: USB hub found
[    7.729516] hub 5-0:1.0: 2 ports detected
[    7.734226] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    7.740747] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    7.746623] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    7.754906] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00005060
[    7.761355] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    7.768937] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.777005] usb usb6: Product: UHCI Host Controller
[    7.782453] usb usb6: Manufacturer: Linux 3.10.0-rc5.nab+ uhci_hcd
[    7.789354] usb usb6: SerialNumber: 0000:00:1d.0
[    7.794585] hub 6-0:1.0: USB hub found
[    7.798775] hub 6-0:1.0: 2 ports detected
[    7.803440] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    7.809958] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    7.815828] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    7.824112] uhci_hcd 0000:00:1d.1: irq 16, io base 0x00005040
[    7.830555] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    7.838140] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    7.846207] usb usb7: Product: UHCI Host Controller
[    7.851654] usb usb7: Manufacturer: Linux 3.10.0-rc5.nab+ uhci_hcd
[    7.853087] ata2.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.853104] ata2.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.859545] ata2.00: ATA-8: ST9500530NS, CC04, max UDMA/133
[    7.859547] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    7.859888] ata2.01: ATA-8: ST9500530NS, CC04, max UDMA/133
[    7.859890] ata2.01: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    7.866571] ata2.00: configured for UDMA/133
[    7.872535] ata2.01: configured for UDMA/133
[    7.909880] usb usb7: SerialNumber: 0000:00:1d.1
[    7.909965] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.909981] ata1.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.915578] ata1.00: ATA-8: ST9500530NS, CC03, max UDMA/133
[    7.915579] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    7.915919] ata1.01: ATA-8: ST9500530NS, CC04, max UDMA/133
[    7.915920] ata1.01: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    7.921573] ata1.00: configured for UDMA/133
[    7.927581] ata1.01: configured for UDMA/133
[    7.927596] Calling blk_mq_init_queue: scsi_mq_ops: ffffffff81ca13e0, queue_depth: 64, cmd_size: 296 SCSI cmd_size: 0
[    7.927639] blk-mq: CPU -> queue map
[    7.927640]   CPU 0 -> Queue 0
[    7.927640]   CPU 1 -> Queue 0
[    7.927640]   CPU 2 -> Queue 0
[    7.927641]   CPU 3 -> Queue 0
[    7.927641]   CPU 4 -> Queue 0
[    7.927642]   CPU 5 -> Queue 0
[    7.927642]   CPU 6 -> Queue 0
[    7.927643]   CPU 7 -> Queue 0
[    7.927643]   CPU 8 -> Queue 0
[    7.927643]   CPU 9 -> Queue 0
[    7.927644]   CPU10 -> Queue 0
[    7.927644]   CPU11 -> Queue 0
[    7.927645]   CPU12 -> Queue 0
[    7.927645]   CPU13 -> Queue 0
[    7.927646]   CPU14 -> Queue 0
[    7.927646]   CPU15 -> Queue 0
[    7.927673] Performing sc map setup on q: ffff880462430000 hctx: ffff880462a14200 i: 0
[    7.927780] scsi_mq_alloc_queue() complete !! >>>>>>>>>>>>>>>>>>>>>>>>>>>
[    7.927784] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927785] Allocated blk-mq req: ffff88046244ad40, req->tag: 63
[    7.927790] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927803] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927815] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927816] Allocated blk-mq req: ffff88046244ad40, req->tag: 63
[    7.927817] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927818] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927826] scsi 0:0:0:0: Direct-Access     ATA      ST9500530NS      CC03 PQ: 0 ANSI: 5
[    7.927944] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927946] Allocated blk-mq req: ffff88046244a7c0, req->tag: 61
[    7.927946] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927949] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927951] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927952] Allocated blk-mq req: ffff88046244a7c0, req->tag: 61
[    7.927955] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927958] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927960] sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
[    7.927964] sd 0:0:0:0: [sda] 1 512-byte logical blocks: (512 B/512 B)
[    7.927965] sd 0:0:0:0: [sda] 0-byte physical blocks
[    7.927966] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927967] Allocated blk-mq req: ffff88046244a7c0, req->tag: 61
[    7.927968] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927970] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927970] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927971] Allocated blk-mq req: ffff88046244a7c0, req->tag: 61
[    7.927972] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927973] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927975] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927976] Allocated blk-mq req: ffff88046244a7c0, req->tag: 61
[    7.927977] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927979] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927981] sd 0:0:0:0: [sda] Write Protect is off
[    7.927982] sd 0:0:0:0: [sda] Mode Sense: 00 00 00 00
[    7.927983] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.927984] Allocated blk-mq req: ffff88046244a7c0, req->tag: 61
[    7.927985] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.927986] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.927987] scsi_execute(): Calling blk_mq_free_request >>>
[    7.927989] sd 0:0:0:0: [sda] Asking for cache data failed
[    7.927990] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    7.927995] Calling blk_mq_init_queue: scsi_mq_ops: ffffffff81ca13e0, queue_depth: 64, cmd_size: 296 SCSI cmd_size: 0
[    7.928030] blk-mq: CPU -> queue map
[    7.928030]   CPU 0 -> Queue 0
[    7.928031]   CPU 1 -> Queue 0
[    7.928031]   CPU 2 -> Queue 0
[    7.928032]   CPU 3 -> Queue 0
[    7.928032]   CPU 4 -> Queue 0
[    7.928032]   CPU 5 -> Queue 0
[    7.928033]   CPU 6 -> Queue 0
[    7.928033]   CPU 7 -> Queue 0
[    7.928034]   CPU 8 -> Queue 0
[    7.928034]   CPU 9 -> Queue 0
[    7.928035]   CPU10 -> Queue 0
[    7.928035]   CPU11 -> Queue 0
[    7.928035]   CPU12 -> Queue 0
[    7.928036]   CPU13 -> Queue 0
[    7.928036]   CPU14 -> Queue 0
[    7.928037]   CPU15 -> Queue 0
[    7.928055] Performing sc map setup on q: ffff8804624f0000 hctx: ffff880462938400 i: 0
[    7.928087] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928088] Allocated blk-mq req: ffff88046244a240, req->tag: 59
[    7.928089] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928092] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928093] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928094] Allocated blk-mq req: ffff88046244a240, req->tag: 59
[    7.928096] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928097] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928099] sd 0:0:0:0: [sda] Sector size 0 reported, assuming 512.
[    7.928100] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928101] Allocated blk-mq req: ffff88046244a240, req->tag: 59
[    7.928102] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928103] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928104] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928105] Allocated blk-mq req: ffff88046244a240, req->tag: 59
[    7.928106] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928107] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928108] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928109] Allocated blk-mq req: ffff88046244a240, req->tag: 59
[    7.928110] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928112] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928113] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928113] Allocated blk-mq req: ffff88046244a240, req->tag: 59
[    7.928114] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928116] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928117] sd 0:0:0:0: [sda] Asking for cache data failed
[    7.928118] sd 0:0:0:0: [sda] Assuming drive cache: write through
[    7.928174] scsi_mq_alloc_queue() complete !! >>>>>>>>>>>>>>>>>>>>>>>>>>>
[    7.928177] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928178] Allocated blk-mq req: ffff88046250ad40, req->tag: 63
[    7.928180] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928232] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928237] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928238] Allocated blk-mq req: ffff88046250ad40, req->tag: 63
[    7.928238] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928240] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928246] scsi 0:0:1:0: Direct-Access     ATA      ST9500530NS      CC04 PQ: 0 ANSI: 5
[    7.928336] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928337] Allocated blk-mq req: ffff88046250a7c0, req->tag: 61
[    7.928338] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928340] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928341] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928342] Allocated blk-mq req: ffff88046250a7c0, req->tag: 61
[    7.928344] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928346] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928347] sd 0:0:1:0: [sdb] Sector size 0 reported, assuming 512.
[    7.928349] sd 0:0:1:0: [sdb] 1 512-byte logical blocks: (512 B/512 B)
[    7.928351] sd 0:0:1:0: Attached scsi generic sg1 type 0
[    7.928351] sd 0:0:1:0: [sdb] 0-byte physical blocks
[    7.928352] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928353] Allocated blk-mq req: ffff88046250a7c0, req->tag: 61
[    7.928354] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928356] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928356] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928357] Allocated blk-mq req: ffff88046250a7c0, req->tag: 61
[    7.928362] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928364] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928366] Calling blk_mq_init_queue: scsi_mq_ops: ffffffff81ca13e0, queue_depth: 64, cmd_size: 296 SCSI cmd_size: 0
[    7.928366] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928367] Allocated blk-mq req: ffff88046250a7c0, req->tag: 61
[    7.928368] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928369] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928371] sd 0:0:1:0: [sdb] Write Protect is off
[    7.928372] sd 0:0:1:0: [sdb] Mode Sense: 00 00 00 00
[    7.928373] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928374] Allocated blk-mq req: ffff88046250a7c0, req->tag: 61
[    7.928375] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928376] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928377] sd 0:0:1:0: [sdb] Asking for cache data failed
[    7.928378] sd 0:0:1:0: [sdb] Assuming drive cache: write through
[    7.928394] blk-mq: CPU -> queue map
[    7.928394]   CPU 0 -> Queue 0
[    7.928395]   CPU 1 -> Queue 0
[    7.928395]   CPU 2 -> Queue 0
[    7.928396]   CPU 3 -> Queue 0
[    7.928396]   CPU 4 -> Queue 0
[    7.928396]   CPU 5 -> Queue 0
[    7.928397]   CPU 6 -> Queue 0
[    7.928397]   CPU 7 -> Queue 0
[    7.928398]   CPU 8 -> Queue 0
[    7.928398]   CPU 9 -> Queue 0
[    7.928399]   CPU10 -> Queue 0
[    7.928399]   CPU11 -> Queue 0
[    7.928399]   CPU12 -> Queue 0
[    7.928400]   CPU13 -> Queue 0
[    7.928400]   CPU14 -> Queue 0
[    7.928401]   CPU15 -> Queue 0
[    7.928420] Performing sc map setup on q: ffff8804624f08e0 hctx: ffff880462938a00 i: 0
[    7.928435] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928436] Allocated blk-mq req: ffff88046250a240, req->tag: 59
[    7.928437] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928439] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928441] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928441] Allocated blk-mq req: ffff88046250a240, req->tag: 59
[    7.928443] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928444] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928446] sd 0:0:1:0: [sdb] Sector size 0 reported, assuming 512.
[    7.928448] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928448] Allocated blk-mq req: ffff88046250a240, req->tag: 59
[    7.928450] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928451] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928452] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928452] Allocated blk-mq req: ffff88046250a240, req->tag: 59
[    7.928457] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928458] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928459] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928460] Allocated blk-mq req: ffff88046250a240, req->tag: 59
[    7.928461] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928462] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928463] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928464] Allocated blk-mq req: ffff88046250a240, req->tag: 59
[    7.928465] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928466] scsi_execute(): Calling blk_mq_free_request >>>
[    7.928468] sd 0:0:1:0: [sdb] Asking for cache data failed
[    7.928469] sd 0:0:1:0: [sdb] Assuming drive cache: write through
[    7.928487] ------------[ cut here ]------------
[    7.928492] WARNING: at drivers/ata/libata-core.c:5038 ata_qc_issue+0x266/0x380()
[    7.928494] Modules linked in:
[    7.928496] CPU: 9 PID: 153 Comm: kworker/u50:5 Not tainted 3.10.0-rc5.nab+ #11
[    7.928497] Hardware name: Cisco Systems Inc R210-2121605W/R210-2121605W, BIOS C200.1.4.3j.0.020720132258 02/07/2013
[    7.928502] Workqueue: events_unbound async_run_entry_fn
[    7.928505]  0000000000000009 ffff88046241f588 ffffffff8162cc58 ffff88046241f5c8
[    7.928507]  ffffffff8104a200 ffff88046241f5d8 ffff880462b90000 0000000000000003
[    7.928509]  ffff880462b91c68 ffffffff81415450 ffff880462b90230 ffff88046241f5d8
[    7.928510] Call Trace:
[    7.928514]  [<ffffffff8162cc58>] dump_stack+0x19/0x1b
[    7.928518]  [<ffffffff8104a200>] warn_slowpath_common+0x70/0xa0
[    7.928521]  [<ffffffff81415450>] ? ata_scsi_set_sense.constprop.26+0x30/0x30
[    7.928523]  [<ffffffff8104a24a>] warn_slowpath_null+0x1a/0x20
[    7.928525]  [<ffffffff8140f586>] ata_qc_issue+0x266/0x380
[    7.928526]  [<ffffffff814155b3>] ? ata_scsi_rw_xlat+0x163/0x210
[    7.928528]  [<ffffffff81415450>] ? ata_scsi_set_sense.constprop.26+0x30/0x30
[    7.928530]  [<ffffffff814140d7>] ata_scsi_translate+0xa7/0x180
[    7.928531] scsi_mq_alloc_queue() complete !! >>>>>>>>>>>>>>>>>>>>>>>>>>>
[    7.928533]  [<ffffffff814181f9>] ata_scsi_queuecmd+0xa9/0x2b0
[    7.928534] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.928537]  [<ffffffff813ed956>] scsi_dispatch_cmd+0x1c6/0x310
[    7.928537] Allocated blk-mq req: ffff88046259ad40, req->tag: 63
[    7.928540]  [<ffffffff813f63bb>] scsi_mq_queue_rq+0x17b/0x280
[    7.928541] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.928546]  [<ffffffff812c15c5>] __blk_mq_run_hw_queue+0x1b5/0x3a0
[    7.928549]  [<ffffffff812c1c65>] blk_mq_run_hw_queue+0x35/0x40
[    7.928550]  [<ffffffff812c1fbb>] blk_mq_make_request+0x34b/0x4a0
[    7.928554]  [<ffffffff812b74f2>] generic_make_request+0xc2/0x110
[    7.928556]  [<ffffffff812b7a1b>] submit_bio+0x7b/0x160
[    7.928560]  [<ffffffff811baa8d>] ? bio_alloc_bioset+0x9d/0x1b0
[    7.928562]  [<ffffffff811b576e>] _submit_bh+0x13e/0x200
[    7.928564]  [<ffffffff811b5840>] submit_bh+0x10/0x20
[    7.928566]  [<ffffffff811b754d>] block_read_full_page+0x21d/0x350
[    7.928568]  [<ffffffff811bbff0>] ? I_BDEV+0x10/0x10
[    7.928571]  [<ffffffff8113be73>] ? __inc_zone_page_state+0x33/0x40
[    7.928573]  [<ffffffff8111f4bf>] ? add_to_page_cache_locked+0xdf/0x190
[    7.928575]  [<ffffffff811bc4a0>] ? blkdev_write_begin+0x30/0x30
[    7.928577]  [<ffffffff811bc4b8>] blkdev_readpage+0x18/0x20
[    7.928579]  [<ffffffff8111fcfa>] do_read_cache_page+0x7a/0x170
[    7.928581]  [<ffffffff8112837a>] ? __alloc_pages_nodemask+0x17a/0xad0
[    7.928583]  [<ffffffff8111fe09>] read_cache_page_async+0x19/0x20
[    7.928585]  [<ffffffff8112015e>] read_cache_page+0xe/0x20
[    7.928588]  [<ffffffff812c80cd>] read_dev_sector+0x2d/0x90
[    7.928590]  [<ffffffff812cdc4c>] read_lba+0xec/0x190
[    7.928592]  [<ffffffff812ce255>] ? efi_partition+0xe5/0x5f0
[    7.928594]  [<ffffffff812ce26f>] efi_partition+0xff/0x5f0
[    7.928596]  [<ffffffff812e9c34>] ? snprintf+0x34/0x40
[    7.928598]  [<ffffffff812ce170>] ? is_gpt_valid+0x480/0x480
[    7.928600]  [<ffffffff812c9138>] check_partition+0x108/0x220
[    7.928602]  [<ffffffff812c8d44>] rescan_partitions+0xb4/0x2c0
[    7.928604]  [<ffffffff811bda35>] __blkdev_get+0x375/0x4b0
[    7.928606]  [<ffffffff8119e447>] ? inode_init_always+0x107/0x1c0
[    7.928608]  [<ffffffff811bc010>] ? blkdev_get_block+0x20/0x20
[    7.928610]  [<ffffffff811bdd05>] blkdev_get+0x195/0x2e0
[    7.928612]  [<ffffffff8119f0c7>] ? unlock_new_inode+0x47/0x70
[    7.928613]  [<ffffffff811bcff0>] ? bdget+0x120/0x140
[    7.928615]  [<ffffffff812c6531>] add_disk+0x391/0x490
[    7.928618]  [<ffffffff81402c4a>] sd_probe_async+0x13a/0x230
[    7.928620]  [<ffffffff81075de6>] async_run_entry_fn+0x46/0x140
[    7.928623]  [<ffffffff810683c4>] process_one_work+0x174/0x400
[    7.928624]  [<ffffffff81068acc>] worker_thread+0x11c/0x370
[    7.928626]  [<ffffffff810689b0>] ? rescuer_thread+0x320/0x320
[    7.928629]  [<ffffffff8106f410>] kthread+0xc0/0xd0
[    7.928631]  [<ffffffff8106f350>] ? flush_kthread_worker+0x80/0x80
[    7.928633]  [<ffffffff8163b2dc>] ret_from_fork+0x7c/0xb0
[    7.928635]  [<ffffffff8106f350>] ? flush_kthread_worker+0x80/0x80
[    7.928638] ---[ end trace 9f4b3fe3fb787a07 ]---
[    7.931709] scsi_execute(): Calling blk_mq_free_request >>>
[    7.931715] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.931715] Allocated blk-mq req: ffff88046259ad40, req->tag: 63
[    7.931716] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.931718] scsi_execute(): Calling blk_mq_free_request >>>
[    7.931724] scsi 1:0:0:0: Direct-Access     ATA      ST9500530NS      CC04 PQ: 0 ANSI: 5
[    7.931786] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.931787] Allocated blk-mq req: ffff88046259a7c0, req->tag: 61
[    7.931788] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.931791] scsi_execute(): Calling blk_mq_free_request >>>
[    7.931792] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.931792] Allocated blk-mq req: ffff88046259a7c0, req->tag: 61
[    7.931795] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.931796] scsi_execute(): Calling blk_mq_free_request >>>
[    7.931798] sd 1:0:0:0: [sdc] Sector size 0 reported, assuming 512.
[    7.931800] sd 1:0:0:0: [sdc] 1 512-byte logical blocks: (512 B/512 B)
[    7.931801] sd 1:0:0:0: [sdc] 0-byte physical blocks
[    7.931802] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.931803] Allocated blk-mq req: ffff88046259a7c0, req->tag: 61
[    7.931804] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.931807] scsi_execute(): Calling blk_mq_free_request >>>
[    7.931808] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.931808] Allocated blk-mq req: ffff88046259a7c0, req->tag: 61
[    7.931809] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.931813] scsi_execute(): Calling blk_mq_free_request >>>
[    7.931814] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.931815] Allocated blk-mq req: ffff88046259a7c0, req->tag: 61
[    7.931816] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.931821] scsi_execute(): Calling blk_mq_free_request >>>
[    7.931822] sd 1:0:0:0: [sdc] Write Protect is off
[    7.931823] sd 1:0:0:0: [sdc] Mode Sense: 00 00 00 00
[    7.931824] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.931825] Allocated blk-mq req: ffff88046259a7c0, req->tag: 61
[    7.931826] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.931827] scsi_execute(): Calling blk_mq_free_request >>>
[    7.931829] sd 1:0:0:0: [sdc] Asking for cache data failed
[    7.931830] sd 1:0:0:0: Attached scsi generic sg2 type 0
[    7.931831] sd 1:0:0:0: [sdc] Assuming drive cache: write through
[    7.931837] Calling blk_mq_init_queue: scsi_mq_ops: ffffffff81ca13e0, queue_depth: 64, cmd_size: 296 SCSI cmd_size: 0
[    7.931860] blk-mq: CPU -> queue map
[    7.931860]   CPU 0 -> Queue 0
[    7.931861]   CPU 1 -> Queue 0
[    7.931861]   CPU 2 -> Queue 0
[    7.931862]   CPU 3 -> Queue 0
[    7.931862]   CPU 4 -> Queue 0
[    7.931863]   CPU 5 -> Queue 0
[    7.931863]   CPU 6 -> Queue 0
[    7.931863]   CPU 7 -> Queue 0
[    7.931864]   CPU 8 -> Queue 0
[    7.931864]   CPU 9 -> Queue 0
[    7.931865]   CPU10 -> Queue 0
[    7.931865]   CPU11 -> Queue 0
[    7.931866]   CPU12 -> Queue 0
[    7.931866]   CPU13 -> Queue 0
[    7.931866]   CPU14 -> Queue 0
[    7.931867]   CPU15 -> Queue 0
[    7.931886] Performing sc map setup on q: ffff8804624308e0 hctx: ffff880462a14600 i: 0
[    7.931895] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.931896] Allocated blk-mq req: ffff88046259a7c0, req->tag: 61
[    7.931896] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.931899] scsi_execute(): Calling blk_mq_free_request >>>
[    7.931900] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.931901] Allocated blk-mq req: ffff88046259a7c0, req->tag: 61
[    7.931902] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.931904] scsi_execute(): Calling blk_mq_free_request >>>
[    7.931906] sd 1:0:0:0: [sdc] Sector size 0 reported, assuming 512.
[    7.931907] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.931908] Allocated blk-mq req: ffff88046259a7c0, req->tag: 61
[    7.931909] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.931910] scsi_execute(): Calling blk_mq_free_request >>>
[    7.931911] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.931912] Allocated blk-mq req: ffff88046259a7c0, req->tag: 61
[    7.931913] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.931917] scsi_execute(): Calling blk_mq_free_request >>>
[    7.931918] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.931919] Allocated blk-mq req: ffff88046259a7c0, req->tag: 61
[    7.931930] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.931932] scsi_execute(): Calling blk_mq_free_request >>>
[    7.931933] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.931933] Allocated blk-mq req: ffff88046259a7c0, req->tag: 61
[    7.931934] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.931937] scsi_execute(): Calling blk_mq_free_request >>>
[    7.931938] sd 1:0:0:0: [sdc] Asking for cache data failed
[    7.931940] sd 1:0:0:0: [sdc] Assuming drive cache: write through
[    7.932002] scsi_mq_alloc_queue() complete !! >>>>>>>>>>>>>>>>>>>>>>>>>>>
[    7.932006] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932007] Allocated blk-mq req: ffff88046264ad40, req->tag: 63
[    7.932008] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.932042] scsi_execute(): Calling blk_mq_free_request >>>
[    7.932047] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932048] Allocated blk-mq req: ffff88046264ad40, req->tag: 63
[    7.932048] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.932050] scsi_execute(): Calling blk_mq_free_request >>>
[    7.932056] scsi 1:0:1:0: Direct-Access     ATA      ST9500530NS      CC04 PQ: 0 ANSI: 5
[    7.932160] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932161] Allocated blk-mq req: ffff88046264ad40, req->tag: 63
[    7.932161] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.932168] sd 1:0:1:0: Attached scsi generic sg3 type 0
[    7.932168] scsi_execute(): Calling blk_mq_free_request >>>
[    7.932170] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932170] Allocated blk-mq req: ffff88046264ad40, req->tag: 63
[    7.932172] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.932175] scsi_execute(): Calling blk_mq_free_request >>>
[    7.932177] sd 1:0:1:0: [sdd] Sector size 0 reported, assuming 512.
[    7.932179] sd 1:0:1:0: [sdd] 1 512-byte logical blocks: (512 B/512 B)
[    7.932180] sd 1:0:1:0: [sdd] 0-byte physical blocks
[    7.932181] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932182] Allocated blk-mq req: ffff88046264ad40, req->tag: 63
[    7.932183] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.932184] scsi_execute(): Calling blk_mq_free_request >>>
[    7.932185] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932186] Allocated blk-mq req: ffff88046264ad40, req->tag: 63
[    7.932187] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.932190] scsi_execute(): Calling blk_mq_free_request >>>
[    7.932191] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932192] Allocated blk-mq req: ffff88046264ad40, req->tag: 63
[    7.932193] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.932198] scsi_execute(): Calling blk_mq_free_request >>>
[    7.932200] sd 1:0:1:0: [sdd] Write Protect is off
[    7.932201] sd 1:0:1:0: [sdd] Mode Sense: 00 00 00 00
[    7.932202] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932203] Allocated blk-mq req: ffff88046264ad40, req->tag: 63
[    7.932204] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.932206] scsi_execute(): Calling blk_mq_free_request >>>
[    7.932207] sd 1:0:1:0: [sdd] Asking for cache data failed
[    7.932208] sd 1:0:1:0: [sdd] Assuming drive cache: write through
[    7.932218] Calling blk_mq_init_queue: scsi_mq_ops: ffffffff81ca13e0, queue_depth: 64, cmd_size: 296 SCSI cmd_size: 0
[    7.932251] blk-mq: CPU -> queue map
[    7.932252]   CPU 0 -> Queue 0
[    7.932253]   CPU 1 -> Queue 0
[    7.932253]   CPU 2 -> Queue 0
[    7.932254]   CPU 3 -> Queue 0
[    7.932255]   CPU 4 -> Queue 0
[    7.932255]   CPU 5 -> Queue 0
[    7.932256]   CPU 6 -> Queue 0
[    7.932256]   CPU 7 -> Queue 0
[    7.932257]   CPU 8 -> Queue 0
[    7.932258]   CPU 9 -> Queue 0
[    7.932259]   CPU10 -> Queue 0
[    7.932259]   CPU11 -> Queue 0
[    7.932260]   CPU12 -> Queue 0
[    7.932260]   CPU13 -> Queue 0
[    7.932261]   CPU14 -> Queue 0
[    7.932262]   CPU15 -> Queue 0
[    7.932282] Performing sc map setup on q: ffff8804626f8000 hctx: ffff8802628f0200 i: 0
[    7.932286] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932287] Allocated blk-mq req: ffff88046264ad40, req->tag: 63
[    7.932288] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.932293] scsi_execute(): Calling blk_mq_free_request >>>
[    7.932294] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932295] Allocated blk-mq req: ffff88046264ad40, req->tag: 63
[    7.932296] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.932300] scsi_execute(): Calling blk_mq_free_request >>>
[    7.932302] sd 1:0:1:0: [sdd] Sector size 0 reported, assuming 512.
[    7.932303] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932304] Allocated blk-mq req: ffff88046264ad40, req->tag: 63
[    7.932305] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.932308] scsi_execute(): Calling blk_mq_free_request >>>
[    7.932309] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932310] Allocated blk-mq req: ffff88046264ad40, req->tag: 63
[    7.932311] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.932316] scsi_execute(): Calling blk_mq_free_request >>>
[    7.932317] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932318] Allocated blk-mq req: ffff88046264ad40, req->tag: 63
[    7.932318] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.932324] scsi_execute(): Calling blk_mq_free_request >>>
[    7.932325] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932325] Allocated blk-mq req: ffff88046264ad40, req->tag: 63
[    7.932326] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.932331] scsi_execute(): Calling blk_mq_free_request >>>
[    7.932333] sd 1:0:1:0: [sdd] Asking for cache data failed
[    7.932334] sd 1:0:1:0: [sdd] Assuming drive cache: write through
[    7.932394] scsi_mq_alloc_queue() complete !! >>>>>>>>>>>>>>>>>>>>>>>>>>>
[    7.932398] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.932399] Allocated blk-mq req: ffff88046271ad40, req->tag: 63
[    7.932400] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.943187]  sdb: sdb1
[    7.943191] sdb: p1 start 2048 is beyond EOD, enabling native capacity
[    7.943222] scsi_execute(): Calling blk_mq_free_request >>>
[    7.943230] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.943231] Allocated blk-mq req: ffff88046271ad40, req->tag: 63
[    7.943232] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.944750] scsi_execute(): Calling blk_mq_free_request >>>
[    7.944757] scsi 3:0:0:0: CD-ROM            Optiarc  DVD RW AD-7580S  FX04 PQ: 0 ANSI: 5
[    7.944813] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[    7.944814] Allocated blk-mq req: ffff88046271ad40, req->tag: 63
[    7.944815] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[    7.957010]  sdd: sdd1
[    7.957013] sdd: p1 start 2048 is beyond EOD, enabling native capacity
[    7.963106] usb 1-4: new high-speed USB device number 3 using ehci-pci
[    8.218646] usb 1-4: config 1 has no interfaces?
[    8.219146] usb 1-4: New USB device found, idVendor=0624, idProduct=0249
[    8.219148] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    8.219149] usb 1-4: Product: USB Composite Device-1
[    8.219150] usb 1-4: Manufacturer: Avocent
[    8.426474] usb 2-5: new high-speed USB device number 2 using ehci-pci
[    8.719067] usb 2-5: New USB device found, idVendor=04b4, idProduct=6560
[    8.719069] usb 2-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    8.719215] hub 2-5:1.0: USB hub found
[    8.719315] hub 2-5:1.0: 4 ports detected
[    8.957907] usb 4-1: new full-speed USB device number 2 using uhci_hcd
[    9.112050] usb 4-1: New USB device found, idVendor=0624, idProduct=0248
[    9.112051] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    9.112053] usb 4-1: Product: USB Composite Device-0
[    9.112054] usb 4-1: Manufacturer: Avocent
[    9.112055] usb 4-1: SerialNumber: 20080930
[    9.329209] usb 2-3: new high-speed USB device number 3 using ehci-pci
[    9.470178] usb 2-3: New USB device found, idVendor=14dd, idProduct=0002
[    9.470180] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    9.470181] usb 2-3: Product: Multidevice
[    9.470182] usb 2-3: Manufacturer: Peppercon AG
[    9.470183] usb 2-3: SerialNumber: 18EB7D234B1BCF34ADCBEA6091EC9869
[   10.986077] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   10.986079] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   10.986082] Allocated blk-mq req: ffff88046264a7c0, req->tag: 61
[   10.986083] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   10.986088] scsi_execute(): Calling blk_mq_free_request >>>
[   10.986090] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   10.986091] Allocated blk-mq req: ffff88046264a7c0, req->tag: 61
[   10.986094] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   10.986097] scsi_execute(): Calling blk_mq_free_request >>>
[   10.986100] sd 1:0:1:0: [sdd] Sector size 0 reported, assuming 512.
[   10.986101] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   10.986102] Allocated blk-mq req: ffff88046264a7c0, req->tag: 61
[   10.986104] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   10.986107] scsi_execute(): Calling blk_mq_free_request >>>
[   10.986110] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   10.986111] Allocated blk-mq req: ffff88046264a7c0, req->tag: 61
[   10.986113] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   10.986115] scsi_execute(): Calling blk_mq_free_request >>>
[   10.986116] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   10.986117] Allocated blk-mq req: ffff88046264a7c0, req->tag: 61
[   10.986118] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   10.986121] scsi_execute(): Calling blk_mq_free_request >>>
[   10.986124] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   10.986124] Allocated blk-mq req: ffff88046264a7c0, req->tag: 61
[   10.986126] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   10.986129] scsi_execute(): Calling blk_mq_free_request >>>
[   10.986132] sd 1:0:1:0: [sdd] Asking for cache data failed
[   10.986133] sd 1:0:1:0: [sdd] Assuming drive cache: write through
[   10.986155] hub 7-0:1.0: USB hub found
[   10.986158] hub 7-0:1.0: 2 ports detected
[   10.986355] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   10.986358] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   10.986397] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[   10.986428] uhci_hcd 0000:00:1d.2: irq 16, io base 0x00005020
[   10.986429]  sdd: sdd1
[   10.986432] sdd: p1 start 2048 is beyond EOD, truncated
[   10.986462] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[   10.986464] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.986465] usb usb8: Product: UHCI Host Controller
[   10.986466] usb usb8: Manufacturer: Linux 3.10.0-rc5.nab+ uhci_hcd
[   10.986467] usb usb8: SerialNumber: 0000:00:1d.2
[   10.986547] hub 8-0:1.0: USB hub found
[   10.986550] hub 8-0:1.0: 2 ports detected
[   10.986570] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   10.986572] Allocated blk-mq req: ffff88046264a500, req->tag: 60
[   10.986572] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   10.986576] scsi_execute(): Calling blk_mq_free_request >>>
[   10.986581] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   10.986582] Allocated blk-mq req: ffff88046264a500, req->tag: 60
[   10.986582] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   10.986584] scsi_execute(): Calling blk_mq_free_request >>>
[   10.986585] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   10.986586] Allocated blk-mq req: ffff88046264a500, req->tag: 60
[   10.986588] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   10.986590] scsi_execute(): Calling blk_mq_free_request >>>
[   10.986593] sd 1:0:1:0: [sdd] Sector size 0 reported, assuming 512.
[   10.986595] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   10.986595] Allocated blk-mq req: ffff88046264a500, req->tag: 60
[   10.986598] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   10.986600] scsi_execute(): Calling blk_mq_free_request >>>
[   10.986601] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   10.986602] Allocated blk-mq req: ffff88046264a500, req->tag: 60
[   10.986603] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   10.986606] scsi_execute(): Calling blk_mq_free_request >>>
[   10.986607] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   10.986608] Allocated blk-mq req: ffff88046264a500, req->tag: 60
[   10.986609] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   10.986612] scsi_execute(): Calling blk_mq_free_request >>>
[   10.986614] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   10.986615] Allocated blk-mq req: ffff88046264a500, req->tag: 60
[   10.986617] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   10.986619] scsi_execute(): Calling blk_mq_free_request >>>
[   10.986620] sd 1:0:1:0: [sdd] Asking for cache data failed
[   10.986622] sd 1:0:1:0: [sdd] Assuming drive cache: write through
[   10.986623] sd 1:0:1:0: [sdd] Attached SCSI disk
[   10.986693] usbcore: registered new interface driver usbserial
[   10.986699] usbcore: registered new interface driver usbserial_generic
[   10.986706] usbserial: USB Serial support registered for generic
[   10.986730] i8042: PNP: No PS/2 controller found. Probing ports directly.
[   11.523406] Allocated blk-mq req: ffff880462509f80, req->tag: 58
[   11.530116] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   11.538869] scsi_execute(): Calling blk_mq_free_request >>>
[   11.545095] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   11.551996] Allocated blk-mq req: ffff880462509f80, req->tag: 58
[   11.558705] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   11.567452] scsi_execute(): Calling blk_mq_free_request >>>
[   11.573677] sd 0:0:1:0: [sdb] Sector size 0 reported, assuming 512.
[   11.580679] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   11.587580] Allocated blk-mq req: ffff880462509f80, req->tag: 58
[   11.594288] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   11.603035] scsi_execute(): Calling blk_mq_free_request >>>
[   11.609259] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   11.616161] Allocated blk-mq req: ffff880462509f80, req->tag: 58
[   11.622871] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   11.631617] scsi_execute(): Calling blk_mq_free_request >>>
[   11.637840] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   11.644741] Allocated blk-mq req: ffff880462509f80, req->tag: 58
[   11.651450] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   11.660198] scsi_execute(): Calling blk_mq_free_request >>>
[   11.666421] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   11.673324] Allocated blk-mq req: ffff880462509f80, req->tag: 58
[   11.680034] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   11.688782] scsi_execute(): Calling blk_mq_free_request >>>
[   11.695005] sd 0:0:1:0: [sdb] Asking for cache data failed
[   11.701132] sd 0:0:1:0: [sdb] Assuming drive cache: write through
[   11.708212]  sdb: sdb1
[   11.710851] sdb: p1 start 2048 is beyond EOD, truncated
[   11.716790] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   11.723696] Allocated blk-mq req: ffff880462509cc0, req->tag: 57
[   11.723744] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   11.723745] Allocated blk-mq req: ffff880462509740, req->tag: 55
[   11.723746] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   11.723749] scsi_execute(): Calling blk_mq_free_request >>>
[   11.723750] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   11.723751] Allocated blk-mq req: ffff880462509740, req->tag: 55
[   11.723754] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   11.723755] scsi_execute(): Calling blk_mq_free_request >>>
[   11.723757] sd 0:0:1:0: [sdb] Sector size 0 reported, assuming 512.
[   11.723759] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   11.723760] Allocated blk-mq req: ffff880462509740, req->tag: 55
[   11.723761] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   11.723762] scsi_execute(): Calling blk_mq_free_request >>>
[   11.723763] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   11.723764] Allocated blk-mq req: ffff880462509740, req->tag: 55
[   11.723765] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   11.723766] scsi_execute(): Calling blk_mq_free_request >>>
[   11.723767] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   11.723768] Allocated blk-mq req: ffff880462509740, req->tag: 55
[   11.723769] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   11.723770] scsi_execute(): Calling blk_mq_free_request >>>
[   11.723771] Entering scsi_execute with q->mq_ops: ffffffff81ca13e0
[   11.723772] Allocated blk-mq req: ffff880462509740, req->tag: 55
[   11.723773] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   11.723774] scsi_execute(): Calling blk_mq_free_request >>>
[   11.723776] sd 0:0:1:0: [sdb] Asking for cache data failed
[   11.723777] sd 0:0:1:0: [sdb] Assuming drive cache: write through
[   11.723778] sd 0:0:1:0: [sdb] Attached SCSI disk
[   11.926903] Calling blk_mq_insert_request from blk_execute_rq_nowait >>>>>>>>>>>>>>>>
[   11.935652] scsi_execute(): Calling blk_mq_free_request >>>
[   12.033094] i8042: No controller found
[   12.037373] mousedev: PS/2 mouse device common for all mice
[   12.043839] rtc_cmos 00:02: RTC can wake from S4
[   12.049118] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[   12.055954] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[   12.064566] device-mapper: uevent: version 1.0.3
[   12.069788] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[   12.079541] cpuidle: using governor ladder
[   12.084416] cpuidle: using governor menu
[   12.089357] hidraw: raw HID events driver (C) Jiri Kosina
[   12.100665] input: Avocent USB Composite Device-0 as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.0/input/input2
[   12.112415] hid-generic 0003:0624:0248.0001: input,hidraw0: USB HID v1.00 Keyboard [Avocent USB Composite Device-0] on usb-0000:00:1a.1-1/input0
[   12.130629] input: Avocent USB Composite Device-0 as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.1/input/input3
[   12.142391] hid-generic 0003:0624:0248.0002: input,hidraw1: USB HID v1.00 Mouse [Avocent USB Composite Device-0] on usb-0000:00:1a.1-1/input1
[   12.161647] input: Avocent USB Composite Device-0 as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.2/input/input4
[   12.173406] hid-generic 0003:0624:0248.0003: input,hidraw2: USB HID v1.00 Mouse [Avocent USB Composite Device-0] on usb-0000:00:1a.1-1/input2
[   12.188165] input: Peppercon AG Multidevice as /devices/pci0000:00/0000:00:1d.7/usb2/2-3/2-3:1.0/input/input5
[   12.199328] hid-generic 0003:14DD:0002.0004: input,hidraw3: USB HID v1.01 Keyboard [Peppercon AG Multidevice] on usb-0000:00:1d.7-3/input0
[   12.214075] input: Peppercon AG Multidevice as /devices/pci0000:00/0000:00:1d.7/usb2/2-3/2-3:1.1/input/input6
[   12.225243] hid-generic 0003:14DD:0002.0005: input,hidraw4: USB HID v1.01 Mouse [Peppercon AG Multidevice] on usb-0000:00:1d.7-3/input1
[   12.238856] usbcore: registered new interface driver usbhid
[   12.245087] usbhid: USB HID core driver
[   12.249415] drop_monitor: Initializing network drop monitor service
[   12.256511] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.262688] TCP: cubic registered
[   12.266394] Initializing XFRM netlink socket
[   12.271252] NET: Registered protocol family 10
[   12.276437] mip6: Mobile IPv6
[   12.279754] NET: Registered protocol family 17
[   12.285687] PM: Hibernation image not present or could not be loaded.
[   12.292888] registered taskstats version 1
[   12.299282]   Magic number: 5:412:283
[   12.304146] rtc_cmos 00:02: setting system clock to 2013-07-16 14:17:22 UTC (1373984242)

--XsQoSWH+UP9D9v3l--
