Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbbAXBqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:46:05 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64122 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbbAXBoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:44:13 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nico@linaro.org>, John Stultz <john.stultz@linaro.org>
Subject: [PATCH 1/8] ktime: Optimize ktime_divns for constant divisors
Date: Fri, 23 Jan 2015 17:43:53 -0800
Message-Id: <1422063840-2837-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
References: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Pitre <nicolas.pitre@linaro.org>

At least on ARM, do_div() is optimized to turn constant divisors into
an inline multiplication by the reciprocal value at compile time.
However this optimization is missed entirely whenever ktime_divns() is
used and the slow out-of-line division code is used all the time.

Let ktime_divns() use do_div() inline whenever the divisor is constant
and small enough.  This will make things like ktime_to_us() and
ktime_to_ms() much faster.

Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Nicolas Pitre <nico@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/ktime.h | 12 +++++++++++-
 kernel/time/hrtimer.c |  4 ++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index c9d645a..411dd8b 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -166,7 +166,17 @@ static inline bool ktime_before(const ktime_t cmp1, const ktime_t cmp2)
 }
 
 #if BITS_PER_LONG < 64
-extern u64 ktime_divns(const ktime_t kt, s64 div);
+extern u64 __ktime_divns(const ktime_t kt, s64 div);
+static inline u64 ktime_divns(const ktime_t kt, s64 div)
+{
+	if (__builtin_constant_p(div) && !(div >> 32)) {
+		u64 ns = kt.tv64;
+		do_div(ns, div);
+		return ns;
+	} else {
+		return __ktime_divns(kt, div);
+	}
+}
 #else /* BITS_PER_LONG < 64 */
 # define ktime_divns(kt, div)		(u64)((kt).tv64 / (div))
 #endif
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 37e50aa..890535c 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -266,7 +266,7 @@ lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 /*
  * Divide a ktime value by a nanosecond value
  */
-u64 ktime_divns(const ktime_t kt, s64 div)
+u64 __ktime_divns(const ktime_t kt, s64 div)
 {
 	u64 dclc;
 	int sft = 0;
@@ -282,7 +282,7 @@ u64 ktime_divns(const ktime_t kt, s64 div)
 
 	return dclc;
 }
-EXPORT_SYMBOL_GPL(ktime_divns);
+EXPORT_SYMBOL_GPL(__ktime_divns);
 #endif /* BITS_PER_LONG >= 64 */
 
 /*
-- 
1.9.1

