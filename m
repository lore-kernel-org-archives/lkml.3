Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaCBP5P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 10:57:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbaCBP5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 10:57:10 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/3] perf tools: Disable user space callchain/stack for function trace event
Date: Sun,  2 Mar 2014 16:56:40 +0100
Message-Id: <1393775800-13524-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1393775800-13524-1-git-send-email-jolsa@redhat.com>
References: <1393775800-13524-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User space callchains and user space stack dump were disabled
for function trace event. Mailing list discussions:
  http://marc.info/?t=139302086500001&r=1&w=2
  http://marc.info/?t=139301437300003&r=1&w=2

Catching up with perf and disabling user space callchains and
DWARF unwind (uses user stack dump) for function trace event.

Adding following warnings when callchains are used
for function trace event:

  # perf record -g -e ftrace:function ...
  Disabling user space callchains for function trace event.
  ...

  # ./perf record --call-graph=dwarf -e ftrace:function ...
  Cannot use DWARF unwind for function trace event, falling back to framepointers.
  Disabling user space callchains for function trace event.
  ...

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/evsel.c | 41 ++++++++++++++++++++++++++++++-----------
 tools/perf/util/evsel.h | 18 ++++++++++++++++++
 2 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index adc94dd..26b67b1 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -500,6 +500,34 @@ int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size)
 	return ret;
 }
 
+static void
+perf_evsel__config_callgraph(struct perf_evsel *evsel,
+			     struct record_opts *opts)
+{
+	bool function = perf_evsel__is_function_event(evsel);
+	struct perf_event_attr *attr = &evsel->attr;
+
+	perf_evsel__set_sample_bit(evsel, CALLCHAIN);
+
+	if (opts->call_graph == CALLCHAIN_DWARF) {
+		if (!function) {
+			perf_evsel__set_sample_bit(evsel, REGS_USER);
+			perf_evsel__set_sample_bit(evsel, STACK_USER);
+			attr->sample_regs_user = PERF_REGS_MASK;
+			attr->sample_stack_user = opts->stack_dump_size;
+			attr->exclude_callchain_user = 1;
+		} else {
+			pr_info("Cannot use DWARF unwind for function trace event,"
+				" falling back to framepointers.\n");
+		}
+	}
+
+	if (function) {
+		pr_info("Disabling user space callchains for function trace event.\n");
+		attr->exclude_callchain_user = 1;
+	}
+}
+
 /*
  * The enable_on_exec/disabled value strategy:
  *
@@ -595,17 +623,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		attr->mmap_data = track;
 	}
 
-	if (opts->call_graph_enabled) {
-		perf_evsel__set_sample_bit(evsel, CALLCHAIN);
-
-		if (opts->call_graph == CALLCHAIN_DWARF) {
-			perf_evsel__set_sample_bit(evsel, REGS_USER);
-			perf_evsel__set_sample_bit(evsel, STACK_USER);
-			attr->sample_regs_user = PERF_REGS_MASK;
-			attr->sample_stack_user = opts->stack_dump_size;
-			attr->exclude_callchain_user = 1;
-		}
-	}
+	if (opts->call_graph_enabled)
+		perf_evsel__config_callgraph(evsel, opts);
 
 	if (target__has_cpu(&opts->target))
 		perf_evsel__set_sample_bit(evsel, CPU);
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index f1b3256..0c9926c 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -315,6 +315,24 @@ static inline bool perf_evsel__is_group_event(struct perf_evsel *evsel)
 	return perf_evsel__is_group_leader(evsel) && evsel->nr_members > 1;
 }
 
+/**
+ * perf_evsel__is_function_event - Return whether given evsel is a function
+ * trace event
+ *
+ * @evsel - evsel selector to be tested
+ *
+ * Return %true if event is function trace event
+ */
+static inline bool perf_evsel__is_function_event(struct perf_evsel *evsel)
+{
+#define FUNCTION_EVENT "ftrace:function"
+
+	return evsel->name &&
+	       !strncmp(FUNCTION_EVENT, evsel->name, sizeof(FUNCTION_EVENT));
+
+#undef FUNCTION_EVENT
+}
+
 struct perf_attr_details {
 	bool freq;
 	bool verbose;
-- 
1.8.3.1

