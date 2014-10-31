Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793AbaJaN04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:26:56 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41943 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759693AbaJaN0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:26:52 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        kishon@ti.com, balbi@ti.com, stern@rowland.harvard.edu,
        kgene.kim@samsung.com, heikki.krogerus@linux.intel.com,
        mathias.nyman@intel.com, sergei.shtylyov@cogentembedded.com,
        jwerner@google.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v7 2/2] phy: exynos5-usbdrd: Calibrate LOS levels for exynos5420/5800
Date: Fri, 31 Oct 2014 18:56:29 +0530
Message-Id: <1414761989-21088-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414761989-21088-1-git-send-email-gautam.vivek@samsung.com>
References: <1414761989-21088-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding phy calibration sequence for USB 3.0 DRD PHY present on
Exynos5420/5800 systems.
This calibration facilitates setting certain PHY parameters viz.
the Loss-of-Signal (LOS) Detector Threshold Level, as well as
Tx-Vboost-Level for Super-Speed operations.
Additionally we also set proper time to wait for RxDetect measurement,
for desired PHY reference clock, so as to solve issue with enumeration
of few USB 3.0 devices, like Samsung SUM-TSB16S 3.0 USB drive
on the controller.

We are using CR_port for this purpose to send required data
to override the LOS values.

On testing with USB 3.0 devices on USB 3.0 port present on
SMDK5420, and peach-pit boards should see following message:
usb 2-1: new SuperSpeed USB device number 2 using xhci-hcd

and without this patch, should see below shown message:
usb 1-1: new high-speed USB device number 2 using xhci-hcd

[Also removed unnecessary extra lines in the register macro definitions]

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/phy/phy-exynos5-usbdrd.c |  219 +++++++++++++++++++++++++++++++++++---
 1 file changed, 203 insertions(+), 16 deletions(-)

diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index b3ca3bc..1a63634 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -37,13 +37,11 @@
 
 /* EXYNOS5: USB 3.0 DRD PHY registers */
 #define EXYNOS5_DRD_LINKSYSTEM			0x04
-
 #define LINKSYSTEM_FLADJ_MASK			(0x3f << 1)
 #define LINKSYSTEM_FLADJ(_x)			((_x) << 1)
 #define LINKSYSTEM_XHCI_VERSION_CONTROL		BIT(27)
 
 #define EXYNOS5_DRD_PHYUTMI			0x08
-
 #define PHYUTMI_OTGDISABLE			BIT(6)
 #define PHYUTMI_FORCESUSPEND			BIT(1)
 #define PHYUTMI_FORCESLEEP			BIT(0)
@@ -51,26 +49,20 @@
 #define EXYNOS5_DRD_PHYPIPE			0x0c
 
 #define EXYNOS5_DRD_PHYCLKRST			0x10
-
 #define PHYCLKRST_EN_UTMISUSPEND		BIT(31)
-
 #define PHYCLKRST_SSC_REFCLKSEL_MASK		(0xff << 23)
 #define PHYCLKRST_SSC_REFCLKSEL(_x)		((_x) << 23)
-
 #define PHYCLKRST_SSC_RANGE_MASK		(0x03 << 21)
 #define PHYCLKRST_SSC_RANGE(_x)			((_x) << 21)
-
 #define PHYCLKRST_SSC_EN			BIT(20)
 #define PHYCLKRST_REF_SSP_EN			BIT(19)
 #define PHYCLKRST_REF_CLKDIV2			BIT(18)
-
 #define PHYCLKRST_MPLL_MULTIPLIER_MASK		(0x7f << 11)
 #define PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF	(0x19 << 11)
 #define PHYCLKRST_MPLL_MULTIPLIER_50M_REF	(0x32 << 11)
 #define PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF	(0x68 << 11)
 #define PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF	(0x7d << 11)
 #define PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF	(0x02 << 11)
-
 #define PHYCLKRST_FSEL_UTMI_MASK		(0x7 << 5)
 #define PHYCLKRST_FSEL_PIPE_MASK		(0x7 << 8)
 #define PHYCLKRST_FSEL(_x)			((_x) << 5)
@@ -78,46 +70,68 @@
 #define PHYCLKRST_FSEL_PAD_24MHZ		(0x2a << 5)
 #define PHYCLKRST_FSEL_PAD_20MHZ		(0x31 << 5)
 #define PHYCLKRST_FSEL_PAD_19_2MHZ		(0x38 << 5)
