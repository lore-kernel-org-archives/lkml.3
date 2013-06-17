Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3FQQ7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:59:01 -0400
Received: from mail-ve0-f201.google.com ([209.85.128.201]:53541 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab3FQQ7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:59:00 -0400
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>, ilho215.lee@samsung.com,
        eunki_kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3] pinctrl: exynos: ack level-triggered interrupts before unmasking
Date: Mon, 17 Jun 2013 09:50:43 -0700
Message-Id: <1371487843-2066-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A level-triggered interrupt should be acked after the interrupt line
becomes inactive and before it is unmasked, or else another interrupt
will be immediately triggered.  Acking before or after calling the
handler is not enough.

Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Tomasz Figa <t.figa@samsung.com>
---
Changes in v3:
- Rebased atop (44b6d93 pinctrl: rockchip: correctly handle arguments
  of pinconf options)

Changes in v2:
- Greatly simplified using Tomasz's suggestion of irqd_get_trigger_type
- Moved acking out of the bank spinlock since since it's not needed.
- Linus W. has already applied parts 1 and 2, so not resending.

 drivers/pinctrl/pinctrl-exynos.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
index c0729a3..ef75321 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -84,6 +84,17 @@ static void exynos_gpio_irq_unmask(struct irq_data *irqd)
 	unsigned long mask;
 	unsigned long flags;
 
+	/*
+	 * Ack level interrupts right before unmask
+	 *
+	 * If we don't do this we'll get a double-interrupt.  Level triggered
+	 * interrupts must not fire an interrupt if the level is not
+	 * _currently_ active, even if it was active while the interrupt was
+	 * masked.
+	 */
+	if (irqd_get_trigger_type(irqd) & IRQ_TYPE_LEVEL_MASK)
+		exynos_gpio_irq_ack(irqd);
+
 	spin_lock_irqsave(&bank->slock, flags);
 
 	mask = readl(d->virt_base + reg_mask);
@@ -302,6 +313,17 @@ static void exynos_wkup_irq_unmask(struct irq_data *irqd)
 	unsigned long mask;
 	unsigned long flags;
 
+	/*
+	 * Ack level interrupts right before unmask
+	 *
+	 * If we don't do this we'll get a double-interrupt.  Level triggered
+	 * interrupts must not fire an interrupt if the level is not
+	 * _currently_ active, even if it was active while the interrupt was
+	 * masked.
+	 */
+	if (irqd_get_trigger_type(irqd) & IRQ_TYPE_LEVEL_MASK)
+		exynos_wkup_irq_ack(irqd);
+
 	spin_lock_irqsave(&b->slock, flags);
 
 	mask = readl(d->virt_base + reg_mask);
-- 
1.8.3

