Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030195Ab3BAK5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:57:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52165 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161242Ab3BAK5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:57:13 -0500
Date: Fri, 1 Feb 2013 02:56:55 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-00c7e1f10c6b8ae8a031f5c6a58ecd15d20c52cb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1358845787-1350-19-git-send-email-namhyung@kernel.org>
References: <1358845787-1350-19-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Add report.group config option
Git-Commit-ID: 00c7e1f10c6b8ae8a031f5c6a58ecd15d20c52cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 01 Feb 2013 02:57:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00c7e1f10c6b8ae8a031f5c6a58ecd15d20c52cb
Gitweb:     http://git.kernel.org/tip/00c7e1f10c6b8ae8a031f5c6a58ecd15d20c52cb
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 22 Jan 2013 18:09:46 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 Jan 2013 13:07:49 -0300

perf report: Add report.group config option

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
