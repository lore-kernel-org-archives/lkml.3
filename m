Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3LTFL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:11:29 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50330 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3LTFLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 00:11:25 -0500
X-AuditID: 9c93016f-b7cc5ae000007121-4b-52b3d1792604
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 5/7] perf ui/tui: Implement log window
Date: Fri, 20 Dec 2013 14:11:16 +0900
Message-Id: <1387516278-17024-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
References: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Implement a simple, full-screen log window which shows error messages
saved so far.  Press 'l' (lower-case 'L') key to display the log
window.  It'll be used usually with -v option.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile.perf       |   1 +
 tools/perf/ui/browser.h        |   1 +
 tools/perf/ui/browsers/hists.c |   4 ++
 tools/perf/ui/browsers/log.c   | 111 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 117 insertions(+)
 create mode 100644 tools/perf/ui/browsers/log.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index ec8184014a76..30aabace33a0 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -490,6 +490,7 @@ ifndef NO_SLANG
   LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
   LIB_OBJS += $(OUTPUT)ui/browsers/map.o
   LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
+  LIB_OBJS += $(OUTPUT)ui/browsers/log.o
   LIB_OBJS += $(OUTPUT)ui/tui/setup.o
   LIB_OBJS += $(OUTPUT)ui/tui/util.o
   LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 7d45d2f53601..fff46942a8c7 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -59,6 +59,7 @@ int ui_browser__help_window(struct ui_browser *browser, const char *text);
 bool ui_browser__dialog_yesno(struct ui_browser *browser, const char *text);
 int ui_browser__input_window(const char *title, const char *text, char *input,
 			     const char *exit_msg, int delay_sec);
+int tui__log_window(void);
 
 void ui_browser__argv_seek(struct ui_browser *browser, off_t offset, int whence);
 unsigned int ui_browser__argv_refresh(struct ui_browser *browser);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index a440e03cd8c2..8cc6f5eaa2cf 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1484,6 +1484,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			if (is_report_browser(hbt))
 				goto do_data_switch;
 			continue;
+		case 'l':
+			tui__log_window();
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
@@ -1506,6 +1509,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"s             Switch to another data file in PWD ('perf report' only)\n"
 					"P             Print histograms to perf.hist.N\n"
 					"V             Verbose (DSO names in callchains, etc)\n"
+					"l             Show log messages\n"
 					"/             Filter symbol by name");
 			continue;
 		case K_ENTER:
diff --git a/tools/perf/ui/browsers/log.c b/tools/perf/ui/browsers/log.c
new file mode 100644
index 000000000000..592e2774e919
--- /dev/null
+++ b/tools/perf/ui/browsers/log.c
@@ -0,0 +1,111 @@
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
+#include "ui/tui/tui.h"
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
+	return row;
+}
+
+static int log_menu__run(struct ui_browser *menu)
+{
+	int key;
+	unsigned long offset;
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
-- 
1.7.11.7

