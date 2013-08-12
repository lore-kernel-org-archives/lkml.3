Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab3HLNIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:08:44 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2381 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3HLNHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:07:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 12 Aug 2013 06:07:12 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <balbi@ti.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <swarren@wwwdotorg.org>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH v3 3/6] usb: phy: tegra: Tegra30 support
Date: Mon, 12 Aug 2013 16:06:51 +0300
Message-ID: <1376312814-18992-4-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376312814-18992-1-git-send-email-ttynkkynen@nvidia.com>
References: <1376312814-18992-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Tegra30 USB PHY is a bit different than the Tegra20 PHY:

- The EHCI controller supports the HOSTPC register extension, and some
  of the fields that the PHY needs to modify (PHCD and PTS) have moved
  to the new HOSTPC register.
- Some of the UTMI PLL configuration registers have moved from the USB
  register space to the Clock-And-Reset controller space. In Tegra30
  the clock driver is responsible for configuring the UTMI PLL.
- The USBMODE register must be explicitly written to enter host mode.
- Certain PHY parameters need to be programmed for optimal signal
  quality. Support for this will be added in the next patch.

The new tegra_phy_soc_config structure is added to describe the
differences between the SoCs.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Reviewed-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/usb/phy/phy-tegra-usb.c   | 121 +++++++++++++++++++++++++++++---------
 include/linux/usb/tegra_usb_phy.h |  19 ++++++
 2 files changed, 112 insertions(+), 28 deletions(-)

diff --git a/drivers/usb/phy/phy-tegra-usb.c b/drivers/usb/phy/phy-tegra-usb.c
index ebbf85f..1ad184a 100644
--- a/drivers/usb/phy/phy-tegra-usb.c
+++ b/drivers/usb/phy/phy-tegra-usb.c
@@ -28,6 +28,7 @@
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/of_gpio.h>
 #include <linux/usb/otg.h>
 #include <linux/usb/ulpi.h>
@@ -39,11 +40,16 @@
 
 #define ULPI_VIEWPORT		0x170
 
-/* PORTSC registers */
+/* PORTSC PTS/PHCD bits, Tegra20 only */
 #define TEGRA_USB_PORTSC1				0x184
 #define TEGRA_USB_PORTSC1_PTS(x)			(((x) & 0x3) << 30)
 #define TEGRA_USB_PORTSC1_PHCD				(1 << 23)
 
+/* HOSTPC1 PTS/PHCD bits, Tegra30 and above */
+#define TEGRA_USB_HOSTPC1_DEVLC		0x1b4
+#define TEGRA_USB_HOSTPC1_DEVLC_PTS(x)	(((x) & 0x7) << 29)
+#define TEGRA_USB_HOSTPC1_DEVLC_PHCD	(1 << 22)
+
 /* Bits of PORTSC1, which will get cleared by writing 1 into them */
 #define TEGRA_PORTSC1_RWC_BITS	(PORT_CSC | PORT_PEC | PORT_OCC)
 
@@ -141,6 +147,12 @@
 #define UTMIP_BIAS_CFG1		0x83c
 #define   UTMIP_BIAS_PDTRK_COUNT(x)	(((x) & 0x1f) << 3)
 
+/* For Tegra30 and above only, the address is different in Tegra20 */
+#define USB_USBMODE		0x1f8
+#define   USB_USBMODE_MASK		(3 << 0)
+#define   USB_USBMODE_HOST		(3 << 0)
+#define   USB_USBMODE_DEVICE		(2 << 0)
+
 static DEFINE_SPINLOCK(utmip_pad_lock);
 static int utmip_pad_count;
 
@@ -193,10 +205,17 @@ static void set_pts(struct tegra_usb_phy *phy, u8 pts_val)
 	void __iomem *base = phy->regs;
 	unsigned long val;
 
