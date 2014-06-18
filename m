Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaFRPA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:00:56 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:42968 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251AbaFRPAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:00:52 -0400
X-Yandex-Uniq: 73bb85bd-5711-44d0-9922-92e73238d17a
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, dsahern@gmail.com, stfomichev@yandex-team.ru,
        jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] perf trace: add support for pagefault tracing
Date: Wed, 18 Jun 2014 18:59:21 +0400
Message-Id: <1403103565-6388-2-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403103565-6388-1-git-send-email-stfomichev@yandex-team.ru>
References: <1403103565-6388-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/Documentation/perf-trace.txt |  12 ++
 tools/perf/builtin-trace.c              | 198 ++++++++++++++++++++++++++------
 2 files changed, 176 insertions(+), 34 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index fae38d9a44a4..7da5f75a45f1 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -107,6 +107,18 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 	Show tool stats such as number of times fd->pathname was discovered thru
 	hooking the open syscall return + vfs_getname or via reading /proc/pid/fd, etc.
 
+-f::
+--pgfaults::
+	Trace major pagefaults. To also trace minor pagefaults, specify this
+	option twice.
+
+EXAMPLES
+--------
+
+Trace syscalls, major and minor pagefaults:
+
+ $ perf trace -f -f
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script[1]
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f954c26de231..6c7ae048db59 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1211,6 +1211,7 @@ struct trace {
 	bool			summary_only;
 	bool			show_comm;
 	bool			show_tool_stats;
+	int			trace_pgfaults;
 };
 
 static int trace__set_fd_pathname(struct thread *thread, int fd, const char *pathname)
@@ -1534,7 +1535,9 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 	return printed;
 }
 
