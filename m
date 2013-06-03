Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075Ab3FCXNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 19:13:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab3FCXNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 19:13:04 -0400
Date: Mon, 3 Jun 2013 16:13:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: rtc-linux@googlegroups.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] rtc: rtc-twl: ensure IRQ is wakeup enabled
Message-Id: <20130603161303.55e9da049744656541e9048f@linux-foundation.org>
In-Reply-To: <1370039827-25033-1-git-send-email-khilman@linaro.org>
References: <1370039827-25033-1-git-send-email-khilman@linaro.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013 15:37:07 -0700 Kevin Hilman <khilman@linaro.org> wrote:

> Currently, the RTC IRQ is never wakeup-enabled so is not capable of
> bringing the system out of suspend.
> 
> On OMAP platforms, we have gotten by without this because the TWL RTC
> is on an I2C-connected chip which is capable of waking up the OMAP via
> the IO ring when the OMAP is in low-power states.
> 
> However, if the OMAP suspends without hitting the low-power states
> (and the IO ring is not enabled), RTC wakeups will not work because
> the IRQ is not wakeup enabled.
> 
> To fix, ensure the RTC IRQ is wakeup enabled whenever the RTC alarm is
> set.
> 
> --- a/drivers/rtc/rtc-twl.c
> +++ b/drivers/rtc/rtc-twl.c
> @@ -213,12 +213,24 @@ static int mask_rtc_irq_bit(unsigned char bit)
>  
>  static int twl_rtc_alarm_irq_enable(struct device *dev, unsigned enabled)
>  {
> +	struct platform_device *pdev = to_platform_device(dev);
> +	int irq = platform_get_irq(pdev, 0);
> +	static bool twl_rtc_wake_enabled;
>  	int ret;
>  
> -	if (enabled)
> +	if (enabled) {
>  		ret = set_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
> -	else
> +		if (device_can_wakeup(dev) && !twl_rtc_wake_enabled) {
> +			enable_irq_wake(irq);
> +			twl_rtc_wake_enabled = true;
> +		}
> +	} else {
>  		ret = mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
> +		if (twl_rtc_wake_enabled) {
> +			disable_irq_wake(irq);
> +			twl_rtc_wake_enabled = false;
> +		}
> +	}

Why do we need this (slightly racy) logic with twl_rtc_wake_enabled? 
Other drivers don't do this.

Should we test device_may_wakeup() befre running disable_irq_wake()? 
Most drivers seem to do this, but it's all a bit foggy.

