Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaAOLAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 06:00:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33753 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaAOLAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:00:42 -0500
Date: Wed, 15 Jan 2014 12:00:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, raistlin@linux.it,
        juri.lelli@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] [ tip/sched/core ] System unresponsive after booting
Message-ID: <20140115110018.GA31570@twins.programming.kicks-ass.net>
References: <52D64676.4040000@linaro.org>
 <20140115092245.GA15190@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115092245.GA15190@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 10:22:45AM +0100, Ingo Molnar wrote:
> 1)
> 
> There's this change to __setscheduler():
> 
> -__setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio)
> +/* Actually do priority change: must hold pi & rq lock. */
> +static void __setscheduler(struct rq *rq, struct task_struct *p,
> +                          const struct sched_attr *attr)
>  {
> +       int policy = attr->sched_policy;
> +
>         p->policy = policy;
> -       p->rt_priority = prio;
> +
> +       if (rt_policy(policy))
> +               p->rt_priority = attr->sched_priority;
> +       else
> +               p->static_prio = NICE_TO_PRIO(attr->sched_nice);
> +
> 
> 
> doesnt this change keep p->rt_priority uninitialized in the 
> normalize_task() case?
> 
> I.e. rt_priority should still be set unconditionally. In the 
> SCHED_NORMAL case that will be a zero initialization.

But why? SCHED_NORMAL doesn't care about rt_priority afaict. And once it
gets priority boosted we'll set the rt_priority again to whatever is
propagated from the pi-chain.

> 2)
> 
> It's not clear why this change to __setscheduler() was done:
> 
>         /*
>          * Allow unprivileged RT tasks to decrease priority:
>          */
>         if (user && !capable(CAP_SYS_NICE)) {
> +               if (fair_policy(policy)) {
> +                       if (!can_nice(p, attr->sched_nice))
> +                               return -EPERM;
> +               }
> +
>                 if (rt_policy(policy)) {o

Bah, I'm pretty sure I wrote that :/ And I can't for the life of me
remember why I did that. Complete fail there.
