Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3LZFiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 00:38:15 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:44611 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3LZFiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 00:38:12 -0500
X-AuditID: 9c93017e-b7cd8ae000002ce9-01-52bbc0c0ed26
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 6/8] perf ui/tui: Implement log window
Date: Thu, 26 Dec 2013 14:38:02 +0900
Message-Id: <1388036284-32342-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1388036284-32342-1-git-send-email-namhyung@kernel.org>
References: <1388036284-32342-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Implement a simple, full-screen log window which shows error messages
saved so far.  Press 'l' (lower-case 'L') key to display the log
window.  It'll be used usually with -v option.

Protect updating log by ui__lock to prevent the linemap reallocation
during log window refresh (it led to a segfault) and add
linemap_changed member to perf_log in order to detect the change.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile.perf       |   1 +
 tools/perf/ui/browser.h        |   1 +
 tools/perf/ui/browsers/hists.c |   5 ++
 tools/perf/ui/browsers/log.c   | 132 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/debug.h        |   1 +
 tools/perf/util/log.c          |   8 ++-
 6 files changed, 147 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/ui/browsers/log.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 49c5c998009e..7cce69b9911a 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -491,6 +491,7 @@ ifndef NO_SLANG
   LIB_OBJS += $(OUTPUT)ui/browsers/map.o
   LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
   LIB_OBJS += $(OUTPUT)ui/browsers/header.o
+  LIB_OBJS += $(OUTPUT)ui/browsers/log.o
   LIB_OBJS += $(OUTPUT)ui/tui/setup.o
   LIB_OBJS += $(OUTPUT)ui/tui/util.o
   LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 118cca29dd26..1f676c8ec4f3 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -61,6 +61,7 @@ int ui_browser__input_window(const char *title, const char *text, char *input,
 			     const char *exit_msg, int delay_sec);
 struct perf_session_env;
 int tui__header_window(struct perf_session_env *env);
+int tui__log_window(void);
 
 void ui_browser__argv_seek(struct ui_browser *browser, off_t offset, int whence);
 unsigned int ui_browser__argv_refresh(struct ui_browser *browser);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 0d9dd99507ee..828b0113a213 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1418,6 +1418,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	/* help messages are sorted by lexical order of the hotkey */
 	const char report_help[] = HIST_BROWSER_HELP_COMMON
 	"i             Show header information\n"
+	"l             Show log messages\n"
 	"P             Print histograms to perf.hist.N\n"
 	"r             Run available scripts\n"
 	"s             Switch to another data file in PWD\n"
@@ -1425,6 +1426,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	"V             Verbose (DSO names in callchains, etc)\n"
 	"/             Filter symbol by name";
 	const char top_help[] = HIST_BROWSER_HELP_COMMON
+	"l             Show log messages\n"
 	"P             Print histograms to perf.hist.N\n"
 	"t             Zoom into current Thread\n"
 	"V             Verbose (DSO names in callchains, etc)\n"
@@ -1519,6 +1521,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			if (env->arch)
 				tui__header_window(env);
 			continue;
