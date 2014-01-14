Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaANF14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:27:56 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65497 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaANF0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:26:08 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-b4-52d4ca687e1d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Arun Sharma <asharma@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 23/24] perf top: Add top.children config option
Date: Tue, 14 Jan 2014 14:25:56 +0900
Message-Id: <1389677157-30513-24-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
References: <1389677157-30513-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add top.children config option for setting default value of
callchain accumulation.  It affects the output only if one of
-g or --call-graph option is given as well.

A user can write .perfconfig file like below to enable accumulation
by default:

  $ cat ~/.perfconfig
  [top]
  children = true

And it can be disabled through command line:

  $ perf top --no-children

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-top.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 439e000b0f39..2e521d00c0a4 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -87,6 +87,16 @@ static void perf_top__sig_winch(int sig __maybe_unused,
 	perf_top__update_print_entries(top);
 }
 
+static int top__config(const char *var, const char *value, void *cb)
+{
+	if (!strcmp(var, "top.children")) {
+		symbol_conf.cumulate_callchain = perf_config_bool(var, value);
+		return 0;
+	}
+
+	return perf_default_config(var, value, cb);
+}
+
 static int perf_top__parse_source(struct perf_top *top, struct hist_entry *he)
 {
 	struct symbol *sym;
@@ -1125,6 +1135,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (top.evlist == NULL)
 		return -ENOMEM;
 
+	perf_config(top__config, &top);
+
 	argc = parse_options(argc, argv, options, top_usage, 0);
 	if (argc)
 		usage_with_options(top_usage, options);
-- 
1.7.11.7

