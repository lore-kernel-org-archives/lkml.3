Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab3FQJw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 05:52:59 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61785 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab3FQJw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:52:57 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linus.walleij@linaro.org,
        sachin.kamat@linaro.org, patches@linaro.org,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH Resend] pinctrl: exynos: Fix build breakage
Date: Mon, 17 Jun 2013 15:08:12 +0530
Message-Id: <1371461892-5298-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'exynos_wkup_irq_ack' should be defined ahead of its call.

Fixes the following error:
drivers/pinctrl/pinctrl-exynos.c: In function ‘exynos_wkup_irq_mask’:
drivers/pinctrl/pinctrl-exynos.c:299:3: error: implicit declaration of
function ‘exynos_wkup_irq_ack’ [-Werror=implicit-function-declaration]
   exynos_wkup_irq_ack(irqd);

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>
---
Fixed the commit message.
---

 drivers/pinctrl/pinctrl-exynos.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-exynos.c b/drivers/pinctrl/pinctrl-exynos.c
index 8cd5bf5..f9277bc 100644
--- a/drivers/pinctrl/pinctrl-exynos.c
+++ b/drivers/pinctrl/pinctrl-exynos.c
@@ -279,6 +279,15 @@ err_domains:
 	return ret;
 }
 
+static void exynos_wkup_irq_ack(struct irq_data *irqd)
+{
+	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
+	struct samsung_pinctrl_drv_data *d = b->drvdata;
+	unsigned long pend = d->ctrl->weint_pend + b->eint_offset;
+
+	writel(1 << irqd->hwirq, d->virt_base + pend);
+}
+
 static void exynos_wkup_irq_mask(struct irq_data *irqd)
 {
 	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
@@ -307,15 +316,6 @@ static void exynos_wkup_irq_mask(struct irq_data *irqd)
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
 static void exynos_wkup_irq_unmask(struct irq_data *irqd)
 {
 	struct samsung_pin_bank *b = irq_data_get_irq_chip_data(irqd);
-- 
1.7.9.5

