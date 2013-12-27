Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab3L0Uu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 15:50:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35704 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826Ab3L0UrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 15:47:23 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 46/49] perf ui/tui: Implement header window
Date: Fri, 27 Dec 2013 17:47:02 -0300
Message-Id: <1388177225-17349-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1388177225-17349-1-git-send-email-acme@infradead.org>
References: <1388177225-17349-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Implement a simple, full-screen header window which shows session header
(metadata) information.  Press 'i' key to display the header window.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1388036284-32342-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf        |   1 +
 tools/perf/ui/browser.h         |   2 +
 tools/perf/ui/browsers/header.c | 127 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/ui/browsers/hists.c  |   6 ++
 4 files changed, 136 insertions(+)
 create mode 100644 tools/perf/ui/browsers/header.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 97a2145e4cc6..3638b0bd20dc 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -489,6 +489,7 @@ ifndef NO_SLANG
   LIB_OBJS += $(OUTPUT)ui/browsers/hists.o
   LIB_OBJS += $(OUTPUT)ui/browsers/map.o
   LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
+  LIB_OBJS += $(OUTPUT)ui/browsers/header.o
   LIB_OBJS += $(OUTPUT)ui/tui/setup.o
   LIB_OBJS += $(OUTPUT)ui/tui/util.o
   LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 7d45d2f53601..118cca29dd26 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -59,6 +59,8 @@ int ui_browser__help_window(struct ui_browser *browser, const char *text);
 bool ui_browser__dialog_yesno(struct ui_browser *browser, const char *text);
 int ui_browser__input_window(const char *title, const char *text, char *input,
 			     const char *exit_msg, int delay_sec);
+struct perf_session_env;
+int tui__header_window(struct perf_session_env *env);
 
 void ui_browser__argv_seek(struct ui_browser *browser, off_t offset, int whence);
 unsigned int ui_browser__argv_refresh(struct ui_browser *browser);
diff --git a/tools/perf/ui/browsers/header.c b/tools/perf/ui/browsers/header.c
new file mode 100644
index 000000000000..89c16b988618
--- /dev/null
+++ b/tools/perf/ui/browsers/header.c
@@ -0,0 +1,127 @@
+#include "util/cache.h"
+#include "util/debug.h"
+#include "ui/browser.h"
+#include "ui/ui.h"
+#include "ui/util.h"
+#include "ui/libslang.h"
+#include "util/header.h"
+#include "util/session.h"
+
+static void ui_browser__argv_write(struct ui_browser *browser,
+				   void *entry, int row)
+{
+	char **arg = entry;
+	char *str = *arg;
+	char empty[] = " ";
+	bool current_entry = ui_browser__is_current_entry(browser, row);
+	unsigned long offset = (unsigned long)browser->priv;
+
+	if (offset >= strlen(str))
+		str = empty;
+	else
+		str = str + offset;
+
+	ui_browser__set_color(browser, current_entry ? HE_COLORSET_SELECTED :
+						       HE_COLORSET_NORMAL);
+
+	slsmg_write_nstring(str, browser->width);
+}
+
+static int list_menu__run(struct ui_browser *menu)
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
+	if (ui_browser__show(menu, "Header information", "Press 'q' to exit") < 0)
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
+static int ui__list_menu(int argc, char * const argv[])
+{
+	struct ui_browser menu = {
+		.entries    = (void *)argv,
+		.refresh    = ui_browser__argv_refresh,
+		.seek	    = ui_browser__argv_seek,
+		.write	    = ui_browser__argv_write,
+		.nr_entries = argc,
+	};
+
+	return list_menu__run(&menu);
+}
+
+int tui__header_window(struct perf_session_env *env)
+{
+	int i, argc = 0;
+	char **argv;
+	struct perf_session *session;
+	char *ptr, *pos;
+	size_t size;
+	FILE *fp = open_memstream(&ptr, &size);
+
+	session = container_of(env, struct perf_session, header.env);
+	perf_header__fprintf_info(session, fp, true);
+	fclose(fp);
+
+	for (pos = ptr, argc = 0; (pos = strchr(pos, '\n')) != NULL; pos++)
+		argc++;
+
+	argv = calloc(argc + 1, sizeof(*argv));
+	if (argv == NULL)
+		goto out;
+
+	argv[0] = pos = ptr;
+	for (i = 1; (pos = strchr(pos, '\n')) != NULL; i++) {
+		*pos++ = '\0';
+		argv[i] = pos;
+	}
+
+	BUG_ON(i != argc + 1);
+
+	ui__list_menu(argc, argv);
+
+out:
+	free(argv);
+	free(ptr);
+	return 0;
+}
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index d43ec79ea4e3..0d9dd99507ee 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1417,6 +1417,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 	/* help messages are sorted by lexical order of the hotkey */
 	const char report_help[] = HIST_BROWSER_HELP_COMMON
+	"i             Show header information\n"
 	"P             Print histograms to perf.hist.N\n"
 	"r             Run available scripts\n"
 	"s             Switch to another data file in PWD\n"
@@ -1513,6 +1514,11 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			if (is_report_browser(hbt))
 				goto do_data_switch;
 			continue;
+		case 'i':
+			/* env->arch is NULL for live-mode (i.e. perf top) */
+			if (env->arch)
+				tui__header_window(env);
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
-- 
1.8.1.4

