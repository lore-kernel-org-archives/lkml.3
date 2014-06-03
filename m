Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965098AbaFCW1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:27:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:61615 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbaFCW1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:27:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,969,1392192000"; 
   d="scan'208";a="551121219"
From: eric.ernst@linux.intel.com
To: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        mark.gross@intel.com, mika.westerberg@linux.intel.com
Cc: eric.ernst@linux.intel.com
Subject: [PATCH v3 1/1] pinctrl: baytrail: Warn if direct IRQ GPIO set to output
Date: Tue,  3 Jun 2014 15:25:16 -0700
Message-Id: <1401834316-199359-1-git-send-email-eric.ernst@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20140603110600.GG1730@lahna.fi.intel.com>
References: <20140603110600.GG1730@lahna.fi.intel.com>
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
 drivers/pinctrl/pinctrl-baytrail.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index e59983423991..7f0a2bac7c82 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -43,6 +43,7 @@
 #define BYT_INT_STAT_REG	0x800
 
 /* BYT_CONF0_REG register bits */
+#define BYT_DIRECT_IRQ_EN	BIT(27)
 #define BYT_TRIG_NEG		BIT(26)
 #define BYT_TRIG_POS		BIT(25)
 #define BYT_TRIG_LVL		BIT(24)
@@ -256,12 +257,22 @@ static int byt_gpio_direction_output(struct gpio_chip *chip,
 				     unsigned gpio, int value)
 {
 	struct byt_gpio *vg = to_byt_gpio(chip);
+	void __iomem *conf_reg = byt_gpio_reg(chip, gpio, BYT_CONF0_REG);
 	void __iomem *reg = byt_gpio_reg(chip, gpio, BYT_VAL_REG);
 	unsigned long flags;
 	u32 reg_val;
 
 	spin_lock_irqsave(&vg->lock, flags);
 
+	/*
+	 * Before making any direction modifications, do a check if gpio
+	 * is set for direct IRQ.  On baytrail, setting GPIO to output does
+	 * not make sense, so let's at least warn the caller before they shoot
+	 * themselves in the foot.
+	 */
+	WARN(readl(conf_reg) & BYT_DIRECT_IRQ_EN,
+		"Potential Error: Setting GPIO with direct_irq_en to output");
+
 	reg_val = readl(reg) | BYT_DIR_MASK;
 	reg_val &= ~BYT_OUTPUT_EN;
 
-- 
1.7.9.5

