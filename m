Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaHGFW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:22:26 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53304 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbaHGFWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:22:25 -0400
Date: Wed, 6 Aug 2014 22:22:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Nick Krause <xerofoiify@gmail.com>
Cc: Mark Brown <broonie@kernel.org>,
        "open list:SPI SUBSYSTEM" <linux-spi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi: Initialize variable to prevent uninitialized warning
Message-ID: <20140807052219.GA21124@roeck-us.net>
References: <1407387060-28992-1-git-send-email-xerofoiify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407387060-28992-1-git-send-email-xerofoiify@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 06:51:00AM +0200, Nick Krause wrote:
> While compiling we see the following waring
> 
> drivers/spi/spi-bfin5xx.c: In function 'bfin_spi_pump_transfers':
> drivers/spi/spi-bfin5xx.c:695:6: warning: 'cr_width' may be used uninitialized
> in this function [-Wuninitialized]
> 
> Initialize it to prevent the above warning
> 
> Signed-off-by: Nick Krause <xerofoify@gmail.com>
> ---
>  drivers/spi/spi-bfin5xx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi-bfin5xx.c b/drivers/spi/spi-bfin5xx.c
> index ebf720b..f268bf4 100644
> --- a/drivers/spi/spi-bfin5xx.c
> +++ b/drivers/spi/spi-bfin5xx.c
> @@ -559,7 +559,7 @@ static void bfin_spi_pump_transfers(unsigned long data)
>  	struct spi_transfer *previous = NULL;
>  	struct bfin_spi_slave_data *chip = NULL;
>  	unsigned int bits_per_word;
> -	u16 cr, cr_width, dma_width, dma_config;
> +	u16 cr, cr_width = 0, dma_width, dma_config;
>  	u32 tranf_success = 1;
>  	u8 full_duplex = 0;
>  
> @@ -648,7 +648,6 @@ static void bfin_spi_pump_transfers(unsigned long data)
>  	} else if (bits_per_word == 8) {
>  		drv_data->n_bytes = bits_per_word/8;
>  		drv_data->len = transfer->len;
> -		cr_width = 0;
>  		drv_data->ops = &bfin_bfin_spi_transfer_ops_u8;
>  	}

So if we ever hit that uninitialized case, where bits_per_word is
neither 8 nor 16, we'll have ops set to NULL and end up wondering
why the kernel crashes a bit further down in the code. Not really
sure if that is an improvement.

Guenter
