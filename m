Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaJ3Gld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:41:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37826 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080AbaJ3Glc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:41:32 -0400
Date: Wed, 29 Oct 2014 23:41:10 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-1b9e97a2a95e4941dcfa968c4b2e04022e9a343e@git.kernel.org>
Cc: paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        ak@linux.intel.com, fweisbec@gmail.com, dsahern@gmail.com,
        jolsa@kernel.org, hpa@zytor.com, namhyung@kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl
Reply-To: ak@linux.intel.com, tglx@linutronix.de, mingo@kernel.org,
        linux-kernel@vger.kernel.org, cjashfor@linux.vnet.ibm.com,
        paulus@samba.org, a.p.zijlstra@chello.nl, acme@redhat.com,
        namhyung@kernel.org, hpa@zytor.com, jolsa@kernel.org,
        dsahern@gmail.com, fweisbec@gmail.com
In-Reply-To: <1413468427-31049-6-git-send-email-jolsa@kernel.org>
References: <1413468427-31049-6-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix report -F symbol_from for data without branch info
Git-Commit-ID: 1b9e97a2a95e4941dcfa968c4b2e04022e9a343e
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

Commit-ID:  1b9e97a2a95e4941dcfa968c4b2e04022e9a343e
Gitweb:     http://git.kernel.org/tip/1b9e97a2a95e4941dcfa968c4b2e04022e9a343e
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Thu, 16 Oct 2014 16:07:05 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:28:39 -0200

perf tools: Fix report -F symbol_from for data without branch info

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
index 57047c0..fc4ff2a 100644
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
