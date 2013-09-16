Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab3IPVZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 17:25:13 -0400
Received: from mail-ye0-f175.google.com ([209.85.213.175]:41739 "EHLO
	mail-ye0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3IPVYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 17:24:54 -0400
Message-ID: <5237771F.1060908@gmail.com>
Date: Mon, 16 Sep 2013 16:24:47 -0500
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
Subject: Re: [PATCH 4/9] of/irq: Introduce of_irq_get()
References: <1379320326-13241-1-git-send-email-treding@nvidia.com> <1379320326-13241-5-git-send-email-treding@nvidia.com>
In-Reply-To: <1379320326-13241-5-git-send-email-treding@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 03:32 AM, Thierry Reding wrote:
> This is a version of irq_of_parse_and_map() that propagates the precise
> error code instead of returning 0 for all errors. It will be used in
> subsequent patches to allow further propagation of error codes.
> 
> To avoid code duplication, implement irq_of_parse_and_map() as a wrapper
> around the new of_irq_get().

*_get typically also implies some reference counting which I don't
believe this does. I don't think having 2 functions with completely
different names doing the same thing with only a different calling
convention is good either. So I would keep the old name and the names
aligned.

> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/of/irq.c       | 21 +++++++++++++++++----
>  include/linux/of_irq.h |  3 +++
>  2 files changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 5f44388..8225289 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -26,6 +26,20 @@
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  
> +int of_irq_get(struct device_node *dev, unsigned int index, unsigned int *virqp)
> +{
> +	struct of_irq oirq;
> +	int ret;
> +
> +	ret = of_irq_map_one(dev, index, &oirq);
> +	if (ret)
> +		return ret;
> +
> +	return __irq_create_of_mapping(oirq.controller, oirq.specifier,
> +				       oirq.size, virqp);
> +}
> +EXPORT_SYMBOL_GPL(of_irq_get);
> +
>  /**
>   * irq_of_parse_and_map - Parse and map an interrupt into linux virq space
>   * @dev: Device node of the device whose interrupt is to be mapped
> @@ -36,13 +50,12 @@
>   */
>  unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
>  {
> -	struct of_irq oirq;
> +	unsigned int virq;
>  
> -	if (of_irq_map_one(dev, index, &oirq))
> +	if (of_irq_get(dev, index, &virq))
>  		return 0;
>  
> -	return irq_create_of_mapping(oirq.controller, oirq.specifier,
> -				     oirq.size);
> +	return virq;

This can be an inline and written more concisely:

{
	unsigned int virq;
	return (of_irq_get(dev, index, &virq) < 0) ? 0 : virq;
}

Rob


