Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab3LTTVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:21:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38471 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3LTTJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/35] perf hists: Leave symbol addr hist bucket auto alloc to symbol layer
Date: Fri, 20 Dec 2013 16:08:41 -0300
Message-Id: <1387566550-3524-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since now symbol__addr_inc_samples() does the auto alloc, no need to do
it prior to calling hist_entry__inc_addr_samples.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6ife7xq2kef1nn017m04b3id@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c | 10 +---------
 tools/perf/builtin-report.c   | 38 ++++----------------------------------
 2 files changed, 5 insertions(+), 43 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 6fd52c8fa682..4136f9970fd5 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -69,15 +69,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 	if (he == NULL)
 		return -ENOMEM;
 
-	ret = 0;
-	if (he->ms.sym != NULL) {
-		struct annotation *notes = symbol__annotation(he->ms.sym);
-		if (notes->src == NULL && symbol__alloc_hist(he->ms.sym) < 0)
-			return -ENOMEM;
-
-		ret = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	}
-
+	ret = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 	return ret;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b75fc361b9bd..0615a63ae355 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -122,23 +122,9 @@ static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
 	if (!he)
 		return -ENOMEM;
 
-	/*
-	 * In the TUI browser, we are doing integrated annotation,
-	 * so we don't allocate the extra space needed because the stdio
-	 * code will not use it.
-	 */
-	if (sort__has_sym && he->ms.sym && use_browser > 0) {
-		struct annotation *notes = symbol__annotation(he->ms.sym);
-
-		assert(evsel != NULL);
-
-		if (notes->src == NULL && symbol__alloc_hist(he->ms.sym) < 0)
-			goto out;
-
-		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-		if (err)
-			goto out;
-	}
+	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	if (err)
+		goto out;
 
 	mx = he->mem_info;
 	err = symbol__inc_addr_samples(mx->daddr.sym, mx->daddr.map,
@@ -259,26 +245,10 @@ static int perf_evsel__add_hist_entry(struct perf_tool *tool,
 		if (err)
 			return err;
 	}
-	/*
-	 * Only in the TUI browser we are doing integrated annotation,
-	 * so we don't allocated the extra space needed because the stdio
-	 * code will not use it.
-	 */
-	if (he->ms.sym != NULL && use_browser == 1 && sort__has_sym) {
-		struct annotation *notes = symbol__annotation(he->ms.sym);
-
-		assert(evsel != NULL);
-
-		err = -ENOMEM;
-		if (notes->src == NULL && symbol__alloc_hist(he->ms.sym) < 0)
-			goto out;
-
-		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	}
 
+	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-out:
 	return err;
 }
 
-- 
1.8.1.4

