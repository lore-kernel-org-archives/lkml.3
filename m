Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbaJ3GmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:42:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbaJ3GmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:42:02 -0400
Date: Wed, 29 Oct 2014 23:41:42 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-288a4b91fc0dc7c0ce3509339e8dec7b590a4d73@git.kernel.org>
Cc: acme@redhat.com, cjashfor@linux.vnet.ibm.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, fweisbec@gmail.com,
        tglx@linutronix.de, ak@linux.intel.com, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, paulus@samba.org, mingo@kernel.org,
        hpa@zytor.com
Reply-To: jolsa@kernel.org, acme@redhat.com, cjashfor@linux.vnet.ibm.com,
        fweisbec@gmail.com, tglx@linutronix.de, namhyung@kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, ak@linux.intel.com, hpa@zytor.com,
        mingo@kernel.org
In-Reply-To: <1413468427-31049-8-git-send-email-jolsa@kernel.org>
References: <1413468427-31049-8-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix report -F dso_from for data without branch info
Git-Commit-ID: 288a4b91fc0dc7c0ce3509339e8dec7b590a4d73
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

Commit-ID:  288a4b91fc0dc7c0ce3509339e8dec7b590a4d73
Gitweb:     http://git.kernel.org/tip/288a4b91fc0dc7c0ce3509339e8dec7b590a4d73
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Thu, 16 Oct 2014 16:07:07 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:29:05 -0200

perf tools: Fix report -F dso_from for data without branch info

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
index 7a9054a..9402885 100644
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
