Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbaD3Kfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:35:37 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:48205 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758223AbaD3Kfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:35:36 -0400
MIME-Version: 1.0
In-Reply-To: <1398847391-5994-1-git-send-email-xindong.ma@intel.com>
References: <1398847391-5994-1-git-send-email-xindong.ma@intel.com>
Date: Wed, 30 Apr 2014 16:05:35 +0530
X-Google-Sender-Auth: 9yLuCEldpU7Y5C0SNZJmhDMBoU0
Message-ID: <CAOh2x=k2-9c8sJtM+gfVjF3NzANO5RBk-GuqOue5gd5CLY3KAg@mail.gmail.com>
Subject: Re: [PATCH] hrtimer:do not start hrtimer on other cpu if it is the
 leftmost timer.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Leon Ma <xindong.ma@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leon,

On Wed, Apr 30, 2014 at 2:13 PM, Leon Ma <xindong.ma@intel.com> wrote:
> On SMP system, if cpuX is idle and it starts an hrtimer, the timer
> will be started on cpuY. But it can not reprogram the event source
> on cpuY. The timer is inserted into rb tree of cpuY, if it is the
> leftmost timer on cpuY and it is a very short timer, following hrtimers
> started on cpuY will also not set the event source. As a result,
> the timers on cpuY will expire later than expected.

Don't know but the explanation confused me a bit :), thought the patch
looked fine. So, in my words this is what I understood, let me know if
I am on the right side.

Current base of timer is: cpuY and we started timer from cpuX. If cpuX
is idle, we might select cpuY again as the base but we wouldn't be able
to reprogram the event source as it has to be done by local CPU.

And so in this case you want to select cpuX instead, right?

> When this case is detected, we should start the timer on cpuX and
> program event source properly.
>
> Signed-off-by: Leon Ma <xindong.ma@intel.com>
> ---
>  kernel/hrtimer.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index d55092c..68becbc 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -234,6 +234,11 @@ again:
>                         goto again;
>                 }
>                 timer->base = new_base;
> +       } else {
> +               if (cpu != this_cpu && hrtimer_check_target(timer, new_base)) {
> +                       cpu = this_cpu;
> +                       goto again;
> +               }
>         }
>         return new_base;
>  }
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
