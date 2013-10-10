Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab3JJWYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:24:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab3JJWYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:24:49 -0400
Date: Thu, 10 Oct 2013 15:24:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: <lee.jones@linaro.org>, <sameo@linux.intel.com>, <broonie@kernel.org>,
        <linus.walleij@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <rob.herring@calxeda.com>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <swarren@wwwdotorg.org>, <rob@landley.net>,
        <ijc+devicetree@hellion.org.uk>, <grant.likely@linaro.org>,
        Florian Lobmaier <florian.lobmaier@ams.com>
Subject: Re: [PATCH V5 3/3] drivers/rtc/rtc-as3722: add RTC driver
Message-Id: <20131010152446.1715e64b70ddd0281a3971e9@linux-foundation.org>
In-Reply-To: <1381321761-8898-4-git-send-email-ldewangan@nvidia.com>
References: <1381321761-8898-1-git-send-email-ldewangan@nvidia.com>
	<1381321761-8898-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Oct 2013 17:59:21 +0530 Laxman Dewangan <ldewangan@nvidia.com> wrote:

> The ams AS3722 is a compact system PMU suitable for mobile phones,
> tablets etc.
> 
> Add a driver to support accessing the RTC found on the ams AS3722
> PMIC using RTC framework.

I hate these patchsets, because ...

> index 9654aa3..d8785d7 100644
> --- a/drivers/rtc/Kconfig
> +++ b/drivers/rtc/Kconfig
> @@ -153,6 +153,16 @@ config RTC_DRV_88PM80X
>  	  This driver can also be built as a module. If so, the module
>  	  will be called rtc-88pm80x.
>  
> +config RTC_DRV_AS3722
> +	tristate "ams AS3722 RTC driver"
> +	depends on MFD_AS3722

... the rtc patch depends on an mfd patch, so everyone ends up sitting
around looking at everyone else, wondering who will merge it all.

> +	help
> +	  If you say yes here you get support for the RTC of ams AS3722 PMIC
> +	  chips.
> +
> +	  This driver can also be built as a module. If so, the module
> +	  will be called rtc-as3722.
> +
>
> ...
>
> +static int as3722_rtc_probe(struct platform_device *pdev)
> +{
> +	struct as3722 *as3722 = dev_get_drvdata(pdev->dev.parent);
> +	struct as3722_rtc *as3722_rtc;
> +	int val;
> +	int ret;
> +
> +	as3722_rtc = devm_kzalloc(&pdev->dev, sizeof(*as3722_rtc), GFP_KERNEL);
> +	if (!as3722_rtc)
> +		return -ENOMEM;
> +
> +	as3722_rtc->as3722 = as3722;
> +	as3722_rtc->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, as3722_rtc);
> +
> +	/* Enable the RTC to make sure it is running. */
> +	ret = as3722_update_bits(as3722, AS3722_RTC_CONTROL_REG,
> +				AS3722_RTC_ON, AS3722_RTC_ON);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "RTC_CONTROL reg update failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	val = AS3722_RTC_ON | AS3722_RTC_ALARM_WAKEUP_EN;
> +	ret = as3722_write(as3722, AS3722_RTC_CONTROL_REG, val);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "RTC_CONTROL reg write failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	device_init_wakeup(&pdev->dev, 1);
> +
> +	as3722_rtc->rtc = rtc_device_register("as3722", &pdev->dev,
> +				&as3722_rtc_ops, THIS_MODULE);

devm_rtc_device_register()?

> +	if (IS_ERR(as3722_rtc->rtc)) {
> +		ret = PTR_ERR(as3722_rtc->rtc);
> +		dev_err(&pdev->dev, "RTC register failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	as3722_rtc->alarm_irq = platform_get_irq(pdev, 0);
> +	dev_info(&pdev->dev, "RTC interrupt %d\n", as3722_rtc->alarm_irq);
> +
> +	ret = request_threaded_irq(as3722_rtc->alarm_irq, NULL,
> +			as3722_alarm_irq, IRQF_ONESHOT | IRQF_EARLY_RESUME,
> +			"rtc-alarm", as3722_rtc);

devm_request_threaded_irq()?

> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Failed to request alarm IRQ %d: %d\n",
> +				as3722_rtc->alarm_irq, ret);
> +		goto scrub;
> +	}
> +	disable_irq(as3722_rtc->alarm_irq);

It seems strange to disable your IRQ here.

> +	return 0;
> +scrub:
> +	rtc_device_unregister(as3722_rtc->rtc);
> +	return ret;
> +}

The function is a bit confused.  It uses a mix of the "returns
sprinkled all over the place" approach and the "goto out" approach. 
The latter is preferred.

> +static int as3722_rtc_remove(struct platform_device *pdev)
> +{
> +	struct as3722_rtc *as3722_rtc = platform_get_drvdata(pdev);
> +
> +	free_irq(as3722_rtc->alarm_irq, as3722_rtc);
> +	rtc_device_unregister(as3722_rtc->rtc);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM

Most (but not all!) rtc drivers use CONFIG_PM_SLEEP.  People have madly
mucked with CONFIG_PM* and I don't know the difference and I don't know
what's going on and I don't know of a convenient place to go to find
out.  If you work it out, please be sure to tell me!  But as soon as I
figure it out I'm sure they'll go and madly muck with it again.


