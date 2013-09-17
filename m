Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3IQNEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:04:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51090 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab3IQNE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:04:28 -0400
From: "Strashko, Grygorii" <grygorii.strashko@ti.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 7/9] of/platform: Resolve interrupt references at probe
 time
Thread-Topic: [PATCH 7/9] of/platform: Resolve interrupt references at probe
 time
Thread-Index: AQHOsreZgkoiZ41uWkOwoWWSHnYI+JnJ4ywG
Date: Tue, 17 Sep 2013 13:04:06 +0000
Message-ID: <902E09E6452B0E43903E4F2D568737AB363BD3@DNCE04.ent.ti.com>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>,<1379320326-13241-8-git-send-email-treding@nvidia.com>
In-Reply-To: <1379320326-13241-8-git-send-email-treding@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.167.131.94]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 09/16/2013 11:32 AM, Thierry Reding wrote:> Interrupt references are currently resolved very early (when a device is
> created). This has the disadvantage that it will fail in cases where the
> interrupt parent hasn't been probed and no IRQ domain for it has been
> registered yet. To work around that various drivers use explicit
> initcall ordering to force interrupt parents to be probed before devices
> that need them are created. That's error prone and doesn't always work.
> If a platform device uses an interrupt line connected to a different
> platform device (such as a GPIO controller), both will be created in the
> same batch, and the GPIO controller won't have been probed by its driver
> when the depending platform device is created. Interrupt resolution will
> fail in that case.
> 
> Another common workaround is for drivers to explicitly resolve interrupt
> references at probe time. This is suboptimal, however, because it will
> require every driver to duplicate the code.
> 
> This patch adds support for late interrupt resolution to the platform
> driver core, by resolving the references right before a device driver's
> .probe() function will be called. This not only delays the resolution
> until a much later time (giving interrupt parents a better chance of
> being probed in the meantime), but it also allows the platform driver
> core to queue the device for deferred probing if the interrupt parent
> hasn't registered its IRQ domain yet.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>   drivers/base/platform.c     |  4 ++++
>   drivers/of/platform.c       | 43 +++++++++++++++++++++++++++++++++++++------
>   include/linux/of_platform.h |  7 +++++++
>   3 files changed, 48 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 4f8bef3..8dcf835 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -481,6 +481,10 @@ static int platform_drv_probe(struct device *_dev)

Should it be the part of really_probe()? Isn't it?

>   	struct platform_device *dev = to_platform_device(_dev);
>   	int ret;
>   
> +	ret = of_platform_probe(dev);
> +	if (ret)
> +		return ret;
> +
>   	if (ACPI_HANDLE(_dev))
>   		acpi_dev_pm_attach(_dev, true);
>   
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 9b439ac..edaef70 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -142,7 +142,7 @@ struct platform_device *of_device_alloc(struct device_node *np,
>   				  struct device *parent)
>   {
>   	struct platform_device *dev;
> -	int rc, i, num_reg = 0, num_irq;
> +	int rc, i, num_reg = 0;
>   	struct resource *res, temp_res;
>   
>   	dev = platform_device_alloc("", -1);
> @@ -153,23 +153,21 @@ struct platform_device *of_device_alloc(struct device_node *np,
>   	if (of_can_translate_address(np))
>   		while (of_address_to_resource(np, num_reg, &temp_res) == 0)
>   			num_reg++;
> -	num_irq = of_irq_count(np);
>   
>   	/* Populate the resource table */
> -	if (num_irq || num_reg) {
> -		res = kzalloc(sizeof(*res) * (num_irq + num_reg), GFP_KERNEL);
> +	if (num_reg) {
> +		res = kzalloc(sizeof(*res) * num_reg, GFP_KERNEL);
>   		if (!res) {
>   			platform_device_put(dev);
>   			return NULL;
>   		}
>   
> -		dev->num_resources = num_reg + num_irq;
> +		dev->num_resources = num_reg;
>   		dev->resource = res;
>   		for (i = 0; i < num_reg; i++, res++) {
>   			rc = of_address_to_resource(np, i, res);
>   			WARN_ON(rc);
>   		}
> -		WARN_ON(of_irq_to_resource_table(np, res, num_irq) != num_irq);
>   	}
>   
>   	dev->dev.of_node = of_node_get(np);
> @@ -490,4 +488,37 @@ int of_platform_populate(struct device_node *root,
>   	return rc;
>   }
>   EXPORT_SYMBOL_GPL(of_platform_populate);
> +
> +int of_platform_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	int num_irq, ret = 0;
> +
> +	if (!pdev->dev.of_node)
> +		return 0;
> +
> +	num_irq = of_irq_count(pdev->dev.of_node);
> +	if (num_irq > 0) {
> +		struct resource *res = pdev->resource;
> +		int num_reg = pdev->num_resources;
> +		int num = num_reg + num_irq;
> +
> +		res = krealloc(res, num * sizeof(*res), GFP_KERNEL);
> +		if (!res)
> +			return -ENOMEM;
> +
> +		pdev->num_resources = num;
> +		pdev->resource = res;
> +		res += num_reg;

What will happen if Driver probe is failed or deferred?
Seems resource table size will grow each time the Driver probe is deferred or failed.

> +
> +		ret = of_irq_to_resource_table(np, res, num_irq);
> +		if (ret < 0)
> +			return ret;
> +
> +		WARN_ON(ret != num_irq);
> +		ret = 0;
> +	}
> +
> +	return ret;
> +}
>   #endif /* CONFIG_OF_ADDRESS */
> diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
> index 05cb4a9..92fc4f6 100644
> --- a/include/linux/of_platform.h
> +++ b/include/linux/of_platform.h
> @@ -72,6 +72,8 @@ extern int of_platform_populate(struct device_node *root,
>   				const struct of_device_id *matches,
>   				const struct of_dev_auxdata *lookup,
>   				struct device *parent);
> +
> +extern int of_platform_probe(struct platform_device *pdev);
>   #else
>   static inline int of_platform_populate(struct device_node *root,
>   					const struct of_device_id *matches,
> @@ -80,6 +82,11 @@ static inline int of_platform_populate(struct device_node *root,
>   {
>   	return -ENODEV;
>   }
> +
> +static inline int of_platform_probe(struct platform_device *pdev)
> +{
> +	return 0;
> +}
>   #endif
>   
>   #endif	/* _LINUX_OF_PLATFORM_H */
> 
Regards,
- grygorii
