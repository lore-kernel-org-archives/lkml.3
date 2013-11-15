Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab3KOH0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:26:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50383 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab3KOH0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:26:09 -0500
Date: Thu, 14 Nov 2013 23:25:08 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-4vjnloi5fisilykwxalb5nel@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Use perf_evlist__{first,last},
  perf_evsel__next
Git-Commit-ID: 9a354cdc2f40344a177d369fb4987a8270dd94df
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 14 Nov 2013 23:25:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a354cdc2f40344a177d369fb4987a8270dd94df
Gitweb:     http://git.kernel.org/tip/9a354cdc2f40344a177d369fb4987a8270dd94df
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 13 Nov 2013 15:54:30 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Nov 2013 16:00:10 -0300

perf tools: Use perf_evlist__{first,last}, perf_evsel__next

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
index ef671cd..3cbd104 100644
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
index 16848bb..089fd37 100644
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
