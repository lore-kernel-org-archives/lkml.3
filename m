Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaBXInc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:43:32 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:37671 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbaBXInW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:43:22 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] pinctrl: mvebu: dove: use global register regmap
Date: Mon, 24 Feb 2014 09:43:02 +0100
Message-Id: <1393231382-11078-11-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have a regmap for global registers, get rid of the last
remaining hardcoded physical addresses. While at it, also remove
DOVE_ prefix from those macros.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 124 ++++++++++++++++-------------------
 1 file changed, 58 insertions(+), 66 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index b1a2e5b828c1..9e7ff651c018 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -30,21 +30,6 @@
 #define PMU_REGS_OFFS		0xd802c
 #define GC_REGS_OFFS		0xe802c
 
-#define DOVE_SB_REGS_VIRT_BASE		IOMEM(0xfde00000)
-#define DOVE_GLOBAL_CONFIG_1		(DOVE_SB_REGS_VIRT_BASE + 0xe802C)
-#define DOVE_GLOBAL_CONFIG_1		(DOVE_SB_REGS_VIRT_BASE + 0xe802C)
-#define  DOVE_TWSI_ENABLE_OPTION1	BIT(7)
-#define DOVE_GLOBAL_CONFIG_2		(DOVE_SB_REGS_VIRT_BASE + 0xe8030)
-#define  DOVE_TWSI_ENABLE_OPTION2	BIT(20)
-#define  DOVE_TWSI_ENABLE_OPTION3	BIT(21)
-#define  DOVE_TWSI_OPTION3_GPIO		BIT(22)
-#define DOVE_SSP_CTRL_STATUS_1		(DOVE_SB_REGS_VIRT_BASE + 0xe8034)
-#define  DOVE_SSP_ON_AU1		BIT(0)
-#define DOVE_MPP_GENERAL_VIRT_BASE	(DOVE_SB_REGS_VIRT_BASE + 0xe803c)
-#define  DOVE_AU1_SPDIFO_GPIO_EN	BIT(1)
-#define  DOVE_NAND_GPIO_EN		BIT(0)
-#define DOVE_GPIO_LO_VIRT_BASE		(DOVE_SB_REGS_VIRT_BASE + 0xd0400)
-
 /* MPP Base registers */
 #define PMU_MPP_GENERAL_CTRL	0x10
 #define  AU0_AC97_SEL		BIT(16)
@@ -61,6 +46,19 @@
 #define PMU_SIGNAL_SELECT_0	0x00
 #define PMU_SIGNAL_SELECT_1	0x04
 
+/* Global Config regmap registers */
+#define GLOBAL_CONFIG_1		0x00
+#define  TWSI_ENABLE_OPTION1	BIT(7)
+#define GLOBAL_CONFIG_2		0x04
+#define  TWSI_ENABLE_OPTION2	BIT(20)
+#define  TWSI_ENABLE_OPTION3	BIT(21)
+#define  TWSI_OPTION3_GPIO	BIT(22)
+#define SSP_CTRL_STATUS_1	0x08
+#define  SSP_ON_AU1		BIT(0)
+#define MPP_GENERAL_CONFIG	0x10
+#define  AU1_SPDIFO_GPIO_EN	BIT(1)
+#define  NAND_GPIO_EN		BIT(0)
+
 #define CONFIG_PMU	BIT(4)
 
 static void __iomem *mpp_base;
@@ -182,23 +180,19 @@ static int dove_mpp4_ctrl_set(unsigned pid, unsigned long config)
 
 static int dove_nand_ctrl_get(unsigned pid, unsigned long *config)
 {
-	unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
+	unsigned int gmpp;
 
-	*config = ((gmpp & DOVE_NAND_GPIO_EN) != 0);
+	regmap_read(gconfmap, MPP_GENERAL_CONFIG, &gmpp);
+	*config = ((gmpp & NAND_GPIO_EN) != 0);
 
 	return 0;
 }
 
 static int dove_nand_ctrl_set(unsigned pid, unsigned long config)
 {
-	unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
-
-	gmpp &= ~DOVE_NAND_GPIO_EN;
-	if (config)
-		gmpp |= DOVE_NAND_GPIO_EN;
-
-	writel(gmpp, DOVE_MPP_GENERAL_VIRT_BASE);
-
+	regmap_update_bits(gconfmap, MPP_GENERAL_CONFIG,
+			   NAND_GPIO_EN,
+			   (config) ? NAND_GPIO_EN : 0);
 	return 0;
 }
 
