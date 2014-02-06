Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbaBFWZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 17:25:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37198 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbaBFWYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 17:24:54 -0500
From: Kumar Gala <galak@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Kumar Gala <galak@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org
Subject: [PATCH v3 4/5] clocksource: qcom: split building of legacy vs multiplatform support
Date: Thu,  6 Feb 2014 16:24:43 -0600
Message-Id: <1391725484-6673-5-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1391725484-6673-1-git-send-email-galak@codeaurora.org>
References: <1391725484-6673-1-git-send-email-galak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The majority of the clocksource code for the Qualcomm platform is shared
between newer (multiplatform) and older platforms.  However there is a bit
of code that isn't, so only build it for the appropriate config.

Acked-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 drivers/clocksource/qcom-timer.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/clocksource/qcom-timer.c b/drivers/clocksource/qcom-timer.c
index dca829e..e807acf 100644
--- a/drivers/clocksource/qcom-timer.c
+++ b/drivers/clocksource/qcom-timer.c
@@ -106,15 +106,6 @@ static notrace cycle_t msm_read_timer_count(struct clocksource *cs)
 	return readl_relaxed(source_base + TIMER_COUNT_VAL);
 }
 
-static notrace cycle_t msm_read_timer_count_shift(struct clocksource *cs)
-{
-	/*
-	 * Shift timer count down by a constant due to unreliable lower bits
-	 * on some targets.
-	 */
-	return msm_read_timer_count(cs) >> MSM_DGT_SHIFT;
-}
-
 static struct clocksource msm_clocksource = {
 	.name	= "dg_timer",
 	.rating	= 300,
@@ -228,7 +219,7 @@ err:
 	sched_clock_register(msm_sched_clock_read, sched_bits, dgt_hz);
 }
 
-#ifdef CONFIG_OF
+#ifdef CONFIG_ARCH_QCOM
 static void __init msm_dt_timer_init(struct device_node *np)
 {
 	u32 freq;
@@ -281,7 +272,7 @@ static void __init msm_dt_timer_init(struct device_node *np)
 }
 CLOCKSOURCE_OF_DECLARE(kpss_timer, "qcom,kpss-timer", msm_dt_timer_init);
 CLOCKSOURCE_OF_DECLARE(scss_timer, "qcom,scss-timer", msm_dt_timer_init);
-#endif
+#else
 
 static int __init msm_timer_map(phys_addr_t addr, u32 event, u32 source,
 				u32 sts)
@@ -301,6 +292,15 @@ static int __init msm_timer_map(phys_addr_t addr, u32 event, u32 source,
 	return 0;
 }
 
+static notrace cycle_t msm_read_timer_count_shift(struct clocksource *cs)
+{
+	/*
+	 * Shift timer count down by a constant due to unreliable lower bits
+	 * on some targets.
+	 */
+	return msm_read_timer_count(cs) >> MSM_DGT_SHIFT;
+}
+
 void __init msm7x01_timer_init(void)
 {
 	struct clocksource *cs = &msm_clocksource;
@@ -327,3 +327,4 @@ void __init qsd8x50_timer_init(void)
 		return;
 	msm_timer_init(19200000 / 4, 32, 7, false);
 }
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

