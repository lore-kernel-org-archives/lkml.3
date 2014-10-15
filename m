Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaJOUxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:53:08 -0400
Received: from mail.kernel.org ([198.145.19.201]:35351 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaJOUxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:53:05 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Taeung Song <treeze.taeung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/15] perf top: Add a visual cue for toggle zeroing of samples
Date: Wed, 15 Oct 2014 17:52:34 -0300
Message-Id: <1413406368-26245-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413406368-26245-1-git-send-email-acme@kernel.org>
References: <1413406368-26245-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Taeung Song <treeze.taeung@gmail.com>

When 'perf top' is run, one can't easily find a difference
between -z option and normal output.
So I added a visual cue to know whether it is the zeroing or not.

Output is as below.

Before:
 $ perf top

 Samples: 61K of event 'cycles', Event count (approx.): 3908136933
 Overhead  Shared Object                       Symbol
    1.42%  firefox                             [.] 0x0000000000011e76
    1.32%  libpthread-2.17.so                  [.] pthread_mutex_lock

If you press key 'z' or run with zero option like '$ perf top --zero', it is as below.

After:
 Samples: 61K of event 'cycles', Event count (approx.): 3908136933 [z]
 Overhead  Shared Object                       Symbol
    1.42%  firefox                             [.] 0x0000000000011e76
    1.32%  libpthread-2.17.so                  [.] pthread_mutex_lock

Signed-off-by: Taeung Song <treeze.taeung@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1412665995-26359-1-git-send-email-treeze.taeung@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 68eab9ea1634..cfb976b3de3a 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -35,7 +35,9 @@ struct hist_browser {
 
 extern void hist_browser__init_hpp(void);
 
-static int hists__browser_title(struct hists *hists, char *bf, size_t size);
+static int hists__browser_title(struct hists *hists,
+				struct hist_browser_timer *hbt,
+				char *bf, size_t size);
 static void hist_browser__update_nr_entries(struct hist_browser *hb);
 
 static struct rb_node *hists__filter_entries(struct rb_node *nd,
@@ -390,7 +392,7 @@ static int hist_browser__run(struct hist_browser *browser,
 	browser->b.entries = &browser->hists->entries;
 	browser->b.nr_entries = hist_browser__nr_entries(browser);
 
-	hists__browser_title(browser->hists, title, sizeof(title));
+	hists__browser_title(browser->hists, hbt, title, sizeof(title));
 
 	if (ui_browser__show(&browser->b, title,
 			     "Press '?' for help on key bindings") < 0)
@@ -417,7 +419,8 @@ static int hist_browser__run(struct hist_browser *browser,
 				ui_browser__warn_lost_events(&browser->b);
 			}
 
-			hists__browser_title(browser->hists, title, sizeof(title));
+			hists__browser_title(browser->hists,
+					     hbt, title, sizeof(title));
 			ui_browser__show_title(&browser->b, title);
 			continue;
 		}
@@ -1204,7 +1207,15 @@ static struct thread *hist_browser__selected_thread(struct hist_browser *browser
 	return browser->he_selection->thread;
 }
 
-static int hists__browser_title(struct hists *hists, char *bf, size_t size)
+/* Check whether the browser is for 'top' or 'report' */
+static inline bool is_report_browser(void *timer)
+{
+	return timer == NULL;
+}
+
+static int hists__browser_title(struct hists *hists,
+				struct hist_browser_timer *hbt,
+				char *bf, size_t size)
 {
 	char unit;
 	int printed;
@@ -1258,6 +1269,13 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size)
 	if (dso)
 		printed += scnprintf(bf + printed, size - printed,
 				    ", DSO: %s", dso->short_name);
+	if (!is_report_browser(hbt)) {
+		struct perf_top *top = hbt->arg;
+
+		if (top->zero)
+			printed += scnprintf(bf + printed, size - printed, " [z]");
+	}
+
 	return printed;
 }
 
@@ -1269,12 +1287,6 @@ static inline void free_popup_options(char **options, int n)
 		zfree(&options[i]);
 }
 
-/* Check whether the browser is for 'top' or 'report' */
-static inline bool is_report_browser(void *timer)
-{
-	return timer == NULL;
-}
-
 /*
  * Only runtime switching of perf data file will make "input_name" point
  * to a malloced buffer. So add "is_input_name_malloced" flag to decide
-- 
1.9.3

