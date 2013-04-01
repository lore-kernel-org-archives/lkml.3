Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab3DALff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 07:35:35 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60002 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909Ab3DALfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 07:35:30 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-8e-515970fe8301
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 7/9] perf sort: Add 'addr_to/from' sort key
Date: Mon,  1 Apr 2013 20:35:23 +0900
Message-Id: <1364816125-12212-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
References: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

New addr_{to,from} sort keys provide a way to sort the entries by the
source/target symbol addresses.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c |  2 ++
 tools/perf/util/hist.h |  2 ++
 tools/perf/util/sort.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/sort.h |  2 ++
 4 files changed, 56 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c098d6ebab1f..1fb1535940f8 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -54,6 +54,8 @@ void hists__reset_col_len(struct hists *hists)
 		hists__set_col_len(hists, col, 0);
 
 	hists__set_col_len(hists, HISTC_ADDR, BITS_PER_LONG / 4 + 2);
+	hists__set_col_len(hists, HISTC_ADDR_FROM, BITS_PER_LONG / 4 + 2);
+	hists__set_col_len(hists, HISTC_ADDR_TO, BITS_PER_LONG / 4 + 2);
 }
 
 static void hists__set_unres_dso_col_len(struct hists *hists, int dso)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 9599f805828f..2640fcc566e9 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -50,6 +50,8 @@ enum hist_column {
 	HISTC_SYMBOL_TO,
 	HISTC_DSO_FROM,
 	HISTC_DSO_TO,
+	HISTC_ADDR_FROM,
+	HISTC_ADDR_TO,
 	HISTC_LOCAL_WEIGHT,
 	HISTC_GLOBAL_WEIGHT,
 	HISTC_MEM_DADDR_SYMBOL,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index fecde9347cbd..19f360b6e698 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -436,6 +436,40 @@ static int hist_entry__sym_to_snprintf(struct hist_entry *self, char *bf,
 
 }
 
+static int64_t
+sort__addr_from_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct addr_map_symbol *from_l = &left->branch_info->from;
+	struct addr_map_symbol *from_r = &right->branch_info->from;
+
+	return from_r->addr - from_l->addr;
+}
+
+static int hist_entry__addr_from_snprintf(struct hist_entry *self, char *bf,
+					  size_t size, unsigned int width)
+{
+	struct addr_map_symbol *from = &self->branch_info->from;
+	return repsep_snprintf(bf, size, "%#*"PRIx64, width,
+					(uint64_t)from->addr);
+}
+
+static int64_t
+sort__addr_to_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct addr_map_symbol *to_l = &left->branch_info->to;
+	struct addr_map_symbol *to_r = &right->branch_info->to;
+
+	return to_r->addr - to_l->addr;
+}
+
+static int hist_entry__addr_to_snprintf(struct hist_entry *self, char *bf,
+					size_t size, unsigned int width)
+{
+	struct addr_map_symbol *to = &self->branch_info->to;
+	return repsep_snprintf(bf, size, "%#*"PRIx64, width,
+					(uint64_t)to->addr);
+}
+
 struct sort_entry sort_dso_from = {
 	.se_header	= "Source Shared Object",
 	.se_cmp		= sort__dso_from_cmp,
@@ -464,6 +498,20 @@ struct sort_entry sort_sym_to = {
 	.se_width_idx	= HISTC_SYMBOL_TO,
 };
 
+struct sort_entry sort_addr_from = {
+	.se_header	= "Source Address",
+	.se_cmp		= sort__addr_from_cmp,
+	.se_snprintf	= hist_entry__addr_from_snprintf,
+	.se_width_idx	= HISTC_ADDR_FROM,
+};
+
+struct sort_entry sort_addr_to = {
+	.se_header	= "Target Address",
+	.se_cmp		= sort__addr_to_cmp,
+	.se_snprintf	= hist_entry__addr_to_snprintf,
+	.se_width_idx	= HISTC_ADDR_TO,
+};
+
 static int64_t
 sort__mispredict_cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -905,6 +953,8 @@ static struct sort_dimension bstack_sort_dimensions[] = {
 	DIM(SORT_DSO_TO, "dso_to", sort_dso_to),
 	DIM(SORT_SYM_FROM, "symbol_from", sort_sym_from),
 	DIM(SORT_SYM_TO, "symbol_to", sort_sym_to),
+	DIM(SORT_ADDR_FROM, "addr_from", sort_addr_from),
+	DIM(SORT_ADDR_TO, "addr_to", sort_addr_to),
 	DIM(SORT_MISPREDICT, "mispredict", sort_mispredict),
 };
 
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 0815e344f38c..1f945a3b2e5b 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -146,6 +146,8 @@ enum sort_type {
 	SORT_DSO_TO,
 	SORT_SYM_FROM,
 	SORT_SYM_TO,
+	SORT_ADDR_FROM,
+	SORT_ADDR_TO,
 	SORT_MISPREDICT,
 
 	/* memory mode specific sort keys */
-- 
1.7.11.7

