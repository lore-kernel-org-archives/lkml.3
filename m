Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab3KHIxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:53:52 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57715 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab3KHIxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:53:51 -0500
X-AuditID: 9c93016f-b7bb9ae000001e30-f0-527ca69eaf0d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf tools: Prevent condition that all sort keys are elided
Date: Fri,  8 Nov 2013 17:53:42 +0900
Message-Id: <1383900822-14609-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If given sort keys are all elided there'll be no output except for the
overhead column - actually the TUI shows a noisy output.  In this case
it'd be better to show up the sort keys rather than elide.

Before:

  $ perf report -s comm -c perf
  (...)
  # Overhead
  # ........
  #
     100.00%

After:

  $ perf report -s comm -c perf
  (...)
  # Overhead  Command
  # ........  .......
  #
     100.00%     perf

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/sort.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 3c1b75c8b9a6..fb7d556ad721 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1137,6 +1137,8 @@ static void sort_entry__setup_elide(struct sort_entry *se,
 
 void sort__setup_elide(FILE *output)
 {
+	struct sort_entry *se;
+
 	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
 				"dso", output);
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list,
@@ -1172,4 +1174,14 @@ void sort__setup_elide(FILE *output)
 					"snoop", output);
 	}
 
+	/*
+	 * It makes no sense to elide all of sort entries.
+	 * Just revert them to show up again.
+	 */
+	list_for_each_entry(se, &hist_entry__sort_list, list)
+		if (!se->elide)
+			return;
+
+	list_for_each_entry(se, &hist_entry__sort_list, list)
+		se->elide = false;
 }
-- 
1.7.11.7

