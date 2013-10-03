Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab3JCSf3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:35:29 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:51777 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab3JCSfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:35:24 -0400
MIME-Version: 1.0
In-Reply-To: <20131002172258.GC24791@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
	<1380298207-29151-15-git-send-email-stefano.stabellini@eu.citrix.com>
	<20130930160223.GU3106@phenom.dumpdata.com>
	<alpine.DEB.2.02.1310021811030.26077@kaball.uk.xensource.com>
	<20131002172258.GC24791@phenom.dumpdata.com>
Date: Thu, 3 Oct 2013 13:35:22 -0500
Message-ID: <CAL_JsqLGhNOZxAhuQMUdgmMLRxLakBpacfTufSWKGEGFSTqd3A@mail.gmail.com>
Subject: Re: [PATCH v6 15/19] swiotlb-xen: call dma_capable only if
 dev->dma_mask is allocated
From: Rob Herring <robherring2@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com, Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 2, 2013 at 12:22 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Wed, Oct 02, 2013 at 06:13:35PM +0100, Stefano Stabellini wrote:
>> The real issue is that some devices (xgmac, I am looking at you), don't
>> set the dma_mask, even though they are perfectly capable of doing dma.
>
> So this looks like a bug in the drivers. I thought I saw a huge patchset
> by the ARM maintainer that tries to fix the dma_mask and dma_mask_coherent
> bugs? And also fix the drivers to use the dma mask?

I think Russell only fixed incorrect handling of masks, not missing handling.

>>
>> Maybe I should modify the arm implementation of dma_capable (see
>> http://marc.info/?l=linux-kernel&m=138029832007821&w=2) to ignore the
>> dma_mask.
>
> Or fix the 'xgmac'?

There's really some core changes needed to fix this and I'd guess
there are lots of other cases of missing dma_mask. The problem is
platform devices don't create a mask to assign to dma_mask in the
first place. I think the right solution is assigning dma_mask to
&coherent_dma_mask by default as Russell did for AMBA devices. I don't
know if doing that would break anything or not.

Rob

>>
>> On Mon, 30 Sep 2013, Konrad Rzeszutek Wilk wrote:
>> > On Fri, Sep 27, 2013 at 05:10:03PM +0100, Stefano Stabellini wrote:
>> >
>> > Why? I am looking at X86 and IA64 and I see:
>> >
>> >  79         if (!dev->dma_mask)
>> >  80                 return 0;
>> >
>> >
>> > Why not port dma_capable over to ARM?
>> >
>> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>> > > ---
>> > >  drivers/xen/swiotlb-xen.c |    6 +++---
>> > >  1 files changed, 3 insertions(+), 3 deletions(-)
>> > >
>> > > diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
>> > > index 790c2eb..3011736 100644
>> > > --- a/drivers/xen/swiotlb-xen.c
>> > > +++ b/drivers/xen/swiotlb-xen.c
>> > > @@ -512,7 +512,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
>> > >    * buffering it.
>> > >    */
>> > >   if (!xen_feature(XENFEAT_auto_translated_physmap) &&
>> > > -     dma_capable(dev, dev_addr, size) &&
>> > > +     dev->dma_mask && dma_capable(dev, dev_addr, size) &&
>> > >       !range_straddles_page_boundary(phys, size) && !swiotlb_force)
>> > >           return dev_addr;
>> > >
>> > > @@ -532,7 +532,7 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
>> > >   /*
>> > >    * Ensure that the address returned is DMA'ble
>> > >    */
>> > > - if (!dma_capable(dev, dev_addr, size)) {
>> > > + if (dev->dma_mask && !dma_capable(dev, dev_addr, size)) {
>> > >           swiotlb_tbl_unmap_single(dev, map, size, dir);
>> > >           dev_addr = 0;
>> > >   }
>> > > @@ -660,7 +660,7 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
>> > >
>> > >           if (swiotlb_force ||
>> > >               xen_feature(XENFEAT_auto_translated_physmap) ||
>> > > -             !dma_capable(hwdev, dev_addr, sg->length) ||
>> > > +             (hwdev->dma_mask && !dma_capable(hwdev, dev_addr, sg->length)) ||
>> > >               range_straddles_page_boundary(paddr, sg->length)) {
>> > >                   /*
>> > >                    * Pass the dma_addr of the first slab in the iotlb buffer as
>> > > --
>> > > 1.7.2.5
>> > >
>> >
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
