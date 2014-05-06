Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934647AbaEFJ3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:29:31 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62068 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934490AbaEFJ31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:29:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: James Bottomley <jbottomley@parallels.com>
Cc: "bhelgaas@google.com" <bhelgaas@google.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DMA-API: Change dma_declare_coherent_memory() CPU address to phys_addr_t
Date: Tue, 06 May 2014 11:29:12 +0200
Message-ID: <4242492.CmiQ52tgWu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399344142.2164.67.camel@dabdike.int.hansenpartnership.com>
References: <20140430203321.30056.14833.stgit@bhelgaas-glaptop.roam.corp.google.com> <20140505230104.GB8883@google.com> <1399344142.2164.67.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3BMNnA3vib1IfbOJsXe/hmD4PhvBg3CaQySYhJtjelj
 crFvOaQuQmSoPwbg+zWOdn5ZVQNIJHRTLAGpRCXhqWZfmwi66h
 MHdPjxSeE4M9uuR189Q3IJIBJH+MvjRZQy0RJ+naLkZkszmOEH
 gfJm+nqtsfcnbbAkk5bJ8SxhsXS02jTZNcoVZKODz0dYGQPi/a
 lkP8/HzT5YdEJHxStDEj42D0KK3umz6LaAJRYRIY3mm68otXlv
 YsMC3PdIX3xIjgHddyWQDxVnLNcxacpgWjMLyhO/LyFXNFtGXw
 pR+NDhT01N1qEko2opM3/YxMFKNgMdA5Do5lqwxph0+zMH5m/8
 WiizKizNoFQQYM2gdwHM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2014 02:42:22 James Bottomley wrote:
> On Mon, 2014-05-05 at 17:01 -0600, Bjorn Helgaas wrote:
> > On Fri, May 02, 2014 at 10:42:18AM +0200, Arnd Bergmann wrote:
> 
> > > I don't know about NCR_Q720, but all others are only used on machines
> > > where physical addresses and bus addresses are in the same space.
> > 
> > In general, the driver doesn't know whether physical and bus addresses
> > are in the same space.  At least, I *hope* it doesn't have to know,
> > because it can't be very generic if it does.
> 
> The API was designed for the case where the memory resides on a PCI
> device (the Q720 case), the card config gives us a bus address, but if
> the system has an IOMMU, we'd have to do a dma_map of the entire region
> to set up the IOMMU before we can touch it.  The address it gets back
> from the dma_map (the dma_addr_t handle for the IOMMU mapping) is what
> we pass into dma_declare_coherent_memory().  The reason it does an
> ioremap is because this IOMMU mapped address is now physical to the CPU
> and we want to make the region available to virtual space.  Essentially
> the memory the allocator hands out behaves as proper virtual memory but
> it's backed by physical memory on the card behind the PCI bridge.
> 
> I'm still not that fussed about the difference between phys_addr_t and
> dma_addr_t, but if the cookie returned from a dma_map is a dma_addr_t
> then that's what dma_declare_coherent_memory() should use.  If it's a
> phys_addr_t, then likewise.

I think the 'bus_addr' argument should be renamed to 'phys_addr' and
changed to type 'phys_addr_t' from the currentn code, the device_addr
should stay as dma_addr_t. This is what the code looks like today:

struct dma_coherent_mem {
        void            *virt_base;
        dma_addr_t      device_base;
        phys_addr_t     pfn_base;
	...
};

int dma_declare_coherent_memory(struct device *dev, dma_addr_t bus_addr,
                                dma_addr_t device_addr, size_t size, int flags)
{
	...
	dev->dma_mem->virt_base = ioremap(bus_addr, size);
	dev->dma_mem->pfn_base = PFN_DOWN(bus_addr);
	dev->dma_mem->device_base = device_addr;
	...
}

* ioremap() takes a phys_addr_t argument, we feed it a dma_addr_t,
  which should get corrected.
* a PFN by convention is an 'unsigned long', not a phys_addr_t,
  PFN_DOWN essentially converts phys_addr_t to 'unsigned long'.

If we change these, it's all consistent.

Unrelated to that, there is the problem that most callers (including Q720)
pass the same address as bus_addr and device_addr into
dma_declare_coherent_memory(), but that would be an issue with the caller,
and it's sort of ok when the caller knows they are the same (i.e. no IOMMU).

Normally dma_map_single() is used to convert from phys_addr_t to dma_addr_t,
and you seem to argue that this is what the callers should do. However,
that doesn't work here, because dma_map_single() is only defined for
actual RAM in the linear kernel mapping, not for a physical address on
a device. We have a similar problem in passing FIFO addresses from slave
devices to dma engines, and that is also unsolved right now, and we rely
on them to be on the same bus, with no IOMMU between them.

	Arnd
