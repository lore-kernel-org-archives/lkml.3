Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab3HMVxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:53:17 -0400
Received: from mx2.parallels.com ([199.115.105.18]:33324 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab3HMVxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:53:15 -0400
From: James Bottomley <jbottomley@parallels.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Chris Metcalf <cmetcalf@tilera.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        "adam radford" <aradford@gmail.com>
Subject: Re: [PATCH v2] tile: support LSI MEGARAID SAS HBA hybrid dma_ops
Thread-Topic: [PATCH v2] tile: support LSI MEGARAID SAS HBA hybrid dma_ops
Thread-Index: AQHOmGQBNw2dMUyC4kKnyEgBN9EO/ZmUI5EA
Date: Tue, 13 Aug 2013 21:53:11 +0000
Message-ID: <1376430790.3467.85.camel@dabdike.int.hansenpartnership.com>
References: <CAErSpo6SzUF44pk3HVyR5UUN0BJUHUz+Z5egWKCoGG70VuB6wg@mail.gmail.com>
	 <520A5B01.2010207@tilera.com>
	 <CAErSpo4sFPiuPLboJ_wsg2cketUaciP7EgmufJmuEEryJmDW7Q@mail.gmail.com>
In-Reply-To: <CAErSpo4sFPiuPLboJ_wsg2cketUaciP7EgmufJmuEEryJmDW7Q@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.17.213.192]
Content-Type: text/plain; charset="utf-8"
Content-ID: <91229F46AB7CBF4F8AC1A05CBA1E417A@sw.swsoft.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7DLrOG7002540

On Tue, 2013-08-13 at 14:30 -0600, Bjorn Helgaas wrote:
> [+cc James in case he has opinions on the DMA mask question]
> 
> On Tue, Aug 13, 2013 at 10:12 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> > (Trimming the quoted material a little to try to keep this email under control.)
> >
> > On 8/12/2013 4:42 PM, Bjorn Helgaas wrote:
> >> On Mon, Aug 12, 2013 at 1:42 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> >>> On 8/9/2013 6:42 PM, Bjorn Helgaas wrote:
> >>>> OK, so physical memory in the [3GB,4GB] range is unreachable via DMA
> >>>> as you describe.  And even if DMA *could* reach it, the CPU couldn't
> >>>> see it because CPU accesses to that range would go to PCI for the
> >>>> memory-mapped BAR space, not to memory.
> >>> Right.  Unreachability is only a problem if the DMA window overlaps [3G, 4G], and since the 64-bit DMA window is [1TB,2TB], the whole PA space can be reached by 64-bit capable devices.
> >> So the [0-1TB] memory range (including [3GB-4GB]) is reachable by
> >> 64-bit DMA to bus addresses [1TB-2TB].  But if the CPU can't see
> >> physical memory from [3GB-4GB], how is it useful to DMA there?
> >
> > Sorry, looking back I can see that the thread is a little confusing.
> > The CPU can see the whole PA space. The confusion comes from the BAR space
> > in [3GB, 4GB].
> >
> > On Tile, we define the CPU memory space as follows:
> >
> > [0, 1TB]: PA
> > [1TB + 3GB, 1TB + 4GB]: BAR space for RC port 0, in [3GB, 4GB]
> > [1TB + 3GB + N*4GB, 1TB + (1 + N)*4GB]: BAR space for RC port N, in [3GB, 4GB]
> >
> > The mapping from [1TB + 3GB + N*4GB, 1TB + (1 + N)*4GB] to [3GB, 4GB] is done by a
> > hardware PIO region, which generates PCI bus addresses in [3GB, 4GB] for MMIOs to
> > the BAR space.
> 
> OK, I think I get it now.  CPU address space:
>   [0, 1TB]: physical memory
>   [1TB + 3GB, 1TB + 4GB]: translated to bus address [3GB, 4GB] under RC port 0
>   [1TB + 3GB + N*4GB, 1TB + (1 + N)*4GB]: translated to bus address
> [3GB, 4GB] under RC port N
> 
> Bus address space:
>   [0, 3GB]: 32-bit DMA reaches physical memory [0, 3GB]
>   [3GB, 4GB]: 32-bit DMA (peer-to-peer DMA under local RC port, I guess?)
>   [1TB, 2TB]: 64-bit DMA mapped via IOMMU to physical memory [0, 1TB]
> 
> I guess the problem is that 32-bit DMA can't reach physical memory
> [3GB, 4GB], so you're using bounce buffers so the bus address is in
> [0, 3GB].  That makes sense, and I don't see another possibility other
> than just throwing away the [3GB, 4GB] range by leaving it out of the
> kernel allocator altogether, or using  hardware (which tilegx probably
> doesn't have) to remap it somewhere else.

This is remarkably familiar.  I think almost every system on earth has a
configuration similar to this.  On PARISC, the top 256MB of memory on a
32 bit system is reserved for I/O access and is designated as "F Space".

What is unusual is that you seem to have responding memory behind the F
Space which is accessible to some bus entities.  On PARISC 32 bit, the
memory is just lost (inaccessible) on 64 bit, it's remapped above 32GB
(and the low F Space window expanded to 1GB).

> So it seems like just a question of how you wrap this all up in
> dma_ops, and *that* is all arch stuff that I don't have an opinion on.
> 
> >>> Unfortunately, the Megaraid driver doesnâ€™t even call pci_set_consistent_dma_mask(dev, DMA_BIT_MASK(32)).
> >> If the Megaraid driver needs that call, but it's missing, why wouldn't
> >> we just add it?
> >
> > The Megaraid driver doesnâ€™t strictly need that call on other platforms, because
> > by default the device coherent_dma_mask is DMA_BIT_MASK(32) and the consistent
> > memory pool doesnâ€™t come from the bounce buffers on most other platforms.
> >
> > Of course, for the sake of correctness, this call should be added across all platforms.
> > ...
> 
> > What is unique about Tile is that the PCI drivers must explicitly declare
> > its DMA capability by calling pci_set_dma_mask() and pci_set_consistent_dma_mask().
> 
> It looks like the reason you need drivers to explicitly call
> pci_set_dma_mask() and pci_set_consistent_dma_mask() is because you
> have hooks in those functions to tweak the dma_ops, even though the
> mask itself might not be changed.
> 
> That doesn't sound like a robust solution: we have well-known defaults
> for the mask sizes, and I don't think it's reasonable to expect
> drivers to explicitly set the mask even if they are happy with the
> defaults (though Documentation/DMA-API-HOWTO.txt does say that being
> explicit is good style).  I'm afraid you'll just keep tripping over
> drivers that don't work on tilegx because they don't set the mask.

Right, it's not a robust solution at all.  A DMA mask is just that: an
accessibility mask.  The founding assumption is that an address line is
either connected or not, which is why the mask works.  What you have is
two different classes of memory: 0-3GB which is usable for I/O and 3-4GB
which isn't.  Surely what you need to do is implement ZONE_DMA32? which
stretches from 0-3GB, which means all kmallocs in the driver will be in
the right range.  Then you need a bounce pfn at 3GB which means that
user space which gets the 3-4GB is bounced.  There's a magic pfn in
BLK_BOUNCE_HIGH that was designed for this, but I'm not sure the design
contemplated BLK_BOUNCE_HIGH being different for 64 and 32 bit.

James

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
