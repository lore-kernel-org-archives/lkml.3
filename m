Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935043Ab3BNVo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 16:44:56 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46995
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030256Ab3BNVos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 16:44:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/10] perf gtk/annotate: Show source lines with gray color
Date: Thu, 14 Feb 2013 18:44:18 -0300
Message-Id: <1360878263-12694-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1360878263-12694-1-git-send-email-acme@infradead.org>
References: <1360878263-12694-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

In order to differentiate source lines from asm line, print them with
gray color.  To do this, it needs to be escaped since sometimes it
contains "<" and/or ">" characters so that it should not be considered
as a markup tags.  Use glib's g_markup_escape_text() for this.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360227734-375-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/annotate.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
index 1ce89f2..2fe056b 100644
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
1.8.1.1.361.gec3ae6e

