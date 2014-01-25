Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaAYSfF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 13:35:05 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:45169 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaAYSeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 13:34:36 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] pinctrl: mvebu: dove: use remapped pmu_mpp registers
Date: Sat, 25 Jan 2014 19:34:15 +0100
Message-Id: <1390674856-4993-11-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have ioremapped pmu_mpp registers, get rid of hardcoded
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
 drivers/pinctrl/mvebu/pinctrl-dove.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 0c7616e086b2..32cb3bbf2e18 100644
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
@@ -60,6 +58,10 @@
 #define  SD1_GPIO_SEL		BIT(1)
 #define  SD0_GPIO_SEL		BIT(0)
 
+/* PMU Signal Select registers */
+#define PMU_SIGNAL_SELECT_0	0x00
+#define PMU_SIGNAL_SELECT_1	0x04
+
 #define MPPS_PER_REG	8
 #define MPP_BITS	4
 #define MPP_MASK	0xf
@@ -80,7 +82,7 @@ static int dove_pmu_mpp_ctrl_get(struct mvebu_mpp_ctrl *ctrl,
 	unsigned long func;
 
 	if (pmu & (1 << ctrl->pid)) {
-		func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
+		func = readl(pmu_base + PMU_SIGNAL_SELECT_0 + off);
 		*config = (func >> shift) & MPP_MASK;
 		*config |= CONFIG_PMU;
 	} else {
@@ -101,10 +103,10 @@ static int dove_pmu_mpp_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
 	if (config & CONFIG_PMU) {
 		writel(pmu | (1 << ctrl->pid),
 		       mpp_base + PMU_MPP_GENERAL_CTRL);
-		func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
+		func = readl(pmu_base + PMU_SIGNAL_SELECT_0 + off);
 		func &= ~(MPP_MASK << shift);
 		func |= (config & MPP_MASK) << shift;
-		writel(func, DOVE_PMU_SIGNAL_SELECT_0 + off);
+		writel(func, pmu_base + PMU_SIGNAL_SELECT_0 + off);
 	} else {
 		writel(pmu & ~(1 << ctrl->pid),
 		       mpp_base + PMU_MPP_GENERAL_CTRL);
-- 
1.8.5.2

