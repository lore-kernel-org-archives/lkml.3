Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760580Ab3DBDzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:55:35 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:52583 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760549Ab3DBDzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:31 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 17/23] perf: remove LIBUNWIND_SUPPORT in favor of CONFIG_LIBUNWIND
Date: Mon,  1 Apr 2013 21:54:31 -0600
Message-Id: <1364874877-5618-18-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile         |    1 -
 tools/perf/builtin-record.c |   11 ++++++-----
 tools/perf/util/unwind.h    |    5 +++--
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a606eb1..cc44818 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -633,7 +633,6 @@ ifdef CONFIG_LIBUNWIND
         $(error No libunwind found. Please install libunwind-dev[el] >= 0.99 or disable CONFIG_LIBUNWIND)
     endif
 
-	BASIC_CFLAGS += -DLIBUNWIND_SUPPORT
 	EXTLIBS += $(LIBUNWIND_LIBS)
 	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
 	BASIC_LDFLAGS := $(LIBUNWIND_LDFLAGS) $(BASIC_LDFLAGS)
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f1a939e..276a6e0 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -26,6 +26,7 @@
 #include "util/symbol.h"
 #include "util/cpumap.h"
 #include "util/thread_map.h"
+#include <linux/kconfig.h>
 
 #include <unistd.h>
 #include <sched.h>
@@ -742,7 +743,7 @@ error:
 	return ret;
 }
 
-#ifdef LIBUNWIND_SUPPORT
+#ifdef CONFIG_LIBUNWIND
 static int get_stack_size(char *str, unsigned long *_size)
 {
 	char *endptr;
@@ -768,7 +769,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 	       max_size, str);
 	return -1;
 }
-#endif /* LIBUNWIND_SUPPORT */
+#endif /* CONFIG_LIBUNWIND */
 
 int record_parse_callchain_opt(const struct option *opt,
 			       const char *arg, int unset)
@@ -806,7 +807,7 @@ int record_parse_callchain_opt(const struct option *opt,
 				       "needed for -g fp\n");
 			break;
 
-#ifdef LIBUNWIND_SUPPORT
+#ifdef CONFIG_LIBUNWIND
 		/* Dwarf style */
 		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
 			const unsigned long default_stack_dump_size = 8192;
@@ -826,7 +827,7 @@ int record_parse_callchain_opt(const struct option *opt,
 			if (!ret)
 				pr_debug("callchain: stack dump size %d\n",
 					 opts->stack_dump_size);
-#endif /* LIBUNWIND_SUPPORT */
+#endif /* CONFIG_LIBUNWIND */
 		} else {
 			pr_err("callchain: Unknown -g option "
 			       "value: %s\n", arg);
@@ -875,7 +876,7 @@ static struct perf_record record = {
 
 #define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
 
-#ifdef LIBUNWIND_SUPPORT
+#ifdef CONFIG_LIBUNWIND
 const char record_callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
 #else
 const char record_callchain_help[] = CALLCHAIN_HELP "[fp]";
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index cb6bc50..9890981 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -4,6 +4,7 @@
 #include "types.h"
 #include "event.h"
 #include "symbol.h"
+#include <linux/kconfig.h>
 
 struct unwind_entry {
 	struct map	*map;
@@ -13,7 +14,7 @@ struct unwind_entry {
 
 typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
 
-#ifdef LIBUNWIND_SUPPORT
+#ifdef CONFIG_LIBUNWIND
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine,
 			struct thread *thread,
@@ -31,5 +32,5 @@ unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 {
 	return 0;
 }
-#endif /* LIBUNWIND_SUPPORT */
+#endif /* CONFIG_LIBUNWIND */
 #endif /* __UNWIND_H */
-- 
1.7.10.1

