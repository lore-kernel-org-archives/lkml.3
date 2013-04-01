Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275Ab3DALfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 07:35:36 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59262 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab3DALf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 07:35:29 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-8c-515970fef069
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 6/9] perf sort: Add 'addr' sort key
Date: Mon,  1 Apr 2013 20:35:22 +0900
Message-Id: <1364816125-12212-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
References: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

New addr sort key provides a way to sort the entries by the symbol
addresses.  It can be helpful to figure out symbol resolution problem
when a dso cannot do it properly as well as finding hotpath in a dso
and/or a function.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=55561
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c |  2 ++
 tools/perf/util/hist.h |  3 ++-
 tools/perf/util/sort.c | 23 +++++++++++++++++++++++
 tools/perf/util/sort.h |  1 +
 4 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 72b4eec820c3..c098d6ebab1f 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -52,6 +52,8 @@ void hists__reset_col_len(struct hists *hists)
 
 	for (col = 0; col < HISTC_NR_COLS; ++col)
 		hists__set_col_len(hists, col, 0);
+
+	hists__set_col_len(hists, HISTC_ADDR, BITS_PER_LONG / 4 + 2);
 }
 
 static void hists__set_unres_dso_col_len(struct hists *hists, int dso)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 14c2fe20aa62..9599f805828f 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -43,12 +43,13 @@ enum hist_column {
 	HISTC_COMM,
 	HISTC_PARENT,
 	HISTC_CPU,
+	HISTC_SRCLINE,
+	HISTC_ADDR,
 	HISTC_MISPREDICT,
 	HISTC_SYMBOL_FROM,
 	HISTC_SYMBOL_TO,
 	HISTC_DSO_FROM,
 	HISTC_DSO_TO,
-	HISTC_SRCLINE,
 	HISTC_LOCAL_WEIGHT,
 	HISTC_GLOBAL_WEIGHT,
 	HISTC_MEM_DADDR_SYMBOL,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index c19bf213cc86..fecde9347cbd 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -342,6 +342,28 @@ struct sort_entry sort_cpu = {
 	.se_width_idx	= HISTC_CPU,
 };
 
+/* --sort addr */
+
+static int64_t
+sort__addr_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return right->ip - left->ip;
+}
+
+static int hist_entry__addr_snprintf(struct hist_entry *self, char *bf,
+				     size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%#*"PRIx64, width, (uint64_t)self->ip);
+}
+
+struct sort_entry sort_addr = {
+	.se_header      = "Address",
+	.se_cmp	        = sort__addr_cmp,
+	.se_snprintf    = hist_entry__addr_snprintf,
+	.se_width_idx	= HISTC_ADDR,
+};
+
+
 /* sort keys for branch stacks */
 
 static int64_t
@@ -871,6 +893,7 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
+	DIM(SORT_ADDR, "addr", sort_addr),
 };
 
 #undef DIM
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 0232d476da87..0815e344f38c 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -138,6 +138,7 @@ enum sort_type {
 	SORT_PARENT,
 	SORT_CPU,
 	SORT_SRCLINE,
+	SORT_ADDR,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
-- 
1.7.11.7