+		case 'l':
+			tui__log_window();
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
diff --git a/tools/perf/ui/browsers/log.c b/tools/perf/ui/browsers/log.c
new file mode 100644
index 000000000000..c64aeb8f9aac
--- /dev/null
+++ b/tools/perf/ui/browsers/log.c
@@ -0,0 +1,132 @@
+#include <stdio.h>
+
+#include "perf.h"
+#include "util/util.h"
+#include "util/cache.h"
+#include "util/debug.h"
+#include "ui/ui.h"
+#include "ui/util.h"
+#include "ui/browser.h"
+#include "ui/libslang.h"
+#include "ui/keysyms.h"
+
+static void ui_browser__file_seek(struct ui_browser *browser __maybe_unused,
+				  off_t offset __maybe_unused,
+				  int whence __maybe_unused)
+{
+	/* do nothing */
+}
+
+static void ui_browser__file_write(struct ui_browser *browser,
+				   void *entry, int row)
+{
+	char buf[1024];
+	char empty[] = " ";
+	FILE *fp = perf_log.fp;
+	bool current_entry = ui_browser__is_current_entry(browser, row);
+	off_t *linemap = perf_log.linemap;
+	unsigned int idx = *(unsigned int *)entry;
+	unsigned long offset = (unsigned long)browser->priv;
+
+	fseek(fp, linemap[idx], SEEK_SET);
+	if (fgets(buf, sizeof(buf), fp) == NULL)
+		return;
+
+	ui_browser__set_color(browser, current_entry ? HE_COLORSET_SELECTED :
+						       HE_COLORSET_NORMAL);
+
+	if (offset < strlen(buf))
+		slsmg_write_nstring(&buf[offset], browser->width);
+	else
+		slsmg_write_nstring(empty, browser->width);
+}
+
+static unsigned int ui_browser__file_refresh(struct ui_browser *browser)
+{
+	unsigned int row = 0;
+	unsigned int idx = browser->top_idx;
+	fpos_t pos;
+
+	fgetpos(perf_log.fp, &pos);
+
+	if (perf_log.linemap_changed) {
+		/* update log window with new linemap */
+		browser->entries = perf_log.linemap;
+		browser->nr_entries = perf_log.lines;
+		perf_log.linemap_changed = false;
+	}
+
+	while (idx < browser->nr_entries) {
+		ui_browser__gotorc(browser, row, 0);
+		browser->write(browser, &idx, row);
+		if (++row == browser->height)
+			break;
+
+		++idx;
+	}
+
+	fsetpos(perf_log.fp, &pos);
+	return row;
+}
+
+static int log_menu__run(struct ui_browser *menu)
+{
+	int key;
+	unsigned long offset;
+	const char help[] =
+	"h/?/F1        Show this window\n"
+	"UP/DOWN/PGUP\n"
+	"PGDN/SPACE\n"
+	"LEFT/RIGHT    Navigate\n"
+	"q/ESC/CTRL+C  Exit browser";
+
+	if (ui_browser__show(menu, "Log messages", "Press 'q' to exit") < 0)
+		return -1;
+
+	while (1) {
+		key = ui_browser__run(menu, 0);
+
+		switch (key) {
+		case K_RIGHT:
+			offset = (unsigned long)menu->priv;
+			offset += 10;
+			menu->priv = (void *)offset;
+			continue;
+		case K_LEFT:
+			offset = (unsigned long)menu->priv;
+			if (offset >= 10)
+				offset -= 10;
+			menu->priv = (void *)offset;
+			continue;
+		case K_F1:
+		case 'h':
+		case '?':
+			ui_browser__help_window(menu, help);
+			continue;
+		case K_ESC:
+		case 'q':
+		case CTRL('c'):
+			key = -1;
+			break;
+		default:
+			continue;
+		}
+
+		break;
+	}
+
+	ui_browser__hide(menu);
+	return key;
+}
+
+int tui__log_window(void)
+{
+	struct ui_browser log_menu = {
+		.refresh    = ui_browser__file_refresh,
+		.seek	    = ui_browser__file_seek,
+		.write	    = ui_browser__file_write,
+		.nr_entries = perf_log.lines,
+	};
+
+	return log_menu__run(&log_menu);
+}
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index ea160abc2ae0..bc3affed682e 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -25,6 +25,7 @@ struct perf_log {
 	u32 lines;
 	u32 nr_alloc;
 	bool seen_newline;
+	bool linemap_changed;
 };
 
 extern struct perf_log perf_log;
diff --git a/tools/perf/util/log.c b/tools/perf/util/log.c
index 3838d49f82de..aee71da25a24 100644
--- a/tools/perf/util/log.c
+++ b/tools/perf/util/log.c
@@ -89,11 +89,17 @@ static void add_to_linemap(struct perf_log *log, const char *msg, off_t base)
 void perf_log_add(const char *msg)
 {
 	FILE *fp = perf_log.fp;
-	off_t offset = ftello(fp);
+	off_t offset;
+
+	pthread_mutex_lock(&ui__lock);
+	offset = ftello(fp);
 
 	add_to_linemap(&perf_log, msg, offset);
 
 	fwrite(msg, 1, strlen(msg), fp);
+
+	perf_log.linemap_changed = true;
+	pthread_mutex_unlock(&ui__lock);
 }
 
 void perf_log_addv(const char *fmt, va_list ap)
-- 
1.7.11.7

