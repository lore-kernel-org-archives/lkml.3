Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaGHKDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 06:03:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50419 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaGHKDi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 06:03:38 -0400
Date: Tue, 8 Jul 2014 11:03:32 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robherring2@gmail.com>, Sinan Kaya <okaya@codeaurora.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Device Tree ML <devicetree@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>, Will Deacon <Will.Deacon@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>, Tanmay Inamdar <tinamdar@apm.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v8 4/9] pci: OF: Fix the conversion of IO ranges into IO
 resources.
Message-ID: <20140708100332.GW6501@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <6122131.ozzYjjjRQi@wuerfel>
 <20140707111133.GP6501@e106497-lin.cambridge.arm.com>
 <201407072322.00990.arnd@arndb.de>
MIME-Version: 1.0
In-Reply-To: <201407072322.00990.arnd@arndb.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 08 Jul 2014 10:03:33.0489 (UTC) FILETIME=[E087A610:01CF9A93]
X-MC-Unique: 114070811033505501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 10:22:00PM +0100, Arnd Bergmann wrote:
> On Monday 07 July 2014, Liviu Dudau wrote:
> > On Sat, Jul 05, 2014 at 09:46:09PM +0100, Arnd Bergmann wrote:
> > > On Saturday 05 July 2014 14:25:52 Rob Herring wrote:
> > > > On Tue, Jul 1, 2014 at 1:43 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > > > > The ranges property for a host bridge controller in DT describes
> > > > > the mapping between the PCI bus address and the CPU physical address.
> > > > > The resources framework however expects that the IO resources start
> > > > > at a pseudo "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.
> > > > > The conversion from pci ranges to resources failed to take that into account.
> > > > 
> > > > I don't think this change is right. There are 2 resources: the PCI bus
> > > > addresses and cpu addresses. This function deals with the cpu
> > > > addresses. Returning pci addresses for i/o and cpu addresses for
> > > > memory is going to be error prone. We probably need both cpu and pci
> > > > resources exposed to host controllers.
> > > > 
> > > > Making the new function only deal with i/o bus resources and naming it
> > > > of_pci_range_to_io_resource would be better.
> > > 
> > > I think you are correct that this change by itself is will break existing
> > > drivers that rely on the current behavior of of_pci_range_to_resource,
> > > but there is also something wrong with the existing implementation:
> > 
> > Either I'm very confused or I've managed to confuse everyone else. The I/O
> > resources described using CPU addresses *are* using "pseudo" port based
> > addresses (or at least that is my understanding and my reading of the code).
> > Can you point me to a function that is expecting the IO resource to have
> > the start address at the physical address of the mapped space?
> 
> pci_v3_preinit() in arch/arm/mach-integrator/pci_v3.c for instance takes
> the resource returned by of_pci_range_to_resource and programs the
> start and size into hardware registers that expect a physical address
> as far as I can tell.
> 
> > I was trying to fix exactly this issue, that you cannot use the resource
> > structure returned by this function in any call that is expecting an IO
> > resource.
> 
> I looked at the other drivers briefly, and I think you indeed fix the Tegra
> driver with this but break the integrator driver as mentioned above.
> The other callers of of_pci_range_to_resource() are apparently not
> impacted as they recalculate the values they get.

I would argue that integrator version is having broken assumptions. If it would
try to allocate that IO range or request the resource as returned currently by
of_pci_range_to_resource (without my patch) it would fail. I know because I did
the same thing in my host bridge driver and it failed miserably. That's why I
tried to patch it.

I will lay out my argument here and people can tell me if I am wrong:

PCI IO resources (even if they are memory mapped on certain architectures) need
to emulate the x86 world "port" concept. Why do I think this? Because of this
structure at the beginning of kernel/resource.c:

struct resource ioport_resource = {
	.name	= "PCI IO",
	.start	= 0,
	.end	= IO_SPACE_LIMIT,
	.flags	= IORESOURCE_IO,
};
EXPORT_SYMBOL(ioport_resource);

The other resource that people seem to confuse it with is the next one in that
file:

struct resource iomem_resource = {
	.name	= "PCI mem",
	.start	= 0,
	.end	= -1,
	.flags	= IORESOURCE_MEM,
};
EXPORT_SYMBOL(iomem_resource);

Now, there are architecture that override the .start and .end values, but arm
is not one of those, and mach-integrator doesn't change it either. So one can
play with the ioport_resource values to move the "port" window wherever he/she
wants, but it doesn't change the "port access" way of addressing it.

If the IO space is memory mapped, then we use the port number, the io_offset
and the PCI_IOBASE to get to the virtual address that, when accessed, will
generate the correct addresses on the bus, based on what the host bridge has
been configured.

This is the current level of my understanding of PCI IO.

Now, I believe Rob has switched entirely to using my series in some test that
he has run and he hasn't encountered any issues, as long as one remembers in
the host bridge driver to add the io_base offset to the .start resource. If
not then I need to patch pci_v3.c.

Best regards,
Liviu

> 
> 	Arnd
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

