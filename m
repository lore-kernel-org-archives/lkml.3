Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3BGJCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 04:02:32 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45999 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3BGJCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 04:02:25 -0500
X-AuditID: 9c930179-b7c24ae00000119c-8b-51136d9cf3bc
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/7] perf ui/gtk: Implement basic GTK2 annotation browser
Date: Thu,  7 Feb 2013 18:02:08 +0900
Message-Id: <1360227734-375-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1360227734-375-1-git-send-email-namhyung@kernel.org>
References: <1360227734-375-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basic implementation of perf annotate on GTK2.  Currently only
shows first symbol.  Add a new --gtk option to use it.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-annotate.txt |   4 +-
 tools/perf/Makefile                        |   1 +
 tools/perf/builtin-annotate.c              |  10 +-
 tools/perf/ui/gtk/annotate.c               | 185 +++++++++++++++++++++++++++++
 tools/perf/ui/setup.c                      |   2 +-
 tools/perf/util/annotate.h                 |  20 ++++
 6 files changed, 218 insertions(+), 4 deletions(-)
 create mode 100644 tools/perf/ui/gtk/annotate.c

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index c8ffd9fd5c6a..e5e1d06efc37 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -61,11 +61,13 @@ OPTIONS
 
 --stdio:: Use the stdio interface.
 
---tui:: Use the TUI interface Use of --tui requires a tty, if one is not
+--tui:: Use the TUI interface. Use of --tui requires a tty, if one is not
 	present, as when piping to other commands, the stdio interface is
 	used. This interfaces starts by centering on the line with more
 	samples, TAB/UNTAB cycles through the lines with more samples.
 
+--gtk:: Use the GTK interface.
+
 -C::
 --cpu:: Only report samples for the list of CPUs provided. Multiple CPUs can
 	be provided as a comma-separated list with no space: 0,1. Ranges of
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a158309a65ef..1c8df6f9c4d9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -698,6 +698,7 @@ ifndef NO_GTK2
 		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
+		LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
 	endif
 endif
 
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 95a2ad3f043e..9d758c9611a5 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -34,7 +34,7 @@
 
 struct perf_annotate {
 	struct perf_tool tool;
-	bool	   force, use_tui, use_stdio;
+	bool	   force, use_tui, use_stdio, use_gtk;
 	bool	   full_paths;
 	bool	   print_line;
 	const char *sym_hist_filter;
@@ -138,7 +138,10 @@ find_next:
 			continue;
 		}
 
