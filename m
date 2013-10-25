Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3JYKd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:33:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52490 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3JYKdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:33:53 -0400
Date: Fri, 25 Oct 2013 03:33:10 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-zjqbfp9gx3yo45s0rp9uv42n@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui: Rename ui_progress to ui_progress_ops
Git-Commit-ID: 4779a2e99af80e133ee1c70c7093dc6cc13429a1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 25 Oct 2013 03:33:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4779a2e99af80e133ee1c70c7093dc6cc13429a1
Gitweb:     http://git.kernel.org/tip/4779a2e99af80e133ee1c70c7093dc6cc13429a1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 23 Oct 2013 14:08:48 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Oct 2013 14:41:23 -0300

perf ui: Rename ui_progress to ui_progress_ops

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

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 326a26e..8a9ca38 100644
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
index 8576cf1..0a9173f 100644
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
index 482bcf3..195c7f9 100644
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
index 6c2dd2e..1d57676 100644
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
index 3ec69560..d753821 100644
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
index 257cc22..d41bde5 100644
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
index 6c2184d..0fcc5a1 100644
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
index b940148..2f61256 100644
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
index 0000000..18961c7
--- /dev/null
+++ b/tools/perf/ui/tui/tui.h
@@ -0,0 +1,6 @@
+#ifndef _PERF_TUI_H_
+#define _PERF_TUI_H_ 1
+
+void tui_progress__init(void);
+
+#endif /* _PERF_TUI_H_ */
