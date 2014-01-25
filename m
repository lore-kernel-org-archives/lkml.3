Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaAYSfq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 13:35:46 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:37433 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaAYSef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 13:34:35 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] pinctrl: mvebu: dove: use remapped mpp base registers
Date: Sat, 25 Jan 2014 19:34:13 +0100
Message-Id: <1390674856-4993-9-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have ioremapped mpp base registers, get rid of hardcoded
physical addresses. While at it, also remove DOVE_ prefix from those
macros.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index d2ad130ba21e..79106e7ecdd0 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -31,9 +31,6 @@
 #define GC_REGS_OFFS			0xe802c
 
 #define DOVE_SB_REGS_VIRT_BASE		IOMEM(0xfde00000)
-#define DOVE_MPP_VIRT_BASE		(DOVE_SB_REGS_VIRT_BASE + 0xd0200)
-#define DOVE_PMU_MPP_GENERAL_CTRL	(DOVE_MPP_VIRT_BASE + 0x10)
-#define  DOVE_AU0_AC97_SEL		BIT(16)
 #define DOVE_PMU_SIGNAL_SELECT_0	(DOVE_SB_REGS_VIRT_BASE + 0xd802C)
 #define DOVE_PMU_SIGNAL_SELECT_1	(DOVE_SB_REGS_VIRT_BASE + 0xd8030)
 #define DOVE_GLOBAL_CONFIG_1		(DOVE_SB_REGS_VIRT_BASE + 0xe802C)
@@ -57,6 +54,10 @@
 #define  DOVE_SD1_GPIO_SEL		BIT(1)
 #define  DOVE_SD0_GPIO_SEL		BIT(0)
 
+/* MPP Base registers */
+#define PMU_MPP_GENERAL_CTRL	0x10
+#define  AU0_AC97_SEL		BIT(16)
+
 #define MPPS_PER_REG	8
 #define MPP_BITS	4
 #define MPP_MASK	0xf
@@ -73,7 +74,7 @@ static int dove_pmu_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 {
 	unsigned off = (ctrl->pid / MPPS_PER_REG) * MPP_BITS;
 	unsigned shift = (ctrl->pid % MPPS_PER_REG) * MPP_BITS;
-	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
+	unsigned long pmu = readl(mpp_base + PMU_MPP_GENERAL_CTRL);
 	unsigned long func;
 
 	if (pmu & (1 << ctrl->pid)) {
@@ -81,7 +82,7 @@ static int dove_pmu_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 		*config = (func >> shift) & MPP_MASK;
 		*config |= CONFIG_PMU;
 	} else {
-		func = readl(DOVE_MPP_VIRT_BASE + off);
+		func = readl(mpp_base + off);
 		*config = (func >> shift) & MPP_MASK;
 	}
 	return 0;
@@ -92,21 +93,23 @@ static int dove_pmu_mpp_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 {
 	unsigned off = (ctrl->pid / MPPS_PER_REG) * MPP_BITS;
 	unsigned shift = (ctrl->pid % MPPS_PER_REG) * MPP_BITS;
-	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
+	unsigned long pmu = readl(mpp_base + PMU_MPP_GENERAL_CTRL);
 	unsigned long func;
 
 	if (config & CONFIG_PMU) {
-		writel(pmu | (1 << ctrl->pid), DOVE_PMU_MPP_GENERAL_CTRL);
+		writel(pmu | (1 << ctrl->pid),
+		       mpp_base + PMU_MPP_GENERAL_CTRL);
 		func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
 		func &= ~(MPP_MASK << shift);
 		func |= (config & MPP_MASK) << shift;
 		writel(func, DOVE_PMU_SIGNAL_SELECT_0 + off);
 	} else {
-		writel(pmu & ~(1 << ctrl->pid), DOVE_PMU_MPP_GENERAL_CTRL);
-		func = readl(DOVE_MPP_VIRT_BASE + off);
+		writel(pmu & ~(1 << ctrl->pid),
+		       mpp_base + PMU_MPP_GENERAL_CTRL);
+		func = readl(mpp_base + off);
 		func &= ~(MPP_MASK << shift);
 		func |= (config & MPP_MASK) << shift;
-		writel(func, DOVE_MPP_VIRT_BASE + off);
+		writel(func, mpp_base + off);
 	}
 	return 0;
 }
@@ -204,9 +207,9 @@ static int dove_nand_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 static int dove_audio0_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 				unsigned long *config)
 {
-	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
+	unsigned long pmu = readl(mpp_base + PMU_MPP_GENERAL_CTRL);
 
-	*config = ((pmu & DOVE_AU0_AC97_SEL) != 0);
+	*config = ((pmu & AU0_AC97_SEL) != 0);
 
 	return 0;
 }
@@ -214,12 +217,12 @@ static int dove_audio0_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 static int dove_audio0_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 				unsigned long config)
 {
-	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
+	unsigned long pmu = readl(mpp_base + PMU_MPP_GENERAL_CTRL);
 
-	pmu &= ~DOVE_AU0_AC97_SEL;
+	pmu &= ~AU0_AC97_SEL;
 	if (config)
-		pmu |= DOVE_AU0_AC97_SEL;
-	writel(pmu, DOVE_PMU_MPP_GENERAL_CTRL);
+		pmu |= AU0_AC97_SEL;
+	writel(pmu, mpp_base + PMU_MPP_GENERAL_CTRL);
 
 	return 0;
 }
-- 
1.8.5.2

