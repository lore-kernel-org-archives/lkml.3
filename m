Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbbA2IST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:18:19 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51226 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbbA2IKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:07 -0500
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
Subject: [PATCH 15/42] perf report: Skip dummy tracking event
Date: Thu, 29 Jan 2015 17:06:56 +0900
Message-Id: <1422518843-25818-16-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dummy tracking event is only for tracking task/comom/mmap events
and has no sample data for itself.  So no need to report, just skip it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c    |  3 +++
 tools/perf/ui/browsers/hists.c | 30 ++++++++++++++++++++++++------
 tools/perf/ui/gtk/hists.c      |  3 +++
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2f91094e228b..4cac79ad3085 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -318,6 +318,9 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 		struct hists *hists = evsel__hists(pos);
 		const char *evname = perf_evsel__name(pos);
 
+		if (perf_evsel__is_dummy_tracking(pos))
+			continue;
+
 		if (symbol_conf.event_group &&
 		    !perf_evsel__is_group_leader(pos))
 			continue;
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 788506eef567..7d33d7dc0824 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1947,14 +1947,17 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
 	return key;
 }
 
-static bool filter_group_entries(struct ui_browser *browser __maybe_unused,
-				 void *entry)
+static bool filter_entries(struct ui_browser *browser __maybe_unused,
+			   void *entry)
 {
 	struct perf_evsel *evsel = list_entry(entry, struct perf_evsel, node);
 
 	if (symbol_conf.event_group && !perf_evsel__is_group_leader(evsel))
 		return true;
 
+	if (perf_evsel__is_dummy_tracking(evsel))
+		return true;
+
 	return false;
 }
 
@@ -1971,7 +1974,7 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			.refresh    = ui_browser__list_head_refresh,
 			.seek	    = ui_browser__list_head_seek,
 			.write	    = perf_evsel_menu__write,
-			.filter	    = filter_group_entries,
+			.filter	    = filter_entries,
 			.nr_entries = nr_entries,
 			.priv	    = evlist,
 		},
@@ -1998,21 +2001,22 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  struct perf_session_env *env)
 {
 	int nr_entries = evlist->nr_entries;
+	struct perf_evsel *first = perf_evlist__first(evlist);
+	struct perf_evsel *pos;
 
 single_entry:
 	if (nr_entries == 1) {
-		struct perf_evsel *first = perf_evlist__first(evlist);
-
 		return perf_evsel__hists_browse(first, nr_entries, help,
 						false, hbt, min_pcnt,
 						env);
 	}
 
 	if (symbol_conf.event_group) {
-		struct perf_evsel *pos;
 
 		nr_entries = 0;
 		evlist__for_each(evlist, pos) {
+			if (perf_evsel__is_dummy_tracking(pos))
+				continue;
 			if (perf_evsel__is_group_leader(pos))
 				nr_entries++;
 		}
@@ -2021,6 +2025,20 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 			goto single_entry;
 	}
 
+	evlist__for_each(evlist, pos) {
+		if (perf_evsel__is_dummy_tracking(pos))
+			nr_entries--;
+	}
+
+	if (nr_entries == 1) {
+		evlist__for_each(evlist, pos) {
+			if (!perf_evsel__is_dummy_tracking(pos)) {
+				first = pos;
+				goto single_entry;
+			}
+		}
+	}
+
 	return __perf_evlist__tui_browse_hists(evlist, nr_entries, help,
 					       hbt, min_pcnt, env);
 }
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 4b3585eed1e8..83a7ecd5cda8 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -317,6 +317,9 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 		char buf[512];
 		size_t size = sizeof(buf);
 
+		if (perf_evsel__is_dummy_tracking(pos))
+			continue;
+
 		if (symbol_conf.event_group) {
 			if (!perf_evsel__is_group_leader(pos))
 				continue;
-- 
2.2.2

