Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab3HPPni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:43:38 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37414 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab3HPPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:42:47 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 4/4] nohz: Convert a few places to use local per cpu accesses
Date: Fri, 16 Aug 2013 17:42:33 +0200
Message-Id: <1376667753-29014-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few functions use remote per CPU access APIs when they
deal with local values.

Just to the right conversion to improve performance, code
readability and debug checks.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/time/tick-sched.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 017bec2..11d64e2 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -395,11 +395,9 @@ __setup("nohz=", setup_tick_nohz);
  */
 static void tick_nohz_update_jiffies(ktime_t now)
 {
-	int cpu = smp_processor_id();
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	unsigned long flags;
 
-	ts->idle_waketime = now;
+	__this_cpu_write(tick_cpu_sched.idle_waketime, now);
 
 	local_irq_save(flags);
 	tick_do_update_jiffies64(now);
@@ -410,7 +408,7 @@ static void tick_nohz_update_jiffies(ktime_t now)
 
 static void tick_nohz_stop_idle(int cpu, ktime_t now)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t delta;
 
 	/* Updates the per cpu time idle statistics counters */
@@ -901,7 +899,7 @@ static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
 void tick_nohz_idle_exit(void)
 {
 	int cpu = smp_processor_id();
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t now;
 
 	local_irq_disable();
@@ -1020,7 +1018,7 @@ static void tick_nohz_kick_tick(int cpu, ktime_t now)
 
 static inline void tick_check_nohz(int cpu)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t now;
 
 	if (!ts->idle_active && !ts->tick_stopped)
-- 
1.7.5.4

