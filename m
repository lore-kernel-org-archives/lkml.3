Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaBTQYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:24:45 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27156 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443AbaBTQYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:24:42 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-75-53062c4883a3
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, john.stultz@linaro.org
Cc: anton@enomsg.org, kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org, Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH v4 3/6] hrtimer: Add support for deferrable timer into the
 hrtimer
Date: Thu, 20 Feb 2014 20:23:42 +0400
Message-id: <1392913425-29369-4-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xa7oeOmzBBosWS1nMvXuexWLO+jVs
	Fge3alpc//Kc1eLMb12Ls01v2C0u75rDZrF501RmBw6PCf2fGD3uXNvD5vHu3Dl2jxMzfrN4
	9G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV8b9H4/YCm4bVjRvW8PWwHhGo4uRg0NCwETi64Ww
	LkZOIFNM4sK99WxdjFwcQgJLGSWuHPzLApIQEuhhkni9MAmknk3AQGLfPVuQsIiAj8SuiR+Z
	QOqZBfoZJQ5Of84OUiMsECIxZ3kBSA2LgKrEnMl/mUHCvALuEi/W6UJsVZCYM8kGxOQU8JDo
	WicDscdd4sjCc2wTGHkXMDKsYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJra87GJceszrE
	KMDBqMTDe1KKLViINbGsuDL3EKMEB7OSCK+7ClCINyWxsiq1KD++qDQntfgQIxMHp1QDY/bV
	00kBmaZ7dYu/aDp82bDmz4zi5g+7vNn3rM26+XyO7NEJbzvVWX32FD/wj4vbouh6o/LP4pkM
	3+YyhQbNlLnv9siLs3BbXWuPI9eqw8zL3G6+0r52q3K1dsnjzD2cnas+Lc2487SsxdigN6T4
	QdCahX3zuLyOC8wt4/Nru+2Qv3Xh1CzWL0osxRmJhlrMRcWJABxjM10LAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

This patch introduces new public CLOCKID constants for
user space API, such as timerfd. It extends hrtimer API and makes
possible to have unified interfaces where deferreble functionality is
used. In-kernel users such as device drivers could find benefits too.

High resolution timer now could work with CLOCK_REALTIME_DEFERRABLE,
CLOCK_MONOTONIC_DEFERRABLE, CLOCK_BOOTTIME_DEFERRABLE.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 include/linux/hrtimer.h   |    3 +++
 include/uapi/linux/time.h |    3 +++
 kernel/hrtimer.c          |   62 +++++++++++++++++++++++++++++++++++----------
 3 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index d19a5c2..fe1159c 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -158,6 +158,9 @@ enum  hrtimer_base_type {
 	HRTIMER_BASE_REALTIME,
 	HRTIMER_BASE_BOOTTIME,
 	HRTIMER_BASE_TAI,
+	HRTIMER_BASE_MONOTONIC_DEFERRABLE,
+	HRTIMER_BASE_REALTIME_DEFERRABLE,
+	HRTIMER_BASE_BOOTTIME_DEFERRABLE,
 	HRTIMER_MAX_CLOCK_BASES,
 };
 
diff --git a/include/uapi/linux/time.h b/include/uapi/linux/time.h
index e75e1b6..bb8dc60 100644
--- a/include/uapi/linux/time.h
+++ b/include/uapi/linux/time.h
@@ -56,6 +56,9 @@ struct itimerval {
 #define CLOCK_BOOTTIME_ALARM		9
 #define CLOCK_SGI_CYCLE			10	/* Hardware specific */
 #define CLOCK_TAI			11
+#define CLOCK_REALTIME_DEFERRABLE	12
+#define CLOCK_MONOTONIC_DEFERRABLE	13
+#define CLOCK_BOOTTIME_DEFERRABLE	14
 
 #define MAX_CLOCKS			16
 #define CLOCKS_MASK			(CLOCK_REALTIME | CLOCK_MONOTONIC)
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 0909436..d1478fc 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -92,14 +92,35 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 			.get_time = &ktime_get_clocktai,
 			.resolution = KTIME_LOW_RES,
 		},
