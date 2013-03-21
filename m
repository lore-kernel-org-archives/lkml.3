Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab3CULRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:17:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56399 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab3CULRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:17:52 -0400
Date: Thu, 21 Mar 2013 04:16:15 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-bd64fcb8805d8e4575f95f0df22f43b74418a4ec@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1362462812-30885-5-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Cleanup disasm__calc_percent()
Git-Commit-ID: bd64fcb8805d8e4575f95f0df22f43b74418a4ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:16:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd64fcb8805d8e4575f95f0df22f43b74418a4ec
Gitweb:     http://git.kernel.org/tip/bd64fcb8805d8e4575f95f0df22f43b74418a4ec
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 5 Mar 2013 14:53:24 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:05 -0300

perf annotate: Cleanup disasm__calc_percent()

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
 tools/perf/util/annotate.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

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
 
