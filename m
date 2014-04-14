Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbaDNQfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:35:44 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48724 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747AbaDNQ1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:27:15 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 27/38] tick-sched: remove 'regs' parameter of tick_sched_handle()
Date: Mon, 14 Apr 2014 21:53:49 +0530
Message-Id: <4e9e4b7fe0a9417777ab1b7543209da5999d7414.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_sched_handle() is called from two places and both pass 'regs' to it almost
same way. This patch removes this parameter to tick_sched_handle() and updates
tick_sched_handle() to get that by itself.

The only point of difference in the way this routine was called from its callers
was, don't call it from process context. To make sure the nohz path doesn't
suffer from an additional branch instruction, add unlikely to the if()
statement.

Though I still don't understand when will we run tick_sched_timer() from process
context. I couldn't see a single instance of that happening on my test machine
for normal boot followed by some userspace operations.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-sched.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index bff7f97..ee0768b 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -129,8 +129,17 @@ static void tick_sched_do_timer(ktime_t now)
 		tick_do_update_jiffies64(now);
 }
 
-static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
+static void tick_sched_handle(struct tick_sched *ts)
 {
+	struct pt_regs *regs = get_irq_regs();
+
+	/*
+	 * Do not call, when we are not in irq context and have
+	 * no valid regs pointer
+	 */
+	if (unlikely(!regs))
+		return;
+
 #ifdef CONFIG_NO_HZ_COMMON
 	/*
 	 * When we are idle and the tick is stopped, we have to touch
@@ -942,13 +951,12 @@ static int tick_nohz_reprogram(struct tick_sched *ts, ktime_t now)
 static void tick_nohz_handler(struct clock_event_device *dev)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
-	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
 
 	dev->next_event.tv64 = KTIME_MAX;
 
 	tick_sched_do_timer(now);
-	tick_sched_handle(ts, regs);
+	tick_sched_handle(ts);
 
 	while (tick_nohz_reprogram(ts, now)) {
 		now = ktime_get();
@@ -1065,17 +1073,10 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 {
 	struct tick_sched *ts =
 		container_of(timer, struct tick_sched, sched_timer);
-	struct pt_regs *regs = get_irq_regs();
 	ktime_t now = ktime_get();
 
 	tick_sched_do_timer(now);
-
-	/*
-	 * Do not call, when we are not in irq context and have
-	 * no valid regs pointer
-	 */
-	if (regs)
-		tick_sched_handle(ts, regs);
+	tick_sched_handle(ts);
 
 	hrtimer_forward(timer, now, tick_period);
 
-- 
1.7.12.rc2.18.g61b472e

