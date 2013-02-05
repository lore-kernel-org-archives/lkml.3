Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab3BESY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:24:56 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34529 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab3BESYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:24:51 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RESEND] spi: spi-fsl-spi: Make spi-fsl-spi usable in cpu mode outside of FSL SOC environments and add a grlib variant normally running on sparc
To: Andreas Larsson <andreas@gaisler.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Kumar Gala <galak@kernel.crashing.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
        software@gaisler.com
In-Reply-To: <1359548124-13692-1-git-send-email-andreas@gaisler.com>
References: <1359548124-13692-1-git-send-email-andreas@gaisler.com>
Date: Tue, 05 Feb 2013 17:56:30 +0000
Message-Id: <20130205175630.C6F7F3E167A@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013 13:15:24 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> This makes the cpu mode of the driver available outside of an FSL SOC
> and even powerpc environment. This is accomplished by putting things
> regarding fsl specific code and to cpm specific code within ifdefs.
> 
> Furthermore, this adds support for the mostly register-compatible
> SPICTRL core from the GRLIB VHDL IP core library normally running on
> sparc. A different entry in of_fsl_spi_match matches this core and
> indicates a different hardware type that is used to set up different
> function pointers and special cases. The fetching of irq is changed to
> work under sparc as well.
> 
> The GRLIB core operates in cpu mode and from the driver's point of view
> the important differences are that the number of bits per word might be
> limited and that there might be native chipselects selected via the
> added slvsel register. These differences if present are indicated by an
> added capabilities register.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> ---
> [Resend to include more recipients]
> 
> This patch relies upon parts of the "of, of_gpio, of_spi: Fix and
> improve of_parse_phandle_with_args, of_gpio_named_count and
> of_spi_register_master" patchset - https://lkml.org/lkml/2012/12/27/54
> (v2 at https://lkml.org/lkml/2013/1/29/308).
> 
> The grlib type has been tested under sparc, but the fsl type has only
> been compile tested, so it would be great if someone with an fsl board
> could test this out.
> 
> One could argue that it would be better to add the grlib variant as a
> mode flag in of_mpc8xxx_spi_probe instead of using a new type field, but
> that would require to add a flag for this core in
> include/linux/fsl_devices.h which does not feel right given that this
> core is not part of an fsl device.
> 
> Maybe the different out/in_be32 vs iowrite/read32be in spi-fsl-lib.h is
> over the top, but I'm not sure if there might be subtle differences
> between those on powerpc and I don't have any fsl hardware to try things
> out on.

Changing to ioread/write globally should be fine. I would change it and get
someone with an fsl board to try it out. That will reduce the diffstat a
bit.

As is, this is quite an invasive patch, so I'm not going to be
comfortable merging it without at least one 3rd party tester. (Breaking
things up into discrete patches will make me less nervous and possible
to merge parts while still revising others.

Comments below...

> diff --git a/drivers/spi/spi-fsl-lib.c b/drivers/spi/spi-fsl-lib.c
> index 8ade675..e3ea564 100644
> --- a/drivers/spi/spi-fsl-lib.c
> +++ b/drivers/spi/spi-fsl-lib.c
> @@ -23,7 +23,9 @@
>  #include <linux/mm.h>
>  #include <linux/of_platform.h>
>  #include <linux/spi/spi.h>
> +#ifdef CONFIG_FSL_SOC
>  #include <sysdev/fsl_soc.h>
> +#endif
>  
>  #include "spi-fsl-lib.h"
>  
> @@ -208,6 +210,7 @@ int of_mpc8xxx_spi_probe(struct platform_device *ofdev)
>  	/* Allocate bus num dynamically. */
>  	pdata->bus_num = -1;
>  
> +#ifdef CONFIG_FSL_SOC
>  	/* SPI controller is either clocked from QE or SoC clock. */
>  	pdata->sysclk = get_brgfreq();
>  	if (pdata->sysclk == -1) {
> @@ -217,16 +220,23 @@ int of_mpc8xxx_spi_probe(struct platform_device *ofdev)
>  			goto err;
>  		}
>  	}
> +#else
> +	ret = of_property_read_u32(np, "clock-frequency", &pdata->sysclk);
> +	if (ret)
> +		goto err;
> +#endif
>  
>  	prop = of_get_property(np, "mode", NULL);
>  	if (prop && !strcmp(prop, "cpu-qe"))
>  		pdata->flags = SPI_QE_CPU_MODE;
> +#ifdef CONFIG_FSL_SOC
>  	else if (prop && !strcmp(prop, "qe"))
>  		pdata->flags = SPI_CPM_MODE | SPI_QE;
>  	else if (of_device_is_compatible(np, "fsl,cpm2-spi"))
>  		pdata->flags = SPI_CPM_MODE | SPI_CPM2;
>  	else if (of_device_is_compatible(np, "fsl,cpm1-spi"))
>  		pdata->flags = SPI_CPM_MODE | SPI_CPM1;
> +#endif

The ifdefs are ugly and these lines won't affect sparc. Just leave them
in.

>  
>  	return 0;
>  
> diff --git a/drivers/spi/spi-fsl-lib.h b/drivers/spi/spi-fsl-lib.h
> index cbe881b..f66f736 100644
> --- a/drivers/spi/spi-fsl-lib.h
> +++ b/drivers/spi/spi-fsl-lib.h
> @@ -34,8 +34,10 @@ struct mpc8xxx_spi {
>  
>  	int subblock;
>  	struct spi_pram __iomem *pram;
> +#ifdef CONFIG_FSL_SOC
>  	struct cpm_buf_desc __iomem *tx_bd;
>  	struct cpm_buf_desc __iomem *rx_bd;
> +#endif
>  
>  	struct spi_transfer *xfer_in_progress;
>  
> @@ -67,6 +69,15 @@ struct mpc8xxx_spi {
>  
>  	unsigned int flags;
>  
> +#ifdef CONFIG_SPI_FSL_SPI
> +	int type;
> +	int native_chipselects;
> +	u8 max_bits_per_word;
> +
> +	void (*set_shifts)(u32 *rx_shift, u32 *tx_shift,
> +			   int bits_per_word, int msb_first);
> +#endif
> +
>  	struct workqueue_struct *workqueue;
>  	struct work_struct work;
>  
> @@ -87,12 +98,20 @@ struct spi_mpc8xxx_cs {
>  
>  static inline void mpc8xxx_spi_write_reg(__be32 __iomem *reg, u32 val)
>  {
> +#ifdef CONFIG_FSL_SOC
>  	out_be32(reg, val);
> +#else
> +	iowrite32be(val, reg);
> +#endif

Yeah, you should be able to just change this.

> diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
> index 3ff4dfe..f9ca8ba 100644
> --- a/drivers/spi/spi-fsl-spi.c
> +++ b/drivers/spi/spi-fsl-spi.c
> @@ -72,6 +84,11 @@ struct fsl_spi_reg {
>  #define	SPMODE_OP		(1 << 14)
>  #define	SPMODE_CG(x)		((x) << 7)
>  
> +/* TYPE_GRLIB SPI Controller capability register definitions */
> +#define SPCAP_SSEN(x)           (((x) >> 16) & 0x1)
> +#define SPCAP_SSSZ(x)           (((x) >> 24) & 0xff)
> +#define SPCAP_MAXWLEN(x)	(((x) >> 20) & 0xf)

Nit: inconsistent whitespace (tabs vs. spaces)

> +static void fsl_spi_grlib_probe(struct device *dev)
> +{
> +	struct fsl_spi_platform_data *pdata = dev->platform_data;
> +	struct spi_master *master = dev_get_drvdata(dev);
> +	struct mpc8xxx_spi *mpc8xxx_spi = spi_master_get_devdata(master);
> +	struct fsl_spi_reg *reg_base = mpc8xxx_spi->reg_base;
> +	int ret, mbits;
> +	u32 capabilities;
> +	u32 bus_num;
> +
> +	capabilities = mpc8xxx_spi_read_reg(&reg_base->cap);
> +
> +	mpc8xxx_spi->set_shifts = fsl_spi_grlib_set_shifts;
> +	mbits = SPCAP_MAXWLEN(capabilities);
> +	if (mbits)
> +		mpc8xxx_spi->max_bits_per_word = mbits + 1;
> +
> +	ret = of_property_read_u32(dev->of_node, "bus-number", &bus_num);
> +	if (!ret)
> +		master->bus_num = bus_num;

Drop these lines. Never set the bus number explicitly when using DT. If
you really want to assign a particular bus number, then use an alias.

> +
> +	mpc8xxx_spi->native_chipselects = 0;
> +	if (SPCAP_SSEN(capabilities))
> +		mpc8xxx_spi->native_chipselects = SPCAP_SSSZ(capabilities);
> +	master->num_chipselect = mpc8xxx_spi->native_chipselects;
> +	pdata->cs_control = fsl_spi_grlib_cs_control;
> +}
> +
>  static struct spi_master * fsl_spi_probe(struct device *dev,
>  		struct resource *mem, unsigned int irq)
>  {
> @@ -866,27 +1048,36 @@ static struct spi_master * fsl_spi_probe(struct device *dev,
>  		goto err_probe;
>  
>  	master->setup = fsl_spi_setup;
> +	master->cleanup = fsl_spi_cleanup;
>  
>  	mpc8xxx_spi = spi_master_get_devdata(master);
>  	mpc8xxx_spi->spi_do_one_msg = fsl_spi_do_one_msg;
>  	mpc8xxx_spi->spi_remove = fsl_spi_remove;
> -
> +	mpc8xxx_spi->max_bits_per_word = 32;
> +	mpc8xxx_spi->type = fsl_spi_get_type(dev);
>  
>  	ret = fsl_spi_cpm_init(mpc8xxx_spi);
>  	if (ret)
>  		goto err_cpm_init;
>  
> -	if (mpc8xxx_spi->flags & SPI_QE_CPU_MODE) {
> -		mpc8xxx_spi->rx_shift = 16;
> -		mpc8xxx_spi->tx_shift = 24;
> -	}
> -
>  	mpc8xxx_spi->reg_base = ioremap(mem->start, resource_size(mem));
>  	if (mpc8xxx_spi->reg_base == NULL) {
>  		ret = -ENOMEM;
>  		goto err_ioremap;
>  	}

That's all the comments I've got for now, but there are an awful lot of
#defines that are added to the driver which is kind of ugly. I'm not
going to nack over that, but it would be good to clean it up and do some
better abstraction. Again, breaking up the changes into logical discrete
steps will make it a lot easier to review too.

g.
