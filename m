Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923AbaEWKMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:12:54 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:49036 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaEWKEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:04:35 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 08/26] perf tools: Save callchain info for each cumulative entry
Date: Fri, 23 May 2014 19:04:05 +0900
Message-Id: <1400839463-21933-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
References: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When accumulating callchain entry, also save current snapshot of the
chain so that it can show the rest of the chain.

Tested-by: Arun Sharma <asharma@fb.com>
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b3faabf3d2c2..de13f0a12940 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -741,6 +741,14 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	iter->he = he;
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
 
@@ -754,8 +762,6 @@ iter_next_cumulative_entry(struct hist_entry_iter *iter,
 	if (node == NULL)
 		return 0;
 
-	callchain_cursor_advance(&callchain_cursor);
-
 	return fill_callchain_info(al, node, iter->hide_unresolved);
 }
 
@@ -779,6 +785,11 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
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
@@ -797,6 +808,8 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 
 	he_cache[iter->curr++] = he;
 
+	callchain_append(he->callchain, &cursor, sample->period);
+
 	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 }
 
-- 
1.9.2

