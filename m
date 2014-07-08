Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaGHW1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:27:48 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53455 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200AbaGHW1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:27:44 -0400
Date: Tue, 8 Jul 2014 23:27:38 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 8/9] pci: Add support for creating a generic
 host_bridge from device tree
Message-ID: <20140708222738.GA4980@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-9-git-send-email-Liviu.Dudau@arm.com>
 <20140708010103.GD22939@google.com>
 <20140708102940.GZ6501@e106497-lin.cambridge.arm.com>
 <20140708213305.GB4555@google.com>
MIME-Version: 1.0
In-Reply-To: <20140708213305.GB4555@google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 08 Jul 2014 22:27:39.0476 (UTC) FILETIME=[D39CA140:01CF9AFB]
X-MC-Unique: 114070823274200201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 10:33:05PM +0100, Bjorn Helgaas wrote:
> On Tue, Jul 08, 2014 at 11:29:40AM +0100, Liviu Dudau wrote:
> > On Tue, Jul 08, 2014 at 02:01:04AM +0100, Bjorn Helgaas wrote:
> > > On Tue, Jul 01, 2014 at 07:43:33PM +0100, Liviu Dudau wrote:
> > > > ...
> > > > +     for_each_of_pci_range(&parser, &range) {
> > > > +             /* Read next ranges element */
> > > > +             pr_debug("pci_space: 0x%08x pci_addr:0x%016llx cpu_addr:0x%016llx size:0x%016llx\n",
> > > > +                     range.pci_space, range.pci_addr, range.cpu_addr, range.size);
> > > 
> > > If you're not trying to match other printk formats, you could try to match
> > > the %pR format used elsewhere, e.g., "%#010llx-%#010llx" with
> > > range.cpu_addr, range.cpu_addr + range.size - 1.
> > 
> > Yes, not a big fan of the ugly output it generates, but the output matches closely the ranges
> > definition in the device tree file so it is easy to validate that you are parsing the right
> > entry. I am happy to change it to shorten the cpu range message.
> 
> If it already matches other device tree stuff, that's perfect.  I'm not
> familiar with that.
> 
> > > > +int __weak pcibios_fixup_bridge_ranges(struct list_head *resources)
> > > > +{
> > > > +     return 0;
> > > > +}
> > > 
> > > I'd wait to add this until there's a platform that needs to implement it.
> > > Splitting it out will make this patch that much smaller and easier to
> > > understand.
> > 
> > I need this as this is the default implementation (i.e. do nothing). Otherwise the
> > link phase will give errors. 
> 
> I meant that you could remove the default implementation *and* the call of
> it, since it currently does nothing.

True. But it looks like converting Will's pci-host-generic.c driver will make use of this.

> 
> > > > diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
> > > > index dde3a4a..71e36d0 100644
> > > > --- a/include/linux/of_pci.h
> > > > +++ b/include/linux/of_pci.h
> > > > @@ -15,6 +15,9 @@ struct device_node *of_pci_find_child_device(struct device_node *parent,
> > > >  int of_pci_get_devfn(struct device_node *np);
> > > >  int of_irq_parse_and_map_pci(const struct pci_dev *dev, u8 slot, u8 pin);
> > > >  int of_pci_parse_bus_range(struct device_node *node, struct resource *res);
> > > > +struct pci_host_bridge *of_create_pci_host_bridge(struct device *parent,
> > > > +                                     struct pci_ops *ops, void *host_data);
> > > > +
> > > >  #else
> > > >  static inline int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *out_irq)
> > > >  {
> > > > @@ -43,6 +46,13 @@ of_pci_parse_bus_range(struct device_node *node, struct resource *res)
> > > >  {
> > > >       return -EINVAL;
> > > >  }
> > > > +
> > > > +static inline struct pci_host_bridge *
> > > > +of_create_pci_host_bridge(struct device *parent, struct pci_ops *ops,
> > > > +                     void *host_data)
> > > > +{
> > > > +     return NULL;
> > > > +}
> > > >  #endif
> > > >
> > > >  #if defined(CONFIG_OF) && defined(CONFIG_PCI_MSI)
> > > > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > > > index 7e7b939..556dc5f 100644
> > > > --- a/include/linux/pci.h
> > > > +++ b/include/linux/pci.h
> > > > @@ -402,6 +402,7 @@ struct pci_host_bridge {
> > > >       struct device dev;
> > > >       struct pci_bus *bus;            /* root bus */
> > > >       int domain_nr;
> > > > +     resource_size_t io_base;        /* physical address for the start of I/O area */
> > > 
> > > I don't see where this is used yet.
> > 
> > It's used in pci_host_bridge_of_get_ranges() (earlier in this patch).
> 
> of_create_pci_host_bridge() fills in bridge->io_base, but I don't see
> anything that ever *reads* bridge->io_base.

Ah, understood. It is used by the host bridge drivers to set their ATR registers to the
correct CPU address values.

> 
> > > As far as I know, there's nothing that prevents a host bridge from having
> > > several I/O port apertures (or several memory-mapped I/O port spaces).
> > 
> > The pci_register_io_range() will give different offsets for each apperture.
> > I just need to make sure I don't overwrite io_base when parsing multiple IO
> > ranges.
> 
> Let's continue this in the other thread where I'm trying to understand the
> I/O apertures.  Obviously I'm still missing something if you can indeed
> have multiple I/O apertures per bridge (because then only one of them can
> start at I/O address 0 on PCI).

Sure.

Thanks,
Liviu

> 
> Bjorn
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

