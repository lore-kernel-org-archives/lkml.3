Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbaDNQ1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:27:33 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38343 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaDNQ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:27:28 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 29/38] tick-sched: remove wrapper around __tick_nohz_task_switch()
Date: Mon, 14 Apr 2014 21:53:51 +0530
Message-Id: <b38dda39bf6cd18df5fab86f7c7cc86a6979786f.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__tick_nohz_task_switch() was called only from tick_nohz_task_switch() and there
is nothing much in tick_nohz_task_switch() as well. IOW, we don't need
unnecessary wrapper over __tick_nohz_task_switch() to be there. Merge all code
from __tick_nohz_task_switch() into tick_nohz_task_switch() and move it to
tick-sched.c.

This also moves check for tick_nohz_tick_stopped() outside of irq_save()
context.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/tick.h     | 11 ++---------
 kernel/time/tick-sched.c |  7 +++++--
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 1065a51..585be84 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -201,7 +201,7 @@ extern void tick_nohz_init(void);
 extern void __tick_nohz_full_check(void);
 extern void tick_nohz_full_kick(void);
 extern void tick_nohz_full_kick_all(void);
-extern void __tick_nohz_task_switch(void);
+extern void tick_nohz_task_switch(void);
 #else
 static inline void tick_nohz_init(void) { }
 static inline bool tick_nohz_full_enabled(void) { return false; }
@@ -209,7 +209,7 @@ static inline bool tick_nohz_full_cpu(int cpu) { return false; }
 static inline void __tick_nohz_full_check(void) { }
 static inline void tick_nohz_full_kick(void) { }
 static inline void tick_nohz_full_kick_all(void) { }
-static inline void __tick_nohz_task_switch(void) { }
+static inline void tick_nohz_task_switch(void) { }
 #endif
 
 static inline void tick_nohz_full_check(void)
@@ -218,11 +218,4 @@ static inline void tick_nohz_full_check(void)
 		__tick_nohz_full_check();
 }
 
-static inline void tick_nohz_task_switch(void)
-{
-	if (tick_nohz_full_enabled())
-		__tick_nohz_task_switch();
-}
-
-
 #endif
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 5f7796d..d8b9a69 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -266,13 +266,16 @@ void tick_nohz_full_kick_all(void)
  * It might need the tick due to per task/process properties:
  * perf events, posix cpu timers, ...
  */
-void __tick_nohz_task_switch(void)
+void tick_nohz_task_switch(void)
 {
 	unsigned long flags;
 
+	if (!tick_nohz_full_enabled() || !tick_nohz_tick_stopped())
+		return;
+
 	local_irq_save(flags);
 
-	if (tick_nohz_tick_stopped() && !can_stop_full_tick())
+	if (!can_stop_full_tick())
 		tick_nohz_full_kick();
 
 	local_irq_restore(flags);
-- 
1.7.12.rc2.18.g61b472e

