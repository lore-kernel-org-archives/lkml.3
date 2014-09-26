Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbaIZUU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:20:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:52789 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbaIZUUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:20:25 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Milian Wolff <mail@milianw.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/10] perf tools: Introduce perf_callchain_config()
Date: Fri, 26 Sep 2014 17:19:45 -0300
Message-Id: <1411762787-26113-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411762787-26113-1-git-send-email-acme@kernel.org>
References: <1411762787-26113-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

This patch adds support for following config options to ~/.perfconfig file.

  [call-graph]
    record-mode = dwarf
    dump-size = 8192
    print-type = fractal
    order = callee
    threshold = 0.5
    print-limit = 128
    sort-key = function

Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Milian Wolff <mail@milianw.de>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1411434104-5307-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/callchain.c | 109 ++++++++++++++++++++++++++++++++++++--------
 tools/perf/util/callchain.h |   1 +
 tools/perf/util/config.c    |   3 ++
 3 files changed, 94 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index ba7297230143..c84d3f8dcb75 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -109,6 +109,49 @@ int parse_callchain_record_opt(const char *arg)
 	return ret;
 }
 
+static int parse_callchain_mode(const char *value)
+{
+	if (!strncmp(value, "graph", strlen(value))) {
+		callchain_param.mode = CHAIN_GRAPH_ABS;
+		return 0;
+	}
+	if (!strncmp(value, "flat", strlen(value))) {
+		callchain_param.mode = CHAIN_FLAT;
+		return 0;
+	}
+	if (!strncmp(value, "fractal", strlen(value))) {
+		callchain_param.mode = CHAIN_GRAPH_REL;
+		return 0;
+	}
+	return -1;
+}
+
+static int parse_callchain_order(const char *value)
+{
+	if (!strncmp(value, "caller", strlen(value))) {
+		callchain_param.order = ORDER_CALLER;
+		return 0;
+	}
+	if (!strncmp(value, "callee", strlen(value))) {
+		callchain_param.order = ORDER_CALLEE;
+		return 0;
+	}
+	return -1;
+}
+
+static int parse_callchain_sort_key(const char *value)
+{
+	if (!strncmp(value, "function", strlen(value))) {
+		callchain_param.key = CCKEY_FUNCTION;
+		return 0;
+	}
+	if (!strncmp(value, "address", strlen(value))) {
+		callchain_param.key = CCKEY_ADDRESS;
+		return 0;
+	}
+	return -1;
+}
+
 int
 parse_callchain_report_opt(const char *arg)
 {
@@ -128,25 +171,12 @@ parse_callchain_report_opt(const char *arg)
 			return 0;
 		}
 
-		/* try to get the output mode */
-		if (!strncmp(tok, "graph", strlen(tok)))
-			callchain_param.mode = CHAIN_GRAPH_ABS;
-		else if (!strncmp(tok, "flat", strlen(tok)))
-			callchain_param.mode = CHAIN_FLAT;
-		else if (!strncmp(tok, "fractal", strlen(tok)))
-			callchain_param.mode = CHAIN_GRAPH_REL;
-		/* try to get the call chain order */
-		else if (!strncmp(tok, "caller", strlen(tok)))
-			callchain_param.order = ORDER_CALLER;
-		else if (!strncmp(tok, "callee", strlen(tok)))
-			callchain_param.order = ORDER_CALLEE;
-		/* try to get the sort key */
-		else if (!strncmp(tok, "function", strlen(tok)))
-			callchain_param.key = CCKEY_FUNCTION;
-		else if (!strncmp(tok, "address", strlen(tok)))
-			callchain_param.key = CCKEY_ADDRESS;
-		/* try to get the min percent */
-		else if (!minpcnt_set) {
+		if (!parse_callchain_mode(tok) ||
+		    !parse_callchain_order(tok) ||
+		    !parse_callchain_sort_key(tok)) {
+			/* parsing ok - move on to the next */
+		} else if (!minpcnt_set) {
+			/* try to get the min percent */
 			callchain_param.min_percent = strtod(tok, &endptr);
 			if (tok == endptr)
 				return -1;
@@ -168,6 +198,47 @@ parse_callchain_report_opt(const char *arg)
 	return 0;
 }
 
+int perf_callchain_config(const char *var, const char *value)
+{
+	char *endptr;
+
+	if (prefixcmp(var, "call-graph."))
+		return 0;
+	var += sizeof("call-graph.") - 1;
+
+	if (!strcmp(var, "record-mode"))
+		return parse_callchain_record_opt(value);
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
+	if (!strcmp(var, "dump-size")) {
+		unsigned long size = 0;
+		int ret;
+
+		ret = get_stack_size(value, &size);
+		callchain_param.dump_size = size;
+
+		return ret;
+	}
+#endif
+	if (!strcmp(var, "print-type"))
+		return parse_callchain_mode(value);
+	if (!strcmp(var, "order"))
+		return parse_callchain_order(value);
+	if (!strcmp(var, "sort-key"))
+		return parse_callchain_sort_key(value);
+	if (!strcmp(var, "threshold")) {
+		callchain_param.min_percent = strtod(value, &endptr);
+		if (value == endptr)
+			return -1;
+	}
+	if (!strcmp(var, "print-limit")) {
+		callchain_param.print_limit = strtod(value, &endptr);
+		if (value == endptr)
+			return -1;
+	}
+
+	return 0;
+}
+
 static void
 rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 		    enum chain_mode mode)
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 8adfbf0bab5c..2a1f5a46543a 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -170,6 +170,7 @@ int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *
 extern const char record_callchain_help[];
 int parse_callchain_record_opt(const char *arg);
 int parse_callchain_report_opt(const char *arg);
+int perf_callchain_config(const char *var, const char *value);
 
 static inline void callchain_cursor_snapshot(struct callchain_cursor *dest,
 					     struct callchain_cursor *src)
diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 9970b8b0190b..953512ed72ba 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -396,6 +396,9 @@ int perf_default_config(const char *var, const char *value,
 	if (!prefixcmp(var, "ui."))
 		return perf_ui_config(var, value);
 
+	if (!prefixcmp(var, "call-graph."))
+		return perf_callchain_config(var, value);
+
 	/* Add other config variables here. */
 	return 0;
 }
-- 
1.9.3

