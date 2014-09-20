Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbaITQT0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:19:26 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:52261 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbaITQSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:18:44 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Milian Wolff <mail@milianw.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] perf tools: Introduce perf_callchain_config()
Date: Sun, 21 Sep 2014 01:18:05 +0900
Message-Id: <1411229886-24390-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
References: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for following config options to ~/.perfconfig file.

  [call-graph]
    record-mode = dwarf
    dump-size = 8192
    print-type = fractal
    order = callee
    threshold = 0.5
    print-limit = 128
    sort-key = function

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/callchain.c | 33 +++++++++++++++++++++++++++++++++
 tools/perf/util/callchain.h |  1 +
 tools/perf/util/config.c    |  3 +++
 3 files changed, 37 insertions(+)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index ba7297230143..ee489a1e3f4c 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -168,6 +168,39 @@ parse_callchain_report_opt(const char *arg)
 	return 0;
 }
 
+int perf_callchain_config(const char *var, const char *value)
+{
+	if (prefixcmp(var, "call-graph."))
+		return 0;
+	var += 11; /* strlen("call-graph.") == 11 */
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
+		return parse_callchain_report_opt(value);
+	if (!strcmp(var, "order"))
+		return parse_callchain_report_opt(value);
+	if (!strcmp(var, "threshold"))
+		return parse_callchain_report_opt(value);
+	if (!strcmp(var, "print-limit"))
+		return parse_callchain_report_opt(value);
+	if (!strcmp(var, "sort-key"))
+		return parse_callchain_report_opt(value);
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
2.1.0

