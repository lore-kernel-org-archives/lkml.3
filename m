Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab3JOUvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:51:03 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54001 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933371Ab3JOUvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:51:00 -0400
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
Subject: [PATCH 1/3] core: New macro to execute code only once
Date: Tue, 15 Oct 2013 22:50:50 +0200
Message-Id: <1381870252-5430-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381870252-5430-1-git-send-email-fweisbec@gmail.com>
References: <1381870252-5430-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce DO_COND(), DO_ONCE() and DO_ONCE_COND(). These
macros should ease the consolidation of CPP code when
it is deemed to be executed only once and/or after a
condition is verified. This incluse printk_once, WARN_ON,
WARN_ON_ONCE, etc...

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
 include/linux/once.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 include/linux/once.h

diff --git a/include/linux/once.h b/include/linux/once.h
new file mode 100644
index 0000000..9399f37
--- /dev/null
+++ b/include/linux/once.h
@@ -0,0 +1,26 @@
+#ifndef _LINUX_ONCE_H
+#define _LINUX_ONCE_H
+
+#include <linux/compiler.h>
+
+#define DO_COND(condition, to_do) ({		\
+	int __ret = !!(condition);		\
+	if (unlikely(__ret)) {			\
+		to_do;				\
+	}					\
+	unlikely(__ret);			\
+})
+
+#define DO_ONCE(to_do) ({			\
+	static bool __done;			\
+						\
+	if (!__done) {				\
+		__done = true;			\
+		to_do;				\
+	}					\
+})
+
+#define DO_ONCE_COND(condition, to_do)		\
+	DO_COND(condition, DO_ONCE(to_do))
+
+#endif /* _LINUX_ONCE_H */
-- 
1.8.3.1

