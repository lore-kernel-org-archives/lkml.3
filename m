Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791AbaIPAZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:25:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759146AbaIPAZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:25:43 -0400
Date: Mon, 15 Sep 2014 20:25:03 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        akpm@linux-foundation.org, andi@firstfloor.org, riel@redhat.com,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND] x86: numa: setup_node_data(): drop dead code and
 rename function
Message-ID: <20140915202503.7ff3fb97@redhat.com>
In-Reply-To: <alpine.DEB.2.02.1409151711060.6549@chino.kir.corp.google.com>
References: <20140915142540.0a24c887@redhat.com>
	<alpine.DEB.2.02.1409151711060.6549@chino.kir.corp.google.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2014 17:13:39 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Mon, 15 Sep 2014, Luiz Capitulino wrote:
> 
> > The setup_node_data() function allocates a pg_data_t object, inserts it
> > into the node_data[] array and initializes the following fields: node_id,
> > node_start_pfn and node_spanned_pages.
> > 
> > However, a few function calls later during the kernel boot,
> > free_area_init_node() re-initializes those fields, possibly with
> > setup_node_data() is not used.
> > 
> > This causes a small glitch when running Linux as a hyperv numa guest:
> > 
> > [    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
> > [    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
> > [    0.000000] SRAT: PXM 1 -> APIC 0x02 -> Node 1
> > [    0.000000] SRAT: PXM 1 -> APIC 0x03 -> Node 1
> > [    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
> > [    0.000000] SRAT: Node 1 PXM 1 [mem 0x80200000-0xf7ffffff]
> > [    0.000000] SRAT: Node 1 PXM 1 [mem 0x100000000-0x1081fffff]
> > [    0.000000] NUMA: Node 1 [mem 0x80200000-0xf7ffffff] + [mem 0x100000000-0x1081fffff] -> [mem 0x80200000-0x1081fffff]
> > [    0.000000] Initmem setup node 0 [mem 0x00000000-0x7fffffff]
> > [    0.000000]   NODE_DATA [mem 0x7ffdc000-0x7ffeffff]
> > [    0.000000] Initmem setup node 1 [mem 0x80800000-0x1081fffff]
> > [    0.000000]   NODE_DATA [mem 0x1081ea000-0x1081fdfff]
> > [    0.000000] crashkernel: memory value expected
> > [    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007de00000-ffff88007fdfffff] on node 0
> > [    0.000000]  [ffffea0002000000-ffffea00043fffff] PMD -> [ffff880105600000-ffff8801077fffff] on node 1
> > [    0.000000] Zone ranges:
> > [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> > [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> > [    0.000000]   Normal   [mem 0x100000000-0x1081fffff]
> > [    0.000000] Movable zone start for each node
> > [    0.000000] Early memory node ranges
> > [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> > [    0.000000]   node   0: [mem 0x00100000-0x7ffeffff]
> > [    0.000000]   node   1: [mem 0x80200000-0xf7ffffff]
> > [    0.000000]   node   1: [mem 0x100000000-0x1081fffff]
> > [    0.000000] On node 0 totalpages: 524174
> > [    0.000000]   DMA zone: 64 pages used for memmap
> > [    0.000000]   DMA zone: 21 pages reserved
> > [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> > [    0.000000]   DMA32 zone: 8128 pages used for memmap
> > [    0.000000]   DMA32 zone: 520176 pages, LIFO batch:31
> > [    0.000000] On node 1 totalpages: 524288
> > [    0.000000]   DMA32 zone: 7672 pages used for memmap
> > [    0.000000]   DMA32 zone: 491008 pages, LIFO batch:31
> > [    0.000000]   Normal zone: 520 pages used for memmap
> > [    0.000000]   Normal zone: 33280 pages, LIFO batch:7
> > 
> > In this dmesg, the SRAT table reports that the memory range for node 1
> > starts at 0x80200000.  However, the line starting with "Initmem" reports
> > that node 1 memory range starts at 0x80800000.  The "Initmem" line is
> > reported by setup_node_data() and is wrong, because the kernel ends up
> > using the range as reported in the SRAT table.
> > 
> > This commit drops all that dead code from setup_node_data(), renames it to
> > alloc_node_data() and adds a printk() to free_area_init_node() so that we
> > report a node's memory range accurately.
> > 
> > Here's the same dmesg section with this patch applied:
> > 
> > [    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
> > [    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
> > [    0.000000] SRAT: PXM 1 -> APIC 0x02 -> Node 1
> > [    0.000000] SRAT: PXM 1 -> APIC 0x03 -> Node 1
> > [    0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
> > [    0.000000] SRAT: Node 1 PXM 1 [mem 0x80200000-0xf7ffffff]
> > [    0.000000] SRAT: Node 1 PXM 1 [mem 0x100000000-0x1081fffff]
> > [    0.000000] NUMA: Node 1 [mem 0x80200000-0xf7ffffff] + [mem 0x100000000-0x1081fffff] -> [mem 0x80200000-0x1081fffff]
> > [    0.000000] NODE_DATA(0) allocated [mem 0x7ffdc000-0x7ffeffff]
> > [    0.000000] NODE_DATA(1) allocated [mem 0x1081ea000-0x1081fdfff]
> > [    0.000000] crashkernel: memory value expected
> > [    0.000000]  [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff88007de00000-ffff88007fdfffff] on node 0
> > [    0.000000]  [ffffea0002000000-ffffea00043fffff] PMD -> [ffff880105600000-ffff8801077fffff] on node 1
> > [    0.000000] Zone ranges:
> > [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> > [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> > [    0.000000]   Normal   [mem 0x100000000-0x1081fffff]
> > [    0.000000] Movable zone start for each node
> > [    0.000000] Early memory node ranges
> > [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> > [    0.000000]   node   0: [mem 0x00100000-0x7ffeffff]
> > [    0.000000]   node   1: [mem 0x80200000-0xf7ffffff]
> > [    0.000000]   node   1: [mem 0x100000000-0x1081fffff]
> > [    0.000000] Initmem setup node 0 [mem 0x00001000-0x7ffeffff]
> > [    0.000000] On node 0 totalpages: 524174
> > [    0.000000]   DMA zone: 64 pages used for memmap
> > [    0.000000]   DMA zone: 21 pages reserved
> > [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> > [    0.000000]   DMA32 zone: 8128 pages used for memmap
> > [    0.000000]   DMA32 zone: 520176 pages, LIFO batch:31
> > [    0.000000] Initmem setup node 1 [mem 0x80200000-0x1081fffff]
> > [    0.000000] On node 1 totalpages: 524288
> > [    0.000000]   DMA32 zone: 7672 pages used for memmap
> > [    0.000000]   DMA32 zone: 491008 pages, LIFO batch:31
> > [    0.000000]   Normal zone: 520 pages used for memmap
> > [    0.000000]   Normal zone: 33280 pages, LIFO batch:7
> > 
> > This commit was tested on a two node bare-metal NUMA machine and Linux as
> > a numa guest on hyperv and qemu/kvm.
> > 
> > PS: The wrong memory range reported by setup_node_data() seems to be
> >     harmless in the current kernel because it's just not used.  However,
> >     that bad range is used in kernel 2.6.32 to initialize the old boot
> >     memory allocator, which causes a crash during boot.
> > 
> > Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
> > Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> > Cc: Yinghai Lu <yinghai@kernel.org>
> > Acked-by: Rik van Riel <riel@redhat.com>
> > Cc: Andi Kleen <andi@firstfloor.org>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> > I posted this patch more than two months ago. Andrew picked it up and it
> > rested in the -mm tree for a couple of weeks. Andrew dropped it from -mm
> > to move it forward, but looks like it hasn't been picked by anyone else
> > since then. Resending...
> > 
> 
> This is still in linux-next-20140915 and I doubt it's 3.17 material so I'd 
> wait for Andrew to take care of it.

Oh, I thought it had been forgotten because it was dropped from -mm some
weeks ago (dropped for inclusion in mainline, I guess). I'm not targeting
3.17 btw, I just don't want this patch to be forgotten.
