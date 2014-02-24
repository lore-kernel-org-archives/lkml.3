Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaBXIrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:47:12 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:56809 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaBXInP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:43:15 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] pinctrl: mvebu: dove: use remapped pmu_mpp registers
Date: Mon, 24 Feb 2014 09:43:01 +0100
Message-Id: <1393231382-11078-10-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have ioremapped pmu_mpp registers, get rid of hardcoded
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
 drivers/pinctrl/mvebu/pinctrl-dove.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index d48db53957e0..b1a2e5b828c1 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -31,8 +31,6 @@
 #define GC_REGS_OFFS		0xe802c
 
 #define DOVE_SB_REGS_VIRT_BASE		IOMEM(0xfde00000)
-#define DOVE_PMU_SIGNAL_SELECT_0	(DOVE_SB_REGS_VIRT_BASE + 0xd802C)
-#define DOVE_PMU_SIGNAL_SELECT_1	(DOVE_SB_REGS_VIRT_BASE + 0xd8030)
 #define DOVE_GLOBAL_CONFIG_1		(DOVE_SB_REGS_VIRT_BASE + 0xe802C)
 #define DOVE_GLOBAL_CONFIG_1		(DOVE_SB_REGS_VIRT_BASE + 0xe802C)
 #define  DOVE_TWSI_ENABLE_OPTION1	BIT(7)
@@ -59,6 +57,10 @@
 #define SD1_GPIO_SEL		BIT(1)
 #define SD0_GPIO_SEL		BIT(0)
 
+/* PMU Signal Select registers */
+#define PMU_SIGNAL_SELECT_0	0x00
+#define PMU_SIGNAL_SELECT_1	0x04
+
 #define CONFIG_PMU	BIT(4)
 
 static void __iomem *mpp_base;
@@ -86,7 +88,7 @@ static int dove_pmu_mpp_ctrl_get(unsigned pid, unsigned long *config)
 	if ((pmu & BIT(pid)) == 0)
 		return default_mpp_ctrl_get(mpp_base, pid, config);
 
-	func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
+	func = readl(pmu_base + PMU_SIGNAL_SELECT_0 + off);
 	*config = (func >> shift) & MVEBU_MPP_MASK;
 	*config |= CONFIG_PMU;
 
@@ -106,10 +108,10 @@ static int dove_pmu_mpp_ctrl_set(unsigned pid, unsigned long config)
 	}
 
 	writel(pmu | BIT(pid), mpp_base + PMU_MPP_GENERAL_CTRL);
-	func = readl(DOVE_PMU_SIGNAL_SELECT_0 + off);
+	func = readl(pmu_base + PMU_SIGNAL_SELECT_0 + off);
 	func &= ~(MVEBU_MPP_MASK << shift);
 	func |= (config & MVEBU_MPP_MASK) << shift;
-	writel(func, DOVE_PMU_SIGNAL_SELECT_0 + off);
+	writel(func, pmu_base + PMU_SIGNAL_SELECT_0 + off);
 
 	return 0;
 }
-- 
1.8.5.3

