Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933714Ab3BLSVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:21:08 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59464 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933479Ab3BLSTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:19:20 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH V2 3/3] gpio: Make of_count_named_gpios() use new of_count_phandle_with_args()
Date: Tue, 12 Feb 2013 17:59:41 +0000
Message-Id: <1360691981-21837-3-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360691981-21837-1-git-send-email-grant.likely@secretlab.ca>
References: <1360691981-21837-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the horribly coded of_count_named_gpios() with a
call to of_count_phandle_with_args() which is far more efficient. This
also changes the return value of of_gpio_count() & of_gpio_named_count()
from 'unsigned int' to 'int' so that it can return an error code. All
the users of that function are fixed up to correctly handle a negative
return value.

v2: Split GPIO portion into a separate patch

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Andreas Larsson <andreas@gaisler.com>
---
 drivers/gpio/gpiolib-of.c              |   35 ----------------------------
 drivers/hwmon/gpio-fan.c               |    4 ++--
 drivers/input/keyboard/matrix_keypad.c |    8 +++----
 drivers/net/phy/mdio-mux-gpio.c        |    4 ++--
 drivers/spi/spi-fsl-spi.c              |    4 ++--
 drivers/spi/spi-oc-tiny.c              |    8 +++----
 drivers/spi/spi-ppc4xx.c               |    4 ++--
 drivers/spi/spi.c                      |    5 ++--
 include/linux/of_gpio.h                |   40 ++++++++++++++++++--------------
 9 files changed, 41 insertions(+), 71 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index d542a14..dd8a212 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -89,41 +89,6 @@ int of_get_named_gpio_flags(struct device_node *np, const char *propname,
 EXPORT_SYMBOL(of_get_named_gpio_flags);
 
 /**
- * of_gpio_named_count - Count GPIOs for a device
- * @np:		device node to count GPIOs for
- * @propname:	property name containing gpio specifier(s)
- *
- * The function returns the count of GPIOs specified for a node.
- *
- * Note that the empty GPIO specifiers counts too. For example,
- *
- * gpios = <0
- *          &pio1 1 2
- *          0
- *          &pio2 3 4>;
- *
- * defines four GPIOs (so this function will return 4), two of which
- * are not specified.
- */
-unsigned int of_gpio_named_count(struct device_node *np, const char* propname)
-{
-	unsigned int cnt = 0;
-
-	do {
-		int ret;
-
-		ret = of_parse_phandle_with_args(np, propname, "#gpio-cells",
-						 cnt, NULL);
-		/* A hole in the gpios = <> counts anyway. */
-		if (ret < 0 && ret != -EEXIST)
-			break;
-	} while (++cnt);
-
-	return cnt;
-}
-EXPORT_SYMBOL(of_gpio_named_count);
-
-/**
  * of_gpio_simple_xlate - translate gpio_spec to the GPIO number and flags
  * @gc:		pointer to the gpio_chip structure
  * @np:		device node of the GPIO chip
diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 4e04c12..3978194 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -422,7 +422,7 @@ static int gpio_fan_get_of_pdata(struct device *dev,
 
 	/* Fill GPIO pin array */
 	pdata->num_ctrl = of_gpio_count(node);
-	if (!pdata->num_ctrl) {
+	if (pdata->num_ctrl <= 0) {
 		dev_err(dev, "gpios DT property empty / missing");
 		return -ENODEV;
 	}
@@ -477,7 +477,7 @@ static int gpio_fan_get_of_pdata(struct device *dev,
 	pdata->speed = speed;
 
 	/* Alarm GPIO if one exists */
-	if (of_gpio_named_count(node, "alarm-gpios")) {
+	if (of_gpio_named_count(node, "alarm-gpios") > 0) {
 		struct gpio_fan_alarm *alarm;
 		int val;
 		enum of_gpio_flags flags;
diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index f4ff0dd..71d7719 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -403,7 +403,7 @@ matrix_keypad_parse_dt(struct device *dev)
 	struct matrix_keypad_platform_data *pdata;
 	struct device_node *np = dev->of_node;
 	unsigned int *gpios;
-	int i;
+	int i, nrow, ncol;
 
 	if (!np) {
 		dev_err(dev, "device lacks DT data\n");
@@ -416,9 +416,9 @@ matrix_keypad_parse_dt(struct device *dev)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	pdata->num_row_gpios = of_gpio_named_count(np, "row-gpios");
-	pdata->num_col_gpios = of_gpio_named_count(np, "col-gpios");
-	if (!pdata->num_row_gpios || !pdata->num_col_gpios) {
+	pdata->num_row_gpios = nrow = of_gpio_named_count(np, "row-gpios");
+	pdata->num_col_gpios = ncol = of_gpio_named_count(np, "col-gpios");
+	if (nrow <= 0 || ncol <= 0) {
 		dev_err(dev, "number of keypad rows/columns not specified\n");
 		return ERR_PTR(-EINVAL);
 	}
diff --git a/drivers/net/phy/mdio-mux-gpio.c b/drivers/net/phy/mdio-mux-gpio.c
index 0c9accb..e91d7d7 100644
--- a/drivers/net/phy/mdio-mux-gpio.c
+++ b/drivers/net/phy/mdio-mux-gpio.c
@@ -53,7 +53,7 @@ static int mdio_mux_gpio_probe(struct platform_device *pdev)
 {
 	enum of_gpio_flags f;
 	struct mdio_mux_gpio_state *s;
-	unsigned int num_gpios;
+	int num_gpios;
 	unsigned int n;
 	int r;
 
@@ -61,7 +61,7 @@ static int mdio_mux_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	num_gpios = of_gpio_count(pdev->dev.of_node);
-	if (num_gpios == 0 || num_gpios > MDIO_MUX_GPIO_MAX_BITS)
+	if (num_gpios <= 0 || num_gpios > MDIO_MUX_GPIO_MAX_BITS)
 		return -ENODEV;
 
 	s = devm_kzalloc(&pdev->dev, sizeof(*s), GFP_KERNEL);
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 1a7f635..086a9ee 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -947,12 +947,12 @@ static int of_fsl_spi_get_chipselects(struct device *dev)
 	struct device_node *np = dev->of_node;
 	struct fsl_spi_platform_data *pdata = dev->platform_data;
 	struct mpc8xxx_spi_probe_info *pinfo = to_of_pinfo(pdata);
-	unsigned int ngpios;
+	int ngpios;
 	int i = 0;
 	int ret;
 
 	ngpios = of_gpio_count(np);
-	if (!ngpios) {
+	if (ngpios <= 0) {
 		/*
 		 * SPI w/o chip-select line. One SPI device is still permitted
 		 * though.
diff --git a/drivers/spi/spi-oc-tiny.c b/drivers/spi/spi-oc-tiny.c
index 432e66e..cb2e284 100644
--- a/drivers/spi/spi-oc-tiny.c
+++ b/drivers/spi/spi-oc-tiny.c
@@ -54,7 +54,7 @@ struct tiny_spi {
 	unsigned int txc, rxc;
 	const u8 *txp;
 	u8 *rxp;
-	unsigned int gpio_cs_count;
+	int gpio_cs_count;
 	int *gpio_cs;
 };
 
@@ -74,7 +74,7 @@ static void tiny_spi_chipselect(struct spi_device *spi, int is_active)
 {
 	struct tiny_spi *hw = tiny_spi_to_hw(spi);
 
-	if (hw->gpio_cs_count) {
+	if (hw->gpio_cs_count > 0) {
 		gpio_set_value(hw->gpio_cs[spi->chip_select],
 			(spi->mode & SPI_CS_HIGH) ? is_active : !is_active);
 	}
@@ -254,7 +254,7 @@ static int tiny_spi_of_probe(struct platform_device *pdev)
 	if (!np)
 		return 0;
 	hw->gpio_cs_count = of_gpio_count(np);
-	if (hw->gpio_cs_count) {
+	if (hw->gpio_cs_count > 0) {
 		hw->gpio_cs = devm_kzalloc(&pdev->dev,
 				hw->gpio_cs_count * sizeof(unsigned int),
 				GFP_KERNEL);
@@ -352,7 +352,7 @@ static int tiny_spi_probe(struct platform_device *pdev)
 			goto exit_gpio;
 		gpio_direction_output(hw->gpio_cs[i], 1);
 	}
-	hw->bitbang.master->num_chipselect = max(1U, hw->gpio_cs_count);
+	hw->bitbang.master->num_chipselect = max(1, hw->gpio_cs_count);
 
 	/* register our spi controller */
 	err = spi_bitbang_start(&hw->bitbang);
diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index 7a85f22..af3e6e7 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -419,7 +419,7 @@ static int __init spi_ppc4xx_of_probe(struct platform_device *op)
 	 * This includes both "null" gpio's and real ones.
 	 */
 	num_gpios = of_gpio_count(np);
-	if (num_gpios) {
+	if (num_gpios > 0) {
 		int i;
 
 		hw->gpios = kzalloc(sizeof(int) * num_gpios, GFP_KERNEL);
@@ -471,7 +471,7 @@ static int __init spi_ppc4xx_of_probe(struct platform_device *op)
 		SPI_CPHA | SPI_CPOL | SPI_CS_HIGH | SPI_LSB_FIRST;
 
 	/* this many pins in all GPIO controllers */
-	bbp->master->num_chipselect = num_gpios;
+	bbp->master->num_chipselect = num_gpios > 0 ? num_gpios : 0;
 
 	/* Get the clock for the OPB */
 	opbnp = of_find_compatible_node(NULL, NULL, "ibm,opb");
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 19ee901..21c4748 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1059,15 +1059,14 @@ EXPORT_SYMBOL_GPL(spi_alloc_master);
 #ifdef CONFIG_OF
 static int of_spi_register_master(struct spi_master *master)
 {
-	u16 nb;
-	int i, *cs;
+	int nb, i, *cs;
 	struct device_node *np = master->dev.of_node;
 
 	if (!np)
 		return 0;
 
 	nb = of_gpio_named_count(np, "cs-gpios");
-	master->num_chipselect = max(nb, master->num_chipselect);
+	master->num_chipselect = max(nb, (int)master->num_chipselect);
 
 	if (nb < 1)
 		return 0;
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index c454f57..a83dc6f 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -50,9 +50,6 @@ static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
 extern int of_get_named_gpio_flags(struct device_node *np,
 		const char *list_name, int index, enum of_gpio_flags *flags);
 
-extern unsigned int of_gpio_named_count(struct device_node *np,
-					const char* propname);
-
 extern int of_mm_gpiochip_add(struct device_node *np,
 			      struct of_mm_gpio_chip *mm_gc);
 
@@ -71,12 +68,6 @@ static inline int of_get_named_gpio_flags(struct device_node *np,
 	return -ENOSYS;
 }
 
-static inline unsigned int of_gpio_named_count(struct device_node *np,
-					const char* propname)
-{
-	return 0;
-}
-
 static inline int of_gpio_simple_xlate(struct gpio_chip *gc,
 				       const struct of_phandle_args *gpiospec,
 				       u32 *flags)
@@ -90,22 +81,37 @@ static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
 #endif /* CONFIG_OF_GPIO */
 
 /**
- * of_gpio_count - Count GPIOs for a device
+ * of_gpio_named_count() - Count GPIOs for a device
  * @np:		device node to count GPIOs for
+ * @propname:	property name containing gpio specifier(s)
  *
  * The function returns the count of GPIOs specified for a node.
+ * Note that the empty GPIO specifiers count too. Returns either
+ *   Number of gpios defined in property,
+ *   -EINVAL for an incorrectly formed gpios property, or
+ *   -ENOENT for a missing gpios property
  *
- * Note that the empty GPIO specifiers counts too. For example,
- *
+ * Example:
  * gpios = <0
- *          &pio1 1 2
+ *          &gpio1 1 2
  *          0
- *          &pio2 3 4>;
+ *          &gpio2 3 4>;
+ *
+ * The above example defines four GPIOs, two of which are not specified.
+ * This function will return '4'
+ */
+static inline int of_gpio_named_count(struct device_node *np, const char* propname)
+{
+	return of_count_phandle_with_args(np, propname, "#gpio-cells");
+}
+
+/**
+ * of_gpio_count() - Count GPIOs for a device
+ * @np:		device node to count GPIOs for
  *
- * defines four GPIOs (so this function will return 4), two of which
- * are not specified.
+ * Same as of_gpio_named_count, but hard coded to use the 'gpios' property
  */
-static inline unsigned int of_gpio_count(struct device_node *np)
+static inline int of_gpio_count(struct device_node *np)
 {
 	return of_gpio_named_count(np, "gpios");
 }
-- 
1.7.10.4

