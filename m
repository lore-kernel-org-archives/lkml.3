Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab3EaLRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:17:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56422 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3EaLQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:16:57 -0400
Date: Fri, 31 May 2013 04:16:29 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-ded19d57a621e92a27a05972949ad3230f84d0b0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1364816125-12212-4-git-send-email-namhyung@kernel.org>
References: <1364816125-12212-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Fix alignment of symbol column when -v is given
Git-Commit-ID: ded19d57a621e92a27a05972949ad3230f84d0b0
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

Commit-ID:  ded19d57a621e92a27a05972949ad3230f84d0b0
Gitweb:     http://git.kernel.org/tip/ded19d57a621e92a27a05972949ad3230f84d0b0
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 1 Apr 2013 20:35:19 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:53 +0300

perf report: Fix alignment of symbol column when -v is given

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
