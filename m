Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847Ab3E3QMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:12:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50966 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934583Ab3E3QCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/66] perf report: Fix alignment of symbol column when -v is given
Date: Thu, 30 May 2013 19:00:37 +0300
Message-Id: <1369929699-8724-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When -v option is given, the symbol sort key prints its address also but
it wasn't properly aligned since hists__calc_col_len() misses the
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
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1364816125-12212-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c | 26 +++++++++++++++-----------
 tools/perf/util/sort.c |  2 +-
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 514fc04..72b4eec 100644
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
index 5f52d49..16d5e38 100644
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
1.8.1.4

