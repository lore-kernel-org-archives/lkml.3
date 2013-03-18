Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab3CRKpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 06:45:51 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:39622 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354Ab3CRKpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 06:45:47 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        <stable@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v2] gpio: stmpe: pass DT node to irqdomain
Date: Mon, 18 Mar 2013 11:45:05 +0100
Message-ID: <1363603505-2996-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>

The irq domain was implemented but the device tree
node was not transmitted to irq_domain_add_simple().

Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-stmpe.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index 770476a..3ce5bc3 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -307,11 +307,15 @@ static const struct irq_domain_ops stmpe_gpio_irq_simple_ops = {
 	.xlate = irq_domain_xlate_twocell,
 };
 
-static int stmpe_gpio_irq_init(struct stmpe_gpio *stmpe_gpio)
+static int stmpe_gpio_irq_init(struct stmpe_gpio *stmpe_gpio,
+		struct device_node *np)
 {
-	int base = stmpe_gpio->irq_base;
+	int base = 0;
 
-	stmpe_gpio->domain = irq_domain_add_simple(NULL,
+	if (!np)
+		base = stmpe_gpio->irq_base;
+
+	stmpe_gpio->domain = irq_domain_add_simple(np,
 				stmpe_gpio->chip.ngpio, base,
 				&stmpe_gpio_irq_simple_ops, stmpe_gpio);
 	if (!stmpe_gpio->domain) {
@@ -346,6 +350,9 @@ static int stmpe_gpio_probe(struct platform_device *pdev)
 	stmpe_gpio->chip = template_chip;
 	stmpe_gpio->chip.ngpio = stmpe->num_gpios;
 	stmpe_gpio->chip.dev = &pdev->dev;
+#ifdef CONFIG_OF
+	stmpe_gpio->chip.of_node = np;
+#endif
 	stmpe_gpio->chip.base = pdata ? pdata->gpio_base : -1;
 
 	if (pdata)
@@ -366,7 +373,7 @@ static int stmpe_gpio_probe(struct platform_device *pdev)
 		goto out_free;
 
 	if (irq >= 0) {
-		ret = stmpe_gpio_irq_init(stmpe_gpio);
+		ret = stmpe_gpio_irq_init(stmpe_gpio, np);
 		if (ret)
 			goto out_disable;
 
-- 
1.7.11.3

