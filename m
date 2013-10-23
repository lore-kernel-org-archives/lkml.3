Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3JWVAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 17:00:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55424 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab3JWU6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 16:58:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/16] perf ui: Rename ui_progress to ui_progress_ops
Date: Wed, 23 Oct 2013 17:58:13 -0300
Message-Id: <1382561895-8237-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382561895-8237-1-git-send-email-acme@infradead.org>
References: <1382561895-8237-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Reserving 'struct ui_progress' to the per progress instances, not to the
particular set of operations used to implmenet a progress bar in the
current UI (GTK, TUI, etc).

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-zjqbfp9gx3yo45s0rp9uv42n@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf     |  1 +
 tools/perf/ui/gtk/gtk.h      |  2 +-
 tools/perf/ui/gtk/progress.c | 14 +++++++-------
 tools/perf/ui/gtk/setup.c    |  2 +-
 tools/perf/ui/progress.c     | 18 +++++++++---------
 tools/perf/ui/progress.h     |  6 ++----
 tools/perf/ui/tui/progress.c |  7 ++++---
 tools/perf/ui/tui/setup.c    |  3 ++-
 tools/perf/ui/tui/tui.h      |  6 ++++++
 9 files changed, 33 insertions(+), 26 deletions(-)
 create mode 100644 tools/perf/ui/tui/tui.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 326a26e5fc1c..8a9ca3836043 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -487,6 +487,7 @@ ifndef NO_SLANG
   LIB_OBJS += $(OUTPUT)ui/tui/util.o
   LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
   LIB_OBJS += $(OUTPUT)ui/tui/progress.o
+  LIB_H += ui/tui/tui.h
   LIB_H += ui/browser.h
   LIB_H += ui/browsers/map.h
   LIB_H += ui/keysyms.h
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 8576cf194872..0a9173ff9a61 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -34,7 +34,7 @@ struct perf_gtk_context *perf_gtk__activate_context(GtkWidget *window);
 int perf_gtk__deactivate_context(struct perf_gtk_context **ctx);
 
 void perf_gtk__init_helpline(void);
-void perf_gtk__init_progress(void);
+void gtk_ui_progress__init(void);
 void perf_gtk__init_hpp(void);
 
 void perf_gtk__signal(int sig);
diff --git a/tools/perf/ui/gtk/progress.c b/tools/perf/ui/gtk/progress.c
index 482bcf3df9b7..195c7f94f98e 100644
--- a/tools/perf/ui/gtk/progress.c
+++ b/tools/perf/ui/gtk/progress.c
@@ -7,7 +7,7 @@
 static GtkWidget *dialog;
 static GtkWidget *progress;
 
-static void gtk_progress_update(u64 curr, u64 total, const char *title)
+static void gtk_ui_progress__update(u64 curr, u64 total, const char *title)
 {
 	double fraction = total ? 1.0 * curr / total : 0.0;
 	char buf[1024];
@@ -40,7 +40,7 @@ static void gtk_progress_update(u64 curr, u64 total, const char *title)
 		gtk_main_iteration();
 }
 
-static void gtk_progress_finish(void)
+static void gtk_ui_progress__finish(void)
 {
 	/* this will also destroy all of its children */
 	gtk_widget_destroy(dialog);
@@ -48,12 +48,12 @@ static void gtk_progress_finish(void)
 	dialog = NULL;
 }
 
