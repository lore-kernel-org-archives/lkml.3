Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623AbaJ2M5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:57:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:37036 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933575AbaJ2M5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:57:08 -0400
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
Subject: [PATCH 09/10] perf tools: Fix report -F dso_from for data without branch info
Date: Wed, 29 Oct 2014 10:56:16 -0200
Message-Id: <1414587377-25077-10-git-send-email-acme@kernel.org>
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
  $ perf report -F dso_from
  perf: Segmentation fault

Checking that hist_entry::branch_info is valid and display "N/A" string
in snprint callback if it's not.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1413468427-31049-8-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 7a9054a23c36..9402885a77f3 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -373,6 +373,9 @@ struct sort_entry sort_cpu = {
 static int64_t
 sort__dso_from_cmp(struct hist_entry *left, struct hist_entry *right)
 {
+	if (!left->branch_info || !right->branch_info)
+		return cmp_null(left->branch_info, right->branch_info);
+
 	return _sort__dso_cmp(left->branch_info->from.map,
 			      right->branch_info->from.map);
 }
@@ -380,8 +383,11 @@ sort__dso_from_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__dso_from_snprintf(struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
-	return _hist_entry__dso_snprintf(he->branch_info->from.map,
-					 bf, size, width);
+	if (he->branch_info)
+		return _hist_entry__dso_snprintf(he->branch_info->from.map,
+						 bf, size, width);
+	else
+		return repsep_snprintf(bf, size, "%-*.*s", width, width, "N/A");
 }
 
 static int64_t
-- 
1.9.3

