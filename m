Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135AbaBUNiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:38:20 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35784 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbaBUNiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:38:15 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v4 1/7] drivers: of: add initialization code for reserved memory
To: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <530731DC.2000400@samsung.com>
References: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com> < 1392893567-31623-2-git-send-email-m.szyprowski@samsung.com> <20140220140100 .5BD65C4050F@trevor.secretlab.ca> <530731DC.2000400@samsung.com>
Date: Fri, 21 Feb 2014 13:38:08 +0000
Message-Id: <20140221133808.65AF7C40575@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 12:00:44 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Hello,
> 
> On 2014-02-20 15:01, Grant Likely wrote:
> > On Thu, 20 Feb 2014 11:52:41 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
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
> > > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > > [joshc: rework to implement new DT binding, provide mechanism for
> > >  plugging in new reserved-memory node handlers via
> > >  RESERVEDMEM_OF_DECLARE]
> > > Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> > > [mszyprow: added generic memory reservation code, refactored code to
> > >  put it directly into fdt.c]
> > > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > > ---
> > >  drivers/of/Kconfig                |    6 +
> > >  drivers/of/Makefile               |    1 +
> > >  drivers/of/fdt.c                  |  145 ++++++++++++++++++
> > >  drivers/of/of_reserved_mem.c      |  296 +++++++++++++++++++++++++++++++++++++
> > >  drivers/of/platform.c             |    7 +
> > >  include/asm-generic/vmlinux.lds.h |   11 ++
> > >  include/linux/of_reserved_mem.h   |   65 ++++++++
> > >  7 files changed, 531 insertions(+)
> > >  create mode 100644 drivers/of/of_reserved_mem.c
> > >  create mode 100644 include/linux/of_reserved_mem.h
> >
> > Hi Marek,
> >
> > There's a lot of moving parts in this patch. Can you split the patch up a bit please. There are parts that I'm not entierly comfortable with yet and it will help reviewing them if they are added separately. For instance, the attaching regions to devices is something that I want to have some discussion about, but the core reserving static ranges I think is pretty much ready to be merged. I can merge the later while still debating the former if they are split.
> >
> > I would recommend splitting into four:
> > 1) reservation of static regions without the support code for referencing them later
> > 2) code to also do dynamic allocations of reserved regions - again without any driver references
> > 3) add hooks to reference specific regions.
> > 4) hooks into drivers/of/platform.c for wiring into the driver model.
> >
> > Can you also make the binding doc the first patch?
> 
> Ok, I will slice the patch into 4 pieces.
> >
> > <off topic> Wow, the flattree parsing code has to be really verbose. We really need better
> > flat tree parsing functions and helpers.
> 
> Yes, parsing fdt is a real pain, but please don't ask me to implement 
> all the
> helpers to make it easier together with this patch. I (and probably other
> developers) would really like to get this piece merged asap.

I won't. Mostly I was thinking out loud.

> > > +	for (i = __reservedmem_of_table; i < &__rmem_of_table_sentinel; i++) {
> > > +		reservedmem_of_init_fn initfn = i->data;
> > > +		const char *compat = i->compatible;
> > > +
> > > +		if (!of_flat_dt_is_compatible(rmem->fdt_node, compat))
> > > +			continue;
> >
> > What if two entries both match the compatible list? Ideally score would
> > be taken into account. (I won't block on this issue, it can be a future
> > enhancement)
> 
> If two entries have same compatible value they will be probed in the order
> of presence in the kernel binary. The return value is checked and the next
> one is being tried if init fails for the given function. The provided code
> already makes use of this feature. Both DMA coherent and CMA use
> "shared-dma-pool" compatible. DMA coherent init fails if 'reusable'
> property has been found. On the other hand, CMA fails initialization if
> 'reusable' property is missing. Frankly I would like to change standard
> DMA coherent compatible value to 'dma-pool' and keep 'shared-dma-pool'
> only for CMA, but I've implemented it the way it has been described in
> your binding documentation.

My binding document isn't gospel and it hasn't been merged yet. Reply to
the binding patch and make your argument for the change.

g.

