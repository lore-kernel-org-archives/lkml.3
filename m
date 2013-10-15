Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab3JOUvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:51:08 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61962 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933667Ab3JOUvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:51:03 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Liu Chuansheng <chuansheng.liu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3/3] bug: Convert warn macros to use once and cond helpers
Date: Tue, 15 Oct 2013 22:50:52 +0200
Message-Id: <1381870252-5430-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381870252-5430-1-git-send-email-fweisbec@gmail.com>
References: <1381870252-5430-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately this removes the use of .data.unlikely code
section for the warned state...

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Liu Chuansheng <chuansheng.liu@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
---
 include/asm-generic/bug.h | 57 ++++++++++-------------------------------------
 1 file changed, 12 insertions(+), 45 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 7d10f96..2663ea1 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -82,29 +82,17 @@ extern void warn_slowpath_null(const char *file, const int line);
 #endif
 
 #ifndef WARN_ON
-#define WARN_ON(condition) ({						\
-	int __ret_warn_on = !!(condition);				\
-	if (unlikely(__ret_warn_on))					\
-		__WARN();						\
-	unlikely(__ret_warn_on);					\
-})
+#define WARN_ON(condition)				 		\
+	DO_COND(condition, __WARN())
 #endif
 
 #ifndef WARN
-#define WARN(condition, format...) ({						\
-	int __ret_warn_on = !!(condition);				\
-	if (unlikely(__ret_warn_on))					\
-		__WARN_printf(format);					\
-	unlikely(__ret_warn_on);					\
-})
+#define WARN(condition, format...)					\
+	DO_COND(condition, __WARN_printf(format))
 #endif
 
-#define WARN_TAINT(condition, taint, format...) ({			\
-	int __ret_warn_on = !!(condition);				\
-	if (unlikely(__ret_warn_on))					\
-		__WARN_printf_taint(taint, format);			\
-	unlikely(__ret_warn_on);					\
-})
+#define WARN_TAINT(condition, taint, format...)			\
+	DO_COND(condition, __WARN_printf_taint(taint, format))
 
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
@@ -133,35 +121,14 @@ extern void warn_slowpath_null(const char *file, const int line);
 
 #endif
 
-#define WARN_ON_ONCE(condition)	({				\
-	static bool __section(.data.unlikely) __warned;		\
-	int __ret_warn_once = !!(condition);			\
-								\
-	if (unlikely(__ret_warn_once))				\
-		if (WARN_ON(!__warned)) 			\
-			__warned = true;			\
-	unlikely(__ret_warn_once);				\
-})
+#define WARN_ON_ONCE(condition)					\
+	DO_ONCE_COND(condition, __WARN())
 
-#define WARN_ONCE(condition, format...)	({			\
-	static bool __section(.data.unlikely) __warned;		\
-	int __ret_warn_once = !!(condition);			\
-								\
-	if (unlikely(__ret_warn_once))				\
-		if (WARN(!__warned, format)) 			\
-			__warned = true;			\
-	unlikely(__ret_warn_once);				\
-})
+#define WARN_ONCE(condition, format...)				\
+	DO_ONCE_COND(condition, __WARN_printf(format))
 
-#define WARN_TAINT_ONCE(condition, taint, format...)	({	\
-	static bool __section(.data.unlikely) __warned;		\
-	int __ret_warn_once = !!(condition);			\
-								\
-	if (unlikely(__ret_warn_once))				\
-		if (WARN_TAINT(!__warned, taint, format))	\
-			__warned = true;			\
-	unlikely(__ret_warn_once);				\
-})
+#define WARN_TAINT_ONCE(condition, taint, format...)			\
+	DO_ONCE_COND(condition, __WARN_printf_taint(taint, format))
 
 /*
  * WARN_ON_SMP() is for cases that the warning is either
-- 
1.8.3.1

