Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaAMO2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:28:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51329 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaAMOZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:25:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 36/96] gpio: msm: Fix irq mask/unmask by writing bits instead of numbers
Date: Mon, 13 Jan 2014 14:23:59 +0000
Message-Id: <1389623099-18783-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit 4cc629b7a20945ce35628179180329b6bc9e552b upstream.

We should be writing bits here but instead we're writing the
numbers that correspond to the bits we want to write. Fix it by
wrapping the numbers in the BIT() macro. This fixes gpios acting
as interrupts.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpio/gpio-msm-v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-msm-v2.c b/drivers/gpio/gpio-msm-v2.c
index 5cb1227..3104502 100644
--- a/drivers/gpio/gpio-msm-v2.c
+++ b/drivers/gpio/gpio-msm-v2.c
@@ -249,7 +249,7 @@ static void msm_gpio_irq_mask(struct irq_data *d)
 
 	spin_lock_irqsave(&tlmm_lock, irq_flags);
 	writel(TARGET_PROC_NONE, GPIO_INTR_CFG_SU(gpio));
-	clear_gpio_bits(INTR_RAW_STATUS_EN | INTR_ENABLE, GPIO_INTR_CFG(gpio));
+	clear_gpio_bits(BIT(INTR_RAW_STATUS_EN) | BIT(INTR_ENABLE), GPIO_INTR_CFG(gpio));
 	__clear_bit(gpio, msm_gpio.enabled_irqs);
 	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
 }
@@ -261,7 +261,7 @@ static void msm_gpio_irq_unmask(struct irq_data *d)
 
 	spin_lock_irqsave(&tlmm_lock, irq_flags);
 	__set_bit(gpio, msm_gpio.enabled_irqs);
-	set_gpio_bits(INTR_RAW_STATUS_EN | INTR_ENABLE, GPIO_INTR_CFG(gpio));
+	set_gpio_bits(BIT(INTR_RAW_STATUS_EN) | BIT(INTR_ENABLE), GPIO_INTR_CFG(gpio));
 	writel(TARGET_PROC_SCORPION, GPIO_INTR_CFG_SU(gpio));
 	spin_unlock_irqrestore(&tlmm_lock, irq_flags);
 }
-- 
1.8.3.2

