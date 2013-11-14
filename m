Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab3KNU1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:27:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36307 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab3KNUZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:25:26 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/10] perf tools: Use perf_evlist__{first,last}, perf_evsel__next
Date: Thu, 14 Nov 2013 17:25:10 -0300
Message-Id: <1384460715-23198-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384460715-23198-1-git-send-email-acme@infradead.org>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

In a few remaining places where the equivalent open coded variant was
still being used.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-4vjnloi5fisilykwxalb5nel@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/parse-events.c | 3 +--
 tools/perf/ui/browsers/hists.c  | 9 ++++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index ef671cd41bb3..3cbd10496087 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -441,9 +441,8 @@ static int test__checkevent_pmu_name(struct perf_evlist *evlist)
 
 static int test__checkevent_pmu_events(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel;
+	struct perf_evsel *evsel = perf_evlist__first(evlist);
 
-	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
 	TEST_ASSERT_VAL("wrong number of entries", 1 == evlist->nr_entries);
 	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong exclude_user",
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 16848bb4c418..089fd3713783 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1847,13 +1847,13 @@ browse_hists:
 			switch (key) {
 			case K_TAB:
 				if (pos->node.next == &evlist->entries)
-					pos = list_entry(evlist->entries.next, struct perf_evsel, node);
+					pos = perf_evlist__first(evlist);
 				else
-					pos = list_entry(pos->node.next, struct perf_evsel, node);
+					pos = perf_evsel__next(pos);
 				goto browse_hists;
 			case K_UNTAB:
 				if (pos->node.prev == &evlist->entries)
-					pos = list_entry(evlist->entries.prev, struct perf_evsel, node);
+					pos = perf_evlist__last(evlist);
 				else
 					pos = list_entry(pos->node.prev, struct perf_evsel, node);
 				goto browse_hists;
@@ -1943,8 +1943,7 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 
 single_entry:
 	if (nr_entries == 1) {
-		struct perf_evsel *first = list_entry(evlist->entries.next,
-						      struct perf_evsel, node);
+		struct perf_evsel *first = perf_evlist__first(evlist);
 		const char *ev_name = perf_evsel__name(first);
 
 		return perf_evsel__hists_browse(first, nr_entries, help,
-- 
1.8.1.4

