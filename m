Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaH1PRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:17:30 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:9281
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751938AbaH1PR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:17:28 -0400
Date: Thu, 28 Aug 2014 10:11:56 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Weike Chen <alvin.chen@intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH 2/3] GPIO: gpio-dwapb: Support Debounce
In-Reply-To: <1409161588-19417-3-git-send-email-alvin.chen@intel.com>
Message-ID: <alpine.DEB.2.02.1408281007290.26299@atx-linux-37>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com> <1409161588-19417-3-git-send-email-alvin.chen@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0052.namprd08.prod.outlook.com (10.141.200.32) To
 DM2PR03MB318.namprd03.prod.outlook.com (10.141.54.17)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031763BCAF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(24454002)(51704005)(199003)(189002)(54356999)(105586002)(95666004)(76176999)(106356001)(42186005)(77096002)(99396002)(33716001)(15202345003)(53416004)(81156004)(46406003)(110136001)(107046002)(83506001)(15975445006)(80022001)(90102001)(101416001)(66066001)(74502001)(74662001)(50986999)(31966008)(64706001)(47776003)(20776003)(19580395003)(19580405001)(83322001)(69596002)(81342001)(81542001)(85306004)(21056001)(87976001)(102836001)(85852003)(83072002)(86152002)(4396001)(86362001)(92726001)(23726002)(575784001)(92566001)(77982001)(46102001)(50466002)(76482001)(79102001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB318;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Weike Chen wrote:

> This patch enables 'debounce' for the designware GPIO, and
> it is based on Josef Ahmad's previous work.
> 
> Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
> Reviewed-by: Shevchenko, Andriy <andriy.shevchenko@intel.com>
> Signed-off-by: Weike Chen <alvin.chen@intel.com>
> ---
>  drivers/gpio/gpio-dwapb.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> index 155a64b..e0ab988 100644
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
> @@ -64,6 +65,23 @@ struct dwapb_gpio {
>  	const struct dwapb_gpio_platform_data	*pdata;
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

Hello,

I don't understand the reason for adding dwapb_read and dwapb_write here.  
The rest of the driver is using readl and writel.  I'd rather not see two 
different methods being used in the same driver for register access.  
Maybe I'm missing something, but if we need to add dwapb_read/write, then
it should be used for all register access.

Alan

>  static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
>  {
>  	struct bgpio_chip *bgc = to_bgpio_chip(gc);
> @@ -209,6 +227,29 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
>  	return 0;
>  }
>  
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
> +	spin_unlock_irqrestore(&bgc->lock, flags);
> +
> +	return 0;
> +}
> +
>  static irqreturn_t dwapb_irq_handler_mfd(int irq, void *dev_id)
>  {
>  	struct irq_desc *desc = irq_to_desc(irq);
> @@ -342,6 +383,7 @@ static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
>  
>  	port->bgc.gc.ngpio = pp->ngpio;
>  	port->bgc.gc.base = pp->gpio_base;
> +	port->bgc.gc.set_debounce = dwapb_gpio_set_debounce;
>  
>  	/*
>  	 * Only port A can provide interrupts in all configurations of the IP.
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
