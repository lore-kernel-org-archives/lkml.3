Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3KKUYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:24:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43978 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab3KKUXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:23:00 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/10] perf tools: Prevent condition that all sort keys are elided
Date: Mon, 11 Nov 2013 17:22:29 -0300
Message-Id: <1384201353-23863-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1384201353-23863-1-git-send-email-acme@infradead.org>
References: <1384201353-23863-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
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
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383900822-14609-1-git-send-email-namhyung@kernel.org
[ Us curly braces around multi-line statements, as requested by Ingo Molnar ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 3c1b75c8b9a6..8b0bb1f4494a 100644
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
@@ -1172,4 +1174,15 @@ void sort__setup_elide(FILE *output)
 					"snoop", output);
 	}
 
+	/*
+	 * It makes no sense to elide all of sort entries.
+	 * Just revert them to show up again.
+	 */
+	list_for_each_entry(se, &hist_entry__sort_list, list) {
+		if (!se->elide)
+			return;
+	}
+
+	list_for_each_entry(se, &hist_entry__sort_list, list)
+		se->elide = false;
 }
-- 
1.8.1.4

