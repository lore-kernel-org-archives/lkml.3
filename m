Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbaAHIr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:47:29 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:48061 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbaAHIqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:46 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-14-52cd106f88bf
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 12/28] perf tools: Save callchain info for each cumulative entry
Date: Wed,  8 Jan 2014 17:46:17 +0900
Message-Id: <1389170793-21926-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When accumulating callchain entry, also save current snapshot of the
chain so that it can show the rest of the chain.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 087d01cac1aa..5f07da10f83c 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -363,7 +363,6 @@ static int
 iter_prepare_cumulative_entry(struct hist_entry_iter *iter __maybe_unused,
 			      struct addr_location *al __maybe_unused)
 {
-	struct callchain_cursor_node *node;
 	struct hist_entry **he_cache;
 
 	callchain_cursor_commit(&callchain_cursor);
@@ -380,10 +379,6 @@ iter_prepare_cumulative_entry(struct hist_entry_iter *iter __maybe_unused,
 	iter->priv = he_cache;
 	iter->curr = 0;
 
-	node = callchain_cursor_current(&callchain_cursor);
-	if (node == NULL)
-		return 0;
-
 	return 0;
 }
 
@@ -404,6 +399,14 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 
 	he_cache[iter->curr++] = he;
 
+	callchain_append(he->callchain, &callchain_cursor, sample->period);
+
+	/*
+	 * We need to re-initialize the cursor since callchain_append()
+	 * advanced the cursor to the end.
+	 */
+	callchain_cursor_commit(&callchain_cursor);
+
 	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 }
 
@@ -453,7 +456,6 @@ iter_next_cumulative_entry(struct hist_entry_iter *iter,
 	}
 
 out:
-	callchain_cursor_advance(&callchain_cursor);
 	return 1;
 }
 
@@ -477,6 +479,11 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 		.parent = iter->parent,
 	};
 	int i;
+	struct callchain_cursor cursor;
+
+	callchain_cursor_snapshot(&cursor, &callchain_cursor);
+
+	callchain_cursor_advance(&callchain_cursor);
 
 	/*
 	 * Check if there's duplicate entries in the callchain.
@@ -495,6 +502,8 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 
 	he_cache[iter->curr++] = he;
 
+	callchain_append(he->callchain, &cursor, sample->period);
+
 	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 }
 
-- 
1.7.11.7

