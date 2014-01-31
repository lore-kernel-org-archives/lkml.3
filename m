Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaAaOeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:34:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:54693 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314AbaAaOeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:34:12 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/2] timer: really raise softirq if there is irq_work to do
Date: Fri, 31 Jan 2014 15:34:05 +0100
Message-Id: <1391178845-15837-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>
References: <1391178845-15837-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

from looking at the code, it seems that the softirq is only raised (in
the !base->active_timers case) if we have also an expired timer
(time_before_eq() is true). This patch ensures that the timer softirq is
also raised in the !base->active_timers && no timer expired.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/timer.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 6b3c172..b04c879 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1453,6 +1453,7 @@ static void run_timer_softirq(struct softirq_action *h)
 void run_local_timers(void)
 {
 	struct tvec_base *base = __this_cpu_read(tvec_bases);
+	bool need_raise = false;
 
 	hrtimer_run_queues();
 	/*
@@ -1470,12 +1471,17 @@ void run_local_timers(void)
 #ifdef CONFIG_PREEMPT_RT_FULL
 		/* On RT, irq work runs from softirq */
 		if (!irq_work_needs_cpu())
-#endif
 			goto out;
+		need_raise = true;
+#else
+		goto out;
+#endif
 	}
 
 	/* Check whether the next pending timer has expired */
 	if (time_before_eq(base->next_timer, jiffies))
+		need_raise = true;
+	if (need_raise)
 		raise_softirq(TIMER_SOFTIRQ);
 out:
 #ifdef CONFIG_PREEMPT_RT_FULL
-- 
1.8.5.3

