Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaBJV7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:59:50 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33980 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaBJV7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:59:36 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v2 4/5] ARM: init: add support for reserved memory defined by device tree
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
In-Reply-To: <52F38D75.4030704@samsung.com>
References: <1391515773-6112-1-git-send-email-m.szyprowski@samsung.com> < 1391515773-6112-5-git-send-email-m.szyprowski@samsung.com> <20140205101510. 59A95C40A89@trevor.secretlab.ca> <52F38D75.4030704@samsung.com>
Date: Mon, 10 Feb 2014 21:59:29 +0000
Message-Id: <20140210215929.4473BC408F7@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Feb 2014 14:26:13 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Hello,
> 
> On 2014-02-05 11:15, Grant Likely wrote:
> > On Tue, 04 Feb 2014 13:09:32 +0100, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> > > Enable reserved memory initialization from device tree.
> > >
> > > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > > Cc: Laura Abbott <lauraa@codeaurora.org>
> > > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > > ---
> > >  arch/arm/mm/init.c |    3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> > > index 804d61566a53..ebafdb479410 100644
> > > --- a/arch/arm/mm/init.c
> > > +++ b/arch/arm/mm/init.c
> > > @@ -17,6 +17,7 @@
> > >  #include <linux/nodemask.h>
> > >  #include <linux/initrd.h>
> > >  #include <linux/of_fdt.h>
> > > +#include <linux/of_reserved_mem.h>
> > >  #include <linux/highmem.h>
> > >  #include <linux/gfp.h>
> > >  #include <linux/memblock.h>
> > > @@ -323,6 +324,8 @@ void __init arm_memblock_init(struct meminfo *mi,
> > >  	if (mdesc->reserve)
> > >  		mdesc->reserve();
> > >
> > > +	early_init_dt_scan_reserved_mem();
> > > +
> >
> > The new binding is being made fundamental. If the reserved-memory node
> > is present, then it needs to be honored, even if the kernel doesn't know
> > how to use the regions. Therefore, This needs to be unconditional for
> > all architectures. The hook should be called in early_init_dt_scan()
> > (drivers/of/fdt.c) immediately after the early_init_dt_scan_memory()
> > hook.
> 
> In theory this will be the best solution, but it practice there is a
> problem. early_init_dt_scan() is called as the first function from kernel
> booting code. That time there is no memory yet added to the system, so it
> would be really hard to reserve anything. Memory nodes are being added
> later either with memblock_add() or by some other arch specific way.

Hmmm, depends on the architecture. On ARM the memory is loaded into the
meminfo structure first, and it isn't until arm_memblock_init() that
memblock_add() gets called on all the regions. Some architectures do the
memblock_add() directly from early_init_dt_add_memory_arch() function.

The default early_init_dt_add_memory_arch() in drivers/of/fdt.c is
overridden by ARM and a number of other architectures. However...

> Finally, once all memory has been added to the system we can parse and
> reserve all regions defined in the device tree. This really requires
> creating another function which will be called by arch specific code.

...Or it means getting rid of meminfo entirely so that memblock is
available earlier. Laura Abbott has just posted v2 of her series to do
exactly that. If you base on that then you should be able to do exactly
what I suggested.

g.
