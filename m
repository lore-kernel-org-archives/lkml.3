Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943Ab3LTN0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:26:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36027 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924Ab3LTN0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:26:03 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-e0-52b445590d10
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, k.debski@samsung.com,
        tjakobi@math.uni-bielefeld.de, stern@rowland.harvard.edu
Subject: [PATCH RFC alternative ver 2] phy: Exynos 421x USB 2.0 PHY support
Date: Fri, 20 Dec 2013 14:24:17 +0100
Message-id: <1387545857-9472-12-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
References: <1387545857-9472-1-git-send-email-k.debski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t9jQd1I1y1BBl0zxC2W7L7BajH/yDlW
	i/43C1kt2q4cZLe4vPASq8WP1xfYLC487WGzONv0Bii2aw6bxYzz+5gsFi1rZbZYe+Quu8XZ
	/ttsFhObprFbnN/SyWRx+E07q8WE30Bt62e8ZrFoW/2B1aLj7EF2BxGPy329TB47Z91l97hz
	bQ+bx79j7B6z7/5g9OjbsorR4/iN7UwenzfJBXBEcdmkpOZklqUW6dslcGXsWruFsWBdccWp
	3+oNjO0JXYycHBICJhJHj15jhLDFJC7cW8/WxcjFISQwnVFi7u2V7BBOB5NE8+8jrF2MHBxs
	ApoSq+55gDSICNRITLl1BayGWaCLWWLCttNsIAlhAW+JPQsmMYHYLAKqEp8v3gSL8wq4SJxs
	mg82R0JAQWLOJBuQMCdQeObiRWAlQgLOEr/PPmKdwMi7gJFhFaNoakFyQXFSeq6RXnFibnFp
	Xrpecn7uJkZwwD+T3sG4qsHiEKMAB6MSD2+B/uYgIdbEsuLK3EOMEhzMSiK8/dpbgoR4UxIr
	q1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUw6qyTVXNn0eJ6K60n
	XhgnzHzk8ZW04z/FtEOidKqFV3DZv4r86q0ot/oGK2fgIf4WKYtwO2nzhB22+23uzZUKfbD8
	V8PiG+I32UqNb18VWGYz79Gtl7O2s06b5de/XXZ24TLBhARtR/Hm2KtcWrcX3z3PPafZ0/XG
	P7PJEQZztujzqSYYFusosRRnJBpqMRcVJwIAADG3NnQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This the alternative version of the support for Exynos 421x USB 2.0 PHY
in the Generic PHY framework. In this version the support for Exynos
4210 and 4212 was joined into one file.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
Hi,

This is the second alternative version. Please look at
"[PATCH RFC alternative ver 1] phy: Exynos 421x USB 2.0 PHY support" for
detailed description.

Best wishes,
Kamil Debski
---
 drivers/phy/phy-exynos4212-usb2.c |  452 +++++++++++++++++++++++++++++++++++++
 drivers/phy/phy-samsung-usb2.h    |    1 +
 2 files changed, 453 insertions(+)
 create mode 100644 drivers/phy/phy-exynos4212-usb2.c

