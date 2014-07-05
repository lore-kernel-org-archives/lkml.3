Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbaGEKlj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:41:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57812 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbaGEKlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:41:35 -0400
Date: Sat, 5 Jul 2014 03:41:15 -0700
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-598d02c5a07b60e5c824184cdaf697b70f3c452a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, stfomichev@yandex-team.ru,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, stfomichev@yandex-team.ru, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1403799268-1367-3-git-send-email-stfomichev@yandex-team.ru>
References: <1403799268-1367-3-git-send-email-stfomichev@yandex-team.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add support for pagefault tracing
Git-Commit-ID: 598d02c5a07b60e5c824184cdaf697b70f3c452a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  598d02c5a07b60e5c824184cdaf697b70f3c452a
Gitweb:     http://git.kernel.org/tip/598d02c5a07b60e5c824184cdaf697b70f3c452a
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Thu, 26 Jun 2014 20:14:25 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 26 Jun 2014 16:07:43 -0300

perf trace: Add support for pagefault tracing

This patch adds optional pagefault tracing support to 'perf trace'.

Using -F/--pf option user can specify whether he wants minor, major or
all pagefault events to be traced. This patch adds only live mode,
record and replace will come in a separate patch.

Example output:

  1756272.905 ( 0.000 ms): curl/5937 majfault [0x7fa7261978b6] => /usr/lib/x86_64-linux-gnu/libkrb5.so.26.0.0@0x85288 (d.)
  1862866.036 ( 0.000 ms): wget/8460 majfault [__clear_user+0x3f] => 0x659cb4 (?k)

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1403799268-1367-3-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt |  39 ++++++++++
 tools/perf/builtin-trace.c              | 125 +++++++++++++++++++++++++++++++-
 2 files changed, 163 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index fae38d9..72397d9 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -107,6 +107,45 @@ the thread executes on the designated CPUs. Default is to monitor all CPUs.
 	Show tool stats such as number of times fd->pathname was discovered thru
 	hooking the open syscall return + vfs_getname or via reading /proc/pid/fd, etc.
 
+-F=[all|min|maj]::
+--pf=[all|min|maj]::
+	Trace pagefaults. Optionally, you can specify whether you want minor,
+	major or all pagefaults. Default value is maj.
+
+PAGEFAULTS
+----------
+
+When tracing pagefaults, the format of the trace is as follows:
+
+<min|maj>fault [<ip.symbol>+<ip.offset>] => <addr.dso@addr.offset> (<map type><addr level>).
+
+- min/maj indicates whether fault event is minor or major;
+- ip.symbol shows symbol for instruction pointer (the code that generated the
+  fault); if no debug symbols available, perf trace will print raw IP;
+- addr.dso shows DSO for the faulted address;
+- map type is either 'd' for non-executable maps or 'x' for executable maps;
+- addr level is either 'k' for kernel dso or '.' for user dso.
+
+For symbols resolution you may need to install debugging symbols.
+
+Please be aware that duration is currently always 0 and doesn't reflect actual
+time it took for fault to be handled!
+
+When --verbose specified, perf trace tries to print all available information
+for both IP and fault address in the form of dso@symbol+offset.
+
+EXAMPLES
+--------
+
+Trace syscalls, major and minor pagefaults:
+
+ $ perf trace -F all
+
+  1416.547 ( 0.000 ms): python/20235 majfault [CRYPTO_push_info_+0x0] => /lib/x86_64-linux-gnu/libcrypto.so.1.0.0@0x61be0 (x.)
+
+  As you can see, there was major pagefault in python process, from
+  CRYPTO_push_info_ routine which faulted somewhere in libcrypto.so.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script[1]
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 4a9e26b..1985c3b 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1178,6 +1178,9 @@ fail:
 	return NULL;
 }
 
