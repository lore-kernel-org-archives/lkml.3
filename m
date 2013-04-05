Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab3DEB1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:27:30 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58205 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab3DEB0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:26:46 -0400
X-AuditID: 9c93016f-b7c18ae000002f5f-0e-515e285282a4
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 7/8] perf top: Use sort__has_sym
Date: Fri,  5 Apr 2013 10:26:37 +0900
Message-Id: <1365125198-8334-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1365125198-8334-1-git-send-email-namhyung@kernel.org>
References: <1365125198-8334-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

perf top had a similar variable sort_has_symbols for the same purpose.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-top.c | 12 +++---------
 tools/perf/util/top.h    |  1 -
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index fbb472c52440..fe4acf568483 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -794,7 +794,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 				return;
 		}
 
-		if (top->sort_has_symbols)
+		if (sort__has_sym)
 			perf_top__record_precise_ip(top, he, evsel->idx, ip);
 	}
 
@@ -912,9 +912,9 @@ out_err:
 	return -1;
 }
 
-static int perf_top__setup_sample_type(struct perf_top *top)
+static int perf_top__setup_sample_type(struct perf_top *top __maybe_unused)
 {
-	if (!top->sort_has_symbols) {
+	if (!sort__has_sym) {
 		if (symbol_conf.use_callchain) {
 			ui__error("Selected -g but \"sym\" not present in --sort/-s.");
 			return -EINVAL;
@@ -1203,12 +1203,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	sort__setup_elide(stdout);
 
-	/*
-	 * Avoid annotation data structures overhead when symbols aren't on the
-	 * sort list.
-	 */
-	top.sort_has_symbols = sort_sym.list.next != NULL;
-
 	get_term_dimensions(&top.winsize);
 	if (top.print_entries == 0) {
 		struct sigaction act = {
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 7ebf357dc9e1..f0a862539ba9 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -26,7 +26,6 @@ struct perf_top {
 	int		   print_entries, count_filter, delay_secs;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
 	bool		   use_tui, use_stdio;
-	bool		   sort_has_symbols;
 	bool		   kptr_restrict_warned;
 	bool		   vmlinux_warned;
 	bool		   dump_symtab;
-- 
1.7.11.7

