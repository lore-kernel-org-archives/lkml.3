Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaBRVLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:11:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35735 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaBRVJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:09:13 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/32] perf callchain: Introduce HAVE_DWARF_UNWIND_SUPPORT macro
Date: Tue, 18 Feb 2014 18:08:35 -0300
Message-Id: <1392757731-32619-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Introducing global macro HAVE_DWARF_UNWIND_SUPPORT to indicate we have
dwarf unwind support. Any library providing the dwarf post unwind
support will enable this macro.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389098853-14466-12-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c     | 10 +++++-----
 tools/perf/config/Makefile      |  2 +-
 tools/perf/tests/builtin-test.c |  2 +-
 tools/perf/tests/tests.h        |  2 +-
 tools/perf/util/unwind.h        |  7 +++++--
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7b8f0e6068b3..eb524f91bffe 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -649,7 +649,7 @@ error:
 	return ret;
 }
 
-#ifdef HAVE_LIBUNWIND_SUPPORT
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
 static int get_stack_size(char *str, unsigned long *_size)
 {
 	char *endptr;
@@ -675,7 +675,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 	       max_size, str);
 	return -1;
 }
-#endif /* HAVE_LIBUNWIND_SUPPORT */
+#endif /* HAVE_DWARF_UNWIND_SUPPORT */
 
 int record_parse_callchain(const char *arg, struct record_opts *opts)
 {
@@ -704,7 +704,7 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 				       "needed for -g fp\n");
 			break;
 
-#ifdef HAVE_LIBUNWIND_SUPPORT
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
 		/* Dwarf style */
 		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
 			const unsigned long default_stack_dump_size = 8192;
@@ -720,7 +720,7 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 				ret = get_stack_size(tok, &size);
 				opts->stack_dump_size = size;
 			}
-#endif /* HAVE_LIBUNWIND_SUPPORT */
+#endif /* HAVE_DWARF_UNWIND_SUPPORT */
 		} else {
 			pr_err("callchain: Unknown --call-graph option "
 			       "value: %s\n", arg);
@@ -823,7 +823,7 @@ static struct record record = {
 
 #define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
 
-#ifdef HAVE_LIBUNWIND_SUPPORT
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
 const char record_callchain_help[] = CALLCHAIN_HELP "fp dwarf";
 #else
 const char record_callchain_help[] = CALLCHAIN_HELP "fp";
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c48d44958172..1686583ff7fc 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -338,7 +338,7 @@ ifndef NO_LIBUNWIND
       CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
     endif
 
-    CFLAGS += -DHAVE_LIBUNWIND_SUPPORT
+    CFLAGS += -DHAVE_DWARF_UNWIND_SUPPORT -DHAVE_LIBUNWIND_SUPPORT
     EXTLIBS += $(LIBUNWIND_LIBS)
     CFLAGS += $(LIBUNWIND_CFLAGS)
     LDFLAGS += $(LIBUNWIND_LDFLAGS)
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index f5a6ffba8a47..b11bf8a08430 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -116,7 +116,7 @@ static struct test {
 		.func = test__parse_no_sample_id_all,
 	},
 #if defined(__x86_64__) || defined(__i386__)
-#ifdef HAVE_LIBUNWIND_SUPPORT
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
 	{
 		.desc = "Test dwarf unwind",
 		.func = test__dwarf_unwind,
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 8979309876a7..a24795ca002d 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -43,7 +43,7 @@ int test__parse_no_sample_id_all(void);
 int test__dwarf_unwind(void);
 
 #if defined(__x86_64__) || defined(__i386__)
-#ifdef HAVE_LIBUNWIND_SUPPORT
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
 struct thread;
 struct perf_sample;
 int test__arch_unwind_sample(struct perf_sample *sample,
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index 18f33b475c46..b031316f221a 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -13,12 +13,15 @@ struct unwind_entry {
 
 typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
 
-#ifdef HAVE_LIBUNWIND_SUPPORT
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine,
 			struct thread *thread,
 			struct perf_sample *data, int max_stack);
+/* libunwind specific */
+#ifdef HAVE_LIBUNWIND_SUPPORT
 int libunwind__arch_reg_id(int regnum);
+#endif
 #else
 static inline int
 unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
@@ -30,5 +33,5 @@ unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 {
 	return 0;
 }
-#endif /* HAVE_LIBUNWIND_SUPPORT */
+#endif /* HAVE_DWARF_UNWIND_SUPPORT */
 #endif /* __UNWIND_H */
-- 
1.8.1.4

