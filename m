Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaAMIBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:01:14 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56271 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaAMIBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:01:01 -0500
X-AuditID: 9c930179-b7c5fae000006619-59-52d39d3a6b46
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 4/5] perf ui/tui: Filter messages in log window
Date: Mon, 13 Jan 2014 17:00:56 +0900
Message-Id: <1389600057-26999-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389600057-26999-1-git-send-email-namhyung@kernel.org>
References: <1389600057-26999-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Press '/' key to input filter string like main hist browser does.

Requested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/log.c | 117 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 103 insertions(+), 14 deletions(-)

diff --git a/tools/perf/ui/browsers/log.c b/tools/perf/ui/browsers/log.c
index c64aeb8f9aac..62343e0578bb 100644
--- a/tools/perf/ui/browsers/log.c
+++ b/tools/perf/ui/browsers/log.c
@@ -10,6 +10,14 @@
 #include "ui/libslang.h"
 #include "ui/keysyms.h"
 
+struct log_browser_data {
+	unsigned long offset;
+	u32 alloc;
+	char filter[64];
+};
+
+static void __log_menu__filter(struct ui_browser *menu, char *filter);
+
 static void ui_browser__file_seek(struct ui_browser *browser __maybe_unused,
 				  off_t offset __maybe_unused,
 				  int whence __maybe_unused)
@@ -23,10 +31,11 @@ static void ui_browser__file_write(struct ui_browser *browser,
 	char buf[1024];
 	char empty[] = " ";
 	FILE *fp = perf_log.fp;
+	struct log_browser_data *lbd = browser->priv;
 	bool current_entry = ui_browser__is_current_entry(browser, row);
-	off_t *linemap = perf_log.linemap;
+	off_t *linemap = browser->entries;
 	unsigned int idx = *(unsigned int *)entry;
-	unsigned long offset = (unsigned long)browser->priv;
+	unsigned long offset = lbd->offset;
 
 	fseek(fp, linemap[idx], SEEK_SET);
 	if (fgets(buf, sizeof(buf), fp) == NULL)
@@ -45,14 +54,14 @@ static unsigned int ui_browser__file_refresh(struct ui_browser *browser)
 {
 	unsigned int row = 0;
 	unsigned int idx = browser->top_idx;
+	struct log_browser_data *lbd = browser->priv;
 	fpos_t pos;
 
 	fgetpos(perf_log.fp, &pos);
 
 	if (perf_log.linemap_changed) {
 		/* update log window with new linemap */
-		browser->entries = perf_log.linemap;
-		browser->nr_entries = perf_log.lines;
+		__log_menu__filter(browser, lbd->filter);
 		perf_log.linemap_changed = false;
 	}
 
@@ -69,16 +78,81 @@ static unsigned int ui_browser__file_refresh(struct ui_browser *browser)
 	return row;
 }
 
+static void __log_menu__filter(struct ui_browser *menu, char *filter)
+{
+	char buf[1024];
+	struct log_browser_data *lbd = menu->priv;
+	off_t *linemap = NULL;
+	u32 lines = 0;
+	u32 alloc = 0;
+	u32 i;
+
+	if (*filter == '\0') {
+		linemap = perf_log.linemap;
+		lines = perf_log.lines;
+		goto out;
+	}
+
+	for (i = 0; i < perf_log.lines; i++) {
+		fseek(perf_log.fp, perf_log.linemap[i], SEEK_SET);
+		if (fgets(buf, sizeof(buf), perf_log.fp) == NULL)
+			goto error;
+
+		if (strstr(buf, filter) == NULL)
+			continue;
+
+		if (lines == alloc) {
+			off_t *map;
+
+			map = realloc(linemap, (alloc + 128) * sizeof(*map));
+			if (map == NULL)
+				goto error;
+
+			linemap = map;
+			alloc += 128;
+		}
+
+		linemap[lines++] = perf_log.linemap[i];
+	}
+
+out:
+	if (lbd->alloc) {
+		BUG_ON(menu->entries == perf_log.linemap);
+		free(menu->entries);
+	}
+	lbd->alloc = alloc;
+
+	menu->entries = linemap;
+	ui_browser__update_nr_entries(menu, lines);
+	return;
+
+error:
+	free(linemap);
+}
+
+static void log_menu__filter(struct ui_browser *menu, char *filter)
+{
+	fpos_t pos;
+
+	pthread_mutex_lock(&ui__lock);
+	fgetpos(perf_log.fp, &pos);
+	__log_menu__filter(menu, filter);
+	fsetpos(perf_log.fp, &pos);
+	perf_log.linemap_changed = false;
+	pthread_mutex_unlock(&ui__lock);
+}
+
 static int log_menu__run(struct ui_browser *menu)
 {
 	int key;
-	unsigned long offset;
+	struct log_browser_data *lbd = menu->priv;
 	const char help[] =
 	"h/?/F1        Show this window\n"
 	"UP/DOWN/PGUP\n"
 	"PGDN/SPACE\n"
 	"LEFT/RIGHT    Navigate\n"
-	"q/ESC/CTRL+C  Exit browser";
+	"q/ESC/CTRL+C  Exit browser\n\n"
+	"/             Filter log message";
 
 	if (ui_browser__show(menu, "Log messages", "Press 'q' to exit") < 0)
 		return -1;
@@ -88,21 +162,25 @@ static int log_menu__run(struct ui_browser *menu)
 
 		switch (key) {
 		case K_RIGHT:
-			offset = (unsigned long)menu->priv;
-			offset += 10;
-			menu->priv = (void *)offset;
+			lbd->offset += 10;
 			continue;
 		case K_LEFT:
-			offset = (unsigned long)menu->priv;
-			if (offset >= 10)
-				offset -= 10;
-			menu->priv = (void *)offset;
+			if (lbd->offset >= 10)
+				lbd->offset -= 10;
 			continue;
 		case K_F1:
 		case 'h':
 		case '?':
 			ui_browser__help_window(menu, help);
 			continue;
+		case '/':
+			if (ui_browser__input_window("Symbol to filter",
+					"Please enter the name of symbol you want to see",
+					lbd->filter, "ENTER: OK, ESC: Cancel",
+					0) == K_ENTER) {
+				log_menu__filter(menu, lbd->filter);
+			}
+			continue;
 		case K_ESC:
 		case 'q':
 		case CTRL('c'):
@@ -121,12 +199,23 @@ static int log_menu__run(struct ui_browser *menu)
 
 int tui__log_window(void)
 {
+	struct log_browser_data lbd = {
+		.filter	    = "",
+	};
 	struct ui_browser log_menu = {
 		.refresh    = ui_browser__file_refresh,
 		.seek	    = ui_browser__file_seek,
 		.write	    = ui_browser__file_write,
+		.entries    = perf_log.linemap,
 		.nr_entries = perf_log.lines,
+		.priv	    = &lbd,
 	};
+	int key;
+
+	key = log_menu__run(&log_menu);
 
-	return log_menu__run(&log_menu);
+	if (lbd.alloc)
+		free(log_menu.entries);
+
+	return key;
 }
-- 
1.7.11.7

