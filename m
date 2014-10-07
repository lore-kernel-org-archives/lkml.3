Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaJGHNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 03:13:37 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42520 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaJGHNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 03:13:35 -0400
From: Taeung Song <treeze.taeung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: namhyung@kernel.org, linux-kernel@vger.kernel.org,
        Taeung Song <treeze.taeung@gmail.com>
Subject: [PATCH resend] perf top: Add a visual cue for toggle zeroing of samples
Date: Tue,  7 Oct 2014 16:13:15 +0900
Message-Id: <1412665995-26359-1-git-send-email-treeze.taeung@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/ui/browsers/hists.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 8f60a97..79b66d0 100644
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
@@ -1256,6 +1267,13 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size)
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
 
@@ -1267,12 +1285,6 @@ static inline void free_popup_options(char **options, int n)
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
1.8.3.2

