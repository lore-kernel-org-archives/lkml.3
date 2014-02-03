Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaBCWRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:17:49 -0500
Received: from service87.mimecast.com ([91.220.42.44]:44271 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaBCWRq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:17:46 -0500
Date: Mon, 3 Feb 2014 22:17:44 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH] pci: Add support for creating a generic host_bridge from
 device tree
Message-ID: <20140203221743.GB24036@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>
References: <1391452428-22917-1-git-send-email-Liviu.Dudau@arm.com>
 <7398333.9L5KlyFggU@wuerfel>
 <20140203190649.GB4889@e106497-lin.cambridge.arm.com>
 <3523674.i9iUPinOAk@wuerfel>
MIME-Version: 1.0
In-Reply-To: <3523674.i9iUPinOAk@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 03 Feb 2014 22:17:44.0478 (UTC) FILETIME=[C2EFE3E0:01CF212D]
X-MC-Unique: 114020322174408001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 07:31:31PM +0000, Arnd Bergmann wrote:
> On Monday 03 February 2014 19:06:49 Liviu Dudau wrote:
> > On Mon, Feb 03, 2014 at 06:46:10PM +0000, Arnd Bergmann wrote:
> > > On Monday 03 February 2014 18:33:48 Liviu Dudau wrote:
> > > > +/**
> > > > + * pci_host_bridge_of_get_ranges - Parse PCI host bridge resources from DT
> > > > + * @dev: device node of the host bridge having the range property
> > > > + * @resources: list where the range of resources will be added after DT parsing
> > > > + *
> > > > + * This function will parse the "ranges" property of a PCI host bridge device
> > > > + * node and setup the resource mapping based on its content. It is expected
> > > > + * that the property conforms with the Power ePAPR document.
> > > > + *
> > > > + * Each architecture will then apply their filtering based on the limitations
> > > > + * of each platform. One general restriction seems to be the number of IO space
> > > > + * ranges, the PCI framework makes intensive use of struct resource management,
> > > > + * and for IORESOURCE_IO types they can only be requested if they are contained
> > > > + * within the global ioport_resource, so that should be limited to one IO space
> > > > + * range.
> > >
> > > Actually we have quite a different set of restrictions around I/O space on ARM32
> > > at the moment: Each host bridge can have its own 64KB range in an arbitrary
> > > location on MMIO space, and the total must not exceed 2MB of I/O space.
> > 
> > And that is why the filtering is not (yet) imposed in the generic code. But once
> > you use pci_request_region, that will call request_region which will check
> > against ioport_resource as parent for the requested resource. That should fail
> > if is is not in the correct range, so I don't know how arm arch code manages
> > multiple IO ranges.
> 
> Let's try to come up with nomenclature so we can talk about this better
> 
> The ioport_resource is in "logical I/O space", which is a Linux fiction,
> it goes from 0 to IO_SPACE_LIMIT (2MB on ARM) and is mapped into "virtual
> I/O space", which start at (void __iomem *)PCI_IO_VIRT_BASE.
> 
> Each PCI domain can have its own "bus I/O aperture", which is typically
> between 0x1000 and 0xffff and reflects the address that is used in PCI
> transactions and in BARs. 

Actually, the bus I/O aperture can start from 0x0000 if you are talking about
PCI bus addresses.

> The aperture here reflects the subset of the
> 4GB bus I/O space that is actually mapped into a CPU visible "physical
> I/O aperture" using an inbound mapping of the host bridge. The physical
> I/O aperture in turn gets mapped to the virtual I/O space using 
> pci_ioremap_io. 

Agree.

> The difference between a bus I/O address and a logical
> I/O address is stored in the io_offset.

Not exactly. If that would be true that means that for an I/O range that
start at bus I/O address zero but physical I/O apperture starts at
0x40000000 the io_offset is zero. For me, the io_offset should be 0x40000000.

Let me see if I can summarise this correctly, using only CPU addresses:

0x0000 - IO_SPACE_LIMIT           <-  logical I/O address
0xPPPPPPPP - 0xPPPPPPPP+IO_SIZE   <-  physical address for PCI I/O space
0xVVVVVVVV - 0xVVVVVVVV+IO_SPACE_LIMIT <- virtual address for I/O

The io_offset then is 0xPPPPPPPP - logical I/O address. At least that is
the intent of the io_offset variable that I introduced in pci_host_bridge.

The bus I/O address is generated by the host bridge, I think we can ignore
it here as it tends to confuse the message.

> 
> So much for basic definitions. When a device driver calls pci_request_region,
> the port number it sees is the bus I/O port number adjusted using the
> io_offset to turn it into a logical I/O port number, which should
> always be within the host bridge window, which in turn is a subset
> of the ioport_resource.

My understanding is that device drivers all user port numbers that are logical
I/O numbers, so no io_offset needs to be applied here. It is only when one
wants to access the port, that the translation happens. First, inb or outb
will add the PCI_IO_VIRT_BASE to generate the virtual address, the MMU will
then convert that address to physical address and the host bridge will
then translate the physical address into bus address.



> 
> > > > +static int pci_host_bridge_of_get_ranges(struct device_node *dev,
> > > > +                                   struct list_head *resources)
> > > > +{
> > > > +   struct resource *res;
> > > > +   struct of_pci_range range;
> > > > +   struct of_pci_range_parser parser;
> > > > +   int err;
> > > > +
> > > > +   pr_info("PCI host bridge %s ranges:\n", dev->full_name);
> > > > +
> > > > +   /* Check for ranges property */
> > > > +   err = of_pci_range_parser_init(&parser, dev);
> > > > +   if (err)
> > > > +           return err;
> > > > +
> > > > +   pr_debug("Parsing ranges property...\n");
> > > > +   for_each_of_pci_range(&parser, &range) {
> > > > +           /* Read next ranges element */
> > > > +           pr_debug("pci_space: 0x%08x pci_addr:0x%016llx ",
> > > > +                           range.pci_space, range.pci_addr);
> > > > +           pr_debug("cpu_addr:0x%016llx size:0x%016llx\n",
> > > > +                                   range.cpu_addr, range.size);
> > > > +
> > > > +           /* If we failed translation or got a zero-sized region
> > > > +            * (some FW try to feed us with non sensical zero sized regions
> > > > +            * such as power3 which look like some kind of attempt
> > > > +            * at exposing the VGA memory hole) then skip this range
> > > > +            */
> > > > +           if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
> > > > +                   continue;
> > > > +
> > > > +           res = kzalloc(sizeof(struct resource), GFP_KERNEL);
> > > > +           if (!res) {
> > > > +                   err = -ENOMEM;
> > > > +                   goto bridge_ranges_nomem;
> > > > +           }
> > > > +
> > > > +           of_pci_range_to_resource(&range, dev, res);
> > > > +
> > > > +           pci_add_resource_offset(resources, res,
> > > > +                           range.cpu_addr - range.pci_addr);
> > > > +   }
> > >
> > > I believe of_pci_range_to_resource() will return the MMIO aperture for the
> > > I/O space window here, which is not what you are supposed to pass into
> > > pci_add_resource_offset.
> > 
> > And that is why the code in probe.c has been added to deal with that. It is
> > too early to do the adjustments here as all we have is the list of resources
> > and that might get culled by the architecture fixup code. Remembering the
> > io_offset will happen once the pci_host_bridge gets created, and the resources
> > are then adjusted.
> 
> So you want to register an incorrect I/O resource first and then
> have it fixed up later, rather than registering the correct
> one from the start as everyone else?

