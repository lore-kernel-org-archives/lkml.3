Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaD0SSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 14:18:08 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:58604 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaD0SSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 14:18:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, prathyush.k@samsung.com, grundler@chromium.org,
        joro@8bytes.org, supash.ramaswamy@linaro.org, tomasz.figa@gmail.com,
        joshi@samsung.com, sachin.kamat@linaro.org, s.nawrocki@samsung.com,
        Varun.Sethi@freescale.com, a.motakis@virtualopensystems.com,
        pullip.cho@samsung.com, t.figa@samsung.com, rahul.sharma@samsung.com
Subject: Re: [PATCH v12 15/31] iommu/exynos: handle 'mmu-masters' property of DT and improve handling sysmmu
Date: Sun, 27 Apr 2014 20:17:48 +0200
Message-ID: <13595839.WFkdpM5auQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398584283-22846-16-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com> <1398584283-22846-16-git-send-email-shaik.ameer@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:W8Xporq8ix0igGQHfhVULx+FEwwXiu1m9qoM7pSEuLJ
 zFMFyfqdzCCYeg7dMgIF7Z4l70YUhxlFt5+aYZN1P56+Ne86ON
 KYrJocosGFmnTwDtfqoHxyYgrEqrdzXyjxOBWlg8LXRzTV/EbY
 GWchs0B2ZL0BipImjwPGKIWtrgxTMGgylbEIkEox8lvUIeFvbv
 TphZyqduebf7rXfu0WXE4HZcaWMsFHQoQgbqepSwJ03numH6AV
 FjAB4ForLN5DdsCvEhOT/mya6rGHo0e1LqhNIxPsPGQ3No9iWc
 G5td76oeRwmjzbs9iATuRc/PP5xp9fTONgz0rdwQtecR2mUrtQ
 9Uz5ES3LA7vuPIhHmZMs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 April 2014 13:07:47 Shaik Ameer Basha wrote:
> @@ -542,14 +592,41 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	/* Relation between master and System MMU is 1:1. */
> +	node = of_parse_phandle(dev->of_node, "mmu-masters", 0);
> +	if (node) {
> +		struct platform_device *master = of_find_device_by_node(node);
> +
> +		if (!master) {
> +			dev_err(dev, "%s: mmu-master '%s' not found\n",
> +				__func__, node->name);
> +			return -EINVAL;
> +		}
> +
> +		if (master->dev.archdata.iommu != NULL) {
> +			dev_err(dev, "%s: '%s' is master of other MMU\n",
> +				__func__, node->name);
> +			return -EINVAL;
> +		}
> +
> +		/*
> +		 * archdata.iommu will be initialized with exynos_iommu_client
> +		 * in sysmmu_hook_driver_register().
> +		 */
> +		master->dev.archdata.iommu = dev;
> +	}

I think parsing of generic properties like this shouldn't be done
by the individual driver. It belongs into core iommu code and should
be done when the devices are probed.

> +
> +static struct notifier_block sysmmu_notifier = {
> +	.notifier_call = &sysmmu_hook_driver_register,
> +};
> +
> +static int __init exynos_iommu_prepare(void)
> +{
> +	static bool registered = false;
> +	int ret;
> +
> +	if (registered)
> +		return 0;
> +
> +	ret = bus_register_notifier(&platform_bus_type, &sysmmu_notifier);
> +	if (!ret)
> +		registered = true;
> +	else
> +		pr_err("Failed to register sysmmu_notifier\n");
> +
> +	return ret;
> +}

This also means we should not have notifiers. Put it into core code to
make sure all IOMMUs are handled the same way.

	Arnd
