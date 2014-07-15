Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbaGOM4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:56:40 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:45307 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002AbaGOM4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:56:30 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, mkl@pengutronix.de
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH v3 4/4] can: flexcan: add vf610 support for FlexCAN
Date: Tue, 15 Jul 2014 14:56:21 +0200
Message-Id: <ff2ea1726b13dc2ffa3519ce9244f3633cf1420d.1405428166.git.stefan@agner.ch>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <cover.1405428166.git.stefan@agner.ch>
References: <cover.1405428166.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend FlexCAN driver to support Vybrid. Vybrids variant of the IP
has ECC support which is controlled through the memory error
control register (MECR). There is also an errata which leads to
false positive error detections (ID e5295). This patch disables
the memory error detection completely.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/net/can/flexcan.c | 73 +++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 64 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 89745aa..1c31a5d 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -92,6 +92,27 @@
 #define FLEXCAN_CTRL_ERR_ALL \
 	(FLEXCAN_CTRL_ERR_BUS | FLEXCAN_CTRL_ERR_STATE)
 
+/* FLEXCAN control register 2 (CTRL2) bits */
+#define FLEXCAN_CRL2_ECRWRE		BIT(29)
+#define FLEXCAN_CRL2_WRMFRZ		BIT(28)
+#define FLEXCAN_CRL2_RFFN(x)		(((x) & 0x0f) << 24)
+#define FLEXCAN_CRL2_TASD(x)		(((x) & 0x1f) << 19)
+#define FLEXCAN_CRL2_MRP		BIT(18)
+#define FLEXCAN_CRL2_RRS		BIT(17)
+#define FLEXCAN_CRL2_EACEN		BIT(16)
+
+/* FLEXCAN memory error control register (MECR) bits */
+#define FLEXCAN_MECR_ECRWRDIS		BIT(31)
+#define FLEXCAN_MECR_HANCEI_MSK		BIT(19)
+#define FLEXCAN_MECR_FANCEI_MSK		BIT(18)
+#define FLEXCAN_MECR_CEI_MSK		BIT(16)
+#define FLEXCAN_MECR_HAERRIE		BIT(15)
+#define FLEXCAN_MECR_FAERRIE		BIT(14)
+#define FLEXCAN_MECR_EXTERRIE		BIT(13)
+#define FLEXCAN_MECR_RERRDIS		BIT(9)
+#define FLEXCAN_MECR_ECCDIS		BIT(8)
+#define FLEXCAN_MECR_NCEFAFRZ		BIT(7)
+
 /* FLEXCAN error and status register (ESR) bits */
 #define FLEXCAN_ESR_TWRN_INT		BIT(17)
 #define FLEXCAN_ESR_RWRN_INT		BIT(16)
@@ -150,18 +171,20 @@
  * FLEXCAN hardware feature flags
  *
  * Below is some version info we got:
- *    SOC   Version   IP-Version  Glitch-  [TR]WRN_INT
- *                                Filter?   connected?
- *   MX25  FlexCAN2  03.00.00.00     no         no
- *   MX28  FlexCAN2  03.00.04.00    yes        yes
- *   MX35  FlexCAN2  03.00.00.00     no         no
- *   MX53  FlexCAN2  03.00.00.00    yes         no
- *   MX6s  FlexCAN3  10.00.12.00    yes        yes
+ *    SOC   Version   IP-Version  Glitch-  [TR]WRN_INT  Memory err
+ *                                Filter?   connected?  detection
+ *   MX25  FlexCAN2  03.00.00.00     no         no         no
+ *   MX28  FlexCAN2  03.00.04.00    yes        yes         no
+ *   MX35  FlexCAN2  03.00.00.00     no         no         no
+ *   MX53  FlexCAN2  03.00.00.00    yes         no         no
+ *   MX6s  FlexCAN3  10.00.12.00    yes        yes         no
+ *   VF610 FlexCAN3  ?               no         no        yes
  *
  * Some SOCs do not have the RX_WARN & TX_WARN interrupt line connected.
  */
 #define FLEXCAN_HAS_V10_FEATURES	BIT(1) /* For core version >= 10 */
 #define FLEXCAN_HAS_BROKEN_ERR_STATE	BIT(2) /* [TR]WRN_INT not connected */
