Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755773Ab3ENCKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:10:06 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60661 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab3ENCJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:09:14 -0400
X-AuditID: 9c93017d-b7b62ae000004f69-71-51919cc5b271
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 9/9] perf top: Reuse report.percent-limit config variable
Date: Tue, 14 May 2013 11:09:07 +0900
Message-Id: <1368497347-9628-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368497347-9628-1-git-send-email-namhyung@kernel.org>
References: <1368497347-9628-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Make the config variable also works for perf top.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-top.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f036af9b6f09..73fd40da47ba 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1032,6 +1032,19 @@ parse_percent_limit(const struct option *opt, const char *arg,
 	return 0;
 }
 
+static int perf_top_config(const char *var, const char *value, void *cb)
+{
+	/* share report config variables */
+	if (!strcmp(var, "report.percent-limit")) {
+		struct perf_top *top = cb;
+
+		top->min_percent = strtof(value, NULL);
+		return 0;
+	}
+
+	return perf_default_config(var, value, cb);
+}
+
 int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int status;
@@ -1132,6 +1145,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	symbol_conf.exclude_other = false;
 
+	perf_config(perf_top_config, &top);
+
 	argc = parse_options(argc, argv, options, top_usage, 0);
 	if (argc)
 		usage_with_options(top_usage, options);
-- 
1.7.11.7

