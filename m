Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaCaAM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:12:56 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43829 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaCaAMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 20:12:53 -0400
MIME-Version: 1.0
In-Reply-To: <1396164244.28950.15.camel@marge.simpson.net>
References: <1396164244.28950.15.camel@marge.simpson.net>
Date: Sun, 30 Mar 2014 17:12:52 -0700
X-Google-Sender-Auth: wg8EWqGuRLNBbq9JdoYmDGMaGhk
Message-ID: <CA+55aFzGVLTiD5QVqZ6YK41b9n0SUxDGD3+yE9CuGJek2U-+MQ@mail.gmail.com>
Subject: Re: [PATCH] sched: update_rq_clock() must skip ONE update
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch looks fine, but the changelog is so chock-full of odd
language that I don't know what to do with the patch.

Is this actually a problem in real life, or just in the drug-induced
wonderland that Mike was in when writing the changelog?

               Linus

On Sun, Mar 30, 2014 at 12:24 AM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
> NEWSFLASH: Wimpy latent scheduler buglet turns axe-murderer...
>
> Root cause being us staying in kernel for weeks at a time during boot:
>
> Subverting ftrace, we see below that updates _can_ be skipped for AGES,
> which can make very bad things happen.  It's supposed to skip ONE, as an
> optimization. not lord knows how many.  Here we see we've been skipping
> since 4915630446, resulting in the watchdog being credited with a 137ms
> delta_exec.  Bogus, and..
>
>         modprobe-134   [000]     5.027903: update_rq_clock <-scheduler_tick
>         modprobe-134   [000]     5.037857: update_rq_clock <-scheduler_tick
>         modprobe-134   [000]     5.037864: update_rq_clock <-enqueue_task
>         modprobe-134   [000]     5.037866: enqueue_task_watchdog: WATCHDOG/0 enqueue 4915630446
>         modprobe-134   [000]     5.044965: update_rq_clock <-scheduler_tick
>         modprobe-134   [000]     5.046275: update_rq_clock <-scheduler_tick
>         modprobe-134   [000]     5.050274: update_rq_clock <-scheduler_tick
>         modprobe-134   [000]     5.052862: update_rq_clock <-dequeue_task
>         modprobe-134   [000]     5.052866: pick_next_task_watchdog: WATCHDOG/0 select 4915630446
>       watchdog/0-7     [000]     5.052868: finish_task_switch: WATCHDOG/0 runs 5052867644
>       watchdog/0-7     [000]     5.052869: watchdog: WATCHDOG/0 DELAYED 137238048 max: 137238048
>       watchdog/0-7     [000]     5.052872: update_rq_clock <-dequeue_task
>       watchdog/0-7     [000]     5.052873: dequeue_task_watchdog: WATCHDOG/0 dequeue 5052872018
>       watchdog/0-7     [000]     5.052874: put_prev_task_watchdog: WATCHDOG/0 STOP trace : delta_exec 137241572 sum_exec 137254287
>
> ..delta_exec was sufficient in a NOPREEMPT kernel on zillion disk box
> that disk discovery combined with swsusp wanting to find out if it needs
> to resume, that the featherweight watchdog was credited with delta_exec
> HUGE enough to be incapacitated by the rt throttle long enough for the
> hard lockup detector to trigger.
>
> Throttled watchdog is bad juju, led to -ENOBOOT for IO beast.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by:  Mike Galbraith <umgwanakikbuti@gmail.com>
> ---
>  kernel/sched/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -118,7 +118,7 @@ void update_rq_clock(struct rq *rq)
>  {
>         s64 delta;
>
> -       if (rq->skip_clock_update > 0)
> +       if (rq->skip_clock_update-- > 0)
>                 return;
>
>         delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
>
>
