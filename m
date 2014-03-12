Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaCLKjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:39:48 -0400
Received: from hofr.at ([212.69.189.236]:53730 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbaCLKjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:39:47 -0400
Date: Wed, 12 Mar 2014 11:39:42 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <tkhai@yandex.ru>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH]sched/rt: Do not try to push tasks if pinned task
	switches to RT
Message-ID: <20140312103942.GB5321@opentech.at>
References: <4451359470707@web16g.yandex.ru> <20140312061833.3a43aa64@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312061833.3a43aa64@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014, Steven Rostedt wrote:

> Peter,
> 
> I'm going through my inbox (over a year old), and found this patch from
> Kirill. It looks fine to me. You can apply it with my
> 
>   Acked-by: Steven Rostedt <rostedt@goodmis.org>
>
> -- Steve
> 
> [PATCH]sched/rt: Do not try to push tasks if pinned task switches to RT
> 
> Just switched pinned task is not able to be pushed. If the rq had had
> several RT tasks before they have already been considered as candidates
> to be pushed (or pulled).
> 
> Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: linux-rt-users <linux-rt-users@vger.kernel.org>
> ---
>  kernel/sched/rt.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 4e8f0f4..5aab032 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1925,9 +1925,9 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
>  	 */
>  	if (p->on_rq && rq->curr != p) {
>  #ifdef CONFIG_SMP
> -		if (rq->rt.overloaded && push_rt_task(rq) &&
> +		if (p->nr_cpus_allowed > 1 && rq->rt.overloaded &&
>  		    /* Don't resched if we changed runqueues */
> -		    rq != task_rq(p))
> +		    push_rt_task(rq) && rq != task_rq(p))
>  			check_resched = 0;
>  #endif /* CONFIG_SMP */
>  		if (check_resched && p->prio < rq->curr->prio)

would there not need to be a check for p->migrate_disable ?
push_rt_task() is not checking and so a high prio RT task 
preemting a low prio RT task in a migrate_disable() section
would actually push it off this cpu ? atleast I did not 
find why that would not happen.

thx!
hofrat
