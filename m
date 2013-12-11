Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3LKMkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:40:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:41746 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab3LKMj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:39:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450497841"
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
Subject: [PATCH v0 23/71] perf evlist: Add perf_evlist__to_front()
Date: Wed, 11 Dec 2013 14:36:35 +0200
Message-Id: <1386765443-26966-24-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to move a selected event to the
front of the list.

This is needed because it is not possible
to use the PERF_EVENT_IOC_SET_OUTPUT IOCTL
from an Instruction Tracing event to a
non-Instruction Tracing event.  Thus the
Instruction Tracing event must come first.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 17 +++++++++++++++++
 tools/perf/util/evlist.h |  3 +++
 2 files changed, 20 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f9dbf5f..93683bc 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1216,3 +1216,20 @@ int perf_evlist__strerror_open(struct perf_evlist *evlist __maybe_unused,
 
 	return 0;
 }
+
+void perf_evlist__to_front(struct perf_evlist *evlist,
+			   struct perf_evsel *move_evsel)
+{
+	struct perf_evsel *evsel, *n;
+	LIST_HEAD(move);
+
+	if (move_evsel == perf_evlist__first(evlist))
+		return;
+
+	list_for_each_entry_safe(evsel, n, &evlist->entries, node) {
+		if (evsel->leader == move_evsel->leader)
+			list_move_tail(&evsel->node, &move);
+	}
+
+	list_splice(&move, &evlist->entries);
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 8a04aae..9f64ede 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -194,5 +194,8 @@ static inline void perf_mmap__write_tail(struct perf_mmap *md,
 }
 
 bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str);
+void perf_evlist__to_front(struct perf_evlist *evlist,
+			   struct perf_evsel *move_evsel);
+
 
 #endif /* __PERF_EVLIST_H */
-- 
1.8.5.1

