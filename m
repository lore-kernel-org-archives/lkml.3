Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115Ab3A2Ox4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 09:53:56 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:52253 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755396Ab3A2Oxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:53:53 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v2 2/6] of: Return -ENXIO from of_parse_phandle_with_args for too large index and return errors from of_gpio_named_count
Date: Tue, 29 Jan 2013 15:53:39 +0100
Message-Id: <1359471223-4794-3-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1359471223-4794-1-git-send-email-andreas@gaisler.com>
References: <1359471223-4794-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets of_gpio_named_count return an errno on errors by being able to
distinguish between reaching the end of the phandle list and getting some other
error from of_parse_phandle_with_args.

Return error from of_spi_register_master when there is an "cs-gpios" list for
which gp_gpio_named_count fails.

Adjust various drivers cope with error return from of_gpio_named_count,
including via of_gpio_count.

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
Changes since v1:
- Handle error return values from calls to of_gpio_count

 drivers/gpio/gpiolib-of.c              |    8 +++++---
 drivers/hwmon/gpio-fan.c               |    6 +++---
 drivers/i2c/muxes/i2c-mux-gpio.c       |    3 ++-
 drivers/input/keyboard/matrix_keypad.c |    2 +-
 drivers/net/phy/mdio-mux-gpio.c        |    2 +-
 drivers/of/base.c                      |    5 ++++-
 drivers/spi/spi-fsl-spi.c              |    4 +++-
 drivers/spi/spi-mpc52xx.c              |    5 +++++
 drivers/spi/spi-oc-tiny.c              |    4 +++-
 drivers/spi/spi-ppc4xx.c               |    6 +++++-
 drivers/spi/spi.c                      |   11 +++++++----
 11 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
index d542a14..28f24a6 100644
--- a/drivers/gpio/gpiolib-of.c
+++ b/drivers/gpio/gpiolib-of.c
@@ -107,11 +107,10 @@ EXPORT_SYMBOL(of_get_named_gpio_flags);
  */
 unsigned int of_gpio_named_count(struct device_node *np, const char* propname)
 {
+	int ret;
 	unsigned int cnt = 0;
 
 	do {
-		int ret;
-
 		ret = of_parse_phandle_with_args(np, propname, "#gpio-cells",
 						 cnt, NULL);
 		/* A hole in the gpios = <> counts anyway. */
@@ -119,7 +118,10 @@ unsigned int of_gpio_named_count(struct device_node *np, const char* propname)
 			break;
 	} while (++cnt);
 
-	return cnt;
+	if (ret == -ENXIO)
+		return cnt;
+	else
+		return ret;
 }
 EXPORT_SYMBOL(of_gpio_named_count);
 
diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 4e04c12..9b92d34 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -422,8 +422,8 @@ static int gpio_fan_get_of_pdata(struct device *dev,
 
 	/* Fill GPIO pin array */
 	pdata->num_ctrl = of_gpio_count(node);
-	if (!pdata->num_ctrl) {
-		dev_err(dev, "gpios DT property empty / missing");
+	if (pdata->num_ctrl <= 0) {
+		dev_err(dev, "gpios DT property broken / empty / missing");
 		return -ENODEV;
 	}
 	ctrl = devm_kzalloc(dev, pdata->num_ctrl * sizeof(unsigned),
@@ -477,7 +477,7 @@ static int gpio_fan_get_of_pdata(struct device *dev,
 	pdata->speed = speed;
 
 	/* Alarm GPIO if one exists */
-	if (of_gpio_named_count(node, "alarm-gpios")) {
+	if (of_gpio_named_count(node, "alarm-gpios") > 0) {
 		struct gpio_fan_alarm *alarm;
 		int val;
 		enum of_gpio_flags flags;
diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index 9272743..a3ddb36 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -106,7 +106,8 @@ static int i2c_mux_gpio_probe_dt(struct gpiomux *mux,
 
 	mux->data.n_gpios = of_gpio_named_count(np, "mux-gpios");
 	if (mux->data.n_gpios < 0) {
-		dev_err(&pdev->dev, "Missing mux-gpios property in the DT.\n");
+		dev_err(&pdev->dev,
+			"Missing or broken mux-gpios property in the DT.\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index f4ff0dd..bc7cec5 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -418,7 +418,7 @@ matrix_keypad_parse_dt(struct device *dev)
 
 	pdata->num_row_gpios = of_gpio_named_count(np, "row-gpios");
 	pdata->num_col_gpios = of_gpio_named_count(np, "col-gpios");
-	if (!pdata->num_row_gpios || !pdata->num_col_gpios) {
+	if (pdata->num_row_gpios <= 0 || !pdata->num_col_gpios <= 0) {
 		dev_err(dev, "number of keypad rows/columns not specified\n");
 		return ERR_PTR(-EINVAL);
 	}
diff --git a/drivers/net/phy/mdio-mux-gpio.c b/drivers/net/phy/mdio-mux-gpio.c
index 0c9accb..3e1d285 100644
--- a/drivers/net/phy/mdio-mux-gpio.c
+++ b/drivers/net/phy/mdio-mux-gpio.c
@@ -61,7 +61,7 @@ static int mdio_mux_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	num_gpios = of_gpio_count(pdev->dev.of_node);
-	if (num_gpios == 0 || num_gpios > MDIO_MUX_GPIO_MAX_BITS)
+	if (num_gpios <= 0 || num_gpios > MDIO_MUX_GPIO_MAX_BITS)
 		return -ENODEV;
 
 	s = devm_kzalloc(&pdev->dev, sizeof(*s), GFP_KERNEL);
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 986afd7..1f16629 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1110,7 +1110,10 @@ int of_parse_phandle_with_args(const struct device_node *np, const char *list_na
 	/* Loop exited without finding a valid entry; return an error */
 	if (node)
 		of_node_put(node);
-	return -EINVAL;
+	if (list == list_end)
+		return -ENXIO; /* Index beyond end of list */
+	else
+		return -EINVAL;
 }
 EXPORT_SYMBOL(of_parse_phandle_with_args);
 
diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index 1a7f635..9dcfeed 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -952,13 +952,15 @@ static int of_fsl_spi_get_chipselects(struct device *dev)
 	int ret;
 
 	ngpios = of_gpio_count(np);
-	if (!ngpios) {
+	if (!ngpios || ngpios == -ENOENT) {
 		/*
 		 * SPI w/o chip-select line. One SPI device is still permitted
 		 * though.
 		 */
 		pdata->max_chipselect = 1;
 		return 0;
+	} else if (ngpios < 0) {
+		return ngpios;
 	}
 
 	pinfo->gpios = kmalloc(ngpios * sizeof(*pinfo->gpios), GFP_KERNEL);
diff --git a/drivers/spi/spi-mpc52xx.c b/drivers/spi/spi-mpc52xx.c
index 29f7705..e945195 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -478,6 +478,11 @@ static int mpc52xx_spi_probe(struct platform_device *op)
 			gpio_direction_output(gpio_cs, 1);
 			ms->gpio_cs[i] = gpio_cs;
 		}
+	} else if (ms->gpio_cs_count < 0 && ms->gpio_cs_count != -ENOENT) {
+		dev_err(&op->dev,
+			"could not count the gpio field entries in oftree\n");
+		rc = ms->gpio_cs_count;
+		goto err_alloc_gpio;
 	}
 
 	spin_lock_init(&ms->lock);
diff --git a/drivers/spi/spi-oc-tiny.c b/drivers/spi/spi-oc-tiny.c
index 432e66e..d1a7151 100644
--- a/drivers/spi/spi-oc-tiny.c
+++ b/drivers/spi/spi-oc-tiny.c
@@ -254,12 +254,14 @@ static int tiny_spi_of_probe(struct platform_device *pdev)
 	if (!np)
 		return 0;
 	hw->gpio_cs_count = of_gpio_count(np);
-	if (hw->gpio_cs_count) {
+	if (hw->gpio_cs_count > 0) {
 		hw->gpio_cs = devm_kzalloc(&pdev->dev,
 				hw->gpio_cs_count * sizeof(unsigned int),
 				GFP_KERNEL);
 		if (!hw->gpio_cs)
 			return -ENOMEM;
+	} else if (hw->gpio_cs_count < 0 && hw->gpio_cs_count != -ENOENT) {
+		return hw->gpio_cs_count;
 	}
 	for (i = 0; i < hw->gpio_cs_count; i++) {
 		hw->gpio_cs[i] = of_get_gpio_flags(np, i, NULL);
diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index 7a85f22..b5243c5 100644
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
@@ -454,6 +454,10 @@ static int __init spi_ppc4xx_of_probe(struct platform_device *op)
 				goto free_gpios;
 			}
 		}
+	} else if (num_gpios < 0 && num_gpios != -ENOENT) {
+		dev_err(dev, "could not count gpio field entries\n");
+		ret = num_gpios;
+		goto free_master;
 	}
 
 	/* Setup the state for the bitbang driver */
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 19ee901..9c2acf1 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1059,7 +1059,7 @@ EXPORT_SYMBOL_GPL(spi_alloc_master);
 #ifdef CONFIG_OF
 static int of_spi_register_master(struct spi_master *master)
 {
-	u16 nb;
+	int nb;
 	int i, *cs;
 	struct device_node *np = master->dev.of_node;
 
@@ -1067,10 +1067,13 @@ static int of_spi_register_master(struct spi_master *master)
 		return 0;
 
 	nb = of_gpio_named_count(np, "cs-gpios");
-	master->num_chipselect = max(nb, master->num_chipselect);
-
-	if (nb < 1)
+	if (nb == 0 || nb == -ENOENT) /* No error if cs-gpios does not exist */
 		return 0;
+	else if (nb < 0)
+		return nb;
+
+	if (nb > master->num_chipselect)
+		master->num_chipselect = (u16)nb;
 
 	cs = devm_kzalloc(&master->dev,
 			  sizeof(int) * master->num_chipselect,
-- 
1.7.0.4