-		if (use_browser > 0) {
+		if (use_browser == 2) {
+			hist_entry__gtk_annotate(he, evidx, NULL);
+			return;
+		} else if (use_browser == 1) {
 			key = hist_entry__tui_annotate(he, evidx, NULL);
 			switch (key) {
 			case K_RIGHT:
@@ -270,6 +273,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
 		    "dump raw trace in ASCII"),
+	OPT_BOOLEAN(0, "gtk", &annotate.use_gtk, "Use the GTK interface"),
 	OPT_BOOLEAN(0, "tui", &annotate.use_tui, "Use the TUI interface"),
 	OPT_BOOLEAN(0, "stdio", &annotate.use_stdio, "Use the stdio interface"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
@@ -300,6 +304,8 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		use_browser = 0;
 	else if (annotate.use_tui)
 		use_browser = 1;
+	else if (annotate.use_gtk)
+		use_browser = 2;
 
 	setup_browser(true);
 
diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
new file mode 100644
index 000000000000..19d84fa327af
--- /dev/null
+++ b/tools/perf/ui/gtk/annotate.c
@@ -0,0 +1,185 @@
+#include "gtk.h"
+#include "util/debug.h"
+#include "util/annotate.h"
+#include "ui/helpline.h"
+
+
+enum {
+	ANN_COL__PERCENT,
+	ANN_COL__OFFSET,
+	ANN_COL__LINE,
+
+	MAX_ANN_COLS
+};
+
+static const char *const col_names[] = {
+	"Overhead",
+	"Offset",
+	"Line"
+};
+
+static int perf_gtk__get_percent(char *buf, size_t size, struct symbol *sym,
+				 struct disasm_line *dl, int evidx)
+{
+	struct sym_hist *symhist;
+	double percent = 0.0;
+	const char *markup;
+	int ret = 0;
+
+	strcpy(buf, "");
+
+	if (dl->offset == (s64) -1)
+		return 0;
+
+	symhist = annotation__histogram(symbol__annotation(sym), evidx);
+	if (!symhist->addr[dl->offset])
+		return 0;
+
+	percent = 100.0 * symhist->addr[dl->offset] / symhist->sum;
+
+	markup = perf_gtk__get_percent_color(percent);
+	if (markup)
+		ret += scnprintf(buf, size, "%s", markup);
+	ret += scnprintf(buf + ret, size - ret, "%6.2f%%", percent);
+	if (markup)
+		ret += scnprintf(buf + ret, size - ret, "</span>");
+
+	return ret;
+}
+
+static int perf_gtk__get_offset(char *buf, size_t size, struct symbol *sym,
+				struct map *map, struct disasm_line *dl)
+{
+	u64 start = map__rip_2objdump(map, sym->start);
+
+	strcpy(buf, "");
+
+	if (dl->offset == (s64) -1)
+		return 0;
+
+	return scnprintf(buf, size, "%"PRIx64, start + dl->offset);
+}
+
+static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
+				struct map *map, int evidx,
+				struct hist_browser_timer *hbt __maybe_unused)
+{
+	struct disasm_line *pos, *n;
+	struct annotation *notes;
+	GType col_types[MAX_ANN_COLS];
+	GtkCellRenderer *renderer;
+	GtkListStore *store;
+	GtkWidget *view;
+	int i;
+	char s[512];
+
+	if (map->dso->annotate_warned)
+		return -1;
+
+	if (symbol__annotate(sym, map, 0) < 0) {
+		ui__error("%s", ui_helpline__current);
+		return -1;
+	}
+
+	notes = symbol__annotation(sym);
+
+	for (i = 0; i < MAX_ANN_COLS; i++) {
+		col_types[i] = G_TYPE_STRING;
+	}
+	store = gtk_list_store_newv(MAX_ANN_COLS, col_types);
+
+	view = gtk_tree_view_new();
+	renderer = gtk_cell_renderer_text_new();
+
+	for (i = 0; i < MAX_ANN_COLS; i++) {
+		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
+					-1, col_names[i], renderer,
+					i == ANN_COL__PERCENT ? "markup" : "text",
+					i, NULL);
+	}
+
+	gtk_tree_view_set_model(GTK_TREE_VIEW(view), GTK_TREE_MODEL(store));
+	g_object_unref(GTK_TREE_MODEL(store));
+
+	list_for_each_entry(pos, &notes->src->source, node) {
+		GtkTreeIter iter;
+
+		gtk_list_store_append(store, &iter);
+
+		if (perf_gtk__get_percent(s, sizeof(s), sym, pos, evidx))
+			gtk_list_store_set(store, &iter, ANN_COL__PERCENT, s, -1);
+		if (perf_gtk__get_offset(s, sizeof(s), sym, map, pos))
+			gtk_list_store_set(store, &iter, ANN_COL__OFFSET, s, -1);
+		gtk_list_store_set(store, &iter, ANN_COL__LINE, pos->line, -1);
+	}
+
+	gtk_container_add(GTK_CONTAINER(window), view);
+
+	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
+		list_del(&pos->node);
+		disasm_line__free(pos);
+	}
+
+	return 0;
+}
+
+int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
+			 struct hist_browser_timer *hbt)
+{
+	GtkWidget *vbox;
+	GtkWidget *notebook;
+	GtkWidget *infobar;
+	GtkWidget *statbar;
+	GtkWidget *window;
+	GtkWidget *scrolled_window;
+	GtkWidget *tab_label;
+
+	signal(SIGSEGV, perf_gtk__signal);
+	signal(SIGFPE,  perf_gtk__signal);
+	signal(SIGINT,  perf_gtk__signal);
+	signal(SIGQUIT, perf_gtk__signal);
+	signal(SIGTERM, perf_gtk__signal);
+
+	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
+	gtk_window_set_title(GTK_WINDOW(window), "perf annotate");
+
+	g_signal_connect(window, "delete_event", gtk_main_quit, NULL);
+
+	pgctx = perf_gtk__activate_context(window);
+	if (!pgctx)
+		return -1;
+
+	vbox = gtk_vbox_new(FALSE, 0);
+	notebook = gtk_notebook_new();
+	scrolled_window = gtk_scrolled_window_new(NULL, NULL);
+	tab_label = gtk_label_new(sym->name);
+
+	gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window),
+				       GTK_POLICY_AUTOMATIC,
+				       GTK_POLICY_AUTOMATIC);
+
+	gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window,
+				 tab_label);
+	gtk_box_pack_start(GTK_BOX(vbox), notebook, TRUE, TRUE, 0);
+
+	infobar = perf_gtk__setup_info_bar();
+	if (infobar)
+		gtk_box_pack_start(GTK_BOX(vbox), infobar, FALSE, FALSE, 0);
+
+	statbar = perf_gtk__setup_statusbar();
+	gtk_box_pack_start(GTK_BOX(vbox), statbar, FALSE, FALSE, 0);
+
+	gtk_container_add(GTK_CONTAINER(window), vbox);
+
+	perf_gtk__annotate_symbol(scrolled_window, sym, map, evidx, hbt);
+
+	gtk_widget_show_all(window);
+
+	perf_gtk__resize_window(window);
+	gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
+
+	gtk_main();
+
+	perf_gtk__deactivate_context(&pgctx);
+	return 0;
+}
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 166f13df3134..ae6a789cb0f6 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -8,7 +8,7 @@ pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
 
 void setup_browser(bool fallback_to_pager)
 {
-	if (!isatty(1) || dump_trace)
+	if (use_browser < 2 && (!isatty(1) || dump_trace))
 		use_browser = 0;
 
 	/* default to TUI */
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 8eec94358a4a..a8ccbda4aeb7 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -6,6 +6,7 @@
 #include "types.h"
 #include "symbol.h"
 #include "hist.h"
+#include "sort.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <pthread.h>
@@ -154,6 +155,25 @@ static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
 }
 #endif
 
+#ifdef GTK2_SUPPORT
+int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
+			 struct hist_browser_timer *hbt);
+
+static inline int hist_entry__gtk_annotate(struct hist_entry *he, int evidx,
+					   struct hist_browser_timer *hbt)
+{
+	return symbol__gtk_annotate(he->ms.sym, he->ms.map, evidx, hbt);
+}
+#else
+static inline int hist_entry__gtk_annotate(struct hist_entry *he __maybe_unused,
+					   int evidx __maybe_unused,
+					   struct hist_browser_timer *hbt
+					   __maybe_unused)
+{
+	return 0;
+}
+#endif
+
 extern const char	*disassembler_style;
 
 #endif	/* __PERF_ANNOTATE_H */
-- 
1.7.11.7

