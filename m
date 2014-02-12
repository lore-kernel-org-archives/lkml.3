Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaBLJyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:54:33 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:62266 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBLJyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:54:31 -0500
Date: Wed, 12 Feb 2014 09:54:24 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <monstr@monstr.eu>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] mfd: syscon: Support early initialization
Message-ID: <20140212095424.GV15081@lee--X1>
References: <cover.1392045742.git.michal.simek@xilinx.com>
 <1785585d090175da81b561b17eeef95d991ff0de.1392045742.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1785585d090175da81b561b17eeef95d991ff0de.1392045742.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014, Michal Simek wrote:

> Some platforms need to get system controller
> ready as soon as possible.
> The patch provides early_syscon_initialization
> which create early mapping for all syscon compatible
> devices in early_syscon_probe.
> Regmap is get via syscon_early_regmap_lookup_by_phandle()
> 
> Regular device probes attach device to regmap
> via regmap_attach_dev().
> 
> For early syscon initialization is necessary to extend
> struct syscon and provide remove function
> which unmap all early init structures.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
>  drivers/mfd/syscon.c       | 126 +++++++++++++++++++++++++++++++++++++++------
>  include/linux/mfd/syscon.h |  11 ++++
>  2 files changed, 120 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c

<snip>

>  struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
>  					const char *property)
>  {
> @@ -128,40 +149,110 @@ static int syscon_probe(struct platform_device *pdev)
>  	struct device *dev = &pdev->dev;
>  	struct syscon *syscon;
>  	struct resource *res;
> -	void __iomem *base;
> 
> -	syscon = devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
> +	/* Early syscon init */
> +	if (pdev->dev.of_node && pdev->dev.of_node->data) {
> +		syscon = pdev->dev.of_node->data;
> +		res = &syscon->res;
> +		regmap_attach_dev(dev, syscon->regmap, &syscon_regmap_config);

Instead of duplicating all of the init code with early and late
versions of each, is there any reason why we can't always do the early
stuff early and then connect it to the dev infrastructure when it
becomes available?

> +	} else {
> +
> +		syscon = devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
> +		if (!syscon)
> +			return -ENOMEM;
> +
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +		if (!res)
> +			return -ENOENT;
> +
> +		syscon->base = devm_ioremap(dev, res->start,
> +					    resource_size(res));
> +		if (!syscon->base)
> +			return -ENOMEM;
> +
> +		syscon_regmap_config.max_register = res->end - res->start - 3;
> +		syscon->regmap = devm_regmap_init_mmio(dev, syscon->base,
> +						&syscon_regmap_config);
> +		if (IS_ERR(syscon->regmap)) {
> +			dev_err(dev, "regmap init failed\n");
> +			return PTR_ERR(syscon->regmap);
> +		}
> +	}
> +	platform_set_drvdata(pdev, syscon);
> +
> +	dev_info(dev, "regmap %pR registered\n", res);
> +
> +	return 0;
> +}
> +
> +static const struct platform_device_id syscon_ids[] = {
> +	{ "syscon", },
> +	{ }
> +};
> +
> +static int syscon_remove(struct platform_device *pdev)
> +{
> +	struct syscon *syscon = platform_get_drvdata(pdev);
> +
> +	if (pdev->dev.of_node && pdev->dev.of_node->data) {
> +		iounmap(syscon->base);
> +		kfree(syscon);
> +	}
> +
> +	return 0;
> +}
> +
> +static int early_syscon_probe(struct device_node *np)
> +{
> +	struct syscon *syscon;
> +
> +	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
>  	if (!syscon)
>  		return -ENOMEM;
> 
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res)
> -		return -ENOENT;
> +	if (of_address_to_resource(np, 0, &syscon->res))
> +		return -EINVAL;
> 
> -	base = devm_ioremap(dev, res->start, resource_size(res));
> -	if (!base)
> -		return -ENOMEM;
> +	syscon->base = ioremap(syscon->res.start, resource_size(&syscon->res));
> +	if (!syscon->base) {
> +		pr_err("%s: Unable to map I/O memory\n", __func__);
> +		return PTR_ERR(syscon->base);
> +	}
> 
> -	syscon_regmap_config.max_register = res->end - res->start - 3;
> -	syscon->regmap = devm_regmap_init_mmio(dev, base,
> -					&syscon_regmap_config);
> +	syscon_regmap_config.max_register = syscon->res.end -
> +					    syscon->res.start - 3;
> +	syscon->regmap = regmap_init_mmio(NULL, syscon->base,
> +					  &syscon_regmap_config);
>  	if (IS_ERR(syscon->regmap)) {
> -		dev_err(dev, "regmap init failed\n");
> +		pr_err("regmap init failed\n");
>  		return PTR_ERR(syscon->regmap);
>  	}
> 
> -	platform_set_drvdata(pdev, syscon);
> +	np->data = syscon;
> 
> -	dev_info(dev, "regmap %pR registered\n", res);
> +	of_node_put(np);
> +
> +	pr_info("%s: regmap %pR registered\n", np->full_name, &syscon->res);
> 
>  	return 0;
>  }
> 
> -static const struct platform_device_id syscon_ids[] = {
> -	{ "syscon", },
> -	{ }
> +static struct of_device_id of_syscon_ids[] = {
> +	{ .compatible = "syscon" },
> +	{},
>  };
> 
> +void __init early_syscon_init(void)
> +{
> +	struct device_node *np;
> +
> +	for_each_matching_node_and_match(np, of_syscon_ids, NULL) {
> +		if (!early_syscon_probe(np))
> +			BUG();
> +	}
> +}
> +
>  static struct platform_driver syscon_driver = {
>  	.driver = {
>  		.name = "syscon",
> @@ -169,6 +260,7 @@ static struct platform_driver syscon_driver = {
>  		.of_match_table = of_syscon_match,
>  	},
>  	.probe		= syscon_probe,
> +	.remove		= syscon_remove,
>  	.id_table	= syscon_ids,
>  };
> 
> diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
> index 8789fa3..465c092 100644
> --- a/include/linux/mfd/syscon.h
> +++ b/include/linux/mfd/syscon.h
> @@ -24,6 +24,10 @@ extern struct regmap *syscon_regmap_lookup_by_pdevname(const char *s);
>  extern struct regmap *syscon_regmap_lookup_by_phandle(
>  					struct device_node *np,
>  					const char *property);
> +extern struct regmap *syscon_early_regmap_lookup_by_phandle(
> +					struct device_node *np,
> +					const char *property);
> +extern void early_syscon_init(void);
>  #else
>  static inline struct regmap *syscon_node_to_regmap(struct device_node *np)
>  {
> @@ -46,6 +50,13 @@ static inline struct regmap *syscon_regmap_lookup_by_phandle(
>  {
>  	return ERR_PTR(-ENOSYS);
>  }
> +
> +static struct regmap *syscon_early_regmap_lookup_by_phandle(
> +					struct device_node *np,
> +					const char *property)
> +{
> +	return ERR_PTR(-ENOSYS);
> +}
>  #endif
> 
>  #endif /* __LINUX_MFD_SYSCON_H__ */



-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
