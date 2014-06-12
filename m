Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaFLSIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:08:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:45213 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaFLSIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:08:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,466,1400050800"; 
   d="scan'208";a="556463016"
From: eric.ernst@linux.intel.com
To: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        mark.gross@intel.com, mika.westerberg@linux.intel.com
Cc: eric.ernst@linux.intel.com
Subject: [PATCH v4 1/1] pinctrl: baytrail: Warn if direct IRQ GPIO set to output
Date: Thu, 12 Jun 2014 11:06:20 -0700
Message-Id: <1402596380-18783-1-git-send-email-eric.ernst@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CACRpkdbU-d7Gdji2fJr4h7bC58d63E_CAVeSHZm3ARuut1UFKQ@mail.gmail.com>
References: <CACRpkdbU-d7Gdji2fJr4h7bC58d63E_CAVeSHZm3ARuut1UFKQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Ernst <eric.ernst@linux.intel.com>

For Baytrail, you should never set a GPIO set to direct_irq
to output mode.  When direct_irq_en is set for a GPIO, it is
tied directly to an APIC internally, and making the pad output
does not make any sense. Assert a WARN() in the event this happens.

Signed-off-by: Eric Ernst <eric.ernst@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pinctrl/pinctrl-baytrail.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 975572e2f260..c34add934216 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -303,12 +303,22 @@ static int byt_gpio_direction_output(struct gpio_chip *chip,
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

