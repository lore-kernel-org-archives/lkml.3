Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3LCHPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 02:15:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:44013 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376Ab3LCHPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 02:15:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,816,1378882800"; 
   d="scan'208";a="445838555"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/7] perf script: Do not call perf_event__preprocess_sample() twice)
Date: Tue,  3 Dec 2013 09:23:04 +0200
Message-Id: <1386055390-13757-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
References: <1386055390-13757-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_event__preprocess_sample() is called in
process_sample_event().  Instead of calling it
again in perf_evsel__print_ip(), pass though
the resultant addr_location.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-script.c | 11 ++++++-----
 tools/perf/util/session.c   | 33 ++++++++++++++++-----------------
 tools/perf/util/session.h   |  3 ++-
 3 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 952dce9..5b865a9 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -414,7 +414,8 @@ static void print_sample_bts(union perf_event *event,
 			     struct perf_sample *sample,
 			     struct perf_evsel *evsel,
 			     struct machine *machine,
-			     struct thread *thread)
+			     struct thread *thread,
+			     struct addr_location *al)
 {
 	struct perf_event_attr *attr = &evsel->attr;
 
@@ -424,7 +425,7 @@ static void print_sample_bts(union perf_event *event,
 			printf(" ");
 		else
 			printf("\n");
-		perf_evsel__print_ip(evsel, event, sample, machine,
+		perf_evsel__print_ip(evsel, event, sample, machine, al,
 				     output[attr->type].print_ip_opts,
 				     PERF_MAX_STACK_DEPTH);
 	}
@@ -443,7 +444,7 @@ static void print_sample_bts(union perf_event *event,
 static void process_event(union perf_event *event, struct perf_sample *sample,
 			  struct perf_evsel *evsel, struct machine *machine,
 			  struct thread *thread,
-			  struct addr_location *al __maybe_unused)
+			  struct addr_location *al)
 {
 	struct perf_event_attr *attr = &evsel->attr;
 
@@ -458,7 +459,7 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 	}
 
 	if (is_bts_event(attr)) {
-		print_sample_bts(event, sample, evsel, machine, thread);
+		print_sample_bts(event, sample, evsel, machine, thread, al);
 		return;
 	}
 
@@ -474,7 +475,7 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 		else
 			printf("\n");
 
-		perf_evsel__print_ip(evsel, event, sample, machine,
+		perf_evsel__print_ip(evsel, event, sample, machine, al,
 				     output[attr->type].print_ip_opts,
 				     PERF_MAX_STACK_DEPTH);
 	}
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4ce146b..bc821b3 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1487,11 +1487,12 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 	return NULL;
 }
 
-void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
+void perf_evsel__print_ip(struct perf_evsel *evsel,
+			  union perf_event *event __maybe_unused,
 			  struct perf_sample *sample, struct machine *machine,
-			  unsigned int print_opts, unsigned int stack_depth)
+			  struct addr_location *al, unsigned int print_opts,
+			  unsigned int stack_depth)
 {
-	struct addr_location al;
 	struct callchain_cursor_node *node;
 	int print_ip = print_opts & PRINT_IP_OPT_IP;
 	int print_sym = print_opts & PRINT_IP_OPT_SYM;
@@ -1500,15 +1501,10 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 	int print_oneline = print_opts & PRINT_IP_OPT_ONELINE;
 	char s = print_oneline ? ' ' : '\t';
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
-		error("problem processing %d event, skipping it.\n",
-			event->header.type);
-		return;
-	}
-
 	if (symbol_conf.use_callchain && sample->callchain) {
+		struct addr_location node_al;
 
-		if (machine__resolve_callchain(machine, evsel, al.thread,
+		if (machine__resolve_callchain(machine, evsel, al->thread,
 					       sample, NULL, NULL,
 					       PERF_MAX_STACK_DEPTH) != 0) {
 			if (verbose)
@@ -1517,6 +1513,9 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 		}
 		callchain_cursor_commit(&callchain_cursor);
 
+		if (print_symoffset)
+			node_al = *al;
+
 		while (stack_depth) {
 			node = callchain_cursor_current(&callchain_cursor);
 			if (!node)
@@ -1531,9 +1530,9 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			if (print_sym) {
 				printf(" ");
 				if (print_symoffset) {
-					al.addr = node->ip;
-					al.map  = node->map;
-					symbol__fprintf_symname_offs(node->sym, &al, stdout);
+					node_al.addr = node->ip;
+					node_al.map  = node->map;
+					symbol__fprintf_symname_offs(node->sym, &node_al, stdout);
 				} else
 					symbol__fprintf_symname(node->sym, stdout);
 			}
@@ -1553,7 +1552,7 @@ next:
 		}
 
 	} else {
-		if (al.sym && al.sym->ignore)
+		if (al->sym && al->sym->ignore)
 			return;
 
 		if (print_ip)
@@ -1562,15 +1561,15 @@ next:
 		if (print_sym) {
 			printf(" ");
 			if (print_symoffset)
-				symbol__fprintf_symname_offs(al.sym, &al,
+				symbol__fprintf_symname_offs(al->sym, al,
 							     stdout);
 			else
-				symbol__fprintf_symname(al.sym, stdout);
+				symbol__fprintf_symname(al->sym, stdout);
 		}
 
 		if (print_dso) {
 			printf(" (");
-			map__fprintf_dsoname(al.map, stdout);
+			map__fprintf_dsoname(al->map, stdout);
 			printf(")");
 		}
 	}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 50f6409..ee88500 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -107,7 +107,8 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 
 void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 			  struct perf_sample *sample, struct machine *machine,
-			  unsigned int print_opts, unsigned int stack_depth);
+			  struct addr_location *al, unsigned int print_opts,
+			  unsigned int stack_depth);
 
 int perf_session__cpu_bitmap(struct perf_session *session,
 			     const char *cpu_list, unsigned long *cpu_bitmap);
-- 
1.7.11.7

