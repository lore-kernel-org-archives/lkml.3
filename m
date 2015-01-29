Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbbA2IRv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:17:51 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51244 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbbA2IKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:08 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 16/42] perf tools: Pass session arg to perf_event__preprocess_sample()
Date: Thu, 29 Jan 2015 17:06:57 +0900
Message-Id: <1422518843-25818-17-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_event__preprocess_sample() translates a given ip into a
matching symbol.  To do that, it first finds a corresponding thread
and map in the current thread tree.  But for indexed data files, it
needs to find a thread (and map) with slightly different APIs using
timestamp.  So it needs a way to know whether this session deals with
an indexed data file or not.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c     |  3 ++-
 tools/perf/builtin-diff.c         | 13 +++++++++----
 tools/perf/builtin-mem.c          |  6 +++++-
 tools/perf/builtin-report.c       |  3 ++-
 tools/perf/builtin-script.c       | 20 +++++++++++---------
 tools/perf/builtin-timechart.c    | 10 +++++++---
 tools/perf/builtin-top.c          |  3 ++-
 tools/perf/tests/hists_cumulate.c |  2 +-
 tools/perf/tests/hists_filter.c   |  2 +-
 tools/perf/tests/hists_link.c     |  4 ++--
 tools/perf/tests/hists_output.c   |  2 +-
 tools/perf/util/event.c           |  3 ++-
 tools/perf/util/event.h           |  4 +++-
 13 files changed, 48 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 747f86103599..b89e4c6ed488 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -85,7 +85,8 @@ static int process_sample_event(struct perf_tool *tool,
 	struct perf_annotate *ann = container_of(tool, struct perf_annotate, tool);
 	struct addr_location al;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample,
+					  ann->session) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 74aada554b12..3e2229227062 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -42,6 +42,7 @@ struct diff_hpp_fmt {
 };
 
 struct data__file {
+	struct perf_tool	tool;
 	struct perf_session	*session;
 	struct perf_data_file	file;
 	int			 idx;
@@ -320,16 +321,18 @@ static int hists__add_entry(struct hists *hists,
 	return -ENOMEM;
 }
 
-static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
+static int diff__process_sample_event(struct perf_tool *tool,
 				      union perf_event *event,
 				      struct perf_sample *sample,
 				      struct perf_evsel *evsel,
 				      struct machine *machine)
 {
 	struct addr_location al;
+	struct data__file *d = container_of(tool, struct data__file, tool);
 	struct hists *hists = evsel__hists(evsel);
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample,
+					  d->session) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
@@ -740,14 +743,16 @@ static int __cmd_diff(void)
 	int ret = -EINVAL, i;
 
 	data__for_each_file(i, d) {
-		d->session = perf_session__new(&d->file, false, &tool);
+		memcpy(&d->tool, &tool, sizeof(tool));
+
+		d->session = perf_session__new(&d->file, false, &d->tool);
 		if (!d->session) {
 			pr_err("Failed to open %s\n", d->file.path);
 			ret = -1;
 			goto out_delete;
 		}
 
-		ret = perf_session__process_events(d->session, &tool);
+		ret = perf_session__process_events(d->session, &d->tool);
 		if (ret) {
 			pr_err("Failed to process %s\n", d->file.path);
 			goto out_delete;
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 9b5663950a4d..21d46918860e 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -12,6 +12,7 @@
 
 struct perf_mem {
 	struct perf_tool	tool;
+	struct perf_session	*session;
 	char const		*input_name;
 	bool			hide_unresolved;
 	bool			dump_raw;
@@ -66,7 +67,8 @@ dump_raw_samples(struct perf_tool *tool,
 	struct addr_location al;
 	const char *fmt;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample,
+					  mem->session) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 				event->header.type);
 		return -1;
@@ -129,6 +131,8 @@ static int report_raw_events(struct perf_mem *mem)
 	if (session == NULL)
 		return -1;
 
+	mem->session = session;
+
 	if (mem->cpu_list) {
 		ret = perf_session__cpu_bitmap(session, mem->cpu_list,
 					       mem->cpu_bitmap);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4cac79ad3085..68d06bc02266 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -142,7 +142,8 @@ static int process_sample_event(struct perf_tool *tool,
 	};
 	int ret;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample,
+					  rep->session) < 0) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ce304dfd962a..ab920f8cded6 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -542,13 +542,21 @@ static int cleanup_scripting(void)
 	return scripting_ops->stop_script();
 }
 
-static int process_sample_event(struct perf_tool *tool __maybe_unused,
+struct perf_script {
+	struct perf_tool	tool;
+	struct perf_session	*session;
+	bool			show_task_events;
+	bool			show_mmap_events;
+};
+
+static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
 				struct machine *machine)
 {
 	struct addr_location al;
+	struct perf_script *script = container_of(tool, struct perf_script, tool);
 	struct thread *thread = machine__findnew_thread(machine, sample->pid,
 							sample->tid);
 
@@ -569,7 +577,8 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 		return 0;
 	}
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample,
+					  script->session) < 0) {
 		pr_err("problem processing %d event, skipping it.\n",
 		       event->header.type);
 		return -1;
@@ -586,13 +595,6 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
-struct perf_script {
-	struct perf_tool	tool;
-	struct perf_session	*session;
-	bool			show_task_events;
-	bool			show_mmap_events;
-};
-
 static int process_attr(struct perf_tool *tool, union perf_event *event,
 			struct perf_evlist **pevlist)
 {
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index f3bb1a4bf060..4178727be12c 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -48,6 +48,7 @@ struct wake_event;
 
 struct timechart {
 	struct perf_tool	tool;
+	struct perf_session	*session;
 	struct per_pid		*all_data;
 	struct power_event	*power_events;
 	struct wake_event	*wake_events;
@@ -469,7 +470,8 @@ static void sched_switch(struct timechart *tchart, int cpu, u64 timestamp,
 
 static const char *cat_backtrace(union perf_event *event,
 				 struct perf_sample *sample,
-				 struct machine *machine)
+				 struct machine *machine,
+				 struct perf_session *session)
 {
 	struct addr_location al;
 	unsigned int i;
@@ -488,7 +490,8 @@ static const char *cat_backtrace(union perf_event *event,
 	if (!chain)
 		goto exit;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample,
+					  session) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		goto exit;
@@ -567,7 +570,7 @@ static int process_sample_event(struct perf_tool *tool,
 	if (evsel->handler != NULL) {
 		tracepoint_handler f = evsel->handler;
 		return f(tchart, evsel, sample,
-			 cat_backtrace(event, sample, machine));
+			 cat_backtrace(event, sample, machine, tchart->session));
 	}
 
 	return 0;
@@ -1623,6 +1626,7 @@ static int __cmd_timechart(struct timechart *tchart, const char *output_name)
 		goto out_delete;
 	}
 
+	tchart->session = session;
 	ret = perf_session__process_events(session, &tchart->tool);
 	if (ret)
 		goto out_delete;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c4c7eac69de4..69a0badfb745 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -723,7 +723,8 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	if (event->header.misc & PERF_RECORD_MISC_EXACT_IP)
 		top->exact_samples++;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0)
+	if (perf_event__preprocess_sample(event, machine, &al, sample,
+					  top->session) < 0)
 		return;
 
 	if (!top->kptr_restrict_warned &&
diff --git a/tools/perf/tests/hists_cumulate.c b/tools/perf/tests/hists_cumulate.c
index 18619966454c..60682e62d9de 100644
--- a/tools/perf/tests/hists_cumulate.c
+++ b/tools/perf/tests/hists_cumulate.c
@@ -101,7 +101,7 @@ static int add_hist_entries(struct hists *hists, struct machine *machine)
 		sample.callchain = (struct ip_callchain *)fake_callchains[i];
 
 		if (perf_event__preprocess_sample(&event, machine, &al,
-						  &sample) < 0)
+						  &sample, NULL) < 0)
 			goto out;
 
 		if (hist_entry_iter__add(&iter, &al, evsel, &sample,
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 59e53db7914c..1c4e495d5137 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -78,7 +78,7 @@ static int add_hist_entries(struct perf_evlist *evlist,
 			sample.ip = fake_samples[i].ip;
 
 			if (perf_event__preprocess_sample(&event, machine, &al,
-							  &sample) < 0)
+							  &sample, NULL) < 0)
 				goto out;
 
 			if (hist_entry_iter__add(&iter, &al, evsel, &sample,
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 278ba8344c23..a731a531a3e2 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -86,7 +86,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 			sample.tid = fake_common_samples[k].pid;
 			sample.ip = fake_common_samples[k].ip;
 			if (perf_event__preprocess_sample(&event, machine, &al,
-							  &sample) < 0)
+							  &sample, NULL) < 0)
 				goto out;
 
 			he = __hists__add_entry(hists, &al, NULL,
@@ -110,7 +110,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 			sample.tid = fake_samples[i][k].pid;
 			sample.ip = fake_samples[i][k].ip;
 			if (perf_event__preprocess_sample(&event, machine, &al,
-							  &sample) < 0)
+							  &sample, NULL) < 0)
 				goto out;
 
 			he = __hists__add_entry(hists, &al, NULL,
diff --git a/tools/perf/tests/hists_output.c b/tools/perf/tests/hists_output.c
index b52c9faea224..f4e3286cd496 100644
--- a/tools/perf/tests/hists_output.c
+++ b/tools/perf/tests/hists_output.c
@@ -67,7 +67,7 @@ static int add_hist_entries(struct hists *hists, struct machine *machine)
 		sample.ip = fake_samples[i].ip;
 
 		if (perf_event__preprocess_sample(&event, machine, &al,
-						  &sample) < 0)
+						  &sample, NULL) < 0)
 			goto out;
 
 		if (hist_entry_iter__add(&iter, &al, evsel, &sample,
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6c6d044e959a..7a90c62ad07a 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -822,7 +822,8 @@ void thread__find_addr_location(struct thread *thread,
 int perf_event__preprocess_sample(const union perf_event *event,
 				  struct machine *machine,
 				  struct addr_location *al,
-				  struct perf_sample *sample)
+				  struct perf_sample *sample,
+				  struct perf_session *session __maybe_unused)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct thread *thread = machine__findnew_thread(machine, sample->pid,
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index c4ffe2bd0738..19814f70292b 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -353,11 +353,13 @@ int perf_event__process(struct perf_tool *tool,
 			struct machine *machine);
 
 struct addr_location;
+struct perf_session;
 
 int perf_event__preprocess_sample(const union perf_event *event,
 				  struct machine *machine,
 				  struct addr_location *al,
-				  struct perf_sample *sample);
+				  struct perf_sample *sample,
+				  struct perf_session *session);
 
 struct thread;
 
-- 
2.2.2

