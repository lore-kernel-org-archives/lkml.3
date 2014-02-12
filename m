Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaBLQCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:02:43 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:45539 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaBLQAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:00:11 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 06/13] pinctrl: mvebu: dove: provide generic mpp callbacks
Date: Wed, 12 Feb 2014 16:59:29 +0100
Message-Id: <1392220776-30851-7-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to get rid of passing register addresses to common pinctrl
driver, so provide set/get callbacks for generic mpp pins that will
be used later. While at it, also make use of globally defined MPP
macros.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Linus Walleij <linus.walleij@linaro.org> 
Cc: Jason Cooper <jason@lakedaemon.net> 
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 48 +++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index c7d365f9009c..b2e317e30759 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -49,48 +49,68 @@
 #define  DOVE_SD1_GPIO_SEL		BIT(1)
 #define  DOVE_SD0_GPIO_SEL		BIT(0)
 
-#define MPPS_PER_REG	8
-#define MPP_BITS	4
-#define MPP_MASK	0xf
-
 #define CONFIG_PMU	BIT(4)
 
+static void __iomem *mpp_base;
+
+static int dove_mpp_ctrl_get(unsigned pid, unsigned long *config)
+{
+	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+
+	*config = (readl(mpp_base + off) >> shift) & MVEBU_MPP_MASK;
+
+	return 0;
+}
+
+static int dove_mpp_ctrl_set(unsigned pid, unsigned long config)
+{
+	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned long reg;
+
+	reg = readl(mpp_base + off) & ~(MVEBU_MPP_MASK << shift);
+	writel(reg | (config << shift), mpp_base + off);
+
+	return 0;
+}
+
 static int dove_pmu_mpp_ctrl_get(unsigned pid, unsigned long *config)
 {
-	unsigned off = (pid / MPPS_PER_REG) * MPP_BITS;
-	unsigned shift = (pid % MPPS_PER_REG) * MPP_BITS;
+	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
 	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
 	unsigned long func;
 
 	if (pmu & (1 << pid)) {
 		func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
-		*config = (func >> shift) & MPP_MASK;
+		*config = (func >> shift) & MVEBU_MPP_MASK;
 		*config |= CONFIG_PMU;
 	} else {
 		func = readl(DOVE_MPP_VIRT_BASE + off);
-		*config = (func >> shift) & MPP_MASK;
+		*config = (func >> shift) & MVEBU_MPP_MASK;
 	}
 	return 0;
 }
 
 static int dove_pmu_mpp_ctrl_set(unsigned pid, unsigned long config)
 {
-	unsigned off = (pid / MPPS_PER_REG) * MPP_BITS;
-	unsigned shift = (pid % MPPS_PER_REG) * MPP_BITS;
+	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
+	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
 	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
 	unsigned long func;
 
 	if (config & CONFIG_PMU) {
 		writel(pmu | (1 << pid), DOVE_PMU_MPP_GENERAL_CTRL);
 		func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
-		func &= ~(MPP_MASK << shift);
-		func |= (config & MPP_MASK) << shift;
+		func &= ~(MVEBU_MPP_MASK << shift);
+		func |= (config & MVEBU_MPP_MASK) << shift;
 		writel(func, DOVE_PMU_SIGNAL_SELECT_0 + off);
 	} else {
 		writel(pmu & ~(1 << pid), DOVE_PMU_MPP_GENERAL_CTRL);
 		func = readl(DOVE_MPP_VIRT_BASE + off);
-		func &= ~(MPP_MASK << shift);
-		func |= (config & MPP_MASK) << shift;
+		func &= ~(MVEBU_MPP_MASK << shift);
+		func |= (config & MVEBU_MPP_MASK) << shift;
 		writel(func, DOVE_MPP_VIRT_BASE + off);
 	}
 	return 0;
-- 
1.8.5.3

