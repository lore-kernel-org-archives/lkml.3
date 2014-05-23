Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaEWKc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:32:56 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:53250 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaEWKcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:52 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 60/71] clocksource: qcom: Implement read_current_timer for udelay
Date: Fri, 23 May 2014 12:31:40 +0200
Message-Id: <1400841111-6683-60-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Setup the same timer used as the clocksource to be used as the
read_current_timer implementation. This allows us to support a
stable udelay implementation on MSMs where it's possible for the
CPUs to scale speeds independently of one another.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/qcom-timer.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/clocksource/qcom-timer.c b/drivers/clocksource/qcom-timer.c
index e807acf..8d115db 100644
--- a/drivers/clocksource/qcom-timer.c
+++ b/drivers/clocksource/qcom-timer.c
@@ -26,6 +26,8 @@
 #include <linux/of_irq.h>
 #include <linux/sched_clock.h>
 
+#include <asm/delay.h>
+
 #define TIMER_MATCH_VAL			0x0000
 #define TIMER_COUNT_VAL			0x0004
 #define TIMER_ENABLE			0x0008
@@ -179,6 +181,15 @@ static u64 notrace msm_sched_clock_read(void)
 	return msm_clocksource.read(&msm_clocksource);
 }
 
+static unsigned long msm_read_current_timer(void)
+{
+	return msm_clocksource.read(&msm_clocksource);
+}
+
+static struct delay_timer msm_delay_timer = {
+	.read_current_timer = msm_read_current_timer,
+};
+
 static void __init msm_timer_init(u32 dgt_hz, int sched_bits, int irq,
 				  bool percpu)
 {
@@ -217,6 +228,8 @@ err:
 	if (res)
 		pr_err("clocksource_register failed\n");
 	sched_clock_register(msm_sched_clock_read, sched_bits, dgt_hz);
+	msm_delay_timer.freq = dgt_hz;
+	register_current_timer_delay(&msm_delay_timer);
 }
 
 #ifdef CONFIG_ARCH_QCOM
-- 
1.7.9.5

