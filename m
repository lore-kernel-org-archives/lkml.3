Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbaHVMoB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:44:01 -0400
Received: from dliviu.plus.com ([80.229.23.120]:43749 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269AbaHVMn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:43:59 -0400
Date: Fri, 22 Aug 2014 13:43:26 +0100
From: Liviu Dudau <liviu@dudau.co.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 12/12] PCI: Introduce pci_remap_iospace() for
 remapping PCI I/O bus resources into CPU space
Message-ID: <20140822124326.GL13147@bart.dudau.co.uk>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
 <1407860725-25202-13-git-send-email-Liviu.Dudau@arm.com>
 <CAL_JsqK6XiuS7OJ_2F16ySA8oj9AHqP0fAft21AOtJxXP2SqnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL_JsqK6XiuS7OJ_2F16ySA8oj9AHqP0fAft21AOtJxXP2SqnQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri Aug 22 13:43:57 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 13,53f73b0d3121195487463
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 11:16:16PM -0500, Rob Herring wrote:
> On Tue, Aug 12, 2014 at 11:25 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > Introduce a default implementation for remapping PCI bus I/O resources
> > onto the CPU address space. Architectures with special needs may
> > provide their own version, but most should be able to use this one.
> >
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> 
> Reviewed-by: Rob Herring <robh@kernel.org>

Thanks, Rob, much appreciated!

> 
> However, I would like to see ARM pci_ioremap_io converted over to this function.

Do you care if this is done as a separate patch?

Best regards,
Liviu

> 
> Rob
> 
> > ---
> >  drivers/pci/pci.c   | 33 +++++++++++++++++++++++++++++++++
> >  include/linux/pci.h |  3 +++
> >  2 files changed, 36 insertions(+)
> >
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index 29d1775..76d21b6 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -2707,6 +2707,39 @@ int pci_request_regions_exclusive(struct pci_dev *pdev, const char *res_name)
> >  }
> >  EXPORT_SYMBOL(pci_request_regions_exclusive);
> >
> > +/**
> > + *     pci_remap_iospace - Remap the memory mapped I/O space
> > + *     @res: Resource describing the I/O space
> > + *     @phys_addr: physical address where the range will be mapped.
> > + *
> > + *     Remap the memory mapped I/O space described by the @res
> > + *     into the CPU physical address space. Only architectures
> > + *     that have memory mapped IO defined (and hence PCI_IOBASE)
> > + *     should call this function.
> > + */
> > +int __weak pci_remap_iospace(const struct resource *res, phys_addr_t phys_addr)
> > +{
> > +       int err = -ENODEV;
> > +
> > +#ifdef PCI_IOBASE
> > +       if (!(res->flags & IORESOURCE_IO))
> > +               return -EINVAL;
> > +
> > +       if (res->end > IO_SPACE_LIMIT)
> > +               return -EINVAL;
> > +
> > +       err = ioremap_page_range(res->start + (unsigned long)PCI_IOBASE,
> > +                               res->end + 1 + (unsigned long)PCI_IOBASE,
> > +                               phys_addr, pgprot_device(PAGE_KERNEL));
> > +#else
> > +       /* this architecture does not have memory mapped I/O space,
> > +          so this function should never be called */
> > +       WARN_ON(1);
> > +#endif
> > +
> > +       return err;
> > +}
> > +
> >  static void __pci_set_master(struct pci_dev *dev, bool enable)
> >  {
> >         u16 old_cmd, cmd;
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index e1e0d80..988c2f5 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -1098,6 +1098,9 @@ int __must_check pci_bus_alloc_resource(struct pci_bus *bus,
> >                                                   resource_size_t),
> >                         void *alignf_data);
> >
> > +
> > +int pci_remap_iospace(const struct resource *res, phys_addr_t phys_addr);
> > +
> >  static inline dma_addr_t pci_bus_address(struct pci_dev *pdev, int bar)
> >  {
> >         struct pci_bus_region region;
> > --
> > 2.0.4
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
-------------------
   .oooO
   (   )
    \ (  Oooo.
     \_) (   )
          ) /
         (_/

 One small step
   for me ...

