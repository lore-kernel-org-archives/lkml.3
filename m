Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab3AaR3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:29:24 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60087
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754821Ab3AaRZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/25] perf tools: Keep group information
Date: Thu, 31 Jan 2013 14:25:06 -0300
Message-Id: <1359653128-10433-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359653128-10433-1-git-send-email-acme@infradead.org>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add a few of group-related field in struct perf_{evlist,evsel} so that
the group information in a evlist can be known easily.  It only counts
groups which have more than 1 members since leader-only groups are
treated as non-group events.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c       |  7 ++++++-
 tools/perf/util/evlist.h       |  1 +
 tools/perf/util/evsel.h        |  6 ++++++
 tools/perf/util/parse-events.c |  1 +
 tools/perf/util/parse-events.h |  1 +
 tools/perf/util/parse-events.y | 10 ++++++++++
 6 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index dc8aee9..eddd5eb 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -117,6 +117,9 @@ void __perf_evlist__set_leader(struct list_head *list)
 	struct perf_evsel *evsel, *leader;
 
 	leader = list_entry(list->next, struct perf_evsel, node);
+	evsel = list_entry(list->prev, struct perf_evsel, node);
+
+	leader->nr_members = evsel->idx - leader->idx + 1;
 
 	list_for_each_entry(evsel, list, node) {
 		if (evsel != leader)
@@ -126,8 +129,10 @@ void __perf_evlist__set_leader(struct list_head *list)
 
 void perf_evlist__set_leader(struct perf_evlist *evlist)
 {
-	if (evlist->nr_entries)
+	if (evlist->nr_entries) {
+		evlist->nr_groups = evlist->nr_entries > 1 ? 1 : 0;
 		__perf_evlist__set_leader(&evlist->entries);
+	}
 }
 
 int perf_evlist__add_default(struct perf_evlist *evlist)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 457e235..73579a2 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -21,6 +21,7 @@ struct perf_evlist {
 	struct list_head entries;
 	struct hlist_head heads[PERF_EVLIST__HLIST_SIZE];
 	int		 nr_entries;
+	int		 nr_groups;
 	int		 nr_fds;
 	int		 nr_mmaps;
 	int		 mmap_len;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index cbf4232..c9031eb 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -74,6 +74,7 @@ struct perf_evsel {
 	bool 			needs_swap;
 	/* parse modifier helper */
 	int			exclude_GH;
+	int			nr_members;
 	struct perf_evsel	*leader;
 	char			*group_name;
 };
@@ -259,4 +260,9 @@ bool perf_evsel__fallback(struct perf_evsel *evsel, int err,
 int perf_evsel__open_strerror(struct perf_evsel *evsel,
 			      struct perf_target *target,
 			      int err, char *msg, size_t size);
+
+static inline int perf_evsel__group_idx(struct perf_evsel *evsel)
+{
+	return evsel->idx - evsel->leader->idx;
+}
 #endif /* __PERF_EVSEL_H */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 02f6421..4e0f5c2 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -884,6 +884,7 @@ int parse_events(struct perf_evlist *evlist, const char *str)
 	if (!ret) {
 		int entries = data.idx - evlist->nr_entries;
 		perf_evlist__splice_list_tail(evlist, &data.list, entries);
+		evlist->nr_groups += data.nr_groups;
 		return 0;
 	}
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 2cd2c42..8a48593 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -64,6 +64,7 @@ struct parse_events_term {
 struct parse_events_evlist {
 	struct list_head list;
 	int idx;
+	int nr_groups;
 };
 
 struct parse_events_terms {
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 9d43c86..4de2fdc 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -23,6 +23,14 @@ do { \
 		YYABORT; \
 } while (0)
 
+static inc_group_count(struct list_head *list,
+		       struct parse_events_evlist *data)
+{
+	/* Count groups only have more than 1 members */
+	if (!list_is_last(list->next, list))
+		data->nr_groups++;
+}
+
 %}
 
 %token PE_START_EVENTS PE_START_TERMS
@@ -123,6 +131,7 @@ PE_NAME '{' events '}'
 {
 	struct list_head *list = $3;
 
+	inc_group_count(list, _data);
 	parse_events__set_leader($1, list);
 	$$ = list;
 }
@@ -131,6 +140,7 @@ PE_NAME '{' events '}'
 {
 	struct list_head *list = $2;
 
+	inc_group_count(list, _data);
 	parse_events__set_leader(NULL, list);
 	$$ = list;
 }
-- 
1.8.1.1.361.gec3ae6e

