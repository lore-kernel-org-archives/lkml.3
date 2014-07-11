Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaGKRzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:55:00 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:41555 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753998AbaGKRy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:54:59 -0400
To: lenb@kernel.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH] intel_idle: use static_key to optimize idle enter/exit paths
Message-Id: <20140711175458.6793B2029@prod-mail-relay06.akamai.com>
Date: Fri, 11 Jul 2014 17:54:58 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If 'arat' is set in the cpuflags, we can avoid the checks for entering/exiting
the tick broadcast code entirely. It would seem that this is a hot enough code
path to make this worthwhile. I ran a few hackbench runs, and consistenly see
reduced branches and cycles.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 drivers/idle/intel_idle.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 4d140bb..61e965c 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -80,6 +80,8 @@ static unsigned int mwait_substates;
 #define LAPIC_TIMER_ALWAYS_RELIABLE 0xFFFFFFFF
 /* Reliable LAPIC Timer States, bit 1 for C1 etc.  */
 static unsigned int lapic_timer_reliable_states = (1 << 1);	 /* Default to only C1 */
+/* if arat is set no sense in checking on each c-state transition */
+static struct static_key lapic_timer_unreliable __read_mostly;
 
 struct idle_cpu {
 	struct cpuidle_state *state_table;
@@ -507,12 +509,10 @@ static int intel_idle(struct cpuidle_device *dev,
 {
 	unsigned long ecx = 1; /* break on interrupt flag */
 	struct cpuidle_state *state = &drv->states[index];
-	unsigned long eax = flg2MWAIT(state->flags);
-	unsigned int cstate;
+	unsigned long uninitialized_var(eax);
+	unsigned int uninitialized_var(cstate);
 	int cpu = smp_processor_id();
 
-	cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) & MWAIT_CSTATE_MASK) + 1;
-
 	/*
 	 * leave_mm() to avoid costly and often unnecessary wakeups
 	 * for flushing the user TLB's associated with the active mm.
@@ -520,13 +520,22 @@ static int intel_idle(struct cpuidle_device *dev,
 	if (state->flags & CPUIDLE_FLAG_TLB_FLUSHED)
 		leave_mm(cpu);
 
-	if (!(lapic_timer_reliable_states & (1 << (cstate))))
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &cpu);
+	if (static_key_false(&lapic_timer_unreliable)) {
+		eax = flg2MWAIT(state->flags);
+		cstate = (((eax) >> MWAIT_SUBSTATE_SIZE) &
+					MWAIT_CSTATE_MASK) + 1;
+		if (!(lapic_timer_reliable_states & (1 << (cstate))))
+			clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
+					   &cpu);
+	}
 
 	mwait_idle_with_hints(eax, ecx);
 
-	if (!(lapic_timer_reliable_states & (1 << (cstate))))
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &cpu);
+	if (static_key_false(&lapic_timer_unreliable)) {
+		if (!(lapic_timer_reliable_states & (1 << (cstate))))
+			clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
+					   &cpu);
+	}
 
 	return index;
 }
@@ -702,8 +711,10 @@ static int __init intel_idle_probe(void)
 
 	if (boot_cpu_has(X86_FEATURE_ARAT))	/* Always Reliable APIC Timer */
 		lapic_timer_reliable_states = LAPIC_TIMER_ALWAYS_RELIABLE;
-	else
+	else {
+		static_key_slow_inc(&lapic_timer_unreliable);
 		on_each_cpu(__setup_broadcast_timer, (void *)true, 1);
+	}
 
 	pr_debug(PREFIX "v" INTEL_IDLE_VERSION
 		" model 0x%X\n", boot_cpu_data.x86_model);
-- 
1.8.2.rc2

