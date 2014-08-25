Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbaHYNsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:48:01 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:65516 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbaHYNsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:48:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140811133352.GC9918@twins.programming.kicks-ass.net>
References: <20140810044127.GB11810@localhost> <20140810075915.GR9918@twins.programming.kicks-ass.net>
 <20140810105413.GA29451@localhost> <20140811133352.GC9918@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 25 Aug 2014 15:47:39 +0200
Message-ID: <CAKfTPtBnyeO1+1=Sbf6On-eXRG3th=0gsfhDectyQQuMCLeP-g@mail.gmail.com>
Subject: Re: [sched] 143e1e28cb4: +17.9% aim7.jobs-per-min, -9.7% hackbench.throughput
To: Peter Zijlstra <peterz@infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Ingo Molnar <mingo@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 August 2014 15:33, Peter Zijlstra <peterz@infradead.org> wrote:

[snip]

>
>
> Now I think I see why this is; we've reduced load balancing frequency
> significantly on this machine due to:

I agree with you about the root cause

>
>
> -#define SD_SIBLING_INIT (struct sched_domain) {                                \
> -       .min_interval           = 1,                                    \
> -       .max_interval           = 2,                                    \
>
>
> -#define SD_MC_INIT (struct sched_domain) {                             \
> -       .min_interval           = 1,                                    \
> -       .max_interval           = 4,                                    \
>
>
> -#define SD_CPU_INIT (struct sched_domain) {                            \
> -       .min_interval           = 1,                                    \
> -       .max_interval           = 4,                                    \
>
>
>         *sd = (struct sched_domain){
>                 .min_interval           = sd_weight,
>                 .max_interval           = 2*sd_weight,
>
> Which both increased the min and max value significantly for all domains
> involved.
>
> That said; I think we might want to do something like the below; I can
> imagine decreasing load balancing too much will negatively impact other
> workloads.
>
> Maybe slightly modified to make sure the first domain has a min_interval
> of 1.
>
> ---
>  kernel/sched/core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1211575a2208..67ed5d854da1 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6049,8 +6049,8 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
>                 sd_flags &= ~TOPOLOGY_SD_FLAGS;
>
>         *sd = (struct sched_domain){
> -               .min_interval           = sd_weight,
> -               .max_interval           = 2*sd_weight,
> +               .min_interval           = max(1, sd_weight/2),
> +               .max_interval           = sd_weight,

What about using ilog2 like the default scaling mode of other
scheduler tunables ?

Regards,
Vincent

>                 .busy_factor            = 32,
>                 .imbalance_pct          = 125,
>
> @@ -6076,7 +6076,7 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
>                                         ,
>
>                 .last_balance           = jiffies,
> -               .balance_interval       = sd_weight,
> +               .balance_interval       = max(1, sd_weight/2),
>                 .smt_gain               = 0,
>                 .max_newidle_lb_cost    = 0,
>                 .next_decay_max_lb_cost = jiffies,
