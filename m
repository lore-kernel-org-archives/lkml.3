Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaGOAPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 20:15:12 -0400
Received: from dliviu.plus.com ([80.229.23.120]:39759 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbaGOAPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 20:15:08 -0400
Date: Tue, 15 Jul 2014 01:14:45 +0100
From: Liviu Dudau <liviu@dudau.co.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 9/9] pci: Remap I/O bus resources into CPU space with
 pci_remap_iospace()
Message-ID: <20140715001444.GB6803@bart.dudau.co.uk>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-10-git-send-email-Liviu.Dudau@arm.com>
 <20140714165443.GI1112@arm.com>
 <7345495.UDsgOtKzyQ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7345495.UDsgOtKzyQ@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Jul 15 01:15:06 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 13,53c4728a3241817718271
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 08:15:48PM +0200, Arnd Bergmann wrote:
> On Monday 14 July 2014 17:54:43 Catalin Marinas wrote:
> > On Tue, Jul 01, 2014 at 07:43:34PM +0100, Liviu Dudau wrote:
> > > Introduce a default implementation for remapping PCI bus I/O resources
> > > onto the CPU address space. Architectures with special needs may
> > > provide their own version, but most should be able to use this one.
> > [...]
> > > +/**
> > > + *   pci_remap_iospace - Remap the memory mapped I/O space
> > > + *   @res: Resource describing the I/O space
> > > + *   @phys_addr: physical address where the range will be mapped.
> > > + *
> > > + *   Remap the memory mapped I/O space described by the @res
> > > + *   into the CPU physical address space. Only architectures
> > > + *   that have memory mapped IO defined (and hence PCI_IOBASE)
> > > + *   should call this function.
> > > + */
> > > +int __weak pci_remap_iospace(const struct resource *res, phys_addr_t phys_addr)
> > > +{
> > > +     int err = -ENODEV;
> > > +
> > > +#ifdef PCI_IOBASE
> > > +     if (!(res->flags & IORESOURCE_IO))
> > > +             return -EINVAL;
> > > +
> > > +     if (res->end > IO_SPACE_LIMIT)
> > > +             return -EINVAL;
> > > +
> > > +     err = ioremap_page_range(res->start + (unsigned long)PCI_IOBASE,
> > > +                             res->end + 1 + (unsigned long)PCI_IOBASE,
> > > +                             phys_addr, __pgprot(PROT_DEVICE_nGnRE));
> > 
> > Except that PROT_DEVICE_nGnRE is arm64 only. I think that's a function
> > that should remain arch specific.
> > 
> 
> How about #defining a macro with the correct pgprot value in asm/pci.h
> or asm/pgtable.h?
> We can provide a default for that in another architecture independent
> location.

I was discussing the same thing with Catalin today. It is the most reasonable
approach, as the host bridge driver that is likely to call this function should
not be aware of the architectural flags used here.

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