@@ -226,18 +220,22 @@ static int dove_audio0_ctrl_set(unsigned pid, unsigned long config)
 static int dove_audio1_ctrl_get(unsigned pid, unsigned long *config)
 {
 	unsigned int mpp4 = readl(mpp4_base);
-	unsigned long sspc1 = readl(DOVE_SSP_CTRL_STATUS_1);
-	unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
-	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
+	unsigned int sspc1;
+	unsigned int gmpp;
+	unsigned int gcfg2;
+
+	regmap_read(gconfmap, SSP_CTRL_STATUS_1, &sspc1);
+	regmap_read(gconfmap, MPP_GENERAL_CONFIG, &gmpp);
+	regmap_read(gconfmap, GLOBAL_CONFIG_2, &gcfg2);
 
 	*config = 0;
 	if (mpp4 & AU1_GPIO_SEL)
 		*config |= BIT(3);
-	if (sspc1 & DOVE_SSP_ON_AU1)
+	if (sspc1 & SSP_ON_AU1)
 		*config |= BIT(2);
-	if (gmpp & DOVE_AU1_SPDIFO_GPIO_EN)
+	if (gmpp & AU1_SPDIFO_GPIO_EN)
 		*config |= BIT(1);
-	if (gcfg2 & DOVE_TWSI_OPTION3_GPIO)
+	if (gcfg2 & TWSI_OPTION3_GPIO)
 		*config |= BIT(0);
 
 	/* SSP/TWSI only if I2S1 not set*/
@@ -252,31 +250,21 @@ static int dove_audio1_ctrl_get(unsigned pid, unsigned long *config)
 static int dove_audio1_ctrl_set(unsigned pid, unsigned long config)
 {
 	unsigned int mpp4 = readl(mpp4_base);
-	unsigned long sspc1 = readl(DOVE_SSP_CTRL_STATUS_1);
-	unsigned long gmpp = readl(DOVE_MPP_GENERAL_VIRT_BASE);
-	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
 
-	/*
-	 * clear all audio1 related bits before configure
-	 */
-	gcfg2 &= ~DOVE_TWSI_OPTION3_GPIO;
-	gmpp &= ~DOVE_AU1_SPDIFO_GPIO_EN;
-	sspc1 &= ~DOVE_SSP_ON_AU1;
 	mpp4 &= ~AU1_GPIO_SEL;
-
-	if (config & BIT(0))
-		gcfg2 |= DOVE_TWSI_OPTION3_GPIO;
-	if (config & BIT(1))
-		gmpp |= DOVE_AU1_SPDIFO_GPIO_EN;
-	if (config & BIT(2))
-		sspc1 |= DOVE_SSP_ON_AU1;
 	if (config & BIT(3))
 		mpp4 |= AU1_GPIO_SEL;
-
 	writel(mpp4, mpp4_base);
-	writel(sspc1, DOVE_SSP_CTRL_STATUS_1);
-	writel(gmpp, DOVE_MPP_GENERAL_VIRT_BASE);
-	writel(gcfg2, DOVE_GLOBAL_CONFIG_2);
+
+	regmap_update_bits(gconfmap, SSP_CTRL_STATUS_1,
+			   SSP_ON_AU1,
+			   (config & BIT(2)) ? SSP_ON_AU1 : 0);
+	regmap_update_bits(gconfmap, MPP_GENERAL_CONFIG,
+			   AU1_SPDIFO_GPIO_EN,
+			   (config & BIT(1)) ? AU1_SPDIFO_GPIO_EN : 0);
+	regmap_update_bits(gconfmap, GLOBAL_CONFIG_2,
+			   TWSI_OPTION3_GPIO,
+			   (config & BIT(0)) ? TWSI_OPTION3_GPIO : 0);
 
 	return 0;
 }
@@ -322,15 +310,18 @@ static int dove_audio1_ctrl_gpio_dir(unsigned pid, bool input)
 
 static int dove_twsi_ctrl_get(unsigned pid, unsigned long *config)
 {
-	unsigned long gcfg1 = readl(DOVE_GLOBAL_CONFIG_1);
-	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
+	unsigned int gcfg1;
+	unsigned int gcfg2;
+
+	regmap_read(gconfmap, GLOBAL_CONFIG_1, &gcfg1);
+	regmap_read(gconfmap, GLOBAL_CONFIG_2, &gcfg2);
 
 	*config = 0;
-	if (gcfg1 & DOVE_TWSI_ENABLE_OPTION1)
+	if (gcfg1 & TWSI_ENABLE_OPTION1)
 		*config = 1;
-	else if (gcfg2 & DOVE_TWSI_ENABLE_OPTION2)
+	else if (gcfg2 & TWSI_ENABLE_OPTION2)
 		*config = 2;
-	else if (gcfg2 & DOVE_TWSI_ENABLE_OPTION3)
+	else if (gcfg2 & TWSI_ENABLE_OPTION3)
 		*config = 3;
 
 	return 0;
@@ -338,26 +329,27 @@ static int dove_twsi_ctrl_get(unsigned pid, unsigned long *config)
 
 static int dove_twsi_ctrl_set(unsigned pid, unsigned long config)
 {
-	unsigned long gcfg1 = readl(DOVE_GLOBAL_CONFIG_1);
-	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
-
-	gcfg1 &= ~DOVE_TWSI_ENABLE_OPTION1;
-	gcfg2 &= ~(DOVE_TWSI_ENABLE_OPTION2 | DOVE_TWSI_ENABLE_OPTION3);
+	unsigned int gcfg1 = 0;
+	unsigned int gcfg2 = 0;
 
 	switch (config) {
 	case 1:
-		gcfg1 |= DOVE_TWSI_ENABLE_OPTION1;
+		gcfg1 = TWSI_ENABLE_OPTION1;
 		break;
 	case 2:
-		gcfg2 |= DOVE_TWSI_ENABLE_OPTION2;
+		gcfg2 = TWSI_ENABLE_OPTION2;
 		break;
 	case 3:
-		gcfg2 |= DOVE_TWSI_ENABLE_OPTION3;
+		gcfg2 = TWSI_ENABLE_OPTION3;
 		break;
 	}
 
-	writel(gcfg1, DOVE_GLOBAL_CONFIG_1);
-	writel(gcfg2, DOVE_GLOBAL_CONFIG_2);
+	regmap_update_bits(gconfmap, GLOBAL_CONFIG_1,
+			   TWSI_ENABLE_OPTION1,
+			   gcfg1);
+	regmap_update_bits(gconfmap, GLOBAL_CONFIG_2,
+			   TWSI_ENABLE_OPTION2 | TWSI_ENABLE_OPTION3,
+			   gcfg2);
 
 	return 0;
 }
-- 
1.8.5.3

