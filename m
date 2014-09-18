Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbaIRPAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:00:46 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:48957 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbaIRPAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:00:44 -0400
From: Nathan Lynch <nathan_lynch@mentor.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sonny Rao <sonnyrao@chromium.org>, Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/3] clocksource: arm_arch_timer: consolidate arch_timer_evtstrm_enable
Date: Thu, 18 Sep 2014 09:59:35 -0500
Message-ID: <1411052390-27238-4-git-send-email-nathan_lynch@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411052390-27238-1-git-send-email-nathan_lynch@mentor.com>
References: <1411052390-27238-1-git-send-email-nathan_lynch@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arch_timer_evtstrm_enable hooks in arm and arm64 are substantially
similar, the only difference being a CONFIG_COMPAT-conditional section
which is relevant only for arm64.  Copy the arm64 version to the
driver, removing the arch-specific hooks.

Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
---
 arch/arm/include/asm/arch_timer.h    | 11 -----------
 arch/arm64/include/asm/arch_timer.h  | 14 --------------
 drivers/clocksource/arm_arch_timer.c | 15 +++++++++++++++
 3 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/arch/arm/include/asm/arch_timer.h b/arch/arm/include/asm/arch_timer.h
index b7ae44464231..92793ba69c40 100644
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
index 49e94c677e7a..f19097134b02 100644
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
index 31781fdd7c19..ce5f99e957b9 100644
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
1.9.3

