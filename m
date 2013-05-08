Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3EHLJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 07:09:01 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:58099 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab3EHLJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 07:09:00 -0400
Message-ID: <518A324A.8000000@linaro.org>
Date: Wed, 08 May 2013 13:08:58 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lianwei Wang <lianwei.wang@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] cpuidle: don't wakeup processor when set a
 longer latency
References: <CAJFUiJiMMAgLGF3tiG1V59dx+KOpTBCEL3ctHUosjMDkBagbJg@mail.gmail.com>
In-Reply-To: <CAJFUiJiMMAgLGF3tiG1V59dx+KOpTBCEL3ctHUosjMDkBagbJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 04:44 AM, Lianwei Wang wrote:
> When a PM-Qos is updated, the cpuidle driver will wakeup all the CPUs
> no matter what a latency is set. But actually it only need to wakeup
> the CPUs when a shorter latency is set. In this way we can reduce the
> cpu wakeup count and save battery.

I am curious, how many times could the pm_qos be changed in a system
live cycle to measure an improvement with this patch ?

Do you have a scenario where you measured a noticeable power saving ?

> So we can pass the prev_value to the notifier callback and check the
> latency curr_value and prev_value in the cpuidle latency notifier
> callback. It modify a common interface(dummy --> prev_value) but shall
> be safe since no one use the dummy parameter currently.
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index e1f6860..1e1758c 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -498,7 +498,11 @@ static void smp_callback(void *v)
>  static int cpuidle_latency_notify(struct notifier_block *b,
>                 unsigned long l, void *v)
>  {
> -       smp_call_function(smp_callback, NULL, 1);
> +       unsigned long prev_value = (unsigned long) v;
> +
> +       /* Dont't waktup processor when set a longer latency */

                    ^^^^^^
                    wakeup

Instead of passing prev and curr, using the dummy variable, why don't
you pass the result of (curr - prev) ?

A negative value means, the latency is smaller and positive is bigger.

Also, may be the optimization could be more improved: if the latency is
bigger than the next wakeup event, it is not necessary to wakeup the cpus.

> +       if (l < prev_value)
> +               smp_call_function(smp_callback, NULL, 1);
>         return NOTIFY_OK;
>  }
> 
> diff --git a/kernel/power/qos.c b/kernel/power/qos.c
> index 9322ff7..533b8bc 100644
> --- a/kernel/power/qos.c
> +++ b/kernel/power/qos.c
> @@ -205,7 +205,7 @@ int pm_qos_update_target(struct pm_qos_constraints
> *c, struct plist_node *node,
>         if (prev_value != curr_value) {
>                 blocking_notifier_call_chain(c->notifiers,
>                                              (unsigned long)curr_value,
> -                                            NULL);
> +                                            (void *)prev_value);
>                 return 1;
>         } else {
>                 return 0;
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

