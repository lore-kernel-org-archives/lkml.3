Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaANO6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:58:35 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:59278 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbaANO63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:58:29 -0500
From: <srinivas.kandagatla@st.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srinivas.kandagatla@st.com>
Subject: [PATCH v1 3/5] pinctrl: st: Add software edge trigger interrupt support.
Date: Tue, 14 Jan 2014 14:52:21 +0000
Message-ID: <1389711141-21090-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1389711077-20949-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389711077-20949-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

ST pin controller does not have hardware support for detecting edge
triggered interrupts, It only has level triggering support.
This patch attempts to fake up edge triggers from hw level trigger
support in software. With this facility now the gpios can be easily used
for keypads, otherwise it would be difficult for drivers like keypads to
work with level trigger interrupts.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/pinctrl/pinctrl-st.c |   66 ++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 03c0cfd..7d2780e 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -271,6 +271,24 @@ struct st_pctl_group {
 	struct st_pinconf	*pin_conf;
 };
 
+#define ST_IRQ_EDGE_CONF_BITS_PER_PIN	4
+#define ST_IRQ_EDGE_MASK		0xf
+#define ST_IRQ_EDGE_FALLING		BIT(0)
+#define ST_IRQ_EDGE_RISING		BIT(1)
+#define ST_IRQ_EDGE_BOTH		(BIT(0) | BIT(1))
+
+#define ST_IRQ_RISING_EDGE_CONF(pin) \
+	(ST_IRQ_EDGE_RISING << (pin * ST_IRQ_EDGE_CONF_BITS_PER_PIN))
+
+#define ST_IRQ_FALLING_EDGE_CONF(pin) \
+	(ST_IRQ_EDGE_FALLING << (pin * ST_IRQ_EDGE_CONF_BITS_PER_PIN))
+
+#define ST_IRQ_BOTH_EDGE_CONF(pin) \
+	(ST_IRQ_EDGE_BOTH << (pin * ST_IRQ_EDGE_CONF_BITS_PER_PIN))
+
+#define ST_IRQ_EDGE_CONF(conf, pin) \
+	(conf >> (pin * ST_IRQ_EDGE_CONF_BITS_PER_PIN) & ST_IRQ_EDGE_MASK)
+
 struct st_gpio_bank {
 	struct gpio_chip		gpio_chip;
 	struct pinctrl_gpio_range	range;
@@ -278,6 +296,8 @@ struct st_gpio_bank {
 	struct st_pio_control		pc;
 	struct	irq_domain		*domain;
 	int				gpio_irq;
+	unsigned long			irq_edge_conf;
+	spinlock_t                      lock;
 };
 
 struct st_pinctrl {
@@ -1241,20 +1261,40 @@ static void st_gpio_irq_enable(struct irq_data *d)
 static int st_gpio_irq_set_type(struct irq_data *d, unsigned type)
 {
 	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
+	unsigned long flags;
 	int comp, pin = d->hwirq;
 	u32 val;
+	u32 pin_edge_conf = 0;
 
 	switch (type) {
 	case IRQ_TYPE_LEVEL_HIGH:
 		comp = 0;
 		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		comp = 0;
+		pin_edge_conf = ST_IRQ_FALLING_EDGE_CONF(pin);
+		break;
 	case IRQ_TYPE_LEVEL_LOW:
 		comp = 1;
 		break;
+	case IRQ_TYPE_EDGE_RISING:
+		comp = 1;
+		pin_edge_conf = ST_IRQ_RISING_EDGE_CONF(pin);
+		break;
+	case IRQ_TYPE_EDGE_BOTH:
+		comp = st_gpio_get(&bank->gpio_chip, pin);
+		pin_edge_conf = ST_IRQ_BOTH_EDGE_CONF(pin);
+		break;
 	default:
 		return -EINVAL;
 	}
 
+	spin_lock_irqsave(&bank->lock, flags);
+	bank->irq_edge_conf &=  ~(ST_IRQ_EDGE_MASK << (
+				pin * ST_IRQ_EDGE_CONF_BITS_PER_PIN));
+	bank->irq_edge_conf |= pin_edge_conf;
+	spin_unlock_irqrestore(&bank->lock, flags);
+
 	val = readl(bank->base + REG_PIO_PCOMP);
 	val &= ~BIT(pin);
 	val |= (comp << pin);
@@ -1266,7 +1306,12 @@ static int st_gpio_irq_set_type(struct irq_data *d, unsigned type)
 static void __gpio_irq_handler(struct st_gpio_bank *bank)
 {
 	unsigned long port_in, port_mask, port_comp, port_active;
-	int n;
+	unsigned long bank_edge_mask, flags;
+	int n, val, pin_edge_cfg;
+
+	spin_lock_irqsave(&bank->lock, flags);
+	bank_edge_mask = bank->irq_edge_conf;
+	spin_unlock_irqrestore(&bank->lock, flags);
 
 	port_in = readl(bank->base + REG_PIO_PIN);
 	port_comp = readl(bank->base + REG_PIO_PCOMP);
@@ -1275,6 +1320,22 @@ static void __gpio_irq_handler(struct st_gpio_bank *bank)
 	port_active = (port_in ^ port_comp) & port_mask;
 
 	for_each_set_bit(n, &port_active, BITS_PER_LONG) {
+		/* check if we are detecting fake edges ... */
+		pin_edge_cfg = ST_IRQ_EDGE_CONF(bank_edge_mask, n);
+
+		if (pin_edge_cfg) {
+			/* edge detection. */
+			val = st_gpio_get(&bank->gpio_chip, n);
+			if (val)
+				writel(BIT(n), bank->base + REG_PIO_SET_PCOMP);
+			else
+				writel(BIT(n), bank->base + REG_PIO_CLR_PCOMP);
+
+			if (pin_edge_cfg != ST_IRQ_EDGE_BOTH &&
+				!((pin_edge_cfg & ST_IRQ_EDGE_FALLING) ^ val))
+					continue;
+		}
+
 		generic_handle_irq(irq_find_mapping(bank->domain, n));
 	}
 }
@@ -1334,7 +1395,7 @@ static int st_gpio_irq_domain_map(struct irq_domain *h,
 	struct st_gpio_bank *bank = h->host_data;
 
 	irq_set_chip(virq, &st_gpio_irqchip);
-	irq_set_handler(virq, handle_level_irq);
+	irq_set_handler(virq, handle_simple_irq);
 	set_irq_flags(virq, IRQF_VALID);
 	irq_set_chip_data(virq, bank);
 
@@ -1392,6 +1453,7 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
 	bank->gpio_chip.base = bank_num * ST_GPIO_PINS_PER_BANK;
 	bank->gpio_chip.ngpio = ST_GPIO_PINS_PER_BANK;
 	bank->gpio_chip.of_node = np;
+	spin_lock_init(&bank->lock);
 
 	of_property_read_string(np, "st,bank-name", &range->name);
 	bank->gpio_chip.label = range->name;
-- 
1.7.6.5

