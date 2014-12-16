Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbaLPPiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:38:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:48008 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaLPPiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:38:08 -0500
Date: Tue, 16 Dec 2014 16:37:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sched: odd values for effective load calculations
Message-ID: <20141216153755.GB3337@twins.programming.kicks-ass.net>
References: <547E42F7.5070105@gmail.com>
 <20141213083012.GH32572@gmail.com>
 <20141215121227.GZ29390@twins.programming.kicks-ass.net>
 <20141215131410.GM10476@twins.programming.kicks-ass.net>
 <548FC338.4050409@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548FC338.4050409@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 12:29:28AM -0500, Sasha Levin wrote:
> On 12/15/2014 08:14 AM, Peter Zijlstra wrote:

> > Pinning my hopes on that reproducability thing :/
> 
> Okay, yeah, it's very reproducible. I've added:
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index df2cdf7..e1fbe1a 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4486,7 +4486,7 @@ static int wake_wide(struct task_struct *p)
> 
>  static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  {
> -       s64 this_load, load;
> +       s64 this_load, load, tmps;
>         s64 this_eff_load, prev_eff_load;
>         int idx, this_cpu, prev_cpu;
>         struct task_group *tg;
> @@ -4538,6 +4538,9 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>         prev_eff_load *= capacity_of(this_cpu);
> 
>         if (this_load > 0) {
> +               if (__builtin_mul_overflow(this_eff_load, this_load +
> +                        effective_load(tg, this_cpu, weight, weight), &tmps))
> +                       printk(KERN_CRIT "%lld %lld %lld", this_eff_load, this_load, effective_load(tg, this_cpu, weight, weight));
>                 this_eff_load *= this_load +
>                         effective_load(tg, this_cpu, weight, weight);

Minor nit: in general it would be recommend to evaluate effective_load()
once, not thrice, state might have changed in between the calls and
results might differ. Still..

> And got:
> 
> [  437.511964] 91600 1765238667340524 81

> So it's actually 'this_load' going bananas.

That is indeed a fairly strong indication its not effective_load(),
which is good, since that's one hairy piece of cra^Wcode.

Lemme go ponder about this_load.
