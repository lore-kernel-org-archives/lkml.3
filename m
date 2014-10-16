Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaJPMVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:21:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbaJPMVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:21:40 -0400
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
Subject: [PATCH 6/7] perf tools: Fix report -F dso_to for data without branch info
Date: Thu, 16 Oct 2014 14:20:48 +0200
Message-Id: <1413462049-12124-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1413462049-12124-1-git-send-email-jolsa@kernel.org>
References: <1413462049-12124-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The branch field sorting code assumes hist_entry::branch_info
is allocated, which is wrong and following perf session ends
up with report segfault.

  $ perf record ls
  $ perf report -F dso_to
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
 tools/perf/util/sort.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index d64c020acac5..1c303f8cc61d 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -387,6 +387,9 @@ static int hist_entry__dso_from_snprintf(struct hist_entry *he, char *bf,
 static int64_t
 sort__dso_to_cmp(struct hist_entry *left, struct hist_entry *right)
 {
+	if (!left->branch_info || !right->branch_info)
+		return 0;
+
 	return _sort__dso_cmp(left->branch_info->to.map,
 			      right->branch_info->to.map);
 }
@@ -394,8 +397,11 @@ sort__dso_to_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__dso_to_snprintf(struct hist_entry *he, char *bf,
 				       size_t size, unsigned int width)
 {
-	return _hist_entry__dso_snprintf(he->branch_info->to.map,
-					 bf, size, width);
+	if (he->branch_info)
+		return _hist_entry__dso_snprintf(he->branch_info->to.map,
+						 bf, size, width);
+	else
+		return repsep_snprintf(bf, size, "%-*.*s", width, width, "N/A");
 }
 
 static int64_t
-- 
1.9.3

