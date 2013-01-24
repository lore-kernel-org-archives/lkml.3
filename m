Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3AXUdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:33:22 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54057
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755618Ab3AXUIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 31/74] perf ui/gtk: Setup browser window early
Date: Thu, 24 Jan 2013 17:07:40 -0300
Message-Id: <1359058103-31645-32-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

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
-- 
1.8.1.1.361.gec3ae6e