The incorrect I/O resource is added to a temporary list of resources, it has not
been attached yet to the list of windows in the bridge. What gets added is the
I/O resource as described if it would be an ordinary resource.

> 
> > > > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> > > > index 6e34498..16febae 100644
> > > > --- a/drivers/pci/probe.c
> > > > +++ b/drivers/pci/probe.c
> > > > @@ -1787,6 +1787,17 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
> > > >     list_for_each_entry_safe(window, n, resources, list) {
> > > >             list_move_tail(&window->list, &bridge->windows);
> > > >             res = window->res;
> > > > +           /*
> > > > +            * IO resources are stored in the kernel with a CPU start
> > > > +            * address of zero. Adjust the data accordingly and remember
> > > > +            * the offset
> > > > +            */
> > > > +           if (resource_type(res) == IORESOURCE_IO) {
> > > > +                   bridge->io_offset = res->start;
> > > > +                   res->end -= res->start;
> > > > +                   window->offset -= res->start;
> > > > +                   res->start = 0;
> > > > +           }

Here, we correct for the fact that IORESOURCE_IO is not a normal resource, because Linux wants
a logical I/O as start and end address, not the physical CPU address. We adjust to that and
remember the offset.


> > > >             offset = window->offset;
> > > >             if (res->flags & IORESOURCE_BUS)
> > >
> > > Won't this break all existing host bridges?
> > 
> > I am not sure. I believe not, due to what I've explained earlier, but you might be right.
> > 
> > The adjustment happens before the resource is added to the host bridge windows and translates
> > it from MMIO range into IO range.
> 
> AFAICT, the resource_type of the resource you register above should be
> IORESOURCE_MEM, so you are not actually matching it here.

No, all resources are added here. For IORESOURCE_IO we do an adjustment.

Best regards,
Liviu

> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
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

