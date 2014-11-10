Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaKJVRB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:17:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:46712 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbaKJVQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:16:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,355,1413270000"; 
   d="scan'208";a="620185102"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V2 3/3] perf tool: Add sort key addr for perf diff
Date: Mon, 10 Nov 2014 16:01:20 -0500
Message-Id: <1415653280-1374-4-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415653280-1374-1-git-send-email-kan.liang@intel.com>
References: <1415653280-1374-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

Sometime, especially debugging scaling issue, the function level diff
may be high granularity. The user may want to do deeper diff analysis
for some cache or lock issue. The "addr" key can let the user sort
differential profile by ips. This feature should only work when the
perf.data comes from same binary.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/Documentation/perf-diff.txt |  7 +++++--
 tools/perf/builtin-diff.c              |  2 +-
 tools/perf/util/hist.c                 |  5 +++--
 tools/perf/util/hist.h                 |  1 +
 tools/perf/util/sort.c                 | 29 +++++++++++++++++++++++++++++
 tools/perf/util/sort.h                 |  2 ++
 6 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index e463caa..400b0ec 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -50,8 +50,11 @@ OPTIONS
 
 -s::
 --sort=::
-	Sort by key(s): pid, comm, dso, symbol, cpu, parent, srcline.
-	Please see description of --sort in the perf-report man page.
+	Sort by key(s): pid, comm, dso, symbol, cpu, parent, srcline, addr.
+
+	- addr: Address executed at the time of sample (for same binary compare)
+
+	For other keys, please see description of --sort in the perf-report man page.
 
 -t::
 --field-separator=::
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 1ce425d..b0a06d2 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -744,7 +744,7 @@ static const struct option options[] = {
 	OPT_STRING('S', "symbols", &symbol_conf.sym_list_str, "symbol[,symbol...]",
 		   "only consider these symbols"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
-		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, ..."
+		   "sort by key(s): pid, comm, dso, symbol, parent, cpu, srcline, addr, ..."
 		   " Please refer the man page for the complete list."),
 	OPT_STRING('t', "field-separator", &symbol_conf.field_sep, "separator",
 		   "separator for columns, no spaces will be added between "
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6e88b9e..f0b3777 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -67,13 +67,14 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 		symlen = h->ms.sym->namelen + 4;
 		if (verbose)
 			symlen += BITS_PER_LONG / 4 + 2 + 3;
-		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
 	} else {
 		symlen = unresolved_col_width + 4 + 2;
-		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
 		hists__set_unres_dso_col_len(hists, HISTC_DSO);
 	}
 
+	hists__new_col_len(hists, HISTC_SYMBOL, symlen);
+	hists__new_col_len(hists, HISTC_ADDR, symlen);
+
 	len = thread__comm_len(h->thread);
 	if (hists__new_col_len(hists, HISTC_COMM, len))
 		hists__set_col_len(hists, HISTC_THREAD, len + 6);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d0ef9a1..eb4bb7d 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -24,6 +24,7 @@ enum hist_filter {
 
 enum hist_column {
 	HISTC_SYMBOL,
+	HISTC_ADDR,
 	HISTC_DSO,
 	HISTC_THREAD,
 	HISTC_COMM,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index ee235ab..604a910 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -280,6 +280,34 @@ struct sort_entry sort_sym = {
 	.se_width_idx	= HISTC_SYMBOL,
 };
 
+static int64_t
+sort__addr_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return _sort__addr_cmp(left->ip, right->ip);
+}
+
+static int hist_entry__addr_snprintf(struct hist_entry *he, char *bf,
+				    size_t size, unsigned int width)
+{
+	struct map *map = he->ms.map;
+	u64 ip;
+
+	if (map)
+		ip = map->unmap_ip(map, he->ip);
+	else
+		ip = he->ip;
+
+	return _hist_entry__sym_snprintf(NULL, NULL, ip,
+					 he->level, bf, size, width);
+}
+
+struct sort_entry sort_addr = {
+	.se_header	= "Addr",
+	.se_cmp		= sort__addr_cmp,
+	.se_snprintf	= hist_entry__addr_snprintf,
+	.se_width_idx	= HISTC_ADDR,
+};
+
 /* --sort srcline */
 
 static int64_t
@@ -1170,6 +1198,7 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_COMM, "comm", sort_comm),
 	DIM(SORT_DSO, "dso", sort_dso),
 	DIM(SORT_SYM, "symbol", sort_sym),
+	DIM(SORT_ADDR, "addr", sort_addr),
 	DIM(SORT_PARENT, "parent", sort_parent),
 	DIM(SORT_CPU, "cpu", sort_cpu),
 	DIM(SORT_SRCLINE, "srcline", sort_srcline),
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index c03e4ff..56a7a0f 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -38,6 +38,7 @@ extern enum sort_mode sort__mode;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
 extern struct sort_entry sort_sym;
+extern struct sort_entry sort_addr;
 extern struct sort_entry sort_parent;
 extern struct sort_entry sort_dso_from;
 extern struct sort_entry sort_dso_to;
@@ -161,6 +162,7 @@ enum sort_type {
 	SORT_COMM,
 	SORT_DSO,
 	SORT_SYM,
+	SORT_ADDR,
 	SORT_PARENT,
 	SORT_CPU,
 	SORT_SRCLINE,
-- 
1.8.3.2

