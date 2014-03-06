Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaCFHlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:41:10 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:53914 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaCFHlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:41:07 -0500
MIME-Version: 1.0
In-Reply-To: <1393223377-5744-7-git-send-email-tuukka.tikkanen@linaro.org>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
	<1393223377-5744-7-git-send-email-tuukka.tikkanen@linaro.org>
Date: Thu, 6 Mar 2014 02:41:06 -0500
X-Google-Sender-Auth: 0sX8khofPMKivb1gxacAL_i_8nA
Message-ID: <CAJvTdKneVk_ToJ=Sv4GnMfn5a0r=ynfL4fRLOoKHsqMrDYr8JA@mail.gmail.com>
Subject: Re: [PATCH 6/7] Cpuidle: Deal with timer expiring in the past
From: Len Brown <lenb@kernel.org>
To: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 1:29 AM, Tuukka Tikkanen
<tuukka.tikkanen@linaro.org> wrote:
> Sometimes (fairly often) when the cpuidle menu governor is making a decision
> about idle state to enter the next timer for the cpu appears to expire in
> the past. The menu governor expects the expiry to always be in the future
> and in fact stores the time delta in an unsigned variable. However, when
> the expiry is in the past, the value returned by tick_nohz_get_sleep_length
> can be negative. This patch prevents using negative values, instead making
> the governor return immediately similar to having latency requirement set
> to 0.
>
> Note: As with latency == 0, the return value is 0 with no check to see if
> the state 0 has been disabled or not.
>
> Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
> ---
>  drivers/cpuidle/governors/menu.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index 71b5232..c414468 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -302,8 +302,16 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
>         if (unlikely(latency_req == 0))
>                 return 0;
>
> -       /* determine the expected residency time, round up */
> +       /*
> +        * Determine the expected residency time. If the time is negative,
> +        * a timer interrupt has probably just expired after disabling
> +        * interrupts. Return as quickly as possible in the most shallow
> +        * state possible. tv_nsec is always positive, so only check the
> +        * seconds.
> +        */
>         t = ktime_to_timespec(tick_nohz_get_sleep_length());
> +       if (t.tv_sec < 0)
> +               return 0;
>         data->next_timer_us =
>                 t.tv_sec * USEC_PER_SEC + t.tv_nsec / NSEC_PER_USEC;
>

Are there special conditions that are necessary to provoke a negative
return value?
I've traced this code on several systems, and never seen a negative
return value.

However...
I do see values up to 300.2 seconds, and those large values seem to decay
at the rate of real-time so that after 5 minutes they are small, and then
jump back up to 300 seconds.

Some folks at Oracle debugged it down to use of NEXT_TIMER_MAX_DELTA
when there is _no_ timer currently pending on that CPU.  It seems this is easier
to observe, the more CPUs a system has -- though I've been able to reproduce
it on a system as small as a single-package 8-cpu systems.

One proposed way to address this is to cap large values at 1 second.
However, that will not recognize that for the period when the large
value decays to under 1 second, all of those are fiction.

Also, if we could identify the case where there is no future timer,
it seems that re-using dev->last_residency would probably be
a more useful guess than pretending we'll have a timer expire in 1 second.

thanks,
Len Brown, Intel Open Source Technology Cente
