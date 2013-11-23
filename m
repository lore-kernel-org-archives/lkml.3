Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab3KWPho (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:37:44 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53444 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab3KWPhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:37:37 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/10] posix-timers: Convert abuses of BUG_ON to WARN_ON
Date: Sat, 23 Nov 2013 16:37:20 +0100
Message-Id: <1385221040-24731-11-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
References: <1385221040-24731-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The posix cpu timers code makes a heavy use of BUG_ON()
but none of these concern fatal issues that require
to stop the machine. So let's just warn the user when
some internal state slips out of our hands.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/posix-cpu-timers.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8c75408..3c9594b 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -395,7 +395,7 @@ static int posix_cpu_timer_del(struct k_itimer *timer)
 		 * We raced with the reaping of the task.
 		 * The deletion should have cleared us off the list.
 		 */
-		BUG_ON(!list_empty(&timer->it.cpu.entry));
+		WARN_ON_ONCE(!list_empty(&timer->it.cpu.entry));
 	} else {
 		if (timer->it.cpu.firing)
 			ret = TIMER_RETRY;
@@ -639,7 +639,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int timer_flags,
 	/*
 	 * Disarm any old timer after extracting its expiry time.
 	 */
-	BUG_ON(!irqs_disabled());
+	WARN_ON_ONCE(!irqs_disabled());
 
 	ret = 0;
 	old_incr = timer->it.cpu.incr;
@@ -1060,7 +1060,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	/*
 	 * Now re-arm for the new expiry time.
 	 */
-	BUG_ON(!irqs_disabled());
+	WARN_ON_ONCE(!irqs_disabled());
 	arm_timer(timer);
 
 out_unlock:
@@ -1149,7 +1149,7 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	struct k_itimer *timer, *next;
 	unsigned long flags;
 
-	BUG_ON(!irqs_disabled());
+	WARN_ON_ONCE(!irqs_disabled());
 
 	/*
 	 * The fast path checks that there are no expired thread or thread
@@ -1223,7 +1223,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 {
 	unsigned long long now;
 
-	BUG_ON(clock_idx == CPUCLOCK_SCHED);
+	WARN_ON_ONCE(clock_idx == CPUCLOCK_SCHED);
 	cpu_timer_sample_group(clock_idx, tsk, &now);
 
 	if (oldval) {
-- 
1.8.3.1