-
 #define PHYCLKRST_RETENABLEN			BIT(4)
-
 #define PHYCLKRST_REFCLKSEL_MASK		(0x03 << 2)
 #define PHYCLKRST_REFCLKSEL_PAD_REFCLK		(0x2 << 2)
 #define PHYCLKRST_REFCLKSEL_EXT_REFCLK		(0x3 << 2)
-
 #define PHYCLKRST_PORTRESET			BIT(1)
 #define PHYCLKRST_COMMONONN			BIT(0)
 
 #define EXYNOS5_DRD_PHYREG0			0x14
+#define PHYREG0_SSC_REF_CLK_SEL			BIT(21)
+#define PHYREG0_SSC_RANGE			BIT(20)
+#define PHYREG0_CR_WRITE			BIT(19)
+#define PHYREG0_CR_READ				BIT(18)
+#define PHYREG0_CR_DATA_IN(_x)			((_x) << 2)
+#define PHYREG0_CR_CAP_DATA			BIT(1)
+#define PHYREG0_CR_CAP_ADDR			BIT(0)
+
 #define EXYNOS5_DRD_PHYREG1			0x18
+#define PHYREG1_CR_DATA_OUT(_x)			((_x) << 1)
+#define PHYREG1_CR_ACK				BIT(0)
 
 #define EXYNOS5_DRD_PHYPARAM0			0x1c
-
 #define PHYPARAM0_REF_USE_PAD			BIT(31)
 #define PHYPARAM0_REF_LOSLEVEL_MASK		(0x1f << 26)
 #define PHYPARAM0_REF_LOSLEVEL			(0x9 << 26)
 
 #define EXYNOS5_DRD_PHYPARAM1			0x20
-
 #define PHYPARAM1_PCS_TXDEEMPH_MASK		(0x1f << 0)
 #define PHYPARAM1_PCS_TXDEEMPH			(0x1c)
 
 #define EXYNOS5_DRD_PHYTERM			0x24
 
 #define EXYNOS5_DRD_PHYTEST			0x28
-
 #define PHYTEST_POWERDOWN_SSP			BIT(3)
 #define PHYTEST_POWERDOWN_HSP			BIT(2)
 
 #define EXYNOS5_DRD_PHYADP			0x2c
 
 #define EXYNOS5_DRD_PHYUTMICLKSEL		0x30
-
 #define PHYUTMICLKSEL_UTMI_CLKSEL		BIT(2)
 
 #define EXYNOS5_DRD_PHYRESUME			0x34
 #define EXYNOS5_DRD_LINKPORT			0x44
 
+/* USB 3.0 DRD PHY SS Function Control Reg; accessed by CR_PORT */
+#define EXYNOS5_DRD_PHYSS_LOSLEVEL_OVRD_IN		(0x15)
+#define LOSLEVEL_OVRD_IN_LOS_BIAS_5420			(0x5 << 13)
+#define LOSLEVEL_OVRD_IN_LOS_BIAS_DEFAULT		(0x0 << 13)
+#define LOSLEVEL_OVRD_IN_EN				(0x1 << 10)
+#define LOSLEVEL_OVRD_IN_LOS_LEVEL_DEFAULT		(0x9 << 0)
+
+#define EXYNOS5_DRD_PHYSS_TX_VBOOSTLEVEL_OVRD_IN	(0x12)
+#define TX_VBOOSTLEVEL_OVRD_IN_VBOOST_5420		(0x5 << 13)
+#define TX_VBOOSTLEVEL_OVRD_IN_VBOOST_DEFAULT		(0x4 << 13)
+
+#define EXYNOS5_DRD_PHYSS_LANE0_TX_DEBUG		(0x1010)
+#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_19M2_20M		(0x4 << 4)
+#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_24M		(0x8 << 4)
+#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_25M_26M		(0x8 << 4)
+#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_48M_50M_52M	(0x20 << 4)
+#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_62M5		(0x20 << 4)
+#define LANE0_TX_DEBUG_RXDET_MEAS_TIME_96M_100M		(0x40 << 4)
+
 #define KHZ	1000
 #define MHZ	(KHZ * KHZ)
 
