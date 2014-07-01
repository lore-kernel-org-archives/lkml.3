Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbaGAPQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:16:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42024 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbaGAPQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:16:45 -0400
X-AuditID: cbfee61b-f79f86d00000144c-95-53b2d0daf111
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: kishon@ti.com, t.figa@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, k.debski@samsung.com
Subject: [PATCH v2] phy: phy-samsung-usb2: Change phy power on/power off
 sequence
Date: Tue, 01 Jul 2014 17:15:54 +0200
Message-id: <1404227754-452-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t9jQd1bFzYFG8ycaWzRduUgu8WP1xfY
	LC487WGzuLxrDpvFjPP7mCwWLWtltlh75C67xfoZr1kcODz6tqxi9Dh+YzuTx+dNcgHMUVw2
	Kak5mWWpRfp2CVwZm2bMYSzYbVNxvr+BtYHxolEXIyeHhICJxOrrJ1kgbDGJC/fWs3UxcnEI
	CUxnlPj86TcThNPBJPFh4ULmLkYODjYBTYlV9zxAGkQEEiRmXl7CDmIzCxRKvFv8lhHEFhYI
	lujaup4FpJxFQFXi8okYkDCvgJPE666dTCBhCQEFiTmTbCYwci9gZFjFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERwWz6R3MK5qsDjEKMDBqMTDe6J2Y7AQa2JZcWXuIUYJDmYlEd6G85uC
	hXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgskycXBKNTBuMejw4hM9
	tivU6pJ/3ela7YU8C90cE9wsZWxPzb91s7bsVUGqrW3rh/XnPKfP8hS/MZVlSZLlh0k2liqX
	D6WufrHFtOzl9oBvG4LY7EVvftJpc2158WmW4/PoVWHTtpl6rLJu1OoylrrUJpGhJslvJPvm
	kNjlPwu0P5RWOv6Y8MM5oUza+7cSS3FGoqEWc1FxIgCdC8iPBwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Exynos4412 USB 2.0 PHY hardware differs from the description provided
in the documentation. Some register bits have different function. This
patch fixes the defines of register bits and changes the way how phys are
powered on and off.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/phy/phy-exynos4x12-usb2.c |  112 +++++++++++++++++++++++++------------
 drivers/phy/phy-exynos5250-usb2.c |    2 -
 drivers/phy/phy-samsung-usb2.h    |    3 +-
 3 files changed, 77 insertions(+), 40 deletions(-)

diff --git a/drivers/phy/phy-exynos4x12-usb2.c b/drivers/phy/phy-exynos4x12-usb2.c
index d92a7cc..63134d8 100644
--- a/drivers/phy/phy-exynos4x12-usb2.c
+++ b/drivers/phy/phy-exynos4x12-usb2.c
@@ -86,13 +86,23 @@
 #define EXYNOS_4x12_URSTCON_OTG_HLINK		BIT(1)
 #define EXYNOS_4x12_URSTCON_OTG_PHYLINK		BIT(2)
 #define EXYNOS_4x12_URSTCON_HOST_PHY		BIT(3)
+/* The following bit defines are presented in the
+ * order taken from the Exynos4412 reference manual.
+ *
+ * During experiments with the hardware and debugging
+ * it was determined that the hardware behaves contrary
+ * to the manual.
+ *
+ * The following bit values were chaned accordingly to the
+ * results of real hardware experiments.
+ */
 #define EXYNOS_4x12_URSTCON_PHY1		BIT(4)
-#define EXYNOS_4x12_URSTCON_HSIC0		BIT(5)
-#define EXYNOS_4x12_URSTCON_HSIC1		BIT(6)
+#define EXYNOS_4x12_URSTCON_HSIC0		BIT(6)
+#define EXYNOS_4x12_URSTCON_HSIC1		BIT(5)
 #define EXYNOS_4x12_URSTCON_HOST_LINK_ALL	BIT(7)
-#define EXYNOS_4x12_URSTCON_HOST_LINK_P0	BIT(8)
+#define EXYNOS_4x12_URSTCON_HOST_LINK_P0	BIT(10)
 #define EXYNOS_4x12_URSTCON_HOST_LINK_P1	BIT(9)
-#define EXYNOS_4x12_URSTCON_HOST_LINK_P2	BIT(10)
+#define EXYNOS_4x12_URSTCON_HOST_LINK_P2	BIT(8)
 
 /* Isolation, configured in the power management unit */
 #define EXYNOS_4x12_USB_ISOL_OFFSET		0x704
