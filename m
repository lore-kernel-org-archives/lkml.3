Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaFXLNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 07:13:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55491 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaFXLNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 07:13:45 -0400
Message-ID: <1403608416.2910.15.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v2 01/12] reset: add the Berlin reset controller driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Antoine =?ISO-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 24 Jun 2014 13:13:36 +0200
In-Reply-To: <1403606121-6368-2-git-send-email-antoine.tenart@free-electrons.com>
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com>
	 <1403606121-6368-2-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
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

Am Dienstag, den 24.06.2014, 12:35 +0200 schrieb Antoine Ténart:
[...]
> +++ b/drivers/reset/reset-berlin.c
> @@ -0,0 +1,131 @@
> +/*
> + * Copyright (C) 2014 Marvell Technology Group Ltd.
> + *
> + * Antoine Ténart <antoine.tenart@free-electrons.com>
> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
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
> +#include <linux/types.h>
> +
> +#define to_berlin_reset_priv(p)		\
> +	container_of((p), struct berlin_reset_priv, rcdev)
> +
> +struct berlin_reset_priv {
> +	spinlock_t			lock;

lock is not used anymore.

[...]
> +static int berlin_reset_xlate(struct reset_controller_dev *rcdev,
> +			      const struct of_phandle_args *reset_spec)
> +{
> +	struct berlin_reset_priv *priv = to_berlin_reset_priv(rcdev);
> +	unsigned offset, bit;
> +
> +	if (WARN_ON(reset_spec->args_count != rcdev->of_reset_n_cells))
> +		return -EINVAL;
> +
> +	offset = reset_spec->args[0];
> +	bit = reset_spec->args[1];
> +
> +	if (offset >= priv->size)
> +		return -EINVAL;
> +
> +	if (bit >= rcdev->nr_resets)
> +		return -EINVAL;

This could be considered a misuse of nr_resets, even if the core only
ever uses nr_resets in the _xlate function. Maybe it would be more clear
to just leave nr_resets empty if you don't know the actual number and
hardcode 32 here.

[...]
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
> +	priv->base = ioremap(res.start, size);
> +	if (!priv->base) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +	priv->size = size;
> +
> +	priv->rcdev.owner = THIS_MODULE;
> +	priv->rcdev.nr_resets = 32;

Leave nr_resets empty, use the correct value, or at least add a comment
that this is not the number of resets in the rcdev as documented in the
structure documentation.

> +	priv->rcdev.ops = &berlin_reset_ops;
> +	priv->rcdev.of_node = np;
> +	priv->rcdev.of_reset_n_cells = 2;
> +	priv->rcdev.of_xlate = berlin_reset_xlate;
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
> +static const struct of_device_id berlin_reset_of_match[] __initconst = {
> +	{ .compatible = "marvell,berlin2-chip-ctrl" },
> +	{ .compatible = "marvell,berlin2cd-chip-ctrl" },
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

Other than the above, and with the understanding that this is going to
be turned into a platform driver at some point in the future,

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

