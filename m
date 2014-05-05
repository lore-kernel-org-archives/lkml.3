Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbaEEMeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:34:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128AbaEEMeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:34:17 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/10] perf tools: Move sys_perf_event_open function from perf.h
Date: Mon,  5 May 2014 14:33:38 +0200
Message-Id: <1399293219-8732-10-git-send-email-jolsa@kernel.org>
In-Reply-To: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Into perf-sys.h header, as requested by Peter:
  http://lkml.kernel.org/r/20140502115201.GI30445@twins.programming.kicks-ass.net

Adding HAVE_ATTR_TEST define to turn off/on the attribute
test code in the sys_perf_event_open function.

Requested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/perf-sys.h | 22 ++++++++++++++++++++++
 tools/perf/perf.h     | 40 +++++++++++-----------------------------
 2 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/tools/perf/perf-sys.h b/tools/perf/perf-sys.h
index 4c22c2a..5268a14 100644
--- a/tools/perf/perf-sys.h
+++ b/tools/perf/perf-sys.h
@@ -1,6 +1,11 @@
 #ifndef _PERF_SYS_H
 #define _PERF_SYS_H
 
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/syscall.h>
+#include <linux/types.h>
+#include <linux/perf_event.h>
 #include <asm/unistd.h>
 
 #if defined(__i386__)
@@ -165,4 +170,21 @@
 #define cpu_relax() barrier()
 #endif
 
+static inline int
+sys_perf_event_open(struct perf_event_attr *attr,
+		      pid_t pid, int cpu, int group_fd,
+		      unsigned long flags)
+{
+	int fd;
+
+	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
+		     group_fd, flags);
+
+#ifdef HAVE_ATTR_TEST
+	if (unlikely(test_attr__enabled))
+		test_attr__open(attr, pid, cpu, fd, group_fd, flags);
+#endif
+	return fd;
+}
+
 #endif /* _PERF_SYS_H */
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index ee95965..813571b 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -1,18 +1,21 @@
 #ifndef _PERF_PERF_H
 #define _PERF_PERF_H
 
-#include "perf-sys.h"
-
-#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
-
 #include <time.h>
-#include <unistd.h>
-#include <sys/types.h>
-#include <sys/syscall.h>
-
+#include <stdbool.h>
 #include <linux/types.h>
 #include <linux/perf_event.h>
 
+extern bool test_attr__enabled;
+void test_attr__init(void);
+void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
+		     int fd, int group_fd, unsigned long flags);
+
+#define HAVE_ATTR_TEST
+#include "perf-sys.h"
+
+#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
+
 #ifndef NSEC_PER_SEC
 # define NSEC_PER_SEC			1000000000ULL
 #endif
@@ -28,27 +31,6 @@ static inline unsigned long long rdclock(void)
 	return ts.tv_sec * 1000000000ULL + ts.tv_nsec;
 }
 
-extern bool test_attr__enabled;
-void test_attr__init(void);
-void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
-		     int fd, int group_fd, unsigned long flags);
-
-static inline int
-sys_perf_event_open(struct perf_event_attr *attr,
-		      pid_t pid, int cpu, int group_fd,
-		      unsigned long flags)
-{
-	int fd;
-
-	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
-		     group_fd, flags);
-
-	if (unlikely(test_attr__enabled))
-		test_attr__open(attr, pid, cpu, fd, group_fd, flags);
-
-	return fd;
-}
-
 #define MAX_NR_CPUS			256
 
 extern const char *input_name;
-- 
1.8.3.1

