Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891Ab3GQRwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:52:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964845Ab3GQRvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:51:35 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 18/23] perf tools: Move synthetizing into single function
Date: Wed, 17 Jul 2013 19:49:58 +0200
Message-Id: <1374083403-14591-19-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving synthetizing into single function, so it
could be reused.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-record.c | 155 ++++++++++++++++++++++++++------------------
 1 file changed, 91 insertions(+), 64 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b67564c..33a5bce 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -317,6 +317,95 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 		       " relocation symbol.\n", machine->pid);
 }
 
+static int synthesize_record_pipe(struct perf_record *rec)
+{
+	struct perf_session  *session = rec->session;
+	struct perf_tool        *tool = &rec->tool;
+	struct perf_evlist    *evlist = rec->evlist;
+	int err;
+
+	err = perf_event__synthesize_attrs(tool, session,
+					   process_synthesized_event);
+	if (err < 0) {
+		pr_err("Couldn't synthesize attrs.\n");
+		return err;
+	}
+
+	if (have_tracepoints(&evlist->entries)) {
+		/*
+		 * FIXME err <= 0 here actually means that
+		 * there were no tracepoints so its not really
+		 * an error, just that we don't need to
+		 * synthesize anything.  We really have to
+		 * return this more properly and also
+		 * propagate errors that now are calling die()
+		 */
+		err = perf_event__synthesize_tracing_data(tool, rec->output, evlist,
+							  process_synthesized_event);
+		if (err <= 0) {
+			pr_err("Couldn't record tracing data.\n");
+			return err;
+		}
+		advance_output(rec, err);
+	}
+
+	return 0;
+}
+
+static int synthesize_record_file(struct perf_record *rec)
+{
+	struct perf_session  *session = rec->session;
+	struct perf_tool        *tool = &rec->tool;
+	struct perf_record_opts *opts = &rec->opts;
+	struct machine       *machine = &session->machines.host;
+	struct perf_evlist    *evlist = rec->evlist;
+	int err;
+
+	err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
+						 machine, "_text");
+	if (err < 0)
+		err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
+							 machine, "_stext");
+	if (err < 0)
+		pr_err("Couldn't record kernel reference relocation symbol\n"
+		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
+		       "Check /proc/kallsyms permission or run as root.\n");
+
+	err = perf_event__synthesize_modules(tool, process_synthesized_event,
+					     machine);
+	if (err < 0)
+		pr_err("Couldn't record kernel module information.\n"
+		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
+		       "Check /proc/modules permission or run as root.\n");
+
+	if (perf_guest)
+		machines__process_guests(&session->machines,
+					 perf_event__synthesize_guest_os, tool);
+
+	if (perf_target__has_task(&opts->target))
+		err = perf_event__synthesize_thread_map(tool, evlist->threads,
+						  process_synthesized_event,
+						  machine);
+	else if (perf_target__has_cpu(&opts->target))
+		err = perf_event__synthesize_threads(tool, process_synthesized_event,
+					       machine);
+	else /* command specified */
+		err = 0;
+
+	return err;
+}
+
+static int synthesize_record(struct perf_record *rec)
+{
+	struct perf_record_opts *opts = &rec->opts;
+	int err = 0;
+
+	if (opts->pipe_output)
+		err = synthesize_record_pipe(rec);
+
+	return err ? err : synthesize_record_file(rec);
+}
+
 static struct perf_event_header finished_round_event = {
 	.size = sizeof(struct perf_event_header),
 	.type = PERF_RECORD_FINISHED_ROUND,
@@ -351,8 +440,6 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	int err, output, feat;
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
-	struct machine *machine;
-	struct perf_tool *tool = &rec->tool;
 	struct perf_record_opts *opts = &rec->opts;
 	struct perf_evlist *evsel_list = rec->evlist;
 	const char *output_name = rec->output_name;
@@ -462,68 +549,8 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		goto out_delete_session;
 	}
 
-	machine = &session->machines.host;
-
-	if (opts->pipe_output) {
-		err = perf_event__synthesize_attrs(tool, session,
-						   process_synthesized_event);
-		if (err < 0) {
-			pr_err("Couldn't synthesize attrs.\n");
-			goto out_delete_session;
-		}
-
-		if (have_tracepoints(&evsel_list->entries)) {
-			/*
-			 * FIXME err <= 0 here actually means that
-			 * there were no tracepoints so its not really
-			 * an error, just that we don't need to
-			 * synthesize anything.  We really have to
-			 * return this more properly and also
-			 * propagate errors that now are calling die()
-			 */
-			err = perf_event__synthesize_tracing_data(tool, output, evsel_list,
-								  process_synthesized_event);
-			if (err <= 0) {
-				pr_err("Couldn't record tracing data.\n");
-				goto out_delete_session;
-			}
-			advance_output(rec, err);
-		}
-	}
-
-	err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
-						 machine, "_text");
-	if (err < 0)
-		err = perf_event__synthesize_kernel_mmap(tool, process_synthesized_event,
-							 machine, "_stext");
-	if (err < 0)
-		pr_err("Couldn't record kernel reference relocation symbol\n"
-		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
-		       "Check /proc/kallsyms permission or run as root.\n");
-
-	err = perf_event__synthesize_modules(tool, process_synthesized_event,
-					     machine);
-	if (err < 0)
-		pr_err("Couldn't record kernel module information.\n"
-		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
-		       "Check /proc/modules permission or run as root.\n");
-
-	if (perf_guest) {
-		machines__process_guests(&session->machines,
-					 perf_event__synthesize_guest_os, tool);
-	}
-
-	if (perf_target__has_task(&opts->target))
-		err = perf_event__synthesize_thread_map(tool, evsel_list->threads,
-						  process_synthesized_event,
-						  machine);
-	else if (perf_target__has_cpu(&opts->target))
-		err = perf_event__synthesize_threads(tool, process_synthesized_event,
-					       machine);
-	else /* command specified */
-		err = 0;
-
-	if (err != 0)
+	err = synthesize_record(rec);
+	if (err)
 		goto out_delete_session;
 
 	if (rec->realtime_prio) {
-- 
1.7.11.7

