Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678Ab3CEFyC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:54:02 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53847 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab3CEFxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:53:54 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-31-5135886e7f01
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 12/12] perf annotate/gtk: Support event group view on GTK
Date: Tue,  5 Mar 2013 14:53:32 +0900
Message-Id: <1362462812-30885-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add support for event group view to GTK annotation browser.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/annotate.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
index 6e2fc7e3f093..f538794615db 100644
--- a/tools/perf/ui/gtk/annotate.c
+++ b/tools/perf/ui/gtk/annotate.c
@@ -33,7 +33,7 @@ static int perf_gtk__get_percent(char *buf, size_t size, struct symbol *sym,
 		return 0;
 
 	symhist = annotation__histogram(symbol__annotation(sym), evidx);
-	if (!symhist->addr[dl->offset])
+	if (!symbol_conf.event_group && !symhist->addr[dl->offset])
 		return 0;
 
 	percent = 100.0 * symhist->addr[dl->offset] / symhist->sum;
@@ -119,10 +119,24 @@ static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		GtkTreeIter iter;
+		int ret = 0;
 
 		gtk_list_store_append(store, &iter);
 
-		if (perf_gtk__get_percent(s, sizeof(s), sym, pos, evsel->idx))
+		if (perf_evsel__is_group_event(evsel)) {
+			for (i = 0; i < evsel->nr_members; i++) {
+				ret += perf_gtk__get_percent(s + ret,
+							     sizeof(s) - ret,
+							     sym, pos,
+							     evsel->idx + i);
+				ret += scnprintf(s + ret, sizeof(s) - ret, " ");
+			}
+		} else {
+			ret = perf_gtk__get_percent(s, sizeof(s), sym, pos,
+						    evsel->idx);
+		}
+
+		if (ret)
 			gtk_list_store_set(store, &iter, ANN_COL__PERCENT, s, -1);
 		if (perf_gtk__get_offset(s, sizeof(s), sym, map, pos))
 			gtk_list_store_set(store, &iter, ANN_COL__OFFSET, s, -1);
-- 
1.7.11.7

