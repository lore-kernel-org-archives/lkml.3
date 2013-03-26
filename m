Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456Ab3CZJzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:55:46 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:51003 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759640Ab3CZJzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:55:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130214101130.GB12290@nekote.pengutronix.de>
References: <1360663374-30951-1-git-send-email-s.hauer@pengutronix.de>
 <1360663374-30951-3-git-send-email-s.hauer@pengutronix.de> <20130214101130.GB12290@nekote.pengutronix.de>
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Tue, 26 Mar 2013 10:55:22 +0100
Message-ID: <CAH9NwWd2soWW-Fx_ESYErL2wioUqxrq=57rnfi7GOsg9LSiBWw@mail.gmail.com>
Subject: Re: [PATCH 2/3] i2c: Add Congatec CGEB I2C driver
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org, linux-i2c@vger.kernel.org,
        linux-watchdog@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/14 Wolfram Sang <wsa@the-dreams.de>:
> Hi Sascha,
>
>> diff --git a/drivers/i2c/busses/i2c-congatec-cgeb.c b/drivers/i2c/busses/i2c-congatec-cgeb.c
>> new file mode 100644
>> index 0000000..5f48ca4
>> --- /dev/null
>> +++ b/drivers/i2c/busses/i2c-congatec-cgeb.c
>> @@ -0,0 +1,194 @@
>> +/*
>> + * CGEB i2c driver
>> + *
>> + * (c) 2011 Sascha Hauer, Pengutronix
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; version 2 of the License.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/i2c.h>
>> +#include <asm/congatec-cgeb.h>
>
> Is asm a good place? Maybe linux/platform_data?
>
>> +
>> +#define CG_I2C_FLAG_START   0x00080  /* send START condition */
>> +#define CG_I2C_FLAG_STOP    0x00040  /* send STOP condition */
>> +#define CG_I2C_FLAG_ALL_ACK 0x08000  /* send ACK on all read bytes */
>> +#define CG_I2C_FLAG_ALL_NAK 0x04000  /* send NAK on all read bytes */
>> +
>> +struct cgeb_i2c_priv {
>> +     struct cgeb_board_data          *board;
>> +     struct i2c_adapter      adapter;
>> +     int unit;
>> +};
>> +
>> +static u32 cgeb_i2c_func(struct i2c_adapter *adapter)
>> +{
>> +     return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
>> +}
>
> To make sure: Have you checked if the driver can do SMBUS_QUICK by using
> 'i2cdetect'?
>
> ...
>
>> +static int cgeb_i2c_probe(struct platform_device *pdev)
>> +{
>> +     struct cgeb_i2c_priv *priv;
>> +     struct cgeb_pdata *pdata = pdev->dev.platform_data;
>> +     int ret;
>> +
>> +     priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
>> +     if (!priv)
>> +             return -ENOMEM;
>> +
>> +     strcpy(priv->adapter.name, pdev->name);
>> +     priv->adapter.owner             = THIS_MODULE;
>> +     priv->adapter.algo              = &cgeb_i2c_algo;
>> +     priv->adapter.dev.parent        = &pdev->dev;
>> +     priv->unit = pdata->unit;
>> +     priv->board = pdata->board;
>> +     i2c_set_adapdata(&priv->adapter, priv);
>> +
>> +     platform_set_drvdata(pdev, priv);
>> +
>> +     ret = cgeb_i2c_set_speed(priv, 400000);
>
> Not all slaves handle 400kHz. So, this might be a bit demanding. Then
> again, it is probably fix which slaves are connected and they work
> currently?
>
> ...
>
>> +MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
>> +MODULE_DESCRIPTION("cgeb i2c driver");
>> +MODULE_LICENSE("GPL");
>
> GPLv2 is mentioned in the header.
>
> Other than that, the driver looks fine to me. If it should go via mfd,
> here is my
>
> Acked-by: Wolfram Sang <wsa@the-dreams.de>
>
> Otherwise, let me know if and when I should pick it up.
>

root@OT:/home/vis# i2cdetect -l
i2c-0   i2c             cgeb-i2c                                I2C adapter
i2c-1   i2c             Radeon i2c bit bus 0x90                 I2C adapter
i2c-2   i2c             Radeon i2c bit bus 0x91                 I2C adapter
i2c-3   i2c             Radeon i2c bit bus 0x92                 I2C adapter
i2c-4   i2c             Radeon i2c bit bus 0x93                 I2C adapter
i2c-5   i2c             Radeon i2c bit bus 0x94                 I2C adapter
i2c-6   i2c             Radeon i2c bit bus 0x95                 I2C adapter
i2c-7   i2c             Radeon i2c bit bus 0x96                 I2C adapter
i2c-8   i2c             Radeon i2c bit bus 0x97                 I2C adapter
i2c-9   i2c             Radeon aux bus DP-auxch                 I2C adapter
root@OT:/home/vis# i2cdetect 0
WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-0.
I will probe address range 0x03-0x77.
Continue? [Y/n]
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: -- 21 -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- 48 -- -- -- -- -- -- --
50: 50 51 -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --


Tested-by: Christian Gmeiner <christian.gmeiner@gmail.com>
--
Christian Gmeiner, MSc
