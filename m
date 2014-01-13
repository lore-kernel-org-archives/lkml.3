Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaAMIBM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:01:12 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56271 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbaAMIBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:01:02 -0500
X-AuditID: 9c930179-b7c5fae000006619-5f-52d39d3b38f7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 5/5] perf ui/tui: Remember last log line for filtering
Date: Mon, 13 Jan 2014 17:00:57 +0900
Message-Id: <1389600057-26999-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389600057-26999-1-git-send-email-namhyung@kernel.org>
References: <1389600057-26999-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When updating log window with filter string, no need to search all
logs everytime.  Just save the last offset and update from there.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/log.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/tools/perf/ui/browsers/log.c b/tools/perf/ui/browsers/log.c
index 62343e0578bb..828b98522a48 100644
--- a/tools/perf/ui/browsers/log.c
+++ b/tools/perf/ui/browsers/log.c
@@ -13,10 +13,11 @@
 struct log_browser_data {
 	unsigned long offset;
 	u32 alloc;
+	u32 last_log_line;
 	char filter[64];
 };
 
-static void __log_menu__filter(struct ui_browser *menu, char *filter);
+static void __log_menu__filter(struct ui_browser *menu, char *filter, bool update);
 
 static void ui_browser__file_seek(struct ui_browser *browser __maybe_unused,
 				  off_t offset __maybe_unused,
@@ -61,7 +62,7 @@ static unsigned int ui_browser__file_refresh(struct ui_browser *browser)
 
 	if (perf_log.linemap_changed) {
 		/* update log window with new linemap */
-		__log_menu__filter(browser, lbd->filter);
+		__log_menu__filter(browser, lbd->filter, true);
 		perf_log.linemap_changed = false;
 	}
 
@@ -78,14 +79,15 @@ static unsigned int ui_browser__file_refresh(struct ui_browser *browser)
 	return row;
 }
 
-static void __log_menu__filter(struct ui_browser *menu, char *filter)
+static void __log_menu__filter(struct ui_browser *menu, char *filter, bool update)
 {
 	char buf[1024];
 	struct log_browser_data *lbd = menu->priv;
 	off_t *linemap = NULL;
 	u32 lines = 0;
 	u32 alloc = 0;
-	u32 i;
+	u32 last = 0;
+	u32 i = 0;
 
 	if (*filter == '\0') {
 		linemap = perf_log.linemap;
@@ -93,7 +95,14 @@ static void __log_menu__filter(struct ui_browser *menu, char *filter)
 		goto out;
 	}
 
-	for (i = 0; i < perf_log.lines; i++) {
+	if (update) {
+		linemap = menu->entries;
+		lines = menu->nr_entries;
+		alloc = lbd->alloc;
+		last = lbd->last_log_line;
+	}
+
+	for (i = last; i < perf_log.lines; i++) {
 		fseek(perf_log.fp, perf_log.linemap[i], SEEK_SET);
 		if (fgets(buf, sizeof(buf), perf_log.fp) == NULL)
 			goto error;
@@ -116,11 +125,16 @@ static void __log_menu__filter(struct ui_browser *menu, char *filter)
 	}
 
 out:
-	if (lbd->alloc) {
+	if (!update && lbd->alloc) {
 		BUG_ON(menu->entries == perf_log.linemap);
 		free(menu->entries);
 	}
+
 	lbd->alloc = alloc;
+	lbd->last_log_line = i;
+
+	if (!update)
+		ui_browser__reset_index(menu);
 
 	menu->entries = linemap;
 	ui_browser__update_nr_entries(menu, lines);
@@ -136,7 +150,7 @@ static void log_menu__filter(struct ui_browser *menu, char *filter)
 
 	pthread_mutex_lock(&ui__lock);
 	fgetpos(perf_log.fp, &pos);
-	__log_menu__filter(menu, filter);
+	__log_menu__filter(menu, filter, false);
 	fsetpos(perf_log.fp, &pos);
 	perf_log.linemap_changed = false;
 	pthread_mutex_unlock(&ui__lock);
-- 
1.7.11.7

