Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaBKMNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:13:24 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:54660 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaBKMNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:13:22 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 1/5] drivers: of: add initialization code for reserved memory
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@gmail.com>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>
In-Reply-To: <52FA0D6E.9090304@samsung.com>
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com> < 1391515773-6112-2-git-send-email-m.szyprowski@samsung.com> <20140205110538. 99E47C40A89@trevor.secretlab.ca> <52FA0D6E.9090304@samsung.com>
Date: Tue, 11 Feb 2014 12:13:16 +0000
Message-Id: <20140211121316.24032C40C4D@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014 12:45:50 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Hello,
> 
> On 2014-02-05 12:05, Grant Likely wrote:
> > On Tue, 04 Feb 2014 13:09:29 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> > > This patch adds device tree support for contiguous and reserved memory
> > > regions defined in device tree.
> > >
> > > Large memory blocks can be reliably reserved only during early boot.
> > > This must happen before the whole memory management subsystem is
> > > initialized, because we need to ensure that the given contiguous blocks
> > > are not yet allocated by kernel. Also it must happen before kernel
> > > mappings for the whole low memory are created, to ensure that there will
> > > be no mappings (for reserved blocks) or mapping with special properties
> > > can be created (for CMA blocks). This all happens before device tree
> > > structures are unflattened, so we need to get reserved memory layout
> > > directly from fdt.
> > >
> > > Later, those reserved memory regions are assigned to devices on each
> > > device structure initialization.
> > >
> > > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > > Cc: Laura Abbott <lauraa@codeaurora.org>
> > > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > > [joshc: rework to implement new DT binding, provide mechanism for
> > >  plugging in new reserved-memory node handlers via
> > >  RESERVEDMEM_OF_DECLARE]
> > > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > > [mszyprow: little code cleanup]
> > > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > > ---
> > >  drivers/of/Kconfig                |    6 +
> > >  drivers/of/Makefile               |    1 +
> > >  drivers/of/of_reserved_mem.c      |  219 +++++++++++++++++++++++++++++++++++++
> > >  drivers/of/platform.c             |    7 ++
> > >  include/asm-generic/vmlinux.lds.h |   11 ++
> > >  include/linux/of_reserved_mem.h   |   62 +++++++++++
> > >  6 files changed, 306 insertions(+)
> > >  create mode 100644 drivers/of/of_reserved_mem.c
> > >  create mode 100644 include/linux/of_reserved_mem.h
> > >
> > > diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> > > index c6973f101a3e..aba13df56f3a 100644
> > > --- a/drivers/of/Kconfig
> > > +++ b/drivers/of/Kconfig
> > > @@ -75,4 +75,10 @@ config OF_MTD
> > >  	depends on MTD
> > >  	def_bool y
> > >
> > > +config OF_RESERVED_MEM
> > > +	depends on HAVE_MEMBLOCK
> > > +	def_bool y
> > > +	help
> > > +	  Helpers to allow for reservation of memory regions
> > > +
> > >  endmenu # OF
> > > diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> > > index efd05102c405..ed9660adad77 100644
> > > --- a/drivers/of/Makefile
> > > +++ b/drivers/of/Makefile
> > > @@ -9,3 +9,4 @@ obj-$(CONFIG_OF_MDIO)	+= of_mdio.o
> > >  obj-$(CONFIG_OF_PCI)	+= of_pci.o
> > >  obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
> > >  obj-$(CONFIG_OF_MTD)	+= of_mtd.o
> > > +obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
> > > diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> > > new file mode 100644
> > > index 000000000000..f17cd56e68d9
> > > --- /dev/null
> > > +++ b/drivers/of/of_reserved_mem.c
> > > @@ -0,0 +1,219 @@
> > > +/*
> > > + * Device tree based initialization code for reserved memory.
> > > + *
> > > + * Copyright (c) 2013, The Linux Foundation. All Rights Reserved.
> > > + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> > > + *		http://www.samsung.com
> > > + * Author: Marek Szyprowski <m.szyprowski@samsung.com>
> > > + * Author: Josh Cartwright <joshc@codeaurora.org>
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > + * modify it under the terms of the GNU General Public License as
> > > + * published by the Free Software Foundation; either version 2 of the
> > > + * License or (at your optional) any later version of the license.
> > > + */
> > > +#include <linux/memblock.h>
> > > +#include <linux/err.h>
> > > +#include <linux/of.h>
> > > +#include <linux/of_fdt.h>
> > > +#include <linux/of_platform.h>
> > > +#include <linux/mm.h>
> > > +#include <linux/sizes.h>
> > > +#include <linux/of_reserved_mem.h>
> > > +
> > > +#define MAX_RESERVED_REGIONS	16
> > > +static struct reserved_mem reserved_mem[MAX_RESERVED_REGIONS];
> > > +static int reserved_mem_count;
> > > +
> > > +int __init of_parse_flat_dt_reg(unsigned long node, const char *uname,
> > > +				   phys_addr_t *base, phys_addr_t *size)
> >
> > Useful utility function; move to drivers/of/fdt.c
> >
> > > +{
> > > +	unsigned long len;
> > > +	__be32 *prop;
> > > +
> > > +	prop = of_get_flat_dt_prop(node, "reg", &len);
> > > +	if (!prop)
> > > +		return -EINVAL;
> > > +
> > > +	if (len < (dt_root_addr_cells + dt_root_size_cells) * sizeof(__be32)) {
> > > +		pr_err("Reserved memory: invalid reg property in '%s' node.\n",
> > > +				uname);
> > > +		return -EINVAL;
> > > +	}
> >
> > This is /okay/ for an initial implementation, but it is naive. While I
> > suggested making #address-cells and #size-cells equal the root node
> > values for the purpose of simplicity, it should still be perfectly valid
> > to have different values if the ranges property is correctly formed.
> >
> > > +
> > > +	*base = dt_mem_next_cell(dt_root_addr_cells, &prop);
> > > +	*size = dt_mem_next_cell(dt_root_size_cells, &prop);
> >
> > Future enhancement; allow for parsing more than just the first reg
> > tuple.
> 
> One more question. Does it really makes any sense to support more than
> one tuple for reg property? For consistency we should also allow more
> than one entry in size, align and alloc-ranges property, but I don't
> see any benefits for defining more than one range for a single region.
> Same can be achieved by defining more regions instead if one really
> needs such configuration.

Yes, if only because it is an define usage of the reg property. If a
devtree has multiple tuples in reg, then all of those tuples should be
treated as reserved, even if the kernel doesn't know how to use them.

I would not do the same for size/align/alloc-ranges unless there is a
very specific use case that you can define. These ones are different
from the static regions because they aren't ever used to protect
something that already exists in the memory.

g.

