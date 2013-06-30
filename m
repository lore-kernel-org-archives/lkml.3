Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab3F3QVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 12:21:10 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:56449 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3F3QVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 12:21:07 -0400
Date: Sun, 30 Jun 2013 19:20:09 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, broonie@kernel.org,
        grant.likely@linaro.org
Subject: Re: [PATCH 5/8] spi: spi-ep93xx: remove 'dss' from per chip private
 data
Message-ID: <20130630162009.GC786@mwesterb-mobl.lan>
References: <201306281144.34074.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306281144.34074.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 11:44:33AM -0700, H Hartley Sweeten wrote:
> This value is only needed to set the bits per word for each transfer
> of a message. There is no reason to set the value in ep93xx_spi_enable()
> because ep93xx_spi_process_transfer() sets it again for each transfer.
> 
> Just pass the t->bits_per_word directly to ep93xx_spi_chip_setup() in
> ep93xx_spi_process_transfer() and remove 'dss' from the per chip private
> data.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/spi/spi-ep93xx.c | 20 +++++++-------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
> index 4fab3bb..cb22c89 100644
> --- a/drivers/spi/spi-ep93xx.c
> +++ b/drivers/spi/spi-ep93xx.c
> @@ -140,7 +140,6 @@ struct ep93xx_spi {
>   * @rate: max rate in hz this chip supports
>   * @div_cpsr: cpsr (pre-scaler) divider
>   * @div_scr: scr divider
> - * @dss: bits per word (4 - 16 bits)
>   * @ops: private chip operations
>   *
>   * This structure is used to store hardware register specific settings for each
> @@ -152,13 +151,9 @@ struct ep93xx_spi_chip {
>  	unsigned long			rate;
>  	u8				div_cpsr;
>  	u8				div_scr;
> -	u8				dss;
>  	struct ep93xx_spi_chip_ops	*ops;
>  };
>  
> -/* converts bits per word to CR0.DSS value */
> -#define bits_per_word_to_dss(bpw)	((bpw) - 1)

I think you should keep this macro...

> -
>  static int ep93xx_spi_enable(const struct ep93xx_spi *espi)
>  {
>  	u8 regval;
> @@ -308,8 +303,6 @@ static int ep93xx_spi_setup(struct spi_device *spi)
>  		chip->rate = spi->max_speed_hz;
>  	}
>  
> -	chip->dss = bits_per_word_to_dss(spi->bits_per_word);
> -
>  	ep93xx_spi_cs_control(spi, false);
>  	return 0;
>  }
> @@ -386,22 +379,25 @@ static void ep93xx_spi_cleanup(struct spi_device *spi)
>   * ep93xx_spi_chip_setup() - configures hardware according to given @chip
>   * @espi: ep93xx SPI controller struct
>   * @chip: chip specific settings
> + * @bits_per_word: transfer bits_per_word
>   *
>   * This function sets up the actual hardware registers with settings given in
>   * @chip. Note that no validation is done so make sure that callers validate
>   * settings before calling this.
>   */
>  static void ep93xx_spi_chip_setup(const struct ep93xx_spi *espi,
> -				  const struct ep93xx_spi_chip *chip)
> +				  const struct ep93xx_spi_chip *chip,
> +				  u8 bits_per_word)
>  {
>  	u16 cr0;
>  
>  	cr0 = chip->div_scr << SSPCR0_SCR_SHIFT;
>  	cr0 |= (chip->spi->mode & (SPI_CPHA|SPI_CPOL)) << SSPCR0_MODE_SHIFT;
> -	cr0 |= chip->dss;
> +	cr0 |= (bits_per_word - 1);

... and use it here. It makes things less confusing, at least to me.
