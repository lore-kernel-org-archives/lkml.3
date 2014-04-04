Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaDDOEs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:04:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39839 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaDDOEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:04:46 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Maxime COQUELIN <maxime.coquelin@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH] pinctrl: st: switch IRQ locking to resource callbacks
Date: Fri,  4 Apr 2014 16:04:38 +0200
Message-Id: <1396620278-18107-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the mass-conversion to the new irqchip callbacks, this
in-transit IRQ support was missed. Fix it.

Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Cc: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-st.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index bd725b0a4341..639af4a9a2e4 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1312,25 +1312,23 @@ static void st_gpio_irq_unmask(struct irq_data *d)
 	writel(BIT(d->hwirq), bank->base + REG_PIO_SET_PMASK);
 }
 
-static unsigned int st_gpio_irq_startup(struct irq_data *d)
+static int st_gpio_irq_reqres(struct irq_data *d)
 {
 	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
 
-	if (gpio_lock_as_irq(&bank->gpio_chip, d->hwirq))
+	if (gpio_lock_as_irq(&bank->gpio_chip, d->hwirq)) {
 		dev_err(bank->gpio_chip.dev,
 			"unable to lock HW IRQ %lu for IRQ\n",
 			d->hwirq);
-
-	st_gpio_irq_unmask(d);
-
+		return -EINVAL;
+	}
 	return 0;
 }
 
-static void st_gpio_irq_shutdown(struct irq_data *d)
+static void st_gpio_irq_relres(struct irq_data *d)
 {
 	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
 
-	st_gpio_irq_mask(d);
 	gpio_unlock_as_irq(&bank->gpio_chip, d->hwirq);
 }
 
@@ -1491,8 +1489,8 @@ static struct irq_chip st_gpio_irqchip = {
 	.irq_mask	= st_gpio_irq_mask,
 	.irq_unmask	= st_gpio_irq_unmask,
 	.irq_set_type	= st_gpio_irq_set_type,
-	.irq_startup	= st_gpio_irq_startup,
-	.irq_shutdown	= st_gpio_irq_shutdown,
+	.irq_request_resources = st_gpio_irq_reqres,
+	.irq_release_resources = st_gpio_irq_relres,
 };
 
 static int st_gpio_irq_domain_map(struct irq_domain *h,
-- 
1.9.0

