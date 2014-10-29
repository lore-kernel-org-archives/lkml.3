Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695AbaJ2LH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:07:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259AbaJ2LH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:07:28 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] rcu: Remove redundant rcu_is_cpu_rrupt_from_idle() function
Date: Wed, 29 Oct 2014 12:07:07 +0100
Message-Id: <1414580827-19545-1-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function rcu_is_cpu_rrupt_from_idle() is called from scheduling-
clock interrupt handler to check if the current CPU was interrupted
from idle. If true, it results in invocation of RCU callbacks. But
the common hardware interrupt exit path also contains similar check
and therefore the call to rcu_is_cpu_rrupt_from_idle() is redundant.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tiny.c | 12 +-----------
 kernel/rcu/tree.c | 14 +-------------
 2 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index c0623fc..0bfb3b9 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -186,16 +186,6 @@ EXPORT_SYMBOL(__rcu_is_watching);
 #endif /* defined(CONFIG_DEBUG_LOCK_ALLOC) || defined(CONFIG_RCU_TRACE) */
 
 /*
- * Test whether the current CPU was interrupted from idle.  Nested
- * interrupts don't count, we must be running at the first interrupt
- * level.
- */
-static int rcu_is_cpu_rrupt_from_idle(void)
-{
-	return rcu_dynticks_nesting <= 1;
-}
-
-/*
  * Helper function for rcu_sched_qs() and rcu_bh_qs().
  * Also irqs are disabled to avoid confusion due to interrupt handlers
  * invoking call_rcu().
@@ -250,7 +240,7 @@ void rcu_bh_qs(void)
 void rcu_check_callbacks(int cpu, int user)
 {
 	RCU_TRACE(check_cpu_stalls());
-	if (user || rcu_is_cpu_rrupt_from_idle())
+	if (user)
 		rcu_sched_qs();
 	else if (!in_softirq())
 		rcu_bh_qs();
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 133e472..8e9341c 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -884,18 +884,6 @@ EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
 
 #endif /* #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU) */
 
-/**
- * rcu_is_cpu_rrupt_from_idle - see if idle or immediately interrupted from idle
- *
- * If the current CPU is idle or running at a first-level (not nested)
- * interrupt from idle, return true.  The caller must have at least
- * disabled preemption.
- */
-static int rcu_is_cpu_rrupt_from_idle(void)
-{
-	return __this_cpu_read(rcu_dynticks.dynticks_nesting) <= 1;
-}
-
 /*
  * Snapshot the specified CPU's dynticks counter so that we can later
  * credit them with an implicit quiescent state.  Return 1 if this CPU
@@ -2391,7 +2379,7 @@ void rcu_check_callbacks(int cpu, int user)
 {
 	trace_rcu_utilization(TPS("Start scheduler-tick"));
 	increment_cpu_stall_ticks();
-	if (user || rcu_is_cpu_rrupt_from_idle()) {
+	if (user) {
 
 		/*
 		 * Get here if this CPU took its interrupt from user
-- 
1.8.3.1

