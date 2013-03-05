Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551Ab3CEFxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:53:46 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55270 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759441Ab3CEFxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:53:44 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-d2-5135886505d5
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 03/12] perf annotate: Factor out disasm__calc_percent()
Date: Tue,  5 Mar 2013 14:53:23 +0900
Message-Id: <1362462812-30885-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Factor out calculation of histogram of a symbol into
disasm__calc_percent.  It'll be used for later changes.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/annotate.c | 49 ++++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index fa347b169e27..a91d7b186081 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -603,6 +603,33 @@ struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disa
 	return NULL;
 }
 
+static double disasm__calc_percent(struct disasm_line *next,
+				   struct annotation *notes, int evidx,
+				   s64 offset, u64 len, const char **path)
+{
+	struct source_line *src_line = notes->src->lines;
+	struct sym_hist *h = annotation__histogram(notes, evidx);
+	unsigned int hits = 0;
+	double percent = 0.0;
+
+	while (offset < (s64)len &&
+	       (next == NULL || offset < next->offset)) {
+		if (src_line) {
+			if (*path == NULL)
+				*path = src_line[offset].path;
+			percent += src_line[offset].percent;
+		} else
+			hits += h->addr[offset];
+
+		++offset;
+	}
+
+	if (src_line == NULL && h->sum)
+		percent = 100.0 * hits / h->sum;
+
+	return percent;
+}
+
 static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 start,
 		      struct perf_evsel *evsel, u64 len, int min_pcnt, int printed,
 		      int max_lines, struct disasm_line *queue)
@@ -612,33 +639,17 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 
 	if (dl->offset != -1) {
 		const char *path = NULL;
-		unsigned int hits = 0;
-		double percent = 0.0;
+		double percent;
 		const char *color;
 		struct annotation *notes = symbol__annotation(sym);
-		struct source_line *src_line = notes->src->lines;
-		struct sym_hist *h = annotation__histogram(notes, evsel->idx);
 		s64 offset = dl->offset;
 		const u64 addr = start + offset;
 		struct disasm_line *next;
 
 		next = disasm__get_next_ip_line(&notes->src->source, dl);
 
-		while (offset < (s64)len &&
-		       (next == NULL || offset < next->offset)) {
-			if (src_line) {
-				if (path == NULL)
-					path = src_line[offset].path;
-				percent += src_line[offset].percent;
-			} else
-				hits += h->addr[offset];
-
-			++offset;
-		}
-
-		if (src_line == NULL && h->sum)
-			percent = 100.0 * hits / h->sum;
-
+		percent = disasm__calc_percent(next, notes, evsel->idx,
+					       offset, len, &path);
 		if (percent < min_pcnt)
 			return -1;
 
-- 
1.7.11.7

