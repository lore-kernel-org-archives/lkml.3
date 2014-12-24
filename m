Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaLXHWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:22:40 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39667 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaLXHOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:14:54 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 10/37] perf report: Skip dummy tracking event
Date: Wed, 24 Dec 2014 16:15:06 +0900
Message-Id: <1419405333-27952-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dummy tracking event is only for tracking task/comom/mmap events
and has no sample data for itself.  So no need to report, just skip it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c    |  3 +++
 tools/perf/ui/browsers/hists.c | 10 ++++++++--
 tools/perf/ui/gtk/hists.c      |  3 +++
 3 files changed, 14 insertions(+), 2 deletions(-)

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
index e6bb04b5b09b..be594e1d6a99 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1998,11 +1998,15 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  struct perf_session_env *env)
 {
 	int nr_entries = evlist->nr_entries;
+	struct perf_evsel *first = perf_evlist__first(evlist);
+
+	if (perf_evsel__is_dummy_tracking(first)) {
+		first = perf_evsel__next(first);
+		nr_entries--;
+	}
 
 single_entry:
 	if (nr_entries == 1) {
-		struct perf_evsel *first = perf_evlist__first(evlist);
-
 		return perf_evsel__hists_browse(first, nr_entries, help,
 						false, hbt, min_pcnt,
 						env);
@@ -2013,6 +2017,8 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 
 		nr_entries = 0;
 		evlist__for_each(evlist, pos) {
+			if (perf_evsel__is_dummy_tracking(pos))
+				continue;
 			if (perf_evsel__is_group_leader(pos))
 				nr_entries++;
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
2.1.3

