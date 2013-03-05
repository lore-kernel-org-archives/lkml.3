Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759688Ab3CEF4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:56:03 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55270 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224Ab3CEFxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:53:46 -0500
X-AuditID: 9c930197-b7cc2ae000000eb7-da-51358867bbee
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 04/12] perf annotate: Cleanup disasm__calc_percent()
Date: Tue,  5 Mar 2013 14:53:24 +0900
Message-Id: <1362462812-30885-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The loop end condition is calculated from next disasm_line or the
symbol size if it's the last disasm_line.  But it doesn't need to be
calculated at every iteration.  Moving it out of the function can
simplify code a bit.  Also the src_line doesn't need to be checked in
every time.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/annotate.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index a91d7b186081..ae71325d3dc7 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -603,29 +603,28 @@ struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disa
 	return NULL;
 }
 
-static double disasm__calc_percent(struct disasm_line *next,
-				   struct annotation *notes, int evidx,
-				   s64 offset, u64 len, const char **path)
+static double disasm__calc_percent(struct annotation *notes, int evidx,
+				   s64 offset, s64 end, const char **path)
 {
 	struct source_line *src_line = notes->src->lines;
 	struct sym_hist *h = annotation__histogram(notes, evidx);
 	unsigned int hits = 0;
 	double percent = 0.0;
 
-	while (offset < (s64)len &&
-	       (next == NULL || offset < next->offset)) {
-		if (src_line) {
+	if (src_line) {
+		while (offset < end) {
 			if (*path == NULL)
 				*path = src_line[offset].path;
-			percent += src_line[offset].percent;
-		} else
-			hits += h->addr[offset];
 
-		++offset;
-	}
+			percent += src_line[offset++].percent;
+		}
+	} else {
+		while (offset < end)
+			hits += h->addr[offset++];
 
-	if (src_line == NULL && h->sum)
-		percent = 100.0 * hits / h->sum;
+		if (h->sum)
+			percent = 100.0 * hits / h->sum;
+	}
 
 	return percent;
 }
@@ -648,8 +647,9 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 
 		next = disasm__get_next_ip_line(&notes->src->source, dl);
 
-		percent = disasm__calc_percent(next, notes, evsel->idx,
-					       offset, len, &path);
+		percent = disasm__calc_percent(notes, evsel->idx, offset,
+					       next ? next->offset : (s64) len,
+					       &path);
 		if (percent < min_pcnt)
 			return -1;
 
-- 
1.7.11.7

