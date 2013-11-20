Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3KTIEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:04:54 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:49043 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3KTIEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:04:46 -0500
MIME-Version: 1.0
In-Reply-To: <0a0c8e4c6fbf681d375f25b0c0eba036b8eaadf7.1380815504.git.viresh.kumar@linaro.org>
References: <cover.1380815504.git.viresh.kumar@linaro.org>
	<0a0c8e4c6fbf681d375f25b0c0eba036b8eaadf7.1380815504.git.viresh.kumar@linaro.org>
Date: Wed, 20 Nov 2013 13:34:45 +0530
Message-ID: <CAKohpon8s6mPVCVsvkZ-_LurDp=038FwqkCNy_Dx5mmeCF9+bw@mail.gmail.com>
Subject: Re: [PATCH V2 14/16] cpuidle: don't calculate time-diff if
 entered_state < 0
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 October 2013 21:26, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> If entered_state < 0, we don't need to set dev->last_residency to 'diff' as we
> will be setting it to zero without using its new value.
>
> And so move calculation of diff also inside the "if" statement.
>
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpuidle/cpuidle.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)

Missed applying this one too?

>
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index b45257a..1a6e9f5 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -77,23 +77,22 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
>
>         struct cpuidle_state *target_state = &drv->states[index];
>         ktime_t time_start, time_end;
> -       s64 diff;
>
>         time_start = ktime_get();
>
>         entered_state = target_state->enter(dev, drv, index);
>
> -       time_end = ktime_get();
> +       if (entered_state >= 0) {
> +               s64 diff;
>
> -       local_irq_enable();
> +               time_end = ktime_get();
> +               diff = ktime_to_us(ktime_sub(time_end, time_start));
>
> -       diff = ktime_to_us(ktime_sub(time_end, time_start));
> -       if (diff > INT_MAX)
> -               diff = INT_MAX;
> +               if (diff > INT_MAX)
> +                       diff = INT_MAX;
>
> -       dev->last_residency = (int) diff;
> +               dev->last_residency = (int) diff;
>
> -       if (entered_state >= 0) {
>                 /* Update cpuidle counters */
>                 /* This can be moved to within driver enter routine
>                  * but that results in multiple copies of same code.
> @@ -104,6 +103,8 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
>                 dev->last_residency = 0;
>         }
>
> +       local_irq_enable();
> +
>         return entered_state;
>  }
>
> --
> 1.7.12.rc2.18.g61b472e
>
