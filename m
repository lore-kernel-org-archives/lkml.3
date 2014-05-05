Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbaEERur (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:50:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53194 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007AbaEERum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:50:42 -0400
Date: Mon, 5 May 2014 10:49:38 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-82baa0eb46c15b749723d0c801470fea044657d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de, bp@suse.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1399293219-8732-10-git-send-email-jolsa@kernel.org>
References: <1399293219-8732-10-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Move sys_perf_event_open function from perf.h
Git-Commit-ID: 82baa0eb46c15b749723d0c801470fea044657d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82baa0eb46c15b749723d0c801470fea044657d7
Gitweb:     http://git.kernel.org/tip/82baa0eb46c15b749723d0c801470fea044657d7
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 5 May 2014 12:58:31 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Mon, 5 May 2014 17:48:51 +0200

perf tools: Move sys_perf_event_open function from perf.h

Into perf-sys.h header, as requested by Peter:
  http://lkml.kernel.org/r/20140502115201.GI30445@twins.programming.kicks-ass.net

Adding HAVE_ATTR_TEST define to turn off/on the attribute
test code in the sys_perf_event_open function.

Requested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1399293219-8732-10-git-send-email-jolsa@kernel.org
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
