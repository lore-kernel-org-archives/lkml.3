Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab3GEW4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:56:40 -0400
Received: from gloria.sntech.de ([95.129.55.99]:38128 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab3GEW4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:56:39 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: John Stultz <john.stultz@linaro.org>
Subject: [PATCH 9/9] clocksource: dw_apb_timer: special variant for rockchip rk3188 timers
Date: Sat, 6 Jul 2013 00:56:29 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Ulrich Prinz <ulrich.prinz@googlemail.com>
References: <201307060051.09716.heiko@sntech.de>
In-Reply-To: <201307060051.09716.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201307060056.29370.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rk3188 uses a variant of the timer containing two registers for load_count
and current_values.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 .../bindings/arm/rockchip/rk3188-timer.txt         |   20 ++++++++++++++++++++
 drivers/clocksource/dw_apb_timer_of.c              |    6 ++++++
 2 files changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/rk3188-timer.txt

diff --git a/Documentation/devicetree/bindings/arm/rockchip/rk3188-timer.txt b/Documentation/devicetree/bindings/arm/rockchip/rk3188-timer.txt
new file mode 100644
index 0000000..ccbb389
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/rockchip/rk3188-timer.txt
@@ -0,0 +1,20 @@
+Rockchip rk3188 timer:
+----------------------
+
+The rk3188 SoCs contain a slightly modified dw-apb-timer.
+
+Required node properties:
+- compatible value : = "rockchip,rk3188-dw-apb-timer-osc";
+
+For the other properties see the generic documentation in
+../../rtc/dw-apb.txt
+
+Example:
+
+	timer3: timer@ffe00000 {
+			compatible = "rockchip,rk3188-dw-apb-timer-osc";
+			interrupts = <0 170 4>;
+			reg = <0xffe00000 0x1000>;
+			clocks = <&timer_clk>, <&timer_pclk>;
+			clock-names = "timer", "pclk";
+		};
diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
index 4bcc1c1..7824796 100644
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@ -38,6 +38,11 @@ static void timer_get_base_and_rate(struct device_node *np,
 
 	*quirks = 0;
 
+	if (of_device_is_compatible(np, "rockchip,rk3188-dw-apb-timer-osc"))
+		*quirks |= APBTMR_QUIRK_64BIT_COUNTER | APBTMR_QUIRK_NO_EOI |
+			   APBTMR_QUIRK_INVERSE_INTMASK |
+			   APBTMR_QUIRK_INVERSE_PERIODIC;
+
 	/*
 	 * Not all implementations use a periphal clock, so don't panic
 	 * if it's not present
@@ -165,3 +170,4 @@ static void __init dw_apb_timer_init(struct device_node *timer)
 }
 CLOCKSOURCE_OF_DECLARE(pc3x2_timer, "picochip,pc3x2-timer", dw_apb_timer_init);
 CLOCKSOURCE_OF_DECLARE(apb_timer, "snps,dw-apb-timer-osc", dw_apb_timer_init);
+CLOCKSOURCE_OF_DECLARE(rk3188_timer, "rockchip,rk3188-dw-apb-timer-osc", dw_apb_timer_init);
-- 
1.7.10.4