diff --git a/drivers/phy/phy-exynos4212-usb2.c b/drivers/phy/phy-exynos4212-usb2.c
new file mode 100644
index 0000000..8f7578a
--- /dev/null
+++ b/drivers/phy/phy-exynos4212-usb2.c
@@ -0,0 +1,452 @@
+/*
+ * Samsung SoC USB 1.1/2.0 PHY driver - Exynos 4210 and 4212 support
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Author: Kamil Debski <k.debski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/phy/phy.h>
+#include <linux/regmap.h>
+#include "phy-samsung-usb2.h"
+
+/* Exynos USB PHY registers */
+
+/* PHY power control */
+#define EXYNOS_421x_UPHYPWR			0x0
+
+#define EXYNOS_421x_UPHYPWR_PHY0_SUSPEND	BIT(0)
+#define EXYNOS_421x_UPHYPWR_PHY0_PWR		BIT(3)
+#define EXYNOS_421x_UPHYPWR_PHY0_OTG_PWR	BIT(4)
+#define EXYNOS_421x_UPHYPWR_PHY0_SLEEP		BIT(5)
+#define EXYNOS_421x_UPHYPWR_PHY0 ( \
+	EXYNOS_421x_UPHYPWR_PHY0_SUSPEND | \
+	EXYNOS_421x_UPHYPWR_PHY0_PWR | \
+	EXYNOS_421x_UPHYPWR_PHY0_OTG_PWR | \
+	EXYNOS_421x_UPHYPWR_PHY0_SLEEP)
+
+#define EXYNOS_421x_UPHYPWR_PHY1_SUSPEND	BIT(6)
+#define EXYNOS_421x_UPHYPWR_PHY1_PWR		BIT(7)
+#define EXYNOS_421x_UPHYPWR_PHY1_SLEEP		BIT(8)
+#define EXYNOS_421x_UPHYPWR_PHY1 ( \
+	EXYNOS_421x_UPHYPWR_PHY1_SUSPEND | \
+	EXYNOS_421x_UPHYPWR_PHY1_PWR | \
+	EXYNOS_421x_UPHYPWR_PHY1_SLEEP)
+
+#define EXYNOS_4210_UPHYPWR_HSCI0_SUSPEND	BIT(9)
+#define EXYNOS_4210_UPHYPWR_HSCI0_SLEEP		BIT(10)
+#define EXYNOS_4210_UPHYPWR_HSCI0 ( \
+	EXYNOS_4210_UPHYPWR_HSCI0_SUSPEND | \
+	EXYNOS_4210_UPHYPWR_HSCI0_SLEEP)
+
+#define EXYNOS_4210_UPHYPWR_HSCI1_SUSPEND	BIT(11)
+#define EXYNOS_4210_UPHYPWR_HSCI1_SLEEP		BIT(12)
+#define EXYNOS_4210_UPHYPWR_HSCI1 ( \
+	EXYNOS_4210_UPHYPWR_HSCI1_SUSPEND | \
+	EXYNOS_4210_UPHYPWR_HSCI1_SLEEP)
+
+#define EXYNOS_4212_UPHYPWR_HSCI0_SUSPEND	BIT(9)
+#define EXYNOS_4212_UPHYPWR_HSCI0_PWR		BIT(10)
+#define EXYNOS_4212_UPHYPWR_HSCI0_SLEEP		BIT(11)
+#define EXYNOS_4212_UPHYPWR_HSCI0 ( \
+	EXYNOS_4212_UPHYPWR_HSCI0_SUSPEND | \
+	EXYNOS_4212_UPHYPWR_HSCI0_PWR | \
+	EXYNOS_4212_UPHYPWR_HSCI0_SLEEP)
+
+#define EXYNOS_4212_UPHYPWR_HSCI1_SUSPEND	BIT(12)
+#define EXYNOS_4212_UPHYPWR_HSCI1_PWR		BIT(13)
+#define EXYNOS_4212_UPHYPWR_HSCI1_SLEEP		BIT(14)
+#define EXYNOS_4212_UPHYPWR_HSCI1 ( \
+	EXYNOS_4212_UPHYPWR_HSCI1_SUSPEND | \
+	EXYNOS_4212_UPHYPWR_HSCI1_PWR | \
+	EXYNOS_4212_UPHYPWR_HSCI1_SLEEP)
+
+/* PHY clock control */
+#define EXYNOS_421x_UPHYCLK			0x4
+
+#define EXYNOS_421x_UPHYCLK_PHY0_COMMON_ON	BIT(4)
+#define EXYNOS_421x_UPHYCLK_PHY1_COMMON_ON	BIT(7)
+
+#define EXYNOS_4210_UPHYCLK_PHYFSEL_MASK	(0x3 << 0)
+#define EXYNOS_4210_UPHYCLK_PHYFSEL_48MHZ	(0x0 << 0)
+#define EXYNOS_4210_UPHYCLK_PHYFSEL_24MHZ	(0x3 << 0)
+#define EXYNOS_4210_UPHYCLK_PHYFSEL_12MHZ	(0x2 << 0)
+
+#define EXYNOS_4210_UPHYCLK_PHY0_ID_PULLUP	BIT(2)
+
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_MASK	(0x7 << 0)
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_9MHZ6	(0x0 << 0)
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_10MHZ	(0x1 << 0)
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_12MHZ	(0x2 << 0)
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_19MHZ2	(0x3 << 0)
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_20MHZ	(0x4 << 0)
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_24MHZ	(0x5 << 0)
+#define EXYNOS_4212_UPHYCLK_PHYFSEL_50MHZ	(0x7 << 0)
+
+#define EXYNOS_4212_UPHYCLK_PHY0_ID_PULLUP	BIT(3)
+
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_MASK	(0x7f << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_12MHZ	(0x24 << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_15MHZ	(0x1c << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_16MHZ	(0x1a << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_19MHZ2	(0x15 << 10)
+#define EXYNOS_4212_UPHYCLK_HSIC_REFCLK_20MHZ	(0x14 << 10)
+
+/* PHY reset control */
+#define EXYNOS_421x_UPHYRST			0x8
+
+#define EXYNOS_421x_URSTCON_PHY0		BIT(0)
+#define EXYNOS_421x_URSTCON_OTG_HLINK		BIT(1)
+#define EXYNOS_421x_URSTCON_OTG_PHYLINK		BIT(2)
+
+#define EXYNOS_4210_URSTCON_PHY1_ALL		BIT(3)
+#define EXYNOS_4210_URSTCON_PHY1_P0		BIT(4)
+#define EXYNOS_4210_URSTCON_PHY1_P1P2		BIT(5)
+#define EXYNOS_4210_URSTCON_HOST_LINK_ALL	BIT(6)
+#define EXYNOS_4210_URSTCON_HOST_LINK_P0	BIT(7)
+#define EXYNOS_4210_URSTCON_HOST_LINK_P1	BIT(8)
+#define EXYNOS_4210_URSTCON_HOST_LINK_P2	BIT(9)
+
+#define EXYNOS_4212_URSTCON_HOST_PHY		BIT(3)
+#define EXYNOS_4212_URSTCON_PHY1		BIT(4)
+#define EXYNOS_4212_URSTCON_HSIC0		BIT(5)
+#define EXYNOS_4212_URSTCON_HSIC1		BIT(6)
+#define EXYNOS_4212_URSTCON_HOST_LINK_ALL	BIT(7)
+#define EXYNOS_4212_URSTCON_HOST_LINK_P0	BIT(8)
+#define EXYNOS_4212_URSTCON_HOST_LINK_P1	BIT(9)
+#define EXYNOS_4212_URSTCON_HOST_LINK_P2	BIT(10)
+
+/* Isolation, configured in the power management unit */
+#define EXYNOS_4210_USB_ISOL_DEVICE_OFFSET	0x704
+#define EXYNOS_4210_USB_ISOL_DEVICE		BIT(0)
+#define EXYNOS_4210_USB_ISOL_HOST_OFFSET	0x708
+#define EXYNOS_4210_USB_ISOL_HOST		BIT(0)
+
+#define EXYNOS_4212_USB_ISOL_OFFSET		0x704
+#define EXYNOS_4212_USB_ISOL_OTG		BIT(0)
+#define EXYNOS_4212_USB_ISOL_HSIC0_OFFSET	0x708
+#define EXYNOS_4212_USB_ISOL_HSIC0		BIT(0)
+#define EXYNOS_4212_USB_ISOL_HSIC1_OFFSET	0x70c
+#define EXYNOS_4212_USB_ISOL_HSIC1		BIT(0)
+
+/* USBYPHY1 Floating prevention */
+#define EXYNOS_4210_UPHY1CON			0x34
+#define EXYNOS_4210_UPHY1CON_FLOAT_PREVENTION	0x1
+
+/* Mode switching SUB Device <-> Host */
+#define EXYNOS_421x_MODE_SWITCH_OFFSET		0x21c
+#define EXYNOS_421x_MODE_SWITCH_MASK		1
+#define EXYNOS_421x_MODE_SWITCH_DEVICE		0
+#define EXYNOS_421x_MODE_SWITCH_HOST		1
+
+enum exynos421x_phy_id {
+	EXYNOS421x_DEVICE,
+	EXYNOS421x_HOST,
+	EXYNOS421x_HSIC0,
+	EXYNOS421x_HSIC1,
+	EXYNOS421x_NUM_PHYS,
+};
+
+/*
+ * exynos4210_rate_to_clk() converts the supplied clock rate to the value that
+ * can be written to the phy register.
+ */
+static int exynos4210_rate_to_clk(unsigned long rate, u32 *reg)
+{
+	switch (rate) {
+	case 12 * MHZ:
+		*reg = EXYNOS_4210_UPHYCLK_PHYFSEL_12MHZ;
+		break;
+	case 24 * MHZ:
+		*reg = EXYNOS_4210_UPHYCLK_PHYFSEL_24MHZ;
+		break;
+	case 48 * MHZ:
+		*reg = EXYNOS_4210_UPHYCLK_PHYFSEL_48MHZ;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * exynos4212_rate_to_clk() converts the supplied clock rate to the value that
+ * can be written to the phy register.
+ */
+static int exynos4212_rate_to_clk(unsigned long rate, u32 *reg)
+{
+	/* EXYNOS_4212_UPHYCLK_PHYFSEL_MASK */
+
+	switch (rate) {
+	case 9600 * KHZ:
+		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_9MHZ6;
+		break;
+	case 10 * MHZ:
+		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_10MHZ;
+		break;
+	case 12 * MHZ:
+		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_12MHZ;
+		break;
+	case 19200 * KHZ:
+		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_19MHZ2;
+		break;
+	case 20 * MHZ:
+		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_20MHZ;
+		break;
+	case 24 * MHZ:
+		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_24MHZ;
+		break;
+	case 50 * MHZ:
+		*reg = EXYNOS_4212_UPHYCLK_PHYFSEL_50MHZ;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void exynos421x_isol(struct samsung_usb2_phy_instance *inst, bool on)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	u32 offset;
+	u32 mask;
+
+	if (inst->cfg->is_exynos4212) {
+		switch (inst->cfg->id) {
+		case EXYNOS421x_DEVICE:
+		case EXYNOS421x_HOST:
+			offset = EXYNOS_4212_USB_ISOL_OFFSET;
+			mask = EXYNOS_4212_USB_ISOL_OTG;
+			break;
+		case EXYNOS421x_HSIC0:
+			offset = EXYNOS_4212_USB_ISOL_HSIC0_OFFSET;
+			mask = EXYNOS_4212_USB_ISOL_HSIC0;
+			break;
+		case EXYNOS421x_HSIC1:
+			offset = EXYNOS_4212_USB_ISOL_HSIC1_OFFSET;
+			mask = EXYNOS_4212_USB_ISOL_HSIC1;
+			break;
+		default:
+			return;
+		};
+	} else {
+		switch (inst->cfg->id) {
+		case EXYNOS421x_DEVICE:
+			offset = EXYNOS_4210_USB_ISOL_DEVICE_OFFSET;
+			mask = EXYNOS_4210_USB_ISOL_DEVICE;
+			break;
+		case EXYNOS421x_HOST:
+			offset = EXYNOS_4210_USB_ISOL_HOST_OFFSET;
+			mask = EXYNOS_4210_USB_ISOL_HOST;
+			break;
+		default:
+			return;
+		}
+	}
+
+	regmap_update_bits(drv->reg_pmu, offset, mask, on ? 0 : mask);
+}
+
+static void exynos421x_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	u32 rstbits = 0;
+	u32 phypwr = 0;
+	u32 rst;
+	u32 pwr;
+
+	if (inst->cfg->is_exynos4212) {
+		switch (inst->cfg->id) {
+		case EXYNOS421x_DEVICE:
+			phypwr =	EXYNOS_421x_UPHYPWR_PHY0;
+			rstbits =	EXYNOS_421x_URSTCON_PHY0;
+			break;
+		case EXYNOS421x_HOST:
+			phypwr =	EXYNOS_421x_UPHYPWR_PHY1;
+			rstbits =	EXYNOS_4212_URSTCON_HOST_PHY;
+			break;
+		case EXYNOS421x_HSIC0:
+			phypwr =	EXYNOS_4212_UPHYPWR_HSCI0;
+			rstbits =	EXYNOS_4212_URSTCON_HSIC1 |
+					EXYNOS_4212_URSTCON_HOST_LINK_P0 |
+					EXYNOS_4212_URSTCON_HOST_PHY;
+			break;
+		case EXYNOS421x_HSIC1:
+			phypwr =	EXYNOS_4212_UPHYPWR_HSCI1;
+			rstbits =	EXYNOS_4212_URSTCON_HSIC1 |
+					EXYNOS_4212_URSTCON_HOST_LINK_P1;
+			break;
+		};
+	} else {
+		switch (inst->cfg->id) {
+		case EXYNOS421x_DEVICE:
+			phypwr =	EXYNOS_421x_UPHYPWR_PHY0;
+			rstbits =	EXYNOS_421x_URSTCON_PHY0;
+			break;
+		case EXYNOS421x_HOST:
+			phypwr =	EXYNOS_421x_UPHYPWR_PHY1;
+			rstbits =	EXYNOS_4210_URSTCON_PHY1_ALL |
+					EXYNOS_4210_URSTCON_PHY1_P0 |
+					EXYNOS_4210_URSTCON_PHY1_P1P2 |
+					EXYNOS_4210_URSTCON_HOST_LINK_ALL |
+					EXYNOS_4210_URSTCON_HOST_LINK_P0;
+			writel(on, drv->reg_phy + EXYNOS_4210_UPHY1CON);
+			break;
+		case EXYNOS421x_HSIC0:
+			phypwr =	EXYNOS_4210_UPHYPWR_HSCI0;
+			rstbits =	EXYNOS_4210_URSTCON_PHY1_P1P2 |
+					EXYNOS_4210_URSTCON_HOST_LINK_P1;
+			break;
+		case EXYNOS421x_HSIC1:
+			phypwr =	EXYNOS_4210_UPHYPWR_HSCI1;
+			rstbits =	EXYNOS_4210_URSTCON_PHY1_P1P2 |
+					EXYNOS_4210_URSTCON_HOST_LINK_P2;
+			break;
+		};
+	}
+
+	if (on) {
+		writel(inst->clk_reg_val, drv->reg_phy + EXYNOS_421x_UPHYCLK);
+
+		pwr = readl(drv->reg_phy + EXYNOS_421x_UPHYPWR);
+		pwr &= ~phypwr;
+		writel(pwr, drv->reg_phy + EXYNOS_421x_UPHYPWR);
+
+		rst = readl(drv->reg_phy + EXYNOS_421x_UPHYRST);
+		rst |= rstbits;
+		writel(rst, drv->reg_phy + EXYNOS_421x_UPHYRST);
+		udelay(10);
+		rst &= ~rstbits;
+		writel(rst, drv->reg_phy + EXYNOS_421x_UPHYRST);
+	} else {
+		pwr = readl(drv->reg_phy + EXYNOS_421x_UPHYPWR);
+		pwr |= phypwr;
+		writel(pwr, drv->reg_phy + EXYNOS_421x_UPHYPWR);
+	}
+}
+
+static int exynos421x_power_on(struct samsung_usb2_phy_instance *inst)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+
+	inst->enabled = 1;
+	exynos421x_phy_pwr(inst, 1);
+	exynos421x_isol(inst, 0);
+
+	/* Power on the device, as it is necessary for HSIC to work */
+	if (inst->cfg->is_exynos4212 && inst->cfg->id == EXYNOS421x_HSIC0) {
+		struct samsung_usb2_phy_instance *device =
+					&drv->instances[EXYNOS421x_DEVICE];
+		exynos421x_phy_pwr(device, 1);
+		exynos421x_isol(device, 0);
+	}
+
+	return 0;
+}
+
+static int exynos421x_power_off(struct samsung_usb2_phy_instance *inst)
+{
+	struct samsung_usb2_phy_driver *drv = inst->drv;
+	struct samsung_usb2_phy_instance *device =
+					&drv->instances[EXYNOS421x_DEVICE];
+
+	inst->enabled = 0;
+	exynos421x_isol(inst, 1);
+	exynos421x_phy_pwr(inst, 0);
+
+	if (inst->cfg->is_exynos4212 && inst->cfg->id == EXYNOS421x_HSIC0 &&
+							!device->enabled) {
+		exynos421x_isol(device, 1);
+		exynos421x_phy_pwr(device, 0);
+	}
+
+	return 0;
+}
+
+static const struct samsung_usb2_common_phy exynos4210_phys[] = {
+	{
+		.label		= "device",
+		.id		= EXYNOS421x_DEVICE,
+		.rate_to_clk	= exynos4210_rate_to_clk,
+		.power_on	= exynos421x_power_on,
+		.power_off	= exynos421x_power_off,
+	},
+	{
+		.label		= "host",
+		.id		= EXYNOS421x_HOST,
+		.rate_to_clk	= exynos4210_rate_to_clk,
+		.power_on	= exynos421x_power_on,
+		.power_off	= exynos421x_power_off,
+	},
+	{
+		.label		= "hsic0",
+		.id		= EXYNOS421x_HSIC0,
+		.rate_to_clk	= exynos4210_rate_to_clk,
+		.power_on	= exynos421x_power_on,
+		.power_off	= exynos421x_power_off,
+	},
+	{
+		.label		= "hsic1",
+		.id		= EXYNOS421x_HSIC1,
+		.rate_to_clk	= exynos4210_rate_to_clk,
+		.power_on	= exynos421x_power_on,
+		.power_off	= exynos421x_power_off,
+	},
+	{},
+};
+
+const struct samsung_usb2_phy_config exynos4210_usb2_phy_config = {
+	.num_phys		= EXYNOS421x_NUM_PHYS,
+	.phys			= exynos4210_phys,
+	.has_mode_switch	= 1,
+};
+
+static const struct samsung_usb2_common_phy exynos4212_phys[] = {
+	{
+		.label		= "device",
+		.id		= EXYNOS421x_DEVICE,
+		.rate_to_clk	= exynos4212_rate_to_clk,
+		.power_on	= exynos421x_power_on,
+		.power_off	= exynos421x_power_off,
+		.is_exynos4212	= 1,
+	},
+	{
+		.label		= "host",
+		.id		= EXYNOS421x_HOST,
+		.rate_to_clk	= exynos4212_rate_to_clk,
+		.power_on	= exynos421x_power_on,
+		.power_off	= exynos421x_power_off,
+		.is_exynos4212	= 1,
+	},
+	{
+		.label		= "hsic0",
+		.id		= EXYNOS421x_HSIC0,
+		.rate_to_clk	= exynos4212_rate_to_clk,
+		.power_on	= exynos421x_power_on,
+		.power_off	= exynos421x_power_off,
+		.is_exynos4212	= 1,
+	},
+	{
+		.label		= "hsic1",
+		.id		= EXYNOS421x_HSIC1,
+		.rate_to_clk	= exynos4212_rate_to_clk,
+		.power_on	= exynos421x_power_on,
+		.power_off	= exynos421x_power_off,
+		.is_exynos4212	= 1,
+	},
+	{},
+};
+
+const struct samsung_usb2_phy_config exynos4212_usb2_phy_config = {
+	.num_phys		= EXYNOS421x_NUM_PHYS,
+	.phys			= exynos4212_phys,
+	.has_mode_switch	= 1,
+};
+
diff --git a/drivers/phy/phy-samsung-usb2.h b/drivers/phy/phy-samsung-usb2.h
index ab89f91..db02692 100644
--- a/drivers/phy/phy-samsung-usb2.h
+++ b/drivers/phy/phy-samsung-usb2.h
@@ -52,6 +52,7 @@ struct samsung_usb2_common_phy {
 	int (*power_off)(struct samsung_usb2_phy_instance *);
 	unsigned int id;
 	char *label;
+	bool is_exynos4212;
 };
 
 
-- 
1.7.9.5

