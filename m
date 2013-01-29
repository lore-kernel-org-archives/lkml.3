Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3A2N0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:26:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:17774 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3A2N0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:26:02 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=c0UBshceEHQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=BbWSn5lSMCYA:10 a=vaJtXVxTAAAA:8 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=5mAfLvFASU47h-itb6wA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=3Rfx1nUSh_UA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359465960.17639.25.camel@gandalf.local.home>
Subject: Re: [PATCH]sched/rt: Do not try to push tasks if pinned task
 switches to RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Tue, 29 Jan 2013 08:26:00 -0500
In-Reply-To: <3019251359404630@web18f.yandex.ru>
References: <3019251359404630@web18f.yandex.ru>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 00:23 +0400, Kirill Tkhai wrote:
> Just switched pinned task is not able to be pushed. If the rq had had
> several RT tasks before they have already been considered as candidates
> to be pushed (or pulled).

Thanks, but I have one minor nit.

> 
> Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: linux-rt-users <linux-rt-users@vger.kernel.org>
> ---
>  kernel/sched/rt.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 4e8f0f4..5f7d92b 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1925,9 +1925,9 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
>  	 */
>  	if (p->on_rq && rq->curr != p) {
>  #ifdef CONFIG_SMP
> -		if (rq->rt.overloaded && push_rt_task(rq) &&
> +		if (rq->rt.overloaded && p->nr_cpus_allowed > 1 &&

I would swap the order here. That is, check p->nr_cpus_allowed before
rq->rt.overloaded. The order doesn't really matter, and even though
rq->rt.overloaded is probably more likely to be 0, it is used by other
CPUs. And as a micro-optimization, I rather read something that is used
by only one CPU than to read something that may be modified by many
CPUs.

-- Steve


>  		    /* Don't resched if we changed runqueues */
> -		    rq != task_rq(p))
> +		    push_rt_task(rq) && rq != task_rq(p))
>  			check_resched = 0;
>  #endif /* CONFIG_SMP */
>  		if (check_resched && p->prio < rq->curr->prio)


