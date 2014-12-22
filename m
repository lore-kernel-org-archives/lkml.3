Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaLVEn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 23:43:57 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50459 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaLVEnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 23:43:41 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 6/7] perf tools: Append callchains only when requested
Date: Mon, 22 Dec 2014 13:44:14 +0900
Message-Id: <1419223455-4362-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
References: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf report --children can be called with callchain disabled so no
need to append callchains.  Actually the root of callchain tree is not
initialized properly in this case.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index bd4a2cd73236..30ff2cb92884 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -300,7 +300,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template,
 	size_t callchain_size = 0;
 	struct hist_entry *he;
 
-	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain)
+	if (symbol_conf.use_callchain)
 		callchain_size = sizeof(struct callchain_root);
 
 	he = zalloc(sizeof(*he) + callchain_size);
@@ -735,7 +735,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	iter->he = he;
 	he_cache[iter->curr++] = he;
 
-	callchain_append(he->callchain, &callchain_cursor, sample->period);
+	hist_entry__append_callchain(he, sample);
 
 	/*
 	 * We need to re-initialize the cursor since callchain_append()
@@ -808,7 +808,8 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 	iter->he = he;
 	he_cache[iter->curr++] = he;
 
-	callchain_append(he->callchain, &cursor, sample->period);
+	if (symbol_conf.use_callchain)
+		callchain_append(he->callchain, &cursor, sample->period);
 	return 0;
 }
 
-- 
2.1.3

