Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbaDWMmB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:42:01 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:55058 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbaDWMl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:41:56 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4 v2] gpio: tc3589x: get rid of static IRQ and GPIO bases
Date: Wed, 23 Apr 2014 14:41:46 +0200
Message-Id: <1398256906-25118-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The static IRQ and GPIO base is not used on any platforms with
this chip (only Ux500, only device tree). Get rid of the static
assignments forever, and rely on dynamic IRQ and GPIO descriptor
allocation.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Be more thorough, delete all static GPIO and IRQ assignments.

Lee/Sam: can you either ACK this small(ish) change so I can
take it through the GPIO tree or provide an immutable TC3589x
branch including any other TC3589x patches I've written or
may have arrived?
---
 drivers/gpio/gpio-tc3589x.c | 12 ++----------
 drivers/mfd/tc3589x.c       |  9 +++------
 include/linux/mfd/tc3589x.h | 11 -----------
 3 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/gpio/gpio-tc3589x.c b/drivers/gpio/gpio-tc3589x.c
index 113e50cb1f59..fee8c73cf8c8 100644
--- a/drivers/gpio/gpio-tc3589x.c
+++ b/drivers/gpio/gpio-tc3589x.c
@@ -32,9 +32,6 @@ struct tc3589x_gpio {
 	struct device *dev;
 	struct mutex irq_lock;
 	struct irq_domain *domain;
-
-	int irq_base;
-
 	/* Caches of interrupt control registers for bus_lock */
 	u8 regs[CACHE_NR_REGS][CACHE_NR_BANKS];
 	u8 oldregs[CACHE_NR_REGS][CACHE_NR_BANKS];
@@ -290,8 +287,6 @@ static struct irq_domain_ops tc3589x_irq_ops = {
 static int tc3589x_gpio_irq_init(struct tc3589x_gpio *tc3589x_gpio,
 				struct device_node *np)
 {
-	int base = tc3589x_gpio->irq_base;
-
 	/*
 	 * If this results in a linear domain, irq_create_mapping() will
 	 * take care of allocating IRQ descriptors at runtime. When a base
@@ -299,7 +294,7 @@ static int tc3589x_gpio_irq_init(struct tc3589x_gpio *tc3589x_gpio,
 	 * domain is instantiated.
 	 */
 	tc3589x_gpio->domain = irq_domain_add_simple(np,
-			tc3589x_gpio->chip.ngpio, base, &tc3589x_irq_ops,
+			tc3589x_gpio->chip.ngpio, 0, &tc3589x_irq_ops,
 			tc3589x_gpio);
 	if (!tc3589x_gpio->domain) {
 		dev_err(tc3589x_gpio->dev, "Failed to create irqdomain\n");
@@ -342,15 +337,12 @@ static int tc3589x_gpio_probe(struct platform_device *pdev)
 	tc3589x_gpio->chip = template_chip;
 	tc3589x_gpio->chip.ngpio = tc3589x->num_gpio;
 	tc3589x_gpio->chip.dev = &pdev->dev;
-	tc3589x_gpio->chip.base = (pdata) ? pdata->gpio_base : -1;
+	tc3589x_gpio->chip.base = -1;
 
 #ifdef CONFIG_OF_GPIO
 	tc3589x_gpio->chip.of_node = np;
 #endif
 
-	tc3589x_gpio->irq_base = tc3589x->irq_base ?
-		tc3589x->irq_base + TC3589x_INT_GPIO(0) : 0;
-
 	/* Bring the GPIO module out of reset */
 	ret = tc3589x_set_bits(tc3589x, TC3589x_RSTCTRL,
 			       TC3589x_RSTCTRL_GPIRST, 0);
diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index bd83accc0f6d..972b00d0220f 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -241,10 +241,8 @@ static struct irq_domain_ops tc3589x_irq_ops = {
 
 static int tc3589x_irq_init(struct tc3589x *tc3589x, struct device_node *np)
 {
-	int base = tc3589x->irq_base;
-
 	tc3589x->domain = irq_domain_add_simple(
-		np, TC3589x_NR_INTERNAL_IRQS, base,
+		np, TC3589x_NR_INTERNAL_IRQS, 0,
 		&tc3589x_irq_ops, tc3589x);
 
 	if (!tc3589x->domain) {
@@ -298,7 +296,7 @@ static int tc3589x_device_init(struct tc3589x *tc3589x)
 	if (blocks & TC3589x_BLOCK_GPIO) {
 		ret = mfd_add_devices(tc3589x->dev, -1, tc3589x_dev_gpio,
 				      ARRAY_SIZE(tc3589x_dev_gpio), NULL,
-				      tc3589x->irq_base, tc3589x->domain);
+				      0, tc3589x->domain);
 		if (ret) {
 			dev_err(tc3589x->dev, "failed to add gpio child\n");
 			return ret;
@@ -309,7 +307,7 @@ static int tc3589x_device_init(struct tc3589x *tc3589x)
 	if (blocks & TC3589x_BLOCK_KEYPAD) {
 		ret = mfd_add_devices(tc3589x->dev, -1, tc3589x_dev_keypad,
 				      ARRAY_SIZE(tc3589x_dev_keypad), NULL,
-				      tc3589x->irq_base, tc3589x->domain);
+				      0, tc3589x->domain);
 		if (ret) {
 			dev_err(tc3589x->dev, "failed to keypad child\n");
 			return ret;
@@ -404,7 +402,6 @@ static int tc3589x_probe(struct i2c_client *i2c,
 	tc3589x->dev = &i2c->dev;
 	tc3589x->i2c = i2c;
 	tc3589x->pdata = pdata;
-	tc3589x->irq_base = pdata->irq_base;
 
 	switch (version) {
 	case TC3589X_TC35893:
diff --git a/include/linux/mfd/tc3589x.h b/include/linux/mfd/tc3589x.h
index 6b8e1ff4672b..c07aba9a1a2a 100644
--- a/include/linux/mfd/tc3589x.h
+++ b/include/linux/mfd/tc3589x.h
@@ -111,15 +111,12 @@ enum tx3589x_block {
 #define TC3589x_INT_PORIRQ	7
 
 #define TC3589x_NR_INTERNAL_IRQS	8
-#define TC3589x_INT_GPIO(x)	(TC3589x_NR_INTERNAL_IRQS + (x))
 
 struct tc3589x {
 	struct mutex lock;
 	struct device *dev;
 	struct i2c_client *i2c;
 	struct irq_domain *domain;
-
-	int irq_base;
 	int num_gpio;
 	struct tc3589x_platform_data *pdata;
 };
@@ -165,13 +162,10 @@ struct tc3589x_keypad_platform_data {
 
 /**
  * struct tc3589x_gpio_platform_data - TC3589x GPIO platform data
- * @gpio_base: first gpio number assigned to TC3589x.  A maximum of
- *	       %TC3589x_NR_GPIOS GPIOs will be allocated.
  * @setup: callback for board-specific initialization
  * @remove: callback for board-specific teardown
  */
 struct tc3589x_gpio_platform_data {
-	int gpio_base;
 	void (*setup)(struct tc3589x *tc3589x, unsigned gpio_base);
 	void (*remove)(struct tc3589x *tc3589x, unsigned gpio_base);
 };
@@ -179,18 +173,13 @@ struct tc3589x_gpio_platform_data {
 /**
  * struct tc3589x_platform_data - TC3589x platform data
  * @block: bitmask of blocks to enable (use TC3589x_BLOCK_*)
- * @irq_base: base IRQ number.  %TC3589x_NR_IRQS irqs will be used.
  * @gpio: GPIO-specific platform data
  * @keypad: keypad-specific platform data
  */
 struct tc3589x_platform_data {
 	unsigned int block;
-	int irq_base;
 	struct tc3589x_gpio_platform_data *gpio;
 	const struct tc3589x_keypad_platform_data *keypad;
 };
 
-#define TC3589x_NR_GPIOS	24
-#define TC3589x_NR_IRQS		TC3589x_INT_GPIO(TC3589x_NR_GPIOS)
-
 #endif
-- 
1.9.0

