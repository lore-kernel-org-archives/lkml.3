Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106AbaEFOJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:09:55 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:62398 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaEFOJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:09:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <jbottomley@parallels.com>
Cc: "bhelgaas@google.com" <bhelgaas@google.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DMA-API: Change dma_declare_coherent_memory() CPU address to phys_addr_t
Date: Tue, 06 May 2014 16:09:20 +0200
Message-ID: <5829375.P5n7Z81gQ7@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399383725.2237.26.camel@dabdike.int.hansenpartnership.com>
References: <20140430203321.30056.14833.stgit@bhelgaas-glaptop.roam.corp.google.com> <CAErSpo7wJTP+GyM4sNN6gAA69cV_j3m=nOsgJasi1XYFZMA2YA@mail.gmail.com> <1399383725.2237.26.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:HDgJm10fALOYWTXDbjKAkylkRbVQBu8jYZ1Jdju52nG
 B87zYJUQ2xJcyMBL3BjYTmCTJWXv2Mb5BZOXjAbcn8//nP3ij5
 Vv4NmeU1BbVTqGDQ+06wkSZRlXAg0J/uGJySBmh1SWQvCxWxUK
 /GwVbOA6fOAc5GgRqHY5AhL1pszBASn1tWE6G0D3QSyGzAHQKn
 jnBI/ru4MG2ItAFQG587EJssFqhSVkt0PL+u6BVin0uH23su3O
 GfaHmB4+376RgXG9G9UEN8/fxH9qEz2bia0auCsb1klf33js3b
 C1cY3TECsTv/DmFPIYxa7JXlXRo1azHrvOJSCC13cF1fqxa3go
 2B6Hm08oqPliA7uDzPBU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2014 13:42:06 James Bottomley wrote:
> On Tue, 2014-05-06 at 07:18 -0600, Bjorn Helgaas wrote:
> > On Mon, May 5, 2014 at 8:42 PM, James Bottomley
> > <jbottomley@parallels.com> wrote:
> > > On Mon, 2014-05-05 at 17:01 -0600, Bjorn Helgaas wrote:
> > >> On Fri, May 02, 2014 at 10:42:18AM +0200, Arnd Bergmann wrote:
> > >
> > >> > I don't know about NCR_Q720, but all others are only used on machines
> > >> > where physical addresses and bus addresses are in the same space.
> > >>
> > >> In general, the driver doesn't know whether physical and bus addresses
> > >> are in the same space.  At least, I *hope* it doesn't have to know,
> > >> because it can't be very generic if it does.
> > >
> > > The API was designed for the case where the memory resides on a PCI
> > > device (the Q720 case), the card config gives us a bus address, but if
> > > the system has an IOMMU, we'd have to do a dma_map of the entire region
> > > to set up the IOMMU before we can touch it.  The address it gets back
> > > from the dma_map (the dma_addr_t handle for the IOMMU mapping) is what
> > > we pass into dma_declare_coherent_memory().
> > 
> > The IOMMU (if any) is only involved for DMA to system memory, and
> > there is no system memory in this picture.  The device does DMA to its
> > own memory; no dma_map is required for this.  We use
> > dma_declare_coherent_memory() to set things up so the CPU can also do
> > programmed I/O to the memory.
> 
> Right, but for the CPU to access memory on a device, the access has to
> go through the IOMMU: it has to be programmed to map the memory on the
> bus to a physical address.

That's not how most IOMMUs work, I haven't actually seen any system that
requires using the IOMMU for an MMIO access on the architectures I worked
on. The IOMMU may be required for the device to access its own memory
though, if it issues a DMA request that goes up the bus hierarchy into
the IOMMU and gets translated into an MMIO address there.

> > > The reason it does an
> > > ioremap is because this IOMMU mapped address is now physical to the CPU
> > > and we want to make the region available to virtual space.  Essentially
> > > the memory the allocator hands out behaves as proper virtual memory but
> > > it's backed by physical memory on the card behind the PCI bridge.
> > 
> > Yep, the programmed I/O depends on the ioremap().  But I don't think
> > it depends on any IOMMU mapping.
> 
> At least on Parisc with U2/Uturn, unless there are IOMMU entries, you
> won't be able to address the memory on the device because it's behind
> the IOMMU.  For regions like this, the necessary IOMMU entries are set
> up at init time because without them you don't get memory mapped access
> to register space either.

I would treat that as a specific property of that system. The IOMMU
and dma-mapping APIs we have in Linux normally assume that the IOMMU
is strictly one-way, translating dma_addr_t (used by the device) into
phys_addr_t (normally for RAM), but not for memory mapped access
initiated by the CPU. Most architectures (not s390 though) rely
on the MMU to set up a page table entry converting from a virtual
address to the physical address. There may be offsets between the
physical address seen by the CPU and the address seen on the bus,
but not a second set of page tables.

	Arnd
