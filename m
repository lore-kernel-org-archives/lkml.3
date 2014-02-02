Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaBBVrE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:47:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbaBBVjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:39:55 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 08/22] perf tools: Implement selected logic for time sort entry
Date: Sun,  2 Feb 2014 22:38:56 +0100
Message-Id: <1391377150-23920-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Display delta time from the selected entry. Implemented
only for the TUI browser.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/ui/browsers/hists.c | 13 +++++++++++++
 tools/perf/util/sort.c         |  6 +++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 0f6d515..e26afea 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -27,6 +27,7 @@ struct hist_browser {
 	bool		     show_dso;
 	float		     min_pcnt;
 	u64		     nr_pcnt_entries;
+	u64		     time_base;
 };
 
 extern void hist_browser__init_hpp(void);
@@ -819,12 +820,24 @@ static void ui_browser__hists_init_top(struct ui_browser *browser)
 	}
 }
 
+static void init_time_base(struct hist_browser *hb)
+{
+	struct hists *hists = hb->hists;
+
+	if (hb->time_base)
+		hists->time_base = hb->time_base;
+
+	if (hists->time_base && !hb->time_base)
+		hb->time_base = hists->time_base;
+}
+
 static unsigned int hist_browser__refresh(struct ui_browser *browser)
 {
 	unsigned row = 0;
 	struct rb_node *nd;
 	struct hist_browser *hb = container_of(browser, struct hist_browser, b);
 
+	init_time_base(hb);
 	ui_browser__hists_init_top(browser);
 
 	for (nd = browser->top; nd; nd = rb_next(nd)) {
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b219eaf..381139d 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -90,11 +90,11 @@ sort__time_cmp(struct sort_entry *se __maybe_unused,
 	return right->time - left->time;
 }
 
-static u64 get_time_base(struct hist_entry *he)
+static u64 get_time_base(struct hist_entry *he, bool selected)
 {
 	struct hists *hists = he->hists;
 
-	if (!hists->time_base)
+	if (!hists->time_base || selected)
 		hists->time_base = he->time;
 
 	return hists->time_base;
@@ -106,7 +106,7 @@ static int hist_entry__time_snprintf(struct sort_entry *se __maybe_unused,
 				     size_t size, unsigned int width)
 {
 	char buf[100];
-	u64 time_base = get_time_base(he);
+	u64 time_base = get_time_base(he, selected);
 	unsigned long time_sec, time_usec;
 	unsigned long base_sec, base_usec;
 	long delta_sec, delta_usec;
-- 
1.8.3.1

