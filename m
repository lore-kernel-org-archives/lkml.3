Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab3BGHaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 02:30:23 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:35541
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab3BGHaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 02:30:22 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zz98dI1432I1447Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz17326ah8275dh6d523h5e7bkz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
Date: Thu, 7 Feb 2013 15:29:32 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Alexander Shiyan <shc_work@mail.ru>
CC: <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dong Aisheng <dong.aisheng@linaro.org>
Subject: Re: [PATCH] mfd: syscon: Added support for using platform driver
 resources
Message-ID: <20130207072931.GT22003@b29396-Latitude-E6410>
References: <1359990040-5339-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1359990040-5339-1-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

Thanks for the patch adding non-dt support. :-)

On Mon, Feb 04, 2013 at 07:00:40PM +0400, Alexander Shiyan wrote:
> This patch adds support usage platform driver resources, i.e.
> possibility works without oftree support. Additionally patch
> removes CONFIG_OF dependency and adds helper for accessing
> regmap by searching device by its name.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/mfd/Kconfig        |  1 -
>  drivers/mfd/syscon.c       | 62 +++++++++++++++++++++++++++++++++++-----------
>  include/linux/mfd/syscon.h |  1 +
>  3 files changed, 48 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 47ad4e2..389f5e2 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -1065,7 +1065,6 @@ config MFD_STA2X11
>  
>  config MFD_SYSCON
>  	bool "System Controller Register R/W Based on Regmap"
> -	depends on OF
>  	select REGMAP_MMIO
>  	help
>  	  Select this option to enable accessing system control registers
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index 3f10591..27d0a08 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -29,7 +29,27 @@ struct syscon {
>  	struct regmap *regmap;
>  };
>  
> -static int syscon_match(struct device *dev, void *data)
> +static int syscon_match_name(struct device *dev, void *data)
> +{
> +	return !strcmp(dev_name(dev), (const char *)data);
> +}
> +
> +struct regmap *syscon_regmap_lookup_by_name(const char *name)
> +{
> +	struct syscon *syscon;
> +	struct device *dev;
> +
> +	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)name,
> +				 syscon_match_name);
> +	if (!dev)
> +		return ERR_PTR(-EPROBE_DEFER);
> +
> +	syscon = dev_get_drvdata(dev);
> +
> +	return syscon->regmap;
> +}
> +

How about syscon_dev_to_regmap(struct device *dev) as the exist dt version
syscon_node_to_regmap since it's not affected by the name change of devices?

> +static int syscon_match_of(struct device *dev, void *data)
>  {
>  	struct syscon *syscon = dev_get_drvdata(dev);
>  	struct device_node *dn = data;
> @@ -43,7 +63,7 @@ struct regmap *syscon_node_to_regmap(struct device_node *np)
>  	struct device *dev;
>  
>  	dev = driver_find_device(&syscon_driver.driver, NULL, np,
> -				 syscon_match);
> +				 syscon_match_of);
>  	if (!dev)
>  		return ERR_PTR(-EPROBE_DEFER);
>  
> @@ -102,26 +122,38 @@ static int syscon_probe(struct platform_device *pdev)
>  	struct device *dev = &pdev->dev;
>  	struct device_node *np = dev->of_node;
>  	struct syscon *syscon;
> -	struct resource res;
> +	struct resource *res, res_of;
>  	int ret;
>  
> -	if (!np)
> -		return -ENOENT;
> -
>  	syscon = devm_kzalloc(dev, sizeof(struct syscon),
>  			    GFP_KERNEL);
>  	if (!syscon)
>  		return -ENOMEM;
>  
> -	syscon->base = of_iomap(np, 0);
> -	if (!syscon->base)
> -		return -EADDRNOTAVAIL;
> -
> -	ret = of_address_to_resource(np, 0, &res);
> -	if (ret)
> -		return ret;
> +	if (IS_ENABLED(CONFIG_OF) && np) {
> +		syscon->base = of_iomap(np, 0);
> +		if (!syscon->base)
> +			return -EADDRNOTAVAIL;
> +
> +		res = &res_of;
> +		ret = of_address_to_resource(np, 0, res);
> +		if (ret)
> +			return ret;
> +	} else {
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +		if (!res)
> +			return -ENXIO;
> +
> +		if (!request_mem_region(res->start, resource_size(res),
> +					dev_name(&pdev->dev)))
> +			return -EBUSY;
> +
> +		syscon->base = ioremap(res->start, resource_size(res));
> +		if (!syscon->base)
> +			return -EADDRNOTAVAIL;

devm_request_and_ioremap?

Regards
Dong Aisheng

> +	}
>  
> -	syscon_regmap_config.max_register = res.end - res.start - 3;
> +	syscon_regmap_config.max_register = res->end - res->start - 3;
>  	syscon->regmap = devm_regmap_init_mmio(dev, syscon->base,
>  					&syscon_regmap_config);
>  	if (IS_ERR(syscon->regmap)) {
> @@ -133,7 +165,7 @@ static int syscon_probe(struct platform_device *pdev)
>  	platform_set_drvdata(pdev, syscon);
>  
>  	dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
> -		res.start, res.end);
> +		res->start, res->end);
>  
>  	return 0;
>  }
> diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
> index 6aeb6b8..e14f7fd 100644
> --- a/include/linux/mfd/syscon.h
> +++ b/include/linux/mfd/syscon.h
> @@ -15,6 +15,7 @@
>  #ifndef __LINUX_MFD_SYSCON_H__
>  #define __LINUX_MFD_SYSCON_H__
>  
> +extern struct regmap *syscon_regmap_lookup_by_name(const char *name);
>  extern struct regmap *syscon_node_to_regmap(struct device_node *np);
>  extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
>  extern struct regmap *syscon_regmap_lookup_by_phandle(
> -- 
> 1.7.12.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

