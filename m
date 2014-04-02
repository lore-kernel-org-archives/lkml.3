Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714AbaDBFlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 01:41:16 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:34481 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaDBFlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 01:41:14 -0400
MIME-Version: 1.0
In-Reply-To: <9ea86197955aee2b751ccb5a8ea746dbd3244850.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
	<9ea86197955aee2b751ccb5a8ea746dbd3244850.1396006658.git.viresh.kumar@linaro.org>
Date: Wed, 2 Apr 2014 11:11:13 +0530
Message-ID: <CAKohpokwwHk=0HxaiRQO2CMfrq2qnikvO9V1G5wpD6bhEjDs0w@mail.gmail.com>
Subject: Re: [PATCH 02/16] hrtimer: reorder code in __remove_hrtimer()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linaro Networking <linaro-networking@linaro.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2014 17:11, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c

> @@ -887,25 +887,22 @@ static void __remove_hrtimer(struct hrtimer *timer,
>                              struct hrtimer_clock_base *base,
>                              unsigned long newstate, int reprogram)
>  {
> -       struct timerqueue_node *next_timer;
>         if (!(timer->state & HRTIMER_STATE_ENQUEUED))
>                 goto out;
>
> -       next_timer = timerqueue_getnext(&base->active);
>         timerqueue_del(&base->active, &timer->node);
> -       if (&timer->node == next_timer) {
> +
>  #ifdef CONFIG_HIGH_RES_TIMERS
> -               /* Reprogram the clock event device. if enabled */
> -               if (reprogram && hrtimer_hres_active()) {
> -                       ktime_t expires;
> -
> -                       expires = ktime_sub(hrtimer_get_expires(timer),
> -                                           base->offset);
> -                       if (base->cpu_base->expires_next.tv64 == expires.tv64)
> -                               hrtimer_force_reprogram(base->cpu_base, 1);
> -               }
> -#endif
> +       /* Reprogram the clock event device. if enabled */
> +       if (reprogram && hrtimer_hres_active() &&
> +           &timer->node == timerqueue_getnext(&base->active)) {

Last comparison here would always fail as we have already removed the timer.
Here is a fixup for that, will include that in my V2:

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 516c67f..189c525 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -886,15 +886,16 @@ static void __remove_hrtimer(struct hrtimer *timer,
                             struct hrtimer_clock_base *base,
                             unsigned long newstate, int reprogram)
 {
+       struct timerqueue_node *next_timer;
        if (!(timer->state & HRTIMER_STATE_ENQUEUED))
                goto out;

+       next_timer = timerqueue_getnext(&base->active);
        timerqueue_del(&base->active, &timer->node);

 #ifdef CONFIG_HIGH_RES_TIMERS
        /* Reprogram the clock event device. if enabled */
-       if (reprogram && hrtimer_hres_active() &&
-           &timer->node == timerqueue_getnext(&base->active)) {
+       if (reprogram && hrtimer_hres_active() && &timer->node == next_timer) {
                ktime_t expires;

                expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
