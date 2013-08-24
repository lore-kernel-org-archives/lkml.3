Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3HXKeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 06:34:31 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:64469 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3HXKea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 06:34:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130819160425.527872672@infradead.org>
References: <20130819160058.539049611@infradead.org> <20130819160425.527872672@infradead.org>
From: Paul Turner <pjt@google.com>
Date: Sat, 24 Aug 2013 03:33:59 -0700
Message-ID: <CAPM31RKTZYsZ6V6qjBNwZfE0i0Tk3fgeH_rxnDoG=pM24-TG_g@mail.gmail.com>
Subject: Re: [PATCH 07/10] sched, fair: Optimize find_busiest_queue()
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>, Joonsoo Kim <js1304@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 9:01 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> Use for_each_cpu_and() and thereby avoid computing the capacity for
> CPUs we know we're not interested in.
>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched/fair.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4977,7 +4977,7 @@ static struct rq *find_busiest_queue(str
>         unsigned long busiest_load = 0, busiest_power = SCHED_POWER_SCALE;
>         int i;
>
> -       for_each_cpu(i, sched_group_cpus(group)) {
> +       for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
>                 unsigned long power = power_of(i);
>                 unsigned long capacity = DIV_ROUND_CLOSEST(power,
>                                                            SCHED_POWER_SCALE);
> @@ -4986,9 +4986,6 @@ static struct rq *find_busiest_queue(str
>                 if (!capacity)
>                         capacity = fix_small_capacity(env->sd, group);
>
> -               if (!cpumask_test_cpu(i, env->cpus))
> -                       continue;
> -
>                 rq = cpu_rq(i);
>                 wl = weighted_cpuload(i);

There's no need to actually do the divisions immediately below this also.

e.g.
  unsigned long max_load_power = SCHED_POWER_SCALE;
  ...
  if (wl * max_load_power > max_load * power) {
   max_load = wl;
   max_load_power = power;
   ...

This would actually end up being a little more accurate even.

[ Alternatively without caching max_load_power we could compare wl *
power vs max_load * SCHED_POWER_SCALE. ]

Reviewed-by: Paul Turner <pjt@google.com>
