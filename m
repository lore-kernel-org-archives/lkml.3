Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965592AbaGPTOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:14:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43978 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760784AbaGPTOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:14:46 -0400
Date: Wed, 16 Jul 2014 12:14:07 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-ovk654rx525b4657y0mh6ku9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Override ui_browser refresh_dimensions method
Git-Commit-ID: 357cfff1c2173b7aedc0e521a2146b78396171e0
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

Commit-ID:  357cfff1c2173b7aedc0e521a2146b78396171e0
Gitweb:     http://git.kernel.org/tip/357cfff1c2173b7aedc0e521a2146b78396171e0
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 1 Jul 2014 17:01:01 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 Jul 2014 12:36:55 -0300

perf hists browser: Override ui_browser refresh_dimensions method

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
index ca63564..ef7abf8 100644
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
