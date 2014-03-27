Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaC0EyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:54:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:62662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbaC0EyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:54:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,739,1389772800"; 
   d="scan'208";a="481082813"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 3/5] tracing: Add get_syscall_name()
Date: Wed, 26 Mar 2014 23:54:05 -0500
Message-Id: <3eb506030d4f1187376d62847eef0327edd84ed8.1395894625.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1395894625.git.tom.zanussi@linux.intel.com>
References: <cover.1395894625.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1395894625.git.tom.zanussi@linux.intel.com>
References: <cover.1395894625.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a utility function to grab the syscall name from the syscall
metadata, given a syscall id.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 kernel/trace/trace.h          |  9 +++++++++
 kernel/trace/trace_syscalls.c | 11 +++++++++++
 2 files changed, 20 insertions(+)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9032cf3..457fb4f 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1277,4 +1277,13 @@ int perf_ftrace_event_register(struct ftrace_event_call *call,
 #define perf_ftrace_event_register NULL
 #endif
 
+#ifdef CONFIG_FTRACE_SYSCALLS
+const char *get_syscall_name(int syscall);
+#else
+static inline const char *get_syscall_name(int syscall)
+{
+	return NULL;
+}
+#endif /* CONFIG_FTRACE_SYSCALLS */
+
 #endif /* _LINUX_KERNEL_TRACE_H */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 759d5e0..1abb3396 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -106,6 +106,17 @@ static struct syscall_metadata *syscall_nr_to_meta(int nr)
 	return syscalls_metadata[nr];
 }
 
+const char *get_syscall_name(int syscall)
+{
+	struct syscall_metadata *entry;
+
+	entry = syscall_nr_to_meta(syscall);
+	if (!entry)
+		return NULL;
+
+	return entry->name;
+}
+
 static enum print_line_t
 print_syscall_enter(struct trace_iterator *iter, int flags,
 		    struct trace_event *event)
-- 
1.8.3.1

