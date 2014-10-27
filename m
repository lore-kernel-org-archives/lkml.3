Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaJ0Wkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:40:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaJ0Wkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:40:31 -0400
Date: Mon, 27 Oct 2014 15:40:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?ISO-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Felipe Balbi <balbi@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Guenter Roeck <linux@roeck-us.net>, nsekhar@ti.com, t-kristo@ti.com,
        j-keerthy@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtc: omap: add support for pmic_power_en
Message-Id: <20141027154031.4492ea11d401045ca04a3ff8@linux-foundation.org>
In-Reply-To: <1414397368-26480-1-git-send-email-johan@kernel.org>
References: <1413913086-12730-1-git-send-email-johan@kernel.org>
	<1414397368-26480-1-git-send-email-johan@kernel.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014 09:09:28 +0100 Johan Hovold <johan@kernel.org> wrote:

> Add new property "ti,system-power-controller" to register the RTC as a
> power-off handler.
> 
> Some RTC IP revisions can control an external PMIC via the pmic_power_en
> pin, which can be configured to transition to OFF on ALARM2 events and
> back to ON on subsequent ALARM (wakealarm) events.
> 
> This is based on earlier work by Colin Foe-Parker and AnilKumar Ch. [1]
> 
> [1] https://www.mail-archive.com/linux-omap@vger.kernel.org/msg82127.html
> 
> Tested-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
> 
> Changes since v2:
>  - add two-second delay to allow alarm to trigger before returning

hmpf.  As this sentence is below the ^--- it doesn't get into the
changelog.

> ...
>
> +static void omap_rtc_power_off(void)
> +{
> +	struct omap_rtc *rtc = omap_rtc_power_off_rtc;
> +	struct rtc_time tm;
> +	unsigned long now;
> +	u32 val;
> +
> +	/* enable pmic_power_en control */
> +	val = rtc_readl(rtc, OMAP_RTC_PMIC_REG);
> +	rtc_writel(rtc, OMAP_RTC_PMIC_REG, val | OMAP_RTC_PMIC_POWER_EN_EN);
> +
> +	/* set alarm two seconds from now */
> +	omap_rtc_read_time_raw(rtc, &tm);
> +	bcd2tm(&tm);
> +	rtc_tm_to_time(&tm, &now);
> +	rtc_time_to_tm(now + 2, &tm);
> +
> +	if (tm2bcd(&tm) < 0) {
> +		dev_err(&rtc->rtc->dev, "power off failed\n");
> +		return;
> +	}
> +
> +	rtc_wait_not_busy(rtc);
> +
> +	rtc_write(rtc, OMAP_RTC_ALARM2_SECONDS_REG, tm.tm_sec);
> +	rtc_write(rtc, OMAP_RTC_ALARM2_MINUTES_REG, tm.tm_min);
> +	rtc_write(rtc, OMAP_RTC_ALARM2_HOURS_REG, tm.tm_hour);
> +	rtc_write(rtc, OMAP_RTC_ALARM2_DAYS_REG, tm.tm_mday);
> +	rtc_write(rtc, OMAP_RTC_ALARM2_MONTHS_REG, tm.tm_mon);
> +	rtc_write(rtc, OMAP_RTC_ALARM2_YEARS_REG, tm.tm_year);
> +
> +	/*
> +	 * enable ALARM2 interrupt
> +	 *
> +	 * NOTE: this fails on AM3352 if rtc_write (writeb) is used
> +	 */
> +	val = rtc_read(rtc, OMAP_RTC_INTERRUPTS_REG);
> +	rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG,
> +			val | OMAP_RTC_INTERRUPTS_IT_ALARM2);
> +
> +	mdelay(2000);

And it is uncommented.

How on earth is a reader to know why this is here?

I can do this

--- a/drivers/rtc/rtc-omap.c~rtc-omap-add-support-for-pmic_power_en-v3-fix
+++ a/drivers/rtc/rtc-omap.c
@@ -417,6 +417,7 @@ static void omap_rtc_power_off(void)
 	rtc_writel(rtc, OMAP_RTC_INTERRUPTS_REG,
 			val | OMAP_RTC_INTERRUPTS_IT_ALARM2);
 
+	/* Allow alarm to trigger before returning */
 	mdelay(2000);
 }
 


But it doesn't explain *why* we want the alarm to trigger before
returning.

