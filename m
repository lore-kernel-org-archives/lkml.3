Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343Ab3AOHd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 02:33:28 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57266 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab3AOHcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 02:32:14 -0500
X-AuditID: 9c930179-b7b0cae0000065b4-b2-50f505f96d7b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 10/13] perf report: Bypass non-leader events when event group is enabled
Date: Tue, 15 Jan 2013 16:31:54 +0900
Message-Id: <1358235117-12803-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1358235117-12803-1-git-send-email-namhyung@kernel.org>
References: <1358235117-12803-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since we have all necessary information in the leader events and
other members don't, bypass members.  Member events will be shown
along with the leaders if event group is enabled.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c    |  4 ++++
 tools/perf/ui/browsers/hists.c | 41 +++++++++++++++++++++++++++++++++++------
 tools/perf/ui/gtk/hists.c      |  4 ++++
 3 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fd2503a5f876..9cc768ecacad 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -319,6 +319,10 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 		struct hists *hists = &pos->hists;
 		const char *evname = perf_evsel__name(pos);
 
+		if (symbol_conf.event_group &&
+		    !perf_evsel__is_group_leader(pos))
+			continue;
+
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
 		hists__fprintf(hists, true, 0, 0, stdout);
 		fprintf(stdout, "\n\n");
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 65e6c005f8e9..17c1753d5fe1 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1699,8 +1699,19 @@ out:
 	return key;
 }
 
+static bool filter_group_entries(struct ui_browser *self __maybe_unused,
+				 void *entry)
+{
+	struct perf_evsel *evsel = list_entry(entry, struct perf_evsel, node);
+
+	if (symbol_conf.event_group && !perf_evsel__is_group_leader(evsel))
+		return true;
+
+	return false;
+}
+
 static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
-					   const char *help,
+					   int nr_entries, const char *help,
 					   struct hist_browser_timer *hbt,
 					   struct perf_session_env *env)
 {
@@ -1711,7 +1722,8 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			.refresh    = ui_browser__list_head_refresh,
 			.seek	    = ui_browser__list_head_seek,
 			.write	    = perf_evsel_menu__write,
-			.nr_entries = evlist->nr_entries,
+			.filter	    = filter_group_entries,
+			.nr_entries = nr_entries,
 			.priv	    = evlist,
 		},
 		.env = env,
@@ -1727,20 +1739,37 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			menu.b.width = line_len;
 	}
 
-	return perf_evsel_menu__run(&menu, evlist->nr_entries, help, hbt);
+	return perf_evsel_menu__run(&menu, nr_entries, help, hbt);
 }
 
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  struct hist_browser_timer *hbt,
 				  struct perf_session_env *env)
 {
-	if (evlist->nr_entries == 1) {
+	int nr_entries = evlist->nr_entries;
+
+single_entry:
+	if (nr_entries == 1) {
 		struct perf_evsel *first = list_entry(evlist->entries.next,
 						      struct perf_evsel, node);
 		const char *ev_name = perf_evsel__name(first);
-		return perf_evsel__hists_browse(first, evlist->nr_entries, help,
+
+		return perf_evsel__hists_browse(first, nr_entries, help,
 						ev_name, false, hbt, env);
 	}
 
-	return __perf_evlist__tui_browse_hists(evlist, help, hbt, env);
+	if (symbol_conf.event_group) {
+		struct perf_evsel *pos;
+
+		nr_entries = 0;
+		list_for_each_entry(pos, &evlist->entries, node)
+			if (perf_evsel__is_group_leader(pos))
+				nr_entries++;
+
+		if (nr_entries == 1)
+			goto single_entry;
+	}
+
+	return __perf_evlist__tui_browse_hists(evlist, nr_entries, help,
+					       hbt, env);
 }
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 8ab2c492a6fd..d6eb50d2aa26 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -267,6 +267,10 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 		GtkWidget *scrolled_window;
 		GtkWidget *tab_label;
 
+		if (symbol_conf.event_group &&
+		    !perf_evsel__is_group_leader(pos))
+			continue;
+
 		scrolled_window = gtk_scrolled_window_new(NULL, NULL);
 
 		gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window),
-- 
1.7.11.7

