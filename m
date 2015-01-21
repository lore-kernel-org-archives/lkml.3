Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbbAUK5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:57:52 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54173 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbbAUK5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:57:43 -0500
Subject: [PATCH V2] cpuidle: Add missing checks to the exit condition of
 cpu_idle_poll()
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: tglx@linutronix.de
Cc: peterz@infradead.org, linuxppc-dev@lists.ozlabs.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Jan 2015 16:27:25 +0530
Message-ID: <20150121105655.15279.59626.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012110-0033-0000-0000-0000019EC46F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_idle_poll() is entered into when either the cpu_idle_force_poll is set or
tick_check_broadcast_expired() returns true. The exit condition from
cpu_idle_poll() is tif_need_resched().

However this does not take into account scenarios where cpu_idle_force_poll
changes or tick_check_broadcast_expired() returns false, without setting
the resched flag. So a cpu will be caught in cpu_idle_poll() needlessly,
thereby wasting power. Add an explicit check on cpu_idle_force_poll and
tick_check_broadcast_expired() to the exit condition of cpu_idle_poll()
to avoid this.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
Changes from V1: Modified the Changelog

 kernel/sched/idle.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index c47fce7..aaf1c1d 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -47,7 +47,8 @@ static inline int cpu_idle_poll(void)
 	rcu_idle_enter();
 	trace_cpu_idle_rcuidle(0, smp_processor_id());
 	local_irq_enable();
-	while (!tif_need_resched())
+	while (!tif_need_resched() &&
+		(cpu_idle_force_poll || tick_check_broadcast_expired()))
 		cpu_relax();
 	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 	rcu_idle_exit();

