Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964971Ab3E3QMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:12:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50957 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934558Ab3E3QCO (ORCPT
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
Subject: [PATCH 12/66] perf top: Use sort__has_sym
Date: Thu, 30 May 2013 19:00:45 +0300
Message-Id: <1369929699-8724-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

perf top had a similar variable sort_has_symbols for the same purpose.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1365125198-8334-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 12 +++---------
 tools/perf/util/top.h    |  1 -
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2eb272d..df9e06a 100644
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
@@ -1202,12 +1202,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
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
index 7ebf357..f0a8625 100644
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
1.8.1.4

