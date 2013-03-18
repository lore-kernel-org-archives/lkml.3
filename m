Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab3CRQhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:37:11 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49381
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752717Ab3CRQZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/54] perf annotate: Cleanup disasm__calc_percent()
Date: Mon, 18 Mar 2013 13:25:09 -0300
Message-Id: <1363623939-10748-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The loop end condition is calculated from next disasm_line or the symbol
size if it's the last disasm_line.  But it doesn't need to be calculated
at every iteration.  Moving it out of the function can simplify code a
bit.  Also the src_line doesn't need to be checked in every time.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362462812-30885-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index a91d7b1..ae71325 100644
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
1.7.1

