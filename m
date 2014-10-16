Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247AbaJPFVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:21:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33453 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaJPFVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:21:50 -0400
Date: Wed, 15 Oct 2014 22:21:33 -0700
From: tip-bot for Taeung Song <tipbot@zytor.com>
Message-ID: <tip-1e378ebd117d1828b9d5dbe0538887478fcb9d84@git.kernel.org>
Cc: eranian@google.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, acme@redhat.com, treeze.taeung@gmail.com,
        mingo@kernel.org, namhyung@kernel.org
Reply-To: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        eranian@google.com, namhyung@kernel.org, treeze.taeung@gmail.com,
        mingo@kernel.org, acme@redhat.com
In-Reply-To: <1412665995-26359-1-git-send-email-treeze.taeung@gmail.com>
References: <1412665995-26359-1-git-send-email-treeze.taeung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf top:
  Add a visual cue for toggle zeroing of samples
Git-Commit-ID: 1e378ebd117d1828b9d5dbe0538887478fcb9d84
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e378ebd117d1828b9d5dbe0538887478fcb9d84
Gitweb:     http://git.kernel.org/tip/1e378ebd117d1828b9d5dbe0538887478fcb9d84
Author:     Taeung Song <treeze.taeung@gmail.com>
AuthorDate: Tue, 7 Oct 2014 16:13:15 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Oct 2014 15:47:48 -0300

perf top: Add a visual cue for toggle zeroing of samples

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
index 68eab9e..cfb976b 100644
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
