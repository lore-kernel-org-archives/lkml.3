Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161054Ab3BGTKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:10:09 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:54071 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab3BGTJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:09:27 -0500
From: Rob Herring <robherring2@gmail.com>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 4/4] clocksource: tegra20: use the device_node pointer passed to init
Date: Thu,  7 Feb 2013 13:09:04 -0600
Message-Id: <1360264144-20714-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360264144-20714-1-git-send-email-robherring2@gmail.com>
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

We've already matched the node, so use the node pointer passed in. The rtc
init was intermingled with the timer init, so split this out to a separate
init function.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
Stephen,

It doesn't seem like there are any init ordering issues to me, but please
test/comment.

Rob

 drivers/clocksource/tegra20_timer.c |   70 ++++++++++++++---------------------
 1 file changed, 27 insertions(+), 43 deletions(-)

diff --git a/drivers/clocksource/tegra20_timer.c b/drivers/clocksource/tegra20_timer.c
index 0bde03f..15cc723 100644
--- a/drivers/clocksource/tegra20_timer.c
+++ b/drivers/clocksource/tegra20_timer.c
@@ -154,29 +154,12 @@ static struct irqaction tegra_timer_irq = {
 	.dev_id		= &tegra_clockevent,
 };
 
-static const struct of_device_id timer_match[] __initconst = {
-	{ .compatible = "nvidia,tegra20-timer" },
-	{}
-};
-
-static const struct of_device_id rtc_match[] __initconst = {
-	{ .compatible = "nvidia,tegra20-rtc" },
-	{}
-};
-
-static void __init tegra20_init_timer(void)
+static void __init tegra20_init_timer(struct device_node *np)
 {
-	struct device_node *np;
 	struct clk *clk;
 	unsigned long rate;
 	int ret;
 
-	np = of_find_matching_node(NULL, timer_match);
-	if (!np) {
-		pr_err("Failed to find timer DT node\n");
-		BUG();
-	}
-
 	timer_reg_base = of_iomap(np, 0);
 	if (!timer_reg_base) {
 		pr_err("Can't map timer registers\n");
@@ -200,30 +183,6 @@ static void __init tegra20_init_timer(void)
 
 	of_node_put(np);
 
-	np = of_find_matching_node(NULL, rtc_match);
-	if (!np) {
-		pr_err("Failed to find RTC DT node\n");
-		BUG();
-	}
-
-	rtc_base = of_iomap(np, 0);
-	if (!rtc_base) {
-		pr_err("Can't map RTC registers");
-		BUG();
-	}
-
-	/*
-	 * rtc registers are used by read_persistent_clock, keep the rtc clock
-	 * enabled
-	 */
-	clk = clk_get_sys("rtc-tegra", NULL);
-	if (IS_ERR(clk))
-		pr_warn("Unable to get rtc-tegra clock\n");
-	else
-		clk_prepare_enable(clk);
-
-	of_node_put(np);
-
 	switch (rate) {
 	case 12000000:
 		timer_writel(0x000b, TIMERUS_USEC_CFG);
@@ -262,9 +221,34 @@ static void __init tegra20_init_timer(void)
 #ifdef CONFIG_HAVE_ARM_TWD
 	twd_local_timer_of_register();
 #endif
+}
+CLOCKSOURCE_OF_DECLARE(tegra20_timer, "nvidia,tegra20-timer", tegra20_init_timer);
+
+static void __init tegra20_init_rtc(struct device_node *np)
+{
+	struct clk *clk;
+
+	rtc_base = of_iomap(np, 0);
+	if (!rtc_base) {
+		pr_err("Can't map RTC registers");
+		BUG();
+	}
+
+	/*
+	 * rtc registers are used by read_persistent_clock, keep the rtc clock
+	 * enabled
+	 */
+	clk = clk_get_sys("rtc-tegra", NULL);
+	if (IS_ERR(clk))
+		pr_warn("Unable to get rtc-tegra clock\n");
+	else
+		clk_prepare_enable(clk);
+
+	of_node_put(np);
+
 	register_persistent_clock(NULL, tegra_read_persistent_clock);
 }
-CLOCKSOURCE_OF_DECLARE(tegra20, "nvidia,tegra20-timer", tegra20_init_timer);
+CLOCKSOURCE_OF_DECLARE(tegra20_rtc, "nvidia,tegra20-rtc", tegra20_init_rtc);
 
 #ifdef CONFIG_PM
 static u32 usec_config;
-- 
1.7.10.4

