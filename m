Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab3BGL4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 06:56:13 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45642 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124Ab3BGL4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 06:56:11 -0500
Date: Thu, 7 Feb 2013 11:55:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Girish K S <girishks2000@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] spi: s3c64xx: add gpio quirk for controller
Message-ID: <20130207115546.GA3801@sirena.org.uk>
References: <1360105784-12282-1-git-send-email-ks.giri@samsung.com>
 <1360105784-12282-4-git-send-email-ks.giri@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360105784-12282-4-git-send-email-ks.giri@samsung.com>
X-Cookie: Check your local listings.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 03:09:43PM -0800, Girish K S wrote:
> This patch adds support for spi controllers with
> dedicated clk/miso/mosi/cs pins. It skips the gpio
> parsing and initialization for controllers that
> have dedicated pins.

>  		if (sdd->tgl_spi != spi) { /* if last mssg on diff device */
>  			/* Deselect the last toggled device */
>  			cs = sdd->tgl_spi->controller_data;
> -			gpio_set_value(cs->line,
> -				spi->mode & SPI_CS_HIGH ? 0 : 1);
> +			if (!(sdd->port_conf->quirks & S3C64XX_SPI_QUIRK_GPIO))
> +				gpio_set_value(cs->line,
> +					spi->mode & SPI_CS_HIGH ? 0 : 1);
>  		}

This isn't going to work with system designs which ignore the /CS line
the controller has and just use a GPIO instead.  This is very common,
for example when connecting multiple devices to the same SPI bus.

It seems like there's really two changes here.  One change is making the
provision of pinmux information optional, the other is allowing the user
to use the controller /CS management rather than using GPIO.
