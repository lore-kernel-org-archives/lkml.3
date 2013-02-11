Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab3BKAXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 19:23:25 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47676 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3BKAXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 19:23:24 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 6/6] of_spi: Initialize cs_gpios and cs_gpio with -EEXIST
To: Andreas Larsson <andreas@gaisler.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        software@gaisler.com
In-Reply-To: <1359471223-4794-7-git-send-email-andreas@gaisler.com>
References: <1359471223-4794-1-git-send-email-andreas@gaisler.com> <1359471223-4794-7-git-send-email-andreas@gaisler.com>
Date: Mon, 11 Feb 2013 00:23:20 +0000
Message-Id: <20130211002320.824593E0C13@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013 15:53:43 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> Holes in the cs-gpios DT phandle list is supposed to mark that native
> chipselects is to be used. The value returned from of_get_named_gpio_flags in
> this case is -EEXIST. By initializing cs_gpios and cs_gpio with -EEXIST, this
> and only this errno will indicate to a spi controller driver that a native
> chipselect is to be used.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

I've left this one off for now. Take a look at the patch I posted and
let me know if you think this one should still be applied.

g.

> ---
>  drivers/spi/spi.c       |    4 ++--
>  include/linux/spi/spi.h |    7 +++++--
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 6f1b717..7494bad 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -334,7 +334,7 @@ struct spi_device *spi_alloc_device(struct spi_master *master)
>  	spi->dev.parent = &master->dev;
>  	spi->dev.bus = &spi_bus_type;
>  	spi->dev.release = spidev_release;
> -	spi->cs_gpio = -EINVAL;
> +	spi->cs_gpio = -EEXIST;
>  	device_initialize(&spi->dev);
>  	return spi;
>  }
> @@ -1097,7 +1097,7 @@ static int of_spi_register_master(struct spi_master *master)
>  	}
>  
>  	for (i = 0; i < master->num_chipselect; i++)
> -		cs[i] = -EINVAL;
> +		cs[i] = -EEXIST;
>  
>  	for (i = 0; i < nb; i++)
>  		cs[i] = of_get_named_gpio_flags(np, "cs-gpios", i, &flags[i]);
> diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
> index 96b1055..0701882 100644
> --- a/include/linux/spi/spi.h
> +++ b/include/linux/spi/spi.h
> @@ -58,7 +58,8 @@ extern struct bus_type spi_bus_type;
>   * @modalias: Name of the driver to use with this device, or an alias
>   *	for that name.  This appears in the sysfs "modalias" attribute
>   *	for driver coldplugging, and in uevents used for hotplugging
> - * @cs_gpio: Negative or gpio for chip select.
> + * @cs_gpio: Negative or gpio for chip select.  Set to -EEXIST when chipselect
> + *	should be handled natively by the controller driver
>   * @cs_gpio_flags: of_gpio_flags corresponding to cs_gpio
>   *
>   * A @spi_device is used to interchange data between an SPI slave
> @@ -262,7 +263,9 @@ static inline void spi_unregister_driver(struct spi_driver *sdrv)
>   * @unprepare_transfer_hardware: there are currently no more messages on the
>   *	queue so the subsystem notifies the driver that it may relax the
>   *	hardware by issuing this call
> - * @cs_gpios: possible array of negative values or gpios for chip selects
> + * @cs_gpios: possible array of negative values or gpios for chip selects.  A
> + *	chipselect that should be handled natively by the controller driver is
> + *	set to -EEXIST.
>   * @cs_gpio_flags: possible array of of_gpio_flags corresponding to cs_gpios
>   *
>   * Each SPI master controller can communicate with one or more @spi_device
> -- 
> 1.7.0.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
