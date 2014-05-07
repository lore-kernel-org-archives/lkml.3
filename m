Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaEGIP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:15:29 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:58935 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaEGIPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:15:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-doc@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 3/5] sh/PCI: Pass GAPSPCI_DMA_BASE CPU address to dma_declare_coherent_memory()
Date: Wed, 07 May 2014 10:15:10 +0200
Message-ID: <4271645.KYLAoYxC5v@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <6994558.Q3OYh8PWMa@wuerfel>
References: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com> <20140506224833.17968.87108.stgit@bhelgaas-glaptop.roam.corp.google.com> <6994558.Q3OYh8PWMa@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:9gLfCHiPMJAM3xAjCKlOynNAiadzSNwxOoDFWRd0cep
 7G5uwHX2bmQWi2LZVTWl+K/pOAkaaTyUDnFpIUiqV1cpWuS5cd
 t8BlUquxjyyBVvyrGeW4E6N8EVdvcO50aH8HLp1AF69KiWmrlU
 81Gf10RxfksX04ynLBsc7qa+FoUB+oIfdlr7UGsZRqC/517XOD
 V8bNzju30PtG1jIxVJVRh9Vphy1uHYSPQKlPibbEz8kVqWHIHC
 TdJ5ZaPj1cpvQcFh1/w05xw2eQrHKEHXKja4CdgdWDo7k4eq91
 9ZMHNAQryY4zXZ8dEbv7jzzAXPBa7ytWTejYRRIzJgy9N+Nbsv
 olqa78X/VhWATqhwg790=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 May 2014 09:55:16 Arnd Bergmann wrote:
> On Tuesday 06 May 2014 16:48:33 Bjorn Helgaas wrote:
> > @@ -51,8 +53,12 @@ static void gapspci_fixup_resources(struct pci_dev *dev)
> >                 /*
> >                  * Redirect dma memory allocations to special memory window.
> >                  */
> > +               region.start = GAPSPCI_DMA_BASE;
> > +               region.end = GAPSPCI_DMA_BASE + GAPSPCI_DMA_SIZE - 1;
> > +               res.flags = IORESOURCE_MEM;
> > +               pcibios_bus_to_resource(dev->bus, &res, &region);
> >                 BUG_ON(!dma_declare_coherent_memory(&dev->dev,
> > -                                               GAPSPCI_DMA_BASE,
> > +                                               res->start,
> >                                                 GAPSPCI_DMA_BASE,
> >                                                 GAPSPCI_DMA_SIZE,
> >                                                 DMA_MEMORY_MAP |
> 
> Not sure if this is an improvement. I understand the intention, but
> it's actually possible for the offset to be different both ways:
> 
> Your patch applies the outbound mem_offset that was provided when
> registering the MMIO resource for the PCI host bridge. What the driver
> needs instead is the inbound DMA offset that gets applied by some
> host bridges that don't have a 1:1 mapping but also don't have an
> IOMMU. We know that on this particular platform, both are zero, so
> the original code works and it will keep working with your change,
> but I think it's a mistake anyway. I have seen both kinds of offsets
> in the past on real machines, but I am not aware of any where they
> are both nonzero and have the same value.

Hmm, looking at it again, it seem even weirder: the address we register
for DMA allocations is the same that gets passed into the PCI host
for MMIO resources. Something is very strange here. Still, I'd rather
not touch it at all, whatever it does.

	Arnd