-static struct ui_progress gtk_progress_fns = {
-	.update		= gtk_progress_update,
-	.finish		= gtk_progress_finish,
+static struct ui_progress_ops gtk_ui_progress__ops = {
+	.update		= gtk_ui_progress__update,
+	.finish		= gtk_ui_progress__finish,
 };
 
-void perf_gtk__init_progress(void)
+void gtk_ui_progress__init(void)
 {
-	progress_fns = &gtk_progress_fns;
+	ui_progress__ops = &gtk_ui_progress__ops;
 }
diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
index 6c2dd2e423f3..1d57676f8212 100644
--- a/tools/perf/ui/gtk/setup.c
+++ b/tools/perf/ui/gtk/setup.c
@@ -8,7 +8,7 @@ int perf_gtk__init(void)
 {
 	perf_error__register(&perf_gtk_eops);
 	perf_gtk__init_helpline();
-	perf_gtk__init_progress();
+	gtk_ui_progress__init();
 	perf_gtk__init_hpp();
 
 	return gtk_init_check(NULL, NULL) ? 0 : -1;
diff --git a/tools/perf/ui/progress.c b/tools/perf/ui/progress.c
index 3ec695607a4d..d753821b6e0b 100644
--- a/tools/perf/ui/progress.c
+++ b/tools/perf/ui/progress.c
@@ -1,26 +1,26 @@
 #include "../cache.h"
 #include "progress.h"
 
-static void nop_progress_update(u64 curr __maybe_unused,
-				u64 total __maybe_unused,
-				const char *title __maybe_unused)
+static void null_progress__update(u64 curr __maybe_unused,
+				  u64 total __maybe_unused,
+				  const char *title __maybe_unused)
 {
 }
 
-static struct ui_progress default_progress_fns =
+static struct ui_progress_ops null_progress__ops =
 {
-	.update		= nop_progress_update,
+	.update = null_progress__update,
 };
 
-struct ui_progress *progress_fns = &default_progress_fns;
+struct ui_progress_ops *ui_progress__ops = &null_progress__ops;
 
 void ui_progress__update(u64 curr, u64 total, const char *title)
 {
-	return progress_fns->update(curr, total, title);
+	return ui_progress__ops->update(curr, total, title);
 }
 
 void ui_progress__finish(void)
 {
-	if (progress_fns->finish)
-		progress_fns->finish();
+	if (ui_progress__ops->finish)
+		ui_progress__ops->finish();
 }
diff --git a/tools/perf/ui/progress.h b/tools/perf/ui/progress.h
index 257cc224f9cf..d41bde5908a6 100644
--- a/tools/perf/ui/progress.h
+++ b/tools/perf/ui/progress.h
@@ -3,14 +3,12 @@
 
 #include <../types.h>
 
-struct ui_progress {
+struct ui_progress_ops {
 	void (*update)(u64, u64, const char *);
 	void (*finish)(void);
 };
 
-extern struct ui_progress *progress_fns;
-
-void ui_progress__init(void);
+extern struct ui_progress_ops *ui_progress__ops;
 
 void ui_progress__update(u64 curr, u64 total, const char *title);
 void ui_progress__finish(void);
diff --git a/tools/perf/ui/tui/progress.c b/tools/perf/ui/tui/progress.c
index 6c2184d53cbf..0fcc5a1f525a 100644
--- a/tools/perf/ui/tui/progress.c
+++ b/tools/perf/ui/tui/progress.c
@@ -2,6 +2,7 @@
 #include "../progress.h"
 #include "../libslang.h"
 #include "../ui.h"
+#include "tui.h"
 #include "../browser.h"
 
 static void tui_progress__update(u64 curr, u64 total, const char *title)
@@ -31,12 +32,12 @@ static void tui_progress__update(u64 curr, u64 total, const char *title)
 	pthread_mutex_unlock(&ui__lock);
 }
 
-static struct ui_progress tui_progress_fns =
+static struct ui_progress_ops tui_progress__ops =
 {
 	.update		= tui_progress__update,
 };
 
-void ui_progress__init(void)
+void tui_progress__init(void)
 {
-	progress_fns = &tui_progress_fns;
+	ui_progress__ops = &tui_progress__ops;
 }
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index b9401482d110..2f612562978c 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -9,6 +9,7 @@
 #include "../util.h"
 #include "../libslang.h"
 #include "../keysyms.h"
+#include "tui.h"
 
 static volatile int ui__need_resize;
 
@@ -119,7 +120,7 @@ int ui__init(void)
 
 	ui_helpline__init();
 	ui_browser__init();
-	ui_progress__init();
+	tui_progress__init();
 
 	signal(SIGSEGV, ui__signal);
 	signal(SIGFPE, ui__signal);
diff --git a/tools/perf/ui/tui/tui.h b/tools/perf/ui/tui/tui.h
new file mode 100644
index 000000000000..18961c7b6ec5
--- /dev/null
+++ b/tools/perf/ui/tui/tui.h
@@ -0,0 +1,6 @@
+#ifndef _PERF_TUI_H_
+#define _PERF_TUI_H_ 1
+
+void tui_progress__init(void);
+
+#endif /* _PERF_TUI_H_ */
-- 
1.8.1.4

