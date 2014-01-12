Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaALStL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:49:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45389 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaALSco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:32:44 -0500
Date: Sun, 12 Jan 2014 10:31:47 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-6ife7xq2kef1nn017m04b3id@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Leave symbol addr hist bucket auto alloc to symbol layer
Git-Commit-ID: 00e55218642b91c152917e170c8387c631467460
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:31:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00e55218642b91c152917e170c8387c631467460
Gitweb:     http://git.kernel.org/tip/00e55218642b91c152917e170c8387c631467460
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 18 Dec 2013 15:46:32 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 11:34:04 -0300

perf hists: Leave symbol addr hist bucket auto alloc to symbol layer

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
index 6fd52c8..4136f99 100644
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
index b75fc36..0615a63 100644
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
 
