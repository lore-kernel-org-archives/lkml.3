Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbaHVNJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:09:27 -0400
Received: from dliviu.plus.com ([80.229.23.120]:43846 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279AbaHVNJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:09:25 -0400
Date: Fri, 22 Aug 2014 14:06:40 +0100
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
Subject: Re: [PATCH v9 04/12] PCI: OF: Fix the conversion of IO ranges into
 IO resources.
Message-ID: <20140822130640.GM13147@bart.dudau.co.uk>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
 <1407860725-25202-5-git-send-email-Liviu.Dudau@arm.com>
 <CAL_JsqJm6qWNdrJ2F8xddFUj46y42n6hQVu1nkTaA-5Tbg--XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL_JsqJm6qWNdrJ2F8xddFUj46y42n6hQVu1nkTaA-5Tbg--XQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Aug 22 14:09:23 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 13,53f741033125885510231
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 11:08:48PM -0500, Rob Herring wrote:
> On Tue, Aug 12, 2014 at 11:25 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > The ranges property for a host bridge controller in DT describes
> > the mapping between the PCI bus address and the CPU physical address.
> > The resources framework however expects that the IO resources start
> > at a pseudo "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.
> > The conversion from pci ranges to resources failed to take that into account.
> >
> > In the process move the function into drivers/of/address.c as it now
> > depends on pci_address_to_pio() code and make it return an error code.
> >
> > Cc: Grant Likely <grant.likely@linaro.org>
> > Cc: Rob Herring <robh+dt@kernel.org>
> 
> Humm, this says I'm cc'ed, but I'm not which defeats the point of
> recording the Cc's in the commit.

Appologies, I've screwed up my git send-email arguments.

> 
> I still have the same concerns that this will break existing users.
> Are you sure integrator is the only platform affected?

microblaze and powerpc have their similar handcoded routine for parsing ranges
where they pre-compute the io_base and adjust the values again when registering
resources. I'm not absolutely sure they are not broken as I lack the appropriate
platforms to test (I've been asking for an FPGA engineer to build me a microblaze
image with all the bits included but haven't received anything yet and it is
possible Xilinx has now shifted their interests towards ARM + PCI as the ML605
board that I have seems to have been discontinued).

mips is doing the same thing and I believe is not affected, pci-host-generic.c
was adjusting the returned values afterwards so that will not be needed and Lorenzo
has a patch for the driver to adapt it to this series anyway.

pcie-designware.c also recalculates the io.start and io.end values, so that's fine
for now. The only ones that I believe are still affected are pci-tegra.c and
pcie-rcar.c for which I will need to provide a patch similar to integrator unless
the code gets converted to the new range parsing.

Best regards,
Liviu

> 
> Rob
> 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > ---
> >  drivers/of/address.c       | 46 ++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/of_address.h | 13 ++-----------
> >  2 files changed, 48 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/of/address.c b/drivers/of/address.c
> > index 4dab700..3735ac7 100644
> > --- a/drivers/of/address.c
> > +++ b/drivers/of/address.c
> > @@ -906,3 +906,49 @@ bool of_dma_is_coherent(struct device_node *np)
> >         return false;
> >  }
> >  EXPORT_SYMBOL_GPL(of_dma_is_coherent);
> > +
> > +/*
> > + * of_pci_range_to_resource - Create a resource from an of_pci_range
> > + * @range:     the PCI range that describes the resource
> > + * @np:                device node where the range belongs to
> > + * @res:       pointer to a valid resource that will be updated to
> > + *              reflect the values contained in the range.
> > + *
> > + * Returns EINVAL if the range cannot be converted to resource.
> > + *
> > + * Note that if the range is an IO range, the resource will be converted
> > + * using pci_address_to_pio() which can fail if it is called too early or
> > + * if the range cannot be matched to any host bridge IO space (our case here).
> > + * To guard against that we try to register the IO range first.
> > + * If that fails we know that pci_address_to_pio() will do too.
> > + */
> > +int of_pci_range_to_resource(struct of_pci_range *range,
> > +       struct device_node *np, struct resource *res)
> > +{
> > +       int err;
> > +       res->flags = range->flags;
> > +       res->parent = res->child = res->sibling = NULL;
> > +       res->name = np->full_name;
> > +
> > +       if (res->flags & IORESOURCE_IO) {
> > +               unsigned long port = -1;
> > +               err = pci_register_io_range(range->cpu_addr, range->size);
> > +               if (err)
> > +                       goto invalid_range;
> > +               port = pci_address_to_pio(range->cpu_addr);
> > +               if (port == (unsigned long)-1) {
> > +                       err = -EINVAL;
> > +                       goto invalid_range;
> > +               }
> > +               res->start = port;
> > +       } else {
> > +               res->start = range->cpu_addr;
> > +       }
> > +       res->end = res->start + range->size - 1;
> > +       return 0;
> > +
> > +invalid_range:
> > +       res->start = (resource_size_t)OF_BAD_ADDR;
> > +       res->end = (resource_size_t)OF_BAD_ADDR;
> > +       return err;
> > +}
> > diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> > index 28e6836..6015f21 100644
> > --- a/include/linux/of_address.h
> > +++ b/include/linux/of_address.h
> > @@ -23,17 +23,8 @@ struct of_pci_range {
> >  #define for_each_of_pci_range(parser, range) \
> >         for (; of_pci_range_parser_one(parser, range);)
> >
> > -static inline void of_pci_range_to_resource(struct of_pci_range *range,
> > -                                           struct device_node *np,
> > -                                           struct resource *res)
> > -{
> > -       res->flags = range->flags;
> > -       res->start = range->cpu_addr;
> > -       res->end = range->cpu_addr + range->size - 1;
> > -       res->parent = res->child = res->sibling = NULL;
> > -       res->name = np->full_name;
> > -}
> > -
> > +extern int of_pci_range_to_resource(struct of_pci_range *range,
> > +               struct device_node *np, struct resource *res);
> >  /* Translate a DMA address from device space to CPU space */
> >  extern u64 of_translate_dma_address(struct device_node *dev,
> >                                     const __be32 *in_addr);
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

