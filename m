Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaJPMVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:21:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbaJPMVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:21:32 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/7] perf tools: Fix report -F symbol_to for data without branch info
Date: Thu, 16 Oct 2014 14:20:46 +0200
Message-Id: <1413462049-12124-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1413462049-12124-1-git-send-email-jolsa@kernel.org>
References: <1413462049-12124-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The branch field sorting code assumes hist_entry::branch_info
is allocated, which is wrong and following perf session ends
up with report segfault.

  $ perf record ls
  $ perf report -F symbol_to
  perf: Segmentation fault

Checking that hist_entry::branch_info is valid and display
"N/A" string in snprint callback if it's not.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/sort.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 07d3ffb3ee2b..134633c474a0 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -413,8 +413,13 @@ sort__sym_from_cmp(struct hist_entry *left, struct hist_entry *right)
 static int64_t
 sort__sym_to_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	struct addr_map_symbol *to_l = &left->branch_info->to;
-	struct addr_map_symbol *to_r = &right->branch_info->to;
+	struct addr_map_symbol *to_l, *to_r;
+
+	if (!left->branch_info || !right->branch_info)
+		return 0;
+
+	to_l = &left->branch_info->to;
+	to_r = &right->branch_info->to;
 
 	if (!to_l->sym && !to_r->sym)
 		return _sort__addr_cmp(to_l->addr, to_r->addr);
@@ -434,10 +439,14 @@ static int hist_entry__sym_from_snprintf(struct hist_entry *he, char *bf,
 static int hist_entry__sym_to_snprintf(struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
-	struct addr_map_symbol *to = &he->branch_info->to;
-	return _hist_entry__sym_snprintf(to->map, to->sym, to->addr,
-					 he->level, bf, size, width);
+	if (he->branch_info) {
+		struct addr_map_symbol *to = &he->branch_info->to;
+
+		return _hist_entry__sym_snprintf(to->map, to->sym, to->addr,
+						 he->level, bf, size, width);
+	}
 
+	return repsep_snprintf(bf, size, "%-*.*s", width, width, "N/A");
 }
 
 struct sort_entry sort_dso_from = {
-- 
1.9.3