@@ -135,12 +149,14 @@ struct exynos5_usbdrd_phy_config {
 	void (*phy_isol)(struct phy_usb_instance *inst, u32 on);
 	void (*phy_init)(struct exynos5_usbdrd_phy *phy_drd);
 	unsigned int (*set_refclk)(struct phy_usb_instance *inst);
+	int (*phy_calibrate)(struct phy_usb_instance *inst);
 };
 
 struct exynos5_usbdrd_phy_drvdata {
 	const struct exynos5_usbdrd_phy_config *phy_cfg;
 	u32 pmu_offset_usbdrd0_phy;
 	u32 pmu_offset_usbdrd1_phy;
+	int (*phy_exynos_calibrate)(struct exynos5_usbdrd_phy *phy_drd);
 };
 
 /**
@@ -399,9 +415,21 @@ static int exynos5_usbdrd_phy_init(struct phy *phy)
 	reg &= ~PHYCLKRST_PORTRESET;
 	writel(reg, phy_drd->reg_phy + EXYNOS5_DRD_PHYCLKRST);
 
+	/*
+	 * Calibrate some of the PHY parameters, using cr_port control
+	 * register, which are internal to PHY and are not exposed
+	 * directly to the outside world for configuring.
+	 */
+	if (inst->phy_cfg->phy_calibrate) {
+		ret = inst->phy_cfg->phy_calibrate(inst);
+		if (ret)
+			dev_err(phy_drd->dev,
+				"Exiting init: Failed to calibrate PHY\n");
+	}
+
 	clk_disable_unprepare(phy_drd->clk);
 
-	return 0;
+	return ret;
 }
 
 static int exynos5_usbdrd_phy_exit(struct phy *phy)
@@ -487,6 +515,163 @@ static int exynos5_usbdrd_phy_power_off(struct phy *phy)
 	return 0;
 }
 
