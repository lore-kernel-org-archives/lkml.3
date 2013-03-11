Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab3CKJzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:55:53 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:15461
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797Ab3CKJzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:55:52 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Mar 2013 05:55:52 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzz17326ah8275dh6d523h5e7bkz2dh2a8h668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
Date: Mon, 11 Mar 2013 17:40:06 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Alexander Shiyan <shc_work@mail.ru>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v6 2/2] mfd: syscon: Add non-DT support
Message-ID: <20130311094005.GA6280@b29396-Latitude-E6410>
References: <1362063434-8318-1-git-send-email-shc_work@mail.ru>
 <1362063434-8318-2-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1362063434-8318-2-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 06:57:14PM +0400, Alexander Shiyan wrote:
> This patch allow using syscon driver from the platform data, i.e.
> possibility using driver on systems without oftree support.
> For search syscon device from the client drivers,
> "syscon_regmap_lookup_by_pdevname" function was added.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/mfd/Kconfig        |  1 -
>  drivers/mfd/syscon.c       | 77 +++++++++++++++++++++++++++-------------------
>  include/linux/mfd/syscon.h |  1 +
>  3 files changed, 47 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 671f5b1..8fdd87e 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -1070,7 +1070,6 @@ config MFD_STA2X11
>  
>  config MFD_SYSCON
>  	bool "System Controller Register R/W Based on Regmap"
> -	depends on OF
>  	select REGMAP_MMIO
>  	help
>  	  Select this option to enable accessing system control registers
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index 674af14..e5b6be1 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -29,7 +29,7 @@ struct syscon {
>  	struct regmap *regmap;
>  };
>  
> -static int syscon_match(struct device *dev, void *data)
> +static int syscon_match_node(struct device *dev, void *data)
>  {
>  	struct device_node *dn = data;
>  
> @@ -42,7 +42,7 @@ struct regmap *syscon_node_to_regmap(struct device_node *np)
>  	struct device *dev;
>  
>  	dev = driver_find_device(&syscon_driver.driver, NULL, np,
> -				 syscon_match);
> +				 syscon_match_node);
>  	if (!dev)
>  		return ERR_PTR(-EPROBE_DEFER);
>  
> @@ -68,6 +68,34 @@ struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
>  }
>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
>  
> +static int syscon_match_pdevname(struct device *dev, void *data)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	const struct platform_device_id *id = platform_get_device_id(pdev);
> +
> +	if (id)
> +		if (!strcmp(id->name, (const char *)data))
> +			return 1;
> +
> +	return !strcmp(dev_name(dev), (const char *)data);
> +}
> +
> +struct regmap *syscon_regmap_lookup_by_pdevname(const char *s)
> +{
> +	struct device *dev;
> +	struct syscon *syscon;
> +
> +	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> +				 syscon_match_pdevname);
> +	if (!dev)
> +		return ERR_PTR(-ENODEV);

Should it be ERR_PTR(-EPROBE_DEFER)?

> +
> +	syscon = dev_get_drvdata(dev);
> +
> +	return syscon->regmap;
> +}
> +EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);
> +
>  struct regmap *syscon_regmap_lookup_by_phandle(struct device_node *np,
>  					const char *property)
>  {
> @@ -99,30 +127,24 @@ static struct regmap_config syscon_regmap_config = {
>  static int syscon_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> -	struct device_node *np = dev->of_node;
>  	struct syscon *syscon;
> -	struct resource res;
> -	int ret;
> -
> -	if (!np)
> -		return -ENOENT;
> +	struct resource *res;
>  
> -	syscon = devm_kzalloc(dev, sizeof(struct syscon),
> -			    GFP_KERNEL);
> +	syscon = devm_kzalloc(dev, sizeof(struct syscon), GFP_KERNEL);
>  	if (!syscon)
>  		return -ENOMEM;
>  
> -	syscon->base = of_iomap(np, 0);
> -	if (!syscon->base)
> -		return -EADDRNOTAVAIL;
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENOENT;
>  
> -	ret = of_address_to_resource(np, 0, &res);
> -	if (ret)
> -		return ret;
> +	syscon->base = devm_ioremap(dev, res->start, resource_size(res));
> +	if (!syscon->base)
> +		return -ENOMEM;
>  
> -	syscon_regmap_config.max_register = res.end - res.start - 3;
> +	syscon_regmap_config.max_register = res->end - res->start - 3;
>  	syscon->regmap = devm_regmap_init_mmio(dev, syscon->base,
> -					&syscon_regmap_config);
> +					       &syscon_regmap_config);

Unneeded change to me

>  	if (IS_ERR(syscon->regmap)) {
>  		dev_err(dev, "regmap init failed\n");
>  		return PTR_ERR(syscon->regmap);
> @@ -130,22 +152,15 @@ static int syscon_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, syscon);
>  
> -	dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
> -		res.start, res.end);
> +	dev_info(dev, "regmap 0x%x-0x%x registered\n", res->start, res->end);

Doesn't with a 'syscon' prefix look better?

>  
>  	return 0;
>  }
>  
> -static int syscon_remove(struct platform_device *pdev)
> -{
> -	struct syscon *syscon;
> -
> -	syscon = platform_get_drvdata(pdev);
> -	iounmap(syscon->base);
> -	platform_set_drvdata(pdev, NULL);
> -
> -	return 0;
> -}
> +static const struct platform_device_id syscon_ids[] = {
> +	{ "syscon", },
> +	{ }
> +};
>  
>  static struct platform_driver syscon_driver = {
>  	.driver = {
> @@ -154,7 +169,7 @@ static struct platform_driver syscon_driver = {
>  		.of_match_table = of_syscon_match,
>  	},
>  	.probe		= syscon_probe,
> -	.remove		= syscon_remove,

So you reply on the managed resource to address the resource leak issue
raised by Dmitry on doing manually unbind here, right?
this looks ok to me.

So, besides above minor comments,
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

> +	.id_table	= syscon_ids,
>  };
>  
>  static int __init syscon_init(void)
> diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
> index 6aeb6b8..5c9ee6e 100644
> --- a/include/linux/mfd/syscon.h
> +++ b/include/linux/mfd/syscon.h
> @@ -17,6 +17,7 @@
>  
>  extern struct regmap *syscon_node_to_regmap(struct device_node *np);
>  extern struct regmap *syscon_regmap_lookup_by_compatible(const char *s);
> +extern struct regmap *syscon_regmap_lookup_by_pdevname(const char *s);
>  extern struct regmap *syscon_regmap_lookup_by_phandle(
>  					struct device_node *np,
>  					const char *property);
> -- 
> 1.7.12.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

