Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3EaLOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:14:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56358 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3EaLOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:14:33 -0400
Date: Fri, 31 May 2013 04:13:55 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-26353a61b977e57b58dd3555bc0422fea46c5ad6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1364816125-12212-2-git-send-email-namhyung@kernel.org>
References: <1364816125-12212-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Fix an invalid memory free on he->
 branch_info
Git-Commit-ID: 26353a61b977e57b58dd3555bc0422fea46c5ad6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26353a61b977e57b58dd3555bc0422fea46c5ad6
Gitweb:     http://git.kernel.org/tip/26353a61b977e57b58dd3555bc0422fea46c5ad6
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 1 Apr 2013 20:35:17 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:52 +0300

perf hists: Fix an invalid memory free on he->branch_info

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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1364816125-12212-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |  9 ++++++---
 tools/perf/util/hist.c      | 14 ++++++++++++++
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bd0ca81..d9f2de3 100644
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
index 6b32721..9438d57 100644
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
