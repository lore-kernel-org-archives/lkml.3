Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaH1PGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:06:51 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:40840
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750896AbaH1PGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:06:49 -0400
Date: Thu, 28 Aug 2014 10:01:02 -0500
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
Subject: Re: [PATCH 3/3] GPIO: gpio-dwapb: Suspend & Resume PM enabling
In-Reply-To: <1409161588-19417-4-git-send-email-alvin.chen@intel.com>
Message-ID: <alpine.DEB.2.02.1408280955560.26299@atx-linux-37>
References: <1409161588-19417-1-git-send-email-alvin.chen@intel.com> <1409161588-19417-4-git-send-email-alvin.chen@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR08CA0046.namprd08.prod.outlook.com (10.242.217.174) To
 BY2PR03MB316.namprd03.prod.outlook.com (10.141.139.26)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031763BCAF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(199003)(24454002)(189002)(51444003)(51704005)(46102001)(85306004)(23726002)(66066001)(80022001)(20776003)(64706001)(15202345003)(47776003)(33716001)(81542001)(4396001)(81342001)(54356999)(95666004)(90102001)(76176999)(50466002)(46406003)(81156004)(101416001)(50986999)(19580395003)(19580405001)(83322001)(107046002)(69596002)(102836001)(99396002)(105586002)(79102001)(53416004)(77982001)(74502001)(110136001)(31966008)(87976001)(575784001)(76482001)(86362001)(106356001)(74662001)(77096002)(21056001)(42186005)(85852003)(92726001)(83072002)(86152002)(92566001)(15975445006)(83506001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB316;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Weike Chen wrote:

> This patch enables suspend and resume mode for the power management, and
> it is based on Josef Ahmad's previous work.
> 
> Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>
> Reviewed-by: Shevchenko, Andriy <andriy.shevchenko@intel.com>
> Signed-off-by: Weike Chen <alvin.chen@intel.com>
> ---
>  drivers/gpio/gpio-dwapb.c |   67 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 67 insertions(+)
> 
> diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
> index e0ab988..1055cb3 100644
> --- a/drivers/gpio/gpio-dwapb.c
> +++ b/drivers/gpio/gpio-dwapb.c
> @@ -560,10 +560,77 @@ static const struct of_device_id dwapb_of_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, dwapb_of_match);
>  
> +#if defined CONFIG_PM_SLEEP
> +/* Store GPIO context across system-wide suspend/resume transitions */
> +static struct gpio_saved_regs {
> +	unsigned long data;
> +	unsigned long dir;
> +	unsigned long int_en;
> +	unsigned long int_mask;
> +	unsigned long int_type;
> +	unsigned long int_pol;
> +	unsigned long int_deb;
> +} saved_regs;
> +
> +static int dwapb_gpio_suspend(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dwapb_gpio *gpio = platform_get_drvdata(pdev);
> +	struct bgpio_chip *bgc	= &gpio->ports[0].bgc;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bgc->lock, flags);
> +
> +	saved_regs.int_mask	= dwapb_read(gpio, GPIO_INTMASK);
> +	saved_regs.int_en	= dwapb_read(gpio, GPIO_INTEN);
> +	saved_regs.int_deb	= dwapb_read(gpio, GPIO_PORTA_DEBOUNCE);
> +	saved_regs.int_pol	= dwapb_read(gpio, GPIO_INT_POLARITY);
> +	saved_regs.int_type	= dwapb_read(gpio, GPIO_INTTYPE_LEVEL);
> +	saved_regs.dir		= dwapb_read(gpio, GPIO_SWPORTA_DDR);
> +	saved_regs.data		= dwapb_read(gpio, GPIO_SWPORTA_DR);

Hello,

The DesignWare GPIO IP can be configured to have ports a, b, c, and d. So 
you will need to save and restore any ports that are present.  I think 
that *some* configurations of the IP include a register that can tell us 
how it was configured, but that register is also optional :)  I don't have 
confidence that we can read/write the registers blindly whether they are 
known to be there or not.  So you may be stuck with looking at the
device tree or platform data to know whether banks b, c, or d exist.

Alan

> +
> +	/* Mask out interrupts */
> +	dwapb_write(gpio, GPIO_INTMASK, 0xffffffff);
> +
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
> +
> +	spin_lock_irqsave(&bgc->lock, flags);
> +
> +	dwapb_write(gpio, GPIO_SWPORTA_DR, saved_regs.data);
> +	dwapb_write(gpio, GPIO_SWPORTA_DDR, saved_regs.dir);
> +	dwapb_write(gpio, GPIO_INTTYPE_LEVEL, saved_regs.int_type);
> +	dwapb_write(gpio, GPIO_INT_POLARITY, saved_regs.int_pol);
> +	dwapb_write(gpio, GPIO_PORTA_DEBOUNCE, saved_regs.int_deb);
> +	dwapb_write(gpio, GPIO_INTEN, saved_regs.int_en);
> +	dwapb_write(gpio, GPIO_INTMASK, saved_regs.int_mask);
> +
> +	/* Clear out spurious interrupts */
> +	dwapb_write(gpio, GPIO_PORTA_EOI, 0xffffffff);
> +
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
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
