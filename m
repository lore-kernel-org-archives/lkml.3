Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab3KRN5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:57:11 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:34201 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3KRN5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:57:07 -0500
Date: Mon, 18 Nov 2013 10:57:00 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 2/3] perf script: Print comm, fork and exit events also
Message-ID: <20131118135700.GB3669@ghostprotocols.net>
References: <1384752894-10974-1-git-send-email-namhyung@kernel.org>
 <1384752894-10974-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384752894-10974-2-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 18, 2013 at 02:34:53PM +0900, Namhyung Kim escreveu:
> If --show-task option is given, also print internal COMM, FORK and
> EXIT events.  It would be helpful for debugging.

Humm, --show-task-events is clearer albeit long :-\ With shell
completion shouldn't be an issue tho.

Also, can't we use: perf_event__fprintf_{mmap,comm,task}?
 
>   $ perf script --show-task
>   ...
>          swapper     0 [009] 3350640.335261: sched:sched_switch: prev_comm=swapper/9
>            sleep  9486 [009] 3350640.335509: comm: perf --> sleep (9486)
>            sleep  9486 [009] 3350640.335806: sched:sched_stat_runtime: comm=sleep pid=9486
>          firefox  2635 [003] 3350641.275896: fork: firefox (2635 --> 9487)
>          firefox  2635 [003] 3350641.275896: sched:sched_process_fork: comm=firefox pid=2635
>            sleep  9486 [009] 3350641.336009: exit: sleep (9486)
> 
> Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
> Reviewed-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/Documentation/perf-script.txt |   3 +
>  tools/perf/builtin-script.c              | 115 +++++++++++++++++++++++++++++++
>  2 files changed, 118 insertions(+)
> 
> diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
> index e9cbfcddfa3f..9a9a7c3d592d 100644
> --- a/tools/perf/Documentation/perf-script.txt
> +++ b/tools/perf/Documentation/perf-script.txt
> @@ -203,6 +203,9 @@ OPTIONS
>  --show-kernel-path::
>  	Try to resolve the path of [kernel.kallsyms]
>  
> +--show-task
> +	Display task related events (e.g. FORK, COMM, EXIT).
> +
>  SEE ALSO
>  --------
>  linkperf:perf-record[1], linkperf:perf-script-perl[1],
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index b392770766dd..d05e6d835877 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -548,6 +548,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
>  struct perf_script {
>  	struct perf_tool	tool;
>  	struct perf_session	*session;
> +	bool			show_task_events;
>  };
>  
>  static int process_attr(struct perf_tool *tool, union perf_event *event,
> @@ -578,6 +579,111 @@ static int process_attr(struct perf_tool *tool, union perf_event *event,
>  	return perf_evsel__check_attr(evsel, scr->session);
>  }
>  
> +static int process_comm_event(struct perf_tool *tool,
> +			      union perf_event *event,
> +			      struct perf_sample *sample,
> +			      struct machine *machine)
> +{
> +	struct thread *thread;
> +	struct perf_script *script = container_of(tool, struct perf_script, tool);
> +	struct perf_session *session = script->session;
> +	struct perf_evsel *evsel = perf_evlist__first(session->evlist);
> +	char *oldname;
> +	int ret = -1;
> +
> +	thread = machine__findnew_thread(machine, event->comm.pid, event->comm.tid);
> +	if (thread == NULL) {
> +		pr_debug("problem processing COMM event, skipping it.\n");
> +		return -1;
> +	}
> +
> +	oldname = strdup(thread__comm_str(thread));
> +	if (oldname == NULL) {
> +		pr_debug("problem processing COMM event, skipping it.\n");
> +		return -1;
> +	}
> +
> +	if (perf_event__process_comm(tool, event, sample, machine) < 0)
> +		goto out;
> +
> +	if (!evsel->attr.sample_id_all) {
> +		sample->cpu = 0;
> +		sample->time = 0;
> +		sample->tid = event->comm.tid;
> +		sample->pid = event->comm.pid;
> +	}
> +	print_sample_start(sample, thread, evsel);
> +	printf("comm: %s --> %s (%d)\n", oldname, event->comm.comm,
> +	       event->comm.tid);
> +	ret = 0;
> +
> +out:
> +	free(oldname);
> +	return ret;
> +}
> +
> +static int process_fork_event(struct perf_tool *tool,
> +			      union perf_event *event,
> +			      struct perf_sample *sample,
> +			      struct machine *machine)
> +{
> +	struct thread *thread;
> +	struct perf_script *script = container_of(tool, struct perf_script, tool);
> +	struct perf_session *session = script->session;
> +	struct perf_evsel *evsel = perf_evlist__first(session->evlist);
> +
> +	if (perf_event__process_fork(tool, event, sample, machine) < 0)
> +		return -1;
> +
> +	thread = machine__findnew_thread(machine, event->fork.pid, event->fork.tid);
> +	if (thread == NULL) {
> +		pr_debug("problem processing FORK event, skipping it.\n");
> +		return -1;
> +	}
> +
> +	if (!evsel->attr.sample_id_all) {
> +		sample->cpu = 0;
> +		sample->time = event->fork.time;
> +		sample->tid = event->fork.tid;
> +		sample->pid = event->fork.pid;
> +	}
> +	print_sample_start(sample, thread, evsel);
> +	printf("fork: %s (%d --> %d)\n", thread__comm_str(thread),
> +	       event->fork.ptid, event->fork.tid);
> +
> +	return 0;
> +}
> +static int process_exit_event(struct perf_tool *tool,
> +			      union perf_event *event,
> +			      struct perf_sample *sample,
> +			      struct machine *machine)
> +{
> +	struct thread *thread;
> +	struct perf_script *script = container_of(tool, struct perf_script, tool);
> +	struct perf_session *session = script->session;
> +	struct perf_evsel *evsel = perf_evlist__first(session->evlist);
> +
> +	thread = machine__findnew_thread(machine, event->fork.pid, event->fork.tid);
> +	if (thread == NULL) {
> +		pr_debug("problem processing EXIT event, skipping it.\n");
> +		return -1;
> +	}
> +
> +	if (!evsel->attr.sample_id_all) {
> +		sample->cpu = 0;
> +		sample->time = 0;
> +		sample->tid = event->comm.tid;
> +		sample->pid = event->comm.pid;
> +	}
> +	print_sample_start(sample, thread, evsel);
> +	printf("exit: %s (%d)\n", thread__comm_str(thread), event->fork.tid);
> +
> +	if (perf_event__process_exit(tool, event, sample, machine) < 0)
> +		return -1;
> +
> +	return 0;
> +}
> +
>  static void sig_handler(int sig __maybe_unused)
>  {
>  	session_done = 1;
> @@ -589,6 +695,13 @@ static int __cmd_script(struct perf_script *script)
>  
>  	signal(SIGINT, sig_handler);
>  
> +	/* override event processing functions */
> +	if (script->show_task_events) {
> +		script->tool.comm = process_comm_event;
> +		script->tool.fork = process_fork_event;
> +		script->tool.exit = process_exit_event;
> +	}
> +
>  	ret = perf_session__process_events(script->session, &script->tool);
>  
>  	if (debug_mode)
> @@ -1351,6 +1464,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
>  		    "display extended information from perf.data file"),
>  	OPT_BOOLEAN('\0', "show-kernel-path", &symbol_conf.show_kernel_path,
>  		    "Show the path of [kernel.kallsyms]"),
> +	OPT_BOOLEAN('\0', "show-task", &script.show_task_events,
> +		    "Show the fork/comm/exit events"),
>  	OPT_END()
>  	};
>  	const char * const script_usage[] = {
> -- 
> 1.7.11.7
