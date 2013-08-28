Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3H1PEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:04:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40586 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab3H1O7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:59:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/21] perf trace: Implement -o/--output filename
Date: Wed, 28 Aug 2013 11:59:21 -0300
Message-Id: <1377701977-2085-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377701977-2085-1-git-send-email-acme@infradead.org>
References: <1377701977-2085-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To output all 'trace' output to a filename, just like 'strace -ofile'

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6q1homkwoayhmoq64y5vhel6@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt |   4 +
 tools/perf/builtin-trace.c              | 134 ++++++++++++++++++++------------
 2 files changed, 90 insertions(+), 48 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 3b3552a..2794efc 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -30,6 +30,10 @@ OPTIONS
 --expr::
 	List of events to show, currently only syscall names.
 
+-o::
+--output=::
+	Output file name.
+
 -p::
 --pid=::
 	Record events on existing process ID (comma separated list).
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 120fdfb..4235316 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -63,7 +63,7 @@ static size_t fprintf_duration(unsigned long t, FILE *fp)
 		printed += color_fprintf(fp, PERF_COLOR_YELLOW, "%6.3f ms", duration);
 	else
 		printed += color_fprintf(fp, PERF_COLOR_NORMAL, "%6.3f ms", duration);
-	return printed + fprintf(stdout, "): ");
+	return printed + fprintf(fp, "): ");
 }
 
 struct thread_trace {
@@ -80,7 +80,7 @@ static struct thread_trace *thread_trace__new(void)
 	return zalloc(sizeof(struct thread_trace));
 }
 
