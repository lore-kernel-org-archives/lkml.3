Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbaJ1Ngv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:36:51 -0400
Received: from mail.kernel.org ([198.145.19.201]:51631 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbaJ1NeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:34:21 -0400
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
Subject: [PATCH 23/32] perf tools: Fix report -F mispredict for data without branch info
Date: Tue, 28 Oct 2014 11:32:17 -0200
Message-Id: <1414503146-22789-24-git-send-email-acme@kernel.org>
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
  $ perf report -F mispredict
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
Link: http://lkml.kernel.org/r/1413468427-31049-4-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9bcdb57076b8..0c68af83e7dd 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -471,11 +471,13 @@ struct sort_entry sort_sym_to = {
 static int64_t
 sort__mispredict_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	const unsigned char mp = left->branch_info->flags.mispred !=
-					right->branch_info->flags.mispred;
-	const unsigned char p = left->branch_info->flags.predicted !=
-					right->branch_info->flags.predicted;
+	unsigned char mp, p;
 
+	if (!left->branch_info || !right->branch_info)
+		return cmp_null(left->branch_info, right->branch_info);
+
+	mp = left->branch_info->flags.mispred != right->branch_info->flags.mispred;
+	p  = left->branch_info->flags.predicted != right->branch_info->flags.predicted;
 	return mp || p;
 }
 
@@ -483,10 +485,12 @@ static int hist_entry__mispredict_snprintf(struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width){
 	static const char *out = "N/A";
 
-	if (he->branch_info->flags.predicted)
-		out = "N";
-	else if (he->branch_info->flags.mispred)
-		out = "Y";
+	if (he->branch_info) {
+		if (he->branch_info->flags.predicted)
+			out = "N";
+		else if (he->branch_info->flags.mispred)
+			out = "Y";
+	}
 
 	return repsep_snprintf(bf, size, "%-*.*s", width, width, out);
 }
-- 
1.9.3

