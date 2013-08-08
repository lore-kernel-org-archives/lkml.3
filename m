Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965333Ab3HHL0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 07:26:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:35773 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965259Ab3HHL0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 07:26:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,838,1367996400"; 
   d="scan'208";a="383802921"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6/8] perf tools: remove filter parameter of perf_event__preprocess_sample()
Date: Thu,  8 Aug 2013 14:32:25 +0300
Message-Id: <1375961547-30267-7-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375961547-30267-1-git-send-email-adrian.hunter@intel.com>
References: <1375961547-30267-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the symbol filter is recorded on the machine
there is no need to pass it to perf_event__preprocess_sample().
So remove it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
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
index cd616ff..025dcaf 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -499,7 +499,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
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
index dedaeb2..2403623 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1494,8 +1494,7 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 	struct addr_location al;
 	struct callchain_cursor_node *node;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample,
-					  NULL) < 0) {
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
 		error("problem processing %d event, skipping it.\n",
 			event->header.type);
 		return;
-- 
1.7.11.7

