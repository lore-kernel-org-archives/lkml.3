Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634Ab3CZMMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:12:09 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43180 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab3CZMMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:12:07 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-4e-515190950297
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] perf sort: Add 'addr' sort key
Date: Tue, 26 Mar 2013 21:11:56 +0900
Message-Id: <1364299918-31175-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

New addr sort key provides a way to sort the entries by the symbol
addresses.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c |  2 ++
 tools/perf/util/hist.h |  1 +
 tools/perf/util/sort.c | 23 +++++++++++++++++++++++
 tools/perf/util/sort.h |  1 +
 4 files changed, 27 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f855941bebea..82b7542db904 100644
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
index 848331377bdb..72c75bef0c68 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -49,6 +49,7 @@ enum hist_column {
 	HISTC_DSO_FROM,
 	HISTC_DSO_TO,
 	HISTC_SRCLINE,
+	HISTC_ADDR,
 	HISTC_NR_COLS, /* Last entry */
 };
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index d41926cb9e3f..27e55562cbbb 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -334,6 +334,28 @@ struct sort_entry sort_cpu = {
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
@@ -480,6 +502,7 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
+	DIM(SORT_ADDR, "addr", sort_addr),
 };
 
 #undef DIM
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index b13e56f6ccbe..a24dba16cc8f 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -130,6 +130,7 @@ enum sort_type {
 	SORT_PARENT,
 	SORT_CPU,
 	SORT_SRCLINE,
+	SORT_ADDR,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
-- 
1.7.11.7

