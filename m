Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422865Ab3BAKxq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:53:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52114 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422873Ab3BAKxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:53:43 -0500
Date: Fri, 1 Feb 2013 02:53:24 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-fc24d7c25c9d880ae012548d522fe13caee556ed@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1358845787-1350-16-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-16-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Bypass non-leader events when event group is enabled
Git-Commit-ID: fc24d7c25c9d880ae012548d522fe13caee556ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:53:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc24d7c25c9d880ae012548d522fe13caee556ed
Gitweb:     http://git.kernel.org/tip/fc24d7c25c9d880ae012548d522fe13caee556ed
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:43 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:48 -0300

perf report: Bypass non-leader events when event group is enabled

Since we have all necessary information in the leader events and other
members don't, bypass members.  Member events will be shown along with
the leaders if event group is enabled.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-16-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c    |  4 ++++
 tools/perf/ui/browsers/hists.c | 41 +++++++++++++++++++++++++++++++++++------
 tools/perf/ui/gtk/hists.c      |  4 ++++
 3 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fd2503a..9cc768e 100644
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
index d7112df..167f770 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1695,8 +1695,19 @@ out:
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
@@ -1707,7 +1718,8 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			.refresh    = ui_browser__list_head_refresh,
 			.seek	    = ui_browser__list_head_seek,
 			.write	    = perf_evsel_menu__write,
-			.nr_entries = evlist->nr_entries,
+			.filter	    = filter_group_entries,
+			.nr_entries = nr_entries,
 			.priv	    = evlist,
 		},
 		.env = env,
@@ -1723,20 +1735,37 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
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
index caa554b..9c02c4c 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -271,6 +271,10 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 		GtkWidget *scrolled_window;
 		GtkWidget *tab_label;
 
+		if (symbol_conf.event_group &&
+		    !perf_evsel__is_group_leader(pos))
+			continue;
+
 		scrolled_window = gtk_scrolled_window_new(NULL, NULL);
 
 		gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window),
