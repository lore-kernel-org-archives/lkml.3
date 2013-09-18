Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3IRLFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:05:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60742 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752062Ab3IRLF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:05:29 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v6 RESEND 1/5] ARM/ARM64: arch_timer: add macros for bits in control register
Date: Wed, 18 Sep 2013 12:05:02 +0100
Message-Id: <1379502306-12911-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379502306-12911-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1379502306-12911-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Add macros to describe the bitfields in the ARM architected timer
control register to make code easy to understand.

Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/arm/include/asm/arch_timer.h    |  9 +++++++--
 arch/arm64/include/asm/arch_timer.h  | 12 ++++++++----
 include/clocksource/arm_arch_timer.h |  8 ++++++++
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 5665134..d57e04d 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -93,8 +93,13 @@ static inline void arch_counter_set_user_access(void)
 
 	asm volatile("mrc p15, 0, %0, c14, c1, 0" : "=r" (cntkctl));
 
-	/* disable user access to everything */
-	cntkctl &= ~((3 << 8) | (7 << 0));
+	/* Disable user access to both physical/virtual counters/timers */
+	/* Also disable virtual event stream */
+	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
+			| ARCH_TIMER_USR_VT_ACCESS_EN
+			| ARCH_TIMER_VIRT_EVT_EN
+			| ARCH_TIMER_USR_VCT_ACCESS_EN
+			| ARCH_TIMER_USR_PCT_ACCESS_EN);
 
 	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
 }
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index c9f1d28..2b9722f 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -96,12 +96,16 @@ static inline void arch_counter_set_user_access(void)
 {
 	u32 cntkctl;
 
-	/* Disable user access to the timers and the physical counter. */
 	asm volatile("mrs	%0, cntkctl_el1" : "=r" (cntkctl));
-	cntkctl &= ~((3 << 8) | (1 << 0));
 
-	/* Enable user access to the virtual counter and frequency. */
-	cntkctl |= (1 << 1);
+	/* Disable user access to the timers and the physical counter */
+	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
+			| ARCH_TIMER_USR_VT_ACCESS_EN
+			| ARCH_TIMER_USR_PCT_ACCESS_EN);
+
+	/* Enable user access to the virtual counter */
+	cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
+
 	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
 }
 
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 93b7f96..8707dae 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -33,6 +33,14 @@ enum arch_timer_reg {
 #define ARCH_TIMER_MEM_PHYS_ACCESS	2
 #define ARCH_TIMER_MEM_VIRT_ACCESS	3
 
+#define ARCH_TIMER_USR_PCT_ACCESS_EN	(1 << 0) /* physical counter */
+#define ARCH_TIMER_USR_VCT_ACCESS_EN	(1 << 1) /* virtual counter */
+#define ARCH_TIMER_VIRT_EVT_EN		(1 << 2)
+#define ARCH_TIMER_EVT_TRIGGER_SHIFT	(4)
+#define ARCH_TIMER_EVT_TRIGGER_MASK	(0xF << ARCH_TIMER_EVT_TRIGGER_SHIFT)
+#define ARCH_TIMER_USR_VT_ACCESS_EN	(1 << 8) /* virtual timer registers */
+#define ARCH_TIMER_USR_PT_ACCESS_EN	(1 << 9) /* physical timer registers */
+
 #ifdef CONFIG_ARM_ARCH_TIMER
 
 extern u32 arch_timer_get_rate(void);
-- 
1.8.1.2

