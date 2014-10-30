Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbaJ3OHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:07:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:35416 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758480AbaJ3OHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:07:05 -0400
Date: Thu, 30 Oct 2014 15:07:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "pang.xunlei" <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        xen-devel@lists.xenproject.org, John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [RFC PATCH v2 04/11] time: Add rtc_time_to_tm64() safe version(using
 time64_t)
In-Reply-To: <1414667745-7703-5-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1410301455380.5308@nanos>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org> <1414667745-7703-5-git-send-email-pang.xunlei@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, pang.xunlei wrote:

As you can guess already: $subject sucks.

> +
>  /*
>   * Convert seconds since 01-01-1970 00:00:00 to Gregorian date.
> + * Safe version for 2038 safety.

See previous replies.

>   */
> -void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
> +void rtc_time_to_tm64(time64_t time, struct rtc_time *tm)

What's tm64? 

This function is converting time64 to rtc_time. So the proper function
name is: rtc_time64_to_tm

Can you see the difference?

>  {
>  	unsigned int month, year;
>  	int days;
>  
> -	days = time / 86400;
> +	days = div_s64(time, 86400);
>  	time -= (unsigned int) days * 86400;
>  
>  	/* day of the week, 1970-01-01 was a Thursday */
> @@ -81,13 +83,23 @@ void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
>  	tm->tm_mon = month;
>  	tm->tm_mday = days + 1;
>  
> -	tm->tm_hour = time / 3600;
> +	tm->tm_hour = div_s64(time, 3600);

We already adjusted time to a value which is less than 24 * 3600,
i.e. it fits nicely into a long on 32bit. So we can avoid the whole
div_s64 business and simply do:

	unsigned int month, year;
+	unsigned long secs;
	int days;

-	days = time / 86400;
- 	time -= (unsigned int) days * 86400;
+	days = div_s64(time, 86400);
+	secs = time - (unsigned int) days * 86400;

And change the rest which uses time to:

-	tm->tm_hour = time / 3600;
+	tm->tm_hour = secs / 3600;

Sigh.

	tglx
