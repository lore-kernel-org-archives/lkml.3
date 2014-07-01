Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbaGAUpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:45:31 -0400
Received: from dliviu.plus.com ([80.229.23.120]:32784 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbaGAUp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:45:29 -0400
From: "Liviu Dudau" <liviu@dudau.co.uk>
Date: Tue, 1 Jul 2014 21:45:09 +0100
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Liviu Dudau <Liviu.Dudau@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 3/9] pci: Introduce pci_register_io_range() helper
 function.
Message-ID: <20140701204508.GA19569@bart.dudau.co.uk>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-4-git-send-email-Liviu.Dudau@arm.com>
 <8556461.i7qCGvGY5a@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8556461.i7qCGvGY5a@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Jul  1 21:45:28 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 13,53b31de83301363255457
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 09:36:10PM +0200, Arnd Bergmann wrote:
> On Tuesday 01 July 2014 19:43:28 Liviu Dudau wrote:
> > +/*
> > + * Record the PCI IO range (expressed as CPU physical address + size).
> > + * Return a negative value if an error has occured, zero otherwise
> > + */
> > +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> > +{
> > +#ifdef PCI_IOBASE
> > +       struct io_range *res;
> > +       resource_size_t allocated_size = 0;
> > +
> > +       /* check if the range hasn't been previously recorded */
> > +       list_for_each_entry(res, &io_range_list, list) {
> > +               if (addr >= res->start && addr + size <= res->start + size)
> > +                       return 0;
> > +               allocated_size += res->size;
> > +       }
> > +
> > +       /* range not registed yet, check for available space */
> > +       if (allocated_size + size - 1 > IO_SPACE_LIMIT)
> > +               return -E2BIG;
> > +
> > +       /* add the range to the list */
> > +       res = kzalloc(sizeof(*res), GFP_KERNEL);
> > +       if (!res)
> > +               return -ENOMEM;
> > +
> > +       res->start = addr;
> > +       res->size = size;
> > +
> > +       list_add_tail(&res->list, &io_range_list);
> > +
> > +       return 0;
> > +#else
> > +       return -EINVAL;
> > +#endif
> > +}
> > +
> >  unsigned long __weak pci_address_to_pio(phys_addr_t address)
> >  {
> > +#ifdef PCI_IOBASE
> > +       struct io_range *res;
> > +       resource_size_t offset = 0;
> > +
> > +       list_for_each_entry(res, &io_range_list, list) {
> > +               if (address >= res->start &&
> > +                       address < res->start + res->size) {
> > +                       return res->start - address + offset;
> > +               }
> > +               offset += res->size;
> > +       }
> > +
> > +       return (unsigned long)-1;
> > +#else
> >         if (address > IO_SPACE_LIMIT)
> >                 return (unsigned long)-1;
> >  
> >         return (unsigned long) address;
> > +#endif
> >  }
> 
> This still conflicts with the other allocator you have in patch 9
> for pci_remap_iospace: nothing guarantees that the mapping is the
> same for both.
> 
> Also, this is a completely pointless exercise at this moment, because
> nobody cares about the result of pci_address_to_pio on architectures
> that don't already provide this function. If we ever get a proper
> Open Firmware implementation that wants to put hardcoded PCI devices
> into DT, we can add an implementation, but for now this seems overkill.
> 
> The allocator in pci_register_io_range seems reasonable, why not merge
> this function with pci_remap_iospace() as I have asked you multiple
> times before? Just make it return the io_offset so the caller can
> put that into the PCI host resources.

Hi Arnd,

While I agree with you that at some moment the allocators were inconsistent
wrt each other, for this version I would respectfully disagree on this.
The allocator in pci_register_io_range() only makes sure that the ranges
are not overlapping, it doesn't do any mapping whatsoever, while
pci_remap_iospace() does only an ioremap_page_range(). The idea is that
you get the offset out of pci_address_to_pio() and apply it to
pci_remap_iospace().

Why do you think there are conflicts?

Best regards,
Liviu


> 
> 	Arnd
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

