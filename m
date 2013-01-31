Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3AaRZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 12:25:47 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60085
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438Ab3AaRZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 12:25:39 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/25] perf report: Add report.group config option
Date: Thu, 31 Jan 2013 14:25:22 -0300
Message-Id: <1359653128-10433-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359653128-10433-1-git-send-email-acme@infradead.org>
References: <1359653128-10433-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add report.group config option for setting default value of event
group view.  It affects the report output only if perf.data contains
event group info.

A user can write .perfconfig file like below to enable group view by
default:

  $ cat ~/.perfconfig
  [report]
  group = true

And it can be disabled through command line:

  $ perf report --no-group

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1358845787-1350-19-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9ef3842..0d22187 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -8,6 +8,7 @@
 #include "builtin.h"
 
 #include "util/util.h"
+#include "util/cache.h"
 
 #include "util/annotate.h"
 #include "util/color.h"
@@ -54,6 +55,16 @@ struct perf_report {
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
+static int perf_report_config(const char *var, const char *value, void *cb)
+{
+	if (!strcmp(var, "report.group")) {
+		symbol_conf.event_group = perf_config_bool(var, value);
+		return 0;
+	}
+
+	return perf_default_config(var, value, cb);
+}
+
 static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 					struct addr_location *al,
 					struct perf_sample *sample,
@@ -677,6 +688,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_END()
 	};
 
+	perf_config(perf_report_config, NULL);
+
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
 	if (report.use_stdio)
-- 
1.8.1.1.361.gec3ae6e

