Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaBQVbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:31:07 -0500
Received: from ring0.de ([5.45.105.125]:47168 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaBQVbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:31:05 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@debian.org>, Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: [PATCHv2] ARM: OMAP2+: Add support for thumb mode on DT booted N900
Date: Mon, 17 Feb 2014 22:30:58 +0100
Message-Id: <1392672658-13866-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391603582-11371-1-git-send-email-sre@debian.org>
References: <1391603582-11371-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without enabling the workaround for ARM errata 430973 thumb
compiled userland crashes randomly on the Nokia N900.

Signed-off-by: Sebastian Reichel <sre@debian.org>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
---
Hi,

This is PATCHv2 for the thumb errata workaround for N900 DT
boot, which should go into 3.14-rc.

Changes since PATCHv1:
 * Add Reviewed-By: Pavel Machek
 * Add more verbose warning about the errata as suggested by Pavel

I did not increase the verbose level, since the next higher verbose
level is pr_err and the message is not an error.

I think it would make sense to update the Kconfig entry for the errata to
enable the workaround by default for the Nokia N900. That should be done in
its own patch, though.

Apart from that it would be nice if errata workaround could be enabled
via DeviceTree instead of kernel configuration. This will require some
discussion though, so I think we should start with this patch for now.

-- Sebastian
---
 arch/arm/mach-omap2/pdata-quirks.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 3d5b24d..0cc710d 100644
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
@@ -169,6 +171,22 @@ static void __init am3517_evm_legacy_init(void)
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
+			pr_warning("Thumb binaries may crash randomly without this workaround\n");
+		}
+	}
+}
 #endif /* CONFIG_ARCH_OMAP3 */
 
 #ifdef CONFIG_ARCH_OMAP4
@@ -259,7 +277,7 @@ struct of_dev_auxdata omap_auxdata_lookup[] __initdata = {
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

