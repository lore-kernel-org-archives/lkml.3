Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbaHERxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 13:53:44 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:13193 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbaHERxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 13:53:43 -0400
Message-ID: <53E11A22.4070604@hp.com>
Date: Tue, 05 Aug 2014 13:53:38 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH] sched: Reduce contention in update_cfs_rq_blocked_load
References: <1407184118.11407.11.camel@j-VirtualBox>
In-Reply-To: <1407184118.11407.11.camel@j-VirtualBox>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 04:28 PM, Jason Low wrote:
> When running workloads on 2+ socket systems, based on perf profiles, the
> update_cfs_rq_blocked_load function constantly shows up as taking up a
> noticeable % of run time. This is especially apparent on an 8 socket
> machine. For example, when running the AIM7 custom workload, we see:
>
>     4.18%        reaim  [kernel.kallsyms]        [k] update_cfs_rq_blocked_load
>
> Much of the contention is in __update_cfs_rq_tg_load_contrib when we
> update the tg load contribution stats.  However, it turns out that in many
> cases, they don't need to be updated and "tg_contrib" is 0.
>
> This patch adds a check in __update_cfs_rq_tg_load_contrib to skip updating
> tg load contribution stats when nothing needs to be updated. This reduces the
> cacheline contention that would be unnecessary. In the above case, with the
> patch, perf reports the total time spent in this function went down by more
> than a factor of 3x:
>
>     1.18%        reaim  [kernel.kallsyms]        [k] update_cfs_rq_blocked_load
>
> Signed-off-by: Jason Low<jason.low2@hp.com>
> ---
>   kernel/sched/fair.c |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index bfa3c86..8d4cc72 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2377,6 +2377,9 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
>   	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
>   	tg_contrib -= cfs_rq->tg_load_contrib;
>
> +	if (!tg_contrib)
> +		return;
> +
>   	if (force_update || abs(tg_contrib)>  cfs_rq->tg_load_contrib / 8) {
>   		atomic_long_add(tg_contrib,&tg->load_avg);
>   		cfs_rq->tg_load_contrib += tg_contrib;
Reviewed-by: Waiman Long <Waiman.Long@hp.com>

