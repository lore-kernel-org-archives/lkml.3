Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaALSgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:36:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45798 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaALSgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:36:46 -0500
Date: Sun, 12 Jan 2014 10:36:05 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-o51iiee7vyq4r3k362uvuylg@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Add 'machine'
  member to struct addr_location
Git-Commit-ID: cc22e575a6fddbe3183ac14c28e2f792704995c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:36:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc22e575a6fddbe3183ac14c28e2f792704995c5
Gitweb:     http://git.kernel.org/tip/cc22e575a6fddbe3183ac14c28e2f792704995c5
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 19 Dec 2013 17:20:06 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 17:38:27 -0300

perf symbols: Add 'machine' member to struct addr_location

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
index da156a4..ec7399a 100644
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
index f8ab125..62ef190 100644
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
index 6948768..fe20227 100644
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
index b672ef0..3773c48 100644
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
index fc00792..b258de6 100644
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
index 989b2e3..cbacaab 100644
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
index 9c25d49..3140f8a 100644
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
index 8a9d910..cbd6803 100644
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
index 95199e4..57aaccc 100644
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
index 3a01618..7b6d686 100644
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