-	val = readl(base + TEGRA_USB_PORTSC1) & ~TEGRA_PORTSC1_RWC_BITS;
-	val &= ~TEGRA_USB_PORTSC1_PTS(3);
-	val |= TEGRA_USB_PORTSC1_PTS(pts_val & 3);
-	writel(val, base + TEGRA_USB_PORTSC1);
+	if (phy->soc_config->has_hostpc) {
+		val = readl(base + TEGRA_USB_HOSTPC1_DEVLC);
+		val &= ~TEGRA_USB_HOSTPC1_DEVLC_PTS(~0);
+		val |= TEGRA_USB_HOSTPC1_DEVLC_PTS(pts_val);
+		writel(val, base + TEGRA_USB_HOSTPC1_DEVLC);
+	} else {
+		val = readl(base + TEGRA_USB_PORTSC1) & ~TEGRA_PORTSC1_RWC_BITS;
+		val &= ~TEGRA_USB_PORTSC1_PTS(~0);
+		val |= TEGRA_USB_PORTSC1_PTS(pts_val);
+		writel(val, base + TEGRA_USB_PORTSC1);
+	}
 }
 
 static void set_phcd(struct tegra_usb_phy *phy, bool enable)
@@ -204,12 +223,21 @@ static void set_phcd(struct tegra_usb_phy *phy, bool enable)
 	void __iomem *base = phy->regs;
 	unsigned long val;
 
-	val = readl(base + TEGRA_USB_PORTSC1) & ~TEGRA_PORTSC1_RWC_BITS;
-	if (enable)
-		val |= TEGRA_USB_PORTSC1_PHCD;
-	else
-		val &= ~TEGRA_USB_PORTSC1_PHCD;
-	writel(val, base + TEGRA_USB_PORTSC1);
+	if (phy->soc_config->has_hostpc) {
+		val = readl(base + TEGRA_USB_HOSTPC1_DEVLC);
+		if (enable)
+			val |= TEGRA_USB_HOSTPC1_DEVLC_PHCD;
+		else
+			val &= ~TEGRA_USB_HOSTPC1_DEVLC_PHCD;
+		writel(val, base + TEGRA_USB_HOSTPC1_DEVLC);
+	} else {
+		val = readl(base + TEGRA_USB_PORTSC1) & ~PORT_RWC_BITS;
+		if (enable)
+			val |= TEGRA_USB_PORTSC1_PHCD;
+		else
+			val &= ~TEGRA_USB_PORTSC1_PHCD;
+		writel(val, base + TEGRA_USB_PORTSC1);
+	}
 }
 
 static int utmip_pad_open(struct tegra_usb_phy *phy)
@@ -367,17 +395,21 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 	val &= ~UTMIP_SUSPEND_EXIT_ON_EDGE;
 	writel(val, base + UTMIP_MISC_CFG0);
 
