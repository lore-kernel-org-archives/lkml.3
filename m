Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaAGMss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:48:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbaAGMsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:48:22 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 11/16] perf tools: Introduce HAVE_DWARF_UNWIND_SUPPORT macro
Date: Tue,  7 Jan 2014 13:47:28 +0100
Message-Id: <1389098853-14466-12-git-send-email-jolsa@redhat.com>
In-Reply-To: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing global macro HAVE_DWARF_UNWIND_SUPPORT to indicate
we have dwarf unwind support. Any library providing the dwarf
post unwind support will enable this macro.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/builtin-record.c     | 10 +++++-----
 tools/perf/config/Makefile      |  2 +-
 tools/perf/tests/builtin-test.c |  2 +-
 tools/perf/tests/tests.h        |  2 +-
 tools/perf/util/unwind.h        |  7 +++++--
 5 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index cb00b53..349c5c0 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -650,7 +650,7 @@ error:
 	return ret;
 }
 
-#ifdef HAVE_LIBUNWIND_SUPPORT
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
 static int get_stack_size(char *str, unsigned long *_size)
 {
 	char *endptr;
@@ -676,7 +676,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 	       max_size, str);
 	return -1;
 }
-#endif /* HAVE_LIBUNWIND_SUPPORT */
+#endif /* HAVE_DWARF_UNWIND_SUPPORT */
 
 int record_parse_callchain(const char *arg, struct record_opts *opts)
 {
@@ -705,7 +705,7 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 				       "needed for -g fp\n");
 			break;
 
-#ifdef HAVE_LIBUNWIND_SUPPORT
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
 		/* Dwarf style */
 		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
 			const unsigned long default_stack_dump_size = 8192;
@@ -721,7 +721,7 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 				ret = get_stack_size(tok, &size);
 				opts->stack_dump_size = size;
 			}
-#endif /* HAVE_LIBUNWIND_SUPPORT */
+#endif /* HAVE_DWARF_UNWIND_SUPPORT */
 		} else {
 			pr_err("callchain: Unknown --call-graph option "
 			       "value: %s\n", arg);
@@ -808,7 +808,7 @@ static struct record record = {
 
 #define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
 
-#ifdef HAVE_LIBUNWIND_SUPPORT
+#ifdef HAVE_DWARF_UNWIND_SUPPORT
 const char record_callchain_help[] = CALLCHAIN_HELP "fp dwarf";
 #else
 const char record_callchain_help[] = CALLCHAIN_HELP "fp";
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5d15b43..1bc78d2 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -337,7 +337,7 @@ ifndef NO_LIBUNWIND
       CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
     endif
 
-    CFLAGS += -DHAVE_LIBUNWIND_SUPPORT
+    CFLAGS += -DHAVE_DWARF_UNWIND_SUPPORT -DHAVE_LIBUNWIND_SUPPORT
     EXTLIBS += $(LIBUNWIND_LIBS)
     CFLAGS += $(LIBUNWIND_CFLAGS)
     LDFLAGS += $(LIBUNWIND_LDFLAGS)
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index f5a6ffb..b11bf8a 100644
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
index 8979309..a24795c 100644
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
index 18f33b4..b031316 100644
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
1.8.3.1

