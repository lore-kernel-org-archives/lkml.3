Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3FKP3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:29:37 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:42376 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3FKP3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:29:34 -0400
From: Robert Richter <rric@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH] perf tools: Use default include path notation for libtraceevent headers
Date: Tue, 11 Jun 2013 17:29:18 +0200
Message-Id: <1370964558-8599-1-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Header files of libtraceevent or no longer local headers. Thus, use
default path notation for them. Also removing extra traceevent include
path and instead handle this similar to liblk.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 tools/perf/Makefile               | 2 +-
 tools/perf/builtin-trace.c        | 2 +-
 tools/perf/config/Makefile        | 5 +++--
 tools/perf/tests/evsel-tp-sched.c | 2 +-
 tools/perf/util/evsel.c           | 8 ++++----
 tools/perf/util/session.c         | 2 +-
 tools/perf/util/trace-event.h     | 2 +-
 7 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 641fccd..5b7c6db 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -281,7 +281,7 @@ LIB_H += util/cpumap.h
 LIB_H += util/top.h
 LIB_H += $(ARCH_INCLUDE)
 LIB_H += util/cgroup.h
-LIB_H += $(TRACE_EVENT_DIR)event-parse.h
+LIB_H += $(LIB_INCLUDE)traceevent/event-parse.h
 LIB_H += util/target.h
 LIB_H += util/rblist.h
 LIB_H += util/intlist.h
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index ab3ed4a..87fc7d0 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1,3 +1,4 @@
+#include <traceevent/event-parse.h>
 #include "builtin.h"
 #include "util/color.h"
 #include "util/evlist.h"
@@ -5,7 +6,6 @@
 #include "util/thread.h"
 #include "util/parse-options.h"
 #include "util/thread_map.h"
-#include "event-parse.h"
 
 #include <libaudit.h>
 #include <stdlib.h>
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f446895..d071077 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -46,6 +46,8 @@ ifneq ($(obj-perf),)
 obj-perf := $(abspath $(obj-perf))/
 endif
 
+LIB_INCLUDE := $(srctree)/tools/lib/
+
 # include ARCH specific config
 -include $(src-perf)/arch/$(ARCH)/Makefile
 
@@ -121,8 +123,7 @@ endif
 
 CFLAGS += -I$(src-perf)/util
 CFLAGS += -I$(src-perf)
-CFLAGS += -I$(TRACE_EVENT_DIR)
-CFLAGS += -I$(srctree)/tools/lib/
+CFLAGS += -I$(LIB_INCLUDE)
 
 CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
diff --git a/tools/perf/tests/evsel-tp-sched.c b/tools/perf/tests/evsel-tp-sched.c
index a5d2fcc..f79e7d0 100644
--- a/tools/perf/tests/evsel-tp-sched.c
+++ b/tools/perf/tests/evsel-tp-sched.c
@@ -1,6 +1,6 @@
+#include <traceevent/event-parse.h>
 #include "evsel.h"
 #include "tests.h"
-#include "event-parse.h"
 
 static int perf_evsel__test_field(struct perf_evsel *evsel, const char *name,
 				  int size, bool should_be_signed)
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 63b6f8c..dea0684 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -9,17 +9,17 @@
 
 #include <byteswap.h>
 #include <linux/bitops.h>
-#include "asm/bug.h"
 #include <lk/debugfs.h>
-#include "event-parse.h"
+#include <traceevent/event-parse.h>
+#include <linux/hw_breakpoint.h>
+#include <linux/perf_event.h>
+#include "asm/bug.h"
 #include "evsel.h"
 #include "evlist.h"
 #include "util.h"
 #include "cpumap.h"
 #include "thread_map.h"
 #include "target.h"
-#include <linux/hw_breakpoint.h>
-#include <linux/perf_event.h>
 #include "perf_regs.h"
 
 static struct {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cf1fe01..ad47fb9 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1,4 +1,5 @@
 #include <linux/kernel.h>
+#include <traceevent/event-parse.h>
 
 #include <byteswap.h>
 #include <unistd.h>
@@ -12,7 +13,6 @@
 #include "sort.h"
 #include "util.h"
 #include "cpumap.h"
-#include "event-parse.h"
 #include "perf_regs.h"
 #include "vdso.h"
 
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 1978c39..11eb7fd 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -1,8 +1,8 @@
 #ifndef _PERF_UTIL_TRACE_EVENT_H
 #define _PERF_UTIL_TRACE_EVENT_H
 
+#include <traceevent/event-parse.h>
 #include "parse-events.h"
-#include "event-parse.h"
 #include "session.h"
 
 struct machine;
-- 
1.8.1.1