+#define TRACE_PFMAJ		(1 << 0)
+#define TRACE_PFMIN		(1 << 1)
+
 struct trace {
 	struct perf_tool	tool;
 	struct {
@@ -1212,6 +1215,7 @@ struct trace {
 	bool			summary_only;
 	bool			show_comm;
 	bool			show_tool_stats;
+	int			trace_pgfaults;
 };
 
 static int trace__set_fd_pathname(struct thread *thread, int fd, const char *pathname)
@@ -1773,6 +1777,68 @@ out_dump:
 	return 0;
 }
 
+static void print_location(FILE *f, struct perf_sample *sample,
+			   struct addr_location *al,
+			   bool print_dso, bool print_sym)
+{
+
+	if ((verbose || print_dso) && al->map)
+		fprintf(f, "%s@", al->map->dso->long_name);
+
+	if ((verbose || print_sym) && al->sym)
+		fprintf(f, "%s+0x%lx", al->sym->name,
+			al->addr - al->sym->start);
+	else if (al->map)
+		fprintf(f, "0x%lx", al->addr);
+	else
+		fprintf(f, "0x%lx", sample->addr);
+}
+
+static int trace__pgfault(struct trace *trace,
+			  struct perf_evsel *evsel,
+			  union perf_event *event,
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
+	fprintf(trace->output, "%sfault [",
+		evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MAJ ?
+		"maj" : "min");
+
+	print_location(trace->output, sample, &al, false, true);
+
+	fprintf(trace->output, "] => ");
+
+	thread__find_addr_location(thread, trace->host, cpumode, MAP__VARIABLE,
+				   sample->addr, &al);
+
+	if (!al.map) {
+		thread__find_addr_location(thread, trace->host, cpumode,
+					   MAP__FUNCTION, sample->addr, &al);
+
+		if (al.map)
+			map_type = 'x';
+		else
+			map_type = '?';
+	}
+
+	print_location(trace->output, sample, &al, true, false);
+
+	fprintf(trace->output, " (%c%c)\n", map_type, al.level);
+
+	return 0;
+}
+
 static bool skip_sample(struct trace *trace, struct perf_sample *sample)
 {
 	if ((trace->pid_list && intlist__find(trace->pid_list, sample->pid)) ||
@@ -1887,6 +1953,30 @@ static void perf_evlist__add_vfs_getname(struct perf_evlist *evlist)
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
@@ -1907,6 +1997,14 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	perf_evlist__add_vfs_getname(evlist);
 
+	if ((trace->trace_pgfaults & TRACE_PFMAJ) &&
+	    perf_evlist__add_pgfault(evlist, PERF_COUNT_SW_PAGE_FAULTS_MAJ))
+		goto out_error_tp;
+
+	if ((trace->trace_pgfaults & TRACE_PFMIN) &&
+	    perf_evlist__add_pgfault(evlist, PERF_COUNT_SW_PAGE_FAULTS_MIN))
+		goto out_error_tp;
+
 	if (trace->sched &&
 		perf_evlist__add_newtp(evlist, "sched", "sched_stat_runtime",
 				trace__sched_stat_runtime))
@@ -1987,7 +2085,8 @@ again:
 				goto next_event;
 			}
 
-			if (sample.raw_data == NULL) {
+			if (evsel->attr.type == PERF_TYPE_TRACEPOINT &&
+			    sample.raw_data == NULL) {
 				fprintf(trace->output, "%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
 				       perf_evsel__name(evsel), sample.tid,
 				       sample.cpu, sample.raw_size);
@@ -2269,6 +2368,23 @@ static int trace__open_output(struct trace *trace, const char *filename)
 	return trace->output == NULL ? -errno : 0;
 }
 
+static int parse_pagefaults(const struct option *opt, const char *str,
+			    int unset __maybe_unused)
+{
+	int *trace_pgfaults = opt->value;
+
+	if (strcmp(str, "all") == 0)
+		*trace_pgfaults |= TRACE_PFMAJ | TRACE_PFMIN;
+	else if (strcmp(str, "maj") == 0)
+		*trace_pgfaults |= TRACE_PFMAJ;
+	else if (strcmp(str, "min") == 0)
+		*trace_pgfaults |= TRACE_PFMIN;
+	else
+		return -1;
+
+	return 0;
+}
+
 int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	const char * const trace_usage[] = {
@@ -2335,6 +2451,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show only syscall summary with statistics"),
 	OPT_BOOLEAN('S', "with-summary", &trace.summary,
 		    "Show all syscalls and summary with statistics"),
+	OPT_CALLBACK_DEFAULT('F', "pf", &trace.trace_pgfaults, "all|maj|min",
+		     "Trace pagefaults", parse_pagefaults, "maj"),
 	OPT_END()
 	};
 	int err;
@@ -2349,6 +2467,11 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (trace.summary_only)
 		trace.summary = trace.summary_only;
 
+	if (trace.trace_pgfaults) {
+		trace.opts.sample_address = true;
+		trace.opts.sample_time = true;
+	}
+
 	if (output_name != NULL) {
 		err = trace__open_output(&trace, output_name);
 		if (err < 0) {
