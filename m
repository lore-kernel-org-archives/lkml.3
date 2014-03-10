Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaCJHpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 03:45:07 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52385 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbaCJHoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 03:44:06 -0400
X-AuditID: 9c93017d-b7c89ae000006ae1-ed-531d6d4342c9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 7/9] perf tools: Add hist.percentage config option
Date: Mon, 10 Mar 2014 16:43:58 +0900
Message-Id: <1394437440-11609-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
References: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
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

Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-diff.c | 2 ++
 tools/perf/util/config.c  | 4 ++++
 tools/perf/util/hist.c    | 8 ++++++++
 tools/perf/util/hist.h    | 1 +
 4 files changed, 15 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index c903fe13c173..6ef80f22c1e2 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -1134,6 +1134,8 @@ static int data_init(int argc, const char **argv)
 
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
index 6e7eb53d4bcc..a0b32df4cd88 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -956,3 +956,11 @@ int parse_filter_percentage(const struct option *opt __maybe_unused,
 
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
index a4ec336ae3fe..5a0343eb22e2 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -258,5 +258,6 @@ unsigned int hists__sort_list_width(struct hists *hists);
 struct option;
 int parse_filter_percentage(const struct option *opt __maybe_unused,
 			    const char *arg, int unset __maybe_unused);
+int perf_hist_config(const char *var, const char *value);
 
 #endif	/* __PERF_HIST_H */
-- 
1.7.11.7

