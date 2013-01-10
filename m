Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab3AJTNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:13:32 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:53119 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3AJTNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:13:30 -0500
Date: Thu, 10 Jan 2013 14:18:03 -0500
From: Matt Porter <mporter@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3 04/16] ARM: edma: add DT and runtime PM support
 for AM33XX
Message-ID: <20130110191803.GN14660@beef>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
 <1350566815-409-5-git-send-email-mporter@ti.com>
 <508D110B.8010908@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508D110B.8010908@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 04:33:39PM +0530, Sekhar Nori wrote:
> On 10/18/2012 6:56 PM, Matt Porter wrote:
> > Adds support for parsing the TI EDMA DT data into the required
> > EDMA private API platform data.
> > 
> > Calls runtime PM API only in the DT case in order to unidle the
> > associated hwmods on AM33XX.
> 
> Runtime PM is supported on DaVinci now, so if that was the reason for
> this choice, then it doesn't need to be that way.

Thanks, fixed this for v4.

> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> >  arch/arm/common/edma.c                      |  255 +++++++++++++++++++++++++--
> >  arch/arm/mach-davinci/board-da830-evm.c     |    4 +-
> >  arch/arm/mach-davinci/board-da850-evm.c     |    8 +-
> >  arch/arm/mach-davinci/board-dm646x-evm.c    |    4 +-
> >  arch/arm/mach-davinci/board-omapl138-hawk.c |    8 +-
> >  arch/arm/mach-davinci/devices-da8xx.c       |    8 +-
> >  arch/arm/mach-davinci/devices-tnetv107x.c   |    4 +-
> >  arch/arm/mach-davinci/dm355.c               |    4 +-
> >  arch/arm/mach-davinci/dm365.c               |    4 +-
> >  arch/arm/mach-davinci/dm644x.c              |    4 +-
> >  arch/arm/mach-davinci/dm646x.c              |    4 +-
> >  include/linux/platform_data/edma.h          |    8 +-
> >  12 files changed, 272 insertions(+), 43 deletions(-)
> > 
> > diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> > index a3d189d..6d2a590 100644
> > --- a/arch/arm/common/edma.c
> > +++ b/arch/arm/common/edma.c
> > @@ -24,6 +24,13 @@
> >  #include <linux/platform_device.h>
> >  #include <linux/io.h>
> >  #include <linux/slab.h>
> > +#include <linux/edma.h>
> > +#include <linux/err.h>
> > +#include <linux/of_address.h>
> > +#include <linux/of_device.h>
> > +#include <linux/of_dma.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/pm_runtime.h>
> >  
> >  #include <linux/platform_data/edma.h>
> >  
> > @@ -1366,31 +1373,237 @@ void edma_clear_event(unsigned channel)
> >  EXPORT_SYMBOL(edma_clear_event);
> >  
> >  /*-----------------------------------------------------------------------*/
> > +static int edma_of_read_u32_to_s8_array(const struct device_node *np,
> > +					 const char *propname, s8 *out_values,
> > +					 size_t sz)
> > +{
> > +	struct property *prop = of_find_property(np, propname, NULL);
> > +	const __be32 *val;
> > +
> > +	if (!prop)
> > +		return -EINVAL;
> > +	if (!prop->value)
> > +		return -ENODATA;
> > +	if ((sz * sizeof(u32)) > prop->length)
> > +		return -EOVERFLOW;
> > +
> > +	val = prop->value;
> > +
> > +	while (sz--)
> > +		*out_values++ = (s8)(be32_to_cpup(val++) & 0xff);
> > +
> > +	/* Terminate it */
> > +	*out_values++ = -1;
> > +	*out_values++ = -1;
> > +
> > +	return 0;
> > +}
> > +
> > +static int edma_of_read_u32_to_s16_array(const struct device_node *np,
> > +					 const char *propname, s16 *out_values,
> > +					 size_t sz)
> > +{
> > +	struct property *prop = of_find_property(np, propname, NULL);
> > +	const __be32 *val;
> > +
> > +	if (!prop)
> > +		return -EINVAL;
> > +	if (!prop->value)
> > +		return -ENODATA;
> > +	if ((sz * sizeof(u32)) > prop->length)
> > +		return -EOVERFLOW;
> > +
> > +	val = prop->value;
> > +
> > +	while (sz--)
> > +		*out_values++ = (s16)(be32_to_cpup(val++) & 0xffff);
> > +
> > +	/* Terminate it */
> > +	*out_values++ = -1;
> > +	*out_values++ = -1;
> > +
> > +	return 0;
> > +}
> 
> I think these helper functions will have some general use beyond EDMA
> and can be kept in drivers/of/base.c. Grant/Rob need to agree though.

I expect these to go away before too long as I expect to rewrite all of
these data structures when the private edma api code is folded into
drivers/dma/edma.c. When that happens, I would like to use some data
structures that lend themselves to the DT property value. Given that,
let's wait until there is another user to move these helpers to
drivers/of/.

> > diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
> > index 95b5e10..ffcbec1 100644
> > --- a/arch/arm/mach-davinci/board-da830-evm.c
> > +++ b/arch/arm/mach-davinci/board-da830-evm.c
> > @@ -512,7 +512,7 @@ static struct davinci_i2c_platform_data da830_evm_i2c_0_pdata = {
> >   * example: Timer, GPIO, UART events etc) on da830/omap-l137 EVM, hence
> >   * they are being reserved for codecs on the DSP side.
> >   */
> > -static const s16 da830_dma_rsv_chans[][2] = {
> > +static s16 da830_dma_rsv_chans[][2] = {
> 
> I wonder why you had to remove const here and in other places. You seem
> to be allocating new memory for DT case anyway. Its also not a good idea
> to modify the passed platform data.

Good catch. Although I was never modifying pdata itself, at one point
the DT parsing code was modifying pointers that were const and I removed
the const. I've since fixed that issue since we'd like them to be const
as you point out. As a result, I've removed all these changes from v4 so
all those files aren't touched.

-Matt
