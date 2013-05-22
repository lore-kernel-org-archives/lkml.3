Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3EVJgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:36:12 -0400
Received: from ns.mm-sol.com ([213.240.235.226]:46442 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546Ab3EVJgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:36:10 -0400
Message-ID: <519C9180.2060408@mm-sol.com>
Date: Wed, 22 May 2013 12:36:00 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Rohit Vaswani <rvaswani@codeaurora.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] gpio: msm: Add device tree and irqdomain support
 for gpio-msm-v2
References: <1369161163-6448-1-git-send-email-rvaswani@codeaurora.org> <1369161163-6448-4-git-send-email-rvaswani@codeaurora.org>
In-Reply-To: <1369161163-6448-4-git-send-email-rvaswani@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rohit

Thanks for the patch!

On 05/21/2013 09:32 PM, Rohit Vaswani wrote:
> This cleans up the gpio-msm-v2 driver of all the global define usage.
> The number of gpios are now defined in the device tree. This enables
> adding irqdomain support as well.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---

<cut>

>  
>  static DEFINE_SPINLOCK(tlmm_lock);
> @@ -168,18 +173,20 @@ static void msm_gpio_free(struct gpio_chip *chip, unsigned offset)
>  
>  static int msm_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
>  {
> -	return MSM_GPIO_TO_INT(chip->base + offset);
> +	struct msm_gpio_dev *g_dev = to_msm_gpio_dev(chip);
> +	struct irq_domain *domain = g_dev->domain;
> +	return irq_create_mapping(domain, offset);

IMO here you should use irq_find_mapping() and create irq mapping once
in .probe. See below comment.

>  }
>  

<cut>

> -static int msm_gpio_probe(struct platform_device *dev)
> +static struct lock_class_key msm_gpio_lock_class;
> +
> +static int msm_gpio_irq_domain_map(struct irq_domain *d, unsigned int irq,
> +				   irq_hw_number_t hwirq)
> +{
> +	irq_set_lockdep_class(irq, &msm_gpio_lock_class);
> +	irq_set_chip_and_handler(irq, &msm_gpio_irq_chip,
> +			handle_level_irq);
> +	set_irq_flags(irq, IRQF_VALID);
> +
> +	return 0;
> +}
> +
> +static const struct irq_domain_ops msm_gpio_irq_domain_ops = {
> +	.xlate = irq_domain_xlate_twocell,
> +	.map = msm_gpio_irq_domain_map,
> +};
> +
> +static int msm_gpio_irqdomain_init(struct device_node *node, int ngpio)
>  {
> -	int i, irq, ret;
> +	msm_gpio.domain = irq_domain_add_linear(node, ngpio,
> +			&msm_gpio_irq_domain_ops, &msm_gpio);
> +	if (!msm_gpio.domain) {
> +		WARN(1, "Cannot allocate irq_domain\n");

Are you sure that we want to WARN if no memory? I'd return an error and
fail the probe if the driver can't works without interrupts.

> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static int msm_gpio_probe(struct platform_device *pdev)
> +{
> +	int i, irq, ret, ngpio;
> +	struct resource *res;
> +
> +	msm_gpio.gpio_chip.label = pdev->name;
> +	msm_gpio.gpio_chip.dev = &pdev->dev;
> +	of_property_read_u32(pdev->dev.of_node, "ngpio", &ngpio);
> +	msm_gpio.gpio_chip.ngpio = ngpio;
> +
> +	res = platform_get_resource(&pdev->dev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "%s: no mem resource\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	msm_tlmm_base = devm_ioremap_resource(pdev->dev, res);
> +	if (!msm_tlmm_base) {
> +		dev_err(&pdev->dev, "Couldn't allocate memory for msm tlmm base\n");
> +		return -ENOMEM;
> +	}
> +
> +	msm_gpio.enabled_irqs = devm_kzalloc(&pdev->dev,
> +						sizeof(unsigned long) * ngpio,
> +						GFP_KERNEL);
> +	msm_gpio.wake_irqs = devm_kzalloc(&pdev->dev,
> +						sizeof(unsigned long) * ngpio,
> +						GFP_KERNEL);
> +	msm_gpio.dual_edge_irqs = devm_kzalloc(&pdev->dev,
> +						sizeof(unsigned long) * ngpio,
> +						GFP_KERNEL);
> +	bitmap_zero(msm_gpio.enabled_irqs, ngpio);
> +	bitmap_zero(msm_gpio.wake_irqs, ngpio);
> +	bitmap_zero(msm_gpio.dual_edge_irqs, ngpio);
>  
> -	bitmap_zero(msm_gpio.enabled_irqs, NR_GPIO_IRQS);
> -	bitmap_zero(msm_gpio.wake_irqs, NR_GPIO_IRQS);
> -	bitmap_zero(msm_gpio.dual_edge_irqs, NR_GPIO_IRQS);
> -	msm_gpio.gpio_chip.label = dev->name;
>  	ret = gpiochip_add(&msm_gpio.gpio_chip);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "gpiochip_add failed with error %d\n", ret);
>  		return ret;
> +	}
> +
> +	summary_irq = platform_get_irq(pdev, 0);
> +	if (summary_irq < 0) {
> +		dev_err(&pdev->dev, "No Summary irq defined for msmgpio\n");
> +		return summary_irq;
> +	}
> +
> +	msm_gpio_irqdomain_init(pdev->dev.of_node, msm_gpio.gpio_chip.ngpio);

Adding irqdomain might fail, could you check the return value. And if
irqdomain init fail do we need to set up chained handler for summary_irq
at all?

>  
>  	for (i = 0; i < msm_gpio.gpio_chip.ngpio; ++i) {
>  		irq = msm_gpio_to_irq(&msm_gpio.gpio_chip, i);

I'd call irq_create_mapping() instead. This way the mapping will be
created once in .probe and use irq_find_mapping() in gpio_to_irq.

> +		irq_set_lockdep_class(irq, &msm_gpio_lock_class);
>  		irq_set_chip_and_handler(irq, &msm_gpio_irq_chip,
>  					 handle_level_irq);
>  		set_irq_flags(irq, IRQF_VALID);

These three function calls are not needed anymore because
irq_create_mapping() will call internally irqdomain .map operation. The
.map already calls these three functions.

>  	}
>  
> -	irq_set_chained_handler(TLMM_SCSS_SUMMARY_IRQ,
> -				msm_summary_irq_handler);
> +	irq_set_chained_handler(summary_irq, msm_summary_irq_handler);
> +
>  	return 0;
>  }
>  

- Stan
