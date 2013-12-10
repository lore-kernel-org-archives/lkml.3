Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab3LJXTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:19:11 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:37084 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3LJXTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:19:06 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Subject: [PATCH 1/2] gpio: msm: Fix irq mask/unmask by writing bits instead of numbers
Date: Tue, 10 Dec 2013 15:19:03 -0800
Message-Id: <1386717544-478-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.1.109.g3d252a9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be writing bits here but instead we're writing the
numbers that correspond to the bits we want to write. Fix it by
wrapping the numbers in the BIT() macro. This fixes gpios acting
as interrupts.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/gpio/gpio-msm-v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-msm-v2.c b/drivers/gpio/gpio-msm-v2.c
index f7a0cc4..00a0978 100644
--- a/drivers/gpio/gpio-msm-v2.c
+++ b/drivers/gpio/gpio-msm-v2.c
@@ -252,7 +252,7 @@ static void msm_gpio_irq_mask(struct irq_data *d)
 
 	spin_lock_irqsave(&tlmm_lock, irq_flags);
 	writel(TARGET_PROC_NONE, GPIO_INTR_CFG_SU(gpio));
-	clear_gpio_bits(INTR_RAW_STATUS_EN | INTR_ENABLE, GPIO_INTR_CFG(gpio));
+	clear_gpio_bits(BIT(INTR_RAW_STATUS_EN) | BIT(INTR_ENABLE), GPIO_INTR_CFG(gpio));
 	__clear_bit(gpio, msm_gpio.enabled_irqs);
 	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
 }
@@ -264,7 +264,7 @@ static void msm_gpio_irq_unmask(struct irq_data *d)
 
 	spin_lock_irqsave(&tlmm_lock, irq_flags);
 	__set_bit(gpio, msm_gpio.enabled_irqs);
-	set_gpio_bits(INTR_RAW_STATUS_EN | INTR_ENABLE, GPIO_INTR_CFG(gpio));
+	set_gpio_bits(BIT(INTR_RAW_STATUS_EN) | BIT(INTR_ENABLE), GPIO_INTR_CFG(gpio));
 	writel(TARGET_PROC_SCORPION, GPIO_INTR_CFG_SU(gpio));
 	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