@@ -188,6 +198,7 @@ static void exynos4x12_setup_clk(struct samsung_usb2_phy_instance *inst)
 	clk = readl(drv->reg_phy + EXYNOS_4x12_UPHYCLK);
 	clk &= ~EXYNOS_4x12_UPHYCLK_PHYFSEL_MASK;
 	clk |= drv->ref_reg_val << EXYNOS_4x12_UPHYCLK_PHYFSEL_OFFSET;
+	clk |= EXYNOS_4x12_UPHYCLK_PHY1_COMMON_ON;
 	writel(clk, drv->reg_phy + EXYNOS_4x12_UPHYCLK);
 }
 
@@ -198,27 +209,22 @@ static void exynos4x12_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
 	u32 phypwr = 0;
 	u32 rst;
 	u32 pwr;
-	u32 mode = 0;
-	u32 switch_mode = 0;
 
 	switch (inst->cfg->id) {
 	case EXYNOS4x12_DEVICE:
 		phypwr =	EXYNOS_4x12_UPHYPWR_PHY0;
 		rstbits =	EXYNOS_4x12_URSTCON_PHY0;
-		mode =		EXYNOS_4x12_MODE_SWITCH_DEVICE;
-		switch_mode =	1;
 		break;
 	case EXYNOS4x12_HOST:
 		phypwr =	EXYNOS_4x12_UPHYPWR_PHY1;
-		rstbits =	EXYNOS_4x12_URSTCON_HOST_PHY;
-		mode =		EXYNOS_4x12_MODE_SWITCH_HOST;
-		switch_mode =	1;
+		rstbits =	EXYNOS_4x12_URSTCON_HOST_PHY |
+				EXYNOS_4x12_URSTCON_PHY1 |
+				EXYNOS_4x12_URSTCON_HOST_LINK_P0;
 		break;
 	case EXYNOS4x12_HSIC0:
 		phypwr =	EXYNOS_4x12_UPHYPWR_HSIC0;
-		rstbits =	EXYNOS_4x12_URSTCON_HSIC1 |
-				EXYNOS_4x12_URSTCON_HOST_LINK_P0 |
-				EXYNOS_4x12_URSTCON_HOST_PHY;
+		rstbits =	EXYNOS_4x12_URSTCON_HSIC0 |
+				EXYNOS_4x12_URSTCON_HOST_LINK_P1;
 		break;
 	case EXYNOS4x12_HSIC1:
 		phypwr =	EXYNOS_4x12_UPHYPWR_HSIC1;
@@ -228,11 +234,6 @@ static void exynos4x12_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
 	};
 
 	if (on) {
-		if (switch_mode)
-			regmap_update_bits(drv->reg_sys,
-					   EXYNOS_4x12_MODE_SWITCH_OFFSET,
-					   EXYNOS_4x12_MODE_SWITCH_MASK, mode);
-
 		pwr = readl(drv->reg_phy + EXYNOS_4x12_UPHYPWR);
 		pwr &= ~phypwr;
 		writel(pwr, drv->reg_phy + EXYNOS_4x12_UPHYPWR);
@@ -253,41 +254,78 @@ static void exynos4x12_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
 	}
 }
 
-static int exynos4x12_power_on(struct samsung_usb2_phy_instance *inst)
+static void exynos4x12_power_on_int(struct samsung_usb2_phy_instance *inst)
 {
-	struct samsung_usb2_phy_driver *drv = inst->drv;
+	if (inst->int_cnt++ > 0)
+		return;
 
-	inst->enabled = 1;
 	exynos4x12_setup_clk(inst);
-	exynos4x12_phy_pwr(inst, 1);
 	exynos4x12_isol(inst, 0);
+	exynos4x12_phy_pwr(inst, 1);
+}
+
+static int exynos4x12_power_on(struct samsung_usb2_phy_instance *inst)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+
+	if (inst->ext_cnt++ > 0)
+		return 0;
 
