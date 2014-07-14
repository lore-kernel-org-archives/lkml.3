Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbaGNKMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:12:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:42003 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbaGNKFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:05:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434690"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 31/41] perf evlist: Add perf_evlist__set_tracking_event()
Date: Mon, 14 Jul 2014 13:02:55 +0300
Message-Id: <1405332185-4050-32-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
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

