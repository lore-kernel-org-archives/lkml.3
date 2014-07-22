Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaGVNan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:30:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:45398 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbaGVNU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:20:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576985664"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 19/52] perf tools: Add id index
Date: Tue, 22 Jul 2014 16:17:28 +0300
Message-Id: <1406035081-14301-20-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an index of the event identifiers.

This is needed to queue Instruction
Trace samples according to the mmap
buffer from which they were recorded.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c |   1 +
 tools/perf/util/event.c     |   1 +
 tools/perf/util/event.h     |  15 ++++++
 tools/perf/util/evlist.c    |  26 ++++++++--
 tools/perf/util/evsel.h     |   3 ++
 tools/perf/util/session.c   | 122 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h   |  10 ++++
 tools/perf/util/tool.h      |   3 +-
 8 files changed, 177 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index cf6a605..ce691c4 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -419,6 +419,7 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			.tracing_data	= perf_event__repipe_op2_synth,
 			.finished_round	= perf_event__repipe_op2_synth,
 			.build_id	= perf_event__repipe_op2_synth,
+			.id_index	= perf_event__repipe_op2_synth,
 		},
 		.input_name  = "-",
 		.samples = LIST_HEAD_INIT(inject.samples),
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index d1283cc..dc32de0 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -28,6 +28,7 @@ static const char *perf_event__names[] = {
 	[PERF_RECORD_HEADER_TRACING_DATA]	= "TRACING_DATA",
 	[PERF_RECORD_HEADER_BUILD_ID]		= "BUILD_ID",
 	[PERF_RECORD_FINISHED_ROUND]		= "FINISHED_ROUND",
+	[PERF_RECORD_ID_INDEX]			= "ID_INDEX",
 };
 
 const char *perf_event__name(unsigned int id)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index e5dd40a..3fa9ab1 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -185,6 +185,7 @@ enum perf_user_event_type { /* above any possible kernel type */
 	PERF_RECORD_HEADER_TRACING_DATA		= 66,
 	PERF_RECORD_HEADER_BUILD_ID		= 67,
 	PERF_RECORD_FINISHED_ROUND		= 68,
+	PERF_RECORD_ID_INDEX			= 69,
 	PERF_RECORD_HEADER_MAX
 };
 
@@ -211,6 +212,19 @@ struct tracing_data_event {
 	u32 size;
 };
 
+struct id_index_entry {
+	u64 id;
+	u64 idx;
+	u64 cpu;
+	u64 tid;
+};
+
+struct id_index_event {
+	struct perf_event_header header;
+	u64 nr;
+	struct id_index_entry entries[0];
+};
+
 union perf_event {
 	struct perf_event_header	header;
 	struct mmap_event		mmap;
@@ -225,6 +239,7 @@ union perf_event {
 	struct event_type_event		event_type;
 	struct tracing_data_event	tracing_data;
 	struct build_id_event		build_id;
+	struct id_index_event		id_index;
 };
 
 void perf_event__print_totals(void);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index c295b7b..10514f3 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -441,6 +441,22 @@ static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
 	return 0;
 }
 
+static void perf_evlist__set_sid_idx(struct perf_evlist *evlist,
+				     struct perf_evsel *evsel, int idx, int cpu,
+				     int thread)
+{
+	struct perf_sample_id *sid = SID(evsel, cpu, thread);
+	sid->idx = idx;
+	if (evlist->cpus && cpu >= 0)
+		sid->cpu = evlist->cpus->map[cpu];
+	else
+		sid->cpu = -1;
+	if (!evsel->system_wide && evlist->threads && thread >= 0)
+		sid->tid = evlist->threads->map[thread];
+	else
+		sid->tid = -1;
+}
+
 struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id)
 {
 	struct hlist_head *head;
@@ -676,9 +692,13 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 				return -1;
 		}
 
-		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-		    perf_evlist__id_add_fd(evlist, evsel, cpu, thread, fd) < 0)
-			return -1;
+		if (evsel->attr.read_format & PERF_FORMAT_ID) {
+			if (perf_evlist__id_add_fd(evlist, evsel, cpu, thread,
+						   fd) < 0)
+				return -1;
+			perf_evlist__set_sid_idx(evlist, evsel, idx, cpu,
+						 thread);
+		}
 	}
 
 	return 0;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index dbb2a0d..330218a 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -38,6 +38,9 @@ struct perf_sample_id {
 	struct hlist_node 	node;
 	u64		 	id;
 	struct perf_evsel	*evsel;
+	int			idx;
+	int			cpu;
+	pid_t			tid;
 
 	/* Holds total ID period value for PERF_SAMPLE_READ processing. */
 	u64			period;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7b0fb03..8aa1be1 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -231,6 +231,15 @@ static int process_finished_round(struct perf_tool *tool,
 				  union perf_event *event,
 				  struct perf_session *session);
 
+static int process_id_index_stub(struct perf_tool *tool __maybe_unused,
+				 union perf_event *event __maybe_unused,
+				 struct perf_session *perf_session
+				 __maybe_unused)
+{
+	dump_printf(": unhandled!\n");
+	return 0;
+}
+
 void perf_tool__fill_defaults(struct perf_tool *tool)
 {
 	if (tool->sample == NULL)
@@ -265,6 +274,8 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 		else
 			tool->finished_round = process_finished_round_stub;
 	}
+	if (tool->id_index == NULL)
+		tool->id_index = process_id_index_stub;
 }
  
 static void swap_sample_id_all(union perf_event *event, void *data)
