Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbaDNQeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:34:50 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:53117 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829AbaDNQ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:27:22 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 28/38] tick-sched: remove parameters to {__}tick_nohz_task_switch() routines
Date: Mon, 14 Apr 2014 21:53:50 +0530
Message-Id: <5a6a145674295895cabbe355ac0d778c17cfc785.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_nohz_task_switch() and __tick_nohz_task_switch() routines get task_struct
passed to them (always for the 'current' task), but they never use it. Remove
it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/tick.h     | 8 ++++----
 kernel/sched/core.c      | 2 +-
 kernel/time/tick-sched.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 801e844..1065a51 100644
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
index 13299c5..84dc349 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2156,7 +2156,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 		put_task_struct(prev);
 	}
 
-	tick_nohz_task_switch(current);
+	tick_nohz_task_switch();
 }
 
 #ifdef CONFIG_SMP
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index ee0768b..5f7796d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -266,7 +266,7 @@ void tick_nohz_full_kick_all(void)
  * It might need the tick due to per task/process properties:
  * perf events, posix cpu timers, ...
  */
-void __tick_nohz_task_switch(struct task_struct *tsk)
+void __tick_nohz_task_switch(void)
 {
 	unsigned long flags;
 
-- 
1.7.12.rc2.18.g61b472e

