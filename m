Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3BOQgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:36:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35895 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3BOQgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:36:16 -0500
Date: Fri, 15 Feb 2013 08:34:39 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-237522378604a2e26e19a8b11a70171eaf98c6c5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        bp@alien8.de, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, bp@alien8.de, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1360227734-375-4-git-send-email-namhyung@kernel.org>
References: <1360227734-375-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf gtk/annotate:
  Show source lines with gray color
Git-Commit-ID: 237522378604a2e26e19a8b11a70171eaf98c6c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 15 Feb 2013 08:34:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  237522378604a2e26e19a8b11a70171eaf98c6c5
Gitweb:     http://git.kernel.org/tip/237522378604a2e26e19a8b11a70171eaf98c6c5
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 7 Feb 2013 18:02:10 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Feb 2013 14:59:28 -0300

perf gtk/annotate: Show source lines with gray color

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
