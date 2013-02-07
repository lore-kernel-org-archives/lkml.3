Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab3BGQMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:12:06 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:48603 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546Ab3BGQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:12:03 -0500
Date: Thu, 7 Feb 2013 08:08:21 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Andreas Larsson <andreas@gaisler.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Kumar Gala <galak@kernel.crashing.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v2 7/7] spi: spi-fsl-spi: Add support for gpio
 chipselects for GRLIB type cores
Message-ID: <20130207160821.GA22224@lizard.gateway.2wire.net>
References: <1360242731-13700-1-git-send-email-andreas@gaisler.com>
 <1360242731-13700-8-git-send-email-andreas@gaisler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1360242731-13700-8-git-send-email-andreas@gaisler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 02:12:11PM +0100, Andreas Larsson wrote:
> This relies upon of_spi_register_master to find out which gpios to use.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> ---
>  drivers/spi/spi-fsl-lib.h |    1 +
>  drivers/spi/spi-fsl-spi.c |   53 +++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 48 insertions(+), 6 deletions(-)

Just a couple of minor nits...

> diff --git a/drivers/spi/spi-fsl-lib.h b/drivers/spi/spi-fsl-lib.h
> index d5c788b..52db693 100644
> --- a/drivers/spi/spi-fsl-lib.h
> +++ b/drivers/spi/spi-fsl-lib.h
> @@ -71,6 +71,7 @@ struct mpc8xxx_spi {
>  
>  #ifdef CONFIG_SPI_FSL_SPI
>  	int type;
> +	int native_chipselects;
>  	u8 max_bits_per_word;
>  
>  	void (*set_shifts)(u32 *rx_shift, u32 *tx_shift,
> diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
> index 55652e6..2befe16 100644
> --- a/drivers/spi/spi-fsl-spi.c
> +++ b/drivers/spi/spi-fsl-spi.c
> @@ -418,7 +418,7 @@ static int fsl_spi_setup(struct spi_device *spi)
>  {
>  	struct mpc8xxx_spi *mpc8xxx_spi;
>  	struct fsl_spi_reg *reg_base;
> -	int retval;
> +	int retval, desel;

We don't usually place variable declarations on the same line, unless the
variables are closely related.

>  	u32 hw_mode;
>  	struct spi_mpc8xxx_cs	*cs = spi->controller_state;
>  
> @@ -456,12 +456,45 @@ static int fsl_spi_setup(struct spi_device *spi)
>  		return retval;
>  	}
>  
> +	if (mpc8xxx_spi->type == TYPE_GRLIB) {
> +		if (gpio_is_valid(spi->cs_gpio)) {

<- You can place the 'int desel;' here, limiting the visibility for it.

> +			retval = gpio_request(spi->cs_gpio,
> +					      dev_name(&spi->dev));
> +			if (retval)
> +				return retval;
> +
> +			desel = !(spi->mode & SPI_CS_HIGH);
> +			desel ^= !!(spi->cs_gpio_flags & OF_GPIO_ACTIVE_LOW);
> +			retval = gpio_direction_output(spi->cs_gpio, desel);
> +			if (retval) {
> +				gpio_free(spi->cs_gpio);
> +				return retval;
> +			}

Thanks,
Anton
