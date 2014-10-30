Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbaJ3Gks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:40:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422AbaJ3Gkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:40:46 -0400
Date: Wed, 29 Oct 2014 23:40:25 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-0199d244d6ed6bc1fcab38a8732fdba1ddf04080@git.kernel.org>
Cc: namhyung@kernel.org, dsahern@gmail.com, paulus@samba.org, acme@redhat.com,
        fweisbec@gmail.com, mingo@kernel.org, cjashfor@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, jolsa@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@zytor.com
Reply-To: a.p.zijlstra@chello.nl, ak@linux.intel.com, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, dsahern@gmail.com, namhyung@kernel.org,
        acme@redhat.com, fweisbec@gmail.com, cjashfor@linux.vnet.ibm.com,
        mingo@kernel.org
In-Reply-To: <1413468427-31049-3-git-send-email-jolsa@kernel.org>
References: <1413468427-31049-3-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix report -F in_tx for data without branch info
Git-Commit-ID: 0199d244d6ed6bc1fcab38a8732fdba1ddf04080
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

Commit-ID:  0199d244d6ed6bc1fcab38a8732fdba1ddf04080
Gitweb:     http://git.kernel.org/tip/0199d244d6ed6bc1fcab38a8732fdba1ddf04080
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Thu, 16 Oct 2014 16:07:02 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:28:10 -0200

perf tools: Fix report -F in_tx for data without branch info

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
index 82241fe..9bcdb57 100644
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
