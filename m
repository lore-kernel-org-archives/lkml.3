Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbaITQT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 12:19:56 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54829 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbaITQSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 12:18:41 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Milian Wolff <mail@milianw.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] perf tools: Move some callchain parser functions to callchain.c
Date: Sun, 21 Sep 2014 01:18:04 +0900
Message-Id: <1411229886-24390-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
References: <1411229886-24390-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And rename record_callchain_parse() to parse_callchain_record_opt() in
accordance to parse_callchain_report_opt().

Signek-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c | 88 ++-------------------------------------------
 tools/perf/builtin-top.c    |  2 +-
 tools/perf/util/callchain.c | 84 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/callchain.h |  2 +-
 4 files changed, 88 insertions(+), 88 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4de632cd677b..12e1f2255f89 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -621,90 +621,6 @@ error:
 	return ret;
 }
 
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
-static int get_stack_size(char *str, unsigned long *_size)
-{
-	char *endptr;
-	unsigned long size;
-	unsigned long max_size = round_down(USHRT_MAX, sizeof(u64));
-
-	size = strtoul(str, &endptr, 0);
-
-	do {
-		if (*endptr)
-			break;
-
-		size = round_up(size, sizeof(u64));
-		if (!size || size > max_size)
-			break;
-
-		*_size = size;
-		return 0;
-
-	} while (0);
-
-	pr_err("callchain: Incorrect stack dump size (max %ld): %s\n",
-	       max_size, str);
-	return -1;
-}
-#endif /* HAVE_DWARF_UNWIND_SUPPORT */
-
-int record_parse_callchain(const char *arg)
-{
-	char *tok, *name, *saveptr = NULL;
-	char *buf;
-	int ret = -1;
-
-	/* We need buffer that we know we can write to. */
-	buf = malloc(strlen(arg) + 1);
-	if (!buf)
-		return -ENOMEM;
-
-	strcpy(buf, arg);
-
-	tok = strtok_r((char *)buf, ",", &saveptr);
-	name = tok ? : (char *)buf;
-
-	do {
-		/* Framepointer style */
-		if (!strncmp(name, "fp", sizeof("fp"))) {
-			if (!strtok_r(NULL, ",", &saveptr)) {
-				callchain_param.record_mode = CALLCHAIN_FP;
-				ret = 0;
-			} else
-				pr_err("callchain: No more arguments "
-				       "needed for -g fp\n");
-			break;
-
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
-		/* Dwarf style */
-		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
-			const unsigned long default_stack_dump_size = 8192;
-
-			ret = 0;
-			callchain_param.record_mode = CALLCHAIN_DWARF;
-			callchain_param.dump_size = default_stack_dump_size;
-
-			tok = strtok_r(NULL, ",", &saveptr);
-			if (tok) {
-				unsigned long size = 0;
-
-				ret = get_stack_size(tok, &size);
-				callchain_param.dump_size = size;
-			}
-#endif /* HAVE_DWARF_UNWIND_SUPPORT */
-		} else {
-			pr_err("callchain: Unknown --call-graph option "
-			       "value: %s\n", arg);
-			break;
-		}
-
-	} while (0);
-
-	free(buf);
-	return ret;
-}
-
 static void callchain_debug(void)
 {
 	static const char *str[CALLCHAIN_MAX] = { "NONE", "FP", "DWARF" };
@@ -731,7 +647,7 @@ int record_parse_callchain_opt(const struct option *opt __maybe_unused,
 		return 0;
 	}
 
-	ret = record_parse_callchain(arg);
+	ret = parse_callchain_record_opt(arg);
 	if (!ret)
 		callchain_debug();
 
@@ -754,7 +670,7 @@ int record_callchain_opt(const struct option *opt __maybe_unused,
 static int perf_record_config(const char *var, const char *value, void *cb)
 {
 	if (!strcmp(var, "record.call-graph"))
-		return record_parse_callchain(value);
+		return parse_callchain_record_opt(value);
 
 	return perf_default_config(var, value, cb);
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 200a44b370c3..45a3a461286f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1021,7 +1021,7 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 static int perf_top_config(const char *var, const char *value, void *cb)
 {
 	if (!strcmp(var, "top.call-graph"))
-		return record_parse_callchain(value);
+		return parse_callchain_record_opt(value);
 	if (!strcmp(var, "top.children")) {
 		symbol_conf.cumulate_callchain = perf_config_bool(var, value);
 		return 0;
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 08f0fbf5527c..ba7297230143 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -25,6 +25,90 @@
 
 __thread struct callchain_cursor callchain_cursor;
 
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
+static int get_stack_size(const char *str, unsigned long *_size)
+{
+	char *endptr;
+	unsigned long size;
+	unsigned long max_size = round_down(USHRT_MAX, sizeof(u64));
+
+	size = strtoul(str, &endptr, 0);
+
+	do {
+		if (*endptr)
+			break;
+
+		size = round_up(size, sizeof(u64));
+		if (!size || size > max_size)
+			break;
+
+		*_size = size;
+		return 0;
+
+	} while (0);
+
+	pr_err("callchain: Incorrect stack dump size (max %ld): %s\n",
+	       max_size, str);
+	return -1;
+}
+#endif /* HAVE_DWARF_UNWIND_SUPPORT */
+
+int parse_callchain_record_opt(const char *arg)
+{
+	char *tok, *name, *saveptr = NULL;
+	char *buf;
+	int ret = -1;
+
+	/* We need buffer that we know we can write to. */
+	buf = malloc(strlen(arg) + 1);
+	if (!buf)
+		return -ENOMEM;
+
+	strcpy(buf, arg);
+
+	tok = strtok_r((char *)buf, ",", &saveptr);
+	name = tok ? : (char *)buf;
+
+	do {
+		/* Framepointer style */
+		if (!strncmp(name, "fp", sizeof("fp"))) {
+			if (!strtok_r(NULL, ",", &saveptr)) {
+				callchain_param.record_mode = CALLCHAIN_FP;
+				ret = 0;
+			} else
+				pr_err("callchain: No more arguments "
+				       "needed for -g fp\n");
+			break;
+
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
+		/* Dwarf style */
+		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
+			const unsigned long default_stack_dump_size = 8192;
+
+			ret = 0;
+			callchain_param.record_mode = CALLCHAIN_DWARF;
+			callchain_param.dump_size = default_stack_dump_size;
+
+			tok = strtok_r(NULL, ",", &saveptr);
+			if (tok) {
+				unsigned long size = 0;
+
+				ret = get_stack_size(tok, &size);
+				callchain_param.dump_size = size;
+			}
+#endif /* HAVE_DWARF_UNWIND_SUPPORT */
+		} else {
+			pr_err("callchain: Unknown --call-graph option "
+			       "value: %s\n", arg);
+			break;
+		}
+
+	} while (0);
+
+	free(buf);
+	return ret;
+}
+
 int
 parse_callchain_report_opt(const char *arg)
 {
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 819ae4f61e08..8adfbf0bab5c 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -157,7 +157,6 @@ static inline void callchain_cursor_advance(struct callchain_cursor *cursor)
 struct option;
 struct hist_entry;
 
-int record_parse_callchain(const char *arg);
 int record_parse_callchain_opt(const struct option *opt, const char *arg, int unset);
 int record_callchain_opt(const struct option *opt, const char *arg, int unset);
 
@@ -169,6 +168,7 @@ int fill_callchain_info(struct addr_location *al, struct callchain_cursor_node *
 			bool hide_unresolved);
 
 extern const char record_callchain_help[];
+int parse_callchain_record_opt(const char *arg);
 int parse_callchain_report_opt(const char *arg);
 
 static inline void callchain_cursor_snapshot(struct callchain_cursor *dest,
-- 
2.1.0

