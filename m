Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3LSHAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:00:31 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:47179 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3LSHAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:00:18 -0500
X-AuditID: 9c930179-b7bedae000000f15-7d-52b2997e8a6e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 6/6] perf ui/tui: Implement header window
Date: Thu, 19 Dec 2013 16:00:11 +0900
Message-Id: <1387436411-20160-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Implement a simple, full-screen header window which shows session
header (metadata) information.  Press 'i' key to display the header
window.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile.perf        |   1 +
 tools/perf/ui/browser.h         |   2 +
 tools/perf/ui/browsers/header.c | 116 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/ui/browsers/hists.c  |   4 ++
 4 files changed, 123 insertions(+)
 create mode 100644 tools/perf/ui/browsers/header.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 30aabace33a0..4d046e97d0e7 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -491,6 +491,7 @@ ifndef NO_SLANG
   LIB_OBJS += $(OUTPUT)ui/browsers/map.o
   LIB_OBJS += $(OUTPUT)ui/browsers/scripts.o
   LIB_OBJS += $(OUTPUT)ui/browsers/log.o
+  LIB_OBJS += $(OUTPUT)ui/browsers/header.o
   LIB_OBJS += $(OUTPUT)ui/tui/setup.o
   LIB_OBJS += $(OUTPUT)ui/tui/util.o
   LIB_OBJS += $(OUTPUT)ui/tui/helpline.o
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index fff46942a8c7..b77d8728b3f0 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -60,6 +60,8 @@ bool ui_browser__dialog_yesno(struct ui_browser *browser, const char *text);
 int ui_browser__input_window(const char *title, const char *text, char *input,
 			     const char *exit_msg, int delay_sec);
 int tui__log_window(void);
+struct perf_session_env;
+int tui__header_window(struct perf_session_env *env);
 
 void ui_browser__argv_seek(struct ui_browser *browser, off_t offset, int whence);
 unsigned int ui_browser__argv_refresh(struct ui_browser *browser);
diff --git a/tools/perf/ui/browsers/header.c b/tools/perf/ui/browsers/header.c
new file mode 100644
index 000000000000..b5f0961bf793
--- /dev/null
+++ b/tools/perf/ui/browsers/header.c
@@ -0,0 +1,116 @@
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
index 8cc6f5eaa2cf..d710c6403a14 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1487,6 +1487,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		case 'l':
 			tui__log_window();
 			continue;
+		case 'i':
+			tui__header_window(env);
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
@@ -1510,6 +1513,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"P             Print histograms to perf.hist.N\n"
 					"V             Verbose (DSO names in callchains, etc)\n"
 					"l             Show log messages\n"
+					"i             Show header information\n"
 					"/             Filter symbol by name");
 			continue;
 		case K_ENTER:
-- 
1.7.11.7

