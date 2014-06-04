Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaFDLgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:36:08 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58894 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbaFDLgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:36:04 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 15/21] pinctrl: use devm_irq_of_parse_and_map() where appropriate
Date: Wed,  4 Jun 2014 15:13:15 +0400
Message-Id: <1401880402-30091-16-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

This avoids leak of IRQ mapping on error paths, and makes it possible
to use devm_request_irq() without facing unmap-while-handler-installed
issues.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/pinctrl/pinctrl-bcm2835.c    |    6 +++++-
 drivers/pinctrl/pinctrl-exynos.c     |   11 ++++++-----
 drivers/pinctrl/pinctrl-exynos5440.c |    2 +-
 drivers/pinctrl/pinctrl-rockchip.c   |    6 +++++-
 drivers/pinctrl/pinctrl-s3c24xx.c    |    6 +++---
 drivers/pinctrl/pinctrl-s3c64xx.c    |    6 +++---
 drivers/pinctrl/pinctrl-single.c     |    6 +++++-
 drivers/pinctrl/pinctrl-sunxi.c      |    6 +++---
 8 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-bcm2835.c b/drivers/pinctrl/pinctrl-bcm2835.c
index 3d907de..320dcf4 100644
--- a/drivers/pinctrl/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/pinctrl-bcm2835.c
@@ -1012,7 +1012,11 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 		for_each_set_bit(offset, &events, 32)
 			bcm2835_gpio_wr(pc, GPEDS0 + i * 4, BIT(offset));
 
-		pc->irq[i] = irq_of_parse_and_map(np, i);
+		pc->irq[i] = devm_irq_of_parse_and_map(dev, np, i);
+		if (pc->irq[i] <= 0) {
+			dev_err(dev, "unable to locate IRQ for bank %d\n", i);
+			return pc->irq[i] ? pc->irq[i] : -EINVAL;
+		}
 		pc->irq_data[i].pc = pc;
 		pc->irq_data[i].bank = i;
 		spin_lock_init(&pc->irq_lock[i]);
diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
index 07c8130..128af30 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -549,8 +549,9 @@ static int exynos_eint_wkup_init(struct samsung_pinctrl_drv_data *d)
 		}
 
 		for (idx = 0; idx < bank->nr_pins; ++idx) {
-			irq = irq_of_parse_and_map(bank->of_node, idx);
-			if (!irq) {
+			irq = devm_irq_of_parse_and_map(dev, bank->of_node,
+					idx);
+			if (irq <= 0) {
 				dev_err(dev, "irq number for eint-%s-%d not found\n",
 							bank->name, idx);
 				continue;
@@ -565,10 +566,10 @@ static int exynos_eint_wkup_init(struct samsung_pinctrl_drv_data *d)
 	if (!muxed_banks)
 		return 0;
 
-	irq = irq_of_parse_and_map(wkup_np, 0);
-	if (!irq) {
+	irq = devm_irq_of_parse_and_map(dev, wkup_np, 0);
+	if (irq <= 0) {
 		dev_err(dev, "irq number for muxed EINTs not found\n");
-		return 0;
+		return irq ? irq : -EINVAL;
 	}
 
 	muxed_data = devm_kzalloc(dev, sizeof(*muxed_data)
diff --git a/drivers/pinctrl/pinctrl-exynos5440.c b/drivers/pinctrl/pinctrl-exynos5440.c
index 8fe2ab0..efb1e8d 100644
--- a/drivers/pinctrl/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/pinctrl-exynos5440.c
@@ -966,7 +966,7 @@ static int exynos5440_gpio_irq_init(struct platform_device *pdev,
 	}
 
 	for (i = 0; i < EXYNOS5440_MAX_GPIO_INT; i++) {
-		irq = irq_of_parse_and_map(dev->of_node, i);
+		irq = devm_irq_of_parse_and_map(dev, dev->of_node, i);
 		if (irq <= 0) {
 			dev_err(dev, "irq parsing failed\n");
 			return -EINVAL;
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 96c60d2..622a130 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1398,7 +1398,11 @@ static int rockchip_get_bank_data(struct rockchip_pin_bank *bank,
 		bank->bank_type = COMMON_BANK;
 	}
 
-	bank->irq = irq_of_parse_and_map(bank->of_node, 0);
+	bank->irq = devm_irq_of_parse_and_map(dev, bank->of_node, 0);
+	if (bank->irq < 0) {
+		dev_err(dev, "cannot find IRQ for bank\n");
+		return bank->irq;
+	}
 
 	bank->clk = of_clk_get(bank->of_node, 0);
 	if (IS_ERR(bank->clk))
diff --git a/drivers/pinctrl/pinctrl-s3c24xx.c b/drivers/pinctrl/pinctrl-s3c24xx.c
index ad3eaad..93d8e2f 100644
--- a/drivers/pinctrl/pinctrl-s3c24xx.c
+++ b/drivers/pinctrl/pinctrl-s3c24xx.c
@@ -507,10 +507,10 @@ static int s3c24xx_eint_init(struct samsung_pinctrl_drv_data *d)
 	for (i = 0; i < NUM_EINT_IRQ; ++i) {
 		unsigned int irq;
 
-		irq = irq_of_parse_and_map(eint_np, i);
-		if (!irq) {
+		irq = devm_irq_of_parse_and_map(dev, eint_np, i);
+		if (irq <= 0) {
 			dev_err(dev, "failed to get wakeup EINT IRQ %d\n", i);
-			return -ENXIO;
+			return irq ? irq : -ENXIO;
 		}
 
 		eint_data->parents[i] = irq;
diff --git a/drivers/pinctrl/pinctrl-s3c64xx.c b/drivers/pinctrl/pinctrl-s3c64xx.c
index 89143c9..f0c9188 100644
--- a/drivers/pinctrl/pinctrl-s3c64xx.c
+++ b/drivers/pinctrl/pinctrl-s3c64xx.c
@@ -725,10 +725,10 @@ static int s3c64xx_eint_eint0_init(struct samsung_pinctrl_drv_data *d)
 	for (i = 0; i < NUM_EINT0_IRQ; ++i) {
 		unsigned int irq;
 
-		irq = irq_of_parse_and_map(eint0_np, i);
-		if (!irq) {
+		irq = devm_irq_of_parse_and_map(dev, eint0_np, i);
+		if (irq <= 0) {
 			dev_err(dev, "failed to get wakeup EINT IRQ %d\n", i);
-			return -ENXIO;
+			return irq ? irq : -ENXIO;
 		}
 
 		irq_set_chained_handler(irq, s3c64xx_eint0_handlers[i]);
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 2960557..0b9b017 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1988,7 +1988,11 @@ static int pcs_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto free;
 
-	pcs->socdata.irq = irq_of_parse_and_map(np, 0);
+	pcs->socdata.irq = devm_irq_of_parse_and_map(&pdev->dev, np, 0);
+	if (pcs->socdata.irq < 0) {
+		ret = pcs->socdata.irq;
+		goto free;
+	}
 	if (pcs->socdata.irq)
 		pcs->flags |= PCS_FEAT_IRQ;
 
diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index f9fabe9..e0759e2 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -886,9 +886,9 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 
 	clk_prepare_enable(clk);
 
-	pctl->irq = irq_of_parse_and_map(node, 0);
-	if (!pctl->irq) {
-		ret = -EINVAL;
+	pctl->irq = devm_irq_of_parse_and_map(&pdev->dev, node, 0);
+	if (pctl->irq <= 0) {
+		ret = pctl->irq ? pctl->irq : -EINVAL;
 		goto gpiochip_error;
 	}
 
-- 
1.7.10.4

