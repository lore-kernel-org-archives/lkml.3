Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011Ab3HMR37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:29:59 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45617 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758961Ab3HMR3z (ORCPT
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
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v3 2/6] drivers: clocksource: configure event stream for ARM arch timer
Date: Tue, 13 Aug 2013 18:29:40 +0100
Message-Id: <1376414984-14182-3-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492082-13686-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376414984-14182-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 13 Aug 2013 17:29:51.0767 (UTC) FILETIME=[B7B8DA70:01CE984A]
X-MC-Unique: 113081318295402201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7DHWBvi000837

From: Will Deacon <will.deacon@arm.com>

The ARM architected timer can generate events (used for waking up
CPUs executing the wfe instruction) at a frequency represented as a
power-of-2 divisor of the clock rate.

An event stream might be used:
- To impose a time-out on a WFE polling loop.
- To safeguard against any programming error in case an expected event
  is not generated.
- To implement wfe-based timeouts for userspace locking implementations.

This patch only computes the event stream frequency, aiming for a period
of 100us between events. ARM/ARM64 specific backends needs to configure
and enable the event stream using this frequency.

Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[sudeep: moving ARM/ARM64 changes into separate patches,
         cosmetic changes to commit message]
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/arm/include/asm/arch_timer.h    | 2 +-
 arch/arm64/include/asm/arch_timer.h  | 2 +-
 drivers/clocksource/arm_arch_timer.c | 9 ++++++++-
 include/clocksource/arm_arch_timer.h | 2 ++
 4 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index 9ef74da..12f3fac 100644
--- a/arch/arm/include/asm/arch_timer.h
+++ b/arch/arm/include/asm/arch_timer.h
@@ -89,7 +89,7 @@ static inline u64 arch_counter_get_cntvct(void)
 	return cval;
 }
 
-static inline void arch_counter_set_user_access(void)
+static inline void arch_counter_set_user_access(int divider)
 {
 	u32 cntkctl;
 
diff --git a/arch/arm64/include/asm/arch_timer.h b/arch/arm64/include/asm/arch_timer.h
index 00b09d0..69f5c8e 100644
--- a/arch/arm64/include/asm/arch_timer.h
+++ b/arch/arm64/include/asm/arch_timer.h
@@ -97,7 +97,7 @@ static inline u32 arch_timer_get_cntfrq(void)
 	return val;
 }
 
-static inline void arch_counter_set_user_access(void)
+static inline void arch_counter_set_user_access(int divider)
 {
 	u32 cntkctl;
 
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
index 551f7e9..c4d0fc4 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -37,6 +37,8 @@
 #define ARCH_TIMER_USR_VT_ACCESS_EN	(1 << 8) /* virtual timer registers */
 #define ARCH_TIMER_USR_PT_ACCESS_EN	(1 << 9) /* physical timer registers */
 
+#define ARCH_TIMER_EVT_STREAM_FREQ	10000	/* 100us */
+
 #ifdef CONFIG_ARM_ARCH_TIMER
 
 extern u32 arch_timer_get_rate(void);
-- 
1.8.1.2


