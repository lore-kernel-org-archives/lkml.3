Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab3AQNY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:24:56 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41536 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664Ab3AQNYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:24:53 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/7] cputime: Move default nsecs_to_cputime() to jiffies based cputime file
Date: Thu, 17 Jan 2013 14:24:31 +0100
Message-Id: <1358429075-3430-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1358429075-3430-1-git-send-email-fweisbec@gmail.com>
References: <1358429075-3430-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the architecture doesn't provide an implementation of
nsecs_to_cputime(), the cputime accounting core uses a
default one that converts the nanoseconds to jiffies. However
this only makes sense if we use the jiffies based cputime.

For now it doesn't matter much because this API is only
called on code that uses jiffies based cputime accounting.

But the code may evolve and this API may be used more
broadly in the future. Keeping this default implementation
around is very error prone as it may introduce a bug and
hide it on architectures that don't override this API.

Fix this by moving this definition to the jiffies based
cputime headers as it is the only place where it belongs to.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-generic/cputime_jiffies.h |   10 ++++++++--
 kernel/sched/cputime.c                |    4 ----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/cputime_jiffies.h b/include/asm-generic/cputime_jiffies.h
index b747f1f..272ecba 100644
--- a/include/asm-generic/cputime_jiffies.h
+++ b/include/asm-generic/cputime_jiffies.h
@@ -13,8 +13,14 @@ typedef u64 __nocast cputime64_t;
 #define cputime64_to_jiffies64(__ct)	(__force u64)(__ct)
 #define jiffies64_to_cputime64(__jif)	(__force cputime64_t)(__jif)
 
-#define nsecs_to_cputime64(__ct)	\
-	jiffies64_to_cputime64(nsecs_to_jiffies64(__ct))
+
+/*
+ * Convert nanoseconds to cputime
+ */
+#define nsecs_to_cputime64(__nsec)	\
+	jiffies64_to_cputime64(nsecs_to_jiffies64(__nsec))
+#define nsecs_to_cputime(__nsec)	\
+	jiffies_to_cputime(nsecs_to_jiffies(__nsec))
 
 
 /*
diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 293b202..5849448b 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -505,10 +505,6 @@ EXPORT_SYMBOL_GPL(vtime_account);
 
 #else
 
-#ifndef nsecs_to_cputime
-# define nsecs_to_cputime(__nsecs)	nsecs_to_jiffies(__nsecs)
-#endif
-
 static cputime_t scale_utime(cputime_t utime, cputime_t rtime, cputime_t total)
 {
 	u64 temp = (__force u64) rtime;
-- 
1.7.5.4

