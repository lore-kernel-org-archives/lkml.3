Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab3KVJ0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:26:38 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55671 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238Ab3KVJ0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:26:33 -0500
Date: Fri, 22 Nov 2013 09:26:06 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH] rtc: ds1511: add device-tree bindings
Message-ID: <20131122092606.GA7817@e106331-lin.cambridge.arm.com>
References: <marcus.folkesson@gmail.com>
 <1385104599-7527-1-git-send-email-marcus.folkesson@gmail.com>
 <1385104599-7527-2-git-send-email-marcus.folkesson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385104599-7527-2-git-send-email-marcus.folkesson@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 07:16:39AM +0000, Marcus Folkesson wrote:
> Compatible with ds1500, ds1501 and ds1511
> 
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
> ---
>  .../devicetree/bindings/rtc/maxim-ds1511.txt       |   18 +++++
>  drivers/rtc/rtc-ds1511.c                           |   85 +++++++++++++++++---
>  2 files changed, 90 insertions(+), 13 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/rtc/maxim-ds1511.txt
> 
> diff --git a/Documentation/devicetree/bindings/rtc/maxim-ds1511.txt b/Documentation/devicetree/bindings/rtc/maxim-ds1511.txt
> new file mode 100644
> index 0000000..17fa356
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rtc/maxim-ds1511.txt
> @@ -0,0 +1,18 @@
> +* Maxim Real Time Clock
> +
> +
> +Support for Maxim DS1500, DS1501 and DS1511 RTC.
> +
> +Required properties:
> +- compatible : Should be "maxim,ds1500-rtc", "maxim,ds1501-rtc" or "maxim,ds1511-rtc".

I'd prefer each of these on an individial line:

- compatible : Should contain one of:
   * "maxim,ds1500-rtc"
   * "maxim,ds1501-rtc"
   * "maxim,ds1511-rtc"

It would also be nice to have a description of how these differ, if
possible.

> +- reg: physical base address of the controller and length of memory mapped
> +  region.
> +- interrupts: IRQ line for the RTC.
> +
> +Example:
> +
> +rtc@10300 {
> +        compatible = "maxim,ds1511-rtc";
> +        reg = <0xd0010300 0x20>;
> +        interrupts = <50>;
> +};

Otherwise, the binding looks fine to me.

> diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
> index 6a3fcfe..3778a8e 100644
> --- a/drivers/rtc/rtc-ds1511.c
> +++ b/drivers/rtc/rtc-ds1511.c
> @@ -24,6 +24,9 @@
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
>  
>  #define DRV_VERSION "0.6"
>  
> @@ -476,6 +479,52 @@ static struct bin_attribute ds1511_nvram_attr = {
>  	.write = ds1511_nvram_write,
>  };
>  
> +
> +
> +#ifdef CONFIG_OF
> +static int ds1511_of_probe(struct platform_device *pdev,
> +	 struct rtc_plat_data *pdata)
> +{
> +	struct device *dev = &pdev->dev;
> +	u32 val;
> +	int ret;
> +	struct resource res;
> +
> +	ret = of_address_to_resource(&pdev->dev.of_node, 0, &res);
> +	if (ret)
> +		return -ENODEV;
> +

You can use platform_get_resource(pdev, IORESOURCE_MEM, 0) here as the
platform bus OF code will have already parsed this out of the dt for
you.

> +	pdata->size = resource_size(&res);
> +
> +	if (!devm_request_mem_region(&pdev->dev, res.start, pdata->size,
> +			pdev->name))
> +		return -EBUSY;
> +
> +	ds1511_base = devm_ioremap(&pdev->dev, res.start, pdata->size);
> +	if (!ds1511_base)
> +		return -ENOMEM;
> +
> +	pdata->ioaddr = ds1511_base;
> +	pdata->irq = irq_of_parse_and_map(&pdev->dev.of_node, 0);

Similarly, platform_get_resource(pdev, IORESOURCE_IRQ, 0).

There's no need to parse the dt twice.

> +
> +	return 0;
> +}
> +
> +static const struct of_device_id rtc_of_match[] = {
> +	{ .compatible = "maxim,ds1500-rtc" },
> +	{ .compatible = "maxim,ds1501-rtc" },
> +	{ .compatible = "maxim,ds1511-rtc" },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, rtc_of_match);
> +
> +#else
> +static int ds1511_of_probe(struct platform_device *pdev, struct rtc_plat_data *pdata)
> +{
> +	return -ENODEV;
> +}
> +#endif
> +
>  static int ds1511_rtc_probe(struct platform_device *pdev)
>  {
>  	struct rtc_device *rtc;
> @@ -483,22 +532,31 @@ static int ds1511_rtc_probe(struct platform_device *pdev)
>  	struct rtc_plat_data *pdata;
>  	int ret = 0;
>  
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		return -ENODEV;
> -	}
>  	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
>  	if (!pdata)
>  		return -ENOMEM;
> -	pdata->size = resource_size(res);
> -	if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
> -			pdev->name))
> -		return -EBUSY;
> -	ds1511_base = devm_ioremap(&pdev->dev, res->start, pdata->size);
> -	if (!ds1511_base)
> -		return -ENOMEM;
> -	pdata->ioaddr = ds1511_base;
> -	pdata->irq = platform_get_irq(pdev, 0);

As the platform bus OF code parses everything for you, this should have
been sufficient (with the rtc_of_match table wired up).

> +
> +	if (pdev->dev.of_node) {
> +		ret = ds1511_of_probe(pdev, pdata);
> +		if (ret < 0)
> +			return ret;
> +	} else if (!pdev) {

You've already dereferenced pdev above, if this is necessary it's
broken.

How would this get called without a pdev? I believe it can't.

> +
> +		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +		if (!res) {
> +			return -ENODEV;
> +		}
> +		pdata->size = resource_size(res);
> +		if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
> +				pdev->name))
> +			return -EBUSY;
> +		ds1511_base = devm_ioremap(&pdev->dev, res->start, pdata->size);
> +		if (!ds1511_base)
> +			return -ENOMEM;
> +		pdata->ioaddr = ds1511_base;
> +		pdata->irq = platform_get_irq(pdev, 0);

This all relies on pdev despite only being called when pdev is NULL, so
it's broken.

Thanks,
Mark.
