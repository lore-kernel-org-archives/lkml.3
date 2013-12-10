Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3LJJR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:17:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3LJJRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:17:51 -0500
Date: Tue, 10 Dec 2013 01:17:24 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-a2cb3cf20e06ef119ae541c1a08dc1977f7f0fff@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, ak@linux.intel.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <529F3944.9050007@intel.com>
References: <529F3944.9050007@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Do not call perf_event__preprocess_sample() twice)
Git-Commit-ID: a2cb3cf20e06ef119ae541c1a08dc1977f7f0fff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:17:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2cb3cf20e06ef119ae541c1a08dc1977f7f0fff
Gitweb:     http://git.kernel.org/tip/a2cb3cf20e06ef119ae541c1a08dc1977f7f0fff
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 4 Dec 2013 16:16:36 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 15:09:53 -0300

perf script: Do not call perf_event__preprocess_sample() twice)

The perf_event__preprocess_sample() function is called in
process_sample_event().  Instead of calling it again in
perf_evsel__print_ip(), pass through the resultant addr_location.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/529F3944.9050007@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 11 ++++++-----
 tools/perf/util/session.c   | 31 ++++++++++++++-----------------
 tools/perf/util/session.h   |  4 ++--
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 952dce9..c555bdd 100644
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
+		perf_evsel__print_ip(evsel, sample, machine, al,
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
+		perf_evsel__print_ip(evsel, sample, machine, al,
 				     output[attr->type].print_ip_opts,
 				     PERF_MAX_STACK_DEPTH);
 	}
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4ce146b..8a7da6f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1487,11 +1487,10 @@ struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 	return NULL;
 }
 
-void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
-			  struct perf_sample *sample, struct machine *machine,
+void perf_evsel__print_ip(struct perf_evsel *evsel, struct perf_sample *sample,
+			  struct machine *machine, struct addr_location *al,
 			  unsigned int print_opts, unsigned int stack_depth)
 {
-	struct addr_location al;
 	struct callchain_cursor_node *node;
 	int print_ip = print_opts & PRINT_IP_OPT_IP;
 	int print_sym = print_opts & PRINT_IP_OPT_SYM;
@@ -1500,15 +1499,10 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
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
@@ -1517,6 +1511,9 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
 		}
 		callchain_cursor_commit(&callchain_cursor);
 
+		if (print_symoffset)
+			node_al = *al;
+
 		while (stack_depth) {
 			node = callchain_cursor_current(&callchain_cursor);
 			if (!node)
@@ -1531,9 +1528,9 @@ void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
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
@@ -1553,7 +1550,7 @@ next:
 		}
 
 	} else {
-		if (al.sym && al.sym->ignore)
+		if (al->sym && al->sym->ignore)
 			return;
 
 		if (print_ip)
@@ -1562,15 +1559,15 @@ next:
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
index 50f6409..7e5d4398 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -105,8 +105,8 @@ size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp);
 struct perf_evsel *perf_session__find_first_evtype(struct perf_session *session,
 					    unsigned int type);
 
-void perf_evsel__print_ip(struct perf_evsel *evsel, union perf_event *event,
-			  struct perf_sample *sample, struct machine *machine,
+void perf_evsel__print_ip(struct perf_evsel *evsel, struct perf_sample *sample,
+			  struct machine *machine, struct addr_location *al,
 			  unsigned int print_opts, unsigned int stack_depth);
 
 int perf_session__cpu_bitmap(struct perf_session *session,
