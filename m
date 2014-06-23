Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaFWPdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 11:33:25 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65008 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbaFWPdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 11:33:24 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A848B8.8060501@roeck-us.net>
Date: Mon, 23 Jun 2014 08:33:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Rob Herring <robh@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v2] platform_get_irq: Revert to platform_get_resource
 if of_irq_get fails
References: <1403045462-24204-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1403045462-24204-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping ... any comments ?

Guenter

On 06/17/2014 03:51 PM, Guenter Roeck wrote:
> Commits 9ec36ca (of/irq: do irq resolution in platform_get_irq)
> and ad69674 (of/irq: do irq resolution in platform_get_irq_byname)
> change the semantics of platform_get_irq and platform_get_irq_byname
> to always rely on devicetree information if devicetree is enabled
> and if a devicetree node is attached to the device. The functions
> now return an error if the devicetree data does not include interrupt
> information, even if the information is available as platform resource
> data.
>
> This causes mfd client drivers to fail if the interrupt number is
> passed via platform resources. Therefore, if of_irq_get fails, try
> platform_get_resource as method of last resort. This restores the
> original functionality for drivers depending on platform resources
> to get irq information.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Include change for platform_get_irq_byname
>      Handle EPROBE_DEFER
>
> It looks like v1 got lost in space, so you may not have seen it.
> I am sending this patch as v2 anyway to avoid confusion, just in case
> v1 shows up somewhere.
>
> At least 9ec36ca has been applied to -stable, so if this patch is
> accepted it may make sense to apply it to the same -stable releases.
>
>   drivers/base/platform.c | 18 ++++++++++++++----
>   1 file changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 9e9227e..eee48c4 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -89,8 +89,13 @@ int platform_get_irq(struct platform_device *dev, unsigned int num)
>   	return dev->archdata.irqs[num];
>   #else
>   	struct resource *r;
> -	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node)
> -		return of_irq_get(dev->dev.of_node, num);
> +	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node) {
> +		int ret;
> +
> +		ret = of_irq_get(dev->dev.of_node, num);
> +		if (ret >= 0 || ret == -EPROBE_DEFER)
> +			return ret;
> +	}
>
>   	r = platform_get_resource(dev, IORESOURCE_IRQ, num);
>
> @@ -133,8 +138,13 @@ int platform_get_irq_byname(struct platform_device *dev, const char *name)
>   {
>   	struct resource *r;
>
> -	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node)
> -		return of_irq_get_byname(dev->dev.of_node, name);
> +	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node) {
> +		int ret;
> +
> +		ret = of_irq_get_byname(dev->dev.of_node, name);
> +		if (ret >= 0 || ret == -EPROBE_DEFER)
> +			return ret;
> +	}
>
>   	r = platform_get_resource_byname(dev, IORESOURCE_IRQ, name);
>   	return r ? r->start : -ENXIO;
>

