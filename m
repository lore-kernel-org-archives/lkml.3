Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab3EaIqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:46:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52276 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab3EaIqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:46:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 2/2] spi: convert drivers to use bits_per_word_mask
Date: Fri, 31 May 2013 10:45:32 +0200
Message-ID: <1528437.8btZmmDHhd@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1369190195-14598-2-git-send-email-swarren@wwwdotorg.org>
References: <1369190195-14598-1-git-send-email-swarren@wwwdotorg.org> <1369190195-14598-2-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:RBoVuE2+xIp9Yc17Q/I0wknZnt+IlciEn9PhrF1PgwF
 ijeH3QnJ5wV2Sf79XatzWWnD8OTt2bkljr8zyfLNaCQksHjcfB
 wHHmafUlJYG8nhoIYc7jnJFMetDuOweVzdabo7VPhcf8HOI6AI
 KfYbh4AKm0guKAJwfpXOUA9AwLYSqGacwWbflX6YKzfrfDAgdf
 fqm7XcNcGQIZv68PTisXkeUKP4zD9RnWC1A+L9ic7IVM0XbD2w
 AY2RAtB/RD1v0IcflYTrAzrz6z74D9xeize+CZ/Z68MR763yYi
 H16hqWSt+kFl2Us+56ZOcOig/jCFkHIbLglRow/mxK6Bdq2DUa
 Y/KyZbKBp4pjExmDZyI4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you check this part again:

On Tuesday 21 May 2013 20:36:35 Stephen Warren wrote:
> diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
> index f5d84d6..7de2ca1 100644
> --- a/drivers/spi/spi-pxa2xx.c
> +++ b/drivers/spi/spi-pxa2xx.c
> @@ -881,21 +881,6 @@ static int setup(struct spi_device *spi)
>                 rx_thres = RX_THRESH_DFLT;
>         }
>  
> -       if (!pxa25x_ssp_comp(drv_data)
> -               && (spi->bits_per_word < 4 || spi->bits_per_word > 32)) {
> -               dev_err(&spi->dev, "failed setup: ssp_type=%d, bits/wrd=%d "
> -                               "b/w not 4-32 for type non-PXA25x_SSP\n",
> -                               drv_data->ssp_type, spi->bits_per_word);
> -               return -EINVAL;
> -       } else if (pxa25x_ssp_comp(drv_data)
> -                       && (spi->bits_per_word < 4
> -                               || spi->bits_per_word > 16)) {
> -               dev_err(&spi->dev, "failed setup: ssp_type=%d, bits/wrd=%d "
> -                               "b/w not 4-16 for type PXA25x_SSP\n",
> -                               drv_data->ssp_type, spi->bits_per_word);
> -               return -EINVAL;
> -       }
> -
>         /* Only alloc on first setup */
>         chip = spi_get_ctldata(spi);
>         if (!chip) {
> @@ -1011,9 +996,6 @@ static int setup(struct spi_device *spi)
>                 chip->n_bytes = 4;
>                 chip->read = u32_reader;
>                 chip->write = u32_writer;
> -       } else {
> -               dev_err(&spi->dev, "invalid wordsize\n");
> -               return -ENODEV;
>         }
>         chip->bits_per_word = spi->bits_per_word;
>  
> @@ -1190,11 +1172,13 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
>         drv_data->ioaddr = ssp->mmio_base;
>         drv_data->ssdr_physical = ssp->phys_base + SSDR;
>         if (pxa25x_ssp_comp(drv_data)) {
> +               master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 16);
>                 drv_data->int_cr1 = SSCR1_TIE | SSCR1_RIE;
>                 drv_data->dma_cr1 = 0;
>                 drv_data->clear_sr = SSSR_ROR;
>                 drv_data->mask_sr = SSSR_RFS | SSSR_TFS | SSSR_ROR;
>         } else {
> +               master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
>                 drv_data->int_cr1 = SSCR1_TIE | SSCR1_RIE | SSCR1_TINTE;
>                 drv_data->dma_cr1 = DEFAULT_DMA_CR1;
>                 drv_data->clear_sr = SSSR_ROR | SSSR_TINT;

I get a new build warning

drivers/spi/spi-pxa2xx.c: In function 'pxa2xx_spi_probe':
drivers/spi/spi-pxa2xx.c:1152:3: warning: left shift count >= width of type [enabled by default]
   master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
   ^

	Arnd
