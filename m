Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaLRIXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 03:23:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:27293 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbaLRIXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 03:23:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,599,1413270000"; 
   d="scan'208";a="625777310"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] gpio: support for GPIO forwarding
Date: Thu, 18 Dec 2014 10:23:18 +0200
Message-Id: <1418890998-23811-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible to assign GPIOs at runtime. The
motivation for it is because of need to forward GPIOs from
one device to an other. That feature may be useful for
example with some mfd devices, but initially it is needed
because on some Intel Braswell based ACPI platforms the GPIO
resources controlling signals of the USB PHY are given to
the controller device object for whatever reason, so the
driver of that controller needs be able to pass them to the
PHY device somehow.

So basically this is meant to allow patching of bad (bad
from Linux kernels point of view) hardware descriptions
provided by system fw in the drivers.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---

Hi,

I'm sending this first as a RFC in case you guys have some better
idea how to solve our problem. I actually already have couple
platforms where the GPIO resources are given to the "wrong" device
objects now.

Originally we were thinking about simply handling our problem with
hacks to the PHY drivers, basically also checking if the parent has
GPIOs. That would only work if the controller is always the parent,
which it's not, but even if it was, it would be too risky. The PHY
drivers don't know which controller they are attached to, so what is
to say that the GPIOs aren't really attached to the controller.

So the safest way to handle our problem is to deal with it in quirks
in the controller drivers. Solving it by bouncing the GPIOs did not
feel ideal there doesn't seem to be any other way. The API is copied
from clkdev (clk_register_clkdev). In the end it's really only one
function for adding the lookups and one for removing them.

The way it's implemented is by modifying the current style of handling
the lookups a little bit. The per device lookup table is basically
reverted back to the single linked-list format since it seems that
these lookups may have to be assigned from several sources.

Thanks,

 Documentation/gpio/board.txt                 |  17 ++---
 Documentation/gpio/consumer.txt              |  15 ++++
 arch/arm/mach-integrator/impd1.c             |  22 +++---
 arch/arm/mach-omap2/board-rx51-peripherals.c |  11 +--
 arch/arm/mach-tegra/board-paz00.c            |  13 ++--
 arch/mips/jz4740/board-qi_lb60.c             |  13 ++--
 drivers/gpio/gpiolib.c                       | 110 ++++++++++++++++-----------
 include/linux/gpio/consumer.h                |  22 ++++++
 include/linux/gpio/machine.h                 |  20 ++---
 9 files changed, 146 insertions(+), 97 deletions(-)

diff --git a/Documentation/gpio/board.txt b/Documentation/gpio/board.txt
index 4452786..58a0eaf 100644
--- a/Documentation/gpio/board.txt
+++ b/Documentation/gpio/board.txt
@@ -90,20 +90,17 @@ Note that GPIO_LOOKUP() is just a shortcut to GPIO_LOOKUP_IDX() where idx = 0.
 A lookup table can then be defined as follows, with an empty entry defining its
 end:
 
