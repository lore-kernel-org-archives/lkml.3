Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594AbaIEJ0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:26:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:22810 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909AbaIEJ0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:26:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,471,1406617200"; 
   d="scan'208";a="568780481"
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
Subject: Re: [PATCH 3/3 v2] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Topic: [PATCH 3/3 v2] GPIO: gpio-dwapb: Suspend & Resume PM enabling
Thread-Index: AQHPyNcp/ZRAVyzApUOJPkFrjH7HF5vyNAAA
Date: Fri, 5 Sep 2014 09:24:42 +0000
Message-ID: <1409909082.30155.86.camel@intel.com>
References: <1409928798-31895-1-git-send-email-alvin.chen@intel.com>
	 <1409928798-31895-4-git-send-email-alvin.chen@intel.com>
In-Reply-To: <1409928798-31895-4-git-send-email-alvin.chen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.168]
Content-Type: text/plain; charset="utf-8"
Content-ID: <19A51FCC913AFA45A7583E8A1C64529D@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s859QswV015992

On Fri, 2014-09-05 at 07:53 -0700, Weike Chen wrote:
> This patch enables suspend and resume mode for the power management, and
> it is based on Josef Ahmad's previous work.
> 
> Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
> Reviewed-by: Shevchenko, Andriy <andriy.shevchenko@intel.com>

I have to recall my reviwed-by tag since patch is quite changed and as I
understood Linus is continuing to be changed.

> Signed-off-by: Weike Chen <alvin.chen@intel.com>
> ---
>  drivers/gpio/gpio-dwapb.c |  102 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 102 insertions(+)
> 
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> index 6db7501..a103def 100644
> --- a/drivers/gpio/gpio-dwapb.c
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -54,6 +54,7 @@ struct dwapb_gpio_port {
>  	struct bgpio_chip	bgc;
>  	bool			is_registered;
>  	struct dwapb_gpio	*gpio;
> +	unsigned int		idx;
>  };
>  
>  struct dwapb_gpio {
> @@ -376,6 +377,7 @@ static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
>  
>  	port = &gpio->ports[offs];
>  	port->gpio = gpio;
> +	port->idx = pp->idx;
>  
>  	dat = gpio->regs + GPIO_EXT_PORTA + (pp->idx * GPIO_EXT_PORT_SIZE);
>  	set = gpio->regs + GPIO_SWPORTA_DR + (pp->idx * GPIO_SWPORT_DR_SIZE);
> @@ -594,10 +596,110 @@ static const struct of_device_id dwapb_of_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, dwapb_of_match);
>  
> +#ifdef CONFIG_PM_SLEEP
> +/* Store GPIO context across system-wide suspend/resume transitions */
> +static struct dwapb_context {
> +	u32 data[DWAPB_MAX_PORTS];
> +	u32 dir[DWAPB_MAX_PORTS];
> +	u32 ext[DWAPB_MAX_PORTS];
> +	u32 int_en;
> +	u32 int_mask;
> +	u32 int_type;
> +	u32 int_pol;
> +	u32 int_deb;
> +} dwapb_context;
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
> +
> +		offset = GPIO_SWPORTA_DDR + (idx * GPIO_SWPORT_DDR_SIZE);
> +		dwapb_context.dir[i]	= dwapb_read(gpio, offset);
> +
> +		offset = GPIO_SWPORTA_DR + (idx * GPIO_SWPORT_DR_SIZE);
> +		dwapb_context.data[i]	= dwapb_read(gpio, offset);
> +
> +		offset = GPIO_EXT_PORTA + (idx * GPIO_EXT_PORT_SIZE);
> +		dwapb_context.ext[i]	= dwapb_read(gpio, offset);
> +
> +		if (idx == 0) {
> +			dwapb_context.int_mask = dwapb_read(gpio, GPIO_INTMASK);
> +			dwapb_context.int_en = dwapb_read(gpio, GPIO_INTEN);
> +			dwapb_context.int_pol =
> +					dwapb_read(gpio, GPIO_INT_POLARITY);
> +			dwapb_context.int_type =
> +					dwapb_read(gpio, GPIO_INTTYPE_LEVEL);
> +			dwapb_context.int_deb =
> +					dwapb_read(gpio, GPIO_PORTA_DEBOUNCE);
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
> +
> +		offset = GPIO_SWPORTA_DR + (idx * GPIO_SWPORT_DR_SIZE);
> +		dwapb_write(gpio, offset, dwapb_context.data[i]);
> +
> +		offset = GPIO_SWPORTA_DDR + (idx * GPIO_SWPORT_DDR_SIZE);
> +		dwapb_write(gpio, offset, dwapb_context.dir[i]);
> +
> +		offset = GPIO_EXT_PORTA + (idx * GPIO_EXT_PORT_SIZE);
> +		dwapb_write(gpio, offset, dwapb_context.ext[i]);
> +
> +		if (idx == 0) {
> +			dwapb_write(gpio, GPIO_INTTYPE_LEVEL,
> +				    dwapb_context.int_type);
> +			dwapb_write(gpio, GPIO_INT_POLARITY,
> +				    dwapb_context.int_pol);
> +			dwapb_write(gpio, GPIO_PORTA_DEBOUNCE,
> +				    dwapb_context.int_deb);
> +			dwapb_write(gpio, GPIO_INTEN, dwapb_context.int_en);
> +			dwapb_write(gpio, GPIO_INTMASK, dwapb_context.int_mask);
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
