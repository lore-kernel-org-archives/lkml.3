Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbaEHKsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:48:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33453 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaEHKsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:48:00 -0400
Date: Thu, 8 May 2014 03:47:27 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-vq7719foqzf6z5h4j7eh7f9e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        nicolas.pitre@linaro.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/idle: Delay clearing the polling bit
Git-Commit-ID: c444117f0f39d59733ec23da67c44424df529230
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c444117f0f39d59733ec23da67c44424df529230
Gitweb:     http://git.kernel.org/tip/c444117f0f39d59733ec23da67c44424df529230
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 11 Apr 2014 13:47:16 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 8 May 2014 09:16:58 +0200

sched/idle: Delay clearing the polling bit

With the generic idle functions assuming !polling we should only clear
the polling bit at the very last opportunity in order to avoid
spurious IPIs.

Ideally we'd flip the default to polling, but that means auditing all
arch idle functions.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-vq7719foqzf6z5h4j7eh7f9e@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/idle.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index 8f4390a..ed67f0c 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -78,12 +78,10 @@ static int cpuidle_idle_call(void)
 
 	/*
 	 * Check if the idle task must be rescheduled. If it is the
-	 * case, exit the function after re-enabling the local irq and
-	 * set again the polling flag
+	 * case, exit the function after re-enabling the local irq.
 	 */
-	if (current_clr_polling_and_test()) {
+	if (need_resched()) {
 		local_irq_enable();
-		__current_set_polling();
 		return 0;
 	}
 
@@ -127,7 +125,7 @@ static int cpuidle_idle_call(void)
 			broadcast = !!(drv->states[next_state].flags &
 				       CPUIDLE_FLAG_TIMER_STOP);
 
-			if (broadcast)
+			if (broadcast) {
 				/*
 				 * Tell the time framework to switch
 				 * to a broadcast timer because our
@@ -139,6 +137,7 @@ static int cpuidle_idle_call(void)
 				ret = clockevents_notify(
 					CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
 					&dev->cpu);
+			}
 
 			if (!ret) {
 				trace_cpu_idle_rcuidle(next_state, dev->cpu);
@@ -175,8 +174,12 @@ static int cpuidle_idle_call(void)
 	 * We can't use the cpuidle framework, let's use the default
 	 * idle routine
 	 */
-	if (ret)
-		arch_cpu_idle();
+	if (ret) {
+		if (!current_clr_polling_and_test())
+			arch_cpu_idle();
+		else
+			local_irq_enable();
+	}
 
 	__current_set_polling();
 
