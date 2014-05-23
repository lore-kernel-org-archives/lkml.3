Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaEWMvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 08:51:15 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46077 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbaEWMvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 08:51:11 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v1] of/irq: do irq resolution in
 platform_get_irq_byname()
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: santosh.shilimkar@ti.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Herring <robh@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Thierry Reding <thierry.reding@gmail.com>
In-Reply-To: <1400582523-22684-1-git-send-email-grygorii.strashko@ti.com>
References: <1400582523-22684-1-git-send-email-grygorii.strashko@ti.com>
Date: Fri, 23 May 2014 17:03:33 +0900
Message-Id: <20140523080333.66720C4176E@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014 13:42:02 +0300, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
> The commit 9ec36cafe43bf835f8f29273597a5b0cbc8267ef
> "of/irq: do irq resolution in platform_get_irq" from Rob Herring -
> moves resolving of the interrupt resources in platform_get_irq().
> But this solution isn't complete because platform_get_irq_byname()
> need to be modified the same way.
> 
> Hence, fix it by adding interrupt resolution code at the
> platform_get_irq_byname() function too.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied, Thanks.

g.

> ---
> Changes in v1:
> - use of_property_match_string() to get IRQ index by name
> - minor comments fixed
> 
> RFC:
>  https://lkml.org/lkml/2014/5/19/325
> 
>  drivers/base/platform.c |    7 +++++--
>  drivers/of/irq.c        |   22 ++++++++++++++++++++++
>  include/linux/of_irq.h  |    5 +++++
>  3 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index 5b47210..9e9227e 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -131,9 +131,12 @@ EXPORT_SYMBOL_GPL(platform_get_resource_byname);
>   */
>  int platform_get_irq_byname(struct platform_device *dev, const char *name)
>  {
> -	struct resource *r = platform_get_resource_byname(dev, IORESOURCE_IRQ,
> -							  name);
> +	struct resource *r;
> +
> +	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node)
> +		return of_irq_get_byname(dev->dev.of_node, name);
>  
> +	r = platform_get_resource_byname(dev, IORESOURCE_IRQ, name);
>  	return r ? r->start : -ENXIO;
>  }
>  EXPORT_SYMBOL_GPL(platform_get_irq_byname);
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 5aeb894..3e06a69 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -406,6 +406,28 @@ int of_irq_get(struct device_node *dev, int index)
>  }
>  
>  /**
> + * of_irq_get_byname - Decode a node's IRQ and return it as a Linux irq number
> + * @dev: pointer to device tree node
> + * @name: irq name
> + *
> + * Returns Linux irq number on success, or -EPROBE_DEFER if the irq domain
> + * is not yet created, or error code in case of any other failure.
> + */
> +int of_irq_get_byname(struct device_node *dev, const char *name)
> +{
> +	int index;
> +
> +	if (unlikely(!name))
> +		return -EINVAL;
> +
> +	index = of_property_match_string(dev, "interrupt-names", name);
> +	if (index < 0)
> +		return index;
> +
> +	return of_irq_get(dev, index);
> +}
> +
> +/**
>   * of_irq_count - Count the number of IRQs a node uses
>   * @dev: pointer to device tree node
>   */
> diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
> index 6404253..bfec136 100644
> --- a/include/linux/of_irq.h
> +++ b/include/linux/of_irq.h
> @@ -45,6 +45,7 @@ extern void of_irq_init(const struct of_device_id *matches);
>  #ifdef CONFIG_OF_IRQ
>  extern int of_irq_count(struct device_node *dev);
>  extern int of_irq_get(struct device_node *dev, int index);
> +extern int of_irq_get_byname(struct device_node *dev, const char *name);
>  #else
>  static inline int of_irq_count(struct device_node *dev)
>  {
> @@ -54,6 +55,10 @@ static inline int of_irq_get(struct device_node *dev, int index)
>  {
>  	return 0;
>  }
> +static inline int of_irq_get_byname(struct device_node *dev, const char *name)
> +{
> +	return 0;
> +}
>  #endif
>  
>  #if defined(CONFIG_OF)
> -- 
> 1.7.9.5
> 

