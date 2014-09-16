Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaIPH37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:29:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:1423 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbaIPH3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:29:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,533,1406617200"; 
   d="scan'208";a="573703689"
Message-ID: <1410852405.7023.48.camel@linux.intel.com>
Subject: Re: [PATCH 4/4 v4] GPIO: gpio-dwapb: Suspend & Resume PM enabling
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Weike Chen <alvin.chen@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, atull <atull@opensource.altera.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Boon Leong Ong <boon.leong.ong@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Date: Tue, 16 Sep 2014 10:26:45 +0300
In-Reply-To: <1410859335-11080-5-git-send-email-alvin.chen@intel.com>
References: <1410859335-11080-1-git-send-email-alvin.chen@intel.com>
	 <1410859335-11080-5-git-send-email-alvin.chen@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 02:22 -0700, Weike Chen wrote:
> This patch enables suspend and resume mode for the power management, and
> it is based on Josef Ahmad's previous work.
> 

Few comments below.

> Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>

You still keep that guy as reviewer in a whole series, however I didn't
see a word from him here. How is it possible?

> Signed-off-by: Weike Chen <alvin.chen@intel.com>
> ---
>  drivers/gpio/gpio-dwapb.c |  109 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 109 insertions(+)
> 
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> index 9a76e3c..14d83af 100644
> --- a/drivers/gpio/gpio-dwapb.c
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -50,11 +50,14 @@
>  #define GPIO_SWPORT_DDR_SIZE	(GPIO_SWPORTB_DDR - GPIO_SWPORTA_DDR)
>  
>  struct dwapb_gpio;
> +struct dwapb_context;
>  
>  struct dwapb_gpio_port {
>  	struct bgpio_chip	bgc;
>  	bool			is_registered;
>  	struct dwapb_gpio	*gpio;
> +	struct dwapb_context	*ctx;
> +	unsigned int		idx;
>  };
>  
>  struct dwapb_gpio {
> @@ -377,6 +380,7 @@ static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
>  
>  	port = &gpio->ports[offs];
>  	port->gpio = gpio;
> +	port->idx = pp->idx;
>  
>  	dat = gpio->regs + GPIO_EXT_PORTA + (pp->idx * GPIO_EXT_PORT_SIZE);
>  	set = gpio->regs + GPIO_SWPORTA_DR + (pp->idx * GPIO_SWPORT_DR_SIZE);
> @@ -584,10 +588,115 @@ static const struct of_device_id dwapb_of_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, dwapb_of_match);
>  
> +#ifdef CONFIG_PM_SLEEP
> +/* Store GPIO context across system-wide suspend/resume transitions */
> +struct dwapb_context {
> +	u32 data;
> +	u32 dir;
> +	u32 ext;
> +	u32 int_en;
> +	u32 int_mask;
> +	u32 int_type;
> +	u32 int_pol;
> +	u32 int_deb;
> +};

> +
> +static int dwapb_gpio_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dwapb_gpio *gpio = platform_get_drvdata(pdev);
> +	struct bgpio_chip *bgc	= &gpio->ports[0].bgc;
> +	unsigned long flags;
> +	int i;
> +
> +	spin_lock_irqsave(&bgc->lock, flags);
> +	for (i = 0; i < gpio->nr_ports; i++) {
> +		unsigned int offset;
> +		unsigned int idx = gpio->ports[i].idx;
> +		struct dwapb_context *ctx = gpio->ports[i].ctx;
> +
> +		if (!ctx) {
> +			ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
> +			gpio->ports[i].ctx = ctx;
> +		}

I don't think it's a right place to allocate this resource, especially
with devm_ helper. Can you move this to probe() stage?

Or you even can embed contex structure inside chip one with #ifdef
CONFIG_PM_SLEEP.

Maybe others could comment on this.

> +
> +		offset = GPIO_SWPORTA_DDR + (idx * GPIO_SWPORT_DDR_SIZE);

No need to have parentheses here. Check the code below as well.

> +		ctx->dir = dwapb_read(gpio, offset);
> +
> +		offset = GPIO_SWPORTA_DR + (idx * GPIO_SWPORT_DR_SIZE);
> +		ctx->data = dwapb_read(gpio, offset);
> +
> +		offset = GPIO_EXT_PORTA + (idx * GPIO_EXT_PORT_SIZE);
> +		ctx->ext = dwapb_read(gpio, offset);
> +
> +		/* Only port A can provide interrupts */
> +		if (idx == 0) {
> +			ctx->int_mask	= dwapb_read(gpio, GPIO_INTMASK);
> +			ctx->int_en	= dwapb_read(gpio, GPIO_INTEN);
> +			ctx->int_pol	= dwapb_read(gpio, GPIO_INT_POLARITY);
> +			ctx->int_type	= dwapb_read(gpio, GPIO_INTTYPE_LEVEL);
> +			ctx->int_deb	= dwapb_read(gpio, GPIO_PORTA_DEBOUNCE);
> +
> +			/* Mask out interrupts */
> +			dwapb_write(gpio, GPIO_INTMASK, 0xffffffff);
> +		}
> +	}
> +	spin_unlock_irqrestore(&bgc->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int dwapb_gpio_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dwapb_gpio *gpio = platform_get_drvdata(pdev);
> +	struct bgpio_chip *bgc	= &gpio->ports[0].bgc;
> +	unsigned long flags;
> +	int i;
> +
> +	spin_lock_irqsave(&bgc->lock, flags);
> +	for (i = 0; i < gpio->nr_ports; i++) {
> +		unsigned int offset;
> +		unsigned int idx = gpio->ports[i].idx;
> +		struct dwapb_context *ctx = gpio->ports[i].ctx;
> +
> +		BUG_ON(ctx == 0);
> +
> +		offset = GPIO_SWPORTA_DR + (idx * GPIO_SWPORT_DR_SIZE);
> +		dwapb_write(gpio, offset, ctx->data);
> +
> +		offset = GPIO_SWPORTA_DDR + (idx * GPIO_SWPORT_DDR_SIZE);
> +		dwapb_write(gpio, offset, ctx->dir);
> +
> +		offset = GPIO_EXT_PORTA + (idx * GPIO_EXT_PORT_SIZE);
> +		dwapb_write(gpio, offset, ctx->ext);
> +
> +		/* Only port A can provide interrupts */
> +		if (idx == 0) {
> +			dwapb_write(gpio, GPIO_INTTYPE_LEVEL, ctx->int_type);
> +			dwapb_write(gpio, GPIO_INT_POLARITY, ctx->int_pol);
> +			dwapb_write(gpio, GPIO_PORTA_DEBOUNCE, ctx->int_deb);
> +			dwapb_write(gpio, GPIO_INTEN, ctx->int_en);
> +			dwapb_write(gpio, GPIO_INTMASK, ctx->int_mask);
> +
> +			/* Clear out spurious interrupts */
> +			dwapb_write(gpio, GPIO_PORTA_EOI, 0xffffffff);
> +		}
> +	}
> +	spin_unlock_irqrestore(&bgc->lock, flags);
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(dwapb_gpio_pm_ops, dwapb_gpio_suspend,
> +			 dwapb_gpio_resume);
> +
>  static struct platform_driver dwapb_gpio_driver = {
>  	.driver		= {
>  		.name	= "gpio-dwapb",
>  		.owner	= THIS_MODULE,
> +		.pm	= &dwapb_gpio_pm_ops,
>  		.of_match_table = of_match_ptr(dwapb_of_match),
>  	},
>  	.probe		= dwapb_gpio_probe,



-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

