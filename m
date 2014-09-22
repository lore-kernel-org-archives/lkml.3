Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaIVRJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:09:44 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:58148 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbaIVRJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:09:42 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, linus.walleij@linaro.org,
        gnurou@gmail.com
Cc: linux@arm.linux.org.uk, jingchang.lu@freescale.com, b20788@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, stefan@agner.ch
Subject: [PATCH 5/9] gpio: vf610: Extend with wakeup support
Date: Mon, 22 Sep 2014 19:09:26 +0200
Message-Id: <704b6bb97147b3d0ee1557b43d85ab9376c28666.1411404079.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support Vybrid GPIO's as wakeup source by requesting the parent
IRQ as wakeup IRQ.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/gpio/gpio-vf610.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index 5f59424..50326af 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -196,12 +196,28 @@ static void vf610_gpio_irq_unmask(struct irq_data *d)
 			  pcr_base);
 }
 
+static int vf610_gpio_irq_set_wake(struct irq_data *d, u32 enable)
+{
+	struct vf610_gpio_port *port = irq_data_get_irq_chip_data(d);
+
+	if (enable)
+		enable_irq_wake(port->irq);
+	else
+		disable_irq_wake(port->irq);
+
+	return 0;
+}
+
+
 static struct irq_chip vf610_gpio_irq_chip = {
 	.name		= "gpio-vf610",
 	.irq_ack	= vf610_gpio_irq_ack,
 	.irq_mask	= vf610_gpio_irq_mask,
 	.irq_unmask	= vf610_gpio_irq_unmask,
 	.irq_set_type	= vf610_gpio_irq_set_type,
+#ifdef CONFIG_PM_SLEEP
+	.irq_set_wake	= vf610_gpio_irq_set_wake,
+#endif
 };
 
 static int vf610_gpio_probe(struct platform_device *pdev)
-- 
2.1.0

