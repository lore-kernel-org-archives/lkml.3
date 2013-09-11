Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab3IKQnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:43:32 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:45610 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab3IKQnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:43:31 -0400
Message-ID: <52309DB0.4020403@linaro.org>
Date: Wed, 11 Sep 2013 09:43:28 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>, lttng-dev@lists.lttng.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH lttng-modules] Fix: use timekeeping_is_busy() to fix
 ktime_get() hard lockup
References: <20130911151200.GB19800@Krystal>
In-Reply-To: <20130911151200.GB19800@Krystal>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 08:12 AM, Mathieu Desnoyers wrote:
> LTTng uses ktime to have the same time-base across kernel and
> user-space, so traces gathered from LTTng-modules and LTTng-UST can be
> correlated. We plan on using ktime until a fast, scalable, and
> fine-grained time-source for tracing that can be used across kernel and
> user-space, and which does not rely on read seqlock for kernel-level
> synchronization, makes its way into the kernel.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
> diff --git a/wrapper/trace-clock.h b/wrapper/trace-clock.h
> index bced61c..2f9df7a 100644
> --- a/wrapper/trace-clock.h
> +++ b/wrapper/trace-clock.h
> @@ -32,6 +32,7 @@
>  #include <linux/ktime.h>
>  #include <linux/time.h>
>  #include <linux/hrtimer.h>
> +#include <linux/version.h>
>  #include "random.h"
>  
>  static inline u64 trace_clock_monotonic_wrapper(void)
> @@ -45,6 +46,10 @@ static inline u64 trace_clock_monotonic_wrapper(void)
>  	if (in_nmi())
>  		return (u64) -EIO;
>  
> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,10,0))
> +	if (timekeeping_is_busy())
> +		return (u64) -EIO;
> +#endif
>  	ktime = ktime_get();
>  	return ktime_to_ns(ktime);
>  }


I guess the other question here is should this functionality be pushed
down into the timekeeping accessors themselves?

I know any extra checks would probably be considered overhead in some
uses, but if we do the check only when we hit contention then it might
not be so bad.

thanks
-john



