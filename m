Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3BJX6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 18:58:33 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:61263 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab3BJX6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 18:58:31 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Andreas Larsson <andreas@gaisler.com>
Subject: [PATCH] of: Create function for counting number of phandles in a property
Date: Sun, 10 Feb 2013 23:58:21 +0000
Message-Id: <1360540701-23439-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates of_count_phandle_with_args(), a new function for
counting the number of phandle+argument tuples in a given property. This
is better than the existing method of parsing each phandle individually
until parsing fails which is a horribly slow way to do the count.

It also converts of_gpio_named_count() to use the new function instead
of using the above described horrible method.

This also requires the return value of of_gpio_count() &
of_gpio_named_count() from 'unsigned int' to 'int' so that it can return
an error code. All the users of that function are fixed up to correctly
handle a negative return value.

Tested on ARM using the selftest code.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Andreas Larsson <andreas@gaisler.com>
---
 drivers/gpio/gpiolib-of.c              |   35 ---------------------
 drivers/hwmon/gpio-fan.c               |    4 +--
 drivers/input/keyboard/matrix_keypad.c |    8 ++---
 drivers/net/phy/mdio-mux-gpio.c        |    4 +--
 drivers/of/base.c                      |   54 +++++++++++++++++++++++++++-----
 drivers/of/selftest.c                  |   23 +++++++++++++-
 drivers/spi/spi-fsl-spi.c              |    4 +--
 drivers/spi/spi-oc-tiny.c              |    8 ++---
 drivers/spi/spi-ppc4xx.c               |    4 +--
 include/linux/of.h                     |    9 ++++++
 include/linux/of_gpio.h                |   30 +++++++++++++++---
 11 files changed, 118 insertions(+), 65 deletions(-)

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
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 2390ddb..e1120a2 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1025,12 +1025,13 @@ EXPORT_SYMBOL(of_parse_phandle);
  * To get a device_node of the `node2' node you may call this:
  * of_parse_phandle_with_args(node3, "list", "#list-cells", 1, &args);
  */
-int of_parse_phandle_with_args(const struct device_node *np, const char *list_name,
-				const char *cells_name, int index,
-				struct of_phandle_args *out_args)
+static int __of_parse_phandle_with_args(const struct device_node *np,
+					const char *list_name,
+					const char *cells_name, int index,
+					struct of_phandle_args *out_args)
 {
 	const __be32 *list, *list_end;
-	int size, cur_index = 0;
+	int rc = 0, size, cur_index = 0;
 	uint32_t count = 0;
 	struct device_node *node = NULL;
 	phandle phandle;
@@ -1059,12 +1060,14 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 			if (!node) {
 				pr_err("%s: could not find phandle\n",
 					 np->full_name);
+				rc = -EINVAL;
 				break;
 			}
 			if (of_property_read_u32(node, cells_name, &count)) {
 				pr_err("%s: could not get %s for %s\n",
 					 np->full_name, cells_name,
 					 node->full_name);
+				rc = -EINVAL;
 				break;
 			}
 
@@ -1075,6 +1078,7 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 			if (list + count > list_end) {
 				pr_err("%s: arguments longer than property\n",
 					 np->full_name);
+				rc = -EINVAL;
 				break;
 			}
 		}
@@ -1086,8 +1090,10 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 		 * or return -ENOENT for an empty entry.
 		 */
 		if (cur_index == index) {
-			if (!phandle)
-				return -ENOENT;
+			if (!phandle) {
+				rc = -ENOENT;
+				break;
+			}
 
 			if (out_args) {
 				int i;
@@ -1098,22 +1104,54 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 				for (i = 0; i < count; i++)
 					out_args->args[i] = be32_to_cpup(list++);
 			}
-			return 0;
+
+			rc = 0;
+			break;
 		}
 
 		of_node_put(node);
 		node = NULL;
 		list += count;
 		cur_index++;
+		rc = cur_index;
 	}
 
 	/* Loop exited without finding a valid entry; return an error */
 	if (node)
 		of_node_put(node);
-	return -EINVAL;
+	return rc;
+}
+
+int of_parse_phandle_with_args(const struct device_node *np, const char *list_name,
+				const char *cells_name, int index,
+				struct of_phandle_args *out_args)
+{
+	return __of_parse_phandle_with_args(np, list_name, cells_name, index, out_args);
 }
 EXPORT_SYMBOL(of_parse_phandle_with_args);
 
+/**
+ * of_count_phandle_with_args() - Find the number of phandles references in a property
+ * @np:		pointer to a device tree node containing a list
+ * @list_name:	property name that contains a list
+ * @cells_name:	property name that specifies phandles' arguments count
+ *
+ * Returns the number of phandle + argument tuples within a property. It
+ * is a typical pattern to encode a list of phandle and variable
+ * arguments into a single property. The number of arguments is encoded
+ * by a property in the phandle-target node. For example, a gpios
+ * property would contain a list of GPIO specifies consisting of a
+ * phandle and 1 or more arguments. The number of arguments are
+ * determined by the #gpio-cells property in the node pointed to by the
+ * phandle.
+ */
+int of_count_phandle_with_args(const struct device_node *np, const char *list_name,
+				const char *cells_name)
+{
+	return __of_parse_phandle_with_args(np, list_name, cells_name, -1, NULL);
+}
+EXPORT_SYMBOL(of_count_phandle_with_args);
+
 #if defined(CONFIG_OF_DYNAMIC)
 static int of_property_notify(int action, struct device_node *np,
 			      struct property *prop)
diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index f24ffd7..e3a03d5 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -35,6 +35,11 @@ static void __init of_selftest_parse_phandle_with_args(void)
 		return;
 	}
 
+	rc = of_count_phandle_with_args(np, "phandle-list", "#phandle-cells");
+	if (rc != 7)
+		pr_err("of_count_phandle_with_args() returned %i, expected 7\n", rc);
+	passed_all &= (rc == 7);
+
 	for (i = 0; i < 7; i++) {
 		bool passed = true;
 		rc = of_parse_phandle_with_args(np, "phandle-list",
@@ -100,22 +105,38 @@ static void __init of_selftest_parse_phandle_with_args(void)
 	/* Check for missing list property */
 	rc = of_parse_phandle_with_args(np, "phandle-list-missing",
 					"#phandle-cells", 0, &args);
-	passed_all &= (rc == -EINVAL);
+	passed_all &= (rc == -ENOENT);
+	rc = of_count_phandle_with_args(np, "phandle-list-missing",
+					"#phandle-cells");
+	passed_all &= (rc == -ENOENT);
+	pr_err("rc = %i\n", rc);
 
 	/* Check for missing cells property */
 	rc = of_parse_phandle_with_args(np, "phandle-list",
 					"#phandle-cells-missing", 0, &args);
 	passed_all &= (rc == -EINVAL);
+	rc = of_count_phandle_with_args(np, "phandle-list",
+					"#phandle-cells-missing");
+	passed_all &= (rc == -EINVAL);
+	pr_err("rc = %i\n", rc);
 
 	/* Check for bad phandle in list */
 	rc = of_parse_phandle_with_args(np, "phandle-list-bad-phandle",
 					"#phandle-cells", 0, &args);
 	passed_all &= (rc == -EINVAL);
+	rc = of_count_phandle_with_args(np, "phandle-list-bad-phandle",
+					"#phandle-cells");
+	passed_all &= (rc == -EINVAL);
+	pr_err("rc = %i\n", rc);
 
 	/* Check for incorrectly formed argument list */
 	rc = of_parse_phandle_with_args(np, "phandle-list-bad-args",
 					"#phandle-cells", 1, &args);
 	passed_all &= (rc == -EINVAL);
+	rc = of_count_phandle_with_args(np, "phandle-list-bad-args",
+					"#phandle-cells");
+	passed_all &= (rc == -EINVAL);
+	pr_err("rc = %i\n", rc);
 
 	pr_info("end - %s\n", passed_all ? "PASS" : "FAIL");
 }
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
diff --git a/include/linux/of.h b/include/linux/of.h
index 5ebcc5c..fabc610 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -277,6 +277,8 @@ extern struct device_node *of_parse_phandle(const struct device_node *np,
 extern int of_parse_phandle_with_args(const struct device_node *np,
 	const char *list_name, const char *cells_name, int index,
 	struct of_phandle_args *out_args);
+extern int of_count_phandle_with_args(const struct device_node *np,
+	const char *list_name, const char *cells_name);
 
 extern void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align));
 extern int of_alias_get_id(struct device_node *np, const char *stem);
@@ -467,6 +469,13 @@ static inline int of_parse_phandle_with_args(struct device_node *np,
 	return -ENOSYS;
 }
 
+static inline int of_parse_count_with_args(struct device_node *np,
+					   const char *list_name,
+					   const char *cells_name)
+{
+	return -ENOSYS;
+}
+
 static inline int of_alias_get_id(struct device_node *np, const char *stem)
 {
 	return -ENOSYS;
diff --git a/include/linux/of_gpio.h b/include/linux/of_gpio.h
index c454f57..bdbe0f3 100644
--- a/include/linux/of_gpio.h
+++ b/include/linux/of_gpio.h
@@ -50,8 +50,28 @@ static inline struct of_mm_gpio_chip *to_of_mm_gpio_chip(struct gpio_chip *gc)
 extern int of_get_named_gpio_flags(struct device_node *np,
 		const char *list_name, int index, enum of_gpio_flags *flags);
 
-extern unsigned int of_gpio_named_count(struct device_node *np,
-					const char* propname);
+/**
+ * of_gpio_named_count - Count GPIOs for a device
+ * @np:		device node to count GPIOs for
+ * @propname:	property name containing gpio specifier(s)
+ *
+ * The function returns the count of GPIOs specified for a node.
+ *
+ * Note that the empty GPIO specifiers counts too. For example,
+ *
+ * gpios = <0
+ *          &pio1 1 2
+ *          0
+ *          &pio2 3 4>;
+ *
+ * defines four GPIOs (so this function will return 4), two of which
+ * are not specified. Returns -EINVAL for an incorrectly formed gpios
+ * property.
+ */
+static int of_gpio_named_count(struct device_node *np, const char* propname)
+{
+	return of_count_phandle_with_args(np, propname, "#gpio-cells");
+}
 
 extern int of_mm_gpiochip_add(struct device_node *np,
 			      struct of_mm_gpio_chip *mm_gc);
@@ -71,10 +91,10 @@ static inline int of_get_named_gpio_flags(struct device_node *np,
 	return -ENOSYS;
 }
 
-static inline unsigned int of_gpio_named_count(struct device_node *np,
+static inline int of_gpio_named_count(struct device_node *np,
 					const char* propname)
 {
-	return 0;
+	return -ENOSYS;
 }
 
 static inline int of_gpio_simple_xlate(struct gpio_chip *gc,
@@ -105,7 +125,7 @@ static inline void of_gpiochip_remove(struct gpio_chip *gc) { }
  * defines four GPIOs (so this function will return 4), two of which
  * are not specified.
  */
-static inline unsigned int of_gpio_count(struct device_node *np)
+static inline int of_gpio_count(struct device_node *np)
 {
 	return of_gpio_named_count(np, "gpios");
 }
-- 
1.7.10.4

