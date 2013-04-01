Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab3DALgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 07:36:54 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59262 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785Ab3DALf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 07:35:28 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-87-515970fe558a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/9] perf report: Fix alignment of symbol column when -v is given
Date: Mon,  1 Apr 2013 20:35:19 +0900
Message-Id: <1364816125-12212-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
References: <1364816125-12212-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When -v option is given, the symbol sort key prints its address also
but it wasn't properly aligned since hists__calc_col_len() misses the
additional part.  Also it missed 2 spaces for 0x prefix when printing.

  $ perf report --stdio -v -s sym
  # Samples: 133  of event 'cycles'
  # Event count (approx.): 50536717
  #
  # Overhead                          Symbol
  # ........  ..............................
  #
      12.20%  0xffffffff81384c50 v [k] intel_idle
       7.62%  0xffffffff8170976a v [k] ftrace_caller
       7.02%  0x2d986d         B [.] 0x00000000002d986d

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 26 +++++++++++++++-----------
 tools/perf/util/sort.c |  2 +-
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 514fc0470e38..72b4eec820c3 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -70,9 +70,17 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 	int symlen;
 	u16 len;
 
-	if (h->ms.sym)
-		hists__new_col_len(hists, HISTC_SYMBOL, h->ms.sym->namelen + 4);
-	else {
+	/*
+	 * +4 accounts for '[x] ' priv level info
+	 * +2 accounts for 0x prefix on raw addresses
+	 * +3 accounts for ' y ' symtab origin info
+	 */
+	if (h->ms.sym) {
+		symlen = h->ms.sym->namelen + 4;
+		if (verbose)
+			symlen += BITS_PER_LONG / 4 + 2 + 3;
+		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
+	} else {
 		symlen = unresolved_col_width + 4 + 2;
 		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
 		hists__set_unres_dso_col_len(hists, HISTC_DSO);
@@ -91,12 +99,10 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 		hists__new_col_len(hists, HISTC_PARENT, h->parent->namelen);
 
 	if (h->branch_info) {
-		/*
-		 * +4 accounts for '[x] ' priv level info
-		 * +2 account of 0x prefix on raw addresses
-		 */
 		if (h->branch_info->from.sym) {
 			symlen = (int)h->branch_info->from.sym->namelen + 4;
+			if (verbose)
+				symlen += BITS_PER_LONG / 4 + 2 + 3;
 			hists__new_col_len(hists, HISTC_SYMBOL_FROM, symlen);
 
 			symlen = dso__name_len(h->branch_info->from.map->dso);
@@ -109,6 +115,8 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 
 		if (h->branch_info->to.sym) {
 			symlen = (int)h->branch_info->to.sym->namelen + 4;
+			if (verbose)
+				symlen += BITS_PER_LONG / 4 + 2 + 3;
 			hists__new_col_len(hists, HISTC_SYMBOL_TO, symlen);
 
 			symlen = dso__name_len(h->branch_info->to.map->dso);
@@ -121,10 +129,6 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 	}
 
 	if (h->mem_info) {
-		/*
-		 * +4 accounts for '[x] ' priv level info
-		 * +2 account of 0x prefix on raw addresses
-		 */
 		if (h->mem_info->daddr.sym) {
 			symlen = (int)h->mem_info->daddr.sym->namelen + 4
 			       + unresolved_col_width + 2;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 5f52d492590c..16d5e38befe5 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -194,7 +194,7 @@ static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
 	if (verbose) {
 		char o = map ? dso__symtab_origin(map->dso) : '!';
 		ret += repsep_snprintf(bf, size, "%-#*llx %c ",
-				       BITS_PER_LONG / 4, ip, o);
+				       BITS_PER_LONG / 4 + 2, ip, o);
 	}
 
 	ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", level);
-- 
1.7.11.7

