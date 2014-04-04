Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbaDDGmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:42:21 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45223 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaDDGmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:42:15 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 25/36] hrtimer: call hrtimer_get_softirq_time() only if cpu_base->active_bases is set
Date: Fri,  4 Apr 2014 12:06:08 +0530
Message-Id: <e41f13b3e2a205550970056c9f24bc8e945bdb09.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to call hrtimer_get_softirq_time() only once for a cpu_base from
hrtimer_run_queues(). And it shouldn't be called if there are no timers queued
for that cpu_base.

Currently we are managing this with help of a variable: gettime. This part of
code can be simplified by using cpu_base->active_bases instead. With this we can
get rid of the 'if' block from the loop iterating over all clock bases.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b3ab19a..2d9a7e2 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1458,19 +1458,16 @@ void hrtimer_run_queues(void)
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	struct hrtimer_clock_base *base;
 	unsigned int active_bases;
-	int index, gettime = 1;
+	int index;
 
 	if (hrtimer_hres_active())
 		return;
 
-	for_each_active_base(index, base, cpu_base, active_bases) {
-		if (gettime) {
-			hrtimer_get_softirq_time(cpu_base);
-			gettime = 0;
-		}
+	if (cpu_base->active_bases)
+		hrtimer_get_softirq_time(cpu_base);
 
+	for_each_active_base(index, base, cpu_base, active_bases) {
 		raw_spin_lock(&cpu_base->lock);
-
 		while ((node = timerqueue_getnext(&base->active))) {
 			struct hrtimer *timer;
 
-- 
1.7.12.rc2.18.g61b472e

