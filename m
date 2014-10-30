Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbaJ3NzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:55:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:35290 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423AbaJ3NzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:55:17 -0400
Date: Thu, 30 Oct 2014 14:55:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "pang.xunlei" <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        xen-devel@lists.xenproject.org, John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [RFC PATCH v2 03/11] time: Add rtc_tm_to_time64() safe version(using
 time64_t)
In-Reply-To: <1414667745-7703-4-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1410301444100.5308@nanos>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org> <1414667745-7703-4-git-send-email-pang.xunlei@linaro.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, pang.xunlei wrote:

Same $subject issue.

> As part of addressing 2038 saftey for in-kernel uses, this patch
> adds safe rtc_tm_to_time64() using time64_t. After this patch,
> rtc_tm_to_time() should be replaced by rtc_tm_to_time64() one by
> one. Eventually, rtc_tm_to_time() will be removed from the kernel
> when it has no users.
> 
> Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
> ---
>  drivers/rtc/rtc-lib.c |   15 ++++++++++++++-
>  include/linux/rtc.h   |    1 +
>  2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
> index c4cf057..6948cbd 100644
> --- a/drivers/rtc/rtc-lib.c
> +++ b/drivers/rtc/rtc-lib.c
> @@ -110,10 +110,23 @@ EXPORT_SYMBOL(rtc_valid_tm);
>  
>  /*
>   * Convert Gregorian date to seconds since 01-01-1970 00:00:00.
> + * Safe version for 2038 safety.

Docbook comment missing. See the previous replies.

> + */
> +int rtc_tm_to_time64(struct rtc_time *tm, time64_t *time)

What's the point of the return value? Just because rtc_tm_to_time()
has one? 

Yes it does, but that does not mean that we blindly copy the existing
nonsense when we implement a replacement interface.

What's wrong with changing it to:

time64_t rtc_tm_to_time64(struct rtc_time *tm)
{
	return mktime64(......);
}

> +/*
> + * Convert Gregorian date to seconds since 01-01-1970 00:00:00.
> + * TODO: [2038 safety] should be replaced by rtc_tm_to_time64.

Groan.

>   */
>  int rtc_tm_to_time(struct rtc_time *tm, unsigned long *time)
>  {
> -       *time = mktime(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
> +       *time = (unsigned long) mktime64(tm->tm_year + 1900, tm->tm_mon + 1, tm->tm_mday,
>                         tm->tm_hour, tm->tm_min, tm->tm_sec);

And that would become

    	 *time = rtc_time_to_time64(tm);

>         return 0;
>  }

Please stop doing purely mechanical changes. Just blindly copying
stuff and make it take time64_t instead of unsigned long can be done
with a script as well.

Thanks,

	tglx
