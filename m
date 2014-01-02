Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaABTcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 14:32:43 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53897 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaABTcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 14:32:41 -0500
Message-ID: <52C5BED6.5090603@linaro.org>
Date: Thu, 02 Jan 2014 11:32:38 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexey Perevalov <a.perevalov@samsung.com>, linux-kernel@vger.kernel.org
CC: Anton Vorontsov <anton@enomsg.org>, kyungmin.park@samsung.com,
        akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH 3/3] timerfd: Add support for deferrable timers
References: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com> <1388687448-12987-4-git-send-email-a.perevalov@samsung.com>
In-Reply-To: <1388687448-12987-4-git-send-email-a.perevalov@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 10:30 AM, Alexey Perevalov wrote:
> From: Anton Vorontsov <anton@enomsg.org>
>
> This patch implements a userland-side API for generic deferrable timers,
> per linux/timer.h:
>
>  * A deferrable timer will work normally when the system is busy, but
>  * will not cause a CPU to come out of idle just to service it; instead,
>  * the timer will be serviced when the CPU eventually wakes up with a
>  * subsequent non-deferrable timer.
>
> These timers are crucial for power saving, i.e. periodic tasks that want
> to work in background when the system is under use, but don't want to
> cause wakeups themselves.
>
> The deferred timers are somewhat orthogonal to high-res external timers,
> since the deferred timer is tied to the system load, not just to some
> external decrementer source.
>
> So, currently, the implementation has a HZ precision, and the maximum
> interval is jiffies resolution (i.e. with HZ=1000, on 32 bit that would
> be around max 49 days).  Of course we can implement longer timeouts by
> rearming the timer, although it probably  wouldn't make much sense in
> real world, so we keep it simple and just return E2BIG if we don't like
> the interval.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
> ---
>  fs/timerfd.c              |   59 ++++++++++++++++++++++++++++++++++++++++++---
>  include/uapi/linux/time.h |    1 +
>  2 files changed, 56 insertions(+), 4 deletions(-)
>
> diff --git a/fs/timerfd.c b/fs/timerfd.c
> index 3561ce7..331ce4b 100644
> --- a/fs/timerfd.c
> +++ b/fs/timerfd.c
> @@ -30,6 +30,7 @@ struct timerfd_ctx {
>  	union {
>  		struct hrtimer tmr;
>  		struct alarm alarm;
> +		struct timer_list dtmr;
>  	} t;
>  	ktime_t tintv;
>  	ktime_t moffs;
> @@ -51,6 +52,11 @@ static inline bool isalarm(struct timerfd_ctx *ctx)
>  		ctx->clockid == CLOCK_BOOTTIME_ALARM;
>  }
>  
> +static inline bool isdeferrable(struct timerfd_ctx *ctx)
> +{
> +	return ctx->clockid == CLOCK_DEFERRABLE;
> +}
> +
>  /*
>   * This gets called when the timer event triggers. We set the "expired"
>   * flag, but we do not re-arm the timer (in case it's necessary,
[snip]
> diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
> index e75e1b6..3481cb3 100644
> --- a/include/uapi/linux/time.h
> +++ b/include/uapi/linux/time.h
> @@ -56,6 +56,7 @@ struct itimerval {
>  #define CLOCK_BOOTTIME_ALARM		9
>  #define CLOCK_SGI_CYCLE			10	/* Hardware specific */
>  #define CLOCK_TAI			11
> +#define CLOCK_DEFERRABLE		12
>  
>  #define MAX_CLOCKS			16
>  #define CLOCKS_MASK			(CLOCK_REALTIME | CLOCK_MONOTONIC)


So, I'm a bit concerned about the CLOCK_DEFERRABLE clockid, as it isn't
clear what time domain it uses. Its unlikely to be its own time domain,
so this is really a misuse of extending the clockids.

It seems to me that deferrability is an attribute of the time domain. So
instead of having a CLOCK_DEFERRABLE, I suspect we'll want something
like CLOCK_MONOTONIC_DEFER/CLOCK_REALTIME_DEFER, etc.

That is, unless we extend the timerfd interface to also take something
like a properties flag or something.

thanks
-john






