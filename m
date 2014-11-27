Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751088AbaK0XCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:02:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:59192 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaK0XCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:02:49 -0500
Date: Fri, 28 Nov 2014 00:02:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xunlei Pang <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Sven Schnelle <svens@stackframe.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [RFC PATCH 1/4] rtc/mxc: Convert get_alarm_or_time()/set_alarm_or_time()
 to use time64_t
In-Reply-To: <1417089760-26848-2-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1411272350190.3961@nanos>
References: <1417089760-26848-1-git-send-email-pang.xunlei@linaro.org> <1417089760-26848-2-git-send-email-pang.xunlei@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014, Xunlei Pang wrote:
> We want to convert y2038 unsafe rtc_class_ops.set_mmss() and all its
> users to use time64_t. mxc_rtc_set_mmss() in "mxc" driver is one of
> its users, but it uses get_alarm_or_time()/set_alarm_or_time() internal
> interfaces which are also y2038 unsafe.
> 
> So here as a separate patch, it converts these two internal interfaces
> of "mxc" to use safe time64_t first, so as to make some preparations
> for the rtc_class_ops.set_mmss() conversion.
> 
> Currently, "mxc" is the only driver with such issue.

Well. The driver has some more issues and again you are just blindly
following your y2038 agenda instead of looking what this stuff is
actually doing.
 
> -static u32 get_alarm_or_time(struct device *dev, int time_alarm)
> +static time64_t get_alarm_or_time(struct device *dev, int time_alarm)
>  {
>  	struct platform_device *pdev = to_platform_device(dev);
>  	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
> @@ -129,29 +129,28 @@ static u32 get_alarm_or_time(struct device *dev, int time_alarm)
>  	hr = hr_min >> 8;
>  	min = hr_min & 0xff;
>  
> -	return (((day * 24 + hr) * 60) + min) * 60 + sec;
> +	return ((((time64_t)day * 24 + hr) * 60) + min) * 60 + sec;

So why does this convert a split representation, which could be easily
represented in a struct rtc_time to time64t?

Now looking at the usage sites:

>  static int rtc_update_alarm(struct device *dev, struct rtc_time *alrm)
>  {
>  	struct rtc_time alarm_tm, now_tm;
> -	unsigned long now, time;
> +	time64_t now, time;
>  	struct platform_device *pdev = to_platform_device(dev);
>  	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
>  	void __iomem *ioaddr = pdata->ioaddr;
>  
>  	now = get_alarm_or_time(dev, MXC_RTC_TIME);
> -	rtc_time_to_tm(now, &now_tm);
> +	rtc_time64_to_tm(now, &now_tm);

So here you convert that to struct rtc_time.

>  	alarm_tm.tm_year = now_tm.tm_year;
>  	alarm_tm.tm_mon = now_tm.tm_mon;
>  	alarm_tm.tm_mday = now_tm.tm_mday;
>  	alarm_tm.tm_hour = alrm->tm_hour;
>  	alarm_tm.tm_min = alrm->tm_min;
>  	alarm_tm.tm_sec = alrm->tm_sec;
> -	rtc_tm_to_time(&alarm_tm, &time);
> +	time = rtc_tm_to_time64(&alarm_tm);

Just to convert it back and then do the reverse operation in
set_alarm_or_time()
  
>  static int mxc_rtc_read_time(struct device *dev, struct rtc_time *tm)
>  {
> -	u32 val;
> +	time64_t val;
>  
>  	/* Avoid roll-over from reading the different registers */
>  	do {
>  		val = get_alarm_or_time(dev, MXC_RTC_TIME);
>  	} while (val != get_alarm_or_time(dev, MXC_RTC_TIME));
>  
> -	rtc_time_to_tm(val, tm);
> +	rtc_time64_to_tm(val, tm);

Ditto
 
>  	return 0;
>  }
> @@ -333,7 +332,7 @@ static int mxc_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>  	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
>  	void __iomem *ioaddr = pdata->ioaddr;
>  
> -	rtc_time_to_tm(get_alarm_or_time(dev, MXC_RTC_ALARM), &alrm->time);
> +	rtc_time64_to_tm(get_alarm_or_time(dev, MXC_RTC_ALARM), &alrm->time);

Ditto.

Makes a lot of sense? NOT

I did not have to look at the actual code to notice that
nonsense. Looking at the patch was enough.

Can you folks please stop to run shell scripts without looking at the
actual code?

This mechanical attempt to fix the 2038 issue w/o switching on
braincells is just annoying as hell. Dammit, if you touch stuff then
you better look at it and fix it proper instead of copying the same
crap over and over.

Thanks,

	tglx

