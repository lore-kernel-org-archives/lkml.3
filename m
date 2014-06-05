Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaFEQgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:36:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40953 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaFEQgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:36:52 -0400
Message-ID: <1401986205.4103.9.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 1/9] reset: add the Berlin reset controller driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Antoine =?ISO-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Jun 2014 18:36:45 +0200
In-Reply-To: <1401983326-19205-2-git-send-email-antoine.tenart@free-electrons.com>
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com>
	 <1401983326-19205-2-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antoine,

thank you for the patch. I have a few comments below.

Am Donnerstag, den 05.06.2014, 17:48 +0200 schrieb Antoine Ténart:
> Add a reset controller for Marvell Berlin SoCs which is used by the
> USB PHYs drivers (for now).
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  drivers/reset/Makefile       |   1 +
>  drivers/reset/reset-berlin.c | 113 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 114 insertions(+)
>  create mode 100644 drivers/reset/reset-berlin.c
> 
> diff --git a/drivers/reset/Makefile b/drivers/reset/Makefile
> index 4f60caf750ce..fffe2a3dd255 100644
> --- a/drivers/reset/Makefile
> +++ b/drivers/reset/Makefile
> @@ -1,3 +1,4 @@
>  obj-$(CONFIG_RESET_CONTROLLER) += core.o
> +obj-$(CONFIG_ARCH_BERLIN) += reset-berlin.o
>  obj-$(CONFIG_ARCH_SUNXI) += reset-sunxi.o
>  obj-$(CONFIG_ARCH_STI) += sti/
> diff --git a/drivers/reset/reset-berlin.c b/drivers/reset/reset-berlin.c
> new file mode 100644
> index 000000000000..78b42c882cb2
> --- /dev/null
> +++ b/drivers/reset/reset-berlin.c
> @@ -0,0 +1,113 @@
> +/*
> + * Copyright (C) 2014 Marvell Technology Group Ltd.
> + *
> + * Antoine Ténart <antoine.tenart@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>

Is there a reason this is not actually implemented as platform device?

> +#include <linux/reset-controller.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/types.h>
> +
> +#define BERLIN_RESET_REGISTER		0x104

How many reset registers are there? (See below).

> +#define to_berlin_reset_priv(p)		\
> +	container_of((p), struct berlin_reset_priv, rcdev)
> +
> +struct berlin_reset_priv {
> +	spinlock_t			lock;
> +	void __iomem			*base;
> +	struct reset_controller_dev	rcdev;
> +};
> +
> +static int berlin_reset_reset(struct reset_controller_dev *rcdev,
> +			      unsigned long id)
> +{
> +	struct berlin_reset_priv *priv = to_berlin_reset_priv(rcdev);
> +	unsigned long flags;
> +	int bank = id / BITS_PER_LONG;
> +	int offset = id % BITS_PER_LONG;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +
> +	writel(BIT(offset), priv->base + bank * 4);
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);

Since this is a single write into an apparently self-clearing
register, I see no need for the spinlock here.

> +	/* let the reset be effective */
> +	udelay(10);
> +
> +	return 0;
> +}
> +
> +static struct reset_control_ops berlin_reset_ops = {
> +	.reset	= berlin_reset_reset,
> +};
> +
> +static int __berlin_reset_init(struct device_node *np)
> +{
> +	struct berlin_reset_priv *priv;
> +	struct resource res;
> +	resource_size_t size;
> +	int ret;
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
> +	ret = of_address_to_resource(np, 0, &res);
> +	if (ret)
> +		goto err;
> +
> +	size = resource_size(&res);
> +
> +	priv->base = ioremap(res.start, size);
> +	if (!priv->base) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}

A platform driver could use devm_kzalloc, platform_get_resource,
and devm_ioremap_resource here.

> +	priv->base += BERLIN_RESET_REGISTER;
> +
> +	priv->rcdev.owner = THIS_MODULE;
> +	priv->rcdev.nr_resets = size * 32;

This doesn't seem right. The device tree patch shows that
size = 0x400.

> +	priv->rcdev.ops = &berlin_reset_ops;
> +	priv->rcdev.of_node = np;
> +
> +	reset_controller_register(&priv->rcdev);
> +
> +	return 0;
> +
> +err:
> +	kfree(priv);
> +	return ret;
> +}
> +
> +static const struct of_device_id berlin_reset_of_match[] __initdata = {
> +	{ .compatible = "marvell,berlin2q-chip-ctrl" },
> +	{ },
> +};
> +
> +static int __init berlin_reset_init(void)
> +{
> +	struct device_node *np;
> +	int ret;
> +
> +	for_each_matching_node(np, berlin_reset_of_match) {
> +		ret = __berlin_reset_init(np);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +arch_initcall(berlin_reset_init);

regards
Philipp

