Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3H0ISz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:18:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:48948 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab3H0ISH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:18:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,966,1367996400"; 
   d="scan'208";a="352105234"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V13 12/12] perf tools: allow non-matching sample types
Date: Tue, 27 Aug 2013 11:23:14 +0300
Message-Id: <1377591794-30553-13-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377591794-30553-1-git-send-email-adrian.hunter@intel.com>
References: <1377591794-30553-1-git-send-email-adrian.hunter@intel.com>
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
 tools/perf/util/event.h  | 16 ++++++++++++++++
 tools/perf/util/evlist.c | 25 +++++++++++++++++++++++++
 tools/perf/util/evlist.h |  1 +
 tools/perf/util/record.c |  5 ++++-
 4 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 93130d8..a452504 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -56,6 +56,22 @@ struct read_event {
 	 PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD |		\
 	 PERF_SAMPLE_IDENTIFIER)
 
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
index 6a629af..1a39e3e 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -64,6 +64,31 @@ void perf_evlist__set_id_pos(struct perf_evlist *evlist)
 	evlist->is_pos = first->is_pos;
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
index ab95d72..4d1d342 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -89,6 +89,7 @@ int perf_evlist__open(struct perf_evlist *evlist);
 void perf_evlist__close(struct perf_evlist *evlist);
 
 void perf_evlist__set_id_pos(struct perf_evlist *evlist);
+void perf_evlist__make_sample_types_compatible(struct perf_evlist *evlist);
 bool perf_can_sample_identifier(void);
 void perf_evlist__config(struct perf_evlist *evlist,
 			 struct perf_record_opts *opts);
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 18d73aa..6e01bf2 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -104,5 +104,8 @@ void perf_evlist__config(struct perf_evlist *evlist,
 			perf_evsel__set_sample_id(evsel, use_sample_identifier);
 	}
 
-	perf_evlist__set_id_pos(evlist);
+	if (use_sample_identifier)
+		perf_evlist__set_id_pos(evlist);
+	else
+		perf_evlist__make_sample_types_compatible(evlist);
 }
-- 
1.7.11.7

