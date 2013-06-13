Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455Ab3FMQsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:48:18 -0400
Received: from mail-yh0-f73.google.com ([209.85.213.73]:63448 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3FMQsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:48:17 -0400
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>, ilho215.lee@samsung.com,
        eunki_kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] pinctrl: exynos: ack level-triggered interrupts before unmasking
Date: Thu, 13 Jun 2013 09:38:42 -0700
Message-Id: <1371141522-29255-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371058399-31933-1-git-send-email-dianders@chromium.org>
References: <1371058399-31933-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A level-triggered interrupt should be acked after the interrupt line
becomes inactive and before it is unmasked, or else another interrupt
will be immediately triggered.  Acking before or after calling the
handler is not enough.

Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
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

