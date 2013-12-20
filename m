Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3LTTKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:10:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38547 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3LTTJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 32/35] perf symbols: Add 'machine' member to struct addr_location
Date: Fri, 20 Dec 2013 16:09:07 -0300
Message-Id: <1387566550-3524-33-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The addr_location struct should fully qualify an address, and to do that
it should have in it the machine where the thread was found.

Thus all functions that receive an addr_location now don't need to also
receive a 'machine', those functions just need to access al->machine
instead, just like it does with the other parts of an address location:
al->thread, al->map, etc.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-o51iiee7vyq4r3k362uvuylg@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c                        | 28 ++++++++++------------
 tools/perf/builtin-script.c                        | 16 ++++++-------
 tools/perf/util/event.c                            |  1 +
 .../perf/util/scripting-engines/trace-event-perl.c |  1 -
 .../util/scripting-engines/trace-event-python.c    |  1 -
 tools/perf/util/session.c                          |  4 ++--
 tools/perf/util/session.h                          |  2 +-
 tools/perf/util/symbol.h                           |  1 +
 tools/perf/util/trace-event-scripting.c            |  3 +--
 tools/perf/util/trace-event.h                      |  1 -
 10 files changed, 26 insertions(+), 32 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index da156a44cb15..ec7399a84872 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -77,10 +77,10 @@ static int report__config(const char *var, const char *value, void *cb)
 
 static int report__resolve_callchain(struct report *rep, struct symbol **parent,
 				     struct perf_evsel *evsel, struct addr_location *al,
-				     struct perf_sample *sample, struct machine *machine)
+				     struct perf_sample *sample)
 {
 	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
-		return machine__resolve_callchain(machine, evsel, al->thread, sample,
+		return machine__resolve_callchain(al->machine, evsel, al->thread, sample,
 						  parent, al, rep->max_stack);
 	}
 	return 0;
@@ -95,7 +95,7 @@ static int hist_entry__append_callchain(struct hist_entry *he, struct perf_sampl
 
 static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_location *al,
 				      struct perf_sample *sample, struct perf_evsel *evsel,
-				      struct machine *machine, union perf_event *event)
+				      union perf_event *event)
 {
 	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
@@ -103,12 +103,12 @@ static int report__add_mem_hist_entry(struct perf_tool *tool, struct addr_locati
 	struct hist_entry *he;
 	struct mem_info *mi, *mx;
 	uint64_t cost;
-	int err = report__resolve_callchain(rep, &parent, evsel, al, sample, machine);
+	int err = report__resolve_callchain(rep, &parent, evsel, al, sample);
 
 	if (err)
 		return err;
 
-	mi = machine__resolve_mem(machine, al->thread, sample, cpumode);
+	mi = machine__resolve_mem(al->machine, al->thread, sample, cpumode);
 	if (!mi)
 		return -ENOMEM;
 
@@ -148,20 +148,19 @@ out:
 }
 
 static int report__add_branch_hist_entry(struct perf_tool *tool, struct addr_location *al,
-					 struct perf_sample *sample, struct perf_evsel *evsel,
-					 struct machine *machine)
+					 struct perf_sample *sample, struct perf_evsel *evsel)
 {
 	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
 	unsigned i;
 	struct hist_entry *he;
 	struct branch_info *bi, *bx;
-	int err = report__resolve_callchain(rep, &parent, evsel, al, sample, machine);
+	int err = report__resolve_callchain(rep, &parent, evsel, al, sample);
 
 	if (err)
 		return err;
 
-	bi = machine__resolve_bstack(machine, al->thread,
+	bi = machine__resolve_bstack(al->machine, al->thread,
 				     sample->branch_stack);
 	if (!bi)
 		return -ENOMEM;
@@ -204,13 +203,12 @@ out:
 }
 
 static int report__add_hist_entry(struct perf_tool *tool, struct perf_evsel *evsel,
-				  struct addr_location *al, struct perf_sample *sample,
-				  struct machine *machine)
+				  struct addr_location *al, struct perf_sample *sample)
 {
 	struct report *rep = container_of(tool, struct report, tool);
 	struct symbol *parent = NULL;
 	struct hist_entry *he;
-	int err = report__resolve_callchain(rep, &parent, evsel, al, sample, machine);
+	int err = report__resolve_callchain(rep, &parent, evsel, al, sample);
 
 	if (err)
 		return err;
@@ -256,18 +254,18 @@ static int process_sample_event(struct perf_tool *tool,
 		return 0;
 
 	if (sort__mode == SORT_MODE__BRANCH) {
-		ret = report__add_branch_hist_entry(tool, &al, sample, evsel, machine);
+		ret = report__add_branch_hist_entry(tool, &al, sample, evsel);
 		if (ret < 0)
 			pr_debug("problem adding lbr entry, skipping event\n");
 	} else if (rep->mem_mode == 1) {
-		ret = report__add_mem_hist_entry(tool, &al, sample, evsel, machine, event);
+		ret = report__add_mem_hist_entry(tool, &al, sample, evsel, event);
 		if (ret < 0)
 			pr_debug("problem adding mem entry, skipping event\n");
 	} else {
 		if (al.map != NULL)
 			al.map->dso->hit = 1;
 
-		ret = report__add_hist_entry(tool, evsel, &al, sample, machine);
+		ret = report__add_hist_entry(tool, evsel, &al, sample);
 		if (ret < 0)
 			pr_debug("problem incrementing symbol period, skipping event\n");
 	}
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index f8ab125aac48..62ef190c4320 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -423,7 +423,6 @@ static void print_sample_addr(union perf_event *event,
 static void print_sample_bts(union perf_event *event,
 			     struct perf_sample *sample,
 			     struct perf_evsel *evsel,
-			     struct machine *machine,
 			     struct thread *thread,
 			     struct addr_location *al)
 {
@@ -435,7 +434,7 @@ static void print_sample_bts(union perf_event *event,
 			printf(" ");
 		else
 			printf("\n");
-		perf_evsel__print_ip(evsel, sample, machine, al,
+		perf_evsel__print_ip(evsel, sample, al,
 				     output[attr->type].print_ip_opts,
 				     PERF_MAX_STACK_DEPTH);
 	}
@@ -446,14 +445,13 @@ static void print_sample_bts(union perf_event *event,
 	if (PRINT_FIELD(ADDR) ||
 	    ((evsel->attr.sample_type & PERF_SAMPLE_ADDR) &&
 	     !output[attr->type].user_set))
-		print_sample_addr(event, sample, machine, thread, attr);
+		print_sample_addr(event, sample, al->machine, thread, attr);
 
 	printf("\n");
 }
 
 static void process_event(union perf_event *event, struct perf_sample *sample,
-			  struct perf_evsel *evsel, struct machine *machine,
-			  struct thread *thread,
+			  struct perf_evsel *evsel, struct thread *thread,
 			  struct addr_location *al)
 {
 	struct perf_event_attr *attr = &evsel->attr;
@@ -469,7 +467,7 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 	}
 
 	if (is_bts_event(attr)) {
-		print_sample_bts(event, sample, evsel, machine, thread, al);
+		print_sample_bts(event, sample, evsel, thread, al);
 		return;
 	}
 
@@ -477,7 +475,7 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 		event_format__print(evsel->tp_format, sample->cpu,
 				    sample->raw_data, sample->raw_size);
 	if (PRINT_FIELD(ADDR))
-		print_sample_addr(event, sample, machine, thread, attr);
+		print_sample_addr(event, sample, al->machine, thread, attr);
 
 	if (PRINT_FIELD(IP)) {
 		if (!symbol_conf.use_callchain)
@@ -485,7 +483,7 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 		else
 			printf("\n");
 
-		perf_evsel__print_ip(evsel, sample, machine, al,
+		perf_evsel__print_ip(evsel, sample, al,
 				     output[attr->type].print_ip_opts,
 				     PERF_MAX_STACK_DEPTH);
 	}
@@ -574,7 +572,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
 		return 0;
 
-	scripting_ops->process_event(event, sample, evsel, machine, thread, &al);
+	scripting_ops->process_event(event, sample, evsel, thread, &al);
 
 	evsel->hists.stats.total_period += sample->period;
 	return 0;
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 694876877ae2..fe2022799161 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -638,6 +638,7 @@ void thread__find_addr_map(struct thread *thread,
 	struct map_groups *mg = &thread->mg;
 	bool load_map = false;
 
+	al->machine = machine;
 	al->thread = thread;
 	al->addr = addr;
 	al->cpumode = cpumode;
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index b672ef0ae46d..3773c4841cab 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -371,7 +371,6 @@ static void perl_process_event_generic(union perf_event *event,
 static void perl_process_event(union perf_event *event,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
-			       struct machine *machine __maybe_unused,
 			       struct thread *thread,
 			       struct addr_location *al __maybe_unused)
 {
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index fc007926eb1c..b258de6357ac 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -408,7 +408,6 @@ exit:
 static void python_process_event(union perf_event *event __maybe_unused,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
-				 struct machine *machine __maybe_unused,
 				 struct thread *thread,
 				 struct addr_location *al)
 {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 989b2e377626..cbacaab3e9c4 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1467,7 +1467,7 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 }
 
 void perf_evsel__print_ip(struct perf_evsel *evsel, struct perf_sample *sample,
-			  struct machine *machine, struct addr_location *al,
+			  struct addr_location *al,
 			  unsigned int print_opts, unsigned int stack_depth)
 {
 	struct callchain_cursor_node *node;
@@ -1482,7 +1482,7 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, struct perf_sample *sample,
 	if (symbol_conf.use_callchain && sample->callchain) {
 		struct addr_location node_al;
 
-		if (machine__resolve_callchain(machine, evsel, al->thread,
+		if (machine__resolve_callchain(al->machine, evsel, al->thread,
 					       sample, NULL, NULL,
 					       PERF_MAX_STACK_DEPTH) != 0) {
 			if (verbose)
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 9c25d49900af..3140f8ae6148 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -106,7 +106,7 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					    unsigned int type);
 
 void perf_evsel__print_ip(struct perf_evsel *evsel, struct perf_sample *sample,
-			  struct machine *machine, struct addr_location *al,
+			  struct addr_location *al,
 			  unsigned int print_opts, unsigned int stack_depth);
 
 int perf_session__cpu_bitmap(struct perf_session *session,
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 8a9d910c5345..cbd680361806 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -164,6 +164,7 @@ struct mem_info {
 };
 
 struct addr_location {
+	struct machine *machine;
 	struct thread *thread;
 	struct map    *map;
 	struct symbol *sym;
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 95199e4eea97..57aaccc1692e 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -38,9 +38,8 @@ static int stop_script_unsupported(void)
 static void process_event_unsupported(union perf_event *event __maybe_unused,
 				      struct perf_sample *sample __maybe_unused,
 				      struct perf_evsel *evsel __maybe_unused,
-				      struct machine *machine __maybe_unused,
 				      struct thread *thread __maybe_unused,
-					  struct addr_location *al __maybe_unused)
+				      struct addr_location *al __maybe_unused)
 {
 }
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 3a01618c5b87..7b6d68688327 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -68,7 +68,6 @@ struct scripting_ops {
 	void (*process_event) (union perf_event *event,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
-			       struct machine *machine,
 			       struct thread *thread,
 				   struct addr_location *al);
 	int (*generate_script) (struct pevent *pevent, const char *outfile);
-- 
1.8.1.4

