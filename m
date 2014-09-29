Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbaI2AYU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:24:20 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33770 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaI2AYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:24:05 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/13] clocksource: arm_arch_timer: Enable counter access for 32-bit ARM
Date: Mon, 29 Sep 2014 02:23:45 +0200
Message-Id: <1411950226-21598-12-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
References: <5428A559.5050908@linaro.org>
 <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <nathan_lynch@mentor.com>

The only difference between arm and arm64's implementations of
arch_counter_set_user_access is that 32-bit ARM does not enable user
access to the virtual counter.  We want to enable this access for the
32-bit ARM VDSO, so copy the arm64 version to the driver itself, and
remove the arch-specific implementations.

Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/arch_timer.h    | 14 --------------
 arch/arm64/include/asm/arch_timer.h  | 17 -----------------
 drivers/clocksource/arm_arch_timer.c | 17 +++++++++++++++++
 3 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 0704e0c..b7ae444 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -99,20 +99,6 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
 	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
 }
 
-static inline void arch_counter_set_user_access(void)
-{
-	u32 cntkctl = arch_timer_get_cntkctl();
-
-	/* Disable user access to both physical/virtual counters/timers */
-	/* Also disable virtual event stream */
-	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
-			| ARCH_TIMER_USR_VT_ACCESS_EN
-			| ARCH_TIMER_VIRT_EVT_EN
-			| ARCH_TIMER_USR_VCT_ACCESS_EN
-			| ARCH_TIMER_USR_PCT_ACCESS_EN);
-	arch_timer_set_cntkctl(cntkctl);
-}
-
 static inline void arch_timer_evtstrm_enable(int divider)
 {
 	u32 cntkctl = arch_timer_get_cntkctl();
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 9400596..49e94c6 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -104,23 +104,6 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
 	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
 }
 
-static inline void arch_counter_set_user_access(void)
-{
-	u32 cntkctl = arch_timer_get_cntkctl();
-
-	/* Disable user access to the timers and the physical counter */
-	/* Also disable virtual event stream */
-	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
-			| ARCH_TIMER_USR_VT_ACCESS_EN
-			| ARCH_TIMER_VIRT_EVT_EN
-			| ARCH_TIMER_USR_PCT_ACCESS_EN);
-
-	/* Enable user access to the virtual counter */
-	cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
-
-	arch_timer_set_cntkctl(cntkctl);
-}
-
 static inline void arch_timer_evtstrm_enable(int divider)
 {
 	u32 cntkctl = arch_timer_get_cntkctl();
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index e0e7729..42bd445 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -312,6 +312,23 @@ static void arch_timer_configure_evtstream(void)
 	arch_timer_evtstrm_enable(min(pos, 15));
 }
 
+static void arch_counter_set_user_access(void)
+{
+	u32 cntkctl = arch_timer_get_cntkctl();
+
+	/* Disable user access to the timers and the physical counter */
+	/* Also disable virtual event stream */
+	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
+			| ARCH_TIMER_USR_VT_ACCESS_EN
+			| ARCH_TIMER_VIRT_EVT_EN
+			| ARCH_TIMER_USR_PCT_ACCESS_EN);
+
+	/* Enable user access to the virtual counter */
+	cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
+
+	arch_timer_set_cntkctl(cntkctl);
+}
+
 static int arch_timer_setup(struct clock_event_device *clk)
 {
 	__arch_timer_setup(ARCH_CP15_TIMER, clk);
-- 
1.9.1

