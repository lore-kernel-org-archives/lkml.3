Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab3LBPhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:37:51 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:58524 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab3LBPhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:37:50 -0500
Date: Mon, 2 Dec 2013 16:37:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <htejun@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: Revert 14a40ffccd61 ("sched: replace
 PF_THREAD_BOUND with PF_NO_SETAFFINITY")
Message-ID: <20131202153746.GA27781@gmail.com>
References: <20131202152956.GI16796@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131202152956.GI16796@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Subject: sched: Revert 14a40ffccd61 ("sched: replace PF_THREAD_BOUND with PF_NO_SETAFFINITY")
> 
> PF_NO_SETAFFINITY, which crudely turns off affinity control and cgroups
> access to tasks, and which is in use by every workqueue thread in Linux (!),
> is conceptually wrong on many levels:
> 
>  - We should strive to never consciously place artificial limitations on
>    kernel functionality; our main reason to place limitations should be
>    correctness.
> 
>    There are cases where limiting affinity is justified: for example the
>    case of single cpu workqueue threads, which are special for their
>    limited concurrency, esp. when coupled with per-cpu resources --
>    allowing such threads to run on other cpus is a correctness violation
>    and can crash the kernel.
> 
>  - But using it outside this case is overly broad; it dis-allows usage
>    that is functionally fine and in some cases desired.
> 
>    In particular; tj argues ( http://lkml.kernel.org/r/20131128143848.GD3925@htj.dyndns.org )
> 
>    "That's just inviting people to do weirdest things and then
>    reporting things like "crypt jobs on some of our 500 machines end up
>    stuck on a single cpu once in a while" which will eventually be
>    tracked down to some weird shell script setting affinity on workers
>    doing something else."
> 
>    While that is exactly what HPC/RT people _want_ in order to avoid
>    disturbing the other CPUs with said crypt work.
> 
>  - Furthermore, the above example is also wrong in that you should not
>    protect root from itself; there's plenty root can do to shoot his
>    own foot off, let alone shoot his head off.
> 
>    Setting affinities is limited to root, and if root messes up the
>    system he can keep the pieces. But limiting in an overly broad
>    fashion stifles the functionality of the system.
> 
>  - Lastly; the flag actually blocks entry into cgroups as well as
>    sched_setaffinity(), so the name is misleading at best.
> 
> The right fix is to only set PF_THREAD_BOUND on per-cpu workers:
> 
>  --- a/kernel/workqueue.c
>  +++ b/kernel/workqueue.c
> 
>          set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
> 
>  -       /* prevent userland from meddling with cpumask of workqueue workers */
>  -       worker->task->flags |= PF_NO_SETAFFINITY;
>  -
>          /*
>           * The caller is responsible for ensuring %POOL_DISASSOCIATED
>           * remains stable across this function.  See the comments above the
>           * flag definition for details.
>           */
>  -       if (pool->flags & POOL_DISASSOCIATED)
>  +       if (pool->flags & POOL_DISASSOCIATED) {
>                  worker->flags |= WORKER_UNBOUND;
>  +       } else {
>  +               /*
>  +                * Prevent userland from meddling with cpumask of workqueue
>  +                * workers:
>  +                */
>  +               worker->task->flags |= PF_THREAD_BOUND;
>  +       }
> 
> Therefore revert the patch and add an annoying but non-destructive warning
> check against abuse.

Hm, I missed these problems with the approach, but I think you are 
right.

Tejun, I suspect you concur with Peter's analysis, can I also add 
Peter's workqueue.c fixlet above to workqueue.c to this patch plus 
your Acked-by, so that the two changes are together?

Thanks,

	Ingo
