Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaLXLET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 06:04:19 -0500
Received: from smtprelay0202.hostedemail.com ([216.40.44.202]:50333 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751872AbaLXLEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 06:04:16 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2904:2914:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3871:3872:3874:4250:4321:4605:5007:6261:6742:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: silk59_7abcaec2d01b
X-Filterd-Recvd-Size: 4768
Message-ID: <1419419050.6157.11.camel@perches.com>
Subject: Re: [PATCH v8 2/2] drivers/gpio: Altera soft IP GPIO driver
From: Joe Perches <joe@perches.com>
To: thloh@altera.com
Cc: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Dinh Nguyen <dinguyen@altera.com>
Date: Wed, 24 Dec 2014 03:04:10 -0800
In-Reply-To: <1419409345-8297-3-git-send-email-thloh@altera.com>
References: <1419409345-8297-1-git-send-email-thloh@altera.com>
	 <1419409345-8297-3-git-send-email-thloh@altera.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-24 at 00:22 -0800, thloh@altera.com wrote:
> Adds a new driver for Altera soft GPIO IP. The driver is able to
> do read/write and allows GPIO to be a interrupt controller.

Some trivial comments, some not quite so trivial.

> diff --git a/drivers/gpio/gpio-altera.c b/drivers/gpio/gpio-altera.c
[]
> +static int altera_gpio_irq_set_type(struct irq_data *d,
> +				   unsigned int type)
> +{
> +	struct altera_gpio_chip *altera_gc = irq_data_get_irq_chip_data(d);
> +
> +	altera_gc = irq_data_get_irq_chip_data(d);

I presume this multiple initialization of altera_gc
is unnecessary duplication.

> +static void altera_gpio_irq_edge_handler(unsigned int irq,
> +					struct irq_desc *desc)
> +{
> +	struct altera_gpio_chip *altera_gc;
> +	struct irq_chip *chip;
> +	struct of_mm_gpio_chip *mm_gc;
> +	unsigned long status;
> +	int i;
> +
> +	altera_gc = irq_desc_get_handler_data(desc);
> +	chip = irq_desc_get_chip(desc);
> +	mm_gc = &altera_gc->mmchip;
> +
> +	chained_irq_enter(chip, desc);
> +
> +	while ((status =
> +	      (readl(mm_gc->regs + ALTERA_GPIO_EDGE_CAP) &
> +	      readl(mm_gc->regs + ALTERA_GPIO_IRQ_MASK)))) {
> +		writel(status, mm_gc->regs + ALTERA_GPIO_EDGE_CAP);
> +		for_each_set_bit(i, &status, mm_gc->gc.ngpio) {
> +			generic_handle_irq(
> +				irq_find_mapping(altera_gc->mmchip.gc.irqdomain
> +						, i));

That's kind of unpleasant to read.
It might be better to use a separate these statements
and use a temporary for irq_find_mapping()

> +static void altera_gpio_irq_leveL_high_handler(unsigned int irq,
> +					      struct irq_desc *desc)
> +{
> +	struct altera_gpio_chip *altera_gc;
> +	struct irq_chip *chip;
> +	struct of_mm_gpio_chip *mm_gc;
> +	unsigned long status;
> +	int i;
> +
> +	altera_gc = irq_desc_get_handler_data(desc);
> +	chip = irq_desc_get_chip(desc);
> +	mm_gc = &altera_gc->mmchip;
> +
> +	chained_irq_enter(chip, desc);
> +
> +	status = readl(mm_gc->regs + ALTERA_GPIO_DATA);
> +	status &= readl(mm_gc->regs + ALTERA_GPIO_IRQ_MASK);
> +
> +	for_each_set_bit(i, &status, mm_gc->gc.ngpio) {
> +		generic_handle_irq(
> +			irq_find_mapping(altera_gc->mmchip.gc.irqdomain, i));

Maybe a temporary here too

> +int altera_gpio_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	int id, reg, ret;
> +	struct altera_gpio_chip *altera_gc;
> +
> +	altera_gc = devm_kzalloc(&pdev->dev, sizeof(*altera_gc), GFP_KERNEL);
> +
> +	if (altera_gc == NULL)
> +		return -ENOMEM;

No blank line after the devm_kzalloc please and
	if (!altera_gc)
is more common.


> +	if (altera_gc->interrupt_trigger == IRQ_TYPE_LEVEL_HIGH) {
> +		gpiochip_set_chained_irqchip(&altera_gc->mmchip.gc,
> +			&altera_irq_chip,
> +			altera_gc->mapped_irq,
> +			altera_gpio_irq_leveL_high_handler);
> +	} else {
> +		gpiochip_set_chained_irqchip(&altera_gc->mmchip.gc,
> +			&altera_irq_chip,
> +			altera_gc->mapped_irq,
> +			altera_gpio_irq_edge_handler);
> +	}

Sometimes using a ?: ternary is smaller code

	gpiochip_set_chained_irqchip(&altera_gc->mmchip.gc,
				     &altera_irq_chip,
				     altera_gc->mapped_irq,
				     altera_gc->interrupt_trigger == IRQ_TYPE_LEVEL_HIGH ?
				     altera_gpio_irq_leveL_high_handler :
				     altera_gpio_irq_edge_handler);
> 

