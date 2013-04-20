Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3DTNPb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 09:15:31 -0400
Received: from mail.df.lth.se ([194.47.250.12]:56970 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151Ab3DTNP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 09:15:29 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Apr 2013 09:15:29 EDT
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [PATCH 2/4] clocksource: nomadik-mtu: support of probe
Date: Sat, 20 Apr 2013 15:08:29 +0200
Message-Id: <1366463309-9960-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

Support device tree probe of the nomadik-mtu clocksource.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---
 drivers/clocksource/nomadik-mtu.c | 70 ++++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 12 deletions(-)

diff --git a/drivers/clocksource/nomadik-mtu.c b/drivers/clocksource/nomadik-mtu.c
index e405531..7982cb0 100644
--- a/drivers/clocksource/nomadik-mtu.c
+++ b/drivers/clocksource/nomadik-mtu.c
@@ -13,6 +13,9 @@
 #include <linux/io.h>
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
 #include <linux/clk.h>
 #include <linux/jiffies.h>
 #include <linux/delay.h>
@@ -188,22 +191,15 @@ static struct irqaction nmdk_timer_irq = {
 	.dev_id		= &nmdk_clkevt,
 };
 
-void __init nmdk_timer_init(void __iomem *base, int irq)
+static void __init __nmdk_timer_init(void __iomem *base, int irq,
+				     struct clk *pclk, struct clk *clk)
 {
 	unsigned long rate;
-	struct clk *clk0, *pclk0;
 
 	mtu_base = base;
 
-	pclk0 = clk_get_sys("mtu0", "apb_pclk");
-	BUG_ON(IS_ERR(pclk0));
-	BUG_ON(clk_prepare(pclk0) < 0);
-	BUG_ON(clk_enable(pclk0) < 0);
-
-	clk0 = clk_get_sys("mtu0", NULL);
-	BUG_ON(IS_ERR(clk0));
-	BUG_ON(clk_prepare(clk0) < 0);
-	BUG_ON(clk_enable(clk0) < 0);
+	BUG_ON(clk_prepare_enable(pclk));
+	BUG_ON(clk_prepare_enable(clk));
 
 	/*
 	 * Tick rate is 2.4MHz for Nomadik and 2.4Mhz, 100MHz or 133 MHz
@@ -213,7 +209,7 @@ void __init nmdk_timer_init(void __iomem *base, int irq)
 	 * to wake-up at a max 127s a head in time. Dividing a 2.4 MHz timer
 	 * with 16 gives too low timer resolution.
 	 */
-	rate = clk_get_rate(clk0);
+	rate = clk_get_rate(clk);
 	if (rate > 32000000) {
 		rate /= 16;
 		clk_prescale = MTU_CRn_PRESCALE_16;
@@ -247,3 +243,53 @@ void __init nmdk_timer_init(void __iomem *base, int irq)
 	mtu_delay_timer.freq = rate;
 	register_current_timer_delay(&mtu_delay_timer);
 }
+
+void __init nmdk_timer_init(void __iomem *base, int irq)
+{
+	struct clk *clk0, *pclk0;
+
+	pclk0 = clk_get_sys("mtu0", "apb_pclk");
+	BUG_ON(IS_ERR(pclk0));
+	clk0 = clk_get_sys("mtu0", NULL);
+	BUG_ON(IS_ERR(clk0));
+
+	__nmdk_timer_init(base, irq, pclk0, clk0);
+}
+
+static struct of_device_id nmdk_timer_match[] __initconst = {
+	{ .compatible = "st,nomadik-mtu" },
+	{}
+};
+
+static void __init nmdk_timer_of_init(void)
+{
+	struct device_node *node;
+	struct clk *pclk;
+	struct clk *clk;
+	void __iomem *base;
+	int irq;
+
+	node = of_find_matching_node(NULL, nmdk_timer_match);
+	if (!node)
+		panic("No timer node");
+
+	base = of_iomap(node, 0);
+	if (!base)
+		panic("Can't remap registers");
+
+	pclk = of_clk_get_by_name(node, "apb_pclk");
+	if (IS_ERR(pclk))
+		panic("could not get apb_pclk");
+
+	clk = of_clk_get_by_name(node, "timclk");
+	if (IS_ERR(clk))
+		panic("could not get timclk");
+
+	irq = irq_of_parse_and_map(node, 0);
+	if (irq <= 0)
+		panic("Can't parse IRQ");
+
+	__nmdk_timer_init(base, irq, pclk, clk);
+}
+CLOCKSOURCE_OF_DECLARE(nomadik_mtu, "st,nomadik-mtu",
+		       nmdk_timer_of_init);
-- 
1.8.1.4

