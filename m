Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbaDHSWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:22:42 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41833 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807AbaDHSVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:21:21 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, linux-gpio@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [RFC PATCH 5/5] gpio: switch to use struct struct gpio_chip_ops
Date: Tue,  8 Apr 2014 20:20:15 +0200
Message-Id: <1396981215-24888-6-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396981215-24888-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1396981215-24888-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All GPIO controller drivers have been migrated to use the struct
gpio_chip_ops virtual function table so the embeddeded function
pointers in struct gpio_chip can now be removed.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/gpio/gpiolib.c      | 83 +++++++++++++++++----------------------------
 include/linux/gpio/driver.h | 40 +++-------------------
 2 files changed, 36 insertions(+), 87 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index f0cc93a..2808076 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -214,8 +214,8 @@ static int gpio_ensure_requested(struct gpio_desc *desc)
 			return -EIO;
 		}
 		desc_set_label(desc, "[auto]");
-		/* caller must chip->request() w/o spinlock */
-		if (chip->request)
+		/* caller must chip->ops->request() w/o spinlock */
+		if (chip->ops->request)
 			return 1;
 	}
 	return 0;
@@ -272,10 +272,10 @@ int gpiod_get_direction(const struct gpio_desc *desc)
 	chip = gpiod_to_chip(desc);
 	offset = gpio_chip_hwgpio(desc);
 
-	if (!chip->get_direction)
+	if (!chip->ops->get_direction)
 		return status;
 
-	status = chip->get_direction(chip, offset);
+	status = chip->ops->get_direction(chip, offset);
 	if (status > 0) {
 		/* GPIOF_DIR_IN, or other positive */
 		status = 1;
@@ -837,7 +837,7 @@ int gpiod_export(struct gpio_desc *desc, bool direction_may_change)
 		goto fail_unlock;
 	}
 
-	if (!desc->chip->direction_input || !desc->chip->direction_output)
+	if (!desc->chip->ops->direction_input || !desc->chip->ops->direction_output)
 		direction_may_change = false;
 	spin_unlock_irqrestore(&gpio_lock, flags);
 
@@ -1188,25 +1188,6 @@ int gpiochip_add(struct gpio_chip *chip)
 		goto fail;
 	}
 
-	/*
-	 * REVISIT: this is a workaround to not break git bisectability by
-	 * allowing GPIO controller drivers to set either either the function
-	 * pointers embedded in struct gpio_chip or by using a gpio_chip_ops.
-	 *
-	 * Should be removed once all drivers are converted to set chip->ops.
-	 */
-	if (chip->ops) {
-		chip->request          = chip->ops->request;
-		chip->free             = chip->ops->free;
-		chip->get_direction    = chip->ops->get_direction;
-		chip->direction_input  = chip->ops->direction_input;
-		chip->direction_output = chip->ops->direction_output;
-		chip->get              = chip->ops->get;
-		chip->set              = chip->ops->set;
-		chip->set_debounce     = chip->ops->set_debounce;
-		chip->dbg_show         = chip->ops->dbg_show;
-	}
-
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	if (base < 0) {
@@ -1231,10 +1212,10 @@ int gpiochip_add(struct gpio_chip *chip)
 			 * inputs (often with pullups enabled) so power
 			 * usage is minimized.  Linux code should set the
 			 * gpio direction first thing; but until it does,
-			 * and in case chip->get_direction is not set,
+			 * and in case chip->ops->get_direction is not set,
 			 * we may expose the wrong direction in sysfs.
 			 */
-			desc->flags = !chip->direction_input
+			desc->flags = !chip->ops->direction_input
 				? (1 << FLAG_IS_OUT)
 				: 0;
 		}
@@ -1711,10 +1692,10 @@ static int __gpiod_request(struct gpio_desc *desc, const char *label)
 		goto done;
 	}
 
