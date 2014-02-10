Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaBJCtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:49:06 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:54735 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbaBJCre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:47:34 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-c7-52f83dc22dbb
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 6/8] perf tools: Add hist.percentage config option
Date: Mon, 10 Feb 2014 11:47:23 +0900
Message-Id: <1392000446-14744-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add hist.percentage option for setting default value of the
symbol_conf.filter_relative.  It affects the output of various perf
commands (like perf report, top and diff) only if filter(s) applied.

An user can write .perfconfig file like below to show absolute
percentage of filtered entries by default:

  $ cat ~/.perfconfig
  [hist]
  percentage = absolute

And it can be changed through command line:

  $ perf report --percentage relative

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c |  2 ++
 tools/perf/util/config.c  |  4 ++++
 tools/perf/util/hist.c    | 14 ++++++++++++++
 tools/perf/util/hist.h    |  3 +++
 4 files changed, 23 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 2c7406d9eb5d..839c8c0b1060 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -1153,6 +1153,8 @@ static int data_init(int argc, const char **argv)
 
 int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	perf_config(perf_default_config, NULL);
+
 	sort_order = diff__default_sort_order;
 	argc = parse_options(argc, argv, options, diff_usage, 0);
 
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 3e0fdd369ccb..24519e14ac56 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -11,6 +11,7 @@
 #include "util.h"
 #include "cache.h"
 #include "exec_cmd.h"
+#include "util/hist.h"  /* perf_hist_config */
 
 #define MAXNAME (256)
 
@@ -355,6 +356,9 @@ int perf_default_config(const char *var, const char *value,
 	if (!prefixcmp(var, "core."))
 		return perf_default_core_config(var, value);
 
+	if (!prefixcmp(var, "hist."))
+		return perf_hist_config(var, value);
+
 	/* Add other config variables here. */
 	return 0;
 }
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 3d9cdf97cfce..84adde197c05 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -934,3 +934,17 @@ int hists__link(struct hists *leader, struct hists *other)
 
 	return 0;
 }
+
+int perf_hist_config(const char *var, const char *value)
+{
+	if (!strcmp(var, "hist.percentage")) {
+		if (!strcmp(value, "relative"))
+			symbol_conf.filter_relative = true;
+		else if (!strcmp(value, "absolute"))
+			symbol_conf.filter_relative = false;
+		else
+			return -1;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2f5686f4031b..cb8250d078b1 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -237,4 +237,7 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 #endif
 
 unsigned int hists__sort_list_width(struct hists *hists);
+
+int perf_hist_config(const char *var, const char *value);
+
 #endif	/* __PERF_HIST_H */
-- 
1.7.11.7

