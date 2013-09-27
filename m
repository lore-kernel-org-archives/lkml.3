Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3I0Och (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:32:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab3I0Oce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:32:34 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [BUG/RFC 3/3] perf tools: Add missing GTK2_SUPPORT ifdefs
Date: Fri, 27 Sep 2013 16:32:12 +0200
Message-Id: <1380292332-6518-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380292332-6518-1-git-send-email-jolsa@redhat.com>
References: <1380221754-29865-1-git-send-email-jolsa@redhat.com>
 <1380292332-6518-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building minimal perf via:
  NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1 NO_DEMANGLE=1
  NO_LIBELF=1 NO_LIBUNWIND=1 NO_BACKTRACE=1 NO_LIBNUMA=1 NO_LIBAUDIT=1
  NO_LIBBIONIC=1

We dont link -ldl and that's causing error for gtk2 related code,
which is disabled on command line (NO_GTK2), but not in the code
(GTK2_SUPPORT).

We probably need some global fix/change for this browser
enabled/disable code.

Tested just by building it corretly.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-annotate.c | 6 ++++++
 tools/perf/builtin-report.c   | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 577c3a1..ddde407 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -142,6 +142,7 @@ find_next:
 		}
 
 		if (use_browser == 2) {
+#ifdef GTK2_SUPPORT
 			int ret;
 			int (*annotate)(struct hist_entry *he,
 					struct perf_evsel *evsel,
@@ -161,6 +162,9 @@ find_next:
 			/* skip missing symbols */
 			nd = rb_next(nd);
 		} else if (use_browser == 1) {
+#else
+			use_browser = 1;
+#endif
 			key = hist_entry__tui_annotate(he, evsel, NULL);
 			switch (key) {
 			case -1:
@@ -258,6 +262,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 		goto out_delete;
 	}
 
+#ifdef GTK2_SUPPORT
 	if (use_browser == 2) {
 		void (*show_annotations)(void);
 
@@ -269,6 +274,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 		}
 		show_annotations();
 	}
+#endif
 
 out_delete:
 	/*
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 295025e..c902229 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -591,6 +591,7 @@ static int __cmd_report(struct perf_report *rep)
 				ret = 0;
 
 		} else if (use_browser == 2) {
+#ifdef GTK2_SUPPORT
 			int (*hist_browser)(struct perf_evlist *,
 					    const char *,
 					    struct hist_browser_timer *,
@@ -604,6 +605,7 @@ static int __cmd_report(struct perf_report *rep)
 			}
 			hist_browser(session->evlist, help, NULL,
 				     rep->min_percent);
+#endif
 		}
 	} else
 		perf_evlist__tty_browse_hists(session->evlist, rep, help);
-- 
1.7.11.7

