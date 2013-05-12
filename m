Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab3ELJKO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 05:10:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48716 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3ELJKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 05:10:12 -0400
Date: Sun, 12 May 2013 10:06:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Tang <dt.tangr@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCHv3 1/6] arm: Initial TI-Nspire support
Message-ID: <20130512090610.GF18614@n2100.arm.linux.org.uk>
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com> <1368332581-94691-2-git-send-email-dt.tangr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368332581-94691-2-git-send-email-dt.tangr@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 02:22:56PM +1000, Daniel Tang wrote:
> diff --git a/arch/arm/mach-nspire/clcd.c b/arch/arm/mach-nspire/clcd.c
> new file mode 100644
> index 0000000..a4b9f06
> --- /dev/null
> +++ b/arch/arm/mach-nspire/clcd.c
> @@ -0,0 +1,117 @@
> +/*
> + *	linux/arch/arm/mach-nspire/clcd.c
> + *
> + *	Copyright (C) 2013 Daniel Tang <tangrs@tangrs.id.au>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/of.h>
> +#include <linux/amba/bus.h>
> +#include <linux/amba/clcd.h>
> +#include <linux/dma-mapping.h>
> +
> +static struct clcd_panel nspire_cx_lcd_panel = {
> +	.mode		= {
> +		.name		= "Color LCD",
> +		.refresh	= 60,
> +		.xres		= 320,
> +		.yres		= 240,
> +		.sync		= 0,
> +		.vmode		= FB_VMODE_NONINTERLACED,
> +		.pixclock	= 1,
> +		.hsync_len	= 6,
> +		.vsync_len	= 1,
> +		.right_margin	= 50,
> +		.left_margin	= 38,
> +		.lower_margin	= 3,
> +		.upper_margin	= 17,
> +	},
> +	.width		= 65, /* ~6.50 cm */
> +	.height		= 49, /* ~4.87 cm */
> +	.tim2		= TIM2_IPC,
> +	.cntl		= CNTL_LCDTFT | CNTL_LCDVCOMP(1),
> +	.bpp		= 16,
> +};
> +
> +static struct clcd_panel nspire_classic_lcd_panel = {
> +	.mode		= {
> +		.name		= "Grayscale LCD",
> +		.refresh	= 60,
> +		.xres		= 320,
> +		.yres		= 240,
> +		.sync		= FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
> +		.vmode		= FB_VMODE_NONINTERLACED,
> +		.pixclock	= 1,
> +		.hsync_len	= 6,
> +		.vsync_len	= 1,
> +		.right_margin	= 6,
> +		.left_margin	= 6,
> +	},
> +	.width		= 71, /* 7.11cm */
> +	.height		= 53, /* 5.33cm */
> +	.tim2		= 0x80007d0,
> +	.cntl		= CNTL_LCDMONO8,
> +	.bpp		= 8,
> +	.grayscale	= 1
> +};

Still no capabilities in the above - how does the CLCD controller know
which of BGR or RGB output and which format these panels support?

Each entry needs a .caps = CLCD_CAP_xxx | CLCD_CAP_xxx listing the
formats supported there.

Unless panels and the board have a .caps entry, the caps system won't
be used.

> +static struct clcd_board nspire_clcd_data = {
> +       .name           = "LCD",
> +       .caps           = CLCD_CAP_ALL,

Your board has logic to support the RGB444/BGR444 mode?  If not, setting
CLCD_CAP_ALL is incorrect.
