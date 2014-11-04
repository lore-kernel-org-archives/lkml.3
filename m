Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaKDLbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:31:25 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:54951 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaKDLbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:31:20 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] power: reset: augment versatile driver for integrator
Date: Tue,  4 Nov 2014 12:31:12 +0100
Message-Id: <1415100672-31425-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Augment the Versatile reset driver to also handle the core
module reset sequence used on the Integrator/AP and
Integrator/CP.

Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Sebastian: please merge this into your power tree if you're
OK with it, the corresponding platform changes are orthogonal
so these can go separately through the ARM SoC tree.
---
 drivers/power/reset/arm-versatile-reboot.c | 32 +++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/power/reset/arm-versatile-reboot.c b/drivers/power/reset/arm-versatile-reboot.c
index 5b08bffcf1a8..adea9d0c38e0 100644
--- a/drivers/power/reset/arm-versatile-reboot.c
+++ b/drivers/power/reset/arm-versatile-reboot.c
@@ -15,14 +15,21 @@
 #include <linux/of.h>
 #include <asm/system_misc.h>
 
+#define INTEGRATOR_HDR_CTRL_OFFSET	0x0C
+#define INTEGRATOR_HDR_LOCK_OFFSET	0x14
+#define INTEGRATOR_CM_CTRL_RESET	(1 << 3)
+
 #define REALVIEW_SYS_LOCK_OFFSET	0x20
-#define REALVIEW_SYS_LOCK_VAL		0xA05F
 #define REALVIEW_SYS_RESETCTL_OFFSET	0x40
 
+/* Magic unlocking token used on all Versatile boards */
+#define VERSATILE_LOCK_VAL		0xA05F
+
 /*
  * We detect the different syscon types from the compatible strings.
  */
 enum versatile_reboot {
+	INTEGRATOR_REBOOT_CM,
 	REALVIEW_REBOOT_EB,
 	REALVIEW_REBOOT_PB1176,
 	REALVIEW_REBOOT_PB11MP,
@@ -36,6 +43,10 @@ static enum versatile_reboot versatile_reboot_type;
 
 static const struct of_device_id versatile_reboot_of_match[] = {
 	{
+		.compatible = "arm,core-module-integrator",
+		.data = (void *)INTEGRATOR_REBOOT_CM
+	},
+	{
 		.compatible = "arm,realview-eb-syscon",
 		.data = (void *)REALVIEW_REBOOT_EB,
 	},
@@ -55,31 +66,46 @@ static const struct of_device_id versatile_reboot_of_match[] = {
 		.compatible = "arm,realview-pbx-syscon",
 		.data = (void *)REALVIEW_REBOOT_PBX,
 	},
+	{},
 };
 
 static void versatile_reboot(enum reboot_mode mode, const char *cmd)
 {
 	/* Unlock the reset register */
-	regmap_write(syscon_regmap, REALVIEW_SYS_LOCK_OFFSET,
-		     REALVIEW_SYS_LOCK_VAL);
 	/* Then hit reset on the different machines */
 	switch (versatile_reboot_type) {
+	case INTEGRATOR_REBOOT_CM:
+		regmap_write(syscon_regmap, INTEGRATOR_HDR_LOCK_OFFSET,
+			     VERSATILE_LOCK_VAL);
+		regmap_update_bits(syscon_regmap,
+				   INTEGRATOR_HDR_CTRL_OFFSET,
+				   INTEGRATOR_CM_CTRL_RESET,
+				   INTEGRATOR_CM_CTRL_RESET);
+		break;
 	case REALVIEW_REBOOT_EB:
+		regmap_write(syscon_regmap, REALVIEW_SYS_LOCK_OFFSET,
+			     VERSATILE_LOCK_VAL);
 		regmap_write(syscon_regmap,
 			     REALVIEW_SYS_RESETCTL_OFFSET, 0x0008);
 		break;
 	case REALVIEW_REBOOT_PB1176:
+		regmap_write(syscon_regmap, REALVIEW_SYS_LOCK_OFFSET,
+			     VERSATILE_LOCK_VAL);
 		regmap_write(syscon_regmap,
 			     REALVIEW_SYS_RESETCTL_OFFSET, 0x0100);
 		break;
 	case REALVIEW_REBOOT_PB11MP:
 	case REALVIEW_REBOOT_PBA8:
+		regmap_write(syscon_regmap, REALVIEW_SYS_LOCK_OFFSET,
+			     VERSATILE_LOCK_VAL);
 		regmap_write(syscon_regmap, REALVIEW_SYS_RESETCTL_OFFSET,
 			     0x0000);
 		regmap_write(syscon_regmap, REALVIEW_SYS_RESETCTL_OFFSET,
 			     0x0004);
 		break;
 	case REALVIEW_REBOOT_PBX:
+		regmap_write(syscon_regmap, REALVIEW_SYS_LOCK_OFFSET,
+			     VERSATILE_LOCK_VAL);
 		regmap_write(syscon_regmap, REALVIEW_SYS_RESETCTL_OFFSET,
 			     0x00f0);
 		regmap_write(syscon_regmap, REALVIEW_SYS_RESETCTL_OFFSET,
-- 
1.9.3

