Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3K1Juc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 04:50:32 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49651 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3K1Ju1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 04:50:27 -0500
X-AuditID: 9c930179-b7b6eae000007f2a-ec-529711e139d3
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 6/8] perf sched: Introduce timehist command
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
	<1384806771-2945-7-git-send-email-dsahern@gmail.com>
Date: Thu, 28 Nov 2013 18:50:24 +0900
In-Reply-To: <1384806771-2945-7-git-send-email-dsahern@gmail.com> (David
	Ahern's message of "Mon, 18 Nov 2013 13:32:49 -0700")
Message-ID: <87siugq2hr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013 13:32:49 -0700, David Ahern wrote:
> 'perf sched timehist' provides an analysis of scheduling events.
>
> Example usage:
>     perf sched record -- sleep 1
>     perf sched timehist
>
> By default it shows the individual schedule events, including the time between
> sched-in events for the task, the task scheduling delay (time between wakeup
> and actually running) and run time for the task:
>
>            time cpu  task name[tid/pid]    b/n time sch delay  run time
> --------------- ---- -------------------- --------- --------- ---------
>    79371.874569 [11] gcc[31949]            0.000014  0.000000  0.001148
>    79371.874591 [10] gcc[31951]            0.000000  0.000000  0.000024
>    79371.874603 [10] migration/10[59]      0.003350  0.000004  0.000011
>    79371.874604 [11] <idle>                0.001148  0.000000  0.000035
>    79371.874723 [05] <idle>                0.000016  0.000000  0.001383
>    79371.874746 [05] gcc[31949]            0.000153  0.000078  0.000022
> ...
>
> If callchains were recorded they are appended to the line with a default stack depth of 5:
>
>    79371.874569 [11] gcc[31949]                  0.000014  0.000000  0.001148  wait_for_completion_killable do_fork sys_vfork stub_vfork __vfork
>    79371.874591 [10] gcc[31951]                  0.000000  0.000000  0.000024  __cond_resched _cond_resched wait_for_completion stop_one_cpu sched_exec
>    79371.874603 [10] migration/10[59]            0.003350  0.000004  0.000011  smpboot_thread_fn kthread ret_from_fork
>    79371.874604 [11] <idle>                      0.001148  0.000000  0.000035  cpu_startup_entry start_secondary
>    79371.874723 [05] <idle>                      0.000016  0.000000  0.001383  cpu_startup_entry start_secondary
>    79371.874746 [05] gcc[31949]                  0.000153  0.000078  0.000022  do_wait sys_wait4 system_call_fastpath __GI___waitpid
>
> --no-call-graph can be used to not show the callchains. --max-stack is used
> to control the number of frames shown (default of 5). -x/--excl options can
> be used to collapse redundant callchains to get more relevant data on screen.
>
> Similar to perf-trace -s and -S can be used to dump a statistical summary
> without or with events (respectively). Statistics include min run time,
> average run time and max run time. Stats are also shown for run time by
> cpu.
>
> The cpu-visual option provides a visual aid for sched switches by cpu:
> ...
>    79371.874569 [11]            s      gcc[31949]                  0.000014  0.000000  0.001148
>    79371.874591 [10]           s       gcc[31951]                  0.000000  0.000000  0.000024
>    79371.874603 [10]           s       migration/10[59]            0.003350  0.000004  0.000011
>    79371.874604 [11]            i      <idle>                      0.001148  0.000000  0.000035
>    79371.874723 [05]      i            <idle>                      0.000016  0.000000  0.001383
>    79371.874746 [05]      s            gcc[31949]                  0.000153  0.000078  0.000022
> ...
>
> Additional options:
> - -w option can be used to include a dump of wakeup events
> - -c comm to only display events and stats for the given comm (csv list)
> - -p/-t to only display events and stats for given pid/tid (csv list)

Looks like a very nice feature.  I haven't read the whole patch yet but
just want some comments.  More will come later. :)


[SNIP]
> +static inline void printf_nsecs(unsigned long long nsecs, int width_sec)
> +{
> +	unsigned long secs;
> +	unsigned long usecs;
> +
> +	secs = nsecs / NSECS_PER_SEC;
> +	nsecs -= secs * NSECS_PER_SEC;
> +	usecs = nsecs / NSECS_PER_USEC;
> +	printf("%*lu.%06lu ", width_sec, secs, usecs);
> +}

It seems very similar to what timehist_time_str() does.  Better to
factor out?


