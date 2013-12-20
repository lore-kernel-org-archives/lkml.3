Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab3LTFMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:12:41 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50330 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab3LTFL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 00:11:27 -0500
X-AuditID: 9c93016f-b7cc5ae000007121-55-52b3d1797b98
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 7/7] perf ui/tui: Filter messages in log window
Date: Fri, 20 Dec 2013 14:11:18 +0900
Message-Id: <1387516278-17024-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
References: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Press '/' key to input filter string like main hist browser does.

Requested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/log.c | 62 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/log.c b/tools/perf/ui/browsers/log.c
index 592e2774e919..84b708073441 100644
--- a/tools/perf/ui/browsers/log.c
+++ b/tools/perf/ui/browsers/log.c
@@ -25,7 +25,7 @@ static void ui_browser__file_write(struct ui_browser *browser,
 	char empty[] = " ";
 	FILE *fp = perf_log.fp;
 	bool current_entry = ui_browser__is_current_entry(browser, row);
-	off_t *linemap = perf_log.linemap;
+	off_t *linemap = browser->entries;
 	unsigned int idx = *(unsigned int *)entry;
 	unsigned long offset = (unsigned long)browser->priv;
 
@@ -59,9 +59,60 @@ static unsigned int ui_browser__file_refresh(struct ui_browser *browser)
 	return row;
 }
 
+static void log_menu__filter(struct ui_browser *menu, char *filter)
+{
+	char buf[1024];
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
+	if (menu->entries != perf_log.linemap)
+		free(menu->entries);
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
+			map = realloc(linemap, (alloc + 128) * sizeof(*linemap));
+			if (map == NULL)
+				goto error;
+
+			linemap = map;
+			alloc += 128;
+		}
+
+		linemap[lines++] = perf_log.linemap[i];
+	}
+out:
+	menu->entries = linemap;
+	menu->nr_entries = lines;
+
+	menu->top_idx = 0;
+	menu->index = 0;
+	return;
+
+error:
+	free(linemap);
+}
+
 static int log_menu__run(struct ui_browser *menu)
 {
 	int key;
+	char buf[64];
 	unsigned long offset;
 
 	if (ui_browser__show(menu, "Log messages", "Press 'q' to exit") < 0)
@@ -82,6 +133,14 @@ static int log_menu__run(struct ui_browser *menu)
 				offset -= 10;
 			menu->priv = (void *)offset;
 			continue;
+		case '/':
+			if (ui_browser__input_window("Symbol to show",
+					"Please enter the name of symbol you want to see",
+					buf, "ENTER: OK, ESC: Cancel",
+					0) == K_ENTER) {
+				log_menu__filter(menu, buf);
+			}
+			continue;
 		case K_ESC:
 		case 'q':
 		case CTRL('c'):
@@ -104,6 +163,7 @@ int tui__log_window(void)
 		.refresh    = ui_browser__file_refresh,
 		.seek	    = ui_browser__file_seek,
 		.write	    = ui_browser__file_write,
+		.entries    = perf_log.linemap,
 		.nr_entries = perf_log.lines,
 	};
 
-- 
1.7.11.7

