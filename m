Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaAMUyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:54:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40431 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbaAMUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:09 -0500
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
Subject: [PATCH 22/38] perf report: Move hist browser selection code to separate function
Date: Mon, 13 Jan 2014 17:47:23 -0300
Message-Id: <1389646059-24881-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To unclutter the main function.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-agvxwpazlucy6h5sejuttw9t@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 79 ++++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f2ff8609e98e..03941ad8fc46 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -441,13 +441,57 @@ static void report__warn_kptr_restrict(const struct report *rep)
 	}
 }
 
+static int report__gtk_browse_hists(struct report *rep, const char *help)
+{
+	int (*hist_browser)(struct perf_evlist *evlist, const char *help,
+			    struct hist_browser_timer *timer, float min_pcnt);
+
+	hist_browser = dlsym(perf_gtk_handle, "perf_evlist__gtk_browse_hists");
+
+	if (hist_browser == NULL) {
+		ui__error("GTK browser not found!\n");
+		return -1;
+	}
+
+	return hist_browser(rep->session->evlist, help, NULL, rep->min_percent);
+}
+
+static int report__browse_hists(struct report *rep)
+{
+	int ret;
+	struct perf_session *session = rep->session;
+	struct perf_evlist *evlist = session->evlist;
+	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
+
+	switch (use_browser) {
+	case 1:
+		ret = perf_evlist__tui_browse_hists(evlist, help, NULL,
+						    rep->min_percent,
+						    &session->header.env);
+		/*
+		 * Usually "ret" is the last pressed key, and we only
+		 * care if the key notifies us to switch data file.
+		 */
+		if (ret != K_SWITCH_INPUT_DATA)
+			ret = 0;
+		break;
+	case 2:
+		ret = report__gtk_browse_hists(rep, help);
+		break;
+	default:
+		ret = perf_evlist__tty_browse_hists(evlist, rep, help);
+		break;
+	}
+
+	return ret;
+}
+
 static int __cmd_report(struct report *rep)
 {
 	int ret = -EINVAL;
 	u64 nr_samples;
 	struct perf_session *session = rep->session;
 	struct perf_evsel *pos;
-	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
 	struct ui_progress prog;
 	struct perf_data_file *file = session->file;
 
@@ -524,38 +568,7 @@ static int __cmd_report(struct report *rep)
 	list_for_each_entry(pos, &session->evlist->entries, node)
 		hists__output_resort(&pos->hists);
 
-	if (use_browser > 0) {
-		if (use_browser == 1) {
-			ret = perf_evlist__tui_browse_hists(session->evlist,
-							help, NULL,
-							rep->min_percent,
-							&session->header.env);
-			/*
-			 * Usually "ret" is the last pressed key, and we only
-			 * care if the key notifies us to switch data file.
-			 */
-			if (ret != K_SWITCH_INPUT_DATA)
-				ret = 0;
-
-		} else if (use_browser == 2) {
-			int (*hist_browser)(struct perf_evlist *,
-					    const char *,
-					    struct hist_browser_timer *,
-					    float min_pcnt);
-
-			hist_browser = dlsym(perf_gtk_handle,
-					     "perf_evlist__gtk_browse_hists");
-			if (hist_browser == NULL) {
-				ui__error("GTK browser not found!\n");
-				return ret;
-			}
-			hist_browser(session->evlist, help, NULL,
-				     rep->min_percent);
-		}
-	} else
-		perf_evlist__tty_browse_hists(session->evlist, rep, help);
-
-	return ret;
+	return report__browse_hists(rep);
 }
 
 static int
-- 
1.8.1.4

