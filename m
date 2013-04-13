Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab3DMRWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 13:22:16 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:38640 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808Ab3DMRWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 13:22:14 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18/GjH/UNYSKytMynltwVdV
Date: Sat, 13 Apr 2013 10:22:10 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH V4 1/6] clk: OMAP: introduce device tree binding to
 kernel clock data
Message-ID: <20130413172210.GM10155@atomide.com>
References: <1365807278-554-1-git-send-email-nm@ti.com>
 <1365807278-554-2-git-send-email-nm@ti.com>
 <20130412233142.GE10155@atomide.com>
 <20130412233900.GA1599@kahuna>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412233900.GA1599@kahuna>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [130412 16:43]:
> Thanks for checking up. Fixed all of them below, will post part of
> series again, only if I need to address further comments in other
> patches..

Thanks it seems that the other ones are ready to go, just one
more comment below.

> --- /dev/null
> +++ b/drivers/clk/omap/clk.c
> @@ -0,0 +1,95 @@
> +/*
> + * Texas Instruments OMAP Clock driver
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
> + *	Nishanth Menon <nm@ti.com>
> + *	Tony Lindgren <tony@atomide.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clkdev.h>
> +#include <linux/clk-provider.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/string.h>
> +
> +static const struct of_device_id omap_clk_of_match[] = {
> +	{.compatible = "ti,omap-clock",},
> +	{},
> +};
> +
> +/**
> + * omap_clk_src_get() - Get OMAP clock from node name when needed
> + * @clkspec:	clkspec argument
> + * @data:	unused
> + *
> + * REVISIT: We assume the following:
> + * 1. omap clock names end with _ck
> + * 2. omap clock names are under 32 characters in length
> + */
> +static struct clk *omap_clk_src_get(struct of_phandle_args *clkspec, void *data)
> +{
> +	struct clk *clk;
> +	char clk_name[32];
> +	struct device_node *np = clkspec->np;
> +
> +	snprintf(clk_name, 32, "%s_ck", np->name);
> +	clk = clk_get(NULL, clk_name);
> +	if (IS_ERR(clk)) {
> +		pr_err("%s: could not get clock %s(%ld)\n", __func__,
> +		       clk_name, PTR_ERR(clk));
> +		goto out;
> +	}
> +	clk_put(clk);

It seems that clk_put() is actually wrong here. That's because
of_clk_get() should boild down to just the look up of the clock 
and then clk_get() on it, so no double clk_get() is done in this
case. Once the consumer driver is done, it will just call clk_put()
on it.

> +out:
> +	return clk;
> +}
> +
> +/**
> + * omap_clk_probe() - create link from DT definition to clock data
> + * @pdev:	device node
> + *
> + * NOTE: we look up the clock lazily when the consumer driver does
> + * of_clk_get() and initialize a NULL clock here.
> + */
> +static int omap_clk_probe(struct platform_device *pdev)
> +{
> +	int res;
> +	struct device_node *np = pdev->dev.of_node;
> +
> +	/* This allows the driver to of_clk_get() */
> +	res = of_clk_add_provider(np, omap_clk_src_get, NULL);
> +	if (res)
> +		dev_err(&pdev->dev, "could not add provider(%d)\n", res);
> +
> +	return res;
> +}
> +
> +static struct platform_driver omap_clk_driver = {
> +	.probe = omap_clk_probe,
> +	.driver = {
> +		   .name = "omap_clk",
> +		   .of_match_table = of_match_ptr(omap_clk_of_match),
> +		   },
> +};
> +
> +static int __init omap_clk_init(void)
> +{
> +	return platform_driver_register(&omap_clk_driver);
> +}
> +arch_initcall(omap_clk_init);
> +
> +MODULE_DESCRIPTION("OMAP Clock driver");
> +MODULE_AUTHOR("Texas Instruments Inc.");
> +MODULE_LICENSE("GPL v2");

Other than that looks OK to me.

Tony
