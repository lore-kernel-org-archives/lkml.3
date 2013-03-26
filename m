Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759686Ab3CZMML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:12:11 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43180 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759612Ab3CZMMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:12:09 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-51-51519095596a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] perf report: Fix alignment of symbol column when -v is given
Date: Tue, 26 Mar 2013 21:11:58 +0900
Message-Id: <1364299918-31175-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364299918-31175-1-git-send-email-namhyung@kernel.org>
References: <1364299918-31175-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/util/hist.c | 20 +++++++++++++++++---
 tools/perf/util/sort.c |  2 +-
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b951f4101d7e..7d4bb1f515d1 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -73,8 +73,17 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 	const unsigned int unresolved_col_width = BITS_PER_LONG / 4;
 	u16 len;
 
-	if (h->ms.sym)
-		hists__new_col_len(hists, HISTC_SYMBOL, h->ms.sym->namelen + 4);
+	if (h->ms.sym) {
+		/*
+		 * +4 accounts for '[x] ' priv level info
+		 * +2 accounts for 0x prefix on raw addresses
+		 * +3 accounts for ' y ' symtab origin info
+		 */
+		len = h->ms.sym->namelen + 4;
+		if (verbose)
+			len += BITS_PER_LONG / 4 + 2 + 3;
+		hists__new_col_len(hists, HISTC_SYMBOL, len);
+	}
 	else
 		hists__set_unres_dso_col_len(hists, HISTC_DSO);
 
@@ -94,10 +103,13 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 		int symlen;
 		/*
 		 * +4 accounts for '[x] ' priv level info
-		 * +2 account of 0x prefix on raw addresses
+		 * +2 accounts for 0x prefix on raw addresses
+		 * +3 accounts for ' y ' symtab origin info
 		 */
 		if (h->branch_info->from.sym) {
 			symlen = (int)h->branch_info->from.sym->namelen + 4;
+			if (verbose)
+				symlen += BITS_PER_LONG / 4 + 2 + 3;
 			hists__new_col_len(hists, HISTC_SYMBOL_FROM, symlen);
 
 			symlen = dso__name_len(h->branch_info->from.map->dso);
@@ -110,6 +122,8 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 
 		if (h->branch_info->to.sym) {
 			symlen = (int)h->branch_info->to.sym->namelen + 4;
+			if (verbose)
+				symlen += BITS_PER_LONG / 4 + 2 + 3;
 			hists__new_col_len(hists, HISTC_SYMBOL_TO, symlen);
 
 			symlen = dso__name_len(h->branch_info->to.map->dso);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 988d7ea3ecc2..5df020f3f59b 100644
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

