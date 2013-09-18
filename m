Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3IRLF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:05:29 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60737 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab3IRLFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:05:23 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v6 RESEND 4/5] drivers: clocksource: add support for ARM architected timer event stream
Date: Wed, 18 Sep 2013 12:05:05 +0100
Message-Id: <1379502306-12911-5-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379502306-12911-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1379502306-12911-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

The ARM architected timer can generate events (used for waking up
CPUs executing the wfe instruction) at a frequency represented as a
power-of-2 divisor of the clock rate.

An event stream might be used:
- To implement wfe-based timeouts for userspace locking implementations.
- To impose a timeout on a wfe for safeguarding against any programming
  error in case an expected event is not generated.

This patch computes the event stream frequency aiming for a period
of 100us between events. It uses ARM/ARM64 specific backends to configure
and enable the event stream.

Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[sudeep: moving ARM/ARM64 changes into separate patches
         and adding Kconfig option]
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/clocksource/Kconfig          | 15 +++++++++++++++
 drivers/clocksource/arm_arch_timer.c | 15 +++++++++++++++
 include/clocksource/arm_arch_timer.h |  2 ++
 3 files changed, 32 insertions(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 41c6946..559d803 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -74,6 +74,21 @@ config ARM_ARCH_TIMER
 	bool
 	select CLKSRC_OF if OF
 
+config ARM_ARCH_TIMER_EVTSTREAM
+	bool "Support for ARM architected timer event stream generation"
+	default y if ARM_ARCH_TIMER
+	help
+	  This option enables support for event stream generation based on
+	  the ARM architected timer. It is used for waking up CPUs executing
+	  the wfe instruction at a frequency represented as a power-of-2
+	  divisor of the clock rate.
+	  The main use of the event stream is wfe-based timeouts of userspace
+	  locking implementations. It might also be useful for imposing timeout
+	  on wfe to safeguard against any programming errors in case an expected
+	  event is not generated.
+	  This must be disabled for hardware validation purposes to detect any
+	  hardware anomalies of missing events.
+
 config ARM_GLOBAL_TIMER
 	bool
 	select CLKSRC_OF if OF
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index fbd9ccd..105f8ff 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -294,6 +294,19 @@ static void __arch_timer_setup(unsigned type,
 	clockevents_config_and_register(clk, arch_timer_rate, 0xf, 0x7fffffff);
 }
 
+static void arch_timer_configure_evtstream(void)
+{
+	int evt_stream_div, pos;
+
+	/* Find the closest power of two to the divisor */
+	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
+	pos = fls(evt_stream_div);
+	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
+		pos--;
+	/* enable event stream */
+	arch_timer_evtstrm_enable(min(pos, 15));
+}
+
 static int arch_timer_setup(struct clock_event_device *clk)
 {
 	__arch_timer_setup(ARCH_CP15_TIMER, clk);
@@ -307,6 +320,8 @@ static int arch_timer_setup(struct clock_event_device *clk)
 	}
 
 	arch_counter_set_user_access();
+	if (IS_ENABLED(CONFIG_ARM_ARCH_TIMER_EVTSTREAM))
+		arch_timer_configure_evtstream();
 
 	return 0;
 }
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 8707dae..6d26b40 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -41,6 +41,8 @@ enum arch_timer_reg {
 #define ARCH_TIMER_USR_VT_ACCESS_EN	(1 << 8) /* virtual timer registers */
 #define ARCH_TIMER_USR_PT_ACCESS_EN	(1 << 9) /* physical timer registers */
 
+#define ARCH_TIMER_EVT_STREAM_FREQ	10000	/* 100us */
+
 #ifdef CONFIG_ARM_ARCH_TIMER
 
 extern u32 arch_timer_get_rate(void);
-- 
1.8.1.2

