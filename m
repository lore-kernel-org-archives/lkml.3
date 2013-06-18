Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543Ab3FRRHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:07:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45971 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab3FRRHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:07:05 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com, linux@arm.linux.org.uk,
        catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com,
        marc.zyngier@arm.com, tglx@linutronix.de,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH 2/4] ARM: arch_timer: add macros for bits in control register
Date: Tue, 18 Jun 2013 18:07:01 +0100
Message-Id: <1371575223-21702-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 18 Jun 2013 17:07:01.0763 (UTC) FILETIME=[4000D530:01CE6C46]
X-MC-Unique: 113061818070302701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r5IH7sTD002375

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Add macros to describe the bitfields in the ARM architected timer
control register to make code easy to understand.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/arch_timer.h    |  9 +++++++--
 arch/arm64/include/asm/arch_timer.h  | 10 ++++++++--
 include/clocksource/arm_arch_timer.h |  8 ++++++++
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 75c8ec3..6725017 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -96,8 +96,13 @@ static inline void __cpuinit arch_counter_set_user_access(int divider)
 	asm volatile("mrc p15, 0, %0, c14, c1, 0" : "=r" (cntkctl));
 
 	/* disable user access to everything */
-	cntkctl &= ~((3 << 8) | (0xf << 4) | (3 << 0));
-	cntkctl |= (divider << 4) | (1 << 2);
+	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
+			| ARCH_TIMER_USR_VT_ACCESS_EN
+			| ARCH_TIMER_EVT_TRIGGER_MASK
+			| ARCH_TIMER_USR_VCT_ACCESS_EN
+			| ARCH_TIMER_USR_PCT_ACCESS_EN);
+	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
+			| ARCH_TIMER_VIRT_EVT_EN;
 
 	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
 }
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 5fcaa6f..2269944 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -103,10 +103,16 @@ static inline void __cpuinit arch_counter_set_user_access(int divider)
 
 	/* Disable user access to the timers and the physical counter. */
 	asm volatile("mrs	%0, cntkctl_el1" : "=r" (cntkctl));
-	cntkctl &= ~((3 << 8) | (0xf << 4) | (1 << 0));
+	cntkctl &= ~(ARCH_TIMER_USR_PT_ACCESS_EN
+			| ARCH_TIMER_USR_VT_ACCESS_EN
+			| ARCH_TIMER_EVT_TRIGGER_MASK
+			| ARCH_TIMER_USR_PCT_ACCESS_EN)
 
 	/* Enable user access to the virtual counter and frequency. */
-	cntkctl |= (divider << 4) | (1 << 2) | (1 << 1);
+	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
+			| ARCH_TIMER_VIRT_EVT_EN
+			| ARCH_TIMER_USR_VCT_ACCESS_EN;
+
 	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
 }
 
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 24dc140..c4d0fc4 100644
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
 #define ARCH_TIMER_EVT_STREAM_FREQ	10000	/* 100us */
 
 #ifdef CONFIG_ARM_ARCH_TIMER
-- 
1.8.1.2


