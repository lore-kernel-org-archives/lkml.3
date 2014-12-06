Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaLFB2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 20:28:11 -0500
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:38761 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751141AbaLFB2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 20:28:08 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1500:1515:1516:1518:1535:1543:1593:1594:1605:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2693:2828:2904:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:4250:4321:5007:6261:6742:10004:10400:10848:11026:11232:11473:11658:11914:12043:12050:12296:12438:12517:12519:12740:13161:13229:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: knife42_2958249b3304f
X-Filterd-Recvd-Size: 5338
Message-ID: <1417829282.31745.3.camel@perches.com>
Subject: Re: [PATCH 2/5] gpio: Cygnus: add GPIO driver
From: Joe Perches <joe@perches.com>
To: Ray Jui <rjui@broadcom.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Date: Fri, 05 Dec 2014 17:28:02 -0800
In-Reply-To: <1417826408-1600-3-git-send-email-rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
	 <1417826408-1600-1-git-send-email-rjui@broadcom.com>
	 <1417826408-1600-3-git-send-email-rjui@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 16:40 -0800, Ray Jui wrote:
> This GPIO driver supports all 3 GPIO controllers in the Broadcom Cygnus
> SoC. The 3 GPIO controllers are 1) the ASIU GPIO controller
> ("brcm,cygnus-asiu-gpio"), 2) the chipCommonG GPIO controller
> ("brcm,cygnus-ccm-gpio"), and 3) the ALWAYS-ON GPIO controller
> ("brcm,cygnus-crmu-gpio")

trivia:

> diff --git a/drivers/gpio/gpio-bcm-cygnus.c b/drivers/gpio/gpio-bcm-cygnus.c

> +static inline struct bcm_cygnus_gpio *to_bcm_cygnus_gpio(
> +		struct gpio_chip *gc)
> +{
> +	return container_of(gc, struct bcm_cygnus_gpio, gc);
> +}

Probably all of these inlines can just be static.

The compiler does a pretty good job these days
of inlining where appropriate.


> +static void bcm_cygnus_gpio_irq_handler(unsigned int irq,
> +		struct irq_desc *desc)
> +{
> +	struct bcm_cygnus_gpio *cygnus_gpio;
> +	struct irq_chip *chip = irq_desc_get_chip(desc);
> +	int i, bit;
> +
> +	chained_irq_enter(chip, desc);
> +
> +	cygnus_gpio = irq_get_handler_data(irq);
> +
> +	/* go through the entire GPIO banks and handle all interrupts */
> +	for (i = 0; i < cygnus_gpio->num_banks; i++) {
> +		unsigned long val = readl(cygnus_gpio->base +
> +				(i * GPIO_BANK_SIZE) +
> +				CYGNUS_GPIO_INT_MSTAT_OFFSET);
> +		if (val) {

This if (val) and indentation isn't really necessary

> +			for_each_set_bit(bit, &val, 32) {

for_each_set_bit will effectively do the if above.

32 bit only code?
otherwise isn't this endian unsafe?

> +				unsigned pin = NGPIOS_PER_BANK * i + bit;
> +				int child_irq =	bcm_cygnus_gpio_to_irq(
> +						&cygnus_gpio->gc, pin);
> +
> +				/*
> +				 * Clear the interrupt before invoking the
> +				 * handler, so we do not leave any window
> +				 */
> +				writel(1 << bit,
> +					cygnus_gpio->base +
> +					(i * GPIO_BANK_SIZE) +
> +					CYGNUS_GPIO_INT_CLR_OFFSET);
> +
> +				generic_handle_irq(child_irq);
> +			}
> +
> +		}
> +	}
> +
> +	chained_irq_exit(chip, desc);
> +}
> +
> +static void bcm_cygnus_gpio_irq_ack(struct irq_data *d)
> +{
> +	struct bcm_cygnus_gpio *cygnus_gpio = irq_data_get_irq_chip_data(d);
> +	unsigned gpio = d->hwirq;
> +	unsigned int offset, shift;
> +	u32 val;
> +
> +	offset = __gpio_reg_offset(cygnus_gpio, gpio) +
> +		CYGNUS_GPIO_INT_CLR_OFFSET;
> +	shift = __gpio_bitpos(cygnus_gpio, gpio);
> +
> +	val = 1 << shift;
> +	writel(val, cygnus_gpio->base + offset);
> +
> +	dev_dbg(cygnus_gpio->dev, "gpio:%u offset:0x%04x shift:%u\n", gpio,
> +			offset, shift);
> +}

> +static struct irq_chip bcm_cygnus_gpio_irq_chip = {
> +	.name = "bcm-cygnus-gpio",
> +	.irq_ack = bcm_cygnus_gpio_irq_ack,
> +	.irq_mask = bcm_cygnus_gpio_irq_mask,
> +	.irq_unmask = bcm_cygnus_gpio_irq_unmask,
> +	.irq_set_type = bcm_cygnus_gpio_irq_set_type,
> +};

const?

> +static struct irq_domain_ops bcm_cygnus_irq_ops = {
> +	.map = bcm_cygnus_gpio_irq_map,
> +	.unmap = bcm_cygnus_gpio_irq_unmap,
> +	.xlate = irq_domain_xlate_twocell,
> +};

const here too?

> +#ifdef CONFIG_OF_GPIO
> +static void bcm_cygnus_gpio_set_pull(struct bcm_cygnus_gpio *cygnus_gpio,
> +		unsigned gpio, enum gpio_pull pull)
> +{
> +	unsigned int offset, shift;
> +	u32 val, up;

	bool up; ?

> +	unsigned long flags;
> +
> +	switch (pull) {
> +	case GPIO_PULL_NONE:
> +		return;
> +	case GPIO_PULL_UP:
> +		up = 1;
> +		break;
> +	case GPIO_PULL_DOWN:
> +		up = 0;
> +		break;
> +	case GPIO_PULL_INVALID:
> +	default:
> +		return;
> +	}

Maybe more sensible to group GPIO_PULL_NONE with GPIO_PULL_INVALID


> +static int bcm_cygnus_gpio_probe(struct platform_device *pdev)
> +{
[]
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "unable to get I/O resource");

missing newline


