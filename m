Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaDDGvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:51:07 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:42285 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaDDGk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:40:58 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 12/36] hrtimer: use base->hres_active directly instead of hrtimer_hres_active()
Date: Fri,  4 Apr 2014 12:05:55 +0530
Message-Id: <60a6ed11683347eb697dd739444d9c927e52e4b9.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

retrigger_next_event() is defined within #ifdef CONFIG_HIGH_RES_TIMERS as we
already have pointer to base available. So it makes more sense to simple use
base->hres_active instead of doing this by calling hrtimer_hres_active():

	__this_cpu_read(hrtimer_bases.hres_active)

Also the same reason apply to code in __remove_hrtimer().

There is one more noticeable issue with __remove_hrtimer() without this patch.
We are checking hres_active of *this cpu's* base, where as it is not guanrateed
at all that __remove_hrtimer() would be called on this CPU. Specially from the
migration code, timer's CPU is already down.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index b0fbf12..ad5b7ba 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -672,7 +672,7 @@ static void retrigger_next_event(void *arg)
 {
 	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
 
-	if (!hrtimer_hres_active())
+	if (!base->hres_active)
 		return;
 
 	raw_spin_lock(&base->lock);
@@ -897,7 +897,7 @@ static void __remove_hrtimer(struct hrtimer *timer,
 	if (&timer->node == next_timer) {
 #ifdef CONFIG_HIGH_RES_TIMERS
 		/* Reprogram the clock event device. if enabled */
-		if (reprogram && hrtimer_hres_active()) {
+		if (reprogram && base->cpu_base->hres_active) {
 			ktime_t expires;
 
 			expires = ktime_sub(hrtimer_get_expires(timer),
-- 
1.7.12.rc2.18.g61b472e

