Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaDANNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:13:48 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35193 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaDANNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:13:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        grant.likely@linaro.org, mark.rutland@arm.com, galak@codeaurora.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com, s.hauer@pengutronix.de
Subject: Re: [PATCH RFC v4 2/2] clk: Add handling of clk parent and rate assigned from DT
Date: Tue, 01 Apr 2014 15:15:41 +0200
Message-ID: <1965445.mLnp8rmPxd@avalon>
User-Agent: KMail/4.11.5 (Linux/3.12.13-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com> <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

Thank you for the patch.

On Monday 31 March 2014 18:41:56 Sylwester Nawrocki wrote:
> This function adds a helper function to configure clock parents and rates
> as specified in clock-parents, clock-rates DT properties for a consumer
> device and a call to it before driver is bound to a device.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
> Changes since v3:
>  - added detailed description of the assigned-clocks subnode,
>  - clk-conf.c is now excluded when CONFIG_OF is not set,
>  - s/of_clk_device_setup/of_clk_device_init,
>  - added missing 'static inline' to the function stub definition.
> 
> Changes since v2:
>  - edited in clock-bindings.txt, added note about 'assigned-clocks'
>    subnode which may be used to specify "global" clocks configuration
>    at a clock provider node,
>  - moved of_clk_device_setup() function declaration from clk-provider.h
>    to clk-conf.h so required function stubs are available when
>    CONFIG_COMMON_CLK is not enabled,
> 
> Changes since v1:
>  - the helper function to parse and set assigned clock parents and
>    rates made public so it is available to clock providers to call
>    directly;
>  - dropped the platform bus notification and call of_clk_device_setup()
>    is is now called from the driver core, rather than from the
>    notification callback;
>  - s/of_clk_get_list_entry/of_clk_get_by_property.
> ---
>  .../devicetree/bindings/clock/clock-bindings.txt   |   42 ++++++++++
>  drivers/base/dd.c                                  |    7 ++
>  drivers/clk/Makefile                               |    3 +
>  drivers/clk/clk-conf.c                             |   87 +++++++++++++++++
>  drivers/clk/clk.c                                  |   10 ++-
>  include/linux/clk/clk-conf.h                       |   19 +++++
>  6 files changed, 167 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/clk/clk-conf.c
>  create mode 100644 include/linux/clk/clk-conf.h

[snip]

> diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
> new file mode 100644
> index 0000000..a2e992e
> --- /dev/null
> +++ b/drivers/clk/clk-conf.c
> @@ -0,0 +1,87 @@
> +/*
> + * Copyright (C) 2014 Samsung Electronics Co., Ltd.
> + * Sylwester Nawrocki <s.nawrocki@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/device.h>
> +#include <linux/of.h>
> +#include <linux/printk.h>
> +
> +/**
> + * of_clk_device_init() - parse and set clk configuration assigned to a
> device
> + * @node: device node to apply the configuration for
> + *
> + * This function parses 'clock-parents' and 'clock-rates' properties and
> sets
> + * any specified clock parents and rates.
> + */
> +int of_clk_device_init(struct device_node *node)
> +{
> +	struct property	*prop;
> +	const __be32 *cur;
> +	int rc, index, num_parents;
> +	struct clk *clk, *pclk;
> +	u32 rate;
> +
> +	num_parents = of_count_phandle_with_args(node, "clock-parents",
> +						 "#clock-cells");
> +	if (num_parents == -EINVAL)
> +		pr_err("clk: Invalid value of clock-parents property at %s\n",
> +		       node->full_name);

This is an implementation detail, but wouldn't it simplify the code if you 
merged the two loops by iterating of the 	clocks property instead of over the 
clock-parents and clock-rates properties separately ?

> +	for (index = 0; index < num_parents; index++) {
> +		pclk = of_clk_get_by_property(node, "clock-parents", index);
> +		if (IS_ERR(pclk)) {
> +			/* skip empty (null) phandles */
> +			if (PTR_ERR(pclk) == -ENOENT)
> +				continue;
> +
> +			pr_warn("clk: couldn't get parent clock %d for %s\n",
> +				index, node->full_name);
> +			return PTR_ERR(pclk);
> +		}
> +
> +		clk = of_clk_get(node, index);
> +		if (IS_ERR(clk)) {
> +			pr_warn("clk: couldn't get clock %d for %s\n",
> +				index, node->full_name);
> +			return PTR_ERR(clk);
> +		}
> +
> +		rc = clk_set_parent(clk, pclk);
> +		if (rc < 0)
> +			pr_err("clk: failed to reparent %s to %s: %d\n",
> +			       __clk_get_name(clk), __clk_get_name(pclk), rc);
> +		else
> +			pr_debug("clk: set %s as parent of %s\n",
> +				 __clk_get_name(pclk), __clk_get_name(clk));
> +	}
> +
> +	index = 0;
> +	of_property_for_each_u32(node, "clock-rates", prop, cur, rate) {
> +		if (rate) {
> +			clk = of_clk_get(node, index);
> +			if (IS_ERR(clk)) {
> +				pr_warn("clk: couldn't get clock %d for %s\n",
> +					index, node->full_name);
> +				return PTR_ERR(clk);
> +			}
> +
> +			rc = clk_set_rate(clk, rate);
> +			if (rc < 0)
> +				pr_err("clk: couldn't set %s clock rate: %d\n",
> +				       __clk_get_name(clk), rc);
> +			else
> +				pr_debug("clk: set rate of clock %s to %lu\n",
> +					 __clk_get_name(clk), clk_get_rate(clk));
> +		}
> +		index++;
> +	}
> +
> +	return 0;
> +}
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index dff0373..ea6d8bd 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c

[snip]

> @@ -2620,7 +2621,15 @@ void __init of_clk_init(const struct of_device_id
> *matches) list_for_each_entry_safe(clk_provider, next,
>  					&clk_provider_list, node) {
>  			if (force || parent_ready(clk_provider->np)) {
> +
>  				clk_provider->clk_init_cb(clk_provider->np);
> +
> +				/* Set any assigned clock parents and rates */
> +				np = of_get_child_by_name(clk_provider->np,
> +							  "assigned-clocks");
> +				if (np)
> +					of_clk_device_init(np);

Aren't you missing an of_node_put() here ?

> +
>  				list_del(&clk_provider->node);
>  				kfree(clk_provider);
>  				is_init_done = true;

-- 
Regards,

Laurent Pinchart

