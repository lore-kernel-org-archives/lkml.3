Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab3GVLV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:21:59 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42526 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab3GVLVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:21:32 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com, Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH v2 1/3] drivers: clocksource: configure event stream for ARM arch timer
Date: Mon, 22 Jul 2013 12:21:20 +0100
Message-Id: <1374492082-13686-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1371575223-21702-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 22 Jul 2013 11:21:28.0481 (UTC) FILETIME=[9C0C9110:01CE86CD]
X-MC-Unique: 113072212213002701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r6MBM4QX009574

From: Will Deacon <will.deacon@arm.com>

The ARM architected timer can generate events (used for waking up
CPUs executing the wfe instruction) at a frequency represented as a
power-of-2 divisor of the clock rate.

This patch configures the event stream, aiming for a period of 100us
between events. This can be used to implement wfe-based timeouts for
userspace locking implementations.

Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/arch_timer.h    | 5 +++--
 arch/arm64/include/asm/arch_timer.h  | 6 +++---
 drivers/clocksource/arm_arch_timer.c | 9 ++++++++-
 include/clocksource/arm_arch_timer.h | 2 ++
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index e406d57..c3d9ef7 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -89,14 +89,15 @@ static inline u64 arch_counter_get_cntvct(void)
 	return cval;
 }
 
-static inline void arch_counter_set_user_access(void)
+static inline void arch_counter_set_user_access(int divider)
 {
 	u32 cntkctl;
 
 	asm volatile("mrc p15, 0, %0, c14, c1, 0" : "=r" (cntkctl));
 
 	/* disable user access to everything */
-	cntkctl &= ~((3 << 8) | (7 << 0));
+	cntkctl &= ~((3 << 8) | (0xf << 4) | (3 << 0));
+	cntkctl |= (divider << 4) | (1 << 2);
 
 	asm volatile("mcr p15, 0, %0, c14, c1, 0" : : "r" (cntkctl));
 }
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 98abd47..8c1e42f 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -97,16 +97,16 @@ static inline u32 arch_timer_get_cntfrq(void)
 	return val;
 }
 
-static inline void arch_counter_set_user_access(void)
+static inline void arch_counter_set_user_access(int divider)
 {
 	u32 cntkctl;
 
 	/* Disable user access to the timers and the physical counter. */
 	asm volatile("mrs	%0, cntkctl_el1" : "=r" (cntkctl));
-	cntkctl &= ~((3 << 8) | (1 << 0));
+	cntkctl &= ~((3 << 8) | (0xf << 4) | (1 << 0));
 
 	/* Enable user access to the virtual counter and frequency. */
-	cntkctl |= (1 << 1);
+	cntkctl |= (divider << 4) | (1 << 2) | (1 << 1);
 	asm volatile("msr	cntkctl_el1, %0" : : "r" (cntkctl));
 }
 
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index ffadd83..6301ee5 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -125,6 +125,8 @@ static int arch_timer_set_next_event_phys(unsigned long evt,
 
 static int arch_timer_setup(struct clock_event_device *clk)
 {
+	int evt_stream_div, pos;
+
 	clk->features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP;
 	clk->name = "arch_sys_timer";
 	clk->rating = 450;
@@ -153,7 +155,12 @@ static int arch_timer_setup(struct clock_event_device *clk)
 			enable_percpu_irq(arch_timer_ppi[PHYS_NONSECURE_PPI], 0);
 	}
 
-	arch_counter_set_user_access();
+	/* Find the closest power of two to the divisor */
+	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
+	pos = fls(evt_stream_div);
+	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
+		pos--;
+	arch_counter_set_user_access(min(pos, 15));
 
 	return 0;
 }
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index c463ce9..24dc140 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -29,6 +29,8 @@
 #define ARCH_TIMER_PHYS_ACCESS		0
 #define ARCH_TIMER_VIRT_ACCESS		1
 
+#define ARCH_TIMER_EVT_STREAM_FREQ	10000	/* 100us */
+
 #ifdef CONFIG_ARM_ARCH_TIMER
 
 extern u32 arch_timer_get_rate(void);
-- 
1.8.1.2


