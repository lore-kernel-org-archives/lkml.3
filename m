Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaBSQyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:54:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49011 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaBSQyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:54:24 -0500
Message-ID: <1392828827.3445.54.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH RFC 04/10] base: power: Add generic OF-based power
 domain look-up
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 19 Feb 2014 17:53:47 +0100
In-Reply-To: <1389469372-17199-5-git-send-email-tomasz.figa@gmail.com>
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
	 <1389469372-17199-5-git-send-email-tomasz.figa@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

Am Samstag, den 11.01.2014, 20:42 +0100 schrieb Tomasz Figa:
> This patch introduces generic code to perform power domain look-up using
> device tree and automatically bind devices to their power domains.
> Generic device tree binding is introduced to specify power domains of
> devices in their device tree nodes.
> 
> Backwards compatibility with legacy Samsung-specific power domain
> bindings is provided, but for now the new code is not compiled when
> CONFIG_ARCH_EXYNOS is selected to avoid collision with legacy code. This
> will change as soon as Exynos power domain code gets converted to use
> the generic framework in further patch.
> 
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> ---
>  .../devicetree/bindings/power/power_domain.txt     |  51 ++++
>  drivers/base/power/domain.c                        | 339 +++++++++++++++++++++
>  include/linux/pm_domain.h                          |  34 +++
>  kernel/power/Kconfig                               |   4 +
>  4 files changed, 428 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power/power_domain.txt
> 
> diff --git a/Documentation/devicetree/bindings/power/power_domain.txt b/Documentation/devicetree/bindings/power/power_domain.txt
> new file mode 100644
> index 0000000..93be5d9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power/power_domain.txt
> @@ -0,0 +1,51 @@
> +* Generic power domains
> +
> +System on chip designs are often divided into multiple power domains that
> +can be used for power gating of selected IP blocks for power saving by
> +reduced leakage current.
> +
> +This device tree binding can be used to bind power domain consumer devices
> +with their power domains provided by power domain providers. A power domain
> +provider can be represented by any node in the device tree and can provide
> +one or more power domains. A consumer node can refer to the provider by
> +a phandle and a set of phandle arguments (so called power domain specifier)
> +of length specified by #power-domain-cells property in the power domain
> +provider node.
> +
> +==Power domain providers==
> +
> +Required properties:
> + - #power-domain-cells : Number of cells in a power domain specifier;
> +   Typically 0 for nodes representing a single power domain and 1 for nodes
> +   providing multiple power domains (e.g. power controllers), but can be
> +   any value as specified by device tree binding documentation of particular
> +   provider.
> +
> +Example:
> +
> +	power: power-controller@12340000 {
> +		compatible = "foo,power-controller";
> +		reg = <0x12340000 0x1000>;
> +		#power-domain-cells = <1>;
> +	};
> +
> +The node above defines a power controller that is a power domain provider
> +and expects one cell as its phandle argument.
> +
> +==Power domain consumers==
> +
> +Required properties:
> + - power-domain : A phandle and power domain specifier as defined by bindings
> +                  of power controller specified by phandle.
> +
> +Example:
> +
> +	leaky-device@12350000 {
> +		compatible = "foo,i-leak-current";
> +		reg = <0x12350000 0x1000>;
> +		power-domain = <&power 0>;
> +	};
> +
> +The node above defines a typical power domain consumer device, which is located
> +inside power domain with index 0 of power controller represented by node with
> +label "power".
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index bfb8955..6d47498 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -3,12 +3,16 @@
>   *
>   * Copyright (C) 2011 Rafael J. Wysocki <rjw@sisk.pl>, Renesas Electronics Corp.
>   *
> + * Support for Device Tree based power domain providers:
> + * Copyright (C) 2014 Tomasz Figa <tomasz.figa@gmail.com>
> + *
>   * This file is released under the GPLv2.
>   */
>  
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/io.h>
> +#include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/pm_domain.h>
>  #include <linux/pm_qos.h>
> @@ -2177,3 +2181,338 @@ void pm_genpd_init(struct generic_pm_domain *genpd,
>  	list_add(&genpd->gpd_list_node, &gpd_list);
>  	mutex_unlock(&gpd_list_lock);
>  }
> +
> +#ifdef CONFIG_PM_GENERIC_DOMAINS_OF
> +/*
> + * DEVICE TREE BASED POWER DOMAIN PROVIDERS
> + *
> + * The code below implements generic device tree based power domain providers
> + * that bind device tree nodes with generic power domains registered in the
> + * system.
> + *
> + * Any driver that registers generic power domains and need to support binding
> + * of devices to these domains is supposed to register a power domain provider,
> + * which maps a power domain specifier retrieved from device tree to a power
> + * domain.
> + *
> + * Two simple mapping functions have been provided for convenience:
> + *  - of_genpd_xlate_simple() for 1:1 device tree node to domain mapping,
> + *  - of_genpd_xlate_onecell() for mapping of multiple domains per node
> + *    by index.
> + */
> +
> +/**
> + * struct of_genpd_provider - Power domain provider registration structure
> + * @link: Entry in global list of domain providers
> + * @node: Pointer to device tree node of domain provider
> + * @xlate: Provider-specific xlate callback mapping a set of specifier cells
> + *         into a power domain.
> + * @data: context pointer to be passed into @xlate callback
> + */
> +struct of_genpd_provider {
> +	struct list_head link;
> +
> +	struct device_node *node;
> +	genpd_xlate_t xlate;
> +	void *data;
> +};
> +
> +/* List of registered power domain providers. */
> +static LIST_HEAD(of_genpd_providers);
> +/* Mutex to protect the list above. */
> +static DEFINE_MUTEX(of_genpd_mutex);
> +
> +/**
> + * of_genpd_lock() - Lock access to of_genpd_providers list
> + */
> +static void of_genpd_lock(void)
> +{
> +	mutex_lock(&of_genpd_mutex);
> +}
> +
> +/**
> + * of_genpd_unlock() - Unlock access to of_genpd_providers list
> + */
> +static void of_genpd_unlock(void)
> +{
> +	mutex_unlock(&of_genpd_mutex);
> +}
> +
> +/**
> + * of_genpd_xlate_simple() - Xlate function for direct node-domain mapping
> + * @genpdspec: OF phandle args to map into a power domain
> + * @data: xlate function private data - pointer to struct generic_pm_domain
> + *
> + * This is a generic xlate function that can be used to model power domains
> + * that have their own device tree nodes. The private data of xlate function
> + * needs to be a valid pointer to struct generic_pm_domain.
> + */
> +struct generic_pm_domain *of_genpd_xlate_simple(
> +					struct of_phandle_args *genpdspec,
> +					void *data)
> +{
> +	if (genpdspec->args_count != 0)
> +		return ERR_PTR(-EINVAL);
> +	return data;
> +}
> +EXPORT_SYMBOL_GPL(of_genpd_xlate_simple);
> +
> +/**
> + * of_genpd_xlate_onecell() - Xlate function for providers using single index.
> + * @genpdspec: OF phandle args to map into a power domain
> + * @data: xlate function private data - pointer to struct genpd_onecell_data
> + *
> + * This is a generic xlate function that can be used to model simple power
> + * domain controllers that have one device tree node and provide multiple
> + * power domains. A single cell is used as an index to an array of power
> + * domains specified in genpd_onecell_data struct when registering the
> + * provider.
> + */
> +struct generic_pm_domain *of_genpd_xlate_onecell(
> +					struct of_phandle_args *genpdspec,
> +					void *data)
> +{
> +	struct genpd_onecell_data *genpd_data = data;
> +	unsigned int idx = genpdspec->args[0];
> +
> +	if (genpdspec->args_count != 1)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (idx >= genpd_data->domain_num) {
> +		pr_err("%s: invalid domain index %d\n", __func__, idx);
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	return genpd_data->domains[idx];
> +}
> +EXPORT_SYMBOL_GPL(of_genpd_xlate_onecell);
> +
> +/**
> + * of_genpd_add_provider() - Register a domain provider for a node
> + * @np: Device node pointer associated with domain provider
> + * @genpd_src_get: callback for decoding domain
> + * @data: context pointer for @genpd_src_get callback.
> + */
> +int of_genpd_add_provider(struct device_node *np, genpd_xlate_t xlate,
> +			  void *data)
> +{
> +	struct of_genpd_provider *cp;
> +
> +	cp = kzalloc(sizeof(struct of_genpd_provider), GFP_KERNEL);
> +	if (!cp)
> +		return -ENOMEM;
> +
> +	cp->node = of_node_get(np);
> +	cp->data = data;
> +	cp->xlate = xlate;
> +
> +	of_genpd_lock();
> +	list_add(&cp->link, &of_genpd_providers);
> +	of_genpd_unlock();
> +	pr_debug("Added domain provider from %s\n", np->full_name);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_genpd_add_provider);
> +
> +/**
> + * of_genpd_del_provider() - Remove a previously registered domain provider
> + * @np: Device node pointer associated with domain provider
> + */
> +void of_genpd_del_provider(struct device_node *np)
> +{
> +	struct of_genpd_provider *cp;
> +
> +	of_genpd_lock();
> +	list_for_each_entry(cp, &of_genpd_providers, link) {
> +		if (cp->node == np) {
> +			list_del(&cp->link);
> +			of_node_put(cp->node);
> +			kfree(cp);
> +			break;
> +		}
> +	}
> +	of_genpd_unlock();
> +}
> +EXPORT_SYMBOL_GPL(of_genpd_del_provider);
> +
> +/* See of_genpd_get_from_provider(). */
> +static struct generic_pm_domain *__of_genpd_get_from_provider(
> +					struct of_phandle_args *genpdspec)
> +{
> +	struct of_genpd_provider *provider;
> +	struct generic_pm_domain *genpd = ERR_PTR(-ENOENT);
> +
> +	/* Check if we have such a provider in our array */
> +	list_for_each_entry(provider, &of_genpd_providers, link) {
> +		if (provider->node == genpdspec->np)
> +			genpd = provider->xlate(genpdspec, provider->data);
> +		if (!IS_ERR(genpd))
> +			break;
> +	}
> +
> +	return genpd;
> +}
> +
> +/**
> + * of_genpd_get_from_provider() - Look-up power domain
> + * @genpdspec: OF phandle args to use for look-up
> + *
> + * Looks for domain provider under node specified by @genpdspec and if found
> + * uses xlate function of the provider to map phandle args to a power domain.
> + *
> + * Returns a valid pointer to struct generic_pm_domain on success or ERR_PTR()
> + * on failure.
> + */
> +static struct generic_pm_domain *of_genpd_get_from_provider(
> +					struct of_phandle_args *genpdspec)
> +{
> +	struct generic_pm_domain *genpd;
> +
> +	of_genpd_lock();
> +	genpd = __of_genpd_get_from_provider(genpdspec);
> +	of_genpd_unlock();
> +
> +	return genpd;
> +}
> +
> +/*
> + * DEVICE<->DOMAIN BINDING USING DEVICE TREE LOOK-UP
> + *
> + * The code below registers a notifier for platform bus devices'
> + * BUS_NOTIFY_BIND_DRIVER events and tries to attach devices to their power
> + * domains by looking them up using Device Tree.
> + *
> + * Similarly in BUS_NOTIFY_UNBOUND_DRIVER the device is detached from its
> + * domain, since it no longer supports runtime PM without any driver bound
> + * to it.
> + *
> + * Both generic and legacy Samsung-specific DT bindings are supported to
> + * keep backwards compatibility with existing DTBs.
> + */
> +
> +/**
> + * of_genpd_add_to_domain - Bind device to its power domain using Device Tree.
> + * @dev: Device to bind to its power domain.
> + *
> + * Tries to parse power domain specifier from device's OF node and if succeeds
> + * attaches the device to retrieved power domain.
> + *
> + * Returns 0 on success or negative error code otherwise.
> + */
> +static int of_genpd_add_to_domain(struct device *dev)
> +{
> +	struct of_phandle_args pd_args;
> +	struct generic_pm_domain *pd;
> +	int ret;
> +
> +	ret = of_parse_phandle_with_args(dev->of_node, "power-domain",
> +					"#power-domain-cells", 0, &pd_args);
> +	if (ret < 0) {
> +		if (ret != ENOENT)
> +			return ret;
> +
> +		/*
> +		 * Try legacy Samsung-specific bindings
> +		 * (for backwards compatibility of DT ABI)
> +		 */
> +		pd_args.args_count = 0;
> +		pd_args.np = of_parse_phandle(dev->of_node,
> +						"samsung,power-domain", 0);
> +		if (!pd_args.np)
> +			return 0;
> +	}
> +
> +	pd = of_genpd_get_from_provider(&pd_args);
> +	if (IS_ERR(pd))
> +		return PTR_ERR(pd);
> +
> +	dev_dbg(dev, "adding to power domain %s\n", pd->name);
> +
> +	while (1) {
> +		ret = pm_genpd_add_device(pd, dev);

Since pm_genpd_add_device is used here, no gpd_timing_data can be
provided. Do you have a plan to solve this? Should the timing data be
provided from the device tree?

> +		if (ret != -EAGAIN)
> +			break;
> +		cond_resched();
> +	}
> +
> +	if (!ret)
> +		pm_genpd_dev_need_restore(dev, true);
> +
> +	return ret;
> +}
[...]

regards
Philipp

