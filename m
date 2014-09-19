Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578AbaISPMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:12:05 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:39307 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547AbaISPMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:12:01 -0400
Message-ID: <541C47BD.3070601@gmail.com>
Date: Fri, 19 Sep 2014 17:11:57 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
CC: lee.jones@linaro.org, arnd@arndb.de, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com, kgene.kim@samsung.com,
        b29396@freescale.com, Li.Xiubo@freescale.com
Subject: Re: [PATCH v4] mfd: syscon: Decouple syscon interface from platform
 devices
References: <1411132009-11173-1-git-send-email-pankaj.dubey@samsung.com>
In-Reply-To: <1411132009-11173-1-git-send-email-pankaj.dubey@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj,

Please see my comments inline.

On 19.09.2014 15:06, Pankaj Dubey wrote:
> Currently a syscon entity can be only registered directly through a
> platform device that binds to a dedicated syscon driver. However in
> certain use cases it is desirable to make a device used with another
> driver a syscon interface provider.

[snip]

> -static int syscon_match_node(struct device *dev, void *data)
> +static struct syscon *of_syscon_register(struct device_node *np)
>  {
> -	struct device_node *dn = data;
> +	struct platform_device *pdev = NULL;
> +	struct syscon *syscon;
> +	struct regmap *regmap;
> +	void __iomem *base;
> +
> +

nit: Stray blank line.

> +	if (!of_device_is_compatible(np, "syscon"))
> +		return ERR_PTR(-EINVAL);

I don't think this check is needed at all. I'd say that drivers should
be free to register a syscon provider for any node.

> +
> +	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
> +	if (!syscon)
> +		return ERR_PTR(-ENOMEM);
> +
> +	base = of_iomap(np, 0);
> +	if (!base)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (!of_device_is_available(np) ||

Wouldn't it be enough to simply call of_find_device_by_node(np) and if
it fails then instead create a dummy device?

> +			of_node_test_and_set_flag(np, OF_POPULATED)) {
> +		/* if device is already populated and avaiable then use it */
> +		pdev = of_find_device_by_node(np);
> +		if (!(&pdev->dev))

This is just plain wrong, because this condition will always evaluate to
true (see the definition of struct platform_device). Shouldn't you
rather just check the pdev pointer?

> +			return ERR_PTR(-ENODEV);
> +
> +	} else {
> +		/* for early users create dummy syscon device and use it */
> +		pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
> +		if (!pdev)
> +			return ERR_PTR(-ENOMEM);

Any clean-up on error path?

> +
> +		pdev->name = "dummy-syscon";
> +		pdev->id = -1;

Wouldn't you get an ID collision if more than one syscon is registered
early? Maybe the naming scheme from of_device_alloc() could be adopted
partially?

> +		device_initialize(&pdev->dev);

I wonder if you couldn't simply reuse platform_device_alloc() for all of
this, except the line below, which would still have to be handled
separately.

> +		pdev->dev.of_node = np;
> +	}
> +
> +	regmap = regmap_init_mmio(&pdev->dev, base, &syscon_regmap_config);
> +	if (IS_ERR(regmap)) {
> +		pr_err("regmap init failed\n");

If you have a dev here then you should be able to use dev_err() already.

> +		return ERR_CAST(regmap);
> +	}
> +
> +	syscon->regmap = regmap;
> +	syscon->np = np;
>  
> -	return (dev->of_node == dn) ? 1 : 0;
> +	spin_lock(&syscon_list_slock);
> +	list_add_tail(&syscon->list, &syscon_list);
> +	spin_unlock(&syscon_list_slock);
> +
> +	return syscon;
>  }
>  
>  struct regmap *syscon_node_to_regmap(struct device_node *np)
>  {
> -	struct syscon *syscon;
> -	struct device *dev;
> +	struct syscon *entry, *syscon = NULL;
>  
> -	dev = driver_find_device(&syscon_driver.driver, NULL, np,
> -				 syscon_match_node);
> -	if (!dev)
> -		return ERR_PTR(-EPROBE_DEFER);
> +	spin_lock(&syscon_list_slock);
>  
> -	syscon = dev_get_drvdata(dev);
> +	list_for_each_entry(entry, &syscon_list, list)
> +		if (entry->np == np) {
> +			syscon = entry;
> +			break;
> +		}
>  
> -	return syscon->regmap;
> +	spin_unlock(&syscon_list_slock);
> +
> +	if (!syscon)
> +		syscon = of_syscon_register(np);
> +
> +	if (!IS_ERR(syscon))
> +		return syscon->regmap;
> +
> +	return ERR_CAST(syscon);

nit: Usually error checking is done the opposite way, i.e.

	if (IS_ERR(syscon))
		return ERR_CAST(syscon);

	return syscon->regmap;

Best regards,
Tomasz
