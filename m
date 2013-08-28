Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab3H1Kov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:44:51 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48384 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab3H1Kol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:44:41 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Sudeep.KarkadaNagesha@arm.com,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v5 4/5] drivers: clocksource: add support for ARM architected timer event stream
Date: Wed, 28 Aug 2013 11:44:48 +0100
Message-Id: <1377686689-30828-5-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377686689-30828-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1377686689-30828-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 28 Aug 2013 10:44:38.0704 (UTC) FILETIME=[98341B00:01CEA3DB]
X-MC-Unique: 113082811444003101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7SAiukS005371

From: Will Deacon <will.deacon@arm.com>

The ARM architected timer can generate events (used for waking up
CPUs executing the wfe instruction) at a frequency represented as a
power-of-2 divisor of the clock rate.

An event stream might be used:
- To impose a time-out on a wfe polling loop.
- To safeguard against any programming error in case an expected event
  is not generated.
- To implement wfe-based timeouts for userspace locking implementations.

This patch computes the event stream frequency aiming for a period
of 100us between events. It uses ARM/ARM64 specific backends to configure
and enable the event stream.

Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
[sudeep: moving ARM/ARM64 changes into separate patches
         and adding Kconfig option]
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 drivers/clocksource/Kconfig          | 14 ++++++++++++++
 drivers/clocksource/arm_arch_timer.c | 21 +++++++++++++++++++++
 include/clocksource/arm_arch_timer.h |  2 ++
 3 files changed, 37 insertions(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index b7b9b04..74946ca 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -74,6 +74,20 @@ config ARM_ARCH_TIMER
 	bool
 	select CLKSRC_OF if OF
 
+config ARM_ARCH_TIMER_EVTSTREAM
+	bool "Support for ARM architected timer event stream generation"
+	default y if ARM_ARCH_TIMER
+	help
+	  This option enables support for event stream generation based on
+	  the ARM architected timer. It is used for waking up CPUs executing
+	  the wfe instruction at a frequency represented as a power-of-2
+	  divisor of the clock rate. An event stream might be useful for
+	  imposing timeout on a wfe, safeguarding against any programming
+	  errors in case an expected event is not generated or even to
+	  implement wfe-based timeouts for userspace locking implementations.
+	  This can be disabled for hardware validation purposes to detect any
+	  hardware anomalies of missing events.
+
 config ARM_GLOBAL_TIMER
 	bool
 	select CLKSRC_OF if OF
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index ffadd83..f42bef4 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -123,6 +123,26 @@ static int arch_timer_set_next_event_phys(unsigned long evt,
 	return 0;
 }
 
+#ifdef CONFIG_ARM_ARCH_TIMER_EVTSTREAM
+static void arch_timer_setup_evtstream(void)
+{
+	int evt_stream_div, pos;
+
+	/* Find the closest power of two to the divisor */
+	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
+	pos = fls(evt_stream_div);
+	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
+		pos--;
+	/* enable event stream */
+	arch_timer_evtstrm_config(true, min(pos, 15));
+}
+#else
+static void arch_timer_setup_evtstream(void)
+{
+	arch_timer_evtstrm_config(false, 0);
+}
+#endif
+
 static int arch_timer_setup(struct clock_event_device *clk)
 {
 	clk->features = CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP;
@@ -154,6 +174,7 @@ static int arch_timer_setup(struct clock_event_device *clk)
 	}
 
 	arch_counter_set_user_access();
+	arch_timer_setup_evtstream();
 
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


