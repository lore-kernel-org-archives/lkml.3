Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbaBEAPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:15:19 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:59376 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaBEAPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:15:17 -0500
X-IronPort-AV: E=Sophos;i="4.95,783,1384329600"; 
   d="scan'208";a="12967731"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Subject: [PATCH v2] clocksource: kona: Print warning rather than panic
Date: Tue, 4 Feb 2014 16:15:04 -0800
Message-ID: <1391559304-26558-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there may be other clocksources available, this driver should not
trigger a panic simply because it can not determine the frequency of an
external clock.  This change refactors the driver to allow a warning to
be printed in this case instead.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
---

Changes since v1:
  - Rebased on v3.14-rc1

 drivers/clocksource/bcm_kona_timer.c | 54 +++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
index 974b2db..0595dc6 100644
--- a/drivers/clocksource/bcm_kona_timer.c
+++ b/drivers/clocksource/bcm_kona_timer.c
@@ -99,31 +99,6 @@ kona_timer_get_counter(void *timer_base, uint32_t *msw, uint32_t *lsw)
 	return;
 }
 
-static void __init kona_timers_init(struct device_node *node)
-{
-	u32 freq;
-	struct clk *external_clk;
-
-	external_clk = of_clk_get_by_name(node, NULL);
-
-	if (!IS_ERR(external_clk)) {
-		arch_timer_rate = clk_get_rate(external_clk);
-		clk_prepare_enable(external_clk);
-	} else if (!of_property_read_u32(node, "clock-frequency", &freq)) {
-		arch_timer_rate = freq;
-	} else {
-		panic("unable to determine clock-frequency");
-	}
-
-	/* Setup IRQ numbers */
-	timers.tmr_irq = irq_of_parse_and_map(node, 0);
-
-	/* Setup IO addresses */
-	timers.tmr_regs = of_iomap(node, 0);
-
-	kona_timer_disable_and_clear(timers.tmr_regs);
-}
-
 static int kona_timer_set_next_event(unsigned long clc,
 				  struct clock_event_device *unused)
 {
@@ -198,7 +173,34 @@ static struct irqaction kona_timer_irq = {
 
 static void __init kona_timer_init(struct device_node *node)
 {
-	kona_timers_init(node);
+	u32 freq;
+	struct clk *external_clk;
+
+	if (!of_device_is_available(node)) {
+		pr_info("Kona Timer v1 marked as disabled in device tree\n");
+		return;
+	}
+
+	external_clk = of_clk_get_by_name(node, NULL);
+
+	if (!IS_ERR(external_clk)) {
+		arch_timer_rate = clk_get_rate(external_clk);
+		clk_prepare_enable(external_clk);
+	} else if (!of_property_read_u32(node, "clock-frequency", &freq)) {
+		arch_timer_rate = freq;
+	} else {
+		pr_err("Kona Timer v1 unable to determine clock-frequency");
+		return;
+	}
+
+	/* Setup IRQ numbers */
+	timers.tmr_irq = irq_of_parse_and_map(node, 0);
+
+	/* Setup IO addresses */
+	timers.tmr_regs = of_iomap(node, 0);
+
+	kona_timer_disable_and_clear(timers.tmr_regs);
+
 	kona_timer_clockevents_init();
 	setup_irq(timers.tmr_irq, &kona_timer_irq);
 	kona_timer_set_next_event((arch_timer_rate / HZ), NULL);
-- 
1.8.0.1

