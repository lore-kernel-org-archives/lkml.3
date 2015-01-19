Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895AbbASF2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 00:28:11 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37574 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbbASF2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 00:28:09 -0500
Subject: [PATCH] idle/tick-broadcast: Exit cpu idle poll loop when cleared
 from tick_broadcast_force_mask
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: tglx@linutronix.de
Cc: peterz@infradead.org, linuxppc-dev@lists.ozlabs.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2015 10:57:54 +0530
Message-ID: <20150119052754.20256.54721.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011905-0037-0000-0000-000000635D62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An idle cpu enters cpu_idle_poll() if it is set in the tick_broadcast_force_mask.
This is so that it does not incur the overhead of entering idle states when it is expected
to be woken up anytime then through a broadcast IPI. The condition that forces an exit out
of the idle polling is the check on setting of the TIF_NEED_RESCHED flag for the idle thread.

When the broadcast IPI does arrive, it is not guarenteed that the handler sets the
TIF_NEED_RESCHED flag. Hence although the cpu is cleared in the tick_broadcast_force_mask,
it continues to loop in cpu_idle_poll unnecessarily wasting power. Hence exit the idle
poll loop if the tick_broadcast_force_mask gets cleared and enter idle states.

Of course if the cpu has entered cpu_idle_poll() on being asked to poll explicitly,
it continues to poll till it is asked to reschedule.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

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

