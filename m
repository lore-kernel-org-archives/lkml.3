Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbbA2IRf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:17:35 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51261 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbbA2IKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:09 -0500
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
Subject: [PATCH 17/42] perf script: Pass session arg to ->process_event callback
Date: Thu, 29 Jan 2015 17:06:58 +0900
Message-Id: <1422518843-25818-18-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it needs to retrieve symbol info inside a script engine so
we need to pass the session pointer to find the symbol correctly as
with previous patch.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-script.c                        | 23 ++++++++++++----------
 tools/perf/util/db-export.c                        |  6 ++++--
 tools/perf/util/db-export.h                        |  4 +++-
 tools/perf/util/event.c                            |  3 ++-
 tools/perf/util/event.h                            |  3 ++-
 .../perf/util/scripting-engines/trace-event-perl.c |  3 ++-
 .../util/scripting-engines/trace-event-python.c    |  5 +++--
 tools/perf/util/trace-event-scripting.c            |  3 ++-
 tools/perf/util/trace-event.h                      |  3 ++-
 9 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ab920f8cded6..4a007110d2f7 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -377,9 +377,10 @@ static void print_sample_start(struct perf_sample *sample,
 }
 
 static void print_sample_addr(union perf_event *event,
-			  struct perf_sample *sample,
-			  struct thread *thread,
-			  struct perf_event_attr *attr)
+			      struct perf_sample *sample,
+			      struct thread *thread,
+			      struct perf_event_attr *attr,
+			      struct perf_session *session)
 {
 	struct addr_location al;
 
@@ -388,7 +389,7 @@ static void print_sample_addr(union perf_event *event,
 	if (!sample_addr_correlates_sym(attr))
 		return;
 
-	perf_event__preprocess_sample_addr(event, sample, thread, &al);
+	perf_event__preprocess_sample_addr(event, sample, thread, &al, session);
 
 	if (PRINT_FIELD(SYM)) {
 		printf(" ");
@@ -409,7 +410,8 @@ static void print_sample_bts(union perf_event *event,
 			     struct perf_sample *sample,
 			     struct perf_evsel *evsel,
 			     struct thread *thread,
-			     struct addr_location *al)
+			     struct addr_location *al,
+			     struct perf_session *session)
 {
 	struct perf_event_attr *attr = &evsel->attr;
 	bool print_srcline_last = false;
@@ -436,7 +438,7 @@ static void print_sample_bts(union perf_event *event,
 	    ((evsel->attr.sample_type & PERF_SAMPLE_ADDR) &&
 	     !output[attr->type].user_set)) {
 		printf(" => ");
-		print_sample_addr(event, sample, thread, attr);
+		print_sample_addr(event, sample, thread, attr, session);
 	}
 
 	if (print_srcline_last)
@@ -447,7 +449,7 @@ static void print_sample_bts(union perf_event *event,
 
 static void process_event(union perf_event *event, struct perf_sample *sample,
 			  struct perf_evsel *evsel, struct thread *thread,
-			  struct addr_location *al)
+			  struct addr_location *al, struct perf_session *session)
 {
 	struct perf_event_attr *attr = &evsel->attr;
 
@@ -465,7 +467,7 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 	}
 
 	if (is_bts_event(attr)) {
-		print_sample_bts(event, sample, evsel, thread, al);
+		print_sample_bts(event, sample, evsel, thread, al, session);
 		return;
 	}
 
@@ -473,7 +475,7 @@ static void process_event(union perf_event *event, struct perf_sample *sample,
 		event_format__print(evsel->tp_format, sample->cpu,
 				    sample->raw_data, sample->raw_size);
 	if (PRINT_FIELD(ADDR))
-		print_sample_addr(event, sample, thread, attr);
+		print_sample_addr(event, sample, thread, attr, session);
 
 	if (PRINT_FIELD(IP)) {
 		if (!symbol_conf.use_callchain)
@@ -590,7 +592,8 @@ static int process_sample_event(struct perf_tool *tool,
 	if (cpu_list && !test_bit(sample->cpu, cpu_bitmap))
 		return 0;
 
-	scripting_ops->process_event(event, sample, evsel, thread, &al);
+	scripting_ops->process_event(event, sample, evsel, thread, &al,
+				     script->session);
 
 	return 0;
 }
diff --git a/tools/perf/util/db-export.c b/tools/perf/util/db-export.c
index c81dae399763..e9ad11fe2e16 100644
--- a/tools/perf/util/db-export.c
+++ b/tools/perf/util/db-export.c
@@ -282,7 +282,8 @@ int db_export__branch_type(struct db_export *dbe, u32 branch_type,
 
 int db_export__sample(struct db_export *dbe, union perf_event *event,
 		      struct perf_sample *sample, struct perf_evsel *evsel,
-		      struct thread *thread, struct addr_location *al)
+		      struct thread *thread, struct addr_location *al,
+		      struct perf_session *session)
 {
 	struct export_sample es = {
 		.event = event,
@@ -328,7 +329,8 @@ int db_export__sample(struct db_export *dbe, union perf_event *event,
 	    sample_addr_correlates_sym(&evsel->attr)) {
 		struct addr_location addr_al;
 
-		perf_event__preprocess_sample_addr(event, sample, thread, &addr_al);
+		perf_event__preprocess_sample_addr(event, sample, thread,
+						   &addr_al, session);
 		err = db_ids_from_al(dbe, &addr_al, &es.addr_dso_db_id,
 				     &es.addr_sym_db_id, &es.addr_offset);
 		if (err)
diff --git a/tools/perf/util/db-export.h b/tools/perf/util/db-export.h
index adbd22d66798..b994f1041d19 100644
--- a/tools/perf/util/db-export.h
+++ b/tools/perf/util/db-export.h
@@ -29,6 +29,7 @@ struct addr_location;
 struct call_return_processor;
 struct call_path;
 struct call_return;
+struct perf_session;
 
 struct export_sample {
 	union perf_event	*event;
@@ -97,7 +98,8 @@ int db_export__branch_type(struct db_export *dbe, u32 branch_type,
 			   const char *name);
 int db_export__sample(struct db_export *dbe, union perf_event *event,
 		      struct perf_sample *sample, struct perf_evsel *evsel,
-		      struct thread *thread, struct addr_location *al);
+		      struct thread *thread, struct addr_location *al,
+		      struct perf_session *session);
 
 int db_export__branch_types(struct db_export *dbe);
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 7a90c62ad07a..186960a09024 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -904,7 +904,8 @@ bool sample_addr_correlates_sym(struct perf_event_attr *attr)
 void perf_event__preprocess_sample_addr(union perf_event *event,
 					struct perf_sample *sample,
 					struct thread *thread,
-					struct addr_location *al)
+					struct addr_location *al,
+					struct perf_session *session __maybe_unused)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 19814f70292b..27261320249a 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -368,7 +368,8 @@ bool sample_addr_correlates_sym(struct perf_event_attr *attr);
 void perf_event__preprocess_sample_addr(union perf_event *event,
 					struct perf_sample *sample,
 					struct thread *thread,
-					struct addr_location *al);
+					struct addr_location *al,
+					struct perf_session *session);
 
 const char *perf_event__name(unsigned int id);
 
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 22ebc46226e7..dd69fbaf03b8 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -356,7 +356,8 @@ static void perl_process_event(union perf_event *event,
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct thread *thread,
-			       struct addr_location *al __maybe_unused)
+			       struct addr_location *al __maybe_unused,
+			       struct perf_session *session __maybe_unused)
 {
 	perl_process_tracepoint(sample, evsel, thread);
 	perl_process_event_generic(event, sample, evsel);
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 0c815a40a6e8..802def46af7b 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -839,7 +839,8 @@ static void python_process_event(union perf_event *event,
 				 struct perf_sample *sample,
 				 struct perf_evsel *evsel,
 				 struct thread *thread,
-				 struct addr_location *al)
+				 struct addr_location *al,
+				 struct perf_session *session)
 {
 	struct tables *tables = &tables_global;
 
@@ -851,7 +852,7 @@ static void python_process_event(union perf_event *event,
 	default:
 		if (tables->db_export_mode)
 			db_export__sample(&tables->dbe, event, sample, evsel,
-					  thread, al);
+					  thread, al, session);
 		else
 			python_process_general_event(sample, evsel, thread, al);
 	}
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 5c9bdd1591a9..36ed50d71171 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -44,7 +44,8 @@ static void process_event_unsupported(union perf_event *event __maybe_unused,
 				      struct perf_sample *sample __maybe_unused,
 				      struct perf_evsel *evsel __maybe_unused,
 				      struct thread *thread __maybe_unused,
-				      struct addr_location *al __maybe_unused)
+				      struct addr_location *al __maybe_unused,
+				      struct perf_session *session __maybe_unused)
 {
 }
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 52aaa19e1eb1..c5870e57eee9 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -70,7 +70,8 @@ struct scripting_ops {
 			       struct perf_sample *sample,
 			       struct perf_evsel *evsel,
 			       struct thread *thread,
-				   struct addr_location *al);
+			       struct addr_location *al,
+			       struct perf_session *session);
 	int (*generate_script) (struct pevent *pevent, const char *outfile);
 };
 
-- 
2.2.2

