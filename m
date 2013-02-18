Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab3BRGal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 01:30:41 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50287 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878Ab3BRGai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 01:30:38 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: [RFC 3/8] ARM: twd: clock rate from DT (if no DT clk tree)
Date: Mon, 18 Feb 2013 12:00:21 +0530
Message-ID: <94cb377171f84ceefd667aead4602d70adab6619.1361166003.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1361166003.git.afzal@ti.com>
References: <cover.1361166003.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an optional property to find clock-frequency from DT. This helps
as a fallback mechanism in case there is no representation of clock
tree in DT.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 Documentation/devicetree/bindings/arm/twd.txt | 7 ++++++-
 arch/arm/kernel/smp_twd.c                     | 8 ++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/twd.txt b/Documentation/devicetree/bindings/arm/twd.txt
index 75b8610..fdafa4f 100644
--- a/Documentation/devicetree/bindings/arm/twd.txt
+++ b/Documentation/devicetree/bindings/arm/twd.txt
@@ -7,8 +7,9 @@ and watchdog.
 The TWD is usually attached to a GIC to deliver its two per-processor
 interrupts.
 
-** Timer node required properties:
+** Timer node properties:
 
+Required properties:
 - compatible : Should be one of:
 	"arm,cortex-a9-twd-timer"
 	"arm,cortex-a5-twd-timer"
@@ -19,12 +20,16 @@ interrupts.
 - reg : Specify the base address and the size of the TWD timer
 	register window.
 
+Optional property:
+- clock-frequency : frequency(Hz) of peripheral clock fed to timer
+
 Example:
 
 	twd-timer@2c000600 {
 		compatible = "arm,arm11mp-twd-timer"";
 		reg = <0x2c000600 0x20>;
 		interrupts = <1 13 0xf01>;
+		clock-frequency = <300000000>;
 	};
 
 ** Watchdog node properties:
diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 118f4f2..aac0f9f 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -247,7 +247,15 @@ static void twd_get_clock(struct device_node *np)
 		twd_clk = clk_get_sys("smp_twd", NULL);
 
 	if (IS_ERR(twd_clk)) {
+		u32 freq;
+
 		pr_err("smp_twd: clock not found %d\n", (int) PTR_ERR(twd_clk));
+
+		/* If there is no representation of clock tree in DT,
+		   provide a fallback option to obtain frequency
+		 */
+		if (np && !of_property_read_u32(np, "clock-frequency", &freq))
+			twd_timer_rate = freq;
 		return;
 	}
 
-- 
1.7.12

