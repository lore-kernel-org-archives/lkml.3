Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaB1Ipg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 03:45:36 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:63186 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaB1Ipe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 03:45:34 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, tj@kernel.org, peterz@infradead.org,
        mingo@kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] timer: check failure of timer_cpu_notify() before calling init_timer_stats()
Date: Fri, 28 Feb 2014 14:15:21 +0530
Message-Id: <c439f5b6bbc2047e1662f4d523350531425bcf9d.1393576981.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

timer_cpu_notify() should return NOTIFY_OK and nothing else. Anything else would
trigger a BUG_ON(). Return value of this routine is already checked correctly
but is done after issuing a call to init_timer_stats(). The right order would be
to check the error case first and then call init_timer_stats(). Lets do it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index f64a98c..e8e7839 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1674,9 +1674,9 @@ void __init init_timers(void)
 
 	err = timer_cpu_notify(&timers_nb, (unsigned long)CPU_UP_PREPARE,
 			       (void *)(long)smp_processor_id());
-	init_timer_stats();
-
 	BUG_ON(err != NOTIFY_OK);
+
+	init_timer_stats();
 	register_cpu_notifier(&timers_nb);
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
 }
-- 
1.7.12.rc2.18.g61b472e

