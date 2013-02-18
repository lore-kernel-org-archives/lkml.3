Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3BRQCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:02:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60273 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3BRQCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:02:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: [PATCH v3] mfd: syscon: Add non-DT support
Date: Mon, 18 Feb 2013 16:02:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru>
In-Reply-To: <1361198522-23789-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302181602.47157.arnd@arndb.de>
X-Provags-ID: V02:K0:Zk+9fJ3/WmuBxaIEqpZFaWSuUmYjD1o4GDjVxISK0F/
 Y57vT2VaxuyIYAURgLyWlFl+MqjbyyMjlViLqklOnZAZ5qIyT3
 2VIkXVAabfJ+5PjHINvC0jW0qStIePKxGBO7xV9P2WUPpl0mlx
 ZmDPrA61MxZ4Lcw2eO2LarNygFag9w1jpLc2AhuTfHJTkTyf6c
 5YuYSLfJTnSYcK5HpTE+AOJYgE0REZQjGF1k7L2KMclqMq9ETo
 K2TJra8e0S3ED6IBdCNFkXXbqaLkhcKXg5hjpdrA2rPTCx8lzo
 aLC9FHWllQPlKMfmCNva1cEL9E9O4HuZblD/8G5PgXKptW4yP4
 0RGOXAEzzNTMHKr7dy80=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2013, Alexander Shiyan wrote:
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index 4a7ed5a..3c0abcb 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c

Hi Alexander,

>  struct regmap *syscon_regmap_lookup_by_compatible(const char *s)
>  {
>  	struct device_node *syscon_np;
>  	struct regmap *regmap;
> +	struct syscon *syscon;
> +	struct device *dev;
>  
>  	syscon_np = of_find_compatible_node(NULL, NULL, s);
> -	if (!syscon_np)
> +	if (syscon_np) {
> +		regmap = syscon_node_to_regmap(syscon_np);
> +		of_node_put(syscon_np);
> +
> +		return regmap;
> +	}
> +
> +	/* Fallback to search by id_entry.name string */
> +	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> +				 syscon_match_id);
> +	if (!dev)
>  		return ERR_PTR(-ENODEV);
>  
> -	regmap = syscon_node_to_regmap(syscon_np);
> -	of_node_put(syscon_np);
> +	syscon = dev_get_drvdata(dev);
>  
> -	return regmap;
> +	return syscon->regmap;
>  }
>  EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);

Since you are not actually comparing the "compatible" property here,
I would suggest adding another function here, something like
syscon_regmap_lookup_by_pdevname() that you can use in device
drivers that are not DT-enabled. I would also recommend enclosing
that function in #ifdef CONFIG_ATAGS.

Which code do you have in mind that would call this anyway?
The changeset description does not really explain what ATAG
boot support in syscon is good for.

> +	if (IS_ENABLED(CONFIG_OF) && np) {
> +		syscon->base = of_iomap(np, 0);
> +		if (!syscon->base)
> +			return -EADDRNOTAVAIL;
> +
> +		res = &res_of;
> +		ret = of_address_to_resource(np, 0, res);
> +		if (ret) {
> +			iounmap(syscon->base);
> +			return ret;
> +		}
> +	} else {
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +		if (!res)
> +			return -ENOENT;
> +
> +		if (!devm_request_mem_region(dev, res->start,
> +					     resource_size(res),
> +					     dev_name(&pdev->dev)))
> +			return -EBUSY;
> +
> +		syscon->base = ioremap(res->start, resource_size(res));
> +		if (!syscon->base)
> +			return -EADDRNOTAVAIL;
> +	}

These two code paths look equivalent. Why not always use the second
one? Also, you might want to convert this to devm_ioremap_resource()
to simplify the code in the process.

	Arnd
