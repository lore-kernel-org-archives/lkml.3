Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaFUX3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 19:29:39 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:62569 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaFUX31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 19:29:27 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/5] hrtimer: Store cpu-number in 'struct hrtimer_cpu_base'
Date: Sun, 22 Jun 2014 01:29:15 +0200
Message-Id: <1403393357-2070-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1403393357-2070-1-git-send-email-fweisbec@gmail.com>
References: <1403393357-2070-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

In lowres mode, hrtimers are serviced by the tick instead of a clock
event. Now it works well as long as the tick stays periodic but we
must also make sure that the hrtimers are serviced in dynticks mode.

Part of that job consist in kicking a dynticks hrtimer target in order
to make it reconsider the next tick to schedule to correctly handle the
hrtimer's expiring time. And that part isn't handled by the hrtimers
subsystem.

To prepare for fixing this, we need __hrtimer_start_range_ns() to be
able to resolve the CPU target associated to a hrtimer's object
'cpu_base' so that the kick can be centralized there.

So lets store it in the 'struct hrtimer_cpu_base' to resolve the CPU
without overhead. It is set once at CPU's online notification.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/hrtimer.h | 2 ++
 kernel/hrtimer.c        | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index e7a8d3f..bb4ffff 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -165,6 +165,7 @@ enum  hrtimer_base_type {
  * struct hrtimer_cpu_base - the per cpu clock bases
  * @lock:		lock protecting the base and associated clock bases
  *			and timers
+ * @cpu:		cpu number
  * @active_bases:	Bitfield to mark bases with active timers
  * @clock_was_set:	Indicates that clock was set from irq context.
  * @expires_next:	absolute time of the next event which was scheduled
@@ -179,6 +180,7 @@ enum  hrtimer_base_type {
  */
 struct hrtimer_cpu_base {
 	raw_spinlock_t			lock;
+	unsigned int			cpu;
 	unsigned int			active_bases;
 	unsigned int			clock_was_set;
 #ifdef CONFIG_HIGH_RES_TIMERS
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 3ab2899..0e32d4e 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1680,6 +1680,7 @@ static void init_hrtimers_cpu(int cpu)
 		timerqueue_init_head(&cpu_base->clock_base[i].active);
 	}
 
+	cpu_base->cpu = cpu;
 	hrtimer_init_hres(cpu_base);
 }
 
-- 
1.8.3.1

