Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab3IHP7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 11:59:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3IHP4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 11:56:48 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=hfnr_yKHR2EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=0Y4sWKI711YA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=6_mJPgj3Y11pTnSMgxAA:9 a=hPjdaMEvmhQA:10 a=Zh68SRI7RUMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130908151446.754102670@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 08 Sep 2013 11:14:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: [PATCH RT 06/19] timers: prepare for full preemption improve
References: <20130908151355.362583092@goodmis.org>
Content-Disposition: inline; filename=0006-timers-prepare-for-full-preemption-improve.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

wake_up should do nothing on the nort, so we should use wakeup_timer_waiters,
also fix a spell mistake.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
[bigeasy: s/CONFIG_PREEMPT_RT_BASE/CONFIG_PREEMPT_RT_FULL/]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/timer.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 027ce4e..61b57c1 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -76,7 +76,9 @@ struct tvec_root {
 struct tvec_base {
 	spinlock_t lock;
 	struct timer_list *running_timer;
+#ifdef CONFIG_PREEMPT_RT_FULL
 	wait_queue_head_t wait_for_running_timer;
+#endif
 	unsigned long timer_jiffies;
 	unsigned long next_timer;
 	unsigned long active_timers;
@@ -1006,7 +1008,7 @@ static void wait_for_running_timer(struct timer_list *timer)
 			   base->running_timer != timer);
 }
 
-# define wakeup_timer_waiters(b)	wake_up(&(b)->wait_for_tunning_timer)
+# define wakeup_timer_waiters(b)	wake_up(&(b)->wait_for_running_timer)
 #else
 static inline void wait_for_running_timer(struct timer_list *timer)
 {
@@ -1251,7 +1253,7 @@ static inline void __run_timers(struct tvec_base *base)
 			spin_lock_irq(&base->lock);
 		}
 	}
-	wake_up(&base->wait_for_running_timer);
+	wakeup_timer_waiters(base);
 	spin_unlock_irq(&base->lock);
 }
 
@@ -1765,7 +1767,9 @@ static int __cpuinit init_timers_cpu(int cpu)
 			base = &boot_tvec_bases;
 		}
 		spin_lock_init(&base->lock);
+#ifdef CONFIG_PREEMPT_RT_FULL
 		init_waitqueue_head(&base->wait_for_running_timer);
+#endif
 		tvec_base_done[cpu] = 1;
 	} else {
 		base = per_cpu(tvec_bases, cpu);
-- 
1.7.10.4


