Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab3FLRdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:33:33 -0400
Received: from mail-yh0-f73.google.com ([209.85.213.73]:45380 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3FLRdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:33:31 -0400
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>, ilho215.lee@samsung.com,
        eunki_kim@samsung.com, Doug Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] pinctrl: exynos: reorder xyz_irq_unmask() so future patch can ack
Date: Wed, 12 Jun 2013 10:33:18 -0700
Message-Id: <1371058399-31933-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371058399-31933-1-git-send-email-dianders@chromium.org>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does nothing but reorder the functions to improve the
readability of a future patch.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/pinctrl/pinctrl-exynos.c | 52 ++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
index c29a28e..c0729a3 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -50,7 +50,7 @@ static const struct of_device_id exynos_wkup_irq_ids[] = {
 	{ }
 };
 
-static void exynos_gpio_irq_unmask(struct irq_data *irqd)
+static void exynos_gpio_irq_mask(struct irq_data *irqd)
 {
 	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
 	struct samsung_pinctrl_drv_data *d = bank->drvdata;
@@ -61,13 +61,22 @@ static void exynos_gpio_irq_unmask(struct irq_data *irqd)
 	spin_lock_irqsave(&bank->slock, flags);
 
 	mask = readl(d->virt_base + reg_mask);
-	mask &= ~(1 << irqd->hwirq);
+	mask |= 1 << irqd->hwirq;
 	writel(mask, d->virt_base + reg_mask);
 
 	spin_unlock_irqrestore(&bank->slock, flags);
 }
 
-static void exynos_gpio_irq_mask(struct irq_data *irqd)
+static void exynos_gpio_irq_ack(struct irq_data *irqd)
+{
+	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
+	struct samsung_pinctrl_drv_data *d = bank->drvdata;
+	unsigned long reg_pend = d->ctrl->geint_pend + bank->eint_offset;
+
+	writel(1 << irqd->hwirq, d->virt_base + reg_pend);
+}
+
+static void exynos_gpio_irq_unmask(struct irq_data *irqd)
 {
 	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
 	struct samsung_pinctrl_drv_data *d = bank->drvdata;
@@ -78,21 +87,12 @@ static void exynos_gpio_irq_mask(struct irq_data *irqd)
 	spin_lock_irqsave(&bank->slock, flags);
 
 	mask = readl(d->virt_base + reg_mask);
-	mask |= 1 << irqd->hwirq;
+	mask &= ~(1 << irqd->hwirq);
 	writel(mask, d->virt_base + reg_mask);
 
 	spin_unlock_irqrestore(&bank->slock, flags);
 }
 
-static void exynos_gpio_irq_ack(struct irq_data *irqd)
-{
-	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
-	struct samsung_pinctrl_drv_data *d = bank->drvdata;
-	unsigned long reg_pend = d->ctrl->geint_pend + bank->eint_offset;
-
-	writel(1 << irqd->hwirq, d->virt_base + reg_pend);
-}
-
 static int exynos_gpio_irq_set_type(struct irq_data *irqd, unsigned int type)
 {
 	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
@@ -268,7 +268,7 @@ err_domains:
 	return ret;
 }
 
-static void exynos_wkup_irq_unmask(struct irq_data *irqd)
+static void exynos_wkup_irq_mask(struct irq_data *irqd)
 {
 	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
 	struct samsung_pinctrl_drv_data *d = b->drvdata;
@@ -279,13 +279,22 @@ static void exynos_wkup_irq_unmask(struct irq_data *irqd)
 	spin_lock_irqsave(&b->slock, flags);
 
 	mask = readl(d->virt_base + reg_mask);
-	mask &= ~(1 << irqd->hwirq);
+	mask |= 1 << irqd->hwirq;
 	writel(mask, d->virt_base + reg_mask);
 
 	spin_unlock_irqrestore(&b->slock, flags);
 }
 
-static void exynos_wkup_irq_mask(struct irq_data *irqd)
+static void exynos_wkup_irq_ack(struct irq_data *irqd)
+{
+	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
+	struct samsung_pinctrl_drv_data *d = b->drvdata;
+	unsigned long pend = d->ctrl->weint_pend + b->eint_offset;
+
+	writel(1 << irqd->hwirq, d->virt_base + pend);
+}
+
+static void exynos_wkup_irq_unmask(struct irq_data *irqd)
 {
 	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
 	struct samsung_pinctrl_drv_data *d = b->drvdata;
@@ -296,21 +305,12 @@ static void exynos_wkup_irq_mask(struct irq_data *irqd)
 	spin_lock_irqsave(&b->slock, flags);
 
 	mask = readl(d->virt_base + reg_mask);
-	mask |= 1 << irqd->hwirq;
+	mask &= ~(1 << irqd->hwirq);
 	writel(mask, d->virt_base + reg_mask);
 
 	spin_unlock_irqrestore(&b->slock, flags);
 }
 
-static void exynos_wkup_irq_ack(struct irq_data *irqd)
-{
-	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
-	struct samsung_pinctrl_drv_data *d = b->drvdata;
-	unsigned long pend = d->ctrl->weint_pend + b->eint_offset;
-
-	writel(1 << irqd->hwirq, d->virt_base + pend);
-}
-
 static int exynos_wkup_irq_set_type(struct irq_data *irqd, unsigned int type)
 {
 	struct samsung_pin_bank *bank = irq_data_get_irq_chip_data(irqd);
-- 
1.8.3

