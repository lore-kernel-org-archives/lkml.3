Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbaC0Tms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 15:42:48 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:50715 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbaC0TmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 15:42:14 -0400
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Rob Herring <robh@kernel.org>
Subject: [RFC PATCH 4/4] vmlinux.lds: define conditional sections with macros
Date: Thu, 27 Mar 2014 14:41:57 -0500
Message-Id: <1395949317-8738-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395949317-8738-1-git-send-email-robherring2@gmail.com>
References: <1395949317-8738-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Various section definitions all use the same pattern. Create a common
macro to define these.

There are a few other instances with a different symbol naming convention
which could also be converted over to use this.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/vmlinux.lds.h | 82 +++++++++++++--------------------------
 1 file changed, 27 insertions(+), 55 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 000a0f30..9a08039 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -84,61 +84,33 @@
 #define MEM_DISCARD(sec) *(.mem##sec)
 #endif
 
-#ifdef CONFIG_FTRACE_MCOUNT_RECORD
-#define MCOUNT_REC()	. = ALIGN(8);				\
-			VMLINUX_SYMBOL(__start_mcount_loc) = .; \
-			*(__mcount_loc)				\
-			VMLINUX_SYMBOL(__stop_mcount_loc) = .;
-#else
-#define MCOUNT_REC()
-#endif
-
-#ifdef CONFIG_TRACE_BRANCH_PROFILING
-#define LIKELY_PROFILE()	VMLINUX_SYMBOL(__start_annotated_branch_profile) = .; \
-				*(_ftrace_annotated_branch)			      \
-				VMLINUX_SYMBOL(__stop_annotated_branch_profile) = .;
-#else
-#define LIKELY_PROFILE()
-#endif
-
-#ifdef CONFIG_PROFILE_ALL_BRANCHES
-#define BRANCH_PROFILE()	VMLINUX_SYMBOL(__start_branch_profile) = .;   \
-				*(_ftrace_branch)			      \
-				VMLINUX_SYMBOL(__stop_branch_profile) = .;
-#else
-#define BRANCH_PROFILE()
-#endif
-
-#ifdef CONFIG_EVENT_TRACING
-#define FTRACE_EVENTS()	. = ALIGN(8);					\
-			VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
-			*(_ftrace_events)				\
-			VMLINUX_SYMBOL(__stop_ftrace_events) = .;
-#else
-#define FTRACE_EVENTS()
-#endif
-
-#ifdef CONFIG_TRACING
-#define TRACE_PRINTKS() VMLINUX_SYMBOL(__start___trace_bprintk_fmt) = .;      \
-			 *(__trace_printk_fmt) /* Trace_printk fmt' pointer */ \
-			 VMLINUX_SYMBOL(__stop___trace_bprintk_fmt) = .;
-#define TRACEPOINT_STR() VMLINUX_SYMBOL(__start___tracepoint_str) = .;	\
-			 *(__tracepoint_str) /* Trace_printk fmt' pointer */ \
-			 VMLINUX_SYMBOL(__stop___tracepoint_str) = .;
-#else
-#define TRACE_PRINTKS()
-#define TRACEPOINT_STR()
-#endif
-
-#ifdef CONFIG_FTRACE_SYSCALLS
-#define TRACE_SYSCALLS() . = ALIGN(8);					\
-			 VMLINUX_SYMBOL(__start_syscalls_metadata) = .;	\
-			 *(__syscalls_metadata)				\
-			 VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;
-#else
-#define TRACE_SYSCALLS()
-#endif
-
+#define __DEF_SECT(cfg, align, sec, sym)	_DEF_SECT_##cfg(align, sec, sym)
+#define _DEF_SECT(cfg, align, sec, sym)		__DEF_SECT(cfg, align, sec, sym)
+#define DEF_SECTION_SYM(cfg, align, sec, sym)				\
+	_DEF_SECT(config_enabled(cfg), align, sec, sym)
+#define DEF_SECTION(cfg, align, sec)				\
+	_DEF_SECT(config_enabled(cfg), align, sec, sec)
+#define _DEF_SECT_0(align, sec, sym)
+#define _DEF_SECT_1(align, sec, sym)					\
+	. = ALIGN(align);						\
+	VMLINUX_SYMBOL(__start_##sym) = .;				\
+	*(##sec)							\
+	VMLINUX_SYMBOL(__stop_##sym) = .;
+
+#define MCOUNT_REC()		\
+	DEF_SECTION(CONFIG_FTRACE_MCOUNT_RECORD, 8, mcount_loc)
+#define LIKELY_PROFILE()	\
+	DEF_SECTION_SYM(CONFIG_TRACE_BRANCH_PROFILING, 1, _ftrace_annotated_branch, annotated_branch_profile)
+#define FTRACE_EVENTS()		\
+	DEF_SECTION(CONFIG_EVENT_TRACING, 8, ftrace_events)
+#define BRANCH_PROFILE()	\
+	DEF_SECTION_SYM(CONFIG_PROFILE_ALL_BRANCHES, 1, _ftrace_branch, branch_profile)
+#define TRACE_PRINTKS()		\
+	DEF_SECTION_SYM(CONFIG_TRACING, 1, __trace_printk_fmt, __trace_bprintk_fmt)
+#define TRACEPOINT_STR()	\
+	DEF_SECTION(CONFIG_TRACING, 1, __tracepoint_str)
+#define TRACE_SYSCALLS()	\
+	DEF_SECTION_SYM(CONFIG_FTRACE_SYSCALLS, 8, __syscalls_metadata, syscalls_metadata)
 
 #define ___OF_TABLE(cfg, name)	_OF_TABLE_##cfg(name)
 #define __OF_TABLE(cfg, name)	___OF_TABLE(cfg, name)
-- 
1.8.3.2

