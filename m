Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbaDHJtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 05:49:41 -0400
Received: from service87.mimecast.com ([91.220.42.44]:59678 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbaDHJti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 05:49:38 -0400
Date: Tue, 8 Apr 2014 10:49:33 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper
 function.
Message-ID: <20140408094933.GS17163@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Bjorn Helgaas <bhelgaas@google.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811272-1547-2-git-send-email-Liviu.Dudau@arm.com>
 <CAErSpo6S49qNuJQB-XXEfJ1Nkz=4gZ5_hE93=gb_yGZesA1H9Q@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAErSpo6S49qNuJQB-XXEfJ1Nkz=4gZ5_hE93=gb_yGZesA1H9Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 08 Apr 2014 09:49:50.0498 (UTC) FILETIME=[E265F020:01CF530F]
X-MC-Unique: 114040810493600901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 12:21:51AM +0100, Bjorn Helgaas wrote:
> On Fri, Mar 14, 2014 at 9:34 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > Some architectures do not share x86 simple view of the PCI I/O space
> > and instead use a range of addresses that map to bus addresses. For
> > some architectures these ranges will be expressed by OF bindings
> > in a device tree file.
> >
> > Introduce a pci_register_io_range() helper function that can be used
> > by the architecture code to keep track of the I/O ranges described by the
> > PCI bindings. If the PCI_IOBASE macro is not defined that signals
> > lack of support for PCI and we return an error.
> >
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > Acked-by: Grant Likely <grant.likely@linaro.org>
> > Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> > ---
> >  drivers/of/address.c       | 9 +++++++++
> >  include/linux/of_address.h | 1 +
> >  2 files changed, 10 insertions(+)
> >
> > diff --git a/drivers/of/address.c b/drivers/of/address.c
> > index 1a54f1f..be958ed 100644
> > --- a/drivers/of/address.c
> > +++ b/drivers/of/address.c
> > @@ -619,6 +619,15 @@ const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
> >  }
> >  EXPORT_SYMBOL(of_get_address);
> >
> > +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> > +{
> > +#ifndef PCI_IOBASE
> > +       return -EINVAL;
> > +#else
> > +       return 0;
> > +#endif
> > +}
> 
> This isn't PCI code, so I'm fine with it in that sense, but I'm not
> sure the idea of a PCI_IOBASE #define is really what we need.  It's
> not really determined by the processor architecture, it's determined
> by the platform.  And a single address isn't enough in general,
> either, because if there are multiple host bridges, there's no reason
> the apertures that generate PCI I/O transactions need to be contiguous
> on the CPU side.

It should not be only platform's choice if the architecture doesn't support it.
To my mind PCI_IOBASE means "I support MMIO operations and this is the
start of the virtual address where my I/O ranges are mapped." It's the
same as ppc's _IO_BASE. And pci_address_to_pio() will take care to give
you the correct io_offset in the presence of multiple host bridges,
while keeping the io resource in the range [0 .. host_bridge_io_range_size - 1]

> 
> That's just a long way of saying that if we ever came up with a more
> generic way to handle I/O port spaces, PCI_IOBASE might go away.  And
> I guess part of that rework could be changing this use of it along
> with the others.

And I have a patch series that #defines PCI_IOBASE only in those architectures
that support MMIO, where this macro makes sense. Also notice that the
arm64 series has a patch that I'm going to roll into this one where ioport_map()
gets fixed to include PCI_IOBASE when !CONFIG_GENERIC_MAP.

Best regards,
Liviu

> 
> >  unsigned long __weak pci_address_to_pio(phys_addr_t address)
> >  {
> >         if (address > IO_SPACE_LIMIT)
> > diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> > index 5f6ed6b..40c418d 100644
> > --- a/include/linux/of_address.h
> > +++ b/include/linux/of_address.h
> > @@ -56,6 +56,7 @@ extern void __iomem *of_iomap(struct device_node *device, int index);
> >  extern const __be32 *of_get_address(struct device_node *dev, int index,
> >                            u64 *size, unsigned int *flags);
> >
> > +extern int pci_register_io_range(phys_addr_t addr, resource_size_t size);
> >  extern unsigned long pci_address_to_pio(phys_addr_t addr);
> >
> >  extern int of_pci_range_parser_init(struct of_pci_range_parser *parser,
> > --
> > 1.9.0
> >
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

