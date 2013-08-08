Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524Ab3HHOxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 10:53:54 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:37907 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965097Ab3HHOxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 10:53:52 -0400
Date: Thu, 8 Aug 2013 11:53:36 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 01/19] perf: sample after exit loses thread correlation -
 v3
Message-ID: <20130808145336.GD2851@ghostprotocols.net>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
 <1375930261-77273-2-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375930261-77273-2-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 07, 2013 at 10:50:43PM -0400, David Ahern escreveu:
> Occassionally events (e.g., context-switch, sched tracepoints) are losing
> the conversion of sample data associated with a thread. For example:

Humm, if we have a tool that traverses the list of threads in a machine
it will not know, after one of them exits, about it being dead, so I
think this needs to add a thread->dead, no?

As of now, from what I can remember, the closest to such a tool would
be:

 perf top --sort pid

But that uses hist_entries that would eventually be decayed as samples
would cease to be taken at most a few moments after the EXIT event.

But at least for debugging purposes, machine__fprintf() would list dead
threads as being present, i.e. alive till its pid gets reused.

This is the only, minor, problem that I see with this solution, what do
you think?

- Arnaldo
 
> $ perf record -e sched:sched_switch -c 1 -a -- sleep 5
> $ perf script
> <selected events shown>
>     ls 30482 [000] 1379727.583037: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
>     ls 30482 [000] 1379727.586339: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
> :30482 30482 [000] 1379727.589462: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
> 
> The last line lost the conversion from tid to comm. If you look at the events
> (perf script -D) you see why - SAMPLE event is generated after the EXIT:
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
>   ls 30482 [000] 1379727.583037: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
>   ls 30482 [000] 1379727.586339: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
>   ls 30482 [000] 1379727.589462: sched:sched_switch: prev_comm=ls prev_pid=30482 ...
> 
> and
> 
>   0 1379727589449774 0x1540b0 [0x38]: PERF_RECORD_EXIT(30482:30482):(30482:30482)
>   0 1379727589462497 0x1540e8 [0x80]: PERF_RECORD_SAMPLE(IP, 1): 30482/30482: 0xffffffff816416f1 period: 1 addr: 0
>   ... thread: ls:30482
> 
> v3: re-do from a time based check to a delayed move to dead_threads list
> 
> v2: Rebased to latest perf/core branch. Changed time comparison to use
>     a macro which explicitly shows the time basis
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
>  tools/perf/util/machine.c |   37 +++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index 6fcc358..7784a9d 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1011,11 +1011,27 @@ out_problem:
>  	return 0;
>  }
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
>  int machine__process_fork_event(struct machine *machine, union perf_event *event)
>  {
> -	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
> +	struct thread *thread = machine__find_thread(machine, event->fork.tid);
>  	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
>  
> +	/* if a thread currently exists for the thread id remove it */
> +	if (thread != NULL)
> +		machine__remove_thread(machine, thread);
> +
> +	thread = machine__findnew_thread(machine, event->fork.tid);
>  	if (dump_trace)
>  		perf_event__fprintf_task(event, stdout);
>  
> @@ -1028,27 +1044,12 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
>  	return 0;
>  }
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
>  {
> -	struct thread *thread = machine__find_thread(machine, event->fork.tid);
> -
>  	if (dump_trace)
>  		perf_event__fprintf_task(event, stdout);
>  
> -	if (thread != NULL)
> -		machine__remove_thread(machine, thread);
> -
>  	return 0;
>  }
>  
> -- 
> 1.7.10.1
