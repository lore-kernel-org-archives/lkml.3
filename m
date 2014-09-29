Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaI2AY0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:24:26 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63765 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbaI2AYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:24:06 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/13] clocksource: arm_arch_timer: Consolidate arch_timer_evtstrm_enable
Date: Mon, 29 Sep 2014 02:23:46 +0200
Message-Id: <1411950226-21598-13-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
References: <5428A559.5050908@linaro.org>
 <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <nathan_lynch@mentor.com>

The arch_timer_evtstrm_enable hooks in arm and arm64 are substantially
similar, the only difference being a CONFIG_COMPAT-conditional section
which is relevant only for arm64.  Copy the arm64 version to the
driver, removing the arch-specific hooks.

Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/arch_timer.h    | 11 -----------
 arch/arm64/include/asm/arch_timer.h  | 14 --------------
 drivers/clocksource/arm_arch_timer.c | 15 +++++++++++++++
 3 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index b7ae444..92793ba 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -99,17 +99,6 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
 	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
 }
 
-static inline void arch_timer_evtstrm_enable(int divider)
-{
-	u32 cntkctl = arch_timer_get_cntkctl();
-	cntkctl &= ~ARCH_TIMER_EVT_TRIGGER_MASK;
-	/* Set the divider and enable virtual event stream */
-	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
-			| ARCH_TIMER_VIRT_EVT_EN;
-	arch_timer_set_cntkctl(cntkctl);
-	elf_hwcap |= HWCAP_EVTSTRM;
-}
-
 #endif
 
 #endif
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 49e94c6..f190971 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -104,20 +104,6 @@ static inline void arch_timer_set_cntkctl(u32 cntkctl)
 	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
 }
 
-static inline void arch_timer_evtstrm_enable(int divider)
-{
-	u32 cntkctl = arch_timer_get_cntkctl();
-	cntkctl &= ~ARCH_TIMER_EVT_TRIGGER_MASK;
-	/* Set the divider and enable virtual event stream */
-	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
-			| ARCH_TIMER_VIRT_EVT_EN;
-	arch_timer_set_cntkctl(cntkctl);
-	elf_hwcap |= HWCAP_EVTSTRM;
-#ifdef CONFIG_COMPAT
-	compat_elf_hwcap |= COMPAT_HWCAP_EVTSTRM;
-#endif
-}
-
 static inline u64 arch_counter_get_cntvct(void)
 {
 	u64 cval;
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 42bd445..2133f9d 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -299,6 +299,21 @@ static void __arch_timer_setup(unsigned type,
 	clockevents_config_and_register(clk, arch_timer_rate, 0xf, 0x7fffffff);
 }
 
+static void arch_timer_evtstrm_enable(int divider)
+{
+	u32 cntkctl = arch_timer_get_cntkctl();
+
+	cntkctl &= ~ARCH_TIMER_EVT_TRIGGER_MASK;
+	/* Set the divider and enable virtual event stream */
+	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
+			| ARCH_TIMER_VIRT_EVT_EN;
+	arch_timer_set_cntkctl(cntkctl);
+	elf_hwcap |= HWCAP_EVTSTRM;
+#ifdef CONFIG_COMPAT
+	compat_elf_hwcap |= COMPAT_HWCAP_EVTSTRM;
+#endif
+}
+
 static void arch_timer_configure_evtstream(void)
 {
 	int evt_stream_div, pos;
-- 
1.9.1

