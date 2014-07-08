Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaGHTDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:03:40 -0400
Received: from mail.kernel.org ([198.145.19.201]:58034 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127AbaGHTDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:03:35 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/16] perf hists browser: Override ui_browser refresh_dimensions method
Date: Tue,  8 Jul 2014 16:02:52 -0300
Message-Id: <1404846184-20075-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404846184-20075-1-git-send-email-acme@kernel.org>
References: <1404846184-20075-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This requires some more work so that we can really just use the width of
current entries when we want to partition the screen.

Right now its just a prep patch so that we can have where to update
ui_browser->rows when introducing the column headers line, that will be
togglable, so we need to update it everytime we refresh the dimensions
of the browser.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ovk654rx525b4657y0mh6ku9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index ca63564d203a..ef7abf896f5a 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -56,11 +56,19 @@ static u32 hist_browser__nr_entries(struct hist_browser *hb)
 	return nr_entries + hb->nr_callchain_rows;
 }
 
-static void hist_browser__refresh_dimensions(struct hist_browser *browser)
+static void hist_browser__refresh_dimensions(struct ui_browser *browser)
 {
+	struct hist_browser *hb = container_of(browser, struct hist_browser, b);
+
 	/* 3 == +/- toggle symbol before actual hist_entry rendering */
-	browser->b.width = 3 + (hists__sort_list_width(browser->hists) +
-			     sizeof("[k]"));
+	browser->width = 3 + (hists__sort_list_width(hb->hists) + sizeof("[k]"));
+	/*
+ 	 * FIXME: Just keeping existing behaviour, but this really should be
+ 	 *	  before updating browser->width, as it will invalidate the
+ 	 *	  calculation above. Fix this and the fallout in another
+ 	 *	  changeset.
+ 	 */
+	ui_browser__refresh_dimensions(browser);
 }
 
 static void hist_browser__gotorc(struct hist_browser *browser, int row, int column)
@@ -78,7 +86,7 @@ static void hist_browser__reset(struct hist_browser *browser)
 
 	hist_browser__update_nr_entries(browser);
 	browser->b.nr_entries = hist_browser__nr_entries(browser);
-	hist_browser__refresh_dimensions(browser);
+	hist_browser__refresh_dimensions(&browser->b);
 	ui_browser__reset_index(&browser->b);
 }
 
@@ -360,7 +368,6 @@ static int hist_browser__run(struct hist_browser *browser,
 	browser->b.entries = &browser->hists->entries;
 	browser->b.nr_entries = hist_browser__nr_entries(browser);
 
-	hist_browser__refresh_dimensions(browser);
 	hists__browser_title(browser->hists, title, sizeof(title));
 
 	if (ui_browser__show(&browser->b, title,
@@ -1195,6 +1202,7 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 	if (browser) {
 		browser->hists = hists;
 		browser->b.refresh = hist_browser__refresh;
+		browser->b.refresh_dimensions = hist_browser__refresh_dimensions;
 		browser->b.seek = ui_browser__hists_seek;
 		browser->b.use_navkeypressed = true;
 	}
-- 
1.9.3