+#define FLEXCAN_HAS_MECR_FEATURES	BIT(3) /* Memory error detection */
 
 /* Structure of the message buffer */
 struct flexcan_mb {
@@ -192,8 +215,11 @@ struct flexcan_regs {
 	u32 crcr;		/* 0x44 */
 	u32 rxfgmask;		/* 0x48 */
 	u32 rxfir;		/* 0x4c */
-	u32 _reserved3[12];
+	u32 _reserved3[12];	/* 0x50 */
 	struct flexcan_mb cantxfg[64];
+	u32 _reserved4[408];
+	u32 mecr;		/* 0xae0 */
+	u32 erriar;		/* 0xae4 */
 };
 
 struct flexcan_devtype_data {
@@ -223,6 +249,9 @@ static struct flexcan_devtype_data fsl_imx28_devtype_data;
 static struct flexcan_devtype_data fsl_imx6q_devtype_data = {
 	.features = FLEXCAN_HAS_V10_FEATURES,
 };
+static struct flexcan_devtype_data fsl_vf610_devtype_data = {
+	.features = FLEXCAN_HAS_V10_FEATURES | FLEXCAN_HAS_MECR_FEATURES,
+};
 
 static const struct can_bittiming_const flexcan_bittiming_const = {
 	.name = DRV_NAME,
@@ -807,7 +836,7 @@ static int flexcan_chip_start(struct net_device *dev)
 	struct flexcan_priv *priv = netdev_priv(dev);
 	struct flexcan_regs __iomem *regs = priv->base;
 	int err;
-	u32 reg_mcr, reg_ctrl;
+	u32 reg_mcr, reg_ctrl, reg_crl2, reg_mecr;
 
 	/* enable module */
 	err = flexcan_chip_enable(priv);
@@ -884,6 +913,31 @@ static int flexcan_chip_start(struct net_device *dev)
 	if (priv->devtype_data->features & FLEXCAN_HAS_V10_FEATURES)
 		flexcan_write(0x0, &regs->rxfgmask);
 
+	/*
+	 * On Vybrid, disable memory error detection interrupts
+	 * and freeze mode.
+	 * This also works around errata e5295 which generates
+	 * false positive memory errors and put the device in
+	 * freeze mode.
+	 */
+	if (priv->devtype_data->features & FLEXCAN_HAS_MECR_FEATURES) {
+		/*
+		 * Follow the protocol as described in "Detection
+		 * and Correction of Memory Errors" to write to
+		 * MECR register
+		 */
+		reg_crl2 = flexcan_read(&regs->crl2);
+		reg_crl2 |= FLEXCAN_CRL2_ECRWRE;
+		flexcan_write(reg_crl2, &regs->crl2);
+
+		reg_mecr = flexcan_read(&regs->mecr);
+		reg_mecr &= ~FLEXCAN_MECR_ECRWRDIS;
+		flexcan_write(reg_mecr, &regs->mecr);
+		reg_mecr &= ~(FLEXCAN_MECR_NCEFAFRZ | FLEXCAN_MECR_HANCEI_MSK |
+				FLEXCAN_MECR_FANCEI_MSK);
+		flexcan_write(reg_mecr, &regs->mecr);
+	}
+
 	err = flexcan_transceiver_enable(priv);
 	if (err)
 		goto out_chip_disable;
@@ -1094,6 +1148,7 @@ static const struct of_device_id flexcan_of_match[] = {
 	{ .compatible = "fsl,imx6q-flexcan", .data = &fsl_imx6q_devtype_data, },
 	{ .compatible = "fsl,imx28-flexcan", .data = &fsl_imx28_devtype_data, },
 	{ .compatible = "fsl,p1010-flexcan", .data = &fsl_p1010_devtype_data, },
+	{ .compatible = "fsl,vf610-flexcan", .data = &fsl_vf610_devtype_data, },
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, flexcan_of_match);
-- 
2.0.1

