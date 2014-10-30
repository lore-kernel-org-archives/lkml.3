Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806AbaJ3NoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:44:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:35222 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468AbaJ3NoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:44:02 -0400
Date: Thu, 30 Oct 2014 14:43:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "pang.xunlei" <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        xen-devel@lists.xenproject.org, John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [RFC PATCH v2 02/11] time: Add mktime64() safe version(using
 time64_t)
In-Reply-To: <1414667745-7703-3-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1410301424510.5308@nanos>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org> <1414667745-7703-3-git-send-email-pang.xunlei@linaro.org>
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

Same problem with the $subject as in the previous patch.

> As part of addressing 2038 saftey for in-kernel uses, this patch

  s/saftey/safety/ 

  saftey is something completely different.
  
> +/* 
> + * Converts Gregorian date to seconds since 1970-01-01 00:00:00.
> + * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
> + * => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
> + *
> + * [For the Julian calendar (which was used in Russia before 1917,
> + * Britain & colonies before 1752, anywhere else before 1582,
> + * and is still in use by some communities) leave out the
> + * -year/100+year/400 terms, and add 10.]
> + *
> + * This algorithm was first published by Gauss (I think).
> + *

So this blindly copies the comment from mktime but misses to add a
proper docbook comment for the function.

> + * Safe version 2038 safety on 32-bit systems.

This sentence makes no sense at all. Aside of that you want to do the
same as I suggested for do_settimeofday64

* mktime64 - Convert gregrorian date to seconds since 1970. y2038 safe

> + */
> +time64_t
> +mktime64(const unsigned int year0, const unsigned int mon0,
> +       const unsigned int day, const unsigned int hour,
> +       const unsigned int min, const unsigned int sec)

Make this

time64_t mktime64(const unsigned int year0, const unsigned int mon0,
       	 	  const unsigned int day, const unsigned int hour,
       		  const unsigned int min, const unsigned int sec)

please.

> +{
> +	time64_t ret;
> +	unsigned int mon = mon0, year = year0;

I pretty much prefer the following style:

+	unsigned int mon = mon0, year = year0;
+	time64_t ret;

Way simpler to parse.


> +	 /* 1..12 -> 11,12,1..10 */
> +	if (0 >= (int) (mon -= 2)) {
> +		mon += 12;  /* Puts Feb last since it has leap day */

Please get rid of the tail comments while you are at it:

       	        /* Put Feb last since it has a leap day */
		mon += 12;

Again simpler to parse.

> +		year -= 1;
> +	}
> +
> +	ret = (year/4 - year/100 + year/400 + 367*mon/12 + day) + year*365 - 719499;

For readability sake

> +	ret = ret*24 + hour; /* now have hours */

Please kill these pointless comments. The calculation above is the one
which could do with a comment not the obvious days to hrs and hrs to
min and min to sec conversions.

We do not blindly copy code and leave the mess unchanged.

> +	ret = ret*60 + min; /* now have minutes */
> +	ret = ret*60 + sec; /* finally seconds */
> +
> +	return ret;
> +}
> +
> +EXPORT_SYMBOL(mktime64);

EXPORT_SYMBOL_GPL please.

> +
>  /* Converts Gregorian date to seconds since 1970-01-01 00:00:00.
>   * Assumes input in normal date format, i.e. 1980-12-31 23:59:59
>   * => year=1980, mon=12, day=31, hour=23, min=59, sec=59.
> @@ -318,6 +356,7 @@ EXPORT_SYMBOL(timespec_trunc);
>   * WARNING: this function will overflow on 2106-02-07 06:28:16 on
>   * machines where long is 32-bit! (However, as time_t is signed, we
>   * will already get problems at other places on 2038-01-19 03:14:08)
> + * TODO: [2038 safety] should be replaced by mktime64().
>   */
>  unsigned long
>  mktime(const unsigned int year0, const unsigned int mon0,

Why are you keeping this implementation instead of replacing the
comment by a simple one liner

/*
 * mktime - Convert gregrorian date to seconds since 1970. Deprecated. Use mktime64
 */

No need to add a full docbook comment as this is going away anyway.

and change the implementation to

{
	return mktime64(....);
}

Thanks,

	tglx
