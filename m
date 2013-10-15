Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563Ab3JOT6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 15:58:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:57700 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933455Ab3JOT6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 15:58:11 -0400
Date: Tue, 15 Oct 2013 15:58:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: [PATCH] bug: Use xchg() to update WARN_ON_ONCE() static variable
Message-ID: <20131015155806.04e2613f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WARN_ON_ONCE() code is to trigger a waring only once when some
condition happens. But due to the way it is written it is racy.

	if (unlikely(condition)) {
		if (WARN(!__warned))
			__warned = true;
	}

The problem is that multiple CPUs could hit the same warning and
produce multiple output dumps of the same warning, or an interrupt could
happen and hit the same warning and do the warning in the middle of a
previous one, especially since the WARN() does a dump of the current
stack.

Even more of a problem, a recent WARN_ON_ONCE() that was in the page
fault handler triggered and the stack dump of the WARN() caused the
same WARN_ON_ONCE() get hit again. Since the __warned = true is not
updated until after the WARN() is completed, each WARN() triggered
another page fault causing the stack to be filled and crashed the box.

The point of WARN_ON() is to warn the user and not to crash the box.

The easy fix is to update the __warned variable with a xchg(). This way
only one WARN_ON_ONCE() will actually happen, and prevents any issues
of the WARN() causing the same WARN() to be hit and crash the system.

[ Fixed the WARN() whitespace offset of a '\' while I was at it ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 7d10f96..ab7ebdb 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -11,6 +11,7 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/kernel.h>
+#include <asm/cmpxchg.h>
 
 #ifdef CONFIG_BUG
 
@@ -91,7 +92,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 #endif
 
 #ifndef WARN
-#define WARN(condition, format...) ({						\
+#define WARN(condition, format...) ({					\
 	int __ret_warn_on = !!(condition);				\
 	if (unlikely(__ret_warn_on))					\
 		__WARN_printf(format);					\
@@ -134,32 +135,29 @@ extern void warn_slowpath_null(const char *file, const int line);
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
-	static bool __section(.data.unlikely) __warned;		\
+	static int __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
-		if (WARN_ON(!__warned)) 			\
-			__warned = true;			\
+		WARN_ON(!xchg(&__warned, 1));			\
 	unlikely(__ret_warn_once);				\
 })
 
 #define WARN_ONCE(condition, format...)	({			\
-	static bool __section(.data.unlikely) __warned;		\
+	static int __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
-		if (WARN(!__warned, format)) 			\
-			__warned = true;			\
+		WARN(!xchg(&__warned, 1), format);		\
 	unlikely(__ret_warn_once);				\
 })
 
 #define WARN_TAINT_ONCE(condition, taint, format...)	({	\
-	static bool __section(.data.unlikely) __warned;		\
+	static int __section(.data.unlikely) __warned;		\
 	int __ret_warn_once = !!(condition);			\
 								\
 	if (unlikely(__ret_warn_once))				\
-		if (WARN_TAINT(!__warned, taint, format))	\
-			__warned = true;			\
+		WARN_TAINT(!xchg(&__warned, 1), taint, format);	\
 	unlikely(__ret_warn_once);				\
 })
 
