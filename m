Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaDUJ5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:57:04 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:44417 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaDUJ46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:56:58 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 16/19] tick-sched: remove parameters to {__}tick_nohz_task_switch() routines
Date: Mon, 21 Apr 2014 15:25:12 +0530
Message-Id: <ca7890d2e6e7ec5dc14518bb5946695ae66b3aca.1398072824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1398072824.git.viresh.kumar@linaro.org>
References: <cover.1398072824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_nohz_task_switch() and __tick_nohz_task_switch() routines get task_struct
passed to them (always for the 'current' task), but they never use it. Remove
it.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/tick.h     | 8 ++++----
 kernel/sched/core.c      | 2 +-
 kernel/time/tick-sched.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index b8ee6f4..f538a4d 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -201,7 +201,7 @@ extern void tick_nohz_init(void);
 extern void __tick_nohz_full_check(void);
 extern void tick_nohz_full_kick(void);
 extern void tick_nohz_full_kick_all(void);
-extern void __tick_nohz_task_switch(struct task_struct *tsk);
+extern void __tick_nohz_task_switch(void);
 #else
 static inline void tick_nohz_init(void) { }
 static inline bool tick_nohz_full_enabled(void) { return false; }
@@ -209,7 +209,7 @@ static inline bool tick_nohz_full_cpu(int cpu) { return false; }
 static inline void __tick_nohz_full_check(void) { }
 static inline void tick_nohz_full_kick(void) { }
 static inline void tick_nohz_full_kick_all(void) { }
-static inline void __tick_nohz_task_switch(struct task_struct *tsk) { }
+static inline void __tick_nohz_task_switch(void) { }
 #endif
 
 static inline void tick_nohz_full_check(void)
@@ -218,10 +218,10 @@ static inline void tick_nohz_full_check(void)
 		__tick_nohz_full_check();
 }
 
-static inline void tick_nohz_task_switch(struct task_struct *tsk)
+static inline void tick_nohz_task_switch(void)
 {
 	if (tick_nohz_full_enabled())
-		__tick_nohz_task_switch(tsk);
+		__tick_nohz_task_switch();
 }
 
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3a4bb63..7cfe9d5a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2157,7 +2157,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 		put_task_struct(prev);
 	}
 
-	tick_nohz_task_switch(current);
+	tick_nohz_task_switch();
 }
 
 #ifdef CONFIG_SMP
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 8e75c13..2360e7a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -258,7 +258,7 @@ void tick_nohz_full_kick_all(void)
  * It might need the tick due to per task/process properties:
  * perf events, posix cpu timers, ...
  */
-void __tick_nohz_task_switch(struct task_struct *tsk)
+void __tick_nohz_task_switch(void)
 {
 	unsigned long flags;
 
-- 
1.7.12.rc2.18.g61b472e

