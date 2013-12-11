Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3LKMkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:40:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:10658 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453Ab3LKMkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:40:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450498235"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 37/71] perf tools: Add support for PERF_RECORD_ITRACE_LOST
Date: Wed, 11 Dec 2013 14:36:49 +0200
Message-Id: <1386765443-26966-38-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Instruction Tracing may lose data, for example when buffers
are full.  In that case, an event of type PERF_RECORD_ITRACE_LOST
is created to inform of the loss.  Add support for that event type.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c |  1 +
 tools/perf/util/event.c     | 17 +++++++++++++++++
 tools/perf/util/event.h     | 11 +++++++++++
 tools/perf/util/machine.c   | 10 ++++++++++
 tools/perf/util/machine.h   |  2 ++
 tools/perf/util/session.c   |  5 +++++
 tools/perf/util/tool.h      |  1 +
 7 files changed, 47 insertions(+)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 8400d29..78911a3 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -417,6 +417,7 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			.fork		= perf_event__repipe,
 			.exit		= perf_event__repipe,
 			.lost		= perf_event__repipe,
+			.itrace_lost	= perf_event__repipe,
 			.read		= perf_event__repipe_sample,
 			.throttle	= perf_event__repipe,
 			.unthrottle	= perf_event__repipe,
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 30f91d7..4d001d9 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -20,6 +20,7 @@ static const char *perf_event__names[] = {
 	[PERF_RECORD_FORK]			= "FORK",
 	[PERF_RECORD_READ]			= "READ",
 	[PERF_RECORD_SAMPLE]			= "SAMPLE",
+	[PERF_RECORD_ITRACE_LOST]		= "ITRACE_LOST",
 	[PERF_RECORD_HEADER_ATTR]		= "ATTR",
 	[PERF_RECORD_HEADER_EVENT_TYPE]		= "EVENT_TYPE",
 	[PERF_RECORD_HEADER_TRACING_DATA]	= "TRACING_DATA",
@@ -536,6 +537,14 @@ int perf_event__process_lost(struct perf_tool *tool __maybe_unused,
 	return machine__process_lost_event(machine, event, sample);
 }
 
+int perf_event__process_itrace_lost(struct perf_tool *tool __maybe_unused,
+				    union perf_event *event,
+				    struct perf_sample *sample __maybe_unused,
+				    struct machine *machine)
+{
+	return machine__process_itrace_lost_event(machine, event);
+}
+
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
 {
 	return fprintf(fp, " %d/%d: [%#" PRIx64 "(%#" PRIx64 ") @ %#" PRIx64 "]: %c %s\n",
@@ -596,6 +605,11 @@ int perf_event__process_exit(struct perf_tool *tool __maybe_unused,
 	return machine__process_exit_event(machine, event, sample);
 }
 
+size_t perf_event__fprintf_itrace_lost(union perf_event *event, FILE *fp)
+{
+	return fprintf(fp, " offset: %#"PRIx64"\n", event->itrace_lost.offset);
+}
+
 size_t perf_event__fprintf(union perf_event *event, FILE *fp)
 {
 	size_t ret = fprintf(fp, "PERF_RECORD_%s",
@@ -615,6 +629,9 @@ size_t perf_event__fprintf(union perf_event *event, FILE *fp)
 	case PERF_RECORD_MMAP2:
 		ret += perf_event__fprintf_mmap2(event, fp);
 		break;
+	case PERF_RECORD_ITRACE_LOST:
+		ret += perf_event__fprintf_itrace_lost(event, fp);
+		break;
 	default:
 		ret += fprintf(fp, "\n");
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 88e27cb..b684398 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -193,6 +193,11 @@ struct id_index_event {
 	struct id_index_entry entries[0];
 };
 
+struct itrace_lost_event {
+	struct perf_event_header header;
+	u64 offset;
+};
+
 union perf_event {
 	struct perf_event_header	header;
 	struct mmap_event		mmap;
@@ -208,6 +213,7 @@ union perf_event {
 	struct tracing_data_event	tracing_data;
 	struct build_id_event		build_id;
 	struct id_index_event		id_index;
+	struct itrace_lost_event	itrace_lost;
 };
 
 void perf_event__print_totals(void);
@@ -244,6 +250,10 @@ int perf_event__process_lost(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct machine *machine);
+int perf_event__process_itrace_lost(struct perf_tool *tool,
+				    union perf_event *event,
+				    struct perf_sample *sample,
+				    struct machine *machine);
 int perf_event__process_mmap(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
@@ -285,6 +295,7 @@ size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp);
+size_t perf_event__fprintf_itrace_lost(union perf_event *event, FILE *fp);
 size_t perf_event__fprintf(union perf_event *event, FILE *fp);
 
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index a04210d..a224cf7 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -361,6 +361,14 @@ int machine__process_lost_event(struct machine *machine __maybe_unused,
 	return 0;
 }
 
+int machine__process_itrace_lost_event(struct machine *machine __maybe_unused,
+				       union perf_event *event)
+{
+	if (dump_trace)
+		perf_event__fprintf_itrace_lost(event, stdout);
+	return 0;
+}
+
 struct map *machine__new_module(struct machine *machine, u64 start,
 				const char *filename)
 {
@@ -1149,6 +1157,8 @@ int machine__process_event(struct machine *machine, union perf_event *event,
 		ret = machine__process_exit_event(machine, event, sample); break;
 	case PERF_RECORD_LOST:
 		ret = machine__process_lost_event(machine, event, sample); break;
+	case PERF_RECORD_ITRACE_LOST:
+		ret = machine__process_itrace_lost_event(machine, event); break;
 	default:
 		ret = -1;
 		break;
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index aaad99a..fee1f89 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -50,6 +50,8 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
 				struct perf_sample *sample);
 int machine__process_lost_event(struct machine *machine, union perf_event *event,
 				struct perf_sample *sample);
+int machine__process_itrace_lost_event(struct machine *machine,
+				       union perf_event *event);
 int machine__process_mmap_event(struct machine *machine, union perf_event *event,
 				struct perf_sample *sample);
 int machine__process_mmap2_event(struct machine *machine, union perf_event *event,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7847096..de09c2e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -236,6 +236,8 @@ void perf_tool__fill_defaults(struct perf_tool *tool)
 		tool->exit = process_event_stub;
 	if (tool->lost == NULL)
 		tool->lost = perf_event__process_lost;
+	if (tool->itrace_lost == NULL)
+		tool->itrace_lost = perf_event__process_itrace_lost;
 	if (tool->read == NULL)
 		tool->read = process_event_sample_stub;
 	if (tool->throttle == NULL)
@@ -454,6 +456,7 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_THROTTLE]		  = perf_event__throttle_swap,
 	[PERF_RECORD_UNTHROTTLE]	  = perf_event__throttle_swap,
 	[PERF_RECORD_SAMPLE]		  = perf_event__all64_swap,
+	[PERF_RECORD_ITRACE_LOST]	  = perf_event__all64_swap,
 	[PERF_RECORD_HEADER_ATTR]	  = perf_event__hdr_attr_swap,
 	[PERF_RECORD_HEADER_EVENT_TYPE]	  = perf_event__event_type_swap,
 	[PERF_RECORD_HEADER_TRACING_DATA] = perf_event__tracing_data_swap,
@@ -998,6 +1001,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 		return tool->throttle(tool, event, sample, machine);
 	case PERF_RECORD_UNTHROTTLE:
 		return tool->unthrottle(tool, event, sample, machine);
+	case PERF_RECORD_ITRACE_LOST:
+		return tool->itrace_lost(tool, event, sample, machine);
 	default:
 		++session->stats.nr_unknown_events;
 		return -1;
diff --git a/tools/perf/util/tool.h b/tools/perf/util/tool.h
index f07d6fe..18afd13 100644
--- a/tools/perf/util/tool.h
+++ b/tools/perf/util/tool.h
@@ -34,6 +34,7 @@ struct perf_tool {
 			fork,
 			exit,
 			lost,
+			itrace_lost,
 			throttle,
 			unthrottle;
 	event_attr_op	attr;
-- 
1.8.5.1

