Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaBEMmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 07:42:07 -0500
Received: from ring0.de ([5.45.105.125]:57240 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaBEMmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 07:42:03 -0500
X-Greylist: delayed 524 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Feb 2014 07:42:03 EST
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@debian.org>, Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] ARM: OMAP2+: Add support for thumb mode on DT booted N900
Date: Wed,  5 Feb 2014 13:33:02 +0100
Message-Id: <1391603582-11371-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without enabling the workaround for ARM errata 430973 thumb
compiled userland crashes randomly on the Nokia N900.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
Hi Tony,

I think this patch should be added into some fix branch for 3.14-rcX.

-- Sebastian
---
 arch/arm/mach-omap2/pdata-quirks.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 3d5b24d..7929df3 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -22,6 +22,8 @@
 #include "common-board-devices.h"
 #include "dss-common.h"
 #include "control.h"
+#include "omap-secure.h"
+#include "soc.h"
 
 struct pdata_init {
 	const char *compatible;
@@ -169,6 +171,21 @@ static void __init am3517_evm_legacy_init(void)
 	omap_ctrl_writel(v, AM35XX_CONTROL_IP_SW_RESET);
 	omap_ctrl_readl(AM35XX_CONTROL_IP_SW_RESET); /* OCP barrier */
 }
+
+static void __init nokia_n900_legacy_init(void)
+{
+	hsmmc2_internal_input_clk();
+
+	if (omap_type() == OMAP2_DEVICE_TYPE_SEC) {
+		if (IS_ENABLED(CONFIG_ARM_ERRATA_430973)) {
+			pr_info("RX-51: Enabling ARM errata 430973 workaround\n");
+			/* set IBE to 1 */
+			rx51_secure_update_aux_cr(BIT(6), 0);
+		} else {
+			pr_warning("RX-51: Not enabling ARM errata 430973 workaround\n");
+		}
+	}
+}
 #endif /* CONFIG_ARCH_OMAP3 */
 
 #ifdef CONFIG_ARCH_OMAP4
@@ -259,7 +276,7 @@ struct of_dev_auxdata omap_auxdata_lookup[] __initdata = {
 static struct pdata_init pdata_quirks[] __initdata = {
 #ifdef CONFIG_ARCH_OMAP3
 	{ "compulab,omap3-sbc-t3730", omap3_sbc_t3730_legacy_init, },
-	{ "nokia,omap3-n900", hsmmc2_internal_input_clk, },
+	{ "nokia,omap3-n900", nokia_n900_legacy_init, },
 	{ "nokia,omap3-n9", hsmmc2_internal_input_clk, },
 	{ "nokia,omap3-n950", hsmmc2_internal_input_clk, },
 	{ "isee,omap3-igep0020", omap3_igep0020_legacy_init, },
-- 
1.8.5.3

