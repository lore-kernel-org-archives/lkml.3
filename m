Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaA1Aq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:46:56 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:64238 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbaA1AqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:46:20 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 17/21] pinctrl: mvebu: dove: use remapped mpp base registers
Date: Tue, 28 Jan 2014 01:39:29 +0100
Message-Id: <1390869573-27624-18-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
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
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 74a50a3d6729..43e037cf6db0 100644
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
@@ -97,7 +98,7 @@ static int dove_pmu_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 {
 	unsigned off = (ctrl->pid / MPPS_PER_REG) * MPP_BITS;
 	unsigned shift = (ctrl->pid % MPPS_PER_REG) * MPP_BITS;
-	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
+	unsigned long pmu = readl(mpp_base + PMU_MPP_GENERAL_CTRL);
 	unsigned long func;
 
 	if (pmu & (1 << ctrl->pid)) {
@@ -105,7 +106,7 @@ static int dove_pmu_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 		*config = (func >> shift) & MPP_MASK;
 		*config |= CONFIG_PMU;
 	} else {
-		func = readl(DOVE_MPP_VIRT_BASE + off);
+		func = readl(mpp_base + off);
 		*config = (func >> shift) & MPP_MASK;
 	}
 	return 0;
@@ -116,21 +117,23 @@ static int dove_pmu_mpp_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
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
@@ -228,9 +231,9 @@ static int dove_nand_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 static int dove_audio0_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 				unsigned long *config)
 {
-	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
+	unsigned long pmu = readl(mpp_base + PMU_MPP_GENERAL_CTRL);
 
-	*config = ((pmu & DOVE_AU0_AC97_SEL) != 0);
+	*config = ((pmu & AU0_AC97_SEL) != 0);
 
 	return 0;
 }
@@ -238,12 +241,12 @@ static int dove_audio0_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
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