+		{
+			.index = HRTIMER_BASE_MONOTONIC_DEFERRABLE,
+			.clockid = CLOCK_MONOTONIC_DEFERRABLE,
+			.get_time = &ktime_get,
+			.resolution = KTIME_LOW_RES,
+		},
+		{
+			.index = HRTIMER_BASE_REALTIME_DEFERRABLE,
+			.clockid = CLOCK_REALTIME_DEFERRABLE,
+			.get_time = &ktime_get_real,
+			.resolution = KTIME_LOW_RES,
+		},
+		{
+			.index = HRTIMER_BASE_BOOTTIME_DEFERRABLE,
+			.clockid = CLOCK_BOOTTIME_DEFERRABLE,
+			.get_time = &ktime_get_boottime,
+			.resolution = KTIME_LOW_RES,
+		},
 	}
 };
 
 static const int hrtimer_clock_to_base_table[MAX_CLOCKS] = {
-	[CLOCK_REALTIME]	= HRTIMER_BASE_REALTIME,
-	[CLOCK_MONOTONIC]	= HRTIMER_BASE_MONOTONIC,
-	[CLOCK_BOOTTIME]	= HRTIMER_BASE_BOOTTIME,
-	[CLOCK_TAI]		= HRTIMER_BASE_TAI,
+	[CLOCK_REALTIME]		= HRTIMER_BASE_REALTIME,
+	[CLOCK_MONOTONIC]		= HRTIMER_BASE_MONOTONIC,
+	[CLOCK_BOOTTIME]		= HRTIMER_BASE_BOOTTIME,
+	[CLOCK_TAI]			= HRTIMER_BASE_TAI,
+	[CLOCK_REALTIME_DEFERRABLE]	= HRTIMER_BASE_REALTIME_DEFERRABLE,
+	[CLOCK_MONOTONIC_DEFERRABLE]	= HRTIMER_BASE_MONOTONIC_DEFERRABLE,
+	[CLOCK_BOOTTIME_DEFERRABLE]	= HRTIMER_BASE_BOOTTIME_DEFERRABLE,
 };
 
 static inline int hrtimer_clockid_to_base(clockid_t clock_id)
@@ -194,7 +215,8 @@ hrtimer_check_target(struct hrtimer *timer, struct hrtimer_clock_base *new_base)
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t expires;
 
-	if (!new_base->cpu_base->hres_active)
+	if (!new_base->cpu_base->hres_active ||
+	    new_base->index >= HRTIMER_BASE_MONOTONIC_DEFERRABLE)
 		return 0;
 
 	expires = ktime_sub(hrtimer_get_expires(timer), new_base->offset);
@@ -556,7 +578,7 @@ hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 
 	expires_next.tv64 = KTIME_MAX;
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
+	for (i = 0; i < HRTIMER_BASE_MONOTONIC_DEFERRABLE; i++, base++) {
 		struct hrtimer *timer;
 		struct timerqueue_node *next;
 
@@ -615,6 +637,13 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 		return 0;
 
 	/*
+	 * Deferrable timers are not touching the underlying
+	 * hardware.
+	 */
+	if (base->index >= HRTIMER_BASE_MONOTONIC_DEFERRABLE)
+		return 0;
+
+	/*
 	 * CLOCK_REALTIME timer might be requested with an absolute
 	 * expiry time which is less than base->offset. Nothing wrong
 	 * about that, just avoid to call into the tick code, which
@@ -924,7 +953,10 @@ static void __remove_hrtimer(struct hrtimer *timer,
 
 			expires = ktime_sub(hrtimer_get_expires(timer),
 					    base->offset);
-			if (base->cpu_base->expires_next.tv64 == expires.tv64)
+
+			/* We only care about non deferrable timers here */
+			if (base->index <= HRTIMER_BASE_MONOTONIC_DEFERRABLE &&
+			    base->cpu_base->expires_next.tv64 == expires.tv64)
 				hrtimer_force_reprogram(base->cpu_base, 1);
 		}
 #endif
@@ -1152,7 +1184,7 @@ ktime_t hrtimer_get_next_event(void)
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 
 	if (!hrtimer_hres_active()) {
-		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
+		for (i = 0; i < HRTIMER_BASE_MONOTONIC_DEFERRABLE; i++, base++) {
 			struct hrtimer *timer;
 			struct timerqueue_node *next;
 
@@ -1284,7 +1316,8 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
 	ktime_t expires_next, now, entry_time, delta;
-	int i, retries = 0;
+	unsigned long bases;
+	int retries = 0;
 
 	BUG_ON(!cpu_base->hres_active);
 	cpu_base->nr_events++;
@@ -1302,14 +1335,16 @@ retry:
 	 * this CPU.
 	 */
 	cpu_base->expires_next.tv64 = KTIME_MAX;
+	bases = cpu_base->active_bases;
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
+	while (bases) {
 		struct hrtimer_clock_base *base;
 		struct timerqueue_node *node;
 		ktime_t basenow;
+		int i;
 
-		if (!(cpu_base->active_bases & (1 << i)))
-			continue;
+		i = __ffs(bases);
+		bases &= ~(1 << i);
 
 		base = cpu_base->clock_base + i;
 		basenow = ktime_add(now, base->offset);
@@ -1339,7 +1374,8 @@ retry:
 						    base->offset);
 				if (expires.tv64 < 0)
 					expires.tv64 = KTIME_MAX;
-				if (expires.tv64 < expires_next.tv64)
+				if (expires.tv64 < expires_next.tv64 &&
+				    base->index <= HRTIMER_BASE_MONOTONIC_DEFERRABLE)
 					expires_next = expires;
 				break;
 			}
-- 
1.7.9.5

