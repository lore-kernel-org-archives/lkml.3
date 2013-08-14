Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab3HNSZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:25:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34406 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884Ab3HNSZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/21] perf tools: Remove filter parameter of perf_event__preprocess_sample()
Date: Wed, 14 Aug 2013 15:25:10 -0300
Message-Id: <1376504715-28107-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376504715-28107-1-git-send-email-acme@infradead.org>
References: <1376504715-28107-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Now that the symbol filter is recorded on the machine there is no need
to pass it to perf_event__preprocess_sample().  So remove it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375961547-30267-7-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c | 3 +--
 tools/perf/builtin-diff.c     | 2 +-
 tools/perf/builtin-mem.c      | 3 +--
 tools/perf/builtin-report.c   | 3 +--
 tools/perf/builtin-script.c   | 2 +-
 tools/perf/builtin-top.c      | 3 +--
 tools/perf/tests/hists_link.c | 4 ++--
 tools/perf/util/event.c       | 8 ++++----
 tools/perf/util/event.h       | 3 +--
 tools/perf/util/session.c     | 3 +--
 10 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 9754cb1..f988d38 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -90,8 +90,7 @@ static int process_sample_event(struct perf_tool *tool,
 	struct perf_annotate *ann = container_of(tool, struct perf_annotate, tool);
 	struct addr_location al;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample,
-					  machine->symbol_filter) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 93de3ac..f28799e 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -319,7 +319,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 {
 	struct addr_location al;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample, NULL) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index f96168c..706a1fa 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -68,8 +68,7 @@ dump_raw_samples(struct perf_tool *tool,
 	struct addr_location al;
 	const char *fmt;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample,
-				NULL) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 				event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f06a5a2..958a56a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -304,8 +304,7 @@ static int process_sample_event(struct perf_tool *tool,
 	struct addr_location al;
 	int ret;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample,
-					  machine->symbol_filter) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 33b2d83..a7d623f 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -520,7 +520,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 		return 0;
 	}
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample, 0) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		pr_err("problem processing %d event, skipping it.\n",
 		       event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a63ade2..e37521f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -716,8 +716,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	if (event->header.misc & PERF_RECORD_MISC_EXACT_IP)
 		top->exact_samples++;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample,
-					  machine->symbol_filter) < 0 ||
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0 ||
 	    al.filtered)
 		return;
 
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 89085a9..50bfb01 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -220,7 +220,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 			};
 
 			if (perf_event__preprocess_sample(&event, machine, &al,
-							  &sample, 0) < 0)
+							  &sample) < 0)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1);
@@ -244,7 +244,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 			};
 
 			if (perf_event__preprocess_sample(&event, machine, &al,
-							  &sample, 0) < 0)
+							  &sample) < 0)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL, 1, 1);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index cc7c0c9..f3cf771 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -683,8 +683,7 @@ void thread__find_addr_location(struct thread *thread, struct machine *machine,
 int perf_event__preprocess_sample(const union perf_event *event,
 				  struct machine *machine,
 				  struct addr_location *al,
-				  struct perf_sample *sample,
-				  symbol_filter_t filter)
+				  struct perf_sample *sample)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct thread *thread = machine__findnew_thread(machine, event->ip.pid);
@@ -709,7 +708,7 @@ int perf_event__preprocess_sample(const union perf_event *event,
 		machine__create_kernel_maps(machine);
 
 	thread__find_addr_map(thread, machine, cpumode, MAP__FUNCTION,
-			      event->ip.ip, al, filter);
+			      event->ip.ip, al, machine->symbol_filter);
 	dump_printf(" ...... dso: %s\n",
 		    al->map ? al->map->dso->long_name :
 			al->level == 'H' ? "[hypervisor]" : "<not found>");
@@ -727,7 +726,8 @@ int perf_event__preprocess_sample(const union perf_event *event,
 						   dso->long_name)))))
 			goto out_filtered;
 
-		al->sym = map__find_symbol(al->map, al->addr, filter);
+		al->sym = map__find_symbol(al->map, al->addr,
+					   machine->symbol_filter);
 	}
 
 	if (symbol_conf.sym_list &&
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 6119a64..15db071 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -234,8 +234,7 @@ struct addr_location;
 int perf_event__preprocess_sample(const union perf_event *self,
 				  struct machine *machine,
 				  struct addr_location *al,
-				  struct perf_sample *sample,
-				  symbol_filter_t filter);
+				  struct perf_sample *sample);
 
 const char *perf_event__name(unsigned int id);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4d9028e..de16a77 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1503,8 +1503,7 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 	int print_oneline = print_opts & PRINT_IP_OPT_ONELINE;
 	char s = print_oneline ? ' ' : '\t';
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample,
-					  NULL) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		error("problem processing %d event, skipping it.\n",
 			event->header.type);
 		return;
-- 
1.8.1.4

