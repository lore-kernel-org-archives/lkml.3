Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbaFIKdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:33:05 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:65222 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbaFIKdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:33:03 -0400
Message-ID: <53958D52.2050402@gmail.com>
Date: Mon, 09 Jun 2014 12:32:50 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        p.zabel@pengutronix.de
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] reset: add the Berlin reset controller driver
References: <1401983326-19205-1-git-send-email-antoine.tenart@free-electrons.com> <1401983326-19205-2-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1401983326-19205-2-git-send-email-antoine.tenart@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 05:48 PM, Antoine Ténart wrote:
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
> +#include <linux/reset-controller.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/types.h>
> +
> +#define BERLIN_RESET_REGISTER		0x104
> +
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
> +
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
> +	priv->base += BERLIN_RESET_REGISTER;

I currently have no way to look it up myself, but is reset API providing
a way to deal with phandle+specifier with more than one parameter?
Chip-ctrl has a bunch of other reset bits spread over the regset, having
the offset encoded in the specifier would save us some SoC specific
boiler plate, i.e.

reset = <&chip 0x104 14>;

Sebastian

> +	priv->rcdev.owner = THIS_MODULE;
> +	priv->rcdev.nr_resets = size * 32;
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
> 