-	/* Power on the device, as it is necessary for HSIC to work */
-	if (inst->cfg->id == EXYNOS4x12_HSIC0) {
-		struct samsung_usb2_phy_instance *device =
-					&drv->instances[EXYNOS4x12_DEVICE];
-		exynos4x12_phy_pwr(device, 1);
-		exynos4x12_isol(device, 0);
+	if (inst->cfg->id == EXYNOS4x12_HOST) {
+		regmap_update_bits(drv->reg_sys, EXYNOS_4x12_MODE_SWITCH_OFFSET,
+						EXYNOS_4x12_MODE_SWITCH_MASK,
+						EXYNOS_4x12_MODE_SWITCH_HOST);
+		exynos4x12_power_on_int(&drv->instances[EXYNOS4x12_DEVICE]);
 	}
 
+	if (inst->cfg->id == EXYNOS4x12_DEVICE)
+		regmap_update_bits(drv->reg_sys, EXYNOS_4x12_MODE_SWITCH_OFFSET,
+						EXYNOS_4x12_MODE_SWITCH_MASK,
+						EXYNOS_4x12_MODE_SWITCH_DEVICE);
+
+	if (inst->cfg->id == EXYNOS4x12_HSIC0 ||
+		inst->cfg->id == EXYNOS4x12_HSIC1) {
+		exynos4x12_power_on_int(&drv->instances[EXYNOS4x12_DEVICE]);
+		exynos4x12_power_on_int(&drv->instances[EXYNOS4x12_HOST]);
+	}
+
+	exynos4x12_power_on_int(inst);
+
 	return 0;
 }
 
-static int exynos4x12_power_off(struct samsung_usb2_phy_instance *inst)
+static void exynos4x12_power_off_int(struct samsung_usb2_phy_instance *inst)
 {
-	struct samsung_usb2_phy_driver *drv = inst->drv;
-	struct samsung_usb2_phy_instance *device =
-					&drv->instances[EXYNOS4x12_DEVICE];
+	if (inst->int_cnt-- > 1)
+		return;
 
-	inst->enabled = 0;
 	exynos4x12_isol(inst, 1);
 	exynos4x12_phy_pwr(inst, 0);
+}
 
-	if (inst->cfg->id == EXYNOS4x12_HSIC0 && !device->enabled) {
-		exynos4x12_isol(device, 1);
-		exynos4x12_phy_pwr(device, 0);
+static int exynos4x12_power_off(struct samsung_usb2_phy_instance *inst)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+
+	if (inst->ext_cnt-- > 1)
+		return 0;
+
+	if (inst->cfg->id == EXYNOS4x12_DEVICE)
+		regmap_update_bits(drv->reg_sys, EXYNOS_4x12_MODE_SWITCH_OFFSET,
+						EXYNOS_4x12_MODE_SWITCH_MASK,
+						EXYNOS_4x12_MODE_SWITCH_HOST);
+
+	if (inst->cfg->id == EXYNOS4x12_HOST)
+		exynos4x12_power_off_int(&drv->instances[EXYNOS4x12_DEVICE]);
+
+	if (inst->cfg->id == EXYNOS4x12_HSIC0 ||
+		inst->cfg->id == EXYNOS4x12_HSIC1) {
+		exynos4x12_power_off_int(&drv->instances[EXYNOS4x12_DEVICE]);
+		exynos4x12_power_off_int(&drv->instances[EXYNOS4x12_HOST]);
 	}
 
+	exynos4x12_power_off_int(inst);
+
 	return 0;
 }
 
diff --git a/drivers/phy/phy-exynos5250-usb2.c b/drivers/phy/phy-exynos5250-usb2.c
index 94179af..1c139aa 100644
--- a/drivers/phy/phy-exynos5250-usb2.c
+++ b/drivers/phy/phy-exynos5250-usb2.c
@@ -318,7 +318,6 @@ static int exynos5250_power_on(struct samsung_usb2_phy_instance *inst)
 
 		break;
 	}
-	inst->enabled = 1;
 	exynos5250_isol(inst, 0);
 
 	return 0;
@@ -331,7 +330,6 @@ static int exynos5250_power_off(struct samsung_usb2_phy_instance *inst)
 	u32 otg;
 	u32 hsic;
 
-	inst->enabled = 0;
 	exynos5250_isol(inst, 1);
 
 	switch (inst->cfg->id) {
diff --git a/drivers/phy/phy-samsung-usb2.h b/drivers/phy/phy-samsung-usb2.h
index 45b3170..9188478 100644
--- a/drivers/phy/phy-samsung-usb2.h
+++ b/drivers/phy/phy-samsung-usb2.h
@@ -29,7 +29,8 @@ struct samsung_usb2_phy_instance {
 	const struct samsung_usb2_common_phy *cfg;
 	struct phy *phy;
 	struct samsung_usb2_phy_driver *drv;
-	bool enabled;
+	int int_cnt;
+	int ext_cnt;
 };
 
 struct samsung_usb2_phy_driver {
-- 
1.7.9.5

