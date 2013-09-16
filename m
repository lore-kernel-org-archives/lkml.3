Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab3IPV3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 17:29:24 -0400
Received: from mail-ye0-f173.google.com ([209.85.213.173]:45023 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3IPV3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 17:29:21 -0400
Message-ID: <5237782B.3030804@gmail.com>
Date: Mon, 16 Sep 2013 16:29:15 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 5/9] of/irq: Introduce __of_irq_to_resource()
References: <1379320326-13241-1-git-send-email-treding@nvidia.com> <1379320326-13241-6-git-send-email-treding@nvidia.com>
In-Reply-To: <1379320326-13241-6-git-send-email-treding@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 03:32 AM, Thierry Reding wrote:
> This is a version of of_irq_to_resource() that propagates the precise
> error code instead of returning 0 for all errors. It will be used in
> subsequent patches to allow further propagation of error codes.
> 
> To avoid code duplication, implement of_irq_to_resource() as a wrapper
> around the new __of_irq_to_resource().

I think the callers in this case are manageable to update as well.
Several cases could simply use irq_of_parse_and_map instead as they just
pass in a NULL resource.

Rob

> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/of/irq.c | 33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 8225289..57396fd 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -343,15 +343,15 @@ int of_irq_map_one(struct device_node *device, int index, struct of_irq *out_irq
>  }
>  EXPORT_SYMBOL_GPL(of_irq_map_one);
>  
> -/**
> - * of_irq_to_resource - Decode a node's IRQ and return it as a resource
> - * @dev: pointer to device tree node
> - * @index: zero-based index of the irq
> - * @r: pointer to resource structure to return result into.
> - */
> -int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
> +static int __of_irq_to_resource(struct device_node *dev, unsigned int index,
> +				struct resource *r)
>  {
> -	int irq = irq_of_parse_and_map(dev, index);
> +	unsigned int irq;
> +	int ret;
> +
> +	ret = of_irq_get(dev, index, &irq);
> +	if (ret)
> +		return ret;
>  
>  	/* Only dereference the resource if both the
>  	 * resource and the irq are valid. */
> @@ -373,6 +373,23 @@ int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
>  
>  	return irq;
>  }
> +
> +/**
> + * of_irq_to_resource - Decode a node's IRQ and return it as a resource
> + * @dev: pointer to device tree node
> + * @index: zero-based index of the irq
> + * @r: pointer to resource structure to return result into.
> + */
> +int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
> +{
> +	int ret;
> +
> +	ret = __of_irq_to_resource(dev, index, r);
> +	if (ret < 0)
> +		return 0;
> +
> +	return ret;
> +}
>  EXPORT_SYMBOL_GPL(of_irq_to_resource);
>  
>  /**
> 

