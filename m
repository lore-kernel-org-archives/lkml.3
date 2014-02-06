Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaBFPEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 10:04:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43796 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaBFPEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 10:04:43 -0500
Date: Thu, 6 Feb 2014 07:04:29 -0800
From: tip-bot for Tim Kryger <tipbot@zytor.com>
Message-ID: <tip-ad037c1f4ae6f9258f27fddb679ceb703ff07a88@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tim.kryger@linaro.org, markus.mayer@linaro.org, tglx@linutronix.de,
        matt.porter@linaro.org, daniel.lezcano@linaro.org, bcm@fixthebug.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tim.kryger@linaro.org, markus.mayer@linaro.org, tglx@linutronix.de,
        matt.porter@linaro.org, daniel.lezcano@linaro.org, bcm@fixthebug.org
In-Reply-To: <1391559304-26558-1-git-send-email-tim.kryger@linaro.org>
References: <1391559304-26558-1-git-send-email-tim.kryger@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] clocksource: Kona:
  Print warning rather than panic
Git-Commit-ID: ad037c1f4ae6f9258f27fddb679ceb703ff07a88
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 06 Feb 2014 07:04:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad037c1f4ae6f9258f27fddb679ceb703ff07a88
Gitweb:     http://git.kernel.org/tip/ad037c1f4ae6f9258f27fddb679ceb703ff07a88
Author:     Tim Kryger <tim.kryger@linaro.org>
AuthorDate: Tue, 4 Feb 2014 16:15:04 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 6 Feb 2014 16:01:40 +0100

clocksource: Kona: Print warning rather than panic

Since there may be other clocksources available, this driver should not
trigger a panic simply because it can not determine the frequency of an
external clock.  This change refactors the driver to allow a warning to
be printed in this case instead.

Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: http://lkml.kernel.org/r/1391559304-26558-1-git-send-email-tim.kryger@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
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
