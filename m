Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3HTSEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:04:07 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38508 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3HTSEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:04:04 -0400
Message-ID: <5213AF91.6000403@gmail.com>
Date: Tue, 20 Aug 2013 12:04:01 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] perf: sample after exit loses thread correlation - v4
References: <1376491767-84171-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1376491767-84171-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping

On 8/14/13 8:49 AM, David Ahern wrote:
> Occassionally events (e.g., context-switch, sched tracepoints) are losing
> the conversion of sample data associated with a thread. For example:
>
> $ perf record -e sched:sched_switch -c 1 -a -- sleep 5
> $ perf script
> <selected events shown>
>      ls 30482 [000] 1379727.583037: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
>      ls 30482 [000] 1379727.586339: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
> :30482 30482 [000] 1379727.589462: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
>
> The last line lost the conversion from tid to comm. If you look at the events
> (perf script -D) you see why - a SAMPLE event is generated after the EXIT:
>
> 0 1379727589449774 0x1540b0 [0x38]: PERF_RECORD_EXIT(30482:30482):(30482:30482)
> 0 1379727589462497 0x1540e8 [0x80]: PERF_RECORD_SAMPLE(IP, 1): 30482/30482: 0xffffffff816416f1 period: 1 addr: 0
> ... thread: :30482:30482
>
> When perf processes the EXIT event the thread is moved to the dead_threads
> list. When the SAMPLE event is processed no thread exists for the pid so a new
> one is created by machine__findnew_thread.
>
> This patch address the problem by delaying the move to the dead_threads list
> until the tid is re-used (per Adrian's suggestion).
>
> With this patch we get the previous example shows:
>
>    ls 30482 [000] 1379727.583037: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
>    ls 30482 [000] 1379727.586339: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
>    ls 30482 [000] 1379727.589462: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
>
> and
>
>    0 1379727589449774 0x1540b0 [0x38]: PERF_RECORD_EXIT(30482:30482):(30482:30482)
>    0 1379727589462497 0x1540e8 [0x80]: PERF_RECORD_SAMPLE(IP, 1): 30482/30482: 0xffffffff816416f1 period: 1 addr: 0
>    ... thread: ls:30482
>
> v4: per Arnaldo's request add dead flag to thread struct and set when task exits
>
> v3: re-do from a time based check to a delayed move to dead_threads list
>
> v2: Rebased to latest perf/core branch. Changed time comparison to use
>      a macro which explicitly shows the time basis
>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   tools/perf/util/machine.c |   34 ++++++++++++++++++++--------------
>   tools/perf/util/thread.h  |    5 +++++
>   2 files changed, 25 insertions(+), 14 deletions(-)
>
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 4514e7e..574feb7 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1031,11 +1031,27 @@ out_problem:
>   	return 0;
>   }
>
> +static void machine__remove_thread(struct machine *machine, struct thread *th)
> +{
> +	machine->last_match = NULL;
> +	rb_erase(&th->rb_node, &machine->threads);
> +	/*
> +	 * We may have references to this thread, for instance in some hist_entry
> +	 * instances, so just move them to a separate list.
> +	 */
> +	list_add_tail(&th->node, &machine->dead_threads);
> +}
> +
>   int machine__process_fork_event(struct machine *machine, union perf_event *event)
>   {
> -	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
> +	struct thread *thread = machine__find_thread(machine, event->fork.tid);
>   	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
>
> +	/* if a thread currently exists for the thread id remove it */
> +	if (thread != NULL)
> +		machine__remove_thread(machine, thread);
> +
> +	thread = machine__findnew_thread(machine, event->fork.tid);
>   	if (dump_trace)
>   		perf_event__fprintf_task(event, stdout);
>
> @@ -1048,18 +1064,8 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
>   	return 0;
>   }
>
> -static void machine__remove_thread(struct machine *machine, struct thread *th)
> -{
> -	machine->last_match = NULL;
> -	rb_erase(&th->rb_node, &machine->threads);
> -	/*
> -	 * We may have references to this thread, for instance in some hist_entry
> -	 * instances, so just move them to a separate list.
> -	 */
> -	list_add_tail(&th->node, &machine->dead_threads);
> -}
> -
> -int machine__process_exit_event(struct machine *machine, union perf_event *event)
> +int machine__process_exit_event(struct machine *machine __maybe_unused,
> +				union perf_event *event)
>   {
>   	struct thread *thread = machine__find_thread(machine, event->fork.tid);
>
> @@ -1067,7 +1073,7 @@ int machine__process_exit_event(struct machine *machine, union perf_event *event
>   		perf_event__fprintf_task(event, stdout);
>
>   	if (thread != NULL)
> -		machine__remove_thread(machine, thread);
> +		thread__exited(thread);
>
>   	return 0;
>   }
> diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
> index 13c62c9..32d0601 100644
> --- a/tools/perf/util/thread.h
> +++ b/tools/perf/util/thread.h
> @@ -16,6 +16,7 @@ struct thread {
>   	pid_t			ppid;
>   	char			shortname[3];
>   	bool			comm_set;
> +	bool			dead; /* if set thread has exited */
>   	char			*comm;
>   	int			comm_len;
>
> @@ -26,6 +27,10 @@ struct machine;
>
>   struct thread *thread__new(pid_t tid);
>   void thread__delete(struct thread *self);
> +static inline void thread__exited(struct thread *thread)
> +{
> +	thread->dead = true;
> +}
>
>   int thread__set_comm(struct thread *self, const char *comm);
>   int thread__comm_len(struct thread *self);
>

