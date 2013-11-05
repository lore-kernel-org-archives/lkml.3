Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab3KEXcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:32:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab3KEXcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:32:13 -0500
Date: Tue, 5 Nov 2013 15:32:10 -0800
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
Subject: Re: [PATCH V6 3/3] drivers/rtc/rtc-as3722: add RTC driver
Message-Id: <20131105153210.e4c93cf589fbbe46fcd831c1@linux-foundation.org>
In-Reply-To: <1382356041-30973-1-git-send-email-ldewangan@nvidia.com>
References: <1382356041-30973-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Oct 2013 17:17:21 +0530 Laxman Dewangan <ldewangan@nvidia.com> wrote:

> The ams AS3722 is a compact system PMU suitable for mobile phones,
> tablets etc.
> 
> Add a driver to support accessing the RTC found on the ams AS3722
> PMIC using RTC framework.
> 
> ...
>
> +static int as3722_rtc_probe(struct platform_device *pdev)
> +{
> +	struct as3722 *as3722 = dev_get_drvdata(pdev->dev.parent);
> +	struct as3722_rtc *as3722_rtc;
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
> +			AS3722_RTC_ON | AS3722_RTC_ALARM_WAKEUP_EN,
> +			AS3722_RTC_ON | AS3722_RTC_ALARM_WAKEUP_EN);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "RTC_CONTROL reg write failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +	device_init_wakeup(&pdev->dev, 1);
> +
> +	as3722_rtc->rtc = rtc_device_register("as3722", &pdev->dev,
> +				&as3722_rtc_ops, THIS_MODULE);

Could use devm_rtc_device_register() here.

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

Why is this necessary?

Would it be safer to do this before the request_threaded_irq()?

> +	return 0;
> +scrub:
> +	rtc_device_unregister(as3722_rtc->rtc);
> +	return ret;
> +}
> +

