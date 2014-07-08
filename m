Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaGHHBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:01:41 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:55738 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbaGHHBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:01:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v8 3/9] pci: Introduce pci_register_io_range() helper function.
Date: Tue, 8 Jul 2014 09:00:44 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, "linux-pci" <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com> <1404240214-9804-4-git-send-email-Liviu.Dudau@arm.com> <20140708001418.GB22939@google.com>
In-Reply-To: <20140708001418.GB22939@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201407080900.44882.arnd@arndb.de>
X-Provags-ID: V02:K0:jT8ZcG9Hz0xlybekLb7IEI+1o331+eGNmvQswm+Igyd
 HYRQHVesX5R+nFx17w1fZvcWVsufbCW0DJjcrSFRI3an52gP4v
 ozDMpS1B+FCDvfZiKQojIvKeMDQLIMt5O279Amyvm05vpmAk6l
 7VbRWfPmrf/uNCxkiz9BfK6Jjcy2q2nndiGWWNnHIWnqd2JiG5
 +n45gnw0E316SXce4fTBtbMlEKliWTCsF4fcPDogA/1HfF/y7O
 AQNIASzKs/gQZqphBQtkA4NqpFXIMCtbflcObgbU/wUFZ/Y716
 CKs6mJz8BLpHhnfDzOWUZOm3YVVZ7RHdkdPhvOJeElln/RrjdM
 mP3gjsMlMxIk8QbP9cpG3EVqAX0kYWxAqjDYVYVlw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 July 2014, Bjorn Helgaas wrote:
> On Tue, Jul 01, 2014 at 07:43:28PM +0100, Liviu Dudau wrote:
> > +static LIST_HEAD(io_range_list);
> > +
> > +/*
> > + * Record the PCI IO range (expressed as CPU physical address + size).
> > + * Return a negative value if an error has occured, zero otherwise
> > + */
> > +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> 
> I don't understand the interface here.  What's the mapping from CPU
> physical address to bus I/O port?  For example, I have the following
> machine in mind:
> 
>   HWP0002:00: PCI Root Bridge (domain 0000 [bus 00-1b])
>   HWP0002:00: memory-mapped IO port space [mem 0xf8010000000-0xf8010000fff]
>   HWP0002:00: host bridge window [io  0x0000-0x0fff]
> 
>   HWP0002:09: PCI Root Bridge (domain 0001 [bus 00-1b])
>   HWP0002:09: memory-mapped IO port space [mem 0xf8110000000-0xf8110000fff]
>   HWP0002:09: host bridge window [io  0x1000000-0x1000fff] (PCI address [0x0-0xfff])
> 
> The CPU physical memory [mem 0xf8010000000-0xf8010000fff] is translated by
> the bridge to I/O ports 0x0000-0x0fff on PCI bus 0000:00.  Drivers use,
> e.g., "inb(0)" to access it.
> 
> Similarly, [mem 0xf8110000000-0xf8110000fff] is translated by the second
> bridge to I/O ports 0x0000-0x0fff on PCI bus 0001:00.  Drivers use
> "inb(0x1000000)" to access it.

I guess you are thinking of the IA64 model here where you keep the virtual
I/O port numbers in a per-bus lookup table that gets accessed for each
inb() call. I've thought about this some more, and I believe there are good
reasons for sticking with the model used on arm32 and powerpc for the
generic OF implementation.

The idea is that there is a single virtual memory range for all I/O port
mappings and we use the MMU to do the translation rather than computing
it manually in the inb() implemnetation. The main advantage is that all
functions used in device drivers to (potentially) access I/O ports
become trivial this way, which helps for code size and in some cases
(e.g. SoC-internal registers with a low latency) it may even be performance
relevant.

What this scheme gives you is a set of functions that literally do:

/* architecture specific virtual address */
#define PCI_IOBASE (void __iomem *)0xabcd00000000000

static inline u32 inl(unsigned long port)
{
	return readl(port + PCI_IOBASE);
}

static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
{
	return port + PCI_IOBASE;
}

static inline unsigned int ioread32(void __iomem *p)
{
	return readl(p);
}

Since we want this to work on 32-bit machines, the virtual I/O space has
to be rather tightly packed, so Liviu's algorithm just picks the next
available address for each new I/O space.

> pci_register_io_range() seems sort of like it's intended to track the
> memory-mapped IO port spaces, e.g., [mem 0xf8010000000-0xf8010000fff].
> But I would think you'd want to keep track of at least the base port
> number on the PCI bus, too.  Or is that why it's weak?

The PCI bus start address only gets factored in when the window is registered
with the PCI core in patch 8/9, where we go over all ranges doing

+               pci_add_resource_offset(resources, res,
+                               res->start - range.pci_addr);

With Liviu's patch, this can be done in exactly the same way for both
MMIO and PIO spaces.

> Here's what these look like in /proc/iomem and /proc/ioports (note that
> there are two resource structs for each memory-mapped IO port space: one
> IORESOURCE_MEM for the memory-mapped area (used only by the host bridge
> driver), and one IORESOURCE_IO for the I/O port space (this becomes the
> parent of a region used by a regular device driver):
> 
>   /proc/iomem:
>     PCI Bus 0000:00 I/O Ports 00000000-00000fff
>     PCI Bus 0001:00 I/O Ports 01000000-01000fff
> 
>   /proc/ioports:
>     00000000-00000fff : PCI Bus 0000:00
>     01000000-01000fff : PCI Bus 0001:00

The only difference I'd expect here is that the last line would make it
packed more tightly, so it's instead

  /proc/ioports:
     00000000-00000fff : PCI Bus 0000:00
     00001000-00001fff : PCI Bus 0001:00

In practice we'd probably have 64KB per host controller, and each of them 
would be a separate domain. I think we normally don't register the
IORESOURCE_MEM resource, but I agree it's a good idea and we should
always do that.

	Arnd
