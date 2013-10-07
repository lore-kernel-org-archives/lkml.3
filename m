Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab3JGUoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 16:44:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53064 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab3JGUob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 16:44:31 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Felipe <balbi@ti.com>,
        Olof Johansson <olof@lixom.net>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V3] ARM: OMAP3: Fix hardware detection for omap3630 when booted with device tree
Date: Mon, 7 Oct 2013 15:43:49 -0500
Message-ID: <1381178629-13488-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131007192009.GA8949@atomide.com>
References: <20131007192009.GA8949@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SoC family definitions at the moment are reactive to board needs
as a result, beagle-xm would matchup with ti,omap3 which invokes
omap3430_init_early instead of omap3630_init_early. Obviously, this is
the wrong behavior.

With clock node dts conversion, we get the following warnings as a
result and 3630 based platforms fails to boot (uart4 clocks are only
present in OMAP3630 and not present in OMAP3430):

...
omap_hwmod: uart4: cannot clk_get main_clk uart4_fck
omap_hwmod: uart4: cannot _init_clocks

WARNING: CPU: 0 PID: 1 at arch/arm/mach-omap2/omap_hwmod.c:2434
_init+0x6c/0x80()
omap_hwmod: uart4: couldn't init clocks
...

WARNING: CPU: 0 PID: 1 at arch/arm/mach-omap2/omap_hwmod.c:2126
_enable+0x254/0x280()
omap_hwmod: timer12: enabled state can only be entered from
initialized, idle, or disabled state
...

WARNING: CPU: 0 PID: 46 at arch/arm/mach-omap2/omap_hwmod.c:2224
_idle+0xd4/0xf8()
omap_hwmod: timer12: idle state can only be entered from enabled state

WARNING: CPU: 0 PID: 1 at arch/arm/mach-omap2/omap_hwmod.c:2126
_enable+0x254/0x280()
omap_hwmod: uart4: enabled state can only be entered from
initialized, idle, or disabled state

So, add specific compatiblity for 3630 to allow match for Beagle-XM
platform.

Signed-off-by: Nishanth Menon <nm@ti.com>
---

Changes in V3 (since v2):
	- Fix typo in dts :(

V2: https://patchwork.kernel.org/patch/2999111/
	- based on v3.12-rc4 tag
	- Update based on Tony's review comments.

V1: http://marc.info/?l=linux-omap&m=138117342909375&w=2

RFC: https://patchwork.kernel.org/patch/2919661/

 arch/arm/boot/dts/omap3-beagle-xm.dts |    2 +-
 arch/arm/mach-omap2/board-generic.c   |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
index 0c514dc..2816bf6 100644
--- a/arch/arm/boot/dts/omap3-beagle-xm.dts
+++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
@@ -11,7 +11,7 @@
 
 / {
 	model = "TI OMAP3 BeagleBoard xM";
-	compatible = "ti,omap3-beagle-xm", "ti,omap3-beagle", "ti,omap3";
+	compatible = "ti,omap3-beagle-xm", "ti,omap36xx", "ti,omap3";
 
 	cpus {
 		cpu@0 {
diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 39c7838..4fe5b9c 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -113,6 +113,7 @@ MACHINE_END
 #ifdef CONFIG_ARCH_OMAP3
 static const char *omap3_boards_compat[] __initdata = {
 	"ti,omap3",
+	"ti,omap343x",
 	NULL,
 };
 
@@ -129,6 +130,24 @@ DT_MACHINE_START(OMAP3_DT, "Generic OMAP3 (Flattened Device Tree)")
 	.restart	= omap3xxx_restart,
 MACHINE_END
 
+static const char *omap36xx_boards_compat[] __initdata = {
+	"ti,omap36xx",
+	NULL,
+};
+
+DT_MACHINE_START(OMAP36XX_DT, "Generic OMAP36xx (Flattened Device Tree)")
+	.reserve	= omap_reserve,
+	.map_io		= omap3_map_io,
+	.init_early	= omap3630_init_early,
+	.init_irq	= omap_intc_of_init,
+	.handle_irq	= omap3_intc_handle_irq,
+	.init_machine	= omap_generic_init,
+	.init_late	= omap3_init_late,
+	.init_time	= omap3_sync32k_timer_init,
+	.dt_compat	= omap36xx_boards_compat,
+	.restart	= omap3xxx_restart,
+MACHINE_END
+
 static const char *omap3_gp_boards_compat[] __initdata = {
 	"ti,omap3-beagle",
 	"timll,omap3-devkit8000",
-- 
1.7.9.5

