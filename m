Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaANQqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:46:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaANQkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:40:37 -0500
Date: Tue, 14 Jan 2014 08:39:56 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-agvxwpazlucy6h5sejuttw9t@git.kernel.org>
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
Subject: [tip:perf/core] perf report:
  Move hist browser selection code to separate function
Git-Commit-ID: 8362951b7b0618687beddac90aeee43940d20659
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:40:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8362951b7b0618687beddac90aeee43940d20659
Gitweb:     http://git.kernel.org/tip/8362951b7b0618687beddac90aeee43940d20659
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 8 Jan 2014 12:22:07 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:25 -0300

perf report: Move hist browser selection code to separate function

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
index f2ff860..03941ad 100644
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
