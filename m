Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab3JaG42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:56:28 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42171 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab3JaG40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:56:26 -0400
X-AuditID: 9c930197-b7b3eae00000122e-f2-5271ff1788af
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: [PATCH 14/14] perf report: Add -g cumulative option
Date: Thu, 31 Oct 2013 15:56:16 +0900
Message-Id: <1383202576-28141-15-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The -g cumulative option is for showing accumulated overhead (period)
value as well as self overhead.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt |  2 ++
 tools/perf/builtin-report.c              |  3 +++
 tools/perf/util/callchain.c              | 12 +++++++++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 10a279871251..b150bfb734f4 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -130,6 +130,8 @@ OPTIONS
 	- graph: use a graph tree, displaying absolute overhead rates.
 	- fractal: like graph, but displays relative rates. Each branch of
 		 the tree is considered as a new profiled object. +
+        - cumulative: accumulate callchain to parent entry so that they can
+		    show up in the output.
 
 	order can be either:
 	- callee: callee based call graph.
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3b626127c8d6..281053b28898 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1030,6 +1030,9 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 	else if (!strncmp(tok, "fractal", strlen(arg)))
 		callchain_param.mode = CHAIN_GRAPH_REL;
 
+	else if (!strncmp(tok, "cumulative", strlen(arg)))
+		callchain_param.mode = CHAIN_CUMULATIVE;
+
 	else if (!strncmp(tok, "none", strlen(arg))) {
 		callchain_param.mode = CHAIN_NONE;
 		symbol_conf.use_callchain = false;
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index c10052c6e73c..c3c73eb839df 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -150,6 +150,14 @@ sort_chain_graph_rel(struct rb_root *rb_root, struct callchain_root *chain_root,
 	rb_root->rb_node = chain_root->node.rb_root.rb_node;
 }
 
+static void
+sort_chain_cumulative(struct rb_root *rb_root __maybe_unused,
+		      struct callchain_root *chain_root __maybe_unused,
+		      u64 min_hit __maybe_unused,
+		      struct callchain_param *param __maybe_unused)
+{
+}
+
 int callchain_register_param(struct callchain_param *param)
 {
 	switch (param->mode) {
@@ -162,8 +170,10 @@ int callchain_register_param(struct callchain_param *param)
 	case CHAIN_FLAT:
 		param->sort = sort_chain_flat;
 		break;
-	case CHAIN_NONE:
 	case CHAIN_CUMULATIVE:
+		param->sort = sort_chain_cumulative;
+		break;
+	case CHAIN_NONE:
 	default:
 		return -1;
 	}
-- 
1.7.11.7

