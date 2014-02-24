Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaBXIL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:11:58 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45796 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaBXIJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:09:40 -0500
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 6/8] perf tools: Add hist.percentage config option
Date: Mon, 24 Feb 2014 17:09:26 +0900
Message-Id: <1393229368-31412-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
References: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-diff.c | 2 ++
 tools/perf/util/config.c  | 4 ++++
 tools/perf/util/hist.c    | 8 ++++++++
 tools/perf/util/hist.h    | 1 +
 4 files changed, 15 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 5f936e63b74c..e7bfb16aabcf 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -1140,6 +1140,8 @@ static int data_init(int argc, const char **argv)
 
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
index 3143b8c14a4b..dacd1e06c94b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -953,3 +953,11 @@ int parse_filter_percentage(const struct option *opt __maybe_unused,
 
 	return 0;
 }
+
+int perf_hist_config(const char *var, const char *value)
+{
+	if (!strcmp(var, "hist.percentage"))
+		return parse_filter_percentage(NULL, value, 0);
+
+	return 0;
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d0178eab31d5..927321512e90 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -242,5 +242,6 @@ unsigned int hists__sort_list_width(struct hists *hists);
 struct option;
 int parse_filter_percentage(const struct option *opt __maybe_unused,
 			    const char *arg, int unset __maybe_unused);
+int perf_hist_config(const char *var, const char *value);
 
 #endif	/* __PERF_HIST_H */
-- 
1.7.11.7

