Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab3LKMjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:39:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:23959 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab3LKMjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:39:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="442368603"
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
Subject: [PATCH v0 24/71] perf evlist: Add perf_evlist__set_tracking_event()
Date: Wed, 11 Dec 2013 14:36:36 +0200
Message-Id: <1386765443-26966-25-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
 tools/perf/util/evlist.h |  3 ++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 93683bc..ae9cbe6 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1233,3 +1233,23 @@ void perf_evlist__to_front(struct perf_evlist *evlist,
 
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
index 9f64ede..2c8d068 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -196,6 +196,7 @@ static inline void perf_mmap__write_tail(struct perf_mmap *md,
 bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str);
 void perf_evlist__to_front(struct perf_evlist *evlist,
 			   struct perf_evsel *move_evsel);
-
+int perf_evlist__set_tracking_event(struct perf_evlist *evlist,
+				    struct perf_evsel *tracking_evsel);
 
 #endif /* __PERF_EVLIST_H */
-- 
1.8.5.1

