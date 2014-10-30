Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbaJ3NYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:24:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:35115 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727AbaJ3NYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:24:47 -0400
Date: Thu, 30 Oct 2014 14:24:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "pang.xunlei" <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        xen-devel@lists.xenproject.org, John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [RFC PATCH v2 01/11] time: Add do_settimeofday64() safe
 version(using timespec64)
In-Reply-To: <1414667745-7703-2-git-send-email-pang.xunlei@linaro.org>
Message-ID: <alpine.DEB.2.11.1410301411290.5308@nanos>
References: <1414667745-7703-1-git-send-email-pang.xunlei@linaro.org> <1414667745-7703-2-git-send-email-pang.xunlei@linaro.org>
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

Your subject line

> time: Add do_settimeofday64() safe version(using timespec64)

is confusing at best.

time: Provide y2038 safe do_settimeofday() replacement

That explains what the patch is doing in a very precice way.

>  /**
> - * do_settimeofday - Sets the time of day
> - * @tv:		pointer to the timespec variable containing the new time
> + * do_settimeofday64 - Sets the time of day
> + * @ts:     pointer to the timespec64 variable containing the new time
>   *
>   * Sets the time of day to the new time and update NTP and notify hrtimers
> + * Safe version for 2038 safety.

I rather put this into the function description above:

+ * do_settimeofday64 - Sets the time of day. 2038 safe.

Way simpler to grep for.

>   */
> -int do_settimeofday(const struct timespec *tv)
> +int do_settimeofday64(const struct timespec64 *ts)
>  {
>  	struct timekeeper *tk = &tk_core.timekeeper;
> -	struct timespec64 ts_delta, xt, tmp;
> +	struct timespec64 ts_delta, xt;
>  	unsigned long flags;
>  
> -	if (!timespec_valid_strict(tv))
> +	if (!timespec64_valid_strict(ts))
>  		return -EINVAL;
>  
>  	raw_spin_lock_irqsave(&timekeeper_lock, flags);
> @@ -723,13 +724,12 @@ int do_settimeofday(const struct timespec *tv)
>  	timekeeping_forward_now(tk);
>  
>  	xt = tk_xtime(tk);
> -	ts_delta.tv_sec = tv->tv_sec - xt.tv_sec;
> -	ts_delta.tv_nsec = tv->tv_nsec - xt.tv_nsec;
> +	ts_delta.tv_sec = ts->tv_sec - xt.tv_sec;
> +	ts_delta.tv_nsec = ts->tv_nsec - xt.tv_nsec;
>  
>  	tk_set_wall_to_mono(tk, timespec64_sub(tk->wall_to_monotonic, ts_delta));
>  
> -	tmp = timespec_to_timespec64(*tv);
> -	tk_set_xtime(tk, &tmp);
> +	tk_set_xtime(tk, ts);
>  
>  	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
>  
> @@ -741,6 +741,22 @@ int do_settimeofday(const struct timespec *tv)
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL(do_settimeofday64);

EXPORT_SYMBOL_GPL please.

> +
> +/**
> + * do_settimeofday - Sets the time of day
> + * @tv:		pointer to the timespec variable containing the new time
> + *
> + * Sets the time of day to the new time and update NTP and notify hrtimers
> + * TODO: [2038 safety] should be replaced by do_settimeofday64().

The TODO is not to replace do_settimeofday() by do_settimeofday64(). The TODO
is to fix the call sites.

So instead of adding this you can simply say:

+ * do_settimeofday - Sets the time of day. Deprecated. Use do_settimeofday64()

We want things like this easy to find and not be burried in some
cryptic comment.

Thanks,

	tglx
