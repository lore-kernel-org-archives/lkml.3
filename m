Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbaIWIb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:31:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:37134 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbaIWIbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:31:23 -0400
Message-ID: <54212FD7.6080209@atmel.com>
Date: Tue, 23 Sep 2014 10:31:19 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        "Samuel Ortiz" <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Johan Hovold <jhovold@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 5/9] rtc: at91sam9: make use of syscon/regmap to access
 GPBR registers
References: <1411400563-570-1-git-send-email-boris.brezillon@free-electrons.com> <1411400563-570-6-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1411400563-570-6-git-send-email-boris.brezillon@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/09/2014 17:42, Boris BREZILLON :
> The GPBR registers are not part of the RTT block and thus should not be
> defined in the reg property of the rtt node.
> 
> Use syscon to provide a proper DT representation and reference the GPBR
> syscon device in a new "atmel,rtt-rtc-time-reg" property which store both
> the syscon device phandle and the register offset within the GPBR block.
> 
> When using non DT boards, we won't be able to retrieve the syscon regmap,
> hence we need to create our own regmap using the memory region defined
> in the 2nd memory resource assigned to the RTT platform device.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/rtc/Kconfig        |  1 +
>  drivers/rtc/rtc-at91sam9.c | 64 +++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 56 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index a168e96..7d76da8 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -1081,6 +1081,7 @@ config RTC_DRV_AT91RM9200
>  config RTC_DRV_AT91SAM9
>  	tristate "AT91SAM9x/AT91CAP9 RTT as RTC"

BTW, while we are at it, can we remove mention of the CAP9 here ^^^

>  	depends on ARCH_AT91 && !(ARCH_AT91RM9200 || ARCH_AT91X40)
> +	select MFD_SYSCON
>  	help
>  	  RTC driver for the Atmel AT91SAM9x and AT91CAP9 internal RTT

And there ^^^ and refine the Kconfig "help" message which can be
confusing (not all SAM9's have this rtt or need for it). We can also
remove the explicit mention of 9rl and 9g45 as many other AT91 SoCs can
use the "real" RTC...

Thanks ;-)


>  	  (Real Time Timer). These timers are powered by the backup power
> diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
> index d72c34d..902cd01 100644
> --- a/drivers/rtc/rtc-at91sam9.c
> +++ b/drivers/rtc/rtc-at91sam9.c
> @@ -21,6 +21,8 @@
>  #include <linux/slab.h>
>  #include <linux/platform_data/atmel.h>
>  #include <linux/io.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
>  
>  /*
>   * This driver uses two configurable hardware resources that live in the
> @@ -72,7 +74,8 @@ struct sam9_rtc {
>  	void __iomem		*rtt;
>  	struct rtc_device	*rtcdev;
>  	u32			imr;
> -	void __iomem		*gpbr;
> +	struct regmap		*gpbr;
> +	unsigned int		gpbr_offset;
>  	int 			irq;
>  };
>  
> @@ -81,10 +84,19 @@ struct sam9_rtc {
>  #define rtt_writel(rtc, field, val) \
>  	writel((val), (rtc)->rtt + AT91_RTT_ ## field)
>  
> -#define gpbr_readl(rtc) \
> -	readl((rtc)->gpbr)
> -#define gpbr_writel(rtc, val) \
> -	writel((val), (rtc)->gpbr)
> +static inline unsigned int gpbr_readl(struct sam9_rtc *rtc)
> +{
> +	unsigned int val;
> +
> +	regmap_read(rtc->gpbr, rtc->gpbr_offset, &val);
> +
> +	return val;
> +}
> +
> +static inline void gpbr_writel(struct sam9_rtc *rtc, unsigned int val)
> +{
> +	regmap_write(rtc->gpbr, rtc->gpbr_offset, val);
> +}
>  
>  /*
>   * Read current time and date in RTC
> @@ -301,6 +313,12 @@ static const struct rtc_class_ops at91_rtc_ops = {
>  	.alarm_irq_enable = at91_rtc_alarm_irq_enable,
>  };
>  
> +static struct regmap_config gpbr_regmap_config = {
> +	.reg_bits = 32,
> +	.val_bits = 32,
> +	.reg_stride = 4,
> +};
> +
>  /*
>   * Initialize and install RTC driver
>   */
> @@ -334,10 +352,38 @@ static int at91_rtc_probe(struct platform_device *pdev)
>  	if (IS_ERR(rtc->rtt))
>  		return PTR_ERR(rtc->rtt);
>  
> -	r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	rtc->gpbr = devm_ioremap_resource(&pdev->dev, r);
> -	if (IS_ERR(rtc->gpbr))
> -		return PTR_ERR(rtc->rtt);
> +	if (!pdev->dev.of_node) {
> +		/*
> +		 * TODO: Remove this code chunk when when removing non DT
> +		 * board support. Remember to remove the gpbr_regmap_config
> +		 * variable too.

Thanks for having add this: very useful in the near future!

> +		 */
> +		void __iomem *gpbr;
> +
> +		r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +		gpbr = devm_ioremap_resource(&pdev->dev, r);
> +		if (IS_ERR(gpbr))
> +			return PTR_ERR(gpbr);
> +
> +		rtc->gpbr = regmap_init_mmio(NULL, gpbr,
> +					     &gpbr_regmap_config);
> +	} else {
> +		struct of_phandle_args args;
> +
> +		ret = of_parse_phandle_with_fixed_args(pdev->dev.of_node,
> +						"atmel,rtt-rtc-time-reg", 1, 0,
> +						&args);
> +		if (ret)
> +			return ret;
> +
> +		rtc->gpbr = syscon_node_to_regmap(args.np);
> +		rtc->gpbr_offset = args.args[0];
> +	}
> +
> +	if (IS_ERR(rtc->gpbr)) {
> +		dev_err(&pdev->dev, "failed to retrieve gpbr regmap, aborting.\n");
> +		return -ENOMEM;
> +	}
>  
>  	mr = rtt_readl(rtc, MR);
>  
> 

Okay: look pretty good: thanks for having handling this Boris!


Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Bye,

-- 
Nicolas Ferre
