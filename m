Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab3DBOix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:38:53 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:64630 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab3DBOiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:38:52 -0400
MIME-Version: 1.0
In-Reply-To: <1364654108-16307-11-git-send-email-alex.shi@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
	<1364654108-16307-11-git-send-email-alex.shi@intel.com>
Date: Tue, 2 Apr 2013 16:38:51 +0200
Message-ID: <CAKfTPtAb1byoZRJZPfvGGgQBEVDCNya3tC6NF83v0khiGV9dDw@mail.gmail.com>
Subject: Re: [patch v6 10/21] sched: get rq potential maximum utilization
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Paul Turner <pjt@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 March 2013 15:34, Alex Shi <alex.shi@intel.com> wrote:
> Since the rt task priority is higher than fair tasks, cfs_rq utilization
> is just the left of rt utilization.
>
> When there are some cfs tasks in queue, the potential utilization may
> be yielded, so mulitiplying cfs task number to get max potential
> utilization of cfs. Then the rq utilization is sum of rt util and cfs
> util.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index ae87dab..0feeaee 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3350,6 +3350,22 @@ struct sg_lb_stats {
>         unsigned int group_util;        /* sum utilization of group */
>  };
>
> +static unsigned long scale_rt_util(int cpu);
> +
> +static unsigned int max_rq_util(int cpu)
> +{
> +       struct rq *rq = cpu_rq(cpu);
> +       unsigned int rt_util = scale_rt_util(cpu);
> +       unsigned int cfs_util;
> +       unsigned int nr_running;
> +
> +       cfs_util = (FULL_UTIL - rt_util) > rq->util ? rq->util
> +                       : (FULL_UTIL - rt_util);

rt_util and rq->util don't use the same computation algorithm so the
results are hardly comparable or addable. In addition, some RT tasks
can have impacted the rq->util, so they will be accounted in both
side.

Vincent

> +       nr_running = rq->nr_running ? rq->nr_running : 1;
> +
> +       return rt_util + cfs_util * nr_running;
> +}
> +
>  /*
>   * sched_balance_self: balance the current task (running on cpu) in domains
>   * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
> --
> 1.7.12
>
