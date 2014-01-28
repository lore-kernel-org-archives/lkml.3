Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbaA1A4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:56:20 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:56783 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbaA1A4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:56:16 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 18/21] pinctrl: mvebu: dove: use remapped mpp4 register
Date: Tue, 28 Jan 2014 01:39:30 +0100
Message-Id: <1390869573-27624-19-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have an ioremapped mpp4 register, get rid of hardcoded
physical addresses. While at it, also remove DOVE_ prefix from those
macros.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 54 +++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 43e037cf6db0..1487bd270401 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -46,18 +46,20 @@
 #define  DOVE_AU1_SPDIFO_GPIO_EN	BIT(1)
 #define  DOVE_NAND_GPIO_EN		BIT(0)
 #define DOVE_GPIO_LO_VIRT_BASE		(DOVE_SB_REGS_VIRT_BASE + 0xd0400)
-#define DOVE_MPP_CTRL4_VIRT_BASE	(DOVE_GPIO_LO_VIRT_BASE + 0x40)
-#define  DOVE_SPI_GPIO_SEL		BIT(5)
-#define  DOVE_UART1_GPIO_SEL		BIT(4)
-#define  DOVE_AU1_GPIO_SEL		BIT(3)
-#define  DOVE_CAM_GPIO_SEL		BIT(2)
-#define  DOVE_SD1_GPIO_SEL		BIT(1)
-#define  DOVE_SD0_GPIO_SEL		BIT(0)
 
 /* MPP Base registers */
 #define PMU_MPP_GENERAL_CTRL	0x10
 #define  AU0_AC97_SEL		BIT(16)
 
+/* MPP Control 4 register */
+#define MPP_CTRL4		0x40
+#define  SPI_GPIO_SEL		BIT(5)
+#define  UART1_GPIO_SEL		BIT(4)
+#define  AU1_GPIO_SEL		BIT(3)
+#define  CAM_GPIO_SEL		BIT(2)
+#define  SD1_GPIO_SEL		BIT(1)
+#define  SD0_GPIO_SEL		BIT(0)
+
 #define MPPS_PER_REG	8
 #define MPP_BITS	4
 #define MPP_MASK	0xf
@@ -141,24 +143,24 @@ static int dove_pmu_mpp_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 static int dove_mpp4_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 			      unsigned long *config)
 {
-	unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
+	unsigned long mpp4 = readl(mpp4_base + MPP_CTRL4);
 	unsigned long mask;
 
 	switch (ctrl->pid) {
 	case 24: /* mpp_camera */
-		mask = DOVE_CAM_GPIO_SEL;
+		mask = CAM_GPIO_SEL;
 		break;
 	case 40: /* mpp_sdio0 */
-		mask = DOVE_SD0_GPIO_SEL;
+		mask = SD0_GPIO_SEL;
 		break;
 	case 46: /* mpp_sdio1 */
-		mask = DOVE_SD1_GPIO_SEL;
+		mask = SD1_GPIO_SEL;
 		break;
 	case 58: /* mpp_spi0 */
-		mask = DOVE_SPI_GPIO_SEL;
+		mask = SPI_GPIO_SEL;
 		break;
 	case 62: /* mpp_uart1 */
-		mask = DOVE_UART1_GPIO_SEL;
+		mask = UART1_GPIO_SEL;
 		break;
 	default:
 		return -EINVAL;
@@ -172,24 +174,24 @@ static int dove_mpp4_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 static int dove_mpp4_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 			      unsigned long config)
 {
-	unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
+	unsigned long mpp4 = readl(mpp4_base + MPP_CTRL4);
 	unsigned long mask;
 
 	switch (ctrl->pid) {
 	case 24: /* mpp_camera */
-		mask = DOVE_CAM_GPIO_SEL;
+		mask = CAM_GPIO_SEL;
 		break;
 	case 40: /* mpp_sdio0 */
-		mask = DOVE_SD0_GPIO_SEL;
+		mask = SD0_GPIO_SEL;
 		break;
 	case 46: /* mpp_sdio1 */
-		mask = DOVE_SD1_GPIO_SEL;
+		mask = SD1_GPIO_SEL;
 		break;
 	case 58: /* mpp_spi0 */
-		mask = DOVE_SPI_GPIO_SEL;
+		mask = SPI_GPIO_SEL;
 		break;
 	case 62: /* mpp_uart1 */
-		mask = DOVE_UART1_GPIO_SEL;
+		mask = UART1_GPIO_SEL;
 		break;
 	default:
 		return -EINVAL;
@@ -199,7 +201,7 @@ static int dove_mpp4_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 	if (config)
 		mpp4 |= mask;
 
-	writel(mpp4, DOVE_MPP_CTRL4_VIRT_BASE);
+	writel(mpp4, mpp4_base + MPP_CTRL4);
 
 	return 0;
 }
@@ -254,13 +256,13 @@ static int dove_audio0_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 static int dove_audio1_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 				unsigned long *config)
 {
-	unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
+	unsigned long mpp4 = readl(mpp4_base + MPP_CTRL4);
 	unsigned long sspc1 = readl(DOVE_SSP_CTRL_STATUS_1);
 	unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
 	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
 
 	*config = 0;
-	if (mpp4 & DOVE_AU1_GPIO_SEL)
+	if (mpp4 & AU1_GPIO_SEL)
 		*config |= BIT(3);
 	if (sspc1 & DOVE_SSP_ON_AU1)
 		*config |= BIT(2);
@@ -281,7 +283,7 @@ static int dove_audio1_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 static int dove_audio1_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 				unsigned long config)
 {
-	unsigned long mpp4 = readl(DOVE_MPP_CTRL4_VIRT_BASE);
+	unsigned long mpp4 = readl(mpp4_base + MPP_CTRL4);
 	unsigned long sspc1 = readl(DOVE_SSP_CTRL_STATUS_1);
 	unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
 	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
@@ -292,7 +294,7 @@ static int dove_audio1_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 	gcfg2 &= ~DOVE_TWSI_OPTION3_GPIO;
 	gmpp &= ~DOVE_AU1_SPDIFO_GPIO_EN;
 	sspc1 &= ~DOVE_SSP_ON_AU1;
-	mpp4 &= ~DOVE_AU1_GPIO_SEL;
+	mpp4 &= ~AU1_GPIO_SEL;
 
 	if (config & BIT(0))
 		gcfg2 |= DOVE_TWSI_OPTION3_GPIO;
@@ -301,9 +303,9 @@ static int dove_audio1_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 	if (config & BIT(2))
 		sspc1 |= DOVE_SSP_ON_AU1;
 	if (config & BIT(3))
-		mpp4 |= DOVE_AU1_GPIO_SEL;
+		mpp4 |= AU1_GPIO_SEL;
 
-	writel(mpp4, DOVE_MPP_CTRL4_VIRT_BASE);
+	writel(mpp4, mpp4_base + MPP_CTRL4);
 	writel(sspc1, DOVE_SSP_CTRL_STATUS_1);
 	writel(gmpp, DOVE_MPP_GENERAL_VIRT_BASE);
 	writel(gcfg2, DOVE_GLOBAL_CONFIG_2);
-- 
1.8.5.2

