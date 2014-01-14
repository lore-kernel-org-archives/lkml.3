Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaANEoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:44:14 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50909 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaANEnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:43:22 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-6e-52d4c068e2a0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/5] perf report: Add --percentage option
Date: Tue, 14 Jan 2014 13:43:17 +0900
Message-Id: <1389674599-28227-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389674599-28227-1-git-send-email-namhyung@kernel.org>
References: <1389674599-28227-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The --percentage option is for controlling overhead percentage
displayed.  It can only receive either of "relative" or "absolute".

"relative" means it's relative to filtered entries only so that the
sum of shown entries will be always 100%.  "absolute" means it retains
original value before and after the filter applied.

  $ perf report -s comm
  # Overhead       Command
  # ........  ............
  #
      74.19%           cc1
       7.61%           gcc
       6.11%            as
       4.35%            sh
       4.14%          make
       1.13%        fixdep
  ...

  $ perf report -s comm -c cc1,gcc --percentage absolute
  # Overhead       Command
  # ........  ............
  #
      74.19%           cc1
       7.61%           gcc

  $ perf report -s comm -c cc1,gcc --percentage relative
  # Overhead       Command
  # ........  ............
  #
      90.69%           cc1
       9.31%           gcc

Note that it has zero effect if no filter was applied.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt |  6 ++++++
 tools/perf/builtin-report.c              | 16 ++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 8eab8a4bdeb8..9a67a42356d6 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -237,6 +237,12 @@ OPTIONS
 	Do not show entries which have an overhead under that percent.
 	(Default: 0).
 
+--percentage::
+	Determine how to display the overhead percentage of filtered entries.
+	"relative" means it's relative to filtered entries only so that the
+	sum of shown entries will be always 100%.  "absolute" means it retains
+	original value before and after the filter applied.
+
 --header::
 	Show header information in the perf.data file.  This includes
 	various information like hostname, OS and perf version, cpu/mem
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 664a3dcdf0e0..535bd6745355 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -717,6 +717,20 @@ parse_percent_limit(const struct option *opt, const char *str,
 	return 0;
 }
 
+static int
+parse_percentage(const struct option *opt __maybe_unused, const char *str,
+		 int unset __maybe_unused)
+{
+	if (!strcmp(str, "relative"))
+		symbol_conf.filter_relative = true;
+	else if (!strcmp(str, "absolute"))
+		symbol_conf.filter_relative = false;
+	else
+		return -1;
+
+	return 0;
+}
+
 int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_session *session;
@@ -839,6 +853,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
 	OPT_CALLBACK(0, "percent-limit", &report, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
+	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
+		     "how to display percentage of filtered entries", parse_percentage),
 	OPT_END()
 	};
 	struct perf_data_file file = {
-- 
1.7.11.7

