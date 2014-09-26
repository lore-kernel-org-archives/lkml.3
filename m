Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaIZUVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:21:30 -0400
Received: from mail.kernel.org ([198.145.19.201]:52774 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030214AbaIZUUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:20:22 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Milian Wolff <mail@milianw.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/10] perf callchain: Move some parser functions to callchain.c
Date: Fri, 26 Sep 2014 17:19:44 -0300
Message-Id: <1411762787-26113-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411762787-26113-1-git-send-email-acme@kernel.org>
References: <1411762787-26113-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

And rename record_callchain_parse() to parse_callchain_record_opt() in
accordance to parse_callchain_report_opt().

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
Link: http://lkml.kernel.org/r/1411434104-5307-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 88 ++-------------------------------------------
 tools/perf/builtin-top.c    |  2 +-
 tools/perf/util/callchain.c | 84 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/callchain.h |  2 +-
 4 files changed, 88 insertions(+), 88 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index fde0df72beaa..0ee647bcd2ec 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -624,90 +624,6 @@ error:
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
@@ -734,7 +650,7 @@ int record_parse_callchain_opt(const struct option *opt __maybe_unused,
 		return 0;
 	}
 
-	ret = record_parse_callchain(arg);
+	ret = parse_callchain_record_opt(arg);
 	if (!ret)
 		callchain_debug();
 
@@ -757,7 +673,7 @@ int record_callchain_opt(const struct option *opt __maybe_unused,
 static int perf_record_config(const char *var, const char *value, void *cb)
 {
 	if (!strcmp(var, "record.call-graph"))
-		return record_parse_callchain(value);
+		return parse_callchain_record_opt(value);
 
 	return perf_default_config(var, value, cb);
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f7003fc0c5f0..9d647a079d02 100644
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
1.9.3