-typedef int (*tracepoint_handler)(struct trace *trace, struct perf_evsel *evsel,
+typedef int (*tracepoint_handler)(struct trace *trace,
+				  union perf_event *event,
+				  struct perf_evsel *evsel,
 				  struct perf_sample *sample);
 
 static struct syscall *trace__syscall_info(struct trace *trace,
@@ -1606,7 +1609,9 @@ static void thread__update_stats(struct thread_trace *ttrace,
 	update_stats(stats, duration);
 }
 
-static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
+static int trace__sys_enter(struct trace *trace,
+			    union perf_event *event __maybe_unused,
+			    struct perf_evsel *evsel,
 			    struct perf_sample *sample)
 {
 	char *msg;
@@ -1655,7 +1660,9 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	return 0;
 }
 
-static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
+static int trace__sys_exit(struct trace *trace,
+			   union perf_event *event __maybe_unused,
+			   struct perf_evsel *evsel,
 			   struct perf_sample *sample)
 {
 	int ret;
@@ -1734,14 +1741,18 @@ out:
 	return 0;
 }
 
-static int trace__vfs_getname(struct trace *trace, struct perf_evsel *evsel,
+static int trace__vfs_getname(struct trace *trace,
+			      union perf_event *event __maybe_unused,
+			      struct perf_evsel *evsel,
 			      struct perf_sample *sample)
 {
 	trace->last_vfs_getname = perf_evsel__rawptr(evsel, sample, "pathname");
 	return 0;
 }
 
-static int trace__sched_stat_runtime(struct trace *trace, struct perf_evsel *evsel,
+static int trace__sched_stat_runtime(struct trace *trace,
+				     union perf_event *event __maybe_unused,
+				     struct perf_evsel *evsel,
 				     struct perf_sample *sample)
 {
         u64 runtime = perf_evsel__intval(evsel, sample, "runtime");
@@ -1768,6 +1779,69 @@ out_dump:
 	return 0;
 }
 
+static bool valid_dso(struct addr_location *al, struct perf_sample *sample)
+{
+	if (al->map && al->map->dso &&
+	    al->map->start <= sample->addr &&
+	    al->map->end > sample->addr)
+		return true;
+	else
+		return false;
+}
+
+static int trace__pgfault(struct trace *trace,
+			  union perf_event *event,
+			  struct perf_evsel *evsel,
+			  struct perf_sample *sample)
+{
+	struct thread *thread;
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct addr_location al;
+	char map_type = 'd';
+
+	thread = machine__findnew_thread(trace->host, sample->pid, sample->tid);
+
+	thread__find_addr_location(thread, trace->host, cpumode, MAP__FUNCTION,
+			      sample->ip, &al);
+
+	trace__fprintf_entry_head(trace, thread, 0, sample->time, trace->output);
+
+	fprintf(trace->output, "%sfault ",
+		evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MAJ ?
+		"maj" : "min");
+
+	if (al.sym)
+		fprintf(trace->output, "[%s+0x%lx]",
+			al.sym->name, al.addr - al.sym->start);
+	else
+		fprintf(trace->output, "[0x%lx]", sample->ip);
+
+	fprintf(trace->output, " => ");
+
+	thread__find_addr_map(thread, trace->host, cpumode, MAP__VARIABLE,
+			      sample->addr, &al);
+
+	if (!valid_dso(&al, sample)) {
+		thread__find_addr_map(thread, trace->host, cpumode,
+				      MAP__FUNCTION, sample->addr, &al);
+
+		if (valid_dso(&al, sample))
+			map_type = 'x';
+	}
+
+	if (valid_dso(&al, sample)) {
+		fprintf(trace->output, "%s+0x%lx",
+			al.map->dso->long_name, sample->addr - al.map->start);
+	} else {
+		map_type = '?';
+		fprintf(trace->output, "0x%lx", sample->addr);
+	}
+
+	fprintf(trace->output, " (%c%c)\n", map_type, al.level);
+
+	return 0;
+}
+
 static bool skip_sample(struct trace *trace, struct perf_sample *sample)
 {
 	if ((trace->pid_list && intlist__find(trace->pid_list, sample->pid)) ||
@@ -1781,7 +1855,7 @@ static bool skip_sample(struct trace *trace, struct perf_sample *sample)
 }
 
 static int trace__process_sample(struct perf_tool *tool,
-				 union perf_event *event __maybe_unused,
+				 union perf_event *event,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct machine *machine __maybe_unused)
@@ -1799,7 +1873,7 @@ static int trace__process_sample(struct perf_tool *tool,
 
 	if (handler) {
 		++trace->nr_events;
-		handler(trace, evsel, sample);
+		handler(trace, event, evsel, sample);
 	}
 
 	return err;
@@ -1826,7 +1900,7 @@ static int parse_target_str(struct trace *trace)
 	return 0;
 }
 
-static int trace__record(int argc, const char **argv)
+static int trace__record(struct trace *trace, int argc, const char **argv)
 {
 	unsigned int rec_argc, i, j;
 	const char **rec_argv;
@@ -1835,34 +1909,52 @@ static int trace__record(int argc, const char **argv)
 		"-R",
 		"-m", "1024",
 		"-c", "1",
-		"-e",
 	};
 
+	const char * const sc_args[] = { "-e", };
+	unsigned int sc_args_nr = ARRAY_SIZE(sc_args);
+	const char * const majpf_args[] = { "-e", "major-faults" };
+	unsigned int majpf_args_nr = ARRAY_SIZE(majpf_args);
+	const char * const minpf_args[] = { "-e", "minor-faults" };
+	unsigned int minpf_args_nr = ARRAY_SIZE(minpf_args);
+
 	/* +1 is for the event string below */
-	rec_argc = ARRAY_SIZE(record_args) + 1 + argc;
+	rec_argc = ARRAY_SIZE(record_args) + sc_args_nr + 1 +
+		majpf_args_nr + minpf_args_nr + argc;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
 	if (rec_argv == NULL)
 		return -ENOMEM;
 
+	j = 0;
 	for (i = 0; i < ARRAY_SIZE(record_args); i++)
-		rec_argv[i] = record_args[i];
+		rec_argv[j++] = record_args[i];
+
+	for (i = 0; i < sc_args_nr; i++)
+		rec_argv[j++] = sc_args[i];
 
 	/* event string may be different for older kernels - e.g., RHEL6 */
 	if (is_valid_tracepoint("raw_syscalls:sys_enter"))
-		rec_argv[i] = "raw_syscalls:sys_enter,raw_syscalls:sys_exit";
+		rec_argv[j++] = "raw_syscalls:sys_enter,raw_syscalls:sys_exit";
 	else if (is_valid_tracepoint("syscalls:sys_enter"))
-		rec_argv[i] = "syscalls:sys_enter,syscalls:sys_exit";
+		rec_argv[j++] = "syscalls:sys_enter,syscalls:sys_exit";
 	else {
 		pr_err("Neither raw_syscalls nor syscalls events exist.\n");
 		return -1;
 	}
-	i++;
 
-	for (j = 0; j < (unsigned int)argc; j++, i++)
-		rec_argv[i] = argv[j];
+	if (trace->trace_pgfaults)
+		for (i = 0; i < majpf_args_nr; i++)
+			rec_argv[j++] = majpf_args[i];
+
+	if (trace->trace_pgfaults > 1)
+		for (i = 0; i < minpf_args_nr; i++)
+			rec_argv[j++] = minpf_args[i];
 
-	return cmd_record(i, rec_argv, NULL);
+	for (i = 0; i < (unsigned int)argc; i++)
+		rec_argv[j++] = argv[i];
+
+	return cmd_record(j, rec_argv, NULL);
 }
 
 static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp);
@@ -1882,6 +1974,30 @@ static void perf_evlist__add_vfs_getname(struct perf_evlist *evlist)
 	perf_evlist__add(evlist, evsel);
 }
 
+static int perf_evlist__add_pgfault(struct perf_evlist *evlist,
+				    u64 config)
+{
+	struct perf_evsel *evsel;
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_SOFTWARE,
+		.mmap_data = 1,
+		.sample_period = 1,
+	};
+
+	attr.config = config;
+
+	event_attr_init(&attr);
+
+	evsel = perf_evsel__new(&attr);
+	if (!evsel)
+		return -ENOMEM;
+
+	evsel->handler = trace__pgfault;
+	perf_evlist__add(evlist, evsel);
+
+	return 0;
+}
+
 static int trace__run(struct trace *trace, int argc, const char **argv)
 {
 	struct perf_evlist *evlist = perf_evlist__new();
@@ -1902,6 +2018,14 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	perf_evlist__add_vfs_getname(evlist);
 
+	if (trace->trace_pgfaults &&
+	    perf_evlist__add_pgfault(evlist, PERF_COUNT_SW_PAGE_FAULTS_MAJ))
+		goto out_error_tp;
+
+	if (trace->trace_pgfaults > 1 &&
+	    perf_evlist__add_pgfault(evlist, PERF_COUNT_SW_PAGE_FAULTS_MIN))
+		goto out_error_tp;
+
 	if (trace->sched &&
 		perf_evlist__add_newtp(evlist, "sched", "sched_stat_runtime",
 				trace__sched_stat_runtime))
@@ -1982,7 +2106,8 @@ again:
 				goto next_event;
 			}
 
-			if (sample.raw_data == NULL) {
+			if (evsel->attr.type != PERF_TYPE_SOFTWARE &&
+			    sample.raw_data == NULL) {
 				fprintf(trace->output, "%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
 				       perf_evsel__name(evsel), sample.tid,
 				       sample.cpu, sample.raw_size);
@@ -1990,7 +2115,7 @@ again:
 			}
 
 			handler = evsel->handler;
-			handler(trace, evsel, &sample);
+			handler(trace, event, evsel, &sample);
 next_event:
 			perf_evlist__mmap_consume(evlist, i);
 
@@ -2093,13 +2218,10 @@ static int trace__replay(struct trace *trace)
 	if (evsel == NULL)
 		evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
 							     "syscalls:sys_enter");
-	if (evsel == NULL) {
-		pr_err("Data file does not have raw_syscalls:sys_enter event\n");
-		goto out;
-	}
 
-	if (perf_evsel__init_syscall_tp(evsel, trace__sys_enter) < 0 ||
-	    perf_evsel__init_sc_tp_ptr_field(evsel, args)) {
+	if (evsel &&
+	    (perf_evsel__init_syscall_tp(evsel, trace__sys_enter) < 0 ||
+	    perf_evsel__init_sc_tp_ptr_field(evsel, args))) {
 		pr_err("Error during initialize raw_syscalls:sys_enter event\n");
 		goto out;
 	}
@@ -2109,15 +2231,19 @@ static int trace__replay(struct trace *trace)
 	if (evsel == NULL)
 		evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
 							     "syscalls:sys_exit");
-	if (evsel == NULL) {
-		pr_err("Data file does not have raw_syscalls:sys_exit event\n");
+	if (evsel &&
+	    (perf_evsel__init_syscall_tp(evsel, trace__sys_exit) < 0 ||
+	    perf_evsel__init_sc_tp_uint_field(evsel, ret))) {
+		pr_err("Error during initialize raw_syscalls:sys_exit event\n");
 		goto out;
 	}
 
-	if (perf_evsel__init_syscall_tp(evsel, trace__sys_exit) < 0 ||
-	    perf_evsel__init_sc_tp_uint_field(evsel, ret)) {
-		pr_err("Error during initialize raw_syscalls:sys_exit event\n");
-		goto out;
+	evlist__for_each(session->evlist, evsel) {
+		if (evsel->attr.type == PERF_TYPE_SOFTWARE &&
+		    (evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MAJ ||
+		     evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MIN ||
+		     evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS))
+			evsel->handler = trace__pgfault;
 	}
 
 	err = parse_target_str(trace);
@@ -2290,6 +2416,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 			.user_interval = ULLONG_MAX,
 			.no_buffering  = true,
 			.mmap_pages    = 1024,
+			.sample_address	= true,
+			.sample_time	= true,
 		},
 		.output = stdout,
 		.show_comm = true,
@@ -2330,15 +2458,17 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show only syscall summary with statistics"),
 	OPT_BOOLEAN('S', "with-summary", &trace.summary,
 		    "Show all syscalls and summary with statistics"),
+	OPT_INCR('f', "pgfaults", &trace.trace_pgfaults, "Trace pagefaults"),
 	OPT_END()
 	};
 	int err;
 	char bf[BUFSIZ];
 
-	if ((argc > 1) && (strcmp(argv[1], "record") == 0))
-		return trace__record(argc-2, &argv[2]);
+	argc = parse_options(argc, argv, trace_options, trace_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
 
-	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
+	if ((argc >= 1) && (strcmp(argv[0], "record") == 0))
+		return trace__record(&trace, argc-1, &argv[1]);
 
 	/* summary_only implies summary option, but don't overwrite summary if set */
 	if (trace.summary_only)
-- 
1.8.3.2

