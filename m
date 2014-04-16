Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbaDPSlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:41:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755983AbaDPSlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:41:52 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 05/11] perf tools: Add hist.percentage config option
Date: Wed, 16 Apr 2014 20:41:33 +0200
Message-Id: <1397673699-25824-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397673699-25824-1-git-send-email-jolsa@redhat.com>
References: <1397673699-25824-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

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
Link: http://lkml.kernel.org/r/1397145720-8063-6-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-diff.c | 2 ++
 tools/perf/util/config.c  | 4 ++++
 tools/perf/util/hist.c    | 8 ++++++++
 tools/perf/util/hist.h    | 1 +
 4 files changed, 15 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index c903fe1..6ef80f2 100644
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
index 3e0fdd3..24519e1 100644
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
index 3c2dd23..5a89247 100644
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
index a4ec336..5a0343e 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -258,5 +258,6 @@ unsigned int hists__sort_list_width(struct hists *hists);
 struct option;
 int parse_filter_percentage(const struct option *opt __maybe_unused,
 			    const char *arg, int unset __maybe_unused);
+int perf_hist_config(const char *var, const char *value);
 
 #endif	/* __PERF_HIST_H */
-- 
1.8.3.1

