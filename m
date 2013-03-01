Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab3CAMCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:02:11 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:59117 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261Ab3CAMCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:02:10 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        <stable@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] gpio: stmpe: pass DT node to irqdomain
Date: Fri, 1 Mar 2013 13:01:42 +0100
Message-ID: <1362139302-23048-1-git-send-email-linus.walleij@stericsson.com>
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
 drivers/gpio/gpio-stmpe.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index 770476a..73b691c 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -309,9 +309,11 @@ static const struct irq_domain_ops stmpe_gpio_irq_simple_ops = {
 
 static int stmpe_gpio_irq_init(struct stmpe_gpio *stmpe_gpio)
 {
-	int base = stmpe_gpio->irq_base;
+	int base = 0;
+	if (!stmpe_gpio->chip.of_node)
+		base = stmpe_gpio->irq_base;
 
-	stmpe_gpio->domain = irq_domain_add_simple(NULL,
+	stmpe_gpio->domain = irq_domain_add_simple(stmpe_gpio->chip.of_node,
 				stmpe_gpio->chip.ngpio, base,
 				&stmpe_gpio_irq_simple_ops, stmpe_gpio);
 	if (!stmpe_gpio->domain) {
@@ -346,6 +348,7 @@ static int stmpe_gpio_probe(struct platform_device *pdev)
 	stmpe_gpio->chip = template_chip;
 	stmpe_gpio->chip.ngpio = stmpe->num_gpios;
 	stmpe_gpio->chip.dev = &pdev->dev;
+	stmpe_gpio->chip.of_node = np;
 	stmpe_gpio->chip.base = pdata ? pdata->gpio_base : -1;
 
 	if (pdata)
-- 
1.7.11.3

