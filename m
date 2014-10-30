Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbaJ3Gku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:40:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37782 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758420AbaJ3Gkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:40:45 -0400
Date: Wed, 29 Oct 2014 23:40:10 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-49f4744307f9718d8e100755110b3b7b40ec4237@git.kernel.org>
Cc: a.p.zijlstra@chello.nl, cjashfor@linux.vnet.ibm.com, hpa@zytor.com,
        paulus@samba.org, namhyung@kernel.org, fweisbec@gmail.com,
        jolsa@kernel.org, linux-kernel@vger.kernel.org, dsahern@gmail.com,
        ak@linux.intel.com, acme@redhat.com, tglx@linutronix.de,
        mingo@kernel.org
Reply-To: linux-kernel@vger.kernel.org, dsahern@gmail.com, ak@linux.intel.com,
        tglx@linutronix.de, acme@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, cjashfor@linux.vnet.ibm.com, hpa@zytor.com,
        paulus@samba.org, namhyung@kernel.org, fweisbec@gmail.com,
        jolsa@kernel.org
In-Reply-To: <1413468427-31049-2-git-send-email-jolsa@kernel.org>
References: <1413468427-31049-2-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix report -F abort for data without branch info
Git-Commit-ID: 49f4744307f9718d8e100755110b3b7b40ec4237
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

Commit-ID:  49f4744307f9718d8e100755110b3b7b40ec4237
Gitweb:     http://git.kernel.org/tip/49f4744307f9718d8e100755110b3b7b40ec4237
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Thu, 16 Oct 2014 16:07:01 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:27:56 -0200

perf tools: Fix report -F abort for data without branch info

The branch field sorting code assumes hist_entry::branch_info is
allocated, which is wrong and following perf session ends up with report
segfault.

  $ perf record ls
  $ perf report -F abort
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
Link: http://lkml.kernel.org/r/1413468427-31049-2-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 4906cd8..82241fe 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -989,6 +989,9 @@ struct sort_entry sort_mem_dcacheline = {
 static int64_t
 sort__abort_cmp(struct hist_entry *left, struct hist_entry *right)
 {
+	if (!left->branch_info || !right->branch_info)
+		return cmp_null(left->branch_info, right->branch_info);
+
 	return left->branch_info->flags.abort !=
 		right->branch_info->flags.abort;
 }
@@ -996,10 +999,15 @@ sort__abort_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__abort_snprintf(struct hist_entry *he, char *bf,
 				    size_t size, unsigned int width)
 {
-	static const char *out = ".";
+	static const char *out = "N/A";
+
+	if (he->branch_info) {
+		if (he->branch_info->flags.abort)
+			out = "A";
+		else
+			out = ".";
+	}
 
-	if (he->branch_info->flags.abort)
-		out = "A";
 	return repsep_snprintf(bf, size, "%-*s", width, out);
 }
 