-	val = readl(base + UTMIP_MISC_CFG1);
-	val &= ~(UTMIP_PLL_ACTIVE_DLY_COUNT(~0) | UTMIP_PLLU_STABLE_COUNT(~0));
-	val |= UTMIP_PLL_ACTIVE_DLY_COUNT(phy->freq->active_delay) |
-		UTMIP_PLLU_STABLE_COUNT(phy->freq->stable_count);
-	writel(val, base + UTMIP_MISC_CFG1);
-
-	val = readl(base + UTMIP_PLL_CFG1);
-	val &= ~(UTMIP_XTAL_FREQ_COUNT(~0) | UTMIP_PLLU_ENABLE_DLY_COUNT(~0));
-	val |= UTMIP_XTAL_FREQ_COUNT(phy->freq->xtal_freq_count) |
-		UTMIP_PLLU_ENABLE_DLY_COUNT(phy->freq->enable_delay);
-	writel(val, base + UTMIP_PLL_CFG1);
+	if (!phy->soc_config->utmi_pll_config_in_car_module) {
+		val = readl(base + UTMIP_MISC_CFG1);
+		val &= ~(UTMIP_PLL_ACTIVE_DLY_COUNT(~0) |
+			UTMIP_PLLU_STABLE_COUNT(~0));
+		val |= UTMIP_PLL_ACTIVE_DLY_COUNT(phy->freq->active_delay) |
+			UTMIP_PLLU_STABLE_COUNT(phy->freq->stable_count);
+		writel(val, base + UTMIP_MISC_CFG1);
+
+		val = readl(base + UTMIP_PLL_CFG1);
+		val &= ~(UTMIP_XTAL_FREQ_COUNT(~0) |
+			UTMIP_PLLU_ENABLE_DLY_COUNT(~0));
+		val |= UTMIP_XTAL_FREQ_COUNT(phy->freq->xtal_freq_count) |
+			UTMIP_PLLU_ENABLE_DLY_COUNT(phy->freq->enable_delay);
+		writel(val, base + UTMIP_PLL_CFG1);
+	}
 
 	if (phy->mode == USB_DR_MODE_PERIPHERAL) {
 		val = readl(base + USB_SUSP_CTRL);
@@ -448,6 +480,16 @@ static int utmi_phy_power_on(struct tegra_usb_phy *phy)
 
 	utmi_phy_clk_enable(phy);
 
+	if (phy->soc_config->requires_usbmode_setup) {
+		val = readl(base + USB_USBMODE);
+		val &= ~USB_USBMODE_MASK;
+		if (phy->mode == USB_DR_MODE_HOST)
+			val |= USB_USBMODE_HOST;
+		else
+			val |= USB_USBMODE_DEVICE;
+		writel(val, base + USB_USBMODE);
+	}
+
 	if (!phy->is_legacy_phy)
 		set_pts(phy, 0);
 
@@ -864,8 +906,30 @@ static int utmi_phy_probe(struct tegra_usb_phy *tegra_phy,
 	return 0;
 }
 
+static const struct tegra_phy_soc_config tegra20_soc_config = {
+	.utmi_pll_config_in_car_module = false,
+	.has_hostpc = false,
+	.requires_usbmode_setup = false,
+	.requires_extra_tuning_parameters = false,
+};
+
+static const struct tegra_phy_soc_config tegra30_soc_config = {
+	.utmi_pll_config_in_car_module = true,
+	.has_hostpc = true,
+	.requires_usbmode_setup = true,
+	.requires_extra_tuning_parameters = true,
+};
+
+static struct of_device_id tegra_usb_phy_id_table[] = {
+	{ .compatible = "nvidia,tegra30-usb-phy", .data = &tegra30_soc_config },
+	{ .compatible = "nvidia,tegra20-usb-phy", .data = &tegra20_soc_config },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tegra_usb_phy_id_table);
+
 static int tegra_usb_phy_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *match;
 	struct resource *res;
 	struct tegra_usb_phy *tegra_phy = NULL;
 	struct device_node *np = pdev->dev.of_node;
@@ -878,6 +942,13 @@ static int tegra_usb_phy_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	match = of_match_device(tegra_usb_phy_id_table, &pdev->dev);
+	if (!match) {
+		dev_err(&pdev->dev, "Error: No device match found\n");
+		return -ENODEV;
+	}
+	tegra_phy->soc_config = match->data;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "Failed to get I/O memory\n");
@@ -968,12 +1039,6 @@ static int tegra_usb_phy_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id tegra_usb_phy_id_table[] = {
-	{ .compatible = "nvidia,tegra20-usb-phy", },
-	{ },
-};
-MODULE_DEVICE_TABLE(of, tegra_usb_phy_id_table);
-
 static struct platform_driver tegra_usb_phy_driver = {
 	.probe		= tegra_usb_phy_probe,
 	.remove		= tegra_usb_phy_remove,
diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
index d3db274..d3a63c3 100644
--- a/include/linux/usb/tegra_usb_phy.h
+++ b/include/linux/usb/tegra_usb_phy.h
@@ -18,6 +18,24 @@
 #include <linux/clk.h>
 #include <linux/usb/otg.h>
 
+/*
+ * utmi_pll_config_in_car_module: true if the UTMI PLL configuration registers
+ *     should be set up by clk-tegra, false if by the PHY code
+ * has_hostpc: true if the USB controller has the HOSTPC extension, which
+ *     changes the location of the PHCD and PTS fields
+ * requires_usbmode_setup: true if the USBMODE register needs to be set to
+ *      enter host mode
+ * requires_extra_tuning_parameters: true if xcvr_hsslew, hssquelch_level
+ *      and hsdiscon_level should be set for adequate signal quality
+ */
+
+struct tegra_phy_soc_config {
+	bool utmi_pll_config_in_car_module;
+	bool has_hostpc;
+	bool requires_usbmode_setup;
+	bool requires_extra_tuning_parameters;
+};
+
 struct tegra_utmip_config {
 	u8 hssync_start_delay;
 	u8 elastic_limit;
@@ -47,6 +65,7 @@ struct tegra_usb_phy {
 	struct regulator *vbus;
 	enum usb_dr_mode mode;
 	void *config;
+	const struct tegra_phy_soc_config *soc_config;
 	struct usb_phy *ulpi;
 	struct usb_phy u_phy;
 	bool is_legacy_phy;
-- 
1.8.1.5

