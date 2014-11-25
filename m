Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaKYEWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 23:22:30 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:34326 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaKYEW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 23:22:29 -0500
MIME-Version: 1.0
In-Reply-To: <1416878180-25312-1-git-send-email-pang.xunlei@linaro.org>
References: <1416878180-25312-1-git-send-email-pang.xunlei@linaro.org>
Date: Mon, 24 Nov 2014 20:22:29 -0800
Message-ID: <CALAqxLUoH7-9VaE1MYHVd0TM5gka+3iGEb9o6wBsL1AT_v8TtQ@mail.gmail.com>
Subject: Re: [PATCH] time: Avoid possible NTP adjustment mult overflow
From: John Stultz <john.stultz@linaro.org>
To: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 5:16 PM, pang.xunlei <pang.xunlei@linaro.org> wrote:
> Ideally, __clocksource_updatefreq_scale, selects the largest shift
> value possible for a clocksource. This results in the mult memember
> of struct clocksource being particularly large, although not so large
> that NTP would adjust the clock to cause it to overflow.
>
> That said, nothing actually prohibits an overflow from occurring, its
> just that it "shouldn't" occur.
>
> So while very unlikely, and so far never observed, the value of
> (cs->mult+cs->maxadj) may have a chance to reach very near 0xFFFFFFFF,
> so there is a possibility it may overflow when doing NTP positive
> adjustment
>
> See the following detail: When NTP slewes the clock, kernel goes
> through update_wall_time()->...->timekeeping_apply_adjustment():
>                  tk->tkr.mult += mult_adj;
>
> Since there is no guard against it, its possible tk->tkr.mult may
> overflow during this operation.
>
> This patch avoids any possible mult overflow by judging the overflow
> case before adding mult_adj to mult, also adds the WARNING message
> when capturing such case.
>
> Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
> ---
> Fix the problem in the former patch catched by Fengguang's 0day robot:
> [time] WARNING: CPU: 0 PID: 1 at kernel/time/timekeeping.c:1337 update_wall_time()
>
>  kernel/time/timekeeping.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 0aef92a..9a1482e 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1390,6 +1390,12 @@ static __always_inline void timekeeping_apply_adjustment(struct timekeeper *tk,
>          *
>          * XXX - TODO: Doc ntp_error calculation.
>          */
> +       if (mult_adj > 0 && (tk->tkr.mult + mult_adj < mult_adj)) {
> +               /* NTP adjustment caused clocksource mult overflow */
> +               WARN_ON_ONCE(1);
> +               return;
> +       }
> +
>         tk->tkr.mult += mult_adj;
>         tk->xtime_interval += interval;
>         tk->tkr.xtime_nsec -= offset;

So the original problematic patch is already queued in -tip, so next
time its best to just provide the additional fix on-top of the
problematic one (instead of sending a entirely new patch).

I've got a fix implementing the same, which went through testing
today, and I'll send it to Thomas in a moment.

thanks
-john
