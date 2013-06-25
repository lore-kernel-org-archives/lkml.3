Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab3FYLy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 07:54:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab3FYLyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 07:54:54 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/5] perf tools: Introduce new -P/--parent-deep report option
Date: Tue, 25 Jun 2013 13:54:12 +0200
Message-Id: <1372161253-22081-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1372161253-22081-1-git-send-email-jolsa@redhat.com>
References: <1372161253-22081-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing new -P/--parent-deep report option. It does the
same as '-p' but it force the deep search of the callchain
and looks for the deepest possible match.

The -p option searches for the first match of the parent
pattern in the callchain.

  $ perf report -i perf.data.delete -p perf_session__delete -s parent

  +  99.51%  [other]
  +   0.46%  perf_session__delete_dead_threads
  +   0.03%  perf_session__delete
  +   0.00%  perf_session__delete_threads

so we got multiple 'different' matches instancies, while
they all belong under perf_session__delete function:

  $ perf report -i perf.data.delete -P perf_session__delete -s parent

  +  99.51%  [other]
  +   0.49%  perf_session__delete

NOTE the 'p' vs 'P' difference in above commands above.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Documentation/perf-report.txt |  5 +++++
 tools/perf/builtin-report.c              | 12 ++++++++++++
 tools/perf/util/machine.c                |  4 +++-
 tools/perf/util/symbol.h                 |  3 ++-
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 66dab74..90d1566 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -96,6 +96,11 @@ OPTIONS
 	information recorded. The pattern is in the exteneded regex format and
 	defaults to "\^sys_|^do_page_fault", see '--sort parent'.
 
+-P::
+--parent-deep=<regex>::
+	Same as '-p' but it force the deep search of the callchain
+	and looks for the deepest possible match.
+
 -x::
 --exclude-other::
         Only display entries with parent-match.
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 6ab49da..8c2c7ce 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -714,6 +714,16 @@ parse_percent_limit(const struct option *opt, const char *str,
 	return 0;
 }
 
+static int
+parent_deep(const struct option *opt __maybe_unused,
+	    const char *str,
+	    int unset __maybe_unused)
+{
+	parent_pattern = str;
+	symbol_conf.parent_deep = true;
+	return 0;
+}
+
 int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_session *session;
@@ -777,6 +787,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
 		   "regex filter to identify parent, see: '--sort parent'"),
+	OPT_CALLBACK('P', "parent-deep", NULL, "regex",
+		     "Enables deep callchain search, implies -p", parent_deep),
 	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
 	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 93527af..5ec5580 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1210,7 +1210,9 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 		thread__find_addr_location(thread, machine, cpumode,
 					   MAP__FUNCTION, ip, &al, NULL);
 		if (al.sym != NULL) {
-			if (sort__has_parent && !*parent &&
+			bool more = symbol_conf.parent_deep || !*parent;
+
+			if (sort__has_parent && more &&
 			    symbol__match_parent_regex(al.sym))
 				*parent = al.sym;
 			if (!symbol_conf.use_callchain)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5f720dc..6023edb 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -98,7 +98,8 @@ struct symbol_conf {
 			annotate_asm_raw,
 			annotate_src,
 			event_group,
-			demangle;
+			demangle,
+			parent_deep;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
1.7.11.7

