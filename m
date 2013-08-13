Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994Ab3HMR36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:29:58 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45605 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837Ab3HMR3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:29:55 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v3 1/6] ARM/ARM64: arch_timer: add macros for bits in control register
Date: Tue, 13 Aug 2013 18:29:39 +0100
Message-Id: <1376414984-14182-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 13 Aug 2013 17:29:51.0236 (UTC) FILETIME=[B767D440:01CE984A]
X-MC-Unique: 113081318295302501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7DHWg5D000850

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Add macros to describe the bitfields in the ARM architected timer
control register to make code easy to understand.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/arm/include/asm/arch_timer.h    |  9 +++++++--
 arch/arm64/include/asm/arch_timer.h  | 12 ++++++++----
 include/clocksource/arm_arch_timer.h |  8 ++++++++
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index e406d57..9ef74da 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -95,8 +95,13 @@ static inline void arch_counter_set_user_access(void)
 
 	asm volatile("mrc p15, 0, %0, c14, c1, 0" : "=r" (cntkctl));
 
-	/* disable user access to everything */
-	cntkctl &= ~((3 << 8) | (7 << 0));
+	/* Disable user access to both physical/virtual counters/timers. */
+	/* Also disable virtual event stream */
+	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
+			| ARCH_TIMER_USR_VT_ACCESS_EN
+			| ARCH_TIMER_VIRT_EVT_EN
+			| ARCH_TIMER_USR_VCT_ACCESS_EN
+			| ARCH_TIMER_USR_PCT_ACCESS_EN);
 
 	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
 }
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 98abd47..00b09d0 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -101,12 +101,16 @@ static inline void arch_counter_set_user_access(void)
 {
 	u32 cntkctl;
 
-	/* Disable user access to the timers and the physical counter. */
 	asm volatile("mrs	%0, cntkctl_el1" : "=r" (cntkctl));
-	cntkctl &= ~((3 << 8) | (1 << 0));
 
-	/* Enable user access to the virtual counter and frequency. */
-	cntkctl |= (1 << 1);
+	/* Disable user access to the timers and the physical counter. */
+	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
+			| ARCH_TIMER_USR_VT_ACCESS_EN
+			| ARCH_TIMER_USR_PCT_ACCESS_EN);
+
+	/* Enable user access to the virtual counter. */
+	cntkctl |= ARCH_TIMER_USR_VCT_ACCESS_EN;
+
 	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
 }
 
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index c463ce9..551f7e9 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -29,6 +29,14 @@
 #define ARCH_TIMER_PHYS_ACCESS		0
 #define ARCH_TIMER_VIRT_ACCESS		1
 
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


