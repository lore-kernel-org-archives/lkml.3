Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbaDHSVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:21:20 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41813 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477AbaDHSVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:21:14 -0400
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
Subject: [RFC PATCH 1/5] gpio: add a vtable to abstract GPIO controller operations
Date: Tue,  8 Apr 2014 20:20:11 +0200
Message-Id: <1396981215-24888-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396981215-24888-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1396981215-24888-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common pattern to implement object oriented code in the kernel is
to use a separate structure to hold all the methods for a particular
kind of object and just have a pointer to this table rather than a
separate pointer for each method.

The alternate approach is to directly embedded function pointers in
the object but there are some advantages on using the former approach.

This patch adds a struct gpio_chip_ops to be set by GPIO chip controllers.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 include/linux/gpio/driver.h | 47 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index 1827b43..824cd32 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -16,6 +16,51 @@ struct seq_file;
 #ifdef CONFIG_GPIOLIB
 
 /**
+ * struct gpio_chip_ops - virtual function table for GPIO controller operations
+ * @request: optional hook for chip-specific activation, such as
+ *	enabling module power and clock; may sleep
+ * @free: optional hook for chip-specific deactivation, such as
+ *	disabling module power and clock; may sleep
+ * @get_direction: returns direction for signal "offset", 0=out, 1=in,
+ *	(same as GPIOF_DIR_XXX), or negative error
+ * @direction_input: configures signal "offset" as input, or returns error
+ * @direction_output: configures signal "offset" as output, or returns error
+ * @get: returns value for signal "offset"; for output signals this
+ *	returns either the value actually sensed, or zero
+ * @set: assigns output value for signal "offset"
+ * @set_debounce: optional hook for setting debounce time for specified gpio in
+ *      interrupt triggered gpio chips
+ * @dbg_show: optional routine to show contents in debugfs; default code
+ *	will be used when this is omitted, but custom code can show extra
+ *	state (such as pullup/pulldown configuration).
+ *
+ * A gpio_chip_ops is used as a virtual function table for gpio_chip so GPIO
+ * drivers can define their custom methods as needed by its the GPIO controller.
+ */
+struct gpio_chip_ops {
+	int			(*request)(struct gpio_chip *chip,
+						unsigned offset);
+	void			(*free)(struct gpio_chip *chip,
+						unsigned offset);
+	int			(*get_direction)(struct gpio_chip *chip,
+						unsigned offset);
+	int			(*direction_input)(struct gpio_chip *chip,
+						unsigned offset);
+	int			(*direction_output)(struct gpio_chip *chip,
+						unsigned offset, int value);
+	int			(*get)(struct gpio_chip *chip,
+						unsigned offset);
+	void			(*set)(struct gpio_chip *chip,
+						unsigned offset, int value);
+	int			(*set_debounce)(struct gpio_chip *chip,
+						unsigned offset,
+						unsigned debounce);
+
+	void			(*dbg_show)(struct seq_file *s,
+						struct gpio_chip *chip);
+};
+
+/**
  * struct gpio_chip - abstract a GPIO controller
  * @label: for diagnostics
  * @dev: optional device providing the GPIOs
@@ -44,6 +89,7 @@ struct seq_file;
  * @ngpio: the number of GPIOs handled by this controller; the last GPIO
  *	handled is (base + ngpio - 1).
  * @desc: array of ngpio descriptors. Private.
+ * @ops: virtual table with GPIO controller operations.
  * @names: if set, must be an array of strings to use as alternative
  *      names for the GPIOs in this chip. Any entry in the array
  *      may be NULL if there is no alias for the GPIO, however the
@@ -97,6 +143,7 @@ struct gpio_chip {
 	u16			ngpio;
 	struct gpio_desc	*desc;
 	const char		*const *names;
+	const struct gpio_chip_ops    *ops;
 	bool			can_sleep;
 	bool			exported;
 
-- 
1.9.0

