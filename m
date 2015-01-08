Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbbAHNe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 08:34:26 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63255 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755024AbbAHNeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:34:25 -0500
Date: Thu, 8 Jan 2015 13:34:05 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2] mfd: lubbock_io: add lubbock_io board
Message-ID: <20150108133404.GE10537@leverpostej>
References: <1420324515-7444-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420324515-7444-1-git-send-email-robert.jarzmik@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Sat, Jan 03, 2015 at 10:35:15PM +0000, Robert Jarzmik wrote:
> Lubbock () board is the IO motherboard of the Intel PXA25x Development
> Platform, which supports the Lubbock pxa25x soc board.
> 
> Historically, this support was in arch/arm/mach-pxa/lubbock.c. When
> gpio-pxa was moved to drivers/pxa, it became a driver, and its
> initialization and probing happened at postcore initcall. The lubbock
> code used to install the chained lubbock interrupt handler at init_irq()
> time.
> 
> The consequence of the gpio-pxa change is that the installed chained irq
> handler lubbock_irq_handler() was overwritten in pxa_gpio_probe(_dt)(),
> removing :
>  - the handler
>  - the falling edge detection setting of GPIO0, which revealed the
>    interrupt request from the lubbock IO board.
> 
> As a fix, move the gpio0 chained handler setup to a place where we have
> the guarantee that pxa_gpio_probe() was called before, so that lubbock
> handler becomes the true IRQ chained handler of GPIO0, demuxing the
> lubbock IO board interrupts.
> 
> This patch moves all that handling to a mfd driver. It's only purpose
> for the time being is the interrupt handling, but in the future it
> should encompass all the motherboard CPLDs handling :
>  - leds
>  - switches
>  - hexleds

Given the addition of an of_device_id table and some (implicit) property
parsing, this requires a device tree binding document.

[...]

> +static int lubbock_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	struct lubbock *cot;
> +	int ret;
> +	unsigned int base_irq = 0;
> +
> +	cot = devm_kzalloc(&pdev->dev, sizeof(*cot), GFP_KERNEL);
> +	if (!cot)
> +		return -ENOMEM;
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (res)
> +		cot->irq = (unsigned int)res->start;
> +	if (!cot->irq)
> +		return -ENODEV;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
> +	if (res)
> +		base_irq = (unsigned int)res->start;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	cot->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(cot->base))
> +		return PTR_ERR(cot->base);
> +
> +	platform_set_drvdata(pdev, cot);
> +
> +	writel(cot->irq_mask, cot->base + COT_IRQ_MASK_EN);
> +	writel(0, cot->base + COT_IRQ_SET_CLR);
> +	ret = devm_request_irq(&pdev->dev, cot->irq, lubbock_irq_handler, 0,
> +			       dev_name(&pdev->dev), cot);
> +	if (ret == -ENOSYS)
> +		return -EPROBE_DEFER;
> +	if (ret) {
> +		dev_err(&pdev->dev, "Couldn't request GPIO : ret = %d\n", ret);
> +		return ret;
> +	}
> +	irq_set_irq_type(cot->irq, IRQ_TYPE_EDGE_FALLING);

Shouldn't that be in the interrupt-specifier when using DT?

> +	irq_set_irq_wake(cot->irq, 1);
> +
> +	cot->irqdomain =
> +		irq_domain_add_linear(pdev->dev.of_node, LUBBOCK_NB_IRQ,
> +				      &lubbock_irq_domain_ops, cot);
> +	if (!cot->irqdomain)
> +		return -ENODEV;
> +
> +	ret = 0;
> +	if (base_irq)
> +		ret = irq_create_strict_mappings(cot->irqdomain, base_irq, 0,
> +						 LUBBOCK_NB_IRQ);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Couldn't create the irq mapping %d..%d\n",
> +			base_irq, base_irq + LUBBOCK_NB_IRQ);
> +		return ret;
> +	}
> +
> +	dev_info(&pdev->dev, "base=%p, irq=%d, base_irq=%d\n",
> +		 cot->base, cot->irq, base_irq);
> +
> +	return 0;
> +}
> +
> +static int lubbock_remove(struct platform_device *pdev)
> +{
> +	struct lubbock *cot = platform_get_drvdata(pdev);
> +
> +	irq_set_chip_and_handler(cot->irq, NULL, NULL);
> +	return 0;
> +}
> +
> +static const struct of_device_id lubbock_id_table[] = {
> +	{ .compatible = "marvell,lubbock_io", },

When PXA25x it was Intel, not Marvell. So I think the vendor prefix
should be "intel".

Also s/_/-/ in property names and compatible strings please.

Thanks,
Mark.
