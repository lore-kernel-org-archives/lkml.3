Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaLXHOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:14:54 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39514 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaLXHOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:14:50 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 02/37] perf record: Use a software dummy event to track task/mmap events
Date: Wed, 24 Dec 2014 16:14:58 +0900
Message-Id: <1419405333-27952-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepend a software dummy event into evlist to track task/comm/mmap
events separately.  This is a preparation of multi-file/thread support
which will come later.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c |  3 +++
 tools/perf/perf.h           |  1 +
 tools/perf/util/evlist.c    | 38 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h    |  1 +
 tools/perf/util/evsel.h     | 15 +++++++++++++++
 5 files changed, 58 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8648c6d3003d..aa5fa6aabb31 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -862,6 +862,9 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 		goto out_symbol_exit;
 	}
 
+	if (rec->opts.multi_file)
+		perf_evlist__prepend_dummy(rec->evlist);
+
 	if (rec->opts.target.tid && !rec->opts.no_inherit_set)
 		rec->opts.no_inherit = true;
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 1dabb8553499..37284eb47b56 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -53,6 +53,7 @@ struct record_opts {
 	bool	     sample_time;
 	bool	     period;
 	bool	     sample_intr_regs;
+	bool	     multi_file;
 	unsigned int freq;
 	unsigned int mmap_pages;
 	unsigned int user_freq;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index cfbe2b99b9aa..72dff295237e 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -193,6 +193,44 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
 	return -ENOMEM;
 }
 
+int perf_evlist__prepend_dummy(struct perf_evlist *evlist)
+{
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_SOFTWARE,
+		.config = PERF_COUNT_SW_DUMMY,
+	};
+	struct perf_evsel *evsel, *pos;
+
+	event_attr_init(&attr);
+
+	evsel = perf_evsel__new(&attr);
+	if (evsel == NULL)
+		goto error;
+
+	/* use strdup() because free(evsel) assumes name is allocated */
+	evsel->name = strdup("dummy");
+	if (!evsel->name)
+		goto error_free;
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		pos->idx += 1;
+		pos->tracking = false;
+	}
+
+	list_add(&evsel->node, &evlist->entries);
+	evsel->idx = 0;
+	evsel->tracking = true;
+
+	if (!evlist->nr_entries++)
+		perf_evlist__set_id_pos(evlist);
+
+	return 0;
+error_free:
+	perf_evsel__delete(evsel);
+error:
+	return -ENOMEM;
+}
+
 static int perf_evlist__add_attrs(struct perf_evlist *evlist,
 				  struct perf_event_attr *attrs, size_t nr_attrs)
 {
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 649b0c597283..b974bddf6b8b 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -67,6 +67,7 @@ void perf_evlist__delete(struct perf_evlist *evlist);
 
 void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
+int perf_evlist__prepend_dummy(struct perf_evlist *evlist);
 int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
 				     struct perf_event_attr *attrs, size_t nr_attrs);
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 38622747d130..5b45eea63043 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -331,6 +331,21 @@ static inline bool perf_evsel__is_function_event(struct perf_evsel *evsel)
 #undef FUNCTION_EVENT
 }
 
+/**
+ * perf_evsel__is_dummy_tracking - Return whether given evsel is a dummy
+ * event for tracking meta events only
+ *
+ * @evsel - evsel selector to be tested
+ *
+ * Return %true if event is a dummy tracking event
+ */
+static inline bool perf_evsel__is_dummy_tracking(struct perf_evsel *evsel)
+{
+	return evsel->attr.type == PERF_TYPE_SOFTWARE &&
+		evsel->attr.config == PERF_COUNT_SW_DUMMY &&
+		evsel->attr.task == 1 && evsel->idx == 0;
+}
+
 struct perf_attr_details {
 	bool freq;
 	bool verbose;
-- 
2.1.3

