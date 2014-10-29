Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555AbaJ2M5C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:57:02 -0400
Received: from mail.kernel.org ([198.145.19.201]:36952 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933536AbaJ2M47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:56:59 -0400
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
Subject: [PATCH 07/10] perf tools: Fix report -F symbol_from for data without branch info
Date: Wed, 29 Oct 2014 10:56:14 -0200
Message-Id: <1414587377-25077-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414587377-25077-1-git-send-email-acme@kernel.org>
References: <1414587377-25077-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

The branch field sorting code assumes hist_entry::branch_info is
allocated, which is wrong and following perf session ends up with report
segfault.

  $ perf record ls
  $ perf report -F symbol_from
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
Link: http://lkml.kernel.org/r/1413468427-31049-6-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 57047c0a247c..fc4ff2a96616 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -404,6 +404,12 @@ sort__sym_from_cmp(struct hist_entry *left, struct hist_entry *right)
 	struct addr_map_symbol *from_l = &left->branch_info->from;
 	struct addr_map_symbol *from_r = &right->branch_info->from;
 
+	if (!left->branch_info || !right->branch_info)
+		return cmp_null(left->branch_info, right->branch_info);
+
+	from_l = &left->branch_info->from;
+	from_r = &right->branch_info->from;
+
 	if (!from_l->sym && !from_r->sym)
 		return _sort__addr_cmp(from_l->addr, from_r->addr);
 
@@ -430,10 +436,14 @@ sort__sym_to_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__sym_from_snprintf(struct hist_entry *he, char *bf,
 					 size_t size, unsigned int width)
 {
-	struct addr_map_symbol *from = &he->branch_info->from;
-	return _hist_entry__sym_snprintf(from->map, from->sym, from->addr,
-					 he->level, bf, size, width);
+	if (he->branch_info) {
+		struct addr_map_symbol *from = &he->branch_info->from;
 
+		return _hist_entry__sym_snprintf(from->map, from->sym, from->addr,
+						 he->level, bf, size, width);
+	}
+
+	return repsep_snprintf(bf, size, "%-*.*s", width, width, "N/A");
 }
 
 static int hist_entry__sym_to_snprintf(struct hist_entry *he, char *bf,
-- 
1.9.3

