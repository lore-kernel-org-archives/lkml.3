Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731AbaEFCaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 22:30:13 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:54281 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933630AbaEFCaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 22:30:11 -0400
X-IronPort-AV: E=Sophos;i="4.97,993,1389715200"; 
   d="scan'208";a="30112647"
Message-ID: <53683B14.3060702@cn.fujitsu.com>
Date: Tue, 6 May 2014 10:29:56 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <peterz@infradead.org>, <bsegall@google.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Move the wakeup tracepoint from ttwu_do_wakeup()
 to ttwu_activate().
References: <53673074.1040406@cn.fujitsu.com> <1399271647-25696-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20140505100014.19b46560@gandalf.local.home> <53682AA7.9060401@cn.fujitsu.com> <20140505220628.5d62fdec@gandalf.local.home>
In-Reply-To: <20140505220628.5d62fdec@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 11:06 AM, Steven Rostedt wrote:
> On Tue, 6 May 2014 09:19:51 +0900
> Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:
>
> I wonder if we should have the event, or way to distinguish the
> difference. Hmm, there's that "success" parameter in the tracepoint.
> Could we possible be able to trace events where the success is true
> only if it was actually waking the event, and false otherwise?
>
> Having the sched_wakeup trace event show you when something woke the
> task up may still be useful information. For example, you add yourself
> to a wait queue and want to see the "wakeup". If we only show it for
> tasks that really woke up then we wont see it for those that added
> itself to a waitqueue but was "woken" before it could schedule out.
>
> The original sched_wakeup did this, but with the ttwu rewrite, it was
> lost.

Ha, got what you mean. Yes, we can take the use of success in sched_wakeup
event.
>
> Something like below?
>
> -- Steve
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 268a45e..e583989 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1404,6 +1404,7 @@ static void ttwu_activate(struct rq *rq, struct task_struct *p, int en_flags)
>   {
>   	activate_task(rq, p, en_flags);
>   	p->on_rq = 1;
> +	trace_sched_wakeup(p, true);
>   
>   	/* if a worker is waking up, notify workqueue */
>   	if (p->flags & PF_WQ_WORKER)
> @@ -1417,7 +1418,6 @@ static void
>   ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
>   {
>   	check_preempt_curr(rq, p, wake_flags);
> -	trace_sched_wakeup(p, true);
>   
>   	p->state = TASK_RUNNING;
>   #ifdef CONFIG_SMP
> @@ -1662,6 +1662,8 @@ static void try_to_wake_up_local(struct task_struct *p)
>   
>   	if (!p->on_rq)
>   		ttwu_activate(rq, p, ENQUEUE_WAKEUP);
> +	else
> +		trace_sched_wakeup(p, false);

Also we should add a false trace point in ttwu_remote().
>   
>   	ttwu_do_wakeup(rq, p, 0);
>   	ttwu_stat(p, smp_processor_id(), 0);

Thanx steven, I will send a new patch as you suggested here.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> .
>

