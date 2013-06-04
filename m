Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3FDJhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:37:51 -0400
Received: from gloria.sntech.de ([95.129.55.99]:57469 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab3FDJhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:37:47 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 2/4] clocksource: dw_apb_timer_of: add clock-handling
Date: Tue, 4 Jun 2013 11:37:36 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Baruch Siach <baruch@tkos.co.il>
References: <201306041136.09566.heiko@sntech.de>
In-Reply-To: <201306041136.09566.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306041137.37036.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the possibility to get the clock-frequency from a timer clock instead
of specifying it as dt property. Additionally also add the possibility
to also define a controlling periphal clock for the timer block.

The clock-frequency property is kept to act as fallback if no clocks
are specified.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 Documentation/devicetree/bindings/rtc/dw-apb.txt |   19 ++++++++++++++++
 drivers/clocksource/dw_apb_timer_of.c            |   26 +++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/rtc/dw-apb.txt b/Documentation/devicetree/bindings/rtc/dw-apb.txt
index 93e2b0f..eb2327b 100644
--- a/Documentation/devicetree/bindings/rtc/dw-apb.txt
+++ b/Documentation/devicetree/bindings/rtc/dw-apb.txt
@@ -5,9 +5,20 @@ Required properties:
 - reg: physical base address of the controller and length of memory mapped
   region.
 - interrupts: IRQ line for the timer.
+- either clocks+clock-names or clock-frequency properties
+
+Optional properties:
+- clocks	: list of clock specifiers, corresponding to entries in
+		  the clock-names property;
+- clock-names	: should contain "timer" and "pclk" entries, matching entries
+		  in the clocks property.
 - clock-frequency: The frequency in HZ of the timer.
 - clock-freq: For backwards compatibility with picoxcell
 
+If using the clock specifiers, the pclk clock is optional, as not all
+systems may use one.
+
+
 Example:
 
 		timer1: timer@ffc09000 {
@@ -23,3 +34,11 @@ Example:
 				clock-frequency = <200000000>;
 				reg = <0xffd00000 0x1000>;
 			};
+
+		timer3: timer@ffe00000 {
+				compatible = "snps,dw-apb-timer-osc";
+				interrupts = <0 170 4>;
+				reg = <0xffe00000 0x1000>;
+				clocks = <&timer_clk>, <&timer_pclk>;
+				clock-names = "timer", "pclk";
+			};
diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index d6c0fda..1964f87 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -20,6 +20,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/clk.h>
 
 #include <asm/mach/time.h>
 #include <asm/sched_clock.h>
@@ -27,14 +28,37 @@
 static void timer_get_base_and_rate(struct device_node *np,
 				    void __iomem **base, u32 *rate)
 {
+	struct clk *timer_clk;
+	struct clk *pclk;
+
 	*base = of_iomap(np, 0);
 
 	if (!*base)
 		panic("Unable to map regs for %s", np->name);
 
+	/*
+	 * Not all implementations use a periphal clock, so don't panic
+	 * if it's not present
+	 */
+	pclk = of_clk_get_by_name(np, "pclk");
+	if (!IS_ERR(pclk))
+		if (clk_prepare_enable(pclk))
+			pr_warn("pclk for %s is present, but could not be activated\n",
+				np->name);
+
+	timer_clk = of_clk_get_by_name(np, "timer");
+	if (IS_ERR(timer_clk))
+		goto try_clock_freq;
+
+	if (!clk_prepare_enable(timer_clk)) {
+		*rate = clk_get_rate(timer_clk);
+		return;
+	}
+
+try_clock_freq:
 	if (of_property_read_u32(np, "clock-freq", rate) &&
 		of_property_read_u32(np, "clock-frequency", rate))
-		panic("No clock-frequency property for %s", np->name);
+		panic("No clock nor clock-frequency property for %s", np->name);
 }
 
 static void add_clockevent(struct device_node *event_timer)
-- 
1.7.2.3

