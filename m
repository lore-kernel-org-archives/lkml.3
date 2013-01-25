Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3AYLZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:25:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41614 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab3AYLZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:25:03 -0500
Date: Fri, 25 Jan 2013 03:24:42 -0800
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-6bf1a295a896c8dbe8cad663c6344e8c877a0570@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1356078018-31905-3-git-send-email-namhyung@kernel.org>
References: <1356078018-31905-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/gtk: Setup browser window early
Git-Commit-ID: 6bf1a295a896c8dbe8cad663c6344e8c877a0570
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:24:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6bf1a295a896c8dbe8cad663c6344e8c877a0570
Gitweb:     http://git.kernel.org/tip/6bf1a295a896c8dbe8cad663c6344e8c877a0570
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Fri, 21 Dec 2012 17:20:14 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:16 -0300

perf ui/gtk: Setup browser window early

The ui__error/warning functions use gtk infobar or statusbar and pr_*
functions use statusbar too.  But after perf gtk context created but
those infobar and/or statusbar not yet set up, calling one of those
functions will get a segment fault.

Although current code has no problem, move these setting as early as
possible so that it can prevent the segfault from future change.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1356078018-31905-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/hists.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 26912f8..c03da79 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -180,6 +180,17 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 
 	notebook = gtk_notebook_new();
 
+	gtk_box_pack_start(GTK_BOX(vbox), notebook, TRUE, TRUE, 0);
+
+	info_bar = perf_gtk__setup_info_bar();
+	if (info_bar)
+		gtk_box_pack_start(GTK_BOX(vbox), info_bar, FALSE, FALSE, 0);
+
+	statbar = perf_gtk__setup_statusbar();
+	gtk_box_pack_start(GTK_BOX(vbox), statbar, FALSE, FALSE, 0);
+
+	gtk_container_add(GTK_CONTAINER(window), vbox);
+
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct hists *hists = &pos->hists;
 		const char *evname = perf_evsel__name(pos);
@@ -199,17 +210,6 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 		gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window, tab_label);
 	}
 
-	gtk_box_pack_start(GTK_BOX(vbox), notebook, TRUE, TRUE, 0);
-
-	info_bar = perf_gtk__setup_info_bar();
-	if (info_bar)
-		gtk_box_pack_start(GTK_BOX(vbox), info_bar, FALSE, FALSE, 0);
-
-	statbar = perf_gtk__setup_statusbar();
-	gtk_box_pack_start(GTK_BOX(vbox), statbar, FALSE, FALSE, 0);
-
-	gtk_container_add(GTK_CONTAINER(window), vbox);
-
 	gtk_widget_show_all(window);
 
 	perf_gtk__resize_window(window);
