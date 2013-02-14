Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab3BNKLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:11:37 -0500
Received: from sauhun.de ([89.238.76.85]:37790 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab3BNKLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:11:35 -0500
Date: Thu, 14 Feb 2013 11:11:30 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-i2c@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] i2c: Add Congatec CGEB I2C driver
Message-ID: <20130214101130.GB12290@nekote.pengutronix.de>
References: <1360663374-30951-1-git-send-email-s.hauer@pengutronix.de>
 <1360663374-30951-3-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360663374-30951-3-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

> diff --git a/drivers/i2c/busses/i2c-congatec-cgeb.c b/drivers/i2c/busses/i2c-congatec-cgeb.c
> new file mode 100644
> index 0000000..5f48ca4
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-congatec-cgeb.c
> @@ -0,0 +1,194 @@
> +/*
> + * CGEB i2c driver
> + *
> + * (c) 2011 Sascha Hauer, Pengutronix
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <asm/congatec-cgeb.h>

Is asm a good place? Maybe linux/platform_data?

> +
> +#define CG_I2C_FLAG_START   0x00080	/* send START condition */
> +#define CG_I2C_FLAG_STOP    0x00040	/* send STOP condition */
> +#define CG_I2C_FLAG_ALL_ACK 0x08000	/* send ACK on all read bytes */
> +#define CG_I2C_FLAG_ALL_NAK 0x04000	/* send NAK on all read bytes */
> +
> +struct cgeb_i2c_priv {
> +	struct cgeb_board_data		*board;
> +	struct i2c_adapter	adapter;
> +	int unit;
> +};
> +
> +static u32 cgeb_i2c_func(struct i2c_adapter *adapter)
> +{
> +	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
> +}

To make sure: Have you checked if the driver can do SMBUS_QUICK by using
'i2cdetect'?

...

> +static int cgeb_i2c_probe(struct platform_device *pdev)
> +{
> +	struct cgeb_i2c_priv *priv;
> +	struct cgeb_pdata *pdata = pdev->dev.platform_data;
> +	int ret;
> +
> +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	strcpy(priv->adapter.name, pdev->name);
> +	priv->adapter.owner		= THIS_MODULE;
> +	priv->adapter.algo		= &cgeb_i2c_algo;
> +	priv->adapter.dev.parent	= &pdev->dev;
> +	priv->unit = pdata->unit;
> +	priv->board = pdata->board;
> +	i2c_set_adapdata(&priv->adapter, priv);
> +
> +	platform_set_drvdata(pdev, priv);
> +
> +	ret = cgeb_i2c_set_speed(priv, 400000);

Not all slaves handle 400kHz. So, this might be a bit demanding. Then
again, it is probably fix which slaves are connected and they work
currently?

...

> +MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
> +MODULE_DESCRIPTION("cgeb i2c driver");
> +MODULE_LICENSE("GPL");

GPLv2 is mentioned in the header.

Other than that, the driver looks fine to me. If it should go via mfd,
here is my

Acked-by: Wolfram Sang <wsa@the-dreams.de>

Otherwise, let me know if and when I should pick it up.

Thanks,

   Wolfram