[SNIP]
> +static unsigned int comm_width = 20;
> +
> +static char *timehist_get_commstr(struct thread *thread)
> +{
> +	static char str[32];
> +	const char *comm = thread__comm_str(thread);
> +	pid_t tid = thread->tid;
> +	pid_t pid = thread->pid_;
> +	unsigned int n;
> +
> +	if (pid == 0)
> +		scnprintf(str, sizeof(str), "%s", comm);
> +
> +	else if (tid != pid)
> +		scnprintf(str, sizeof(str), "%s[%d/%d]", comm, tid, pid);
> +
> +	else
> +		scnprintf(str, sizeof(str), "%s[%d]", comm, tid);
> +
> +	n = strlen(str);

Why not just using return value of scnprintf()?


> +	if (n > comm_width)
> +		comm_width = n;
> +
> +	return str;
> +}
> +
> +static void timehist_header(struct perf_sched *sched)
> +{
> +	u32 max_cpus = sched->max_cpu;
> +	u32 i, j;
> +
> +	printf("%15s %-4s", "time", "cpu");
> +
> +	if (sched->show_cpu_visual && max_cpus) {
> +		printf(" ");
> +		for (i = 0, j = 0; i < max_cpus; ++i) {
> +			printf("%x", j++);
> +			if (j > 15)
> +				j = 0;
> +		}
> +		printf(" ");
> +	}
> +
> +	printf(" %-20s %9s %9s %9s",
> +		"task name[tid/pid]", "b/n time", "sch delay", "run time");
> +
> +	if (sched->show_wakeups)
> +		printf("  %-20s", "wakeup");
> +
> +	printf("\n");
> +
> +	printf("%15s %4s", "---------------", "----");

You might want to use "%.15s" and graph_dotted_line.

> +
> +	if (sched->show_cpu_visual && max_cpus) {
> +		printf(" ");
> +		for (i = 0; i < max_cpus; ++i)
> +			printf("-");
> +		printf(" ");
> +	}
> +
> +	printf(" %20s %9s %9s %9s",
> +		"--------------------", "---------", "---------", "---------");

Ditto.

> +
> +	if (sched->show_wakeups)
> +		printf("  %20s", "--------------------");

Ditto.

> +
> +	printf("\n");
> +}
> +
> +static char *timehist_time_str(char *tstr, int len, u64 t)
> +{
> +	unsigned long secs, usecs;
> +	unsigned long long nsecs;
> +
> +	nsecs = t;
> +	secs = nsecs / NSECS_PER_SEC;
> +	nsecs -= secs * NSECS_PER_SEC;
> +	usecs = nsecs / NSECS_PER_USEC;
> +	snprintf(tstr, len, "%5lu.%06lu", secs, usecs);
> +
> +	return tstr;
> +}

See above.

> +
> +static void timehist_print_sample(struct perf_sched *sched,
> +				  union perf_event *event,
> +				  struct perf_evsel *evsel,
> +				  struct perf_sample *sample,
> +				  struct thread *thread,
> +				  struct machine *machine)
> +{
> +	struct thread_runtime *tr = thread__priv(thread);
> +	char tstr[64];
> +	u32 max_cpus = sched->max_cpu;
> +
> +	printf("%15s ", timehist_time_str(tstr, sizeof(tstr), sample->time));
> +
> +	printf("[%02d] ", sample->cpu);
> +
> +	if (sched->show_cpu_visual && max_cpus) {
> +		u32 i;
> +		char c;
> +		for (i = 0; i < max_cpus; ++i) {
> +			if (i == sample->cpu)
> +				c = (thread->tid == 0) ? 'i' : 's';

It'd better explaining what the 'i' and 's' mean..


> +			else
> +				c = ' ';
> +			printf("%c", c);
> +		}
> +		printf("  ");
> +	}
> +
> +	printf("%-*s ", comm_width, timehist_get_commstr(thread));
> +
> +	printf_nsecs(tr->dt_between, 2);
> +	printf_nsecs(tr->dt_delay, 2);
> +	printf_nsecs(tr->dt_run, 2);
> +
> +	if (sched->show_wakeups)
> +		printf(" %-*s ", comm_width, "");
> +
> +	perf_evsel__print_ip(evsel, event, sample, machine,
> +			     PRINT_IP_OPT_SYM | PRINT_IP_OPT_ONELINE,
> +			     sched->max_stack);
> +
> +	printf("\n");
> +}

[SNIP]
> +static void free_idle_threads(void)
> +{
> +	int i;
> +
> +	if (idle_threads == NULL)
> +		return;
> +
> +	for (i = 0; i <= idle_max_cpu; ++i)
> +		free(idle_threads[i]);

Doesn't it need to be thread__delete(idle_threads[i]) ?

Thanks,
Namhyung

> +
> +	free(idle_threads);
> +}
