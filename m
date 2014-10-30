Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbaJ3GlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:41:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37815 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521AbaJ3GlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:41:16 -0400
Date: Wed, 29 Oct 2014 23:40:56 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-38cdbd39ddf39c1284d54c4b7fe04db80ce97d04@git.kernel.org>
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, ak@linux.intel.com, mingo@kernel.org,
        acme@redhat.com, tglx@linutronix.de, namhyung@kernel.org,
        dsahern@gmail.com
Reply-To: acme@redhat.com, ak@linux.intel.com, mingo@kernel.org,
        dsahern@gmail.com, namhyung@kernel.org, tglx@linutronix.de,
        a.p.zijlstra@chello.nl, hpa@zytor.com, cjashfor@linux.vnet.ibm.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, jolsa@kernel.org,
        fweisbec@gmail.com
In-Reply-To: <1413468427-31049-5-git-send-email-jolsa@kernel.org>
References: <1413468427-31049-5-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix report -F symbol_to for data without branch info
Git-Commit-ID: 38cdbd39ddf39c1284d54c4b7fe04db80ce97d04
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

Commit-ID:  38cdbd39ddf39c1284d54c4b7fe04db80ce97d04
Gitweb:     http://git.kernel.org/tip/38cdbd39ddf39c1284d54c4b7fe04db80ce97d04
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Thu, 16 Oct 2014 16:07:04 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:28:30 -0200

perf tools: Fix report -F symbol_to for data without branch info

The branch field sorting code assumes hist_entry::branch_info is
allocated, which is wrong and following perf session ends up with report
segfault.

  $ perf record ls
  $ perf report -F symbol_to
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
Link: http://lkml.kernel.org/r/1413468427-31049-5-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 0c68af8..57047c0 100644
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
+		return cmp_null(left->branch_info, right->branch_info);
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
