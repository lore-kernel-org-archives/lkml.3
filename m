Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbaBUR4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:56:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:42638 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbaBUR4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:56:07 -0500
Message-Id: <20140221174639.557494772@linutronix.de>
User-Agent: quilt/0.60-1
Date: Fri, 21 Feb 2014 17:56:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Alexey Perevalov <a.perevalov@samsung.com>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com
Subject: [RFC patch 2/5] hrtimer: Make use of the active bases bitfield
References: <20140221173936.583477951@linutronix.de>
Content-Disposition: inline; filename=hrtimer-use-active-bases.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of looping through all bases, find the active ones via the
cpu_base->active_bases bit field.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/hrtimer.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

Index: tip/kernel/hrtimer.c
===================================================================
--- tip.orig/kernel/hrtimer.c
+++ tip/kernel/hrtimer.c
@@ -1284,7 +1284,8 @@ void hrtimer_interrupt(struct clock_even
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	ktime_t expires_next, now, entry_time, delta;
-	int i, retries = 0;
+	unsigned long bases;
+	int retries = 0;
 
 	BUG_ON(!cpu_base->hres_active);
 	cpu_base->nr_events++;
@@ -1302,16 +1303,18 @@ retry:
 	 * this CPU.
 	 */
 	cpu_base->expires_next.tv64 = KTIME_MAX;
+	bases = cpu_base->active_bases;
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
+	while (bases) {
 		struct hrtimer_clock_base *base;
 		struct timerqueue_node *node;
 		ktime_t basenow;
+		int idx;
 
-		if (!(cpu_base->active_bases & (1 << i)))
-			continue;
+		idx = __ffs(bases);
+		bases &= ~(1 << idx);
 
-		base = cpu_base->clock_base + i;
+		base = cpu_base->clock_base + idx;
 		basenow = ktime_add(now, base->offset);
 
 		while ((node = timerqueue_getnext(&base->active))) {
@@ -1479,18 +1482,24 @@ void hrtimer_run_pending(void)
  */
 void hrtimer_run_queues(void)
 {
-	struct timerqueue_node *node;
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-	struct hrtimer_clock_base *base;
-	int index, gettime = 1;
+	unsigned long bases;
+	int gettime = 1;
 
 	if (hrtimer_hres_active())
 		return;
 
-	for (index = 0; index < HRTIMER_MAX_CLOCK_BASES; index++) {
-		base = &cpu_base->clock_base[index];
-		if (!timerqueue_getnext(&base->active))
-			continue;
+	bases = cpu_base->active_bases;
+
+	while (bases) {
+		struct hrtimer_clock_base *base;
+		struct timerqueue_node *node;
+		int idx;
+
+		idx = __ffs(bases);
+		bases &= ~(1 << idx);
+
+		base = &cpu_base->clock_base[idx];
 
 		if (gettime) {
 			hrtimer_get_softirq_time(cpu_base);


