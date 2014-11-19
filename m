Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbaKSP4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:56:52 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:50829 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbaKSP4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:56:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ding Tianhong <dingtianhong@huawei.com>
Subject: Re: For the problem when using swiotlb
Date: Wed, 19 Nov 2014 16:56:42 +0100
Message-ID: <3918100.vD6471iH9k@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141119154634.GE7156@e104818-lin.cambridge.arm.com>
References: <5469E26B.2010905@huawei.com> <1497289.TPKf3qDiKk@wuerfel> <20141119154634.GE7156@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:OqZYBtm4vySZtnz90Z7WSJA9W8OqPuM0qkY0cri/ggU
 5wWRVQ4yLqlCUz0qxpHoNbjuf9umxDYfnqAZ0FrbXW1Aee8aPG
 XITuiM0GQvPFDq0c+eamdvkvmQVtTisWD7qZNwyHkXHG88HfW9
 0Fu9tICdLLQ922aEnZTONwME61EO751j9ntlYOnLSdpVfZt8Tc
 e9z8RRkatFClss7QwxeFDta2pTfiGSTxIfEdjtj6/vlzi18FRE
 NFHlwc3KmOzA4+SiroJUHgo6OzeFOCpmmlfAHhy7IswrtoGm2C
 WzRI/yWVlkTKg1u0Jh/weKAb3n67vMzUjlIF5XvSa2Qq31LE5D
 ZP/hnApna5xXQF8Mdd9o=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2014 15:46:35 Catalin Marinas wrote:
> On Wed, Nov 19, 2014 at 12:48:58PM +0000, Arnd Bergmann wrote:
> > On Wednesday 19 November 2014 11:29:10 Catalin Marinas wrote:
> > > > The driver should call 'dma_set_mask_and_coherent()' with the appropriate
> > > > dma mask, and check whether that succeeded. However, the code implementing
> > > > dma_set_mask_and_coherent on arm64 also needs to be changed to look up
> > > > the dma-ranges property (see of_dma_configure()), and check if the mask
> > > > is possible.
> > > 
> > > dma_set_mask_and_coherent() is a generic function. I think the
> > > of_dma_configure() should start with a coherent_dma_mask based on
> > > dma-ranges if given rather than defaulting to DMA_BIT_MASK(32). The
> > > comment in of_dma_configure() says that devices should set up the
> > > supported mask but it's not always up to them but the bus they are
> > > connected to.
> > > 
> > > Something like below, untested:
> > > 
> > > diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> > > index 3b64d0bf5bba..dff34883db45 100644
> > > --- a/drivers/of/platform.c
> > > +++ b/drivers/of/platform.c
> > > @@ -200,6 +200,10 @@ static void of_dma_configure(struct device *dev)
> > >         /* DMA ranges found. Calculate and set dma_pfn_offset */
> > >         dev->dma_pfn_offset = PFN_DOWN(paddr - dma_addr);
> > >         dev_dbg(dev, "dma_pfn_offset(%#08lx)\n", dev->dma_pfn_offset);
> > > +
> > > +       /* Set the coherent_dma_mask based on the dma-ranges property */
> > > +       if (size)
> > > +               dev->coherent_dma_mask = DMA_BIT_MASK(ilog2(size));
> > >  }
> > 
> > We have discussed this in the past, and the problem with this is
> > that the actual mask depends both on the capabilities of the
> > device and the bus. In particular, if the device can only do
> > 32-bit DMA, we must not set the mask to something higher.
> 
> So is the dma-ranges property allowed to specify a size bigger than what
> the device supports?

dma-ranges is a property that describes the bus, but you can have
devices with different capabilities on the same bus. In particular
on PCI, you will have 32-bit and 64-bit masters on the same host
controller.

> > The normal rule here is that a driver that wants to do 64-bit
> > DMA must call dma_set_mask_and_coherent() with the higher mask,
> > while a device that can not access all of the 32-bit address space
> > must call dma_set_mask_and_coherent() with the smaller mask
> > before doing calling any of the other DMA interfaces.
> 
> OK, looking at the DMA API docs, it looks like the default mask is
> 32-bit and any other value should be explicitly set by the driver.
> 
> What we don't have on arm64 yet is taking dma_pfn_offset into account
> when generating the dma address (but so far I haven't seen any request
> for this from hardware vendors; it can easily be fixed). So if that's
> not the case for Ding, I'm not sure dma-ranges property would help.

You can ignore dma_pfn_offset for now, until someone needs it. What
we definitely need is the size of the range.

> > However, if the bus is not capable of addressing the entire
> > 32-bit range (as on some modern shmobile machines, or some of the
> > really old machines), we need to limit the mask here already.
> 
> Would the limiting be based on the dma-ranges size property?

Yes.

> Such information is not easily available after of_dma_configure(),
> maybe we could store it somewhere in struct device.

I don't think it's necessary. Setting the dma mask is a rare operation,
and we only need to check again if the new mask is larger than the
old one.

> Going back to original topic, the dma_supported() function on arm64
> calls swiotlb_dma_supported() which actually checks whether the swiotlb
> bounce buffer is within the dma mask. This transparent bouncing (unlike
> arm32 where it needs to be explicit) is not always optimal, though
> required for 32-bit only devices on a 64-bit system. The problem is when
> the driver is 64-bit capable but forgets to call
> dma_set_mask_and_coherent() (that's not the only question I got about
> running out of swiotlb buffers).

I think it would be nice to warn once per device that starts using the
swiotlb. Really all 32-bit DMA masters should have a proper IOMMU
attached.

	Arnd
