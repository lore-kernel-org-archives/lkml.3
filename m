Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270Ab3BNVqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 16:46:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57490 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934996Ab3BNVor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 16:44:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/10] perf gtk/annotate: Support multiple event annotation
Date: Thu, 14 Feb 2013 18:44:17 -0300
Message-Id: <1360878263-12694-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1360878263-12694-1-git-send-email-acme@infradead.org>
References: <1360878263-12694-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Show multiple annotation result for each evsel.  Each result represents
the most frquently sampled symbol/function for the evsel and it will be
shown in a tab window.

For this add a reference to main container (notebook) to the pgctx.  At
the first call to annotate browser, hist_entry__find_annotations() will
setup a new browser, and next calls will add new tabs to the browser.
But it requires final perf_gtk__show_annotations() to start processing
GUI events.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360227734-375-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |  4 +++
 tools/perf/ui/gtk/annotate.c  | 74 +++++++++++++++++++++++++++----------------
 tools/perf/ui/gtk/gtk.h       |  1 +
 tools/perf/util/annotate.h    |  4 +++
 4 files changed, 56 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 9d758c9..68e3a16 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -227,6 +227,10 @@ static int __cmd_annotate(struct perf_annotate *ann)
 		ui__error("The %s file has no samples!\n", session->filename);
 		goto out_delete;
 	}
+
+	if (use_browser == 2)
+		perf_gtk__show_annotations();
+
 out_delete:
 	/*
 	 * Speed up the exit process, for large files this can
diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
index 19d84fa..1ce89f2 100644
--- a/tools/perf/ui/gtk/annotate.c
+++ b/tools/perf/ui/gtk/annotate.c
@@ -126,31 +126,52 @@ static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
 int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
 			 struct hist_browser_timer *hbt)
 {
-	GtkWidget *vbox;
-	GtkWidget *notebook;
-	GtkWidget *infobar;
-	GtkWidget *statbar;
 	GtkWidget *window;
+	GtkWidget *notebook;
 	GtkWidget *scrolled_window;
 	GtkWidget *tab_label;
 
-	signal(SIGSEGV, perf_gtk__signal);
-	signal(SIGFPE,  perf_gtk__signal);
-	signal(SIGINT,  perf_gtk__signal);
-	signal(SIGQUIT, perf_gtk__signal);
-	signal(SIGTERM, perf_gtk__signal);
+	if (perf_gtk__is_active_context(pgctx)) {
+		window = pgctx->main_window;
+		notebook = pgctx->notebook;
+	} else {
+		GtkWidget *vbox;
+		GtkWidget *infobar;
+		GtkWidget *statbar;
 
-	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
-	gtk_window_set_title(GTK_WINDOW(window), "perf annotate");
+		signal(SIGSEGV, perf_gtk__signal);
+		signal(SIGFPE,  perf_gtk__signal);
+		signal(SIGINT,  perf_gtk__signal);
+		signal(SIGQUIT, perf_gtk__signal);
+		signal(SIGTERM, perf_gtk__signal);
 
-	g_signal_connect(window, "delete_event", gtk_main_quit, NULL);
+		window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
+		gtk_window_set_title(GTK_WINDOW(window), "perf annotate");
 
-	pgctx = perf_gtk__activate_context(window);
-	if (!pgctx)
-		return -1;
+		g_signal_connect(window, "delete_event", gtk_main_quit, NULL);
+
+		pgctx = perf_gtk__activate_context(window);
+		if (!pgctx)
+			return -1;
+
+		vbox = gtk_vbox_new(FALSE, 0);
+		notebook = gtk_notebook_new();
+		pgctx->notebook = notebook;
+
+		gtk_box_pack_start(GTK_BOX(vbox), notebook, TRUE, TRUE, 0);
+
+		infobar = perf_gtk__setup_info_bar();
+		if (infobar) {
+			gtk_box_pack_start(GTK_BOX(vbox), infobar,
+					   FALSE, FALSE, 0);
+		}
+
+		statbar = perf_gtk__setup_statusbar();
+		gtk_box_pack_start(GTK_BOX(vbox), statbar, FALSE, FALSE, 0);
+
+		gtk_container_add(GTK_CONTAINER(window), vbox);
+	}
 
-	vbox = gtk_vbox_new(FALSE, 0);
-	notebook = gtk_notebook_new();
 	scrolled_window = gtk_scrolled_window_new(NULL, NULL);
 	tab_label = gtk_label_new(sym->name);
 
@@ -160,19 +181,19 @@ int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window,
 				 tab_label);
-	gtk_box_pack_start(GTK_BOX(vbox), notebook, TRUE, TRUE, 0);
-
-	infobar = perf_gtk__setup_info_bar();
-	if (infobar)
-		gtk_box_pack_start(GTK_BOX(vbox), infobar, FALSE, FALSE, 0);
 
-	statbar = perf_gtk__setup_statusbar();
-	gtk_box_pack_start(GTK_BOX(vbox), statbar, FALSE, FALSE, 0);
+	perf_gtk__annotate_symbol(scrolled_window, sym, map, evidx, hbt);
+	return 0;
+}
 
-	gtk_container_add(GTK_CONTAINER(window), vbox);
+void perf_gtk__show_annotations(void)
+{
+	GtkWidget *window;
 
-	perf_gtk__annotate_symbol(scrolled_window, sym, map, evidx, hbt);
+	if (!perf_gtk__is_active_context(pgctx))
+		return;
 
+	window = pgctx->main_window;
 	gtk_widget_show_all(window);
 
 	perf_gtk__resize_window(window);
@@ -181,5 +202,4 @@ int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
 	gtk_main();
 
 	perf_gtk__deactivate_context(&pgctx);
-	return 0;
 }
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 5d36937..3d96785 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -10,6 +10,7 @@
 
 struct perf_gtk_context {
 	GtkWidget *main_window;
+	GtkWidget *notebook;
 
 #ifdef HAVE_GTK_INFO_BAR
 	GtkWidget *info_bar;
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index a8ccbda..c422440 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -164,6 +164,8 @@ static inline int hist_entry__gtk_annotate(struct hist_entry *he, int evidx,
 {
 	return symbol__gtk_annotate(he->ms.sym, he->ms.map, evidx, hbt);
 }
+
+void perf_gtk__show_annotations(void);
 #else
 static inline int hist_entry__gtk_annotate(struct hist_entry *he __maybe_unused,
 					   int evidx __maybe_unused,
@@ -172,6 +174,8 @@ static inline int hist_entry__gtk_annotate(struct hist_entry *he __maybe_unused,
 {
 	return 0;
 }
+
+static inline void perf_gtk__show_annotations(void) {}
 #endif
 
 extern const char	*disassembler_style;
-- 
1.8.1.1.361.gec3ae6e

