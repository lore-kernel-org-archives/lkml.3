Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaDDGmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:42:18 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:64806 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbaDDGmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:42:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 24/36] hrtimer: Use for_each_active_base() to iterate over active clock bases
Date: Fri,  4 Apr 2014 12:06:07 +0530
Message-Id: <12b00acd325068b14ef079a6740dca9eb1ce3734.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are various places where we are currently running a loop of
HRTIMER_MAX_CLOCK_BASES iterations. We just run 'continue;' if there are no
timers added to a clock base. Instead we can use the new for_each_active_base()
routine to iterate over only the bases which are currently active.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 58 ++++++++++++++++++++++----------------------------------
 1 file changed, 23 insertions(+), 35 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ceadfa5..b3ab19a 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -557,21 +557,17 @@ static inline int hrtimer_hres_active(void)
 static void
 hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 {
-	int i;
-	struct hrtimer_clock_base *base = cpu_base->clock_base;
+	struct hrtimer_clock_base *base;
+	struct hrtimer *timer;
 	ktime_t expires, expires_next;
+	unsigned int active_bases;
+	int i;
 
 	expires_next.tv64 = KTIME_MAX;
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
-		struct hrtimer *timer;
-		struct timerqueue_node *next;
-
-		next = timerqueue_getnext(&base->active);
-		if (!next)
-			continue;
-		timer = container_of(next, struct hrtimer, node);
-
+	for_each_active_base(i, base, cpu_base, active_bases) {
+		timer = container_of(timerqueue_getnext(&base->active),
+				     struct hrtimer, node);
 		expires = hrtimer_get_monoexpires(timer, base);
 		/*
 		 * clock_was_set() has changed base->offset so the
@@ -1131,23 +1127,19 @@ EXPORT_SYMBOL_GPL(hrtimer_get_remaining);
 ktime_t hrtimer_get_next_event(void)
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-	struct hrtimer_clock_base *base = cpu_base->clock_base;
+	struct hrtimer_clock_base *base;
 	ktime_t delta, mindelta = { .tv64 = KTIME_MAX };
+	struct hrtimer *timer;
+	unsigned int active_bases;
 	unsigned long flags;
 	int i;
 
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 
 	if (!hrtimer_hres_active()) {
-		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
-			struct hrtimer *timer;
-			struct timerqueue_node *next;
-
-			next = timerqueue_getnext(&base->active);
-			if (!next)
-				continue;
-
-			timer = container_of(next, struct hrtimer, node);
+		for_each_active_base(i, base, cpu_base, active_bases) {
+			timer = container_of(timerqueue_getnext(&base->active),
+					     struct hrtimer, node);
 			delta.tv64 = hrtimer_get_expires_tv64(timer);
 			delta = ktime_sub(delta, base->get_time());
 			if (delta.tv64 < mindelta.tv64)
@@ -1270,7 +1262,9 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 void hrtimer_interrupt(struct clock_event_device *dev)
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
+	struct hrtimer_clock_base *base;
 	ktime_t expires_next, now, entry_time, delta;
+	unsigned int active_bases;
 	int i, retries = 0;
 
 	BUG_ON(!cpu_base->hres_active);
@@ -1290,15 +1284,10 @@ retry:
 	 */
 	cpu_base->expires_next.tv64 = KTIME_MAX;
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
-		struct hrtimer_clock_base *base;
+	for_each_active_base(i, base, cpu_base, active_bases) {
 		struct timerqueue_node *node;
 		ktime_t basenow;
 
-		if (!(cpu_base->active_bases & (1 << i)))
-			continue;
-
-		base = cpu_base->clock_base + i;
 		basenow = ktime_add(now, base->offset);
 
 		while ((node = timerqueue_getnext(&base->active))) {
@@ -1468,16 +1457,13 @@ void hrtimer_run_queues(void)
 	struct timerqueue_node *node;
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	struct hrtimer_clock_base *base;
+	unsigned int active_bases;
 	int index, gettime = 1;
 
 	if (hrtimer_hres_active())
 		return;
 
-	for (index = 0; index < HRTIMER_MAX_CLOCK_BASES; index++) {
-		base = &cpu_base->clock_base[index];
-		if (!timerqueue_getnext(&base->active))
-			continue;
-
+	for_each_active_base(index, base, cpu_base, active_bases) {
 		if (gettime) {
 			hrtimer_get_softirq_time(cpu_base);
 			gettime = 0;
@@ -1697,6 +1683,8 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 static void migrate_hrtimers(int scpu)
 {
 	struct hrtimer_cpu_base *old_base, *new_base;
+	struct hrtimer_clock_base *clock_base;
+	unsigned int active_bases;
 	int i;
 
 	BUG_ON(cpu_online(scpu));
@@ -1712,9 +1700,9 @@ static void migrate_hrtimers(int scpu)
 	raw_spin_lock(&new_base->lock);
 	raw_spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
-		migrate_hrtimer_list(&old_base->clock_base[i],
-				     &new_base->clock_base[i]);
+	for_each_active_base(i, clock_base, old_base, active_bases)
+		migrate_hrtimer_list(clock_base,
+				     &new_base->clock_base[clock_base->index]);
 
 	raw_spin_unlock(&old_base->lock);
 	raw_spin_unlock(&new_base->lock);
-- 
1.7.12.rc2.18.g61b472e

