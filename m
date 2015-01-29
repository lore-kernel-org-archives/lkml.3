Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbbA2IVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:21:10 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50988 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbbA2IJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:09:59 -0500
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
Subject: [PATCH 06/42] perf tools: Use a software dummy event to track task/mmap events
Date: Thu, 29 Jan 2015 17:06:47 +0900
Message-Id: <1422518843-25818-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add APIs for software dummy event to track task/comm/mmap events
separately.  The perf record will use them to save such events in a
separate mmap buffer to make it easy to index.  This is a preparation of
multi-thread support which will come later.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/evlist.c | 30 ++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h |  1 +
 tools/perf/util/evsel.h  | 15 +++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 28b8ce86bf12..2d81b4d154f4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -195,6 +195,36 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
 	return -ENOMEM;
 }
 
+int perf_evlist__add_dummy_tracking(struct perf_evlist *evlist)
+{
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_SOFTWARE,
+		.config = PERF_COUNT_SW_DUMMY,
+		.exclude_kernel = 1,
+	};
+	struct perf_evsel *evsel;
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
+	perf_evlist__add(evlist, evsel);
+	perf_evlist__set_tracking_event(evlist, evsel);
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
index c94a9e03ecf1..771175e70d2f 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -67,6 +67,7 @@ void perf_evlist__delete(struct perf_evlist *evlist);
 
 void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
+int perf_evlist__add_dummy_tracking(struct perf_evlist *evlist);
 int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
 				     struct perf_event_attr *attrs, size_t nr_attrs);
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 38622747d130..9764e9456546 100644
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
+		evsel->attr.task == 1 && evsel->attr.mmap == 1;
+}
+
 struct perf_attr_details {
 	bool freq;
 	bool verbose;
-- 
2.2.2

