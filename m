Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbaCEB72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:59:28 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:34420 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753299AbaCEB70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:59:26 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linus.walleij@linaro.org>, <plagnioj@jcrosoft.com>
CC: <b.brezillon@overkiz.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH] pinctrl: at91: add the config GPIO_OUTPUT_x
Date: Wed, 5 Mar 2014 09:53:20 +0800
Message-ID: <1393984400-14687-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support the pinctrl sleep state.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
Hi Linus,

The patch is based on branch: for-next
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl

Best Regards,
Wenyou Yang

 drivers/pinctrl/pinctrl-at91.c     |   31 +++++++++++++++++++++++++++++++
 include/dt-bindings/pinctrl/at91.h |    2 ++
 2 files changed, 33 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 5d24aae..fc51e59 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -62,6 +62,8 @@ static int gpio_banks;
 #define DEGLITCH	(1 << 2)
 #define PULL_DOWN	(1 << 3)
 #define DIS_SCHMIT	(1 << 4)
+#define GPIO_OUTPUT_HIGH	(1 << 5)
+#define GPIO_OUTPUT_LOW		(1 << 6)
 #define DEBOUNCE	(1 << 16)
 #define DEBOUNCE_VAL_SHIFT	17
 #define DEBOUNCE_VAL	(0x3fff << DEBOUNCE_VAL_SHIFT)
@@ -152,12 +154,15 @@ struct at91_pinctrl_mux_ops {
 	void (*set_pulldown)(void __iomem *pio, unsigned mask, bool is_on);
 	bool (*get_schmitt_trig)(void __iomem *pio, unsigned pin);
 	void (*disable_schmitt_trig)(void __iomem *pio, unsigned mask);
+	bool (*get_gpio_output)(void __iomem *pio, unsigned mask);
+	void (*set_gpio_output)(void __iomem *pio, unsigned mask, bool is_high);
 	/* irq */
 	int (*irq_type)(struct irq_data *d, unsigned type);
 };
 
 static int gpio_irq_type(struct irq_data *d, unsigned type);
 static int alt_gpio_irq_type(struct irq_data *d, unsigned type);
+static void at91_mux_gpio_enable(void __iomem *pio, unsigned mask, bool input);
 
 struct at91_pinctrl {
 	struct device		*dev;
@@ -472,6 +477,20 @@ static bool at91_mux_pio3_get_schmitt_trig(void __iomem *pio, unsigned pin)
 	return (__raw_readl(pio + PIO_SCHMITT) >> pin) & 0x1;
 }
 
+static bool at91_mux_pio3_get_gpio_output(void __iomem *pio, unsigned pin)
+{
+	return (__raw_readl(pio + PIO_ODSR) >> pin) & 0x1;
+}
+
+static void at91_mux_pio3_set_gpio_output(void __iomem *pio,
+						unsigned mask,
+						bool is_high)
+{
+	at91_mux_gpio_enable(pio, mask, 0);
+	writel_relaxed(mask, pio + (is_high ? PIO_SODR : PIO_CODR));
+}
+
+
 static struct at91_pinctrl_mux_ops at91rm9200_ops = {
 	.get_periph	= at91_mux_get_periph,
 	.mux_A_periph	= at91_mux_set_A_periph,
@@ -495,6 +514,8 @@ static struct at91_pinctrl_mux_ops at91sam9x5_ops = {
 	.set_pulldown	= at91_mux_pio3_set_pulldown,
 	.get_schmitt_trig = at91_mux_pio3_get_schmitt_trig,
 	.disable_schmitt_trig = at91_mux_pio3_disable_schmitt_trig,
+	.get_gpio_output = at91_mux_pio3_get_gpio_output,
+	.set_gpio_output = at91_mux_pio3_set_gpio_output,
 	.irq_type	= alt_gpio_irq_type,
 };
 
@@ -741,6 +762,10 @@ static int at91_pinconf_get(struct pinctrl_dev *pctldev,
 		*config |= PULL_DOWN;
 	if (info->ops->get_schmitt_trig && info->ops->get_schmitt_trig(pio, pin))
 		*config |= DIS_SCHMIT;
+	if (info->ops->get_gpio_output) {
+		*config |= info->ops->get_gpio_output(pio, pin) ?
+					GPIO_OUTPUT_HIGH : GPIO_OUTPUT_LOW;
+	}
 
 	return 0;
 }
@@ -778,6 +803,12 @@ static int at91_pinconf_set(struct pinctrl_dev *pctldev,
 			info->ops->set_pulldown(pio, mask, config & PULL_DOWN);
 		if (info->ops->disable_schmitt_trig && config & DIS_SCHMIT)
 			info->ops->disable_schmitt_trig(pio, mask);
+		if (info->ops->set_gpio_output) {
+			if (config & GPIO_OUTPUT_HIGH)
+				info->ops->set_gpio_output(pio, mask, 1);
+			if (config & GPIO_OUTPUT_LOW)
+				info->ops->set_gpio_output(pio, mask, 0);
+		};
 
 	} /* for each config */
 
diff --git a/include/dt-bindings/pinctrl/at91.h b/include/dt-bindings/pinctrl/at91.h
index 0fee6ff..e799268 100644
--- a/include/dt-bindings/pinctrl/at91.h
+++ b/include/dt-bindings/pinctrl/at91.h
@@ -15,6 +15,8 @@
 #define AT91_PINCTRL_DEGLITCH		(1 << 2)
 #define AT91_PINCTRL_PULL_DOWN		(1 << 3)
 #define AT91_PINCTRL_DIS_SCHMIT		(1 << 4)
+#define AT91_PINCTRL_OUTPUT_HIGH	(1 << 5)
+#define AT91_PINCTRL_OUTPUT_LOW		(1 << 6)
 #define AT91_PINCTRL_DEBOUNCE		(1 << 16)
 #define AT91_PINCTRL_DEBOUNCE_VAL(x)	(x << 17)
 
-- 
1.7.9.5

