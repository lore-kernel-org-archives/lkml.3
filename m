Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab3FLRde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:33:34 -0400
Received: from mail-ve0-f202.google.com ([209.85.128.202]:40541 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab3FLRdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:33:31 -0400
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>, ilho215.lee@samsung.com,
        eunki_kim@samsung.com, Doug Anderson <dianders@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] pinctrl: exynos: Add spinlocks to irq_mask and irq_unmask
Date: Wed, 12 Jun 2013 10:33:17 -0700
Message-Id: <1371058399-31933-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch:
  1984695 pinctrl: samsung: Protect bank registers with a spinlock

...added spinlocks to protect many accesses.  However, the irq_mask
and irq_unmask functions still do an unprotected read/modify/write.
Add the spinlock there.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/pinctrl/pinctrl-exynos.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
index 2d76f66..c29a28e 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -56,10 +56,15 @@ static void exynos_gpio_irq_unmask(struct irq_data *irqd)
 	struct samsung_pinctrl_drv_data *d = bank->drvdata;
 	unsigned long reg_mask = d->ctrl->geint_mask + bank->eint_offset;
 	unsigned long mask;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bank->slock, flags);
 
 	mask = readl(d->virt_base + reg_mask);
 	mask &= ~(1 << irqd->hwirq);
 	writel(mask, d->virt_base + reg_mask);
+
+	spin_unlock_irqrestore(&bank->slock, flags);
 }
 
 static void exynos_gpio_irq_mask(struct irq_data *irqd)
@@ -68,10 +73,15 @@ static void exynos_gpio_irq_mask(struct irq_data *irqd)
 	struct samsung_pinctrl_drv_data *d = bank->drvdata;
 	unsigned long reg_mask = d->ctrl->geint_mask + bank->eint_offset;
 	unsigned long mask;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bank->slock, flags);
 
 	mask = readl(d->virt_base + reg_mask);
 	mask |= 1 << irqd->hwirq;
 	writel(mask, d->virt_base + reg_mask);
+
+	spin_unlock_irqrestore(&bank->slock, flags);
 }
 
 static void exynos_gpio_irq_ack(struct irq_data *irqd)
@@ -264,10 +274,15 @@ static void exynos_wkup_irq_unmask(struct irq_data *irqd)
 	struct samsung_pinctrl_drv_data *d = b->drvdata;
 	unsigned long reg_mask = d->ctrl->weint_mask + b->eint_offset;
 	unsigned long mask;
+	unsigned long flags;
+
+	spin_lock_irqsave(&b->slock, flags);
 
 	mask = readl(d->virt_base + reg_mask);
 	mask &= ~(1 << irqd->hwirq);
 	writel(mask, d->virt_base + reg_mask);
+
+	spin_unlock_irqrestore(&b->slock, flags);
 }
 
 static void exynos_wkup_irq_mask(struct irq_data *irqd)
@@ -276,10 +291,15 @@ static void exynos_wkup_irq_mask(struct irq_data *irqd)
 	struct samsung_pinctrl_drv_data *d = b->drvdata;
 	unsigned long reg_mask = d->ctrl->weint_mask + b->eint_offset;
 	unsigned long mask;
+	unsigned long flags;
+
+	spin_lock_irqsave(&b->slock, flags);
 
 	mask = readl(d->virt_base + reg_mask);
 	mask |= 1 << irqd->hwirq;
 	writel(mask, d->virt_base + reg_mask);
+
+	spin_unlock_irqrestore(&b->slock, flags);
 }
 
 static void exynos_wkup_irq_ack(struct irq_data *irqd)
-- 
1.8.3

