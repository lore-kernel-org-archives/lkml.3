Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaHMWw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:52:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:55638 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407AbaHMWvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:51:05 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 34/41] perf evlist: Add perf_evlist__set_tracking_event()
Date: Wed, 13 Aug 2014 19:48:20 -0300
Message-Id: <1407970107-24540-35-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to change which event is used to track mmap, comm and
task events.

This is needed with Instruction Tracing because the Instruction Tracing
event must come first but cannot be used for tracking because it will be
disabled under some circumstances.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406786474-9306-10-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 17 +++++++++++++++++
 tools/perf/util/evlist.h |  3 +++
 tools/perf/util/evsel.c  |  3 ++-
 tools/perf/util/evsel.h  |  1 +
 tools/perf/util/record.c |  2 +-
 5 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index c74d8ecc9c70..9d863db3f4b2 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -122,6 +122,7 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry)
 {
 	list_add_tail(&entry->node, &evlist->entries);
 	entry->idx = evlist->nr_entries;
+	entry->tracking = !entry->idx;
 
 	if (!evlist->nr_entries++)
 		perf_evlist__set_id_pos(evlist);
@@ -1295,3 +1296,19 @@ void perf_evlist__to_front(struct perf_evlist *evlist,
 
 	list_splice(&move, &evlist->entries);
 }
+
+void perf_evlist__set_tracking_event(struct perf_evlist *evlist,
+				     struct perf_evsel *tracking_evsel)
+{
+	struct perf_evsel *evsel;
+
+	if (tracking_evsel->tracking)
+		return;
+
+	evlist__for_each(evlist, evsel) {
+		if (evsel != tracking_evsel)
+			evsel->tracking = false;
+	}
+
+	tracking_evsel->tracking = true;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index f5173cd63693..e0084f90c271 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -262,4 +262,7 @@ void perf_evlist__to_front(struct perf_evlist *evlist,
 #define evlist__for_each_safe(evlist, tmp, evsel) \
 	__evlist__for_each_safe(&(evlist)->entries, tmp, evsel)
 
+void perf_evlist__set_tracking_event(struct perf_evlist *evlist,
+				     struct perf_evsel *tracking_evsel);
+
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 66de9a708163..01ce14c3575e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -162,6 +162,7 @@ void perf_evsel__init(struct perf_evsel *evsel,
 		      struct perf_event_attr *attr, int idx)
 {
 	evsel->idx	   = idx;
+	evsel->tracking	   = !idx;
 	evsel->attr	   = *attr;
 	evsel->leader	   = evsel;
 	evsel->unit	   = "";
@@ -561,7 +562,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 {
 	struct perf_evsel *leader = evsel->leader;
 	struct perf_event_attr *attr = &evsel->attr;
-	int track = !evsel->idx; /* only the first counter needs these */
+	int track = evsel->tracking;
 	bool per_cpu = opts->target.default_per_cpu && !opts->target.per_thread;
 
 	attr->sample_id_all = perf_missing_features.sample_id_all ? 0 : 1;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index dbb2a0d20907..7bc314be6a7b 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -86,6 +86,7 @@ struct perf_evsel {
 	bool			no_aux_samples;
 	bool			immediate;
 	bool			system_wide;
+	bool			tracking;
 	/* parse modifier helper */
 	int			exclude_GH;
 	int			nr_members;
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index e778afda0fb9..cf69325b985f 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -115,7 +115,7 @@ void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts)
 
 	evlist__for_each(evlist, evsel) {
 		perf_evsel__config(evsel, opts);
-		if (!evsel->idx && use_comm_exec)
+		if (evsel->tracking && use_comm_exec)
 			evsel->attr.comm_exec = 1;
 	}
 
-- 
1.9.3

