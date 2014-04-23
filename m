Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbaDWKFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:05:40 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:36383 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbaDWKFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:05:37 -0400
Date: Wed, 23 Apr 2014 11:05:30 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu, pankaj.dubey@samsung.com,
        Samuel Ortiz <sameo@linux.intel.com>, arnd@arndb.de,
        broonie@kernel.org
Subject: Re: [PATCH v3] mfd: syscon: Support early initialization
Message-ID: <20140423100530.GG21613@lee--X1>
References: <3eb785d83c406f4a57508dc03610b05492e12bfd.1396969250.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3eb785d83c406f4a57508dc03610b05492e12bfd.1396969250.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think leaving Arnd and Mark off of CC was a mistake.

Correcting now.

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
> Changes in v3:
> - Keep backward compatibility for platform drivers and test it
> - Use only one probe method which is early_syscon_probe
>   suggested by Lee Jones. Do not force anybody to call early_syscon_init
> - Add kernel-doc description
> 
> Changes in v2:
> - Fix bad logic in early_syscon_probe
> - Fix compilation failure for x86_64 reported by zero day testing system
> - Regmap change available here
>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/nodev
> 
>  drivers/mfd/syscon.c       | 159 ++++++++++++++++++++++++++++++++++++++++-----
>  include/linux/mfd/syscon.h |  11 ++++
>  2 files changed, 153 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index 71841f9..8e2ff88 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -20,12 +20,15 @@
>  #include <linux/of_platform.h>
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
> +#include <linux/slab.h>
>  #include <linux/mfd/syscon.h>
> 
>  static struct platform_driver syscon_driver;
> 
>  struct syscon {
> +	void __iomem *base;
>  	struct regmap *regmap;
> +	struct resource res;
>  };
> 
>  static int syscon_match_node(struct device *dev, void *data)
> @@ -95,6 +98,30 @@ struct regmap *syscon_regmap_lookup_by_pdevname(const char *s)
>  }
>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);
> 
> +/**
> + * syscon_early_regmap_lookup_by_phandle - Early phandle lookup function
> + * @np:		device_node pointer
> + * @property:	property name which handle system controller phandle
> + * Return:	regmap pointer, an error pointer otherwise
> + */
> +struct regmap *syscon_early_regmap_lookup_by_phandle(struct device_node *np,
> +						     const char *property)
> +{
> +	struct device_node *syscon_np;
> +	struct syscon *syscon;
> +
> +	syscon_np = of_parse_phandle(np, property, 0);
> +	if (!syscon_np)
> +		return ERR_PTR(-ENODEV);
> +
> +	syscon = syscon_np->data;
> +
> +	of_node_put(syscon_np);
> +
> +	return syscon->regmap;
> +}
> +EXPORT_SYMBOL_GPL(syscon_early_regmap_lookup_by_phandle);
> +
>  struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
>  					const char *property)
>  {
> @@ -123,36 +150,118 @@ static struct regmap_config syscon_regmap_config = {
>  	.reg_stride = 4,
>  };
> 
> -static int syscon_probe(struct platform_device *pdev)
> +/**
> + * early_syscon_probe - Early system controller probe method
> + * @np:		device_node pointer
> + * @syscon_p:	syscon pointer
> + * @res:	device IO resource
> + * Return:	0 if successful, a negative error code otherwise
> + */
> +static int early_syscon_probe(struct device_node *np, struct syscon **syscon_p,
> +			      struct resource *res)
>  {
> -	struct device *dev = &pdev->dev;
>  	struct syscon *syscon;
> -	struct resource *res;
> -	void __iomem *base;
> +	int ret;
> +
> +	if (np && np->data) {
> +		pr_debug("Early syscon was called\n");
> +		*syscon_p = (struct syscon *)&np->data;
> +		return 0;
> +	}
> 
> -	syscon = devm_kzalloc(dev, sizeof(*syscon), GFP_KERNEL);
> +	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
>  	if (!syscon)
>  		return -ENOMEM;
> 
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res)
> -		return -ENOENT;
> +	*syscon_p = (struct syscon *)&syscon;
> 
> -	base = devm_ioremap(dev, res->start, resource_size(res));
> -	if (!base)
> -		return -ENOMEM;
> +	if (!res && np) {
> +		if (of_address_to_resource(np, 0, &syscon->res)) {
> +			ret = -EINVAL;
> +			goto alloc;
> +		}
> +
> +		np->data = syscon;
> +		of_node_put(np);
> +	} else {
> +		syscon->res = *res;
> +	}
> 
> -	syscon_regmap_config.max_register = res->end - res->start - 3;
> -	syscon->regmap = devm_regmap_init_mmio(dev, base,
> -					&syscon_regmap_config);
> +	syscon->base = ioremap(syscon->res.start, resource_size(&syscon->res));
> +	if (!syscon->base) {
> +		pr_err("%s: Unable to map I/O memory\n", __func__);
> +		ret = PTR_ERR(syscon->base);
> +		goto alloc;
> +	}
> +
> +	syscon_regmap_config.max_register = syscon->res.end -
> +					    syscon->res.start - 3;
> +	syscon->regmap = regmap_init_mmio(NULL, syscon->base,
> +					  &syscon_regmap_config);
>  	if (IS_ERR(syscon->regmap)) {
> -		dev_err(dev, "regmap init failed\n");
> -		return PTR_ERR(syscon->regmap);
> +		pr_err("regmap init failed\n");
> +		ret = PTR_ERR(syscon->regmap);
> +		goto iomap;
>  	}
> +	if (np)
> +		pr_info("syscon: %s regmap %pR registered\n", np->name,
> +			&syscon->res);
> +
> +	return 0;
> +
> +iomap:
> +	iounmap(syscon->base);
> +alloc:
> +	kfree(syscon);
> +
> +	return ret;
> +}
> +
> +/**
> + * early_syscon_init - Early system controller initialization
> + */
> +void __init early_syscon_init(void)
> +{
> +	struct device_node *np;
> +	struct syscon *syscon = NULL;
> +
> +	for_each_matching_node_and_match(np, of_syscon_match, NULL) {
> +		if (early_syscon_probe(np, &syscon, NULL))
> +			BUG();
> +	}
> +}
> +
> +/**
> + * syscon_probe - System controller probe method
> + * @pdev:	Platform device
> + * Return:	0 if successful, a negative error code otherwise
> + */
> +static int syscon_probe(struct platform_device *pdev)
> +{
> +	struct syscon *syscon, *syscon_p;
> +	struct resource *res = NULL;
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = pdev->dev.of_node;
> +	int ret;
> +
> +	if (!np) {
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +		if (!res)
> +			return -ENOENT;
> +	}
> +	ret = early_syscon_probe(np, &syscon_p, res);
> +	if (ret) {
> +		dev_err(dev, "Syscon probe failed\n");
> +		return ret;
> +	}
> +
> +	syscon = *(struct syscon **)syscon_p;
> +
> +	regmap_attach_dev(dev, syscon->regmap, &syscon_regmap_config);
> 
>  	platform_set_drvdata(pdev, syscon);
> 
> -	dev_info(dev, "regmap %pR registered\n", res);
> +	dev_info(dev, "regmap attach device to %pR\n", &syscon->res);
> 
>  	return 0;
>  }
> @@ -162,6 +271,21 @@ static const struct platform_device_id syscon_ids[] = {
>  	{ }
>  };
> 
> +/**
> + * syscon_remove - System controller cleanup function
> + * @pdev:	Platform device
> + * Return:	0 always
> + */
> +static int syscon_remove(struct platform_device *pdev)
> +{
> +	struct syscon *syscon = platform_get_drvdata(pdev);
> +
> +	iounmap(syscon->base);
> +	kfree(syscon);
> +
> +	return 0;
> +}
> +
>  static struct platform_driver syscon_driver = {
>  	.driver = {
>  		.name = "syscon",
> @@ -169,6 +293,7 @@ static struct platform_driver syscon_driver = {
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
