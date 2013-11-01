Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3KANwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:52:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:23727 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab3KANwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:52:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="402157130"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V3 11/11] perf tools: Allow non-matching sample types
Date: Fri,  1 Nov 2013 15:51:39 +0200
Message-Id: <1383313899-15987-12-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com>
References: <1383313899-15987-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For kernels that do not support PERF_SAMPLE_IDENTIFIER,
sample types need not be identical to determine
the sample id from the event.  Only the position
of the sample id needs to be the same.

Compatible sample types are ones in which the bits
defined by PERF_COMPAT_MASK are the same.
'perf_evlist__config()' forces sample types to be
compatible on that basis.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-trace.c |  1 +
 tools/perf/perf.h          |  1 +
 tools/perf/util/event.h    | 16 ++++++++++++++++
 tools/perf/util/evlist.c   | 25 +++++++++++++++++++++++++
 tools/perf/util/evlist.h   |  1 +
 tools/perf/util/record.c   |  5 ++++-
 6 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index dc3da65..08a34e3 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2062,6 +2062,7 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 			.user_interval = ULLONG_MAX,
 			.no_delay      = true,
 			.mmap_pages    = 1024,
+			.incompatible_sample_types = true,
 		},
 		.output = stdout,
 		.show_comm = true,
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index f61c230..aeecdf7 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -233,6 +233,7 @@ struct perf_record_opts {
 	u64	     user_interval;
 	u16	     stack_dump_size;
 	bool	     sample_transaction;
+	bool         incompatible_sample_types;
 };
 
 #endif
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 752709c..ca0689c 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -78,6 +78,22 @@ struct throttle_event {
 /* perf sample has 16 bits size limit */
 #define PERF_SAMPLE_MAX_SIZE (1 << 16)
 
+/*
+ * Events have compatible sample types if the following bits all have the same
+ * value.  This is because the order of sample members is fixed.  For sample
+ * events the order is: PERF_SAMPLE_IP, PERF_SAMPLE_TID, PERF_SAMPLE_TIME,
+ * PERF_SAMPLE_ADDR, PERF_SAMPLE_ID.  For non-sample events the sample members
+ * are accessed in reverse order.  The order is: PERF_SAMPLE_ID,
+ * PERF_SAMPLE_STREAM_ID, PERF_SAMPLE_CPU.  PERF_SAMPLE_IDENTIFIER is added for
+ * completeness but it should not be used with PERF_SAMPLE_ID.  Sample types
+ * that include PERF_SAMPLE_IDENTIFIER are always compatible.
+ */
+#define PERF_COMPAT_MASK				\
+	(PERF_SAMPLE_IP   | PERF_SAMPLE_TID       |	\
+	 PERF_SAMPLE_TIME | PERF_SAMPLE_ADDR      |	\
+	 PERF_SAMPLE_ID   | PERF_SAMPLE_STREAM_ID |	\
+	 PERF_SAMPLE_CPU  | PERF_SAMPLE_IDENTIFIER)
+
 struct sample_event {
 	struct perf_event_header        header;
 	u64 array[];
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b3183d5..c893113 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -87,6 +87,31 @@ static void perf_evlist__update_id_pos(struct perf_evlist *evlist)
 	perf_evlist__set_id_pos(evlist);
 }
 
+/**
+ * perf_evlist__make_sample_types_compatible - make sample types compatible.
+ * @evlist: selected event list
+ *
+ * Events with compatible sample types all have the same id_pos and is_pos.
+ * This can be achieved by matching the bits of PERF_COMPAT_MASK.
+ */
+void perf_evlist__make_sample_types_compatible(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+	u64 compat = 0;
+
+	list_for_each_entry(evsel, &evlist->entries, node)
+		compat |= evsel->attr.sample_type & PERF_COMPAT_MASK;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		evsel->attr.sample_type |= compat;
+		evsel->sample_size =
+			__perf_evsel__sample_size(evsel->attr.sample_type);
+		perf_evsel__calc_id_pos(evsel);
+	}
+
+	perf_evlist__set_id_pos(evlist);
+}
+
 static void perf_evlist__purge(struct perf_evlist *evlist)
 {
 	struct perf_evsel *pos, *n;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 6e8acc9..d0d8a39 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -96,6 +96,7 @@ int perf_evlist__open(struct perf_evlist *evlist);
 void perf_evlist__close(struct perf_evlist *evlist);
 
 void perf_evlist__set_id_pos(struct perf_evlist *evlist);
+void perf_evlist__make_sample_types_compatible(struct perf_evlist *evlist);
 bool perf_can_sample_identifier(void);
 void perf_evlist__config(struct perf_evlist *evlist,
 			 struct perf_record_opts *opts);
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 18d73aa..1eb1290 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -104,5 +104,8 @@ void perf_evlist__config(struct perf_evlist *evlist,
 			perf_evsel__set_sample_id(evsel, use_sample_identifier);
 	}
 
-	perf_evlist__set_id_pos(evlist);
+	if (use_sample_identifier || opts->incompatible_sample_types)
+		perf_evlist__set_id_pos(evlist);
+	else
+		perf_evlist__make_sample_types_compatible(evlist);
 }
-- 
1.7.11.7

