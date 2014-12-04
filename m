Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356AbaLDOpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:45:24 -0500
Received: from gloria.sntech.de ([95.129.55.99]:49591 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206AbaLDOpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:45:21 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: LiYunzhi <lyz@rock-chips.com>
Cc: ulrich.prinz@googlemail.com, dianders <dianders@chromium.org>,
        huangtao <huangtao@rock-chips.com>, wulf <wulf@rock-chips.com>,
        kever.yang@rock-chips.com, linux-usb@vger.kernel.org, kishon@ti.com,
        linux-kernel@vger.kernel.org, zyw@rock-chips.com
Subject: Re: [PATCH] phy: add Rockchip RK3288 USB2 PHY driver.
Date: Thu, 04 Dec 2014 15:49:16 +0100
Message-ID: <2285404.g96njTRcVk@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1417614410-15885-2-git-send-email-lyz@rock-chips.com>
References: <1417614410-15885-1-git-send-email-lyz@rock-chips.com> <1417614410-15885-2-git-send-email-lyz@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roy,

Am Mittwoch, 3. Dezember 2014, 21:46:50 schrieb LiYunzhi:
> From: lyz <lyz@rock-chips.com>
> 
> Add a driver for the Rockchip SoC internal USB2.0 PHY.
> This driver currently support RK3288.
> 
> Signed-off-by: lyz <lyz@rock-chips.com>
> ---

[...]

> diff --git a/drivers/phy/phy-rockchip-usb.c b/drivers/phy/phy-rockchip-usb.c
> new file mode 100644
> index 0000000..2586b76
> --- /dev/null
> +++ b/drivers/phy/phy-rockchip-usb.c
> @@ -0,0 +1,179 @@
> +/*
> + * Rockchip usb PHY driver
> + *
> + * Copyright (C) 2014 Roy Li <lyz@rock-chips.com>
> + * Copyright (C) 2014 ROCKCHIP, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/reset.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/syscon.h>
> +
> +#define ROCKCHIP_RK3288_UOC(n)	(0x320 + n * 0x14)
> +
> +#define SIDDQ_MSK		(1 << (13 + 16))
> +#define SIDDQ_ON		(1 << 13)
> +#define SIDDQ_OFF		(0 << 13)

In the rockchip clock driver [in drivers/clk/rockchip/clk.h] exist a macro 
HIWORD_UPDATE that removes the need to declare the write-enable bits 
separately.


> +
> +enum rk3288_phy_id {
> +	RK3288_OTG,
> +	RK3288_HOST0,
> +	RK3288_HOST1,
> +	RK3288_NUM_PHYS,
> +};
> +
> +struct rockchip_usb_phy {
> +	struct regmap *reg_base;
> +	unsigned int reg_offset;
> +	struct clk *clk;
> +	struct phy *phy;
> +};
> +
> +static int rockchip_usb_phy_power(struct rockchip_usb_phy *phy,
> +					   bool siddq)
> +{
> +	return regmap_write(phy->reg_base, phy->reg_offset,
> +			    SIDDQ_MSK | (siddq ? SIDDQ_ON : SIDDQ_OFF));

just for my understanding:

You're using the SIDDQ bit, which supposedly "powers down all analog blocks" 
for IDDQ testing to control the phy power.

What is the difference to usbotg_disable (bit 4 of uoc_con0) that is supposed 
to "power down the USB OTG/HOST block"?

Similarly, where is the difference to usbotg_sleepm [uoc_con2 bit 10] combined 
with usbotg_common_on_n [uoc_con0 bit 0]?


Thanks
Heiko
