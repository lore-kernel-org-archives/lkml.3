Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaE0T2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:28:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:7848 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbaE0T2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:28:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,921,1392192000"; 
   d="scan'208";a="518548940"
From: eric.ernst@linux.intel.com
To: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        mark.gross@intel.com
Cc: eric.ernst@linux.intel.com
Subject: [PATCH 1/1] PINCTRL: Warn if direct IRQ GPIO set to output
Date: Tue, 27 May 2014 12:26:44 -0700
Message-Id: <1401218804-77997-1-git-send-email-eric.ernst@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Ernst <eric.ernst@linux.intel.com>

For Baytrail, you should never set a GPIO set to direct_irq
to output mode.  When direct_irq_en is set for a GPIO, it is
tied directly to an APIC internally, and making the pad output
does not make any sense. Assert a WARN() in the event this happens.

Signed-off-by: Eric Ernst <eric.ernst@linux.intel.com>
---
 drivers/pinctrl/pinctrl-baytrail.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index e59983423991..677f79a9efca 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -47,6 +47,7 @@
 #define BYT_TRIG_POS		BIT(25)
 #define BYT_TRIG_LVL		BIT(24)
 #define BYT_PIN_MUX		0x07
+#define BYT_DIRECTIRQ		BIT(27)
 
 /* BYT_VAL_REG register bits */
 #define BYT_INPUT_EN		BIT(2)  /* 0: input enabled (active low)*/
@@ -256,19 +257,26 @@ static int byt_gpio_direction_output(struct gpio_chip *chip,
 				     unsigned gpio, int value)
 {
 	struct byt_gpio *vg = to_byt_gpio(chip);
-	void __iomem *reg = byt_gpio_reg(chip, gpio, BYT_VAL_REG);
+	void __iomem *conf_reg = byt_gpio_reg(chip, gpio, BYT_CONF0_REG);
+	void __iomem *value_reg = byt_gpio_reg(chip, gpio, BYT_VAL_REG);
 	unsigned long flags;
 	u32 reg_val;
 
 	spin_lock_irqsave(&vg->lock, flags);
 
-	reg_val = readl(reg) | BYT_DIR_MASK;
+	/* Before making any direction modifications, do a check if gpio
+	is set for direct IRQ.  On baytrail, setting GPIO to output does
+	not make sense, so let's at least warn the caller before they shoot
+	themselves in the foot */
+	WARN((readl(conf_reg) & BYT_DIRECTIRQ), "Potential Error: Setting GPIO with direct_irq_en to output");
+
+	reg_val = readl(value_reg) | BYT_DIR_MASK;
 	reg_val &= ~BYT_OUTPUT_EN;
 
 	if (value)
-		writel(reg_val | BYT_LEVEL, reg);
+		writel(reg_val | BYT_LEVEL, value_reg);
 	else
-		writel(reg_val & ~BYT_LEVEL, reg);
+		writel(reg_val & ~BYT_LEVEL, value_reg);
 
 	spin_unlock_irqrestore(&vg->lock, flags);
 
-- 
1.7.9.5

