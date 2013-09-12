Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab3ILGxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:53:16 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43310 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab3ILGxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:53:11 -0400
From: Fan Rong <cinifr@gmail.com>
To: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Cc: Fan Rong <cinifr@gmail.com>
Subject: [PATCH 3/4] Add physical count arch timer support for clocksource in ARMv7.
Date: Thu, 12 Sep 2013 14:51:26 +0800
Message-Id: <1378968687-8200-4-git-send-email-cinifr@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fan Rong <cinifr@gmail.com>
---
 arch/arm/include/asm/arch_timer.h    |   11 +++++++++++
 drivers/clocksource/Kconfig          |    8 ++++++++
 drivers/clocksource/arm_arch_timer.c |   10 +++++++++-
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 5665134..24c904a 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -87,6 +87,17 @@ static inline u64 arch_counter_get_cntvct(void)
 	return cval;
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
+
+
 static inline void arch_counter_set_user_access(void)
 {
 	u32 cntkctl;
diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 41c6946..a4981d2 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -109,3 +109,11 @@ config VF_PIT_TIMER
 	bool
 	help
 	  Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
+menu "Clock Source"
+
+config ARM_ARCH_TIMER_USE_PHYCNT
+	bool "Use Physical Count Timer"
+	depends on ARM_ARCH_TIMER
+	help
+          If bootloader dont set Virtual Offset register,Physical Count Timer is needed to replace Virtual Count Timer.
+endmenu
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index fbd9ccd..884e4d1 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -372,7 +372,11 @@ static u64 arch_counter_get_cntvct_mem(void)
  * to exist on arm64. arm doesn't use this before DT is probed so even
  * if we don't have the cp15 accessors we won't have a problem.
  */
-u64 (*arch_timer_read_counter)(void) = arch_counter_get_cntvct;
+#ifdef CONFIG_ARM_ARCH_TIMER_USE_PHYCNT
+	u64 (*arch_timer_read_counter)(void) = arch_counter_get_cntpct;
+#else
+	u64 (*arch_timer_read_counter)(void) = arch_counter_get_cntvct;
+#endif
 
 static cycle_t arch_counter_read(struct clocksource *cs)
 {
@@ -410,7 +414,11 @@ static void __init arch_counter_register(unsigned type)
 
 	/* Register the CP15 based counter if we have one */
 	if (type & ARCH_CP15_TIMER)
+#ifdef CONFIG_ARM_ARCH_TIMER_USE_PHYCNT
+		arch_timer_read_counter = arch_counter_get_cntpct;
+#else
 		arch_timer_read_counter = arch_counter_get_cntvct;
+#endif
 	else
 		arch_timer_read_counter = arch_counter_get_cntvct_mem;
 
-- 
1.7.9.5