-static struct thread_trace *thread__trace(struct thread *thread)
+static struct thread_trace *thread__trace(struct thread *thread, FILE *fp)
 {
 	struct thread_trace *ttrace;
 
@@ -98,12 +98,13 @@ static struct thread_trace *thread__trace(struct thread *thread)
 
 	return ttrace;
 fail:
-	color_fprintf(stdout, PERF_COLOR_RED,
+	color_fprintf(fp, PERF_COLOR_RED,
 		      "WARNING: not enough memory, dropping samples!\n");
 	return NULL;
 }
 
 struct trace {
+	struct perf_tool	tool;
 	int			audit_machine;
 	struct {
 		int		max;
@@ -112,6 +113,7 @@ struct trace {
 	struct perf_record_opts opts;
 	struct machine		host;
 	u64			base_time;
+	FILE			*output;
 	struct strlist		*ev_qualifier;
 	unsigned long		nr_events;
 	bool			sched;
@@ -151,13 +153,14 @@ static size_t trace__fprintf_entry_head(struct trace *trace, struct thread *thre
 	return printed;
 }
 
-static int trace__process_event(struct machine *machine, union perf_event *event)
+static int trace__process_event(struct trace *trace, struct machine *machine,
+				union perf_event *event)
 {
 	int ret = 0;
 
 	switch (event->header.type) {
 	case PERF_RECORD_LOST:
-		color_fprintf(stdout, PERF_COLOR_RED,
+		color_fprintf(trace->output, PERF_COLOR_RED,
 			      "LOST %" PRIu64 " events!\n", event->lost.lost);
 		ret = machine__process_lost_event(machine, event);
 	default:
@@ -168,12 +171,13 @@ static int trace__process_event(struct machine *machine, union perf_event *event
 	return ret;
 }
 
-static int trace__tool_process(struct perf_tool *tool __maybe_unused,
+static int trace__tool_process(struct perf_tool *tool,
 			       union perf_event *event,
 			       struct perf_sample *sample __maybe_unused,
 			       struct machine *machine)
 {
-	return trace__process_event(machine, event);
+	struct trace *trace = container_of(tool, struct trace, tool);
+	return trace__process_event(trace, machine, event);
 }
 
 static int trace__symbols_init(struct trace *trace, struct perf_evlist *evlist)
@@ -187,11 +191,11 @@ static int trace__symbols_init(struct trace *trace, struct perf_evlist *evlist)
 	machine__create_kernel_maps(&trace->host);
 
 	if (perf_target__has_task(&trace->opts.target)) {
-		err = perf_event__synthesize_thread_map(NULL, evlist->threads,
+		err = perf_event__synthesize_thread_map(&trace->tool, evlist->threads,
 							trace__tool_process,
 							&trace->host);
 	} else {
-		err = perf_event__synthesize_threads(NULL, trace__tool_process,
+		err = perf_event__synthesize_threads(&trace->tool, trace__tool_process,
 						     &trace->host);
 	}
 
@@ -288,7 +292,7 @@ static struct syscall *trace__syscall_info(struct trace *trace,
 	int id = perf_evsel__intval(evsel, sample, "id");
 
 	if (id < 0) {
-		printf("Invalid syscall %d id, skipping...\n", id);
+		fprintf(trace->output, "Invalid syscall %d id, skipping...\n", id);
 		return NULL;
 	}
 
@@ -302,10 +306,10 @@ static struct syscall *trace__syscall_info(struct trace *trace,
 	return &trace->syscalls.table[id];
 
 out_cant_read:
-	printf("Problems reading syscall %d", id);
+	fprintf(trace->output, "Problems reading syscall %d", id);
 	if (id <= trace->syscalls.max && trace->syscalls.table[id].name != NULL)
-		printf("(%s)", trace->syscalls.table[id].name);
-	puts(" information");
+		fprintf(trace->output, "(%s)", trace->syscalls.table[id].name);
+	fputs(" information", trace->output);
 	return NULL;
 }
 
@@ -326,13 +330,13 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 		return 0;
 
 	thread = machine__findnew_thread(&trace->host, sample->tid);
-	ttrace = thread__trace(thread);
+	ttrace = thread__trace(thread, trace->output);
 	if (ttrace == NULL)
 		return -1;
 
 	args = perf_evsel__rawptr(evsel, sample, "args");
 	if (args == NULL) {
-		printf("Problems reading syscall arguments\n");
+		fprintf(trace->output, "Problems reading syscall arguments\n");
 		return -1;
 	}
 
@@ -352,8 +356,8 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 
 	if (!strcmp(sc->name, "exit_group") || !strcmp(sc->name, "exit")) {
 		if (!trace->duration_filter) {
-			trace__fprintf_entry_head(trace, thread, 1, sample->time, stdout);
-			printf("%-70s\n", ttrace->entry_str);
+			trace__fprintf_entry_head(trace, thread, 1, sample->time, trace->output);
+			fprintf(trace->output, "%-70s\n", ttrace->entry_str);
 		}
 	} else
 		ttrace->entry_pending = true;
@@ -377,7 +381,7 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 		return 0;
 
 	thread = machine__findnew_thread(&trace->host, sample->tid);
-	ttrace = thread__trace(thread);
+	ttrace = thread__trace(thread, trace->output);
 	if (ttrace == NULL)
 		return -1;
 
@@ -394,14 +398,14 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 	} else if (trace->duration_filter)
 		goto out;
 
-	trace__fprintf_entry_head(trace, thread, duration, sample->time, stdout);
+	trace__fprintf_entry_head(trace, thread, duration, sample->time, trace->output);
 
 	if (ttrace->entry_pending) {
-		printf("%-70s", ttrace->entry_str);
+		fprintf(trace->output, "%-70s", ttrace->entry_str);
 	} else {
-		printf(" ... [");
-		color_fprintf(stdout, PERF_COLOR_YELLOW, "continued");
-		printf("]: %s()", sc->name);
+		fprintf(trace->output, " ... [");
+		color_fprintf(trace->output, PERF_COLOR_YELLOW, "continued");
+		fprintf(trace->output, "]: %s()", sc->name);
 	}
 
 	if (ret < 0 && sc->fmt && sc->fmt->errmsg) {
@@ -409,13 +413,13 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 		const char *emsg = strerror_r(-ret, bf, sizeof(bf)),
 			   *e = audit_errno_to_name(-ret);
 
-		printf(") = -1 %s %s", e, emsg);
+		fprintf(trace->output, ") = -1 %s %s", e, emsg);
 	} else if (ret == 0 && sc->fmt && sc->fmt->timeout)
-		printf(") = 0 Timeout");
+		fprintf(trace->output, ") = 0 Timeout");
 	else
-		printf(") = %d", ret);
+		fprintf(trace->output, ") = %d", ret);
 
-	putchar('\n');
+	fputc('\n', trace->output);
 out:
 	ttrace->entry_pending = false;
 
@@ -428,7 +432,7 @@ static int trace__sched_stat_runtime(struct trace *trace, struct perf_evsel *evs
         u64 runtime = perf_evsel__intval(evsel, sample, "runtime");
 	double runtime_ms = (double)runtime / NSEC_PER_MSEC;
 	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
-	struct thread_trace *ttrace = thread__trace(thread);
+	struct thread_trace *ttrace = thread__trace(thread, trace->output);
 
 	if (ttrace == NULL)
 		goto out_dump;
@@ -438,7 +442,7 @@ static int trace__sched_stat_runtime(struct trace *trace, struct perf_evsel *evs
 	return 0;
 
 out_dump:
-	printf("%s: comm=%s,pid=%u,runtime=%" PRIu64 ",vruntime=%" PRIu64 ")\n",
+	fprintf(trace->output, "%s: comm=%s,pid=%u,runtime=%" PRIu64 ",vruntime=%" PRIu64 ")\n",
 	       evsel->name,
 	       perf_evsel__strval(evsel, sample, "comm"),
 	       (pid_t)perf_evsel__intval(evsel, sample, "pid"),
@@ -456,32 +460,32 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	const bool forks = argc > 0;
 
 	if (evlist == NULL) {
-		printf("Not enough memory to run!\n");
+		fprintf(trace->output, "Not enough memory to run!\n");
 		goto out;
 	}
 
 	if (perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_enter", trace__sys_enter) ||
 	    perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_exit", trace__sys_exit)) {
-		printf("Couldn't read the raw_syscalls tracepoints information!\n");
+		fprintf(trace->output, "Couldn't read the raw_syscalls tracepoints information!\n");
 		goto out_delete_evlist;
 	}
 
 	if (trace->sched &&
 	    perf_evlist__add_newtp(evlist, "sched", "sched_stat_runtime",
 				   trace__sched_stat_runtime)) {
-		printf("Couldn't read the sched_stat_runtime tracepoint information!\n");
+		fprintf(trace->output, "Couldn't read the sched_stat_runtime tracepoint information!\n");
 		goto out_delete_evlist;
 	}
 
 	err = perf_evlist__create_maps(evlist, &trace->opts.target);
 	if (err < 0) {
-		printf("Problems parsing the target to trace, check your options!\n");
+		fprintf(trace->output, "Problems parsing the target to trace, check your options!\n");
 		goto out_delete_evlist;
 	}
 
 	err = trace__symbols_init(trace, evlist);
 	if (err < 0) {
-		printf("Problems initializing symbol libraries!\n");
+		fprintf(trace->output, "Problems initializing symbol libraries!\n");
 		goto out_delete_maps;
 	}
 
@@ -494,20 +498,20 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 		err = perf_evlist__prepare_workload(evlist, &trace->opts.target,
 						    argv, false, false);
 		if (err < 0) {
-			printf("Couldn't run the workload!\n");
+			fprintf(trace->output, "Couldn't run the workload!\n");
 			goto out_delete_maps;
 		}
 	}
 
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
-		printf("Couldn't create the events: %s\n", strerror(errno));
+		fprintf(trace->output, "Couldn't create the events: %s\n", strerror(errno));
 		goto out_delete_maps;
 	}
 
 	err = perf_evlist__mmap(evlist, UINT_MAX, false);
 	if (err < 0) {
-		printf("Couldn't mmap the events: %s\n", strerror(errno));
+		fprintf(trace->output, "Couldn't mmap the events: %s\n", strerror(errno));
 		goto out_close_evlist;
 	}
 
@@ -532,7 +536,7 @@ again:
 
 			err = perf_evlist__parse_sample(evlist, event, &sample);
 			if (err) {
-				printf("Can't parse sample, err = %d, skipping...\n", err);
+				fprintf(trace->output, "Can't parse sample, err = %d, skipping...\n", err);
 				continue;
 			}
 
@@ -540,18 +544,18 @@ again:
 				trace->base_time = sample.time;
 
 			if (type != PERF_RECORD_SAMPLE) {
-				trace__process_event(&trace->host, event);
+				trace__process_event(trace, &trace->host, event);
 				continue;
 			}
 
 			evsel = perf_evlist__id2evsel(evlist, sample.id);
 			if (evsel == NULL) {
-				printf("Unknown tp ID %" PRIu64 ", skipping...\n", sample.id);
+				fprintf(trace->output, "Unknown tp ID %" PRIu64 ", skipping...\n", sample.id);
 				continue;
 			}
 
 			if (sample.raw_data == NULL) {
-				printf("%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
+				fprintf(trace->output, "%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
 				       perf_evsel__name(evsel), sample.tid,
 				       sample.cpu, sample.raw_size);
 				continue;
@@ -640,6 +644,23 @@ static int trace__set_duration(const struct option *opt, const char *str,
 	return 0;
 }
 
+static int trace__open_output(struct trace *trace, const char *filename)
+{
+	struct stat st;
+
+	if (!stat(filename, &st) && st.st_size) {
+		char oldname[PATH_MAX];
+
+		scnprintf(oldname, sizeof(oldname), "%s.old", filename);
+		unlink(oldname);
+		rename(filename, oldname);
+	}
+
+	trace->output = fopen(filename, "w");
+
+	return trace->output == NULL ? -errno : 0;
+}
+
 int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	const char * const trace_usage[] = {
@@ -662,11 +683,14 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 			.no_delay      = true,
 			.mmap_pages    = 1024,
 		},
+		.output = stdout,
 	};
+	const char *output_name = NULL;
 	const char *ev_qualifier_str = NULL;
 	const struct option trace_options[] = {
 	OPT_STRING('e', "expr", &ev_qualifier_str, "expr",
 		    "list of events to trace"),
+	OPT_STRING('o', "output", &output_name, "file", "output file name"),
 	OPT_STRING('p', "pid", &trace.opts.target.pid, "pid",
 		    "trace events on existing process id"),
 	OPT_STRING(0, "tid", &trace.opts.target.tid, "tid",
@@ -692,26 +716,36 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
 
+	if (output_name != NULL) {
+		err = trace__open_output(&trace, output_name);
+		if (err < 0) {
+			perror("failed to create output file");
+			goto out;
+		}
+	}
+
 	if (ev_qualifier_str != NULL) {
 		trace.ev_qualifier = strlist__new(true, ev_qualifier_str);
 		if (trace.ev_qualifier == NULL) {
-			puts("Not enough memory to parse event qualifier");
-			return -ENOMEM;
+			fputs("Not enough memory to parse event qualifier",
+			      trace.output);
+			err = -ENOMEM;
+			goto out_close;
 		}
 	}
 
 	err = perf_target__validate(&trace.opts.target);
 	if (err) {
 		perf_target__strerror(&trace.opts.target, err, bf, sizeof(bf));
-		printf("%s", bf);
-		return err;
+		fprintf(trace.output, "%s", bf);
+		goto out_close;
 	}
 
 	err = perf_target__parse_uid(&trace.opts.target);
 	if (err) {
 		perf_target__strerror(&trace.opts.target, err, bf, sizeof(bf));
-		printf("%s", bf);
-		return err;
+		fprintf(trace.output, "%s", bf);
+		goto out_close;
 	}
 
 	if (!argc && perf_target__none(&trace.opts.target))
@@ -720,7 +754,11 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	err = trace__run(&trace, argc, argv);
 
 	if (trace.sched && !err)
-		trace__fprintf_thread_summary(&trace, stdout);
+		trace__fprintf_thread_summary(&trace, trace.output);
 
+out_close:
+	if (output_name != NULL)
+		fclose(trace.output);
+out:
 	return err;
 }
-- 
1.8.1.4

