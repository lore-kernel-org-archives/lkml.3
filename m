Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab3BGJCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 04:02:41 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45999 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab3BGJCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 04:02:32 -0500
X-AuditID: 9c930179-b7c24ae00000119c-c4-51136da2a6a7
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/7] perf gtk/annotate: Show source lines with gray color
Date: Thu,  7 Feb 2013 18:02:10 +0900
Message-Id: <1360227734-375-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1360227734-375-1-git-send-email-namhyung@kernel.org>
References: <1360227734-375-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

In order to differentiate source lines from asm line, print them with
gray color.  To do this, it needs to be escaped since sometimes it
contains "<" and/or ">" characters so that it should not be considered
as a markup tags.  Use glib's g_markup_escape_text() for this.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/annotate.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
index 1ce89f2558fa..2fe056b0096c 100644
--- a/tools/perf/ui/gtk/annotate.c
+++ b/tools/perf/ui/gtk/annotate.c
@@ -60,6 +60,30 @@ static int perf_gtk__get_offset(char *buf, size_t size, struct symbol *sym,
 	return scnprintf(buf, size, "%"PRIx64, start + dl->offset);
 }
 
+static int perf_gtk__get_line(char *buf, size_t size, struct disasm_line *dl)
+{
+	int ret = 0;
+	char *line = g_markup_escape_text(dl->line, -1);
+	const char *markup = "<span fgcolor='gray'>";
+
+	strcpy(buf, "");
+
+	if (!line)
+		return 0;
+
+	if (dl->offset != (s64) -1)
+		markup = NULL;
+
+	if (markup)
+		ret += scnprintf(buf, size, "%s", markup);
+	ret += scnprintf(buf + ret, size - ret, "%s", line);
+	if (markup)
+		ret += scnprintf(buf + ret, size - ret, "</span>");
+
+	g_free(line);
+	return ret;
+}
+
 static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
 				struct map *map, int evidx,
 				struct hist_browser_timer *hbt __maybe_unused)
@@ -93,8 +117,7 @@ static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
 
 	for (i = 0; i < MAX_ANN_COLS; i++) {
 		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
-					-1, col_names[i], renderer,
-					i == ANN_COL__PERCENT ? "markup" : "text",
+					-1, col_names[i], renderer, "markup",
 					i, NULL);
 	}
 
@@ -110,7 +133,8 @@ static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
 			gtk_list_store_set(store, &iter, ANN_COL__PERCENT, s, -1);
 		if (perf_gtk__get_offset(s, sizeof(s), sym, map, pos))
 			gtk_list_store_set(store, &iter, ANN_COL__OFFSET, s, -1);
-		gtk_list_store_set(store, &iter, ANN_COL__LINE, pos->line, -1);
+		if (perf_gtk__get_line(s, sizeof(s), pos))
+			gtk_list_store_set(store, &iter, ANN_COL__LINE, s, -1);
 	}
 
 	gtk_container_add(GTK_CONTAINER(window), view);
-- 
1.7.11.7

