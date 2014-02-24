Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaBXIrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:47:11 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:51582 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaBXInQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:43:16 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/10] pinctrl: mvebu: dove: use remapped mpp base registers
Date: Mon, 24 Feb 2014 09:42:59 +0100
Message-Id: <1393231382-11078-8-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have ioremapped mpp base registers, get rid of hardcoded
physical addresses. While at it, also remove DOVE_ prefix from those
macros.

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
 drivers/pinctrl/mvebu/pinctrl-dove.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index e4f954a78b15..902c18f11b94 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -31,9 +31,6 @@
 #define GC_REGS_OFFS		0xe802c
 
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
 #define CONFIG_PMU	BIT(4)
 
 static void __iomem *mpp_base;
@@ -78,7 +79,7 @@ static int dove_pmu_mpp_ctrl_get(unsigned pid, unsigned long *config)
 {
 	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
 	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
-	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
+	unsigned long pmu = readl(mpp_base + PMU_MPP_GENERAL_CTRL);
 	unsigned long func;
 
 	if ((pmu & BIT(pid)) == 0)
@@ -95,15 +96,15 @@ static int dove_pmu_mpp_ctrl_set(unsigned pid, unsigned long config)
 {
 	unsigned off = (pid / MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
 	unsigned shift = (pid % MVEBU_MPPS_PER_REG) * MVEBU_MPP_BITS;
-	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
+	unsigned long pmu = readl(mpp_base + PMU_MPP_GENERAL_CTRL);
 	unsigned long func;
 
 	if ((config & CONFIG_PMU) == 0) {
-		writel(pmu & ~BIT(pid), DOVE_PMU_MPP_GENERAL_CTRL);
+		writel(pmu & ~BIT(pid), mpp_base + PMU_MPP_GENERAL_CTRL);
 		return default_mpp_ctrl_set(mpp_base, pid, config);
 	}
 
-	writel(pmu | BIT(pid), DOVE_PMU_MPP_GENERAL_CTRL);
+	writel(pmu | BIT(pid), mpp_base + PMU_MPP_GENERAL_CTRL);
 	func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
 	func &= ~(MVEBU_MPP_MASK << shift);
 	func |= (config & MVEBU_MPP_MASK) << shift;
@@ -200,21 +201,21 @@ static int dove_nand_ctrl_set(unsigned pid, unsigned long config)
 
 static int dove_audio0_ctrl_get(unsigned pid, unsigned long *config)
 {
-	unsigned long pmu = readl(DOVE_PMU_MPP_GENERAL_CTRL);
+	unsigned long pmu = readl(mpp_base + PMU_MPP_GENERAL_CTRL);
 
-	*config = ((pmu & DOVE_AU0_AC97_SEL) != 0);
+	*config = ((pmu & AU0_AC97_SEL) != 0);
 
 	return 0;
 }
 
 static int dove_audio0_ctrl_set(unsigned pid, unsigned long config)
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
1.8.5.3

