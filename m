Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaIPH34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:29:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:16618 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbaIPH3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:29:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,533,1406617200"; 
   d="scan'208";a="477798043"
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
        "arnd@arndb.de" <arnd@arndb.de>,
        "atull@opensource.altera.com" <atull@opensource.altera.com>
Subject: Re: [PATCH 4/4 v4] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Topic: [PATCH 4/4 v4] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Index: AQHP0U23/+uxq9SP7kqT9UolCDPFE5wDS0OA
Date: Tue, 16 Sep 2014 07:24:57 +0000
Message-ID: <1410852297.7023.46.camel@intel.com>
References: <1410859335-11080-1-git-send-email-alvin.chen@intel.com>
	 <1410859335-11080-5-git-send-email-alvin.chen@intel.com>
In-Reply-To: <1410859335-11080-5-git-send-email-alvin.chen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.168]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A53B6F9743788A468B1B9A594C0BB768@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8G7VIY5025728

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
