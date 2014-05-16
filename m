Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbaEPJSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:18:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:34487 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286AbaEPJSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:18:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1066,1389772800"; 
   d="scan'208";a="532952151"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sundar Iyer <sundar.iyer@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: baytrail: Add pull type, strength and open drain to debugfs output
Date: Fri, 16 May 2014 12:18:29 +0300
Message-Id: <1400231909-7662-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of resolving power management or similar issues it might be useful
to have these properties included in the debugfs output.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pinctrl/pinctrl-baytrail.c | 55 +++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
index 7c65c9dab215..975572e2f260 100644
--- a/drivers/pinctrl/pinctrl-baytrail.c
+++ b/drivers/pinctrl/pinctrl-baytrail.c
@@ -43,9 +43,20 @@
 #define BYT_INT_STAT_REG	0x800
 
 /* BYT_CONF0_REG register bits */
+#define BYT_IODEN		BIT(31)
 #define BYT_TRIG_NEG		BIT(26)
 #define BYT_TRIG_POS		BIT(25)
 #define BYT_TRIG_LVL		BIT(24)
+#define BYT_PULL_STR_SHIFT	9
+#define BYT_PULL_STR_MASK	(3 << BYT_PULL_STR_SHIFT)
+#define BYT_PULL_STR_2K		(0 << BYT_PULL_STR_SHIFT)
+#define BYT_PULL_STR_10K	(1 << BYT_PULL_STR_SHIFT)
+#define BYT_PULL_STR_20K	(2 << BYT_PULL_STR_SHIFT)
+#define BYT_PULL_STR_40K	(3 << BYT_PULL_STR_SHIFT)
+#define BYT_PULL_ASSIGN_SHIFT	7
+#define BYT_PULL_ASSIGN_MASK	(3 << BYT_PULL_ASSIGN_SHIFT)
+#define BYT_PULL_ASSIGN_UP	(1 << BYT_PULL_ASSIGN_SHIFT)
+#define BYT_PULL_ASSIGN_DOWN	(2 << BYT_PULL_ASSIGN_SHIFT)
 #define BYT_PIN_MUX		0x07
 
 /* BYT_VAL_REG register bits */
@@ -321,6 +332,8 @@ static void byt_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 	spin_lock_irqsave(&vg->lock, flags);
 
 	for (i = 0; i < vg->chip.ngpio; i++) {
+		const char *pull_str = NULL;
+		const char *pull = NULL;
 		const char *label;
 		offs = vg->range->pins[i] * 16;
 		conf0 = readl(vg->reg_base + offs + BYT_CONF0_REG);
@@ -330,8 +343,32 @@ static void byt_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 		if (!label)
 			label = "Unrequested";
 
+		switch (conf0 & BYT_PULL_ASSIGN_MASK) {
+		case BYT_PULL_ASSIGN_UP:
+			pull = "up";
+			break;
+		case BYT_PULL_ASSIGN_DOWN:
+			pull = "down";
+			break;
+		}
+
+		switch (conf0 & BYT_PULL_STR_MASK) {
+		case BYT_PULL_STR_2K:
+			pull_str = "2k";
+			break;
+		case BYT_PULL_STR_10K:
+			pull_str = "10k";
+			break;
+		case BYT_PULL_STR_20K:
+			pull_str = "20k";
+			break;
+		case BYT_PULL_STR_40K:
+			pull_str = "40k";
+			break;
+		}
+
 		seq_printf(s,
-			   " gpio-%-3d (%-20.20s) %s %s %s pad-%-3d offset:0x%03x mux:%d %s%s%s\n",
+			   " gpio-%-3d (%-20.20s) %s %s %s pad-%-3d offset:0x%03x mux:%d %s%s%s",
 			   i,
 			   label,
 			   val & BYT_INPUT_EN ? "  " : "in",
@@ -339,9 +376,19 @@ static void byt_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			   val & BYT_LEVEL ? "hi" : "lo",
 			   vg->range->pins[i], offs,
 			   conf0 & 0x7,
-			   conf0 & BYT_TRIG_NEG ? " fall" : "",
-			   conf0 & BYT_TRIG_POS ? " rise" : "",
-			   conf0 & BYT_TRIG_LVL ? " level" : "");
+			   conf0 & BYT_TRIG_NEG ? " fall" : "     ",
+			   conf0 & BYT_TRIG_POS ? " rise" : "     ",
+			   conf0 & BYT_TRIG_LVL ? " level" : "      ");
+
+		if (pull && pull_str)
+			seq_printf(s, " %-4s %-3s", pull, pull_str);
+		else
+			seq_puts(s, "          ");
+
+		if (conf0 & BYT_IODEN)
+			seq_puts(s, " open-drain");
+
+		seq_puts(s, "\n");
 	}
 	spin_unlock_irqrestore(&vg->lock, flags);
 }
-- 
2.0.0.rc2

