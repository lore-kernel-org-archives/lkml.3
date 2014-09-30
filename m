Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaI3NHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:07:06 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45397 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaI3NHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:07:04 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: nomadik: improve GPIO debug prints
Date: Tue, 30 Sep 2014 15:06:57 +0200
Message-Id: <1412082417-10178-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debugfs file would only define if the line was "pulled" and
not which direction (pull up or pull down). Improve this by
taking two print paths depending on whether the pin is set as
input or output and use the data register directly to figure
out whether the pin is set for pull up or pull down.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/nomadik/pinctrl-nomadik.c | 36 +++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/nomadik/pinctrl-nomadik.c b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
index c4d9c5daa21b..3b7c733de489 100644
--- a/drivers/pinctrl/nomadik/pinctrl-nomadik.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
@@ -986,6 +986,7 @@ static void nmk_gpio_dbg_show_one(struct seq_file *s,
 		container_of(chip, struct nmk_gpio_chip, chip);
 	int mode;
 	bool is_out;
+	bool data_out;
 	bool pull;
 	u32 bit = 1 << offset;
 	const char *modes[] = {
@@ -998,28 +999,41 @@ static void nmk_gpio_dbg_show_one(struct seq_file *s,
 		[NMK_GPIO_ALT_C+3]	= "altC3",
 		[NMK_GPIO_ALT_C+4]	= "altC4",
 	};
+	const char *pulls[] = {
+		"none     ",
+		"pull down",
+		"pull up  ",
+	};
 
 	clk_enable(nmk_chip->clk);
 	is_out = !!(readl(nmk_chip->addr + NMK_GPIO_DIR) & bit);
 	pull = !(readl(nmk_chip->addr + NMK_GPIO_PDIS) & bit);
+	data_out = !!(readl(nmk_chip->addr + NMK_GPIO_DAT) & bit);
 	mode = nmk_gpio_get_mode(gpio);
 	if ((mode == NMK_GPIO_ALT_C) && pctldev)
 		mode = nmk_prcm_gpiocr_get_mode(pctldev, gpio);
 
-	seq_printf(s, " gpio-%-3d (%-20.20s) %s %s %s %s",
-		   gpio, label ?: "(none)",
-		   is_out ? "out" : "in ",
-		   chip->get
-		   ? (chip->get(chip, offset) ? "hi" : "lo")
-		   : "?  ",
-		   (mode < 0) ? "unknown" : modes[mode],
-		   pull ? "pull" : "none");
-
-	if (!is_out) {
+	if (is_out) {
+		seq_printf(s, " gpio-%-3d (%-20.20s) out %s        %s",
+			   gpio,
+			   label ?: "(none)",
+			   data_out ? "hi" : "lo",
+			   (mode < 0) ? "unknown" : modes[mode]);
+	} else {
 		int irq = gpio_to_irq(gpio);
 		struct irq_desc	*desc = irq_to_desc(irq);
+		int pullidx = 0;
 
-		/* This races with request_irq(), set_irq_type(),
+		if (pull)
+			pullidx = data_out ? 1 : 2;
+
+		seq_printf(s, " gpio-%-3d (%-20.20s) in  %s %s",
+			   gpio,
+			   label ?: "(none)",
+			   pulls[pullidx],
+			   (mode < 0) ? "unknown" : modes[mode]);
+		/*
+		 * This races with request_irq(), set_irq_type(),
 		 * and set_irq_wake() ... but those are "rare".
 		 */
 		if (irq > 0 && desc && desc->action) {
-- 
1.9.3

