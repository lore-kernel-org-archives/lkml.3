Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161655AbaDPOoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:44:37 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:51998 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161145AbaDPOod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:44:33 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Silvio F <silvio.fricke@gmail.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/6] mfd: stmpe: root out static GPIO and IRQ assignments
Date: Wed, 16 Apr 2014 16:44:10 +0200
Message-Id: <1397659455-13638-2-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only platform using the STMPE expander now boots from
device tree using all-dynamic GPIO and IRQ number assignments, so
remove the mechanism to pass this from the device tree entirely.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/gpio-stmpe.c | 18 +++++-------------
 drivers/mfd/stmpe.c       |  3 +--
 include/linux/mfd/stmpe.h | 14 --------------
 3 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
index 2776a09bee58..628b58494294 100644
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@ -23,7 +23,8 @@
 enum { REG_RE, REG_FE, REG_IE };
 
 #define CACHE_NR_REGS	3
-#define CACHE_NR_BANKS	(STMPE_NR_GPIOS / 8)
+/* No variant has more than 24 GPIOs */
+#define CACHE_NR_BANKS	(24 / 8)
 
 struct stmpe_gpio {
 	struct gpio_chip chip;
@@ -31,8 +32,6 @@ struct stmpe_gpio {
 	struct device *dev;
 	struct mutex irq_lock;
 	struct irq_domain *domain;
-
-	int irq_base;
 	unsigned norequest_mask;
 
 	/* Caches of interrupt control registers for bus_lock */
@@ -311,13 +310,8 @@ static const struct irq_domain_ops stmpe_gpio_irq_simple_ops = {
 static int stmpe_gpio_irq_init(struct stmpe_gpio *stmpe_gpio,
 		struct device_node *np)
 {
-	int base = 0;
-
-	if (!np)
-		base = stmpe_gpio->irq_base;
-
 	stmpe_gpio->domain = irq_domain_add_simple(np,
-				stmpe_gpio->chip.ngpio, base,
+				stmpe_gpio->chip.ngpio, 0,
 				&stmpe_gpio_irq_simple_ops, stmpe_gpio);
 	if (!stmpe_gpio->domain) {
 		dev_err(stmpe_gpio->dev, "failed to create irqdomain\n");
@@ -354,7 +348,7 @@ static int stmpe_gpio_probe(struct platform_device *pdev)
 #ifdef CONFIG_OF
 	stmpe_gpio->chip.of_node = np;
 #endif
-	stmpe_gpio->chip.base = pdata ? pdata->gpio_base : -1;
+	stmpe_gpio->chip.base = -1;
 
 	if (pdata)
 		stmpe_gpio->norequest_mask = pdata->norequest_mask;
@@ -362,9 +356,7 @@ static int stmpe_gpio_probe(struct platform_device *pdev)
 		of_property_read_u32(np, "st,norequest-mask",
 				&stmpe_gpio->norequest_mask);
 
-	if (irq >= 0)
-		stmpe_gpio->irq_base = stmpe->irq_base + STMPE_INT_GPIO(0);
-	else
+	if (irq < 0)
 		dev_info(&pdev->dev,
 			"device configured in no-irq mode; "
 			"irqs are not available\n");
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 3c7eec6917d7..6155230ae29c 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1063,7 +1063,7 @@ static int stmpe_chip_init(struct stmpe *stmpe)
 static int stmpe_add_device(struct stmpe *stmpe, const struct mfd_cell *cell)
 {
 	return mfd_add_devices(stmpe->dev, stmpe->pdata->id, cell, 1,
-			       NULL, stmpe->irq_base, stmpe->domain);
+			       NULL, 0, stmpe->domain);
 }
 
 static int stmpe_devices_init(struct stmpe *stmpe)
@@ -1167,7 +1167,6 @@ int stmpe_probe(struct stmpe_client_info *ci, int partnum)
 	stmpe->dev = ci->dev;
 	stmpe->client = ci->client;
 	stmpe->pdata = pdata;
-	stmpe->irq_base = pdata->irq_base;
 	stmpe->ci = ci;
 	stmpe->partnum = partnum;
 	stmpe->variant = stmpe_variant_info[partnum];
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index 48395a69a7e9..3f8798e4a87d 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -73,7 +73,6 @@ struct stmpe_client_info;
  * @regs: list of addresses of registers which are at different addresses on
  *	  different variants.  Indexed by one of STMPE_IDX_*.
  * @irq: irq number for stmpe
- * @irq_base: starting IRQ number for internal IRQs
  * @num_gpios: number of gpios, differs for variants
  * @ier: cache of IER registers for bus_lock
  * @oldier: cache of IER registers for bus_lock
@@ -91,7 +90,6 @@ struct stmpe {
 	const u8 *regs;
 
 	int irq;
-	int irq_base;
 	int num_gpios;
 	u8 ier[2];
 	u8 oldier[2];
@@ -132,8 +130,6 @@ struct stmpe_keypad_platform_data {
 
 /**
  * struct stmpe_gpio_platform_data - STMPE GPIO platform data
- * @gpio_base: first gpio number assigned.  A maximum of
- *	       %STMPE_NR_GPIOS GPIOs will be allocated.
  * @norequest_mask: bitmask specifying which GPIOs should _not_ be
  *		    requestable due to different usage (e.g. touch, keypad)
  *		    STMPE_GPIO_NOREQ_* macros can be used here.
@@ -141,7 +137,6 @@ struct stmpe_keypad_platform_data {
  * @remove: board specific remove callback
  */
 struct stmpe_gpio_platform_data {
-	int gpio_base;
 	unsigned norequest_mask;
 	void (*setup)(struct stmpe *stmpe, unsigned gpio_base);
 	void (*remove)(struct stmpe *stmpe, unsigned gpio_base);
@@ -195,8 +190,6 @@ struct stmpe_ts_platform_data {
  * @irq_trigger: IRQ trigger to use for the interrupt to the host
  * @autosleep: bool to enable/disable stmpe autosleep
  * @autosleep_timeout: inactivity timeout in milliseconds for autosleep
- * @irq_base: base IRQ number.  %STMPE_NR_IRQS irqs will be used, or
- *	      %STMPE_NR_INTERNAL_IRQS if the GPIO driver is not used.
  * @irq_over_gpio: true if gpio is used to get irq
  * @irq_gpio: gpio number over which irq will be requested (significant only if
  *	      irq_over_gpio is true)
@@ -207,7 +200,6 @@ struct stmpe_ts_platform_data {
 struct stmpe_platform_data {
 	int id;
 	unsigned int blocks;
-	int irq_base;
 	unsigned int irq_trigger;
 	bool autosleep;
 	bool irq_over_gpio;
@@ -219,10 +211,4 @@ struct stmpe_platform_data {
 	struct stmpe_ts_platform_data *ts;
 };
 
-#define STMPE_NR_INTERNAL_IRQS	9
-#define STMPE_INT_GPIO(x)	(STMPE_NR_INTERNAL_IRQS + (x))
-
-#define STMPE_NR_GPIOS		24
-#define STMPE_NR_IRQS		STMPE_INT_GPIO(STMPE_NR_GPIOS)
-
 #endif
-- 
1.9.0

