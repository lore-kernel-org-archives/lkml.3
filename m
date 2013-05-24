Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3EXOcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:32:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60616 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab3EXOcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:32:23 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <balbi@ti.com>,
        <ldewangan@nvidia.com>, <gg@slimlogic.co.uk>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <george.cherian@ti.com>, <kishon@ti.com>,
        <sameo@linux.intel.com>
Subject: [PATCH 1/3] drivers: regulator: palmas: add an API to set/clear the switch bit on SMPS10
Date: Fri, 24 May 2013 20:01:34 +0530
Message-ID: <1369405896-30246-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369405896-30246-1-git-send-email-kishon@ti.com>
References: <1369405896-30246-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <gg@slimlogic.co.uk>

Added an API to set/clear the switch bit on SMPS10 which can be used by
palmas usb. The switch bit should be set in order for palmas to
supply VBUS and is needed when OMAP is acting as USB HOST.

Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/regulator/palmas-regulator.c | 26 ++++++++++++++++++++++++++
 include/linux/mfd/palmas.h           |  2 ++
 2 files changed, 28 insertions(+)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 92ceed0..d57ab55 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -465,6 +465,32 @@ static int palmas_smps_set_ramp_delay(struct regulator_dev *rdev,
 	return ret;
 }
 
+/**
+ * palmas_set_switch_smps10() - set or clear the switch bit on SMPS10
+ * @param palmas pointer to the palmas mfd structure
+ * @param sw boolean to indicate switch status
+ *
+ * There is not a way to represent this function within the regulator
+ * framework. This sets/clears the switch of SMPS10 so SMPS10_OUT1 and
+ * SMPS10_OUT2 are shorted together.
+ */
+int palmas_set_switch_smps10(struct palmas *palmas, int sw)
+{
+	unsigned int reg;
+
+	palmas_smps_read(palmas, PALMAS_SMPS10_CTRL, &reg);
+
+	if (sw)
+		reg |= SMPS10_SWITCH_EN;
+	else
+		reg &= ~SMPS10_SWITCH_EN;
+
+	palmas_smps_write(palmas, PALMAS_SMPS10_CTRL, reg);
+
+	return 0;
+}
+EXPORT_SYMBOL(palmas_set_switch_smps10);
+
 static struct regulator_ops palmas_ops_smps = {
 	.is_enabled		= palmas_is_enabled_smps,
 	.enable			= palmas_enable_smps,
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 8f21daf..6df375d 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -404,6 +404,8 @@ enum usb_irq_events {
 	N_PALMAS_USB_VOTG_SESS_VLD,
 };
 
+extern int palmas_set_switch_smps10(struct palmas *palmas, int sw);
+
 /* defines so we can store the mux settings */
 #define PALMAS_GPIO_0_MUXED					(1 << 0)
 #define PALMAS_GPIO_1_MUXED					(1 << 1)
-- 
1.8.1.2

