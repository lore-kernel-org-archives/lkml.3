Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbaGWLBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:01:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:41334 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaGWLBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:01:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,716,1400050800"; 
   d="scan'208";a="565984104"
Message-ID: <53CF95BE.7060909@intel.com>
Date: Wed, 23 Jul 2014 14:00:14 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 17/52] perf evlist: Add perf_evlist__set_tracking_event()
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com> <1406035081-14301-18-git-send-email-adrian.hunter@intel.com> <20140722192206.GD29750@krava.redhat.com> <53CF5559.8050908@intel.com>
In-Reply-To: <53CF5559.8050908@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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


V2:
	Changed to use evsel->tracking as suggested by Jiri

	Note this patch now applies after the patch
		"perf evlist: Add 'system_wide' option"

	The change is reflected in the branch here:

		http://git.infradead.org/users/ahunter/linux-perf.git/shortlog/refs/heads/for-acme


 tools/perf/util/evlist.c | 17 +++++++++++++++++
 tools/perf/util/evlist.h |  3 +++
 tools/perf/util/evsel.c  |  3 ++-
 tools/perf/util/evsel.h  |  1 +
 tools/perf/util/record.c |  2 +-
 5 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7cfc371..e47d724 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -122,6 +122,7 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry)
 {
 	list_add_tail(&entry->node, &evlist->entries);
 	entry->idx = evlist->nr_entries;
+	entry->tracking = !entry->idx;
 
 	if (!evlist->nr_entries++)
 		perf_evlist__set_id_pos(evlist);
@@ -1279,3 +1280,19 @@ void perf_evlist__to_front(struct perf_evlist *evlist,
 
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
index f5173cd..e0084f9 100644
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
index 7baa06f..fbe0ce4 100644
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
index dbb2a0d..7bc314b 100644
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
index fe8079e..787b882 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -106,7 +106,7 @@ void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts)
 
 	evlist__for_each(evlist, evsel) {
 		perf_evsel__config(evsel, opts);
-		if (!evsel->idx && use_comm_exec)
+		if (evsel->tracking && use_comm_exec)
 			evsel->attr.comm_exec = 1;
 	}
 
-- 
1.8.3.2


