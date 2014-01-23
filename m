Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbaAWAOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:14:18 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58514 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbaAWAOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:14:15 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-59-52e05ed1b236
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 08/21] perf tools: Save callchain info for each cumulative entry
Date: Thu, 23 Jan 2014 09:13:52 +0900
Message-Id: <1390436045-16830-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390436045-16830-1-git-send-email-namhyung@kernel.org>
References: <1390436045-16830-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When accumulating callchain entry, also save current snapshot of the
chain so that it can show the rest of the chain.

Tested-by: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 1b477f8d2d17..765ac5953201 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -744,6 +744,14 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 
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
 
@@ -757,8 +765,6 @@ iter_next_cumulative_entry(struct hist_entry_iter *iter,
 	if (node == NULL)
 		return 0;
 
-	callchain_cursor_advance(&callchain_cursor);
-
 	return fill_callchain_info(al, node, iter->hide_unresolved);
 }
 
@@ -782,6 +788,11 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
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
@@ -800,6 +811,8 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 
 	he_cache[iter->curr++] = he;
 
+	callchain_append(he->callchain, &cursor, sample->period);
+
 	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 }
 
-- 
1.7.11.7

