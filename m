Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3EaL1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:27:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56596 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3EaL1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:27:05 -0400
Date: Fri, 31 May 2013 04:26:46 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-8f0f684b7b640caeca319f7f4e18474d099d8606@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1365125198-8334-8-git-send-email-namhyung@kernel.org>
References: <1365125198-8334-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Use sort__has_sym
Git-Commit-ID: 8f0f684b7b640caeca319f7f4e18474d099d8606
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

Commit-ID:  8f0f684b7b640caeca319f7f4e18474d099d8606
Gitweb:     http://git.kernel.org/tip/8f0f684b7b640caeca319f7f4e18474d099d8606
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 5 Apr 2013 10:26:37 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:56 +0300

perf top: Use sort__has_sym

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
