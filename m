Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760763Ab3EFXSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:18:43 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47759 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435Ab3EFXSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:18:40 -0400
Date: Tue, 7 May 2013 01:18:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Olivier Langlois <olivier@olivierlanglois.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] posix_timers: do not account group_exec_runtime
 for dying autoreaped tasks
Message-ID: <20130506231835.GC1225@somewhere>
References: <1367258649.8833.19.camel@Wailaba2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367258649.8833.19.camel@Wailaba2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 02:04:09PM -0400, Olivier Langlois wrote:
> 
> 
> Forbids the cputimer to drift ahead of its process clock by
> blocking its update when a tick occurs while a autoreaping task
> is currently in do_exit() between the call to release_task() and
> its final call to schedule().
> 
> Any task stats update after having called release_task() will
> be lost because they are added to the global process stats located
> in the signal struct from release_task().

I wonder if this is real problem that the clock is ahead of the timer.
Have you seen any issue in practice with this? Or may be it's a
guarantee that the posix clock should provide wrt. to the timer?

thanks.

> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  kernel/sched/fair.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7a33e59..52d7b10 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -708,7 +708,15 @@ static void update_curr(struct cfs_rq *cfs_rq)
>  
>                 trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
>                 cpuacct_charge(curtask, delta_exec);
> -               account_group_exec_runtime(curtask, delta_exec);
> +               /*
> +                * Do not update the cputimer if the task is already released by
> +                * release_task().
> +                *
> +                * it would preferable to defer the autoreap release_task
> +                * after the last context switch but harder to do.
> +                */
> +               if (likely(curtask->sighand))
> +                       account_group_exec_runtime(curtask, delta_exec);
>         }
>  
>         account_cfs_rq_runtime(cfs_rq, delta_exec);
> -- 
> 1.8.2.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
