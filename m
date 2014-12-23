Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbaLWPdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:33:04 -0500
Received: from mail.kernel.org ([198.145.19.201]:38221 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226AbaLWPdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:33:00 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/3] perf callchain: Append callchains only when requested
Date: Tue, 23 Dec 2014 12:32:43 -0300
Message-Id: <1419348763-29118-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1419348763-29118-1-git-send-email-acme@kernel.org>
References: <1419348763-29118-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The perf report --children can be called with callchain disabled so no
need to append callchains.  Actually the root of callchain tree is not
initialized properly in this case.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1419223455-4362-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 1cc6ea4b7065..0ced178ce306 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -304,7 +304,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template,
 	size_t callchain_size = 0;
 	struct hist_entry *he;
 
-	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain)
+	if (symbol_conf.use_callchain)
 		callchain_size = sizeof(struct callchain_root);
 
 	he = zalloc(sizeof(*he) + callchain_size);
@@ -737,7 +737,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	iter->he = he;
 	he_cache[iter->curr++] = he;
 
-	callchain_append(he->callchain, &callchain_cursor, sample->period);
+	hist_entry__append_callchain(he, sample);
 
 	/*
 	 * We need to re-initialize the cursor since callchain_append()
@@ -810,7 +810,8 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 	iter->he = he;
 	he_cache[iter->curr++] = he;
 
-	callchain_append(he->callchain, &cursor, sample->period);
+	if (symbol_conf.use_callchain)
+		callchain_append(he->callchain, &cursor, sample->period);
 	return 0;
 }
 
-- 
1.9.3

