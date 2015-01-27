Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbbA0Eqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:46:54 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:56205 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223AbbA0EqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:46:24 -0500
From: Rob Herring <robh@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>, Jing Xiang <jxiang@marvell.com>,
        Xiangzhan Meng <mengxzh@marvell.com>
Subject: [PATCH 3/3] gpio: pxa: add PXA1928 gpio type support
Date: Mon, 26 Jan 2015 22:46:06 -0600
Message-Id: <1422333966-18338-4-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422333966-18338-1-git-send-email-robh@kernel.org>
References: <1422333966-18338-1-git-send-email-robh@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for PXA1928 GPIOs. The PXA1928 adds a 6th bank from previous
generations.

Signed-off-by: Jing Xiang <jxiang@marvell.com>
Signed-off-by: Xiangzhan Meng <mengxzh@marvell.com>
[robh: ported to 3.19 from vendor kernel]
Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
---
 drivers/gpio/gpio-pxa.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
index b4fb8de..2fdb04b 100644
--- a/drivers/gpio/gpio-pxa.c
+++ b/drivers/gpio/gpio-pxa.c
@@ -41,9 +41,12 @@
  * BANK 4 - 0x0104  0x0110  0x011C  0x0128  0x0134  0x0140  0x014C
  * BANK 5 - 0x0108  0x0114  0x0120  0x012C  0x0138  0x0144  0x0150
  *
+ * BANK 6 - 0x0200  0x020C  0x0218  0x0224  0x0230  0x023C  0x0248
+ *
  * NOTE:
  *   BANK 3 is only available on PXA27x and later processors.
- *   BANK 4 and 5 are only available on PXA935
+ *   BANK 4 and 5 are only available on PXA935, PXA1928
+ *   BANK 6 is only available on PXA1928
  */
 
 #define GPLR_OFFSET	0x00
@@ -56,7 +59,8 @@
 #define GAFR_OFFSET	0x54
 #define ED_MASK_OFFSET	0x9C	/* GPIO edge detection for AP side */
 
-#define BANK_OFF(n)	(((n) < 3) ? (n) << 2 : 0x100 + (((n) - 3) << 2))
+#define BANK_OFF(n)	(((n) < 3) ? (n) << 2 : ((n) > 5 ? 0x200 : 0x100)	\
+			+ (((n) % 3) << 2))
 
 int pxa_last_gpio;
 static int irq_base;
@@ -92,6 +96,7 @@ enum pxa_gpio_type {
 	PXA93X_GPIO,
 	MMP_GPIO = 0x10,
 	MMP2_GPIO,
+	PXA1928_GPIO,
 };
 
 struct pxa_gpio_id {
@@ -139,6 +144,11 @@ static struct pxa_gpio_id mmp2_id = {
 	.gpio_nums	= 192,
 };
 
+static struct pxa_gpio_id pxa1928_id = {
+	.type		= PXA1928_GPIO,
+	.gpio_nums	= 224,
+};
+
 #define for_each_gpio_chip(i, c)			\
 	for (i = 0, c = &pxa_gpio_chips[0]; i <= pxa_last_gpio; i += 32, c++)
 
@@ -486,6 +496,7 @@ static int pxa_gpio_nums(struct platform_device *pdev)
 	case PXA93X_GPIO:
 	case MMP_GPIO:
 	case MMP2_GPIO:
+	case PXA1928_GPIO:
 		gpio_type = pxa_id->type;
 		count = pxa_id->gpio_nums - 1;
 		break;
@@ -505,6 +516,7 @@ static const struct of_device_id pxa_gpio_dt_ids[] = {
 	{ .compatible = "marvell,pxa93x-gpio",	.data = &pxa93x_id, },
 	{ .compatible = "marvell,mmp-gpio",	.data = &mmp_id, },
 	{ .compatible = "marvell,mmp2-gpio",	.data = &mmp2_id, },
+	{ .compatible = "marvell,pxa1928-gpio",	.data = &pxa1928_id, },
 	{}
 };
 
@@ -666,6 +678,7 @@ static const struct platform_device_id gpio_id_table[] = {
 	{ "pxa93x-gpio",	(unsigned long)&pxa93x_id },
 	{ "mmp-gpio",		(unsigned long)&mmp_id },
 	{ "mmp2-gpio",		(unsigned long)&mmp2_id },
+	{ "pxa1928-gpio",	(unsigned long)&pxa1928_id },
 	{ },
 };
 
-- 
2.1.0

