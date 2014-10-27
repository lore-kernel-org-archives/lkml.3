Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbaKGHOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 02:14:55 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35002 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaKGHOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 02:14:52 -0500
Date: Mon, 27 Oct 2014 05:14:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org
Subject: Re: [PATCH v4] Add LTC2941/LTC2943 Battery Gauge Driver
Message-ID: <20141027041417.GB21264@xo-6d-61-c0.localdomain>
References: <1412748300-3915-1-git-send-email-mike.looijmans@topic.nl>
 <1414067918-6688-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414067918-6688-1-git-send-email-mike.looijmans@topic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +++ b/drivers/power/ltc2941-battery-gauge.c
> @@ -0,0 +1,547 @@
> +/*
> + * I2C client/driver for the Linear Technology LTC2941 and LTC2943
> + * Battery Gas Gauge IC
> + *
> + * Copyright (C) 2014 Topic Embedded Systems
> + *

NOrmally GPL notice would go here.

> + * Author: Auryn Verwegen
> + * Author: Mike Looijmans
> + */

Do you want to add yourself as a maintainers?

> +{
> +	int ret;
> +	struct i2c_msg msgs[2] = { };
> +	u8 reg_start = reg;
> +
> +	msgs[0].addr	= client->addr;
> +	msgs[0].len	= 1;
> +	msgs[0].buf	= &reg_start;
> +
> +	msgs[1].addr	= client->addr;
> +	msgs[1].len	= num_regs;
> +	msgs[1].buf	= buf;
> +	msgs[1].flags	= I2C_M_RD;
> +
> +	ret = i2c_transfer(client->adapter, &msgs[0], 2);

Here you send byte from kernel stack to i2c device. I'd add msg[0].flags = 0.

> +		ret = ltc294x_write_regs(info->client,
> +			LTC294X_REG_CONTROL, &control, 1);
> +		if (ret < 0) {
> +			dev_err(&info->client->dev,
> +				"Could not write register\n");
> +			goto error_exit;

return ret; No need to goto when you have nothing to clean up.

> +		}
> +	}
> +
> +	return 0;
> +
> +error_exit:
> +	return ret;
> +}

> +	if (info->Qlsb < 0)
> +		value += 0xFFFF;

q_lsb?

> +	dataw[0] = I16_MSB(value);
> +	dataw[1] = I16_LSB(value);
> +	ret = ltc294x_write_regs(info->client,
> +		LTC294X_REG_ACC_CHARGE_MSB, &dataw[0], 2);
> +	if (ret < 0)
> +		goto error_exit;
> +	/* Enable analog section */
> +error_exit:

Interesting use of goto... remove?

> +	ret = of_property_read_u32(np, "prescaler-exponent", &prescaler_exp);
> +	if (ret < 0) {
> +		dev_err(&client->dev,
> +			"PrescalerExponent not in devicetree, assume max\n");

assuming?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