+static int crport_handshake(struct exynos5_usbdrd_phy *phy_drd,
+						u32 val, u32 cmd)
+{
+	u32 usec = 100;
+	unsigned int result;
+
+	writel(val | cmd, phy_drd->reg_phy + EXYNOS5_DRD_PHYREG0);
+
+	do {
+		result = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYREG1);
+		if (result & PHYREG1_CR_ACK)
+			break;
+
+		udelay(1);
+	} while (usec-- > 0);
+
+	if (!usec) {
+		dev_err(phy_drd->dev,
+			"CRPORT handshake timeout1 (0x%08x)\n", val);
+		return -ETIME;
+	}
+
+	usec = 100;
+
+	writel(val, phy_drd->reg_phy + EXYNOS5_DRD_PHYREG0);
+
+	do {
+		result = readl(phy_drd->reg_phy + EXYNOS5_DRD_PHYREG1);
+		if (!(result & PHYREG1_CR_ACK))
+			break;
+
+		udelay(1);
+	} while (usec-- > 0);
+
+	if (!usec) {
+		dev_err(phy_drd->dev,
+			"CRPORT handshake timeout2 (0x%08x)\n", val);
+		return -ETIME;
+	}
+
+	return 0;
+}
+
+static int crport_ctrl_write(struct exynos5_usbdrd_phy *phy_drd,
+						u32 addr, u32 data)
+{
+	int ret;
+
+	/* Write Address */
+	writel(PHYREG0_CR_DATA_IN(addr),
+		phy_drd->reg_phy + EXYNOS5_DRD_PHYREG0);
+	ret = crport_handshake(phy_drd, PHYREG0_CR_DATA_IN(addr),
+				PHYREG0_CR_CAP_ADDR);
+	if (ret)
+		return ret;
+
+	/* Write Data */
+	writel(PHYREG0_CR_DATA_IN(data),
+		phy_drd->reg_phy + EXYNOS5_DRD_PHYREG0);
+	ret = crport_handshake(phy_drd, PHYREG0_CR_DATA_IN(data),
+				PHYREG0_CR_CAP_DATA);
+	if (ret)
+		return ret;
+
+	ret = crport_handshake(phy_drd, PHYREG0_CR_DATA_IN(data),
+				PHYREG0_CR_WRITE);
+
+	return ret;
+}
+
+/*
+ * Calibrate few PHY parameters using CR_PORT register to meet
+ * SuperSpeed requirements on Exynos5420 and Exynos5800 systems,
+ * which have 28nm USB 3.0 DRD PHY.
+ */
+static void exynos5420_usbdrd_phy_calibrate(struct exynos5_usbdrd_phy *phy_drd)
+{
+	unsigned int temp;
+	int ret = 0;
+
+	/*
+	 * Change los_bias to (0x5) for 28nm PHY from a
+	 * default value (0x0); los_level is set as default
+	 * (0x9) as also reflected in los_level[30:26] bits
+	 * of PHYPARAM0 register.
+	 */
+	temp = LOSLEVEL_OVRD_IN_LOS_BIAS_5420 |
+		LOSLEVEL_OVRD_IN_EN |
+		LOSLEVEL_OVRD_IN_LOS_LEVEL_DEFAULT;
+	ret = crport_ctrl_write(phy_drd,
+				EXYNOS5_DRD_PHYSS_LOSLEVEL_OVRD_IN,
+				temp);
+	if (ret) {
+		dev_err(phy_drd->dev,
+		 "Failed setting Loss-of-Signal level for SuperSpeed\n");
+		return ret;
+	}
+
+	/*
+	 * Set tx_vboost_lvl to (0x5) for 28nm PHY Tuning,
+	 * to raise Tx signal level from its default value of (0x4)
+	 */
+	temp = TX_VBOOSTLEVEL_OVRD_IN_VBOOST_5420;
+	ret = crport_ctrl_write(phy_drd,
+				EXYNOS5_DRD_PHYSS_TX_VBOOSTLEVEL_OVRD_IN,
+				temp);
+	if (ret) {
+		dev_err(phy_drd->dev,
+		 "Failed setting Tx-Vboost-Level for SuperSpeed\n");
+		return ret;
+	}
+
+	/*
+	 * Set proper time to wait for RxDetect measurement, for
+	 * desired reference clock of PHY, by tuning the CR_PORT
+	 * register LANE0.TX_DEBUG which is internal to PHY.
+	 * This fixes issue with few USB 3.0 devices, which are
+	 * not detected (not even generate interrupts on the bus
+	 * on insertion) without this change.
+	 * e.g. Samsung SUM-TSB16S 3.0 USB drive.
+	 */
+	switch (phy_drd->extrefclk) {
+	case EXYNOS5_FSEL_50MHZ:
+		temp = LANE0_TX_DEBUG_RXDET_MEAS_TIME_48M_50M_52M;
+		break;
+	case EXYNOS5_FSEL_20MHZ:
+	case EXYNOS5_FSEL_19MHZ2:
+		temp = LANE0_TX_DEBUG_RXDET_MEAS_TIME_19M2_20M;
+		break;
+	case EXYNOS5_FSEL_24MHZ:
+	default:
+		temp = LANE0_TX_DEBUG_RXDET_MEAS_TIME_24M;
+		break;
+	}
+
+	ret = crport_ctrl_write(phy_drd,
+				EXYNOS5_DRD_PHYSS_LANE0_TX_DEBUG,
+				temp);
+	if (ret)
+		dev_err(phy_drd->dev,
+		 "Failed setting RxDetect measurement time for SuperSpeed\n");
+
+	return ret;
+}
+
+/* Calibrate PIPE3 PHY settings, if any */
+static int exynos5_usbdrd_pipe3_calibrate(struct phy_usb_instance *inst)
+{
+	struct exynos5_usbdrd_phy *phy_drd = to_usbdrd_phy(inst);
+
+	/* Call respective phy_calibrate given by certain platform */
+	if (phy_drd->drv_data->phy_exynos_calibrate)
+		return phy_drd->drv_data->phy_exynos_calibrate(phy_drd);
+
+	return -ENODEV;
+}
+
 static struct phy *exynos5_usbdrd_phy_xlate(struct device *dev,
 					struct of_phandle_args *args)
 {
@@ -518,6 +703,7 @@ static const struct exynos5_usbdrd_phy_config phy_cfg_exynos5[] = {
 		.phy_isol	= exynos5_usbdrd_phy_isol,
 		.phy_init	= exynos5_usbdrd_pipe3_init,
 		.set_refclk	= exynos5_usbdrd_pipe3_set_refclk,
+		.phy_calibrate	= exynos5_usbdrd_pipe3_calibrate,
 	},
 };
 
@@ -525,6 +711,7 @@ static const struct exynos5_usbdrd_phy_drvdata exynos5420_usbdrd_phy = {
 	.phy_cfg		= phy_cfg_exynos5,
 	.pmu_offset_usbdrd0_phy	= EXYNOS5_USBDRD_PHY_CONTROL,
 	.pmu_offset_usbdrd1_phy	= EXYNOS5420_USBDRD1_PHY_CONTROL,
+	.phy_exynos_calibrate	= exynos5420_usbdrd_phy_calibrate,
 };
 
 static const struct exynos5_usbdrd_phy_drvdata exynos5250_usbdrd_phy = {
-- 
1.7.10.4

