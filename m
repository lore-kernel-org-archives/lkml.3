Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaIHP7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:59:39 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42916 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbaIHP7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:59:36 -0400
Date: Mon, 8 Sep 2014 16:59:31 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v10 07/10] OF: Introduce helper function for getting PCI
 domain_nr
Message-ID: <20140908155931.GP27864@e106497-lin.cambridge.arm.com>
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com>
 <1410184472-17630-8-git-send-email-Liviu.Dudau@arm.com>
 <CAL_JsqJi8k1Goc3UmXhuxf9v7=4gJrYG_Di7v574PxS8TsJaXw@mail.gmail.com>
 <20140908145459.GO27864@e106497-lin.cambridge.arm.com>
 <CAL_JsqJdGKDVwJOpPp19OkVPGzR7Zqv3nh+ONHHaYnPLYTYoYg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJdGKDVwJOpPp19OkVPGzR7Zqv3nh+ONHHaYnPLYTYoYg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 08 Sep 2014 15:59:32.0861 (UTC) FILETIME=[E151AAD0:01CFCB7D]
X-MC-Unique: 114090816593303801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 04:27:36PM +0100, Rob Herring wrote:
> On Mon, Sep 8, 2014 at 9:54 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > On Mon, Sep 08, 2014 at 03:27:56PM +0100, Rob Herring wrote:
> >> On Mon, Sep 8, 2014 at 8:54 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> >> > Add of_pci_get_domain_nr() to retrieve the PCI domain number
> >> > of a given device from DT. If the information is not present,
> >> > the function can be requested to allocate a new domain number.
> >> >
> >> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> >> > Cc: Arnd Bergmann <arnd@arndb.de>
> >> > Cc: Grant Likely <grant.likely@linaro.org>
> >> > Cc: Rob Herring <robh+dt@kernel.org>
> >> > Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> >> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> >> > ---
> >> >  drivers/of/of_pci.c    | 34 ++++++++++++++++++++++++++++++++++
> >> >  include/linux/of_pci.h |  7 +++++++
> >> >  2 files changed, 41 insertions(+)
> >> >
> >> > diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> >> > index 8481996..a107edb 100644
> >> > --- a/drivers/of/of_pci.c
> >> > +++ b/drivers/of/of_pci.c
> >> > @@ -89,6 +89,40 @@ int of_pci_parse_bus_range(struct device_node *node, struct resource *res)
> >> >  }
> >> >  EXPORT_SYMBOL_GPL(of_pci_parse_bus_range);
> >> >
> >> > +static atomic_t of_domain_nr = ATOMIC_INIT(-1);
> >> > +
> >> > +/**
> >> > + * This function will try to obtain the host bridge domain number by
> >> > + * using of_alias_get_id() call with "pci-domain" as a stem. If that
> >> > + * fails, a local allocator will be used. The local allocator can
> >> > + * be requested to return a new domain_nr if the information is missing
> >> > + * from the device tree.
> >> > + *
> >> > + * @node: device tree node with the domain information
> >> > + * @allocate_if_missing: if DT lacks information about the domain nr,
> >> > + * allocate a new number.
> >> > + *
> >> > + * Returns the associated domain number from DT, or a new domain number
> >> > + * if DT information is missing and @allocate_if_missing is true. If
> >> > + * @allocate_if_missing is false then the last allocated domain number
> >> > + * will be returned.
> >> > + */
> >> > +int of_pci_get_domain_nr(struct device_node *node, bool allocate_if_missing)
> >> > +{
> >> > +       int domain;
> >> > +
> >> > +       domain = of_alias_get_id(node, "pci-domain");
> >> > +       if (domain == -ENODEV) {
> >> > +               if (allocate_if_missing)
> >> > +                       domain = atomic_inc_return(&of_domain_nr);
> >> > +               else
> >> > +                       domain = atomic_read(&of_domain_nr);
> >>
> >> This function seems a bit broken to me. It is overloaded with too many
> >> different outcomes. Think about how this would work if you have
> >> multiple PCI buses and a mixture of having pci-domain aliases or not.
> >> Aren't domain numbers global? Allocation should then start outside of
> >> the range of alias ids.
> >>
> >> Rob
> >>
> >
> > Rob,
> >
> > Would this version make more sense?
> 
> No.
> 
> > int of_pci_get_domain_nr(struct device_node *node, bool allocate_if_missing)
> > {
> >        int domain;
> >
> >        domain = of_alias_get_id(node, "pci-domain");
> >        if (domain == -ENODEV) {
> >                if (allocate_if_missing)
> >                        domain = atomic_inc_return(&of_domain_nr);
> >                else
> >                        domain = atomic_read(&of_domain_nr);
> >        } else {
> >                /* remember the largest value seen */
> >                int d = atomic_read(&of_domain_nr);
> >                atomic_set(&of_domain_nr, max(domain, d));
> >        }
> >
> >        return domain;
> > }
> > EXPORT_SYMBOL_GPL(of_pci_get_domain_nr);
> >
> > It would still create gaps and possible duplicates, but this is just a number
> > and trying to create a new root bus in an existing domain should fail. I have
> 
> Is failure okay in that case?

Well, you would get the failure at development time and hopefully fix the DT to
eliminate sparseness of domain numbers.

> 
> > no clue on how to generate unique values without parsing the DT and filling
> > a sparse array with values found there and then checking for allocated values
> 
> You really only need to know the maximum value and then start the
> non-DT allocations from there.
> 
> > on new requests. This function gets called quite a lot and I'm trying not to
> > make it too heavy weight.
> 
> Generally, nothing should be accessing the same DT value frequently.
> It should get cached somewhere.
> 

The problem appears for DTs that don't have the pci-domain info. Then the cached
value is left at the default non-valid value and attempts to rescan the DT will
be made every time the function is called.

> I don't really understand how domains are used so it's hard to provide
> a recommendation here. Do domains even belong in the DT?

ACPI calls them segments and the way Bjorn explained it to me at some moment was
that it was an attempt to split up a bus in different groups (or alternatively,
merge a few busses together). To be honest I haven't seen systems where the domain
is anything other than zero, but JasonG (or maybe Benjamin) were floating an
idea of using the domain number to identify physical slots.

> This function
> is just a weird mixture of data retrieval and allocation. I think you
> need to separate it into 2 functions.

It is meant to do allocation with the retrieval being a short-cut (or fine
control if you want).

I need to think a bit more for a better solution.

Best regards,
Liviu

> 
> Rob
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

