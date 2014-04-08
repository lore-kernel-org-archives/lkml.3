Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbaDHKLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 06:11:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50078 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaDHKLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 06:11:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper function.
Date: Tue, 08 Apr 2014 12:11:07 +0200
Message-ID: <6228807.4v9ZRtib77@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140408094933.GS17163@e106497-lin.cambridge.arm.com>
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com> <CAErSpo6S49qNuJQB-XXEfJ1Nkz=4gZ5_hE93=gb_yGZesA1H9Q@mail.gmail.com> <20140408094933.GS17163@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:GJqM9K7pzMI/KXnMnCHrhqZjZ5u8rDsk1IcTVXgpH0O
 TzreEKf+Ni1lfqa72kFtlvikmp5vcc7SHFgpPXREeoHjufl0pf
 P1fuRe6xk5QCIZHI2lJEOmQytS48qX7iPzLFePxzW+zBKZBj1f
 qcnXhZcPwfRZnFkrRvpRQ+CC5Zw6eUUXKtd+TPZiIjkQtLAM77
 //dOSDUsfrs+1cPIpH8IYNHUzRFhfzDnplzzHOPLtJLxxTch8O
 NspGUTcDDSJl6G2v/7tRxkh9aHpK29eBW6X0CaSyaGAG1upG/x
 D9B9sDrPeaHKo2mnJcYblTzIiFSPBJ6PJ+6Cw5zEfxgXE7gxgv
 ny9fpSpSOD+tDAcxLfjo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 April 2014 10:49:33 Liviu Dudau wrote:
> On Tue, Apr 08, 2014 at 12:21:51AM +0100, Bjorn Helgaas wrote:
> > On Fri, Mar 14, 2014 at 9:34 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > > Some architectures do not share x86 simple view of the PCI I/O space
> > > and instead use a range of addresses that map to bus addresses. For
> > > some architectures these ranges will be expressed by OF bindings
> > > in a device tree file.
> > >
> > > Introduce a pci_register_io_range() helper function that can be used
> > > by the architecture code to keep track of the I/O ranges described by the
> > > PCI bindings. If the PCI_IOBASE macro is not defined that signals
> > > lack of support for PCI and we return an error.
> > >
> > > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > > Acked-by: Grant Likely <grant.likely@linaro.org>
> > > Tested-by: Tanmay Inamdar <tinamdar@apm.com>
> > > ---
> > >  drivers/of/address.c       | 9 +++++++++
> > >  include/linux/of_address.h | 1 +
> > >  2 files changed, 10 insertions(+)
> > >
> > > diff --git a/drivers/of/address.c b/drivers/of/address.c
> > > index 1a54f1f..be958ed 100644
> > > --- a/drivers/of/address.c
> > > +++ b/drivers/of/address.c
> > > @@ -619,6 +619,15 @@ const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
> > >  }
> > >  EXPORT_SYMBOL(of_get_address);
> > >
> > > +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> > > +{
> > > +#ifndef PCI_IOBASE
> > > +       return -EINVAL;
> > > +#else
> > > +       return 0;
> > > +#endif
> > > +}
> > 
> > This isn't PCI code, so I'm fine with it in that sense, but I'm not
> > sure the idea of a PCI_IOBASE #define is really what we need.  It's
> > not really determined by the processor architecture, it's determined
> > by the platform.  And a single address isn't enough in general,
> > either, because if there are multiple host bridges, there's no reason
> > the apertures that generate PCI I/O transactions need to be contiguous
> > on the CPU side.
> 
> It should not be only platform's choice if the architecture doesn't support it.
> To my mind PCI_IOBASE means "I support MMIO operations and this is the
> start of the virtual address where my I/O ranges are mapped." It's the
> same as ppc's _IO_BASE. And pci_address_to_pio() will take care to give
> you the correct io_offset in the presence of multiple host bridges,
> while keeping the io resource in the range [0 .. host_bridge_io_range_size - 1]

There is a wide range of implementations across architectures:

a) no access to I/O ports at all (tile, s390, ...)
b) access to I/O ports only through special instructions (x86, ...)
c) all MMIO is mapped virtual contiguous to PCI_IOBASE or _IO_BASE
   (most ppc64, arm32 with MMU, arm64, ...)
d) only one PCI host can have an I/O space (mips, microblaze, ...)
e) each host controller can have its own method (ppc64 with indirect pio)
f) PIO token equals virtual address plus offset (some legacy ARM platforms,
   probably some other architectures), or physical address (sparc)
g) PIO token encodes address space number plus offset (ia64)

a) and b) are trivially handled by any implementation that falls
back to 'return -EINVAL'.
I believe that c) is the most appropriate solution and we should be
able to adopt it by most of the architectures that have an MMU and
make it the default implementation.
d) seems like a good fallback for noMMU architectures: While we do
need to support I/O spaces, we need to support multiple PCI domains,
and we need to support noMMU, the combination of all three should
be extremely rare, and I'd leave it up to the architecture to support
that if there is a real use case, rather than trying to put that into
common code.
Anything that currently requires e), f) or g) I think should keep
doing that and not try to use the generic implementation.

	Arnd
