Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbaEMXBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 19:01:12 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33375 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaEMXBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 19:01:04 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] clocksource: qcom: Implement read_current_timer for udelay
Date: Tue, 13 May 2014 16:01:00 -0700
Message-Id: <1400022060-30118-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup the same timer used as the clocksource to be used as the
read_current_timer implementation. This allows us to support a
stable udelay implementation on MSMs where it's possible for the
CPUs to scale speeds independently of one another.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clocksource/qcom-timer.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/clocksource/qcom-timer.c b/drivers/clocksource/qcom-timer.c
index e807acf4c665..8d115db1e651 100644
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
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

