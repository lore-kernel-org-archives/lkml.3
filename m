Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab3CKW2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 18:28:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab3CKW2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 18:28:03 -0400
Date: Mon, 11 Mar 2013 15:28:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [PATCH] backlight: l4f00242t03: check return value of
 regulator_enable()
Message-Id: <20130311152801.fd07ff051885bb1c98fe14f5@linux-foundation.org>
In-Reply-To: <005f01ce1e0c$b7dbcfc0$27936f40$%han@samsung.com>
References: <005f01ce1e0c$b7dbcfc0$27936f40$%han@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Mar 2013 12:58:41 +0900 Jingoo Han <jg1.han@samsung.com> wrote:

> The regulator_enable() was marked as as __must_check, therefore,
> the return value of regulator_enable() should be checked.
> Also, this patch checks return value of regulator_set_voltage().
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/l4f00242t03.c |   27 ++++++++++++++++++++++-----
>  1 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
> index fb61557..8d54c3c 100644
> --- a/drivers/video/backlight/l4f00242t03.c
> +++ b/drivers/video/backlight/l4f00242t03.c
> @@ -51,14 +51,31 @@ static void l4f00242t03_lcd_init(struct spi_device *spi)
>  	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
>  	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
>  	const u16 cmd[] = { 0x36, param(0), 0x3A, param(0x60) };
> +	int ret;
>  
>  	dev_dbg(&spi->dev, "initializing LCD\n");
>  
> -	regulator_set_voltage(priv->io_reg, 1800000, 1800000);
> -	regulator_enable(priv->io_reg);
> +	ret = regulator_set_voltage(priv->io_reg, 1800000, 1800000);
> +	if (ret) {
> +		dev_err(&spi->dev, "failed to set the IO regulator voltage.\n");
> +		return;
> +	}
> +	ret = regulator_enable(priv->io_reg);
> +	if (ret) {
> +		dev_err(&spi->dev, "failed to enable the IO regulator.\n");
> +		return;
> +	}
>  
> -	regulator_set_voltage(priv->core_reg, 2800000, 2800000);
> -	regulator_enable(priv->core_reg);
> +	ret = regulator_set_voltage(priv->core_reg, 2800000, 2800000);
> +	if (ret) {
> +		dev_err(&spi->dev, "failed to set the core regulator voltage.\n");
> +		return;

Should the IO regulator be disabled before returning?

> +	}
> +	ret = regulator_enable(priv->core_reg);
> +	if (ret) {
> +		dev_err(&spi->dev, "failed to enable the core regulator.\n");
> +		return;
> +	}

Ditto.
