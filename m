Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab3EMJHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:07:33 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:53095 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3EMJHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:07:31 -0400
Message-ID: <5190AC9B.70106@linux.vnet.ibm.com>
Date: Mon, 13 May 2013 14:34:27 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Lianwei Wang <lianwei.wang@gmail.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] [PATCH] cpuidle: don't wakeup processor when set a
 longer latency
References: <CAJFUiJiMMAgLGF3tiG1V59dx+KOpTBCEL3ctHUosjMDkBagbJg@mail.gmail.com> <518A324A.8000000@linaro.org> <CAJFUiJio8jHtGwGo=-FSm6_E9LATSkyUx_iWsuFddmA9+PXCJA@mail.gmail.com> <518C3502.2040306@linaro.org> <CAJFUiJjLUvpO5t+LT32hmaER1QX06wpK8a+Rr4GSB-Xikh=O7w@mail.gmail.com>
In-Reply-To: <CAJFUiJjLUvpO5t+LT32hmaER1QX06wpK8a+Rr4GSB-Xikh=O7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051309-5564-0000-0000-000007E5DC09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 12:22 PM, Lianwei Wang wrote:
> Thank you. Patch is updated.
> 
> From 2d0b4afb5461847dcdf08a87b02015d061b12e85 Mon Sep 17 00:00:00 2001
> From: Lianwei Wang <lianwei.wang@gmail.com>
> Date: Fri, 26 Apr 2013 10:59:24 +0800
> Subject: [PATCH] cpuidle: wakeup processor on a smaller latency
> 
> Checking the PM-Qos latency and cpu idle sleep latency, and only
> wakeup the cpu if the requested PM-Qos latency is smaller than its
> idle sleep latency. This can reduce at least 50% cpu wakeup count
> on PM-Qos updated.
>
> The PM-Qos is not updated most of time, especially for home idle
> case. But for some specific case, the PM-Qos may be updated too
> frequently. (E.g. my measurement show that it is changed frequently
> between 2us/3us/200us/200s for bootup and usb case.)
> 
> The battery current drain is measured from PMIC or battery eliminator.
> Although this is just a little saving, it is still reasonable to
> improve it.
>

I don't understand how this patch is supposed to improve things.

IIUC, if a CPU was sleeping for a short duration, and you set the latency
requirement for a longer value, this patch will avoid waking that CPU.
But how does that help? Perhaps, during the short sleep, the CPU was
actually in a shallow (less power-saving) sleep state, and hence it might
actually be better off waking it up and then putting it into a much
deeper sleep state no?

And if we ignore the sleep length for a moment, in the case that you
set a very strict latency requirement and then later relax the constraint,
does it not make sense to wake up the CPUs and allow them to go to
deeper sleep states?

And IMHO there are other problems with this patch as well, see below.

> Change-Id: If564fd0d9c53cf100bd85247bfd509dfeaf54c13
> Signed-off-by: Lianwei Wang <lianwei.wang@gmail.com>
> ---
>  drivers/cpuidle/cpuidle.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 2f0083a..a0829ad 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -18,6 +18,7 @@
>  #include <linux/ktime.h>
>  #include <linux/hrtimer.h>
>  #include <linux/module.h>
> +#include <linux/tick.h>
>  #include <trace/events/power.h>
> 
>  #include "cpuidle.h"
> @@ -462,11 +463,25 @@ static void smp_callback(void *v)
>   * requirement.  This means we need to get all processors out of their C-state,
>   * and then recalculate a new suitable C-state. Just do a cross-cpu IPI; that
>   * wakes them all right up.
> + * l - > latency in us
>   */
>  static int cpuidle_latency_notify(struct notifier_block *b,
>                 unsigned long l, void *v)
>  {
> -       smp_call_function(smp_callback, NULL, 1);
> +       int cpu, rcpu = smp_processor_id();

This is not atomic context. So your rcpu is not guaranteed to remain valid
(because you can get migrated to another cpu).

> +       s64 s; /* sleep_length in us */
> +       struct tick_device *td;
> +
> +       for_each_online_cpu(cpu) {

You need to protect against CPU hotplug, by using get/put_online_cpus().

> +               if (cpu == rcpu)
> +                       continue;
> +               td = tick_get_device(cpu);
> +               s = ktime_us_delta(td->evtdev->next_event, ktime_get());

What happens if that wakeup event got cancelled just after this? And hence
the CPU sleeps longer than expected... In that case, you'll be violating
the latency requirement set by the user, no?

Moreover, looking at the menu and ladder cpu idle governors, the value set
in cpu_dma_latency is used to compare with the *exit-latency* of the sleep
state in order to decide which sleep state to go to. IOW, it has got *nothing*
to do with the duration of the sleep!!

> +               if ((long)l < (long)s) {

... and hence, this check doesn't make sense at all!

> +                       smp_call_function_single(cpu, smp_callback, NULL, 1);
> +               }
> +       }
> +
>         return NOTIFY_OK;
>  }
> 

Regards,
Srivatsa S. Bhat

