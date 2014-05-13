Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaEMCmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 22:42:11 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:56565 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751524AbaEMCmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 22:42:09 -0400
X-IronPort-AV: E=Sophos;i="4.97,1040,1389715200"; 
   d="scan'208";a="30430981"
Message-ID: <53717874.2020200@cn.fujitsu.com>
Date: Tue, 13 May 2014 10:42:12 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: <peterz@infradead.org>, <acme@infradead.org>, <jolsa@kernel.org>,
        <rostedt@goodmis.org>, <mingo@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_tools/sched: Remove nr_state_machine_bugs in perf
 latency.
References: <20140512181946.GG13467@laptop.programming.kicks-ass.net> <1399945101-21736-1-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1399945101-21736-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi jiri or Arnaldo,
     It seems Peter really do not like the usage of 
sched_wakeup(.success), and
don't plan to support it in scheduler any more.  Please consider to 
append this patch
too when you take the patch from Peter.  Thanx :)

On 05/13/2014 10:38 AM, Dongsheng Yang wrote:
> As we do not use .success in sched_wakeup event any more, then
> we can not guarantee that the task when wakeup event happen is
> out of run queue. So the message of nr_state_machine_bugs is
> not correct.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>   tools/perf/builtin-sched.c | 19 ++++++++-----------
>   1 file changed, 8 insertions(+), 11 deletions(-)
>
> diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
> index d3fb0ed..5b2fc62 100644
> --- a/tools/perf/builtin-sched.c
> +++ b/tools/perf/builtin-sched.c
> @@ -149,7 +149,6 @@ struct perf_sched {
>   	unsigned long	 nr_runs;
>   	unsigned long	 nr_timestamps;
>   	unsigned long	 nr_unordered_timestamps;
> -	unsigned long	 nr_state_machine_bugs;
>   	unsigned long	 nr_context_switch_bugs;
>   	unsigned long	 nr_events;
>   	unsigned long	 nr_lost_chunks;
> @@ -1037,12 +1036,18 @@ static int latency_wakeup_event(struct perf_sched *sched,
>   	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
>   
>   	/*
> +	 * As we do not guarantee the wakeup event happens when
> +	 * task is out of run queue, also may happen when task is
> +	 * on run queue and wakeup only change ->state to TASK_RUNNING,
> +	 * then we should not set the ->wake_up_time when wake up a
> +	 * task which is on run queue.
> +	 *
>   	 * You WILL be missing events if you've recorded only
>   	 * one CPU, or are only looking at only one, so don't
> -	 * make useless noise.
> +	 * skip in this case.
>   	 */
>   	if (sched->profile_cpu == -1 && atom->state != THREAD_SLEEPING)
> -		sched->nr_state_machine_bugs++;
> +		return 0;
>   
>   	sched->nr_timestamps++;
>   	if (atom->sched_out_time > timestamp) {
> @@ -1496,14 +1501,6 @@ static void print_bad_events(struct perf_sched *sched)
>   			(double)sched->nr_lost_events/(double)sched->nr_events * 100.0,
>   			sched->nr_lost_events, sched->nr_events, sched->nr_lost_chunks);
>   	}
> -	if (sched->nr_state_machine_bugs && sched->nr_timestamps) {
> -		printf("  INFO: %.3f%% state machine bugs (%ld out of %ld)",
> -			(double)sched->nr_state_machine_bugs/(double)sched->nr_timestamps*100.0,
> -			sched->nr_state_machine_bugs, sched->nr_timestamps);
> -		if (sched->nr_lost_events)
> -			printf(" (due to lost events?)");
> -		printf("\n");
> -	}
>   	if (sched->nr_context_switch_bugs && sched->nr_timestamps) {
>   		printf("  INFO: %.3f%% context switch bugs (%ld out of %ld)",
>   			(double)sched->nr_context_switch_bugs/(double)sched->nr_timestamps*100.0,

