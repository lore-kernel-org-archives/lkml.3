Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaESM5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:57:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbaESM5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:57:40 -0400
Date: Mon, 19 May 2014 13:59:57 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: peterz@infradead.org, acme@infradead.org, jolsa@kernel.org,
        rostedt@goodmis.org, mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_tools/sched: Remove nr_state_machine_bugs in perf
 latency.
Message-ID: <20140519115957.GF5027@krava.brq.redhat.com>
References: <20140512181946.GG13467@laptop.programming.kicks-ass.net>
 <1399945101-21736-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399945101-21736-1-git-send-email-yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

any ACKs?

thanks,
jirka

On Tue, May 13, 2014 at 10:38:21AM +0900, Dongsheng Yang wrote:
> As we do not use .success in sched_wakeup event any more, then
> we can not guarantee that the task when wakeup event happen is
> out of run queue. So the message of nr_state_machine_bugs is
> not correct.
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>  tools/perf/builtin-sched.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
> index d3fb0ed..5b2fc62 100644
> --- a/tools/perf/builtin-sched.c
> +++ b/tools/perf/builtin-sched.c
> @@ -149,7 +149,6 @@ struct perf_sched {
>  	unsigned long	 nr_runs;
>  	unsigned long	 nr_timestamps;
>  	unsigned long	 nr_unordered_timestamps;
> -	unsigned long	 nr_state_machine_bugs;
>  	unsigned long	 nr_context_switch_bugs;
>  	unsigned long	 nr_events;
>  	unsigned long	 nr_lost_chunks;
> @@ -1037,12 +1036,18 @@ static int latency_wakeup_event(struct perf_sched *sched,
>  	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
>  
>  	/*
> +	 * As we do not guarantee the wakeup event happens when
> +	 * task is out of run queue, also may happen when task is
> +	 * on run queue and wakeup only change ->state to TASK_RUNNING,
> +	 * then we should not set the ->wake_up_time when wake up a
> +	 * task which is on run queue. 
> +	 *
>  	 * You WILL be missing events if you've recorded only
>  	 * one CPU, or are only looking at only one, so don't
> -	 * make useless noise.
> +	 * skip in this case.
>  	 */
>  	if (sched->profile_cpu == -1 && atom->state != THREAD_SLEEPING)
> -		sched->nr_state_machine_bugs++;
> +		return 0;
>  
>  	sched->nr_timestamps++;
>  	if (atom->sched_out_time > timestamp) {
> @@ -1496,14 +1501,6 @@ static void print_bad_events(struct perf_sched *sched)
>  			(double)sched->nr_lost_events/(double)sched->nr_events * 100.0,
>  			sched->nr_lost_events, sched->nr_events, sched->nr_lost_chunks);
>  	}
> -	if (sched->nr_state_machine_bugs && sched->nr_timestamps) {
> -		printf("  INFO: %.3f%% state machine bugs (%ld out of %ld)",
> -			(double)sched->nr_state_machine_bugs/(double)sched->nr_timestamps*100.0,
> -			sched->nr_state_machine_bugs, sched->nr_timestamps);
> -		if (sched->nr_lost_events)
> -			printf(" (due to lost events?)");
> -		printf("\n");
> -	}
>  	if (sched->nr_context_switch_bugs && sched->nr_timestamps) {
>  		printf("  INFO: %.3f%% context switch bugs (%ld out of %ld)",
>  			(double)sched->nr_context_switch_bugs/(double)sched->nr_timestamps*100.0,
> -- 
> 1.8.2.1
> 