-	if (chip->request) {
-		/* chip->request may sleep */
+	if (chip->ops->request) {
+		/* chip->ops->request may sleep */
 		spin_unlock_irqrestore(&gpio_lock, flags);
-		status = chip->request(chip, gpio_chip_hwgpio(desc));
+		status = chip->ops->request(chip, gpio_chip_hwgpio(desc));
 		spin_lock_irqsave(&gpio_lock, flags);
 
 		if (status < 0) {
@@ -1723,8 +1704,8 @@ static int __gpiod_request(struct gpio_desc *desc, const char *label)
 			goto done;
 		}
 	}
-	if (chip->get_direction) {
-		/* chip->get_direction may sleep */
+	if (chip->ops->get_direction) {
+		/* chip->ops->get_direction may sleep */
 		spin_unlock_irqrestore(&gpio_lock, flags);
 		gpiod_get_direction(desc);
 		spin_lock_irqsave(&gpio_lock, flags);
@@ -1781,10 +1762,10 @@ static bool __gpiod_free(struct gpio_desc *desc)
 
 	chip = desc->chip;
 	if (chip && test_bit(FLAG_REQUESTED, &desc->flags)) {
-		if (chip->free) {
+		if (chip->ops->free) {
 			spin_unlock_irqrestore(&gpio_lock, flags);
 			might_sleep_if(chip->can_sleep);
-			chip->free(chip, gpio_chip_hwgpio(desc));
+			chip->ops->free(chip, gpio_chip_hwgpio(desc));
 			spin_lock_irqsave(&gpio_lock, flags);
 		}
 		desc_set_label(desc, NULL);
@@ -1989,7 +1970,7 @@ int gpiod_direction_input(struct gpio_desc *desc)
 	}
 
 	chip = desc->chip;
-	if (!chip->get || !chip->direction_input) {
+	if (!chip->ops->get || !chip->ops->direction_input) {
 		gpiod_warn(desc,
 			"%s: missing get() or direction_input() operations\n",
 			__func__);
@@ -2010,7 +1991,7 @@ int gpiod_direction_input(struct gpio_desc *desc)
 
 	offset = gpio_chip_hwgpio(desc);
 	if (status) {
-		status = chip->request(chip, offset);
+		status = chip->ops->request(chip, offset);
 		if (status < 0) {
 			gpiod_dbg(desc, "%s: chip request fail, %d\n",
 					__func__, status);
@@ -2021,7 +2002,7 @@ int gpiod_direction_input(struct gpio_desc *desc)
 		}
 	}
 
-	status = chip->direction_input(chip, offset);
+	status = chip->ops->direction_input(chip, offset);
 	if (status == 0)
 		clear_bit(FLAG_IS_OUT, &desc->flags);
 
@@ -2060,7 +2041,7 @@ static int _gpiod_direction_output_raw(struct gpio_desc *desc, int value)
 		return gpiod_direction_input(desc);
 
 	chip = desc->chip;
-	if (!chip->set || !chip->direction_output) {
+	if (!chip->ops->set || !chip->ops->direction_output) {
 		gpiod_warn(desc,
 		       "%s: missing set() or direction_output() operations\n",
 		       __func__);
@@ -2081,7 +2062,7 @@ static int _gpiod_direction_output_raw(struct gpio_desc *desc, int value)
 
 	offset = gpio_chip_hwgpio(desc);
 	if (status) {
-		status = chip->request(chip, offset);
+		status = chip->ops->request(chip, offset);
 		if (status < 0) {
 			gpiod_dbg(desc, "%s: chip request fail, %d\n",
 					__func__, status);
@@ -2092,7 +2073,7 @@ static int _gpiod_direction_output_raw(struct gpio_desc *desc, int value)
 		}
 	}
 
-	status = chip->direction_output(chip, offset, value);
+	status = chip->ops->direction_output(chip, offset, value);
 	if (status == 0)
 		set_bit(FLAG_IS_OUT, &desc->flags);
 	trace_gpio_value(desc_to_gpio(desc), 0, value);
@@ -2172,7 +2153,7 @@ int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 	}
 
 	chip = desc->chip;
-	if (!chip->set || !chip->set_debounce) {
+	if (!chip->ops->set || !chip->ops->set_debounce) {
 		gpiod_dbg(desc,
 			  "%s: missing set() or set_debounce() operations\n",
 			  __func__);
@@ -2192,7 +2173,7 @@ int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
 	might_sleep_if(chip->can_sleep);
 
 	offset = gpio_chip_hwgpio(desc);
-	return chip->set_debounce(chip, offset, debounce);
+	return chip->ops->set_debounce(chip, offset, debounce);
 
 fail:
 	spin_unlock_irqrestore(&gpio_lock, flags);
@@ -2245,7 +2226,7 @@ static bool _gpiod_get_raw_value(const struct gpio_desc *desc)
 
 	chip = desc->chip;
 	offset = gpio_chip_hwgpio(desc);
-	value = chip->get ? chip->get(chip, offset) : false;
+	value = chip->ops->get ? chip->ops->get(chip, offset) : false;
 	trace_gpio_value(desc_to_gpio(desc), 1, value);
 	return value;
 }
@@ -2308,11 +2289,11 @@ static void _gpio_set_open_drain_value(struct gpio_desc *desc, bool value)
 	int offset = gpio_chip_hwgpio(desc);
 
 	if (value) {
-		err = chip->direction_input(chip, offset);
+		err = chip->ops->direction_input(chip, offset);
 		if (!err)
 			clear_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
-		err = chip->direction_output(chip, offset, 0);
+		err = chip->ops->direction_output(chip, offset, 0);
 		if (!err)
 			set_bit(FLAG_IS_OUT, &desc->flags);
 	}
@@ -2335,11 +2316,11 @@ static void _gpio_set_open_source_value(struct gpio_desc *desc, bool value)
 	int offset = gpio_chip_hwgpio(desc);
 
 	if (value) {
-		err = chip->direction_output(chip, offset, 1);
+		err = chip->ops->direction_output(chip, offset, 1);
 		if (!err)
 			set_bit(FLAG_IS_OUT, &desc->flags);
 	} else {
-		err = chip->direction_input(chip, offset);
+		err = chip->ops->direction_input(chip, offset);
 		if (!err)
 			clear_bit(FLAG_IS_OUT, &desc->flags);
 	}
@@ -2361,7 +2342,7 @@ static void _gpiod_set_raw_value(struct gpio_desc *desc, bool value)
 	else if (test_bit(FLAG_OPEN_SOURCE, &desc->flags))
 		_gpio_set_open_source_value(desc, value);
 	else
-		chip->set(chip, gpio_chip_hwgpio(desc), value);
+		chip->ops->set(chip, gpio_chip_hwgpio(desc), value);
 }
 
 /**
@@ -2828,8 +2809,8 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s %s",
 			gpio, gdesc->label,
 			is_out ? "out" : "in ",
-			chip->get
-				? (chip->get(chip, i) ? "hi" : "lo")
+			chip->ops->get
+				? (chip->ops->get(chip, i) ? "hi" : "lo")
 				: "?  ",
 			is_irq ? "IRQ" : "   ");
 		seq_printf(s, "\n");
@@ -2895,8 +2876,8 @@ static int gpiolib_seq_show(struct seq_file *s, void *v)
 		seq_printf(s, ", can sleep");
 	seq_printf(s, ":\n");
 
-	if (chip->dbg_show)
-		chip->dbg_show(s, chip);
+	if (chip->ops->dbg_show)
+		chip->ops->dbg_show(s, chip);
 	else
 		gpiolib_dbg_show(s, chip);
 
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 824cd32..326ad96 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -66,24 +66,8 @@ struct gpio_chip_ops {
  * @dev: optional device providing the GPIOs
  * @owner: helps prevent removal of modules exporting active GPIOs
  * @list: links gpio_chips together for traversal
- * @request: optional hook for chip-specific activation, such as
- *	enabling module power and clock; may sleep
- * @free: optional hook for chip-specific deactivation, such as
- *	disabling module power and clock; may sleep
- * @get_direction: returns direction for signal "offset", 0=out, 1=in,
- *	(same as GPIOF_DIR_XXX), or negative error
- * @direction_input: configures signal "offset" as input, or returns error
- * @direction_output: configures signal "offset" as output, or returns error
- * @get: returns value for signal "offset"; for output signals this
- *	returns either the value actually sensed, or zero
- * @set: assigns output value for signal "offset"
- * @set_debounce: optional hook for setting debounce time for specified gpio in
- *      interrupt triggered gpio chips
  * @to_irq: optional hook supporting non-static gpio_to_irq() mappings;
  *	implementation may not sleep
- * @dbg_show: optional routine to show contents in debugfs; default code
- *	will be used when this is omitted, but custom code can show extra
- *	state (such as pullup/pulldown configuration).
  * @base: identifies the first GPIO number handled by this chip; or, if
  *	negative during registration, requests dynamic ID allocation.
  * @ngpio: the number of GPIOs handled by this controller; the last GPIO
@@ -116,29 +100,13 @@ struct gpio_chip {
 	struct module		*owner;
 	struct list_head        list;
 
-	int			(*request)(struct gpio_chip *chip,
-						unsigned offset);
-	void			(*free)(struct gpio_chip *chip,
-						unsigned offset);
-	int			(*get_direction)(struct gpio_chip *chip,
-						unsigned offset);
-	int			(*direction_input)(struct gpio_chip *chip,
-						unsigned offset);
-	int			(*direction_output)(struct gpio_chip *chip,
-						unsigned offset, int value);
-	int			(*get)(struct gpio_chip *chip,
-						unsigned offset);
-	void			(*set)(struct gpio_chip *chip,
-						unsigned offset, int value);
-	int			(*set_debounce)(struct gpio_chip *chip,
-						unsigned offset,
-						unsigned debounce);
-
+	/*
+	 * The to_irq function pointer is not in struct gpio_chip_ops
+	 * because it can be modified inside the gpiolib.
+	 */
 	int			(*to_irq)(struct gpio_chip *chip,
 						unsigned offset);
 
-	void			(*dbg_show)(struct seq_file *s,
-						struct gpio_chip *chip);
 	int			base;
 	u16			ngpio;
 	struct gpio_desc	*desc;
-- 
1.9.0

