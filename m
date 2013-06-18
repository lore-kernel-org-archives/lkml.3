Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab3FRQFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:05:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48748 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932644Ab3FRQFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:05:34 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <b-cousson@ti.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 4/4] ARM: OMAP2+: Provide alias to USB PHY clock
Date: Tue, 18 Jun 2013 19:04:47 +0300
Message-ID: <1371571487-14389-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371571487-14389-1-git-send-email-rogerq@ti.com>
References: <1371571487-14389-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Till the OMAP clocks are correctly defined in device tree, use
this temporary hack to provide clock alias to the USB PHY clocks.

Without this, USB Host & Ethernet will not be functional with
device tree boots on Panda and uEVM.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/board-generic.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 88aa6b1..7428733 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -15,6 +15,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/irqdomain.h>
+#include <linux/clk.h>
 
 #include <asm/mach/arch.h>
 
@@ -35,6 +36,21 @@ static struct of_device_id omap_dt_match_table[] __initdata = {
 	{ }
 };
 
+/*
+ * Create alias for USB host PHY clock.
+ * Remove this when clock phandle can be provided via DT
+ */
+static void __init legacy_init_ehci_clk(char *clkname)
+{
+	int ret;
+
+	ret = clk_add_alias("main_clk", NULL, clkname, NULL);
+	if (ret) {
+		pr_err("%s:Failed to add main_clk alias to %s :%d\n",
+						__func__, clkname, ret);
+	}
+}
+
 static void __init omap_generic_init(void)
 {
 	omap_sdrc_init(NULL, NULL);
@@ -45,10 +61,15 @@ static void __init omap_generic_init(void)
 	 * HACK: call display setup code for selected boards to enable omapdss.
 	 * This will be removed when omapdss supports DT.
 	 */
-	if (of_machine_is_compatible("ti,omap4-panda"))
+	if (of_machine_is_compatible("ti,omap4-panda")) {
 		omap4_panda_display_init_of();
+		legacy_init_ehci_clk("auxclk3_ck");
+
+	}
 	else if (of_machine_is_compatible("ti,omap4-sdp"))
 		omap_4430sdp_display_init_of();
+	else if (of_machine_is_compatible("ti,omap5-uevm"))
+		legacy_init_ehci_clk("auxclk1_ck");
 }
 
 #ifdef CONFIG_SOC_OMAP2420
-- 
1.7.4.1

