Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaHDUwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 16:52:36 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47496 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaHDUwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 16:52:34 -0400
From: bsegall@google.com
To: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Waiman Long <Waiman.Long@hp.com>,
        Mel Gorman <mgorman@suse.de>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Rik van Riel <riel@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Chegu Vinod <chegu_vinod@hp.com>, Scott J Norton <scott.norton@hp.com>,
        pjt@google.com
Subject: Re: [PATCH] sched: Reduce contention in update_cfs_rq_blocked_load
References: <1407184118.11407.11.camel@j-VirtualBox>
Date: Mon, 04 Aug 2014 13:52:31 -0700
In-Reply-To: <1407184118.11407.11.camel@j-VirtualBox> (Jason Low's message of
	"Mon, 04 Aug 2014 13:28:38 -0700")
Message-ID: <xm264mxsugds.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Low <jason.low2@hp.com> writes:

> When running workloads on 2+ socket systems, based on perf profiles, the
> update_cfs_rq_blocked_load function constantly shows up as taking up a
> noticeable % of run time. This is especially apparent on an 8 socket
> machine. For example, when running the AIM7 custom workload, we see:
>
>    4.18%        reaim  [kernel.kallsyms]        [k] update_cfs_rq_blocked_load
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
>    1.18%        reaim  [kernel.kallsyms]        [k] update_cfs_rq_blocked_load
>
> Signed-off-by: Jason Low <jason.low2@hp.com>
Reviewed-by: Ben Segall <bsegall@google.com>

That said, it might be better to remove force_update for this function,
or make it just reduce the minimum to /64 or something. If the test is
easy to run it would be good to see what it's like just removing the
force_update param for this function to see if it's worth worrying
about or if the zero case catches ~all the perf gain. Paul, your thoughts?

> ---
>  kernel/sched/fair.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index bfa3c86..8d4cc72 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2377,6 +2377,9 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
>  	tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
>  	tg_contrib -= cfs_rq->tg_load_contrib;
>  
> +	if (!tg_contrib)
> +		return;
> +
>  	if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
>  		atomic_long_add(tg_contrib, &tg->load_avg);
>  		cfs_rq->tg_load_contrib += tg_contrib;
