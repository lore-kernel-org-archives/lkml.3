Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaIKRmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:42:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48900 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751306AbaIKRmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:42:13 -0400
Date: Thu, 11 Sep 2014 19:42:09 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Johan Hovold <jhovold@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/9] rtc: at91sam9: make use of syscon/regmap to
 access GPBR registers
Message-ID: <20140911174209.GE3131@piout.net>
References: <1410441525-25258-6-git-send-email-boris.brezillon@free-electrons.com>
 <1410443588-9092-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410443588-9092-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 at 15:53:08 +0200, Boris Brezillon wrote :
> The GPBR registers are not part of the RTT block and thus should not be
> defined in the reg property of the rtt node.
> 
> Use syscon to provide a proper DT representation and reference the GPBR
> syscon device in a new "atmel,time-reg" property which store both the
> syscon device phandle and the register offset within the GPBR block.
> 
> When using non DT boards, we won't be able to retrieve the syscon regmap,
> hence we need to create our own regmap using the memory region defined
> in the 2nd memory resource assigned to the RTT platform device.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/rtc/Kconfig        |  1 +
>  drivers/rtc/rtc-at91sam9.c | 59 +++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 51 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
> index a168e96..7d76da8 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -1081,6 +1081,7 @@ config RTC_DRV_AT91RM9200
>  config RTC_DRV_AT91SAM9
>  	tristate "AT91SAM9x/AT91CAP9 RTT as RTC"
>  	depends on ARCH_AT91 && !(ARCH_AT91RM9200 || ARCH_AT91X40)
> +	select MFD_SYSCON
>  	help
>  	  RTC driver for the Atmel AT91SAM9x and AT91CAP9 internal RTT
>  	  (Real Time Timer). These timers are powered by the backup power
> diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
> index d72c34d..944e317 100644
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
> @@ -334,10 +352,33 @@ static int at91_rtc_probe(struct platform_device *pdev)
>  	if (IS_ERR(rtc->rtt))
>  		return PTR_ERR(rtc->rtt);
>  
> -	r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	rtc->gpbr = devm_ioremap_resource(&pdev->dev, r);
> -	if (IS_ERR(rtc->gpbr))
> -		return PTR_ERR(rtc->rtt);
> +	if (!pdev->dev.of_node) {
> +		void __iomem *gpbr;
> +
> +		r = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +		gpbr = devm_ioremap_resource(&pdev->dev, r);
> +		if (IS_ERR(gpbr))
> +			return PTR_ERR(gpbr);
> +

Maybe you could add a comment here as this is soon to be dead code.

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
> -- 
> 1.9.1
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
