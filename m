Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbaGVNU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:20:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:45398 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbaGVNUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:20:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576985595"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/52] perf evlist: Add perf_evlist__set_tracking_event()
Date: Tue, 22 Jul 2014 16:17:26 +0300
Message-Id: <1406035081-14301-18-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to change which event is used
to track mmap, comm and task events.

This is needed with Instruction Tracing
because the Instruction Tracing event
must come first but cannot be used for
tracking because it will be disabled
under some circumstances.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 20 ++++++++++++++++++++
 tools/perf/util/evlist.h |  3 +++
 2 files changed, 23 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 814e954..282e83e 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1250,3 +1250,23 @@ void perf_evlist__to_front(struct perf_evlist *evlist,
 
 	list_splice(&move, &evlist->entries);
 }
+
+int perf_evlist__set_tracking_event(struct perf_evlist *evlist,
+				    struct perf_evsel *tracking_evsel)
+{
+	struct perf_evsel *evsel;
+
+	if (tracking_evsel->idx == 0)
+		return 0;
+
+	if (tracking_evsel->leader->nr_members > 1)
+		return -EINVAL;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (evsel->idx < tracking_evsel->idx)
+			evsel->idx += 1;
+	}
+	tracking_evsel->idx = 0;
+
+	return 0;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index f5173cd..657a36c 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -262,4 +262,7 @@ void perf_evlist__to_front(struct perf_evlist *evlist,
 #define evlist__for_each_safe(evlist, tmp, evsel) \
 	__evlist__for_each_safe(&(evlist)->entries, tmp, evsel)
 
+int perf_evlist__set_tracking_event(struct perf_evlist *evlist,
+				    struct perf_evsel *tracking_evsel);
+
 #endif /* __PERF_EVLIST_H */
-- 
1.8.3.2

