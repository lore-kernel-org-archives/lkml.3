Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbaBFKSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:18:25 -0500
Received: from service87.mimecast.com ([91.220.42.44]:40389 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537AbaBFKSU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:18:20 -0500
Date: Thu, 6 Feb 2014 10:18:15 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] pci: Add support for creating a generic host_bridge from
 device tree
Message-ID: <20140206101814.GA4993@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Tanmay Inamdar <tinamdar@apm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	Will Deacon <Will.Deacon@arm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	LAKML <linux-arm-kernel@lists.infradead.org>
References: <1391452428-22917-1-git-send-email-Liviu.Dudau@arm.com>
 <1391452428-22917-2-git-send-email-Liviu.Dudau@arm.com>
 <7398333.9L5KlyFggU@wuerfel>
 <CACoXjckKRQfR3CbC1JpgbhOumED+OqiMh1_Y73-h6q=ByMNanw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACoXjckKRQfR3CbC1JpgbhOumED+OqiMh1_Y73-h6q=ByMNanw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 06 Feb 2014 10:18:15.0379 (UTC) FILETIME=[BF636230:01CF2324]
X-MC-Unique: 114020610181702201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 10:26:27PM +0000, Tanmay Inamdar wrote:
> Hello Liviu,
> 
> I did not get the first email of this particular patch on any of
> subscribed mailing lists (don't know why), hence replying here.

Strange, it shows in the MARC and GMANE archive for linux-pci, probably
a hickup on your receiving side?

> 
> +struct pci_host_bridge *
> +pci_host_bridge_of_init(struct device *parent, int busno, struct pci_ops *ops,
> + void *host_data, struct list_head *resources)
> +{
> + struct pci_bus *root_bus;
> + struct pci_host_bridge *bridge;
> +
> + /* first parse the host bridge bus ranges */
> + if (pci_host_bridge_of_get_ranges(parent->of_node, resources))
> + return NULL;
> +
> + /* then create the root bus */
> + root_bus = pci_create_root_bus(parent, busno, ops, host_data, resources);
> + if (!root_bus)
> + return NULL;
> +
> + bridge = to_pci_host_bridge(root_bus->bridge);
> +
> + return bridge;
> +}
> 
> You are keeping the domain_nr inside pci_host_bridge structure. In
> above API, domain_nr is required in 'pci_find_bus' function called
> from 'pci_create_root_bus'. Since the bridge is allocated after
> creating root bus, 'pci_find_bus' always gets domain_nr as 0. This
> will cause problem for scanning multiple domains.

Good catch. I was switching between creating a pci_controller in arch/arm64 and
adding the needed bits in pci_host_bridge. After internal review I've decided to
add the domain_nr to pci_host_bridge, but forgot to update the code everywhere.

Thanks for reviewing this, will fix in v2.

Do you find porting to the new API straight forward?

Best regards,
Liviu

> 
> 
> On Mon, Feb 3, 2014 at 10:46 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 03 February 2014 18:33:48 Liviu Dudau wrote:
> >> +/**
> >> + * pci_host_bridge_of_get_ranges - Parse PCI host bridge resources from DT
> >> + * @dev: device node of the host bridge having the range property
> >> + * @resources: list where the range of resources will be added after DT parsing
> >> + *
> >> + * This function will parse the "ranges" property of a PCI host bridge device
> >> + * node and setup the resource mapping based on its content. It is expected
> >> + * that the property conforms with the Power ePAPR document.
> >> + *
> >> + * Each architecture will then apply their filtering based on the limitations
> >> + * of each platform. One general restriction seems to be the number of IO space
> >> + * ranges, the PCI framework makes intensive use of struct resource management,
> >> + * and for IORESOURCE_IO types they can only be requested if they are contained
> >> + * within the global ioport_resource, so that should be limited to one IO space
> >> + * range.
> >
> > Actually we have quite a different set of restrictions around I/O space on ARM32
> > at the moment: Each host bridge can have its own 64KB range in an arbitrary
> > location on MMIO space, and the total must not exceed 2MB of I/O space.
> >
> >> + */
> >> +static int pci_host_bridge_of_get_ranges(struct device_node *dev,
> >> +                                     struct list_head *resources)
> >> +{
> >> +     struct resource *res;
> >> +     struct of_pci_range range;
> >> +     struct of_pci_range_parser parser;
> >> +     int err;
> >> +
> >> +     pr_info("PCI host bridge %s ranges:\n", dev->full_name);
> >> +
> >> +     /* Check for ranges property */
> >> +     err = of_pci_range_parser_init(&parser, dev);
> >> +     if (err)
> >> +             return err;
> >> +
> >> +     pr_debug("Parsing ranges property...\n");
> >> +     for_each_of_pci_range(&parser, &range) {
> >> +             /* Read next ranges element */
> >> +             pr_debug("pci_space: 0x%08x pci_addr:0x%016llx ",
> >> +                             range.pci_space, range.pci_addr);
> >> +             pr_debug("cpu_addr:0x%016llx size:0x%016llx\n",
> >> +                                     range.cpu_addr, range.size);
> >> +
> >> +             /* If we failed translation or got a zero-sized region
> >> +              * (some FW try to feed us with non sensical zero sized regions
> >> +              * such as power3 which look like some kind of attempt
> >> +              * at exposing the VGA memory hole) then skip this range
> >> +              */
> >> +             if (range.cpu_addr == OF_BAD_ADDR || range.size == 0)
> >> +                     continue;
> >> +
> >> +             res = kzalloc(sizeof(struct resource), GFP_KERNEL);
> >> +             if (!res) {
> >> +                     err = -ENOMEM;
> >> +                     goto bridge_ranges_nomem;
> >> +             }
> >> +
> >> +             of_pci_range_to_resource(&range, dev, res);
> >> +
> >> +             pci_add_resource_offset(resources, res,
> >> +                             range.cpu_addr - range.pci_addr);
> >> +     }
> >
> > I believe of_pci_range_to_resource() will return the MMIO aperture for the
> > I/O space window here, which is not what you are supposed to pass into
> > pci_add_resource_offset.
> >
> >> +EXPORT_SYMBOL(pci_host_bridge_of_init);
> >
> > EXPORT_SYMBOL_GPL
> >
> >> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> >> index 6e34498..16febae 100644
> >> --- a/drivers/pci/probe.c
> >> +++ b/drivers/pci/probe.c
> >> @@ -1787,6 +1787,17 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
> >>       list_for_each_entry_safe(window, n, resources, list) {
> >>               list_move_tail(&window->list, &bridge->windows);
> >>               res = window->res;
> >> +             /*
> >> +              * IO resources are stored in the kernel with a CPU start
> >> +              * address of zero. Adjust the data accordingly and remember
> >> +              * the offset
> >> +              */
> >> +             if (resource_type(res) == IORESOURCE_IO) {
> >> +                     bridge->io_offset = res->start;
> >> +                     res->end -= res->start;
> >> +                     window->offset -= res->start;
> >> +                     res->start = 0;
> >> +             }
> >>               offset = window->offset;
> >>               if (res->flags & IORESOURCE_BUS)
> >
> > Won't this break all existing host bridges?
> >
> >         Arnd
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
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

