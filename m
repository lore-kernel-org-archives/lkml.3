Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622Ab3DALhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 07:37:40 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60002 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab3DALf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 07:35:27 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-85-515970fe91c3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/9] perf hists: Fix an invalid memory free on he->branch_info
Date: Mon,  1 Apr 2013 20:35:17 +0900
Message-Id: <1364816125-12212-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
References: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The branch info was allocated for the whole stack and passed matching
hist entry for each level during processing samples.  Thus when a hist
entry tries to free its branch info like in hists__collapse_insert_entry
it'll face following error.

  *** glibc detected *** perf: munmap_chunk(): invalid pointer: 0x00000000014e9d20 ***
  ======= Backtrace: =========
  /lib64/libc.so.6[0x387d47ae16]
  perf[0x4923bd]
  perf(cmd_report+0xd68)[0x432a08]
  perf[0x41a663]
  perf(main+0x58f)[0x419eaf]
  /lib64/libc.so.6(__libc_start_main+0xf5)[0x387d421735]
  perf[0x419f95]

Fix it by allocating and copying branch info for each new hist entry.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c |  9 ++++++---
 tools/perf/util/hist.c      | 14 ++++++++++++++
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bd0ca81eeaca..d9f2de3e81fe 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -187,6 +187,9 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 	for (i = 0; i < sample->branch_stack->nr; i++) {
 		if (rep->hide_unresolved && !(bi[i].from.sym && bi[i].to.sym))
 			continue;
+
+		err = -ENOMEM;
+
 		/*
 		 * The report shows the percentage of total branches captured
 		 * and not events sampled. Thus we use a pseudo period of 1.
@@ -195,7 +198,6 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 				&bi[i], 1, 1);
 		if (he) {
 			struct annotation *notes;
-			err = -ENOMEM;
 			bx = he->branch_info;
 			if (bx->from.sym && use_browser == 1 && sort__has_sym) {
 				notes = symbol__annotation(bx->from.sym);
@@ -226,11 +228,12 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 			}
 			evsel->hists.stats.total_period += 1;
 			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-			err = 0;
 		} else
-			return -ENOMEM;
+			goto out;
 	}
+	err = 0;
 out:
+	free(bi);
 	return err;
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6b32721f829a..9438d576459d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -292,6 +292,20 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 			he->ms.map->referenced = true;
 
 		if (he->branch_info) {
+			/*
+			 * This branch info is (a part of) allocated from
+			 * machine__resolve_bstack() and will be freed after
+			 * adding new entries.  So we need to save a copy.
+			 */
+			he->branch_info = malloc(sizeof(*he->branch_info));
+			if (he->branch_info == NULL) {
+				free(he);
+				return NULL;
+			}
+
+			memcpy(he->branch_info, template->branch_info,
+			       sizeof(*he->branch_info));
+
 			if (he->branch_info->from.map)
 				he->branch_info->from.map->referenced = true;
 			if (he->branch_info->to.map)
-- 
1.7.11.7

