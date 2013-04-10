Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965139Ab3DJXRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:17:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937092Ab3DJWrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 10/64] gpio: stmpe: pass DT node to irqdomain
Date: Wed, 10 Apr 2013 15:46:07 -0700
Message-Id: <20130410224335.506478214@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>

commit 9afd9b7090225d78ef56423a2ff65354dc38f1b1 upstream.

The irq domain was implemented but the device tree
node was not transmitted to irq_domain_add_simple().

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-stmpe.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -307,11 +307,15 @@ static const struct irq_domain_ops stmpe
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
@@ -346,6 +350,9 @@ static int stmpe_gpio_probe(struct platf
 	stmpe_gpio->chip = template_chip;
 	stmpe_gpio->chip.ngpio = stmpe->num_gpios;
 	stmpe_gpio->chip.dev = &pdev->dev;
+#ifdef CONFIG_OF
+	stmpe_gpio->chip.of_node = np;
+#endif
 	stmpe_gpio->chip.base = pdata ? pdata->gpio_base : -1;
 
 	if (pdata)
@@ -366,7 +373,7 @@ static int stmpe_gpio_probe(struct platf
 		goto out_free;
 
 	if (irq >= 0) {
-		ret = stmpe_gpio_irq_init(stmpe_gpio);
+		ret = stmpe_gpio_irq_init(stmpe_gpio, np);
 		if (ret)
 			goto out_disable;
 


