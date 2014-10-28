Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaJ1NeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:34:22 -0400
Received: from mail.kernel.org ([198.145.19.201]:51597 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbaJ1NeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:34:17 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/32] perf tools: Fix report -F in_tx for data without branch info
Date: Tue, 28 Oct 2014 11:32:16 -0200
Message-Id: <1414503146-22789-23-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414503146-22789-1-git-send-email-acme@kernel.org>
References: <1414503146-22789-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

The branch field sorting code assumes hist_entry::branch_info is
allocated, which is wrong and following perf session ends up with report
segfault.

  $ perf record ls
  $ perf report -F in_tx
  perf: Segmentation fault

Checking that hist_entry::branch_info is valid and display "N/A" string
in snprint callback if it's not.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1413468427-31049-3-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 82241fe54e4b..9bcdb57076b8 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1021,6 +1021,9 @@ struct sort_entry sort_abort = {
 static int64_t
 sort__in_tx_cmp(struct hist_entry *left, struct hist_entry *right)
 {
+	if (!left->branch_info || !right->branch_info)
+		return cmp_null(left->branch_info, right->branch_info);
+
 	return left->branch_info->flags.in_tx !=
 		right->branch_info->flags.in_tx;
 }
@@ -1028,10 +1031,14 @@ sort__in_tx_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__in_tx_snprintf(struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
-	static const char *out = ".";
+	static const char *out = "N/A";
 
-	if (he->branch_info->flags.in_tx)
-		out = "T";
+	if (he->branch_info) {
+		if (he->branch_info->flags.in_tx)
+			out = "T";
+		else
+			out = ".";
+	}
 
 	return repsep_snprintf(bf, size, "%-*s", width, out);
 }
-- 
1.9.3

