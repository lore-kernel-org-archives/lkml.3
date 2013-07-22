Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab3GVLVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:21:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42538 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab3GVLVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:21:32 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com, Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v2 2/3] ARM: arch_timer: add macros for bits in control register
Date: Mon, 22 Jul 2013 12:21:21 +0100
Message-Id: <1374492082-13686-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 22 Jul 2013 11:21:28.0996 (UTC) FILETIME=[9C5B2640:01CE86CD]
X-MC-Unique: 113072212213007901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6MBLdiu009566

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

Add macros to describe the bitfields in the ARM architected timer
control register to make code easy to understand.

Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/arm/include/asm/arch_timer.h    |  9 +++++++--
 arch/arm64/include/asm/arch_timer.h  | 10 ++++++++--
 include/clocksource/arm_arch_timer.h |  8 ++++++++
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index c3d9ef7..26c65ae 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -96,8 +96,13 @@ static inline void arch_counter_set_user_access(int divider)
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
index 8c1e42f..3494102 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -103,10 +103,16 @@ static inline void arch_counter_set_user_access(int divider)
 
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