-struct gpiod_lookup_table gpios_table = {
-	.dev_id = "foo.0",
-	.table = {
-		GPIO_LOOKUP_IDX("gpio.0", 15, "led", 0, GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP_IDX("gpio.0", 16, "led", 1, GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP_IDX("gpio.0", 17, "led", 2, GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP("gpio.0", 1, "power", GPIO_ACTIVE_LOW),
-		{ },
-	},
+struct gpiod_lookup gpios_table[] = {
+	GPIO_LOOKUP_IDX("gpio.0", 15, "foo.0", "led", 0, GPIO_ACTIVE_HIGH),
+	GPIO_LOOKUP_IDX("gpio.0", 16, "foo.0", "led", 1, GPIO_ACTIVE_HIGH),
+	GPIO_LOOKUP_IDX("gpio.0", 17, "foo.0", "led", 2, GPIO_ACTIVE_HIGH),
+	GPIO_LOOKUP("gpio.0", 1, "foo.0", "power", GPIO_ACTIVE_LOW),
+	{ },
 };
 
 And the table can be added by the board code as follows:
 
-	gpiod_add_lookup_table(&gpios_table);
+	gpiod_add_lookup_table(gpios_table);
 
 The driver controlling "foo.0" will then be able to obtain its GPIOs as follows:
 
diff --git a/Documentation/gpio/consumer.txt b/Documentation/gpio/consumer.txt
index d85fbae..21b2eee 100644
--- a/Documentation/gpio/consumer.txt
+++ b/Documentation/gpio/consumer.txt
@@ -281,3 +281,18 @@ descriptor is only possible after the GPIO number has been released.
 
 Freeing a GPIO obtained by one API with the other API is forbidden and an
 unchecked error.
+
+Runtime GPIO Mappings
+=====================
+If a GPIO needs to be assigning to consumer when the system is already up and
+running, a lookup can be created and later removed with the following
+functions:
+
+	int gpiod_create_lookup(struct gpio_desc *desc, const char *con_id,
+				const char *dev_id)
+	void gpiod_remove_lookup(struct gpio_desc *desc, const char *con_id,
+				 const char *dev_id)
+
+Where "dev_id" is the device name of the consumer and "con_id" the connection
+identifier that can be used to identify the GPIO when it's requested by that
+consumer.
diff --git a/arch/arm/mach-integrator/impd1.c b/arch/arm/mach-integrator/impd1.c
index 38b0da3..70ff0b5 100644
--- a/arch/arm/mach-integrator/impd1.c
+++ b/arch/arm/mach-integrator/impd1.c
@@ -386,16 +386,14 @@ static int __init_refok impd1_probe(struct lm_device *dev)
 
 		/* Add GPIO descriptor lookup table for the PL061 block */
 		if (idev->offset == 0x00400000) {
-			struct gpiod_lookup_table *lookup;
+			struct gpiod_lookup *lookup;
 			char *chipname;
 			char *mmciname;
 
-			lookup = devm_kzalloc(&dev->dev,
-					      sizeof(*lookup) + 3 * sizeof(struct gpiod_lookup),
+			lookup = devm_kzalloc(&dev->dev, sizeof(*lookup) * 3,
 					      GFP_KERNEL);
 			chipname = devm_kstrdup(&dev->dev, devname, GFP_KERNEL);
 			mmciname = kasprintf(GFP_KERNEL, "lm%x:00700", dev->id);
-			lookup->dev_id = mmciname;
 			/*
 			 * Offsets on GPIO block 1:
 			 * 3 = MMC WP (write protect)
@@ -410,13 +408,15 @@ static int __init_refok impd1_probe(struct lm_device *dev)
 			 * 5 = Key lower right
 			 */
 			/* We need the two MMCI GPIO entries */
-			lookup->table[0].chip_label = chipname;
-			lookup->table[0].chip_hwnum = 3;
-			lookup->table[0].con_id = "wp";
-			lookup->table[1].chip_label = chipname;
-			lookup->table[1].chip_hwnum = 4;
-			lookup->table[1].con_id = "cd";
-			lookup->table[1].flags = GPIO_ACTIVE_LOW;
+			lookup[0].chip_label = chipname;
+			lookup[0].chip_hwnum = 3;
+			lookup[0].dev_id = mmciname;
+			lookup[0].con_id = "wp";
+			lookup[1].chip_label = chipname;
+			lookup[1].chip_hwnum = 4;
+			lookup[1].dev_id = mmciname;
+			lookup[1].con_id = "cd";
+			lookup[1].flags = GPIO_ACTIVE_LOW;
 			gpiod_add_lookup_table(lookup);
 		}
 
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 14edcd7..606ba16 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -756,17 +756,14 @@ static struct regulator_init_data rx51_vintdig = {
 	},
 };
 
-static struct gpiod_lookup_table rx51_fmtx_gpios_table = {
-	.dev_id = "2-0063",
-	.table = {
-		GPIO_LOOKUP("gpio.6", 3, "reset", GPIO_ACTIVE_HIGH), /* 163 */
-		{ },
-	},
+static struct gpiod_lookup rx51_fmtx_gpios_table[] = {
+	GPIO_LOOKUP("gpio.6", 3, "2-0063", "reset", GPIO_ACTIVE_HIGH), /* 163 */
+	{ },
 };
 
 static __init void rx51_gpio_init(void)
 {
-	gpiod_add_lookup_table(&rx51_fmtx_gpios_table);
+	gpiod_add_lookup_table(rx51_fmtx_gpios_table);
 }
 
 static int rx51_twlgpio_setup(struct device *dev, unsigned gpio, unsigned n)
diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
index fbe74c6..fedd7d5 100644
--- a/arch/arm/mach-tegra/board-paz00.c
+++ b/arch/arm/mach-tegra/board-paz00.c
@@ -36,17 +36,14 @@ static struct platform_device wifi_rfkill_device = {
 	},
 };
 
-static struct gpiod_lookup_table wifi_gpio_lookup = {
-	.dev_id = "rfkill_gpio",
-	.table = {
-		GPIO_LOOKUP_IDX("tegra-gpio", 25, NULL, 0, 0),
-		GPIO_LOOKUP_IDX("tegra-gpio", 85, NULL, 1, 0),
-		{ },
-	},
+static struct gpiod_lookup wifi_gpio_lookup[] = {
+	GPIO_LOOKUP_IDX("tegra-gpio", 25, "rfkill_gpio", NULL, 0, 0),
+	GPIO_LOOKUP_IDX("tegra-gpio", 85, "rfkill_gpio", NULL, 1, 0),
+	{ },
 };
 
 void __init tegra_paz00_wifikill_init(void)
 {
-	gpiod_add_lookup_table(&wifi_gpio_lookup);
+	gpiod_add_lookup_table(wifi_gpio_lookup);
 	platform_device_register(&wifi_rfkill_device);
 }
diff --git a/arch/mips/jz4740/board-qi_lb60.c b/arch/mips/jz4740/board-qi_lb60.c
index c454525..7b94feb 100644
--- a/arch/mips/jz4740/board-qi_lb60.c
+++ b/arch/mips/jz4740/board-qi_lb60.c
@@ -426,13 +426,10 @@ static struct platform_device qi_lb60_audio_device = {
 	.id = -1,
 };
 
-static struct gpiod_lookup_table qi_lb60_audio_gpio_table = {
-	.dev_id = "qi-lb60-audio",
-	.table = {
-		GPIO_LOOKUP("Bank B", 29, "snd", 0),
-		GPIO_LOOKUP("Bank D", 4, "amp", 0),
-		{ },
-	},
+static struct gpiod_lookup qi_lb60_audio_gpio_table[] = {
+	GPIO_LOOKUP("Bank B", 29, "qi-lb60-audio", "snd", 0),
+	GPIO_LOOKUP("Bank D", 4, "qi-lb60-audio", "amp", 0),
+	{ },
 };
 
 static struct platform_device *jz_platform_devices[] __initdata = {
@@ -471,7 +468,7 @@ static int __init qi_lb60_init_platform_devices(void)
 	jz4740_adc_device.dev.platform_data = &qi_lb60_battery_pdata;
 	jz4740_mmc_device.dev.platform_data = &qi_lb60_mmc_pdata;
 
-	gpiod_add_lookup_table(&qi_lb60_audio_gpio_table);
+	gpiod_add_lookup_table(qi_lb60_audio_gpio_table);
 
 	jz4740_serial_device_register();
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 487afe6..36dc2a9 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1644,14 +1644,62 @@ EXPORT_SYMBOL_GPL(gpiod_set_array_cansleep);
  * gpiod_add_lookup_table() - register GPIO device consumers
  * @table: table of consumers to register
  */
-void gpiod_add_lookup_table(struct gpiod_lookup_table *table)
+void gpiod_add_lookup_table(struct gpiod_lookup *table)
 {
 	mutex_lock(&gpio_lookup_lock);
+	for ( ; table->chip_label; table++)
+		list_add_tail(&table->list, &gpio_lookup_list);
+	mutex_unlock(&gpio_lookup_lock);
+}
 
-	list_add_tail(&table->list, &gpio_lookup_list);
+/**
+ * gpiod_create_lookup() - register consumer for a GPIO
+ * @desc: the GPIO
+ * @con_id: name of the GPIO from the device's point of view
+ * @dev_id: device name of the consumer for this GPIO
+ */
+int gpiod_create_lookup(struct gpio_desc *desc, const char *con_id,
+			const char *dev_id)
+{
+	struct gpiod_lookup *gl;
+
+	gl = kzalloc(sizeof(*gl), GFP_KERNEL);
+	if (!gl)
+		return -ENOMEM;
 
+	gl->con_id = con_id;
+	gl->dev_id = dev_id;
+	gl->desc = desc;
+
+	mutex_lock(&gpio_lookup_lock);
+	list_add_tail(&gl->list, &gpio_lookup_list);
 	mutex_unlock(&gpio_lookup_lock);
+	return 0;
 }
+EXPORT_SYMBOL_GPL(gpiod_create_lookup);
+
+/**
+ * gpiod_remove_lookup() - remove GPIO consumer
+ * @desc: the GPIO
+ * @con_id: name of the GPIO from the device's point of view
+ * @dev_id: device name of the consumer for this GPIO
+ */
+void gpiod_remove_lookup(struct gpio_desc *desc, const char *con_id,
+			 const char *dev_id)
+{
+	struct gpiod_lookup *gl;
+
+	mutex_lock(&gpio_lookup_lock);
+	list_for_each_entry(gl, &gpio_lookup_list, list)
+		if (gl->desc == desc && !strcmp(gl->dev_id, dev_id) &&
+		    !strcmp(gl->con_id, con_id)) {
+			list_del(&gl->list);
+			kfree(gl);
+			break;
+		}
+	mutex_unlock(&gpio_lookup_lock);
+}
+EXPORT_SYMBOL_GPL(gpiod_remove_lookup);
 
 static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 				      unsigned int idx,
@@ -1723,52 +1771,22 @@ static struct gpio_desc *acpi_find_gpio(struct device *dev, const char *con_id,
 	return desc;
 }
 
-static struct gpiod_lookup_table *gpiod_find_lookup_table(struct device *dev)
-{
-	const char *dev_id = dev ? dev_name(dev) : NULL;
-	struct gpiod_lookup_table *table;
-
-	mutex_lock(&gpio_lookup_lock);
-
-	list_for_each_entry(table, &gpio_lookup_list, list) {
-		if (table->dev_id && dev_id) {
-			/*
-			 * Valid strings on both ends, must be identical to have
-			 * a match
-			 */
-			if (!strcmp(table->dev_id, dev_id))
-				goto found;
-		} else {
-			/*
-			 * One of the pointers is NULL, so both must be to have
-			 * a match
-			 */
-			if (dev_id == table->dev_id)
-				goto found;
-		}
-	}
-	table = NULL;
-
-found:
-	mutex_unlock(&gpio_lookup_lock);
-	return table;
-}
-
 static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
 				    unsigned int idx,
 				    enum gpio_lookup_flags *flags)
 {
+	const char *dev_id = dev ? dev_name(dev) : NULL;
 	struct gpio_desc *desc = ERR_PTR(-ENOENT);
-	struct gpiod_lookup_table *table;
 	struct gpiod_lookup *p;
 
-	table = gpiod_find_lookup_table(dev);
-	if (!table)
-		return desc;
-
-	for (p = &table->table[0]; p->chip_label; p++) {
+	mutex_lock(&gpio_lookup_lock);
+	list_for_each_entry(p, &gpio_lookup_list, list) {
 		struct gpio_chip *chip;
 
+		/* If the lookup entry has a dev_id, require exact match */
+		if (p->dev_id && (!dev_id || strcmp(p->dev_id, dev_id)))
+			continue;
+
 		/* idx must always match exactly */
 		if (p->idx != idx)
 			continue;
@@ -1777,27 +1795,33 @@ static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
 		if (p->con_id && (!con_id || strcmp(p->con_id, con_id)))
 			continue;
 
+		if (p->desc) {
+			desc = p->desc;
+			break;
+		}
+
 		chip = find_chip_by_name(p->chip_label);
 
 		if (!chip) {
 			dev_err(dev, "cannot find GPIO chip %s\n",
 				p->chip_label);
-			return ERR_PTR(-ENODEV);
+			break;
 		}
 
 		if (chip->ngpio <= p->chip_hwnum) {
 			dev_err(dev,
 				"requested GPIO %d is out of range [0..%d] for chip %s\n",
 				idx, chip->ngpio, chip->label);
-			return ERR_PTR(-EINVAL);
+			desc = ERR_PTR(-EINVAL);
+			break;
 		}
 
 		desc = gpiochip_get_desc(chip, p->chip_hwnum);
 		*flags = p->flags;
 
-		return desc;
+		break;
 	}
-
+	mutex_unlock(&gpio_lookup_lock);
 	return desc;
 }
 
diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
index fd85cb1..d6e7579 100644
--- a/include/linux/gpio/consumer.h
+++ b/include/linux/gpio/consumer.h
@@ -111,6 +111,13 @@ struct gpio_desc *fwnode_get_named_gpiod(struct fwnode_handle *fwnode,
 					 const char *propname);
 struct gpio_desc *devm_get_gpiod_from_child(struct device *dev,
 					    struct fwnode_handle *child);
+
+/* For passing forward GPIOs */
+int gpiod_create_lookup(struct gpio_desc *desc, const char *con_id,
+			const char *dev_id);
+void gpiod_remove_lookup(struct gpio_desc *desc, const char *con_id,
+			 const char *dev_id);
+
 #else /* CONFIG_GPIOLIB */
 
 static inline struct gpio_desc *__must_check __gpiod_get(struct device *dev,
@@ -329,6 +336,21 @@ static inline int desc_to_gpio(const struct gpio_desc *desc)
 	return -EINVAL;
 }
 
+static inline int gpiod_create_lookup(struct gpio_desc *desc,
+				      const char *con_id, const char *dev_id)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+	return -ENOSYS;
+}
+
+static inline void gpiod_remove_lookup(struct gpio_desc *desc,
+				       const char *con_id, const char *dev_id)
+{
+	/* GPIO can never have been requested */
+	WARN_ON(1);
+}
+
 #endif /* CONFIG_GPIOLIB */
 
 /*
diff --git a/include/linux/gpio/machine.h b/include/linux/gpio/machine.h
index e270614..b367a19 100644
--- a/include/linux/gpio/machine.h
+++ b/include/linux/gpio/machine.h
@@ -15,6 +15,7 @@ enum gpio_lookup_flags {
  * struct gpiod_lookup - lookup table
  * @chip_label: name of the chip the GPIO belongs to
  * @chip_hwnum: hardware number (i.e. relative to the chip) of the GPIO
+ * @dev_id: name of the consumer device for this GPIO
  * @con_id: name of the GPIO from the device's point of view
  * @idx: index of the GPIO in case several GPIOs share the same name
  * @flags: mask of GPIO_* values
@@ -23,39 +24,38 @@ enum gpio_lookup_flags {
  * functions using platform data.
  */
 struct gpiod_lookup {
+	struct list_head list;
 	const char *chip_label;
 	u16 chip_hwnum;
+	const char *dev_id;
 	const char *con_id;
 	unsigned int idx;
 	enum gpio_lookup_flags flags;
-};
-
-struct gpiod_lookup_table {
-	struct list_head list;
-	const char *dev_id;
-	struct gpiod_lookup table[];
+	void *desc;
 };
 
 /*
  * Simple definition of a single GPIO under a con_id
  */
-#define GPIO_LOOKUP(_chip_label, _chip_hwnum, _con_id, _flags) \
-	GPIO_LOOKUP_IDX(_chip_label, _chip_hwnum, _con_id, 0, _flags)
+#define GPIO_LOOKUP(_chip_label, _chip_hwnum, _dev_id, _con_id, _flags) \
+	GPIO_LOOKUP_IDX(_chip_label, _chip_hwnum, _dev_id, _con_id, 0, _flags)
 
 /*
  * Use this macro if you need to have several GPIOs under the same con_id.
  * Each GPIO needs to use a different index and can be accessed using
  * gpiod_get_index()
  */
-#define GPIO_LOOKUP_IDX(_chip_label, _chip_hwnum, _con_id, _idx, _flags)  \
+#define GPIO_LOOKUP_IDX(_chip_label, _chip_hwnum, _dev_id, _con_id, _idx, \
+			_flags)						  \
 {                                                                         \
 	.chip_label = _chip_label,                                        \
 	.chip_hwnum = _chip_hwnum,                                        \
+	.dev_id = _dev_id,                                                \
 	.con_id = _con_id,                                                \
 	.idx = _idx,                                                      \
 	.flags = _flags,                                                  \
 }
 
-void gpiod_add_lookup_table(struct gpiod_lookup_table *table);
+void gpiod_add_lookup_table(struct gpiod_lookup *table);
 
 #endif /* __LINUX_GPIO_MACHINE_H */
-- 
2.1.3

