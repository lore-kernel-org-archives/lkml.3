Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767Ab3CLWhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:37:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab3CLWdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Baatz <gmbnomis@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [ 088/100] gpio: mvebu: Add clk support to prevent lockup
Date: Tue, 12 Mar 2013 15:32:13 -0700
Message-Id: <20130312223132.381875242@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Lunn <andrew@lunn.ch>

commit de88747f514a4e0cca416a8871de2302f4f77790 upstream.

The kirkwood SoC GPIO cores use the runit clock. Add code to
clk_prepare_enable() runit, otherwise there is a danger of locking up
the SoC by accessing the GPIO registers when runit clock is not
ticking.

Reported-by: Simon Baatz <gmbnomis@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Simon Baatz <gmbnomis@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/kirkwood.dtsi |    2 ++
 drivers/gpio/gpio-mvebu.c       |    7 +++++++
 2 files changed, 9 insertions(+)

--- a/arch/arm/boot/dts/kirkwood.dtsi
+++ b/arch/arm/boot/dts/kirkwood.dtsi
@@ -38,6 +38,7 @@
 			interrupt-controller;
 			#interrupt-cells = <2>;
 			interrupts = <35>, <36>, <37>, <38>;
+			clocks = <&gate_clk 7>;
 		};
 
 		gpio1: gpio@10140 {
@@ -49,6 +50,7 @@
 			interrupt-controller;
 			#interrupt-cells = <2>;
 			interrupts = <39>, <40>, <41>;
+			clocks = <&gate_clk 7>;
 		};
 
 		serial@12000 {
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -41,6 +41,7 @@
 #include <linux/io.h>
 #include <linux/of_irq.h>
 #include <linux/of_device.h>
+#include <linux/clk.h>
 #include <linux/pinctrl/consumer.h>
 
 /*
@@ -495,6 +496,7 @@ static int mvebu_gpio_probe(struct platf
 	struct resource *res;
 	struct irq_chip_generic *gc;
 	struct irq_chip_type *ct;
+	struct clk *clk;
 	unsigned int ngpios;
 	int soc_variant;
 	int i, cpu, id;
@@ -528,6 +530,11 @@ static int mvebu_gpio_probe(struct platf
 		return id;
 	}
 
+	clk = devm_clk_get(&pdev->dev, NULL);
+	/* Not all SoCs require a clock.*/
+	if (!IS_ERR(clk))
+		clk_prepare_enable(clk);
+
 	mvchip->soc_variant = soc_variant;
 	mvchip->chip.label = dev_name(&pdev->dev);
 	mvchip->chip.dev = &pdev->dev;