@@ -463,6 +474,7 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_HEADER_EVENT_TYPE]	  = perf_event__event_type_swap,
 	[PERF_RECORD_HEADER_TRACING_DATA] = perf_event__tracing_data_swap,
 	[PERF_RECORD_HEADER_BUILD_ID]	  = NULL,
+	[PERF_RECORD_ID_INDEX]		  = perf_event__all64_swap,
 	[PERF_RECORD_HEADER_MAX]	  = NULL,
 };
 
@@ -1045,6 +1057,8 @@ static int perf_session__process_user_event(struct perf_session *session, union
 		return tool->build_id(tool, event, session);
 	case PERF_RECORD_FINISHED_ROUND:
 		return tool->finished_round(tool, event, session);
+	case PERF_RECORD_ID_INDEX:
+		return tool->id_index(tool, event, session);
 	default:
 		return -EINVAL;
 	}
@@ -1701,3 +1715,111 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
 out:
 	return err;
 }
+
+int perf_event__process_id_index(struct perf_tool *tool __maybe_unused,
+				 union perf_event *event,
+				 struct perf_session *session)
+{
+	struct perf_evlist *evlist = session->evlist;
+	struct id_index_event *ie = &event->id_index;
+	size_t i, nr, max_nr;
+
+	max_nr = (ie->header.size - sizeof(struct id_index_event)) /
+		 sizeof(struct id_index_entry);
+	nr = ie->nr;
+	if (nr > max_nr)
+		return -EINVAL;
+
+	if (dump_trace)
+		fprintf(stdout, " nr: %zu\n", nr);
+
+	for (i = 0; i < nr; i++) {
+		struct id_index_entry *e = &ie->entries[i];
+		struct perf_sample_id *sid;
+
+		if (dump_trace) {
+			fprintf(stdout,	" ... id: %"PRIu64, e->id);
+			fprintf(stdout,	"  idx: %"PRIu64, e->idx);
+			fprintf(stdout,	"  cpu: %"PRId64, e->cpu);
+			fprintf(stdout,	"  tid: %"PRId64"\n", e->tid);
+		}
+
+		sid = perf_evlist__id2sid(evlist, e->id);
+		if (!sid)
+			return -ENOENT;
+		sid->idx = e->idx;
+		sid->cpu = e->cpu;
+		sid->tid = e->tid;
+	}
+	return 0;
+}
+
+int perf_event__synthesize_id_index(struct perf_tool *tool,
+				    perf_event__handler_t process,
+				    struct perf_evlist *evlist,
+				    struct machine *machine)
+{
+	union perf_event *ev;
+	struct perf_evsel *evsel;
+	size_t nr = 0, i = 0, sz, max_nr, n;
+	int err;
+
+	pr_debug2("Synthesizing id index\n");
+
+	max_nr = (UINT16_MAX - sizeof(struct id_index_event)) /
+		 sizeof(struct id_index_entry);
+
+	list_for_each_entry(evsel, &evlist->entries, node)
+		nr += evsel->ids;
+
+	n = nr > max_nr ? max_nr : nr;
+	sz = sizeof(struct id_index_event) + n * sizeof(struct id_index_entry);
+	ev = zalloc(sz);
+	if (!ev)
+		return -ENOMEM;
+
+	ev->id_index.header.type = PERF_RECORD_ID_INDEX;
+	ev->id_index.header.size = sz;
+	ev->id_index.nr = n;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		u32 j;
+
+		for (j = 0; j < evsel->ids; j++) {
+			struct id_index_entry *e;
+			struct perf_sample_id *sid;
+
+			if (i >= n) {
+				err = process(tool, ev, NULL, machine);
+				if (err)
+					goto out_err;
+				nr -= n;
+				i = 0;
+			}
+
+			e = &ev->id_index.entries[i++];
+
+			e->id = evsel->id[j];
+
+			sid = perf_evlist__id2sid(evlist, e->id);
+			if (!sid) {
+				free(ev);
+				return -ENOENT;
+			}
+
+			e->idx = sid->idx;
+			e->cpu = sid->cpu;
+			e->tid = sid->tid;
+		}
+	}
+
+	sz = sizeof(struct id_index_event) + nr * sizeof(struct id_index_entry);
+	ev->id_index.header.size = sz;
+	ev->id_index.nr = nr;
+
+	err = process(tool, ev, NULL, machine);
+out_err:
+	free(ev);
+
+	return err;
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 0321013..39327ca 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -129,4 +129,14 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
 extern volatile int session_done;
 
 #define session_done()	(*(volatile int *)(&session_done))
+
+int perf_event__process_id_index(struct perf_tool *tool,
+				 union perf_event *event,
+				 struct perf_session *session);
+
+int perf_event__synthesize_id_index(struct perf_tool *tool,
+				    perf_event__handler_t process,
+				    struct perf_evlist *evlist,
+				    struct machine *machine);
+
 #endif /* __PERF_SESSION_H */
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index 4385816..f07d6fe 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -39,7 +39,8 @@ struct perf_tool {
 	event_attr_op	attr;
 	event_op2	tracing_data;
 	event_op2	finished_round,
-			build_id;
+			build_id,
+			id_index;
 	bool		ordered_samples;
 	bool		ordering_requires_timestamps;
 };
-- 
1.8.3.2

