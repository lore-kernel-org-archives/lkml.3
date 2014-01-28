Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaA1Ar3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:47:29 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:36542 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbaA1AqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:46:16 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 19/21] pinctrl: mvebu: dove: use remapped pmu_mpp registers
Date: Tue, 28 Jan 2014 01:39:31 +0100
Message-Id: <1390869573-27624-20-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have ioremapped pmu_mpp registers, get rid of hardcoded
physical addresses. While at it, also remove DOVE_ prefix from those
macros. Also use common defines for MPP shift and masks and reuse
generic get/set callbacks from pmu specific get/set.

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
 drivers/pinctrl/mvebu/pinctrl-dove.c | 59 +++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 31 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 1487bd270401..9126cedec1bc 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -31,8 +31,6 @@
 #define GC_REGS_OFFS			0xe802c
 
 #define DOVE_SB_REGS_VIRT_BASE		IOMEM(0xfde00000)
-#define DOVE_PMU_SIGNAL_SELECT_0	(DOVE_SB_REGS_VIRT_BASE + 0xd802C)
-#define DOVE_PMU_SIGNAL_SELECT_1	(DOVE_SB_REGS_VIRT_BASE + 0xd8030)
 #define DOVE_GLOBAL_CONFIG_1		(DOVE_SB_REGS_VIRT_BASE + 0xe802C)
 #define DOVE_GLOBAL_CONFIG_1		(DOVE_SB_REGS_VIRT_BASE + 0xe802C)
 #define  DOVE_TWSI_ENABLE_OPTION1	BIT(7)
@@ -60,9 +58,9 @@
 #define  SD1_GPIO_SEL		BIT(1)
 #define  SD0_GPIO_SEL		BIT(0)
 
-#define MPPS_PER_REG	8
-#define MPP_BITS	4
-#define MPP_MASK	0xf
+/* PMU Signal Select registers */
+#define PMU_SIGNAL_SELECT_0	0x00
+#define PMU_SIGNAL_SELECT_1	0x04
 
 #define CONFIG_PMU	BIT(4)
 
@@ -98,46 +96,45 @@ static int dove_mpp_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 static int dove_pmu_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 				 unsigned long *config)
 {
-	unsigned off = (ctrl->pid / MPPS_PER_REG) * MPP_BITS;
-	unsigned shift = (ctrl->pid % MPPS_PER_REG) * MPP_BITS;
+	unsigned off = (ctrl->pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (ctrl->pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
 	unsigned long pmu = readl(mpp_base + PMU_MPP_GENERAL_CTRL);
-	unsigned long func;
 
 	if (pmu & (1 << ctrl->pid)) {
-		func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
-		*config = (func >> shift) & MPP_MASK;
+		unsigned long func =
+			readl(pmu_base + PMU_SIGNAL_SELECT_0 + off);
+		*config = (func >> shift) & MVEBU_MPP_MASK;
 		*config |= CONFIG_PMU;
-	} else {
-		func = readl(mpp_base + off);
-		*config = (func >> shift) & MPP_MASK;
+
+		return 0;
 	}
-	return 0;
+
+	return dove_mpp_ctrl_get(ctrl, config);
 }
 
 static int dove_pmu_mpp_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 				 unsigned long config)
 {
-	unsigned off = (ctrl->pid / MPPS_PER_REG) * MPP_BITS;
-	unsigned shift = (ctrl->pid % MPPS_PER_REG) * MPP_BITS;
+	unsigned off = (ctrl->pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (ctrl->pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
 	unsigned long pmu = readl(mpp_base + PMU_MPP_GENERAL_CTRL);
-	unsigned long func;
+
+	if (config & CONFIG_PMU)
+		pmu |= (1 << ctrl->pid);
+	else
+		pmu &= ~(1 << ctrl->pid);
 
 	if (config & CONFIG_PMU) {
-		writel(pmu | (1 << ctrl->pid),
-		       mpp_base + PMU_MPP_GENERAL_CTRL);
-		func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
-		func &= ~(MPP_MASK << shift);
-		func |= (config & MPP_MASK) << shift;
-		writel(func, DOVE_PMU_SIGNAL_SELECT_0 + off);
-	} else {
-		writel(pmu & ~(1 << ctrl->pid),
-		       mpp_base + PMU_MPP_GENERAL_CTRL);
-		func = readl(mpp_base + off);
-		func &= ~(MPP_MASK << shift);
-		func |= (config & MPP_MASK) << shift;
-		writel(func, mpp_base + off);
+		unsigned long func =
+			readl(pmu_base + PMU_SIGNAL_SELECT_0 + off);
+		func &= ~(MVEBU_MPP_MASK << shift);
+		func |= (config & MVEBU_MPP_MASK) << shift;
+		writel(func, pmu_base + PMU_SIGNAL_SELECT_0 + off);
+
+		return 0;
 	}
-	return 0;
+
+	return dove_mpp_ctrl_set(ctrl, config);
 }
 
 static int dove_mpp4_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
-- 
1.8.5.2

