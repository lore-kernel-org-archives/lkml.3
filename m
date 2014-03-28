Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaC1LmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 07:42:15 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:41753 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaC1LmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:42:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, linaro-networking@linaro.org,
        Arvind.Chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 03/16] hrtimer: Create hrtimer_get_monoexpires()
Date: Fri, 28 Mar 2014 17:11:22 +0530
Message-Id: <2619470bbeea98a34d7f8b98bb9cef9751bd6e29.1396006658.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396006658.git.viresh.kumar@linaro.org>
References: <cover.1396006658.git.viresh.kumar@linaro.org>
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
index 6f524db..377023b 100644
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
index 6476152..675fe9e 100644
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
@@ -555,7 +555,7 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 			continue;
 		timer = container_of(next, struct hrtimer, node);
 
-		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+		expires = hrtimer_get_monoexpires(timer, base);
 		/*
 		 * clock_was_set() has changed base->offset so the
 		 * result might be negative. Fix it up to prevent a
@@ -589,7 +589,7 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base)
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-	ktime_t expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+	ktime_t expires = hrtimer_get_monoexpires(timer, base);
 	int res;
 
 	WARN_ON_ONCE(hrtimer_get_expires_tv64(timer) < 0);
@@ -898,7 +898,7 @@ static void __remove_hrtimer(struct hrtimer *timer,
 	    &timer->node == timerqueue_getnext(&base->active)) {
 		ktime_t expires;
 
-		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+		expires = hrtimer_get_monoexpires(timer, base);
 		if (base->cpu_base->expires_next.tv64 == expires.tv64)
 			hrtimer_force_reprogram(base->cpu_base, 1);
 	}
@@ -1306,8 +1306,7 @@ retry:
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

