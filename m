Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbaKGObk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:31:40 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:51604 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbaKGObh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:31:37 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rjw@rjwysocki.net
Cc: preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, lenb@kernel.org
Subject: [PATCH V3 1/6] sched: idle: Add a weak arch_cpu_idle_poll function
Date: Fri,  7 Nov 2014 15:31:22 +0100
Message-Id: <1415370687-18688-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The poll function is called when a timer expired or if we force to poll when
the cpu_idle_force_poll option is set.

The poll function does:

       local_irq_enable();
       while (!tif_need_resched())
               cpu_relax();

This default poll function suits for the x86 arch because its rep; nop;
hardware power optimization. But on other archs, this optimization does not
exists and we are not saving power. The arch specific bits may want to
optimize this loop by adding their own optimization.

Give an opportunity to the different platform to specify their own polling
loop by adding a weak cpu_idle_poll_loop function.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 kernel/sched/idle.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index c47fce7..ea65bbae 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -42,18 +42,6 @@ static int __init cpu_idle_nopoll_setup(char *__unused)
 __setup("hlt", cpu_idle_nopoll_setup);
 #endif
 
-static inline int cpu_idle_poll(void)
-{
-	rcu_idle_enter();
-	trace_cpu_idle_rcuidle(0, smp_processor_id());
-	local_irq_enable();
-	while (!tif_need_resched())
-		cpu_relax();
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
-	rcu_idle_exit();
-	return 1;
-}
-
 /* Weak implementations for optional arch specific functions */
 void __weak arch_cpu_idle_prepare(void) { }
 void __weak arch_cpu_idle_enter(void) { }
@@ -65,6 +53,23 @@ void __weak arch_cpu_idle(void)
 	local_irq_enable();
 }
 
+void __weak arch_cpu_idle_poll(void)
+{
+	local_irq_enable();
+	while (!tif_need_resched())
+		cpu_relax();
+}
+
+static inline int cpu_idle_poll(void)
+{
+	rcu_idle_enter();
+	trace_cpu_idle_rcuidle(0, smp_processor_id());
+	arch_cpu_idle_poll();
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
+	rcu_idle_exit();
+	return 1;
+}
+
 /**
  * cpuidle_idle_call - the main idle function
  *
-- 
1.9.1

