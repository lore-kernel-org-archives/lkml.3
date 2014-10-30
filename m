Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbaJ3GlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:41:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37799 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490AbaJ3GlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:41:02 -0400
Date: Wed, 29 Oct 2014 23:40:41 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-428560e762601d1248359052361322b71561c093@git.kernel.org>
Cc: tglx@linutronix.de, ak@linux.intel.com, mingo@kernel.org,
        fweisbec@gmail.com, cjashfor@linux.vnet.ibm.com, dsahern@gmail.com,
        hpa@zytor.com, namhyung@kernel.org, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, jolsa@kernel.org,
        acme@redhat.com
Reply-To: tglx@linutronix.de, ak@linux.intel.com, mingo@kernel.org,
        fweisbec@gmail.com, cjashfor@linux.vnet.ibm.com, dsahern@gmail.com,
        hpa@zytor.com, namhyung@kernel.org, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, jolsa@kernel.org,
        acme@redhat.com
In-Reply-To: <1413468427-31049-4-git-send-email-jolsa@kernel.org>
References: <1413468427-31049-4-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix report -F mispredict for data without branch info
Git-Commit-ID: 428560e762601d1248359052361322b71561c093
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

Commit-ID:  428560e762601d1248359052361322b71561c093
Gitweb:     http://git.kernel.org/tip/428560e762601d1248359052361322b71561c093
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Thu, 16 Oct 2014 16:07:03 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:28:20 -0200

perf tools: Fix report -F mispredict for data without branch info

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
index 9bcdb57..0c68af8 100644
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
