Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaDDGle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:41:34 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:45848 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaDDGlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:41:22 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 16/36] hrtimer: Create hrtimer_get_monoexpires()
Date: Fri,  4 Apr 2014 12:05:59 +0530
Message-Id: <f4cfdcca46828d7adbfc763dd70a2ae0b724b9ad.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following code is repeated at many places:
	ktime_sub(hrtimer_get_expires(timer), base->offset);

and so it makes sense to create a separate inlined routine for this.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/hrtimer.h |  6 ++++++
 kernel/hrtimer.c        | 11 +++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 17c08ca..d1836cb 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -233,6 +233,12 @@ static inline ktime_t hrtimer_get_expires(const struct hrtimer *timer)
 	return timer->node.expires;
 }
 
+static inline ktime_t hrtimer_get_monoexpires(const struct hrtimer *timer,
+		struct hrtimer_clock_base *base)
+{
+	return ktime_sub(hrtimer_get_expires(timer), base->offset);
+}
+
 static inline ktime_t hrtimer_get_softexpires(const struct hrtimer *timer)
 {
 	return timer->_softexpires;
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 5b0cbe7..1a1fdc0 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -184,7 +184,7 @@ hrtimer_check_target(struct hrtimer *timer, struct hrtimer_clock_base *new_base)
 	if (!new_base->cpu_base->hres_active)
 		return 0;
 
-	expires = ktime_sub(hrtimer_get_expires(timer), new_base->offset);
+	expires = hrtimer_get_monoexpires(timer, new_base);
 	return expires.tv64 <= new_base->cpu_base->expires_next.tv64;
 #else
 	return 0;
@@ -554,7 +554,7 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 			continue;
 		timer = container_of(next, struct hrtimer, node);
 
-		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+		expires = hrtimer_get_monoexpires(timer, base);
 		/*
 		 * clock_was_set() has changed base->offset so the
 		 * result might be negative. Fix it up to prevent a
@@ -588,7 +588,7 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base)
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-	ktime_t expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+	ktime_t expires = hrtimer_get_monoexpires(timer, base);
 	int res;
 
 	WARN_ON_ONCE(hrtimer_get_expires_tv64(timer) < 0);
@@ -898,7 +898,7 @@ static void __remove_hrtimer(struct hrtimer *timer,
 	    &timer->node == next_timer) {
 		ktime_t expires;
 
-		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+		expires = hrtimer_get_monoexpires(timer, base);
 		if (base->cpu_base->expires_next.tv64 == expires.tv64)
 			hrtimer_force_reprogram(base->cpu_base, 1);
 	}
@@ -1309,8 +1309,7 @@ retry:
 			if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer)) {
 				ktime_t expires;
 
-				expires = ktime_sub(hrtimer_get_expires(timer),
-						    base->offset);
+				expires = hrtimer_get_monoexpires(timer, base);
 				if (expires.tv64 < 0)
 					expires.tv64 = KTIME_MAX;
 				if (expires.tv64 < expires_next.tv64)
-- 
1.7.12.rc2.18.g61b472e

