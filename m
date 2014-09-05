Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbaIEJYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:24:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:63007 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbaIEJYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:24:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,471,1406617200"; 
   d="scan'208";a="568779929"
From: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
To: "Chen, Alvin" <alvin.chen@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "sebastian@breakpoint.cc" <sebastian@breakpoint.cc>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "dvhart@linux.intel.com" <dvhart@linux.intel.com>,
        "atull@opensource.altera.com" <atull@opensource.altera.com>
Subject: Re: [PATCH 2/3 v2] GPIO: gpio-dwapb: Support Debounce
Thread-Topic: [PATCH 2/3 v2] GPIO: gpio-dwapb: Support Debounce
Thread-Index: AQHPyNcp8n6awOMU40SWtvGXv+WZgZvyM52A
Date: Fri, 5 Sep 2014 09:23:19 +0000
Message-ID: <1409908999.30155.85.camel@intel.com>
References: <1409928798-31895-1-git-send-email-alvin.chen@intel.com>
	 <1409928798-31895-3-git-send-email-alvin.chen@intel.com>
In-Reply-To: <1409928798-31895-3-git-send-email-alvin.chen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.168]
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C922FB006FE914981ECEA44D67094E8@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s859Opj1015976

On Fri, 2014-09-05 at 07:53 -0700, Weike Chen wrote:
> This patch enables 'debounce' for the designware GPIO, and
> it is based on Josef Ahmad's previous work.

Can we split dwapb_read/write introducing and changing from this patch
to a separate one?


> Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
> Reviewed-by: Shevchenko, Andriy <andriy.shevchenko@intel.com>


> Signed-off-by: Weike Chen <alvin.chen@intel.com>
> ---
>  drivers/gpio/gpio-dwapb.c |   62 +++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 52 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> index f2264a2..6db7501 100644
> --- a/drivers/gpio/gpio-dwapb.c
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -36,6 +36,7 @@
>  #define GPIO_INTTYPE_LEVEL	0x38
>  #define GPIO_INT_POLARITY	0x3c
>  #define GPIO_INTSTATUS		0x40
> +#define GPIO_PORTA_DEBOUNCE	0x48
>  #define GPIO_PORTA_EOI		0x4c
>  #define GPIO_EXT_PORTA		0x50
>  #define GPIO_EXT_PORTB		0x54
> @@ -63,6 +64,23 @@ struct dwapb_gpio {
>  	struct irq_domain	*domain;
>  };
>  
> +static inline u32 dwapb_read(struct dwapb_gpio *gpio, unsigned int offset)
> +{
> +	struct bgpio_chip *bgc	= &gpio->ports[0].bgc;
> +	void __iomem *reg_base	= gpio->regs;
> +
> +	return bgc->read_reg(reg_base + offset);
> +}
> +
> +static inline void dwapb_write(struct dwapb_gpio *gpio, unsigned int offset,
> +			       u32 val)
> +{
> +	struct bgpio_chip *bgc	= &gpio->ports[0].bgc;
> +	void __iomem *reg_base	= gpio->regs;
> +
> +	bgc->write_reg(reg_base + offset, val);
> +}
> +
>  static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
>  {
>  	struct bgpio_chip *bgc = to_bgpio_chip(gc);
> @@ -75,14 +93,14 @@ static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
>  
>  static void dwapb_toggle_trigger(struct dwapb_gpio *gpio, unsigned int offs)
>  {
> -	u32 v = readl(gpio->regs + GPIO_INT_POLARITY);
> +	u32 v = dwapb_read(gpio, GPIO_INT_POLARITY);
>  
>  	if (gpio_get_value(gpio->ports[0].bgc.gc.base + offs))
>  		v &= ~BIT(offs);
>  	else
>  		v |= BIT(offs);
>  
> -	writel(v, gpio->regs + GPIO_INT_POLARITY);
> +	dwapb_write(gpio, GPIO_INT_POLARITY, v);
>  }
>  
>  static u32 _dwapb_irq_handler(struct dwapb_gpio *gpio)
> @@ -125,9 +143,9 @@ static void dwapb_irq_enable(struct irq_data *d)
>  	u32 val;
>  
>  	spin_lock_irqsave(&bgc->lock, flags);
> -	val = readl(gpio->regs + GPIO_INTEN);
> +	val = dwapb_read(gpio, GPIO_INTEN);
>  	val |= BIT(d->hwirq);
> -	writel(val, gpio->regs + GPIO_INTEN);
> +	dwapb_write(gpio, GPIO_INTEN, val);
>  	spin_unlock_irqrestore(&bgc->lock, flags);
>  }
>  
> @@ -140,9 +158,9 @@ static void dwapb_irq_disable(struct irq_data *d)
>  	u32 val;
>  
>  	spin_lock_irqsave(&bgc->lock, flags);
> -	val = readl(gpio->regs + GPIO_INTEN);
> +	val = dwapb_read(gpio, GPIO_INTEN);
>  	val &= ~BIT(d->hwirq);
> -	writel(val, gpio->regs + GPIO_INTEN);
> +	dwapb_write(gpio, GPIO_INTEN, val);
>  	spin_unlock_irqrestore(&bgc->lock, flags);
>  }
>  
> @@ -182,8 +200,8 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
>  		return -EINVAL;
>  
>  	spin_lock_irqsave(&bgc->lock, flags);
> -	level = readl(gpio->regs + GPIO_INTTYPE_LEVEL);
> -	polarity = readl(gpio->regs + GPIO_INT_POLARITY);
> +	level = dwapb_read(gpio, GPIO_INTTYPE_LEVEL);
> +	polarity = dwapb_read(gpio, GPIO_INT_POLARITY);
>  
>  	switch (type) {
>  	case IRQ_TYPE_EDGE_BOTH:
> @@ -210,8 +228,31 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
>  
>  	irq_setup_alt_chip(d, type);
>  
> -	writel(level, gpio->regs + GPIO_INTTYPE_LEVEL);
> -	writel(polarity, gpio->regs + GPIO_INT_POLARITY);
> +	dwapb_write(gpio, GPIO_INTTYPE_LEVEL, level);
> +	dwapb_write(gpio, GPIO_INT_POLARITY, polarity);
> +	spin_unlock_irqrestore(&bgc->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int dwapb_gpio_set_debounce(struct gpio_chip *gc,
> +				   unsigned offset, unsigned debounce)
> +{
> +	struct bgpio_chip *bgc = to_bgpio_chip(gc);
> +	struct dwapb_gpio_port *port =
> +			container_of(bgc, struct dwapb_gpio_port, bgc);
> +	struct dwapb_gpio *gpio = port->gpio;
> +	unsigned long flags, val_deb;
> +	unsigned long mask = bgc->pin2mask(bgc, offset);
> +
> +	spin_lock_irqsave(&bgc->lock, flags);
> +
> +	val_deb = dwapb_read(gpio, GPIO_PORTA_DEBOUNCE);
> +	if (debounce)
> +		dwapb_write(gpio, GPIO_PORTA_DEBOUNCE, mask | val_deb);
> +	else
> +		dwapb_write(gpio, GPIO_PORTA_DEBOUNCE, ~mask & val_deb);
> +
>  	spin_unlock_irqrestore(&bgc->lock, flags);
>  
>  	return 0;
> @@ -354,6 +395,7 @@ static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
>  #endif
>  	port->bgc.gc.ngpio = pp->ngpio;
>  	port->bgc.gc.base = pp->gpio_base;
> +	port->bgc.gc.set_debounce = dwapb_gpio_set_debounce;
>  
>  	if (pp->irq)
>  		dwapb_configure_irqs(gpio, port, pp);


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
