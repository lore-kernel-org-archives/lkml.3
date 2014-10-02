Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbaJBSwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:52:54 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:52103 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaJBSwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:52:25 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v2 4/5] pinctrl: samsung: Constify samsung_pin_ctrl struct
Date: Thu,  2 Oct 2014 20:52:10 +0200
Message-Id: <1412275931-10807-5-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412275931-10807-1-git-send-email-tomasz.figa@gmail.com>
References: <1412275931-10807-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to separate initialization constants from runtime data, this
patch modifies the driver to store only constant data in
samsung_pin_ctrl struct and copy data required at runtime to
samsung_pinctrl_drv_data struct. This makes it possible to mark all
existing instances of samsung_pin_ctrl struct as const and __initconst.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Tested by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/pinctrl/samsung/pinctrl-exynos.c  | 39 +++++++-------
 drivers/pinctrl/samsung/pinctrl-s3c24xx.c | 12 ++---
 drivers/pinctrl/samsung/pinctrl-s3c64xx.c | 14 ++---
 drivers/pinctrl/samsung/pinctrl-samsung.c | 86 +++++++++++++++----------------
 drivers/pinctrl/samsung/pinctrl-samsung.h | 40 +++++++-------
 5 files changed, 96 insertions(+), 95 deletions(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index 0f46391df3ea..4659a1abc862 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -222,8 +222,7 @@ static const struct irq_domain_ops exynos_gpio_irqd_ops = {
 static irqreturn_t exynos_eint_gpio_irq(int irq, void *data)
 {
 	struct samsung_pinctrl_drv_data *d = data;
-	struct samsung_pin_ctrl *ctrl = d->ctrl;
-	struct samsung_pin_bank *bank = ctrl->pin_banks;
+	struct samsung_pin_bank *bank = d->pin_banks;
 	unsigned int svc, group, pin, virq;
 
 	svc = readl(d->virt_base + EXYNOS_SVC_OFFSET);
@@ -270,8 +269,8 @@ static int exynos_eint_gpio_init(struct samsung_pinctrl_drv_data *d)
 		return -ENXIO;
 	}
 
-	bank = d->ctrl->pin_banks;
-	for (i = 0; i < d->ctrl->nr_banks; ++i, ++bank) {
+	bank = d->pin_banks;
+	for (i = 0; i < d->nr_banks; ++i, ++bank) {
 		if (bank->eint_type != EINT_TYPE_GPIO)
 			continue;
 		bank->irq_domain = irq_domain_add_linear(bank->of_node,
@@ -441,8 +440,8 @@ static int exynos_eint_wkup_init(struct samsung_pinctrl_drv_data *d)
 	if (!wkup_np)
 		return -ENODEV;
 
-	bank = d->ctrl->pin_banks;
-	for (i = 0; i < d->ctrl->nr_banks; ++i, ++bank) {
+	bank = d->pin_banks;
+	for (i = 0; i < d->nr_banks; ++i, ++bank) {
 		if (bank->eint_type != EINT_TYPE_WKUP)
 			continue;
 
@@ -499,9 +498,9 @@ static int exynos_eint_wkup_init(struct samsung_pinctrl_drv_data *d)
 	irq_set_chained_handler(irq, exynos_irq_demux_eint16_31);
 	irq_set_handler_data(irq, muxed_data);
 
-	bank = d->ctrl->pin_banks;
+	bank = d->pin_banks;
 	idx = 0;
-	for (i = 0; i < d->ctrl->nr_banks; ++i, ++bank) {
+	for (i = 0; i < d->nr_banks; ++i, ++bank) {
 		if (bank->eint_type != EINT_TYPE_WKUP_MUX)
 			continue;
 
@@ -533,11 +532,10 @@ static void exynos_pinctrl_suspend_bank(
 
 static void exynos_pinctrl_suspend(struct samsung_pinctrl_drv_data *drvdata)
 {
-	struct samsung_pin_ctrl *ctrl = drvdata->ctrl;
-	struct samsung_pin_bank *bank = ctrl->pin_banks;
+	struct samsung_pin_bank *bank = drvdata->pin_banks;
 	int i;
 
-	for (i = 0; i < ctrl->nr_banks; ++i, ++bank)
+	for (i = 0; i < drvdata->nr_banks; ++i, ++bank)
 		if (bank->eint_type == EINT_TYPE_GPIO)
 			exynos_pinctrl_suspend_bank(drvdata, bank);
 }
@@ -569,11 +567,10 @@ static void exynos_pinctrl_resume_bank(
 
 static void exynos_pinctrl_resume(struct samsung_pinctrl_drv_data *drvdata)
 {
-	struct samsung_pin_ctrl *ctrl = drvdata->ctrl;
-	struct samsung_pin_bank *bank = ctrl->pin_banks;
+	struct samsung_pin_bank *bank = drvdata->pin_banks;
 	int i;
 
-	for (i = 0; i < ctrl->nr_banks; ++i, ++bank)
+	for (i = 0; i < drvdata->nr_banks; ++i, ++bank)
 		if (bank->eint_type == EINT_TYPE_GPIO)
 			exynos_pinctrl_resume_bank(drvdata, bank);
 }
@@ -616,7 +613,7 @@ static struct samsung_pin_bank s5pv210_pin_bank[] = {
 	EXYNOS_PIN_BANK_EINTW(8, 0xc60, "gph3", 0x0c),
 };
 
-struct samsung_pin_ctrl s5pv210_pin_ctrl[] = {
+const struct samsung_pin_ctrl s5pv210_pin_ctrl[] __initconst = {
 	{
 		/* pin-controller instance 0 data */
 		.pin_banks	= s5pv210_pin_bank,
@@ -663,7 +660,7 @@ static struct samsung_pin_bank exynos3250_pin_banks1[] = {
  * Samsung pinctrl driver data for Exynos3250 SoC. Exynos3250 SoC includes
  * two gpio/pin-mux/pinconfig controllers.
  */
-struct samsung_pin_ctrl exynos3250_pin_ctrl[] = {
+const struct samsung_pin_ctrl exynos3250_pin_ctrl[] __initconst = {
 	{
 		/* pin-controller instance 0 data */
 		.pin_banks	= exynos3250_pin_banks0,
@@ -735,7 +732,7 @@ static struct samsung_pin_bank exynos4210_pin_banks2[] = {
  * Samsung pinctrl driver data for Exynos4210 SoC. Exynos4210 SoC includes
  * three gpio/pin-mux/pinconfig controllers.
  */
-struct samsung_pin_ctrl exynos4210_pin_ctrl[] = {
+const struct samsung_pin_ctrl exynos4210_pin_ctrl[] __initconst = {
 	{
 		/* pin-controller instance 0 data */
 		.pin_banks	= exynos4210_pin_banks0,
@@ -820,7 +817,7 @@ static struct samsung_pin_bank exynos4x12_pin_banks3[] = {
  * Samsung pinctrl driver data for Exynos4x12 SoC. Exynos4x12 SoC includes
  * four gpio/pin-mux/pinconfig controllers.
  */
-struct samsung_pin_ctrl exynos4x12_pin_ctrl[] = {
+const struct samsung_pin_ctrl exynos4x12_pin_ctrl[] __initconst = {
 	{
 		/* pin-controller instance 0 data */
 		.pin_banks	= exynos4x12_pin_banks0,
@@ -913,7 +910,7 @@ static struct samsung_pin_bank exynos5250_pin_banks3[] = {
  * Samsung pinctrl driver data for Exynos5250 SoC. Exynos5250 SoC includes
  * four gpio/pin-mux/pinconfig controllers.
  */
-struct samsung_pin_ctrl exynos5250_pin_ctrl[] = {
+const struct samsung_pin_ctrl exynos5250_pin_ctrl[] __initconst = {
 	{
 		/* pin-controller instance 0 data */
 		.pin_banks	= exynos5250_pin_banks0,
@@ -990,7 +987,7 @@ static struct samsung_pin_bank exynos5260_pin_banks2[] = {
  * Samsung pinctrl driver data for Exynos5260 SoC. Exynos5260 SoC includes
  * three gpio/pin-mux/pinconfig controllers.
  */
-struct samsung_pin_ctrl exynos5260_pin_ctrl[] = {
+const struct samsung_pin_ctrl exynos5260_pin_ctrl[] __initconst = {
 	{
 		/* pin-controller instance 0 data */
 		.pin_banks	= exynos5260_pin_banks0,
@@ -1070,7 +1067,7 @@ static struct samsung_pin_bank exynos5420_pin_banks4[] = {
  * Samsung pinctrl driver data for Exynos5420 SoC. Exynos5420 SoC includes
  * four gpio/pin-mux/pinconfig controllers.
  */
-struct samsung_pin_ctrl exynos5420_pin_ctrl[] = {
+const struct samsung_pin_ctrl exynos5420_pin_ctrl[] __initconst = {
 	{
 		/* pin-controller instance 0 data */
 		.pin_banks	= exynos5420_pin_banks0,
diff --git a/drivers/pinctrl/samsung/pinctrl-s3c24xx.c b/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
index 9db6cf5c8823..c0c7924657e6 100644
--- a/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
+++ b/drivers/pinctrl/samsung/pinctrl-s3c24xx.c
@@ -518,8 +518,8 @@ static int s3c24xx_eint_init(struct samsung_pinctrl_drv_data *d)
 		irq_set_handler_data(irq, eint_data);
 	}
 
-	bank = d->ctrl->pin_banks;
-	for (i = 0; i < d->ctrl->nr_banks; ++i, ++bank) {
+	bank = d->pin_banks;
+	for (i = 0; i < d->nr_banks; ++i, ++bank) {
 		struct s3c24xx_eint_domain_data *ddata;
 		unsigned int mask;
 		unsigned int irq;
@@ -573,7 +573,7 @@ static struct samsung_pin_bank s3c2412_pin_banks[] = {
 	PIN_BANK_2BIT(13, 0x080, "gpj"),
 };
 
-struct samsung_pin_ctrl s3c2412_pin_ctrl[] = {
+const struct samsung_pin_ctrl s3c2412_pin_ctrl[] __initconst = {
 	{
 		.pin_banks	= s3c2412_pin_banks,
 		.nr_banks	= ARRAY_SIZE(s3c2412_pin_banks),
@@ -595,7 +595,7 @@ static struct samsung_pin_bank s3c2416_pin_banks[] = {
 	PIN_BANK_2BIT(2, 0x100, "gpm"),
 };
 
-struct samsung_pin_ctrl s3c2416_pin_ctrl[] = {
+const struct samsung_pin_ctrl s3c2416_pin_ctrl[] __initconst = {
 	{
 		.pin_banks	= s3c2416_pin_banks,
 		.nr_banks	= ARRAY_SIZE(s3c2416_pin_banks),
@@ -615,7 +615,7 @@ static struct samsung_pin_bank s3c2440_pin_banks[] = {
 	PIN_BANK_2BIT(13, 0x0d0, "gpj"),
 };
 
-struct samsung_pin_ctrl s3c2440_pin_ctrl[] = {
+const struct samsung_pin_ctrl s3c2440_pin_ctrl[] __initconst = {
 	{
 		.pin_banks	= s3c2440_pin_banks,
 		.nr_banks	= ARRAY_SIZE(s3c2440_pin_banks),
@@ -638,7 +638,7 @@ static struct samsung_pin_bank s3c2450_pin_banks[] = {
 	PIN_BANK_2BIT(2, 0x100, "gpm"),
 };
 
-struct samsung_pin_ctrl s3c2450_pin_ctrl[] = {
+const struct samsung_pin_ctrl s3c2450_pin_ctrl[] __initconst = {
 	{
 		.pin_banks	= s3c2450_pin_banks,
 		.nr_banks	= ARRAY_SIZE(s3c2450_pin_banks),
diff --git a/drivers/pinctrl/samsung/pinctrl-s3c64xx.c b/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
index 2a14db2826d8..14c3f9823cc5 100644
--- a/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
+++ b/drivers/pinctrl/samsung/pinctrl-s3c64xx.c
@@ -468,8 +468,8 @@ static int s3c64xx_eint_gpio_init(struct samsung_pinctrl_drv_data *d)
 	}
 
 	nr_domains = 0;
-	bank = d->ctrl->pin_banks;
-	for (i = 0; i < d->ctrl->nr_banks; ++i, ++bank) {
+	bank = d->pin_banks;
+	for (i = 0; i < d->nr_banks; ++i, ++bank) {
 		unsigned int nr_eints;
 		unsigned int mask;
 
@@ -497,9 +497,9 @@ static int s3c64xx_eint_gpio_init(struct samsung_pinctrl_drv_data *d)
 	}
 	data->drvdata = d;
 
-	bank = d->ctrl->pin_banks;
+	bank = d->pin_banks;
 	nr_domains = 0;
-	for (i = 0; i < d->ctrl->nr_banks; ++i, ++bank) {
+	for (i = 0; i < d->nr_banks; ++i, ++bank) {
 		if (bank->eint_type != EINT_TYPE_GPIO)
 			continue;
 
@@ -735,8 +735,8 @@ static int s3c64xx_eint_eint0_init(struct samsung_pinctrl_drv_data *d)
 		irq_set_handler_data(irq, data);
 	}
 
-	bank = d->ctrl->pin_banks;
-	for (i = 0; i < d->ctrl->nr_banks; ++i, ++bank) {
+	bank = d->pin_banks;
+	for (i = 0; i < d->nr_banks; ++i, ++bank) {
 		struct s3c64xx_eint0_domain_data *ddata;
 		unsigned int nr_eints;
 		unsigned int mask;
@@ -804,7 +804,7 @@ static struct samsung_pin_bank s3c64xx_pin_banks0[] = {
  * Samsung pinctrl driver data for S3C64xx SoC. S3C64xx SoC includes
  * one gpio/pin-mux/pinconfig controller.
  */
-struct samsung_pin_ctrl s3c64xx_pin_ctrl[] = {
+const struct samsung_pin_ctrl s3c64xx_pin_ctrl[] __initconst = {
 	{
 		/* pin-controller instance 1 data */
 		.pin_banks	= s3c64xx_pin_banks0,
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.c b/drivers/pinctrl/samsung/pinctrl-samsung.c
index b8edc901fe08..e46fd0a25de7 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.c
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.c
@@ -349,7 +349,7 @@ static void pin_to_reg_bank(struct samsung_pinctrl_drv_data *drvdata,
 {
 	struct samsung_pin_bank *b;
 
-	b = drvdata->ctrl->pin_banks;
+	b = drvdata->pin_banks;
 
 	while ((pin >= b->pin_base) &&
 			((b->pin_base + b->nr_pins - 1) < pin))
@@ -378,7 +378,7 @@ static void samsung_pinmux_setup(struct pinctrl_dev *pctldev, unsigned selector,
 	func = &drvdata->pmx_functions[selector];
 	grp = &drvdata->pin_groups[group];
 
-	pin_to_reg_bank(drvdata, grp->pins[0] - drvdata->ctrl->base,
+	pin_to_reg_bank(drvdata, grp->pins[0] - drvdata->pin_base,
 			&reg, &pin_offset, &bank);
 	type = bank->type;
 	mask = (1 << type->fld_width[PINCFG_TYPE_FUNC]) - 1;
@@ -431,7 +431,7 @@ static int samsung_pinconf_rw(struct pinctrl_dev *pctldev, unsigned int pin,
 	unsigned long flags;
 
 	drvdata = pinctrl_dev_get_drvdata(pctldev);
-	pin_to_reg_bank(drvdata, pin - drvdata->ctrl->base, &reg_base,
+	pin_to_reg_bank(drvdata, pin - drvdata->pin_base, &reg_base,
 					&pin_offset, &bank);
 	type = bank->type;
 
@@ -834,32 +834,32 @@ static int samsung_pinctrl_register(struct platform_device *pdev,
 	ctrldesc->confops = &samsung_pinconf_ops;
 
 	pindesc = devm_kzalloc(&pdev->dev, sizeof(*pindesc) *
-			drvdata->ctrl->nr_pins, GFP_KERNEL);
+			drvdata->nr_pins, GFP_KERNEL);
 	if (!pindesc) {
 		dev_err(&pdev->dev, "mem alloc for pin descriptors failed\n");
 		return -ENOMEM;
 	}
 	ctrldesc->pins = pindesc;
-	ctrldesc->npins = drvdata->ctrl->nr_pins;
+	ctrldesc->npins = drvdata->nr_pins;
 
 	/* dynamically populate the pin number and pin name for pindesc */
 	for (pin = 0, pdesc = pindesc; pin < ctrldesc->npins; pin++, pdesc++)
-		pdesc->number = pin + drvdata->ctrl->base;
+		pdesc->number = pin + drvdata->pin_base;
 
 	/*
 	 * allocate space for storing the dynamically generated names for all
 	 * the pins which belong to this pin-controller.
 	 */
 	pin_names = devm_kzalloc(&pdev->dev, sizeof(char) * PIN_NAME_LENGTH *
-					drvdata->ctrl->nr_pins, GFP_KERNEL);
+					drvdata->nr_pins, GFP_KERNEL);
 	if (!pin_names) {
 		dev_err(&pdev->dev, "mem alloc for pin names failed\n");
 		return -ENOMEM;
 	}
 
 	/* for each pin, the name of the pin is pin-bank name + pin number */
-	for (bank = 0; bank < drvdata->ctrl->nr_banks; bank++) {
-		pin_bank = &drvdata->ctrl->pin_banks[bank];
+	for (bank = 0; bank < drvdata->nr_banks; bank++) {
+		pin_bank = &drvdata->pin_banks[bank];
 		for (pin = 0; pin < pin_bank->nr_pins; pin++) {
 			sprintf(pin_names, "%s-%d", pin_bank->name, pin);
 			pdesc = pindesc + pin_bank->pin_base + pin;
@@ -878,11 +878,11 @@ static int samsung_pinctrl_register(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-	for (bank = 0; bank < drvdata->ctrl->nr_banks; ++bank) {
-		pin_bank = &drvdata->ctrl->pin_banks[bank];
+	for (bank = 0; bank < drvdata->nr_banks; ++bank) {
+		pin_bank = &drvdata->pin_banks[bank];
 		pin_bank->grange.name = pin_bank->name;
 		pin_bank->grange.id = bank;
-		pin_bank->grange.pin_base = drvdata->ctrl->base
+		pin_bank->grange.pin_base = drvdata->pin_base
 						+ pin_bank->pin_base;
 		pin_bank->grange.base = pin_bank->gpio_chip.base;
 		pin_bank->grange.npins = pin_bank->gpio_chip.ngpio;
@@ -918,17 +918,16 @@ static const struct gpio_chip samsung_gpiolib_chip = {
 static int samsung_gpiolib_register(struct platform_device *pdev,
 				    struct samsung_pinctrl_drv_data *drvdata)
 {
-	struct samsung_pin_ctrl *ctrl = drvdata->ctrl;
-	struct samsung_pin_bank *bank = ctrl->pin_banks;
+	struct samsung_pin_bank *bank = drvdata->pin_banks;
 	struct gpio_chip *gc;
 	int ret;
 	int i;
 
-	for (i = 0; i < ctrl->nr_banks; ++i, ++bank) {
+	for (i = 0; i < drvdata->nr_banks; ++i, ++bank) {
 		bank->gpio_chip = samsung_gpiolib_chip;
 
 		gc = &bank->gpio_chip;
-		gc->base = ctrl->base + bank->pin_base;
+		gc->base = drvdata->pin_base + bank->pin_base;
 		gc->ngpio = bank->nr_pins;
 		gc->dev = &pdev->dev;
 		gc->of_node = bank->of_node;
@@ -956,12 +955,11 @@ fail:
 static int samsung_gpiolib_unregister(struct platform_device *pdev,
 				      struct samsung_pinctrl_drv_data *drvdata)
 {
-	struct samsung_pin_ctrl *ctrl = drvdata->ctrl;
-	struct samsung_pin_bank *bank = ctrl->pin_banks;
+	struct samsung_pin_bank *bank = drvdata->pin_banks;
 	int ret = 0;
 	int i;
 
-	for (i = 0; !ret && i < ctrl->nr_banks; ++i, ++bank)
+	for (i = 0; !ret && i < drvdata->nr_banks; ++i, ++bank)
 		ret = gpiochip_remove(&bank->gpio_chip);
 
 	if (ret)
@@ -973,15 +971,15 @@ static int samsung_gpiolib_unregister(struct platform_device *pdev,
 static const struct of_device_id samsung_pinctrl_dt_match[];
 
 /* retrieve the soc specific data */
-static struct samsung_pin_ctrl *samsung_pinctrl_get_soc_data(
-				struct samsung_pinctrl_drv_data *d,
-				struct platform_device *pdev)
+static const struct samsung_pin_ctrl *
+samsung_pinctrl_get_soc_data(struct samsung_pinctrl_drv_data *d,
+			     struct platform_device *pdev)
 {
 	int id;
 	const struct of_device_id *match;
 	struct device_node *node = pdev->dev.of_node;
 	struct device_node *np;
-	struct samsung_pin_ctrl *ctrl;
+	const struct samsung_pin_ctrl *ctrl;
 	struct samsung_pin_bank *bank;
 	int i;
 
@@ -993,19 +991,24 @@ static struct samsung_pin_ctrl *samsung_pinctrl_get_soc_data(
 	match = of_match_node(samsung_pinctrl_dt_match, node);
 	ctrl = (struct samsung_pin_ctrl *)match->data + id;
 
-	bank = ctrl->pin_banks;
-	for (i = 0; i < ctrl->nr_banks; ++i, ++bank) {
+	d->suspend = ctrl->suspend;
+	d->resume = ctrl->resume;
+	d->pin_banks = ctrl->pin_banks;
+	d->nr_banks = ctrl->nr_banks;
+
+	bank = d->pin_banks;
+	for (i = 0; i < d->nr_banks; ++i, ++bank) {
 		spin_lock_init(&bank->slock);
 		bank->drvdata = d;
-		bank->pin_base = ctrl->nr_pins;
-		ctrl->nr_pins += bank->nr_pins;
+		bank->pin_base = d->nr_pins;
+		d->nr_pins += bank->nr_pins;
 	}
 
 	for_each_child_of_node(node, np) {
 		if (!of_find_property(np, "gpio-controller", NULL))
 			continue;
-		bank = ctrl->pin_banks;
-		for (i = 0; i < ctrl->nr_banks; ++i, ++bank) {
+		bank = d->pin_banks;
+		for (i = 0; i < d->nr_banks; ++i, ++bank) {
 			if (!strcmp(bank->name, np->name)) {
 				bank->of_node = np;
 				break;
@@ -1013,8 +1016,8 @@ static struct samsung_pin_ctrl *samsung_pinctrl_get_soc_data(
 		}
 	}
 
-	ctrl->base = pin_base;
-	pin_base += ctrl->nr_pins;
+	d->pin_base = pin_base;
+	pin_base += d->nr_pins;
 
 	return ctrl;
 }
@@ -1022,8 +1025,8 @@ static struct samsung_pin_ctrl *samsung_pinctrl_get_soc_data(
 static int samsung_pinctrl_probe(struct platform_device *pdev)
 {
 	struct samsung_pinctrl_drv_data *drvdata;
+	const struct samsung_pin_ctrl *ctrl;
 	struct device *dev = &pdev->dev;
-	struct samsung_pin_ctrl *ctrl;
 	struct resource *res;
 	int ret;
 
@@ -1044,7 +1047,6 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "driver data not available\n");
 		return PTR_ERR(ctrl);
 	}
-	drvdata->ctrl = ctrl;
 	drvdata->dev = dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1089,12 +1091,11 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 static void samsung_pinctrl_suspend_dev(
 	struct samsung_pinctrl_drv_data *drvdata)
 {
-	struct samsung_pin_ctrl *ctrl = drvdata->ctrl;
 	void __iomem *virt_base = drvdata->virt_base;
 	int i;
 
-	for (i = 0; i < ctrl->nr_banks; i++) {
-		struct samsung_pin_bank *bank = &ctrl->pin_banks[i];
+	for (i = 0; i < drvdata->nr_banks; i++) {
+		struct samsung_pin_bank *bank = &drvdata->pin_banks[i];
 		void __iomem *reg = virt_base + bank->pctl_offset;
 		const u8 *offs = bank->type->reg_offset;
 		const u8 *widths = bank->type->fld_width;
@@ -1122,8 +1123,8 @@ static void samsung_pinctrl_suspend_dev(
 		}
 	}
 
-	if (ctrl->suspend)
-		ctrl->suspend(drvdata);
+	if (drvdata->suspend)
+		drvdata->suspend(drvdata);
 }
 
 /**
@@ -1136,15 +1137,14 @@ static void samsung_pinctrl_suspend_dev(
  */
 static void samsung_pinctrl_resume_dev(struct samsung_pinctrl_drv_data *drvdata)
 {
-	struct samsung_pin_ctrl *ctrl = drvdata->ctrl;
 	void __iomem *virt_base = drvdata->virt_base;
 	int i;
 
-	if (ctrl->resume)
-		ctrl->resume(drvdata);
+	if (drvdata->resume)
+		drvdata->resume(drvdata);
 
-	for (i = 0; i < ctrl->nr_banks; i++) {
-		struct samsung_pin_bank *bank = &ctrl->pin_banks[i];
+	for (i = 0; i < drvdata->nr_banks; i++) {
+		struct samsung_pin_bank *bank = &drvdata->pin_banks[i];
 		void __iomem *reg = virt_base + bank->pctl_offset;
 		const u8 *offs = bank->type->reg_offset;
 		const u8 *widths = bank->type->fld_width;
diff --git a/drivers/pinctrl/samsung/pinctrl-samsung.h b/drivers/pinctrl/samsung/pinctrl-samsung.h
index b4f7a8dd8dcb..1288d7acb2df 100644
--- a/drivers/pinctrl/samsung/pinctrl-samsung.h
+++ b/drivers/pinctrl/samsung/pinctrl-samsung.h
@@ -154,8 +154,6 @@ struct samsung_pin_bank {
  * struct samsung_pin_ctrl: represent a pin controller.
  * @pin_banks: list of pin banks included in this controller.
  * @nr_banks: number of pin banks.
- * @base: starting system wide pin number.
- * @nr_pins: number of pins supported by the controller.
  * @eint_gpio_init: platform specific callback to setup the external gpio
  *	interrupts for the controller.
  * @eint_wkup_init: platform specific callback to setup the external wakeup
@@ -165,9 +163,6 @@ struct samsung_pin_ctrl {
 	struct samsung_pin_bank	*pin_banks;
 	u32		nr_banks;
 
-	u32		base;
-	u32		nr_pins;
-
 	int		(*eint_gpio_init)(struct samsung_pinctrl_drv_data *);
 	int		(*eint_wkup_init)(struct samsung_pinctrl_drv_data *);
 	void		(*suspend)(struct samsung_pinctrl_drv_data *);
@@ -187,6 +182,8 @@ struct samsung_pin_ctrl {
  * @nr_groups: number of such pin groups.
  * @pmx_functions: list of pin functions available to the driver.
  * @nr_function: number of such pin functions.
+ * @pin_base: starting system wide pin number.
+ * @nr_pins: number of pins supported by the controller.
  */
 struct samsung_pinctrl_drv_data {
 	struct list_head		node;
@@ -194,7 +191,6 @@ struct samsung_pinctrl_drv_data {
 	struct device			*dev;
 	int				irq;
 
-	struct samsung_pin_ctrl		*ctrl;
 	struct pinctrl_desc		pctl;
 	struct pinctrl_dev		*pctl_dev;
 
@@ -202,6 +198,14 @@ struct samsung_pinctrl_drv_data {
 	unsigned int			nr_groups;
 	const struct samsung_pmx_func	*pmx_functions;
 	unsigned int			nr_functions;
+
+	struct samsung_pin_bank		*pin_banks;
+	u32				nr_banks;
+	unsigned int			pin_base;
+	unsigned int			nr_pins;
+
+	void (*suspend)(struct samsung_pinctrl_drv_data *);
+	void (*resume)(struct samsung_pinctrl_drv_data *);
 };
 
 /**
@@ -232,17 +236,17 @@ struct samsung_pmx_func {
 };
 
 /* list of all exported SoC specific data */
-extern struct samsung_pin_ctrl exynos3250_pin_ctrl[];
-extern struct samsung_pin_ctrl exynos4210_pin_ctrl[];
-extern struct samsung_pin_ctrl exynos4x12_pin_ctrl[];
-extern struct samsung_pin_ctrl exynos5250_pin_ctrl[];
-extern struct samsung_pin_ctrl exynos5260_pin_ctrl[];
-extern struct samsung_pin_ctrl exynos5420_pin_ctrl[];
-extern struct samsung_pin_ctrl s3c64xx_pin_ctrl[];
-extern struct samsung_pin_ctrl s3c2412_pin_ctrl[];
-extern struct samsung_pin_ctrl s3c2416_pin_ctrl[];
-extern struct samsung_pin_ctrl s3c2440_pin_ctrl[];
-extern struct samsung_pin_ctrl s3c2450_pin_ctrl[];
-extern struct samsung_pin_ctrl s5pv210_pin_ctrl[];
+extern const struct samsung_pin_ctrl exynos3250_pin_ctrl[];
+extern const struct samsung_pin_ctrl exynos4210_pin_ctrl[];
+extern const struct samsung_pin_ctrl exynos4x12_pin_ctrl[];
+extern const struct samsung_pin_ctrl exynos5250_pin_ctrl[];
+extern const struct samsung_pin_ctrl exynos5260_pin_ctrl[];
+extern const struct samsung_pin_ctrl exynos5420_pin_ctrl[];
+extern const struct samsung_pin_ctrl s3c64xx_pin_ctrl[];
+extern const struct samsung_pin_ctrl s3c2412_pin_ctrl[];
+extern const struct samsung_pin_ctrl s3c2416_pin_ctrl[];
+extern const struct samsung_pin_ctrl s3c2440_pin_ctrl[];
+extern const struct samsung_pin_ctrl s3c2450_pin_ctrl[];
+extern const struct samsung_pin_ctrl s5pv210_pin_ctrl[];
 
 #endif /* __PINCTRL_SAMSUNG_H */
-- 
2.1.1

