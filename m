Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965172AbaH0VDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:03:45 -0400
Received: from mail-oi0-f73.google.com ([209.85.218.73]:34619 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965090AbaH0VDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:03:42 -0400
From: Sonny Rao <sonnyrao@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dianders@chromium.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: [PATCH] clocksource: arch_timer: Fix code to use physical timers when requested
Date: Wed, 27 Aug 2014 14:03:39 -0700
Message-Id: <1409173419-13076-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a bug fix for using physical arch timers when
the arch_timer_use_virtual boolean is false.  It restores the
arch_counter_get_cntpct() function after removal in

0d651e4e "clocksource: arch_timer: use virtual counters"

and completes the implementation of memory mapped access for physical
timers, so if a system is trying to use physical timers, it will
function properly.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
---
 arch/arm/include/asm/arch_timer.h    |  9 +++++++++
 arch/arm64/include/asm/arch_timer.h  | 10 ++++++++++
 drivers/clocksource/arm_arch_timer.c | 30 ++++++++++++++++++++++++++----
 3 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 0704e0c..e72aa4d 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -78,6 +78,15 @@ static inline u32 arch_timer_get_cntfrq(void)
 	return val;
 }
 
+static inline u64 arch_counter_get_cntpct(void)
+{
+	u64 cval;
+
+	isb();
+	asm volatile("mrrc p15, 0, %Q0, %R0, c14" : "=r" (cval));
+	return cval;
+}
+
 static inline u64 arch_counter_get_cntvct(void)
 {
 	u64 cval;
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 9400596..58657c4 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -135,6 +135,16 @@ static inline void arch_timer_evtstrm_enable(int divider)
 #endif
 }
 
+static inline u64 arch_counter_get_cntpct(void)
+{
+	u64 cval;
+
+	isb();
+	asm volatile("mrs %0, cntpct_el0" : "=r" (cval));
+
+	return cval;
+}
+
 static inline u64 arch_counter_get_cntvct(void)
 {
 	u64 cval;
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 5163ec1..ad723cb 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -30,6 +30,8 @@
 #define CNTTIDR		0x08
 #define CNTTIDR_VIRT(n)	(BIT(1) << ((n) * 4))
 
+#define CNTPCT_LO	0x00
+#define CNTPCT_HI	0x04
 #define CNTVCT_LO	0x08
 #define CNTVCT_HI	0x0c
 #define CNTFRQ		0x10
@@ -386,6 +388,19 @@ static u64 arch_counter_get_cntvct_mem(void)
 	return ((u64) vct_hi << 32) | vct_lo;
 }
 
+static u64 arch_counter_get_cntpct_mem(void)
+{
+	u32 pct_lo, pct_hi, tmp_hi;
+
+	do {
+		pct_hi = readl_relaxed(arch_counter_base + CNTPCT_HI);
+		pct_lo = readl_relaxed(arch_counter_base + CNTPCT_LO);
+		tmp_hi = readl_relaxed(arch_counter_base + CNTPCT_HI);
+	} while (pct_hi != tmp_hi);
+
+	return ((u64) pct_hi << 32) | pct_lo;
+}
+
 /*
  * Default to cp15 based access because arm64 uses this function for
  * sched_clock() before DT is probed and the cp15 method is guaranteed
@@ -429,10 +444,17 @@ static void __init arch_counter_register(unsigned type)
 	u64 start_count;
 
 	/* Register the CP15 based counter if we have one */
-	if (type & ARCH_CP15_TIMER)
-		arch_timer_read_counter = arch_counter_get_cntvct;
-	else
-		arch_timer_read_counter = arch_counter_get_cntvct_mem;
+	if (type & ARCH_CP15_TIMER) {
+		if (arch_timer_use_virtual)
+			arch_timer_read_counter = arch_counter_get_cntvct;
+		else
+			arch_timer_read_counter = arch_counter_get_cntpct;
+	} else {
+		if (arch_timer_use_virtual)
+			arch_timer_read_counter = arch_counter_get_cntvct_mem;
+		else
+			arch_timer_read_counter = arch_counter_get_cntpct_mem;
+	}
 
 	start_count = arch_timer_read_counter();
 	clocksource_register_hz(&clocksource_counter, arch_timer_rate);
-- 
1.8.3.2

