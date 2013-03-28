Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab3C1Kwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 06:52:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57481 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab3C1Kww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 06:52:52 -0400
Message-ID: <1364467946.4018.56.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v9 RESEND 2/4] misc: Generic on-chip SRAM allocation
 driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>, Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Date: Thu, 28 Mar 2013 11:52:26 +0100
In-Reply-To: <20130327152723.723cd65e884413df405abe2d@linux-foundation.org>
References: <1363776767-2635-1-git-send-email-p.zabel@pengutronix.de>
	 <1363776767-2635-3-git-send-email-p.zabel@pengutronix.de>
	 <20130327152723.723cd65e884413df405abe2d@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

thanks for taking care of these patches.

Am Mittwoch, den 27.03.2013, 15:27 -0700 schrieb Andrew Morton:
> On Wed, 20 Mar 2013 11:52:45 +0100 Philipp Zabel <p.zabel@pengutronix.de> wrote:
> 
> > This driver requests and remaps a memory region as configured in the
> > device tree. It serves memory from this region via the genalloc API.
> > It optionally enables the SRAM clock.
> > 
> > Other drivers can retrieve the genalloc pool from a phandle pointing
> > to this drivers' device node in the device tree.
> > 
> > The allocation granularity is hard-coded to 32 bytes for now,
> > to make the SRAM driver useful for the 6502 remoteproc driver.
> > There is overhead for bigger SRAMs, where only a much coarser
> > allocation granularity is needed: At 32 bytes minimum allocation
> > size, a 256 KiB SRAM needs a 1 KiB bitmap to track allocations.
> > 
> >  Documentation/devicetree/bindings/misc/sram.txt |   16 +++
> >  drivers/misc/Kconfig                            |    9 ++
> >  drivers/misc/Makefile                           |    1 +
> >  drivers/misc/sram.c                             |  121 +++++++++++++++++++++++
> 
> drivers/misc/sram.c is a pretty generic-sounding thing.  Is it really
> Linux's One True SRAM driver?  How many different sorts of sram devices
> do we expect this can be used with?  If I don't use DT?

It's just a driver for MMIO-accessible SRAM ranges that are provided to
other drivers (or suspend or dvfs platform code) via a genalloc pool.
This is for system use, as opposed to an SRAM mtd device exporting SRAM
to userspace. It's intended to unify all current SRAM genalloc pools in
use. DT support is completely optional, the SRAM driver just uses
platform resources.

One limitation is that currently the allocation granularity is not
configurable, that should be added to the driver.

> In other words, perhaps this should have a more specific and accurate
> name?

Grant already made me change the compatible string to "mmio-sram". We
could change the driver name to mmio_sram, too.

> > --- a/drivers/misc/Kconfig
> > +++ b/drivers/misc/Kconfig
> > @@ -510,6 +510,15 @@ config LATTICE_ECP3_CONFIG
> >  
> >  	  If unsure, say N.
> >  
> > ...
> >
> > +static int sram_probe(struct platform_device *pdev)
> > +{
> > +	void __iomem *virt_base;
> > +	struct sram_dev *sram;
> > +	struct resource *res;
> > +	unsigned long size;
> > +	int ret;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res)
> > +		return -EINVAL;
> > +
> > +	size = resource_size(res);
> > +
> > +	virt_base = devm_request_and_ioremap(&pdev->dev, res);
> > +	if (!virt_base)
> > +		return -EADDRNOTAVAIL;
> 
> EADDRNOTAVAIL is a networking error.  If your users see this error pop
> up on their console they'll start wiggling ethernet cables, wondering
> why that didn't fix it.

I should probably switch to devm_ioremap_resource() instead, which
returns -EBUSY or -ENOMEM, depending on whether the request_region or
ioremap fails.

> > +	sram = devm_kzalloc(&pdev->dev, sizeof(*sram), GFP_KERNEL);
> > +	if (!sram)
> > +		return -ENOMEM;
> > +
> > +	sram->clk = devm_clk_get(&pdev->dev, NULL);
> > +	if (IS_ERR(sram->clk))
> > +		sram->clk = NULL;
> > +	else
> > +		clk_prepare_enable(sram->clk);
> > +
> > +	sram->pool = devm_gen_pool_create(&pdev->dev, ilog2(SRAM_GRANULARITY), -1);
> > +	if (!sram->pool)
> > +		return -ENOMEM;
> > +
> > +	ret = gen_pool_add_virt(sram->pool, (unsigned long)virt_base,
> > +				res->start, size, -1);
> > +	if (ret < 0) {
> > +		gen_pool_destroy(sram->pool);
> > +		return ret;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, sram);
> > +
> > +	dev_dbg(&pdev->dev, "SRAM pool: %ld KiB @ 0x%p\n", size / 1024, virt_base);
> > +
> > +	return 0;
> > +}
> >
> > ...
> >
> > +int __init sram_init(void)
> > +{
> > +	return platform_driver_register(&sram_driver);
> > +}
> > +
> > +postcore_initcall(sram_init);
> 
> Why is it postcore_initcall()?

Good question. A few architectures initialize their SRAM in a
core_initcall (davinci, sh, mmp), a few from init_machine (omap2)
postcore_initcall is when Freescale initialized their IRAM for i.MX.

I have not tried yet to use SRAM to execute code for bus frequency
changes during wfi or suspend, I'm not sure how early the sram pool is
really needed by everyone.

regards
Philipp

> Fixlets:
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: misc-generic-on-chip-sram-allocation-driver-fix
> 
> fix Kconfig text, make sram_init static
> 
> Cc: Dong Aisheng <dong.aisheng@linaro.org>
> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Huang Shijie <shijie8@gmail.com>
> Cc: Javier Martin <javier.martin@vista-silicon.com>
> Cc: Matt Porter <mporter@ti.com>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/misc/Kconfig |    6 +++---
>  drivers/misc/sram.c  |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff -puN Documentation/devicetree/bindings/misc/sram.txt~misc-generic-on-chip-sram-allocation-driver-fix Documentation/devicetree/bindings/misc/sram.txt
> diff -puN drivers/misc/Kconfig~misc-generic-on-chip-sram-allocation-driver-fix drivers/misc/Kconfig
> --- a/drivers/misc/Kconfig~misc-generic-on-chip-sram-allocation-driver-fix
> +++ a/drivers/misc/Kconfig
> @@ -523,9 +523,9 @@ config SRAM
>  	depends on HAS_IOMEM
>  	select GENERIC_ALLOCATOR
>  	help
> -	  This driver allows to declare a memory region to be managed
> -	  by the genalloc API. It is supposed to be used for small
> -	  on-chip SRAM areas found on many SoCs.
> +	  This driver allows you to declare a memory region to be managed by
> +	  the genalloc API. It is supposed to be used for small on-chip SRAM
> +	  areas found on many SoCs.
>  
>  source "drivers/misc/c2port/Kconfig"
>  source "drivers/misc/eeprom/Kconfig"
> diff -puN drivers/misc/Makefile~misc-generic-on-chip-sram-allocation-driver-fix drivers/misc/Makefile
> diff -puN drivers/misc/sram.c~misc-generic-on-chip-sram-allocation-driver-fix drivers/misc/sram.c
> --- a/drivers/misc/sram.c~misc-generic-on-chip-sram-allocation-driver-fix
> +++ a/drivers/misc/sram.c
> @@ -113,7 +113,7 @@ static struct platform_driver sram_drive
>  	.remove = sram_remove,
>  };
>  
> -int __init sram_init(void)
> +static int __init sram_init(void)
>  {
>  	return platform_driver_register(&sram_driver);
>  }
> _
> 
> 


