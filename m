Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaBSKH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:07:26 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:58432 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaBSKHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:07:22 -0500
Message-ID: <53048262.4000200@gmail.com>
Date: Wed, 19 Feb 2014 11:07:30 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched/deadline: Update total bandwidth when adding new
 task
References: <20140218215659.2a3ddd8f@gandalf.local.home>
In-Reply-To: <20140218215659.2a3ddd8f@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 03:56 AM, Steven Rostedt wrote:
> While debugging the crash with the bad nr_running accounting, I hit
> another bug where, after running my sched deadline test, I was getting
> failures to take a CPU offline. It was giving me a -EBUSY error.
> 
> Adding a bunch of trace_printk()s around, I found that the cpu
> notifier that called sched_cpu_inactive() was returning a failure. The
> overflow value was coming up negative?
> 
> Adding more trace_printk()s, I found that task_dead_dl() function was
> subtracting the exact amount that was keeping the CPU from going
> offline. I then realized that the task_dead_dl() was updating the
> total_bw for the task that was going away, but there was nothing that
> added to the total_bw when the task came alive. 

We call __dl_add() from dl_overflow(), right before calling __setscheduler().

> If total_bw is not
> zero for a CPU, it will keep that CPU from going offline.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b46131e..17f4830 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3178,6 +3178,7 @@ static void
>  __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
>  {
>  	struct sched_dl_entity *dl_se = &p->dl;
> +	struct dl_bw *dl_b = dl_bw_of(task_cpu(p));
>  
>  	init_dl_task_timer(dl_se);
>  	dl_se->dl_runtime = attr->sched_runtime;
> @@ -3187,6 +3188,7 @@ __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
>  	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
>  	dl_se->dl_throttled = 0;
>  	dl_se->dl_new = 1;
> +	__dl_add(dl_b, dl_se->dl_bw);
>  }

This is intended to set params for a task that is going to become -deadline. I
don't think it is the right place to update dl_b. And it seems you add it twice
(inside dl_overflow and inside __setscheduler).

I performed some tests, and it seems that dl_b is updated correctly, once when
the task is started and once when task_dead_dl() is called.

That said, I'm still testing with your stress-cpu-hotplug.

Thanks,

- Juri

>  
>  /* Actually do priority change: must hold pi & rq lock. */
> 
